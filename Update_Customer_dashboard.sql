USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [master].[Update_customer_KPI_graph_data]    Script Date: 7/15/2021 2:44:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--ALTER procedure [master].[Update_customer_KPI_graph_data]
--declare
--@dealer_id varchar(50)='1806'

--AS
/*
	 exec [master].[Update_customer_KPI_graph_data] 1806

	 select * from master.dashboard_kpis (nolock)
	 
	 ----------------------------------------------------------               
	 PURPOSE        
	 To Upate master.dashboard_kpis
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date          Author			Work Tracker Id		Description          
	 -----------------------------------------------------------        
	 06/23/2021	   Srikanth K							Created - To update customer graph data in master.dashboard_kpis table.      
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/

Begin


---------CUSTOMERS SEGMENTATION: NEW, ACTIVE, LAPSED, LOST
/*
IF OBJECT_ID('tempdb..#customer') IS NOT NULL DROP TABLE #customer
IF OBJECT_ID('tempdb..#type_customer') IS NOT NULL DROP TABLE #type_customer
IF OBJECT_ID('tempdb..#result1') IS NOT NULL DROP TABLE #result1
IF OBJECT_ID('tempdb..#result33') IS NOT NULL DROP TABLE #result33
IF OBJECT_ID('tempdb..#dlr33') IS NOT NULL DROP TABLE #dlr33


select parent_dealer_id
		 ,cust_dms_number
		, ro_number
		, ro_close_date
		, DateDiff(month, Cast(Cast(ro_close_date as varchar(10)) as date), getdate()) as diff
into #customer
from master.repair_order_header (nolock)
where  ro_close_date is not null and is_deleted=0 --and total_repair_order_price>0
and parent_dealer_id=@dealer_id

union

select parent_dealer_id
		 ,cust_dms_number
		, deal_number_dms
		, purchase_date
		, DateDiff(month, Cast(Cast(purchase_date as varchar(10)) as date), getdate()) as diff

from master.fi_sales (nolock)
where purchase_date is not null
and parent_dealer_id=@dealer_id

select *, row_number() over(partition by cust_dms_number order by diff asc) as rnk 
into #type_customer
from #customer order by cust_dms_number, diff



select * ,0 as new_cust, 0 as active_cust, 0 as lapsed_cust, 0 as lost_cust into #result1 from #type_customer where rnk =1

update #result1 set new_cust=1 where diff<12 and cust_dms_number not in (select distinct cust_dms_number from #customer where diff>=12)
update #result1 set active_cust =1 where diff<12 and cust_dms_number in (select distinct cust_dms_number from #customer where diff>=12)
update #result1 set lapsed_cust=1 where diff >= 12 and diff <= 24
update #result1 set lost_cust=1 where diff > 24

select distinct parent_dealer_id into #dlr33 from #result1

select 
parent_dealer_id
,sum(new_cust) as new
,sum(active_cust) as active
,sum(lapsed_cust) as lapsed
,sum(lost_cust) as lost 
into #result33
from #result1 group by parent_dealer_id

*/
IF OBJECT_ID('tempdb..#temp_customer') IS NOT NULL DROP TABLE #temp_customer
IF OBJECT_ID('tempdb..#temp_ros') IS NOT NULL DROP TABLE #temp_ros
IF OBJECT_ID('tempdb..#temp_sales') IS NOT NULL DROP TABLE #temp_sales
IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3
IF OBJECT_ID('tempdb..#temp4') IS NOT NULL DROP TABLE #temp4
IF OBJECT_ID('tempdb..#temp5') IS NOT NULL DROP TABLE #temp5
IF OBJECT_ID('tempdb..#new') IS NOT NULL DROP TABLE #new
IF OBJECT_ID('tempdb..#active') IS NOT NULL DROP TABLE #active
IF OBJECT_ID('tempdb..#lapsed') IS NOT NULL DROP TABLE #lapsed
IF OBJECT_ID('tempdb..#lost') IS NOT NULL DROP TABLE #lost




select  a.cust_dms_number,  
	    0 as new_customer, 0 as active_customer, 0 as lapsed_customer,
	   b.vin,
	   0 as lost_customer,
	   a.parent_dealer_id
	   
	into #temp_customer
from master.customer a (nolock)
inner join master.cust_2_vehicle b (nolock) on a.master_customer_id = b.master_customer_id
--where a.parent_dealer_id = 1806 --and b.is_deleted is null



--Servies
select cust_dms_number, vin, ro_number, ro_close_date, DateDiff(month, Cast(Cast(ro_close_date as varchar(10)) as date), getdate()) as diff
,parent_dealer_id
into #temp_ros
from master.repair_order_header (nolock)
--where parent_dealer_id = 1806 
-- DateDiff(month, Cast(Cast(ro_close_date as varchar(10)) as date), getdate()) between 12 and 24


select  cust_dms_number, vin, deal_number_dms, purchase_date,DateDiff(month, Cast(Cast(purchase_date as varchar(10)) as date), getdate()) as diff
,parent_dealer_id
into #temp_sales
from master.fi_sales (nolock)
--where parent_dealer_id = 1806
--where DateDiff(month, Cast(Cast(ro_close_date as varchar(10)) as date), getdate()) between 12 and 24

--Sales
select *, 'Service'as source into #temp3
from 
(
select parent_dealer_id,cust_dms_number, vin, ro_number, ro_close_date, diff, rank() over (partition by parent_dealer_id,cust_dms_number order by diff asc) as rnk from #temp_ros
) as a
where a.rnk = 1 and diff >= 12 and diff <= 24
Union
select *, 'Sales'
from 
(
select parent_dealer_id,cust_dms_number, vin, deal_number_dms, purchase_date, diff, rank() over (partition by parent_dealer_id,cust_dms_number order by diff asc) as rnk from #temp_sales
) as a
where a.rnk = 1 and diff >= 12 and diff <= 24


Update #temp_customer set lapsed_customer = 1 where cust_dms_number in (select distinct cust_dms_number from #temp3)


select *, 'Service'as source into #temp4
from 
(
select parent_dealer_id,cust_dms_number, vin, ro_number, ro_close_date, diff, rank() over (partition by cust_dms_number order by diff asc) as rnk from #temp_ros
) as a
where a.rnk = 1 and diff > 24
Union
select *, 'Sales'
from 
(
select parent_dealer_id,cust_dms_number, vin, deal_number_dms, purchase_date, diff, rank() over (partition by cust_dms_number order by diff asc) as rnk from #temp_sales
) as a
where a.rnk = 1 and diff > 24



Update #temp_customer set lost_customer = 1 where cust_dms_number in (select distinct cust_dms_number from #temp4)

select * into #temp5 from #temp_sales where diff <12 and cust_dms_number + '#' + vin not in (select distinct cust_dms_number + '#' + vin from #temp_ros)

Update #temp_customer set new_customer = 1 where cust_dms_number in (select distinct cust_dms_number from #temp5)

Update #temp_customer set active_customer = 1 where cust_dms_number in (select cust_dms_number from #temp_ros  where diff <= 12)


--select * from #temp_customer where lapsed_customer = 1 and lost_customer = 1

Update #temp_customer set new_customer = 0 where new_customer = 1 and active_customer = 1
Update #temp_customer set lapsed_customer = 0 where lapsed_customer = 1 and active_customer = 1
Update #temp_customer set lost_customer = 0 where lost_customer = 1 and active_customer = 1

Update #temp_customer set lapsed_customer = 0 where new_customer = 1 and lapsed_customer = 1 -- 215
Update #temp_customer set lost_customer = 0 where new_customer = 1 and lost_customer = 1 -- 586

Update #temp_customer set lost_customer = 0 where lapsed_customer = 1 and lost_customer = 1 -- 510



/*
declare @new varchar(5000) = (select count(distinct cust_dms_number) from #temp_customer where new_customer = 1) -- 3346 - 1338 -- 2008
declare @active varchar(5000) = (select count(distinct cust_dms_number) from #temp_customer where active_customer = 1 )-- 16385 -- 16385
declare @lapsed varchar(5000) = (select count(distinct cust_dms_number) from #temp_customer where lapsed_customer = 1) -- 8210 - 1480 -- 6515
declare @lost varchar(5000) = (select count(distinct cust_dms_number) from #temp_customer where lost_customer = 1) -- 22398 - 295 -- 21007
*/

select parent_dealer_id, count(distinct cust_dms_number) as new into #new from #temp_customer where new_customer = 1 group by parent_dealer_id
select parent_dealer_id, count(distinct cust_dms_number) as active into #active from #temp_customer where active_customer = 1 group by parent_dealer_id
select parent_dealer_id, count(distinct cust_dms_number) as lapsed into #lapsed from #temp_customer where lapsed_customer = 1 group by parent_dealer_id
select parent_dealer_id, count(distinct cust_dms_number) as lost into #lost from #temp_customer where lost_customer = 1  group by parent_dealer_id


declare @cust_class varchar(5000) =
( 


select
n.parent_dealer_id 
,new as "customer_segmentation.new"
,active as "customer_segmentation.active"
,lapsed as "customer_segmentation.lapsed"
,lost  as "customer_segmentation.lost"

from #new n inner join #active a on n.parent_dealer_id =a.parent_dealer_id
inner join #lapsed la on la.parent_dealer_id = a.parent_dealer_id
inner join #lost l on l.parent_dealer_id =a.parent_dealer_id


for json path
)


-------------  CUSTOMERS BY RADIUS

IF OBJECT_ID('tempdb..#cust_dist') IS NOT NULL DROP TABLE #cust_dist
IF OBJECT_ID('tempdb..#result2') IS NOT NULL DROP TABLE #result2
IF OBJECT_ID('tempdb..#result22') IS NOT NULL DROP TABLE #result22
IF OBJECT_ID('tempdb..#dlr22') IS NOT NULL DROP TABLE #dlr22
IF OBJECT_ID('tempdb..#result23') IS NOT NULL DROP TABLE #result23

select 
	parent_dealer_id, 
	a.cust_dms_number, 
	cust_full_name, 
	cust_zip_code4,
	--Cast(Cast(LEFT(CONVERT(VARCHAR,(geography::Point(41.0224, -73.6234, 4326).STDistance(geography::Point(ISNULL(latitude,0), ISNULL(longitude,0), 4326))/1000)),5) as decimal(18,2)) * 1 as decimal(18,2)) as distance
	cust_miles_distance as distance
into #cust_dist
from master.customer a (nolock)
where is_deleted !=1
--and parent_dealer_id=@dealer_id

select parent_dealer_id
	,cust_dms_number
	,cust_full_name
	,cust_zip_code4
	,distance
	,(case when distance <=10 then '0 - 10 Miles'
			when distance >10 and distance<=20 then '11 - 20 Miles'
			when distance >20 and distance<=30 then '21 - 30 Miles'
			when distance >30 and distance<=40 then '31 - 40 Miles'
			when distance >40 and distance<=50 then '41 - 50 Miles'
			else '> 50 Miles' end) as range

	into #result2
from #cust_dist
select distinct parent_dealer_id into #dlr22 from #result2
select parent_dealer_id,[range], count(cust_dms_number) as cust_count into #result22 from #result2 group by parent_dealer_id,[range] order by [range]


--select * from #result22
create table #result23 ( acc_id int ,Miles_0_10 int, Miles_11_20 int,Miles_21_30 int,Miles_31_40 int,Miles_41_50 int,Miles_more_50 int)

insert into #result23 (acc_id) select distinct parent_dealer_id  from #result2

--select * from #result23
/*
declare @cust_radius varchar(5000) =

( 
select 
		accId.acc_id
		,cust_rad.range 
		,cust_rad.cust_count 
from #result22 cust_rad inner join #result23 accId on cust_rad.parent_dealer_id =accId.acc_id
order by parent_dealer_id

for json auto
)
select @cust_radius*


update #result23 set Miles_0_10 =  (select cust_count from #result22 where range ='0 - 10 Miles'  )
update #result23 set Miles_11_20 = (select cust_count from #result22 where range ='11 - 20 Miles')
update #result23 set Miles_21_30 = (select cust_count from #result22 where range ='21 - 30 Miles')
update #result23 set Miles_31_40 = (select cust_count from #result22 where range ='31 - 40 Miles')
update #result23 set Miles_41_50 = (select cust_count from #result22 where range ='41 - 50 Miles')
update #result23 set Miles_more_50=(select cust_count from #result22 where range ='> 50 Miles')
*/

update b set
Miles_more_50=isnull(cust_count,0)--,acc_id,parent_dealer_id
from #result22 a inner join #result23 b on a.parent_dealer_id =b.acc_id
where  range ='> 50 Miles'

update b set
Miles_41_50=isnull(cust_count,0)--,acc_id,parent_dealer_id
from #result22 a inner join #result23 b on a.parent_dealer_id =b.acc_id
where  range ='41 - 50 Miles'

update b set
Miles_31_40=isnull(cust_count,0)--,acc_id,parent_dealer_id
from #result22 a inner join #result23 b on a.parent_dealer_id =b.acc_id
where  range ='31 - 40 Miles'

update b set
Miles_21_30=isnull(cust_count,0)--,acc_id,parent_dealer_id
from #result22 a inner join #result23 b on a.parent_dealer_id =b.acc_id
where  range ='21 - 30 Miles'

update b set
Miles_11_20=isnull(cust_count,0)--,acc_id,parent_dealer_id
from #result22 a inner join #result23 b on a.parent_dealer_id =b.acc_id
where  range ='11 - 20 Miles'

update b set
Miles_0_10=isnull(cust_count,0)--,acc_id,parent_dealer_id
from #result22 a inner join #result23 b on a.parent_dealer_id =b.acc_id
where  range ='0 - 10 Miles'



declare @cust_radius varchar(5000) =

( 
select

*
from #result23
FOR JSON PATH
)
select @cust_radius



--select @cust_radius

--IF OBJECT_ID('tempdb..#cust_dist') IS NOT NULL DROP TABLE #cust_dist
--IF OBJECT_ID('tempdb..#result2') IS NOT NULL DROP TABLE #result2
--IF OBJECT_ID('tempdb..#result22') IS NOT NULL DROP TABLE #result22
--IF OBJECT_ID('tempdb..#dlr22') IS NOT NULL DROP TABLE #dlr22



--select 
--	parent_dealer_id, 
--	a.cust_dms_number, 
--	cust_full_name, 
--	cust_zip_code4,
--	Cast(Cast(LEFT(CONVERT(VARCHAR,(geography::Point(41.0224, -73.6234, 4326).STDistance(geography::Point(ISNULL(latitude,0), ISNULL(longitude,0), 4326))/1000)),5) as decimal(18,2)) * 1 as decimal(18,2)) as distance
--into #cust_dist
--from master.customer a (nolock)
--where is_deleted !=1
--and parent_dealer_id=@dealer_id

--select parent_dealer_id
--	,cust_dms_number
--	,cust_full_name
--	,cust_zip_code4
--	,distance
--	,(case when distance <=10 then '0 - 10 Miles'
--			when distance >10 and distance<=20 then '11 - 20 Miles'
--			when distance >20 and distance<=30 then '21 - 30 Miles'
--			when distance >30 and distance<=40 then '31 - 40 Miles'
--			when distance >40 and distance<=50 then '41 - 50 Miles'
--			else '> 50 Miles' end) as range

--	into #result2
--from #cust_dist
--select distinct parent_dealer_id into #dlr22 from #result2
--select parent_dealer_id,[range], count(cust_dms_number) as cust_count into #result22 from #result2 group by parent_dealer_id,[range] order by [range]

--declare @cust_radius varchar(5000) =
--(
--select 
--[data].parent_dealer_id
--,[data].[range]
--,[data].cust_count
--from #dlr22 [accountId] inner join #result22 [data] on accountId.parent_dealer_id = [data].parent_dealer_id
--order by accountId.parent_dealer_id
--FOR JSON PATH
--)


--select @cust_radius
--return;

/*--------------------------	CUSTOMERS PERCENTAGE WITH EMAIL, MAIL AND PHONE INFORMATION
IF OBJECT_ID('tempdb..#temp_customer') IS NOT NULL DROP TABLE #temp_customer
IF OBJECT_ID('tempdb..#result3') IS NOT NULL DROP TABLE #result3
IF OBJECT_ID('tempdb..#result44') IS NOT NULL DROP TABLE #result44
IF OBJECT_ID('tempdb..#dlr44') IS NOT NULL DROP TABLE #dlr44


select 
		parent_dealer_id,
		a.cust_dms_number, 
		cust_full_name, 
		cust_email_address1, 
		cust_home_phone, 
		cust_mobile_phone, 
		cust_work_phone, 
		cust_address1, 
		cust_address2, 
		cust_city, 
		cust_county, 
		cust_state_code, 
		cust_country, 
		cust_zip_code, 
		cust_zip_code4, 
		is_invalid_email, 
		is_invalid_mail,
		(Case when Len(cust_home_phone) > 0 then cust_home_phone 
				when Len(cust_work_phone) > 0 then cust_work_phone 
				when Len(cust_mobile_phone) > 0 then cust_mobile_phone 
				else '' end) as phone
into #temp_customer
from master.customer a (nolock)
where a.parent_dealer_id = @dealer_id and a.is_deleted !=1


declare @total_cust int = (select count(*) total_cust from #temp_customer)

declare @valid_email decimal(18,2) = (select cast(count(cust_dms_number)*100 as decimal(18,2))/@total_cust as perc_valid_email from #temp_customer where is_invalid_email =0)
declare @valid_mail decimal(18,2) = (select cast(count(cust_dms_number)*100 as decimal(18,2))/@total_cust as perc_valid_mail  from #temp_customer where is_invalid_mail =0)
declare @valid_phone decimal(18,2) = (select cast(count(cust_dms_number)*100 as decimal(18,2))/@total_cust  as perc_valid_phone from #temp_customer where len(phone) =0)
--select count(cust_dms_number)*100/@total_cust from #temp_customer where is_invalid_email =0 and is_invalid_mail =0 and len(phone) =0

select distinct parent_dealer_id into #dlr44 from #temp_customer
select @dealer_id as parent_dealer_id,@valid_email as perc_valid_emails ,@valid_mail as perc_valid_mails,@valid_phone as perc_valid_phones into #result44


declare @valid_contact_perc varchar(5000)=
(select
accountId.parent_dealer_id
,[data].perc_valid_emails
,[data].perc_valid_mails
,[data].perc_valid_phones
from #dlr44 accountId inner join #result44 [data] on accountId.parent_dealer_id = [data].parent_dealer_id


FOR JSON AUTO
)

--select @valid_contact_perc
--return;
--select @cust_class, @cust_radius,@valid_contact_perc
*/

IF OBJECT_ID('tempdb..#temp_customer1') IS NOT NULL DROP TABLE #temp_customer1
IF OBJECT_ID('tempdb..#result3') IS NOT NULL DROP TABLE #result3
IF OBJECT_ID('tempdb..#result44') IS NOT NULL DROP TABLE #result44
IF OBJECT_ID('tempdb..#dlr44') IS NOT NULL DROP TABLE #dlr44
IF OBJECT_ID('tempdb..#cust_dlr') IS NOT NULL DROP TABLE #cust_dlr
IF OBJECT_ID('tempdb..#valid_email') IS NOT NULL DROP TABLE #valid_email
IF OBJECT_ID('tempdb..#valid_mail') IS NOT NULL DROP TABLE #valid_mail
IF OBJECT_ID('tempdb..#valid_phone') IS NOT NULL DROP TABLE #valid_phone

select 
		parent_dealer_id,
		a.cust_dms_number, 
		cust_full_name, 
		cust_email_address1, 
		cust_home_phone, 
		cust_mobile_phone, 
		cust_work_phone, 
		cust_address1, 
		cust_address2, 
		cust_city, 
		cust_county, 
		cust_state_code, 
		cust_country, 
		cust_zip_code, 
		cust_zip_code4, 
		is_invalid_email, 
		is_invalid_mail,
		(Case when Len(cust_home_phone) > 0 then cust_home_phone 
				when Len(cust_work_phone) > 0 then cust_work_phone 
				when Len(cust_mobile_phone) > 0 then cust_mobile_phone 
				else '' end) as phone
into #temp_customer1
from master.customer a (nolock)
where  a.is_deleted !=1
--and parent_dealer_id =@dealer_id



declare @total_cust int = (select count(*) total_cust from #temp_customer1)

select 
parent_dealer_id,
count(*) total_cust 
into #cust_dlr
from #temp_customer1 group by parent_dealer_id



select 
c.parent_dealer_id, 
cast(count(cust_dms_number) as decimal(18,2))*100/total_cust as valid_email  
into #valid_email 
from #temp_customer1 c  inner join #cust_dlr d on c.parent_dealer_id=d.parent_dealer_id where is_invalid_email =0 group by c.parent_dealer_id,total_cust

select 
c.parent_dealer_id,
cast(count(cust_dms_number) as decimal(18,2))*100/total_cust as valid_mail  
into #valid_mail
from #temp_customer1 c  inner join #cust_dlr d on c.parent_dealer_id=d.parent_dealer_id where is_invalid_mail =0 group by c.parent_dealer_id,total_cust

select c.parent_dealer_id,
cast(count(cust_dms_number) as decimal(18,2))*100/total_cust as valid_phone 
into #valid_phone
from #temp_customer1 c inner join #cust_dlr d on c.parent_dealer_id=d.parent_dealer_id where len(phone)! =0 group by c.parent_dealer_id,total_cust

select distinct parent_dealer_id into #dlr44 from #temp_customer1

select 
e.parent_dealer_id,
e.valid_email as perc_valid_emails,
m.valid_mail as perc_valid_mails,
p.valid_phone as perc_valid_phones

into #result44

from #valid_email e inner join #valid_mail m on e.parent_dealer_id =m.parent_dealer_id
inner join #valid_phone p on p.parent_dealer_id =m.parent_dealer_id

select * from #result44


declare @valid_contact_perc varchar(5000)=
(select
[data].parent_dealer_id
,Cast([data].perc_valid_emails as decimal(18,2)) as perc_valid_emails
,Cast([data].perc_valid_mails as decimal(18,2)) as perc_valid_mails
,Cast([data].perc_valid_phones as decimal(18,2)) as perc_valid_phones
from #dlr44 accountId inner join #result44 [data] on accountId.parent_dealer_id = [data].parent_dealer_id
order by parent_dealer_id

FOR JSON PATH
)

select @valid_contact_perc
-------------------updating master.dashboard_kpis table with graph data


	--Update master.dashboard_kpis set graph_data = @cust_class where kpi_type = 'Customers Segmentation'

	--Update master.dashboard_kpis set graph_data = @cust_radius where kpi_type = 'Customers by radius'

	--Update master.dashboard_kpis set graph_data = @valid_contact_perc where kpi_type = 'Customers percentage with communication'

	select @cust_class,@cust_radius,@valid_contact_perc
end
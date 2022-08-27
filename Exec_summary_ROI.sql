use clictell_auto_master
go
declare
@dealer varchar(4000) = '524,513,512,514',  
@FromDate date = '2010-01-01',  
@ToDate date = '2021-01-01'

-----------------------------------creating campaign Temp table begin
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

create table #temp
(

id int identity(1,1)
,vin varchar(30)
,cust_id varchar(30)
,campaign_date date
,email_sent_date date
,campaign_type varchar(30)
,dealer_id varchar(20)
)
insert into #temp ( vin, cust_id, campaign_date,email_sent_date,  campaign_type, dealer_id)
select distinct top 3
vin
,c.cust_dms_number
,'2011-10-05'
,'2011-10-01'
,'MoreServices'
,'524'
from master.repair_order_header roh (nolock) 
inner join master.customer c (nolock) on roh.master_customer_id = c.master_customer_id
inner join master.repair_order_header_detail rd (nolock) on  roh.master_ro_header_id = rd.master_ro_header_id
where 
	convert(date,convert(char(8),ro_open_date)) between @FromDate and @ToDate
	and op_code like '%declined%' or customer_comment like '%declined%'

insert into #temp ( vin, cust_id, campaign_date,email_sent_date,  campaign_type,dealer_id)
select distinct top 5
roh.vin
,c.cust_dms_number
,'2011-06-05'
,'2011-06-01'
,'Service Reminders'
,'524'
from master.repair_order_header roh (nolock) 
inner join master.customer c (nolock) on roh.master_customer_id = c.master_customer_id
left outer join #temp t on t.vin  = roh.vin
where 1=1 and t.cust_id  is null
		and convert(date,convert(char(8),ro_open_date)) between @FromDate and @ToDate



insert into #temp ( vin, cust_id, campaign_date,email_sent_date,  campaign_type,dealer_id)
select distinct top 2
roh.vin
,c.cust_dms_number
,'2011-09-05'
,'2011-09-10'
,'Over All'
,'524'
from master.repair_order_header roh (nolock) 
inner join master.customer c (nolock) on roh.master_customer_id = c.master_customer_id
left outer join #temp t on t.vin  = roh.vin
where 1=1 and t.cust_id  is null
		and convert(date,convert(char(8),ro_open_date)) between @FromDate and @ToDate

-----------------------------------creating campaign Temp table end

select * from #temp


/*
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
select distinct
		t.*,ro_open_date
		,iif(datediff(day,campaign_date,convert(date,convert(char(8),ro_open_date))) between 0 and 60,'1','0') as campaign_responce
into #temp1
from #temp t 
inner join master.repair_order_header roh (nolock) on roh.vin = t.vin
where campaign_type = 'MoreServices' 
and (dealer_id in (select [value] from dbo.fn_split_string_to_column(@dealer,',')))
--and (datediff(day,campaign_date,convert(date,convert(char(8),ro_open_date))) between 0 and 60)
order by id



IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2
select distinct
		t.*,ro_open_date
		,iif(datediff(day,campaign_date,convert(date,convert(char(8),ro_open_date))) between 0 and 60,'1','0') as campaign_responce
into #temp2
from #temp t 
inner join master.repair_order_header roh (nolock) on roh.vin = t.vin
where campaign_type = 'Service Reminders' 
and (dealer_id in (select [value] from dbo.fn_split_string_to_column(@dealer,',')))
order by id



IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3
select distinct
		t.*,ro_open_date
		,iif(datediff(day,campaign_date,convert(date,convert(char(8),ro_open_date))) between 0 and 60,'1','0') as campaign_responce
into #temp3
from #temp t 
inner join master.repair_order_header roh (nolock) on roh.vin = t.vin
where campaign_type = 'Over All' 
and (dealer_id in (select [value] from dbo.fn_split_string_to_column(@dealer,',')))
order by id

IF OBJECT_ID('tempdb..#temp4') IS NOT NULL DROP TABLE #temp4
select distinct
		t.*,ro_open_date
		,iif(datediff(day,campaign_date,convert(date,convert(char(8),ro_open_date))) between 0 and 60,'1','0') as campaign_responce
into #temp4
from #temp t 
inner join master.repair_order_header roh (nolock) on roh.vin = t.vin
where campaign_type = 'Recovery phase' 
and (dealer_id in (select [value] from dbo.fn_split_string_to_column(@dealer,',')))

order by id


IF OBJECT_ID('tempdb..#temp5') IS NOT NULL DROP TABLE #temp5
select distinct
		t.*,purchase_date
		,iif(datediff(day,campaign_date,convert(date,convert(char(8),purchase_date))) between 0 and 60,'1','0') as campaign_responce
into #temp5
from #temp t 
inner join master.fi_sales roh (nolock) on roh.vin = t.vin
where campaign_type = 'Vehicle Purchase' 
and (dealer_id in (select [value] from dbo.fn_split_string_to_column(@dealer,',')))
order by id

--return;
--select * from #temp2
--select * from #temp3
--select * from #temp4
--select * from #temp5

declare @MS int = (select count(distinct vin) from #temp1 where campaign_responce = 1)
declare @inv1 int = (select avg(camp_investment) from #temp1)

declare @SR int = (select count(distinct vin) from #temp2 where campaign_responce = 1)
declare @inv2 int = (select avg(camp_investment) from #temp2)

declare @OA int = (select count(distinct vin) from #temp3 where campaign_responce = 1)
declare @inv3 int = (select avg(camp_investment) from #temp3)

declare @RP int = (select count(distinct vin) from #temp4 where campaign_responce = 1)
declare @inv4 int = (select avg(camp_investment) from #temp4)

declare @VP int =(select count(distinct vin) from #temp5 where campaign_responce = 1)
declare @inv5 int = (select avg(camp_investment) from #temp5) 


IF OBJECT_ID('tempdb..#disp') IS NOT NULL DROP TABLE #disp
create table #disp ( campaign varchar(50) ,response int, investment int)

insert into #disp (campaign, response, Investment)
values ('Over All',@OA,@inv3), ('Service Reminders',@SR,@inv2), ('MoreServices', @MS, @inv1), ('Recovery Phase', @RP, @inv4), ('Vehicle Purchase',@VP,@inv5)

select * from #disp

select campaign_type as campaign, count(distinct vin) as vin, sum(customer_pay) as cust_pay,sum(warranty_pay) as warr_pay, avg(camp_investment) as investment, sum(sale_amount) as sale 
from #temp1 where campaign_responce = 1 group by campaign_type
union
select campaign_type, count(distinct vin), sum(customer_pay),sum(warranty_pay), avg(camp_investment), sum(sale_amount) from #temp2 where campaign_responce = 1 group by campaign_type
union
select campaign_type, count(distinct vin), sum(customer_pay),sum(warranty_pay), avg(camp_investment), sum(sale_amount) from #temp3 where campaign_responce = 1 group by campaign_type
union
select campaign_type, count(distinct vin), sum(customer_pay),sum(warranty_pay), avg(camp_investment), sum(sale_amount) from #temp4 where campaign_responce = 1 group by campaign_type
union
select  campaign_type, count(distinct vin), sum(customer_pay),sum(warranty_pay), avg(camp_investment), sum(sale_amount) from #temp5 where campaign_responce = 1 group by campaign_type
*/


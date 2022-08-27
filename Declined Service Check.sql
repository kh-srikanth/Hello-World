drop table if exists #customer
drop table if exists #type_customer
drop table if exists #result1
select 
		parent_dealer_id
		, cust_dms_number
		, ro_number
		, ro_close_date
		, DateDiff(month, Cast(Cast(ro_close_date as varchar(10)) as date), getdate()) as diff
into #customer
from master.repair_order_header (nolock)
where 
	ro_close_date is not null 
	and is_deleted=0 
	and total_repair_order_price>0
	and parent_dealer_id = 4592

	--select * from auto_customers.portal.account with (nolock) where accountname like 'seaco%'

select *, row_number() over(partition by cust_dms_number order by diff asc) as rnk 
into #type_customer
from #customer order by parent_dealer_id,cust_dms_number, diff

select * ,0 as new_cust, 0 as active_cust, 0 as lapsed_cust, 0 as lost_cust into #result1 from #type_customer where rnk =1 

update #result1 set new_cust=1 where diff<12 and cust_dms_number not in (select distinct cust_dms_number from #customer where diff>=12)
update #result1 set active_cust =1 where diff<12 and cust_dms_number in (select distinct cust_dms_number from #customer where diff>=12)
update #result1 set lapsed_cust=1 where diff >= 12 and diff <= 24
update #result1 set lost_cust=1 where diff > 24


------------------------------------KPI3: Total Declines by Month


IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result  
IF OBJECT_ID('tempdb..#dlr33') IS NOT NULL DROP TABLE #dlr33 
drop table if exists #final_result_custsegment
drop table if exists #finla_cust_segment2
drop table if exists #dlr33
--truncate table #final_result_custsegment

select 
			parent_Dealer_id
			,is_declined
			,DATENAME(month,convert(date,convert(char(8),ro_closed_date))) as month_year
			,month(convert(date,convert(char(8),ro_closed_date))) as m
			,year(convert(date,convert(char(8),ro_closed_date))) as y
into #result
from master.repair_order_header_detail (nolock)
where  is_declined =1
and convert(date,convert(char(8),ro_closed_date)) between '2022-01-01' and '2022-08-24'

select distinct parent_dealer_id into #dlr33 from #result1

drop table if exists #finla_cust_segment2
select 
		[data].parent_dealer_id
		,[data].month_year
		--,count(*) as declined
		,sum(convert(int,is_declined)) as declined
into #finla_cust_segment2
from #dlr33 accountId 
inner join #result [data] on 
	accountId.parent_dealer_id = [data].parent_Dealer_id
group by 
	[data].parent_dealer_id,[data].month_year




Declare @parent_dealer_id int  
 While ((select count(*) from #finla_cust_segment2 where is_processed = 0) > 0)  
 Begin  
  select top 1 @parent_dealer_id = parent_dealer_id from #finla_cust_segment2 where is_processed = 0  
  --Insert into #final_result_custsegment (parent_dealer_id, graph_data)  
  select @parent_dealer_id as parent_dealer_id, (select * from #finla_cust_segment2 where parent_dealer_id = @parent_dealer_id For Json AUTO) as graph_data into  #final_result_custsegment
  
  Update #finla_cust_segment2 set is_processed = 1 where parent_dealer_id = @parent_dealer_id  
   
 End  



select * from master.repair_order_header_detail (nolock) where parent_Dealer_id = 4592 and  is_declined = 1 and convert(date,convert(varchar(30),ro_closed_date)) between convert(date,convert(varchar(30),'20220101')) and convert(date,convert(varchar(30),'20220824'))
select * from #result where parent_Dealer_id = 4592
select * from #dlr33

 select * from #final_result_custsegment


 select * from #finla_cust_segment2
 select distinct month_year from #result

 select * from master.dashboard_kpis a (nolock)  where is_deleted =0 and parent_dealer_id= 4592 and dashboard_kpi_id = 496


 select 
	cust_email_address1,cust_mobile_phone,cust_home_phone,cust_work_phone,cust_address1,cust_address2,is_invalid_email,is_invalid_mail 
 from clictell_auto_master.master.customer (nolock) 
 where parent_dealer_id = 4592
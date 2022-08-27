use clictell_auto_master
go

IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

select 
		campaign_id
		,ca.list_member_id
		,run_date
		,convert(date,convert(char(8),ro_open_date)) as ro_open_date
		,ro_number
		,parent_dealer_id
		,datediff(day,convert(date,convert(char(8),ro_open_date)), run_date) as diff
		,ROW_NUMBER() over (partition by ca.list_member_id,ro_number order by ro_open_date asc) as rnk
		
		into #temp
from master.campaign_items ca(nolock)
left outer join master.repair_order_header h (nolock) on h.master_customer_id = ca.list_member_id

where 
	 ca.campaign_id =19 and ca.list_type_id =2 
and convert(date,convert(char(8),ro_open_date)) > ca.run_date
and	 convert(date,convert(char(8),ro_close_date)) < dateadd(day,60,ca.run_date)
and parent_dealer_id is not null

order by list_member_id, run_date, ro_number

--select * from #temp where rnk =1


insert into master.campaign_responce
(		campaign_id
		,master_customer_id
		,run_date
		,ro_open_date
		,ro_number	
		,parent_dealer_id
		)

select 

		campaign_id
		,list_member_id
		,run_date
		,ro_open_date
		,ro_number
		,parent_dealer_id
from #temp where rnk=1

select * from  master.campaign_responce order by master_customer_id, run_date


--select distinct parent_dealer_id from master.repair_order_header  (nolock)

/*
create table master.campaign_responce ( campaign_id int, list_member_id int , run_date datetime, ro_open_date date, ro_number int )
drop table campaign_responce
select * from  master.campaign_responce

truncate table master.campaign_responce


select master_ro_header_id, natural_key, parent_dealer_id, master_customer_id, master_vehicle_id, vin, cust_dms_number, ro_number, ro_open_date, ro_close_date, Dateadd(day, 8, Cast(Cast(ro_open_date as varchar(10)) as date)) as run_date into #temp  from master.repair_order_header (nolock) where --ro_open_date >= 20210601
ro_close_date is not null

select a.* 
from #temp a
inner join #temp b on 
		a.master_customer_id = b.master_customer_id
	and a.master_vehicle_id = b.master_vehicle_id
	and Cast(Cast(b.ro_open_date as varchar(10)) as date) between a.run_date and dateadd(day, 60, a.run_date)
	and a.ro_number != b.ro_number
*/


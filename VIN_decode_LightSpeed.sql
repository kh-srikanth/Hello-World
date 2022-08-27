use auto_customers
go
drop table if exists #temp
drop table if exists #vin_decode

select * into #vin_decode from auto_customers.[customer].[vin_decode] (nolock)

select distinct 
		a.vehicle_id
		,a.vin
		,0 as is_valid_vin
		,0 as is_processed
		,2 as vertical_id
		,getdate() as created_dt
		,row_number() over (partition by a.vin order by a.vehicle_id desc) as rnk
into #temp
from auto_customers.customer.vehicles a (nolock)
left outer join #vin_decode b (nolock) 
				on a.vin = b.vin
where 
	b.vehicle_id is null					
	and len(a.vin) > 15


insert into #vin_decode
(
		vehicle_id
		,vin
		,is_valid_vin
		,is_processed
		,vertical_id
		,created_dt
)

select 
		vehicle_id
		,vin
		,is_valid_vin
		,is_processed
		,vertical_id
		,created_dt

from #temp
where rnk =1

select  * from #vin_decode where convert(date,created_dt) = convert(date,getdate()) order by vin 

select * from auto_customers.[customer].[vin_decode] (nolock)


/*
--select vin,count(*) from #temp group by vin having count(*) > 1

--select vin,count(*) from customer.vehicles group by vin having count(*) > 1

--select vehicle_id,vin,* from customer.vehicles a(nolock) where len(a.vin) >13 order by a.vin,a.vehicle_id 

select vin,vehicle_id,* from auto_customers.[customer].[vin_decode] a (nolock) order by a.vin
group by vin having count(*) >1


select distinct vin from customer.vehicles (nolock)   -- 2,32,986
select distinct vin,vehicle_id from customer.vehicles (nolock)   -- 3,41,352

select vin,customer_id, from customer.vehicles (nolock) where len(vin) > 13

*/
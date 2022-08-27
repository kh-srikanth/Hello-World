select * from customer.customers (nolock) where primary_email like '%Prod8%'
select distinct vehicle_status from customer.vehicles (nolock) 
--where customer_id in (select customer_id from customer.vehicles (nolock) where account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB')

select top 10 odometer,totalowed,rono,vin,* from clictell_auto_etl.etl.cdklgt_service_details_short a(nolock) order by a.rono


select top 10 vin,* from customer.vehicles (nolock) where vehicle_status is not null
select top 10 * from clictell_auto_etl.etl.cdklgt_deals_details a (nolock)

drop table if exists #sales
select 
	--a.DealNo,
	trim(a.custID) as custID--,a.DeliveryDate
	,trim(JSON_VALUE(b.[value],'$.VIN')) as vin
	--,JSON_VALUE(b.[value],'$.Newused') as newused
into #sales
from clictell_auto_etl.etl.cdklgt_deals_details a (nolock) 
cross apply openjson(Units) b

select distinct vin from #sales
select distinct vin from 

select 
vehicle_status , b.newused
,upper(a.vin) as veh_vin , upper(b.vin) as sale_vin
,a.customer_id , b.CustID
,c.is_deleted as cust_del, a.is_deleted as veh_del
--into #result
from customer.vehicles a(nolock)
inner join customer.customers c (nolock) on a.customer_id = c.customer_id
inner join #sales b on c.src_cust_id = b.CustID and a.vin = b.vin

order by a.customer_id


select * from #result order by  where veh_vin ='1HFVE0429G4000929' --and customer_id =
select * from #sales where vin ='1HFVE0429G4000929' and custID =250481
select * from  customer.vehicles a(nolock) where vin = '1HFVE0429G4000929'

/*
update a set 
vehicle_status = b.newused
from customer.vehicles a(nolock)
inner join customer.customers c (nolock) on a.customer_id = c.customer_id
inner join #sales b on c.src_cust_id = b.CustID and a.vin = b.vin
*/

drop table if exists #service
select 
			odometer
			,totalowed
			,rono
			,closedate
			,vin
			,custID
	,*
from clictell_auto_etl.etl.cdklgt_service_details_short a(nolock)


select 
a.customer_id,
odometer, totalowed
from customer.vehicles a(nolock)
inner join customer.customers c (nolock) on a.customer_id = c.customer_id
inner join #service b on c.src_cust_id = b.CustID and a.vin = b.vin


select top 10 * from customer.vehicles a(nolock) where miles_ridden is not null





use auto_customers
Go

--------------------- Script for Buddy Count Update
select b.customer_id, count(*) as cc into #temp_buddy_rider
from [18.216.140.206].[r2r_admin].[buddy].[buddy] a with (nolock)
inner join customer.customers b (nolock) on a.sender_id = b.r2r_customer_id
where a.is_deleted = 0 and b.is_deleted = 0 and a.is_request_accepted = 1
--and b.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
group by b.customer_id

select a.customer_id, a.buddy_count, b.cc
--Update a set a.buddy_count = b.cc
from customer.customers a (nolock)
inner join #temp_buddy_rider b on a.customer_id = b.customer_id
where isnull(a.buddy_count, 0) != b.cc


--------------------- Script for Promotion Count Update
select b.customer_id, count(*) as cc into #temp_promotions
from [18.216.140.206].[r2r_admin].[owner].owner_promotions a with (nolock)
inner join customer.customers b (nolock) on a.owner_id = b.r2r_customer_id
where a.is_deleted = 0 and b.is_deleted = 0 and a.is_redeemed = 1
--and b.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
group by b.customer_id


select a.customer_id, a.promotions_count, b.cc
--Update a set a.promotions_count = b.cc
from customer.customers a (nolock)
inner join #temp_promotions b on a.customer_id = b.customer_id
where isnull(a.promotions_count, 0) != b.cc


--------------------- Script for Event Count Update
select b.customer_id, a.owner_id,  count(*) as cc into #temp_events
from [18.216.140.206].[r2r_admin].[owner].owner_events a with (nolock)
inner join customer.customers b (nolock) on a.owner_id = b.r2r_customer_id
where a.is_deleted = 0 and b.is_deleted = 0 --and a.is_redeemed = 1
--and b.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
group by b.customer_id, a.owner_id


select a.customer_id, a.events_count, b.cc
--Update a set a.events_count = b.cc
from customer.customers a (nolock)
inner join #temp_events b on a.customer_id = b.customer_id
where isnull(a.events_count, 0) != b.cc

--------------------- Script for Rides Data Update
drop table #temp_ride_log
drop table #temp_rides_cc
drop table #temp_ride_json1
drop table #temp_json2
drop table #temp_json3
drop table #temp_json4

select ride_id, ride_log, owner_id, cycle_id, is_deleted into #temp_ride_log from [18.216.140.206].[r2r_admin].[ride].[ride] with (nolock) where is_ride_saved = 1 and is_deleted = 0

select cycle_id, count(distinct ride_id) as rides into #temp_rides_cc from #temp_ride_log group by cycle_id

select a.vehicle_id, a.vin, a.customer_id, a.rides_taken, b.rides, b.cycle_id
--Update a set a.rides_taken = b.rides
from customer.vehicles a (nolock)
inner join #temp_rides_cc b on a.r2r_vehicle_id = b.cycle_id

select a.owner_id, a.cycle_id, b.value as [ride_json], ride_id into #temp_ride_json1
from #temp_ride_log a
Cross Apply OpenJson(ride_log)as b
where Len(a.ride_log) > 0

select 
	owner_id, cycle_id, ride_id,
	Json_value(ride_json, '$.Distance') as distance,
	Json_value(ride_json, '$.Speed') as speed,
	Json_value(ride_json, '$.Time') as [Time],
	Json_value(ride_json, '$.SubRideId') as subride_id
into #temp_json2
from #temp_ride_json1 

select a.cycle_id, sum(cast(speed as decimal(18,2))) as speed, b.rides, sum(Cast(distance as decimal(18,2))) as distance, 
sum(Cast([Time] as decimal(18,2))) as [time]
into #temp_json3
from #temp_json2 a
inner join #temp_rides_cc b on a.cycle_id = b.cycle_id
group by a.cycle_id, b.rides

select *, [dbo].[get_avg_speed](distance, [time]) as avg_mph  into #temp_json4
from #temp_json3
order by 6 DESC


select a.vehicle_id, a.vin, a.customer_id, a.rides_taken, a.avg_mph, b.avg_mph, a.miles_ridden, b.distance
--Update a set a.avg_mph = b.avg_mph, a.miles_ridden = b.distance
from customer.vehicles a (nolock)
inner join #temp_json4 b on a.r2r_vehicle_id = b.cycle_id


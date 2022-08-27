select dealer_id, count(*) 
from [18.216.140.206].[r2r_admin].cycle.cycle_service a with (nolock) where dealer_id in (2990,48878,48884,48829,48570,48752,48755) group by dealer_id


and a.account_id in (
'7DB79611-A797-4938-AAC8-F3A887384304',
'EF42DEF6-DA60-4632-B879-B01B26CDE74A',
'A1478891-4F48-4B55-9D64-B5FB5B99B1EF',
'3822DF16-C38D-4280-AB89-0304B430E3C3',
'96DBF74D-C8BD-459B-B751-B93F961EF884',
'6B9537BD-115F-4019-B3AA-7F981EC69559',
'F0590E45-19AA-4597-A2B5-67553DD7B113'
) 
and b.dealer_id in (2990,48878,48884,48829,48570,48752,48755) 


select account_id, count(*) from auto_customers.customer.vehicles (nolock) where account_id in (
'7DB79611-A797-4938-AAC8-F3A887384304',
'EF42DEF6-DA60-4632-B879-B01B26CDE74A',
'A1478891-4F48-4B55-9D64-B5FB5B99B1EF',
'3822DF16-C38D-4280-AB89-0304B430E3C3',
'96DBF74D-C8BD-459B-B751-B93F961EF884',
'6B9537BD-115F-4019-B3AA-7F981EC69559',
'F0590E45-19AA-4597-A2B5-67553DD7B113'
) group by account_id

select top 10 * from auto_customers.customer.vehicles (nolock) where is_deleted = 0 and account_id in (
'7DB79611-A797-4938-AAC8-F3A887384304',
'EF42DEF6-DA60-4632-B879-B01B26CDE74A',
'A1478891-4F48-4B55-9D64-B5FB5B99B1EF',
'3822DF16-C38D-4280-AB89-0304B430E3C3',
'96DBF74D-C8BD-459B-B751-B93F961EF884',
'6B9537BD-115F-4019-B3AA-7F981EC69559',
'F0590E45-19AA-4597-A2B5-67553DD7B113'
) 
select top 3 * from [18.216.140.206].[r2r_admin].cycle.cycle_service a with (nolock) where is_deleted =0 and dealer_id in (2990,48878,48884,48829,48570,48752,48755) 
select top 3 * from [18.216.140.206].[r2r_admin].cycle.cycle a with (nolock) where is_deleted =0 and dealer_id in (2990,48878,48884,48829,48570,48752,48755) 
select top 3 * from [18.216.140.206].[r2r_admin].owner.owner a with (nolock) where is_deleted =0 and dealer_id in (2990,48878,48884,48829,48570,48752,48755) 
select top 10 * from auto_customers.customer.vehicles (nolock) a where is_deleted =0
select top 10 * from auto_customers.customer.customers (nolock) a where is_deleted =0
select top 10 * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock)

select cycle_id, count(distinct vin) from [18.216.140.206].[r2r_admin].cycle.cycle with (nolock) group by cycle_id having count(distinct vin) > 1



drop table if exists #temp1
select 
b.dealer_id,o.owner_id,c.cycle_id,b.service_date
,ROW_NUMBER() over (partition by c.dealer_id,c.cycle_id,o.owner_id order by b.service_date) as rnk
into #temp1
from [18.216.140.206].[r2r_admin].cycle.cycle_service b with (nolock) 
inner join [18.216.140.206].[r2r_admin].cycle.cycle c with (nolock) on b.cycle_id  = c.cycle_id and c.dealer_id = b.dealer_id
inner join [18.216.140.206].[r2r_admin].owner.owner o with (nolock) on c.owner_id = o.owner_id and o.dealer_id = c.dealer_id
where  b.dealer_id = 48755
--and b.is_deleted =0 and c.is_deleted =0 and o.is_deleted =0 

select count(*) from #temp1 where rnk =1

select --32,228
a.dealer_id,a.cycle_id,b.r2r_vehicle_id,a.owner_id,c.r2r_customer_id,b.last_service_date,a.service_date

--update b set last_service_date = a.service_date, b.updated_by = 'SK_LS_date', updated_dt = getdate()
from #temp1 a
inner join [PostgreSQL_Clictell].[clictell].[public].[account] p with (nolock) on a.dealer_id = p.r2r_dealer_id
inner join auto_customers.customer.vehicles (nolock) b on a.cycle_id = b.r2r_vehicle_id
inner join auto_customers.customer.customers (nolock) c on c.r2r_customer_id = a.owner_id and b.account_id = c.account_id
where a.rnk =1 and p.accountstatus = 'active'

48878 -- updated 5388
48884  --17494
select distinct cycle_id from  [18.216.140.206].[r2r_admin].cycle.cycle b with (nolock)  where dealer_id = 2990 
except
select distinct cycle_id from  [18.216.140.206].[r2r_admin].cycle.cycle_service b with (nolock)  where dealer_id = 2990 

 
drop table if exists #missing
select distinct cycle_id into #missing from  [18.216.140.206].[r2r_admin].cycle.cycle_service b with (nolock)  where dealer_id = 2990 
except
select distinct cycle_id from  #temp1  where dealer_id = 2990 and rnk=1

drop table if exists #miss_owner
select * into #miss_owner from [18.216.140.206].[r2r_admin].cycle.cycle c with (nolock)  where cycle_id in (select cycle_id from #missing) and dealer_id = 2990
select * from #miss_owner 
select * from [18.216.140.206].[r2r_admin].owner.owner o with (nolock)  where owner_id in (select owner_id from #miss_owner) and dealer_id =2990










--update a set is_deleted =1
select * from clictell_auto_master.master.vehicle_makemodel a (nolock) where vertical_id =2 and model like '%?%'
--and isnull(ModelYear,'') = ''
select * from auto_customers.customer.customers (nolock) where account_id = '278e54da-7d6d-479d-8f20-817eb8762e44' and primary_phone_number  = '7660040815'
select * from auto_customers.customer.vehicles (nolock) where customer_id = 3436449 and account_id = '278e54da-7d6d-479d-8f20-817eb8762e44' and is_deleted =0


insert into clictell_auto_master.master.vehicle_makemodel 
(
	make
	,makedesc
	,model
	,modeldesc
	,modelyear
	,vertical_id
)
select distinct  
	 a.make
	,a.make as makedesc
	,a.model
	,a.model as modeldesc
	,a.[year] as modelyear
	,2 as vertical_id
from auto_customers.customer.vehicles a (nolock) 
left outer join clictell_auto_master.master.vehicle_makemodel b (nolock)
		on a.make =b.make and a.model = b.model and a.[year] = b.[modelyear] and b.is_deleted =0
where 
a.is_deleted =0 
and b.makemodel_id is null
and len(a.make) <> 0 and len(a.model) <> 0 and isnull(a.[year],0) > 1900
and a.account_id IN ('7DB79611-A797-4938-AAC8-F3A887384304', '82abf13b-b9c9-4bab-b883-7613e964a1eb', 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
					,'96DBF74D-C8BD-459B-B751-B93F961EF884', '6B9537BD-115F-4019-B3AA-7F981EC69559', 'F0590E45-19AA-4597-A2B5-67553DD7B113'
					,'ef42def6-da60-4632-b879-b01b26cde74a', 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF', 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A'
					,'9A9AC801-A7EE-40FB-99DA-B80F552A3A61') 
order by a.make,a.model,a.[year]




drop table if exists #temp_makes
select distinct make, model, Isnull([year], 1900) as [year] into #temp_makes
from Customer.vehicles a (nolock)
where account_id IN ('7DB79611-A797-4938-AAC8-F3A887384304', '82abf13b-b9c9-4bab-b883-7613e964a1eb', 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
					,'96DBF74D-C8BD-459B-B751-B93F961EF884', '6B9537BD-115F-4019-B3AA-7F981EC69559', 'F0590E45-19AA-4597-A2B5-67553DD7B113'
					,'ef42def6-da60-4632-b879-b01b26cde74a', 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF', 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A')
and Isnull(make, '') != ''

select * from #temp_makes

select a.make,a.model,a.year 
from Customer.vehicles a (nolock) 
left outer join clictell_auto_master.master.vehicle_makemodel b on a.make = b.make and a.model = b.model and b.modelyear = a.[year] and b.vertical_id = 2
where a.is_deleted =0 and  
b.makemodel_id is null and
a.account_id IN ('7DB79611-A797-4938-AAC8-F3A887384304', '82abf13b-b9c9-4bab-b883-7613e964a1eb', 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
					,'96DBF74D-C8BD-459B-B751-B93F961EF884', '6B9537BD-115F-4019-B3AA-7F981EC69559', 'F0590E45-19AA-4597-A2B5-67553DD7B113'
					,'ef42def6-da60-4632-b879-b01b26cde74a', 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF', 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A') 
and Isnull(a.make, '') != ''





--insert into clictell_auto_master.master.vehicle_makemodel 
--(
--	make
--	,makedesc
--	,model
--	,modeldesc
--	,modelyear
--	,vertical_id
--	,created_by
--	,created_dt
--	,updated_by
--	,updated_dt
--)

select 
	upper(make) as make
	,upper(make) as makedesc
	,upper(model) as new_model
	,upper(model) as modeldesc
	,[year] as model_year
	,2 as vertical_id
	,suser_name()
	,getdate()
	,suser_name()
	,getdate()

from (
select b.*, replace(b.model,' ', '') as new_model, rank() over (partition by b.make, replace(b.model,' ', ''), b.[year] order by newid()) as rnk
from #temp_makes b (nolock)
left outer join clictell_auto_master.master.vehicle_makemodel a on a.make = b.make and a.model = b.model and a.modelyear = b.[year] and a.vertical_id = 2
where a.makemodel_id is null --and b.make like 'A%'
) as a where a.rnk = 1
order by 1


select distinct model 
from auto_customers.customer.vehicles a (nolock)
where 
a.is_deleted =0 and  
a.account_id IN ('7DB79611-A797-4938-AAC8-F3A887384304', '82abf13b-b9c9-4bab-b883-7613e964a1eb', 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
					,'96DBF74D-C8BD-459B-B751-B93F961EF884', '6B9537BD-115F-4019-B3AA-7F981EC69559', 'F0590E45-19AA-4597-A2B5-67553DD7B113'
					,'ef42def6-da60-4632-b879-b01b26cde74a', 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF', 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A') 
and Isnull(a.make, '') != ''
except
select distinct model 
from clictell_auto_master.master.vehicle_makemodel (nolock)
where 
is_Deleted =0 
and vertical_id =2 



select top 10 * from clictell_auto_master.master.vehicle_makemodel (nolock) where make = 'HONDA' and model  like 'VTX 1800%' and is_deleted =0 
select * 
--update a set model  = 'VTX 1800'
from auto_customers.customer.vehicles a (nolock) where is_deleted =0 and vin = '1HFSC46004A202051'

select model,modeldesc,* 
--update a set model = '500SPORTSMAN' , modeldesc = '500SPORTSMAN' 
from clictell_auto_master.master.vehicle_makemodel a(nolock) where model like '500sp%'

select model,vin,* 
--update a set model = '500SPORTSMAN'
from auto_customers.customer.vehicles a (nolock) where model like '500sp%'



select model,modeldesc,* 
--update a set model = '500SPORTSMAN' , modeldesc = '500SPORTSMAN' 
from clictell_auto_master.master.vehicle_makemodel a(nolock) where model like '500 sp%'

select model,vin,* 
--update a set model = '500SPORTSMAN'
from auto_customers.customer.vehicles a (nolock) where model like '500 sp%'



select model,modeldesc,* 
--update a set model = '550SPORTSMAN' , modeldesc = '550SPORTSMAN' 
from clictell_auto_master.master.vehicle_makemodel a(nolock) where model like '550 sp%'

select model,vin,* 
--update a set model = '550SPORTSMAN'
from auto_customers.customer.vehicles a (nolock) where model like '550 sp%'


select model,modeldesc,* 
--update a set model = '570SPORTSMAN' , modeldesc = '570SPORTSMAN' 
from clictell_auto_master.master.vehicle_makemodel a(nolock) where model like '570 sp%'

select model,vin,* 
--update a set model = '570SPORTSMAN'
from auto_customers.customer.vehicles a (nolock) where model like '570 sp%'


select model,modeldesc,* 
--update a set model = '670SUMMIT' , modeldesc = '670SUMMIT' 
from clictell_auto_master.master.vehicle_makemodel a(nolock) where model like '670su%'

select model,vin,* 
--update a set model = '670SUMMIT'
from auto_customers.customer.vehicles a (nolock) where model like '670su%'



select model,modeldesc,* 
--update a set model = '670SUMMIT' , modeldesc = '670SUMMIT' 
from clictell_auto_master.master.vehicle_makemodel a(nolock) where model like '670 su%'

select model,vin,* 
--update a set model = '670SUMMIT'
from auto_customers.customer.vehicles a (nolock) where model like '670 su%'


select model,modeldesc,* 
--update a set model = '848STREETFIGHTER' , modeldesc = '848STREETFIGHTER' 
from clictell_auto_master.master.vehicle_makemodel a(nolock) where model like '848 str%'

select model,vin,* 
--update a set model = '848STREETFIGHTER'
from auto_customers.customer.vehicles a (nolock) where model like '848 str%'


select model,modeldesc,* 
--update a set model = '848STREETFIGHTER' , modeldesc = '848STREETFIGHTER' 
from clictell_auto_master.master.vehicle_makemodel a(nolock) where model like '848str%'

select model,vin,* 
--update a set model = '848STREETFIGHTER'
from auto_customers.customer.vehicles a (nolock) where model like '848str%'


select model,modeldesc,* 
--update a set model = 'UNKNOWN' , modeldesc = 'UNKNOWN' 
from clictell_auto_master.master.vehicle_makemodel a(nolock) where model like 'carry in%'

select model,vin,* 
--update a set model = 'UNKNOWN'
from auto_customers.customer.vehicles a (nolock) where model like 'carry in%'


select model,modeldesc,* 
--update a set model = 'UNKNOWN' , modeldesc = 'UNKNOWN' 
from clictell_auto_master.master.vehicle_makemodel a(nolock) where model like '*%'

select model,vin,* 
--update a set model = 'UNKNOWN'
from auto_customers.customer.vehicles a (nolock) where model like '*%'


select model,modeldesc,* 
--update a set model = 'WILDCAT' , modeldesc = 'WILDCAT' 
from clictell_auto_master.master.vehicle_makemodel a(nolock) where model like 'wild%'

select model,vin,* 
--update a set model = 'WILDCAT'
from auto_customers.customer.vehicles a (nolock) where model like 'wild%'


select model,modeldesc,* 
--update a set model = 'ATLANTIC 500' , modeldesc = 'ATLANTIC 500' 
from clictell_auto_master.master.vehicle_makemodel a(nolock) where model like 'ATLAN%'

select model,vin,* 
--update a set model = 'ATLANTIC 500'
from auto_customers.customer.vehicles a (nolock) where model like 'ATLAN%'


select model,modeldesc,* 
--update a set model = 'SHIVER 750' , modeldesc = 'SHIVER 750' 
from clictell_auto_master.master.vehicle_makemodel a(nolock) where model like 'shive%'

select model,vin,* 
--update a set model = 'SHIVER 750'
from auto_customers.customer.vehicles a (nolock) where model like 'shive%'


select model,modeldesc,* 
--update a set model = 'CRF50' , modeldesc = 'CRF50' 
from clictell_auto_master.master.vehicle_makemodel a(nolock) where model like 'CRF50WHEELS ONL%'

select model,vin,* 
--update a set model = 'CRF50'
from auto_customers.customer.vehicles a (nolock) where model like 'CRF50WHEELS ONL%'


select model,modeldesc,* 
--update a set model = 'CRF50' , modeldesc = 'CRF50' 
from clictell_auto_master.master.vehicle_makemodel a(nolock) where model like 'TRX450%'

select model,vin,* 
--update a set model = 'CRF50'
from auto_customers.customer.vehicles a (nolock) where model like 'TRX450%'



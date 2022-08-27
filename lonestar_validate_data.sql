drop table if exists #customers
select 
	customer_id
	,src_cust_id
	,primary_phone_number
	,secondary_phone_number
	,primary_email
	,is_deleted
into #customers
from auto_customers.customer.customers (nolock) where account_id = '2928eacc-a39d-4743-bf02-f9689f16e79f'

drop table if exists #vehicles
select 
	vehicle_id
	,a.customer_id
	,vin
	,make
	,model
	,year
	,last_service_date
	,purchase_date
	,a.is_deleted
into #vehicles
from auto_customers.customer.vehicles a (nolock) 
--inner join #customers b on a.customer_id = b.customer_id
where a.account_id  = '2928eacc-a39d-4743-bf02-f9689f16e79f' 



select is_Deleted, count(*) from #vehicles  group by is_deleted with rollup
select is_Deleted, count(*) from #customers group by is_deleted



select * from #vehicles where is_deleted = 1
select * from #customers where customer_id in (select customer_id from #vehicles where is_deleted = 0) and is_deleted =1



select vehicle_id from (
select *
	,row_number() over (partition by vin order by is_deleted asc) as rnk
	, count(*) over (partition by vin) as cc  
from #vehicles 
where 
	vin in (select vin from #vehicles where is_deleted = 1)
) as a 

where rnk =1 and is_deleted =1





select * 
,row_number() over (partition by vin order by last_visit desc) as rnk2
from (
select *
	,row_number() over (partition by vin order by is_deleted) as rnk
	, count(*) over (partition by vin) as cc  
	,case when isnull(last_service_date,1900) >= isnull(purchase_date,1900) then last_service_date else purchase_date end as last_visit
from #vehicles 
where 
	vin in (select vin from #vehicles where is_deleted = 1)
) as a 

where 1=1 





---deleted customers need to be undelete
select customer_id
,(case when primary_phone_number_valid =1 then primary_phone_number 
	 when primary_phone_number_valid = 0  and secondary_phone_number_valid = 1 then secondary_phone_number else '' end) as phone
,primary_email
,is_deleted
from auto_customers.customer.customers (nolock) where customer_id in (
select customer_id from #customers where customer_id in (select customer_id from #vehicles where is_deleted =0) and is_deleted =1 
)


select is_deleted,* from auto_customers.customer.customers (nolock) where primary_phone_number = '4694947821' or secondary_phone_number = '4694947821'

select * from auto_customers.customer.vehicles (nolock) where customer_id in (3603339,3586932,3588741)

select * 
--update a set customer_id = 3603339
from auto_customers.customer.vehicles a (nolock) where vehicle_id in (1527005,1530130,1530894,1535593,1535598)

select *
--update a set is_deleted =1
from auto_customers.customer.customers a (nolock) where customer_id = 3588741







------ETL validation

Use auto_customers
,'JYACJ15C1DA021681'
,'JYARJ12E66A008766'
,'JYAVM01E6YA019030')
,'JYACJ15C1DA021681'
,'JYARJ12E66A008766'
,'JYAVM01E6YA019030')
,8782112
,1278721
,8828166
,8929012
,8782112
,1278721
,8828166
,8929012
,8782112
,1278721
,8828166
,8929012
,4000334
,4000335
,4001453
,4002451
,4002451
,308802
,308832
,308880
,8782112
,8929012
,8955788
,1278721
,9138232
,9139350
,8420133
,8927396
,9138287
,8847482
,8866082
,9138503
,8999065
,8874713
,9137826
,9138509
,9138337
,9138119
,9138120
,8828166
,3633785
,3633786
,3633787
,3588741
,3607256
,3633789
,3633790
,3633793
,3633794
,3633795
,3633797

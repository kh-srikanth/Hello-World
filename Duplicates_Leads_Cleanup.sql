---E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A			Cycle Design
drop table if exists #temp
select 
	 a.customer_id
	,a.primary_phone_number
	,a.primary_phone_number_valid
	,a.secondary_phone_number
	,a.secondary_phone_number_valid
	,case when len(a.primary_phone_number) >= 10 then a.primary_phone_number
		  when len(a.primary_phone_number) < 10 and  len(a.secondary_phone_number) >= 10 then a.secondary_phone_number else '' end as phone_number
	,a.primary_email
	,b.vehicle_id
	,b.vin
	,b.make
	,b.model
	,b.year
	,a.is_deleted

	into #temp
from auto_customers.customer.customers a  (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_deleted =0 
and a.is_subscriber = 0
and a.account_id  = 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A'

drop table if exists #temp1
select *
,Rank() over (partition by phone_number,primary_email,make,model,year order by customer_id desc) as rnk
into #temp1
from #temp

select * from #temp1 where rnk <> 1

select * 
--update a set is_deleted =1, updated_by = 'lead_dupli_sk',updated_dt = getdate()
from auto_customers.customer.customers a  (nolock) where is_deleted =0 and account_id  = 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A' and customer_id in 
(select customer_id from #temp1 where rnk <> 1)



drop table if exists #temp_new
select 
	 a.customer_id
	,a.primary_phone_number
	,a.primary_phone_number_valid
	,a.secondary_phone_number
	,a.secondary_phone_number_valid
	,case when len(a.primary_phone_number) >= 10 then a.primary_phone_number
		  when len(a.primary_phone_number) < 10 and  len(a.secondary_phone_number) >= 10 then a.secondary_phone_number else '' end as phone_number
	,a.primary_email
	,b.vehicle_id
	,b.vin
	,b.make
	,b.model
	,b.year
	,a.is_deleted

	into #temp_new
from auto_customers.customer.customers a  (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_deleted =0 
and a.is_subscriber = 0
and a.account_id  = 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A'


select * from (
select 
	customer_id
	,phone_number
	,primary_email
	,vehicle_id
	,make
	,model
	,year 
	,rank() over (partition by phone_number,primary_email order by customer_id) as rnk
from #temp_new 
) as a where rnk > 1
order by phone_number,primary_email


select 
	customer_id
	,phone_number
	,primary_email
	,vehicle_id
	,make
	,model
	,year 
	,rank() over (partition by phone_number,primary_email order by customer_id) as rnk
from #temp_new where primary_email LIKE 'DAVID.GALVIN.JR@GMAIL.COM'


use auto_customers

select *
--update b set customer_id = 3445934, updated_by = 'sk_leadClean',updated_dt = getdate()
from auto_customers.customer.vehicles b (nolock)
where b.is_deleted =0
and vehicle_id  = 3583

select *
--update a set is_deleted = 1 ,updated_by = 'lead_dupli_sk',updated_dt = getdate()
from auto_customers.customer.customers a  (nolock)
where 
a.is_deleted =0 
and a.is_subscriber = 0
and a.account_id  = 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A'
and customer_id = 43440



---D74F05FA-FCB4-4AFC-AB9A-6C2497F7FD9A	Champion Motor Sports

drop table if exists #temp
select 
	 a.customer_id
	,a.primary_phone_number
	,a.primary_phone_number_valid
	,a.secondary_phone_number
	,a.secondary_phone_number_valid
	,case when len(a.primary_phone_number) >= 10 then a.primary_phone_number
		  when len(a.primary_phone_number) < 10 and  len(a.secondary_phone_number) >= 10 then a.secondary_phone_number else '' end as phone_number
	,a.primary_email
	,b.vehicle_id
	,b.vin
	,b.make
	,b.model
	,b.year
	,a.is_deleted

	into #temp
from auto_customers.customer.customers a  (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_deleted =0 
and a.is_subscriber = 0
and a.account_id  = 'D74F05FA-FCB4-4AFC-AB9A-6C2497F7FD9A'

drop table if exists #temp1
select *
,Rank() over (partition by phone_number,primary_email,make,model,year order by customer_id desc) as rnk
into #temp1
from #temp

select * from #temp1 where rnk <> 1

select * 
--update a set is_deleted =1, updated_by = 'lead_dupli_sk',updated_dt = getdate()
from auto_customers.customer.customers a  (nolock) where is_deleted =0 and account_id  = 'D74F05FA-FCB4-4AFC-AB9A-6C2497F7FD9A' and customer_id in 
(select customer_id from #temp1 where rnk <> 1)

	---STG2
drop table if exists #temp_new
select 
	 a.customer_id
	,a.primary_phone_number
	,a.primary_phone_number_valid
	,a.secondary_phone_number
	,a.secondary_phone_number_valid
	,case when len(a.primary_phone_number) >= 10 then a.primary_phone_number
		  when len(a.primary_phone_number) < 10 and  len(a.secondary_phone_number) >= 10 then a.secondary_phone_number else '' end as phone_number
	,a.primary_email
	,b.vehicle_id
	,b.vin
	,b.make
	,b.model
	,b.year
	,a.is_deleted

	into #temp_new
from auto_customers.customer.customers a  (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_deleted =0 
and a.is_subscriber = 0
and a.account_id  = 'D74F05FA-FCB4-4AFC-AB9A-6C2497F7FD9A'


select * from (
select 
	customer_id
	,phone_number
	,primary_email
	,vehicle_id
	,make
	,model
	,year 
	,rank() over (partition by phone_number,primary_email order by customer_id) as rnk
from #temp_new 
) as a where rnk > 1
order by phone_number,primary_email


select 
	customer_id
	,phone_number
	,primary_email
	,vehicle_id
	,make
	,model
	,year 
	,rank() over (partition by phone_number,primary_email order by customer_id) as rnk
from #temp_new where primary_email LIKE 'lconsuegra.vasquez8008@gmail.com'


use auto_customers

select *
--update b set customer_id = 3620589, updated_by = 'sk_leadClean',updated_dt = getdate()
from auto_customers.customer.vehicles b (nolock)
where b.is_deleted =0
and vehicle_id  in (1533362)

select *
--update a set is_deleted = 1 ,updated_by = 'lead_dupli_sk',updated_dt = getdate()
from auto_customers.customer.customers a  (nolock)
where 
a.is_deleted =0 
and a.is_subscriber = 0
and a.account_id  = 'D74F05FA-FCB4-4AFC-AB9A-6C2497F7FD9A'
and customer_id in ( 3620588)




----9DBF432C-0DA6-4337-80BF-E24F03E9D821	        Main Street Moto


drop table if exists #temp
select 
	 a.customer_id
	,a.primary_phone_number
	,a.primary_phone_number_valid
	,a.secondary_phone_number
	,a.secondary_phone_number_valid
	,case when len(a.primary_phone_number) >= 10 then a.primary_phone_number
		  when len(a.primary_phone_number) < 10 and  len(a.secondary_phone_number) >= 10 then a.secondary_phone_number else '' end as phone_number
	,a.primary_email
	,b.vehicle_id
	,b.vin
	,b.make
	,b.model
	,b.year
	,a.is_deleted

	into #temp
from auto_customers.customer.customers a  (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_deleted =0 
and a.is_subscriber = 0
and a.account_id  = '9DBF432C-0DA6-4337-80BF-E24F03E9D821'

drop table if exists #temp1
select *
,Rank() over (partition by phone_number,primary_email,make,model,year order by customer_id desc) as rnk
into #temp1
from #temp

select * from #temp1 where rnk <> 1

select * 
--update a set is_deleted =1, updated_by = 'lead_dupli_sk',updated_dt = getdate()
from auto_customers.customer.customers a  (nolock) where is_deleted =0 and account_id  = '9DBF432C-0DA6-4337-80BF-E24F03E9D821' and customer_id in 
(select customer_id from #temp1 where rnk <> 1)

	--STG2
drop table if exists #temp_new
select 
	 a.customer_id
	,a.primary_phone_number
	,a.primary_phone_number_valid
	,a.secondary_phone_number
	,a.secondary_phone_number_valid
	,case when len(a.primary_phone_number) >= 10 then a.primary_phone_number
		  when len(a.primary_phone_number) < 10 and  len(a.secondary_phone_number) >= 10 then a.secondary_phone_number else '' end as phone_number
	,a.primary_email
	,b.vehicle_id
	,b.vin
	,b.make
	,b.model
	,b.year
	,a.is_deleted

	into #temp_new
from auto_customers.customer.customers a  (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_deleted =0 
and a.is_subscriber = 0
and a.account_id  = '9DBF432C-0DA6-4337-80BF-E24F03E9D821'


select * from (
select 
	customer_id
	,phone_number
	,primary_email
	,vehicle_id
	,make
	,model
	,year 
	,rank() over (partition by phone_number,primary_email order by customer_id) as rnk
from #temp_new 
) as a where rnk > 1
order by phone_number,primary_email


select 
	customer_id
	,phone_number
	,primary_email
	,vehicle_id
	,make
	,model
	,year 
	,rank() over (partition by phone_number,primary_email order by customer_id) as rnk
from #temp_new where primary_email LIKE 'lconsuegra.vasquez8008@gmail.com'


use auto_customers

select *
--update b set customer_id = 3620589, updated_by = 'sk_leadClean',updated_dt = getdate()
from auto_customers.customer.vehicles b (nolock)
where b.is_deleted =0
and vehicle_id  in (1533362)

select *
--update a set is_deleted = 1 ,updated_by = 'lead_dupli_sk',updated_dt = getdate()
from auto_customers.customer.customers a  (nolock)
where 
a.is_deleted =0 
and a.is_subscriber = 0
and a.account_id  = '9DBF432C-0DA6-4337-80BF-E24F03E9D821'
and customer_id in ( 3620588)


----1AFCA2E5-B2B9-49A0-9894-506AA6F3D6CD	Champion Harley-Davidson


drop table if exists #temp
select 
	 a.customer_id
	,a.primary_phone_number
	,a.primary_phone_number_valid
	,a.secondary_phone_number
	,a.secondary_phone_number_valid
	,case when len(a.primary_phone_number) >= 10 then a.primary_phone_number
		  when len(a.primary_phone_number) < 10 and  len(a.secondary_phone_number) >= 10 then a.secondary_phone_number else '' end as phone_number
	,a.primary_email
	,b.vehicle_id
	,b.vin
	,b.make
	,b.model
	,b.year
	,a.is_deleted

	into #temp
from auto_customers.customer.customers a  (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_deleted =0 
and a.is_subscriber = 0
and a.account_id  = '1AFCA2E5-B2B9-49A0-9894-506AA6F3D6CD'

drop table if exists #temp1
select *
,Rank() over (partition by phone_number,primary_email,make,model,year order by customer_id desc) as rnk
into #temp1
from #temp

select * from #temp1 where rnk <> 1

select * 
--update a set is_deleted =1, updated_by = 'lead_dupli_sk',updated_dt = getdate()
from auto_customers.customer.customers a  (nolock) where is_deleted =0 and account_id  = '1AFCA2E5-B2B9-49A0-9894-506AA6F3D6CD' and customer_id in 
(select customer_id from #temp1 where rnk <> 1)


----------STG2

drop table if exists #temp_new
select 
	 a.customer_id
	,a.primary_phone_number
	,a.primary_phone_number_valid
	,a.secondary_phone_number
	,a.secondary_phone_number_valid
	,case when len(a.primary_phone_number) >= 10 then a.primary_phone_number
		  when len(a.primary_phone_number) < 10 and  len(a.secondary_phone_number) >= 10 then a.secondary_phone_number else '' end as phone_number
	,a.primary_email
	,b.vehicle_id
	,b.vin
	,b.make
	,b.model
	,b.year
	,a.is_deleted

	into #temp_new
from auto_customers.customer.customers a  (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_deleted =0 
and a.is_subscriber = 0
and a.account_id  = '1AFCA2E5-B2B9-49A0-9894-506AA6F3D6CD'


select * from (
select 
	customer_id
	,phone_number
	,primary_email
	,vehicle_id
	,make
	,model
	,year 
	,rank() over (partition by phone_number,primary_email order by customer_id) as rnk
from #temp_new 
) as a where rnk > 1
order by phone_number,primary_email


select 
	customer_id
	,phone_number
	,primary_email
	,vehicle_id
	,make
	,model
	,year 
	,rank() over (partition by phone_number,primary_email order by customer_id) as rnk
from #temp_new where primary_email LIKE 'rodriguez10_3@icloud.com'


use auto_customers

select *
--update b set customer_id = 3623577, updated_by = 'sk_leadClean',updated_dt = getdate()
from auto_customers.customer.vehicles b (nolock)
where b.is_deleted =0
and vehicle_id  in (1534668,1534669)

select *
--update a set is_deleted = 1 ,updated_by = 'lead_dupli_sk',updated_dt = getdate()
from auto_customers.customer.customers a  (nolock)
where 
a.is_deleted =0 
and a.is_subscriber = 0
and a.account_id  = '1AFCA2E5-B2B9-49A0-9894-506AA6F3D6CD'
and customer_id in ( 3623575,3623576)


----



use auto_customers
--rollback customer-vehicles relation as per old r2r portal
select a.customer_id,d.customer_id
--update a set a.customer_id = d.customer_id
from customer.vehicles a (nolock) 
inner join [18.216.140.206].[r2r_admin].cycle.cycle b with (nolock) on a.r2r_vehicle_id = b.cycle_id
inner join [18.216.140.206].[r2r_admin].owner.owner c with (nolock) on b.owner_id = c.owner_id
inner join customer.customers d (nolock) on c.owner_id = d.r2r_customer_id
where a.account_id  = 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A' --and a.is_deleted =0
and b.dealer_id = 48829 and b.is_deleted =0 --and d.is_deleted =0
and a.customer_id <> d.customer_id

select first_name,last_name,primary_phone_number,secondary_phone_number,primary_email from customer.customers d (nolock) where 
account_id  = '96DBF74D-C8BD-459B-B751-B93F961EF884' and customer_id in (2318833,2307057)


--Check if any customer is undeleted from old portal
select 
a.is_deleted,b.is_deleted
from customer.customers a (nolock)
inner join [18.216.140.206].[r2r_admin].owner.owner b with (nolock) on a.r2r_customer_id = b.owner_id
where a.account_id  = 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A' and b.dealer_id = 48829 
and a.is_deleted =0
and a.is_deleted <> b.is_deleted
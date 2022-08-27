select * 
from auto_customers.customer.customers (nolock) where is_deleted =0 and account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'

select * from auto_customers.portal.account with (nolock) where accountname like '%big%'

select 
customer_id
,first_name
,last_name
,full_name
,address_line
,city
,zip
,primary_phone_number
,secondary_phone_number
,case when primary_phone_number_valid = 1 then primary_phone_number when primary_phone_number_valid=0 and secondary_phone_number_valid =1 then secondary_phone_number else primary_phone_number end as phone
,primary_email
,primary_email_valid

from auto_customers.customer.customers (nolock) where is_deleted =0 and account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'


select count(*) --29629/225765
from auto_customers.customer.customers (nolock) 
where is_deleted =0 and account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
and primary_phone_number_valid=0 and secondary_phone_number_valid =0 and primary_email_valid =0 


drop table if exists #temp_cust_veh
select 
		a.customer_id,vehicle_id
		,primary_phone_number
		,secondary_phone_number
		,case when primary_phone_number_valid = 1 then primary_phone_number when primary_phone_number_valid=0 and secondary_phone_number_valid =1 then secondary_phone_number else primary_phone_number end as phone
		,primary_email
		,vin
		,make,model,year
		,last_service_date
		,ro_date
		,purchase_date
into #temp_cust_veh
from auto_customers.customer.customers a(nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_deleted =0 
and a.account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
and (a.primary_phone_number_valid =1 or secondary_phone_number_valid =1 or primary_email_valid =1)

drop table if exists #temp_cust1
select 
	customer_id
	,phone
	,primary_email
	,string_agg(convert(varchar(max),vehicle_id),'; ') as vehicles
	,max(last_service_date) as last_service_date
	,max(purchase_date) as purchase_date
	into #temp_cust1
from #temp_cust_veh
group by
	customer_id
	,phone
	,primary_email


drop table if exists #temp2
select *,row_number() over (partition by phone,primary_email order by vehicles desc) as rnk 
into #temp2
from #temp_cust1 

select * from #temp2 where rnk >1 and vehicles is null--14639/15702

select *--14639
--update a set is_deleted =1, updated_by = 'sk_dupli',updated_dt = getdate()
from auto_customers.customer.customers a (nolock) where customer_id in 
(
	select distinct customer_id from #temp2 where rnk >1 and vehicles is null
)


select  clictell_auto_etl.dbo.isphonenovalid('4567891230')

select customer_id
,primary_phone_number
,primary_phone_number_valid


from auto_customers.customer.customers (nolock) 
where account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
and primary_phone_number = '0000000000'
and primary_phone_number_valid <> clictell_auto_etl.dbo.isphonenovalid(primary_phone_number)


select customer_id
,secondary_phone_number
,secondary_phone_number_valid
,clictell_auto_etl.dbo.isphonenovalid(secondary_phone_number)
update a set secondary_phone_number_valid = clictell_auto_etl.dbo.isphonenovalid(secondary_phone_number)

from auto_customers.customer.customers a (nolock) 
where account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
and secondary_phone_number = '0000000000'
and secondary_phone_number_valid <> clictell_auto_etl.dbo.isphonenovalid(secondary_phone_number)

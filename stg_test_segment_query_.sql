select  do_not_email,count(*) from auto_stg_customers.customer.customers (nolock) 
where is_deleted =0 
and account_id = '63e6b499-4cc0-4591-a489-6f7376e7e4e8' 
group by do_not_email



select * from (
select  customer_id, primary_email,do_not_email,is_email_bounce 
,row_number() over (partition by primary_email order by customer_id) as rnk
from auto_stg_customers.customer.customers (nolock) 
where is_deleted =0 
and account_id = '63e6b499-4cc0-4591-a489-6f7376e7e4e8' 
and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1 or primary_email_valid = 1)
and Isnull(is_unsubscribed, 0) = 0
and Isnull(fleet_flag, 0) = 0
and do_not_email is null 
--and do_not_email like '%'+null+'%'
and len(isnull(primary_email,'')) > 0
and is_email_bounce <> 1
and clictell_stg_auto_etl.dbo.isValidEmail(primary_email) = 1
) as a-- where rnk =1
order by primary_email 



--insert into auto_stg_customers.customer.customers (
--account_id
--,first_name
--,last_name
--,primary_email
--,primary_email_valid
--,primary_phone_number
--,primary_phone_number_valid
--,do_not_email
--,do_not_sms
--,do_not_phone
--,do_not_whatsapp
--,phone_numbers
--,websites
--,social_profiles
--,addresses
----,created_by
----,created_dt
----,updated_by
----,updated_dt
--)

--select

-- '63e6b499-4cc0-4591-a489-6f7376e7e4e8' as account_id
--,'K.Srikanth' as first_name
--,'k' as last_name
--,'kh.srikanth@gmail.com' as primary_email
--,1 as primary_email_valid
--,'9491419809' as primary_phone_number
--,1 as primary_phone_number_valid
--,null as do_not_email
--,null as do_not_sms
--,0 as do_not_phone
--,0 as do_not_whatsapp
--,'' as phone_numbers
--,'' as websites
--,'' as social_profiles
--,'' as addresses
--,created_by
--,created_dt
--,updated_by
--,updated_dt



use auto_stg_customers
	select count(*)
from customer.customers (nolock) a 
left outer join customer.vehicles (nolock) b 
on a.customer_id = b.customer_id
where a.is_deleted =0 and b.is_deleted =0 
and b.account_id = '63e6b499-4cc0-4591-a489-6f7376e7e4e8' 
and (primary_phone_number_valid = 1 or secondary_phone_number_valid = 1 or primary_email_valid = 1) 
and a.account_id = '63e6b499-4cc0-4591-a489-6f7376e7e4e8' 
and isnull(a.is_unsubscribed,0) = 0 
and isnull(a.fleet_flag,0)=0
and  ((primary_email_valid = 1 and isnull(do_not_email,1) = 0 and isnull(is_email_bounce,0) = 0) or len(isnull(address_line,'')) > 0 or 
((primary_phone_number_valid = 1 or secondary_phone_number_valid = 1)and isnull(do_not_sms,1) = 0))


	select addresses,(select top 1 Json_value(Replace(Replace([value],'[',''), ']',''), '$.city') from OpenJson(replace(replace(addresses,'"',''),'',''), '$.addresses'))
	--(select json_value(Replace(Replace([value],'[',''), ']',''),'$.city') from OpenJson(addresses, '$.addresses'))
	,*
from customer.customers (nolock) a 
where a.is_deleted =0 
and (primary_phone_number_valid = 1 or secondary_phone_number_valid = 1 or primary_email_valid = 1) 
and a.account_id = '63e6b499-4cc0-4591-a489-6f7376e7e4e8' 
and isnull(a.is_unsubscribed,0) = 0 
and isnull(a.fleet_flag,0)=0
and  ((primary_email_valid = 1 and isnull(do_not_email,1) = 0 and isnull(is_email_bounce,0) = 0) or len(isnull(address_line,'')) > 0 or 
((primary_phone_number_valid = 1 or secondary_phone_number_valid = 1)and isnull(do_not_sms,1) = 0))
and city = 'newyork'


select  city, count(*) as cc
from customer.customers (nolock) a 
where a.is_deleted =0 
and (primary_phone_number_valid = 1 or secondary_phone_number_valid = 1 or primary_email_valid = 1) 
and a.account_id = '63e6b499-4cc0-4591-a489-6f7376e7e4e8' 
group by city
order by count(*) desc

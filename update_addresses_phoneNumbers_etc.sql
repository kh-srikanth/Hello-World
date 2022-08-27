use auto_customers

select 
customer_id
,src_cust_id
,addresses
,'{"addresses":['+concat_ws(
	','
	,(select '' as addressType, isnull(a.address_line,'')+isnull(a.address_line2,'') as street,a.city as city, a.State as state,a.Country as country,a.Zip as zip for JSON PATH, without_array_wrapper)
	,']}')

,phone_numbers
,'{"phoneNumbers":['+concat_ws(
	','	
	,(select 'Mobile' as phoneType, '' as countryCode, a.primary_phone_number as phoneNumber, '0' as isPrimary for JSON PATH, without_array_wrapper)
	,(select 'HomePhone' as phoneType, '' as countryCode, a.secondary_phone_number as phoneNumber, '0' as isPrimary for JSON PATH, without_array_wrapper)
	) +']}'
,primary_email
,primary_email_valid
,IIF((a.primary_email) Like '%_@__%.__%',1,0) as primary_email_valid
,primary_phone_number
,primary_phone_number_valid
,IIF(len(a.primary_phone_number) = 10, '1','0') as phone_valid


from customer.customers a(nolock)
where account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and is_deleted =0
--and customer_id =1972743

select top 3 * from  customer.customers a(nolock) where customer_id =1972743



select 
--update a set
	addresses ,'{"addresses":['+concat_ws(
		','
		,(select '' as addressType, isnull(a.address_line,'')+isnull(a.address_line2,'') as street,a.city as city, a.State as state,a.Country as country,a.Zip as zip for JSON PATH, without_array_wrapper)
		,']}')

	,phone_numbers ,'{"phoneNumbers":['+concat_ws(
		','	
		,(select 'Mobile' as phoneType, '' as countryCode, a.primary_phone_number as phoneNumber, '0' as isPrimary for JSON PATH, without_array_wrapper)
		,(select 'HomePhone' as phoneType, '' as countryCode, a.secondary_phone_number as phoneNumber, '0' as isPrimary for JSON PATH, without_array_wrapper)
		) +']}'
	,primary_email
	,a.primary_email_valid , IIF((a.primary_email) Like '%_@__%.__%',1,0) 
	,primary_phone_number
	,primary_phone_number_valid , IIF(len(a.primary_phone_number) = 10, '1','0') 
	,updated_by  

from customer.customers a(nolock)
where account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and is_deleted =0
--and primary_phone_number_valid is null


select count(*) 
from customer.customers a(nolock)
where account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and is_deleted =0
and (addresses is null or phone_numbers is null or primary_email_valid is null or primary_phone_number_valid is null)


use auto_customers
select do_not_email,count(*) 
from customer.customers a(nolock)
inner join  customer.vehicles b(nolock) on a.customer_id = b.customer_id
where 
a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and a.is_deleted =0 and b.is_deleted =0
and is_email_bounce =0
group by do_not_email

---SMS_Subscribers
use auto_customers
select do_not_sms,count(*) 
from customer.customers a(nolock)
inner join  customer.vehicles b(nolock) on a.customer_id = b.customer_id
where 
a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and a.is_deleted =0 and b.is_deleted =0
group by do_not_sms


---APP USers
use auto_customers
select  a.*
from customer.customers a(nolock)
inner join  customer.vehicles b(nolock) on a.customer_id = b.customer_id
where 
a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and a.is_deleted =0 and b.is_deleted =0 and is_app_user =1 and primary_email in ('brantmmorris@gmail.com','VERGEERS@COMCAST.COM')
--group by is_app_user



select * from customer.customers a(nolock) where  is_deleted =0 and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and primary_email in ('brantmmorris@gmail.com','VERGEERS@COMCAST.COM')
--update customer.customers set is_app_user =1 where is_deleted =0 and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and primary_email in ('brantmmorris@gmail.com','VERGEERS@COMCAST.COM')
)
and primary_email in 
('djboeve@gmail.com'
,'lferrera7@gmail.com'
,'llarrybishop@aol.com'
,'davehoit@yahoo.com'
,'dfowens@comcast.net'
,'why4usay@msn.com'
,'bwisner51@gmail.com'
,'nancyandrist@msn.com'
,'vergeers@comcast.com'
,'davehoit@yahoo.com'
,'bosmarine90@gmail.com'
,'davehoit@yahoo.com'
,'bailey.evo@gmail.com'
,'brantmmorris@gmail.com'
,'sidk33@gmail.com'
,'eddiel247@gmail.com'
,'buckharleyozzy@yahoo.com')

select primary_email,do_not_email
from customer.customers a(nolock)
inner join  customer.vehicles b(nolock) on a.customer_id = b.customer_id
where 
a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and a.is_deleted =0 and b.is_deleted =0
and do_not_email =1


select 
	customer_id
	,primary_phone_number
	,primary_phone_number_valid
	,secondary_phone_number
	,substring(secondary_phone_number,1,PATINDEX('%[A-Z]%',upper(secondary_phone_number))-1)
from  auto_customers.customer.customers a(nolock) 
where a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and a.is_deleted =0 
and customer_id in (1868849,1878287,1947283)



select 
primary_email
,case when primary_email = '' then 0
	when primary_email like ' ' then 0
	when primary_email like ('%["(),:;<>\]%') then 0
	when substring(primary_email,charindex('@',primary_email),len(primary_email)) like ('%[!#$%&*+/=?^`_{|]%') then 0
	when (left(primary_email,1) like ('[-_.+]') or right(primary_email,1) like ('[-_.+]')) then 0 
	when (primary_email like '%[%' or primary_email like '%]%') then 0
	when primary_email LIKE '%@%@%' then 0
	when primary_email NOT LIKE '_%@_%._%' then 0
	else 1 end
from auto_customers.customer.customers a(nolock) 
where a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and a.is_deleted =0 



1867851

select secondary_phone_number--, secondary_phone_number_valid 
--update a set secondary_phone_number_valid =1
from auto_customers.customer.customers a(nolock) where 
a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and a.is_deleted =0 
and len(secondary_phone_number) <> 10 --and secondary_phone_number_valid = 0


select primary_email, primary_email_valid, clictell_auto_etl.dbo.isvalidemail(primary_email)
--update a set secondary_phone_number_valid =1
--update a set primary_email_valid = 0
from auto_customers.customer.customers a(nolock) where 
a.account_id = 'd51e5da3-9099-42c6-b311-de6bbc9d825c' and a.is_deleted =0 
and (case when primary_email = '' then 0
	when primary_email like ' ' then 0
	when primary_email like ('%["(),:;<>\]%') then 0
	when substring(primary_email,charindex('@',primary_email),len(primary_email)) like ('%[!#$%&*+/=?^`_{|]%') then 0
	when (left(primary_email,1) like ('[-_.+]') or right(primary_email,1) like ('[-_.+]')) then 0 
	when (primary_email like '%[%' or primary_email like '%]%') then 0
	when primary_email LIKE '%@%@%' then 0
	when primary_email NOT LIKE '_%@_%._%' then 0
	else 1 end) =0 and primary_email_valid =1

and primary_email like '_%@_%.__%' and primary_email_valid = 0



select a.customer_id, full_name,vin, purchase_date,last_service_date
from auto_customers.customer.customers a(nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and a.is_deleted =0  and b.is_deleted =0
and a.customer_id in (3449822, 1972237) and vin in ('YAMA0865H617','YAMA1683A717')
order by vin

drop table if exists #temp
select a.customer_id,primary_email,primary_phone_number,secondary_phone_number, full_name,vin,vehicle_id, purchase_date,last_service_date into #temp
from auto_customers.customer.customers a(nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and a.is_deleted =0  and b.is_deleted =0
--and a.customer_id in (3449822, 1972237) and vin in ('YAMA0865H617','YAMA1683A717')
order by vin

select 
a.customer_id
,a.full_name
,a.vin
,a.last_service_date
,a.purchase_date
from 
#temp a 
inner join #temp b on a.vin =b.vin 
where 
a.customer_id <> b.customer_id
and len(a.vin) <> 0
order by a.vin, a.last_service_date desc

select * from auto_customers.customer.customers a(nolock) where customer_id =
3462288
beaujasons@gmail.com 'd51e5da3-9099-42c6-b311-de6bbc9d825c'



select 
--update a set 
primary_phone_number
,primary_phone_number_valid 
--secondary_phone_number
--primary_phone_number_valid = iif(len(secondary_phone_number) =10,1,0)
from auto_customers.customer.customers a(nolock)
where 
account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and is_deleted =0
--and len(secondary_phone_number) = 10  and secondary_phone_number_valid =0

and len(secondary_phone_number) <> 10
and secondary_phone_number_valid = 1




select 
first_name,last_name,primary_email,primary_phone_number,primary_phone_number_valid,secondary_phone_number,secondary_phone_number_valid,do_not_sms
,do_not_email 
from auto_customers.customer.customers a(nolock)
where 
account_id = 'd51e5da3-9099-42c6-b311-de6bbc9d825c' 
and is_deleted =0
and last_name like '%PAINTER%'


select 
first_name,last_name,primary_email,primary_phone_number,primary_phone_number_valid,secondary_phone_number,secondary_phone_number_valid,do_not_sms
--update a set do_not_sms = null
from auto_customers.customer.customers a(nolock)
where 
is_deleted =0
and account_id = 'd51e5da3-9099-42c6-b311-de6bbc9d825c' 
--and primary_phone_number_valid =0 and secondary_phone_number_valid =0 
--and do_not_sms =0
--and secondary_phone_number_valid is null
--and len(secondary_phone_number) = 10
and last_name like '%LYKINS%'
select * from clictell_auto_master.master.dealer (nolock) where _id  = 'd51e5da3-9099-42c6-b311-de6bbc9d825c'
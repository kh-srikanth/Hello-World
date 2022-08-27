
/*
----update don_not_sms based on Primary_phone_number
update  a set --5035
a.do_not_sms = case when b.is_lime_opted_in =1 then 0 when b.is_lime_opted_in = 0 then 1 end 
,a.updated_by = 'lime_opt_out'
from auto_customers.customer.customers a (nolock) 
inner join [18.216.140.206].r2r_admin.owner.owner b with  (nolock) 
		on a.primary_phone_number = replace(replace(replace(replace(b.mobile,'-',''),' ',''),'(',''),')','') 			
		and a.r2r_customer_id = b.owner_id
where 
a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and a.is_deleted =0
and b.is_deleted =0 and b.dealer_id = 2998 and (len(b.mobile) <> 0 or len(b.phone) <> 0)
--and len(b.mobile) <> 0
and a.do_not_sms <> case when b.is_lime_opted_in =1 then 0 when b.is_lime_opted_in=0 then 1 end 


----update don_not_sms based on secondary_phone_number
update a set
a.do_not_sms = case when b.is_lime_opted_in =1 then 0 when b.is_lime_opted_in = 0 then 1 end 
,a.updated_by = 'lime_opt_out2'
from auto_customers.customer.customers a (nolock) 
inner join [18.216.140.206].r2r_admin.owner.owner b with  (nolock) 
		on a.secondary_phone_number = replace(replace(replace(replace(b.phone,'-',''),' ',''),'(',''),')','') 			
		and a.r2r_customer_id = b.owner_id
where 
a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and a.is_deleted =0
and b.is_deleted =0 and b.dealer_id = 2998 and (len(b.mobile) <> 0 or len(b.phone) <> 0)
--and len(b.mobile) <> 0
and a.do_not_sms <> case when b.is_lime_opted_in =1 then 0 when b.is_lime_opted_in=0 then 1 end 

---Update do_not_email

update a set 
a.do_not_email = b.is_email_suppressed
,a.updated_by = 'email_supres'
from auto_customers.customer.customers a (nolock) 
inner join [18.216.140.206].r2r_admin.owner.owner b with  (nolock) on a.primary_email = b.email and a.r2r_customer_id = b.owner_id
where 
a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and a.is_deleted =0
and b.is_deleted =0 and b.dealer_id = 2998 and len(b.email) <> 0
and a.do_not_email <> b.is_email_suppressed
*/

select count(*) 
from auto_customers.customer.customers a(nolock)
inner join  auto_customers.customer.vehicles b(nolock) on a.customer_id = b.customer_id

where 
a.account_id ='d51e5da3-9099-42c6-b311-de6bbc9d825c' and a.is_deleted =0 and b.is_deleted =0
and last_service_date between '12-31-2021' and '01-07-2022'


select count(distinct customer_id) from
(
select 
a.customer_id,a.r2r_customer_id,b.owner_id,a.do_not_sms ,b.is_lime_opted_in, (case when b.is_lime_opted_in =1 then 0 when b.is_lime_opted_in = 0 then 1 else null end ) as lime_optout
,c.vehicle_id, c.vin, c.is_valid_vin
from auto_customers.customer.customers a (nolock) 
inner join [18.216.140.206].r2r_admin.owner.owner b with  (nolock) 
		on a.r2r_customer_id = b.owner_id
--inner join [18.216.140.206].r2r_admin.cycle.cycle d with  (nolock) on b.owner_id = d.owner_id and d.dealer_id = b.dealer_id
left outer join auto_customers.customer.vehicles c (nolock) on a.customer_id = c.customer_id and c.is_deleted =0
where 
a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and a.is_deleted =0
and b.dealer_id = 2998 
and b.is_deleted =0 
--and b.is_lime_opted_in = 1
--and c.vehicle_id is not null
and a.primary_phone_number = '3602419099'

) as a

select count(distinct r2r_customer_id)
from auto_customers.customer.customers a (nolock) 
--inner join auto_customers.customer.vehicles c (nolock) on a.customer_id = c.customer_id
where 
a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and a.is_deleted =0
--and c.is_deleted =0
and a.do_not_sms =0
and a.r2r_customer_id is not null

--do_not_sms=0 count:2,111 / 93(r2r)
--do_not_sms=1 count:15,191 / 14,530(r2r)
--distinct r2r_customer_id in customer : 7098
drop table if exists #r2r_phone_data1
select distinct dist_phone_number into #r2r_phone_data1 
from
(
select *,case when len(phone_number) >10 then substring(phone_number,2,10) else phone_number end as dist_phone_number 
from (
select Replace(Replace(Replace(Replace(Replace(Replace(Replace(ltrim(rtrim(mobile)),'-',''),' ',''),')',''),'(',''),'.',''),'*',''),'#','') as phone_number, mobile
from [18.216.140.206].r2r_admin.owner.owner b with  (nolock) 
where b.dealer_id =2998
and is_lime_opted_in =0
--and mobile like '%2532231638%'
union 
select Replace(Replace(Replace(Replace(Replace(Replace(Replace(ltrim(rtrim(phone)),'-',''),' ',''),')',''),'(',''),'.',''),'*',''),'#','') ,phone
from [18.216.140.206].r2r_admin.owner.owner b with  (nolock) 
where b.dealer_id =2998
and is_lime_opted_in =0
--and phone like '%2532231638%'

) as a
where len(isnull(phone_number,'')) > 0 
) as b 


drop table if exists #r2r_phone_data2
select distinct dist_phone_number into #r2r_phone_data2 
from
(
select *,case when len(phone_number) >10 then substring(phone_number,2,10) else phone_number end as dist_phone_number 
from (
select Replace(Replace(Replace(Replace(Replace(Replace(Replace(ltrim(rtrim(mobile)),'-',''),' ',''),')',''),'(',''),'.',''),'*',''),'#','') as phone_number, mobile
from [18.216.140.206].r2r_admin.owner.owner b with  (nolock) 
where b.dealer_id =2998
and is_lime_opted_in =1
--and mobile like '%2532231638%'
union 
select Replace(Replace(Replace(Replace(Replace(Replace(Replace(ltrim(rtrim(phone)),'-',''),' ',''),')',''),'(',''),'.',''),'*',''),'#','') ,phone
from [18.216.140.206].r2r_admin.owner.owner b with  (nolock) 
where b.dealer_id =2998
and is_lime_opted_in =1
--and phone like '%2532231638%'

) as a
where len(isnull(phone_number,'')) > 0 
) as b 


select * from #r2r_phone_data1 where dist_phone_number = '4128741218' --0
select * from #r2r_phone_data2 where dist_phone_number = '4128741218'  --1


select email into #r2r_email1 from [18.216.140.206].r2r_admin.owner.owner b with  (nolock)
where b.dealer_id =2998
and is_email_suppressed =1
and is_deleted =0


select email into #r2r_email2 from [18.216.140.206].r2r_admin.owner.owner b with  (nolock)
where b.dealer_id =2998
and is_email_bounced =1
and is_deleted =0
and mobile = '3602419099'

select email into #r2r_email3 from [18.216.140.206].r2r_admin.owner.owner b with  (nolock)
where b.dealer_id =2998
and is_email_bounced =0
and is_deleted =0



select * from #r2r_phone_data1 where dist_phone_number = '2532231638'

select customer_id, do_not_sms , primary_phone_number
--update a set do_not_sms =1
from auto_customers.customer.customers a (nolock) where primary_phone_number in (select * from #r2r_phone_data1 ) 
and a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and a.is_deleted =0
and do_not_sms =0


select customer_id,secondary_phone_number, do_not_sms 
--update a set do_not_sms =0
from auto_customers.customer.customers a (nolock) where secondary_phone_number in (select * from #r2r_phone_data) 
and a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and a.is_deleted =0
and do_not_sms is null
order by secondary_phone_number

--and (b.phone like '%3605503140%' or b.mobile like '%3605503140%')
select * from auto_customers.customer.customers a (nolock) where customer_id in (1877601,1946635)
select * from auto_customers.customer.vehicles a (nolock) where customer_id in (1877601,1946635)

select customer_id,primary_email, is_email_bounce
--update a set is_email_bounce =0
from auto_customers.customer.customers a (nolock) where primary_email in (select * from #r2r_email3) 
and a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and a.is_deleted =0
and is_email_bounce =1
and len(primary_email) >0
order by primary_email


select *  from [18.216.140.206].r2r_admin.owner.owner b with  (nolock)
where b.dealer_id =2998
and is_deleted =0
and (phone like '%1218' or mobile like '%1218')
--2532231638	253-223-1638	2532231638

select * from auto_customers.customer.customers a (nolock) where (primary_phone_number = '3605365945' or secondary_phone_number = '3605365945')
and a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and a.is_deleted =0


select * from auto_customers.customer.customers a (nolock) where (primary_phone_number = '3604262439' or secondary_phone_number = '3604262439')
and a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and a.is_deleted =0


select last_service_date,purchase_date,a.customer_id,primary_phone_number,primary_phone_number_valid,secondary_phone_number, secondary_phone_number_valid,vin, is_valid_vin, fleet_flag,primary_email,do_not_email,do_not_sms,src_cust_id,r2r_customer_id
--update a set do_not_email = null 
from auto_customers.customer.customers a (nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
and a.is_deleted =0
and b.is_deleted =0
and src_cust_id is not null
and r2r_customer_id is null
and do_not_email is not null



select * from clictell_auto_etl.etl.cdkLgt_customer (nolock) where CustomerId = '242949'

--and do_not_sms=0
--and a.customer_id in (3450152,1942121)
--and vin in ('YAMA3097J415')
--and (primary_phone_number ='2532824867'
-- or secondary_phone_number = '2532824867')


select * from auto_customers.customer.vehicles b (nolock) where 
b.is_deleted =0 and b.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and customer_id in (3450152,1942121)

select 
	last_service_date,purchase_date,a.customer_id,primary_phone_number,secondary_phone_number,vin,src_cust_id
from auto_customers.customer.customers a (nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and a.is_deleted =0
and b.is_deleted =0
and do_not_sms =0 
and r2r_customer_id is null


select 
a.customer_id
,a.do_not_sms
--,c.is_lime_opted_in
,a.do_not_email
,b.vin
,b.is_valid_vin
,a.primary_phone_number
,a.primary_phone_number_valid
,a.secondary_phone_number
,a.secondary_phone_number_valid


from auto_customers.customer.customers a (nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
--left outer join [18.216.140.206].r2r_admin.owner.owner c with  (nolock) on a.r2r_customer_id = c.owner_id
where 
a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and a.is_deleted =0
--and c.dealer_id = 2998
and b.is_deleted =0
and (a.primary_phone_number = '2063751416' or secondary_phone_number = '2063751416')



select top 10 *

from [18.216.140.206].r2r_admin.owner.owner c with  (nolock) 
where c.dealer_id = 2998 and c.is_deleted =0
and (mobile = '2063751416' or phone = '2063751416')


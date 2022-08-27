select * from auto_customers.customer.customers (nolock) 
select  2888 - 2485
2485  --> 2190  = 295


--94183  count i
drop table if exists #temp
select *,row_number() over (partition by phone order by customer_id desc) as rnk 
into #temp
from (
select  
customer_id, primary_phone_number,primary_phone_number_valid,secondary_phone_number,secondary_phone_number_valid,do_not_sms,src_cust_id
,case when primary_phone_number_valid = 1 then primary_phone_number 
		when primary_phone_number_valid = 0 and secondary_phone_number_valid =1 then secondary_phone_number 
		else primary_phone_number end as phone
from auto_customers.customer.customers (nolock) 
where is_deleted =0 
and account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244' 
and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1 or primary_email_valid = 1)
and Isnull(is_unsubscribed, 0) = 0
and Isnull(fleet_flag, 0) = 0
and do_not_sms is null 
and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1)
) as a-- where rnk =1


select * from #temp order by phone

select * from #temp  where rnk <> 1


select is_Deleted ,1,* 
--update a set a.is_Deleted =1, updated_by = 'sk_neg_dup',updated_dt = getdate()
from auto_customers.customer.customers a (nolock) where account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244'  and customer_id in (
select customer_id from #temp where rnk <> 1)



drop table if exists #temp1
select *  into #temp1
from (
select  
	customer_id, primary_email,do_not_email,is_email_bounce, src_cust_id
	,row_number() over (partition by primary_email order by customer_id) as rnk
from auto_customers.customer.customers (nolock) 
where is_deleted =0 
and account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244' 
and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1 or primary_email_valid = 1)
and Isnull(is_unsubscribed, 0) = 0
and Isnull(fleet_flag, 0) = 0
and do_not_email is null 
and len(isnull(primary_email,'')) > 0
and is_email_bounce <> 1
and clictell_auto_etl.dbo.isValidEmail(primary_email) = 1
) as a
order by primary_email 


select * from #temp1 where rnk <> 1

select is_Deleted ,1,* 
--update a set a.is_Deleted =1, updated_by = 'sk_neg_email_dup',updated_dt = getdate()
from auto_customers.customer.customers a (nolock) where account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244' and customer_id in (
select customer_id from #temp1 where rnk <> 1
)


--------------------------------------Undel duplicate records
-------------------------------Email Duplicates undel


drop table if exists #temp
select customer_id,primary_email,do_not_email,is_email_bounce,is_deleted
into #temp
from auto_customers.customer.customers (nolock)
where is_deleted = 1
and account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244' 
and updated_by = 'sk_neg_email_dup'



--select 
--	a.customer_id
--	,b.customer_id
--	,a.primary_email
--	,b.primary_email
--	,a.do_not_email
--	,b.do_not_email
--	,a.is_email_bounce
--	,b.is_email_bounce

	update b set b.do_not_email = a.do_not_email
from auto_customers.customer.customers a (nolock)
inner join #temp b on a.primary_email = b.primary_email
where a.is_Deleted = 0
and account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244' 
--order by a.primary_email,b.primary_email


select 
a.customer_id,a.do_not_email,b.do_not_email,a.is_deleted,0
--update a set a.do_not_email = b.do_not_email, a.is_deleted = 0
from auto_customers.customer.customers a (nolock)
inner join #temp b on a.customer_id = b.customer_id
where account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244' 
and a.updated_by = 'sk_neg_email_dup'
and a.do_not_email is null
--DONE
------------------------------
--------------------Phone undel

drop table if exists #temp
select customer_id,primary_phone_number,secondary_phone_number,primary_phone_number_valid,secondary_phone_number_valid
,case when primary_phone_number_valid = 1 then primary_phone_number 
		when primary_phone_number_valid = 0 and secondary_phone_number_valid =1 then secondary_phone_number 
		else primary_phone_number end as phone
,do_not_sms,is_deleted
into #temp
from auto_customers.customer.customers (nolock)
where is_deleted = 1
and account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244' 
and updated_by = 'sk_neg_dup'

select * from #temp--5246


select
a.customer_id
,b.customer_id
,case when a.primary_phone_number_valid = 1 then a.primary_phone_number 
	  when a.primary_phone_number_valid = 0 and a.secondary_phone_number_valid =1 then a.secondary_phone_number 
	  else a.primary_phone_number end as a_phone
,a.do_not_sms
,b.do_not_sms

	--update b set b.do_not_sms = a.do_not_sms
from auto_customers.customer.customers a (nolock)
inner join #temp b on (case when a.primary_phone_number_valid = 1 then a.primary_phone_number 
							  when a.primary_phone_number_valid = 0 and a.secondary_phone_number_valid =1 then a.secondary_phone_number 
							  else a.primary_phone_number end) = b.phone
where a.is_Deleted = 0
and account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244' 


select -----updated 269--8/11/2022
a.customer_id,a.do_not_sms,b.do_not_sms,a.is_deleted,case when b.do_not_sms is not null then 0 else a.is_deleted end
--update a set a.do_not_sms = b.do_not_sms, a.is_deleted = case when b.do_not_sms is not null then 0 else a.is_deleted end
from auto_customers.customer.customers a (nolock)
inner join #temp b on a.customer_id = b.customer_id
where account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244' 
and a.updated_by = 'sk_neg_dup'
and b.do_not_sms is not null
--and a.do_not_sms is null
------------------------------------------------------------------------------------------


-------------------CHECK

select do_not_email,primary_email,is_deleted,updated_by,* from auto_customers.customer.customers a (nolock)
where account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244' 
and primary_email = 'beto@kentpowersports.com'
and primary_email in (select primary_email from #temp where do_not_email is null)
and is_deleted =0

select * from #temp



select do_not_email,primary_email,is_deleted,updated_by,* from auto_customers.customer.customers a (nolock)
where account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244' 
and customer_id = 4366923

select * from auto_campaigns.flow.flows (nolock) where account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244' 


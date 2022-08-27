select 
convert(date,created_dt),convert(date,updated_dt),count(*)
from auto_customers.customer.customers (nolock) 
where is_deleted =0
and account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
--and		(
--			(primary_email_valid = 1 and do_not_email = 0 and is_email_bounce = 0) 
--		or len(isnull(address_line,''))>0 
--		or ((primary_phone_number_valid=1 or secondary_phone_number_valid=1)  and do_not_sms = 0)
--		) 
and isnull(fleet_flag,0) = 0
and isnull(is_unsubscribed,0) <> 1
and do_not_sms is null
and (primary_phone_number_valid =1 or secondary_phone_number_valid = 1)
group by 
	convert(date,created_dt),convert(date,updated_dt)


select 
	count(*)
from auto_customers.customer.customers (nolock) 
where is_deleted =0
and account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
--and	(
--			(primary_email_valid = 1 and do_not_email = 0 and is_email_bounce = 0) 
--		or len(isnull(address_line,''))>0 
--		or ((primary_phone_number_valid=1 or secondary_phone_number_valid=1)  and do_not_sms = 0)
--		) 
--and isnull(fleet_flag,0) = 0
--and isnull(is_unsubscribed,0) <> 1
and do_not_sms = 0
and (primary_phone_number_valid =1 or secondary_phone_number_valid = 1)
and list_ids like '%,3318,%'


select * from auto_customers.list.lists (nolock) where account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306' and is_default = 1

use auto_campaigns
------------------SMS Subscriber Check
select 
	 --count(*)
	 b.list_member_id
	 ,b.phone
	into #big_st_sms
from auto_campaigns.sms.campaigns a (nolock)
inner join auto_campaigns.sms.campaign_items b (nolock) on a.campaign_id = b.campaign_id
where
	a.is_deleted =0 
	and account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
	and b.campaign_id = 28373
	and b.is_delivered = 1

		

select * from #big_st_sms



drop table if exists #cust_db_sms
select 
customer_id
,case when primary_phone_number_valid =1 then primary_phone_number 
		when primary_phone_number_valid = 0 and secondary_phone_number_valid = 1 then Secondary_phone_number 
		else primary_phone_number end as phone_db
,do_not_sms
,list_ids
	into #cust_db_sms
from auto_customers.customer.customers a (nolock) 
where is_deleted =0
and account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
and (primary_phone_number_valid =1 or secondary_phone_number_valid = 1)



select --4607
*
from #big_st_sms a
inner join #cust_db_sms b on a.list_member_id = b.customer_id
and b.do_not_sms is null


drop table if exists #sms_result
select --5266
	*,concat(list_ids,'3318,') as new_list_ids
into #sms_result
from #big_st_sms a
inner join #cust_db_sms b on a.phone = b.phone_db
and b.do_not_sms is null

select a.customer_id
,a.do_not_sms , 0
,a.list_ids , new_list_ids

--update a set --5250
--a.do_not_sms = 0
--,a.list_ids = new_list_ids
from auto_customers.customer.customers a (nolock)
inner join #sms_result b on a.customer_id = b.customer_id
where a.is_deleted =0
and a.account_id =  '2AB7B512-7D61-4C6D-8AED-710075AA6306'
--------------------------------END
-----------
select * from auto_customers.list.lists (nolock) where account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306' and is_default = 1

select * from auto_customers.portal.account with (nolock) where accountname like 'team%' and _id = 'C5161306-8F14-44AE-B6B0-8937E9C12E62'
------------



-----------Email Subscribers Count

select * from auto_campaigns.email.campaigns a (nolock) where a.is_deleted =0 and account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
select * from auto_campaigns.email.campaign_items b (nolock) where campaign_id = 24562  --54909

drop table if exists #big_st_email
select 
		 --count(*)
		 b.list_member_id
		 ,b.email_address
	into #big_st_email
from auto_campaigns.email.campaigns a (nolock)
inner join auto_campaigns.email.campaign_items b (nolock) on a.campaign_id = b.campaign_id
where
	a.is_deleted =0 
	and account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
	and b.campaign_id = 24562
	and is_delivered = 1


drop table if exists #cust_db_email
select 
		customer_id
		,primary_email
		,do_not_email
		,list_ids
	into #cust_db_email
from auto_customers.customer.customers a (nolock) 
where is_deleted =0
and account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
and primary_email_valid = 1 and isnull(is_email_bounce,0) = 0





select 
*
from #big_st_email a
inner join #cust_db_email b on a.list_member_id = b.customer_id
and do_not_email is null


drop table if exists #email_result
select 
	*,concat(list_ids,'3317,') as new_list_ids
into #email_result
from #big_st_email a
inner join #cust_db_email b on a.email_address = b.primary_email
and do_not_email is null



select a.customer_id
,a.do_not_email , 0
,a.list_ids , new_list_ids

--update a set --63
--a.do_not_email = 0
--,a.list_ids = new_list_ids
from auto_customers.customer.customers a (nolock)
inner join #email_result b on a.customer_id = b.customer_id
where a.is_deleted =0
and a.account_id =  '2AB7B512-7D61-4C6D-8AED-710075AA6306'
----------------------------END


select top 10  ro_number,last_service_date,ro_date,* from auto_customers.customer.vehicles (nolock)








------------------SMS Subscriber Check  Brothers Power Sports
drop table if exists #big_st_sms
select 
	 --count(*)
	 b.list_member_id
	 ,b.phone
	into #big_st_sms
from auto_campaigns.sms.campaigns a (nolock)
inner join auto_campaigns.sms.campaign_items b (nolock) on a.campaign_id = b.campaign_id
where
	a.is_deleted =0 
	and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
	and b.campaign_id = 27892
	and b.is_delivered = 1


		

select * from #big_st_sms



drop table if exists #cust_db_sms
select 
customer_id
,case when primary_phone_number_valid =1 then primary_phone_number 
		when primary_phone_number_valid = 0 and secondary_phone_number_valid = 1 then Secondary_phone_number 
		else primary_phone_number end as phone_db
,do_not_sms
,list_ids
	into #cust_db_sms
from auto_customers.customer.customers a (nolock) 
where is_deleted =0
and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
and (primary_phone_number_valid =1 or secondary_phone_number_valid = 1)


select * from #cust_db_sms where do_not_sms is null and customer_id = 3449136
select * from #big_st_sms where list_member_id = 3449136


select --4607
*
from #big_st_sms a
inner join #cust_db_sms b on a.list_member_id = b.customer_id
and b.do_not_sms is null








drop table if exists #sms_result
select --5266
	*,concat(list_ids,'3318,') as new_list_ids
into #sms_result
from #big_st_sms a
inner join #cust_db_sms b on a.phone = b.phone_db
and b.do_not_sms is null

select a.customer_id
,a.do_not_sms , 0
,a.list_ids , new_list_ids

--update a set --5250
--a.do_not_sms = 0
--,a.list_ids = new_list_ids
from auto_customers.customer.customers a (nolock)
inner join #sms_result b on a.customer_id = b.customer_id
where a.is_deleted =0
and a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'




------------UNDELIVERED COUNTS

select count(*) 
from auto_campaigns.sms.campaign_items b (nolock) 
inner join auto_customers.customer.customers a (nolock) on a.customer_id = b.list_member_id
where
	b.campaign_id = 27892 and is_delivered = 1
	and a.is_unsubscribed = 1


----getting undelivered Negative optin counts
drop table if exists #sms_undelivered
select 
		 b.list_member_id
		 ,b.phone

	into #sms_undelivered
from auto_campaigns.sms.campaign_items b (nolock) 
where
	b.campaign_id = 27892
	and b.is_delivered = 0

---Getting total valid phone customers
drop table if exists #cust_db_sms
select 
		customer_id
		,case when primary_phone_number_valid =1 then primary_phone_number 
				when primary_phone_number_valid = 0 and secondary_phone_number_valid = 1 then Secondary_phone_number 
				else primary_phone_number end as phone_db
		,do_not_sms
		,list_ids
	into #cust_db_sms
from auto_customers.customer.customers a (nolock) 
where is_deleted =0
and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
and (primary_phone_number_valid =1 or secondary_phone_number_valid = 1)

select --2671
distinct customer_id
from #sms_undelivered a
inner join #cust_db_sms b on a.list_member_id = b.customer_id
and b.do_not_sms = 0

select count(*) from auto_customers.customer.customers a (nolock) where account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and customer_id in (
select --2718
	distinct customer_id	
from #sms_undelivered a
inner join #cust_db_sms b on a.phone = b.phone_db
and b.do_not_sms = 0

)
--------------------------------END


-----------Email Subscribers Count Brothers Power Sports

select * from auto_campaigns.email.campaigns a (nolock) where a.is_deleted =0 and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
select * from auto_campaigns.email.campaign_items b (nolock) where campaign_id = 23675  --54909

drop table if exists #big_st_email
select 
		 --count(*)
		 b.list_member_id
		 ,b.email_address
	into #big_st_email
from auto_campaigns.email.campaigns a (nolock)
inner join auto_campaigns.email.campaign_items b (nolock) on a.campaign_id = b.campaign_id
where
	a.is_deleted =0 
	and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
	and b.campaign_id = 23675
	and is_delivered = 1


drop table if exists #cust_db_email
select 
		customer_id
		,primary_email
		,do_not_email
		,list_ids
	into #cust_db_email
from auto_customers.customer.customers a (nolock) 
where is_deleted =0
and account_id =  'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
and primary_email_valid = 1 and isnull(is_email_bounce,0) = 0





select 
*
from #big_st_email a
inner join #cust_db_email b on a.list_member_id = b.customer_id
and do_not_email is null


drop table if exists #email_result
select 
	*,concat(list_ids,'3317,') as new_list_ids
into #email_result
from #big_st_email a
inner join #cust_db_email b on a.email_address = b.primary_email
and do_not_email is null



select a.customer_id
,a.do_not_email , 0
,a.list_ids , new_list_ids

--update a set --63
--a.do_not_email = 0
--,a.list_ids = new_list_ids
from auto_customers.customer.customers a (nolock)
inner join #email_result b on a.customer_id = b.customer_id
where a.is_deleted =0
and a.account_id =  '2AB7B512-7D61-4C6D-8AED-710075AA6306'
----------------------------END




------------------SMS Subscriber Check  Lonestar
select * from auto_customers.portal.account with (nolock) where accountname like 'lone%'
select * from auto_campaigns.sms.campaigns a (nolock) where a.is_deleted =0 and account_id = '2928EACC-A39D-4743-BF02-F9689F16E79F'
select * from auto_campaigns.sms.campaign_items b (nolock) where campaign_id = 27885  --54909

drop table if exists #big_st_sms
select 
	 --count(*)
	 b.list_member_id
	 ,b.phone
	into #big_st_sms
from auto_campaigns.sms.campaigns a (nolock)
inner join auto_campaigns.sms.campaign_items b (nolock) on a.campaign_id = b.campaign_id
where
	a.is_deleted =0 
	and account_id = '2928EACC-A39D-4743-BF02-F9689F16E79F'
	and b.campaign_id = 27885
	and b.is_delivered = 1

		

select * from #big_st_sms



drop table if exists #cust_db_sms
select 
customer_id
,case when primary_phone_number_valid =1 then primary_phone_number 
		when primary_phone_number_valid = 0 and secondary_phone_number_valid = 1 then Secondary_phone_number 
		else primary_phone_number end as phone_db
,do_not_sms
,list_ids
	into #cust_db_sms
from auto_customers.customer.customers a (nolock) 
where is_deleted =0
and account_id = '2928EACC-A39D-4743-BF02-F9689F16E79F'
and (primary_phone_number_valid =1 or secondary_phone_number_valid = 1)


select * from #cust_db_sms where do_not_sms is null and customer_id = 3449136
select * from #big_st_sms where list_member_id = 3449136


select --4607
*
from #big_st_sms a
inner join #cust_db_sms b on a.list_member_id = b.customer_id
and b.do_not_sms is null


drop table if exists #sms_result
select --5266
	*,concat(list_ids,'3318,') as new_list_ids
into #sms_result
from #big_st_sms a
inner join #cust_db_sms b on a.phone = b.phone_db
and b.do_not_sms is null

select a.customer_id
,a.do_not_sms , 0
,a.list_ids , new_list_ids

--update a set --5250
--a.do_not_sms = 0
--,a.list_ids = new_list_ids
from auto_customers.customer.customers a (nolock)
inner join #sms_result b on a.customer_id = b.customer_id
where a.is_deleted =0
and a.account_id = '2928EACC-A39D-4743-BF02-F9689F16E79F'
--------------------------------END

-----------Email Subscribers Count Lonestar yamaha

select * from auto_campaigns.email.campaigns a (nolock) where a.is_deleted =0 and account_id = '2928EACC-A39D-4743-BF02-F9689F16E79F'
select * from auto_campaigns.email.campaign_items b (nolock) where campaign_id = 23277  --54909

drop table if exists #big_st_email
select 
		 --count(*)
		 b.list_member_id
		 ,b.email_address
	into #big_st_email
from auto_campaigns.email.campaigns a (nolock)
inner join auto_campaigns.email.campaign_items b (nolock) on a.campaign_id = b.campaign_id
where
	a.is_deleted =0 
	and account_id = '2928EACC-A39D-4743-BF02-F9689F16E79F'
	and b.campaign_id = 23277
	and is_delivered = 1


drop table if exists #cust_db_email
select 
		customer_id
		,primary_email
		,do_not_email
		,list_ids
	into #cust_db_email
from auto_customers.customer.customers a (nolock) 
where is_deleted =0
and account_id =  '2928EACC-A39D-4743-BF02-F9689F16E79F'
and primary_email_valid = 1 and isnull(is_email_bounce,0) = 0

select 
*
from #big_st_email a
inner join #cust_db_email b on a.list_member_id = b.customer_id
and do_not_email is null


drop table if exists #email_result
select 
	*,concat(list_ids,'3317,') as new_list_ids
into #email_result
from #big_st_email a
inner join #cust_db_email b on a.email_address = b.primary_email
and do_not_email is null



select a.customer_id
,a.do_not_email , 0
,a.list_ids , new_list_ids

--update a set --63
--a.do_not_email = 0
--,a.list_ids = new_list_ids
from auto_customers.customer.customers a (nolock)
inner join #email_result b on a.customer_id = b.customer_id
where a.is_deleted =0
and a.account_id =  '2928EACC-A39D-4743-BF02-F9689F16E79F'
----------------------------END
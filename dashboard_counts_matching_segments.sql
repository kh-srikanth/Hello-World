	use auto_campaigns	
	declare @account_id uniqueidentifier = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'  	
		
		
	DROP TABLE if exists #EmpDetails


	CREATE TABLE #EmpDetails 
	(
	Account_id uniqueidentifier,
	campaign_count INT, 
	social_media_count INT,
	email_subscribers_count INT,
	sms_subscribers_count INT,
	mobile_app_count INT,
	active_customers int
	) 
        --Declaring Variables----
	declare @campaign_count int=0;
	declare @social_count int=0;
	declare @email_subscribers_count int=0;
	declare @sms_subscribers_count int=0;
	declare @mobile_app_count int=0;
	declare @active_customers_count int=0;


set @campaign_count=(select
(select  count(campaign_id) from auto_campaigns.email.campaigns (nolock) where account_id=@account_id and is_deleted=0 and status_type_id in (select status_type_id from campaign.status_type (nolock) where status_type in ('Delivered')))  +
(select  count(campaign_id) from auto_campaigns.sms.campaigns (nolock) where account_id=@account_id and is_deleted=0 and status_type_id in (select status_type_id from campaign.status_type (nolock) where status_type in ('Delivered')))  +
(select  count(campaign_id) from auto_campaigns.push.campaigns (nolock) where account_id=@account_id and is_deleted=0 and status_type_id in (select status_type_id from campaign.status_type (nolock) where status_type in ('Delivered')))+
(select  count(campaign_id) from social.campaigns (nolock) where account_id=@account_id and is_deleted=0 and status_type_id in (select status_type_id from campaign.status_type (nolock) where status_type in ('Delivered')))
)

drop table if exists #customers
	select 
			customer_id
			,case when primary_phone_number_valid=1 then primary_phone_number 
						 when primary_phone_number_valid =0 and secondary_phone_number_valid =1 then secondary_phone_number 
						 else primary_phone_number end as phone
			,primary_email
			,do_not_email
			,is_email_bounce
			,clictell_auto_etl.dbo.isValidEmail(primary_email) as primary_email_valid
			,iif(primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1,1,0) as phone_valid
			,do_not_sms
			,is_app_user

		into #customers
	from auto_customers.customer.customers a (nolock)
	where a.account_id=@account_id
		and a.is_deleted=0
		and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1 or primary_email_valid = 1)
		and Isnull(is_unsubscribed, 0) = 0
		and Isnull(fleet_flag, 0) = 0


------Email subscribers count
set @email_subscribers_count=
	(
	select count(distinct ltrim(rtrim(primary_email)))
	from #customers a
	where 
			isnull(a.do_not_email,1) = 0  
		and isnull(a.is_email_bounce,0) =0
		and primary_email_valid = 1
	)
--------------------------------------------
------SMS Subscribers count
drop table if exists #temp_phone
set @sms_subscribers_count = (select count(distinct phone) from #customers a where a.do_not_sms = 0 and phone_valid = 1)

--------------------------------------------------

set @mobile_app_count=
(
	select count(distinct a.customer_id)
	from auto_customers.customer.customers a (nolock) 
	where a.account_id=@account_id and a.is_app_user=1 and a.is_deleted=0
	and (primary_phone_number_valid = 1 or secondary_phone_number_valid = 1)
)


-----Active customers count
set @active_customers_count = 
( select count(customer_id) 
	from (
			select 
					customer_id
					,phone			
					,primary_email
					,row_number() over (partition by phone,primary_email order by customer_id desc) as rnk
			from #customers
			where
				((primary_email_valid = 1 and isnull(do_not_email,1) = 0 and isnull(is_email_bounce,0) = 0) 
					or 
				 (phone_valid = 1 and isnull(do_not_sms,1) = 0))
		) as a 
	where rnk = 1
)
-------------------------------------

--select * from #active_cust where  rnk =1 
------------------------------------------------

--set @email_subscribers_count=
--(select count( a.customer_id)
--from auto_customers.customer.customers a (nolock)
--where a.account_id=@account_id 
--		and a.is_deleted=0 
--		and a.do_not_email=0 
--		and isnull(a.is_email_bounce,0) =0 
--		and primary_email_valid = 1)

--set @sms_subscribers_count=
--(select count(distinct a.customer_id)
--from auto_customers.customer.customers a(nolock) 
----inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id 
--where a.account_id=@account_id and  a.do_not_sms=0    and a.is_deleted=0 /*and b.is_deleted =0*/
--and (primary_phone_number_valid = 1 or secondary_phone_number_valid = 1))


--set @active_customers_count=
--(select count(distinct a.customer_id)
--from auto_customers.customer.customers a (nolock) 
--where a.account_id=@account_id and  a.is_deleted=0
--and (Isnull(a.primary_email_valid, 0) = 1 or Isnull(a.primary_phone_number_valid, 0) = 1 or Isnull(a.secondary_phone_number_valid, 0) = 1)  --KS add to match All list counts
--)



		--inserting into temp table---
	insert into #EmpDetails 
	values (
	@account_id,
	@campaign_count,
	@social_count,
	@email_subscribers_count,
	@sms_subscribers_count,
	@mobile_app_count,
	@active_customers_count
	)

select Account_id, campaign_count, social_media_count,email_subscribers_count,sms_subscribers_count,mobile_app_count,active_customers
from #EmpDetails
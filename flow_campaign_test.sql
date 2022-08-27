select  top 100 * from auto_customers.dbo.segment_execution_query (nolock)  where query like '%@flow_id = %'  and convert(date,created_dt) = '08/25/2022'  order by 1 desc

--exec [customer].[query_segment_get] @account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306', @segmant_query = '{"queries":[{"element":"Email Optout","operator":"is","secondOperator":"","value":"","match":"","elementTypeId":"1","order":"1"}]}'
--, @operator = 'or', @Offset = '0', @page_no = '1', @page_size = '20', @sort_column = 'CreatedDate', @sort_order = 'ASC', @list_type_id = '3', @campaign_type = 'Email', @campaign_id = '24562'
--, @campaign_run_id = '323023', @flow_id = '9771', @is_parent_campaign = '1'


select
     a.customer_id,do_not_sms,purchase_date
from auto_customers.customer.customers(nolock) as a
inner join auto_customers.customer.vehicles b (nolock) 
     on a.customer_id = b.customer_id
where a.account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
and a.is_deleted =0 
and b.is_deleted =0
and do_not_sms is null 
and convert(date,purchase_date) >='8/4/2019'
and(primary_phone_number_valid = 1 or secondary_phone_number_valid = 1) 
and isnull(a.is_unsubscribed,0) = 0 
and isnull(fleet_flag,0) = 0 



--select * from auto_customers.portal.account with (nolock) where accountname like 'big%'
--_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244'
--brothers: flow_id:8853,campaign_id:23675, campaign_run_id: 310451;;; sms: campaign_id: 27892,campaign_run_id : 310480
--Kent: flow_id: 10151,campaign_id: 25945, campaign_run_id: 310454
--Brothers
select count(*) from auto_campaigns.email.campaign_items (nolock) where campaign_id = 23675 and convert(date,created_dt) = '08/26/2022'   --31
select count(*) from auto_campaigns.sms.campaign_items (nolock) where campaign_id = 27892 and convert(date,created_dt) = '08/26/2022' --and is_failed =1   --26

-- big St charles
select count(*) from auto_campaigns.email.campaign_items (nolock) where campaign_id = 24562 and convert(date,created_dt) = '08/26/2022'   --274
select count(*) from auto_campaigns.sms.campaign_items (nolock) where campaign_id = 28373 and convert(date,created_dt) = '08/26/2022' --and is_failed =1    --44

select * from auto_campaigns.sms.campaigns (nolock) where campaign_id  = 28373
select * from auto_campaigns.email.campaigns (nolock) where campaign_id  = 24562

select * from portal.account with (nolock) where _id ='42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244'

use auto_customers

--exec [customer].[query_segment_get] @account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
--, @segmant_query = '{"queries":[{"element":"Phone Number","operator":"is not blank","secondOperator":"","value":"","match":"and","elementTypeId":"1","order":"1"},{"element":"Sale Date","operator":"is after","secondOperator":"","value":"08-04-2019","match":"and","elementTypeId":"10","order":"2"},{"element":"SMS Optout","operator":"is","secondOperator":"","value":"","match":"","elementTypeId":"1","order":"3"}]}'
--, @operator = 'or', @Offset = '0', @page_no = '1', @page_size = '20', @sort_column = 'CreatedDate', @sort_order = 'ASC', @list_type_id = '3', @campaign_type = 'SMS'
--, @campaign_id = '28373', @campaign_run_id = '321247', @flow_id = '9771', @is_parent_campaign = '1'


----exec 
--[customer].[query_segment_get] @account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
--, @segmant_query = '{"queries":[{"element":"SMS Optout","operator":"is","secondOperator":"","value":"","match":"","elementTypeId":"1","order":"1"}]}'
--, @operator = 'or', @Offset = '0', @page_no = '1', @page_size = '20', @sort_column = 'CreatedDate', @sort_order = 'ASC', @list_type_id = '3', @campaign_type = 'SMS'
--, @campaign_id = '27892', @campaign_run_id = '320343', @flow_id = '8853', @is_parent_campaign = '1'



select len(middle_name) as len_mid,
select count(*) from auto_customers.customer.customers (nolock) 
where account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306' and do_not_sms  is null 

alter table auto_campaigns.email.campaign_items alter column middle_name varchar(150)
select getdate()
select * from auto_customers.portal.account with (nolock) where accountname like 'big%' and _id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'

select * from auto_campaigns.email.campaigns with (nolock) where is_deleted =0 and account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
select * from auto_campaigns.sms.campaigns with (nolock) where is_deleted =0 and account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'



select a.campaign_id, a.name, count(b.campaign_item_id)
from auto_campaigns.email.campaigns a with (nolock)
inner join auto_campaigns.email.campaign_items b (nolock) on a.campaign_id = b.campaign_id
where 
a.account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
--and campaign_id = 25945 
and convert(date,b.created_dt) = convert(date,getdate())   --23
group by 
	a.campaign_id, a.name




select a.campaign_id, a.name, count(b.campaign_item_id)
from auto_campaigns.sms.campaigns a with (nolock)
inner join auto_campaigns.sms.campaign_items b (nolock) on a.campaign_id = b.campaign_id
where 
a.account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
--and campaign_id = 25945 
and convert(date,b.created_dt) = convert(date,getdate())   --23
group by 
	a.campaign_id, a.name


select * from auto_campaigns.sms.campaign_items (nolock) where campaign_id = 27892 and convert(date,created_dt) = convert(date,getdate()) --and is_failed =1   --23


drop table if exists #dealer
select _id,accountname into #dealer from auto_customers.portal.account with (nolock) where lower(accountstatus) <> 'inactive' and lower(parentid) in ('c994b4f4-666e-446b-9a2f-c4985ebea150')

select 
	d.accountname,a.campaign_id, a.name, count(b.campaign_item_id)
from auto_campaigns.email.campaigns a with (nolock)
inner join auto_campaigns.email.campaign_items b (nolock) on a.campaign_id = b.campaign_id
inner join #dealer d on d._id = a.account_id
where 
 convert(date,b.created_dt) = convert(date,getdate())   --23
group by 
	 d.accountname,a.campaign_id, a.name




select  
	d.accountname,a.campaign_id, a.name, count(b.campaign_item_id)
from auto_campaigns.sms.campaigns a with (nolock)
inner join auto_campaigns.sms.campaign_items b (nolock) on a.campaign_id = b.campaign_id
inner join #dealer d on d._id = a.account_id
where 
 convert(date,b.created_dt) = convert(date,getdate())   --23
group by 
	 d.accountname,a.campaign_id, a.name





select * from auto_campaigns.sms.campaigns with (nolock) where name like 'mega sale' and campaign_id = 29246

select * from auto_campaigns.sms.campaign_items with (nolock) where campaign_id = 29246





select 
b.customer_id
,b.do_not_sms
from auto_campaigns.sms.campaign_items a (nolock) 
inner join auto_customers.customer.customers b(nolock) on a.list_member_id = b.customer_id
where 
a.campaign_id = 27892 
and convert(date,a.created_dt) = '08/23/2022' --and is_failed =1   --23
and b.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'


select 
b.customer_id
,b.do_not_sms
from auto_campaigns.sms.campaign_items a (nolock) 
inner join auto_customers.customer.customers b(nolock) on a.list_member_id = b.customer_id
where 
a.campaign_id = 28373 
and convert(date,a.created_dt) = '08/23/2022' --and is_failed =1   --23
and b.account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'




select 
count(*)
from auto_customers.customer.customers a(nolock) 
inner join auto_customers.customer.vehicles b(nolock) on a.customer_id = b.customer_id
where 
	a.is_deleted =0 
	and Isnull(is_unsubscribed, 0) = 0
	and Isnull(fleet_flag, 0) = 0
	and (primary_phone_number_valid=1 or secondary_phone_number_valid =1)
	and purchase_date > '2015-08-04'
	and do_not_sms is null
	and a.account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'






select 	a.customer_id, a.primary_email, a.primary_email_valid, a.do_not_email, a.is_email_bounce, a.r2r_customer_id, a.src_cust_id, b.campaign_id, a.created_by, a.created_dt, a.updated_by, a.updated_dtfrom auto_customers.customer.customers a (nolock)left outer join auto_campaigns.email.campaign_items b (nolock) on a.customer_id = b.list_member_id and b.campaign_id = 23277where a.account_id= '2928EACC-A39D-4743-BF02-F9689F16E79F' and a.do_not_email=0 and a.is_deleted=0 and isnull(a.is_email_bounce,0) =0  /*and b.is_deleted =0*/and primary_email_valid = 1 and src_cust_id is not nulland b.campaign_item_id is null
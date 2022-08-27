select * from auto_customers.customer.customers (nolock) where is_deleted =0 and  account_id = '489436CB-731A-4647-A26F-24BBD7034D28'

select * from auto_customers.dbo.[hanksters subscribers] a(nolock)  --6431

select  --72
a.Email
,b.primary_email
,a.[First Name]
,b.first_name
,a.[Last Name]
,b.last_name
,a.[Subscriber Source]
,b.is_subscriber
,b.do_not_email


from auto_customers.dbo.[hanksters subscribers] a(nolock)
inner join auto_customers.customer.customers b (nolock)  on b.primary_email = a.Email

where b.is_deleted =0 and  b.account_id = '489436CB-731A-4647-A26F-24BBD7034D28'




	   insert into auto_customers.[customer].[customers] 
		 (
			account_id
			,first_name
			,last_name
			,primary_email
			,primary_email_valid
			,is_subscriber
			,list_ids
			,created_by
			,updated_by
			,created_dt
			,updated_dt
		 )

select  distinct--6362
		'489436CB-731A-4647-A26F-24BBD7034D28' as account_id
		,a.[First Name]
		,a.[Last Name]
		,a.Email
		,clictell_auto_etl.dbo.IsValidEmail(a.Email) as primary_email_valid
		,1 as is_subscriber
		,'-1,' as list_ids
		,SUSER_NAME() as created_by
		,SUSER_NAME() as updated_by
		,getdate() as created_dt
		,getdate() as updated_dt
from auto_customers.dbo.[hanksters subscribers] a(nolock)
left outer join auto_customers.customer.customers b (nolock)  on isnull(b.primary_email,'') = isnull(a.Email,'') and b.is_deleted =0 and  b.account_id = '489436CB-731A-4647-A26F-24BBD7034D28'

where 
b.customer_id is null 



select do_not_email,updated_by,updated_dt,* from auto_customers.customer.customers b (nolock) where is_deleted =0 and account_id = '489436CB-731A-4647-A26F-24BBD7034D28' and list_ids like '%,3306,%'
select count(*) from auto_customers.dbo.[hankster_leads] a(nolock) 

select customer_id, list_ids ,is_subscriber,do_not_email 
--update b set list_ids = concat(list_ids,'3305,')--6223
from auto_customers.dbo.[hankster_leads] a(nolock) 
inner join auto_customers.customer.customers b (nolock) on a.[E-mail] =b.primary_Email
where is_deleted =0 and account_id = '489436CB-731A-4647-A26F-24BBD7034D28'
and do_not_email =0



	   insert into auto_customers.[customer].[customers] ---2444
		 (
			account_id
			,full_name
			,primary_email
			,primary_email_valid
			,is_subscriber
			,list_ids
			,created_by
			,updated_by
			,created_dt
			,updated_dt
		 )




select --count(*)  --2444
		'489436CB-731A-4647-A26F-24BBD7034D28' as account_id
		,[Customer Name]
		,[E-mail]
		,clictell_auto_etl.dbo.IsValidEmail([E-mail]) 
		,0 as is_subscriber
		,'-1,3305,' as list_ids
		,SUSER_NAME() as created_by
		,SUSER_NAME() as updated_by
		,getdate() as created_dt
		,getdate() as updated_dt

from auto_customers.dbo.[hankster_leads] a(nolock) 
left outer join auto_customers.customer.customers b (nolock) on a.[E-mail] =b.primary_Email and b.is_deleted =0 and  b.account_id = '489436CB-731A-4647-A26F-24BBD7034D28'
where 
b.customer_id is null 

select * from auto_customers.dbo.[hankster_leads] a(nolock) 



select do_not_email,count(*) from auto_customers.customer.customers b (nolock) where account_id = '489436CB-731A-4647-A26F-24BBD7034D28' and list_ids like '%,3305,%' group by do_not_email with rollup
select do_not_email,count(*) from auto_customers.customer.customers b (nolock) where account_id = '489436CB-731A-4647-A26F-24BBD7034D28' and list_ids like '%,3306,%' group by do_not_email with rollup

select * from auto_customers.customer.customers b (nolock) where account_id = '489436CB-731A-4647-A26F-24BBD7034D28' and list_ids like '%,3306,%'

group by do_not_email


select * from auto_customers.list.lists (nolock) where is_deleted =0 and  account_id = '489436CB-731A-4647-A26F-24BBD7034D28'

insert into auto_customers.list.lists(
account_id
,list_type_id
,list_name
,program_id
,list_status_id
,list_path
,tag_name
,tag_desc
,accepted_count
,rejected_count
,total_count
,created_by
,updated_by
,created_dt
,updated_dt


)
select 
'489436CB-731A-4647-A26F-24BBD7034D28' as account_id
,3 as list_type_id
,'Subscribers_06_30_22' as list_name
,3 as program_id
,2 as list_status_id
,'' as list_path
,'Subscribers_06_30_22' as tag_name
,'Subscribers_06_30_22' as tag_desc
,0 as accepted_count
,0 as rejected_count
,0 as total_count
,suser_name() as created_by
,suser_name() as updated_by
,getdate() as created_dt
,getdate() as updated_dt





select do_not_email,created_by,created_dt,* from auto_customers.customer.customers b (nolock) where account_id = '489436CB-731A-4647-A26F-24BBD7034D28' and list_ids like '%,3305,%'
and created_by <> suser_name() and do_not_email = 1


select * from auto_campaigns.email.campaigns (nolock) where campaign_id = 24102

select * from auto_campaigns.email.campaign_items(nolock) where campaign_id =24102 and campaign_run_id = 272368

list_member_id in (3837592,
3837594
,3837595
,3837596)
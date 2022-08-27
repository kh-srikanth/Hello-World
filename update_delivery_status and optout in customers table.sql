select * from auto_campaigns.[dbo].[Clictell0719] (nolock)
select 
	phone_number,phone
	,replace(replace(replace(replace(replace(phone,':',''),'/',''),'\',''),'?',''),'','')
	,list_member_id 
from sms.campaign_items a (nolock) where campaign_id = '28105'

select 
	a.phone
	,b.phone
	,a.list_member_id
	,a.campaign_item_id
	,a.is_delivered
	,case when b.[status] = 'DLR' then 1 else 0 end  as is_deliv
--update a set a.is_delivered = 1
from sms.campaign_items a (nolock) 
inner join auto_campaigns.[dbo].[Clictell0719] b (nolock) on a.phone = b.phone
where a.campaign_id = '28105'
and isnumeric(a.phone) =1
and a.is_delivered <> 1
and (case when b.[status] = 'DLR' then 1 else 0 end) =  1

select * from auto_campaigns.[dbo].[Clictell0719] (nolock) where phone like '951440382%'
select * from sms.campaign_items a (nolock) where phone_number like '%7142873915'



select --6108
	a.phone
	,b.phone
	,a.list_member_id
	,a.campaign_item_id
	,c.do_not_sms
	,case when b.[status] = 'OPT_OUT' then 1 else 0 end  as do_not_sms_new
--update c set do_not_sms = 1, updated_by = 'sk_fileoptout',updated_dt = getdate()
from sms.campaign_items a (nolock) 
inner join auto_campaigns.[dbo].[Clictell0719] b (nolock) on a.phone = b.phone
inner join auto_customers.customer.customers c (nolock) on a.list_member_id = c.customer_id
where a.campaign_id = '28105'
and c.is_Deleted =0
and isnull(c.do_not_sms,0) <> 1
and isnumeric(a.phone) =1
and (case when b.[status] = 'OPT_OUT' then 1 else 0 end) = 1



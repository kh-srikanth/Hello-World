select count(*) from auto_campaigns.[dbo].[Clicktell_API_DeliveryReport1] (nolock) where [message state] in ('DLR','ENR') and isnumeric(phone) = 1
select count(*) from sms.campaign_items a (nolock) where campaign_id = '28989' and 

use auto_campaigns
select --3989+6
	a.phone
	,b.phone
	,a.list_member_id
	,a.campaign_item_id
	,a.is_delivered
	,case when b.[message state]  in ('DLR','ENR') then 1 else 0 end  as is_deliv
--update a set a.is_delivered = 1
from sms.campaign_items a (nolock) 
inner join auto_campaigns.[dbo].[Clicktell_API_DeliveryReport1]  b (nolock) on a.phone = b.phone and convert(date,a.created_dt) = convert(date,substring([timestamp],5,11))
where 
--a.campaign_id = '28989' and
isnumeric(a.phone) =1
and a.is_delivered <> 1
and (case when b.[message state] in ('DLR','ENR') then 1 else 0 end) =  1



select count(*) from auto_campaigns.[dbo].[Clicktell_API_DeliveryReport2] (nolock) where [message state] in ('DLR','ENR') and isnumeric(phone) = 1
select *,convert(date,substring([timestamp],5,11)) from auto_campaigns.[dbo].[Clicktell_API_DeliveryReport2] (nolock) where [message state] in ('DLR','ENR') and isnumeric(phone) = 1

use auto_campaigns
select --NULL  --260
	a.phone
	,b.phone
	,a.list_member_id
	,a.campaign_item_id
	,a.is_delivered
	,case when b.[message state]  in ('DLR','ENR') then 1 else 0 end  as is_deliv
	,campaign_id
--update a set a.is_delivered = 1
from sms.campaign_items a (nolock) 
inner join auto_campaigns.[dbo].[Clicktell_API_DeliveryReport2]  b (nolock) on a.phone = b.phone and convert(date,a.created_dt) = convert(date,substring([timestamp],5,11))
where 
--a.campaign_id = '28989' and
isnumeric(a.phone) =1
and a.is_delivered <> 1
and (case when b.[message state] in ('DLR','ENR') then 1 else 0 end) =  1



select count(*) from auto_campaigns.[dbo].[Clicktell_API_DeliveryReport3] (nolock) where [message state] in ('DLR','ENR') and isnumeric(phone) = 1
select * from auto_campaigns.[dbo].[Clicktell_API_DeliveryReport3] (nolock) where [message state] in ('DLR','ENR') and isnumeric(phone) = 1

use auto_campaigns
select --NULL  --284
	a.phone
	,b.phone
	,a.list_member_id
	,a.campaign_item_id
	,a.is_delivered
	,case when b.[message state]  in ('DLR','ENR') then 1 else 0 end  as is_deliv
	,campaign_id
--update a set a.is_delivered = 1
from sms.campaign_items a (nolock) 
inner join auto_campaigns.[dbo].[Clicktell_API_DeliveryReport3]  b (nolock) on a.phone = b.phone and convert(date,a.created_dt) = convert(date,substring([timestamp],5,11))
where 
--a.campaign_id = '28989' and
isnumeric(a.phone) =1
and a.is_delivered <> 1
and (case when b.[message state] in ('DLR','ENR') then 1 else 0 end) =  1




select count(*) from auto_campaigns.[dbo].[Clicktell_API_DeliveryReport4] (nolock) where [message state] in ('DLR','ENR') and isnumeric(phone) = 1
select * from auto_campaigns.[dbo].[Clicktell_API_DeliveryReport4] (nolock) where [message state] in ('DLR','ENR') and isnumeric(phone) = 1

use auto_campaigns
select --NULL  --3
	a.phone
	,b.phone
	,a.list_member_id
	,a.campaign_item_id
	,a.is_delivered
	,case when b.[message state]  in ('DLR','ENR') then 1 else 0 end  as is_deliv
	,campaign_id
--update a set a.is_delivered = 1
from sms.campaign_items a (nolock) 
inner join auto_campaigns.[dbo].[Clicktell_API_DeliveryReport4]  b (nolock) on a.phone = b.phone and convert(date,a.created_dt) = convert(date,substring([timestamp],5,11))
where 
--a.campaign_id = '28989' and
isnumeric(a.phone) =1
and a.is_delivered <> 1
and (case when b.[message state] in ('DLR','ENR') then 1 else 0 end) =  1


------

select --NULL--2
	a.phone
	,a.list_member_id
	,a.campaign_item_id
	,a.is_delivered
	,campaign_id
--update a set a.is_delivered = 1
from sms.campaign_items a (nolock) 
where --a.campaign_id = '28989' 
convert(date,a.created_dt) = '7-12-2022'
and a.phone = '2487229334'
and isnumeric(a.phone) =1
and a.is_delivered <> 1



select count(*) from auto_campaigns.[dbo].[API_messages5] (nolock) where [message state] in ('DLR','ENR') and isnumeric(phone) = 1
select * from auto_campaigns.[dbo].[API_messages5] (nolock) where [message state] in ('DLR','ENR') and isnumeric(phone) = 1

use auto_campaigns
select --NULL  --170
	a.phone
	,b.phone
	,a.list_member_id
	,a.campaign_item_id
	,a.is_delivered
	,case when b.[message state]  in ('DLR','ENR') then 1 else 0 end  as is_deliv
	,campaign_id
--update a set a.is_delivered = 1
from sms.campaign_items a (nolock) 
inner join auto_campaigns.[dbo].[API_messages5]  b (nolock) on a.phone = b.phone and convert(date,a.created_dt) = convert(date,substring([timestamp],5,11))
where 
--a.campaign_id = '28989' and
 isnumeric(a.phone) =1
and a.is_delivered <> 1
and (case when b.[message state] in ('DLR','ENR') then 1 else 0 end) =  1



select --6873
	a.phone
	,b.phone
	,a.list_member_id
	,a.campaign_item_id
	,c.do_not_sms
	,case when b.[message state] in ('OPT_OUT','ERR_HARD_BOUNCE') then 1 else 0 end  as do_not_sms_new
--update c set do_not_sms = 1, updated_by = 'sk_fileoptout',updated_dt = getdate()
from sms.campaign_items a (nolock) 
inner join auto_campaigns.[dbo].[API_messages5] b (nolock) on a.phone = b.phone
inner join auto_customers.customer.customers c (nolock) on a.list_member_id = c.customer_id
where a.campaign_id = '28105'
and c.is_Deleted =0
and isnull(c.do_not_sms,0) <> 1
and isnumeric(a.phone) =1
and (case when b.[message state] in ('OPT_OUT','ERR_HARD_BOUNCE') then 1 else 0 end) = 1



select * from auto_campaigns.[dbo].[API_messages5] b (nolock) 
use auto_campaigns


select -- 27,604
	a.phone
	,b.phone
	,a.list_member_id 
	,a.campaign_item_id
	,c.do_not_sms
	,null as do_not_sms_new
--update c set do_not_sms = null, updated_by = 'sk_smsUnknown',updated_dt = getdate()
from sms.campaign_items a (nolock) 
inner join auto_campaigns.[dbo].[API_messages5] b (nolock) on a.phone = b.phone
inner join auto_customers.customer.customers c (nolock) on a.list_member_id = c.customer_id
where a.campaign_id = '28105'
and c.is_deleted =0
and isnumeric(a.phone) =1
and b.[message state] in ('ERR_SOFT_BOUNCE') 
order by campaign_item_id







--select * from auto_campaigns.sms.campaigns (nolock) where campaign_id = 28105



select count(*) from auto_campaigns.[dbo].[API_report] (nolock) where [message state] in ('DLR','ENR') and isnumeric(phone) = 1
select * from auto_campaigns.[dbo].[API_report] (nolock) where [message state] in ('DLR','ENR') and isnumeric(phone) = 1

use auto_campaigns
select --NULL
	a.phone
	,b.phone
	,a.list_member_id
	,a.campaign_item_id
	,a.is_delivered
	,case when b.[message state]  in ('DLR','ENR') then 1 else 0 end  as is_deliv
	,campaign_id
--update a set a.is_delivered = 1
from sms.campaign_items a (nolock) 
inner join auto_campaigns.[dbo].[API_report]  b (nolock) on a.phone = b.phone and convert(date,a.created_dt) = convert(date,substring([timestamp],5,11))
where --a.campaign_id = '28989' and
isnumeric(a.phone) =1
and a.is_delivered <> 1
and (case when b.[message state] in ('DLR','ENR') then 1 else 0 end) =  1



select * from [dbo].[email_metrics_24520] (nolock)

select [event]  --805
,case when [event] in ('delivered','open','click') then 1 else 0 end  as is_delivered
,case when [event] = 'bounce' then 1 else 0 end as is_bounced
,case when [event] in ('open','click') then 1 else 0 end as is_opened
,case when [event] = 'click' then 1 else 0 end as is_clicked

,email 
from [dbo].[email_metrics_24520] (nolock) 
where [event] <> 'processed'


select a.email_address,b.email,
is_delivered, case when [event] in ('delivered','open','click') then 1 else 0 end
,is_opened,case when [event] in ('open','click') then 1 else 0 end
,is_bounced,case when [event] = 'bounce' then 1 else 0 end
,is_clicked,case when [event] = 'click' then 1 else 0 end
from email.campaign_items a (nolock)
inner join [dbo].[email_metrics_24520] b(nolock) on trim(a.email_address) = trim(b.email)

where a.is_deleted =0 and a.campaign_id =24520
and b.[event] <> 'processed'


select --16
	is_delivered
	,is_opened
	,is_bounced
	,is_clicked

--update a set is_bounced = 1
from email.campaign_items a (nolock)
inner join [dbo].[email_metrics_24520] b(nolock) on trim(a.email_address) = trim(b.email)

where a.is_deleted =0 and a.campaign_id =24520
and b.[event] = 'bounce'


select --289
is_delivered
,is_opened
,is_bounced
,is_clicked

--update a set is_clicked = 1,is_delivered =1 ,is_opened =1
from email.campaign_items a (nolock)
inner join [dbo].[email_metrics_24520] b(nolock) on trim(a.email_address) = trim(b.email)

where a.is_deleted =0 and a.campaign_id =24520
and b.[event] = 'click'


select --93
is_delivered
,is_opened
,is_bounced
,is_clicked

--update a set is_opened =1,is_delivered =1
from email.campaign_items a (nolock)
inner join [dbo].[email_metrics_24520] b(nolock) on trim(a.email_address) = trim(b.email)

where a.is_deleted =0 and a.campaign_id =24520
and b.[event] = 'open' and a.is_clicked =0 

select --295
is_delivered
,is_opened
,is_bounced
,is_clicked

--update a set is_delivered =1
from email.campaign_items a (nolock)
inner join [dbo].[email_metrics_24520] b(nolock) on trim(a.email_address) = trim(b.email)

where a.is_deleted =0 and a.campaign_id =24520
and b.[event] = 'delivered' and a.is_clicked =0 and is_opened = 0 



select * from auto_customers.portal.account with (nolock) where accountname like 'malco%'
select * from sms.campaign_items a (nolock) where campaign_item_id = 2838606
select * from auto_campaigns.[dbo].[API_messages5] b (nolock) where phone = '7602207783'
select * from auto_customers.customer.customers c (nolock) where  account_id  = '26239573-9C57-44A1-B209-391C7B564B7E' and is_deleted =0 
and (secondary_phone_number = '7602207783' or primary_phone_number = '7602207783')



------------soft delete campaign_items delivered
use auto_campaigns
select * 
--update a set is_deleted =1, updated_by = 'sk',updated_dt =getdate()--27274
from sms.campaign_items a (nolock) where  campaign_item_id in 
(
		select -- 27,604
		distinct
			a.campaign_item_id
			--,c.do_not_sms
		--update c set do_not_sms = null, updated_by = 'sk_smsUnknown',updated_dt = getdate()
		from sms.campaign_items a (nolock) 
		inner join auto_campaigns.[dbo].[API_messages5] b (nolock) on a.phone = b.phone
		inner join auto_customers.customer.customers c (nolock) on a.list_member_id = c.customer_id
		where a.campaign_id = '28105'
		and c.is_deleted =0
		and isnumeric(a.phone) =1
		and b.[message state] in ('ERR_SOFT_BOUNCE') 

)


use auto_campaigns
select * from auto_customers.portal.account with (nolock) where accountname like 'lone%'

select * from email.campaigns with (nolock) where account_id  = '26239573-9C57-44A1-B209-391C7B564B7E' and campaign_id = 24049

select * from auto_campaigns.email.campaign_items (nolock) where campaign_id = 24049  --14713
--in (25913, 25840)


select --14713/14479 --10302
	 a.list_member_id
	,b.customer_id
	,b.do_not_email
	,a.is_deleted
	--update b set do_not_email = null, updated_by = 'sk_neg_optin',updated_dt = getdate()
	--update a set is_deleted =1, updated_by = 'sk_reNegCampDel',updated_dt =  getdate()
from auto_campaigns.email.campaign_items a (nolock)
inner join auto_customers.customer.customers b (nolock) on a.list_member_id = b.customer_id
where a.campaign_id = 24049
and b.account_id = '26239573-9C57-44A1-B209-391C7B564B7E'
--and b.do_not_email <> 1
and isnull(a.is_delivered,0) = 0
and isnull(b.is_email_bounce,0) = 0
-------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
drop table if exists #tep
select 
	b.customer_id,b.first_name,b.last_name,b.primary_email,case when b.do_not_sms=1 then 'Opt-Out' when b.do_not_sms=0 then 'Opt-In' else 'DONotKnow' end as [SMS Preference],
	--v.vin,v.make,v.model,v.year,
	max(v.purchase_date) as purchase_date ,max(v.last_service_date) as last_service_date
	into #tep
from auto_customers.customer.customers b (nolock)
inner join auto_campaigns.email.campaign_items a (nolock) on a.list_member_id = b.customer_id
left outer join auto_customers.customer.vehicles v (nolock) on a.list_member_id = v.customer_id

where 
	b.account_id = '26239573-9C57-44A1-B209-391C7B564B7E'
	and a.is_deleted =0
	and a.campaign_id = 24049
	and a.is_unsubscribed = 1

group by 
	b.customer_id,b.first_name,b.last_name,b.primary_email,b.do_not_sms


select *,row_number() over (partition by primary_email order by customer_id desc) as rnk from #tep

select * from 

select is_deleted,* 
--update a set is_deleted =1, updated_by = 'sk_recampNegoptin',updated_dt = getdate()
from email.campaign_items a (nolock) where campaign_id = 24049 and email_address like '%malcolmsmith%'

--select * from auto_campaigns.campaign.reports (nolock)
select b.do_not_email

--update b set do_not_email = null, updated_by = 'reoptin', updated_dt =getdate()
from  email.campaign_items a (nolock) 
inner join auto_customers.customer.customers b (nolock) on a.list_member_id = b.customer_id
where a.campaign_id = 24049 and a.email_address like '%malcolmsmith%'
and b.account_id = '26239573-9C57-44A1-B209-391C7B564B7E'
and b.is_deleted =0



select segment_list,* from auto_customers.customer.customers (nolock) where account_id = '26239573-9C57-44A1-B209-391C7B564B7E' and segment_list like '%,6876,%'

select * from auto_customers.customer.segments (nolock) where segment_id in (6876,6799)



select * from auto_campaigns.email.campaigns (nolock) where [name] like 'Google Review 2022-08-03 11:15' and account_id = 'DE352067-1436-40B0-8BA4-86D036A3CE0D' and campaign_id =25914 

select * from auto_campaigns.email.campaign_items (nolock) where campaign_id = 25914

select * from auto_customers.customer.customers (nolock) where account_id = 'DE352067-1436-40B0-8BA4-86D036A3CE0D' and segment_list like '%,6901,%'

select * from auto_customers.customer.customers (nolock) where account_id = 'DE352067-1436-40B0-8BA4-86D036A3CE0D' and list_ids like '%,3526,%'

select * from auto_customers.customer.segments (nolock) where segment_id in (6901)

select * from auto_customers.list.lists (nolock) where list_id = 3526


exec auto_customers.[customer].[query_segment_get] @account_id = 'de352067-1436-40b0-8ba4-86d036a3ce0d'
,@segmant_query = '{"queries":[{"element":"List Name","operator":"is","secondOperator":"","value":"3526","elementTypeId":13,"order":1,"match":"","groupId":1,"groupValue":""}]}'
,@list_type_id = 3
,@campaign_type = 'download'


select make, count(*)
from auto_customers.customer.customers a (nolock) 
inner join  auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
	a.account_id = '2928EACC-A39D-4743-BF02-F9689F16E79F' 
	and a.is_deleted = 0 
	and (make like 'Apri%' or make like 'duca%')
group by make
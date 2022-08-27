
--'Velocity Cycles' --'F0590E45-19AA-4597-A2B5-67553DD7B113'48755
select _id,accountname,r2r_dealer_id from auto_customers.portal.account with (nolock) where accountname like 'Velocity Cycles' and accountstatus = 'active'


--EMAIL CAMPAIGNS COUNTS
select status_type_id,count(*) from auto_campaigns.email.campaigns (nolock) where is_deleted =0 and account_id  = 'F0590E45-19AA-4597-A2B5-67553DD7B113' and 
isnull(is_flow_campaign,0) =0 
group by status_type_id
select status_type_id,count(*) from  [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) where is_deleted =0 and dealer_id = 48755 and 
isnull(is_r2r_flow,0) =0 and media_type = 'Email' 
group by status_type_id



---statustype_id
select * from auto_campaigns.[campaign].[status_type] (nolock)
select * from [18.216.140.206].r2r_cm.[campaign].[status_type] with (nolock)




---------------lists

select count(*) from [18.216.140.206].[r2r_admin].[owner].[contact_list] with (nolock) where dealer_id  = 48755 and is_deleted =0 --29
select count(*)  from auto_customers.list.lists (nolock) where is_deleted = 0 and account_id= 'F0590E45-19AA-4597-A2B5-67553DD7B113' --29


---update thumbnail image

select  a.campaign_id,a.html_content,b.html_content,a.thumbnail_url,b.thumbnail_url,a.content_json,b.content_json
--update a set a.content_json = b.content_json

--update a set a.html_content = b.html_content,a.thumbnail_url = b.thumbnail_url, a.content_json = b.content_json
from auto_campaigns.email.campaigns a(nolock)
inner join [18.216.140.206].[r2r_cm].campaign.campaign_media b with (nolock) on a.r2r_campaign_id = b.campaign_id
where  
a.account_id =  'F0590E45-19AA-4597-A2B5-67553DD7B113'and 
a.thumbnail_url is null and b.thumbnail_url is not null

---Check campaign counts

select top 10 * from auto_campaigns.[email].[counts] co with(nolock,readuncommitted) where campaign_id  = 48755


---updating schedule_type_id


---checked SP [auto_campaigns].[email].[get_campaigns]

--auto_campaigns.analytics.get_fulfilled_campaigns


----SMS CAMPAIGNS
select status_type_id,count(*) from auto_campaigns.sms.campaigns (nolock) where is_deleted =0 and account_id  = 'F0590E45-19AA-4597-A2B5-67553DD7B113' and 
isnull(is_flow_campaign,0) =0 group by status_type_id
select status_type_id,count(*) from  [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) where is_deleted =0 and dealer_id = 48755 and
isnull(is_r2r_flow,0) =0 and media_type = 'sms' 
group by status_type_id



select list_ids,segment_list,* from auto_customers.customer.customers (nolock) where is_Deleted =0 and account_id  = 'F0590E45-19AA-4597-A2B5-67553DD7B113' 

select * from auto_customers.customer.segments (nolock) where is_Deleted =0 and account_id  = 'F0590E45-19AA-4597-A2B5-67553DD7B113' 

select list_ids,segment_list,*
--update a set segment_list = iif(segment_list='-1,',segment_list,concat(replace(segment_list,' ', ''),','))
from auto_customers.customer.customers a (nolock) where is_Deleted =0 and account_id  = 'F0590E45-19AA-4597-A2B5-67553DD7B113' 
and 
segment_list like '%,4277,%'

select * 
--update a set total_count = 1136,updated_by ='sk_totcount',updated_dt =getdate()
from auto_customers.customer.segments a (nolock) where is_Deleted =0 and account_id  = 'F0590E45-19AA-4597-A2B5-67553DD7B113' 
and segment_id  = 4277

select _id,accountname,r2r_dealer_id from auto_customers.portal.account with (nolock) where accountname like 'cycle%' and accountstatus = 'active'


---update campaign_items


select a.r2r_campaignitem_id,b.campaign_item_id,b.campaign_media_id,a.email_address,b.email_address ,a.is_clicked,b.is_clicked--update a set a.is_clicked = b.is_clickedfrom auto_campaigns.[email].[campaign_items] a(nolock) inner join [18.216.140.206].[r2r_cm].[email].[campaign_item] b (nolock) on a.r2r_campaignitem_id = b.campaign_item_idwhere  a.is_clicked != b.is_clicked select a.r2r_campaignitem_id,b.campaign_item_id,b.campaign_media_id,a.email_address,b.email_address ,a.is_opened,b.is_opened--update a set a.is_opened = b.is_openedfrom auto_campaigns.[email].[campaign_items] a(nolock) inner join [18.216.140.206].[r2r_cm].[email].[campaign_item] b (nolock) on a.r2r_campaignitem_id = b.campaign_item_idwhere  a.is_opened != b.is_opened

  select a.r2r_campaignitem_id,b.campaign_item_id,b.campaign_media_id,a.email_address,b.email_address ,a.is_bounced,b.is_bounced--update a set a.is_bounced = b.is_bouncedfrom auto_campaigns.[email].[campaign_items] a(nolock) inner join [18.216.140.206].[r2r_cm].[email].[campaign_item] b (nolock) on a.r2r_campaignitem_id = b.campaign_item_idwhere  a.is_bounced != b.is_bounced


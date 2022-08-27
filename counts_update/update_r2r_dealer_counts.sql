-------------------INDIANAPOLIS SOUTHSIDE HD
select _id,accountname,r2r_dealer_id from auto_customers.portal.account with (nolock) where accountname like 'indianapolis%' and accountstatus = 'active'


--EMAIL CAMPAIGNS COUNTS
select status_type_id,count(*) from auto_campaigns.email.campaigns (nolock) where is_deleted =0 and account_id  = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' and 
isnull(is_flow_campaign,0) =0 group by status_type_id
select status_type_id,count(*) from  [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) where is_deleted =0 and dealer_id = 48878 and isnull(is_r2r_flow,0) =0 and media_type = 'Email' 
group by status_type_id



---statustype_id
select * from auto_campaigns.[campaign].[status_type] (nolock)
select * from [18.216.140.206].r2r_cm.[campaign].[status_type] with (nolock)


select * from auto_campaigns.email.campaigns (nolock) where is_deleted =0 and account_id  = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A'
select status_type_id,count(*) from  [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) where is_deleted =0 and dealer_id = 48878

select * from [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) where is_deleted =0 and dealer_id = 48878 and campaign_id in (
select campaign_id from  [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) where is_deleted =0 and dealer_id = 48878 and media_type = 'Email' 
except
select r2r_campaign_id from auto_campaigns.email.campaigns (nolock) where is_deleted =0 and account_id  = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' 
)



---------------lists

select count(*) from [18.216.140.206].[r2r_admin].[owner].[contact_list] with (nolock) where dealer_id  = 48878 and is_deleted =0 --29
select count(*)  from auto_customers.list.lists (nolock) where is_deleted = 0 and account_id= 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' --29


---update thumbnail image

select  a.campaign_id,a.html_content,b.html_content,a.thumbnail_url,b.thumbnail_url,a.content_json,b.content_json
--update a set a.content_json = b.content_json

--update a set a.html_content = b.html_content,a.thumbnail_url = b.thumbnail_url, a.content_json = b.content_json
from auto_campaigns.email.campaigns a(nolock)
inner join [18.216.140.206].[r2r_cm].campaign.campaign_media b with (nolock) on a.r2r_campaign_id = b.campaign_id
where  
a.account_id =  'EF42DEF6-DA60-4632-B879-B01B26CDE74A'and 
a.thumbnail_url is null and b.thumbnail_url is not null

---Check campaign counts

select * from auto_campaigns.email.campaigns a (nolock) where is_deleted =0 and account_id  = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' and 
name in ('April Video Newsletter #2','March Video Newsletter #1','Feb Video Newsletter #1','Feb Video Newsletter #2')

select top 10 * from auto_campaigns.[email].[counts] co with(nolock,readuncommitted) where campaign_id  = 23338


---updating schedule_type_id

select * 
update a set schedule_type_id =1
from auto_campaigns.email.campaigns a (nolock) where is_deleted =0 and account_id  = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' and 
name in ('April Video Newsletter #2','March Video Newsletter #1','Feb Video Newsletter #1','Feb Video Newsletter #2')

---checked SP [auto_campaigns].[email].[get_campaigns]

--auto_campaigns.analytics.get_fulfilled_campaigns


----SMS CAMPAIGNS
select status_type_id,count(*) from auto_campaigns.sms.campaigns (nolock) where is_deleted =0 and account_id  = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' and 
isnull(is_flow_campaign,0) =0 group by status_type_id
select status_type_id,count(*) from  [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) where is_deleted =0 and dealer_id = 48878 and
isnull(is_r2r_flow,0) =0 and media_type = 'sms' 
group by status_type_id


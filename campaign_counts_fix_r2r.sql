drop table if exists #temp
select
a.campaign_id
,a.status_type_id 
,(Case When a.status_type_id = 1 then 1
		When a.status_type_id = 10 then 11
		When a.status_type_id = 11 then 12			
		When a.status_type_id = 12 then 13
		When a.status_type_id = 13 then 15
		When a.status_type_id = 14 then 14
		When a.status_type_id = 2 then 3
		When a.status_type_id = 3 then 4
		When a.status_type_id = 4 then 5
		When a.status_type_id = 5 then 7
		When a.status_type_id = 7 then 8
		When a.status_type_id = 8 then 6
		When a.status_type_id = 9 then 10
		else a.status_type_id
		end ) as status_type_id_new
,c.status_type_id as status_type_id_clic
,c.campaign_id as cmapign_id_new
,c.name 
into #temp
from [18.216.140.206].[r2r_cm].campaign.campaign a (nolock)
inner join auto_portal.[portal].[account] b with (nolock) on a.dealer_id = b.r2r_dealer_id
inner join auto_campaigns.email.campaigns c with (nolock) on a.campaign_id = c.r2r_campaign_id
where a.media_type = 'Email'   and lower(b.accountstatus) = 'active'
and a.dealer_id in (2991)


select c.campaign_id,c.status_type_id,b.status_type_id_new
--update c set c.status_type_id = b.status_type_id_new
from auto_campaigns.email.campaigns c with (nolock)
inner join #temp b on c.campaign_id =b.cmapign_id_new
where status_type_id_new <> status_type_id_clic 


select * from #temp where status_type_id_new <> status_type_id_clic 

select * from #temp where status_type_id = 1

select * from #temp where  status_type_id not in (1,6)

select top 10 * from auto_campaigns.email.campaigns c with (nolock)

select status_type_id, * from  auto_campaigns.email.campaigns c with (nolock) where campaign_id in (17880,23321)

select status_type_id, * 
--update c set status_type_id =6
from  auto_campaigns.email.campaigns c with (nolock) where campaign_id = 23321




drop table if exists #temp_sms
select
a.campaign_id
,a.status_type_id 
,	(Case When a.status_type_id =	1 then 1
			When a.status_type_id = 10 then 11
			When a.status_type_id = 11 then 12			
			When a.status_type_id = 12 then 13
			When a.status_type_id = 13 then 15
			When a.status_type_id = 14 then 14
			When a.status_type_id = 2 then 3
			When a.status_type_id = 3 then 4
			When a.status_type_id = 4 then 5
			When a.status_type_id = 5 then 7
			When a.status_type_id = 7 then 8
			When a.status_type_id = 8 then 6
			When a.status_type_id = 9 then 10
		else a.status_type_id
		end ) as status_type_id_new
,c.status_type_id as status_type_id_clic
,c.campaign_id as cmapign_id_new
,c.name 
into #temp_sms
from [18.216.140.206].[r2r_cm].campaign.campaign a (nolock)
inner join auto_portal.[portal].[account] b with (nolock) on a.dealer_id = b.r2r_dealer_id
inner join auto_campaigns.sms.campaigns c with (nolock) on a.campaign_id = c.r2r_campaign_id
where a.media_type = 'sms'   and lower(b.accountstatus) = 'active'
and a.dealer_id in (2991)


select c.campaign_id,c.status_type_id,b.status_type_id_new
--update c set c.status_type_id = b.status_type_id_new
from auto_campaigns.sms.campaigns c with (nolock)
inner join #temp_sms b on c.campaign_id =b.cmapign_id_new
where status_type_id_new <> status_type_id_clic 


select * from #temp_sms where status_type_id = 1

select * from #temp_sms where  status_type_id not in (1,6)




select * from auto_campaigns.[campaign].[status_type] (nolock)
select * from [18.216.140.206].r2r_cm.[campaign].[status_type] with (nolock)



select status_type_id,* from auto_campaigns.email.campaigns (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304'  and r2r_campaign_id is not null  and is_deleted =0
and name like '%Marketing 5/4/22'

select status_type_id,* from  [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) where dealer_id = 2990 and media_type = 'Email' 
and name like '%clone of marketing 1/5/22'

select * from [18.216.140.206].r2r_cm.[campaign].[status_type] with (nolock)


use auto_campaigns
declare @account_id  uniqueidentifier = '7DB79611-A797-4938-AAC8-F3A887384304'
(select
(select  count(campaign_id) from auto_campaigns.email.campaigns (nolock) where account_id=@account_id and is_deleted=0 and status_type_id in (select status_type_id from campaign.status_type (nolock) where status_type in ('Delivered')))  +
(select  count(campaign_id) from auto_campaigns.sms.campaigns (nolock) where account_id=@account_id and is_deleted=0 and status_type_id in (select status_type_id from campaign.status_type (nolock) where status_type in ('Delivered')))  +
(select  count(campaign_id) from auto_campaigns.push.campaigns (nolock) where account_id=@account_id and is_deleted=0 and status_type_id in (select status_type_id from campaign.status_type (nolock) where status_type in ('Delivered')))+
(select  count(campaign_id) from social.campaigns (nolock) where account_id=@account_id and is_deleted=0 and status_type_id in (select status_type_id from campaign.status_type (nolock) where status_type in ('Delivered')))
)

select  count(campaign_id) from auto_campaigns.email.campaigns (nolock) where account_id='7DB79611-A797-4938-AAC8-F3A887384304'and is_deleted=0 and status_type_id = 6  --476
select  count(campaign_id) from auto_campaigns.sms.campaigns (nolock) where account_id='7DB79611-A797-4938-AAC8-F3A887384304' and is_deleted=0 and status_type_id =6  --498
select  count(campaign_id) from auto_campaigns.push.campaigns  (nolock) where account_id='7DB79611-A797-4938-AAC8-F3A887384304' and is_deleted=0 and status_type_id = 6
select  count(campaign_id) from social.campaigns (nolock) where account_id='7DB79611-A797-4938-AAC8-F3A887384304' and is_deleted=0 and status_type_id =6

select --475
count(*)
from auto_campaigns.email.campaigns a (nolock) 
inner join  [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) on a.r2r_campaign_id = b.campaign_id
where a.is_deleted=0 and b.is_deleted =0
and b.dealer_id = 2990 and a.account_id = '7DB79611-A797-4938-AAC8-F3A887384304'
and b.media_type = 'Email' 
and b.status_type_id in (1,6)




select --498
count(*)
from auto_campaigns.sms.campaigns a (nolock) 
inner join  [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) on a.r2r_campaign_id = b.campaign_id
where a.is_deleted=0 and b.is_deleted =0
and b.dealer_id = 2990 and a.account_id = '7DB79611-A797-4938-AAC8-F3A887384304'
and b.media_type = 'sms' 
and b.status_type_id in (1,6)

in old DB also completed email campaigns are 475 and sms campaigns are 498, total: 973

email_campaigns: 488, sms_camapigns: 502



select count(distinct campaign_id) from auto_campaigns.email.campaign_items a (nolock) where  is_deleted =0 and campaign_id in (   --185
select --475
distinct a.campaign_id
from auto_campaigns.email.campaigns a (nolock) 
inner join  [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) on a.r2r_campaign_id = b.campaign_id
where a.is_deleted=0 and b.is_deleted =0
and b.dealer_id = 2990 and a.account_id = '7DB79611-A797-4938-AAC8-F3A887384304'
and b.media_type = 'Email' 
and b.status_type_id in (6)
)


select count(distinct campaign_id) from auto_campaigns.sms.campaign_items a (nolock) where  is_deleted =0 and campaign_id in (   --53
select --475
distinct a.campaign_id
from auto_campaigns.sms.campaigns a (nolock) 
inner join  [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) on a.r2r_campaign_id = b.campaign_id
where a.is_deleted=0 and b.is_deleted =0
and b.dealer_id = 2990 and a.account_id = '7DB79611-A797-4938-AAC8-F3A887384304'
and b.media_type = 'sms' 
and b.status_type_id in (6)
)


select a.campaign_id, a.name, a.status_type_id, count(b.campaign_item_id), 'Email' as source
from email.campaigns a (nolock)
left outer join email.campaign_items b (nolock) on a.campaign_id = b.campaign_id
where a.account_id = '7DB79611-A797-4938-AAC8-F3A887384304'  and a.status_type_id in (6) and a.is_deleted = 0 --and b.is_deleted = 0
--and isnull(a.is_flow_campaign,0) = 0
group by a.campaign_id, a.name, a.status_type_id
having count(b.campaign_item_id) < = 0
Union
select a.campaign_id, a.name, a.status_type_id, count(b.campaign_item_id), 'SMS' as source
from sms.campaigns a (nolock)
left outer join sms.campaign_items b (nolock) on a.campaign_id = b.campaign_id
where a.account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and a.status_type_id in (6) and a.is_deleted = 0 --and b.is_deleted = 0
--and isnull(a.is_flow_campaign,0) = 0
group by a.campaign_id, a.name, a.status_type_id



----------------camapigns_columns_updates

select top 10  * from auto_media.[template].[templates] (nolock) where account_id =  '7DB79611-A797-4938-AAC8-F3A887384304' and template_name like 'marketing 4/20/22'

select html_content,thumbnail_url,* from auto_campaigns.email.campaigns (nolock) where is_deleted =0 and account_id =  '7DB79611-A797-4938-AAC8-F3A887384304' and name like 'marketing 4/20/22'

select * from  [18.216.140.206].[r2r_cm].campaign.campaign a (nolock) where dealer_id = 2990 and is_deleted =0  and media_type ='email' and name like 'marketing 4/20/22'


select * from  [18.216.140.206].[r2r_cm].campaign.campaign_media with (nolock) where campaign_id = 78202


select * from [18.216.140.206].[r2r_cm].template.template a (nolock)

select a.html_content,b.html_content,a.thumbnail_url,b.thumbnail_url,a.content_json,b.content_json
--select count(*)
--update a set 
--a.html_content =b.html_content
--,a.thumbnail_url=b.thumbnail_url

--update a set a.content_json = b.content_json
select  a.campaign_id,a.html_content,b.html_content,a.thumbnail_url,b.thumbnail_url,a.content_json,b.content_json
--update a set a.content_json = b.content_json

--update a set a.html_content = b.html_content
from auto_campaigns.email.campaigns a(nolock)
inner join [18.216.140.206].[r2r_cm].campaign.campaign_media b with (nolock) on a.r2r_campaign_id = b.campaign_id
where  
a.account_id =  'EF42DEF6-DA60-4632-B879-B01B26CDE74A'and 
a.content_json is null and b.content_json is not null

and a.campaign_id in (23318,23319,23320,23321,23322 )




----------UNSUBSCRIBED REASON COUNTS FIX R2R



select c.campaign_item_id, c.list_member_id, c.email_address, c.is_unsubscribed, a.campaign_id, d.reason_id, e.customer_id, g.reson_id, f.campaign_id, g.campaign_id, g.opt_out_id
--Update g set g.reson_id = d.reason_id, g.campaign_id = f.campaign_id
from [18.216.140.206].[r2r_cm].[campaign].[campaign] a with (nolock)
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign_media] b (nolock) on a.campaign_id = b.campaign_id
inner join [18.216.140.206].[r2r_cm].[email].[campaign_item] c (nolock) on b.campaign_media_id = c.campaign_media_id
inner join [18.216.140.206].[r2r_admin].[owner].[owner] d with (nolock) on c.list_member_id = d.owner_id
inner join auto_customers.customer.customers e with (nolock) on d.owner_id = e.r2r_customer_id
inner join auto_campaigns.email.campaigns f with (nolock) on a.campaign_id = f.r2r_campaign_id
left outer join auto_customers.[customer].[opt_outs] g with (nolock) on e.customer_id = g.customer_id
where c.is_unsubscribed = 1 and g.opt_out_id is null --and a.campaign_id = 77485
and e.account_id IN ('7DB79611-A797-4938-AAC8-F3A887384304', '82abf13b-b9c9-4bab-b883-7613e964a1eb', 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
					 ,'96DBF74D-C8BD-459B-B751-B93F961EF884', '6B9537BD-115F-4019-B3AA-7F981EC69559', 'F0590E45-19AA-4597-A2B5-67553DD7B113'
					 ,'ef42def6-da60-4632-b879-b01b26cde74a', 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF', 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A')



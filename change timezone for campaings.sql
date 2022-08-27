use auto_campaigns

select 
campaign_id
,scheduled_date
,scheduled_time
--,cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)
--,CONVERT(DATETIME,
--                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
--                    AT TIME ZONE 'UTC')
,cast(CONVERT(DATETIME,
                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
                    AT TIME ZONE 'UTC') as date) as new_scheduled_date
,cast(CONVERT(DATETIME,
                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
                    AT TIME ZONE 'UTC') as time) as new_scheduled_time


--update a set scheduled_date = 
--cast(CONVERT(DATETIME,
--                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
--                    AT TIME ZONE 'UTC') as date) 
--,scheduled_time = 
--cast(CONVERT(DATETIME,
--                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
--                    AT TIME ZONE 'UTC') as time) 



from email.campaigns a (nolock) where 
	is_deleted =0 and
	 r2r_campaign_id is not null 
	--and account_id <> 'ef42def6-da60-4632-b879-b01b26cde74a' 
	--and name like 'may video%'
and a.account_id IN ('7DB79611-A797-4938-AAC8-F3A887384304')
and name in ('Marketing 5/25/22','Marketing 5/18/22','Marketing 5/11/22')


and a.account_id not IN ('7DB79611-A797-4938-AAC8-F3A887384304', '82abf13b-b9c9-4bab-b883-7613e964a1eb', 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
					,'96DBF74D-C8BD-459B-B751-B93F961EF884', '6B9537BD-115F-4019-B3AA-7F981EC69559', 'F0590E45-19AA-4597-A2B5-67553DD7B113'
					,'A1478891-4F48-4B55-9D64-B5FB5B99B1EF', 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A','ef42def6-da60-4632-b879-b01b26cde74a' ) 




select  a.scheduled_date
,Cast([campaign].[schedule_options_startdt_get_del](b.schedule_options) as date) as scheduled_date
,a.scheduled_time
,Cast([campaign].[schedule_options_startdt_get_del](b.schedule_options) as time) as scheduled_time
--update a set 
--	 a.scheduled_date = Cast([campaign].[schedule_options_startdt_get_del](b.schedule_options) as date)
--	,a.scheduled_time =  Cast([campaign].[schedule_options_startdt_get_del](b.schedule_options) as time)

from 
 email.campaigns a (nolock)
inner join [18.216.140.206].[r2r_cm].campaign.campaign b (nolock) on a.r2r_campaign_id = b.campaign_id
where a.is_deleted =0 
	and a.account_id = 'ef42def6-da60-4632-b879-b01b26cde74a' 
	and a.name like 'may video%'





select f.is_opened,a.is_opened,f.is_clicked, a.is_clicked

--update f set f.is_clicked = a.is_clicked
from [18.216.140.206].[r2r_cm].[email].[campaign_item] a with (nolock)
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign_media] b with (nolock) on a.campaign_media_id = b.campaign_media_id
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign] e with (nolock) on b.campaign_id = e.campaign_id
inner join email.campaigns c with (nolock) on e.campaign_id = c.r2r_campaign_id
inner join auto_customers.customer.customers d with (nolock) on a.list_member_id = d.r2r_customer_id
inner join email.campaign_items f with (nolock) on a.campaign_item_id = f.r2r_campaignitem_id and c.campaign_id = f.campaign_id
where c.account_id  = 'ef42def6-da60-4632-b879-b01b26cde74a' 
and c.name like 'may video%'
and f.is_deleted  =0 
and f.is_clicked <> a.is_clicked




select count(*) from 
auto_customers.customer.customers a (nolock) 
inner join  [18.216.140.206].[r2r_admin].owner.owner b with (nolock) on a.r2r_customer_id  = b.owner_id

where 
account_id  = '82ABF13B-B9C9-4BAB-B883-7613E964A1EB' 
and b.is_app_user =1
and b.is_deleted =0



select count(*)  
--update a set a.is_email_bounce = b.is_email_bounced
from 
auto_customers.customer.customers a (nolock) 
inner join  [18.216.140.206].[r2r_admin].owner.owner b with (nolock) on a.r2r_customer_id  = b.owner_id

where 
a.account_id  = '7db79611-a797-4938-aac8-f3a887384304' 
and a.is_deleted =0
and b.is_Deleted =1
--and a.do_not_email=0 
--and isnull(a.is_email_bounce,0)  <> isnull(b.is_email_bounced,0)
--and a.list_ids like '%,345,%'


select * from auto_customers.list.lists (nolock) where account_id  = '7db79611-a797-4938-aac8-f3a887384304' and is_deleted =0

select * from [18.216.140.206].[r2r_admin].[owner].[contact_list] with (nolock) where dealer_id  = 2990 and is_deleted =0 --18
select *  from auto_customers.list.lists (nolock) where is_deleted = 0 and account_id= '7DB79611-A797-4938-AAC8-F3A887384304' --18



use auto_campaigns
select 
campaign_id
,scheduled_date
,scheduled_time
--,cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)
--,CONVERT(DATETIME,
--                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
--                    AT TIME ZONE 'UTC')
,cast(CONVERT(DATETIME,
                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
                    AT TIME ZONE 'UTC') as date) as new_scheduled_date
,cast(CONVERT(DATETIME,
                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
                    AT TIME ZONE 'UTC') as time) as new_scheduled_time


--update a set scheduled_date = 
--cast(CONVERT(DATETIME,
--                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
--                    AT TIME ZONE 'UTC') as date) 
--,scheduled_time = 
--cast(CONVERT(DATETIME,
--                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
--                    AT TIME ZONE 'UTC') as time) 



from email.campaigns a (nolock) where 
	is_deleted =0 and
	 r2r_campaign_id is not null 
	--and account_id <> 'ef42def6-da60-4632-b879-b01b26cde74a' 
	--and name like 'may video%'
and a.account_id IN ('7DB79611-A797-4938-AAC8-F3A887384304')
and name in ('Marketing 4/13/22','Marketing 4/6/22','Marketing 5/11/22')




select  a.scheduled_date
,Cast([campaign].[schedule_options_startdt_get_del](b.schedule_options) as date) as scheduled_date
,a.scheduled_time
,Cast([campaign].[schedule_options_startdt_get_del](b.schedule_options) as time) as scheduled_time

--update a set 
--	 a.scheduled_date = Cast([campaign].[schedule_options_startdt_get_del](b.schedule_options) as date)
--	,a.scheduled_time =  Cast([campaign].[schedule_options_startdt_get_del](b.schedule_options) as time)

from 
 email.campaigns a (nolock)
inner join [18.216.140.206].[r2r_cm].campaign.campaign b (nolock) on a.r2r_campaign_id = b.campaign_id
where a.is_deleted =0 
and a.account_id IN ('7DB79611-A797-4938-AAC8-F3A887384304')
and a.name in ('Marketing 4/13/22','Marketing 4/6/22','Marketing 5/11/22')



select * from [18.216.140.206].[r2r_admin].owner.owner with (nolock) where dealer_id = 2999 and is_app_user = 1 and is_Deleted =0

select a.* 

--update a set a.is_app_user = b.is_app_user
from auto_customers.customer.customers a (nolock) 
inner join  [18.216.140.206].[r2r_admin].owner.owner b with (nolock) on a.r2r_customer_id = b.owner_id

where a.account_id  = '9A9AC801-A7EE-40FB-99DA-B80F552A3A61'
and b.is_app_user =1 

and isnull(a.is_app_user,0) = 0

and is_Deleted = 0


select  a.scheduled_date
,Cast([campaign].[schedule_options_startdt_get_del](b.schedule_options) as date) as scheduled_date
,a.scheduled_time
,Cast([campaign].[schedule_options_startdt_get_del](b.schedule_options) as time) as scheduled_time

update a set 
	 a.scheduled_date = Cast([campaign].[schedule_options_startdt_get_del](b.schedule_options) as date)
	,a.scheduled_time =  Cast([campaign].[schedule_options_startdt_get_del](b.schedule_options) as time)

from 
 email.campaigns a (nolock)
inner join [18.216.140.206].[r2r_cm].campaign.campaign b (nolock) on a.r2r_campaign_id = b.campaign_id
where a.is_deleted =0 
and a.account_id IN ('EF42DEF6-DA60-4632-B879-B01B26CDE74A')
and a.name in ('Jan Video Newsletter #2')



use auto_campaigns
select 
campaign_id
,scheduled_date
,scheduled_time
,cast(CONVERT(DATETIME,
                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
                    AT TIME ZONE 'UTC') as date) as new_scheduled_date
,cast(CONVERT(DATETIME,
                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
                    AT TIME ZONE 'UTC') as time) as new_scheduled_time


--update a set scheduled_date = 
--cast(CONVERT(DATETIME,
--                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
--                    AT TIME ZONE 'UTC') as date) 
--,scheduled_time = 
--cast(CONVERT(DATETIME,
--                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
--                    AT TIME ZONE 'UTC') as time) 



from email.campaigns a (nolock) where 
	is_deleted =0 and
	 r2r_campaign_id is not null 
	--and account_id <> 'ef42def6-da60-4632-b879-b01b26cde74a' 
	--and name like 'may video%'
and a.account_id IN ('EF42DEF6-DA60-4632-B879-B01B26CDE74A')
and a.name in ('Jan Video Newsletter #2')




use auto_campaigns
select 
campaign_id
,scheduled_date
,scheduled_time
,cast(CONVERT(DATETIME,
                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
                    AT TIME ZONE 'UTC') as date) as new_scheduled_date
,cast(CONVERT(DATETIME,
                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
                    AT TIME ZONE 'UTC') as time) as new_scheduled_time


--update a set scheduled_date = 
--cast(CONVERT(DATETIME,
--                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
--                    AT TIME ZONE 'UTC') as date) 
--,scheduled_time = 
--cast(CONVERT(DATETIME,
--                (cast(scheduled_date as datetime) + cast(convert(time,scheduled_time) as datetime)) AT TIME ZONE 'Eastern Standard Time'
--                    AT TIME ZONE 'UTC') as time) 



from email.campaigns a (nolock) where 
	is_deleted =0 and
	 r2r_campaign_id is not null 
	 and campaign_id  = 23874

select * from auto_campaigns.email.campaigns (nolock) where name  = 'Marketing 5/25/22'
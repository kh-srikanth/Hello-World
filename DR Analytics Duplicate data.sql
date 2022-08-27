use auto_stg_campaigns
insert into [email].[campaigns] (
[account_id], [user_id], [program_id], [campaign_type_id], [status_type_id], [schedule_type_id], [list_type_id], [lang_id], [name], [description], [media_type], [from_name], [from_email], [reply_email], [subject], [preview_text], [html_content], [content_json], [target_audience], [schedule_options], [customer_count], [abtest], [thumbnail_url], [flow_id], [audience_type_id], [scheduled_date], [scheduled_time], [is_flow_campaign], [is_internal_notification], [ses_template_name], [multi_channel_campaign_id], [segment_id], [run_count], [last_run_dt],  [seed_list], [participent_type_id], [is_approval_req], [is_editable], [participent_dealers], [parent_campaign_id], [r2r_campaign_id], [time_zone], [list_segment_type_id], [template_name]
)
select 
'AB356E67-E125-4B59-8F33-DF70C481D61B' as [account_id], [user_id], [program_id], [campaign_type_id], [status_type_id], [schedule_type_id], [list_type_id], [lang_id], [name], [description], [media_type], [from_name], [from_email], [reply_email], [subject], [preview_text], [html_content], [content_json], [target_audience], [schedule_options], [customer_count], [abtest], [thumbnail_url], [flow_id], [audience_type_id], [scheduled_date], [scheduled_time], [is_flow_campaign], [is_internal_notification], [ses_template_name], [multi_channel_campaign_id], [segment_id], [run_count], [last_run_dt],  [seed_list], [participent_type_id], [is_approval_req], [is_editable], [participent_dealers], [parent_campaign_id], [r2r_campaign_id], [time_zone], [list_segment_type_id], [template_name]
from [email].[campaigns] where account_id='63e6b499-4cc0-4591-a489-6f7376e7e4e8' and is_deleted=0 and [status_type_id] = 6 and campaign_id in (3193,3041,3154)


select a.campaign_id, count(campaign_item_id) 
from [email].[campaigns] a (nolock)
inner join  [email].[campaign_items] b (nolock) on a.campaign_id = b.campaign_id

where account_id='63e6b499-4cc0-4591-a489-6f7376e7e4e8'
and a.is_deleted=0 and a.[status_type_id] = 6
group by a.campaign_id
order by count(campaign_item_id) desc
select *  from email.campaigns (nolock) where is_deleted =0 and account_id = 'AB356E67-E125-4B59-8F33-DF70C481D61B'
--3638,3639,3640
drop table if exists #temp
select * into #temp from email.campaigns (nolock) where is_deleted =0 and account_id = 'AB356E67-E125-4B59-8F33-DF70C481D61B'

select * from (
select *,row_number() over (partition by name order by created_dt) as rnk from #temp ) as a where rnk > 1

insert into email.campaign_items
(
	[campaign_id], [list_member_id], [aws_message_id], [email_address], [first_name], [last_name], [salutation], [address], [city], [state], [zip_code], [phone], [service_advisor], [vin], [make], [model], [year], [actual_mileage], [predictive_mileage], [purchase_date], [last_service_date], [browser_type_id], [device_type_id], [status_type_id], [is_sent], [is_delivered], [is_opened], [is_unsubscribed], [is_bounced], [is_suppressed], [is_clicked], [is_failed], [propensity_score], [flow_id], [is_deleted], [created_dt], [created_by], [updated_dt], [updated_by], [bounce_type], [is_seed], [r2r_campaignitem_id], [coupon1], [coupon2], [coupon3], [coupon4], [coupon5], [coupon6], [coupon7], [coupon8], [coupon9], [coupon10], [image1], [image2], [image3], [image4], [image5], [image6], [image7], [image8], [image9], [image10], [text1], [text2], [text3], [text4], [text5], [text6], [text7], [text8], [text9], [text10], [campaign_run_id], [list_type_id], [department_type], [request_type]
)

select 
	c.[campaign_id], a.[list_member_id], a.[aws_message_id], a.[email_address], a.[first_name], a.[last_name], a.[salutation], a.[address], a.[city], a.[state], a.[zip_code], a.[phone], a.[service_advisor]
	, a.[vin], a.[make], a.[model], a.[year], a.[actual_mileage], a.[predictive_mileage], a.[purchase_date], a.[last_service_date], a.[browser_type_id], a.[device_type_id], a.[status_type_id], a.[is_sent]
	, a.[is_delivered], a.[is_opened], a.[is_unsubscribed], a.[is_bounced], a.[is_suppressed], a.[is_clicked], a.[is_failed], a.[propensity_score], a.[flow_id], a.[is_deleted], a.[created_dt], a.[created_by]
	, a.[updated_dt], a.[updated_by], a.[bounce_type], a.[is_seed], a.[r2r_campaignitem_id], a.[coupon1], a.[coupon2], a.[coupon3], a.[coupon4], a.[coupon5], a.[coupon6], a.[coupon7], a.[coupon8]
	, a.[coupon9], a.[coupon10], a.[image1], a.[image2], a.[image3], a.[image4], a.[image5], a.[image6], a.[image7], a.[image8], a.[image9], a.[image10], a.[text1], a.[text2], a.[text3], a.[text4], a.[text5]
	, a.[text6], a.[text7], a.[text8], a.[text9], a.[text10], a.[campaign_run_id], a.[list_type_id], a.[department_type], a.[request_type]
from email.campaign_items a (nolock) 
inner join [email].[campaigns] b (nolock) on a.campaign_id = b.campaign_id
inner join #temp c on b.name = c.name
where 
	b.is_deleted =0 
	and b.account_id = '63e6b499-4cc0-4591-a489-6f7376e7e4e8'
	and c.is_deleted =0




	select 
		 b.campaign_id, count(*)
	from email.campaign_items a (nolock) 
	inner join [email].[campaigns] b (nolock) on a.campaign_id = b.campaign_id
	where 
		b.is_deleted =0 
		and b.account_id = '327248a7-1654-4c5b-90ed-181c73454968'
	group by b.campaign_id
	order by count(*) desc

select * from campaign.status_type (nolock)
select * 
--update b set is_deleted = 1
from [email].[campaigns] b (nolock) where is_deleted =0  

	
	
	select 
		b.name,a.*
		--update a set a.is_clicked = 1,a.is_opened = 1
	from email.campaign_items a (nolock) 
	inner join [email].[campaigns] b (nolock) on a.campaign_id = b.campaign_id
	where 
		b.is_deleted =0 
		and b.account_id = '327248a7-1654-4c5b-90ed-181c73454968'
		and b.campaign_id = 3526
		and a.is_delivered = 1
		and is_clicked = 0 and is_opened = 0
		and campaign_item_id in ()


	select 
	b.campaign_id,sum(convert(int,a.is_sent))
	from email.campaign_items a (nolock) 
	inner join [email].[campaigns] b (nolock) on a.campaign_id = b.campaign_id
	where 
		b.is_deleted =0 
		and b.account_id = '327248a7-1654-4c5b-90ed-181c73454968'

	group by b.campaign_id
	order by sum(convert(int,a.is_sent)) desc





		select 
	b.campaign_id,sum(convert(int,a.is_sent))
	from email.campaign_items a (nolock) 
	inner join [email].[campaigns] b (nolock) on a.campaign_id = b.campaign_id
	where 
		b.is_deleted =0 
		and b.account_id = 'AB356E67-E125-4B59-8F33-DF70C481D61B'

	group by b.campaign_id
	order by sum(convert(int,a.is_sent)) desc

	select * 
	--update a set is_clicked =1
	from email.campaign_items a (nolock) where is_deleted =0 and campaign_id = 3638 and is_opened= 1
	and campaign_item_id not in (
124304
,124305
,124306
)--3638,3639,3640


	select * from [email].[campaigns] b (nolock) where account_id = 'AB356E67-E125-4B59-8F33-DF70C481D61B'


	use auto_stg_campaigns




select b.campaign_id, count(campaign_item_id)
from sms.campaigns a (nolock) 
inner join sms.campaign_items b (nolock) on a.campaign_id = b.campaign_id
where a.is_deleted =0 and a.account_id = '327248a7-1654-4c5b-90ed-181c73454968'
group by b.campaign_id


	drop table if exists #temp
select * into #temp from sms.campaigns (nolock) where is_deleted =0 and account_id = '327248a7-1654-4c5b-90ed-181c73454968' and campaign_id in (1987,1989,1986) 


insert into sms.campaigns
(
[account_id], [name], [description], [html_content], [media_type], [campaign_type_id], [status_type_id], [list_source_id], [media_type_id], [schedule_type_id], [business_area_id], [touch_point_id], [list_type_id], [lang_id], [program_id], [is_approved], [approval_date], [approved_by], [target_audience], [participating_dealers], [schedule_options], [cap_count], [est_count], [cap_amount], [est_amount], [coupon_exp_date], [subject], [insert_url], [image_url], [sort_order], [customer_segment_id], [customer_count], [is_pinned], [abtest], [template_name], [is_template], [thumbnail_url], [is_inbox], [is_flow_campaign], [marketplace_type], [target_device], [print_in_home_start_date], [print_in_home_end_date], [audience_type_id], [scheduled_date], [scheduled_time], [aws_topic_arn], [sms_type_id], [is_mms], [is_internal_notification], [multi_channel_campaign_id], [segment_id], [run_count], [last_run_dt], [seed_list], [participent_type_id], [is_approval_req], [is_editable], [participent_dealers], [parent_campaign_id], [is_poll_form], [poll_options], [r2r_campaign_id], [poll_content], [temp_html_content], [list_segment_type_id]
)
select 
'AB356E67-E125-4B59-8F33-DF70C481D61B' as [account_id], [name], [description], [html_content], [media_type], [campaign_type_id], [status_type_id], [list_source_id], [media_type_id], [schedule_type_id], [business_area_id], [touch_point_id], [list_type_id], [lang_id], [program_id], [is_approved], [approval_date], [approved_by], [target_audience], [participating_dealers], [schedule_options], [cap_count], [est_count], [cap_amount], [est_amount], [coupon_exp_date], [subject], [insert_url], [image_url], [sort_order], [customer_segment_id], [customer_count], [is_pinned], [abtest], [template_name], [is_template], [thumbnail_url], [is_inbox], [is_flow_campaign], [marketplace_type], [target_device], [print_in_home_start_date], [print_in_home_end_date], [audience_type_id], [scheduled_date], [scheduled_time], [aws_topic_arn], [sms_type_id], [is_mms], [is_internal_notification], [multi_channel_campaign_id], [segment_id], [run_count], [last_run_dt], [seed_list], [participent_type_id], [is_approval_req], [is_editable], [participent_dealers], [parent_campaign_id], [is_poll_form], [poll_options], [r2r_campaign_id], [poll_content], [temp_html_content], [list_segment_type_id]

from #temp

insert into sms.campaign_items
(

 [campaign_id], [list_member_id], [twilio_sid], [phone_number], [first_name], [last_name], [salutation], [address], [city], [state], [zip_code], [country_code], [phone], [service_advisor], [vin], [make], [model], [year], [actual_mileage], [predictive_mileage], [purchase_date], [last_service_date], [status_type_id], [is_sent], [is_delivered], [is_failed], [delivery_status], [err_message], [cost], [message_parts], [status], [status_code], [network_code], [retry_count], [response], [is_twilio_processed],  [flow_id], [is_seed], [appt_sch_dt], [r2r_campaignitem_id], [campaign_run_id], a.[list_type_id], [middle_name], [title], [email]
)

select 
	c.[campaign_id], [list_member_id], [twilio_sid], [phone_number], [first_name], [last_name], [salutation], [address], [city], [state], [zip_code], [country_code], [phone], [service_advisor], [vin], [make], [model], [year], [actual_mileage], [predictive_mileage], [purchase_date], [last_service_date], a.[status_type_id], [is_sent], [is_delivered], [is_failed], [delivery_status], [err_message], [cost], [message_parts], [status], [status_code], [network_code], [retry_count], [response], [is_twilio_processed],  [flow_id], [is_seed], [appt_sch_dt], [r2r_campaignitem_id], [campaign_run_id], a.[list_type_id], [middle_name], [title], [email]
from sms.campaign_items a (nolock) 
inner join sms.[campaigns] b (nolock) on a.campaign_id = b.campaign_id
inner join #temp c on b.name = c.name
where 
	b.is_deleted =0 
	and b.account_id = '327248a7-1654-4c5b-90ed-181c73454968'
	and c.is_deleted =0

drop table if exists #temp
select * into #temp from sms.[campaigns] b (nolock) where account_id = 'AB356E67-E125-4B59-8F33-DF70C481D61B'



select a.campaign_id,count(*) 
from sms.[campaigns] a (nolock) 
inner join sms.campaign_items b (nolock) on a.campaign_id = b.campaign_id
where account_id = 'AB356E67-E125-4B59-8F33-DF70C481D61B'
group by a.campaign_id





	select * from sms.campaigns (nolock) 
	where account_id = '327248a7-1654-4c5b-90ed-181c73454968' and status_type_id = 6

	select * 
	--update a set list_type_id = 3
	--update a set is_approved = 1
	--update a set media_type_id = 3
	from sms.campaigns a (nolock) where account_id = '327248a7-1654-4c5b-90ed-181c73454968' and status_type_id = 6
	select * from email.campaigns (nolock) where account_id = '327248a7-1654-4c5b-90ed-181c73454968' and status_type_id = 6

		select b.*
		--update b set is_failed = 1
		from sms.campaigns a(nolock) 
		inner join sms.campaign_items b (nolock) on a.campaign_id = b.campaign_id
	where a.account_id = '327248a7-1654-4c5b-90ed-181c73454968' and a.status_type_id = 6
	
	select * from campaign.media_type (nolock)

	select * from sms.counts (nolock) where campaign_id in (select campaign_id from sms.campaigns a (nolock) where is_deleted =0 and  account_id = 'AB356E67-E125-4B59-8F33-DF70C481D61B'  and status_type_id = 6)
	select * from email.counts (nolock) where campaign_id in (select campaign_id from email.campaigns a (nolock) where is_deleted=0 and account_id = 'AB356E67-E125-4B59-8F33-DF70C481D61B' and status_type_id = 6)
	
use auto_stg_campaigns
		insert into sms.counts
		(campaign_id, count,sent,delivered,opened,clicked,undelivered,blocked,sent_on )
		select 
				a.campaign_id,count(*), sum(convert(int,is_sent)), sum(convert(int,is_delivered)),0,0,sum(convert(int,is_failed)),0,max(b.updated_dt)
	
		from sms.campaigns a(nolock) 
		inner join sms.campaign_items b (nolock) on a.campaign_id = b.campaign_id
		where a.account_id = 'AB356E67-E125-4B59-8F33-DF70C481D61B' and a.status_type_id = 6 
		group by a.campaign_id




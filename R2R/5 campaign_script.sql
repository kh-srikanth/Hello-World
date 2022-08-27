use auto_campaigns

---- Email.Campaign Insert
Insert into email.campaigns
(
	  campaign_guid
	, account_id
	, user_id
	, program_id
	, campaign_type_id
	, status_type_id
	, schedule_type_id
	, list_type_id
	, lang_id
	, name
	, description
	, media_type
	, from_name
	, from_email
	, reply_email
	, subject
	, preview_text
	, html_content
	, content_json
	, target_audience
	, schedule_options
	, customer_count
	, abtest
	, thumbnail_url
	, flow_id
	, audience_type_id
	, scheduled_date
	, scheduled_time
	, is_flow_campaign
	, is_internal_notification
	, ses_template_name
	, multi_channel_campaign_id
	, segment_id
	, run_count
	, last_run_dt
	, is_deleted
	, created_dt
	, created_by
	, updated_dt
	, updated_by
	, seed_list
	, participent_type_id
	, is_approval_req
	, is_editable
	, participent_dealers
	, parent_campaign_id
	, r2r_campaign_id
)
select 
	  newid() as campaign_guid
	, b._id as account_id
	, null as [user_id]
	, 3 as program_id
	, 2 as campaign_type -- 'Adhoc'  Need to add value in [campaign].[campaign_type] table
	, (Case When a.status_type_id = 1 then 2
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
		end ) as status_type_id
	, 0 as schedule_type_id
	, 0 as list_type_id
	, 0 as lang_id
	, [name]
	, [description]
	, a.media_type
	, a.from_name
	, a.from_email
	, null as reply_email
	, null as [subject]
	, null as preview_text
	, null as html_content
	, '{}' as content_json
	, '[]' as target_audience
	, a.schedule_options
	, 0 as customer_count
	, null as abtest -- commented due to column length not matching with r2r and clicmotion
	, null as thumbnail_url
	, 0 as flow_id
	, 0 as audience_type_id
	, Cast([campaign].[schedule_options_startdt_get_del](a.schedule_options) as date) as schedule_date
	, Cast([campaign].[schedule_options_startdt_get_del](a.schedule_options) as time) as schedule_time
	, isnull(is_r2r_flow, 0) as is_flow_campaign
	, 0 as is_internal_notification
	, null as ses_template_name	
	, null as multi_channel_campaign_id
	, 0 as segment_id
	, 0 as run_count
	, null as last_run_dt
	, a.is_deleted
	, a.created_dt
	, a.created_by
	, a.updated_dt
	, a.updated_by
	, 0 as seed_list
	, 0 as participent_type_id
	, 0 as is_approval_req
	, 0 as is_editable
	, '' as participent_dealers
	, null as parent_campaign_id
	, a.campaign_id as r2r_campaign_id
from [18.216.140.206].[r2r_cm].campaign.campaign a (nolock)
inner join auto_portal.[portal].[account] b with (nolock) on a.dealer_id = b.r2r_dealer_id
where a.media_type = 'Email'
and a.dealer_id in (48625, 2990, 2991)

---- SMS.Camapgin Insert
Insert into sms.campaigns
(
	  campaign_guid
	, user_id
	, account_id
	, name
	, description
	, html_content
	, media_type
	, campaign_type_id
	, status_type_id
	, list_source_id
	, media_type_id
	, schedule_type_id
	, business_area_id
	, touch_point_id
	, list_type_id
	, lang_id
	, program_id
	, is_approved
	, approval_date
	, approved_by
	, target_audience
	, participating_dealers
	, schedule_options
	, cap_count
	, est_count
	, cap_amount
	, est_amount
	, coupon_exp_date
	, subject
	, insert_url
	, image_url
	, sort_order
	, customer_segment_id
	, customer_count
	, is_pinned
	, abtest
	, template_name
	, is_template
	, thumbnail_url
	, is_inbox
	, is_flow_campaign
	, marketplace_type
	, target_device
	, print_in_home_start_date
	, print_in_home_end_date
	, audience_type_id
	, scheduled_date
	, scheduled_time
	, aws_topic_arn
	, sms_type_id
	, is_mms
	, is_internal_notification
	, multi_channel_campaign_id
	, segment_id
	, run_count
	, last_run_dt
	, is_deleted
	, created_dt
	, created_by
	, updated_dt
	, updated_by
	, seed_list
	, participent_type_id
	, is_approval_req
	, is_editable
	, participent_dealers
	, parent_campaign_id
	, is_poll_form
	, poll_options
	, r2r_campaign_id
)
select 
	  newid() as campaign_guid
	, null as [user_id]
	, b._id as account_id
	, [name]
	, [description]
	, null as html_content
	, a.media_type
	, 2 as campaign_type -- 'Adhoc'  Need to add value in [campaign].[campaign_type] table
	, (Case When a.status_type_id = 1 then 2
			When a.status_type_id = 10 then 11
			When a.status_type_id = 11 then 12
			When a.status_type_id = 12 then 13
			When a.status_type_id = 13 then 15
			When a.status_type_id = 14 then 14
			When a.status_type_id = 2 then 3
			When a.status_type_id = 3 then 4
			When a.status_type_id = 4 then 5
			When a.status_type_id = 5 then 7
			When a.status_type_id = 6 then 6
			When a.status_type_id = 7 then 8
			When a.status_type_id = 8 then 9
			When a.status_type_id = 9 then 10
		else a.status_type_id
		end ) as status_type_id
	, '0' as list_source_id
	, 3 as media_type_id
	, 0 as schedule_type_id
	, a.business_area_id --- need to get the udpate
	, null as touch_point_id
	, 0 as list_type_id -- list_source_id need to check
	, a.lang_id
	, a.program_id
	, a.is_approved
	, a.approval_date
	, a.approved_by
	, a.target_audience
	, a.participating_dealers
	, a.schedule_options
	, null as cap_count
	, null as est_count
	, null as cap_amount
	, null as est_amount
	, null as coupon_exp_date
	, null as subject
	, null as insert_url
	, null as image_url
	, null as sort_order
	, null as customer_segment_id
	, null as customer_count
	, a.is_pinned
	, null as abtest -- Commented column due column length not matching between r2r and clicmotion
	, null as template_name
	, a.is_template
	, null as thumbnail_url
	, a.is_inbox
	, isnull(a.is_r2r_flow, 0) as is_flow_campaign
	, null as marketplace_type
	, null as target_device
	, null as print_in_home_start_date
	, null as print_in_home_end_date
	, 0 as audience_type_id -- need to check
	, Cast([campaign].[schedule_options_startdt_get_del](a.schedule_options) as date) as schedule_date
	, Cast([campaign].[schedule_options_startdt_get_del](a.schedule_options) as time) as schedule_time
	, null as aws_topic_arn
	, null as sms_type_id -- need to check
	, 0 as is_mms -- need to check
	, 0 as is_internal_notification
	, null as multi_channel_campaign_id
	, 0 as segment_id
	, 0 as run_count
	, null as last_run_dt
	, a.is_deleted
	, a.created_dt
	, a.created_by
	, a.updated_dt
	, a.updated_by
	, '0' as seed_list
	, 0 as participent_type_id
	, 0 as is_approval_req
	, 0 as is_editable
	, null as participent_dealers
	, null as parent_campaign_id
	, null as is_poll_form
	, null poll_options
	, a.campaign_id as r2r_campaign_id
from [18.216.140.206].[r2r_cm].campaign.campaign a (nolock)
inner join auto_portal.[portal].[account] b with (nolock) on a.dealer_id = b.r2r_dealer_id
where a.media_type = 'SMS'
and a.dealer_id in (48625, 2990, 2991)

----------------------- Push Campaign Insert
Insert into push.campaigns
(
	  media_type_id
	, campaign_guid
	, account_id
	, dealer_id
	, program_id
	, list_source_id
	, media_type
	, business_area_id
	, touch_point_id
	, campaign_type_id
	, status_type_id
	, lang_id
	, name
	, description
	, is_approved
	, approval_date
	, approved_by
	, target_audience
	, participating_dealers
	, schedule_options
	, cap_count
	, est_count
	, cap_amount
	, est_amount
	, coupon_exp_date
	, from_name
	, from_email
	, sort_order
	, customer_segment_id
	, customer_count
	, is_pinned
	, abtest
	, template_name
	, is_template
	, thumbnail_url
	, is_inbox
	, is_flow_campaign
	, marketplace_type
	, target_device
	, print_in_home_start_date
	, print_in_home_end_date
	, scheduled_date
	, scheduled_time
	, subject
	, is_deleted
	, created_dt
	, created_by
	, updated_dt
	, updated_by
	, user_id
	, segment_id
	, print_order_id
	, schedule_type_id
	, html_content
	, audience_type_id
	, list_type_id
	, participent_type_id
	, seed_list
	, is_approval_req
	, is_editable
	, participent_dealers
	, r2r_campaign_id
)
select 
	  5 as media_type_id
	, newid() as campaign_guid
	, b._id as account_id
	, b.account_id
	, a.program_id
	, null as list_source_id
	, a.media_type
	, a.business_area_id -- need to check
	, null as touch_point_id
	, 2 as campaign_type -- 'Adhoc'  Need to add value in [campaign].[campaign_type] table
	, (Case When a.status_type_id = 1 then 2
			When a.status_type_id = 10 then 11
			When a.status_type_id = 11 then 12			
			When a.status_type_id = 12 then 13
			When a.status_type_id = 13 then 15
			When a.status_type_id = 14 then 14
			When a.status_type_id = 2 then 3
			When a.status_type_id = 3 then 4
			When a.status_type_id = 4 then 5
			When a.status_type_id = 5 then 7
			When a.status_type_id = 6 then 6
			When a.status_type_id = 7 then 8
			When a.status_type_id = 8 then 9
			When a.status_type_id = 9 then 10
		else a.status_type_id
		end ) as status_type_id
	, a.lang_id
	, [name]
	, [description]
	, a.is_approved
	, a.approval_date
	, a.approved_by
	, a.target_audience
	, a.participating_dealers
	, a.schedule_options
	, null as cap_count
	, null as est_count
	, null as cap_amount
	, null as est_amount
	, null as coupon_exp_date
	, a.from_email
	, a.from_email
	, a.sort_order
	, a.customer_segment_id --  need to check
	, null as customer_count
	, a.is_pinned
	, null as abtest -- Commented column due column length not matching between r2r and clicmotion
	, null as template_name
	, is_template
	, null as thumbnail_url
	, a.is_inbox
	, isnull(a.is_r2r_flow, 0) as is_flow_campaign
	, null as marketplace_type
	, null as target_device
	, null as print_in_home_start_date
	, null as print_in_home_end_date
	, Cast([campaign].[schedule_options_startdt_get_del](a.schedule_options) as date) as schedule_date
	, Cast([campaign].[schedule_options_startdt_get_del](a.schedule_options) as time) as schedule_time
	, null as subject
	, a.is_deleted
	, a.created_dt
	, a.created_by
	, a.updated_dt
	, a.updated_by
	, null as [user_id]
	, null as segment_id -- need to check
	, 0 as print_order_id
	, null as schedule_type_id
	, null as html_content
	, null as audience_type_id -- need to check
	, null as list_type_id
	, null as participent_type_id
	, null as seed_list
	, null as is_approved_req
	, null as is_editable
	, participating_dealers
	, a.campaign_id as r2r_campaign_id
from [18.216.140.206].[r2r_cm].campaign.campaign a (nolock)
inner join auto_portal.[portal].[account] b with (nolock) on a.dealer_id = b.r2r_dealer_id
where a.media_type = 'push'
and a.dealer_id in (48625, 2990, 2991)


------------------------------- Social Campaigns Insert
Insert into social.campaigns
(
	  campaign_guid
	, account_id
	, dealer_id
	, program_id
	, list_source_id
	, media_type_id
	, media_type
	, business_area_id
	, touch_point_id
	, campaign_type_id
	, social_type_id
	, status_type_id
	, lang_id
	, name
	, description
	, html_content
	, image_url
	, insert_url
	, is_approved
	, approval_date
	, approved_by
	, target_audience
	, participating_dealers
	, schedule_options
	, cap_count
	, est_count
	, cap_amount
	, est_amount
	, coupon_exp_date
	, from_name
	, from_email
	, sort_order
	, customer_segment_id
	, is_pinned
	, abtest
	, template_name
	, is_template
	, thumbnail_url
	, is_inbox
	, is_flow_campaign
	, marketplace_type
	, target_device
	, print_in_home_start_date
	, print_in_home_end_date
	, scheduled_date
	, is_deleted
	, scheduled_time
	, created_dt
	, created_by
	, updated_dt
	, updated_by
	, user_id
	, is_internal_notification
	, multi_channel_campaign_id
	, seed_list
	, participent_type_id
	, is_approval_req
	, is_editable
	, participent_dealers
	, parent_campaign_id
	, r2r_campaign_id
)
select 
	  newid() as campaign_guid
	, b._id as account_id
	, b.account_id
	, 1 as program_id
	, null as list_source_id
	, 4 as media_type_id
	, a.media_type
	, a.business_area_id -- need to check
	, null as touch_point_id
	, 2 as campaign_type -- 'Adhoc'  Need to add value in [campaign].[campaign_type] table
	, null as social_type_id
	, (Case When a.status_type_id = 1 then 2
			When a.status_type_id = 10 then 11
			When a.status_type_id = 11 then 12			
			When a.status_type_id = 12 then 13
			When a.status_type_id = 13 then 15
			When a.status_type_id = 14 then 14
			When a.status_type_id = 2 then 3
			When a.status_type_id = 3 then 4
			When a.status_type_id = 4 then 5
			When a.status_type_id = 5 then 7
			When a.status_type_id = 6 then 6
			When a.status_type_id = 7 then 8
			When a.status_type_id = 8 then 9
			When a.status_type_id = 9 then 10
		else a.status_type_id
		end ) as status_type_id
	, a.lang_id
	, [name]
	, [description]
	, null as html_content
	, null as image_url
	, null as insert_url
	, a.is_approved
	, a.approval_date
	, a.approved_by
	, a.target_audience
	, a.participating_dealers
	, a.schedule_options
	, null as cap_count
	, null as est_count
	, null as cap_amount
	, null as est_amount
	, null as coupon_exp_date
	, a.from_email
	, a.from_email
	, a.sort_order
	, a.customer_segment_id --  need to check
	, a.is_pinned
	, null as abtest -- Commented column due column length not matching between r2r and clicmotion
	, null as template_name
	, is_template
	, null as thumbnail_url
	, a.is_inbox
	, isnull(a.is_r2r_flow, 0) as is_flow_campaign
	, null as marketplace_type
	, null as target_device
	, null as print_in_home_start_date
	, null as print_in_home_end_date
	, Cast([campaign].[schedule_options_startdt_get_del](a.schedule_options) as date) as schedule_date
	, a.is_deleted
	, Cast([campaign].[schedule_options_startdt_get_del](a.schedule_options) as time) as schedule_time
	, a.created_dt
	, a.created_by
	, a.updated_dt
	, a.updated_by
	, null as [user_id]
	, 0 as is_internal_notification
	, null as multi_channel_campaign_id
	, null as seed_list
	, null as participent_type_id
	, null as is_approved_req
	, null as is_editable
	, participating_dealers
	, null as parent_campaign_id
	, a.campaign_id as r2r_campaign_id
from [18.216.140.206].[r2r_cm].campaign.campaign a (nolock)
inner join auto_portal.[portal].[account] b with (nolock) on a.dealer_id = b.r2r_dealer_id
where a.media_type = 'social'
and a.dealer_id in (48625, 2990, 2991)

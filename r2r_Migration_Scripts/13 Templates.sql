use auto_media
GO

Insert into [template].[templates]
(
	  template_guid
	, account_id
	, user_id
	, lang_id
	, program_id
	, channel_type_id
	, template_type_id
	, print_format_id
	, media_type
	, media_type_id
	, template_name
	, template_desc
	, template_url
	, template_file_name
	, thumbnail_url
	, html_content
	, front_html_content
	, middle_html_content
	, back_html_content
	, print_mailer_type
	, print_mailer_size
	, template_json
	, content_json
	, target_audience
	, subject
	, from_name
	, from_email
	, print_size
	, middle_json
	, back_json
	, print_customer_source
	, print_format
	, print_cost_reduce_by
	, print_cost_reduce_value
	, print_updated_customers_count
	, print_postage_type
	, postcard_thumbnail_url
	, letter_thumbnail_url
	, trifold_thumbnail_url
	, expiry_date
	, sort_id
	, is_deleted
	, created_by
	, created_dt
	, updated_by
	, updated_dt
	, is_whats_app_approval
	, platform_id
	, sms_type_id
	, insert_url
	, preview_text
	, is_crm_template
	, parent_template_id
	, r2r_template_id
)


select 
	  a.template_guid
	, b._id as account_id
	, null as [user_id]
	, a.lang_id -- need to check
	, 3 as program_id
	, 1 as channel_type_id
	, 1 as template_type_id
	, 0 as print_format_id
	, a.media_type
	, (Case when a.media_type = 'Email' then 1
			when a.media_type = 'SMS' then 2
			when a.media_type = 'Push' then 3
			when a.media_type = 'Social' then 4
			when a.media_type = 'Whatsapp' then 5
			when a.media_type = 'Print' then 6
			when a.media_type = 'Multi Channel' then 7
		end
	  ) as media_type_id
	, a.template_name
	, a.template_name as template_desc
	, null as template_url
	, null as template_file_name
	, a.thumbnail_url
	, a.html_content_del as html_content -- need to check
	, a.front_html_content
	, a.middle_html_content
	, null as back_html_content
	, null as print_mailer_type
	, null as print_mailer_size
	, a.template_json
	, null as content_json
	, a.target_audience
	, a.campaign_subject as subject --  need to check
	, a.campaign_from_name as from_name
	, a.from_email 
	, null as print_size
	, null as middle_json
	, null as back_json
	, null as print_customer_source
	, null as print_format
	, null as print_cost_reduce_by
	, null as print_cost_reduce_value
	, null as print_updated_customer_count
	, null  as print_postage_type
	, null as postcard_thumbnail_url
	, null as letter_thumbnail_url
	, null as trifold_thumbnail_url
	, null as expiry_date
	, null as sort_id
	, a.is_deleted
	, a.created_by
	, a.created_dt
	, a.updated_by
	, a.updated_dt
	, null as is_whats_app_approval
	, 1 as platform_id -- need to check
	, null as platform_id
	, null as sms_type_id
	, '' as insert_url
	, Isnull(a.is_crm, 0)
	, null as parent_template_id
	, a.template_id
from [18.216.140.206].[r2r_cm].template.template a (nolock)
inner join auto_portal.[portal].[account] b with (nolock) on a.dealer_id = b.r2r_dealer_id
left outer join [template].[templates] c with (nolock) on a.template_id = c.r2r_template_id
where a.dealer_id in (48625, 2990, 2991) and c.template_id is null

union

select 
	  newid() as template_guid
	, b._id as account_id
	, null as [user_id]
	, a.lang_id -- need to check
	, 3 as program_id
	, 1 as channel_type_id
	, 1 as template_type_id
	, 0 as print_format_id
	, a.media_type
	, (Case when a.media_type = 'Email' then 1
			when a.media_type = 'SMS' then 2
			when a.media_type = 'Push' then 3
			when a.media_type = 'Social' then 4
			when a.media_type = 'Whatsapp' then 5
			when a.media_type = 'Print' then 6
			when a.media_type = 'Multi Channel' then 7
		end
	  ) as media_type_id
	, a.[name] as template_name
	, a.[description] as template_desc
	, null as template_url
	, a.[file_name] as template_file_name
	, null as thumbnail_url
	, null as html_content -- need to check
	, null as front_html_content
	, null as middle_html_content
	, null as back_html_content
	, null as print_mailer_type
	, null as print_mailer_size
	, null as template_json
	, null as content_json
	, a.target_audience
	, null as subject --  need to check
	, a.from_name 
	, a.from_email 
	, null as print_size
	, null as middle_json
	, null as back_json
	, null as print_customer_source
	, null as print_format
	, null as print_cost_reduce_by
	, null as print_cost_reduce_value
	, null as print_updated_customer_count
	, null  as print_postage_type
	, null as postcard_thumbnail_url
	, null as letter_thumbnail_url
	, null as trifold_thumbnail_url
	, null as expiry_date
	, null as sort_id
	, a.is_deleted
	, a.created_by
	, a.created_dt
	, a.updated_by
	, a.updated_dt
	, null as is_whats_app_approval
	, 1 as platform_id -- need to check
	, null as platform_id
	, null as sms_type_id
	, '' as insert_url
	, 0 as is_crm
	, null as parent_template_id
	,  a.campaign_id as template_id
	
--select  a.*
FROM
			[18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted)
			INNER JOIN [18.216.140.206].r2r_cm.campaign.campaign_media cm with(nolock,readuncommitted) on
			cm.campaign_id = a.campaign_id
			inner join auto_portal.[portal].[account] b with (nolock) on a.dealer_id = b.r2r_dealer_id
			LEFT JOIN [18.216.140.206].r2r_cm.campaign.campaign_subject cs with(nolock,readuncommitted) on
			cs.campaign_media_id = cm.campaign_media_id
			LEFT JOIN (select top 1 s.social_id,s.dealer_id,s.page_name from [18.216.140.206].r2r_cm.social.social s with (nolock)  where s.is_deleted = 0 and dealer_id = 2990) ss on
			ss.dealer_id = a.dealer_id
			left outer join [template].[templates] c with (nolock) on a.campaign_id = c.r2r_template_id
		WHERE
			a.dealer_id in (48625, 2990, 2991)
			and a.is_deleted = 0
			and a.is_template = 1
			and a.media_type <> 'Email'
			and c.template_id is null
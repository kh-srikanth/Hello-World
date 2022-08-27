
select * from auto_media.template.templates (nolock) where account_id='81984ea2-27ad-45f7-b28a-bf4fcdf8c8c0' 
select distinct media_type from auto_media.template.templates (nolock) where account_id='81984ea2-27ad-45f7-b28a-bf4fcdf8c8c0' 

select top 3 * from [3.21.66.39].clictell_cm.[template].[template] with (nolock) where account_id='051F6F9E-54AD-4F18-B69B-03DB9F383775'  

[template_id]
, [template_guid]
, [account_id]
, [lang_id]
, [mailer_type_id_del]
, [category_id]
, [layout_id_del]
, [dealer_id]
, [dmail_template_id]
, [coupon_list]
, [template_name]
, [template_code_del]
, [html_content_del]
, [thumbnail_url]
, [coupon_layout_id_del]
, [media_types]
, [email_content_del]
, [dmail_content_del]
, [sms_content_del]
, [social_content_del]
, [letter_code_id_del]
, [media_type_id]
, [phone_code_del]
, [front_html_content]
, [rear_html_content]
, [middle_html_content]
, [dmail_mailer_type]
, [dmail_mailer_size]
, [template_json]
, [target_audience]
, [campaign_subject]
, [campaign_from_name]
, [campaign_text]
, [from_email]
, [preview_text]
, [is_template]
, [social_type]
, [dmail_format_id]
, [middle_json]
, [back_json]
, [social_ids]
, [print_customer_source]
, [print_format]
, [print_cost_reduce_by]
, [print_cost_reduce_value]
, [print_updated_customers_count]
, [print_postage_type]
, [postcard_thumbnail_url]
, [letter_thumbnail_url]
, [trifold_thumbnail_url]
, [whats_app_approval]
, [is_checked]

select
[account_id]
, [user_id]
, [lang_id]
, [program_id]
, [channel_type_id]
, [template_type_id]
, [print_format_id]
, [media_type]
, [media_type_id]
, [template_name]
, [template_desc]
, [template_url]
, [template_file_name]
, [thumbnail_url]
, [html_content]
, [front_html_content]
, [middle_html_content]
, [back_html_content]
, [print_mailer_type]
, [print_mailer_size]
, [template_json]
, [content_json]
, [target_audience]
, [subject]
, [from_name]
, [from_email]
, [print_size]
, [middle_json]
, [back_json]
, [print_customer_source]
, [print_format]
, [print_cost_reduce_by]
, [print_cost_reduce_value]
, [print_updated_customers_count]
, [print_postage_type]
, [postcard_thumbnail_url]
, [letter_thumbnail_url]
, [trifold_thumbnail_url]
, [expiry_date]
, [sort_id]
, [is_whats_app_approval]
, [platform_id]
, [sms_type_id]
, [insert_url]
, [preview_text]
, [is_crm_template]
, [parent_template_id]
, [r2r_template_id]
, [participent_type_id]
, [participent_dealers]
, [is_approval_req]
, [is_editable]
, [is_crm]
, [image_url]
, [is_sms]
, [template_tags]
, [postage_type_id]
, [part_id]
, [part_name]
from 
[3.21.66.39].clictell_cm.[template].[template] with (nolock) where account_id='051F6F9E-54AD-4F18-B69B-03DB9F383775'


insert into auto_media.template.templates
(
account_id
,program_id
,lang_id
,print_format_id
,media_type
,media_type_id
,template_name
,thumbnail_url
,front_html_content
,middle_html_content
,back_html_content
,content_json
,target_audience
,from_email
,print_postage_type
,postcard_thumbnail_url
,letter_thumbnail_url
,trifold_thumbnail_url
,preview_text
,is_deleted
,created_by
,updated_by
,created_dt
,updated_dt

)



select  
'81984ea2-27ad-45f7-b28a-bf4fcdf8c8c0' as account_id
,1 as program_id
,1 as [lang_id]
,print_format
,case	when [media_types]= '[1]' then 'Email' 
		when [media_types]= '[2]' then 'Directmail' 
		when [media_types]= '[3]' then 'sms' 
		when [media_types]= '[4]' then 'Social' 
		when [media_types]= '[6]' then 'Push' 
		when [media_types]= '[8]' then 'Whatsapp' 
		else null end as media_type
,[media_type_id]
,[template_name]
,[thumbnail_url]
,[front_html_content]
,[middle_html_content]
,[rear_html_content]
,[template_json]
,[target_audience]
,[from_email]
,[print_postage_type]
,[postcard_thumbnail_url]
,[letter_thumbnail_url]
,[trifold_thumbnail_url]
,[preview_text]
,is_deleted
,created_by
,updated_by
,created_dt
,updated_dt

from [3.21.66.39].clictell_cm.[template].[template] with (nolock) 
where account_id='051F6F9E-54AD-4F18-B69B-03DB9F383775'  


select * from [3.21.66.39].clictell_cm.[media].[category] with (nolock) 
select * from [3.21.66.39].clictell_cm.[media].[category_type] with (nolock) 
select * from [3.21.66.39].clictell_cm.[admin].[media_type] with (nolock) 
select * from [3.21.66.39].clictell_cm.[program].[media_type] with (nolock) 
select * from [3.21.66.39].clictell_cm.[program].[program] with (nolock) 
select * from [3.21.66.39].clictell_cm.[program].[program_type] with (nolock) 
select * from [3.21.66.39].clictell_cm.[template].[digital_media]  with (nolock) 




insert into auto_customers.customer.customers
(
account_id
,account_status
,account_type
,address_line
,address_line2
,addresses
,anniversary
,ar_status_flag
,birth_date
,block_data_share
,channel_code
,check_sum
,churn_score
,city
,comments
,company_name
,cost
,country
,country_code
,county
,created_by
,created_dt
,custom_fields
,dealer_loyalty_indicator
,del_cde_service_names
,delete_code
,do_not_sms
,employer_name
,error_code
,fcm_token
,first_name
,fleet_flag
,from_landing_page
,full_name
,group_code
,ins_agent_name
,ins_agent_phone
,ins_company_name
,ins_policy_no
,is_deleted
,is_email_bounce
,is_subscriber
,is_unsubscribed
,is_welcome_email_sent
,is_welcome_sms_sent
,job_title
,last_name
,lead_call_status_id
,lead_source_id
,lead_status_id
,list_id
,middle_name
,name_type_id
,notes
,organization_id
,pages_list
,parent_type
,parts_type
,party_id
,phone_numbers
,platform_type
,preferred_demo_product_c
,price_code
,primary_email
,primary_email_desc
,primary_email_valid
,primary_phone_number
,primary_phone_number_desc
,primary_phone_number_extension
,primary_phone_number_valid
,privacy_ind
,privacy_type
,prospect
,prospect_type
,residency
,residency_month
,residency_year
,ro_price_code
,schedule_code
,secondary_email
,secondary_email_desc
,secondary_phone_number
,secondary_phone_number_desc
,secondary_phone_number_extension
,segment_list
,service_status_id
,signup_source_id
,social_profiles
,state
,state_code
,suffix
,tags
,tax_code
,taxability
,title
,type_provider_id
,update_password
,updated_by
,updated_dt
,user_id
,user_type_id
,website_text_area
,websites
,zip
,zip_valid
,src_cust_id
)
select  
'81984ea2-27ad-45f7-b28a-bf4fcdf8c8c0' as account_id
,account_status
,account_type
,address_line
,address_line2
,addresses
,anniversary
,ar_status_flag
,birth_date
,block_data_share
,channel_code
,check_sum
,churn_score
,city
,comments
,company_name
,cost
,country
,country_code
,county
,created_by
,created_dt
,custom_fields
,dealer_loyalty_indicator
,del_cde_service_names
,delete_code
,is_phone_suppressed
,employer_name
,error_code
,fcm_token
,fisrt_name
,fleet_flag
,from_landing_page
,full_name
,group_code
,ins_agent_name
,ins_agent_phone
,ins_company_name
,ins_policy_no
,is_deleted
,is_email_bounce
,is_subscriber
,is_unsubscribed
,is_welcome_email_sent
,is_welcome_sms_sent
,job_title
,last_name
,lead_call_status_id
,lead_source_id
,lead_status_id
,list_id
,middle_name
,name_type_id
,notes
,organization_id
,pages_list
,parent_type
,parts_type
,party_id
,phone_numbers
,platform_type
,preferred_demo_product_c
,price_code
,primary_email
,primary_email_desc
,primary_email_valid
,primary_phone_number
,primary_phone_number_desc
,primary_phone_number_extension
,primary_phone_number_valid
,privacy_ind
,privacy_type
,prospect
,prospect_type
,residency
,residency_month
,residency_year
,ro_price_code
,schedule_code
,secondary_email
,secondary_email_desc
,secondary_phone_number
,secondary_phone_number_desc
,secondary_phone_number_extension
,segment_list
,service_status_id
,signup_source_id
,social_profiles
,state
,state_code
,suffix
,tags
,tax_code
,taxability
,title
,type_provider_id
,update_password
,updated_by
,updated_dt
,user_id
,user_type_id
,vehicle_type
,websites
,zip
,zip_valid
,customer_id

from [3.21.66.39].clictell_customer.[customer].[customer]  with (nolock) where account_id = '051F6F9E-54AD-4F18-B69B-03DB9F383775'  

select top 10 _id,* from auto_customers.customer.customers (nolock)

[customer].[customer_segment]
[customer].[customer_file]



select r2r_customer_id,src_cust_id 
--update a set src_cust_id = null
from auto_customers.customer.customers a (nolock) where account_id = '81984ea2-27ad-45f7-b28a-bf4fcdf8c8c0' and is_deleted = 0


select top 10 * from [3.21.66.39].clictell_customer.[customer].[customer]  with (nolock) where account_id = '051F6F9E-54AD-4F18-B69B-03DB9F383775'  and is_deleted =1
select src_cust_id,r2r_customer_id,list_id,list_ids,* 

update a set list_ids = '-1,3587,'
from auto_customers.customer.customers a (nolock) where is_deleted =0 and account_id = '81984ea2-27ad-45f7-b28a-bf4fcdf8c8c0' 

select * from auto_customers.list.lists (nolock) where account_id = '81984ea2-27ad-45f7-b28a-bf4fcdf8c8c0' and list_id = 3587
select * from auto_customers.list.lists (nolock) where account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and list_id = 3587

insert into auto_customers.list.lists
(
account_id
,list_type_id
,list_name
,program_id
,list_status_id
,tag_name
,tag_desc
,list_path
)
select 
'81984ea2-27ad-45f7-b28a-bf4fcdf8c8c0' as account_id
,3 as list_type_id
,'New Inserted' as list_name
,3 as program_id
,2 as list_status_id
,'New Inserted' as tag_name
,'New Inserted' as tag_desc
,'' as list_path


from auto_customers.list.lists (nolock) where account_id = '81984ea2-27ad-45f7-b28a-bf4fcdf8c8c0' 


select count(*) 

from auto_customers.customer.customers a (nolock)
inner join [3.21.66.39].clictell_customer.[customer].[customer]  b with (nolock) on a.primary_phone_number = b.primary_phone_number and a.primary_email = b.primary_email
where 
	a.account_id = '81984ea2-27ad-45f7-b28a-bf4fcdf8c8c0' 
	and b.account_id = '051F6F9E-54AD-4F18-B69B-03DB9F383775'
	and b.is_deleted = 1
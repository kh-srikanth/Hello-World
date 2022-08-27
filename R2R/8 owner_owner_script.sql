Use auto_customers
GO

Insert into customer.customers
(
 	  customer_guid
	, type_provider_id
	, account_id
	, party_id
	, user_id
	, update_password
	, error_code
	, check_sum
	, first_name
	, middle_name
	, last_name
	, suffix
	, title
	, full_name
	, company_name
	, name_type_id
	, address_line
	, city
	, county
	, state
	, state_code
	, country
	, country_code
	, zip
	, zip_valid
	, primary_phone_number
	, primary_phone_number_extension
	, primary_phone_number_desc
	, primary_phone_number_valid
	, secondary_phone_number
	, secondary_phone_number_extension
	, secondary_phone_number_desc
	, primary_email
	, primary_email_desc
	, primary_email_valid
	, secondary_email
	, secondary_email_desc
	, ar_status_flag
	, parts_type
	, price_code
	, ro_price_code
	, tax_code
	, group_code
	, schedule_code
	, taxability
	, birth_date
	, employer_name
	, privacy_ind
	, privacy_type
	, block_data_share
	, prospect
	, prospect_type
	, fleet_flag
	, ins_agent_name
	, ins_agent_phone
	, ins_company_name
	, ins_policy_no
	, del_cde_service_names
	, delete_code
	, dealer_loyalty_indicator
	, list_id
	, pages_list
	, do_not_email
	, do_not_sms
	, do_not_phone
	, do_not_whatsapp
	, is_subscriber
	, job_title
	, anniversary
	, custom_fields
	, websites
	, social_profiles
	, phone_numbers
	, addresses
	, segment_list
	, tags
	, signup_source_id
	, fcm_token
	, platform_type
	, churn_score
	, is_unsubscribed
	, is_email_bounce
	, account_type
	, parent_type
	, account_status
	, channel_code
	, _id
	, notes
	, comments
	, is_welcome_email_sent
	, is_deleted
	, created_dt
	, created_by
	, updated_dt
	, updated_by
	, lead_status_id
	, lead_source_id
	, lead_call_status_id
	, preferred_demo_product_c
	, address_line2
	, cost
	, residency
	, residency_year
	, residency_month
	, user_type_id
	, service_status_id
	, organization_id
	, is_welcome_sms_sent
	, is_unsubscribed_reason_id
	, is_unsubscribed_reason
	, whats_app_valid
	, whats_app_id
	, whats_app_status
	, whats_app_last_checked_dt
	, demo_complete__c
	, last_status_updated_date
	, reason_for_missed_demo__c
	, connection_received_id
	, call_record_url
	, do_not_mail
	, list_ids
	, from_landing_page
	, bdc_status_id
	, is_ncoa_required
	, is_data_cleansing_required
	, is_call_recording_enabled
	, is_bdc
	, r2r_customer_id
)
select 
	  newid() as customer_guid
	, null as type_provider_id -- need to check the column
	, b._id as account_id
	, null as party_id
	, null as [user_id]
	, null as update_password
	, null as error_code
	, null as check_sum
	, a.fname as first_name
	, null as middle_name
	, a.lname as last_name
	, null as suffix
	, null as title
	, a.fname + ' ' + a.lname as full_name
	, null as company_name --  need to check the organization column from source
	, null as name_type_id
	, a.address1 as address_line
	, a.city
	, null as county
	, a.state
	, a.state as state_code
	, null as country
	, null as country_code
	, a.zip
	, null as zip_valid
	, a.mobile as primary_phone_number
	, null as primary_phone_number_extension
	, null as primary_phone_number_desc -- need to check this colummnn related to default value Mobile
	, a.mobile_valid
	, a.phone as secondary_phone_number
	, null as secondary_phoen_number_extension
	, null as secondary_phoen_number_desc
	, email as primary_email
	, null as primary_email_desc
	, a.email_valid as primary_email_valid
	, null as secondary_email
	, null as secondary_email_desc
	, null as ar_status_flag
	, null as parts_type
	, null as price_code
	, null as ro_price_code
	, null as tax_code
	, null as group_code
	, null as schedule_code
	, null as taxability
	, a.birth_day
	, null as employer_name
	, null as privacy_ind -- need to check is_private_profile
	, null as privacy_type
	, null as block_data_share
	, null as propect
	, null as propect_type
	, null as fllet_flag
	, null as ins_agent_name
	, null as ins_agent_phone
	, null as ins_icompany_name
	, null as ins_policy_no
	, null as del_code_service_names
	, null as delete_code
	, null as dealer_loyality_indicator
	, null as list_id
	, a.pages_list
	, 0 as do_not_email
	, 0 as do_not_sms
	, 0 as do_not_phone
	, 0 as do_not_whatsapp
	, 0 as is_subscriber
	, null as job_title
	, null as anniversary
	, null as custom_fields
	, null as websites
	, null as social_profiles
	, null as phone_numbers
	, null as addresses
	, dbo.fn_CoalesceConcat(a.contact_list_ids) as segment_list
	, null as tags
	, null as signup_source_id
	, null as fcm_token
	, null as platform_type
	, null churn_score
	, 0 as is_unsubscribed
	, 0 is_email_bounce
	, null as account_type
	, null as parent_type
	, null as account_status
	, null as channel_code
	, null as _id
	, a.notes
	, a.comments
	, 0 as is_welcome_email_sent
	, a.is_deleted
	, a.created_dt
	, a.created_by 
	, a.updated_dt
	, Isnull(a.updated_by, 'sa')
	, 0 as lead_status_id
	, null as lead_source_id
	, null as lead_call_status_id
	, null as preferred_demo_product_c
	, a.address2  as address_line2
	, null as cost
	, null as residency
	, null as residency_year
	, null as residency_month
	, null as user_type_id
	, null as service_status_id
	, null as organization_id
	, 0 as is_welcome_sms_sent
	, 0 as is_unsubscribed_reason_id
	, 0 as is_unsubscribed_reason
	, null as whats_app_valid
	, null as whats_app_id
	, null as whats_app_status
	, null as whats_app_last_checked_dt
	, null as demo_complete__c
	, null as last_status_updated_date
	, null as reason_for_missed_demo__c
	, null as connection_received_id
	, null as call_record_url
	, 0 as do_not_mail
	, [dbo].[fn_CoalesceList](a.contact_list_ids) as list_ids
	, null as from_landing_page
	, null as bdc_status_id
	, null as is_ncoa_required
	, null as is_data_cleansing_required
	, null as is_call_recording_enabled
	, null as is_bdc
	, owner_id as r2r_customer_id
from [18.216.140.206].[r2r_admin].[owner].[owner] a
inner join auto_portal.portal.account b on a.dealer_id = b.r2r_dealer_id
where a.dealer_id in (48625, 2990, 2991)
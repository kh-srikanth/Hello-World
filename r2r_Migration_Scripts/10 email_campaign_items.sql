Use auto_campaigns
GO

------------- Email Insert
Insert into email.campaign_items
(
	  campaign_item_guid
	, campaign_id
	, list_member_id
	, aws_message_id
	, email_address
	, first_name
	, last_name
	, salutation
	, address
	, city
	, state
	, zip_code
	, phone
	, service_advisor
	, vin
	, make
	, model
	, year
	, actual_mileage
	, predictive_mileage
	, purchase_date
	, last_service_date
	, browser_type_id
	, device_type_id
	, status_type_id
	, is_sent
	, is_delivered
	, is_opened
	, is_unsubscribed
	, is_bounced
	, is_suppressed
	, is_clicked
	, is_failed
	, propensity_score
	, flow_id
	, is_deleted
	, created_dt
	, created_by
	, updated_dt
	, updated_by
	, bounce_type
	, is_seed
	, r2r_campaignitem_id
)
select 
	  a.campaign_item_guid 
	, c.campaign_id
	, d.customer_id
	, null as aws_message_id
	, a.email_address
	, a.first_name
	, a.last_name
	, a.salutation
	, a.address
	, a.city
	, a.state
	, a.zip_code
	, a.phone
	, a.service_advisor
	, a.vin
	, a.make
	, a.model
	, a.[year]
	, a.actual_mileage
	, a.predictive_mileage
	, a.purchase_date
	, a.last_service_date
	, a.browser_type_id
	, a.device_type_id
	, 0 as status_type_id --- need to check the value
	, a.is_sent
	, a.is_delivered
	, a.is_opened
	, a.is_unsubscribed
	, a.is_bounced
	, a.is_suppressed
	, a.is_clicked
	, 0 as is_failed
	, a.propensity_score
	, a.flow_id
	, a.is_deleted
	, a.created_dt
	, a.created_by
	, a.updated_dt
	, a.updated_by
	, null as bounce_type
	, 0 as is_seed
	, a.campaign_item_id
--into #temp_emailcampaign_items
from [18.216.140.206].[r2r_cm].[email].[campaign_item] a with (nolock)
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign_media] b with (nolock) on a.campaign_media_id = b.campaign_media_id
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign] e with (nolock) on b.campaign_id = e.campaign_id
inner join email.campaigns c with (nolock) on e.campaign_id = c.r2r_campaign_id
inner join auto_customers.customer.customers d with (nolock) on a.list_member_id = d.r2r_customer_id
left outer join email.campaign_items f with (nolock) on a.campaign_item_id = f.r2r_campaignitem_id and c.campaign_id = f.campaign_id
where e.dealer_id in (select r2r_dealer_id from auto_portal.portal.account with (nolock) where r2r_dealer_id is not null and lower(accountstatus) = 'active')
--and e.campaign_id in (7877) 
and f.campaign_item_id is null 
order by Created_dt
Use auto_campaigns
GO

------------- SMS Insert
Insert into sms.campaign_items
(
	campaign_item_guid
	, campaign_id
	, list_member_id
	, twilio_sid
	, phone_number
	, first_name
	, last_name
	, salutation
	, address
	, city
	, state
	, zip_code
	, country_code
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
	, status_type_id
	, is_sent
	, is_delivered
	, is_failed
	, delivery_status
	, err_message
	, cost
	, message_parts
	, status
	, status_code
	, network_code
	, retry_count
	, response
	, is_twilio_processed
	, is_deleted
	, created_dt
	, created_by
	, updated_dt
	, updated_by
	, flow_id
	, is_seed
	, appt_sch_dt
	, r2r_campaignitem_id
)
select 
	  newid() as campaign_item_guid
	, c.campaign_id
	, d.customer_id
	, a.twilio_sid
	, a.phone_number
	, a.first_name
	, a.last_name
	, a.salutation
	, a.address
	, a.city
	, a.state
	, a.zip_code
	, null as country_code
	, a.phone
	, a.service_advisor
	, a.vin
	, a.make
	, a.model
	, a.year
	, a.actual_mileage
	, a.predictive_mileage
	, a.purchase_date
	, a.last_service_date
	, 0 as status_type_id --  need to check
	, a.is_sent
	, a.is_delivered
	, a.is_failed
	, a.delivery_status
	, a.err_message
	, null as cost
	, null as message_parts
	, null as status -- need to check
	, null as status_code
	, null as network_code
	, null as retry_count
	, null as response
	, a.is_twilio_processed
	, a.is_deleted
	, a.created_dt
	, a.created_by
	, a.updated_dt
	, a.updated_by
	, Isnull(a.flow_id, 0) -- need to check
	, 0 as is_seed
	, null as appt_sch_dt
	, a.campaign_item_id
from [18.216.140.206].[r2r_cm].[sms].[campaign_item] a
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign_media] b on a.campaign_media_id = b.campaign_media_id
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign] e on b.campaign_id = e.campaign_id
inner join sms.campaigns c on e.campaign_id = c.r2r_campaign_id
inner join auto_customers.customer.customers d on a.list_member_id = d.r2r_customer_id
where e.dealer_id in (48625, 2990, 2991)



alter table auto_campaigns.email.campaigns add r2r_campaign_id int
alter table auto_campaigns.sms.campaigns add r2r_campaign_id int
alter table auto_campaigns.push.campaigns add r2r_campaign_id int
alter table auto_campaigns.social.campaigns add r2r_campaign_id int

alter table auto_campaigns.email.campaign_items add r2r_campaignitem_id int
alter table auto_campaigns.sms.campaign_items add r2r_campaignitem_id int
alter table auto_campaigns.push.campaign_items add r2r_campaignitem_id int
alter table auto_campaigns.social.campaign_items add r2r_campaignitem_id int

alter table auto_campaigns.social.social add r2r_social_id int

alter table auto_customers.[list].[lists] add r2r_custsegment_id int
alter table auto_customers.customer.segments add r2r_contactlist_id int
alter table customer.customers add r2r_customer_id int

alter table auto_media.[template].[templates] add r2r_template_id int

alter table auto_media.[media].[images] add r2r_image_id int



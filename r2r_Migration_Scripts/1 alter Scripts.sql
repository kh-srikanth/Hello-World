PostGreSqL Scripts

ALTER TABLE account ADD COLUMN r2r_dealer_id int;

use auto_campaigns
GO

alter table email.campaigns add r2r_campaign_id int
alter table sms.campaigns add r2r_campaign_id int
alter table push.campaigns add r2r_campaign_id int
alter table social.campaigns add r2r_campaign_id int

alter table email.campaign_items add r2r_campaignitem_id int
alter table sms.campaign_items add r2r_campaignitem_id int
alter table push.campaign_items add r2r_campaignitem_id int
alter table social.campaign_items add r2r_campaignitem_id int

alter table social.social add r2r_social_id int

alter table [list].[lists] add r2r_custsegment_id int

alter table auto_media.[template].[templates] add r2r_template_id int


use quto_customers
GO

alter table customer.segments add r2r_contactlist_id int
alter table customer.customers add r2r_customer_id int

alter table customer.vehicles add 
photo varchar(max),
photo_path varchar(max),
name varchar(100),
brand_id int,
model_id int,
identity_number varchar(100),
tire_size varchar(5),
tire_install_date date,
tire_pressure int,
riding_style_id int,
last_oil_change date,
is_default bit
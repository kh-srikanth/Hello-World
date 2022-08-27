use 

Insert into [PostgreSQL_Clictell].[clictell].[public].[account]
(
	  _id
	, accountname
	, accountstatus
	, accounttype
	, address1
	, address2
	, adminname
	, agentcode
	, agenttype
	, channelcode
	, city
	, country
	, createdate
	, decrypted
	, hostname
	, mailstatus
	, migration
	, parentid
	, parenttype
	, paymethod
	, phone
	, region
	, source
	, state
	, updatedate
	, updatetime
	, usermigration
	, additionalattributes
	, externalreferences
	, catalog_type
	, src_dealer_code
	, dms_type
	, email_address
	, amenities
	, longitude
	, latitude
	, gtag_id
	, standard_mail_class
	, requested_dropdate
	, dealername_on_card
	, enhanced_mail_class
	, zipcode
	, r2r_dealer_id
)
select 
	a.dealer_guid,
	a.dealer_name,
	'active' as accountstatus,
	'OEM' as accounttype,
	'' as address1,
	'' as address2,
	'' as adminname,
	'' as agentcode,
	'' as agenttype,
	'' as channelcode,
	'' as city,
	'US' as country,
	Cast(created_dt as date) as createddate,
	null as decrypted,
	null as hostname,
	null as mailstatus,
	null as migration,
	null as parentid,
	null as parenttype,
	null as paymethod,
	a.dealer_phone as phone,
	null as region,
	null as source,
	null as state,
	Cast(updated_dt as date) as updateddate,
	Cast(updated_dt as time) as updatedtime,
	null as usermigration,
	null as additionalattributes,
	null as externalreferences,
	null as category_type,
	a.acct_center_code as src_dealer_code,
	null as dms_type,
	null as email_address,
	null as amenities,
	a.dealer_longitude,
	a.dealer_latitude,
	null as gtagid,
	null as standard_mail_class,
	null as requested_dropdate,
	null as dealername_on_card,
	null as enhanced_mail_class,
	null as zipcode,
	a.dealer_id as r2r_dealer_id
from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) 
where dealer_id in (48625)
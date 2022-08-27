Use auto_media
GO


Insert into [media].[landing_pages]
(
	  landing_page_guid
	, account_id
	, user_id
	, status_type_id
	, landing_page_name
	, landing_page_desc
	, landing_page_url
	, landing_page_status
	, file_name
	, landing_page_tags
	, thumbnail_url
	, content_json
	, html_content
	, segment_id
	, content_url
	, is_default
	, is_deleted
	, created_by
	, created_dt
	, updated_by
	, updated_dt	
)
select 
	newid() as landing_page_guid
	, b._id as account_id
	, null as [user_id]
	, a.status_type_id -- need to check for Active status
	, a.landing_page_desc
	, a.landing_page_desc
	, a.landing_page_url
	, null as landing_page_status
	, a.file_name
	, a.landing_page_tags
	, a.thumbnail_url
	, a.content_json
	, null as html_content
	, null as segment_id
	, a.content_url
	, a.is_default
	, a.is_deleted
	, a.created_by
	, a.created_dt
	, a.updated_by
	, a.updated_dt
from [18.216.140.206].[r2r_cm].[media].[landing_page] a with (nolock)
inner join auto_portal.[portal].[account] b with (nolock) on a.dealer_id = b.r2r_dealer_id
where a.dealer_id in (48625, 2990, 2991)
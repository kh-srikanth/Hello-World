use auto_media
GO

Insert into [media].[images]
(
	  image_guid
	, account_id
	, user_id
	, image_size_id
	, program_id
	, image_type_id
	, lang_id
	, image_name
	, image_desc
	, image_url
	, image_size
	, image_format
	, thumbnail_url
	, edited_url
	, image_file_name
	, image_tags
	, channel_type_id
	, image_url_main
	, start_date
	, expiry_date
	, make
	, model
	, year
	, make_id
	, model_id
	, year_id
	, is_deleted
	, created_by
	, created_dt
	, updated_by
	, sort_id
	, updated_dt
	, parent_image_id
	, r2r_image_id
)
select 
	  a.digital_media_guid as image_guid
	, b._id as account_id
	, null as [user_id]
	, null as image_size_id
	, 3 as program_id
	, (Case when a.category_id = 190 then 1 else 0 end) as image_type_id
	, 1 as lang_id
	, a.digital_media_code as image_name
	, a.digital_media_desc as image_desc
	, a.media_url as image_url
	--, (Case when a.digital_media_size_id = 1 then '230pxX600px'
	--	    when a.digital_media_size_id = 2 then '260pxX540px'
	--	else '' end) as image_size
	, a.media_size
	, null as image_format
	, a.img_thumbnail
	, null as edited_url
	, a.[file_name]
	, a.digital_media_tags
	, 1 as channel_type_id
	, media_url_main
	, Cast(a.created_dt as date) as start_date
	, '2050-12-31' as expiry_date
	, null as make
	, null as model
	, null as [year]
	, null as make_id
	, null as model_id
	, null as [year_id]
	, a.is_deleted
	, a.created_by
	, a.created_dt
	, a.updated_by
	, null as sort_id
	, a.updated_dt
	, null as parent_image_id
	, a.digital_media_id
from [18.216.140.206].[r2r_cm].[media].[digital_media] a (nolock)
inner join auto_portal.[portal].[account]b with (nolock) on a.dealer_id = b.r2r_dealer_id
left outer join [media].[images] c with (nolock) on a.digital_media_id = c.r2r_image_id
where a.dealer_id in (select r2r_dealer_id from auto_portal.portal.account with (nolock) where r2r_dealer_id is not null and lower(accountstatus) = 'active')
--where a.dealer_id in (48625, 2990, 2991) 
and c.image_id is null

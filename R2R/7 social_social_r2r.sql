use auto_stg_campaigns
go

insert into [social].[social] 
(
dealer_id
,account_id
,social_type_id
,page_name
,page_id
,access_token
,acess_token_secret
,refresh_token
,token_updated_dt
,last_sync_date
,is_sync
,is_deleted
,created_dt
,created_by
,updated_dt
,updated_by
,last_token_updated_dt
,is_at_invalid
,last_renewal_mail_sent_dt


)

select 
	b.account_id as dealer_id
	,b._id as account_id --
	,(case  when  a.type_social_id =1 then 1 
			when  a.type_social_id =2 then 2
			when  a.type_social_id =3 then 3
			when  a.type_social_id =4 then 5
		end ) 	as social_type_id
	,a.page_name 
	,a.page_id
	,a.access_token
	,a.acess_token_secret
	,null as refresh_token
	,getdate() as token_update_dt-- column not in r2r social
	,getdate() as last_sink_date-- column not in r2r social
	,0 as is_sync
	,a.is_deleted
	,a.created_dt
	,a.created_by
	,a.updated_dt
	,a.updated_by
	,a.last_token_updated_dt
	,a.is_at_invalid
	,a.last_renewal_mail_sent_dt
from [18.216.140.206].[r2r_cm].[social].[social] a (nolock)  
inner join auto_portal.portal.account b (nolock)  on a.dealer_id =b.r2r_dealer_id
where a.dealer_id in (48625, 2990, 2991)
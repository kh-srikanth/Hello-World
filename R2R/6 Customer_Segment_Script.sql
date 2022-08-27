use auto_customers
GO

Insert into customer.segments
(
	 account_id
	, user_id
	, program_id
	, segment_type_id
	, segment_name
	, segment_description
	, segment_query
	, segment_json
	, query_operator
	, portal_name
	, is_dynamic
	, is_count_updated
	, total_count
	, is_deleted
	, created_dt
	, created_by
	, updated_dt
	, updated_by
	, list_type_id
	, is_campaign
	, r2r_contactlist_id
)
select 
	  b._id as account_id
	, null as [user_id]
	, 3 as program_d
	, 1 as segemtn_type_id -- need to check the column
	, a.list_name as segment_name
	, a.list_name as segment_description
	, a.segment_query
	, null as segmeent_json
	, a.segment_operator as query_operator
	, null as portal_name --  need to check the column
	, 0 as is_dynamic -- need to check the column
	, 0 as is_count_update -- need to check the column
	, 0 as total_count
	, a.is_deleted
	, a.created_dt
	, a.created_by
	, a.updated_dt
	, a.updated_by
	, null as list_type_id
	, 0 as is_campaign -- need to check
	, a.contact_list_id
from [18.216.140.206].[r2r_admin].[owner].[contact_list]  a with (nolock)
inner join auto_portal.portal.account b (nolock) on a.dealer_id = b.r2r_dealer_id
where a.dealer_id in (48625, 2990, 2991)




Insert into [list].[lists] 
(
	  list_guid
	, account_id
	, user_id
	, list_type_id
	, list_name
	, program_id
	, list_status_id
	, list_path
	, tag_name
	, tag_desc
	, accepted_count
	, rejected_count
	, total_count
	, expiry_date
	, file_name
	, is_deleted
	, created_by
	, created_dt
	, updated_by
	, updated_dt
	, is_campaign
	, dept_id
	, r2r_custsegment_id

)
select 
	  newid() as list_guid
	, b._id as account_id
	, null as [user_id]
	, 3 as list_type_id
	, a.list_name as list_name
	, 3 as program_id
	, 2 as list_status_id
	, '' as list_path
	, a.list_name as tag_name
	, a.list_name as tag_description
	, 0 as accepted_count
	, 0 as rejecrted_count
	, 0 as total_count
	, null as expiry_date
	, null as [file_name]
	, a.is_deleted
	, a.created_by
	, a.created_dt
	, a.updated_by
	, a.updated_dt
	, null as is_campaign
	, null as dept_id
	, a.contact_list_id
from [18.216.140.206].[r2r_admin].[owner].[contact_list]  a with (nolock)
inner join auto_portal.portal.account b (nolock) on a.dealer_id = b.r2r_dealer_id
where a.dealer_id in (48625, 2990, 2991)

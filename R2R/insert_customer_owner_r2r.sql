use [r2r_admin]

select
'insert into [customer].[r2r_customers_del] 
(

customer_guid
/*,account_id*/
,user_id
,first_name
,last_name
,company_name
,address_line
,city
,state
,zip
,zip_valid
,primary_phone_number
,primary_phone_number_valid
,secondary_phone_number
,primary_email
,primary_email_valid
,birth_date
,privacy_ind
,pages_list
,do_not_email
,do_not_sms
,notes
,comments
,is_deleted
,address_line2
,list_ids
,r2r_customer_id
,r2r_dealer_id
,created_by
,created_dt
,updated_by
,updated_dt
)  
values ('''

+ convert(varchar(40),owner_guid) + ''','''
--+ convert(varchar(50),isnull(b.dealer_guid,'')) + ''','''
+ convert(varchar(50),isnull(owner_user_id,'')) + ''','''
+ isnull(fname,'') + ''','''
+ isnull(lname,'') + ''','''
+ isnull(organization,'') + ''','''
+ isnull(address1,'') + ''','''
+ isnull(city,'') + ''','''
+ isnull(state,'') + ''','''
+ convert(varchar(20),isnull(zip,'')) + ''','''
+ convert(varchar(5),isnull(zip_valid,'')) + ''','''
+ convert(varchar(20),isnull(mobile,'')) + ''','''
+ convert(varchar(5),isnull(mobile_valid,'')) + ''','''
+ convert(varchar(20),isnull(phone,'')) + ''','''
+ isnull(email,'') + ''','''
+ convert(varchar(5),isnull(email_valid,'')) + ''','''
+ convert(varchar(20),isnull(convert(date,birth_day),'')) + ''','''
+ convert(varchar(20),isnull(is_private_profile,'')) + ''','''
+ convert(varchar(20),isnull(pages_list,'')) + ''','''
+ convert(varchar(20),isnull(is_email_list,'')) + ''','''
+ convert(varchar(20),isnull(is_sms_list,'')) + ''','''
+ isnull(notes,'') + ''','''
+ isnull(comments,'') + ''','''
+ convert(varchar(20),isnull(a.is_deleted,'')) + ''','''
+ isnull(address2,'') + ''','''
+ convert(varchar(20),isnull(list_id,'')) + ''','''
+ convert(varchar(20),owner_id) + ''','''
+ convert(varchar(20),a.dealer_id) + ''','''
+ convert(varchar(20),a.created_by) + ''','''
+ convert(varchar(20),a.created_dt) + ''','''
+ convert(varchar(20),a.updated_by) + ''','''
+ convert(varchar(20),a.updated_dt) + ''')'


--select  *
from [r2r_admin].[owner].[owner] (nolock) a
--inner join [r2r_portal].[portal].[dealer] (nolock) b on a.dealer_id = b.dealer_id 
where a.dealer_id = 48428 and owner_id not in ('842032')
--and convert(date,created_dt) between DATEFROMPARTS(2018,10,1) and eomonth(DATEFROMPARTS(2018,10,1))
--select * from [r2r_portal].[portal].[dealer] (nolock) where dealer_name like '%Freedom%'


select * from list.list (nolock)  where list_id = '3601'


use  [r2r_admin]
go

select * from owner.owner (nolock)
select * from [r2r_admin].[owner].[contact_list] (nolock) where cycleclick_segment_id is not null

select
'insert into [auto_stg_customers].[customer].[r2r_segments_del]
(
segment_name
,segment_query
,query_operator
,is_deleted
,created_dt
,created_by
,updated_dt
,updated_by
,r2r_dealer_id
,r2r_contact_list_id


)  
values ('''
+ convert(varchar(100),isnull(list_name,'')) + ''','''
+ convert(varchar(500),isnull(segment_query,'')) + ''','''
+ convert(varchar(50),isnull(segment_operator,'')) + ''','''
+ convert(varchar(50),isnull(is_deleted,'')) + ''','''
+ convert(varchar(50),isnull(created_dt,'')) + ''','''
+ convert(varchar(50),isnull(created_by,'')) + ''','''
+ convert(varchar(50),isnull(updated_dt,'')) + ''','''
+ convert(varchar(50),isnull(updated_by,'')) + ''','''
+ convert(varchar(50),isnull(dealer_id ,'')) + ''','''
+ convert(varchar(50),isnull(contact_list_id,'')) + ''')'




--select  *
from [r2r_admin].[owner].[contact_list] (nolock) 
where dealer_id  = '48428'
order by list_name
use r2r_admin
select * from cycle.cycle (nolock) where dealer_id  ='48428'
use r2r_cm
select * from social.social (nolock) 
select top 10 * from portal.dealer (nolock) where  dealer_id in (48490, 48630, 48629, 48428)

select * from social.type_social (nolock)
use [r2r_admin]
select * from cycle.category
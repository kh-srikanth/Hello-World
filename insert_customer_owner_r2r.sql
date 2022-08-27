use [r2r_admin]

select top 10
'insert into [customer].[customers] (

r2r_customer_id		
,customer_guid
,party_id
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
,created_by
,created_dt
,updated_by
,updated_dt

)  

values ('''

+ convert(varchar(20),owner_id) + ''','''
+ convert(varchar(100),owner_guid) + ''','''
+ convert(varchar(20),isnull(dealer_id,'')) + ''','''
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
+ convert(varchar(20),isnull(is_deleted,'')) + ''','''
+ isnull(address2,'') + ''','''
+ convert(varchar(20),isnull(list_id,'')) + ''','''
+ convert(varchar(50),SUSER_NAME()) + ''','''
+ convert(varchar(10),convert(date,GETDATE()))  + ''','''
+ convert(varchar(50),SUSER_NAME()) + ''','''
+ convert(varchar(10),convert(date,GETDATE())) + ''')'

from [r2r_admin].[owner].[owner]



--select owner_user_id from owner.owner



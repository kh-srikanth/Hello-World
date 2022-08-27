use [r2r_admin]

select --top 10
'insert into public.r2rcustomer_del (

	owner_guid 
	,owner_user_id
	,fname
	,lname 
	,organization 
	,address1
	,city 
	,state 
	,zip 
	,zip_valid 
	,mobile 
	,mobile_valid 
	,phone 
	,email 
	,email_valid 
	,birth_day 
	,is_private_profile 
	,pages_list 
	,is_email_list 
	,is_sms_list
	,notes 
	,comments
	,is_deleted
	,address2 
	,list_id 
	,owner_id 
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
+ convert(varchar(20),a.created_by) + ''','''
+ convert(varchar(20),a.created_dt) + ''','''
+ convert(varchar(20),a.updated_by) + ''','''
+ convert(varchar(20),a.updated_dt) + ''')'


--select top 10 *
from [r2r_admin].[owner].[owner] (nolock) a
--inner join [r2r_portal].[portal].[dealer] (nolock) b on a.dealer_id = b.dealer_id 
--where owner_id not in ('946146')

--use [r2r_portal]
--select top 10 * from [portal].[dealer] where dealer_id = 48570
select distinct convert(date,created_dt) from [r2r_admin].[owner].[owner] (nolock) a --order by convert(date,created_dt)
where convert(date,created_dt) between DATEFROMPARTS(2018,10,1) and eomonth(DATEFROMPARTS(2018,10,1))


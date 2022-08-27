use auto_customers
declare @account_id uniqueidentifier = 'de352067-1436-40b0-8ba4-86d036a3ce0d'

--create default lists if does'nt exists
--EXEC [customer].[insert_customer_default_lists_r2r]   @account_id

--Get Deafult list_id for the account_id
declare @sms_list_id int = (select list_id from list.lists (nolock) where is_deleted =0 and  account_id  = @account_id and is_default = 1 and list_name  = 'All SMS Subscribers')
declare @email_list_id int = (select list_id from list.lists (nolock) where is_deleted =0 and  account_id  = @account_id and is_default = 1 and list_name  = 'All Email Subscribers')
declare @app_list_id int = (select list_id from list.lists (nolock) where is_deleted =0 and  account_id  = @account_id and is_default = 1 and list_name  = 'All App Users')

declare @default_list_check varchar(500) = 'sms_list: ' + convert(varchar(100),@sms_list_id) + '  Email_list: ' + convert(varchar(100),@email_list_id) + '  App list: ' + convert(varchar(100),@app_list_id)

if (@default_list_check is null)
	select 'Default lists not present' as error
else
begin
	--update SMS LIST
	--select customer_id, list_ids,concat(list_ids,convert(varchar(100),@sms_list_id),',') as list_ids_update,created_dt,created_by,updated_dt,updated_by 
	update a set list_ids = concat(list_ids,convert(varchar(100),@sms_list_id),',')
	from customer.customers a (nolock) where is_deleted =0 and 
	account_id  = @account_id
	and (primary_phone_number_valid =1 or secondary_phone_number_valid=1 )
	and isnull(do_not_sms,1) =0 and list_ids not like '%,'+convert(varchar(100),@sms_list_id)+',%'

	--update EMAIL LIST
	--select customer_id, list_ids,concat(list_ids,convert(varchar(100),@email_list_id),',') as list_ids_update,created_dt,created_by,updated_dt,updated_by 
	update a set list_ids = concat(list_ids,convert(varchar(100),@email_list_id),',')
	from customer.customers a (nolock) where is_deleted =0 and 
	account_id  = @account_id
	and  isnull(a.is_email_bounce,0) =0 
	and primary_email_valid = 1
	and isnull(do_not_Email,1) =0
	and list_ids not  like '%,'+convert(varchar(100),@email_list_id)+',%'

	--update APP LIST
	--select customer_id, list_ids,concat(iif(len(list_ids)=0,'-1,',list_ids),convert(varchar(100),@app_list_id),',') as list_ids_update,created_dt,created_by,updated_dt,updated_by 
	update a set list_ids = concat(iif(len(list_ids)=0,'-1,',list_ids),convert(varchar(100),@app_list_id),',')
	from customer.customers a (nolock) where is_deleted =0 and 
	account_id  = @account_id
	and isnull(a.is_app_user,0) = 1
	and list_ids not like '%,'+convert(varchar(100),@app_list_id)+',%'
end



/*--validate lists for clic2mail


select * from auto_customers.customer.customers (nolock) where account_id  = '551302c9-3ec8-4fb3-be67-e9c4a0ecee00' and is_deleted =0


select 
primary_email,primary_email_valid,primary_phone_number,primary_phone_number_valid,secondary_phone_number,secondary_phone_number_valid


select 
customer_id
from auto_customers.customer.customers a (nolock) 
where account_id  = '551302c9-3ec8-4fb3-be67-e9c4a0ecee00' and is_deleted =0
and(primary_email_valid =1 or primary_phone_number_valid =1 or secondary_phone_number_valid =1)
and do_not_email =0 and isnull(is_email_bounce,0) =0 

select * from auto_customers.list.lists (nolock) where is_deleted =0 and is_Default =1 and account_id  = '551302c9-3ec8-4fb3-be67-e9c4a0ecee00' 



select customer_id
from auto_customers.customer.customers a (nolock) 
where account_id  = '551302c9-3ec8-4fb3-be67-e9c4a0ecee00' and is_deleted =0
and list_ids like '%,3032,%'


select customer_id
from auto_customers.customer.customers a (nolock) 
where account_id  = '551302c9-3ec8-4fb3-be67-e9c4a0ecee00' and is_deleted =0
and list_ids like '%,3033,%'


select 
customer_id
from auto_customers.customer.customers a (nolock) 
where account_id  = '551302c9-3ec8-4fb3-be67-e9c4a0ecee00' and is_deleted =0
and(primary_phone_number_valid =1 or secondary_phone_number_valid =1)
and do_not_sms =0



select * from auto_customers.list.lists (nolock) where is_deleted =0 and account_id  = '551302c9-3ec8-4fb3-be67-e9c4a0ecee00' and list_name like 'may25'


select customer_id
from auto_customers.customer.customers a (nolock) 
where account_id  = '551302c9-3ec8-4fb3-be67-e9c4a0ecee00' and is_deleted =0
and list_ids like '%,3017,%'



select * 
from auto_customers.customer.customers a (nolock)  where primary_email = 'dracoska@gmail.com'
and account_id  = '551302c9-3ec8-4fb3-be67-e9c4a0ecee00' and is_deleted =0
and list_ids like '%,3032,%'


select * 
from auto_customers.customer.customers a (nolock)  where account_id  = '551302c9-3ec8-4fb3-be67-e9c4a0ecee00' and is_deleted =0
and list_ids like '%,3032,%' and is_subscriber =1

select * 
from auto_customers.customer.customers a (nolock)  where customer_id in (3623761,3429286
,3429320
,3429354
,3429371
,3429377
,3429381
,3429406)*/
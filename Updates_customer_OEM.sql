select * from auto_customers.list.lists (nolock) where list_name like 'kin%' and is_deleted =0
'933BF385-6423-43B6-B1DE-866C7A38B12C'	--DealerAccounts
'c994b4f4-666e-446b-9a2f-c4985ebea150' --ready2rideMobile
select * from clictell_auto_master.master.dealer (nolock) where _id ='933BF385-6423-43B6-B1DE-866C7A38B12C'

select count(*) from auto_customers.customer.customers (nolock) where account_id = 'c994b4f4-666e-446b-9a2f-c4985ebea150'--20586 --and is_deleted =0 and list_ids like '%,798,%' and do_not_sms =0 and is_email_bounce=0
select count(*) from auto_customers.customer.vehicles (nolock) where account_id = '933BF385-6423-43B6-B1DE-866C7A38B12C'--12696 --and is_deleted =0 
select count(*) from auto_customers.list.lists (nolock) where account_id = '933BF385-6423-43B6-B1DE-866C7A38B12C' --66
select count(*) from auto_customers.customer.segments (nolock) where account_id = '933BF385-6423-43B6-B1DE-866C7A38B12C' --66


--select primary_email,
--update a set primary_email_valid=clictell_auto_etl.dbo.IsValidEmail(primary_email) 
--select replace(replace(replace(replace(replace(replace(primary_phone_number,' ',''),'-',''),'(',''),')',''),'.',''),',',''),
--update a set 
--primary_phone_number_valid	= iif(len(replace(replace(replace(replace(replace(replace(primary_phone_number,' ',''),'-',''),'(',''),')',''),'.',''),',','')) >=10,1,0)
--	--,replace(replace(replace(replace(replace(replace(secondary_phone_number,' ',''),'-',''),'(',''),')',''),'.',''),',',''),
--,secondary_phone_number_valid = iif(len(replace(replace(replace(replace(replace(replace(secondary_phone_number,' ',''),'-',''),'(',''),')',''),'.',''),',','')) >=10,1,0)
--from auto_customers.customer.customers a (nolock) where account_id = 'c994b4f4-666e-446b-9a2f-c4985ebea150'
--and list_ids like '%,798,%'


select len('17179438672')
select count(*) from auto_customers.customer.customers (nolock) where account_id = 'c994b4f4-666e-446b-9a2f-c4985ebea150' and is_deleted =0 and list_ids like '%,798,%' and isnull(do_not_email,0) =0 and is_email_bounce =0 and (do_not_sms =0 or do_not_mail=0 or do_not_email=0)
and do_not_sms =0 and is_email_bounce=0
--37429
--update auto_customers.customer.customers set account_id = 'c994b4f4-666e-446b-9a2f-c4985ebea150' where account_id = '933BF385-6423-43B6-B1DE-866C7A38B12C'
--update auto_customers.customer.vehicles set account_id = 'c994b4f4-666e-446b-9a2f-c4985ebea150' where account_id = '933BF385-6423-43B6-B1DE-866C7A38B12C'
--update auto_customers.list.lists set account_id = 'c994b4f4-666e-446b-9a2f-c4985ebea150' where account_id = '933BF385-6423-43B6-B1DE-866C7A38B12C'
--update auto_customers.customer.segments set account_id = 'c994b4f4-666e-446b-9a2f-c4985ebea150' where account_id = '933BF385-6423-43B6-B1DE-866C7A38B12C'

--select primary_email,
--update a set
--primary_email_valid=clictell_auto_etl.dbo.IsValidEmail(primary_email)
----,primary_phone_number
--,primary_phone_number_valid = iif(len(trim(primary_phone_number)) =10,1,0)
----,secondary_phone_number
--,secondary_phone_number_valid = iif(len(trim(secondary_phone_number)) =10,1,0)
select *
from auto_customers.customer.customers a (nolock) where
account_id = 'de352067-1436-40b0-8ba4-86d036a3ce0d'
and is_deleted =0
and ((do_not_email =0 and is_email_bounce =0) or do_not_sms =0 or do_not_mail =0)
and (primary_email_valid =1 or primary_phone_number_valid =1 or secondary_phone_number_valid =1)
and list_ids like '%2312%'


exec [customer].[query_segment_get] 
@account_id='DE352067-1436-40B0-8BA4-86D036A3CE0D',
@segmant_query=N'{"queries":[{"element":"City","operator":"contains","secondOperator":"","value":"New","match":"","elementTypeId":1,"order":1}]}',
@operator=N'or',@page_no=1,@page_size=20,@sort_column=N'UpdatedDate',@sort_order=N'desc',@search=N'',@list_type_id=3

for list_id =2312 in QAProd (account_id : 'DE352067-1436-40B0-8BA4-86D036A3CE0D')
1.list_ids are creating without ',' and -1
2.addresses JSON column is not populating
3.primary_email_valid, primary_phone_number_valid,secondary_phone_valid are not populating

			select a.first_name,a.last_name,a.state,a.city,zip from 
			auto_customers.customer.customers a with (nolock)    
			left outer join auto_customers.customer.vehicles b with (nolock) on a.customer_id = b.customer_id and b.is_deleted = 0 and is_valid_vin = 1
			left outer join auto_crm.[lead].appointments d (nolock) on a.customer_id = d.customer_id and d.[status] in ('Appointment Reschedule','Appointment Reschedule')
			where     
				a.is_deleted = 0 
			and a.account_id = 'de352067-1436-40b0-8ba4-86d036a3ce0d'  
			and Isnull(is_unsubscribed, 0) = 0
			and Isnull(a.fleet_flag, 0) = 0
			and (a.primary_phone_number_valid = 1 or a.Secondary_Phone_number_valid = 1 or Primary_email_valid = 1)
			and (do_not_email =0 or do_not_sms=0 or do_not_mail =0)
			--and make = 'Honda'
			and a.city = 'New jersy'

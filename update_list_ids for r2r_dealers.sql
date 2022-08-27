---Get account_ids which don't have proper list_ids
		select 
			account_id, count(customer_id)
		from auto_customers.customer.customers a (nolock) 
		where
			 is_deleted =0 
			 and list_ids not like '-1,%'
		group by account_id
		
		
select * from auto_customers.portal.account with (nolock) where _id =  '2AB7B512-7D61-4C6D-8AED-710075AA6306' 
	
----update list_ids with -1 in starting to '-1,'
		select 
			list_ids,replace(list_ids,'-1','-1,'), customer_id

			--update a set list_ids = replace(list_ids,'-1','-1,')
		from auto_customers.customer.customers a (nolock) 
		where
			 is_deleted =0 
			 and account_id =  '2AB7B512-7D61-4C6D-8AED-710075AA6306'
			 and list_ids not like '-1,%'


----Find default list_ids 
	 select * from auto_customers.list.lists (nolock) where account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and is_default = 1


------Update email subscriber lists

	 	 select 
			list_ids,concat(list_ids,'3459,'),*
		--update a set list_ids --= concat(list_ids,'3459,')
		from auto_customers.customer.customers a (nolock) 
		where
			 is_deleted =0 
			 and account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244'
			 and primary_email_valid=1 and isnull(is_email_bounce,0) = 0
 			 and isnull(do_not_email,1) = 0
			 and list_ids not like '%,3459,%'

------update sms subscribers lists


		select 
		list_ids,concat(list_ids,'3457,'),*
		--update a set list_ids = concat(list_ids,'3457,')
		from auto_customers.customer.customers a (nolock) 
		where
			 is_deleted =0 
			 and account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244'
			 and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1)
 			 and isnull(do_not_sms,1) = 0
			 and list_ids not like '%,3457,%'

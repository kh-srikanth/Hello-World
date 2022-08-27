use clictell_auto_master
'c994b4f4-666e-446b-9a2f-c4985ebea150'
select * from clictell_auto_master.master.dealer (nolock) where dealer_name like '%Smoky%'
select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where accountname like '%Smoky%' --2990 '7DB79611-A797-4938-AAC8-F3A887384304' --Duplicates deleted
select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where accountname like '%Indianapolis%' -- 'EF42DEF6-DA60-4632-B879-B01B26CDE74A'
select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where accountstatus='active' and accountname like 'Rexburg Motorsports'  --'A1478891-4F48-4B55-9D64-B5FB5B99B1EF'
select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where accountstatus='active' and accountname like 'Cycle Design' --'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A'
select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where accountstatus='active' and accountname like 'Southern Devil Harley Davidson' -- '96DBF74D-C8BD-459B-B751-B93F961EF884'
select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where accountstatus='active' and accountname like 'Greeley Harley Davidson' --'6B9537BD-115F-4019-B3AA-7F981EC69559'
select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where accountstatus='active' and accountname like 'Velocity Cycles' --'F0590E45-19AA-4597-A2B5-67553DD7B113'48755
select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where accountname like '%black jack%'  --'9A9AC801-A7EE-40FB-99DA-B80F552A3A61'2999
select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where accountname like '%Southern Devil Harley Davidson%' --48570 '96DBF74D-C8BD-459B-B751-B93F961EF884'
select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where accountname like '%Cycle Design%' and accountstatus = 'active' --4382 '3822DF16-C38D-4280-AB89-0304B430E3C3'
select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where accountname like '%CycleDesign%' and accountstatus = 'active' --4382 '3822DF16-C38D-4280-AB89-0304B430E3C3'
select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where accountname like '%Wild%' and accountstatus = 'active'--'82abf13b-b9c9-4bab-b883-7613e964a1eb'


select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where r2r_dealer_id = 4035
select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where _id='C994B4F4-666E-446B-9A2F-C4985EBEA150'

select dealer_id,* from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) where dealer_name like '%Smoky Mountain%' --2990 --Completed**
select dealer_id,* from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) where dealer_name like '%Indianapolis%' --48878 Completed (Purna)**
select dealer_id,* from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) where dealer_name like 'Rexburg Motorsports' and is_deleted =0 --48884 -- Completed (Santosh)**
select dealer_id,* from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) where dealer_name like '%Cycle Design%' --48829**
select dealer_id,* from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) where dealer_name like 'Southern Devil Harley Davidson' and is_deleted =0 --48570 Completed (Srikanth)**
select dealer_id,* from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) where dealer_name like 'Greeley Harley Davidson' and is_deleted =0 --48752**
select dealer_id,* from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) where dealer_name like 'Velocity Cycles%' and is_deleted =0 --48755**
select dealer_id,* from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) where dealer_name like 'wild%' and is_deleted =0 --2991


select dealer_id,* from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) where dealer_name like 'black%' and is_deleted =0 and dealer_id =2999 --2991

select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where r2r_dealer_id in (48878,48884,48829,48570,48752,48755) and accountstatus = 'active'
(2990,48878,48884,48829,48570,48752,48755) 


select top 10 * from auto_customers.customer.customers (nolock) 





select * from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) where dealer_name like '%Kodak%'
select * from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) where dealer_name like '%Rocky%'
select * from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) where dealer_name like 'Wild %' and is_deleted =0
--New dealers
select * from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) where dealer_name like 'Hot%' and is_deleted =0
select * from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) where dealer_name like 'Williams %' and is_deleted =0
select * from [18.216.140.206].[r2r_portal].portal.dealer a with (nolock) where dealer_name like 'Garden %' and is_deleted =0


Dealers Not found in [18.216.140.206].[r2r_portal].portal.dealer

Kodak Harley Davidson
Rocky Top Harley Davidson 
Wild West Motorsports
 
 --NEW Dealers-- These are also not found in portal.dealer table
 Hot Rod Harley Davidson
 Williams Harley Davidson
 Garden State Harley Davidson

 select top 10 * from auto_customers.customer.customers (nolock)

  select count(distinct r2r_customer_id)  from auto_customers.customer.customers (nolock) where account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and is_deleted =0 
  select count(distinct owner_id) from [18.216.140.206].[r2r_admin].owner.owner with (nolock) where dealer_id = 48884 and is_deleted =0 


  select owner_id,dealer_id,mobile,phone,email,created_dt from [18.216.140.206].[r2r_admin].owner.owner with (nolock) where dealer_id = 48884 and owner_id in(   1328722
,1328719
,1328716
,1328725
,1328717
,1328714
,1328723
,1328720
,1328726
,1328721
,1328718
,1328715
,1328724)



  select owner_id from [18.216.140.206].[r2r_admin].owner.owner with (nolock) where dealer_id = 48884 and is_deleted =0 
  except
  select r2r_customer_id from auto_customers.customer.customers (nolock) where account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and is_deleted =0 


 select r2r_customer_id from auto_customers.customer.customers (nolock) where account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and is_deleted =0 and do_not_email = 0 and is_email_bounce = 0
 except
 select owner_id from [18.216.140.206].[r2r_admin].owner.owner with (nolock) where dealer_id = 48884 and is_deleted =0 and is_email_suppressed = 0 and is_email_bounced =0
 
 
 select owner_id from [18.216.140.206].[r2r_admin].owner.owner with (nolock) where dealer_id = 48884 and is_deleted =0 and is_email_suppressed = 0 and is_email_bounced =0
   except
 select r2r_customer_id from auto_customers.customer.customers (nolock) where account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and is_deleted =0 and do_not_email = 0 and is_email_bounce = 0


 select r2r_customer_id from auto_customers.customer.customers (nolock) where account_id = '3822DF16-C38D-4280-AB89-0304B430E3C3' and is_deleted =0 and do_not_sms =0 order by r2r_customer_id desc
 select owner_id from [18.216.140.206].[r2r_admin].owner.owner with (nolock) where dealer_id = 48829 and is_deleted =0 and is_lime_opted_in =1 order by owner_id desc


 select count(*) from auto_customers.customer.customers (nolock) where account_id = '3822DF16-C38D-4280-AB89-0304B430E3C3' and is_deleted =0 and is_app_user =1 
 select count(*) from [18.216.140.206].[r2r_admin].owner.owner with (nolock) where dealer_id = 48829 and is_deleted =0 and is_app_user =1


 select top 10 * from [18.216.140.206].[r2r_admin].owner.owner with (nolock)


  select customer_id,first_name,last_name,primary_email,primary_phone_number,secondary_phone_number,is_email_bounce,do_not_email,do_not_sms,created_dt,updated_dt,is_deleted from auto_customers.customer.customers (nolock) where 
  account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and r2r_customer_id in (1328717)

  select owner_id, fname,lname,email,mobile,phone,is_email_suppressed,is_email_bounced,is_lime_opted_in,is_deleted from [18.216.140.206].[r2r_admin].owner.owner with (nolock) where 
  dealer_id = 48884 and owner_id in (1328717)


  

   select 
   a.r2r_customer_id , b.owner_id
   ,a.first_name , b.fname
   ,a.last_name , b.lname
   ,a.primary_email , b.email
   ,a.primary_phone_number , b.mobile
   ,a.secondary_phone_number , b.phone
   ,a.do_not_email , b.is_email_suppressed
   ,a.do_not_sms, case when b.is_lime_opted_in =1 then 0 else 1 end
   ,a.is_deleted , b.is_deleted
   ,a.is_app_user , b.is_app_user
   ,a.is_email_bounce , b.is_email_bounced
   --update  a set 
   --a.is_email_bounce = b.is_email_bounced
   --update a set 
   --   a.do_not_email = b.is_email_suppressed
   --update a set 
   --a.is_deleted = b.is_deleted
   --update a set
   --a.is_app_user = b.is_app_user
   --select count(*)
   --update a set 
   --a.do_not_sms = case when b.is_lime_opted_in =1 then 0 else 1 end
   from auto_customers.customer.customers a (nolock) 
   inner join [18.216.140.206].[r2r_admin].owner.owner b with (nolock) on a.r2r_customer_id = b.owner_id
   where a.account_id =  'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A'
   and b.dealer_id = 48829
   and a.is_deleted =0 and b.is_deleted =0
   --and isnull(a.is_app_user,0) <> b.is_app_user
   --and do_not_sms <> case when b.is_lime_opted_in =1 then 0 else 1 end
   and a.do_not_email <> b.is_email_suppressed
   and a.is_email_bounce <> b.is_email_bounced

   select count(*) from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where b.is_deleted =0 and dealer_id =48829
   select count(*) from auto_customers.customer.customers a (nolock)    where a.account_id = 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A' and is_deleted =0 

   select count(*) from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where b.is_deleted =0 and dealer_id =2990 and email is null and mobile is null and phone is null
  
  select * from auto_customers.customer.customers a (nolock)    where a.account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and is_deleted =0 
  and r2r_customer_id not in (select owner_id from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where b.is_deleted =0 and dealer_id =2990)

  select owner_id into #temp  from  [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where b.is_deleted =0 and dealer_id =2990 order by owner_id
   
   
   select * from auto_customers.customer.customers a (nolock)    where a.account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and is_deleted =0 	and r2r_customer_id in (860850)
	select * from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where b.is_deleted =0 and dealer_id =2990 and owner_id = 860850

	--update auto_customers.customer.customers  set is_deleted = 1 where account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and is_deleted =0 and r2r_customer_id in (860850)

		select * from [18.216.140.206].[r2r_admin].owner.contact_list with (nolock) where dealer_id = 48829 and is_deleted =0
		select * from auto_customers.list.lists (nolock) where account_id ='A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and is_deleted =0 --345 --1068 346 --1069 ,349--1101
		
		select count(*) from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where dealer_id =48829 and is_deleted =0 and contact_list_ids like '%,13613%'
		select count(*) from auto_customers.customer.customers (nolock) where account_id ='3822DF16-C38D-4280-AB89-0304B430E3C3' and is_deleted =0 and list_ids like '%,1446,%'


		select owner_id from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where dealer_id =48570 and is_deleted =0 and contact_list_ids like '%,13278%'
		EXCEPT
		select r2r_customer_id from auto_customers.customer.customers (nolock) where account_id ='96DBF74D-C8BD-459B-B751-B93F961EF884'and is_deleted=0  and list_ids like '%,1435,%'

		select r2r_customer_id from auto_customers.customer.customers (nolock) where account_id ='96DBF74D-C8BD-459B-B751-B93F961EF884'and is_deleted =0 and list_ids like '%,944,%'
		EXCEPT
		select owner_id from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where dealer_id =48570 and is_deleted =0 and contact_list_ids like '%,13353%'
		
		select r2r_customer_id from auto_customers.customer.customers (nolock) where account_id ='96DBF74D-C8BD-459B-B751-B93F961EF884'and is_deleted =0 and do_not_email =1
		except
		select count(r2r_customer_id) from auto_customers.customer.customers (nolock) where account_id ='96DBF74D-C8BD-459B-B751-B93F961EF884'and is_deleted =0 and list_ids like '%,944,%'

		select owner_id, fname,lname,email,mobile,phone,is_email_suppressed,is_email_bounced,is_lime_opted_in,is_deleted,contact_list_ids
		from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where dealer_id = 48829 and is_deleted =0 and owner_id in (1198270,1199535)

		select customer_id,first_name,last_name,primary_email,primary_phone_number,secondary_phone_number,is_email_bounce,do_not_email,do_not_sms,created_dt,updated_dt,is_deleted,list_ids
		from auto_customers.customer.customers (nolock) where account_id ='3822DF16-C38D-4280-AB89-0304B430E3C3' and is_deleted =0 and r2r_customer_id in (1198270,1199535)


		--update auto_customers.customer.customers  set list_ids = list_ids + ',944,' where account_id ='96DBF74D-C8BD-459B-B751-B93F961EF884' and is_deleted =0 and r2r_customer_id in (981238,966967)

	
	select owner_id from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where dealer_id = 2990 and is_deleted =0 
	and  contact_list_ids like '%,1069%' and is_lime_opted_in =1 
	except
	select r2r_customer_id from auto_customers.customer.customers (nolock) where account_id ='7DB79611-A797-4938-AAC8-F3A887384304' and is_deleted =0 
	and list_ids like '%,346,%' and do_not_sms =0
	
	select count(*) from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where dealer_id = 2990 and is_deleted =0 
	and  contact_list_ids like '%,1101%' -- and is_app_user =1
	except
	select count(*) from auto_customers.customer.customers (nolock) where account_id ='7DB79611-A797-4938-AAC8-F3A887384304' and is_deleted =0 
	and list_ids like '%,349,%' --and is_app_user =1




	select count(*) from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where dealer_id = 2990 and is_deleted =0 
	and  contact_list_ids like '%,1069%' and is_lime_opted_in =1 

	select * from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where dealer_id = 2990 and is_deleted =0 and owner_id in (1149671,1205688)

	select * from auto_customers.customer.customers (nolock) where account_id ='7DB79611-A797-4938-AAC8-F3A887384304' and is_deleted =0 
and r2r_customer_id in (1149671,1205688)

update auto_customers.customer.customers set list_ids = '-1,312,346,' where account_id ='7DB79611-A797-4938-AAC8-F3A887384304' and is_deleted =0 and r2r_customer_id in (1149671,1205688)

update auto_customers.customer.customers set list_ids = list_ids + ',' where account_id ='3822DF16-C38D-4280-AB89-0304B430E3C3' and is_deleted =0  and list_ids not like '%,'

select count(*) from auto_customers.customer.customers (nolock) where account_id ='3822DF16-C38D-4280-AB89-0304B430E3C3' and is_deleted =0 and list_ids not like '%,'





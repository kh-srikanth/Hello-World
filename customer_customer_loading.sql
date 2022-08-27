USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [etl].[CDK_Lite_Customer_Customers_loading]    Script Date: 1/3/2022 8:38:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [etl].[CDK_Lite_Customer_Customers_loading]
    @file_process_id int 
AS

/*
	exec  [etl].[load_cdk_lite_etl_customer] 1

	select * from [clictell_auto_etl].[etl].[cdkLgt_customer] a (nolock)
	select * from [auto_customers].[customer].[customers] (nolock) where account_id ='2FBFFF86-50E3-40F6-B59D-8335327E6BB1' order by src_cust_id
	----------------------------------------------------------------         
	MODIFICATIONS        
	Date			 Author			    Description          
	---------------------------------------------------------------        
	12/10/2021       Rajesh.m           Load customer Data 
	----------------------------------------------------------------      
				Copyright 2021 Clictell
*/        

BEGIN
	
	
	--drop table if exists #customer_customer
	--select * into #customer_customer from [auto_customers].[customer].[customers] (nolock)
/*
      Insert into [auto_customers].[customer].[customers]
              ( 
					src_cust_id
					,customer_guid
					,account_id
				   ,first_name
				   ,middle_name
				   ,last_name
				   ,full_name
				   ,company_name
				   ,address_line
				   ,city
				   ,county
				   ,state
				   ,country
				   ,zip
				   ,primary_phone_number
				   ,secondary_phone_number
				   ,primary_email
				   ,birth_date
				   ,do_not_email
				   ,do_not_sms
				   ,do_not_phone
				   ,do_not_whatsapp
				   ,do_not_mail
				   ,address_line2
				   ,notes
				   ,block_data_share
				   ,is_unsubscribed
				   ,is_email_bounce
				   ,is_welcome_email_sent
				   ,is_welcome_sms_sent
				   ,is_deleted
				   ,created_dt
				   ,updated_dt
				   ,created_by
				   ,updated_by
			   )

		select 
		          a.CustomerId
				 ,NEWID()
				 ,d._id as account_id
				 ,a.FirstName
                 ,a.MIddleName
                 ,a.LastName
                 ,a.CustFullName
                 ,a.Companyname
                 ,a.Address1
                 ,a.City
                 ,a.County
                 ,a.State
                 ,a.Country
                 ,a.Zip
                 ,a.CellPhone
                 ,a.HomePhone
                 ,a.EMail
                 ,a.Birthdate
				 ,case when a.optoutmarketing ='true' then 1 when a.optoutmarketing = 'false' then 0 end
				 ,case when a.optoutmarketing ='true' then 1 when a.optoutmarketing = 'false' then 0 end
				 ,case when a.optoutmarketing ='true' then 1 when a.optoutmarketing = 'false' then 0 end
				 ,case when a.optoutmarketing ='true' then 1 when a.optoutmarketing = 'false' then 0 end
				 ,case when a.optoutmarketing ='true' then 1 when a.optoutmarketing = 'false' then 0 end
                 ,a.Address2
				 ,a.attention
				 ,case when a.optoutsharedata = 'true' then 1 when a.optoutsharedata = 'false' then 0 end
				 ,case when a.optoutmarketing = 'true' then 1 when a.optoutmarketing = 'false' then 0 end
				 ,0
				 ,0
				 ,0
				 ,0
				 ,getdate()
				 ,getdate()
				 ,SUSER_NAME()
				 ,SUSER_NAME()
		from [clictell_auto_etl].[etl].[cdkLgt_customer] a (nolock)
		inner join clictell_auto_master.master.dealer d (nolock) on a.parent_dealer_id = d.parent_dealer_id
		left outer join [auto_customers].[customer].[customers] b(nolock) 
								on a.FirstName = b.first_name 
								and a.LastName = b.last_name
								and a.CellPhone = b.primary_phone_number
								and a.email = b.primary_email 
								and d._id  = b.account_id
		where 
				
				 b.customer_id is null
				 and file_process_id = @file_process_id

*/

    Insert into [auto_customers].[customer].[customers]
              ( 
					src_cust_id
					,customer_guid
					,account_id
				   ,first_name
				   ,middle_name
				   ,last_name
				   ,full_name
				   ,company_name
				   ,address_line
				   ,city
				   ,county
				   ,state
				   ,country
				   ,country_code
				   ,zip
				   ,zip_valid
				   ,primary_phone_number
				   ,primary_phone_number_desc
				   ,primary_phone_number_valid
				   ,secondary_phone_number
				   ,secondary_phone_number_desc
				   ,primary_email
				   ,primary_email_desc
				   ,primary_email_valid
				   ,phone_numbers
				   ,addresses
				   ,birth_date
				   ,do_not_email
				   ,do_not_sms
				   ,do_not_phone
				   ,do_not_whatsapp
				   ,do_not_mail
				   ,address_line2
				   ,notes
				   ,block_data_share
				   ,is_unsubscribed
				   ,is_email_bounce
				   ,is_welcome_email_sent
				   ,is_welcome_sms_sent
				   ,is_deleted
				   ,created_dt
				   ,updated_dt
				   ,created_by
				   ,updated_by
			   )


select 
		          a.CustomerId
				 ,NEWID() as customer_guid
				 ,d._id as account_id
				 ,a.FirstName
                 ,a.MIddleName
                 ,a.LastName
                 ,a.CustFullName
                 ,a.Companyname
                 ,a.Address1
                 ,a.City
                 ,a.County
                 ,a.State
                 ,a.Country
				 ,case when len(REPLACE(REPLACE(REPLACE(REPLACE(a.CellPhone,'(',''),' ',''),'-',''),')','')) > 10 then left(a.CellPhone,2) 
						when len(REPLACE(REPLACE(REPLACE(REPLACE(a.CellPhone,'(',''),' ',''),'-',''),')','')) <=10 and len(REPLACE(REPLACE(REPLACE(REPLACE(a.HomePhone,'(',''),' ',''),'-',''),')','')) > 10 then left(a.HomePhone,2)
						when len(REPLACE(REPLACE(REPLACE(REPLACE(a.CellPhone,'(',''),' ',''),'-',''),')','')) <=10 and len(REPLACE(REPLACE(REPLACE(REPLACE(a.HomePhone,'(',''),' ',''),'-',''),')','')) <=10 and len(REPLACE(REPLACE(REPLACE(REPLACE(a.WorkPhone,'(',''),' ',''),'-',''),')','')) >11 then left(a.WorkPhone,2)
						else '' end						as country_code
                 ,a.Zip
				 ,IIF(len(a.zip)>=5,'1','0') as zip_valid
                 ,REPLACE(REPLACE(REPLACE(REPLACE(a.CellPhone,'(',''),' ',''),'-',''),')','') as cellphone
				 ,'Mobile' as primary_phone_number_desc
				 ,IIF(len(REPLACE(REPLACE(REPLACE(REPLACE(a.CellPhone,'(',''),' ',''),'-',''),')','')) = 10, '1','0') as valid_primary_phone
                 ,REPLACE(REPLACE(REPLACE(REPLACE(a.HomePhone,'(',''),' ',''),'-',''),')','') as HomePhone
				 ,'HomePhone' as secondary_phone_number_desc
				 --,REPLACE(REPLACE(REPLACE(REPLACE(a.WorkPhone,'(',''),' ',''),'-',''),')','') as WorkPhone
                 ,trim(a.EMail) as Email
				 ,'' as primary_email_desc
				 ,IIF((a.EMail) Like '%_@__%.__%',1,0) as primary_email_valid
				 ,'{"phoneNumbers":['+concat_ws(
							','	
							,(select 'Mobile' as phoneType, '' as countryCode, cellphone as phoneNumber, 0 as isPrimary for JSON PATH, without_array_wrapper)
							,(select 'HomePhone' as phoneType, '' as countryCode, a.HomePhone as phoneNumber, 0 as isPrimary for JSON PATH, without_array_wrapper)
							,(select 'WorkPhone' as phoneType, '' as countryCode, a.WorkPhone as phoneNumber, 0 as isPrimary for JSON PATH, without_array_wrapper)
							) +']}' as phoneNumbers
				,'{"addresses":['+concat_ws(
									','
									,(select 'Home' as addressType, a.Address1+isnull(a.Address2,'') as street,a.city as city, a.State as state,a.Country as country,a.Zip as zip for JSON PATH, without_array_wrapper)
									,']}') as addresses

                 ,a.Birthdate
				 ,case when a.optoutmarketing ='true' then 1 when a.optoutmarketing = 'false' then 0 end do_not_email
				 ,case when a.optoutmarketing ='true' then 1 when a.optoutmarketing = 'false' then 0 end do_not_sms
				 ,case when a.optoutmarketing ='true' then 1 when a.optoutmarketing = 'false' then 0 end do_not_phone
				 ,case when a.optoutmarketing ='true' then 1 when a.optoutmarketing = 'false' then 0 end do_not_whatsapp
				 ,case when a.optoutmarketing ='true' then 1 when a.optoutmarketing = 'false' then 0 end do_not_mail
                 ,a.Address2
				 ,a.attention
				 ,case when a.optoutsharedata = 'true' then 1 when a.optoutsharedata = 'false' then 0 end block_data_share
				 ,case when a.optoutmarketing = 'true' then 1 when a.optoutmarketing = 'false' then 0 end is_unsubscribed
				 ,0 is_email_bounce
				 ,0 is_welcome_email_sent
				 ,0 is_welcome_sms_sent
				 ,0 is_deleted
				 ,getdate() as created_dt
				 ,getdate() as updated_dt
				 ,SUSER_NAME() as created_by
				 ,SUSER_NAME() as updated_by
				 
			 
		from [clictell_auto_etl].[etl].[cdkLgt_customer] a (nolock)
		inner join clictell_auto_master.master.dealer d (nolock) on a.parent_dealer_id = d.parent_dealer_id
		left outer join [auto_customers].[customer].[customers] b(nolock) 
								on a.FirstName = b.first_name 
								and a.LastName = b.last_name
								and a.CellPhone = b.primary_phone_number
								and a.email = b.primary_email 
								and d._id  = b.account_id
		where 
				 b.customer_id is null
				 and file_process_id = @file_process_id




		update b set
		--select 
				 b.company_name = a.Companyname
				,b.address_line = a.Address1
				,b.address_line2 = a.Address2
				,b.city = a.City
				,b.state = a.State
				,b.zip = a.Zip
				,b.notes = a.attention
				,b.do_not_email = case when optoutmarketing ='true' then 1 when optoutmarketing = 'false' then 0 end
				,b.do_not_sms = case when optoutmarketing ='true' then 1 when optoutmarketing = 'false' then 0 end
				,b.do_not_mail = case when optoutmarketing ='true' then 1 when optoutmarketing = 'false' then 0 end
				,b.do_not_phone = case when optoutmarketing ='true' then 1 when optoutmarketing = 'false' then 0 end
				,b.do_not_whatsapp = case when optoutmarketing ='true' then 1 when optoutmarketing = 'false' then 0 end
				,b.block_data_share = case when a.optoutsharedata = 'true' then 1 when a.optoutsharedata = 'false' then 0 end
				,b.updated_dt = getdate()
				,b.updated_by = SUSER_NAME()

				,b.phone_numbers = '{"phoneNumbers":['+concat_ws(
								','	
								,(select 'Mobile' as phoneType, '' as countryCode, cellphone as phoneNumber, 0 as isPrimary for JSON PATH, without_array_wrapper)
								,(select 'HomePhone' as phoneType, '' as countryCode, a.HomePhone as phoneNumber, 0 as isPrimary for JSON PATH, without_array_wrapper)
								,(select 'WorkPhone' as phoneType, '' as countryCode, a.WorkPhone as phoneNumber, 0 as isPrimary for JSON PATH, without_array_wrapper)
								) +']}'
				,b.addresses = '{"addresses":['+concat_ws(
									','
									,(select 'Home' as addressType, a.Address1+isnull(a.Address2,'') as street,a.city as city, a.State as state,a.Country as country,a.Zip as zip for JSON PATH, without_array_wrapper)
									,']}') 

		
		from [clictell_auto_etl].[etl].[cdkLgt_customer] a (nolock)
		inner join clictell_auto_master.master.dealer d (nolock) on a.parent_dealer_id = d.parent_dealer_id
		inner join [auto_customers].[customer].[customers] b 
						on a.FirstName = b.first_name 
						and a.LastName = b.last_name
						and a.CellPhone = b.primary_phone_number
						and a.email = b.primary_email
						and d._id = b.account_id
		where 
			a.file_process_id = @file_process_id


END

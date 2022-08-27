USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [etl].[CDK_Lite_Customer_Vehicles_loading]    Script Date: 2/7/2022 2:34:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [etl].[CDK_Lite_Customer_Vehicles_loading]
    @file_process_id int 
AS

/*
-----------------------------------------------------------------------  
	Copyright 2021 Clictell

	PURPOSE  
	Loading Customer Data from etl tables to auto_customers 

	PROCESSES  

	MODIFICATIONS  
	Date			Author		Work Tracker Id		Description    
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------

	exec [etl].[CDK_Lite_etl_Customer_json] 4486

	select * from [etl].[cdkLgt_customer] (nolock) where file_process_detail_id= 4486

	*/



BEGIN



		drop table if exists #temp_customer
		drop table if exists #temp_customer1
		drop table if exists #fleet_cust_rnk
		drop table if exists #distinct_vins


	select
		CustomerId
		,Companyname
		,attention
		,CustFullName
		,FirstName
		,MIddleName
		,LastName
		,address1
		,Address2
		,City
		,State
		,Zip
		,County
		,Country
		--,CellPhone
		,ltrim(rtrim(REPLACE(translate(CellPhone,'ABCDEFGHIJKLMNOPQRSTUVWXYZ+-;,.()[]{}`=* ','@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),'@',''))) as cellphone
		--,HomePhone
		,ltrim(rtrim(REPLACE(translate(homePhone,'ABCDEFGHIJKLMNOPQRSTUVWXYZ+-;,.()[]{}`=* ','@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),'@',''))) as homePhone
		,0 as primary_phone_valid
		,'CellPhone' as primary_phone_number_desc
		,0 as secondary_phone_number_valid
		,'HomePhone' as secondary_phone_number_desc
		,EMail
		,'work' as primary_email_desc
		,dbo.IsValidEmail(EMail) as primary_email_valid
	--	,null as primary_email_valid
		,case when optoutsharedata = 'true' then 1 else 0 end as block_share_data
		,case when optoutmarketing = 'true' then 1 else 0 end as do_not_email
		,case when optoutmarketing = 'true' then 1 else 0 end  as do_not_mail
		,case when optoutmarketing = 'true' then 1 else 0 end  as do_not_sms
		,case when optoutmarketing = 'true' then 1 else 0 end  as do_not_phone
		,case when optoutmarketing = 'true' then 1 else 0 end  as do_not_whatsapp
		,Birthdate
		,HasDriversLicenseNumber
		,LoyaltyCustomer
		,CustomerType
		--,optoutmarketing
		--,optoutsharedata
		---,optoutselldata
		,parent_dealer_id
		,file_process_id
		,file_process_detail_id
		--,created_dt
		--,updated_dt
		,iif(len(ltrim(rtrim(isnull(Zip,'')))) < 5 ,0,1) as zip_valid
		,'{"phoneNumbers":['+concat_ws(
								','	
								,(select 'Mobile' as phoneType, '' as countryCode, CellPhone as phoneNumber, '0' as isPrimary for JSON PATH, without_array_wrapper)
								,(select 'HomePhone' as phoneType, '' as countryCode, HomePhone as phoneNumber, '0' as isPrimary for JSON PATH, without_array_wrapper)
								) +']}' as phone_numbers
		,'{"addresses":['+concat_ws(
								','
								,(select '' as addressType, Address1+isnull(Address2,'') as street,city as city, State as state,Country as country,Zip as zip for JSON PATH, without_array_wrapper)
								,']}') as addressess

	into #temp_customer1
	from etl.cdkLgt_customer (nolock) 
	where CustomerId is not null and file_process_id = @file_process_id




	select * from #temp_customer1

	update #temp_customer1
	 set primary_phone_valid = 1
	 where
		len(ltrim(rtrim(isnull(cellphone,'')))) >=10

	 update #temp_customer1
	 set secondary_phone_number_valid = 1
	 where 
		len(ltrim(rtrim(isnull(HomePhone,'')))) >= 10



------------insert customer records into customer_history table--------------------------

	insert into auto_customers.[customer].[customers_history]
		(
			customer_id
			,customer_guid
			,type_provider_id
			,account_id
			,party_id
			,user_id
			,update_password
			,error_code
			,check_sum
			,first_name
			,middle_name
			,last_name
			,suffix
			,title
			,full_name
			,company_name
			,name_type_id
			,address_line
			,city
			,county
			,state
			,state_code
			,country
			,country_code
			,zip
			,zip_valid
			,primary_phone_number
			,primary_phone_number_extension
			,primary_phone_number_desc
			,primary_phone_number_valid
			,secondary_phone_number
			,secondary_phone_number_extension
			,secondary_phone_number_desc
			,primary_email
			,primary_email_desc
			,primary_email_valid
			,secondary_email
			,secondary_email_desc
			,ar_status_flag
			,parts_type
			,price_code
			,ro_price_code
			,tax_code
			,group_code
			,schedule_code
			,taxability
			,birth_date
			,employer_name
			,privacy_ind
			,privacy_type
			,block_data_share
			,prospect
			,prospect_type
			,fleet_flag
			,ins_agent_name
			,ins_agent_phone
			,ins_company_name
			,ins_policy_no
			,del_cde_service_names
			,delete_code
			,dealer_loyalty_indicator
			,list_id
			,pages_list
			,do_not_email
			,do_not_sms
			,do_not_phone
			,do_not_whatsapp
			,is_subscriber
			,job_title
			,anniversary
			,custom_fields
			,websites
			,social_profiles
			,phone_numbers
			,addresses
			,segment_list
			,tags
			,signup_source_id
			,fcm_token
			,platform_type
			,churn_score
			,is_unsubscribed
			,is_email_bounce
			,account_type
			,parent_type
			,account_status
			,channel_code
			,_id
			,notes
			,comments
			,is_welcome_email_sent
			,is_deleted
			,created_dt
			,created_by
			,updated_dt
			,updated_by
			,lead_status_id
			,lead_source_id
			,lead_call_status_id
			,preferred_demo_product_c
			,address_line2
			,cost
			,residency
			,residency_year
			,residency_month
			,user_type_id
			,service_status_id
			,organization_id
			,is_welcome_sms_sent
			,is_unsubscribed_reason_id
			,is_unsubscribed_reason
			,whats_app_valid
			,whats_app_id
			,whats_app_status
			,whats_app_last_checked_dt
			,demo_complete__c
			,last_status_updated_date
			,reason_for_missed_demo__c
			,connection_received_id
			,call_record_url
			,do_not_mail
			,list_ids
			,from_landing_page
			,bdc_status_id
			,is_ncoa_required
			,is_data_cleansing_required
			,is_call_recording_enabled
			,is_bdc
			,r2r_customer_id
			,is_app_user
			,buddy_count
			,promotions_count
			,events_count
			,distance_from_dealer
			,src_cust_id
			,secondary_phone_number_valid
			,file_process_id
			,file_process_detail_id

		)


		select 
			a.customer_id				
			,a.customer_guid
			,a.type_provider_id
			,a.account_id
			,a.party_id
			,a.user_id
			,a.update_password
			,a.error_code
			,a.check_sum
			,a.first_name	--,b.FirstName
			,a.middle_name
			,a.last_name
			,a.suffix
			,a.title
			,a.full_name		--,b.CustFullName
			,a.company_name
			,a.name_type_id
			,a.address_line		--,b.Address1
			,a.city		--,b.City
			,a.county
			,a.state		--,b.State
			,a.state_code
			,a.country		
			,a.country_code  ---b,country_code
			,a.zip
			,a.zip_valid
			,a.primary_phone_number		---,b.CellPhone
			,a.primary_phone_number_extension
			,a.primary_phone_number_desc
			,a.primary_phone_number_valid
			,a.secondary_phone_number		---,b.HomePhone
			,a.secondary_phone_number_extension
			,a.secondary_phone_number_desc
			,a.primary_email		--,b.EMail
			,a.primary_email_desc
			,a.primary_email_valid
			,a.secondary_email
			,a.secondary_email_desc
			,a.ar_status_flag
			,a.parts_type
			,a.price_code
			,a.ro_price_code
			,a.tax_code
			,a.group_code
			,a.schedule_code
			,a.taxability
			,a.birth_date
			,a.employer_name
			,a.privacy_ind
			,a.privacy_type
			,a.block_data_share
			,a.prospect
			,a.prospect_type
			,a.fleet_flag
			,a.ins_agent_name
			,a.ins_agent_phone
			,a.ins_company_name
			,a.ins_policy_no
			,a.del_cde_service_names
			,a.delete_code
			,a.dealer_loyalty_indicator
			,a.list_id
			,a.pages_list
			,a.do_not_email
			,a.do_not_sms
			,a.do_not_phone
			,a.do_not_whatsapp
			,a.is_subscriber
			,a.job_title
			,a.anniversary
			,a.custom_fields
			,a.websites
			,a.social_profiles
			,a.phone_numbers
			,a.addresses
			,a.segment_list
			,a.tags
			,a.signup_source_id
			,a.fcm_token
			,a.platform_type
			,a.churn_score
			,a.is_unsubscribed
			,a.is_email_bounce
			,a.account_type
			,a.parent_type
			,a.account_status
			,a.channel_code
			,a._id
			,a.notes
			,a.comments
			,a.is_welcome_email_sent
			,a.is_deleted
			,a.created_dt
			,a.created_by
			,a.updated_dt
			,a.updated_by
			,a.lead_status_id
			,a.lead_source_id
			,a.lead_call_status_id
			,a.preferred_demo_product_c
			,a.address_line2		---,b.Address2
			,a.cost
			,a.residency
			,a.residency_year
			,a.residency_month
			,a.user_type_id
			,a.service_status_id
			,a.organization_id
			,a.is_welcome_sms_sent
			,a.is_unsubscribed_reason_id
			,a.is_unsubscribed_reason
			,a.whats_app_valid
			,a.whats_app_id
			,a.whats_app_status
			,a.whats_app_last_checked_dt
			,a.demo_complete__c
			,a.last_status_updated_date
			,a.reason_for_missed_demo__c
			,a.connection_received_id
			,a.call_record_url
			,a.do_not_mail
			,a.list_ids
			,a.from_landing_page
			,a.bdc_status_id
			,a.is_ncoa_required
			,a.is_data_cleansing_required
			,a.is_call_recording_enabled
			,a.is_bdc
			,a.r2r_customer_id
			,a.is_app_user
			,a.buddy_count
			,a.promotions_count
			,a.events_count
			,a.distance_from_dealer
			,a.src_cust_id		---,b.CustomerId
			,a.secondary_phone_number_valid
			,b.file_process_id
			,b.file_process_detail_id		
	from #temp_customer1 b 
				inner join master.dealer d (nolock) on 
					d.parent_dealer_id = b.parent_dealer_id 
		 		inner join [auto_customers].[customer].[customers] a
						on b.CustomerId = a.src_cust_id  and  a.account_id = d._id
				where a.is_deleted = 0

-------------------------------------------------------------------------------
		update b set
		--select 
				 b.company_name = a.Companyname
				,b.first_name = a.FirstName
				,b.middle_name = a.MIddleName
				,b.last_name = a.LastName
				,b.full_name = a.CustFullName
				,b.address_line = a.Address1
				,b.address_line2 = a.Address2
				,b.city = a.City
				,b.state =a.State
				,b.country_code = a.Country
				,b.zip = a.Zip
				,b.zip_valid = a.zip_valid
				,b.primary_phone_number = a.CellPhone
				,b.primary_phone_number_desc = a.primary_phone_number_desc
				,b.primary_phone_number_valid = a.primary_phone_valid
				,b.secondary_phone_number = a.HomePhone
				,b.secondary_phone_number_desc = a.secondary_phone_number_desc
				,b.secondary_phone_number_valid = a.secondary_phone_number_valid
				,b.primary_email = a.EMail
				,b.primary_email_desc = a.primary_email_desc
				,b.primary_email_valid = a.primary_email_valid
				,b.birth_date = a.Birthdate
				,b.notes = a.attention
				,b.do_not_email = a.do_not_email	---case when optoutmarketing ='true' then 1 when optoutmarketing = 'false' then 0 end
				,b.do_not_sms = a.do_not_sms		----case when optoutmarketing ='true' then 1 when optoutmarketing = 'false' then 0 end
				,b.do_not_mail = a.do_not_mail		----case when optoutmarketing ='true' then 1 when optoutmarketing = 'false' then 0 end
				,b.do_not_phone = a.do_not_phone	----case when optoutmarketing ='true' then 1 when optoutmarketing = 'false' then 0 end
				,b.do_not_whatsapp = a.do_not_whatsapp	--case when optoutmarketing ='true' then 1 when optoutmarketing = 'false' then 0 end
				,b.block_data_share = a.block_share_data ---case when a.optoutsharedata = 'true' then 1 when a.optoutsharedata = 'false' then 0 end
				,b.addresses = a.addressess
				,b.phone_numbers = a.phone_numbers
				,b.updated_dt = getdate()
				,b.updated_by = SUSER_NAME()
	---	select a.*
		from #temp_customer1 a (nolock)
			inner join clictell_auto_master.master.dealer d (nolock) on
				a.parent_dealer_id = d.parent_dealer_id
			inner join [auto_customers].[customer].[customers] b on
						 a.CustomerId =b.src_cust_id
						and d._id = b.account_id
		where b.is_deleted = 0 

----------------------insert customer data into customer.customers table
	insert into auto_customers.[customer].[customers] 
		(
			account_id
			,src_cust_id
			,first_name
			,middle_name
			,last_name
			,full_name
			,company_name
			,address_line
			,address_line2
			,city
			,state
			,zip
			,zip_valid
			,county
			,country_code
			,primary_phone_number
			,primary_phone_number_desc
			,primary_phone_number_valid
			,secondary_phone_number
			,secondary_phone_number_valid
			,secondary_phone_number_desc
			,primary_email
			,primary_email_valid
			,primary_email_desc
			,block_data_share
			,do_not_email
			,do_not_mail
			,do_not_sms
			,do_not_phone
			,do_not_whatsapp
			---,is_subscriber
			,birth_date
			,addresses
			,phone_numbers
		)


		select 
			d._id as account_id
			,CustomerId
			,FirstName
			,MIddleName
			,LastName
			,CustFullName
			,a.Companyname
			,a.address1
			,a.Address2
			,a.City
			,a.State
			,a.Zip
			,a.zip_valid
			,a.County
			,a.Country
			,a.CellPhone
			,a.primary_phone_number_desc
			,primary_phone_valid
			,HomePhone
			,a.secondary_phone_number_valid
			,a.secondary_phone_number_desc
			,EMail
			,a.primary_email_valid
			,a.primary_email_desc
			,a.block_share_data
			,a.do_not_email
			,a.do_not_mail
			,a.do_not_sms
			,a.do_not_phone
			,a.do_not_whatsapp
			---,a.is_subscriber
			,Birthdate
			,addresses
			,a.phone_numbers

	---select a.CustomerId	---*,a.parent_dealer_id,d._id	 
	from #temp_customer1 a 
				inner join master.dealer d (nolock) on 
					a.parent_dealer_id = d.parent_dealer_id
				left outer join auto_customers.customer.customers c (nolock) on
					a.CustomerId = c.src_cust_id 
					and d._id = c.account_id
			where c.customer_id is null 
			---order by a.CustomerId

	--select  src_cust_id,primary_phone_number,primary_phone_number_valid,secondary_phone_number,secondary_phone_number_valid,do_not_sms,do_not_phone,do_not_whatsapp from auto_customers.customer.customers (nolock)
	update auto_customers.customer.customers
	 set do_not_sms = null,
		do_not_phone = null,
		do_not_whatsapp = null
	 where primary_phone_number_valid =0 and secondary_phone_number_valid =0
	 and account_id = 'D51E5DA3-9099-42C6-B311-DE6BBC9D825C'



------------------query to insert vehicle data from service and sales tables----------------


	drop table if exists #temp_vehicle
	drop table if exists #temp_cdklgt_service
	drop table if exists #temp_cdklgt_sales
	drop table if exists #vehicle_rank
	drop table if exists #vehicle_final
	drop table if exists #vehicle_insert
		drop table if exists #fleet_cust_rnk
		drop table if exists #distinct_vins

	create table #temp_vehicle
	(
		id int identity(1,1)
		,CustID varchar(30)
		,Make varchar(100)
		,model varchar(100)
		,ModelYear varchar(100)
		,Odometer int 
		,vin varchar(100)
		,vehicle_type varchar(10)
		,ro_date datetime
		,purchase_date datetime
		,ro_close_date datetime 
		,last_service_date datetime
		,rono varchar(20)
		,is_valid_vin int
		,source varchar(10)
		,file_process_id int
		,file_process_detail_id int
		,parent_dealer_id varchar(100)
		--,created_dt datetime
		---,updated_dt datetime
	)



		select distinct rono
		,case when isdate(closedate) = 0 then pudate else  closedate end as closedate
		, pudate, CustID, Unit, 
			JSON_VALUE(b.[value], '$.ROUnitID') as ROUnitID,
			JSON_VALUE(b.[value], '$.VIN') as Vin,
			JSON_VALUE(b.[value], '$.Make') as Make,
			JSON_VALUE(b.[value], '$.Model') as Model,
			JSON_VALUE(b.[value], '$.Year') as [ModelYear],
			JSON_VALUE(b.[value], '$.Odometer') as [Odometer],
			JSON_VALUE(b.[value], '$.Engineno') as [Engineno],
			'service' as source
			,parent_dealer_id, file_process_id, file_process_detail_id
			--,created_dt,updated_dt
		into #temp_cdklgt_service
		from [etl].[cdkLgt_Service_Details]  a (nolock)
		cross apply OpenJson(Unit) b
		where a.Unit is not null and file_process_id = @file_process_id
				

		insert into #temp_vehicle
			(
				CustID
				,Make
				,model
				,ModelYear
				,Odometer
				,vin
				,ro_close_date
				,rono
				,source
				,file_process_id
				,file_process_detail_id
				,parent_dealer_id
				--,created_dt
				--,updated_dt
			)

		select 
			CustID
			,Make
			,Model
			,ModelYear
			,Odometer
			,Vin
			,case when isdate(closedate) = 0 then pudate else  closedate end as closedate
			,rono
			,source
			,file_process_id
			,file_process_detail_id
			,parent_dealer_id
			--,created_dt
			--,updated_dt
		from #temp_cdklgt_service 

	select distinct a.DealNo
			,case when isdate(a.DeliveryDate) = 0 then null else DeliveryDate end as DeliveryDate
			, a.CustID, Units,
		Json_Value(b.[value], '$.DealUnitid') as DealUnitID,
		Json_Value(b.[value], '$.Newused') as Newused,
		Json_Value(b.[value], '$.Year') as [ModelYear],
		Json_Value(b.[value], '$.Make') as Make,
		Json_Value(b.[value], '$.Model') as Model,
		Json_Value(b.[value], '$.VIN') as VIN,
		Json_Value(b.[value], '$.Class') as Class,
		Json_Value(b.[value], '$.SalesType') as SalesType,
		Json_Value(b.[value], '$.Color') as Color,
		Json_Value(b.[value], '$.Odometer') as Odometer,
		Json_Value(b.[value], '$.bodytype') as bodytype,
		Json_Value(b.[value], '$.cylinders') as cylinders,
		Json_Value(b.[value], '$.plateno') as plateno,
		'sales' as source
		,parent_dealer_id, file_process_id, file_process_detail_id
		--,created_dt,updated_dt
	into #temp_cdklgt_sales
	from[etl].[cdkLgt_Deals_Details] a(nolock)
	Cross Apply OpenJson(Units) b
	where file_process_id = @file_process_id


		insert into #temp_vehicle
			(
				CustID
				,Make
				,model
				,ModelYear
				,Odometer
				,vin
				,vehicle_type
				,purchase_date
				,source
				,file_process_id
				,file_process_detail_id
				,parent_dealer_id
				--,created_dt
				--,updated_dt

			)

		select 
			CustID
			,Make
			,Model
			,ModelYear
			,Odometer
			,Vin
			,Newused
			,case when isdate(DeliveryDate) = 0 then null else DeliveryDate end as DeliveryDate
			,source
			,file_process_id
			,file_process_detail_id
			,parent_dealer_id
			--,created_dt
			--,updated_dt
		from #temp_cdklgt_sales 





--drop table #vehicle_rank
	select *,rank() over(partition by CustID,vin order by purchase_date,ro_close_date desc) as rnk
		into #vehicle_rank
		from #temp_vehicle 
	order by CustID,VIN


----------update ro_date if file has same VIN's with 2 RO's---------------

		update a
		set a.ro_date = b.ro_close_date 
	--select a.ro_date , b.ro_close_date,a.*
		from #vehicle_rank a inner join #vehicle_rank b on a.vin = b.vin and isnull(a.CustID,'') = isnull(b.CustID,'') and a.ro_close_date > b.ro_close_date

		select * into #vehicle_final 
		from #vehicle_rank where rnk = 1 and CustID is not null

		---select * from #vehicle_rank
------update is_valid_vin

		update #vehicle_final
			set is_valid_vin = 1
			where 
				len(trim(vin)) = 17


------update purchase_date same customer&vin record from sales and service-----


---select b.purchase_date , a.DeliveryDate,b.make,a.make,b.model,b.model,a.ModelYear,b.ModelYear,a.vin,b.vin,a.Newused,b.vehicle_type

		update 
			b set 
				b.purchase_date = a.DeliveryDate ----saletype,new or used,
				,b.vehicle_type = a.Newused
		from #temp_cdklgt_sales a inner join  #vehicle_final b on 
			a.CustID= b.custID and 
			a.vin = b.vin  
		where  b.purchase_date is null

	----select * from #vehicle_final where delivery
	
	select  
		b.customer_id,b.src_cust_id,b.is_deleted,a.* 
	into #vehicle_insert
	from #vehicle_final  a (nolock) inner join master.dealer d(nolock) on
						a.parent_dealer_id = d.parent_dealer_id
			left outer join auto_customers.customer.customers b on 
						a.CustID = b.src_cust_id and 
						b.account_id = d._id
	order by CustID	
--------update b.ro_date =a.last_service_date

	--select 
	--a.ro_date ,b.last_service_date,a.*
	update a
		set a.ro_date = b.last_service_date
		from #vehicle_insert  a inner join  auto_customers.customer.vehicles b(nolock)  on 
			a.customer_id = b.customer_id and a.vin  = b.vin

---select * from #vehicle_insert

-----------update las_service_date-------------

--		select a.last_service_date ,b.ro_close_date,a.* 
		update a
			set a.last_service_date = b.ro_close_date
			 from #vehicle_insert a inner join #vehicle_insert b on a.vin = b.vin and isnull(a.CustID,'') = isnull(b.CustID,'')
			 where b.rono is not null

 
 ---select * from #vehicle_insert
------------------insert into vehicle_history table------------------------------
		
		insert into [auto_customers].[customer].[vehicles_history]

		(
				vehicle_id
				,vehicle_guid
				,customer_id
				,check_sum
				,dealer_id
				,account_id
				,inventory_account
				,app_error_no
				,app_error_text
				,axle_code
				,axcle_count
				,body_style
				,brake_system
				,cab_type
				,certified_preowned_ind
				,certified_preowned_number
				,chassis
				,delivery_date
				,delivery_mileage
				,doors_quantity
				,engine_number
				,engine_type
				,exterior_color
				,fleet_customer_vehicles_id
				,front_tire_code
				,gmrpo_code
				,ignition_key_number
				,interior_color
				,license_plate_no
				,make
				,model
				,year
				,make_id
				,make_model_id
				,model_year_id
				,number_of_engine_cylinders
				,odometer_status
				,rear_tire_code
				,restraint_system
				,sale_classs
				,sale_class_value
				,source_code_value
				,source_code_description
				,standard_equipment
				,sticker_number
				,transmission_type
				,trim_code
				,vehicle_status
				,vehicle_stock
				,vehicle_weight
				,vin
				,warranty_exp_date
				,wheel_base
				,vehicle_pricing_type
				,price
				,ro_date
				,purchase_date
				,last_service_date
				,is_deleted
				,created_dt
				,created_by
				,updated_dt
				,updated_by
				,r2r_vehicle_id
				,dealership_visits
				,competitor_visits
				,miles_ridden
				,avg_mph
				,rides_taken
				,is_active
				,ro_number
				,is_valid_vin
				,file_process_id
				,file_process_detail_id	
				
		)


		select 
				a.vehicle_id
				,a.vehicle_guid
				,a.customer_id
				,a.check_sum
				,a.dealer_id
				,a.account_id
				,a.inventory_account
				,a.app_error_no
				,a.app_error_text
				,a.axle_code
				,a.axcle_count
				,a.body_style
				,a.brake_system
				,a.cab_type
				,a.certified_preowned_ind
				,a.certified_preowned_number
				,a.chassis
				,a.delivery_date
				,a.delivery_mileage
				,a.doors_quantity
				,a.engine_number
				,a.engine_type
				,a.exterior_color
				,a.fleet_customer_vehicles_id
				,a.front_tire_code
				,a.gmrpo_code
				,a.ignition_key_number
				,a.interior_color
				,a.license_plate_no
				,a.make
				,a.model
				,a.year
				,a.make_id
				,a.make_model_id
				,a.model_year_id
				,a.number_of_engine_cylinders
				,a.odometer_status
				,a.rear_tire_code
				,a.restraint_system
				,a.sale_classs
				,a.sale_class_value
				,a.source_code_value
				,a.source_code_description
				,a.standard_equipment
				,a.sticker_number
				,a.transmission_type
				,a.trim_code
				,a.vehicle_status
				,a.vehicle_stock
				,a.vehicle_weight
				,a.vin
				,a.warranty_exp_date
				,a.wheel_base
				,a.vehicle_pricing_type
				,a.price
				,a.ro_date
				,a.purchase_date
				,a.last_service_date
				,a.is_deleted
				,a.created_dt
				,a.created_by
				,a.updated_dt
				,a.updated_by
				,a.r2r_vehicle_id
				,a.dealership_visits
				,a.competitor_visits
				,a.miles_ridden
				,a.avg_mph
				,a.rides_taken
				,a.is_active
				,a.ro_number
				,a.is_valid_vin
				,b.file_process_id
				,b.file_process_detail_id			

	---select a.*
	from auto_customers.customer.vehicles a (nolock) 
			inner join master.dealer d (nolock) on 
					 a.account_id = d._id
			inner join #vehicle_insert  b on 
				a.customer_id = b.customer_id and a.vin  = b.vin 
				and b.parent_dealer_id = cast(d.parent_dealer_id as varchar(50))
		---	where a.is_deleted = 0
----------------update vehicle data--------------------------------------------------------
	---update a set saletype,eng_no,n/u
	--select 
	update a set 
			a.customer_id = b.customer_id
		   ,a.Make = b.Make
		   ,a.model  = b.model
		   ,a.year = b.ModelYear
		   ,a.delivery_mileage = b.Odometer
		   ,a.vehicle_status = b.vehicle_type
		   ,a.vin = b.vin
		   ,a.ro_date = b.ro_date
		   ,a.purchase_date = b.purchase_date
		   ,a.last_service_date = b.last_service_date
		   ,a.ro_number = b.rono
		   ,a.is_valid_vin = b.is_valid_vin
		   ,a.updated_dt = getdate()
		   ,a.updated_by = SUSER_NAME()

----	select a.* 
	from auto_customers.customer.vehicles a inner join master.dealer d  on 
						 a.account_id = d._id
			inner join  #vehicle_insert  b  on
		 a.customer_id = b.customer_id and 
		 a.vin  = b.vin and b.parent_dealer_id = cast(d.parent_dealer_id as varchar(50))
			---where a.is_deleted = 0

	---	select * from	#vehicle_insert

----------insert vehicle data into vehicle table--------------

	insert into auto_customers.customer.vehicles 
	(
	customer_id
	,account_id
	,make
	,model
	,year
	,delivery_mileage
	,vin
	,ro_date
	,purchase_date
---	,delivery_date
	,last_service_date
	,ro_number
	,is_valid_vin
	,vehicle_status
	)


	select
		a.customer_id
		,d._id as account_id
		,a.Make
		,a.Model
		,a.ModelYear
		,a.Odometer
		,a.vin
		,a.ro_date
		,a.purchase_date
	 --,a.ro_close_date
		,a.last_service_date
		,a.rono
		,isnull(a.is_valid_vin,0)
		,a.vehicle_type
	from #vehicle_insert a 	inner join master.dealer d (nolock) on 
			a.parent_dealer_id = d.parent_dealer_id
	left outer join auto_customers.customer.vehicles b (nolock)  on 
		a.customer_id = b.customer_id and a.VIN = b.vin and b.account_id = d._id
	where b.customer_id is null 
	---and a.customer_id is not null

	---and a.vin like '%DO NOT USE%'

---------------------------update fleet_flag----------------------------

-----get distinct vins from same customer
			select  distinct customer_id,vin,is_valid_vin 
			into #distinct_vins
			from  auto_customers.customer.vehicles (nolock)  where is_valid_vin = 1

----------apply rank on vin
			select   customer_id,vin,is_valid_vin ,rank() over(partition by customer_id order by vin desc) as rnk
			into #fleet_cust_rnk
			from  #distinct_vins (nolock)
			---where  customer_id in (2550211) order by vin desc
		--	=17 valid vin
----update fleet customer--------------

			--select  c.customer_id,r.customer_id,c.src_cust_id,----c.updated_dt,fleet_flag ,
			--fleet_flag, rnk
			update c
			set c.fleet_flag = 1
			from  auto_customers.customer.customers c (nolock) 
				----inner join master.dealer d(nolock) on c.account_id = d._id
				inner join #fleet_cust_rnk r(nolock) on
					c.customer_id = r.customer_id
			where  rnk >= 5


END
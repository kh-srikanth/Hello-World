USE [ETL_Test]
GO
/****** Object:  StoredProcedure [etl].[move_d2d_dmi_service_raw_etl_2_stage]    Script Date: 1/7/2021 6:02:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
  ALTER procedure  [etl].[move_act_service_raw_etl_2_stage]   
	   
   @file_log_detail_id int

as 
/*
	exec  [etl].[move_act_service_raw_etl_2_stage] 1
	
-----------------------------------------------------------------------  
	Copyright 

	PURPOSE  
	Load Raw Service data from ETL to Stage

	PROCESSES  

	MODIFICATIONS  
	Date			Author    Work Tracker Id   Description    
	------------------------------------------------------------------------  

	------------------------------------------------------------------------

	*/  
	begin
	
	/* Deleting temp tables */

	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

	/* Variable declaration */
	declare @geo_type_id int


 /* Loading data into temp table */

	select 
	       es.src_dealer_code  
		  ,RepairOrderNumber  
          ,RepairOrderCloseDate  
          ,RepairOrderOpenDate  
          ,CustomerContactId
          ,CustomerFirstName  
          ,CustomerMiddleName  
          ,CustomerLastName  
          ,CustomerSalutation  
          ,CustomerSuffix  
          ,CustomerFullName  
          ,CustomerTitle  
          ,BusinessPersonFlag 
          ,CustomerDepartment  
          ,ResidentialStreetAddress  
          ,District  
          ,es.City  
          ,es.State  
          ,PostalCode  
          ,es.Country  
          ,HomePhoneNumber  
          ,HomePhoneExtension  
          ,HomePhoneCountryCode  
          ,BusinessPhoneNumber  
          ,BusinessPhoneExtension  
          ,BusinessPhoneCountryCode  
          ,PersonalEmailAddress  
          ,BusinessEmailAddress  
          ,BirthDate  
          ,AllowSolicitation  
          ,AllowPhoneSolicitation  
          ,AllowEmailSolicitation  
          ,AllowMailSolicitation  
          ,OdometerIn  
          ,OdometerOut  
          ,VehiclePickUpDate  
          ,AppointmentFlag  
          ,Department  
          ,ExtendedServiceContractNames 
          ,VIN  
          ,ModelYear  
          ,Make  
          ,Model  
          ,TransmissionDescription  
          ,ExteriorColorDescription  
          ,LicensePlateNumber             
          ,RepairOrderTechnicianComment  
          ,RepairOrderCustomerComment  
          ,ServiceAdvisorContactId  
          ,ServiceAdvisorFirstName  
          ,ServiceAdvisorMiddleName  
          ,ServiceAdvisorLastName  
          ,ServiceAdvisorSalutation  
          ,ServiceAdvisorSuffix  
          ,ServiceAdvisorFullName  
          ,file_log_id  
          ,file_log_detail_id  
          ,dealer_mapping_id		  
		  ,natural_key
		  ,md.parent_dealer_id
		  ,0 as is_err_rec
		  ,cast('' as varchar(500)) as err_description
		  ,etl_dmi_service_id   

           into #temp   
	 from 
	   etl.atc_service es with(nolock)
    inner join master.dealer md with(nolock) on 
	    b.Vendor_dealer_id = md.natural_key
	where 
		es.file_log_detail_id = @file_log_detail_id

	 alter table #temp add vin_prefix varchar(10)
     update #temp set vin_prefix = left(vin,8)+' '+ substring(vin,len(vin)/2+2,1) 

  /* Updated error description for invalid records */
	
	Update 
		#temp
	set
		is_err_rec = 1,
		err_description = 'Vin Not Valid - All numeric'
	 where
		is_err_rec = 0
		and isnumeric(vin) = 1

	Update 
		#temp
	set
		is_err_rec = 1,
		err_description = 'Vin Not Valid - Not equal to 17'
	 where
		is_err_rec = 0
		and len(vin) != 17

	Update 
		#temp
	set
		is_err_rec = 1,
		err_description = 'Customer data not available'
	where
		is_err_rec = 0
		and CustomerContactId is null 
		and CustomerFirstName is null 
		and CustomerMiddleName is null 
		and CustomerLastName is null

	/* Inserting into DMI main stage from temp */

	insert into stg.repair_order_detail 
	 (	
	       src_dealer_code  
          ,dealer_mapping_id
		  ,parent_dealer_id
		  ,natural_key           
          ,ro_number  
          ,vin  
          ,make  
          ,model  
          ,year  
          ,mileage_in  
          ,mileage_out  
          ,delivery_odometer  
          ,sa_number  
          ,sa_name  
          ,ro_open_date  
          ,ro_close_date  
          ,in_service_date  
          ,warr_post_date  
          ,cust_invoice_date  
          ,promise_time  
          ,promise_date  
          ,vehicle_pickup_date  
          ,delivery_date  
          ,void_date  
          ,last_activity_date  
          ,first_ro_number  
          ,last_ro_no  
          ,last_ro_date  
          ,last_roo_dom  
          ,no_of_visits  
          ,service_days  
          ,dept_type  
          ,cust_full_name  
          ,cust_salutation_text  
          ,cust_first_name  
          ,cust_middle_name  
          ,cust_last_name  
          ,cust_suffix  
          ,cust_address1  
          ,cust_address2  
          ,cust_city  
          ,cust_state  
          ,cust_zip_code  
          ,cust_addr_type  
          ,cust_country  
          ,cust_department  
          ,cust_title  
          ,cust_district  
          ,cust_home_phone  
          ,cust_home_phone_ext  
          ,cust_home_phone_country_code  
          ,cust_work_phone  
          ,cust_business_phone  
          ,cust_business_ext  
          ,cust_business_country_code  
          ,cust_dms_number  
          ,cust_mobile_phone  
          ,cust_email_address  
          ,cust_business_email_address  
          ,cust_birth_date  
          ,cust_email_address2  
          ,cust_gender  
          ,cust_mail_block_flag  
          ,cust_do_not_call  
          ,cust_do_not_email  
          ,cust_do_not_mail  
          ,cust_do_not_data_share  
          ,cust_opt_out  
          ,cust_ib_flag  
          ,cust_lic_no  
          ,carline_desc  
          ,ro_status  
          ,vehicle_priority  
          ,appt_no  
          ,tag_no  
          ,disp_no  
          ,ro_cust_comment  
          ,ro_tech_comment  
          ,Carline  
          ,ext_clr_desc  
          ,int_clr_desc  
          ,model_maint_code  
          ,transmission_desc  
          ,stock_id  
          ,ext_svc_contract_number  
          ,ext_svc_contract_name  
          ,ext_svc_contract_exp_date  
          ,ext_svc_contract_exp_mileage  
          ,file_log_id  
          ,file_load_detail_id  
          ,created_date  
          ,updated_date  
          ,created_by  
          ,updated_by 
		  ,vin_prefix 
		)
	select 
		   src_dealer_code  
		  ,dealer_mapping_id
		  ,parent_dealer_id
		  ,natural_key   
		  ,RepairOrderNumber  
		  ,VIN  
		  ,Make  
		  ,Model  
		  ,ModelYear  
		  ,OdometerIn  
		  ,OdometerOut  
		  ,OdometerOut  
		  ,ServiceAdvisorContactId  
		  ,ServiceAdvisorFullName  
		  ,RepairOrderOpenDate  
		  ,RepairOrderCloseDate  
		  ,null
		  ,null
		  ,null
		  ,null
		  ,null
		  ,VehiclePickUpDate  
		  ,null
		  ,null
		  ,null
		  ,null
		  ,null
		  ,null
		  ,null
		  ,null
		  ,null
		  ,Department  
		  ,isnull(CustomerFullName,'') as CustomerFullName 
		  ,isnull(CustomerSalutation,'') as CustomerSalutation 
		  ,isnull(CustomerFirstName,'') as CustomerFirstName
		  ,isnull(CustomerMiddleName,'') as CustomerMiddleName 
		  ,isnull(CustomerLastName,'') as CustomerLastName  
		  ,isnull(CustomerSuffix,'') as  CustomerSuffix
		  ,isnull(ResidentialStreetAddress,'')  as ResidentialStreetAddress
		  ,null
		  ,isnull(City ,'') as City
		  ,isnull(State,'') as 'State'
		  ,isnull(PostalCode,'') as PostalCode
		  ,null
		  ,isnull(Country ,'') as Country
		  ,isnull(CustomerDepartment,'') as CustomerDepartment
		  ,isnull(CustomerTitle,'') as  CustomerTitle
		  ,isnull(District,'') as District
		  ,isnull(HomePhoneNumber,'') as HomePhoneNumber
		  ,isnull(HomePhoneExtension,'')  as HomePhoneExtension
		  ,isnull(HomePhoneCountryCode,'') as HomePhoneCountryCode 
		  ,isnull(BusinessPhoneNumber,'') as BusinessPhoneNumber
		  ,isnull(BusinessPhoneNumber,'') as BusinessPhoneNumber
		  ,isnull(BusinessPhoneExtension,'') as BusinessPhoneExtension 
		  ,isnull(BusinessPhoneCountryCode,'') as BusinessPhoneCountryCode 
		  ,isnull(CustomerContactId,'') as CustomerContactId
		  ,null
		  ,isnull(PersonalEmailAddress,'') as PersonalEmailAddress 
		  ,isnull(BusinessEmailAddress,'') as BusinessEmailAddress
		  ,BirthDate  
		  ,null
		  ,null
		  ,null
		  ,AllowPhoneSolicitation  
		  ,AllowEmailSolicitation  
		  ,AllowMailSolicitation  
		  ,AllowSolicitation  
		  ,AllowSolicitation  
		  ,BusinessPersonFlag  
		  ,LicensePlateNumber             
		  ,null
		  ,null
		  ,null
		  ,AppointmentFlag  
		  ,null
		  ,null
		  ,RepairOrderCustomerComment  
		  ,RepairOrderTechnicianComment  
		  ,null
		  ,ExteriorColorDescription  
		  ,null
		  ,null
		  ,TransmissionDescription  
		  ,null
		  ,null
		  ,ExtendedServiceContractNames  
		  ,null
		  ,null
		  ,file_log_id  
		  ,file_log_detail_id  
		  ,getdate()
		  ,getdate()
		  ,suser_name()
		  ,suser_name()
		  ,vin_prefix
       from  
			#temp 
	  			
	   order by etl_dmi_service_id     

	/* Updated error description for invalid records in intermidate stage table */
	Update 
		a
	set
		a.is_error = b.is_err_rec,
		a.error_desc = b.err_description
	from 
		etl.dmi_service a (nolock)
	inner join #temp b on 
		a.etl_dmi_service_id = b.etl_dmi_service_id
	where 
		b.is_err_rec = 1


		  insert into error.records_2_validate 
       (
         source_sale_service_id
   	    ,table_desc_type
   	    ,source_error_desc 
   	    ,vin
   	    ,file_log_id
   	    ,file_log_detail_id
		,source_file_type
		,parent_dealer_id
		,natural_key
   	   
       )
   
    select 
         etl_dmi_service_id
   	    ,'etl.dmi_service'
   	    ,err_description
   	    ,vin
   	    ,file_log_id
   	    ,file_log_detail_id 
		,'DMI'
		,parent_dealer_id
		,natural_key
    from 
       #temp with(nolock) 
     where 
        is_err_rec = 1
   	    	and file_log_detail_id = @file_log_detail_id

		

	end

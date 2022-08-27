USE clicktell_auto_etl
GO
/****** Object:  StoredProcedure [etl].[move_d2d_dmi_sale_raw_etl_2_stage]    Script Date: 1/7/2021 5:59:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
ALTER procedure  [etl].[move_atc_sale_raw_etl_2_stage]   
   --@job_log_id int,
   @file_log_detail_id int
   --@oem_id int
as 

/*
	exec [etl].[move_dmi_sale_raw_etl_2_stage]  1
	
-----------------------------------------------------------------------  
	Copyright 

	PURPOSE  
	direct load from etl to stage master service
	Load Sale Data form ETL to Stage

	PROCESSES  

	MODIFICATIONS  
	Date			Author			Work Tracker Id   Description    
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------

	*/
	
begin
	
	/* Deleting temp tables */

	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

	/* Variable declaration */
	declare @geo_type_id int
	

	/* Loading data into temp table */
	select distinct 
		 [etl_dmi_sale_id]
		,b.dealer_mapping_id
		,[DV Dealer ID] as src_dealer_code
		,md.natural_key
		,md.parent_dealer_id
		,[Deal Number]
		,[Inventory Date]
		,[Delivery Date]
		,[Stock Number]
		,[VIN]
		,[Make]
		,[Model]
		,[Model Number]
		,[Exterior Color]
		,[Delivery Mileage]
		,[Trim]
		,[License Plate Number]
		,[Transmission]
		,[Engine Configuration]
		,isnull([Customer Number],'') as buyerid
		,[Salutation]
		,[First Name]
		,[Middle Name]
		,[Last Name]
		,[Suffix]
		,[Full Name]
		,[Birth Date]
		,[Address Line 1]
		,[Address Line 2]
		,City
		,State
		,Zip
		,[Home Phone]
		,[Cell Phone]
		,[Work Phone]
		,[Work Extension]
		,[Email 1]
		,[Email 2]
		,[Email 3]
		,[Individual/Business Flag]
		,[Opt Out]
		,[Block Email]
		,[Block Phone]
		,[Block Mail]
		,Language
		,[Customer Create Date]
		,[Customer Last Activity Date]
		,[Co-Buyer Customer Number]
		,[Co-Buyer Full Name]
		,[Co-Buyer Salutation]		
		,0 as is_err_rec
		,cast('' as varchar(500)) as err_description		
	into 
		#temp
	from  
		etl.atc_sales1 a with(nolock)
    inner join master.dealer md with(nolock) on 
	    b.vendor_dealer_id = md.natural_key
	where 
			a.file_log_detail_id = @file_log_detail_id
		 
	
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
		and [Customer Number] is null 
		and [First Name] is null 
		and [Middle Name] is null 
		and [Last Name] is null

	/* Inserting data into main stage table */
	insert into [stg].[fi_sales]
	(
		 dealer_mapping_id
		,parent_dealer_id
		,natural_key
		,[src_dealer_code]
		,[deal_number_dms]
		,[deal_status_date]
		,[deal_status]
		,[purchase_date]
		,[deal_date]
		,[close_deal_date]
		,[inventory_date]
		,[delivery_date]
		,[contract_type]
		,[sale_type]
		,[stock_id]
		,[vehicle_price]
		,[vehicle_cost]
		,[invoice_price]
		,[msrp]
		,[vin]
		,[vin_prefix]
		,[make]
		,[model_year]
		,[model]
		,[model_num]
		,[ext_clr_desc]
		,[mileage_in]
		,[mileage_out]
		,[trim]
		,[veh_class]
		,[license_num]
		,[nuo_flag]
		,[gm_cert]
		,[body_descr]
		,[body_door_count]
		,[transmission_desc]
		,[engine_descr]
		,[feature]
		,[list_price]
		,[total_sale_credit_amount]
		,[total_pickup_payment]
		,[total_cashdown_payment]
		,[total_rebate_amount]
		,[total_taxes]
		,[total_accessories]
		,[total_feeandaccessories]
		,[total_trade_allownce_amount]
		,[total_trade_actuval_cashvalue]
		,[total_trade_payoff]
		,[total_net_trade_amount]
		,[total_gross_profit]
		,[backend_gross_profit]
		,[frontend_gross_profit]
		,[security_deposit]
		,[total_drive_of_amount]
		,[net_captilized_cost]
		,[comments]
		,[delivery_odometer]
		,[total_finance_amount]
		,[finance_apr]
		,[finance_charge]
		,[contract_term]
		,[monthly_payment]
		,[total_of_payments]
		,[payment_frequency]
		,[first_payment_date]
		,[expected_vehicle_payoff_date]
		,[ballon_payment]
		,[finance_company_code]
		,[finance_company_comapnyname]
		,[buy_rate]
		,[term_depreciation_value]
		,[total_estimated_miles]
		,[total_mileage_limit]
		,[resiudal_amount]
		,[buyer_id]
		,[buyer_salutation]
		,[buyer_first_name]
		,[buyer_middle_name]
		,[buyer_last_name]
		,[buyer_suffix]
		,[buyer_full_name]
		,[buyer_birth_date]
		,[buyer_home_address]
		,[buyer_home_address_district]
		,[buyer_home_address_city]
		,[buyer_home_address_region]
		,[buyer_home_address_postal_code]
		,[buyer_home_address_country]
		,[buyer_homephone_number]
		,[buyer_homephone_extension]
		,[buyer_homephone_country_code]
		,[buyer_personal_email_address]
		,[buyer_businessphone_number]
		,[buyer_businessphone_extension]
		,[buyer_businessphone_country_code]
		,[co_buyer_id]
		,[co_buyer_salutation]
		,[co_buyer_first_name]
		,[co_buyer_middle_name]
		,[co_buyer_last_name]
		,[co_buyer_suffix]
		,[co_buyer_full_name]
		,[co_buyer_birth_date]
		,[co_buyer_home_address]
		,[co_buyer_home_address_district]
		,[co_buyer_home_address_city]
		,[co_buyer_home_address_region]
		,[co_buyer_home_address_postal_code]
		,[co_buyer_home_address_country]
		,[co_buyer_homephone_number]
		,[co_buyer_homephone_extension]
		,[co_buyer_homephone_country_code]
		,[co_buyer_personal_email_address]
		,[co_buyer_businessphone_number]
		,[co_buyer_businessphone_extension]
		,[co_buyer_businessphone_country_code]
		,[sales_manager_id]
		,[sales_manager_fullname]
		,[fin_manger_id]
		,[fin_manager_fullname]
		,[accident_health_cost]
		,[accident_health_reserve]
		,[accident_health_coverage_amt]
		,[accident_health_premium]
		,[accident_health_rate]
		,[accident_health_term]
		,[accident_health_provider]
		,[credit_life_cost]
		,[credit_life_reserve]
		,[credit_life_coverage_amt]
		,[credit_life_rate]
		,[credit_life_premium]
		,[credit_lile_term]
		,[credit_life_provider]
		,[gap_cost]
		,[gap_reserve]
		,[gap_coverage_amt]
		,[gap_rate]
		,[gap_premium]
		,[gap_term]
		,[gap_provider]
		,[loss_of_employement_cost]
		,[loss_of_employement_reserve]
		,[loss_of_employement_coverage_amt]
		,[loss_of_employement_rate]
		,[loss_of_employement_premium]
		,[loss_of_employement_term]
		,[loss_of_employement_provider]
		,[mechanical_breakdown_cost]
		,[mechanical_breakdown_reserve]
		,[mechanical_breakdown_coverage_amt]
		,[mechanical_breakdown_rate]
		,[mechanical_breakdown_premium]
		,[mechanical_breakdown_term]
		,[mechanical_breakdown_provider]
		,[service_contract_cost]
		,[service_contract_reserve]
		,[service_contract_coverage_amt]
		,[service_contract_rate]
		,[service_contract_premium]
		,[service_contract_term]
		,[service_contract_provider]
		,[file_log_id]
		,[file_log_detail_id]
		,[created_by]
		,[created_date]
		,[updated_by]
		,[updated_date]
	)

     select
		 dealer_mapping_id
		,parent_dealer_id
		,natural_key
		,src_dealer_code
		,[DealNumber]
		,[DealStatusDate]
		,[DealStatus]
		,[PurchaseOrderDate]
		,iif([ContractDate]= '10101',[DeliveryDate],[ContractDate])
		,[ReversalDate]
		,[InventoryDate]
		,[DeliveryDate]
		,[ContractType]
		,[SaleType]
		,[StockNumber]
		,[VehicleSalePrice]
		,[Cost]
		,[InvoicePrice]
		,[MSRP]
		,[VIN]
		,[vin_prefix]
		,[Make]
		,[ModelYear]
		,[Model]
		,[ModelCode]
		,[ExteriorColorDescription]
		,[DeliveryOdometer]
		,[DeliveryOdometer]
		,[TrimLevel]
		,[TypeCode]
		,[LicensePlateNumber]
		,(case when [InventoryType] = 'USED' then 'U' else 'N' end) as [InventoryType]
		,[IsCertifiedFlag]
		,[BodyDescription]
		,[BodyDoorCount]
		--,(case when isnumeric(BodyDoorCount) = 1 then cast(cast(BodyDoorCount as decimal(4,2)) as int) else 0 end) as [BodyDoorCount]
		,[TransmissionDescription]
		,[EngineDescription]
		,[Feature]
		,[ListPrice]
		,[TotalSaleCreditAmount]
		,[TotalPickupPayment]
		,[TotalCashDownPayment]
		,[TotalRebateAmount]
		,[TotalTaxes]
		,[TotalAccessories]
		,[TotalFeesAndAccessories]
		,[TotalTradesAllowanceAmount]
		,[TotalTradesActualCashValue]
		,[TotalTradesPayoff]
		,[TotalNetTradeAmount]
		,[TotalGrossProfit]
		,[Back_EndGrossProfit]
		,[Front_EndGrossProfit]
		,[SecurityDeposit]
		,[TotalDriveOffAmount]
		,[NetCapitalizedCost]
		,[Comments]
		,[DeliveryOdometer]
		,[TotalFinanceAmount]
		,[FinanceAPR]
		,[FinanceCharge]
		,[ContractTerm]
		,[MonthlyPayment]
		,[TotalOfPayments]
		,[PaymentFrequency]
		,[FirstPaymentDate]
		,[ExpectedVehiclePayoffDate]
		,[BalloonPayment]
		,[FinanceCompanyCode]
		,[FinanceCompanyName]
		,[BuyRate]
		,[TermDepreciationValue]
		,[TotalEstimatedMiles]
		,[TotalMileageLimit]
		,[ResidualAmount]
		,isnull([BuyerID],'') as [BuyerID]
		,isnull([BuyerSalutation],'') as [BuyerSalutation]
		,isnull([BuyerFirstName],'') as [BuyerFirstName]
		,isnull([BuyerMiddleName],'') as [BuyerMiddleName]
		,isnull([BuyerLastName],'') as [BuyerLastName]
		,isnull([BuyerSuffix],'') as [BuyerSuffix]
		,isnull([BuyerFullName],'') as [BuyerFullName]
		,isnull([BuyerBirthDate],'') as [BuyerBirthDate]
		,isnull([BuyerHomeAddress],'') as [BuyerHomeAddress]
		,isnull([BuyerHomeAddressDistrict],'') as [BuyerHomeAddressDistrict]
		,isnull([BuyerHomeAddressCity],'') as [BuyerHomeAddressCity]
		,isnull([BuyerHomeAddressRegion],'') as [BuyerHomeAddressRegion]
		,isnull([BuyerHomeAddressPostalCode],'') as [BuyerHomeAddressPostalCode]
		,isnull([BuyerHomeAddressCountry],'') as [BuyerHomeAddressCountry]
		,isnull([BuyerHomePhoneNumber],'') as [BuyerHomePhoneNumber]
		,isnull([BuyerHomePhoneExtension],'') as [BuyerHomePhoneExtension]
		,isnull([BuyerHomePhoneCountryCode],'') as [BuyerHomePhoneCountryCode]
		,isnull([BuyerPersonalEmailAddress],'') as [BuyerPersonalEmailAddress]
		,isnull([BuyerBusinessPhoneNumber],'') as [BuyerBusinessPhoneNumber]
		,isnull([BuyerBusinessPhoneExtension],'') as [BuyerBusinessPhoneExtension]
		,isnull([BuyerBusinessPhoneCountryCode],'') as [BuyerBusinessPhoneCountryCode]
		,isnull([CoBuyerID],'') as [CoBuyerID]
		,isnull([CoBuyerSalutation],'') as [CoBuyerSalutation]
		,isnull([CoBuyerFirstName],'') as [CoBuyerFirstName]
		,isnull([CoBuyerMiddleName],'') as [CoBuyerMiddleName]
		,isnull([CoBuyerLastName],'') as [CoBuyerLastName]
		,isnull([CoBuyerSuffix],'') as [CoBuyerSuffix]
		,isnull([CoBuyerFullName],'') as [CoBuyerFullName]
		,isnull([CoBuyerBirthDate],'') as [CoBuyerBirthDate]
		,isnull([CoBuyerHomeAddress],'') as [CoBuyerHomeAddress]
		,isnull([CoBuyerHomeAddressDistrict],'') as [CoBuyerHomeAddressDistrict]
		,isnull([CoBuyerHomeAddressCity],'') as [CoBuyerHomeAddressCity]
		,isnull([CoBuyerHomeAddressRegion],'') as [CoBuyerHomeAddressRegion]
		,isnull([CoBuyerHomeAddressPostalCode],'') as [CoBuyerHomeAddressPostalCode]
		,isnull([CoBuyerHomeAddressCountry],'') as [CoBuyerHomeAddressCountry]
		,isnull([CoBuyerHomePhoneNumber],'') as [CoBuyerHomePhoneNumber]
		,isnull([CoBuyerHomePhoneExtension],'') as [CoBuyerHomePhoneExtension]
		,isnull([CoBuyerHomePhoneCountryCode],'') as [CoBuyerHomePhoneCountryCode]
		,isnull([CoBuyerPersonalEmailAddress],'') as [CoBuyerPersonalEmailAddress]
		,isnull([CoBuyerBusinessPhoneNumber],'') as [CoBuyerBusinessPhoneNumber]
		,isnull([CoBuyerBusinessPhoneExtension],'') as [CoBuyerBusinessPhoneExtension]
		,isnull([CoBuyerBusinessPhoneCountryCode],'') as [CoBuyerBusinessPhoneCountryCode]
		,isnull([SalesManagerID],'') as [SalesManagerID]
		,isnull([SalesManagerFullName],'') as [SalesManagerFullName]
		,isnull([FAndIManagerID],'') as [FAndIManagerID]
		,isnull([FAndIManagerFullName],'') as [FAndIManagerFullName]
		,[AAndHCost]
		,[AAndHReserve]
		,[AAndHCoverageAmount]
		,[AAndHPremium]
		,[AAndHRate]
		,[AAndHTermInMonths]
		,[AAndHProvider]
		,[CLCost]
		,[CLReserve]
		,[CLCoverageAmount]
		,[CLPremium]
		,[CLRate]
		,[CLTermInMonths]
		,[CLProvider]
		,[GapCost]
		,[GapReserve]
		,[GapCoverageAmount]
		,[GapPremium]
		,[GapRate]
		,[GapTermInMonths]
		,[GapProvider]
		,[LOECost]
		,[LOEReserve]
		,[LOECoverageAmount]
		,[LOEPremium]
		,[LOERate]
		,[LOETermInMonths]
		,[LOEProvider]
		,[MBICost]
		,[MBIReserve]
		,[MBICoverageAmount]
		,[MBIRate]
		,[MBIPremium]
		,[MBITermInMonths]
		,[MBIProvider]
		,[ServiceContractCost]
		,[ServiceContractReserve]
		,[ServiceContractCoverageAmount]
		,[ServiceContractRate]
		,[ServiceContractPremium]
		,[ServiceContractTermInMonths]
		,[ServiceContractProvider]
		,[file_log_id]
		,[file_log_detail_id]
		,suser_name()
		,getdate()
		,suser_name()
		,getdate()
       from  
			#temp with(nolock) 	   		
	   order by 
	        etl_dmi_sale_id

	/* Updated error description for invalid records in intermidate stage table */
	Update 
		a
	set
		a.is_error = b.is_err_rec,
		a.error_desc = b.err_description
	from 
		etl.dmi_sale a (nolock)
	inner join #temp b on 
		a.etl_dmi_sale_id = b.etl_dmi_sale_id
	where 
		b.is_err_rec = 1
 
 

    insert into error.records_2_validate 
       (
         source_sale_service_id
   	    ,table_desc_type
   	    ,source_error_desc 
   	    ,vin
		,parent_dealer_id
		,natural_key
   	    ,file_log_id
   	    ,file_log_detail_id
   	   
       )
   
    select 
         etl_dmi_sale_id
   	    ,'etl.dmi_sale'
   	    ,err_description
   	    ,vin
		,parent_dealer_id
		,natural_key
   	    ,file_log_id
   	    ,file_log_detail_id 
    from 
       #temp with(nolock) 
     where 
        is_err_rec = 1
   	    	and file_log_detail_id = @file_log_detail_id
	  
    
end
   
GO

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

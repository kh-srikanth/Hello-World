USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [etl].[move_d2d_dmi_service_raw_etl_2_stage]    Script Date: 1/7/2021 6:02:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
  ALTER procedure  [etl].[move_act_service_raw_etl_2_stage]   
	   
   @file_log_detail_id int

as 
	begin
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
	declare @geo_type_id int

	select 
	   md.parent_dealer_id as parent_dealer_ID
		,md.natural_key as natural_key
      ,[DV Dealer ID]
      ,[RO Number]
      ,[VIN]
      ,[Make]
      ,[Model]
      ,[Year]
      ,[RO Mileage]
      ,[Mileage Out]
      ,[Delivery Mileage]
      ,[Service Advisor Number]
      ,[Service Advisor Name]
      ,[Open Date]
      ,[Close Date]
      ,[Promise Time]
      ,[Promise Date]
      ,[Pickup Date]
      ,[Delivery Date]
      ,[RO Department]
      ,[Full Name]
      ,[Salutation]
      ,[First Name]
      ,[Middle Name]
      ,[Last Name]
      ,[Suffix]
      ,[Address Line 1]
      ,[Address Line 2]
      ,es.[City]
      ,es.[State]
      ,es.[Zip]
      ,[County]
      ,[Home Phone]
      ,[Work Phone]
      ,[Cell Phone]
      ,[Email 1]
      ,[Email 3]
      ,[Birth Date]
      ,[Email 2]
      ,[Block Phone]
      ,[Block Email]
      ,[Block Mail]
      ,[Opt Out]
      ,[Individual/Business Flag]
      ,[Customer Misc Sale]
      ,[Customer Total Sale]
      ,[Customer Gas/Oil/Grease Cost]
      ,[Customer Gas/Oil/Grease Sale]
      ,[Customer Labor Cost]
      ,[Customer Labor Sale]
      ,[Customer Misc Cost]
      ,[Customer Parts Cost]
      ,[Customer Parts Sale]
      ,[Customer Total Cost]
      ,[Customer Sublet Cost]
      ,[Customer Sublet Sale]
      ,[Internal Total Cost]
      ,[Internal Gas/Oil/Grease Cost]
      ,[Internal Gas/Oil/Grease Sale]
      ,[Internal Labor Cost]
      ,[Internal Labor Sale]
      ,[Internal Misc Cost]
      ,[Internal Misc Sale]
      ,[Internal Parts Cost]
      ,[Internal Parts Sale]
      ,[Internal Total Sale]
      ,[Internal Sublet Cost]
      ,[Internal Sublet Sale]
      ,[Total Labor Sale]
      ,[Total Misc Cost]
      ,[Total Misc Sale]
      ,[Total Sublet Cost]
      ,[Total Sublet Sale]
      ,[Total Tax]
      ,[Warranty Total Sale]
      ,[Warranty Gas/Oil/Grease Cost]
      ,[Warranty Gas/Oil/Grease Sale]
      ,[Warranty Labor Cost]
      ,[Warranty Labor Sale]
      ,[Warranty Misc Cost]
      ,[Warranty Misc Sale]
      ,[Warranty Parts Cost]
      ,[Warranty Parts Sale]
      ,[Warranty Total Cost]
      ,[Warranty Sublet Cost]
      ,[Warranty Sublet Sale]
      ,[file_process_detail_id]
      ,[process_id]
	  ,0 as is_err_rec
		,cast('' as varchar(500)) as err_description 
		,[Tech Number]
           into #temp   
	 from 
	    etl.atc_service es (nolock)
    inner join master.dealer md with(nolock) on 
	    es.[DV Dealer ID] = md.natural_key
	where 
		es.process_id = @file_log_detail_id

	 alter table #temp add vin_prefix varchar(10)
     update #temp set vin_prefix = left(vin,8)+' '+ substring(vin,len(vin)/2+2,1) 
	
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
		and [Cell Phone]is null 
		and [First Name] is null 
		and [Middle Name] is null 
		and [Last Name] is null
	insert into stg.repair_order_detail 
	 (	
      [parent_dealer_id]
      ,[natural_key]
      ,[src_dealer_code]
      ,[ro_number]
      ,[vin]
      ,[make]
      ,[model]
      ,[year]
      ,[mileage_in]
      ,[mileage_out]
      ,[delivery_odometer]
      ,[sa_number]
      ,[sa_name]
      ,[ro_open_date]
      ,[ro_close_date]
      ,[promise_time]
      ,[promise_date]
      ,[vehicle_pickup_date]
      ,[delivery_date]
      ,[dept_type]
      ,[cust_full_name]
      ,[cust_salutation_text]
      ,[cust_first_name]
      ,[cust_middle_name]
      ,[cust_last_name]
      ,[cust_suffix]
      ,[cust_address1]
      ,[cust_address2]
      ,[cust_city]
      ,[cust_state]
      ,[cust_zip_code]
      ,[cust_country]
      ,[cust_home_phone]
      ,[cust_work_phone]
      ,[cust_mobile_phone]
      ,[cust_email_address]
      ,[cust_business_email_address]
      ,[cust_birth_date]
      ,[cust_email_address2]
      ,[cust_do_not_call]
      ,[cust_do_not_email]
      ,[cust_do_not_mail]
      ,[cust_opt_out]
      ,[cust_ib_flag]
      ,[total_customer_aggregate_misc_cost]
      ,[total_customer_cost]
      ,[total_customer_gog_cost]
      ,[total_customer_gog_price]
      ,[total_customer_labor_cost]
      ,[total_customer_labor_price]
     ,[total_customer_misc_cost] --
      ,[total_customer_parts_cost]
      ,[total_customer_parts_price]
      ,[total_customer_price]
    ,[total_customer_sublet_cost]	--
    ,[total_customer_sublet_price]	--
      ,[total_internal_cost]
      ,[total_internal_gog_cost]
      ,[total_internal_gog_price]
      ,[total_internal_labor_cost]
      ,[total_internal_labor_price]
    ,[total_internal_misc_cost]		--
      ,[total_internal_misc_price]
      ,[total_internal_parts_cost]
      ,[total_internal_parts_price]
      ,[total_internal_price]
     ,[total_internal_sublet_cost] --
      ,[total_internal_sublet_price]
      ,[total_labor_price]
      ,[total_misc_cost]	--
      ,[total_misc_price]
      ,[total_sublet_cost]
      ,[total_sublet_price]
      ,[total_tax_price]
      ,[total_warranty_cost]
      ,[total_warranty_gog_cost]
      ,[total_warranty_gog_price]
      ,[total_warranty_labor_cost]
      ,[total_warranty_labor_price]
     ,[total_warranty_misc_cost]	--
      ,[total_warranty_misc_price]
      ,[total_warranty_parts_cost]
      ,[total_warranty_parts_price]
      ,[total_warranty_price]
     ,[total_warranty_sublet_cost]	--
      ,[total_warranty_sublet_price]
      ,[file_log_detail_id]
      ,[file_log_id]
      ,[created_date]
      ,[updated_date]
      ,[created_by]
      ,[updated_by]
      ,[vin_prefix]
	  ,tech_id
		)
	select 
		parent_dealer_id
		,natural_key
      ,[DV Dealer ID]
      ,[RO Number]
      ,[VIN]
      ,[Make]
      ,[Model]
      ,[Year]
      ,[RO Mileage]
      ,[Mileage Out]
      ,[Delivery Mileage]
      ,[Service Advisor Number]
      ,[Service Advisor Name]
      ,[Open Date]
      ,[Close Date]
      ,[Promise Time]
      ,[Promise Date]
      ,[Pickup Date]
      ,[Delivery Date]
      ,[RO Department]
      ,[Full Name]
      ,[Salutation]
      ,[First Name]
      ,[Middle Name]
      ,[Last Name]
      ,[Suffix]
      ,[Address Line 1]
      ,[Address Line 2]
      ,[City]
      ,[State]
      ,[Zip]
      ,[County]
      ,[Home Phone]
      ,[Work Phone]
      ,[Cell Phone]
      ,[Email 1]
      ,[Email 3]
      ,[Birth Date]
      ,[Email 2]
      ,[Block Phone]
      ,[Block Email]
      ,[Block Mail]
      ,[Opt Out]
      ,[Individual/Business Flag]
      ,cast ([Customer Misc Sale] as decimal(18,2))
      ,cast ([Customer Total Sale] as decimal(18,2))
      ,cast ([Customer Gas/Oil/Grease Cost] as decimal(18,2))
      ,cast ([Customer Gas/Oil/Grease Sale]as decimal(18,2))
      ,cast ([Customer Labor Cost] as decimal(18,2))
      ,cast ([Customer Labor Sale] as decimal(18,2))
	  ,iif(len([Customer Misc Cost]) = 0, 0.00,cast ([Customer Misc Cost] as decimal(18,2)))
     -- ,cast ([Customer Misc Cost] as decimal(18,2))
      ,cast ([Customer Parts Cost] as decimal(18,2))
      ,cast ([Customer Parts Sale] as decimal(18,2))
      ,cast ([Customer Total Cost] as decimal(18,2))
	  ,iif(len([Customer Sublet Cost]) =0,0.00,cast([Customer Sublet Cost] as decimal(18,2)))
   --   ,cast ([Customer Sublet Cost] as decimal(18,2))
	  ,iif(len([Customer Sublet Sale]) =0,0.00,cast([Customer Sublet Sale] as decimal(18,2)))
   --   ,cast ([Customer Sublet Sale] as decimal(18,2))
      ,cast ([Internal Total Cost] as decimal(18,2))
      ,cast ([Internal Gas/Oil/Grease Cost] as decimal(18,2))
      ,cast ([Internal Gas/Oil/Grease Sale] as decimal(18,2))
      ,cast ([Internal Labor Cost] as decimal(18,2))
      ,cast ([Internal Labor Sale] as decimal(18,2))
	  ,iif(len([Internal Misc Cost]) = 0, 0.00, cast([Internal Misc Cost] as decimal(18,2)))
    --  ,cast ([Internal Misc Cost] as decimal(18,2))
      ,cast ([Internal Misc Sale] as decimal(18,2))
      ,cast ([Internal Parts Cost] as decimal(18,2))
      ,cast ([Internal Parts Sale] as decimal(18,2))
      ,cast ([Internal Total Sale] as decimal(18,2))
	  ,iif(len([Internal Sublet Cost]) =0,0.00,cast([Internal Sublet Cost] as decimal(18,2)))
    --  ,cast ([Internal Sublet Cost] as decimal(18,2))
      ,cast ([Internal Sublet Sale] as decimal(18,2))
      ,cast ([Total Labor Sale] as decimal(18,2))
	  ,iif(len([Total Misc Cost]) =0,0.00,cast([Total Misc Cost] as decimal(18,2)))
	--  ,cast ([Total Misc Cost] as decimal(18,2))
      ,cast ([Total Misc Sale] as decimal(18,2))
      ,cast ([Total Sublet Cost] as decimal(18,2))
      ,cast ([Total Sublet Sale] as decimal(18,2))
      ,cast ([Total Tax] as decimal(18,2))
      ,cast ([Warranty Total Sale] as decimal(18,2))
      ,cast ([Warranty Gas/Oil/Grease Cost] as decimal(18,2))
      ,cast ([Warranty Gas/Oil/Grease Sale] as decimal(18,2))
      ,cast ([Warranty Labor Cost] as decimal(18,2))
      ,cast ([Warranty Labor Sale] as decimal(18,2))
	  ,iif(len([Warranty Misc Cost]) =0,0.00,cast([Warranty Misc Cost] as decimal(18,2)))
    --  ,cast ([Warranty Misc Cost] as decimal(18,2))
      ,cast ([Warranty Misc Sale] as decimal(18,2))
      ,cast ([Warranty Parts Cost] as decimal(18,2))
      ,cast ([Warranty Parts Sale] as decimal(18,2))
      ,cast ([Warranty Total Cost] as decimal(18,2))
	  ,iif(len([Warranty Sublet Cost]) =0,0.00,cast([Warranty Sublet Cost] as decimal(18,2)))
   --   ,cast ([Warranty Sublet Cost] as decimal(18,2))
      ,cast ([Warranty Sublet Sale] as decimal(18,2))
      ,[file_process_detail_id]
      ,[process_id]
		  ,getdate()
		  ,getdate()
		  ,suser_name()
		  ,suser_name()
		  ,vin_prefix
		  ,IIF([Tech Number] = null, ' ',[Tech Number])
       from  
			#temp 
	  			
	   order by process_id    

	/* Updated error description for invalid records in intermidate stage table */
	Update 
		a
	set
		a.is_error = b.is_err_rec,
		a.error_desc = b.err_description
	from 
		stg.repair_order_detail a (nolock)
	inner join #temp b on 
		a.file_log_id = b.process_id
	where 
		b.is_err_rec = 1


		  insert into error.records_2_validate 
       (
         source_sale_service_id
   	    ,table_desc_type
   	    ,source_error_desc 
   	    ,vin
   	   -- ,file_log_id
   	  -- ,file_log_detail_id
		,source_file_type
		,parent_dealer_id
		,natural_key
   	   
       )
   
    select 
         file_process_detail_id
   	    ,'etl.dmi_service'
   	    ,err_description
   	    ,vin
   	  --  ,file_log_id
   	   -- ,file_log_detail_id 
		,'DMI'
		,parent_dealer_id
		,natural_key
    from 
       #temp with(nolock) 
     where 
        is_err_rec = 1
   	    	and file_process_detail_id = @file_log_detail_id
	end

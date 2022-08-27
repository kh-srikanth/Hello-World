USE clictell_auto_etl
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

begin
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
	declare @geo_type_id int
	select distinct 
		--etl_fi_sale_id
		--,md.natural_key
		--,md.parent_dealer_id
		[DV Dealer ID] as src_dealer_code
		,[Vendor Dealer ID]
		,[Deal Number]
		,[Customer Number]
		,[Full Name]
		,[Salutation]
		,[First Name]
		,[Middle Name]
		,[Last Name]
		,[Suffix]
		,[Address Line 1]
		,[Address Line 2]
		,a.[City]
		,a.[State]
		,a.[Zip]
		,[County]
		,[Home Phone]
		,[Cell Phone]
		,[Work Phone]
		,[Email 1]
		,[Birth Date]
		,[Opt Out]
		,[Co-Buyer Customer Number]
		,[Co-Buyer Full Name]
		,[Co-Buyer Salutation]
		,[Co-Buyer First Name]
		,[Co-Buyer Middle Name]
		,[Co-Buyer Last Name]
		,[Co-Buyer Suffix]
		,[Co-Buyer Address Line 1]
		,[Co-Buyer Address Line 2]
		,[Co-Buyer City]
		,[Co-Buyer State]
		,[Co-Buyer Zip]
		,[Co-Buyer County]
		,[Co-Buyer Home Phone]
		,[Co-Buyer Cell Phone]
		,[Co-Buyer Work Phone]
		,[Co-Buyer Email 1]
		,[Co-Buyer Birth Date]
		,[Co-Buyer Opt Out]
		,[VIN]
		,[Year]
		,[Make]
		,[Model]
		,[Model Number]
		,[Exterior Color]
		,[Stock Number]
		,[Transmission]
		,[Engine Configuration]
		,[Trim]
		,[License Plate Number]
		,[Delivery Date]
		,[Delivery Mileage]
		,[Inventory Date] 
		,[process_id] as [file_log_id]
		,[file_process_detail_id] as [file_log_detail_id]
		,0 as is_err_rec
		,cast('' as varchar(500)) as err_description		
	into 
		#temp
	from  
		etl.atc_sales1 a with(nolock)
    inner join master.dealer md with(nolock) on 
	    a.[Vendor Dealer ID] = md.natural_key
	where 
		a.file_log_detail_id = @file_log_detail_id
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
		and [Customer Number] is null 
		and [First Name] is null 
		and [Middle Name] is null 
		and [Last Name] is null


	insert into [stg].[fi_sales]
	(
		[src_dealer_code]
		,[parent_dealer_id]
		,[deal_number_dms]
		,[buyer_id]
		,[buyer_full_name]
		,[buyer_salutation]
		,[buyer_first_name]
		,[buyer_middle_name]
		,[buyer_last_name]
		,[buyer_suffix]
		,[buyer_home_address]
		,[buyer_home_address_district]
		,[buyer_home_address_city]
		,[buyer_home_address_region]
		,[buyer_home_address_postal_code]
		,[buyer_home_address_country]
		,[buyer_homephone_number]
		,[buyer_mobilephone_number]
		,[buyer_officephone_number]
		,[buyer_personal_email_address]
		,[buyer_birth_date]
		,[buyer_optout]
		,[co_buyer_id]
		,[co_buyer_full_name]
		,[co_buyer_salutation]
		,[co_buyer_first_name]
		,[co_buyer_middle_name]
		,[co_buyer_last_name]
		,[co_buyer_suffix]
		,[co_buyer_home_address]
		,[co_buyer_home_address_district]
		,[co_buyer_home_address_city]
		,[co_buyer_home_address_region]
		,[co_buyer_home_address_postal_code]
		,[co_buyer_home_address_country]
		,[co_buyer_homephone_number]
		,[co_buyer_mobilephone_number]
		,[co_buyer_officephone_number]
		,[co_buyer_personal_email_address]
		,[co_buyer_birth_date]
		,[co_buyer_optout]
		,[vin]
		,[model_year]
		,[make]
		,[model]
		,[model_num]
		,[ext_clr_code]
		,[stock_id]
		,[transmission_desc]
		,[engine_descr]
		,[trim]
		,[license_num]
		,[delivery_date]
		,[delivery_odometer]
		,[inventory_date]
		,[file_log_id]
		,[file_log_detail_id]
		,[created_by]
		,[created_date]
		,[updated_by]
		,[updated_date]
	)
     select
		[src_dealer_code]
		,[Vendor Dealer ID]
		,[Deal Number]
		,[Customer Number]
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
		,[Cell Phone]
		,[Work Phone]
		,[Email 1]
		,[Birth Date]
		,[Opt Out]
		,[Co-Buyer Customer Number]
		,[Co-Buyer Full Name]
		,[Co-Buyer Salutation]
		,[Co-Buyer First Name]
		,[Co-Buyer Middle Name]
		,[Co-Buyer Last Name]
		,[Co-Buyer Suffix]
		,[Co-Buyer Address Line 1]
		,[Co-Buyer Address Line 2]
		,[Co-Buyer City]
		,[Co-Buyer State]
		,[Co-Buyer Zip]
		,[Co-Buyer County]
		,[Co-Buyer Home Phone]
		,[Co-Buyer Cell Phone]
		,[Co-Buyer Work Phone]
		,[Co-Buyer Email 1]
		,[Co-Buyer Birth Date]
		,[Co-Buyer Opt Out]
		,[VIN]
		,[Year]
		,[Make]
		,[Model]
		,[Model Number]
		,[Exterior Color]
		,[Stock Number]
		,[Transmission]
		,[Engine Configuration]
		,[Trim]
		,[License Plate Number]
		,[Delivery Date]
		,[Delivery Mileage]
		,[Inventory Date] --55
		,[file_log_id]
		,[file_log_detail_id]
		,suser_name()
		,getdate()
		,suser_name()
		,getdate()
       from  
			#temp with(nolock) 	   		
	   order by 
	        [stg].[fi_sales].[etl_fi_sale_id]
	Update 
		a
	set
		a.is_error = b.is_err_rec,				-- cant find stg.fi_sales.is_error
		a.error_desc = b.err_description
	from 
		[stg].[fi_sales] a (nolock)
	inner join #temp b on 
		a.etl_fi_sale_id = b.etl_fi_sale_id			---#temp.etl_fi_sale_id is from?
	where 
		b.is_err_rec = 1
    insert into error.records_2_validate			---cant find table -error. in database
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
         a.etl_fi_sale_id
   	    ,'etl.atc_sale1'
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

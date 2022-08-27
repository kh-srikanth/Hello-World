USE [auto_stg_customers]
GO
/****** Object:  StoredProcedure [customer].[query_segment_get]    Script Date: 11/23/2021 3:01:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER procedure [customer].[query_segment_get]     

declare
	 @account_id uniqueidentifier = '63E6B499-4CC0-4591-A489-6F7376E7E4E8',    
	 --@segmant_query nvarchar(max) = '{"queries":[{"element":"First Name","operator":"contains","secondOperator":"","value":"Warner","match":"","elementTypeId":1,"order":1}]}',
	 --'{"queries":[ { "element": "List Name","operator": "is","secondOperator": "","value": "1385","match": "or","order": "1"}, {"element": "Make","operator": "is","secondOperator": "","value": "Yamaha","match": "or","order": "2"},{"element": "Model","operator": "is","secondOperator": "","value": "Yamaha XVS 400 Dragstar","match": "or","order": "3"},{"element": "Year","operator": "contains","secondOperator": "","value": "2014","match": "","order": "4"}]}',     
	 -- = '{"queries":[{"element":"First Name","operator":"contains","secondOperator":"","value":"k","match":"or","order":"1"},{"element":"Last Name","operator":"contains","secondOperator":"","value":"s","match":"or","order":"2"},{"element":"Campaign Activity","operator":"opened","secondOperator":"","value":"last_3_months","match":"or","order":"3"}, {"element":"Date Added","operator":"is after","secondOperator":"","value":"01/01/2020","match":"","order":"4"}]}',    
	 @segmant_query nvarchar(max),
	 @operator varchar(50) = 'or',    
	 @search NVARCHAR(50) = NULL,    
	 @Offset int = 0,    
	 @page_no INT = 1,    
	 @page_size INT = 100,    
	 @sort_column NVARCHAR(20) = 'CreatedDate',    
	 @sort_order NVARCHAR(20) = 'ASC',    
	 @list_type_id int =3,   
	 @campaign_type varchar(50) = 'Download',
	 @campaign_id int = null,
	 @campaing_run_id int = null,
	 @segment_id int = 4286,
	 @trigger_json varchar(max) = null   
Begin    
    /* Setup */      
           
	SET NOCOUNT ON    

	Print 'Step 1 ' + Convert(varchar(50), getdate(), 108)


    
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL					DROP TABLE #temp    
	IF OBJECT_ID('tempdb..#segments') IS NOT NULL				DROP TABLE #segments    
	IF OBJECT_ID('tempdb..#queries') IS NOT NULL				DROP TABLE #queries    
	IF OBJECT_ID('tempdb..#cust_coupon') IS NOT NULL			DROP TABLE #cust_coupon    
	IF OBJECT_ID('tempdb..#temp_final_coupon') IS NOT NULL		DROP TABLE #temp_final_coupon 
	IF OBJECT_ID('tempdb..#cust_images') IS NOT NULL			DROP TABLE #cust_images 
	IF OBJECT_ID('tempdb..#queries1') IS NOT NULL				DROP TABLE #queries1    
	IF OBJECT_ID('tempdb..#campaign_activity') IS NOT NULL		DROP TABLE #campaign_activity    
	IF OBJECT_ID('tempdb..#date_added') IS NOT NULL				DROP TABLE #date_added    
	IF OBJECT_ID('tempdb..#custTemp') IS NOT NULL				DROP TABLE #custTemp    
	IF OBJECT_ID('tempdb..#cust_Temp') IS NOT NULL				DROP TABLE #cust_Temp   
	IF OBJECT_ID('tempdb..#temp_custvehicle') IS NOT NULL		DROP TABLE #temp_custvehicle
	IF OBJECT_ID('tempdb..#tempro') IS NOT NULL					DROP TABLE #tempro
	IF OBJECT_ID('tempdb..#temp_count') IS NOT NULL				DROP TABLE #temp_count
	IF OBJECT_ID('tempdb..#temp_sales') IS NOT NULL				DROP TABLE #temp_sales
	IF OBJECT_ID('tempdb..#tempsales') IS NOT NULL				DROP TABLE #tempsales
	IF OBJECT_ID('tempdb..#temp_ro') IS NOT NULL				DROP TABLE #temp_ro
	IF OBJECT_ID('tempdb..#temp_coupon_query') IS NOT NULL		DROP TABLE #temp_coupon_query
	IF OBJECT_ID('tempdb..#temp_text_query') IS NOT NULL		DROP TABLE #temp_text_query
	IF OBJECT_ID('tempdb..#temp_Images_query') IS NOT NULL		DROP TABLE #temp_Images_query
	IF OBJECT_ID('tempdb..#temp_dealer') IS NOT NULL			DROP TABLE #temp_dealer
	IF OBJECT_ID('tempdb..#cust_distinct_Temp') IS NOT NULL		DROP TABLE #cust_distinct_Temp
	IF OBJECT_ID('tempdb..#temp_lead_user') IS NOT NULL			DROP TABLE #temp_lead_user
	IF OBJECT_ID('tempdb..#final_print_result') IS NOT NULL 	DROP TABLE #final_print_result
	IF OBJECT_ID('tempdb..#temp_coupon_counts') IS NOT NULL 	DROP TABLE #temp_coupon_counts
	IF OBJECT_ID('tempdb..#cust_text') IS NOT NULL 	DROP TABLE #cust_text
	IF OBJECT_ID('tempdb..#temp_count_Customers') IS NOT NULL 	DROP TABLE #temp_count_Customers
	drop table if exists #temp_count_download


	 declare @total_count int = 0         
			,@query nvarchar(max)    
			,@result varchar(max)    
			,@segment_query_count int    
			,@campaign_activity_query_count int    
			,@date_added_query_count int    
			,@email_client_query_count int    
			,@signup_source_query_count int   
			,@dms_ro_query_count int
			,@dms_sales_query_count int
			,@parent_dealer_id varchar(2000)    
			,@id int
			,@con_Operator varchar(10)
			,@con int = 0    
			,@campaign_type_id int
			,@row_count int
			,@print_coupon_id int
			,@coupon_html nvarchar(max)
			,@sql nvarchar(max)
			,@position_id int
			,@coupon_id int
			,@email_optin int
			,@mail_optin int
			,@phone_optin int
			,@image_url nvarchar(4000)
			,@priority int
			,@is_default bit
			,@media_type varchar(10)
			,@segment_name varchar(500)
    
	set @search = Isnull(@search, '')

	Create table #queries
	(
		query varchar(4000),
		operator varchar(25),
		id int,
		[Brackets] varchar(5),
		is_processed bit default (0)
	)

	Create table #temp ([customer_id] Varchar(50),    
		   customer_guid uniqueidentifier,    
		   [primary_email] [varchar](250),    
		   [first_name] [varchar](250),    
		   [middle_name] [varchar](250),    
		   [last_name] [varchar](250),    
		   [address_line] [varchar](2000), 
		   [address1] varchar(250),
		   [address2] varchar(250),
		   [city] varchar(50),
		   [state] varchar(50),
		   [country] varchar(50),
		   [zip_code] varchar(50),
		   [primary_phone_number] [varchar](300),    
		   [tags] varchar(max),    
		   do_not_email varchar(5),    
		   do_not_mail varchar(5),
		   do_not_call varchar(5),
		   [created_dt] [datetime],    
		   is_deleted bit,    
		   account_id uniqueidentifier,
		   [addresses] varchar(2000),
		   phone_numbers varchar(2000),
		   birth_date date,
		   make varchar(50),	
		   model varchar(50), 
		   model_year varchar(4), 
		   [trim] varchar(50), 
		   Engine varchar(50), 
		   fuel_type varchar(50),
		   vin varchar(20),
		   last_ro_date int,
		   cust_type varchar(10),
		   last_ro_mileage decimal(18,2),
		   avg_mileage_per_day decimal(18,2),
		   vehicle_type varchar(10),
		   redius decimal(18,2),
		   last_visit_date int,
		   master_customer_id int, 
		   master_vehicle_id int,
		   cust_status varchar(25),
		   lead_status_id varchar(500),
		   lead_source_id varchar(500),
		   parent_dealer_id int,
		   suffix varchar(50),
		   cust_title varchar(50)
		  )    
    
	Create table #custTemp ([customer_id] Varchar(50),    
		   customer_guid uniqueidentifier,    
		   [primary_email] [varchar](250),    
		   [first_name] [varchar](250),    
		   [middle_name] [varchar](250),    
		   [last_name] [varchar](250),    
		   [address_line] [varchar](2000),    
		   [primary_phone_number] [varchar](300),    
		   [tags] varchar(max),    
		   do_not_email varchar(5),   
		   do_not_mail varchar(5),
		   do_not_call varchar(5),
		   [created_dt] [datetime],
		   [addresses] varchar(2000),
		   phone_numbers varchar(2000),
		   birth_date date,
		   make varchar(50), 
		   model varchar(50), 
		   model_year varchar(4), 
		   [trim] varchar(50), 
		   Engine varchar(50), 
		   fuel_type varchar(50),
		   last_ro_date int,
		   cust_type varchar(10),
		   redius decimal(18,2),
		   avg_mileage_per_day decimal(18,2),
		   vehicle_type varchar(10),
		   [address1] varchar(250),
		   [address2] varchar(250),
		   [city] varchar(50),
		   [state] varchar(50),
		   [country] varchar(50),
		   [zip_code] varchar(50),
		   last_visit_date int,
		   last_ro_mileage decimal(18,2),
		   ro_number varchar(50), 
		   ro_close_date int, 
		   total_customer_pay decimal(18,2), 
		   total_warranty_pay decimal(18,2), 
		   total_internal_pay decimal(18,2), 
		   total_ro_amount decimal(18,2), 
		   pay_type varchar(50), 
		   master_customer_id int, 
		   master_vehicle_id int, 
		   vin varchar(20),
		   purchase_date int,
		   nuo_flag varchar(25),
		   cust_status varchar(25),
		   lead_status_id varchar(500),
		   lead_source_id varchar(500),
		   parent_dealer_id int,
		   suffix varchar(50),
		   cust_title varchar(50)

		 )        
    
	Create table #tempro
	(
		ro_number varchar(50),
		ro_close_date int,
		total_customer_pay decimal(18,2),
		total_warranty_pay decimal(18,2),
		total_internal_pay decimal(18,2),
		total_ro_amount decimal(18,2),
		pay_type varchar(10),
		master_customer_id int,
		master_vehicle_id int,
		vin varchar(20),
		cust_dms_number varchar(50)
	)

	Create table #tempSales
	(
		deal_number_dms varchar(50), 
		purchase_date int,  
		nuo_flag varchar(25), 
		master_customer_id int, 
		master_vehicle_id int, 
		vin varchar(20), 
		cust_dms_number varchar(50)
	)

	Create table #cust_Temp (
		[customer_id] Varchar(50),    
	    customer_guid uniqueidentifier,    
	    [primary_email] [varchar](250),    
	    [first_name] [varchar](250),    
	    [middle_name] [varchar](250),    
	    [last_name] [varchar](250),    
	    [address_line] [varchar](2000),    
	    [primary_phone_number] [varchar](300),    
	    [tags] varchar(max),    
	    do_not_email varchar(5),   
	    do_not_mail varchar(5),
	    do_not_call varchar(5),
	    [created_dt] [datetime],
	    make varchar(50), 
	    model varchar(50), 
	    model_year varchar(4), 
	    [address1] varchar(250),
	    [address2] varchar(250),
	    [city] varchar(50),
	    [state] varchar(50),
	    [country] varchar(50),
	    [zip_code] varchar(50),
		master_customer_id int,
		master_vehicle_id int,
		vin varchar(20),
		parent_dealer_id int,
		suffix varchar(50),
		cust_title varchar(50)
	)  

	Create table #cust_coupon
	(
		id int identity(1,1),
		customer_id Varchar(50),
		master_customer_id int,
		vin varchar(20),
		print_coupon_id int,
		priority_id int,
		is_default bit,
		position_id int,
		position1 nvarchar(max) null,
		rnk int
	)

	Create table #cust_images
	(
		customer_id Varchar(50),
		master_customer_id int,
		vin varchar(20),
		print_image_id int,
		priority_id int,
		is_default bit,
		position_id int,
		position1 nvarchar(4000) null
	)

	Create table #cust_text
	(
		id int identity(1,1),
		customer_id Varchar(50),
		master_customer_id int,
		vin varchar(20),
		print_text_id int,
		priority_id int,
		is_default bit,
		position_id int,
		position1 nvarchar(max) null
	)

	Print 'Step 1.1 ' + Convert(varchar(50), getdate(), 108)

	if (@segment_id is not null)
	begin
		--select @segmant_query = segment_query from customer.segments (nolock) where segment_id = @segment_id
		select @segmant_query = segment_query, @list_type_id = list_type_id, @segment_name = segment_name from customer.segments (nolock) where segment_id = @segment_id
		print @segmant_query
		print @list_type_id
	end

	Print 'Step 1.2 ' + Convert(varchar(50), getdate(), 108)


	if (@trigger_json is not null)
	begin
		set @segmant_query = Json_Modify(@segmant_query, 'append $.queries', @trigger_json)
	end

	Print 'Step 2 ' + Convert(varchar(50), getdate(), 108)

	select * into #temp_dealer from clictell_stg_auto_master.[master].dealer (nolock)

	Print 'Step 3 ' + Convert(varchar(50), getdate(), 108)
   
	select @parent_dealer_id = COALESCE(@parent_dealer_id + ', ' + Cast(parent_dealer_id as varchar(50)), Cast(parent_dealer_id as varchar(50)))  
	from  clictell_stg_auto_master.[master].[dealer_hierarchy] (@account_id)

	Print 'Step 4 ' + Convert(varchar(50), getdate(), 108)
	
	SELECT 
		  element
		, operator
		, secondOperator
		--,[value]
		, (case when [type] = 1 then [value] else (select [value] from OpenJson(a.[value]) where [key] = 'endDate') end) as [value]
		, [match]
		, [order] as [id]
	into 
		#segments 
	FROM
	(
		SELECT 
			Json_Value([value], '$.element') as element
			,Json_Value([value], '$.operator') as operator
			,Json_Value([value], '$.secondOperator') as secondOperator
			,(Case when Json_Value([value], '$.value') is not null then Json_Value([value], '$.value') else Json_Query([value], '$.value') end) as [value]
			,Json_Value([value], '$.match') as [match]
			,Json_Value([value], '$.order') as [order]
			,(Case when Json_Value([value], '$.value') is not null then 1 else 2 end) as [type]
			--,Json_Value([value], '$.elementTypeId') as elementTypeId
		FROM 
		OPENJSON( @segmant_query, '$.queries')     
	) AS a

	if (@list_type_id = 2)    
	Begin    
		--Print 'DMS'
		--Print @parent_dealer_id
		--Print '1'

		Print 'Step 5 ' + Convert(varchar(50), getdate(), 108)

		select 
			a.cust_dms_number, Cast(a.vin as varchar(20)) as vin, b.cust_first_name, b.cust_middle_name, b.cust_last_name, Isnull(b.ncoa_address1, b.cust_address1) as cust_address1, Isnull(b.ncoa_address2, b.cust_address2) as cust_address2, 
			Isnull(b.ncoa_city, b.cust_city) as cust_city, b.cust_country, Isnull(b.ncoa_zip_code, b.cust_zip_code) as cust_zip_code, Isnull(b.ncoa_zip_code4, b.cust_zip_code4) as cust_zip_code4,
			b.cust_state_code,b.cust_email_address1, b.cust_email_address2, b.cust_work_email_address, 
			(Case when Len(Isnull(b.[cust_mobile_phone],'')) > 0 then b.[cust_mobile_phone]
				 when Len(Isnull(b.[cust_home_phone],'')) > 0 then b.[cust_home_phone]
				 when Len(Isnull(b.[cust_work_phone],'')) > 0 then b.[cust_work_phone]
			else ''
			end) as primary_phone_number,
			b.cust_birth_date, c.make, c.model, c.model_year, c.fuel_type, c.vehicle_trim, a.last_ro_date, 
			--Cast(Cast(b.last_activity_date as varchar(10)) as date) as active_date, 
			b.last_activity_date,b.active_dt as active_date,
			b.inactive_date, (Case when b.customer_type = 'F' then 'Fleet' when b.customer_type = 'B' then 'Business' else 'Resident' end) as customer_type, Isnull(a.last_ro_mileage, 0) as last_ro_mileage, c.avg_mileage_per_day,
			c.vehicle_type, b.cust_do_not_email, b.cust_do_not_mail, b.cust_do_not_call, b.cust_miles_distance as [Redius],
			--Cast(Cast(LEFT(CONVERT(VARCHAR,(geography::Point(41.0224, -73.6234, 4326).STDistance(geography::Point(ISNULL(latitude,0), ISNULL(longitude,0), 4326))/1000)),5) as decimal(18,2)) * 0.621371 as decimal(18,2)) as [Redius],
			a.natural_key, a.parent_dealer_id, a.master_customer_id, a.master_vehicle_id, b.cust_status, b.cust_suffix, b.cust_salutation_text
		into #temp_custvehicle
		from clictell_stg_auto_master.master.cust_2_vehicle a (nolock)
		inner join clictell_stg_auto_master.master.customer b (nolock) on a.master_customer_id = b.master_customer_id
		inner join clictell_stg_auto_master.master.vehicle c (nolock) on a.master_vehicle_id = c.master_vehicle_id
		--inner join master.repair_order_header d (nolock) on a.master_customer_id = d.master_customer_id and a.master_vehicle_id = d.master_vehicle_id
		where Isnull(a.is_deleted, 0) = 0  and a.parent_dealer_id in (select [value] from string_split(@parent_dealer_id,',')) and a.inactive_date is null
		--and b.cust_full_name not like '%Unknown' and Len(b.cust_full_name) > 0 --and b.customer_type = 'C'

		Print 'Step 5.1 ' + Convert(varchar(50), getdate(), 108)
		
		select distinct ro_number, ro_close_date, total_customer_price, total_warranty_price, total_internal_price, total_repair_order_price as total_ro_amount, 
		(Case when total_customer_price > 0  then 'CP/' else '' end) + (Case when total_warranty_price > 0  then 'WP/' else '' end) + (Case when total_internal_price > 0  then 'IP/' else '' end) as pay_type,
		master_customer_id, master_vehicle_id, Cast(vin as varchar(20)) as vin, cust_dms_number
		into #temp_ro
		from clictell_stg_auto_master.master.repair_order_header (nolock)
		where parent_dealer_id in (select [value] from string_split(@parent_dealer_id,',')) and Isnull(is_deleted, 0) = 0
		and ro_status = 'COMPLETED'

		Print 'Step 5.2 ' + Convert(varchar(50), getdate(), 108)

		select distinct deal_number_dms, purchase_date,  Ltrim(Rtrim(nuo_flag)) as nuo_flag, master_customer_id, master_vehicle_id, vin, cust_dms_number
		into #temp_sales
		from clictell_stg_auto_master.master.fi_sales with (nolock)
		where parent_dealer_id in (select [value] from string_split(@parent_dealer_id,',')) 
		and deal_status in ('Sold', 'Booked', 'Booked/Recapped', 'Finalized')

		Print 'Step 5.3 ' + Convert(varchar(50), getdate(), 108)

		Insert into #tempro (ro_number, ro_close_date, total_customer_pay, total_warranty_pay, total_internal_pay, total_ro_amount, pay_type, master_customer_id, master_vehicle_id, vin, cust_dms_number)
		select ro_number, ro_close_date, total_customer_price, total_warranty_price, total_internal_price, total_ro_amount, pay_type, master_customer_id, master_vehicle_id, Cast(vin as varchar(20)) as vin, cust_dms_number from #temp_ro

		Print 'Step 5.6 ' + Convert(varchar(50), getdate(), 108)
	
		Insert into #tempSales (deal_number_dms, purchase_date, nuo_flag, master_customer_id, master_vehicle_id, vin, cust_dms_number)
		select deal_number_dms, purchase_date,  nuo_flag, master_customer_id, master_vehicle_id, vin, cust_dms_number from #temp_sales

		Print 'Step 5.7 ' + Convert(varchar(50), getdate(), 108)

		Insert into #temp (customer_id, customer_guid, primary_email, first_name, middle_name, last_name, address_line, primary_phone_number, tags, do_not_email, created_dt, is_deleted, 
						   account_id, [addresses], phone_numbers, birth_date, make, model, model_year, [trim], Engine, fuel_type, last_ro_date, cust_type, last_ro_mileage, avg_mileage_per_day, 
						   vehicle_type, do_not_mail, do_not_call, redius, [address1], [address2], [city], [state], [country], [zip_code], last_visit_date, master_customer_id, master_vehicle_id, 
						   vin, cust_status, parent_dealer_id, suffix,cust_title)    
		select distinct cust_dms_number, null as customer_guid, lower(cust_email_address1) as [primary_email], cust_first_name as first_name, cust_middle_name as [middle_name], cust_last_name as [last_name],    
		Isnull(cust_address1,'') + ' ' + Isnull(cust_address2, '') + ' ' + Isnull(cust_city, '') + ' ' + Isnull(cust_state_code,'') + ' ' + Isnull(cust_zip_code, '')  as [address_line], 
		primary_phone_number as [primary_phone_number], '' as [tags], cust_do_not_email as do_not_email,
		--(Case when cust_do_not_email = 0 then 'No' else 'Yes' end) as do_not_email, 
		active_date as [created_dt], 0 as is_deleted, @account_id,    
		'{"addresses":[{"street":"' + Isnull(cust_address1,'') + ' ' + Isnull(cust_address2, '') + '","city":"' + Isnull(cust_city, '') + '","state":"'+ Isnull(cust_state_code,'') + '","country":"US","zip":"' + isnull(cust_zip_code, '') + ' ' + Isnull(cust_zip_code4,'') + '"}]}' as [addresses],
		'{"phoneNumbers":[{"phoneType": "Mobile","countryCode": "1","phoneNumber": "' + Isnull(primary_phone_number, '') + '","isPrimary":"0"}]}' as phone_numbers, cust_birth_date as birth_date,
		make , model , model_year, vehicle_trim as [trim], '' as Engine, fuel_type, last_ro_date, customer_type, last_ro_mileage, avg_mileage_per_day, vehicle_type, 
		cust_do_not_mail, cust_do_not_call,
		--(Case when cust_do_not_mail = 0 then 'No' else 'Yes' end) as cust_do_not_mail, (Case when cust_do_not_call = 0 then 'No' else 'Yes' end) as cust_do_not_call, 
		[Redius], cust_address1, cust_address2, cust_city, cust_state_code, cust_country, cust_zip_code + (Case when Len(cust_zip_code4) > 0 then '-' + cust_zip_code4  else '' end)
		, last_activity_date, master_customer_id, master_vehicle_id, vin, cust_status, parent_dealer_id, cust_suffix, cust_salutation_text
		--from 
		--	clictell_auto_master.[master].customer a with (nolock)
		from #temp_custvehicle

		Print 'Step 5.8 ' + Convert(varchar(50), getdate(), 108)

	End   
	else if (@list_type_id in (3, 4, 1, 5))    
	Begin 
		Print 'OEM List'
		Declare @list_id varchar(100)

		select @list_id = [value] from #segments where Element = 'List Name'
		print @list_id
		
		DECLARE @split_list_id TABLE (list_id varchar(10))

		Insert into @split_list_id
		select value from STRING_SPLIT(@list_id, ',')

		--select @list_id = list_id
		--from [list].[lists] a (nolock)
		--where list_name in (select value from #segments where Element = 'OEM')

		print @list_id

		Insert into #temp (customer_id, customer_guid, primary_email, first_name, middle_name, last_name, address_line, primary_phone_number, tags, do_not_email, created_dt, is_deleted, 
						   account_id, [addresses], phone_numbers, birth_date, make, model, model_year, [trim], Engine, fuel_type, [address1], [address2], [city], [state], [country], 
						   [zip_code], do_not_mail, do_not_call, parent_dealer_id, [vin],last_ro_date)    
		select  a.customer_id, customer_guid, ltrim(rtrim([primary_email])) as [primary_email], [first_name], [middle_name], [last_name], [address_line],     
		ltrim(rtrim([primary_phone_number])) as [primary_phone_number], [tags], do_not_email, a.[created_dt], a.is_deleted, a.account_id, addresses, phone_numbers, birth_date,
		make, model, [Year],  trim_code as [trim], '' as Engine, '' as fuel_type, address_line, '' as address2, a.city, a.[state], 'US', zip, do_not_mail, do_not_phone, c.parent_dealer_id,
		b.vin, Convert(varchar(10), last_service_date, 112)
		from     
		customer.customers a with (nolock)    
		inner join #temp_dealer c on a.account_id = c._id
		left outer join customer.vehicles b with (nolock) on a.customer_id = b.customer_id
		where     
			a.is_deleted = 0 
		and a.account_id = @account_id    
		and @list_type_id in (select list_type_id from [list].[lists] b inner join (select [value] from string_split(a.list_ids,',')) c on b.list_id = c.[value])
		and (@list_id is null or  EXISTS (SELECT *
		            FROM   
						@split_list_id w
					WHERE  
						Charindex(',' + w.list_id + ',', ',' + list_ids + ',') > 0)
			)

	end

	insert into #queries
	select * from  [customer].[get_segment_conditions](@segmant_query)

	Print 'Step 6 ' + Convert(varchar(50), getdate(), 108)


	--select @segment_query_count = count(*) from #queries1 where [filter_condition] is not null    
	select @campaign_activity_query_count = count(*) from #segments where element = 'Campaign Activity'    
	select @date_added_query_count = count(*) from #segments where element = 'Date Added'    
	select @email_client_query_count = count(*) from #segments where element = 'Email Client'    
	select @signup_source_query_count = count(*) from #segments where element = 'Signup Source'  
	select @segment_query_count = count(*) from #segments where element in ('First Name', 'Last Name', 'Address', 'Phone Number', 'Tag Name', 'Birthday', 'Email Address', 'Location', 'Email Marketing Status', 'Churn Score', 
																			'Customer Type', 'Customer Subscriptions', 'Make', 'Model', 'Year', 'Trim', 'Engine', 'Fuel_Type', 'Customer Type', 'City', 'State', 'Zipcode', 'Miles Radius', 
																			'Daily Average Mileage', 'Vehicle Type', 'Email Optout', 'SMS Optout', 'Print Optout', 'Last Service Date', 'Visit Date', 'Last RO Mileage', 'Customer Pay Amount',
																			'Warranty Pay Amount','Internal Pay Amount','RO Total Amount','RO Close Date','Pay Type', 'Sale Date', 'Sale Type', 'Area Code', 'Status', 'Modal Year', 
																			'Lead Status', 'Lead Source', 'Customer Status')
	
	Print 'Step 7 ' + Convert(varchar(50), getdate(), 108)

	SELECT @result = SUBSTRING((SELECT ' ' + (case when Brackets = '(' then Brackets + query else '' + query end) +  (case when Brackets = ')' then Brackets else '' end) + ' ' + operator    
	FROM #queries    
	order by id    
	FOR XML PATH('')), 0, 9999)    

	Print 'Step 8 ' + Convert(varchar(50), getdate(), 108)

	set @result = (Case when reverse(substring(reverse(@result), 1, 4)) like '%or%' or substring(reverse(@result), 1, 4) like '%and%' then substring(@result, 1, (Len(@result) -  charindex(' ', reverse(@result), 1))) else @result end) 

	Print 'Step 9 ' + Convert(varchar(50), getdate(), 108)

	if(@segment_query_count > 0 or @list_type_id = 3)    
	BEGIN    

	Print 'Step 10 ' + Convert(varchar(50), getdate(), 108)

	
		CREATE NONCLUSTERED INDEX Idx_temp ON #temp(master_customer_id, master_vehicle_id)
		CREATE NONCLUSTERED INDEX Idx_tempro ON #tempro(master_customer_id, master_vehicle_id)
		CREATE NONCLUSTERED INDEX Idx_tempSales ON #tempSales(master_customer_id, master_vehicle_id)
		
		SET @query = 'select distinct cu.customer_id,     
				cu.customer_guid,    
				ltrim(rtrim(cu.[primary_email])),     
				cu.[first_name],    
				cu.[middle_name],    
				cu.[last_name],    
				cu.[address_line],    
				ltrim(rtrim(cu.[primary_phone_number])),    
				cu.[tags],    
				do_not_email,   
				do_not_mail,   
				do_not_call,   
				cu.[created_dt], 
				cu.addresses,
				cu.phone_numbers,
				cu.birth_date,
				cu.make,
				cu.model,
				cu.model_year,
				cu.[trim],
				cu.Engine,
				cu.fuel_type,
				last_ro_date,
				cu.cust_type,
				redius, 
				avg_mileage_per_day,
				vehicle_type,
				[address1],
				[address2],
				[city],
				[state],
				[country],
				[zip_code],
				last_visit_date,
				last_ro_mileage,'
	SET @query = @query + (Case when (select count(*) from #segments where element in ('Last RO Mileage', 'Customer Pay Amount','Warranty Pay Amount','Internal Pay Amount','RO Total Amount','RO Close Date','Pay Type')) > 0
		then   'ro_number, 
				ro_close_date, 
				total_customer_pay, 
				total_warranty_pay, 
				total_internal_pay, 
				total_ro_amount, 
				pay_type,'
				else 
				'0 as ro_number, 
				19000101 as ro_close_date, 
				0 as total_customer_pay, 
				0 as total_warranty_pay, 
				0 as total_internal_pay, 
				0 as total_ro_amount, 
				'''' as pay_type,
				' end)
	SET @query = @query + 
				'cu.master_customer_id, 
				cu.master_vehicle_id, 
				cu.vin,'
	SET @query = @query + (Case when (select count(*) from #segments where element in ('Sale Date', 'Sale Type')) > 0
		then   'ts.purchase_date,
				ts.nuo_flag,'
				else
				'
				19000101 as purchase_date,
				'''' as nuo_flag,'
				end)
	SET @query = @query + 
				'cu.cust_status,
				lead_status_id, 
				lead_source_id,
				parent_dealer_id,
				suffix,
				cust_title
				from #temp cu with(nolock,readuncommitted) '
	SET @query = @query + (Case when (select count(*) from #segments where element in ('Last RO Mileage', 'Customer Pay Amount','Warranty Pay Amount','Internal Pay Amount','RO Total Amount','RO Close Date','Pay Type')) > 0
		then   'left outer join #tempro trp on cu.master_customer_id = trp.master_customer_id and cu.master_vehicle_id = trp.master_vehicle_id' else '' end)
	SET @query = @query + (Case when (select count(*) from #segments where element in ('Sale Date', 'Sale Type')) > 0
		then   'left outer join #tempSales ts on cu.master_customer_id = ts.master_customer_id and cu.master_vehicle_id = ts.master_vehicle_id ' else '' end)
	SET @query = @query +  
				' where 1 = 1 and ' +
				--where (' + (Case when Len(@result) > 0 then REPLACE(REPLACE(REPLACE(@result,'&#x0D;',''),'&lt;', '<'),'&gt;', '>') else '1 = 1' end) + ') and cu.is_deleted = 0 and cu.account_id=''' + convert(varchar(100), @account_id) + ''''    
				' cu.is_deleted = 0 and cu.account_id=''' + convert(varchar(100), @account_id) + ''' and (' + (Case when Len(@result) > 0 then REPLACE(REPLACE(REPLACE(@result,'&#x0D;',''),'&lt;', '<'),'&gt;', '>') else '1 = 1' end) + ')  '    
		
	print @query

	  INSERT INTO #custTemp    
	  EXEC sp_executesql @query    

	  	Print 'Step 11' + Convert(varchar(50), getdate(), 108)
   
	END    




	


	--Declare @cc int
	--Print 'Count'
	--select @cc = count(*) from #temp
	--Print @cc

	--select @cc = count(*) from #custTemp
	--Print @cc
	Print 'Step 12' + Convert(varchar(50), getdate(), 108)

	if(@campaign_activity_query_count > 0)    
	begin    

	Print 'Step 13' + Convert(varchar(50), getdate(), 108)
      
		insert into #queries    
		select     
		(Case When [value] = 'last_3_months' then ' b.[Leass then 3 Months] = 1 '    
			When [value] = 'last_7_days' then ' b.[Leass then 7 Days] = 1 '    
			When [value] = 'last_1_month' then ' b.[Leass then 3 Months] = 1 '    
			else     
			' b.[Leass then 7 Days] = 1 '    
		End ),    
		Match, Id, '', 0     
		from     
		#segments    
		where     
		Element in ('Campaign Activity')  

	Print 'Step 14' + Convert(varchar(50), getdate(), 108)

	
		SELECT DISTINCT a.*,     
		(case when DateDiff(day, a.start_dt, getdate()) <= 7 then 1 else 0 end) as [Leass then 7 Days],    
		(case when DateDiff(Month, a.start_dt, getdate()) <= 1 then 1 else 0 end) as [Leass then 1 Month],    
		(case when DateDiff(Month, a.start_dt, getdate()) <= 3 then 1 else 0 end) as [Leass then 3 Months]    
		INTO #campaign_activity    
		FROM #segments as T    
		CROSS APPLY  [customer].[segment_campaign_activity_get] (T.Element, T.Operator,T.Value, @account_id) as a    
		WHERE T.Element in ('Campaign Activity')    
        
			Print 'Step 15' + Convert(varchar(50), getdate(), 108)


	end    

		Print 'Step 16' + Convert(varchar(50), getdate(), 108)


	if(@date_added_query_count > 0)    
	begin    

	Print 'Step 17' + Convert(varchar(50), getdate(), 108)

		insert into #queries    
		select     
		'c.start_dt ' +     
			(Case when Operator = 'is' then ' = ''' + cast([Value] as varchar(25)) + ''''    
			when Operator = 'is after' then ' > ''' + cast([Value] as varchar(25)) + ''''    
			when Operator = 'is before' then ' < ''' + cast([Value] as varchar(25)) + ''''    
			else    
			' = ' + cast([Value] as varchar(25))    
			end),     
		Match, Id, '', 0     
		from     
		#segments    
		where     
		Element in ('Date Added')    
    
		SELECT DISTINCT a.*    
		INTO #date_added    
		FROM #segments as T    
		CROSS APPLY  [customer].[segment_campaign_activity_get] (T.Element, T.Operator,T.Value, @account_id) as a    
		WHERE T.Element in ('Date Added')    
	end    

		Print 'Step 18' + Convert(varchar(50), getdate(), 108)

	Declare @str nvarchar(max)    
	set @str =  'select a.[customer_id], a.customer_guid, a.[primary_email], a.[first_name], a.[middle_name], a.[last_name], a.[address_line], a.[primary_phone_number],' 
	set @str += ' a.[tags], a.do_not_email, a.do_not_mail, a.do_not_call, a.[created_dt], a.make, a.model, a.model_year, address1, address2, city, state, country, [zip_code], '
	set @str += ' a.master_customer_id, a.master_vehicle_id, a.vin, a.parent_dealer_id, suffix,cust_title '
	set @str += ' from #custTemp a '    
      
	select @str += ' inner join #campaign_activity b on a.customer_id = b.customer_id' from #segments where Element = 'Campaign Activity'    
	select @str += ' inner join #date_added c on a.customer_id = c.customer_id' from #segments where Element = 'Date Added'    

	Print 'Step 19' + Convert(varchar(50), getdate(), 108)


	SELECT @result = SUBSTRING((SELECT ' ' + (case when Brackets = '(' then Brackets + query else '' + query end) +  (case when Brackets = ')' then Brackets else '' end) + ' ' + operator    
	FROM #queries    
	order by id    
	FOR XML PATH('')), 0, 9999)    
    
	Print 'Step 20' + Convert(varchar(50), getdate(), 108)

	set @str = @str + (Case when @result is not null then ' Where' + REPLACE(REPLACE(REPLACE(@result,'&#x0D;',''),'&lt;', '<'),'&gt;', '>') else '' end)  

	--print 2    
	print @str  

	Insert into #cust_Temp    
	EXEC sp_executesql @str   

	Print 'Step 21' + Convert(varchar(50), getdate(), 108)

	--print @campaign_type

	if (@campaign_type like 'Print%')
	Begin
		delete from #cust_Temp where Len(address_Line) <= 0
	End
	else if (@campaign_type like 'Email%')
	Begin
		delete from #cust_Temp where Len(primary_email) <= 0
	End
		else if (@campaign_type like 'SMS%')
	Begin
		delete from #cust_Temp where Len(primary_phone_number) <= 0
	End

	Print 'Step 22' + Convert(varchar(50), getdate(), 108)

		Update #cust_Temp set do_not_email = 1 where Len(primary_email) <=0 and do_not_email = 0
		Update #cust_Temp set do_not_mail = 1 where Len(address_line) <=0 and do_not_mail = 0
		Update #cust_Temp set do_not_call = 1 where Len(primary_phone_number) <=0 and do_not_call = 0



	if (@campaign_type is null )
	Begin

		Print 'Step 23' + Convert(varchar(50), getdate(), 108)

		--Print 'Campaign Type : ' + @campaign_type
		set @page_size = isnull(@page_size, 20) 

		select distinct customer_id, vin, do_not_email, do_not_mail, do_not_call
		into #temp_count
		from #cust_Temp cust
		where 
		(	
			@search = '' or     
			(
				cust.first_name like '%'+ @search +'%' or    
				cust.last_name like '%'+ @search +'%' or    
				cust.primary_email like '%'+ @search +'%' or    
				cust.primary_phone_number like '%'+ @search +'%' 
			)
		)   

		Print 'Step 24' + Convert(varchar(50), getdate(), 108)


		select 
			  @total_count = count(customer_id)
			, @email_optin = Sum(Case when do_not_email in('0', 'No') then 1 else 0 end)
			, @mail_optin = Sum(Case when do_not_mail in('0', 'No') then 1 else 0 end)
			, @phone_optin = Sum(Case when do_not_call in('0', 'No') then 1 else 0 end)
		from #temp_count

		Print 'Total Customers : ' + Cast(isnull(@total_count, 0) as varchar(50))
		Print 'Email Optins : ' + Cast(Isnull(@email_optin, 0) as varchar(50))
		Print 'Mail Optins : ' +  Cast(Isnull(@mail_optin, 0) as varchar(50))
		Print 'Call Optins : ' +  Cast(Isnull(@phone_optin, 0) as varchar(50))
	
		Print 'Step 25' + Convert(varchar(50), getdate(), 108)

--select * from #temp_count
--select @total_count
--	return;

--	select * from #segments
--	select * from #temp
--	select * from #custTemp

		;WITH CTE_Results AS     
		(select     
			distinct 
				  customer_id
				, customer_guid
				, primary_email
				, first_name
				, middle_name
				, last_name
				, address_line
				, primary_phone_number
				, tags
				, vin
				, do_not_email
				, do_not_mail
				, do_not_call
				, created_dt    
				, Isnull(@total_count, 0) as total_count   
				, Isnull(@email_optin, 0) as email_optin_count
				, Isnull(@mail_optin, 0) as mail_optin_count
				, Isnull(@phone_optin, 0) as phone_optin_count
		from     
		#cust_Temp cust     
		where     
		(@search = '' or     
		cust.first_name like '%'+ @search +'%' or    
		cust.last_name like '%'+ @search +'%' or    
		cust.primary_email like '%'+ @search +'%' or    
		cust.primary_phone_number like '%'+ @search +'%')    
		)    
		select * from CTE_Results    
		ORDER BY    
			CASE WHEN (@sort_column = 'FirstName' AND @sort_order='ASC') THEN first_name END ASC,    
			CASE WHEN (@sort_column = 'FirstName' AND @sort_order='DESC') THEN first_name END DESC,    
			CASE WHEN (@sort_column = 'PrimaryEmail' AND @sort_order='ASC') THEN primary_email END ASC,    
			CASE WHEN (@sort_column = 'PrimaryEmail' AND @sort_order='DESC') THEN primary_email END DESC,    
			CASE WHEN (@sort_column = 'PhoneNumber' AND @sort_order='ASC') THEN primary_phone_number END ASC,     
			CASE WHEN (@sort_column = 'PhoneNumber' AND @sort_order='DESC') THEN primary_phone_number END DESC,     
			CASE WHEN (@sort_column = 'Address' AND @sort_order='ASC') THEN address_line END ASC,     
			CASE WHEN (@sort_column = 'Address' AND @sort_order='DESC') THEN address_line END DESC,     
			CASE WHEN (@sort_column = 'CreatedDate' AND @sort_order='ASC') THEN created_dt END ASC,     
			CASE WHEN (@sort_column = 'CreatedDate' AND @sort_order='DESC') THEN created_dt END DESC       
		OFFSET ((isnull(@page_no,1) - 1) * @page_size) rows fetch next @page_size rows only  
	
		Print 'Step 26' + Convert(varchar(50), getdate(), 108)

	End
	else if (@campaign_type in ('Print', 'Email', 'SMS'))
	Begin
		---------------------------------------- Coupons ----------------------------------------------------------------------------------------------
		Print 'Campaign Type : ' + @campaign_type

		--select * from #cust_Temp
		select 
			a.*, 
			0 as is_processed 
		into 
			#temp_coupon_query
		from 
			auto_stg_campaigns.[print].coupons a (nolock) 
		inner join auto_stg_campaigns.campaign.media_type b (nolock) on
			a.media_type_id = b.media_type_id
		where 
			a.campaign_id = @campaign_id 
			and a.is_deleted = 0
			and b.is_deleted = 0
			and Len(a.conditions_query) > 0
			and b.media_type = @campaign_type
		order by position_id, priority_id
		
		select distinct * into #cust_distinct_Temp from #cust_Temp
		
		-- Updating Coupons
		while ((select count(*) from #temp_coupon_query where is_processed = 0) > 0)
		Begin
		
			truncate table #queries

			set @result = ''

			select top 1 @segmant_query = conditions_query, @print_coupon_id = print_coupon_id, @position_id = position_id, @coupon_id = coupon_id, 
						 @coupon_html = Cast(coupon_html as nvarchar(max)), @priority = priority_id, @is_default = is_default
			from #temp_coupon_query
			where is_processed = 0
			order by position_id, priority_id

			insert into #queries
			select * from  [customer].[get_segment_conditions](@segmant_query)

			SELECT @result = SUBSTRING((SELECT ' ' + (case when Brackets = '(' then Brackets + query else '' + query end) +  (case when Brackets = ')' then Brackets else '' end) + ' ' + operator    
			FROM #queries    
			order by id    
			FOR XML PATH('')), 0, 9999)    

			set @result = (Case when reverse(substring(reverse(@result), 1, 4)) like '%or%' or substring(reverse(@result), 1, 4) like '%and%' then substring(@result, 1, (Len(@result) -  charindex(' ', reverse(@result), 1))) else @result end) 
			
			set @sql = ''
			set @sql = 'Select distinct customer_id, master_customer_id, vin,' + Cast(@print_coupon_id as varchar(25)) + 'as print_coupon_id, ' + Cast(@priority as varchar(25)) + 'as priority_id, ' + Cast(@position_id as varchar(25)) + 'as priority_id, ' + Cast(@is_default as varchar(25)) + 'as is_default from #cust_distinct_Temp where ' + @result

			--Print '----------------------------------------------------'
			--print @print_coupon_id
			--print @sql

			INSERT INTO #cust_coupon(customer_id, master_customer_id, vin, print_coupon_id, priority_id, position_id, is_default)
			EXEC sp_executesql @sql
			
			--print 'Temp Coupon Complted'
			--print @position_id
			--Print @coupon_html
			--Print '----------------------------------------------------'

			--if (Len(Isnull(@coupon_html, '')) <= 0)
			--Begin
			--	select * from 
			--	set @coupon_html = Cast('' as nvarchar(max))
			--end

			Update #cust_coupon set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_coupon set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_coupon set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_coupon set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_coupon set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_coupon set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_coupon set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_coupon set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_coupon set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_coupon set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id

			--select * from #final_cust_coupon
			--select * from #cust_coupon

			Update #temp_coupon_query set is_processed = 1 where print_coupon_id = @print_coupon_id

		End

		print 'While Loop Completed'	

		---------------------------------------- Coupons ----------------------------------------------------------------------------------------------
		---------------------------------------- Images ----------------------------------------------------------------------------------------------
		
		set @segmant_query = ''
		set @print_coupon_id = 0
		set @position_id = 0
		set @coupon_id = 0

		Print 'Campaign Type : ' + @campaign_type
		select 
			a.*, 
			0 as is_processed 
		into 
			#temp_Images_query
		from 
			auto_stg_campaigns.[print].images a (nolock) 
		inner join auto_stg_campaigns.campaign.media_type b (nolock) on
			a.media_type_id = b.media_type_id
		where 
			a.campaign_id = @campaign_id 
			and a.is_deleted = 0
			and b.is_deleted = 0
			and Len(a.conditions_query) > 0
			and b.media_type = @campaign_type
		order by position_id, priority_id

		-- Updating Coupons
		while ((select count(*) from #temp_Images_query where is_processed = 0) > 0)
		Begin
		
			truncate table #queries

			set @result = ''

			select top 1 @segmant_query = conditions_query, @print_coupon_id = print_image_id, @position_id = position_id, @coupon_id = image_id, @image_url = image_url, 
						@priority = priority_id, @is_default = is_default
			from #temp_Images_query
			where is_processed = 0
			order by position_id, priority_id

			insert into #queries
			select * from  [customer].[get_segment_conditions](@segmant_query)

			SELECT @result = SUBSTRING((SELECT ' ' + (case when Brackets = '(' then Brackets + query else '' + query end) +  (case when Brackets = ')' then Brackets else '' end) + ' ' + operator    
			FROM #queries    
			order by id    
			FOR XML PATH('')), 0, 9999)    

			set @result = (Case when reverse(substring(reverse(@result), 1, 4)) like '%or%' or substring(reverse(@result), 1, 4) like '%and%' then substring(@result, 1, (Len(@result) -  charindex(' ', reverse(@result), 1))) else @result end) 
			
			set @sql = ''

			set @sql = 'Select distinct customer_id, master_customer_id, vin, ' + Cast(@print_coupon_id as varchar(25)) + 'as print_coupon_id, ' + Cast(@priority as varchar(25)) + 'as priority_id, ' + Cast(@position_id as varchar(25)) + 'as priority_id, ' + Cast(@is_default as varchar(25)) + 'as is_default from #cust_distinct_Temp where ' + @result

			print @sql

			INSERT INTO #cust_images(customer_id, master_customer_id, vin, print_image_id, priority_id, position_id, is_default)
			EXEC sp_executesql @sql

			--select * from #cust_coupon

			Update #cust_images set position1 = Cast(@image_url as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_images set position1 = Cast(@image_url as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_images set position1 = Cast(@image_url as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_images set position1 = Cast(@image_url as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_images set position1 = Cast(@image_url as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_images set position1 = Cast(@image_url as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_images set position1 = Cast(@image_url as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_images set position1 = Cast(@image_url as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_images set position1 = Cast(@image_url as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_images set position1 = Cast(@image_url as nvarchar(max)) where position1 is null and @position_id = position_id

			--select * from #cust_coupon

			Update #temp_Images_query set is_processed = 1 where print_image_id = @print_coupon_id

		End

		---------------------------------------- Images ----------------------------------------------------------------------------------------------
		---------------------------------------- Text ----------------------------------------------------------------------------------------------

		Print 'Campaign Type : ' + @campaign_type

		select 
			a.*, 
			0 as is_processed 
		into 
			#temp_text_query
		from 
			auto_stg_campaigns.[print].texts a (nolock) 
		inner join auto_stg_campaigns.campaign.media_type b (nolock) on
			a.media_type_id = b.media_type_id
		where 
			a.campaign_id = @campaign_id 
			and a.is_deleted = 0
			and b.is_deleted = 0
			and Len(a.conditions_query) > 0
			and b.media_type = @campaign_type
		order by position_id, priority_id

		-- Updating Text
		while ((select count(*) from #temp_text_query where is_processed = 0) > 0)
		Begin
		
			truncate table #queries

			set @result = ''

			select top 1 @segmant_query = conditions_query, @print_coupon_id = print_text_id, @position_id = position_id, @coupon_id = text_id, 
						 @coupon_html = Cast(text_desc as nvarchar(max)), @priority = priority_id, @is_default = is_default
			from #temp_text_query
			where is_processed = 0
			order by position_id, priority_id

			insert into #queries
			select * from  [customer].[get_segment_conditions](@segmant_query)

			SELECT @result = SUBSTRING((SELECT ' ' + (case when Brackets = '(' then Brackets + query else '' + query end) +  (case when Brackets = ')' then Brackets else '' end) + ' ' + operator    
			FROM #queries    
			order by id    
			FOR XML PATH('')), 0, 9999)    

			set @result = (Case when reverse(substring(reverse(@result), 1, 4)) like '%or%' or substring(reverse(@result), 1, 4) like '%and%' then substring(@result, 1, (Len(@result) -  charindex(' ', reverse(@result), 1))) else @result end) 
			
			set @sql = ''
			set @sql = 'Select distinct customer_id, master_customer_id, vin,' + Cast(@print_coupon_id as varchar(25)) + 'as print_text_id, ' + Cast(@priority as varchar(25)) + 'as priority_id, ' + Cast(@position_id as varchar(25)) + 'as priority_id, ' + Cast(@is_default as varchar(25)) + 'as is_default from #cust_distinct_Temp where ' + @result

			INSERT INTO #cust_text(customer_id, master_customer_id, vin, print_text_id, priority_id, position_id, is_default)
			EXEC sp_executesql @sql
			
			Update #cust_text set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_text set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_text set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_text set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_text set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_text set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_text set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_text set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_text set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id
			Update #cust_text set position1 = Cast(@coupon_html as nvarchar(max)) where position1 is null and @position_id = position_id

			--select * from #final_cust_coupon
			--select * from #cust_coupon

			Update #temp_text_query set is_processed = 1 where print_text_id = @print_coupon_id

		End

		print 'While Loop Completed'	

		---------------------------------------- Text ----------------------------------------------------------------------------------------------
		
		print 'Final Result'

		Update a set a.rnk = b.rnk1
		from #cust_coupon a
		inner join 
		(
			select *, rank() over (partition by master_customer_id order by priority_id asc ) as rnk1 from #cust_coupon 
		) as b 
			on a.id = b.id

		select distinct
			a.customer_id as customer_number,  
			isnull(nullif(ltrim(rtrim(first_name)),''),'') as first_name ,    
			isnull(nullif(ltrim(rtrim(last_name)),''),'') as last_name, 
			isnull(nullif(ltrim(rtrim(a.address1)),''),'') as address_line,
			a.address2 as address2,
			isnull(nullif(ltrim(rtrim(a.city)),''),'') as city, 
			isnull(nullif(ltrim(rtrim(a.[state])),''),'') as [state],
			isnull(nullif(ltrim(rtrim(primary_phone_number)),''),'') as phone_number, 
			isnull(nullif(ltrim(rtrim(zip_code)),''),'') as zip,
			isnull(nullif(ltrim(rtrim(primary_email)),''),'') as email,
			a.vin,
			make,
			model,
			model_year,
			d.accountname as dealer_name,
			d.phone as dealer_phone_number,
			d.address1 + ' ' + d.address2 as dealer_address,
			d.city as dealer_city,
			d.state as dealer_state,
			'' as dealer_zipcode,
			--cc.customer_id as customer_reference,
			Isnull(Replace(Replace(isnull((select position1 from #cust_coupon p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 1 and rnk = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname),'') as coupon1,
			Isnull(Replace(Replace(isnull((select position1 from #cust_coupon p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 2 and rnk = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname),'') as coupon2,
			Isnull(Replace(Replace(isnull((select position1 from #cust_coupon p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 3 and rnk = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname),'') as coupon3,
			Isnull(Replace(Replace(isnull((select position1 from #cust_coupon p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 4 and rnk = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname),'') as coupon4,
			Isnull(Replace(Replace(isnull((select position1 from #cust_coupon p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 5 and rnk = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname),'') as coupon5,
			Isnull(Replace(Replace(isnull((select position1 from #cust_coupon p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 6 and rnk = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname),'') as coupon6,
			Isnull(Replace(Replace(isnull((select position1 from #cust_coupon p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 7 and rnk = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname),'') as coupon7,
			Isnull(Replace(Replace(isnull((select position1 from #cust_coupon p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 8 and rnk = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname),'') as coupon8,
			Isnull(Replace(Replace(isnull((select position1 from #cust_coupon p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 9 and rnk = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname),'') as coupon9,
			Isnull(Replace(Replace(isnull((select position1 from #cust_coupon p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 10 and rnk = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname),'') as coupon10,

			Isnull((select isnull(position1, '') from #cust_images p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 1), '') as image1,
			Isnull((select isnull(position1, '') from #cust_images p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 2), '') as image2,
			Isnull((select isnull(position1, '') from #cust_images p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 3), '') as image3,
			Isnull((select isnull(position1, '') from #cust_images p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 4), '') as image4,
			Isnull((select isnull(position1, '') from #cust_images p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 5), '') as image5,
			Isnull((select isnull(position1, '') from #cust_images p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 6), '') as image6,
			Isnull((select isnull(position1, '') from #cust_images p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 7), '') as image7,
			Isnull((select isnull(position1, '') from #cust_images p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 8), '') as image8,
			Isnull((select isnull(position1, '') from #cust_images p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 9), '') as image9,
			Isnull((select isnull(position1, '') from #cust_images p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 10), '') as image10,

			Isnull((select isnull(position1, '') from #cust_text p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 1), '') as text1,
			Isnull((select isnull(position1, '') from #cust_text p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 2), '') as text2,
			Isnull((select isnull(position1, '') from #cust_text p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 3), '') as text3,
			Isnull((select isnull(position1, '') from #cust_text p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 4), '') as text4,
			Isnull((select isnull(position1, '') from #cust_text p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 5), '') as text5,
			Isnull((select isnull(position1, '') from #cust_text p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 6), '') as text6,
			Isnull((select isnull(position1, '') from #cust_text p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 7), '') as text7,
			Isnull((select isnull(position1, '') from #cust_text p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 8), '') as text8,
			Isnull((select isnull(position1, '') from #cust_text p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 9), '') as text9,
			Isnull((select isnull(position1, '') from #cust_text p1 where a.master_customer_id = p1.master_customer_id and a.vin = p1.vin and position_id = 10), '') as text10,

			a.master_customer_id,
			a.suffix,
			a.cust_title as title,
			a.parent_dealer_id
		into #final_print_result
		from #cust_Temp a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		--left outer join #final_cust_coupon b on a.master_customer_id = b.master_customer_id
		--left outer join #cust_images c on a.master_customer_id = c.master_customer_id
		--where a.customer_id in ('10', '68140')
		


		---- Updating default Coupon html
		update a set a.coupon1 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 1 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.coupon1) <= 0

		update a set a.coupon2 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 2 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.coupon2) <= 0

		update a set a.coupon3 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 3 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.coupon3) <= 0

		update a set a.coupon4 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 4 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.coupon4) <= 0
	
		update a set a.coupon5 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 5 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.coupon5) <= 0

		update a set a.coupon6 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 6 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.coupon6) <= 0

		update a set a.coupon7 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 7 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.coupon7) <= 0

		update a set a.coupon8 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 8 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.coupon8) <= 0

		update a set a.coupon9 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 9 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.coupon9) <= 0

		update a set a.coupon10 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 10 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.coupon10) <= 0

		---- Updating default Image Url
		update a set a.image1 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 1 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.image1) <= 0

		update a set a.image2 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 2 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.image2) <= 0

		update a set a.image3 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 3 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.image3) <= 0

		update a set a.image4 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 4 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.image4) <= 0

		update a set a.image5 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 5 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.image5) <= 0

		update a set a.image6 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 6 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.image6) <= 0

		update a set a.image7 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 7 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.image7) <= 0

		update a set a.image8 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 8 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.image8) <= 0

		update a set a.image9 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 9 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.image9) <= 0

		update a set a.image10 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 10 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.image10) <= 0


		---- Updating default Text
		update a set a.text1 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 1 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.text1) <= 0

		update a set a.text2 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 2 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.text2) <= 0

		update a set a.text3 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 3 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.text3) <= 0

		update a set a.text4 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 4 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.text4) <= 0
	
		update a set a.text5 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 5 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.text5) <= 0

		update a set a.text6 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 6 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.text6) <= 0

		update a set a.text7 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 7 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.text7) <= 0

		update a set a.text8 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 8 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.text8) <= 0

		update a set a.text9 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 9 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.text9) <= 0

		update a set a.text10 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 10 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.parent_dealer_id
		where Len(a.text10) <= 0

		select master_customer_id,  vin,
			((Case when Len(coupon1) > 0 then 1 else 0 end) +
			(Case when Len(coupon2) > 0 then 1 else 0 end) +
			(Case when Len(coupon3) > 0 then 1 else 0 end) +
			(Case when Len(coupon4) > 0 then 1 else 0 end) +
			(Case when Len(coupon5) > 0 then 1 else 0 end) +
			(Case when Len(coupon6) > 0 then 1 else 0 end) +
			(Case when Len(coupon7) > 0 then 1 else 0 end) +
			(Case when Len(coupon8) > 0 then 1 else 0 end) +
			(Case when Len(coupon9) > 0 then 1 else 0 end) +
			(Case when Len(coupon10) > 0 then 1 else 0 end)) as coupon_count,
			
			((Case when Len(image1) > 0 then 1 else 0 end) +
			(Case when Len(image2) > 0 then 1 else 0 end) +
			(Case when Len(image3) > 0 then 1 else 0 end) +
			(Case when Len(image4) > 0 then 1 else 0 end) +
			(Case when Len(image5) > 0 then 1 else 0 end) +
			(Case when Len(image6) > 0 then 1 else 0 end) +
			(Case when Len(image7) > 0 then 1 else 0 end) +
			(Case when Len(image8) > 0 then 1 else 0 end) +
			(Case when Len(image9) > 0 then 1 else 0 end) +
			(Case when Len(image10) > 0 then 1 else 0 end)) as image_count,

			((Case when Len(text1) > 0 then 1 else 0 end) +
			(Case when Len(text2) > 0 then 1 else 0 end) +
			(Case when Len(text3) > 0 then 1 else 0 end) +
			(Case when Len(text4) > 0 then 1 else 0 end) +
			(Case when Len(text5) > 0 then 1 else 0 end) +
			(Case when Len(text6) > 0 then 1 else 0 end) +
			(Case when Len(text7) > 0 then 1 else 0 end) +
			(Case when Len(text8) > 0 then 1 else 0 end) +
			(Case when Len(text9) > 0 then 1 else 0 end) +
			(Case when Len(text10) > 0 then 1 else 0 end)) as text_count
		into #temp_coupon_counts
		from #final_print_result

		if (@campaign_type in ('Print'))
		Begin
		
			--Insert into auto_stg_campaigns.[print].campaign_items 
			--(
			--	campaign_item_guid, campaign_media_id, list_member_id, email_address, first_name, last_name, [address], city, [state], zip_code, phone, salutation,
			--	vin, make, model, [year], is_sent, is_deleted, campaign_id, 
			--	coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10,
			--	image1, image2, image3, image4, image5, image6, image7, image8, image9, image10,
			--	text1, text2, text3, text4, text5, text6, text7, text8, text9, text10,
			--	run_id
			--)					
			select 
				newid(), 0 as campaing_media_id, master_customer_id, email, first_name, last_name, address_line, city, state, zip, phone_number, title,
				vin, make, model, model_year, 1 as is_sent, 0 as is_deleted, @campaign_id as campaign_id, 
				coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10,
				image1, image2, image3, image4, image5, image6, image7, image8, image9, image10 ,
				text1, text2, text3, text4, text5, text6, text7, text8, text9, text10,
				null
			from #final_print_result
		end
		else if (@campaign_type in ('Email'))
		Begin

				set @campaign_type_id = (select
											campaign_type_id
										from
											[auto_stg_campaigns].email.campaigns with(nolock,readuncommitted)
										where
											campaign_id = @campaign_id)

			--Insert into auto_stg_campaigns.[email].campaign_items 
			--(
			--	campaign_item_guid, campaign_id, list_member_id, email_address, first_name, last_name, [address], city, [state], zip_code, phone, salutation,
			--	vin, make, model, [year], is_sent, is_deleted, 
			--	coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10,
			--	image1, image2, image3, image4, image5, image6, image7, image8, image9, image10,
			--	text1, text2, text3, text4, text5, text6, text7, text8, text9, text10
			--	)					
			select 
				newid(), @campaign_id as campaing_id, master_customer_id, email, first_name, last_name, address_line, city, state, zip, phone_number, title,
				vin, make, model, model_year, 1 as is_sent, 0 as is_deleted, 
				coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10,
				image1, image2, image3, image4, image5, image6, image7, image8, image9, image10 ,
				text1, text2, text3, text4, text5, text6, text7, text8, text9, text10
			from #final_print_result


		end
		select 
		  customer_number 
		, first_name 
		, last_name 
		, address_line 
		, address2 
		, city 
		, state 
		, phone_number 
		, zip 
		, email 
		, vin 
		, make 
		, model 
		, model_year 
		, dealer_name 
		, dealer_phone_number 
		, dealer_address 
		, dealer_city 
		, dealer_state 
		, dealer_zipcode 
		/* -------------- Coupon Html */
		, [customer].[get_coupon_html_by_position](coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10, 1, (select coupon_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin)) as coupon1
		, [customer].[get_coupon_html_by_position](coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10, 2, (select coupon_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin)) as coupon2
		, [customer].[get_coupon_html_by_position](coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10, 3, (select coupon_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin)) as coupon3
		, [customer].[get_coupon_html_by_position](coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10, 4, (select coupon_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin)) as coupon4
		, [customer].[get_coupon_html_by_position](coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10, 5, (select coupon_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin)) as coupon5
		, [customer].[get_coupon_html_by_position](coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10, 6, (select coupon_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin)) as coupon6
		, [customer].[get_coupon_html_by_position](coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10, 7, (select coupon_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin)) as coupon7
		, [customer].[get_coupon_html_by_position](coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10, 8, (select coupon_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin)) as coupon8
		, [customer].[get_coupon_html_by_position](coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10, 9, (select coupon_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin)) as coupon9
		, [customer].[get_coupon_html_by_position](coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10, 10, (select coupon_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin))as coupon10

		/* -------------- Images Urls */
			,image1, image2, image3, image4, image5, image6, image7, image8, image9, image10 

		--/* -------------- Text */
			,text1, text2, text3, text4, text5, text6, text7, text8, text9, text10
	
		, master_customer_id 
		, suffix 
		, title 
		, parent_dealer_id 
		, '' as AgreementNumber
		, '' as BodyCopy1
		, '' as AgreementNumber1
		, '' as AgreementExpiration1
		, '' as JobNumber
		, '' as ConsecutiveNumber
		, '' as LetterSignatureName
		, '' as LetterSignatureTitle
		, Reverse(Substring(Reverse(vin), 1, 8)) as VINLast8
		, (select coupon_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin) as coupon_count
		, (select image_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin) as Image_count
		, (select text_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin) as text_count
		from #final_print_result a


	End
	else if (@campaign_type = 'Download' )
	Begin

		Print 'Campaign Type : ' + @campaign_type

		set @page_size = isnull(@page_size, 20) 
		
		--Declare @email_optin int
		--		,@mail_optin int
		--		,@phone_optin int
		Print 'Reached here download'
		select distinct customer_id, vin, do_not_email, do_not_mail, do_not_call				--modified
		into #temp_count_download
		from #cust_Temp cust
		where 
		(	
			@search = '' or     
			(
				cust.first_name like '%'+ @search +'%' or    
				cust.last_name like '%'+ @search +'%' or    
				cust.primary_email like '%'+ @search +'%' or    
				cust.primary_phone_number like '%'+ @search +'%' 
			)
		)   

		select 
			  @total_count = count(distinct customer_id)
			, @email_optin = Sum(Case when do_not_email in('0', 'No') then 1 else 0 end)
			, @mail_optin = Sum(Case when do_not_mail in('0', 'No') then 1 else 0 end)
			, @phone_optin = Sum(Case when do_not_call in('0', 'No') then 1 else 0 end)
		from #temp_count_download

		Print 'Total Customers : ' + Cast(isnull(@total_count, 0) as varchar(50))
		Print 'Email Optins : ' + Cast(Isnull(@email_optin, 0) as varchar(50))
		Print 'Mail Optins : ' +  Cast(Isnull(@mail_optin, 0) as varchar(50))
		Print 'Call Optins : ' +  Cast(Isnull(@phone_optin, 0) as varchar(50))
    

		;WITH CTE_Results AS     
		(select     
			distinct 
				  customer_id
				, customer_guid
				, primary_email
				, first_name
				, middle_name
				, last_name
				, vin
				, address_line
				, primary_phone_number
				, tags
				, do_not_email
				, do_not_mail
				, do_not_call
				, created_dt    
				, Isnull(@total_count, 0) as total_count   
				, Isnull(@email_optin, 0) as email_optin_count
				, Isnull(@mail_optin, 0) as mail_optin_count
				, Isnull(@phone_optin, 0) as phone_optin_count
		from     
		#cust_Temp cust     
		where     
		(@search = '' or     
		cust.first_name like '%'+ @search +'%' or    
		cust.last_name like '%'+ @search +'%' or    
		cust.primary_email like '%'+ @search +'%' or    
		cust.primary_phone_number like '%'+ @search +'%')    
		)    

		select	distinct
				first_name,
				--middle_name,
				last_name,
				vin,
				primary_phone_number,
				address_line,
				primary_email,
				email_optin_count,
				mail_optin_count,
				phone_optin_count
		from CTE_Results    
	End
	else if (@campaign_type = 'Customers' )
	Begin

		Print 'Campaign Type : ' + @campaign_type
		set @page_size = isnull(@page_size, 20) 
		
		Print 'Reached here customers'
		select distinct customer_id, do_not_email, do_not_mail, do_not_call
		into #temp_count_Customers
		from #cust_Temp cust
		where 
		(	
			@search = '' or     
			(
				cust.first_name like '%'+ @search +'%' or    
				cust.last_name like '%'+ @search +'%' or    
				cust.primary_email like '%'+ @search +'%' or    
				cust.primary_phone_number like '%'+ @search +'%' 
			)
		)   

		select 
			  @total_count = count(distinct customer_id)
			, @email_optin = Sum(Case when do_not_email in('0', 'No') then 1 else 0 end)
			, @mail_optin = Sum(Case when do_not_mail in('0', 'No') then 1 else 0 end)
			, @phone_optin = Sum(Case when do_not_call in('0', 'No') then 1 else 0 end)
		from #temp_count_Customers

		Print 'Total Customers : ' + Cast(isnull(@total_count, 0) as varchar(50))
		Print 'Email Optins : ' + Cast(Isnull(@email_optin, 0) as varchar(50))
		Print 'Mail Optins : ' +  Cast(Isnull(@mail_optin, 0) as varchar(50))
		Print 'Call Optins : ' +  Cast(Isnull(@phone_optin, 0) as varchar(50))
    
	
		;WITH CTE_Results AS     
		(select     
			distinct 
				  customer_id
				, customer_guid
				, primary_email
				, first_name
				, middle_name
				, last_name
				, address_line
				, primary_phone_number
				, tags
				, do_not_email
				, do_not_mail
				, do_not_call as do_not_phone
				, created_dt    
				, Isnull(@total_count, 0) as rows_count   
				, Isnull(@email_optin, 0) as email_optin_count
				, Isnull(@mail_optin, 0) as mail_optin_count
				, Isnull(@phone_optin, 0) as phone_optin_count
				, make
				, model
				, model_year as [year]
				, vin
				, @segment_id as segment_id
				, @segment_name as segment_name
		from     
		#cust_Temp cust     
		where     
		(@search = '' or     
		cust.first_name like '%'+ @search +'%' or    
		cust.last_name like '%'+ @search +'%' or    
		cust.primary_email like '%'+ @search +'%' or    
		cust.primary_phone_number like '%'+ @search +'%')    
		)    

		select * from CTE_Results 
		ORDER BY    
			CASE WHEN (@sort_column = 'FirstName' AND @sort_order='ASC') THEN first_name END ASC,    
			CASE WHEN (@sort_column = 'FirstName' AND @sort_order='DESC') THEN first_name END DESC,    
			CASE WHEN (@sort_column = 'PrimaryEmail' AND @sort_order='ASC') THEN primary_email END ASC,    
			CASE WHEN (@sort_column = 'PrimaryEmail' AND @sort_order='DESC') THEN primary_email END DESC,    
			CASE WHEN (@sort_column = 'PhoneNumber' AND @sort_order='ASC') THEN primary_phone_number END ASC,     
			CASE WHEN (@sort_column = 'PhoneNumber' AND @sort_order='DESC') THEN primary_phone_number END DESC,     
			CASE WHEN (@sort_column = 'Address' AND @sort_order='ASC') THEN address_line END ASC,     
			CASE WHEN (@sort_column = 'Address' AND @sort_order='DESC') THEN address_line END DESC,     
			CASE WHEN (@sort_column = 'CreatedDate' AND @sort_order='ASC') THEN created_dt END ASC,     
			CASE WHEN (@sort_column = 'UpdatedDate' AND @sort_order='DESC') THEN created_dt END DESC       
		OFFSET ((isnull(@page_no,1) - 1) * @page_size) rows fetch next @page_size rows only 
	End
	else if(@campaign_type like '%Count%')
	Begin

		if (@campaign_type like 'Print%')
		Begin
			print 1
			select count(*) as Customer_Count from #cust_Temp where do_not_mail = 0
		End
		if (@campaign_type like 'Email%')
		Begin
			print 2
			select count(*) as Customer_Count from #cust_Temp where do_not_email = 0 
		End
		if (@campaign_type like 'SMS%')
		Begin
			print 3
			select count(*) as Customer_Count from #cust_Temp where do_not_call = 0 
		End
	End
			Print 'Step 27' + Convert(varchar(50), getdate(), 108)


 END      
    
  /* Cleanup */            
 SET NOCOUNT OFF            
          
 /* Return Value */    
 --RETURN 0    
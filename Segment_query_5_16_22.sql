USE [auto_customers]
GO
/****** Object:  StoredProcedure [customer].[query_segment_get]    Script Date: 5/13/2022 2:43:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--ALTER procedure [customer].[query_segment_get]     
--(    


--	 @account_id uniqueidentifier,-- = '7d05e6e1-41e6-4d86-a92e-528226970225',    
--	 @segmant_query nvarchar(max) = null, -- = '{"queries":[{"element":"First Name","operator":"contains","secondOperator":"","value":"k","match":"or","order":"1"},{"element":"Last Name","operator":"contains","secondOperator":"","value":"s","match":"or","order":"2"},{"element":"Campaign Activity","operator":"opened","secondOperator":"","value":"last_3_months","match":"or","order":"3"}, {"element":"Date Added","operator":"is after","secondOperator":"","value":"01/01/2020","match":"","order":"4"}]}',    
--	 @operator varchar(50) = 'or',    
--	 @search NVARCHAR(50) = NULL,    
--	 @Offset int = 0,    
--	 @page_no INT = 1,    
--	 @page_size INT = 20,    
--	 @sort_column NVARCHAR(20) = 'CreatedDate',    
--	 @sort_order NVARCHAR(20) = 'ASC',    
--	 @list_type_id int = null,   
--	 @campaign_type varchar(50) = null,
--	 @campaign_id int = null,
--	 @campaign_run_id int = null,
--	 @segment_id int = null,
--	 @flow_id int = null,
--	 @condition_json varchar(max) = null,
--	 @is_parent_campaign bit =  null,
--	 @delay int = null,-- As days
--	 @time_period varchar(10) = null
-- )    
--AS      
     
/*		

	Copyright 2017 Warrous Pvt Ltd    

              
 Date           Author			Work Tracker Id			Description              
 ------------------------------------------------------------------------------            
 3/23/2021		Madhai.k		Created					This is to get segment based on query    
 06/11/2021		Santhosh B		Modified				Added Logic to get Optin(Emails, Print, Phone total Counts)
 06/15/2021		Santhosh B		Modified				Added logic to get Visited Date data
 07/05/2021		Santhosh B		Modified				Added logic to get data for campaign type Download
														Added logic to get data from RO Filters	
 07/08/2021		Santhosh B		Modified				Added logic to filter list_ids based on list_type_ids
 07/22/2021		Santhosh B		Modified				Added logic to filter Area Code 
 08/03/2021		Santhosh B		Modified				Added logic to fetch campaign_type is customer (to update records in customer.customer)
 08/10/2021		Santhosh B		Modified				Added logic to fetch customer based on Customer Status (New, Active, Lapsed, Lost)
 09/13/2021		Santhosh B		Modified				Added logic to get the Coupon html and Image Url for Print
 09/21/2021		Santhosh B		Modified				Added logic to get the Lead Status, Lead Source, Customer Source filters
 09/22/2021		Santhosh B		Modified				Added logic to fulfill the Lead User Notification
 09/28/2021		Santhosh B		Modified				Added logic to retreive Coupon Html and Image URL from print.coupon, print.image tables
 10/06/2021		Santhosh B		Modified				Added Logic to print campaign Items into print.campaign_item table
 10/07/2021		Santhosh B		Modified				Added new column for Print campaign (as per the RRD Columns).
 10/11/2021		Santhosh B		Modified				Added logic to add Service and Sales table join when the filter elements are available
 10/12/2021		Santhosh B		Modified				Added logic to	 media type counts (@Campaign_type = 'Email_Count', 'Print_Count'
 10/13/2021		Santhosh B		Modified				Modified logic to get correct default coupon html and image urls
 10/18/2021		Santhosh B		Modified				Added logic to get print text data
 10/26/2021		Santhosh B		Modified				Added logic to restun coupons/images/text in a sequence order 
 10/27/2021		Santhosh B		Modified				Added Coupon html/Image/text logic for Email campaign.
 4/6/22			madhavi.k		Modified				Added logic to get all customerIds for Static Segments , Download segment customers based on vertical id.
 4/12/22		madhavi.k		modified				email/sms/print optout text changed to Preference in download
 4/15/22		madhavi.k		modified				print preference not returning in verticalid = 2 download
 ------------------------------------------------------------------------------          

 EXEC [customer].[query_segment_get] @account_id = '2928eacc-a39d-4743-bf02-f9689f16e79f',
 @segmant_query='{"queries":[{"element":"Status","operator":"is","secondOperator":"","value":"Inactive","elementTypeId":"1","order":1,"match":"","groupId":1,"groupValue":""}]}',  
 @list_type_id=3   

 EXEC [customer].[query_segment_get] @account_id = '7d05e6e1-41e6-4d86-a92e-528226970225',    
 @segmant_query = '{"queries":[{"element":"First Name","operator":"contains","secondOperator":"","value":"k","match":"or","order":"1"},{"element":"Last Name","operator":"contains","secondOperator":"","value":"s","match":"","order":"2"}]}'
 ,@campaign_type = 'Print', @campaign_id = 1031
 
  EXEC [customer].[query_segment_get_v2] '420EC07B-C616-4921-AAF7-8106C27726D3',    
 '{"queries":[{"element":"OEM","operator":"contains","secondOperator":"","value":"oem-list-3","match":"","order":1}]}'     
 
 EXEC [customer].[query_segment_get_v2] '420EC07B-C616-4921-AAF7-8106C27726D3',    
 '{"queries":[{"element":"OEM","operator":"contains","secondOperator":"","value":"oem-list-3","match":"and","order":1},{"element":"First Name","operator":"contains","secondOperator":"","value":"sath","match":"","order":2}]}'    

EXEC [customer].[query_segment_get_v2] '93d00129-a276-49ff-bfeb-8c80b5443b72',    
'{"queries":[{"element":"First Name","operator":"contains","secondOperator":"","value":"h","match":"and","order":1},{"element":"Customer Subscriptions","operator":"contains","secondOperator":"","value":"g","match":"","order":2}]}'    

exec [customer].[query_segment_get_v2] @account_id='7113589E-B6E0-11EB-82D4-0A4357799CFA',
@segmant_query=N'{"queries":[{"element":"OEM","operator":"is","secondOperator":"","value":"[38,37]","match":"","order":1}]}',@operator=N'',@page_no=1,@page_size=20,@sort_column=N'updateddate',@sort_order=N'desc',@search=N'',@list_type_id=3

exec [customer].[query_segment_get_v2] @account_id='93D00129-A276-49FF-BFEB-8C80B5443B72',@segmant_query=N'{"queries":[{"element":"List Name","operator":"contains","secondOperator":"","value":"OEM Check,CusSeg,40,41","match":"and","elementTypeId":"13","order":1},{"element":"Make","operator":"contains","secondOperator":"","value":"MITSUBISHI,FIAT,CHRYSLER,SUZUKI,EAGLE,JEEP,JAGUAR,MAZDA,SMART,HONDA","match":"","elementTypeId":"9","order":2}]}',@operator=N'',@page_no=1,@page_size=20,@sort_column=N'updateddate',@sort_order=N'desc',@search=N'',@list_type_id=3

exec [customer].[query_segment_get_v2] @account_id='7113589E-B6E0-11EB-82D4-0A4357799CFA',
@segmant_query=N'{"queries":[{"element":"Email Optout","operator":"is","secondOperator":"","value":"Yes","match":"","elementTypeId":1,"order":1}]}',@operator=N'',@page_no=1,@page_size=20,@sort_column=N'updateddate',@sort_order=N'desc',@search=N'',@list_type_id=2

exec [customer].[query_segment_get_v2] @account_id='420EC07B-C616-4921-AAF7-8106C27726D3',@segmant_query=N'{"queries":[{"element":"Email Optout","operator":"is","secondOperator":"","value":"Yes","match":"","elementTypeId":1,"order":1}]}',@operator=N'',@page_no=1,@page_size=20,@sort_column=N'updateddate',@sort_order=N'desc',@search=N'',@list_type_id=2

exec [customer].[query_segment_get_v2] @account_id='420EC07B-C616-4921-AAF7-8106C27726D3',
@segmant_query=N'{"queries":[{"element":"Email Optout","operator":"is","secondOperator":"","value":"Yes","match":"","elementTypeId":1,"order":1}]}',@operator=N'',@page_no=1,@page_size=20,@sort_column=N'updateddate',@sort_order=N'desc',@search=N'',@list_type_id=2

exec [customer].[query_segment_get_v2] 
	@account_id='7113589E-B6E0-11EB-82D4-0A4357799CFA',
	@segmant_query=N'{"queries":[{"element":"Address","operator":"is not blank","secondOperator":"","value":"","match":"","elementTypeId":1,"order":1}]}',@operator=N'',
	@page_no=1,@page_size=20,@sort_column=N'updateddate',@sort_order=N'desc',@search=N'',@list_type_id=2,
	@campaign_type = 'Print'

exec [customer].[query_segment_get_v2] @account_id='93d00129-a276-49ff-bfeb-8c80b5443b72',@segmant_query=N'{"queries":[{"element":"First Name","operator":"contains","secondOperator":"","value":"","match":"","elementTypeId":1,"order":1}]}',@operator=N'',@page_no=1,@page_size=20,@sort_column=N'updateddate',@sort_order=N'desc',@search=N'',@list_type_id=2    

exec [customer].[query_segment_get_v2] 
	@account_id='7113589E-B6E0-11EB-82D4-0A4357799CFA',
	@segmant_query=N'{"queries":[{"element":"Make","operator":"contains","secondOperator":"","value":"HONDA`,HONDA PILO,HONDA CIV,HONDA,HONDA`,HONDA PILO,HONDA CIV,HONDA,","match":"and","elementTypeId":"9","order":1},{"element":"Phone Number","operator":"is not blank","secondOperator":"","value":"","match":"and","elementTypeId":1,"order":2},{"element":"Miles Radius","operator":"is less than","secondOperator":"","value":"25","match":"and","elementTypeId":1,"order":3},{"element":"Visit Date","operator":"is after","secondOperator":"","value":{"startDate":"2020-12-31T18:30:00.000Z","endDate":"2021-01-01T18:29:59.000Z"},"match":"","elementTypeId":1,"order":4}]}',
	@operator=N'or',@page_no=1,@page_size=20,@sort_column=N'UpdatedDate',@sort_order=N'desc',@search=N'',@list_type_id=2	 
	
exec [customer].[query_segment_get] 
	@account_id='93D00129-A276-49FF-BFEB-8C80B5443B72',
	@segmant_query=N'{"queries":[{"element":"Country","operator":"contains","value":"US","match":"And","elementTypeId":1,"order":1},{"element":"State","operator":"is","value":"CT","match":"","elementTypeId":2,"order":2}]}',
	@operator=N'or',@page_no=1,@page_size=20,@sort_column=N'UpdatedDate',@sort_order=N'desc',@search=N'',@list_type_id=5, @campaign_type = 'usernotification'	   

exec [customer].[query_segment_get] 
	@account_id='95ac28d8-d513-4b0e-b234-d989c4d2f0bc',
	@segmant_query=null,
	@operator=N'or',@page_no=1,@page_size=20,@sort_column=N'UpdatedDate',@sort_order=N'desc',@search=N'',@list_type_id=2, @campaign_type = 'Download',@segment_id = 4630   

exec [customer].[query_segment_get] 
	@account_id='95ac28d8-d513-4b0e-b234-d989c4d2f0bc',
	@segmant_query = N'{"queries":[{"element":"Model","operator":"is","secondOperator":"","value":"B4000,B600,B9TRBC,C1500C,C230,C230ML,C230WZ","match":"","elementTypeId":"9","order":1}]}',	
	@operator=N'or',@page_no=1,@page_size=20,@sort_column=N'UpdatedDate',@sort_order=N'desc',@search=N'',@list_type_id=2, @campaign_type = 'Email', @campaign_id=17527  

*/       
Begin    
    /* Setup */      
           
	SET NOCOUNT ON    
	Begin Try
	Print 'Step 1 Started at ' + Convert(varchar(50), getdate(), 108)

	--Declare @account_id uniqueidentifier ='63E6B499-4CC0-4591-A489-6F7376E7E4E8',  
	--		--@segmant_query nvarchar(max) = N'{"queries":[{"element":"Model","operator":"is","secondOperator":"","value":"B4000,B600,B9TRBC,C1500C,C230,C230ML,C230WZ","match":"","elementTypeId":"9","order":1}]}',
	--		@segmant_query nvarchar(max) = null,
	--		@operator varchar(50) = 'or',    
	--		@search NVARCHAR(50) = '',    
	--		@Offset int = 0,    
	--		@page_no INT = 1,    
	--		@page_size INT = 20,    
	--		@sort_column NVARCHAR(20) = 'CreatedDate',    
	--		@sort_order NVARCHAR(20) = 'ASC',    
	--		@list_type_id int = 1,
	--		@campaign_type varchar(50) = 'SMS',
	--		@campaign_id int = 1773,--2991,--1771,--2990,--1767,--2989
	--		@campaign_run_id int = 49,
	--		@segment_id int = null,
	--		@flow_id int = 2597,
	--		--@condition_json nvarchar(max) = '[{"field":"Opens","operator":"is","value":"true","channel":"Email","campaignGuid":"2ba4b939-766e-4f95-8964-42a67e3bdb87","type":"","order":"1","fieldoperator":"and"},{"field":"ServiceVisit","operator":"is","value":"no","channel":"","campaignGuid":"","type":"","order":"2","fieldoperator":""}]'
	--		--@condition_json nvarchar(max) = '[{"field":"SMS Delivered","operator":"is","value":"true","channel":"SMS","campaignGuid":"261eca00-8142-459d-b9d3-24305cba51a8","type":"","order":"1","fieldoperator":"or"},{"field":"Email Delivered","operator":"is","value":"true","channel":"Email","campaignGuid":"2ba4b939-766e-4f95-8964-42a67e3bdb87","type":"","order":"2","fieldoperator":"and"},{"field":"Opens","operator":"is","value":"false","channel":"Email","campaignGuid":"2ba4b939-766e-4f95-8964-42a67e3bdb87","type":"","order":"3","fieldoperator":""}]'
	--		--@condition_json nvarchar(max) = '[{"field":"Opens","operator":"is","value":"true","channel":"Email","campaignGuid":"10b8a5cb-7a5b-4a3f-80c9-7dd2aac4339a","type":"","order":"1","fieldoperator":"and"},{"field":"ServiceVisit","operator":"is","value":"no","channel":"","campaignGuid":"","type":"","order":"2","fieldoperator":""}]'
	--		--@condition_json nvarchar(max) = '[{"field":"SMS Delivered","operator":"is","value":"true","channel":"SMS","campaignGuid":"37863aa1-27b9-44d3-996e-be281ffbdc7d","type":"","order":"1","fieldoperator":"or"},{"field":"Email Delivered","operator":"is","value":"no","channel":"Email","campaignGuid":"10B8A5CB-7A5B-4A3F-80C9-7DD2AAC4339A","type":"","order":"2","fieldoperator":"and"},{"field":"ServiceVisit","operator":"is","value":"no","channel":"","campaignGuid":"","type":"","order":"3","fieldoperator":""}]'
	--		--@condition_json nvarchar(max) = '[{"field":"SMS Delivered","operator":"is","value":"true","channel":"SMS","campaignGuid":"37863aa1-27b9-44d3-996e-be281ffbdc7d","type":"","order":"1","fieldoperator":"or"},{"field":"Email Delivered","operator":"is","value":"no","channel":"Email","campaignGuid":"10B8A5CB-7A5B-4A3F-80C9-7DD2AAC4339A","type":"","order":"2","fieldoperator":"and"},{"field":"ServiceVisit","operator":"is","value":"no","channel":"","campaignGuid":"","type":"","order":"3","fieldoperator":""}]'
	--		,@is_parent_campaign bit =  0,
	--		@delay int = 20,-- As days
	--		@time_period varchar(10) = null


	Declare 
			--@account_id uniqueidentifier ='c6c05522-9555-11ec-b7fc-0a83b82401c6', 
			@account_id uniqueidentifier = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB',
			@segmant_query nvarchar(max) = N'{"queries":[{"element":"First Name","operator":"contains","secondOperator":"","value":"a","elementTypeId":"1","order":1,"match":"and","groupId":1,"groupValue":""},{"element":"Make","operator":"is","secondOperator":"","value":"HARLEY-DAVIDSON","elementTypeId":"9","order":2,"match":"","groupId":1,"groupValue":""}]}',
			--@segmant_query nvarchar(max) = N'{"queries":[{"element":"First Name","operator":"contains","secondOperator":"","value":"jo","elementTypeId":"1","order":1,"match":"","groupId":1,"groupValue":""}]}',
			--@segmant_query nvarchar(max) = N'{"queries":[{"element":"Make","operator":"is","secondOperator":"","value":"HARLEY-DAVIDSON","elementTypeId":"9","order":2,"match":"","groupId":1,"groupValue":""}]}',
			--@segmant_query nvarchar(max) = N'{"queries":[{"element":"Campaign Activity","operator":"opened","secondOperator":"","value":"last_3_months","elementTypeId":"2","order":1,"match":"or","groupId":1,"groupValue":""},{"element":"Campaign Activity","operator":"clicked","secondOperator":"","value":"last_3_months","elementTypeId":"2","order":2,"match":"","groupId":1,"groupValue":""}]}',
			--@segmant_query nvarchar(max) = N'{"queries":[{"element":"First Name","operator":"contains","secondOperator":"","value":"JO","elementTypeId":"1","order":1,"match":"and","groupId":1,"groupValue":""},{"element":"Email Optout","operator":"is","secondOperator":"","value":0,"elementTypeId":"1","order":2,"match":"","groupId":1,"groupValue":""}]}',
			--@segmant_query nvarchar(max) = N'{"queries":[{"element":"First Name","operator":"contains","secondOperator":"","value":"JO","elementTypeId":"1","order":1,"match":"and","groupId":1,"groupValue":""},{"element":"SMS Optout","operator":"is","secondOperator":"","value":0,"elementTypeId":"1","order":2,"match":"","groupId":1,"groupValue":""}]}',
			
			--@account_id uniqueidentifier = '53857968-E3D7-48EB-8BC7-98649353E2AB',
			--@segmant_query nvarchar(max) = N'{"queries":[{"element":"List Name","operator":"is","secondOperator":"","value":"1658","elementTypeId":13,"order":1,"match":"","groupId":1,"groupValue":""}]}',
			@operator varchar(50) = 'or',    
			@search NVARCHAR(50) = '',    
			@Offset int = 0,    
			@page_no INT = 1,    
			@page_size INT = 500,    
			@sort_column NVARCHAR(20) = 'CreatedDate',    
			@sort_order NVARCHAR(20) = 'ASC',    
			@list_type_id int = 3,
			@campaign_type varchar(50) = null,
			@campaign_id int = null,
			@campaign_run_id int = null,
			@segment_id int = null,
			@flow_id int = null,
			@condition_json nvarchar(max) = null,
			@is_parent_campaign bit = null,
			@delay int = 20,-- As days
			@time_period varchar(10) = null


	Print 'Step 2 Dropping Temp Tables at ' + Convert(varchar(50), getdate(), 108)
	------------------------------------ Dropping Drop Tables if Exists ----------------------------------------------------    
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL					DROP TABLE #temp    
	IF OBJECT_ID('tempdb..#temp1') IS NOT NULL					DROP TABLE #temp1    
	IF OBJECT_ID('tempdb..#segments') IS NOT NULL				DROP TABLE #segments    
	IF OBJECT_ID('tempdb..#queries') IS NOT NULL				DROP TABLE #queries    
	IF OBJECT_ID('tempdb..#cust_coupon') IS NOT NULL			DROP TABLE #cust_coupon    
	IF OBJECT_ID('tempdb..#temp_final_coupon') IS NOT NULL		DROP TABLE #temp_final_coupon 
	IF OBJECT_ID('tempdb..#cust_images') IS NOT NULL			DROP TABLE #cust_images 
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
	IF OBJECT_ID('tempdb..#temp_email_campaign_items') IS NOT NULL 	DROP TABLE #temp_email_campaign_items
	IF OBJECT_ID('tempdb..#temp_parent_campaign_items') IS NOT NULL 	DROP TABLE #temp_parent_campaign_items
	IF OBJECT_ID('tempdb..#temp_channel_campaign') IS NOT NULL 	DROP TABLE #temp_channel_campaign
	IF OBJECT_ID('tempdb..#temp_parent_smscampaign_items') IS NOT NULL 	DROP TABLE #temp_parent_smscampaign_items
	IF OBJECT_ID('tempdb..#temp_sms_campaign_items') IS NOT NULL 	DROP TABLE #temp_sms_campaign_items
	IF OBJECT_ID('tempdb..#cust_distinct_Temp1') IS NOT NULL 	DROP TABLE #cust_distinct_Temp1
	IF OBJECT_ID('tempdb..#temp_trigger_json') IS NOT NULL 	DROP TABLE #temp_trigger_json
	IF OBJECT_ID('tempdb..#split_list_id') IS NOT NULL 	DROP TABLE #split_list_id
	IF OBJECT_ID('tempdb..#temp_count_download') IS NOT NULL 	DROP TABLE #temp_count_download
	IF OBJECT_ID('tempdb..#temp_customer_customers') IS NOT NULL 	DROP TABLE #temp_customer_customers
	IF OBJECT_ID('tempdb..#temp_customer_vehicles') IS NOT NULL 	DROP TABLE #temp_customer_vehicles

	--Insert into dbo.error_segment (ErrorMsg, ErrSeverity, ErrState) values ('Started', '', '')
	--Insert Query
	--if (@flow_id is not null)
	--Begin
		--Insert into dbo.segment_execution_query (query)
		--select 'exec [customer].[query_segment_get] ' +
		--			+ Case when @account_id is not null then '@account_id = ''' + Cast(@account_id as varchar(50)) + '''' else '' end
		--			+ Case when @segmant_query is not null then ', @segmant_query = ''' + @segmant_query + '''' else '' end
		--			+ case when @operator is not null then ', @operator = ''' + @operator  + '''' else '' end
		--			+ case when @Offset is not null then ', @Offset = ''' + Cast(@Offset as varchar(10))  + '''' else '' end
		--			+ case when @page_no is not null then ', @page_no = ''' + Cast(@page_no as varchar(10))  + '''' else '' end
		--			+ case when @page_size is not null then ', @page_size = ''' + Cast(@page_size as varchar(10))  + '''' else '' end
		--			+ case when @sort_column is not null then ', @sort_column = ''' + @sort_column  + '''' else '' end
		--			+ case when @sort_order is not null then ', @sort_order = ''' + @sort_order  + '''' else '' end
		--			+ case when @list_type_id is not null then ', @list_type_id = ''' + Cast(@list_type_id as varchar(10))  + '''' else '' end
		--			+ case when @campaign_type is not null then ', @campaign_type = ''' + @campaign_type  + '''' else '''' end
		--			+ case when @campaign_id is not null then ', @campaign_id = ''' + Cast(@campaign_id as varchar(10))  + '''' else '' end
		--			+ case when @campaign_run_id is not null then ', @campaign_run_id = ''' + Cast(@campaign_run_id as varchar(10))  + '''' else '' end
		--			+ case when @segment_id is not null then ', @segment_id = ''' + Cast(@segment_id as varchar(10))  + '''' else '' end
		--			+ case when @flow_id is not null then ', @flow_id = ''' + Cast(@flow_id as varchar(10))  + '''' else '' end
		--			+ case when @condition_json is not null then ', @condition_json = ''' + @condition_json  + '''' else '' end
		--			+ case when @is_parent_campaign is not null then ', @is_parent_campaign = ''' + Cast(@is_parent_campaign as varchar(10))  + '''' else '' end
		--			+ case when @delay is not null then ', @delay = ''' + Cast(@delay as varchar(10))  + '''' else '' end
		--			+ case when @time_period is not null then ', @time_period = ''' + @time_period  + '''' else '' end
	--End

	------------------------------------ Declaring variables ----------------------------------------------------
	Print 'Step 3 Declaring local variables ' + Convert(varchar(50), getdate(), 108)

	declare @total_count int = 0         
			,@query nvarchar(max)    
			,@result varchar(max) = ''
			,@result1 varchar(max) = ''
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
			,@parent_campaign_guid varchar(50)
			,@parent_campaign_id int
			,@channel varchar(10)
			,@trigger_json varchar(max)
			,@trigger_json1 varchar(max)
			,@flow_json varchar(max)
			,@prt_dealer_id int
			,@dealer_name varchar(500)
			,@sms_campaign_items_count int

		
    
	set @search = Isnull(@search, '')

	------------------------------------ Creating Temp Tables ----------------------------------------------------
	Print 'Step 4 Creating Temp Tables ' + Convert(varchar(50), getdate(), 108)

	Create Table #split_list_id (list_id varchar(25))

	Create table #queries
	(
		query varchar(4000),
		operator varchar(25),
		id int,
		[Brackets] varchar(5),
		is_processed bit default (0),
		channel varchar(10),
		groupId int,
		groupValue varchar(10),
		segment_type varchar(50),
	)

	Create table #temp (
		   [customer_id] Varchar(50),    
		   [customer_guid] uniqueidentifier,    
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
		   make varchar(100),	
		   model varchar(100), 
		   model_year varchar(10), 
		   [trim] varchar(50), 
		   Engine varchar(50), 
		   fuel_type varchar(50),
		   vin varchar(50),
		   last_ro_date varchar(15),
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
		   cust_title varchar(50),
		   next_service_date date,
		   is_email_delivered bit, 
		   is_sms_delivered bit, 
		   is_print_delivered bit, 
		   is_opened bit,
		   servicevisit bit default (0),
		   do_not_sms varchar(5),
		   do_not_whatsapp varchar(5),
		   is_service_booked varchar(5),
		   is_valid_email bit default(1),
		   is_valid_phone bit default(1),
		   is_valid_address bit default(1),
		   list_ids varchar(4000),
		   is_email_bounce bit default 0,
		   is_fleet bit default 0,
		   ro_close_date int,
		   ro_number varchar(50),
		   is_app_user bit default 0,
		   nuo_flag varchar(25),
		   src_cust_updatedt int
		  )    
  
	Create table #temp1 (
		   [customer_id] Varchar(50),    
		   [customer_guid] uniqueidentifier,    
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
		   make varchar(100),	
		   model varchar(100), 
		   model_year varchar(10), 
		   [trim] varchar(50), 
		   Engine varchar(50), 
		   fuel_type varchar(50),
		   vin varchar(50),
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
		   cust_title varchar(50),
		   next_service_date date,
		   is_email_delivered bit, 
		   is_sms_delivered bit, 
		   is_print_delivered bit, 
		   is_opened bit,
		   servicevisit bit default (0),
		   do_not_sms varchar(5),
		   do_not_whatsapp varchar(5),
		   is_service_booked varchar(5),
		   source varchar(10),
		   list_ids varchar(4000),
		   is_email_bounce bit default 0,
		   is_fleet bit default 0,
		   ro_close_date int,
		   ro_number varchar(50),
		   is_app_user bit default 0,
		   nuo_flag varchar(25),
		   src_cust_updatedt int
		  )    
   
	Create table #custTemp (
		   [customer_id] Varchar(50),    
		   [customer_guid] uniqueidentifier,    
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
		   make varchar(100), 
		   model varchar(100), 
		   model_year varchar(10), 
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
		   vin varchar(50),
		   purchase_date int,
		   nuo_flag varchar(25),
		   cust_status varchar(25),
		   lead_status_id varchar(500),
		   lead_source_id varchar(500),
		   parent_dealer_id int,
		   suffix varchar(50),
		   cust_title varchar(50),
		   next_service_date date,
		   is_email_delivered bit, 
		   is_sms_delivered bit, 
		   is_print_delivered bit, 
		   is_opened bit,
		   servicevisit bit,
		   do_not_sms varchar(5),
		   do_not_whatsapp varchar(5),
		   is_service_booked varchar(5),
		   is_valid_email bit default(1),
		   is_valid_phone bit default(1),
		   is_valid_address bit default(1),
		   is_email_bounce bit default 0,
		   is_fleet bit default 0,
		   is_app_user bit default 0,
		   src_cust_updatedt int
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
		vin varchar(50),
		cust_dms_number varchar(50)
	)

	Create table #tempSales
	(
		deal_number_dms varchar(50), 
		purchase_date int,  
		nuo_flag varchar(25), 
		master_customer_id int, 
		master_vehicle_id int, 
		vin varchar(50), 
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
	    make varchar(100), 
	    model varchar(100), 
	    model_year varchar(10), 
	    [address1] varchar(250),
	    [address2] varchar(250),
	    [city] varchar(50),
	    [state] varchar(50),
	    [country] varchar(50),
	    [zip_code] varchar(50),
		master_customer_id int,
		master_vehicle_id int,
		vin varchar(50),
		parent_dealer_id int,
		suffix varchar(50),
		cust_title varchar(50),
		next_service_date date,
		is_email_delivered bit, 
		is_sms_delivered bit, 
		is_print_delivered bit, 
		is_opened bit,
		last_ro_date int,
		servicevisit bit,
		do_not_sms varchar(5),
		do_not_whatsapp varchar(5),
	    [addresses] varchar(2000),
		is_service_booked varchar(5),
		is_valid_email bit default(1),
		is_valid_phone bit default(1),
		is_valid_address bit default(1),
		last_visit_date varchar(50),
		is_email_bounce bit default 0,
		is_fleet bit default 0,
		ro_close_date int,
		ro_number varchar(50),
		is_app_user bit default 0,
		src_cust_updatedt int
	)  

	Create table #cust_coupon
	(
		id int identity(1,1),
		customer_id Varchar(50),
		master_customer_id int,
		vin varchar(50),
		[addresses] varchar(2000),
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
		vin varchar(50),
		[addresses] varchar(2000),
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
		vin varchar(50),
		[addresses] varchar(2000),
		print_text_id int,
		priority_id int,
		is_default bit,
		position_id int,
		position1 nvarchar(max) null
	)

	Create table #segments
	(
		element varchar(500),
		operator varchar(50),
		secondoperator varchar(50),
		[value] varchar(max),
		[match] varchar(50),
		[id] int,
		groupId int,
		groupValue varchar(10),
		segment_type varchar(50)
	)

	------------------------------------ Segment/Trigger/Condition Json Deserialize and preparing Condition Query --------------------------------
	Print 'Step 5 Segment/Trigger/Condition Json Deserialize and preparing Condition Query ' + Convert(varchar(50), getdate(), 108)

	------------------------------------ Segment Json Deserialize and preparing Condition Query --------------------------------------------------
	Print 'Step 5.1 Segment Json Deserialize and preparing Condition Query ' + Convert(varchar(50), getdate(), 108)
	if (@segment_id is not null)
	begin
		print 'segment Id Condition'
		--select @segmant_query = segment_query from customer.segments (nolock) where segment_id = @segment_id
		select @segmant_query = segment_query, @list_type_id = list_type_id, @segment_name = segment_name from customer.segments (nolock) where segment_id = @segment_id
		print @segmant_query
		print @list_type_id
	
	end

	print 'Step 5.1.1 ' + Convert(varchar(50), getdate(), 108)
	print @segmant_query

	insert into #queries
	select *, 'Segment Json' from [customer].[get_segment_conditions_new1](@segmant_query, @is_parent_campaign)

	print 'Step 5.1.2 ' + Convert(varchar(50), getdate(), 108)

	SELECT @result = SUBSTRING((SELECT ' ' + (case when Brackets = '(' then Brackets + query else '' + query end) +  (case when Brackets = ')' then Brackets else '' end) + ' ' + operator    
	FROM #queries  
	where segment_type = 'Segment Json'
	order by id    
	FOR XML PATH('')), 0, 9999)   
	
	print 'Step 5.1.3 ' + Convert(varchar(50), getdate(), 108)
	
	set @result1 = '(' +  (Case when reverse(substring(reverse(@result), 1, 4)) like '%or%' or substring(reverse(@result), 1, 4) like '%and%' then substring(@result, 1, (Len(@result) -  charindex(' ', reverse(@result), 1))) else @result end) + ')'
	
	print 'Step 5.1.4 ' + Convert(varchar(50), getdate(), 108)
	
	Insert into #segments (element, operator, secondoperator, [value], [match], id, groupId, groupValue, segment_type)
	SELECT 
		  element
		, operator
		, secondOperator
		, (case when [type] = 1 then [value] else (select [value] from OpenJson(a.[value]) where [key] = 'endDate') end) as [value]
		, [match]
		, [order] as [id]
		, [groupId]
		, [groupValue]
		, 'Segment Json'
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
			,Json_Value([value], '$.groupId') as [groupId]
			,Json_Value([value], '$.groupValue') as [groupValue]
		FROM 
		OPENJSON( @segmant_query, '$.queries')     
	) AS a


	------------------------------------ Trigger Json Deserialize and preparing Condition Query --------------------------------------------------
	Print 'Step 5.2 Trigger Json Deserialize and preparing Condition Query ' + Convert(varchar(50), getdate(), 108)

	--if (@trigger_json is not null)
	if (@is_parent_campaign = 1)
	begin

		--select @trigger_json = b.trigger_json
		--from flow.flows a (nolock)
		--inner join flow.triggers b (nolock) on a.trigger_id = b.trigger_id
		--where a.flow_id = @flow_id
	
		Print 'Step 5.2.1 Trigger Json Deserialize and preparing Condition Query ' + Convert(varchar(50), getdate(), 108)
		
		select @flow_json = a.flow_json
		from flow.flows a (nolock)
		where a.flow_id = @flow_id

		Print 'Step 5.2.2 Trigger Json Deserialize and preparing Condition Query ' + Convert(varchar(50), getdate(), 108)

		select  @trigger_json1 = JSON_QUERY([value], '$.rules')
		from OpenJson((select [Value] from OpenJson(@flow_json) where [Key] = 'rules'))
		Where Json_Value([value], '$.type') = 'trigger'

		select  '{"element":"' + Json_Value([value], '$.element') + '","match":"","elementTypeId":"9","order":1,"operator":"is","secondOperator":"","value":"' + 
				Case when Json_Value([value], '$.type') = 'day' and Json_Value([value], '$.beforeafter') = 'before' then Cast((-1 * Cast(Json_Value([value], '$.value') as int)) as varchar(10))
					 when Json_Value([value], '$.type') = 'day' and Json_Value([value], '$.beforeafter') = 'after' then Cast(Json_Value([value], '$.value') as varchar(10))
					 when Json_Value([value], '$.type') = 'month' and Json_Value([value], '$.beforeafter') = 'before' then Cast(Datediff(day, DateAdd(Month, Cast(-1 * Cast(Json_Value([value], '$.value') as int) as int), getdate()), getdate()) as varchar(10))
					 when Json_Value([value], '$.type') = 'month' and Json_Value([value], '$.beforeafter') = 'after' then Cast(Datediff(day, DateAdd(Month, Cast(Json_Value([value], '$.value') as int), getdate()), getdate()) as varchar(10))
					 when Json_Value([value], '$.type') = 'year' and Json_Value([value], '$.beforeafter') = 'before' then Cast(Datediff(day, DateAdd(Year, Cast(-1 * Cast(Json_Value([value], '$.value') as int) as int), getdate()), getdate()) as varchar(10))
					 when Json_Value([value], '$.type') = 'year' and Json_Value([value], '$.beforeafter') = 'after' then Cast(Datediff(day, DateAdd(Year, Cast(Json_Value([value], '$.value') as int), getdate()), getdate()) as varchar(10))
				else Cast(Json_Value([value], '$.value') as varchar(10))
				end + '"}'  as trigger_json
		into #temp_trigger_json
		from OpenJson(@trigger_json1)

		Print 'Step 5.2.3 Trigger Json Deserialize and preparing Condition Query ' + Convert(varchar(50), getdate(), 108)

		SELECT @trigger_json = COALESCE(@trigger_json + ', ', '') + trigger_json FROM #temp_trigger_json

		set @trigger_json = '{"queries":[' + @trigger_json + ']}'

		print 'Trigger Json'
		Print @trigger_json

		insert into #queries
		select *, 'Trigger Json' from [customer].[get_segment_conditions_new1](@trigger_json, @is_parent_campaign)

		SELECT @result = SUBSTRING((SELECT ' ' + (case when Brackets = '(' then Brackets + query else '' + query end) +  (case when Brackets = ')' then Brackets else '' end) + ' ' + operator    
		FROM #queries   
		where segment_type = 'Trigger Json'
		order by id    
		FOR XML PATH('')), 0, 9999)    
		
		set @result1 = Case when @result1 is null then '' else @result1 end

		set @result1 = @result1 + (Case when Len(@result) > 0 and Len(@result1) > 0 then (Char(10) + Char(13) + ' and (' + (Case when reverse(substring(reverse(@result), 1, 4)) like '%or%' or substring(reverse(@result), 1, 4) like '%and%' then substring(@result, 1, (Len(@result) -  charindex(' ', reverse(@result), 1))) else @result end) + ')') 
										when Len(@result) > 0 and Len(@result1) <= 0 then (Char(10) + Char(13) + ' (' + (Case when reverse(substring(reverse(@result), 1, 4)) like '%or%' or substring(reverse(@result), 1, 4) like '%and%' then substring(@result, 1, (Len(@result) -  charindex(' ', reverse(@result), 1))) else @result end) + ')') 
										else '' end)

		Insert into #segments (element, operator, secondoperator, [value], [match], id, segment_type)
		SELECT 
			  element
			, operator
			, secondOperator
			--,[value]
			, (case when [type] = 1 then [value] else (select [value] from OpenJson(a.[value]) where [key] = 'endDate') end) as [value]
			, [match]
			, [order] as [id]
			, 'Trigger Json'
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
			OPENJSON( @trigger_json, '$.queries')     
		) AS a

			Print  '-------------------------------------------'
	print @result1
	Print  '-------------------------------------------'
	end



	------------------------------------ Condition Json Deserialize and preparing Condition Query --------------------------------------------------
	Print 'Step 5.3 Condition Json Deserialize and preparing Condition Query ' + Convert(varchar(50), getdate(), 108)
	if (@is_parent_campaign = 0)
	Begin
		
		set @condition_json = '{"queries":' + @condition_json + '}'
		set @condition_json = Replace(Replace(Replace(@condition_json, 'fieldoperator', 'match'), 'field', 'element'), '"op"','"operator"')

		insert into #queries
		select *, 'Condition Json' from [customer].[get_segment_conditions_new1](@condition_json, @is_parent_campaign)

		SELECT @result = SUBSTRING((SELECT ' ' + (case when Brackets = '(' then Brackets + query else '' + query end) +  (case when Brackets = ')' then Brackets else '' end) + ' ' + operator    
		FROM #queries   
		where segment_type = 'Condition Json'
		order by id    
		FOR XML PATH('')), 0, 9999)  

		set @result1 = Case when @result1 is null then '' else @result1 end

		set @result1 = @result1 + (Case when Len(@result) > 0 and Len(@result1) > 0 then (Char(10) + Char(13) + ' and (' + (Case when reverse(substring(reverse(@result), 1, 4)) like '%or%' or substring(reverse(@result), 1, 4) like '%and%' then substring(@result, 1, (Len(@result) -  charindex(' ', reverse(@result), 1))) else @result end) + ')') 
										when Len(@result) > 0 and Len(@result1) <= 0 then (Char(10) + Char(13) + ' (' + (Case when reverse(substring(reverse(@result), 1, 4)) like '%or%' or substring(reverse(@result), 1, 4) like '%and%' then substring(@result, 1, (Len(@result) -  charindex(' ', reverse(@result), 1))) else @result end) + ')') 
										else '' end)

		Insert into #segments (element, operator, secondoperator, [value], [match], id, segment_type)
		SELECT 
			  element
			, operator
			, secondOperator
			--,[value]
			, (case when [type] = 1 then [value] else (select [value] from OpenJson(a.[value]) where [key] = 'endDate') end) as [value]
			, [match]
			, [order] as [id]
			, 'Condition Json'
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
			OPENJSON( @condition_json, '$.queries')     
		) AS a

		End

	------------------------------------ Condition Json Deserialize and preparing Condition Query --------------------------------------------------
	Print 'Step 6 Createing Dealer Temp Tables ' + Convert(varchar(50), getdate(), 108)

	--select * into #temp_dealer from clictell_auto_master.[master].dealer (nolock)
	--select * into #temp_dealer from [portal].[account] with (nolock)
	------KS add :start
	declare @verticalid int

	select 
				a.*,b.verticalid  
			into #temp_dealer
	from 
	[portal].[account] a with (nolock) 
	left outer join [auto_customers].[portal].[store_front] b with (nolock) on a._id =b.accountid
	


	select @prt_dealer_id = account_id, @dealer_name = accountname, @verticalid = verticalid from #temp_dealer where _id = @account_id
  	------KS add :END

	Print 'Step 6.1 Getting Parent Delaer Id based on account id  ' + Convert(varchar(50), getdate(), 108)
	select @parent_dealer_id = COALESCE(@parent_dealer_id + ', ' + Cast(parent_dealer_id as varchar(50)), Cast(parent_dealer_id as varchar(50)))  
	from  clictell_auto_master.[master].[dealer_hierarchy] (@account_id)

	------------------------------Verifying ALL Customer Segment -----------------------------------------------
	declare @seg_count int = (select count(*) from #segments)
	declare @seg_cust_count int = (select count(*) from #segments where element in ('First Name','Last Name','Address','Birthday', 'Email Address','Phone Number', 'Tag Name',
	'City', 'State', 'Zipcode','Miles Radius','Status''Daily Average Mileage','Area Code','Email Optout', 'SMS Optout', 'Print Optout','Email Bounced','List Name', 'Cutomer Last Updated Date') )
	
	declare @all_customer_segment bit = (case when @seg_count = @seg_cust_count and @verticalid=2 then 1 else 0 end)


	------------------------------------ Preparing Customer data --------------------------------------------------
	Print 'Step 7 Preparing Customer data ' + Convert(varchar(50), getdate(), 108)

	Print 'Step 7.1 Preparing Customer data for flow Campaings ' + Convert(varchar(50), getdate(), 108)
	if (@is_parent_campaign = 0)
	Begin

		Declare @sms_condition_filter bit  = 0
		Declare @email_condition_filter bit  = 0

		SELECT 
			element,
			channel,
			cguid,
			0 as is_processed,
			[value]
		into 
			#temp_channel_campaign
		FROM
		(
			SELECT 
				Json_Value([value], '$.element') as element
				,Json_Value([value], '$.channel') as channel
				,Json_Value([value], '$.campaignGuid') as cguid
				,Json_Value([value], '$.value') as [value]
			FROM 
			OPENJSON( @condition_json, '$.queries')     
		) AS a

		While ((select count(*) from #temp_channel_campaign where is_processed = 0) > 0)
		Begin
		
			select top 1 @parent_campaign_guid= cguid, @channel = channel from #temp_channel_campaign where is_processed = 0

			if (@channel = 'Email')
			Begin
				set @email_condition_filter = 1
				select @parent_campaign_id = campaign_id from email.campaigns  (nolock) where is_deleted = 0 and campaign_guid = @parent_campaign_guid
				select * into #temp_parent_campaign_items from email.campaign_items (nolock) where is_deleted = 0 and campaign_id = @parent_campaign_id and flow_id = @flow_id and Isnull(is_unsubscribed, 0) = 0 and isnull(is_bounced, 0) = 0
		
				select a.list_member_id, newid() as campaign_item_guid, email_address, first_name, '' as middle_name, last_name, [address], city, state, '' as country, zip_code, phone, @account_id as account_id, 
									a.make, a.model, a.[year], a.vin, a.is_delivered, a.is_opened, a.is_deleted, Convert(varchar(10), Cast(a.last_service_date as date), 112) as last_service_date, 
									(Case when Cast(c.last_service_date as date) > Cast(a.last_service_date as date) then 1 else 0 end) as servicevisit
				into 
					#temp_email_campaign_items
				from 
					#temp_parent_campaign_items a (nolock)
					inner join flow.campaign_run d (nolock) on Isnull(a.campaign_run_id, '') = d.campaign_run_id
					inner join customer.vehicles c (nolock) on isnull(a.list_member_id, '') = c.customer_id and a.vin = c.vin
				where 
					(		lower(@time_period) = 'Days'  and Cast(DateAdd(day, @delay, d.run_dt) as date) = Cast(getdate() as date)
						or
							lower(@time_period) = 'Hours'  and getdate() >= Dateadd(hour, @delay, d.run_dt) and getdate() <= dateadd(hour, @delay + 1, d.run_dt)
					)
					and c.is_deleted = 0
			
				Insert into #temp1 (customer_id, customer_guid, primary_email, first_name, middle_name, last_name, address_line, city, state, country, zip_code, primary_phone_number, account_id,
									make, model, model_year, vin, is_email_delivered, is_opened, is_deleted, last_ro_date, servicevisit, parent_dealer_id, master_customer_id, do_not_email,
									is_service_booked, source)
				select list_member_id, a.campaign_item_guid, a.email_address, a.first_name, a.middle_name, a.last_name, address, a.city, a.state, a.country, zip_code, a.phone, a.account_id,
									make, model, [year], vin, Isnull(is_delivered, 0), is_opened, a.is_deleted, last_service_date, servicevisit, b.account_id, a.list_member_id, 0, 
									(Case when c.demo_scheduled_date__c is null then 0 when Cast(c.demo_scheduled_date__c as date) >= cast(getdate() as date) then 1 else 0 end) as is_service_booked,
									'Email'
				from 
					#temp_email_campaign_items a
				inner join #temp_dealer b on a.account_id = b._id
				left outer join auto_crm.[lead].appointments c on a.list_member_id = c.customer_id and status in ('Appointment Confirmed', 'Appointment Reschedule')
			end	
			else if (@channel = 'SMS')
			Begin
				set @sms_condition_filter = 1
				select @parent_campaign_id = campaign_id from [sms].campaigns (nolock) where is_deleted = 0 and campaign_guid = @parent_campaign_guid 
				select * into #temp_parent_smscampaign_items from [sms].campaign_items (nolock) where is_deleted = 0 and campaign_id = @parent_campaign_id

				select a.list_member_id into #temp_excluded_members
				from #temp_parent_smscampaign_items a (nolock)
				inner join flow.campaign_run b (nolock) on a.campaign_run_id = b.campaign_run_id 
				inner join auto_campaigns.sms.inbound_message c (nolock) on a.phone_number = c.[to]
				where b.run_dt >= (Case when @time_period = 'Hours' then dateadd(hour, -1 * @delay, getdate())
									when @time_period = 'Days' then dateadd(day, -1 * @delay, getdate())
								end )
					--and b.message in (select [value] from #temp_channel_campaign where element = 'Responded')
				 
				select a.list_member_id, newid() as campaign_item_guid, first_name, '' as middle_name, last_name, [address], city, state, '' as country, zip_code, phone, @account_id as account_id, 
									a.make, a.model, a.[year], a.vin, a.is_delivered, a.is_deleted, Convert(varchar(10), Cast(a.last_service_date as date), 112) as last_service_date, 
									(Case when Cast(c.last_service_date as date) > Cast(a.last_service_date as date) then 1 else 0 end) as servicevisit,email
				into 
					#temp_sms_campaign_items
				from 
					#temp_parent_smscampaign_items a (nolock)
					inner join flow.campaign_run d (nolock) on Isnull(a.campaign_run_id, '') = d.campaign_run_id
					inner join customer.vehicles c (nolock) on isnull(a.list_member_id, '') = c.customer_id
				where 
					(		lower(@time_period) = 'Days'  and Cast(DateAdd(day, @delay, d.run_dt) as date) = Cast(getdate() as date)
						or
							lower(@time_period) = 'Hours'  and getdate() >= Dateadd(hour, @delay, d.run_dt) and getdate() <= dateadd(hour, @delay + 1, d.run_dt)
					)
					and c.is_deleted = 0
					and a.list_member_id not in (select list_member_id from #temp_excluded_members)
			
				Insert into #temp1 (customer_id, customer_guid, first_name, middle_name, last_name, address_line, city, state, country, zip_code, primary_phone_number, account_id,
									make, model, model_year, vin, is_sms_delivered, is_deleted, last_ro_date, servicevisit, parent_dealer_id, master_customer_id, is_opened, do_not_sms,
									is_service_booked, source,primary_email)
				select list_member_id, a.campaign_item_guid, a.first_name, a.middle_name, a.last_name, address, a.city, a.state, a.country, zip_code, a.phone, a.account_id,
									make, model, [year], vin, Isnull(is_delivered, 0), a.is_deleted, last_service_date, servicevisit, b.account_id, a.list_member_id, 0 as is_opened, 0,
									(Case when c.demo_scheduled_date__c is null then 0 when Cast(c.demo_scheduled_date__c as date) >= cast(getdate() as date) then 1 else 0 end) as is_service_booked,
									'SMS',a.email
				from 
					#temp_sms_campaign_items a
				inner join #temp_dealer b on a.account_id = b._id
				left outer join auto_crm.[lead].appointments c on a.list_member_id = c.customer_id and status in ('Appointment Confirmed', 'Appointment Reschedule')
			end	

			Update #temp_channel_campaign set is_processed = 1 where channel = @channel and cguid = @parent_campaign_guid

		End

		if (@sms_condition_filter = 1 and @email_condition_filter = 1)
		Begin
			Insert into #temp (customer_id, customer_guid, first_name, middle_name, last_name, address_line, city, state, country, zip_code, primary_phone_number, account_id,
								make, model, model_year, vin, is_email_delivered, is_sms_delivered, is_deleted, last_ro_date, servicevisit, parent_dealer_id, master_customer_id, is_opened, 
								do_not_sms, do_not_email, is_service_booked, primary_email, is_valid_email, is_valid_phone, is_valid_address)
			select a.customer_id, a.customer_guid, a.first_name, a.middle_name, a.last_name, a.address_line, a.city, a.state, a.country, a.zip_code, a.primary_phone_number, a.account_id,
				   a.make, a.model, a.model_year, a.vin, a.is_email_delivered, b.is_sms_delivered, a.is_deleted, a.last_ro_date, a.servicevisit, a.parent_dealer_id, a.master_customer_id, 
				   a.is_opened, b.do_not_sms, a.do_not_email,
				   a.is_service_booked, a.primary_email, 0, 0, 0
			from #temp1 a 
			inner join #temp1 b on a.customer_id = b.customer_id and a.vin = b.vin
			where a.source = 'Email' and b.source = 'SMS'
			Union
			select a.customer_id, a.customer_guid, a.first_name, a.middle_name, a.last_name, a.address_line, a.city, a.state, a.country, a.zip_code, a.primary_phone_number, a.account_id,
				   a.make, a.model, a.model_year, a.vin, a.is_email_delivered, Isnull(b.is_sms_delivered, 0), a.is_deleted, a.last_ro_date, a.servicevisit, a.parent_dealer_id, a.master_customer_id, 
				   a.is_opened, Isnull(b.do_not_sms, 1), a.do_not_email,
				   a.is_service_booked, a.primary_email, 0, 0, 0
			from #temp1 a 
			Left outer join #temp1 b on a.customer_id = b.customer_id and a.vin = b.vin and b.source = 'SMS' 
			where a.source = 'Email' and b.customer_id is null
			Union
			select a.customer_id, a.customer_guid, a.first_name, a.middle_name, a.last_name, a.address_line, a.city, a.state, a.country, a.zip_code, a.primary_phone_number, a.account_id,
				   a.make, a.model, a.model_year, a.vin, isnull(b.is_email_delivered, 0), a.is_sms_delivered, a.is_deleted, a.last_ro_date, a.servicevisit, a.parent_dealer_id, a.master_customer_id, 
				   a.is_opened, a.do_not_sms, Isnull(b.do_not_email,1),
				   a.is_service_booked, a.primary_email, 0, 0, 0
			from #temp1 a 
			Left outer join #temp1 b on a.customer_id = b.customer_id and a.vin = b.vin and b.source = 'Email'
			where a.source = 'SMS' and b.customer_id is null
		End
		else
		Begin
			Insert into #temp (customer_id, customer_guid, first_name, middle_name, last_name, address_line, city, state, country, zip_code, primary_phone_number, account_id,
								make, model, model_year, vin, is_email_delivered, is_sms_delivered, is_deleted, last_ro_date, servicevisit, parent_dealer_id, master_customer_id, is_opened, 
								do_not_sms, do_not_email, is_service_booked, primary_email, is_valid_email, is_valid_phone, is_valid_address)
			select a.customer_id, a.customer_guid, a.first_name, a.middle_name, a.last_name, a.address_line, a.city, a.state, a.country, a.zip_code, a.primary_phone_number, a.account_id,
				   a.make, a.model, a.model_year, a.vin, a.is_email_delivered, a.is_sms_delivered, a.is_deleted, a.last_ro_date, a.servicevisit, a.parent_dealer_id, a.master_customer_id, 
				   a.is_opened, a.do_not_sms, a.do_not_email,
				   a.is_service_booked, a.primary_email, 0, 0, 0
			from #temp1 a 
		End

		--- Updating Invalid Email/Phone Updates
		select customer_id, primary_email_valid, primary_phone_number_valid, secondary_phone_number_valid,do_not_sms,do_not_email into #temp_cust_update from customer.customers (nolock) where account_id = @account_id and is_deleted = 0 and customer_id in (select distinct customer_id from #temp)

		Update a set
			a.is_valid_email = b.primary_email_valid, 
			a.is_valid_phone = (case when Isnull(b.primary_phone_number_valid, 0) = 1 or Isnull(b.secondary_phone_number_valid, 0) = 1 then 1 else 0 end),
			a.do_not_sms = b.do_not_sms,
			a.do_not_email = b.do_not_email
		from #temp a
		inner join #temp_cust_update b on a.customer_id = b.customer_id

	End
	else 
	Begin
		if (@list_type_id = 2)    
		Begin    
			Print 'Step 7.2 Preparing Customer data for DMS Data ' + Convert(varchar(50), getdate(), 108)
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
				b.last_activity_date,b.active_dt as active_date,
				b.inactive_date, (Case when b.customer_type = 'F' then 'Fleet' when b.customer_type = 'B' then 'Business' else 'Resident' end) as customer_type, Isnull(a.last_ro_mileage, 0) as last_ro_mileage, c.avg_mileage_per_day,
				c.vehicle_type, b.cust_do_not_email, b.cust_do_not_mail, b.cust_do_not_call, b.cust_miles_distance as [Redius],
				a.natural_key, a.parent_dealer_id, a.master_customer_id, a.master_vehicle_id, b.cust_status, b.cust_suffix, b.cust_salutation_text, a.next_service_date
			into #temp_custvehicle
			from [master].cust_2_vehicle a (nolock)
			inner join master.customer b (nolock) on a.master_customer_id = b.master_customer_id
			inner join master.vehicle c (nolock) on a.master_vehicle_id = c.master_vehicle_id
			where Isnull(a.is_deleted, 0) = 0  and a.parent_dealer_id in (select [value] from string_split(@parent_dealer_id,',')) and a.inactive_date is null
			--and b.cust_full_name not like '%Unknown' and Len(b.cust_full_name) > 0 --and b.customer_type = 'C'

			Print 'Step 5.1 ' + Convert(varchar(50), getdate(), 108)
		
			select distinct ro_number, ro_close_date, total_customer_price, total_warranty_price, total_internal_price, total_repair_order_price as total_ro_amount, 
			(Case when total_customer_price > 0  then 'CP/' else '' end) + (Case when total_warranty_price > 0  then 'WP/' else '' end) + (Case when total_internal_price > 0  then 'IP/' else '' end) as pay_type,
			master_customer_id, master_vehicle_id, Cast(vin as varchar(20)) as vin, cust_dms_number
			into #temp_ro
			from master.repair_order_header (nolock)
			where parent_dealer_id in (select [value] from string_split(@parent_dealer_id,',')) and Isnull(is_deleted, 0) = 0
			and ro_status = 'COMPLETED'

			Print 'Step 5.2 ' + Convert(varchar(50), getdate(), 108)

			select distinct deal_number_dms, purchase_date,  Ltrim(Rtrim(nuo_flag)) as nuo_flag, master_customer_id, master_vehicle_id, vin, cust_dms_number
			into #temp_sales
			from master.fi_sales with (nolock)
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
								vin, cust_status, parent_dealer_id, suffix,cust_title, next_service_date)    
			select distinct cust_dms_number, null as customer_guid, lower(cust_email_address1) as [primary_email], cust_first_name as first_name, cust_middle_name as [middle_name], cust_last_name as [last_name],    
			Isnull(cust_address1,'') + ' ' + Isnull(cust_address2, '') + ' ' + Isnull(cust_city, '') + ' ' + Isnull(cust_state_code,'') + ' ' + Isnull(cust_zip_code, '')  as [address_line], 
			primary_phone_number as [primary_phone_number], '' as [tags], cust_do_not_email as do_not_email,
			active_date as [created_dt], 0 as is_deleted, @account_id,    
			'{"addresses":[{"street":"' + Isnull(cust_address1,'') + ' ' + Isnull(cust_address2, '') + '","city":"' + Isnull(cust_city, '') + '","state":"'+ Isnull(cust_state_code,'') + '","country":"US","zip":"' + isnull(cust_zip_code, '') + ' ' + Isnull(cust_zip_code4,'') + '"}]}' as [addresses],
			'{"phoneNumbers":[{"phoneType": "Mobile","countryCode": "1","phoneNumber": "' + Isnull(primary_phone_number, '') + '","isPrimary":"0"}]}' as phone_numbers, cust_birth_date as birth_date,
			make , model , model_year, vehicle_trim as [trim], '' as Engine, fuel_type, last_ro_date, customer_type, last_ro_mileage, avg_mileage_per_day, vehicle_type, 
			cust_do_not_mail, cust_do_not_call,
			[Redius], cust_address1, cust_address2, cust_city, cust_state_code, cust_country, cust_zip_code + (Case when Len(cust_zip_code4) > 0 then '-' + cust_zip_code4  else '' end)
			, last_activity_date, master_customer_id, master_vehicle_id, vin, cust_status, parent_dealer_id, cust_suffix, cust_salutation_text, next_service_date
			from #temp_custvehicle

			Print 'Step 5.8 ' + Convert(varchar(50), getdate(), 108)

		End   
		else if (@list_type_id in (3, 4, 1, 5))    
		Begin 
			Print 'Step 7.3 Preparing Customer data for Upload/OEM/CRM Data ' + Convert(varchar(50), getdate(), 108)
			Print 'OEM List'
			print 'Customer_Seg: '+convert(varchar(2),@all_customer_segment)

			Declare @list_id varchar(100)

			select @list_id = [value] from #segments where Element = 'List Name'
	
			Insert into #split_list_id
			select value from STRING_SPLIT(@list_id, ',')

			delete from #split_list_id where Len(list_id) <= 0

			print @list_id
			--set @all_customer_segment =  0--As discussed with Deepak, for Campaign launch add this condition on 2022-03-10 
										
			--Creating Temp Tables from Main Tables
			select 
				* 
				into 
					#temp_customer_customers 
			from 
				Customer.Customers (nolock) 
			where     
					is_deleted = 0 
				and account_id = @account_id   
				and Isnull(is_unsubscribed, 0) = 0
				and Isnull(fleet_flag, 0) = 0
				and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1 or Primary_email_valid = 1)

			select 
				*
			into
				#temp_customer_vehicles
			from	
				Customer.vehicles (nolock)
			where
					is_deleted = 0 
					--and is_valid_vin = 1
				and account_id = @account_id 

			if(@all_customer_segment =0)
			BEGIN

			Insert into #temp (customer_id, customer_guid, primary_email, first_name, middle_name, last_name, address_line, primary_phone_number, tags, created_dt, is_deleted, 
								account_id, [addresses], phone_numbers, birth_date, make, model, model_year, [trim], Engine, fuel_type, [address1], [address2], [city], [state], 
								[country], [zip_code], parent_dealer_id, next_service_date, master_customer_id, last_ro_date, vin, master_vehicle_id, do_not_email, do_not_mail, 
								do_not_call, do_not_sms, do_not_whatsapp, is_service_booked, is_valid_phone, is_valid_email, is_valid_address, redius, list_ids, last_visit_date, 
								is_email_bounce, is_fleet, ro_close_date, ro_number, is_app_user, nuo_flag, src_cust_updatedt )    
			select  a.customer_id, customer_guid, ltrim(rtrim([primary_email])) as [primary_email], a.[first_name], a.[middle_name], a.[last_name], [address_line],     
			(Case when Len(ltrim(rtrim([primary_phone_number]))) >= 10 then ltrim(rtrim([primary_phone_number]))
				 when Len(ltrim(rtrim(secondary_Phone_number))) >= 10 then ltrim(rtrim([secondary_Phone_number]))
				 else ltrim(rtrim([primary_phone_number])) end) as [primary_phone_number], 
			[tags], a.[created_dt], a.is_deleted, a.account_id, addresses, phone_numbers, birth_date, make, model, 
			[Year],  trim_code as [trim], '' as Engine, '' as fuel_type, address_line, '' as address2, a.city, a.[state], Isnull(a.country, 'US'), zip, @prt_dealer_id,
			(Case when last_service_date is not null then Dateadd(month, 6, last_service_date) else null end) as next_service_date, a.customer_id, 
			Convert(varchar(10), b.ro_date, 112),
			vin, b.vehicle_id, do_not_email, do_not_mail, do_not_phone, do_not_sms, do_not_whatsapp, 
			(Case when d.demo_scheduled_date__c is null then 0 when Cast(d.demo_scheduled_date__c as date) >= cast(getdate() as date) then 1 else 0 end) as is_service_booked,
			(Case when Len(ltrim(rtrim([primary_phone_number]))) >= 10 then Isnull(primary_phone_number_valid, 1)
				 when Len(ltrim(rtrim(secondary_Phone_number))) >= 10 then Isnull(secondary_phone_number_valid, 1)
				 else 0 end) as is_valid_phone, 
			--Isnull(primary_phone_number_valid, 1) as is_valid_phone, 
			Isnull(primary_email_valid, 0) as is_valid_email, 1 as is_valid_address, Isnull(distance_from_dealer, 0), a.list_ids, Convert(varchar(10), b.purchase_date, 112)
			, a.is_email_bounce, isNull(fleet_flag, 0), Convert(varchar(10), b.last_service_date, 112), b.ro_number, a.is_app_user, 
			(case when b.vehicle_status is null then '' when b.vehicle_status = 'N' then 'New' when b.vehicle_status = 'U' then 'Used' else Isnull(b.vehicle_status, '') end) as vehicle_status
			, Convert(varchar(10), src_cust_updatedt, 112)
			from     
				#temp_customer_customers a with (nolock)    
			--inner join #temp_dealer c on a.account_id = c._id
			left outer join #temp_customer_vehicles b with (nolock) on a.customer_id = b.customer_id --and b.is_deleted = 0 and is_valid_vin = 1
			left outer join auto_crm.[lead].appointments d (nolock) on a.customer_id = d.customer_id and d.[status] in ('Appointment Confirmed','Appointment Reschedule')
		--where     
			--	a.is_deleted = 0 
			--and a.account_id = @account_id   
			--and Isnull(is_unsubscribed, 0) = 0
			--and Isnull(a.fleet_flag, 0) = 0
			--and (a.primary_phone_number_valid = 1 or a.Secondary_Phone_number_valid = 1 or Primary_email_valid = 1)
			--and @list_type_id in (select list_type_id from [list].[lists] b inner join (select [value] from string_split(a.list_ids,',')) c on Cast(b.list_id as varchar(10)) = c.[value])
			--and (@list_id is null or  EXISTS (SELECT *
			--			FROM   
			--				@split_list_id w
			--			WHERE  
			--				Charindex(',' + w.list_id + ',', ',' + list_ids + ',') > 0)
			--	)
			END
			if(@all_customer_segment = 1)
			BEGIN
			Insert into #temp (customer_id, customer_guid, primary_email, first_name, middle_name, last_name, address_line, primary_phone_number, tags, created_dt, is_deleted, 
								account_id, [addresses], phone_numbers, birth_date, make, model, model_year, [trim], Engine, fuel_type, [address1], [address2], [city], [state], 
								[country], [zip_code], parent_dealer_id, next_service_date, master_customer_id, last_ro_date, vin, master_vehicle_id, do_not_email, do_not_mail, 
								do_not_call, do_not_sms, do_not_whatsapp, is_service_booked, is_valid_phone, is_valid_email, is_valid_address, redius, list_ids, last_visit_date, 
								is_email_bounce, is_fleet, ro_close_date, ro_number, is_app_user, src_cust_updatedt)    
			select distinct  a.customer_id, customer_guid, ltrim(rtrim([primary_email])) as [primary_email], a.[first_name], a.[middle_name], a.[last_name], [address_line],     
			(Case when Len(ltrim(rtrim([primary_phone_number]))) >= 10 then ltrim(rtrim([primary_phone_number]))
				 when Len(ltrim(rtrim(secondary_Phone_number))) >= 10 then ltrim(rtrim([secondary_Phone_number]))
				 else ltrim(rtrim([primary_phone_number])) end) as [primary_phone_number], 
			[tags], a.[created_dt], a.is_deleted, a.account_id, addresses, phone_numbers, birth_date, null as make, null as model, 
			null as [Year],  null as [trim], '' as Engine, '' as fuel_type, address_line, '' as address2, a.city, a.[state], Isnull(a.country, 'US'), zip, @prt_dealer_id,
			/*(Case when last_service_date is not null then Dateadd(month, 6, last_service_date) else null end)*/ null as next_service_date, a.customer_id, 
			/*Convert(varchar(10), b.ro_date, 112)*/ null,
			null as vin, null as vehicle_id, do_not_email, do_not_mail, do_not_phone, do_not_sms, do_not_whatsapp, 
			/*(Case when d.demo_scheduled_date__c is null then 0 when Cast(d.demo_scheduled_date__c as date) >= cast(getdate() as date) then 1 else 0 end)*/ null as is_service_booked,
			(Case when Len(ltrim(rtrim([primary_phone_number]))) >= 10 then Isnull(primary_phone_number_valid, 1)
				 when Len(ltrim(rtrim(secondary_Phone_number))) >= 10 then 1
				 else Isnull(primary_phone_number_valid, 1) end)  as is_valid_phone, 
			--Isnull(primary_phone_number_valid, 1) as is_valid_phone, 
			Isnull(primary_email_valid, 1) as is_valid_email, 1 as is_valid_address, Isnull(distance_from_dealer, 0), a.list_ids, /*Convert(varchar(10), b.purchase_date, 112)*/ null
			, a.is_email_bounce, isNull(fleet_flag, 0), /*Convert(varchar(10), b.last_service_date, 112)*/ null, null as ro_number, is_app_user, Convert(varchar(10), src_cust_updatedt, 112)
			from     
			#temp_customer_customers a with (nolock)    
			--inner join #temp_dealer c on a.account_id = c._id
			--left outer join customer.vehicles b with (nolock) on a.customer_id = b.customer_id and b.is_deleted = 0 and is_valid_vin = 1
			--left outer join auto_crm.[lead].appointments d (nolock) on a.customer_id = d.customer_id and d.[status] in ('Appointment Reschedule','Appointment Reschedule')

			--where     
			--	a.is_deleted = 0 
			--and a.account_id = @account_id   
			--and Isnull(is_unsubscribed, 0) = 0
			--and Isnull(a.fleet_flag, 0) = 0
			--and (a.primary_phone_number_valid = 1 or a.Secondary_Phone_number_valid = 1 or Primary_email_valid = 1)
			--and @list_type_id in (select list_type_id from [list].[lists] b inner join (select [value] from string_split(a.list_ids,',')) c on Cast(b.list_id as varchar(10)) = c.[value])
			--and (@list_id is null or  EXISTS (SELECT *
			--			FROM   
			--				@split_list_id w
			--			WHERE  
			--				Charindex(',' + w.list_id + ',', ',' + list_ids + ',') > 0)
			--	)
		
			END

			 
		end
	End
   	------------------------------------ Updating do_not_email/mail/phone ---------------------------------
	Print 'Step 14 Updating do_not_email/mail/phone ' + Convert(varchar(50), getdate(), 108)

	Update #temp set do_not_email = 1 where Len(Isnull(primary_email, '')) <=0 and isnull(do_not_email,0) = 0
	Update #temp set do_not_mail = 1 where Len(Isnull(address_line,'')) <=0 and do_not_mail = 0
	Update #temp set do_not_call = 1 where Len(Isnull(primary_phone_number, '')) <=0 and do_not_call = 0
	Update #temp set do_not_sms = 1 where Len(Isnull(primary_phone_number, '')) <=0 and isnull(do_not_sms,0) = 0
	--Update #cust_Temp set do_not_whatsapp = 1 where Len(primary_phone_number) <=0 and do_not_whatsapp = 0

	------------------------------------ Preparing counts to apply the conditions --------------------------------------------------
	Print 'Step 8 Preparing counts to apply the conditions ' + Convert(varchar(50), getdate(), 108)

	------------------------------------ Preparing Campaign Activity condition ---------------------------------------
	Print 'Step 8.1 Preparing Campaign Activity condition ' + Convert(varchar(50), getdate(), 108)
	
	--select @campaign_activity_query_count = count(*) from #segments where element = 'Campaign Activity'   
	
	if((select count(*) from #segments where element = 'Campaign Activity') > 0)    
	begin    
		SELECT DISTINCT a.*,     
		(case when DateDiff(day, a.start_dt, getdate()) <= 7 and operator = 'opened' then 1 else 0 end) as [opened_Leass then 7 Days],    
		(case when DateDiff(Month, a.start_dt, getdate()) <= 1 and operator = 'opened' then 1 else 0 end) as [opened_Leass then 1 Month],    
		(case when DateDiff(Month, a.start_dt, getdate()) <= 3 and operator = 'opened' then 1 else 0 end) as [opened_Leass then 3 Months],
		(case when DateDiff(day, a.start_dt, getdate()) <= 7 and operator = 'clicked'  then 1 else 0 end) as [clicked_Leass then 7 Days],    
		(case when DateDiff(Month, a.start_dt, getdate()) <= 1 and operator = 'clicked'   then 1 else 0 end) as [clicked_Leass then 1 Month],    
		(case when DateDiff(Month, a.start_dt, getdate()) <= 3 and operator = 'clicked'   then 1 else 0 end) as [clicked_Leass then 3 Months],
		(case when DateDiff(day, a.start_dt, getdate()) <= 7 and operator = 'sent' then 1 else 0 end) as [sent_Leass then 7 Days],    
		(case when DateDiff(Month, a.start_dt, getdate()) <= 1 and operator = 'sent'  then 1 else 0 end) as [sent_Leass then 1 Month],    
		(case when DateDiff(Month, a.start_dt, getdate()) <= 3 then 1 else 0 end) as [Leass then 3 Months],

		T.operator as activity
		INTO #campaign_activity    
		FROM #segments as T    
		CROSS APPLY  [customer].[segment_campaign_activity_get] (T.Element, T.Operator,T.Value, @account_id) as a    
		WHERE T.Element in ('Campaign Activity')    
	end 
	
--select * from #segments

--select * from #campaign_activity
	------------------------------------ Preparing Date Add condition ---------------------------------------
	Print 'Step 8.2 Preparing Date Add condition ' + Convert(varchar(50), getdate(), 108)

	--select @date_added_query_count = count(*) from #segments where element = 'Date Added'    
	--if(@date_added_query_count > 0)    
	if((select count(*) from #segments where element = 'Date Added') > 0)    
	begin    
		SELECT DISTINCT a.*    
		INTO #date_added    
		FROM #segments as T    
		CROSS APPLY  [customer].[segment_campaign_activity_get] (T.Element, T.Operator,T.Value, @account_id) as a    
		WHERE T.Element in ('Date Added')    
	end    

	select @email_client_query_count = count(*) from #segments where element = 'Email Client'    
	select @signup_source_query_count = count(*) from #segments where element = 'Signup Source'  
	select @segment_query_count = count(*) from #segments where element in ('First Name', 'Last Name', 'Address', 'Phone Number', 'Tag Name', 'Birthday', 'Email Address', 'Location', 'Email Marketing Status', 'Churn Score', 
																			'Customer Type', 'Customer Subscriptions', 'Make', 'Model', 'Year', 'Trim', 'Engine', 'Fuel_Type', 'Customer Type', 'City', 'State', 'Zipcode', 'Miles Radius', 
																			'Daily Average Mileage', 'Vehicle Type', 'Email Optout', 'SMS Optout', 'Print Optout', 'Last Service Date', 'Visit Date', 'Last RO Mileage', 'Customer Pay Amount',
																			'Warranty Pay Amount','Internal Pay Amount','RO Total Amount','RO Close Date','Pay Type', 'Sale Date', 'Sale Type', 'Area Code', 'Status', 'Model Year', 
																			'Lead Status', 'Lead Source', 'Customer Status', 'Service Due Date', 'Opens', 'Delivered', 'ServiceVisit', 'Call Optout', 'WhatsApp Optout', 'ServiceAppointmentBooked',
																			'Estimated Mileage','Odometer','Distance by Dealership(miles)','Opcode','Maintenance Type','Air Bag','Air Filter','Ait Filter','Air Conditioning','Belt','Brake','Battery',
																			'Ball Joint','Body Repair','Cabin Air Filter', 'Cooling System','Drive Train','Electrical','Engine','Exhaust System','Fuel System','Intermediate Maintenance','Major Maintenance',
																			'Minor Maintenance','New Tires','Oil & Filter Change','Oil/Fluid Leak','Sensor','Spark Plugs','State Inspections','Steering','Suspension','Tire Rotation','Wheel Alignment',
																			'Wiper Blades','Last Visit Date, Warranty Due Date', 'When Service Visit', 'Campaign Activity', 'Date Added', 'List Name', 'SMS Delivered', 'Email Delivered', 'When Service Due')
	
	------------------------------------ Applying all the conditins on top the customer data ---------------------------------------
	Print 'Step 9 Applying all the conditins on top the customer data ' + Convert(varchar(50), getdate(), 108)

	if(@segment_query_count > 0 or @list_type_id = 3)    
	BEGIN    

	Print 'Step 10 ' + Convert(varchar(50), getdate(), 108)
		
		--select * from #segments

		if (Len(@result1) >= 0) set @result = @result1

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
				cu.do_not_email,   
				cu.do_not_mail,   
				cu.do_not_call,   
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
	SET @query = @query + (Case when @list_type_id = 2 and (select count(*) from #segments where element in ('Last RO Mileage', 'Customer Pay Amount','Warranty Pay Amount','Internal Pay Amount','RO Total Amount','RO Close Date','Pay Type')) > 0
		then   'trp.ro_number, 
				trp.ro_close_date, 
				trp.total_customer_pay, 
				trp.total_warranty_pay, 
				trp.total_internal_pay, 
				trp.total_ro_amount, 
				trp.pay_type,'
				else 
				'cu.ro_number, 
				cu.ro_close_date, 
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
	SET @query = @query + (Case when @list_type_id = 2 and (select count(*) from #segments where element in ('Sale Date', 'Sale Type')) > 0
		then   'ts.purchase_date,
				ts.nuo_flag,'
				else
				'cu.last_visit_date as purchase_date,
				cu.nuo_flag,'
				end)
	SET @query = @query + 
				'cu.cust_status,
				lead_status_id, 
				lead_source_id,
				parent_dealer_id,
				suffix,
				cust_title,
				next_service_date,
				is_email_delivered, is_sms_delivered, is_print_delivered, is_opened, ServiceVisit,
				cu.do_not_sms, cu.do_not_whatsapp, cu.is_service_booked, cu.is_valid_email, cu.is_valid_phone, cu.is_valid_address, cu.is_email_bounce,
				cu.is_fleet, cu.is_app_user, src_cust_updatedt
				from #temp cu with(nolock,readuncommitted) '
	SET @query = @query + (Case when (select count(*) from #segments where element in ('Campaign Activity')) > 0
		then   ' inner join #campaign_activity b on cu.customer_id = b.customer_id ' else '' end)
	SET @query = @query + (Case when (select count(*) from #segments where element in ('Date Added')) > 0
		then   ' inner join #date_added c on cu.customer_id = c.customer_id ' else '' end)
	SET @query = @query + (Case when @list_type_id = 2 and (select count(*) from #segments where element in ('Last RO Mileage', 'Customer Pay Amount','Warranty Pay Amount','Internal Pay Amount','RO Total Amount','RO Close Date','Pay Type')) > 0
		then   ' left outer join #tempro trp on cu.master_customer_id = trp.master_customer_id and cu.master_vehicle_id = trp.master_vehicle_id' else '' end)
	SET @query = @query + (Case when @list_type_id = 2 and (select	count(*) from #segments where element in ('Sale Date', 'Sale Type')) > 0
		then   ' left outer join #tempSales ts on cu.master_customer_id = ts.master_customer_id and cu.master_vehicle_id = ts.master_vehicle_id ' else '' end)
	SET @query = @query +  ' where 1 = 1 and '
	SET @query = @query + (case when (select count(*) from #segments where element in ('Email Optout', 'SMS Optout','Print Optout')) <= 0 then ' ((cu.is_valid_email = 1 and cu.do_not_email = 0 and cu.is_email_bounce = 0) or cu.do_not_mail = 0 or (cu.is_valid_phone = 1 and cu.do_not_sms = 0)) and ' else '' end) +
	--SET @query = @query +  ' ( '
	--					+ (case when (select count(*) from #segments where element = 'Email Optout') <= 0 then  ' do_not_email = 0 or' else '' end)
	--					+ (case when (select count(*) from #segments where element = 'SMS Optout') <= 0 then  ' do_not_sms = 0 or' else '' end)
	--					+ (case when (select count(*) from #segments where element = 'Print Optout') <= 0 then  ' do_not_mail = 0 or' else '' end) 
	--					+ (case when (select count(*) from #segments where element in ('Print Optout', 'SMS Optout', 'Print Optout')) <= 0 then  
	--					+ ' 1 = 1 ) and' +
				--where (' + (Case when Len(@result) > 0 then REPLACE(REPLACE(REPLACE(@result,'&#x0D;',''),'&lt;', '<'),'&gt;', '>') else '1 = 1' end) + ') and cu.is_deleted = 0 and cu.account_id=''' + convert(varchar(100), @account_id) + ''''    
				' cu.is_deleted = 0 and cu.account_id=''' + convert(varchar(100), @account_id) + '''' +
				' and (' + (Case when Len(@result) > 0 then REPLACE(REPLACE(REPLACE(@result,'&#x0D;',''),'&lt;', '<'),'&gt;', '>') else '1 = 1' end) + ')  '    
		
	print @query
	print @result

	  INSERT INTO #custTemp    
	  EXEC sp_executesql @query    
 
	END 

	------------------------------------ Preparing final customer data on to op the customer data -----------------
	Print 'Step 12 Preparing final customer data on to op the customer data ' + Convert(varchar(50), getdate(), 108)

	Declare @str nvarchar(max)    
	set @str =  'select a.[customer_id], a.customer_guid, a.[primary_email], a.[first_name], a.[middle_name], a.[last_name], a.[address_line], a.[primary_phone_number],' 
	set @str += ' a.[tags], a.do_not_email, a.do_not_mail, a.do_not_call, a.[created_dt], a.make, a.model, a.model_year, address1, address2, city, state, country, [zip_code], '
	set @str += ' a.master_customer_id, a.master_vehicle_id, a.vin, a.parent_dealer_id, suffix,cust_title, next_service_date, is_email_delivered, is_sms_delivered, '
	set @str += ' is_print_delivered, is_opened, last_ro_date, servicevisit, do_not_sms, do_not_whatsapp, [addresses], is_service_booked, is_valid_email, is_valid_phone, is_valid_address, '
	set @str += ' last_visit_date, is_email_bounce, is_fleet, ro_close_date, ro_number, is_app_user, src_cust_updatedt '
	set @str += ' from #custTemp a '    
      
	select @str += ' inner join #campaign_activity b on a.customer_id = b.customer_id' from #segments where Element = 'Campaign Activity'    
	select @str += ' inner join #date_added c on a.customer_id = c.customer_id' from #segments where Element = 'Date Added'    

	SELECT @result = SUBSTRING((SELECT ' ' + (case when Brackets = '(' then Brackets + query else '' + query end) +  (case when Brackets = ')' then Brackets else '' end) + ' ' + operator    
	FROM #queries    
	order by id    
	FOR XML PATH('')), 0, 9999)    
    
	set @str = @str + (Case when @result is not null then ' Where' + REPLACE(REPLACE(REPLACE(@result,'&#x0D;',''),'&lt;', '<'),'&gt;', '>') else '' end)  

	print 2    
	Print 'AAA'
	print @str  

	Insert into #cust_Temp    
	EXEC sp_executesql @str   


-----------Add SK Remove Duplicates
	drop table if exists #custTemp1
	select 
		*
		,row_number() over (partition by primary_phone_number,primary_email,vin,make,model,model_year	order by isnull(ro_close_date,last_visit_date) desc,customer_id desc) as rnk1 
		,row_number() over (partition by (case when (select count(*) from #segments where element in ('SMS Optout')) > 0 then primary_phone_number else null end),vin,make,model,model_year
																			order by isnull(ro_close_date,last_visit_date) desc,customer_id desc) as rnk2
		,row_number() over (partition by (case when (select count(*) from #segments where element in ('email Optout')) > 0 then primary_email else null end),vin,make,model,model_year
																			order by isnull(ro_close_date,last_visit_date) desc,customer_id desc) as rnk3
		into #custTemp1
	from #custTemp
	truncate table #cust_Temp
	insert into #cust_Temp 
	(
		customer_id,customer_guid,primary_email,first_name,middle_name,last_name,address_line,primary_phone_number,tags,do_not_email,do_not_mail,do_not_call,created_dt,make,model,model_year,address1
		,address2,city,state,country,zip_code,master_customer_id,master_vehicle_id,vin,parent_dealer_id,suffix,cust_title,next_service_date,is_email_delivered,is_sms_delivered,is_print_delivered
		,is_opened,last_ro_date,servicevisit,do_not_sms,do_not_whatsapp,addresses,is_service_booked,is_valid_email,is_valid_phone,is_valid_address,last_visit_date,is_email_bounce,is_fleet
		,ro_close_date,ro_number,is_app_user
	)
	select 
		customer_id,customer_guid,primary_email,first_name,middle_name,last_name,address_line,primary_phone_number,tags,do_not_email,do_not_mail,do_not_call,created_dt,make,model,model_year,address1
		,address2,city,state,country,zip_code,master_customer_id,master_vehicle_id,vin,parent_dealer_id,suffix,cust_title,next_service_date,is_email_delivered,is_sms_delivered,is_print_delivered
		,is_opened,last_ro_date,servicevisit,do_not_sms,do_not_whatsapp,addresses,is_service_booked,is_valid_email,is_valid_phone,is_valid_address,last_visit_date,is_email_bounce,is_fleet
		,ro_close_date,ro_number,is_app_user
	from #custTemp1 
	where rnk1 = 1 
			and iif((select count(*) from #segments where element in ('SMS Optout')) > 0,rnk2,1) = 1
			and iif((select count(*) from #segments where element in ('email Optout')) > 0,rnk3,1) = 1
-------------------Add SK*/


return;

select customer_id,primary_email,primary_phone_number,first_name,last_name,master_vehicle_id,vin,make,model,model_year,ro_close_date,last_visit_date 
from #cust_Temp --where primary_phone_number = '2539614474'
order by primary_phone_number,customer_id



select customer_id,first_name,last_name,primary_phone_number,primary_email,do_not_sms,do_not_email,vin, make,model,model_year,ro_close_date,purchase_date from #custTemp -- where primary_phone_number = '2539614474'
order by primary_phone_number



--select customer_id,first_name,last_name,primary_phone_number,primary_email,do_not_sms,do_not_email,rnk1,rnk2,rnk3,ro_close_date,purchase_date from #custTemp1 -- where primary_phone_number = '2539614474'
--order by primary_phone_number
------where rnk2 > 1 order by rnk2


--select * from #segments
select distinct
customer_id
from #temp cu with(nolock,readuncommitted)  where 1 = 1 and  ((cu.is_valid_email = 1 and cu.do_not_email = 0 and cu.is_email_bounce = 0) or cu.do_not_mail = 0 or (cu.is_valid_phone = 1 and cu.do_not_sms = 0)) 
and  cu.is_deleted = 0 and cu.account_id='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and (( (  (first_name like  '%a%') and  (make in ('HARLEY-DAVIDSON'))  )))  


select customer_id 
from #temp cu with(nolock,readuncommitted)  where 1 = 1 and  cu.is_deleted = 0 and cu.account_id='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
and (( (  (first_name like  '%JO%') and  (is_valid_phone = 1 and do_not_sms = '0')  )))  

select *
from #temp cu with(nolock,readuncommitted)  where 1 = 1 and  ((cu.is_valid_email = 1 and cu.do_not_email = 0 and cu.is_email_bounce = 0) or cu.do_not_mail = 0 or (cu.is_valid_phone = 1 and cu.do_not_sms = 0)) and  cu.is_deleted = 0 
and cu.account_id='aeacfc4e-fada-4fa1-a24d-eaced71020bb'  and (( (  (first_name like  '%a%') and  (make in ('HARLEY-DAVIDSON'))  )))  --select customer_id,primary_email,primary_phone_number,first_name,last_name,master_vehicle_id,vin,make,model,model_year,ro_close_date,last_visit_date from #custTemp1


	------------------------------------ Deleting data which doesn't have address/email/phone no ---------------------------------
	Print 'Step 13 Deleting data which doesn''t have address/email/phone no ' + Convert(varchar(50), getdate(), 108)

	if (@campaign_type like 'Print%')
	Begin
		delete from #cust_Temp where Len(address_Line) <= 0
	End
	else if (@campaign_type like 'Email%')
	Begin
		delete from #cust_Temp where Len(primary_email) <= 0
	End
	else if (@campaign_type like 'SMS%' or @campaign_type like 'PUSH%' or @campaign_type like 'EVENT%' or @campaign_type like 'PROMOTION%')
	Begin
		delete from #cust_Temp where Len(primary_phone_number) <= 0
	End


	------------------------------------ Returning Output data  ---------------------------------

	if (@campaign_type is null )
	Begin


		Print 'Step 15 Campaign Type NULL ' + Convert(varchar(50), getdate(), 108)


		--Print 'Campaign Type : ' + @campaign_type
		set @page_size = isnull(@page_size, 20) 

		select distinct customer_id, master_vehicle_id, do_not_email, do_not_mail, do_not_call, do_not_sms, do_not_whatsapp, is_email_bounce
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

		Print 'Step 15.1 ' + Convert(varchar(50), getdate(), 108)


		select 
			  @total_count = count(customer_id)
			, @email_optin = Sum(Case when do_not_email in('0', 'No') and is_email_bounce = 0 then 1 else 0 end)
			, @mail_optin = Sum(Case when do_not_mail in('0', 'No') then 1 else 0 end)
			, @phone_optin = Sum(Case when do_not_sms in('0', 'No') then 1 else 0 end)
		from #temp_count

		Print 'Step 15.1 ' + Convert(varchar(50), getdate(), 108)

		Print 'Total Customers : ' + Cast(isnull(@total_count, 0) as varchar(50))
		Print 'Email Optins : ' + Cast(Isnull(@email_optin, 0) as varchar(50))
		Print 'Mail Optins : ' +  Cast(Isnull(@mail_optin, 0) as varchar(50))
		Print 'Call Optins : ' +  Cast(Isnull(@phone_optin, 0) as varchar(50))
	
		Print 'Step 15.3 ' + Convert(varchar(50), getdate(), 108)

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
				, do_not_sms
				, do_not_whatsapp
				, created_dt    
				, Isnull(@total_count, 0) as total_count   
				, Isnull(@email_optin, 0) as email_optin_count
				, Isnull(@mail_optin, 0) as mail_optin_count
				, Isnull(@phone_optin, 0) as phone_optin_count
				, master_vehicle_id
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
			CASE WHEN (@sort_column = 'CreatedDate' AND @sort_order='DESC') THEN created_dt END DESC,          
			case when (@sort_column = 'OptOut' AND @sort_order='asc') then do_not_email end asc, 
			case when (@sort_column = 'OptOut' AND @sort_order='desc') then do_not_email end desc,
			case when (@sort_column = 'SmsOptOut' AND @sort_order='asc') then do_not_sms end asc, 
			case when (@sort_column = 'SmsOptOut' AND @sort_order='desc') then do_not_sms end desc 

		OFFSET ((isnull(@page_no,1) - 1) * @page_size) rows fetch next @page_size rows only  
	
		Print 'Step 15.4 ' + Convert(varchar(50), getdate(), 108)

	End
	
	else if (@campaign_type in ('Print', 'Email', 'SMS', 'PUSH', 'EVENT', 'PROMOTION' ))
	Begin
		---------------------------------------- Coupons ----------------------------------------------------------------------------------------------
		Print 'Step 16 Campaign Type : ' + @campaign_type + ' ' + Convert(varchar(50), getdate(), 108)

		--select * from #cust_Temp
		select 
			a.*, 
			0 as is_processed 
		into 
			#temp_coupon_query
		from 
			[print].coupons a (nolock) 
		inner join campaign.media_type b (nolock) on
			a.media_type_id = b.media_type_id
		where 
			a.campaign_id = @campaign_id 
			and a.is_deleted = 0
			and b.is_deleted = 0
			and Len(a.conditions_query) > 0
			and b.media_type = @campaign_type
		order by position_id, priority_id

		Print 'Step 16.1 ' + Convert(varchar(50), getdate(), 108)

		select distinct * into #cust_distinct_Temp from #cust_Temp

		Print 'Step 16.2 ' + Convert(varchar(50), getdate(), 108)
		
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
			select *, 'Coupon Json' from  [customer].[get_segment_conditions_new1](@segmant_query, @is_parent_campaign)
			
			SELECT @result = SUBSTRING((SELECT ' ' + (case when Brackets = '(' then Brackets + query else '' + query end) +  (case when Brackets = ')' then Brackets else '' end) + ' ' + operator    
			FROM #queries    
			order by id    
			FOR XML PATH('')), 0, 9999)    

			set @result = (Case when reverse(substring(reverse(@result), 1, 4)) like '%or%' or substring(reverse(@result), 1, 4) like '%and%' then substring(@result, 1, (Len(@result) -  charindex(' ', reverse(@result), 1))) else @result end) 
			
			set @sql = ''
			set @sql = 'Select distinct customer_id, master_customer_id, vin, [addresses],' + Cast(@print_coupon_id as varchar(25)) + ' as print_coupon_id, ' + Cast(@priority as varchar(25)) + ' as priority_id, ' + Cast(@position_id as varchar(25)) + ' as priority_id, ' + Cast(@is_default as varchar(25)) + ' as is_default from #cust_distinct_Temp where ' + @result

			--Print '----------------------------------------------------'
			--print @print_coupon_id
			--print @sql

			INSERT INTO #cust_coupon(customer_id, master_customer_id, vin, [addresses], print_coupon_id, priority_id, position_id, is_default)
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

		Print 'Step 16.3 Coupon While Loop Completed ' + Convert(varchar(50), getdate(), 108)

		---------------------------------------- Coupons ----------------------------------------------------------------------------------------------
		---------------------------------------- Images ----------------------------------------------------------------------------------------------
		
		set @segmant_query = ''
		set @print_coupon_id = 0
		set @position_id = 0
		set @coupon_id = 0

		Print 'Step 16.4 Images Process Started ' + Convert(varchar(50), getdate(), 108)

		select 
			a.*, 
			0 as is_processed 
		into 
			#temp_Images_query
		from 
			[print].images a (nolock) 
		inner join campaign.media_type b (nolock) on
			a.media_type_id = b.media_type_id
		where 
			a.campaign_id = @campaign_id 
			and a.is_deleted = 0
			and b.is_deleted = 0
			and Len(a.conditions_query) > 0
			and b.media_type = @campaign_type
		order by position_id, priority_id

		Print 'Step 16.5 ' + Convert(varchar(50), getdate(), 108)

		-- Updating Images
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
			select *, 'Image Json' from  [customer].[get_segment_conditions_new1](@segmant_query, @is_parent_campaign)

			SELECT @result = SUBSTRING((SELECT ' ' + (case when Brackets = '(' then Brackets + query else '' + query end) +  (case when Brackets = ')' then Brackets else '' end) + ' ' + operator    
			FROM #queries    
			order by id    
			FOR XML PATH('')), 0, 9999)    

			set @result = (Case when reverse(substring(reverse(@result), 1, 4)) like '%or%' or substring(reverse(@result), 1, 4) like '%and%' then substring(@result, 1, (Len(@result) -  charindex(' ', reverse(@result), 1))) else @result end) 
			
			set @sql = ''

			set @sql = 'Select distinct customer_id, master_customer_id, vin, [addresses], ' + Cast(@print_coupon_id as varchar(25)) + ' as print_coupon_id, ' + Cast(@priority as varchar(25)) + ' as priority_id, ' + Cast(@position_id as varchar(25)) + ' as priority_id, ' + Cast(@is_default as varchar(25)) + ' as is_default from #cust_distinct_Temp where ' + @result

			print @sql

			INSERT INTO #cust_images(customer_id, master_customer_id, vin, [addresses], print_image_id, priority_id, position_id, is_default)
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
		
		Print 'Step 16.6 Images While Loop Completed ' + Convert(varchar(50), getdate(), 108)

		---------------------------------------- Images ----------------------------------------------------------------------------------------------
		---------------------------------------- Text ----------------------------------------------------------------------------------------------

		Print 'Step 16.7 Images Process Started ' + Convert(varchar(50), getdate(), 108)

		select 
			a.*, 
			0 as is_processed 
		into 
			#temp_text_query
		from 
			[print].texts a (nolock) 
		inner join campaign.media_type b (nolock) on
			a.media_type_id = b.media_type_id
		where 
			a.campaign_id = @campaign_id 
			and a.is_deleted = 0
			and b.is_deleted = 0
			and Len(a.conditions_query) > 0
			and b.media_type = @campaign_type
		order by position_id, priority_id

		Print 'Step 16.8 ' + Convert(varchar(50), getdate(), 108)

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
			select *, 'Text Json' from  [customer].[get_segment_conditions_new1](@segmant_query, @is_parent_campaign)

			SELECT @result = SUBSTRING((SELECT ' ' + (case when Brackets = '(' then Brackets + query else '' + query end) +  (case when Brackets = ')' then Brackets else '' end) + ' ' + operator    
			FROM #queries    
			order by id    
			FOR XML PATH('')), 0, 9999)    

			set @result = (Case when reverse(substring(reverse(@result), 1, 4)) like '%or%' or substring(reverse(@result), 1, 4) like '%and%' then substring(@result, 1, (Len(@result) -  charindex(' ', reverse(@result), 1))) else @result end) 
			
			set @sql = ''
			set @sql = 'Select distinct customer_id, master_customer_id, vin, [addresses], ' + Cast(@print_coupon_id as varchar(25)) + ' as print_text_id, ' + Cast(@priority as varchar(25)) + ' as priority_id, ' + Cast(@position_id as varchar(25)) + ' as priority_id, ' + Cast(@is_default as varchar(25)) + ' as is_default from #cust_distinct_Temp where ' + @result

			INSERT INTO #cust_text(customer_id, master_customer_id, vin, [addresses], print_text_id, priority_id, position_id, is_default)
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

		Print 'Step 16.9 Text While Loop Completed ' + Convert(varchar(50), getdate(), 108)

		---------------------------------------- Text ----------------------------------------------------------------------------------------------

		Update a set a.rnk = b.rnk1
		from #cust_coupon a
		inner join 
		(
			select *, rank() over (partition by master_customer_id order by priority_id asc ) as rnk1 from #cust_coupon 
		) as b 
			on a.id = b.id

		Print 'Step 16.10 ' + Convert(varchar(50), getdate(), 108)

		select distinct
			a.customer_id as customer_number,  
			isnull(nullif(ltrim(rtrim(first_name)),''),'') as first_name ,    
			isnull(nullif(ltrim(rtrim(last_name)),''),'') as last_name, 
			isnull(nullif(ltrim(rtrim(middle_name)),''),'') as middle_name, 
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
			a.parent_dealer_id,
			a.last_ro_date,
			do_not_email,
			do_not_mail,
			do_not_call,
			do_not_sms,
			do_not_whatsapp,
			is_app_user
		into #final_print_result
		from #cust_Temp a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id

		Print 'Step 16.11 ' + Convert(varchar(50), getdate(), 108)


		---- Updating default Coupon html
		update a set a.coupon1 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 1 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.coupon1) <= 0

		update a set a.coupon2 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 2 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.coupon2) <= 0

		update a set a.coupon3 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 3 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.coupon3) <= 0

		update a set a.coupon4 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 4 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.coupon4) <= 0
	
		update a set a.coupon5 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 5 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.coupon5) <= 0

		update a set a.coupon6 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 6 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.coupon6) <= 0

		update a set a.coupon7 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 7 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.coupon7) <= 0

		update a set a.coupon8 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 8 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.coupon8) <= 0

		update a set a.coupon9 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 9 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.coupon9) <= 0

		update a set a.coupon10 = Isnull(Replace(Replace(isnull((select coupon_html from #temp_coupon_query where position_id = 10 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.coupon10) <= 0

		Print 'Step 16.12 ' + Convert(varchar(50), getdate(), 108)

		---- Updating default Image Url
		update a set a.image1 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 1 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.image1) <= 0

		update a set a.image2 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 2 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.image2) <= 0

		update a set a.image3 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 3 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.image3) <= 0

		update a set a.image4 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 4 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.image4) <= 0

		update a set a.image5 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 5 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.image5) <= 0

		update a set a.image6 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 6 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.image6) <= 0

		update a set a.image7 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 7 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.image7) <= 0

		update a set a.image8 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 8 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.image8) <= 0

		update a set a.image9 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 9 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.image9) <= 0

		update a set a.image10 = Isnull(Replace(Replace(isnull((select image_url from #temp_Images_query where position_id = 10 and is_default = 1),''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.image10) <= 0

		Print 'Step 16.13 ' + Convert(varchar(50), getdate(), 108)

		---- Updating default Text
		update a set a.text1 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 1 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.text1) <= 0

		update a set a.text2 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 2 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.text2) <= 0

		update a set a.text3 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 3 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.text3) <= 0

		update a set a.text4 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 4 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.text4) <= 0
	
		update a set a.text5 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 5 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.text5) <= 0

		update a set a.text6 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 6 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.text6) <= 0

		update a set a.text7 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 7 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.text7) <= 0

		update a set a.text8 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 8 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.text8) <= 0

		update a set a.text9 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 9 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.text9) <= 0

		update a set a.text10 = Isnull(Replace(Replace(isnull((select text_desc from #temp_text_query where position_id = 10 and is_default = 1), ''), '{Make}', make), '{SvcDealerName}', d.accountname), '')
		from #final_print_result a
		inner join #temp_dealer d on a.parent_dealer_id = d.account_id
		where Len(a.text10) <= 0

		Print 'Step 16.14 ' + Convert(varchar(50), getdate(), 108)

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

		Print 'Step 16.17 ' + Convert(varchar(50), getdate(), 108)

		if (@campaign_type in ('Print'))
		Begin

			Print 'Step 16.18 ' + Convert(varchar(50), getdate(), 108)
		
			--Insert into [print].campaign_items 
			--(
			--	list_member_id, email_address, first_name, last_name, [address], city, [state], zip_code, phone, salutation,
			--	vin, make, model, [year], is_sent, is_deleted, campaign_id, 
			--	coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10,
			--	image1, image2, image3, image4, image5, image6, image7, image8, image9, image10,
			--	text1, text2, text3, text4, text5, text6, text7, text8, text9, text10,
			--	run_id, flow_id
			--)					
			select 
				master_customer_id, email, first_name, last_name, address_line, city, state, zip, phone_number, title,
				vin, make, model, model_year, 0 as is_sent, 0 as is_deleted, @campaign_id as campaign_id, 
				coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10,
				image1, image2, image3, image4, image5, image6, image7, image8, image9, image10 ,
				text1, text2, text3, text4, text5, text6, text7, text8, text9, text10,
				@campaign_run_id, Isnull(@flow_id, 0) as flow_id
			from #final_print_result a
			where a.do_not_mail = 0
			--left outer join auto_campaigns.[print].campaign_items b (nolock) on a.campaign_id = b.campaign_id and a.master_customer_id = b.list_member_id
			--where b.campaign_item_id is null

		end
		else if (@campaign_type in ('Email'))
		Begin

			Print 'Step 16.19 ' + Convert(varchar(50), getdate(), 108)

			Begin try
				set @campaign_type_id = (select
											campaign_type_id
										from
											email.campaigns with(nolock,readuncommitted)
										where
											campaign_id = @campaign_id)

					declare @is_negative_email_campaign int = (select count(*) from auto_campaigns.email.campaigns with(nolock,readuncommitted) where 
																	campaign_id = @campaign_id and is_deleted=0 and [name] like 'negative%')  --KS

				--Insert into auto_campaigns.[email].campaign_items 
				--(
				--	campaign_id, list_member_id, email_address, first_name, last_name, [address], city, [state], zip_code, phone, salutation,
				--	vin, make, model, [year], is_sent, is_deleted, 
				--	coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7, coupon8, coupon9, coupon10,
				--	image1, image2, image3, image4, image5, image6, image7, image8, image9, image10,
				--	text1, text2, text3, text4, text5, text6, text7, text8, text9, text10,
				--	last_service_date, campaign_run_id, flow_id, list_type_id
				--	)	
--output clause
				select distinct
					@campaign_id as campaing_id, master_customer_id, email, a.first_name, a.last_name, a.address_line, a.city, a.state, a.zip, a.phone_number, a.title,
					a.vin, a.make, a.model, a.model_year, 0 as is_sent, 0 as is_deleted, 
					a.coupon1, a.coupon2, a.coupon3, a.coupon4, a.coupon5, a.coupon6, a.coupon7, a.coupon8, a.coupon9, a.coupon10,
					a.image1, a.image2, a.image3, a.image4, a.image5, a.image6, a.image7, a.image8, a.image9, a.image10 ,
					a.text1, a.text2, a.text3, a.text4, a.text5, a.text6, a.text7, a.text8, a.text9, a.text10,
					cast(Cast(a.last_ro_date as varchar(10)) as date), @campaign_run_id, Isnull(@flow_id, 0), @list_type_id
				from #final_print_result a
				left outer join auto_campaigns.email.campaign_items b (nolock) on 
					a.master_customer_id = b.list_member_id
					and b.campaign_id = @campaign_id
					and Isnull(a.vin, '') = Isnull(b.vin, '')
					and b.is_deleted = 0
				where b.campaign_item_id is null 
				and isnull(a.do_not_email,3) = (case when @is_negative_email_campaign >=1 then 3 else 0 end) --ks

				if (@is_negative_email_campaign >=1)  --ks 
				begin
						declare @all_email_list int = (select top 1 list_id from auto_customers.list.lists (nolock) where is_deleted =0 and account_id =@account_id and is_default =1 and list_name = 'All Email Subscribers')
						update auto_customers.customer.customers 
						set do_not_email=0, list_ids = concat(list_ids, @all_email_list ,',') where 
						is_deleted =0 and account_id = @account_id 
						and do_not_email is null 
						and	customer_id in (
						select list_member_id from auto_campaigns.[email].campaign_items where is_deleted =0 and campaign_id = @campaign_id and campaign_run_id = @campaign_run_id
						)
				end
			
				if(@campaign_type_id = 1)
			begin

				update 
					email.campaigns
				set
					status_type_id = 6
				where
					campaign_id = @campaign_id
			end 

				--RAISERROR ('Error invoked in the TRY code block.',16,1 );
			End try
			BEGIN catch
				DECLARE @ErrorMsg NVARCHAR(4000); 
				DECLARE @ErrSeverity INT; 
				DECLARE @ErrState INT; 

				set @ErrorMsg = Error_message() 
				set @ErrSeverity = Error_severity() 
				set @ErrState = Error_state()

				Insert into dbo.error_segment (ErrorMsg, ErrSeverity, ErrState) values (@ErrorMsg, @ErrSeverity, @ErrState)

				RAISERROR (@ErrorMsg,
						   @ErrSeverity,
						   @ErrState 
						); 
			End Catch
		end
		else if (@campaign_type in ('SMS'))
		Begin

			Print 'Step 16.20 ' + Convert(varchar(50), getdate(), 108)
			
			declare @is_negative_sms_campaign int = (select count(*) from auto_campaigns.sms.campaigns with(nolock,readuncommitted) where 
																	campaign_id = @campaign_id and is_deleted=0 and [name] like 'negative%')  --KS
			--Insert into [sms].campaign_items 
			--(
			--	campaign_id, list_member_id, phone_number, first_name, middle_name, last_name, salutation, [address], city, [state], zip_code, phone,
			--	vin, make, model, [year], last_service_date, is_sent, is_deleted, flow_id, campaign_run_id, list_type_id, title, email
			--	)					
			select distinct
				@campaign_id as campaing_id, master_customer_id, a.phone_number, a.first_name, a.middle_name, a.last_name, a.title, address_line, a.city, a.[state], a.zip, a.phone_number, 
				a.vin, a.make, a.model, model_year, cast(Cast(last_ro_date as varchar(10)) as date), 0 as is_sent, 
				0 as is_deleted, Isnull(@flow_id, 0), @campaign_run_id, @list_type_id, a.title, a.email
			from #final_print_result a
			left outer join [sms].campaign_items b (nolock) on 
				a.master_customer_id = b.list_member_id
				and Isnull(a.vin, '') = Isnull(b.vin, '')
				and b.campaign_id = @campaign_id
				and b.is_deleted = 0
			where b.campaign_item_id is null 
			and isnull(a.do_not_sms,3) = (case when @is_negative_sms_campaign >=1 then 3 else 0 end) --ks
			
			if (@is_negative_sms_campaign >= 1)  --ks 
			begin
					--updating list_ids and sms optins
					declare @all_sms_list int = (select top 1 list_id from auto_customers.list.lists (nolock) where is_deleted =0 and account_id =@account_id and is_default =1 and list_name = 'All SMS Subscribers')
					update auto_customers.customer.customers 
							set do_not_sms = 0, list_ids = concat(list_ids, @all_sms_list ,',') where 
							is_deleted = 0 and account_id = @account_id 
							and do_not_sms is null 
							and	customer_id in (
						select list_member_id from auto_campaigns.[sms].campaign_items where is_deleted =0 and campaign_id = @campaign_id and campaign_run_id = @campaign_run_id
						)
			end
			

			set @sms_campaign_items_count = (select count(*) from #final_print_result a
												left outer join [sms].campaign_items b (nolock) on 
													a.master_customer_id = b.list_member_id
													and Isnull(a.vin, '') = Isnull(b.vin, '')
													and b.campaign_id = @campaign_id
													and b.is_deleted = 0
												where b.campaign_item_id is null 
												and a.do_not_sms = 0)

			if(@sms_campaign_items_count = 0)
			begin
				update sms.campaigns
				set
					status_type_id = 6
				where
					campaign_id = @campaign_id
			end

		End
		else if (@campaign_type in ('PUSH', 'EVENT', 'PROMOTION'))
		begin
			Print 'Step 16.21 ' + Convert(varchar(50), getdate(), 108) + ' ' + @campaign_type
			
			--Insert into [push].campaign_items 
			--(
			--	campaign_id, list_member_id, phone_number, first_name, last_name, salutation, [address], city, [state], zip_code, phone,
			--	vin, make, model, [year], last_service_date, is_sent, is_deleted, campaign_run_id, list_type_id, campaign_type
			--)	
			select distinct
				@campaign_id as campaing_id, master_customer_id, a.phone_number, a.first_name, a.last_name, a.title, address_line, a.city, a.[state], a.zip, a.phone_number, 
				a.vin, a.make, a.model, model_year, cast(Cast(last_ro_date as varchar(10)) as date), 0 as is_sent, 
				0 as is_deleted, @campaign_run_id, @list_type_id, @campaign_type
			from #final_print_result a
			left outer join [sms].campaign_items b (nolock) on 
				a.master_customer_id = b.list_member_id
				and Isnull(a.vin, '') = Isnull(b.vin, '')
				and b.campaign_id = @campaign_id
				and b.is_deleted = 0
			where b.campaign_item_id is null 
			and a.is_app_user = 1
		end

		Print 'Step 16.18 ' + Convert(varchar(50), getdate(), 108)

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
			
		/* -------------- Text */
			,text1, text2, text3, text4, text5, text6, text7, text8, text9, text10
	
		, master_customer_id 
		, suffix 
		, title 
		, parent_dealer_id 
		, '31545430' as agreement_number
		,'SEB' as plan_code
		,'12-01-2025' as agreement_expiration_date
		,'LEXUS FINANCIAL SERVICES' as lien_holder
		,'JTHY3JBH0K2020466' as vin
		, '49555' as agreement_expiration_mileage
		,'12-01-2021' as agreement_effective_date
		, 5 as service_interval
		,'Mickey Abbott' as agreement_holder		
		,'RAPP LEXUS' as selling_dealer
		,2250 as agreement_purchase_price
		, '' as body_copy1
		, '31564982' as agreement_number1
		, '12-01-2026' as agreement_expiration1
		, 'NA' as job_number
		, 'NA' as consecutive_number
		, 'Mickey Abbott' as letter_signature_name
		, 'MR' as letter_signature_title
		, 'NA' as contract_number
        , '12-01-2025' as expiration_date
		, 'MR' as dealer_program_title
		,'I00026634' as imb_bar_code
		,'OilPlan' as oil_plan
		,'True' as road_side_assistance
		 ,'True' as dealer_group
		,'' as program_name
		, Reverse(Substring(Reverse(vin), 1, 8)) as VINLast8
		, (select top 1 coupon_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin) as coupon_count
		, (select top 1 image_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin) as Image_count
		, (select top 1 text_count from #temp_coupon_counts b where a.master_customer_id = b.master_customer_id and a.vin = b.vin) as text_count
		,case when master_customer_id % 6 = 0 and @segment_id = 5370 then 'LLC' 
			when master_customer_id % 6 = 1 and @segment_id = 5370 then 'LLC' 
			when master_customer_id % 6 = 2 and @segment_id = 5370 then 'LLC'
			when master_customer_id % 6 = 3 and @segment_id = 5370 then 'LLCC'
			when master_customer_id % 6 = 4 and @segment_id = 5370 then 'LMS'
			when master_customer_id % 6 = 5 and @segment_id = 5370 then 'LMS'

			when master_customer_id % 6 = 0 and @segment_id = 5403 then 'Auto Care' 
			when master_customer_id % 6 = 1 and @segment_id = 5403 then 'Dealer Program RSA 25 Miles' 
			when master_customer_id % 6 = 2 and @segment_id = 5403 then 'Dealer Program RSA 400 Miles'
			when master_customer_id % 6 = 3 and @segment_id = 5403 then 'Dealer Program'
			when master_customer_id % 6 = 4 and @segment_id = 5403 then 'Auto Care RSA 25 Miles'
			when master_customer_id % 6 = 5 and @segment_id = 5403 then 'Auto Care RSA 400 Miles'

			when master_customer_id % 6 = 0 and @segment_id = 5404 then 'Gold' 
			when master_customer_id % 6 = 1 and @segment_id = 5404 then 'Platinum' 
			when master_customer_id % 6 = 2 and @segment_id = 5404 then 'Gold'
			when master_customer_id % 6 = 3 and @segment_id = 5404 then 'Platinum'
			when master_customer_id % 6 = 4 and @segment_id = 5404 then 'Gold'
			when master_customer_id % 6 = 5 and @segment_id = 5404 then 'Platinum'

			when master_customer_id % 6 = 0 and @segment_id = 5405 then 'Care' 
			when master_customer_id % 6 = 1 and @segment_id = 5405 then 'Classic' 
			when master_customer_id % 6 = 2 and @segment_id = 5405 then 'Premium'
			when master_customer_id % 6 = 3 and @segment_id = 5405 then 'Care Plus'
			when master_customer_id % 6 = 4 and @segment_id = 5405 then 'Mirai'
			when master_customer_id % 6 = 5 and @segment_id = 5405 then 'Service Care'


			when master_customer_id % 6 = 0 and @segment_id = 5422 then 'Reminder1' 
			when master_customer_id % 6 = 1 and @segment_id = 5422 then 'Reminder2' 
			when master_customer_id % 6 = 2 and @segment_id = 5422 then 'Reminder3'
			when master_customer_id % 6 = 3 and @segment_id = 5422 then 'Reminder1'
			when master_customer_id % 6 = 4 and @segment_id = 5422 then 'Reminder2'
			when master_customer_id % 6 = 5 and @segment_id = 5422 then 'Reminder3'

			when master_customer_id % 6 = 0 and @segment_id = 5423 then 'Reminder1' 
			when master_customer_id % 6 = 1 and @segment_id = 5423 then 'Reminder2' 
			when master_customer_id % 6 = 2 and @segment_id = 5423 then 'Reminder3'
			when master_customer_id % 6 = 3 and @segment_id = 5423 then 'Reminder1'
			when master_customer_id % 6 = 4 and @segment_id = 5423 then 'Reminder2'
			when master_customer_id % 6 = 5 and @segment_id = 5423 then 'Reminder3'

			when master_customer_id % 6 = 0 and @segment_id = 5424 then 'Reminder1' 
			when master_customer_id % 6 = 1 and @segment_id = 5424 then 'Dealer Program Reminder1' 
			when master_customer_id % 6 = 2 and @segment_id = 5424 then 'Reminder2'
			when master_customer_id % 6 = 3 and @segment_id = 5424 then 'Dealer Program Reminder2'
			when master_customer_id % 6 = 4 and @segment_id = 5424 then 'Reminder3'
			when master_customer_id % 6 = 5 and @segment_id = 5424 then 'Dealer Program Reminder3'

			when master_customer_id % 6 = 0 and @segment_id = 5425 then 'Reminder1' 
			when master_customer_id % 6 = 1 and @segment_id = 5425 then 'Reminder2' 
			when master_customer_id % 6 = 2 and @segment_id = 5425 then 'Reminder3'
			when master_customer_id % 6 = 3 and @segment_id = 5425 then 'Reminder1'
			when master_customer_id % 6 = 4 and @segment_id = 5425 then 'Reminder2'
			when master_customer_id % 6 = 5 and @segment_id = 5425 then 'Reminder3'
			else 'LMS' end as plan_program_version

		,case when master_customer_id % 6 = 0 and @segment_id = 5370 then 'Classic' 
			when master_customer_id % 6 = 1 and @segment_id = 5370 then 'Premium' 
			when master_customer_id % 6 = 2 and @segment_id = 5370 then 'LLC'
			when master_customer_id % 6 = 3 and @segment_id = 5370 then 'LLC'
			when master_customer_id % 6 = 4 and @segment_id = 5370 then 'SS1'
			when master_customer_id % 6 = 5 and @segment_id = 5370 then 'SS2'

			when master_customer_id % 6 = 0 and @segment_id = 5403 then 'AC' 
			when master_customer_id % 6 = 1 and @segment_id = 5403 then 'AC' 
			when master_customer_id % 6 = 2 and @segment_id = 5403 then 'AC'
			when master_customer_id % 6 = 3 and @segment_id = 5403 then 'AC'
			when master_customer_id % 6 = 4 and @segment_id = 5403 then 'AC'
			when master_customer_id % 6 = 5 and @segment_id = 5403 then 'AC'

			when master_customer_id % 6 = 0 and @segment_id = 5404 then 'PPM' 
			when master_customer_id % 6 = 1 and @segment_id = 5404 then 'PPM' 
			when master_customer_id % 6 = 2 and @segment_id = 5404 then 'PPM'
			when master_customer_id % 6 = 3 and @segment_id = 5404 then 'PPM'
			when master_customer_id % 6 = 4 and @segment_id = 5404 then 'PPM'
			when master_customer_id % 6 = 5 and @segment_id = 5404 then 'PPM'

			when master_customer_id % 6 = 0 and @segment_id = 5405 then 'TAC' 
			when master_customer_id % 6 = 1 and @segment_id = 5405 then 'TAC' 
			when master_customer_id % 6 = 2 and @segment_id = 5405 then 'TAC'
			when master_customer_id % 6 = 3 and @segment_id = 5405 then 'TCP'
			when master_customer_id % 6 = 4 and @segment_id = 5405 then 'TCP'
			when master_customer_id % 6 = 5 and @segment_id = 5405 then 'TSC'

            when master_customer_id % 6 = 0 and @segment_id = 5422 then 'MPP Gold' 
			when master_customer_id % 6 = 1 and @segment_id = 5422 then 'MPP Gold' 
			when master_customer_id % 6 = 2 and @segment_id = 5422 then 'MPP Gold'
			when master_customer_id % 6 = 3 and @segment_id = 5422 then 'MPP Platinum'
			when master_customer_id % 6 = 4 and @segment_id = 5422 then 'MPP Platinum'
			when master_customer_id % 6 = 5 and @segment_id = 5422 then 'MPP Platinum'

			 when master_customer_id % 6 = 0 and @segment_id = 5423 then 'TAC' 
			when master_customer_id % 6 = 1 and @segment_id = 5423 then 'TAC' 
			when master_customer_id % 6 = 2 and @segment_id = 5423 then 'TAC'
			when master_customer_id % 6 = 3 and @segment_id = 5423 then 'TCP'
			when master_customer_id % 6 = 4 and @segment_id = 5423 then 'TCP'
			when master_customer_id % 6 = 5 and @segment_id = 5423 then 'TSC'

			 when master_customer_id % 6 = 0 and @segment_id = 5424 then 'AC' 
			when master_customer_id % 6 = 1 and @segment_id = 5424 then 'AC' 
			when master_customer_id % 6 = 2 and @segment_id = 5424 then 'AC'
			when master_customer_id % 6 = 3 and @segment_id = 5424 then 'AC'
			when master_customer_id % 6 = 4 and @segment_id = 5424 then 'AC'
			when master_customer_id % 6 = 5 and @segment_id = 5424 then 'AC'

			 when master_customer_id % 6 = 0 and @segment_id = 5425 then 'LLC' 
			when master_customer_id % 6 = 1 and @segment_id = 5425 then 'LLC' 
			when master_customer_id % 6 = 2 and @segment_id = 5425 then 'LLCC'
			when master_customer_id % 6 = 3 and @segment_id = 5425 then 'LLCC'
			when master_customer_id % 6 = 4 and @segment_id = 5425 then 'LMS'
			when master_customer_id % 6 = 5 and @segment_id = 5425 then 'LMS'
			else 'SS2' end as plan_type
		from #final_print_result a
		where 
			(@campaign_type = 'Email' and do_not_email = 0) Or (@campaign_type = 'SMS' and do_not_sms = 0) Or (@campaign_type = 'Print' and do_not_mail = 0) 
			or (@is_negative_sms_campaign >=1 or @is_negative_email_campaign >=1)

		Print 'Step 16.19 ' + Convert(varchar(50), getdate(), 108)

	End
	else if (@campaign_type = 'Download' )
	Begin

		Print 'Campaign Type : ' + @campaign_type

		set @page_size = isnull(@page_size, 20) 
		
		--Declare @email_optin int
		--		,@mail_optin int
		--		,@phone_optin int
		Print 'Reached here download'
		select distinct customer_id, vin, do_not_email, do_not_mail, do_not_call, do_not_sms, do_not_whatsapp, is_email_bounce
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
			  @total_count = count(customer_id)
			--, @email_optin = Sum(Case when do_not_email in('0', 'No') then 1 else 0 end)
			, @email_optin = Sum(Case when do_not_email in('0', 'No') and is_email_bounce = 0 then 1 when @is_negative_email_campaign>=1 and do_not_email is null then 1 else 0 end)  --ks
			, @mail_optin = Sum(Case when do_not_mail in('0', 'No') then 1 else 0 end)
			, @phone_optin = Sum(Case when do_not_sms in('0', 'No') then 1 when @is_negative_sms_campaign >=1 and do_not_sms is null then 1 else 0 end) --ks
		from #temp_count_download

		Print 'Total Customers : ' + Cast(isnull(@total_count, 0) as varchar(50))
		Print 'Email Optins : ' + Cast(Isnull(@email_optin, 0) as varchar(50))
		Print 'Mail Optins : ' +  Cast(Isnull(@mail_optin, 0) as varchar(50))
		Print 'Call Optins : ' +  Cast(Isnull(@phone_optin, 0) as varchar(50))
		 
		if(@verticalid = '3') 
		begin
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
					, city
					, [state]
					, [zip_code]
					, primary_phone_number
					, '' as secondary_phone_number
					, tags
					, do_not_email
					, do_not_mail
					, do_not_call
					, do_not_sms
					, do_not_whatsapp
					, created_dt    
					, Isnull(@total_count, 0) as total_count   
					, Isnull(@email_optin, 0) as email_optin_count
					, Isnull(@mail_optin, 0) as mail_optin_count
					, Isnull(@phone_optin, 0) as phone_optin_count
					, is_fleet 
					, ro_number
					,is_app_user
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
					@dealer_name as [DealerName],
					first_name as [First Name],
					middle_name as [Middle Name],
					last_name  as [Last Name],
					first_name + ' ' + middle_name + ' ' + last_name as [FullName],
					address_line as [Addreess1],
					'' as [Address2],
					city as [City],
					[state] as [State],
					[zip_code] as [ZipCode],
					'' as MileRadius,
					primary_email as [EmailAddress],
					primary_phone_number  as [MobilePhone],
					'' as WorkPhone,
					secondary_phone_number as [HomePhone], 
					'' as EstimatedMiles,
					is_fleet as IsFleet, 
					ro_number as RoNumber,
					'' as TotalRoAmount,
					'' as CustomerPay,
					'' as WarrantyPay,
					(case when  (do_not_email is null) then 'Do not know' 
						when (do_not_email = 1) then 'Opt-out'  when (do_not_email = 0) then 'Opt-In'  end) as [Email Preference],
					(case when  (do_not_sms is null) then 'Do not know' 
							when (do_not_sms = 1) then 'Opt-out'  when (do_not_sms = 0) then 'Opt-In'  end) as [SMS Preference],
					(case when  (do_not_mail is null) then 'Do not know' 
					when (do_not_mail = 1) then 'Opt-out'  when (do_not_mail = 0) then 'Opt-In'  end)  as [Print Preference],
					is_app_user as [App User],
					'' LeaseEndDate,
					'' FinanceEndDate,
					'' WarrantyExpDate,
					Customer_id as CustomerID
			from CTE_Results 
		end
		else if(@verticalid = '2') 
		begin
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
					, make
					, model
					, model_year
					, Cast(Cast(next_service_date as varchar(100)) as date) as next_service_date
					, Cast(Cast(last_ro_date as varchar(100)) as date) as last_ro_date
					, Cast(Cast(last_visit_date as varchar(100)) as date) as last_visit_date
					, address_line
					, city
					, [state]
					, [zip_code]
					, primary_phone_number
					, '' as secondary_phone_number
					, tags
					, do_not_email
					, do_not_mail
					, do_not_call
					, do_not_sms
					, do_not_whatsapp
					, created_dt    
					, Isnull(@total_count, 0) as total_count   
					, Isnull(@email_optin, 0) as email_optin_count
					, Isnull(@mail_optin, 0) as mail_optin_count
					, Isnull(@phone_optin, 0) as phone_optin_count
					, is_fleet
					, Cast(Cast(ro_close_date as varchar(100)) as date) as ro_close_date
					, ro_number
					,is_app_user
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
					@dealer_name as [DealerName],
					first_name as [First Name],
					middle_name as [Middle Name],
					last_name  as [Last Name],
					first_name + ' ' + middle_name + ' ' + last_name as [FullName],
					address_line as [Addreess1],
					'' as [Address2],
					city as [City],
					[state] as [State],
					[zip_code] as [ZipCode],
					'' as MileRadius,
					primary_email as [EmailAddress],
					primary_phone_number  as [MobilePhone],
					'' as WorkPhone,
					secondary_phone_number as [HomePhone],
					vin as [Vin],
					make as [VehicleMake], 
					model as [VehicleModel],
					model_year as [VehicleYear],
					'' as EstimatedMiles,
					is_fleet as IsFleet,
					Cast(last_visit_date as varchar(50)) as [Sale Date],
					'' as SaleType,
					'' as VehicleType,
					Cast(ro_close_date as varchar(50))  as RoDate,
					Cast(last_ro_date as varchar(50)) as [Last Service Date],
					Cast(next_service_date as varchar(50)) as [Next Service Date],
					ro_number as RoNumber,
					'' as TotalRoAmount,
					'' as CustomerPay,
					'' as WarrantyPay,
					(case when  (do_not_email is null) then 'Do not know' 
						when (do_not_email = 1) then 'Opt-out'  when (do_not_email = 0) then 'Opt-In'  end) as [Email Preference],
					(case when  (do_not_sms is null) then 'Do not know' 
							when (do_not_sms = 1) then 'Opt-out'  when (do_not_sms = 0) then 'Opt-In'  end) as [SMS Preference], 
					is_app_user as [App User],
					'' LeaseEndDate,
					'' FinanceEndDate,
					'' WarrantyExpDate,
					Customer_id as CustomerID
			from CTE_Results 
		end   
		else   
		begin
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
					, make
					, model
					, model_year
					, Cast(Cast(next_service_date as varchar(100)) as date) as next_service_date
					, Cast(Cast(last_ro_date as varchar(100)) as date) as last_ro_date
					, Cast(Cast(last_visit_date as varchar(100)) as date) as last_visit_date
					, address_line
					, city
					, [state]
					, [zip_code]
					, primary_phone_number
					, '' as secondary_phone_number
					, tags
					, do_not_email
					, do_not_mail
					, do_not_call
					, do_not_sms
					, do_not_whatsapp
					, created_dt    
					, Isnull(@total_count, 0) as total_count   
					, Isnull(@email_optin, 0) as email_optin_count
					, Isnull(@mail_optin, 0) as mail_optin_count
					, Isnull(@phone_optin, 0) as phone_optin_count
					, is_fleet
					, Cast(Cast(ro_close_date as varchar(100)) as date) as ro_close_date
					, ro_number
					,is_app_user
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
					@dealer_name as [DealerName],
					first_name as [First Name],
					middle_name as [Middle Name],
					last_name  as [Last Name],
					first_name + ' ' + middle_name + ' ' + last_name as [FullName],
					address_line as [Addreess1],
					'' as [Address2],
					city as [City],
					[state] as [State],
					[zip_code] as [ZipCode],
					'' as MileRadius,
					primary_email as [EmailAddress],
					primary_phone_number  as [MobilePhone],
					'' as WorkPhone,
					secondary_phone_number as [HomePhone],
					vin as [Vin],
					make as [VehicleMake], 
					model as [VehicleModel],
					model_year as [VehicleYear],
					'' as EstimatedMiles,
					is_fleet as IsFleet,
					Cast(last_visit_date as varchar(50)) as [Sale Date],
					'' as SaleType,
					'' as VehicleType,
					Cast(ro_close_date as varchar(50))  as RoDate,
					Cast(last_ro_date as varchar(50)) as [Last Service Date],
					Cast(next_service_date as varchar(50)) as [Next Service Date],
					ro_number as RoNumber,
					'' as TotalRoAmount,
					'' as CustomerPay,
					'' as WarrantyPay,
					(case when  (do_not_email is null) then 'Do not know' 
						when (do_not_email = 1) then 'Opt-out'  when (do_not_email = 0) then 'Opt-In'  end) as [Email Preference],
					(case when  (do_not_sms is null) then 'Do not know' 
							when (do_not_sms = 1) then 'Opt-out'  when (do_not_sms = 0) then 'Opt-In'  end) as [SMS Preference],
					(case when  (do_not_mail is null) then 'Do not know' 
							when (do_not_mail = 1) then 'Opt-out'  when (do_not_mail = 0) then 'Opt-In'  end)  as [Print Preference],
					is_app_user as [App User],
					'' LeaseEndDate,
					'' FinanceEndDate,
					'' WarrantyExpDate,
					Customer_id as CustomerID
			from CTE_Results 
		end	
	End
	else if (@campaign_type = 'Customers' )
	Begin

		Print 'Campaign Type : ' + @campaign_type
		set @page_size = isnull(@page_size, 20) 
		
		Print 'Reached here customers'
		select distinct customer_id, master_vehicle_id, do_not_email, do_not_mail, do_not_call, do_not_sms, do_not_whatsapp
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
			  @total_count = count(customer_id)
			, @email_optin = Sum(Case when do_not_email in('0', 'No') then 1 else 0 end)
			, @mail_optin = Sum(Case when do_not_mail in('0', 'No') then 1 else 0 end)
			, @phone_optin = Sum(Case when do_not_sms in('0', 'No') then 1 else 0 end)
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
				, do_not_sms
				, do_not_whatsapp
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
				, master_vehicle_id as master_vehicle_id
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
			CASE WHEN (@sort_column = 'UpdatedDate' AND @sort_order='DESC') THEN created_dt END DESC,
			case when (@sort_column = 'OptOut' AND @sort_order='asc') then do_not_email end asc, 
			case when (@sort_column = 'OptOut' AND @sort_order='desc') then do_not_email end desc,
			case when (@sort_column = 'SmsOptOut' AND @sort_order='asc') then do_not_sms end asc, 
			case when (@sort_column = 'SmsOptOut' AND @sort_order='desc') then do_not_sms end desc 
		OFFSET ((isnull(@page_no,1) - 1) * @page_size) rows fetch next @page_size rows only 
	End
	else if (@campaign_type = 'SegmentMapCustomers' )
	Begin  
		Print 'Reached here SegmentMapCustomers'
		select 
			distinct customer_id  
		from 
			#cust_Temp cust  
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
			select count(*) as Customer_Count from #cust_Temp where isnull(do_not_email,3) = (case when @is_negative_email_campaign >= 1 then 3 else 0 end)  --ks
		End
		if (@campaign_type like 'SMS%')
		Begin
			print 3
			--select count(*) as Customer_Count from #cust_Temp where do_not_call = 0 
			select count(*) as Customer_Count from #cust_Temp where isnull(do_not_sms,3) = (case when @is_negative_sms_campaign >= 1 then 3 else 0 end)  --ks

		End
				if (@campaign_type like 'push%' or @campaign_type like 'event%' or @campaign_type like 'promotion%')
		Begin
			print 3
			select count(*) as Customer_Count from #cust_Temp where is_app_user = 1
		End

	End
			Print 'Step 27' + Convert(varchar(50), getdate(), 108)

End Try
Begin Catch

	--Insert into dbo.error_segment (ErrorMsg, ErrSeverity, ErrState) values (ERROR_MESSAGE() , ERROR_SEVERITY(), ERROR_STATE())

	SELECT
		ERROR_NUMBER() AS ErrorNumber  
		,ERROR_SEVERITY() AS ErrorSeverity  
		,ERROR_STATE() AS ErrorState  
		,ERROR_PROCEDURE() AS ErrorProcedure  
		,ERROR_LINE() AS ErrorLine  
		,ERROR_MESSAGE() AS ErrorMessage; 
End Catch
    

 END      
  /* Cleanup */            
 SET NOCOUNT OFF            
          
 /* Return Value */    
	 --RETURN 0    

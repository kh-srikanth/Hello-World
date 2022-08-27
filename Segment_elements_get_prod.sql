USE [auto_customers]
GO
/****** Object:  StoredProcedure [customer].[segment_elements_get]    Script Date: 1/31/2022 2:05:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [customer].[segment_elements_get]      
        
  @account_id uniqueidentifier = null ,
  @list_source_id varchar(10) = null
		
AS        
/*
  exec [customer].[segment_elements_get] '95ac28d8-d513-4b0e-b234-d989c4d2f0bc' ,2
  exec [customer].[segment_elements_get] '551302c9-3ec8-4fb3-be67-e9c4a0ecee00' ,3

  ----------------------------------------------------------------------------             
  MODIFICATIONS        
  Date				Author				Work Tracker Id			Description          
  ------------------------------------------------------------------------------------------------------------------       
  16/03/2021		Madhavi.k           Created-				This procedure is used to get segment  elements
  07/06/2021		Madhavi k			Modifyed				filter by list source is added
  11/12/2021		Santhosh B			Modify					Removing segment elements based on vertical ID 2
  12/01/2021		Supraja K			Modify					Removing segment elements based on vertical ID 3
  12/02/2021		Durgarao G			Modify					Removing segment elements based on vertical ID 3 lastservice date,Daily Average Mileage
  12/08/2021		Durgarao G			Modify					Removing segment elements based on vertical ID 3 Visit Date,Service Date,Last Visit Date
  12/08/2021		Durgarao G			Modify					ADD segment field type based on vertical ID 3 predective
  12/15/2021		Durgarao G			Modify					Removing segment elements based on vertical ID 3 Toyota Auto Care,Toyota Care Plus,Toyota Service Care,Lexus Luxury Care,Lexus Maintenance Select
  ------------------------------------------------------------------------------------------------------------------      
                              Copyright 2017 Warrous Pvt Ltd 
*/        
BEGIN  

SET NOCOUNT ON

	IF OBJECT_ID('tempdb..#SegmentElements') IS NOT NULL
	DROP TABLE #SegmentElements

	IF OBJECT_ID('tempdb..#CustomFields') IS NOT NULL
	DROP TABLE #CustomFields

	declare @max_sort_order int = 0
	declare @vertical_id int = 1

	set @max_sort_order = ( select max(isnull(sort_order, 0)) from [customer].[segment_elements] (nolock) )
	   
	select
		cse.[element_id],
		cse.[name],
		cet.[name] as field_type,
		cse.[element_type_id],
		cse.[sort_order]
	into
		#SegmentElements
	from
		[customer].[segment_elements] cse with(nolock,readuncommitted)
		inner join [customer].[elements_type] cet with(nolock,readuncommitted) on 
		cse.element_type_id = cet.element_type_id
	where 
		cse.is_deleted = 0 and
		( list_source_ids = @list_source_id  OR 
			 list_source_ids LIKE @list_source_id + ',%' OR
				 list_source_ids LIKE '%,'+ @list_source_id +',%' OR 
					 list_source_ids LIKE '%,'+ @list_source_id ) OR
		@list_source_id is null
	order by
		cse.sort_order asc

	if(@list_source_id = 5)
	begin
		select distinct
			json_value(ss.value, '$.name') as [name] 
		into
			#CustomFields
		from 
			customer.customers cu with(nolock, readuncommitted)
			cross apply openjson(cu.custom_fields,'$.customFields') as ss
		where 
			isjson(cu.custom_fields) = 1
			and cu.account_id = @account_id

		delete from #CustomFields where len(trim([name])) = 0

		insert into #SegmentElements
		select -1 as element_id, [name],'Custom Fields' as field_type, 3 as [element_type_id], isnull(@max_sort_order,0) + 1 as [sort_order] from #CustomFields
		order by element_id desc

	end

	--- Added Logic on 11/12/2021.  Removing segment elements based on vertical id (for r2r dealers)
	 select @vertical_id = Isnull(verticalid, 1) from [portal].[store_front] with (nolock) where accountid=@account_id
	
	if @vertical_id = 2
	begin

		delete from #SegmentElements where [name] in ('Customer Type', 'Customer products', 'Customer Subscriptions', 'Email marketing statistics', 'Landing page activity',
														  'Location', 'Sign up source', 'Churn score', 'Email client', 'Trim', 'Engine', 'Vehicle Type', 'Fuel Type', 'Distance by dealership',
														  'Toyota Auto Care','Toyota Care Plus','Toyota Service Care','Lexus Luxury Care','Lexus Maintenance Select', 'Customer Pay Amount', 'Internal Pay Amount'
														  , 'Opcode', 'Pay Type', 'Last Service Date', 'Visit Date', 'Maintenance Type')

		delete from #SegmentElements where field_type in ('Declined Services', 'Predictive') 

	End
	else if @vertical_id =3
	begin

		delete from #SegmentElements where [name] in ('Customer Type', 'Customer products', 'Customer Subscriptions', 'Email marketing statistics', 'Landing page activity',
													  'Location', 'Sign up source', 'Churn score', 'Email client', 'Trim', 'Engine', 'Vehicle Type', 'Fuel Type', 'Distance by dealership','Last Service Date','Daily Average Mileage',
													  'Visit Date','Service Date','Last Visit Date','Toyota Auto Care','Toyota Care Plus','Toyota Service Care','Lexus Luxury Care','Lexus Maintenance Select')

		delete from #SegmentElements where field_type in ('Vehicle Fields', 'Sales', 'Service Fields', 'Declined Services') 

	End

	select * from #SegmentElements order by [sort_order]
		   
SET NOCOUNT OFF

END
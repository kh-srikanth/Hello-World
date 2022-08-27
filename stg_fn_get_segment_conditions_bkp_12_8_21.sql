USE [auto_stg_customers]
GO
/****** Object:  UserDefinedFunction [customer].[get_segment_conditions]    Script Date: 12/8/2021 1:09:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [customer].[get_segment_conditions]         
   (    
		@segmant_query nvarchar(max)
   )    
RETURNS @queries Table (query varchar(4000), operator varchar(10), id int, Brackets varchar(5), is_processed bit) 
AS
/*
	Copyright 2017 Warrous Pvt Ltd    

              
 Date           Author			Work Tracker Id			Description              
 ------------------------------------------------------------------------------            
 2021-09-01		Santhosh B		Created					To Get the Segment Condition based on Segment Json.
 2021-09-14		Santhosh B		Modified				Added [model year] key word.

 ------------------------------------------------------------------------------            

 select * from  [customer].[get_segment_conditions]('{"queries":[{"element":"First Name","operator":"contains","secondOperator":"","value":"A","match":"","order":1}]}')
 select * from [customer].[get_segment_conditions]('{"queries":[{"element":"First Name","operator":"contains","secondOperator":"","value":"k","match":"or","order":"1"},{"element":"Last Name","operator":"contains","secondOperator":"","value":"s","match":"or","order":"2"},{"element":"Campaign Activity","operator":"opened","secondOperator":"","value":"last_3_months","match":"or","order":"3"}, {"element":"Date Added","operator":"is after","secondOperator":"","value":"01/01/2020","match":"","order":"4"}]}')

*/
Begin

	
	--Declare @segmant_query varchar(max) = '{"queries":[{"element":"First Name","operator":"contains","secondOperator":"","value":"k","match":"or","order":"1"},{"element":"Last Name","operator":"contains","secondOperator":"","value":"s","match":"or","order":"2"},{"element":"Campaign Activity","operator":"opened","secondOperator":"","value":"last_3_months","match":"or","order":"3"}, {"element":"Date Added","operator":"is after","secondOperator":"","value":"01/01/2020","match":"","order":"4"}]}'

	Declare
		@element varchar(max),    
		@operator varchar(max),    
		@value nvarchar(max) =null,    
		@match nvarchar(10) = null,
		@id int,
		@con_Operator varchar(50),
		@con int = 0,
		@result varchar(max)  
		
	Declare @segments Table 
			(
				element varchar(50),
				operator varchar(50),
				secondoperator varchar(50),
				[value] varchar(4000),
				[match] varchar(100),
				[id] int,
				[type] int
			)

	Declare @queries1 Table 
		(
			id int,
			[filter_condition] varchar(4000)
		)

	Insert into @segments (element, operator, secondoperator, [value], [match], [id], [type])
	SELECT 
		  element
		, operator
		, secondOperator
		, (case when [type] = 1 then [value] else (select [value] from OpenJson(a.[value]) where [key] = 'endDate') end) as [value]
		, [match]
		, [order]
		, [type]
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

	Insert into @queries1 (id, [filter_condition])
	SELECT DISTINCT     
		id,    
		case when c.element in ('First Name', 'Last Name', 'Address', 'Phone Number', 'Tag Name', 'Birthday', 'Email Address', 'Location', 'Email Marketing Status', 'Churn Score', 'Customer Type', 
								'Customer Subscriptions', 'Make', 'Model', 'Year', 'Trim', 'Engine', 'Fuel_Type', 'Customer Type', 'City', 'State', 'Zipcode', 'Miles Radius', 'Daily Average Mileage',
								'Vehicle Type', 'Email Optout', 'SMS Optout', 'Print Optout', 'Last Service Date', 'Visit Date', 'Last RO Mileage', 'Customer Pay Amount','Warranty Pay Amount',
								'Internal Pay Amount','RO Total Amount','RO Close Date','Pay Type', 'Sale Date', 'Sale Type', 'Area Code', 'Status', 'Modal Year')     
		then [customer].[query_on_segment_elements_get](c.Element,c.Operator,c.[Value], c.Match) end as [filter_condition]     
	FROM 
		@segments c    
	Order by id     

	Insert into @queries (query, operator, id, Brackets, is_processed)
	select 
	reverse(substring(reverse(filter_condition), charindex('#', reverse(filter_condition), 1) + 1, len(filter_condition))) as query, 
	reverse(substring(reverse(filter_condition), 1, charindex('#', reverse(filter_condition), 1) - 1)) as operator, 
	id, 
	'' as [Brackets], 0 as is_processed 
	from @queries1    

	While ((select count(*) from @queries where is_processed = 0 and query is not null) >= 1)    
	Begin    
		--print @con_Operator    
		select top 1 @id = id, @con_Operator = operator from @queries where is_processed = 0 and query is not null order by id    
       
		if (@con_Operator = 'or' and @con >= 0)    
		Begin    
		update @queries set     
			Brackets = (case when @con = 0 then '(' else '' end)    
		where     
			id = @id    
    
		set @con = @id    
    
		End    
		else    
		Begin    
			 if (@con > 0)
			 Begin
				 update  a set     
				  Brackets = ')'    
				 from 
					@queries a 
				where 
					id = @id    
			End
			set @con = 0
		End    
		
		Update @queries set is_processed = 1 where id = @id    
	End    

	if (@con > 0 )    
	Begin    
		Update @queries set Brackets = ')' where id = @id    
	End    
    
	delete from @queries where query is null    
    
	--SELECT @result = SUBSTRING((SELECT ' ' + (case when Brackets = '(' then Brackets + query else '' + query end) +  (case when Brackets = ')' then Brackets else '' end) + ' ' + operator    
	--FROM @queries    
	--order by id    
	--FOR XML PATH('')), 0, 9999)    

	--set @result = (Case when reverse(substring(reverse(@result), 1, 4)) like '%or%' or substring(reverse(@result), 1, 4) like '%and%' then substring(@result, 1, (Len(@result) -  charindex(' ', reverse(@result), 1))) else @result end) 
	
	--return @result
	return

End
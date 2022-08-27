USE [auto_stg_customers]
GO
/****** Object:  UserDefinedFunction [customer].[query_on_segment_elements_get]    Script Date: 11/25/2021 5:10:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [customer].[query_on_segment_elements_get]         
   (    
      @element varchar(max),    
	  @operator varchar(max),    
	  @value nvarchar(max) =null,    
	  @match nvarchar(10) = null    
   )    
   RETURNS  varchar(max)    
AS            
          
/*    
	 select  [customer].[query_on_segment_elements_get]  ('Churn Score','is less than','10')    
	-------------------------------------------          
	Date			Author			Work Tracker Id		Description              
	-------------------------------------------------------------------------------------            
	16/03/2021		Madhavi.k							Created -	This is to get query on segment elements  
	06/15/2021		Santhosh B							Modified -	Added logic to get Visited Date
	07/05/2021		Santhosh B							Modified -	Added logic to get in and not in operator values for User Fields (city, state and zip Code)
																	Added logic to folter data from RO Fields
	07/22/2021		Santhosh B							Modified -	Added logic to get Area Code
	08/10/2021		Santhosh B							Modified -	Added logic to get Customer Status
	08/13/2021		Santhosh B							Modified -	Added logic to get [Trim] condition
	08/23/2021		Santhosh B							Modified -	Few of the conditions (line numbers: 55,66 & 382-387(last RO Mileage))
	09/14/2021		Santhosh B							Modified -	Added logic for [model year]
	--------------------------------------------------------------------------------------          
        
*/            
BEGIN     
    
  declare @query varchar(max) = '';    
    
  select    
    
    @query = case @element    
    when 'First Name' then case @operator     
         when 'is blank' then  ' (first_name is null or first_name = '''')'    
         when 'is not blank' then  ' (first_name is not null and first_name != '''')'    
            when 'is' then ' (first_name = ''' + @value + ''')'    
         when 'is not' then ' (first_name != ''' + @value + ''')'    
         when 'contains' then ' (first_name like  ''' + '%' + @value +'%' + ''')'    
         when 'does not contain' then ' (first_name not like  ''' + '%' + @value +'%' + ''')'    
         when 'starts with' then ' (first_name like  ''' + @value +'%' + ''')'    
         when 'ends with' then ' (first_name like  ''' + '%' + @value + ''')'    
         end    
        
    when 'Last Name' then case @operator     
         when 'is blank' then  ' (last_name is null or last_name = '''')'    
         when 'is not blank' then  ' (last_name is not null and last_name != '''')'    
         when 'is' then ' (last_name = ''' + @value + ''')'    
         when 'is not' then ' (last_name != ''' + @value + ''')'    
         when 'contains' then ' (last_name like  ''' + '%' + @value + '%' + ''')'    
         when 'does not contain' then ' (last_name not like  ''' + '%' + @value + '%' + ''')'    
         when 'starts with' then ' (last_name like  ''' + @value +'%' + ''')'    
         when 'ends with' then ' (last_name like  ''' + '%' + @value + ''')'    
         end    
    
   when 'Tag Name' then case @operator     
         when 'is blank' then  ' (tags is null or tags = '''')'    
         when 'is not blank' then  ' (tags is not null and tags != '''')'    
         when 'is' then ' (tags = ''' + @value + ''')'    
         when 'is not' then ' (tags != ''' + @value + ''')'    
         when 'contains' then ' (tags like  ''' + '%' + @value + '%' + ''')'    
         when 'does not contain' then ' (tags not like  ''' + '%' + @value + '%' + ''')'    
         when 'starts with' then ' (tags like  ''' + @value +'%' + ''')'    
         when 'ends with' then ' (tags like  ''' + '%' + @value + ''')'    
         end    
       
   when 'Birthday' then case @operator     
         when 'is blank' then  ' (cast(birth_date as date) is null or cast(birth_date as date) = '''')'    
         when 'is not blank' then  ' (cast(birth_date as date) is not null and cast(birth_date as date) != '''')'    
         when 'month is' then ' (datename(month,cast(birth_date as date)) = ''' + @value + ''')'    
         when 'day is' then ' (day(cast(birth_date as date)) = ''' + @value + ''')'    
         when 'is(mm/dd/yyyy)' then ' (CONVERT(VARCHAR(10),cast(birth_date as date), 101) = ''' + @value + ''')'    
         when 'is not' then ' (CONVERT(VARCHAR(10),cast(birth_date as date), 101) != ''' + @value + ''')'    
         when 'contains' then ' ((CONVERT(VARCHAR(10),cast(birth_date as date), 101) like  ''' + '%' + @value + '%' + ''')'    
         when 'starts with' then ' ((CONVERT(VARCHAR(10),cast(birth_date as date), 101) like  ''' + @value +'%' + ''')'    
         when 'ends with' then ' ((CONVERT(VARCHAR(10),cast(birth_date as date), 101) like  ''' + '%' + @value + ''')'    
         end    
        
    when 'Address' then case @operator     
         when 'contains' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
                     FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
                        FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
                        WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + '%' + @value + '%' + ''')'    
             
         when 'does not contain' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
                     FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
                        FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
                        WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) not like  ''' + '%' + @value + '%' + ''')'    
             
         when 'starts with' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
                     FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
                        FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
                        WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + @value + '%' + ''')'    
             
         when 'ends with' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
                     FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
                        FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
                        WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + '%' + @value + ''')'    
         --when 'is blank' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
         --            FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
         --               FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
         --               WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
         --             FOR XML PATH('''')), 1, 1, ''''), '''')) in  ('''', null, '' ''))'    
		 when 'is blank' then ' Len(address_line) <= 0 '
		 when 'is not blank' then ' Len(address_line) > 0 '
         --when 'is not blank' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
         --            FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
         --               FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
         --               WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
         --             FOR XML PATH('''')), 1, 1, ''''), '''')) not in  ('''', '' ''))'    
         end    

	when 'City' then case @operator    
		when 'contains' then '((select JSON_VALUE([value], ''$.City'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) like  ''' + '%' + @value + '%' + ''')'      
		when 'does not contain' then '((select JSON_VALUE([value], ''$.City'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) not like  ''' + '%' + @value + '%' + ''')'      
		when 'starts with' then '((select JSON_VALUE([value], ''$.City'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) like  ''' + @value + '%' + ''')'      
		when 'ends with' then '((select JSON_VALUE([value], ''$.City'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) like  ''' + '%' + @value + ''')'       
		when 'is blank' then '((select JSON_VALUE([value], ''$.City'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) in  ('''', null, '' ''))'        
		when 'is not blank' then '((select JSON_VALUE([value], ''$.City'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) not in  ('''', '' ''))'        
		when 'is' then '((select JSON_VALUE([value], ''$.City'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) =  ''' + @value + ''')'        
		when 'in' then '((select Ltrim(Rtrim(JSON_VALUE([value], ''$.City''))) as [City] from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) in (select Ltrim(Rtrim([value])) from string_split(''' +  @value +  ''','','')))'    
        when 'not in' then '((select Ltrim(Rtrim(JSON_VALUE([value], ''$.City''))) as [City] from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) not in (select Ltrim(Rtrim([value])) from string_split(''' +  @value +  ''','','')))'    
		end 

         --when 'contains' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
         --            FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
         --               FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
         --               WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
         --             FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + '%' + @value + '%' + ''')'    
             
         --when 'does not contain' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
         --            FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
         --               FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
         --               WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
         --             FOR XML PATH('''')), 1, 1, ''''), '''')) not like  ''' + '%' + @value + '%' + ''')'    
             
         --when 'starts with' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
         --            FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
         --               FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
         --               WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
         --             FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + @value + '%' + ''')'    

         --when 'ends with' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
         --            FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
         --               FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
         --               WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
         --             FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + '%' + @value + ''')'    

         --when 'is blank' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
         --            FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
         --               FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
         --               WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
         --             FOR XML PATH('''')), 1, 1, ''''), '''')) in  ('''', null, '' ''))'    

         --when 'is not blank' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
         --            FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
         --               FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
         --               WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
         --             FOR XML PATH('''')), 1, 1, ''''), '''')) not in  ('''', '' ''))'    

         --when 'is' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
         --            FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
         --               FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
         --               WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
         --             FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + '%' + @value + '%' + ''')'   
		--end 
         
		 
	--when 'Zipcode' then case @operator     
 --        when 'is' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
 --                    FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
 --                       FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
 --                       WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
 --                     FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + '%' + @value + '%' + ''')'    
     
 --        when 'is blank' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
 --                    FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
 --                       FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
 --                       WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
 --                     FOR XML PATH('''')), 1, 1, ''''), '''')) in  ('''', null, '' ''))'    
 --        end 

	when 'Zipcode' then case @operator    
			when 'contains' then '((select JSON_VALUE([value], ''$.zip'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) like  ''' + '%' + @value + '%' + ''')'      
			when 'does not contain' then '((select JSON_VALUE([value], ''$.zip'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) not like  ''' + '%' + @value + '%' + ''')'      
			when 'starts with' then '((select JSON_VALUE([value], ''$.zip'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) like  ''' + @value + '%' + ''')'      
			when 'ends with' then '((select JSON_VALUE([value], ''$.zip'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) like  ''' + '%' + @value + ''')'       
			when 'is blank' then '((select JSON_VALUE([value], ''$.zip'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) in  ('''', null, '' ''))'        
			when 'is not blank' then '((select JSON_VALUE([value], ''$.zip'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) not in  ('''', '' ''))'        
			when 'is' then '((select JSON_VALUE([value], ''$.zip'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) =  ''' + @value + ''')'        
			when 'in' then '((select Ltrim(Rtrim(JSON_VALUE([value], ''$.zip''))) as [City] from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) in (select Ltrim(Rtrim([value])) from string_split(''' +  @value +  ''','','')))'    
			when 'not in' then '((select Ltrim(Rtrim(JSON_VALUE([value], ''$.zip''))) as [City] from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) not in (select Ltrim(Rtrim([value])) from string_split(''' +  @value +  ''','','')))'    
		end

	--when 'State' then case @operator     
 --        when 'contains' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
 --                    FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
 --                       FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
 --                       WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
 --                     FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + '%' + @value + '%' + ''')'    
             
 --        when 'does not contain' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
 --                    FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
 --                       FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
 --                       WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
 --                     FOR XML PATH('''')), 1, 1, ''''), '''')) not like  ''' + '%' + @value + '%' + ''')'    
             
 --        when 'starts with' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
 --                    FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
 --                       FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
 --                       WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
 --                     FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + @value + '%' + ''')'    
             
 --        when 'ends with' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
 --                    FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
 --                       FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
 --                       WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
 --                     FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + '%' + @value + ''')'    
 --        when 'is blank' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
 --                    FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
 --                       FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
 --                       WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
 --                     FOR XML PATH('''')), 1, 1, ''''), '''')) in  ('''', null, '' ''))'    
 --        when 'is not blank' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value     
 --                    FROM (SELECT [Street] + '', '' + [City] + '', '' + [State] + '', '' + [Country] + '', '' + [Zip] as value    
 --                       FROM OPENJSON(replace(addresses,''\'',''/''), ''$.addresses'')     
 --                       WITH ([Street] NVARCHAR(25) ''$.street'',[City] NVARCHAR(25) ''$.city'', [State] NVARCHAR(25) ''$.state'',[Country] NVARCHAR(25) ''$.country'', [Zip] NVARCHAR(25) ''$.zip'')) as ss    
 --                     FOR XML PATH('''')), 1, 1, ''''), '''')) not in  ('''', '' ''))'    
 --        end 

	when 'State' then case @operator    
			when 'contains' then '((select JSON_VALUE([value], ''$.State'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) like  ''' + '%' + @value + '%' + ''')'      
			when 'does not contain' then '((select JSON_VALUE([value], ''$.State'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) not like  ''' + '%' + @value + '%' + ''')'      
			when 'starts with' then '((select JSON_VALUE([value], ''$.State'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) like  ''' + @value + '%' + ''')'      
			when 'ends with' then '((select JSON_VALUE([value], ''$.State'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) like  ''' + '%' + @value + ''')'       
			when 'is blank' then '((select JSON_VALUE([value], ''$.State'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) in  ('''', null, '' ''))'        
			when 'is not blank' then '((select JSON_VALUE([value], ''$.State'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) not in  ('''', '' ''))'        
			when 'is' then '((select JSON_VALUE([value], ''$.State'') from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) =  ''' + @value + ''')'        
			when 'in' then '((select Ltrim(Rtrim(JSON_VALUE([value], ''$.State''))) as [City] from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) in (select Ltrim(Rtrim([value])) from string_split(''' +  @value +  ''','','')))'    
			when 'not in' then '((select Ltrim(Rtrim(JSON_VALUE([value], ''$.State''))) as [State] from OpenJson(replace(addresses,''\'',''/''), ''$.addresses'')) not in (select Ltrim(Rtrim([value])) from string_split(''' +  @value +  ''','','')))'    
		end
        
    when 'Phone Number' then case @operator   
         when 'is' then ' (''' + @value + ''' in (SELECT phoneNumber as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')))'    
         when 'is not' then ' (''' + @value + ''' not in (SELECT phoneNumber as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')))'    
         when 'contains' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value FROM (SELECT phoneNumber as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + '%' + @value + '%' + ''')'    
         when ' does not contain' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value FROM (SELECT phoneNumber as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) not like  ''' + '%' + @value + '%' + ''')'    
         when 'starts with' then ' ((select ISNULL(STUFF((SELECT '','' + ss.value FROM (SELECT phoneNumber as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + @value + '%' + ''')'    
         when 'ends with' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value FROM (SELECT phoneNumber as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + '%' + @value + ''')'    
         when 'is blank' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value FROM (SELECT phoneNumber as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) in ('''', '' ''))'     
         when 'is not blank' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value FROM (SELECT phoneNumber as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) not in  ('''', '' ''))'    
         end    

    when 'Area Code' then case @operator   
         when 'is' then ' (''' + @value + ''' in (SELECT Substring(phoneNumber,1,3) as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')))'    
         when 'is not' then ' (''' + @value + ''' not in (SELECT Substring(phoneNumber,1,3) as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')))'    
         when 'contains' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value FROM (SELECT Substring(phoneNumber,1,3) as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + '%' + @value + '%' + ''')'    
         when ' does not contain' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value FROM (SELECT Substring(phoneNumber,1,3) as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) not like  ''' + '%' + @value + '%' + ''')'    
         when 'starts with' then ' ((select ISNULL(STUFF((SELECT '','' + ss.value FROM (SELECT Substring(phoneNumber,1,3) as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + @value + '%' + ''')'    
         when 'ends with' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value FROM (SELECT Substring(phoneNumber,1,3) as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) like  ''' + '%' + @value + ''')'    
         when 'is blank' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value FROM (SELECT phoneNumber as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) in ('''', '' ''))'     
         when 'is not blank' then ' ((select ISNULL(STUFF((SELECT '', '' + ss.value FROM (SELECT phoneNumber as value FROM OPENJSON(replace(phone_numbers,''\'',''/''), ''$.phoneNumbers'') WITH (phoneNumber NVARCHAR(25) ''$.phoneNumber'')) as ss    
                      FOR XML PATH('''')), 1, 1, ''''), '''')) not in  ('''', '' ''))'    
         end    

    
   when 'Email Address' then case @operator     
            when 'is' then ' (primary_email = ''' + @value + ''')'    
            when 'is not' then ' (primary_email != ''' + @value + ''')'    
            when 'contains' then ' (primary_email like  ''' + '%' + @value +'%' + ''')'    
            when 'does not contain' then ' (primary_email not like  ''' + '%' + @value +'%' + ''')'    
            when 'starts with' then ' (primary_email like  ''' + @value +'%' + ''')'    
            when 'ends with' then ' (primary_email like  ''' + '%' + @value + ''')'    
            end     
   when 'Location' then case @operator     
            when 'is in country' then ' (county = ''' + @value + ''')'    
            when 'is not in country' then ' (county != ''' + @value + ''')'    
            when 'is zip' then ' (zip = ''' + @value + ''')'    
            when 'is not zip' then ' (zip <> ''' + @value + ''')'    
            when 'is unknown' then ' (zip is null or zip = '''')'    
            end    
    
   when 'Email Marketing Status' then case @operator     
            when 'is' then ' (is_suppressed = case when ''' + @value + '''= ''Subscribed'' then 0    
                      when ''' + @value + '''= ''Unsubscribed'' then 1    
                      when ''' + @value + '''= ''Non-Subscribed'' then 1    
                      when ''' + @value + '''= ''Cleaned'' then 0    
                      end)'    
            when 'is not' then  ' (is_suppressed = case when ''' + @value + '''!= ''Subscribed'' then 0    
                      when ''' + @value + '''!= ''Unsubscribed'' then 1    
                      when ''' + @value + '''= ''Non-Subscribed'' then 1    
                      when ''' + @value + '''= ''Cleaned'' then 0    
                      end)'    
            end             
    when 'Churn Score' then case @operator     
            when 'is' then ' (churn_score = ' + isnull(@value,0) + ')'    
            when 'is not' then ' (churn_score != ' + isnull(@value,0) + ')'    
            when 'is greater than' then ' (churn_score > ' + isnull(@value,0) + ')'    
            when 'is less than' then ' (churn_score < ' + isnull(@value,0) + ')'    
            end    
    
    --when 'Customer Type' then case @operator     
    --      when 'is' then ' (first_name like  ''' + '%a%' + ''')'    
    --      end    
        
    when 'Customer Subscriptions' then case @operator     
            when 'is' then ' (first_name like  ''' + '%a%' + ''')'    
            end    
  
	--when 'Make' then case @operator     
	--					 when 'contains' then ' (make in (''' +  SUBSTRING(@value,1, len(@value) -1) + '''))'    
	--					 when 'does not contain' then ' (make not in (''' + SUBSTRING(@value,1, len(@value) -1) + '''))'   
	--					 when 'is' then ' (make in (''' + SUBSTRING(@value,1, len(@value) -1) + '''))'   
	--					 when 'is not' then ' (make not in (''' + SUBSTRING(@value,1, len(@value) -1) + '''))'   
	--				 end  
	when 'Make' then case @operator     
						 when 'contains' then ' (make in (''' +  Replace(@value,',',''',''') + '''))'    
						 when 'does not contain' then ' (make not in (''' + Replace(@value,',',''',''') + '''))'   
						 when 'is' then ' (make in (''' + Replace(@value,',',''',''') + '''))'   
						 when 'is not' then ' (make not in (''' + Replace(@value,',',''',''') + '''))'   
					 end  
	
	when 'Model' then case @operator     
						 when 'contains' then ' (Model in (''' +  Replace(@value,',',''',''') + '''))'    
						 when 'does not contain' then ' (Model not in (''' + Replace(@value,',',''',''') + '''))'   
						 when 'is' then ' (Model in (''' + Replace(@value,',',''',''') + '''))'   
						 when 'is not' then ' (Model not in (''' + Replace(@value,',',''',''') + '''))'   
					 end  

	when 'Vehicle Type' then case @operator     
						 when 'contains' then ' (vehicle_type in (''' +  Replace(@value,',',''',''') + '''))'    
						 when 'does not contain' then ' (vehicle_type not in (''' + Replace(@value,',',''',''') + '''))'   
					 end  

	when 'Year' then case @operator     
						 when 'contains' then ' (model_year in (''' +  Replace(@value,',',''',''') + '''))'    
						 when 'does not contain' then ' (model_year not in (''' + Replace(@value,',',''',''') + '''))'   
					 end  

	when 'Model Year' then case @operator     
			when 'equal to' then ' (model_year =  ' + isnull(@value,0) + ')'    
			when 'greater than' then ' (model_year > ' + isnull(@value,0) + ')'    
			when 'less than' then ' (model_year < ' + isnull(@value,0) + ')' 
			when 'greater than or equal to' then ' (model_year >= ' + isnull(@value,0) + ')' 
			when 'less than or equal to' then ' (model_year <= ' + isnull(@value,0) + ')' 
			when 'between' then ' (model_year > ' + isnull(@value,0) + ' and model_year < ' + isnull(@value,0) + ')'    
		end

	when 'Trim' then case @operator     
			when 'is' then ' ([trim] = ''' + isnull(@value,0) + ''')'    
			when 'is not' then ' ([trim] != ''' + isnull(@value,0) + ''')'     
		end

	when 'Lead Status' then case @operator     
			when 'is' then ' ( lead_status_id= ''' + isnull(@value,0) + ''')'    
			when 'is not' then ' (lead_status_id != ''' + isnull(@value,0) + ''')'     
		end


	when 'Lead Source' then case @operator     
			when 'is' then ' (lead_source_id = ''' + isnull(@value,0) + ''')'    
			when 'is not' then ' (lead_source_id != ''' + isnull(@value,0) + ''')'     
		end
  
	when 'Customer Type' then case @operator     
			when 'is' then ' (cust_type like  ''' + isnull(@value,0) + ''')'    
			when 'is not' then ' (cust_type not like  ''' + isnull(@value,0) + ''')'    
			end

	when 'Miles Radius' then case @operator     
			when 'is' then ' (redius =  ' + isnull(@value,0) + ')'    
			when 'is not' then ' (redius != ' + isnull(@value,0) + ')'    
			when 'is greater than' then ' (redius > ' + isnull(@value,0) + ')'    
			when 'is less than' then ' (redius < ' + isnull(@value,0) + ')' 
			when 'is greater than or equal' then ' (redius >= ' + isnull(@value,0) + ')' 
			when 'is less than or equal' then ' (redius <= ' + isnull(@value,0) + ')' 
		end

	when 'Last RO Mileage' then case @operator     
			when 'is' then ' (last_ro_mileage =  ' + isnull(@value,0) + ')'    
			when 'is not' then ' (last_ro_mileage != ' + isnull(@value,0) + ')'    
			when 'is greater than' then ' (last_ro_mileage > ' + isnull(@value,0) + ')'    
			when 'is less than' then ' (last_ro_mileage < ' + isnull(@value,0) + ')' 
			when 'is greater than or equal' then ' (last_ro_mileage >= ' + isnull(@value,0) + ')' 
			when 'is less than or equal' then ' (last_ro_mileage <= ' + isnull(@value,0) + ')' 
		end

	when 'Customer Pay Amount' then case @operator     
			when 'is' then ' (total_customer_pay =  ' + isnull(@value,0) + ')'    
			when 'is not' then ' (total_customer_pay != ' + isnull(@value,0) + ')'    
			when 'is greater than' then ' (total_customer_pay > ' + isnull(@value,0) + ')'    
			when 'is less than' then ' (total_customer_pay < ' + isnull(@value,0) + ')' 
			when 'is greater than or equal' then ' (total_customer_pay >= ' + isnull(@value,0) + ')' 
			when 'is less than or equal' then ' (total_customer_pay <= ' + isnull(@value,0) + ')' 
		end

	when 'Warranty Pay Amount' then case @operator     
			when 'is' then ' (total_warranty_pay =  ' + isnull(@value,0) + ')'    
			when 'is not' then ' (total_warranty_pay != ' + isnull(@value,0) + ')'    
			when 'is greater than' then ' (total_warranty_pay > ' + isnull(@value,0) + ')'    
			when 'is less than' then ' (total_warranty_pay < ' + isnull(@value,0) + ')' 
			when 'is greater than or equal' then ' (total_warranty_pay >= ' + isnull(@value,0) + ')' 
			when 'is less than or equal' then ' (total_warranty_pay <= ' + isnull(@value,0) + ')' 
		end

	when 'Internal Pay Amount' then case @operator     
			when 'is' then ' (total_internal_pay =  ' + isnull(@value,0) + ')'    
			when 'is not' then ' (total_internal_pay != ' + isnull(@value,0) + ')'    
			when 'is greater than' then ' (total_internal_pay > ' + isnull(@value,0) + ')'    
			when 'is less than' then ' (total_internal_pay < ' + isnull(@value,0) + ')' 
			when 'is greater than or equal' then ' (total_internal_pay >= ' + isnull(@value,0) + ')' 
			when 'is less than or equal' then ' (total_internal_pay <= ' + isnull(@value,0) + ')' 
		end

	when 'RO Total Amount' then case @operator     
			when 'is' then ' (total_ro_amount =  ' + isnull(@value,0) + ')'    
			when 'is not' then ' (total_ro_amount != ' + isnull(@value,0) + ')'    
			when 'is greater than' then ' (total_ro_amount > ' + isnull(@value,0) + ')'    
			when 'is less than' then ' (total_ro_amount < ' + isnull(@value,0) + ')' 
			when 'is greater than or equal' then ' (total_ro_amount >= ' + isnull(@value,0) + ')' 
			when 'is less than or equal' then ' (total_ro_amount <= ' + isnull(@value,0) + ')' 
		end

	when 'Pay Type' then case @operator     
			when 'is' then ' (pay_type like  ''%' + (Case when isnull(@value,'Customer Pay') = 'Customer Pay' then 'CP' when isnull(@value,'Customer Pay') = 'Warranty Pay' then 'WP' when isnull(@value,'Customer Pay') = 'Internal Pay' then 'IP' else '' end) + '%'')'    
			when 'is not' then ' (pay_type not like ''%' + (Case when isnull(@value,'Customer Pay') = 'Customer Pay' then 'CP' when isnull(@value,'Customer Pay') = 'Warranty Pay' then 'WP' when isnull(@value,'Customer Pay') = 'Internal Pay' then 'IP' else '' end) + '%'')'    
		end

	when 'Status' then case @operator     
			when 'is' then ' (cust_status = ''' + isnull(@value,0) + ''')'    
			when 'is not' then ' (cust_status != ''' + isnull(@value,0) + ''')'     
		end
		
	when 'RO Close Date' then case @operator     
			when 'is' then ' (ro_close_date =  ' + Convert(varchar(10), isnull(Cast(@value as date), getdate()), 112) + ')'    
			when 'is before' then ' (ro_close_date < ' + Convert(varchar(10), isnull(Cast(@value as date), getdate()), 112) + ')'    
			when 'is after' then ' (ro_close_date > ' + Convert(varchar(10), isnull(Cast(@value as date), getdate()), 112) + ')'    
		end

	when 'Last Service Date' then case @operator     
			when 'is' then ' (last_ro_date =  ' + Convert(varchar(10), isnull(Cast(@value as date), getdate()), 112) + ')'    
			when 'is before' then ' (last_ro_date < ' + Convert(varchar(10), isnull(Cast(@value as date), getdate()), 112) + ')'    
			when 'is after' then ' (last_ro_date > ' + Convert(varchar(10), isnull(Cast(@value as date), getdate()), 112) + ')'    
		end

	when 'Visit Date' then case @operator     
			when 'is' then ' (last_visit_date =  ' + Convert(varchar(10), isnull(Cast(@value as date), getdate()), 112) + ')'    
			when 'is before' then ' (last_visit_date < ' + Convert(varchar(10), isnull(Cast(@value as date), getdate()), 112) + ')'    
			when 'is after' then ' (last_visit_date > ' + Convert(varchar(10), isnull(Cast(@value as date), getdate()), 112) + ')'    
		end

	when 'Sale Date' then case @operator     
			when 'is' then ' (purchase_date =  ' + Convert(varchar(10), isnull(Cast(@value as date), getdate()), 112) + ')'    
			when 'is before' then ' (purchase_date < ' + Convert(varchar(10), isnull(Cast(@value as date), getdate()), 112) + ')'    
			when 'is after' then ' (purchase_date > ' + Convert(varchar(10), isnull(Cast(@value as date), getdate()), 112) + ')'    
		end

	when 'Sale Type' then case @operator     
			when 'is' then ' (nuo_flag = ''' + isnull(@value,0) + ''')'    
			when 'is not' then ' (nuo_flag != ''' + isnull(@value,0) + ''')'     
		end

	when 'Daily Average Mileage' then case @operator     
			when 'is' then ' (avg_mileage_per_day = ' + isnull(@value,0) + ')'    
			when 'is not' then ' (avg_mileage_per_day != ' + isnull(@value,0) + ')'    
			when 'is greater than' then ' (avg_mileage_per_day > ' + isnull(@value,0) + ')'    
			when 'is less than' then ' (avg_mileage_per_day < ' + isnull(@value,0) + ')'    
			when 'is greater than or equal' then ' (redius >= ' + isnull(@value,0) + ')' 
			when 'is less than or equal' then ' (redius <= ' + isnull(@value,0) + ')' 
		end

		when 'Email Optout' then case @operator 
										when 'is' then ' (do_not_email = ''' + isnull(@value,0) + ''')'
										when 'is not' then ' (do_not_email != ''' + isnull(@value,0) + ''')'
										end

		when 'SMS Optout' then case @operator 
										when 'is' then ' (do_not_call = ''' + isnull(@value,0) + ''')'
										when 'is not' then ' (do_not_call != ''' + isnull(@value,0) + ''')'
										end

		when 'Print Optout' then case @operator 
										when 'is' then ' (do_not_mail = ''' + isnull(@value,0) + ''')'
										when 'is not' then ' (do_not_mail != ''' + isnull(@value,0) + ''')'
										end
  
  end  
   
  return @query + '#' + isnull(@match, 'and')    
    
END
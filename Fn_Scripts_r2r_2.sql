USE [auto_mobile]
GO
/****** Object:  UserDefinedFunction [dbo].[get_distance_by_lat_long]    Script Date: 1/25/2022 5:37:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[get_distance_by_lat_long_1] 
(
	@start_lat varchar(20),
	@start_lng  varchar(20),
	@end_lat  varchar(20),
	@end_lng  varchar(20)
)
RETURNS float
AS
/*

 select [dbo].[get_distance_by_lat_long](17.4380,78.3952,'29.726070','-98.108530') as distance
 --------------------------------------       
 Copyright  Ready2Ride  2017 & 2018  
    
 PROCESSES        
    
 MODIFICATIONS        
 Date			 Author			Work Tracker Id				Description          
 -----------------------------------------------------------------------------------------------------------        
 08/21/2018	  Raviteja.V.V       Created					to get distance unsing latitutes and longitudes ( distance in meteres)
 -----------------------------------------------------------------------------------------------------------      
    
*/ 
BEGIN
	 DECLARE @distance float
	 DECLARE @orig_lat  decimal(18, 9)
	 DECLARE @orig_lng  decimal(18, 9)
	 DECLARE @dest_lat  decimal(18, 9)
	 DECLARE @dest_lng  decimal(18, 9)

	 if(isnumeric(@start_lat) = 1)
		begin
			set @orig_lat = cast(@start_lat as decimal(18, 9))
		end
	 else
		begin
			set @orig_lat = null
		end

	if(isnumeric(@start_lng) = 1)
		begin
			set @orig_lng = cast(@start_lng as decimal(18, 9))
		end
	else
		begin
			set @orig_lng = null
		end

	if(isnumeric(@end_lat) = 1)
		begin
			set @dest_lat = cast(@end_lat as decimal(18, 9))
		end
	else
		begin
			set @dest_lat = null
		end

	if(isnumeric(@end_lng) = 1)
		begin
			set @dest_lng = cast(@end_lng as decimal(18, 9))
		end
	else
		begin
			set @dest_lng = null
		end


	 if(@orig_lat is null or @orig_lng is null or @dest_lat is null or @dest_lng is null)
		begin

			SET @distance = 0.00

		end
	else
		begin

			 DECLARE @orig GEOGRAPHY = GEOGRAPHY::Point(@orig_lat, @orig_lng, 4326);
			 DECLARE @dest GEOGRAPHY = GEOGRAPHY::Point(@dest_lat,@dest_lng,4326) 

			 SET @distance = @orig.STDistance(@dest)

		end

	 return @distance
END
GO
/****** Object:  UserDefinedFunction [dbo].[gettext_by_langcode]    Script Date: 1/25/2022 5:37:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Santhosh B
-- Create date: 2017-04-10
-- Description:	To Get the parent dealer id.
-- =============================================
CREATE FUNCTION [dbo].[gettext_by_langcode_1]
(
	-- Add the parameters for the function here
	@text nvarchar(50),
	@lang_code varchar(10)
)
RETURNS nvarchar(100)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result_text nvarchar(100)

	select 
		@result_text =  ld.translated_text
	from 
		cm.admin.lang_dictionary ld with(nolock)
		inner join cm.admin.lang l with(nolock) on
		ld.lang_id = l.lang_id
	where
		ld.text = @text and
		l.lang_code = @lang_code
	


	-- Return the result of the function
	RETURN @result_text

END

GO
/****** Object:  UserDefinedFunction [dbo].[parent_dealer_ifo_get]    Script Date: 1/25/2022 5:37:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Santhosh B
-- Create date: 2017-04-10
-- Description:	To Get the parent dealer id.
-- =============================================
CREATE FUNCTION [dbo].[parent_dealer_ifo_get_1]
(
	-- Add the parameters for the function here
	@dealer_id int,
	@get_type_name varchar(10)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @parent_dealer_id int

	-- To get the parent dealer information
	;with dealer_hierarchy
              as
              (
              
              select 
                a.dealer_id, 
                a.dealer_name, 
                a.acct_center_code, 
                b.dealer_hierarchy_id, 
                b.parent_dealer_hierarchy_id, 
                1 as [level], 
                c.geo_type_name
              from 
                 portal.dealer a with(nolock)
                 inner join portal.dealer_hierarchy b with(nolock) on 
                   a.dealer_id = b.dealer_id
                 inner join portal.geo_type c with(nolock) on 
                   a.geo_type_id = c.geo_type_id
              where 
                a.dealer_id = @dealer_id
              Union all
              select 
                a.dealer_id, 
                a.dealer_name, 
                a.acct_center_code, 
                b.dealer_hierarchy_id, 
                b.parent_dealer_hierarchy_id, 
                [level] + 1, 
                d.geo_type_name
              from 
                portal.dealer a with(nolock)
                 inner join portal.dealer_hierarchy b with(nolock) on 
                   a.dealer_id = b.dealer_id
                 inner join dealer_hierarchy c  on 
                   c.parent_dealer_hierarchy_id = b.dealer_hierarchy_id
                 inner join portal.geo_type d with(nolock) on
                   a.geo_type_id = d.geo_type_id       
              )

       -- To get the specific parent dealer information.
       select @parent_dealer_id = dealer_id from dealer_hierarchy where geo_type_name = @get_type_name


	-- Return the result of the function
	RETURN @parent_dealer_id

END

GO

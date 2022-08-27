USE [auto_mobile]
GO
/****** Object:  UserDefinedFunction [alert].[get_service_suggestion]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [alert].[get_service_suggestion]
(
	-- Add the parameters for the function here
	@last_serviced nvarchar(100),
	@alert_type varchar(20),
	@every varchar(100) = null
)
RETURNS varchar(100)
AS
BEGIN
	  
	-- Declare the return variable here

	declare @service_suggestion varchar(100)
	declare @suggested int = 0
	
	IF(@alert_type = 'time')
		BEGIN
			If(isdate(@last_serviced) = 1 and len(@last_serviced) > 7)
				begin
					set @suggested = dbo.GetNumeric(@every)
					set @suggested = cast(isnull(nullif(ltrim(rtrim(@suggested)),''),'0') as int)
					if(charindex('day', @every) >= 1)
						begin
							set @service_suggestion = convert(varchar(20),(DATEADD(DAY,@suggested,(cast(@last_serviced as date)))),101)
						end
					else if(charindex('week', @every) >= 1)
						begin
							set @service_suggestion = convert(varchar(20),(DATEADD(WEEK,@suggested,(cast(@last_serviced as date)))),101)
						end
					else if(charindex('month', @every) >= 1)
						begin
							set @service_suggestion = convert(varchar(20),(DATEADD(MONTH,@suggested,(cast(@last_serviced as date)))),101)
						end
					else if(charindex('year', @every) >= 1)
						begin
							set @service_suggestion = convert(varchar(20),(DATEADD(YEAR,@suggested,(cast(@last_serviced as date)))),101)
						end
					else
						begin
							set @service_suggestion = convert(varchar(20),(DATEADD(DAY,0,(cast(@last_serviced as date)))),101)
						end
				end
		END
	ELSE IF(@alert_type = 'miles')
		BEGIN
			If(isnumeric(@last_serviced) = 1)
				begin
					if(isnumeric(@every) = 1)
						begin
							set @service_suggestion = cast((cast(@last_serviced as int) + cast(@every as int)) as varchar(20))
							set @service_suggestion = @service_suggestion + ' miles'
						end
					else
						begin
							set @every = dbo.GetNumeric(@every)
							set @every = isnull(nullif(ltrim(rtrim(@every)),''),'0')
							set @service_suggestion = cast((cast(@last_serviced as int) + cast(@every as int)) as varchar(20))
							set @service_suggestion = @service_suggestion + ' miles'
						end
				end
		END

	SET @service_suggestion = isnull(@service_suggestion,'')

	RETURN @service_suggestion

END

GO
/****** Object:  UserDefinedFunction [buddy].[fn_get_common_riders_count]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [buddy].[fn_get_common_riders_count]
(
	-- Add the parameters for the function here
	@owner_id int,
	@suggested_owner_id int
)
RETURNS int
AS
/*
	select [buddy].[fn_get_common_riders_count] (425351, 425247)
	----------------------------------------------------------------         
	MODIFICATIONS        
	Date			 Author			    Description          
	---------------------------------------------------------------        
	09/08/2020     Mohan.K           Created - To get common riders count
	----------------------------------------------------------------      
				Copyright 2020 Powersports Pvt Ltd
*/
BEGIN
		-- Declare the return variable here
		DECLARE @total_count int = 0;

		DECLARE @ownerbuddies TABLE (id int identity, owner_id int)
		DECLARE @suggestedownerbuddies TABLE (id int identity, owner_id int)

		insert into @ownerbuddies(owner_id)
		select sender_id as id
		from buddy.buddy
		where (sender_id = @owner_id and is_request_accepted = 1) or (receiver_id = @owner_id and is_request_accepted = 1)
		union 
		select receiver_id as id
		from buddy.buddy where (sender_id = @owner_id and is_request_accepted = 1) or (receiver_id = @owner_id and is_request_accepted = 1)

		insert into @suggestedownerbuddies(owner_id)
		select sender_id as id
		from buddy.buddy
		where (sender_id = @suggested_owner_id and is_request_accepted = 1) or (receiver_id = @suggested_owner_id and is_request_accepted = 1)
		union 
		select receiver_id as id
		from buddy.buddy where (sender_id = @suggested_owner_id and is_request_accepted = 1) or (receiver_id = @suggested_owner_id and is_request_accepted = 1)

		delete from @ownerbuddies where owner_id = @owner_id
		delete from @ownerbuddies where owner_id = @suggested_owner_id

		delete from @suggestedownerbuddies where owner_id = @owner_id
		delete from @suggestedownerbuddies where owner_id = @suggested_owner_id

		;WITH CTE_CommonRiders AS 
		(
			select owner_id from @ownerbuddies
			intersect
			select owner_id from @suggestedownerbuddies
		)
		select @total_count = count(*) from  CTE_CommonRiders

		set @total_count = isnull(@total_count, 0)

		set @total_count = iif(@total_count < 0, 0, @total_count)

	    RETURN @total_count
END
GO
/****** Object:  UserDefinedFunction [cycle].[get_color]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [cycle].[get_color] 
(
	@cycle_id int,
	@color Varchar(10)
)
RETURNS  int
AS
BEGIN

	Return (Select COUNT(*) from 
	       (SELECT Case When resolved_date <= expire_date Then 'Green' when (resolved_date is null And Getdate() <=   expire_date) Then 'Amber' Else 'Red' end as color, 
		           cycle_id      
		    FROM cycle.cycle_service ccs where service_date is not Null and (is_resolved IS Null Or is_resolved =0)  and ccs.cycle_id= @cycle_id) c where color= @color)

END
GO
/****** Object:  UserDefinedFunction [cycle].[get_cycle_last_service_date]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [cycle].[get_cycle_last_service_date]
(
	-- Add the parameters for the function here
	@cycle_id int = 0
)
RETURNS date
AS
BEGIN
		-- Declare the return variable here
		DECLARE @last_srvice_date date

		SET @cycle_id = isnull(@cycle_id,0)
		
		SET @last_srvice_date  = (select 
										top 1 ccs.service_date 
								  from 
									  cycle.cycle_service ccs with(nolock,readuncommitted)
								  where 
									   ccs.is_deleted = 0
									   and ccs.cycle_id = @cycle_id
								  order by
									    ccs.service_date desc)

	RETURN @last_srvice_date

END

GO
/****** Object:  UserDefinedFunction [cycle].[get_cycle_last_service_id]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [cycle].[get_cycle_last_service_id]
(
	-- Add the parameters for the function here
	@cycle_id int = 0
)
RETURNS bigint
AS
BEGIN
		-- Declare the return variable here
		DECLARE @last_srvice_id bigint

		SET @cycle_id = isnull(@cycle_id,0)
		
		SET @last_srvice_id  = (select 
										top 1 ccs.cycle_service_id 
								  from 
									  cycle.cycle_service ccs with(nolock,readuncommitted)
								  where 
									   ccs.is_deleted = 0
									   and ccs.cycle_id = @cycle_id
								  order by
									    ccs.cycle_service_id desc)

	RETURN @last_srvice_id

END

GO
/****** Object:  UserDefinedFunction [cycle].[get_cycle_rides_distance]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [cycle].[get_cycle_rides_distance]
(
	-- Add the parameters for the function here
	@cycle_id int = 0,
	@owner_id int = 0
)
RETURNS decimal(10,2)
AS
/*

 select [cycle].[get_cycle_rides_distance](296004,829685) as total_distance
 ------------------------------------------------------------------------------------      
 Copyright  Ready2Ride  2017 & 2018  
    
 PROCESSES        
    
 MODIFICATIONS        
 Date			 Author			Work Tracker Id				Description          
 -----------------------------------------------------------------------------------------------------------        
 12/11/2019	     siva.m         Created					to get ride distance of cycle
 -----------------------------------------------------------------------------------------------------------      
    
*/ 
BEGIN
		-- Declare the return variable here
		DECLARE @total_distance decimal(10,2) = 0;

		
		
		;with cteRideLog
		as
		(SELECT
					isnull([ride].[get_ride_log_distance](rr.ride_log),0) as distance
			FROM 
					ride.ride rr with(nolock,readuncommitted) 
					inner join ride.ride_type rrt with(nolock,readuncommitted)
					on rr.ride_type_id = rrt.ride_type_id

			where 
					rr.is_deleted = 0  
					and rr.is_ride_saved = 1 
					and owner_id = @owner_id
					and cycle_id = @cycle_id)

					select  
				@total_distance = cast(sum(distance) as decimal)
		  from cteRideLog
		  where isnumeric(distance) = 1
		set @total_distance = cast(isnull(@total_distance, 0) as decimal)

				
	RETURN @total_distance

END

GO
/****** Object:  UserDefinedFunction [dbo].[fnCalcDistanceMiles]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fnCalcDistanceMiles] (@Lat1 decimal(18,9), @Long1 decimal(18,9), @Lat2 decimal(18,9), @Long2 decimal(18,9))
returns decimal (18,9) as
begin
declare @d decimal(28,10)
-- Convert to radians
set @Lat1 = @Lat1 / 57.2958
set @Long1 = @Long1 / 57.2958
set @Lat2 = @Lat2 / 57.2958
set @Long2 = @Long2 / 57.2958
-- Calc distance
set @d = (Sin(@Lat1) * Sin(@Lat2)) + (Cos(@Lat1) * Cos(@Lat2) * Cos(@Long2 - @Long1))
-- Convert to miles
if @d <> 0
begin
set @d = 3958.75 * Atan(Sqrt(1 - power(@d, 2)) / @d);
end
return @d
end 
GO
/****** Object:  UserDefinedFunction [dbo].[get_distance_by_lat_long]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[get_distance_by_lat_long] 
(
	@start_lat varchar(20),
	@start_lng  varchar(20),
	@end_lat  varchar(20),
	@end_lng  varchar(20)
)
RETURNS float
AS
/*

 select [dbo].[get_distance_by_lat_long](17.4380,78.3952,'17.4472','78.3778') as distance
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
	 DECLARE @orig_lat  decimal(12, 9)
	 DECLARE @orig_lng  decimal(12, 9)
	 DECLARE @dest_lat  decimal(12, 9)
	 DECLARE @dest_lng  decimal(12, 9)

	 if(isnumeric(@start_lat) = 1)
		begin
			set @orig_lat = cast(@start_lat as decimal(12,9))
		end
	 else
		begin
			set @orig_lat = null
		end

	if(isnumeric(@start_lng) = 1)
		begin
			set @orig_lng = cast(@start_lng as decimal(12,9))
		end
	else
		begin
			set @orig_lng = null
		end

	if(isnumeric(@end_lat) = 1)
		begin
			set @dest_lat = cast(@end_lat as decimal(12,9))
		end
	else
		begin
			set @dest_lat = null
		end

	if(isnumeric(@end_lng) = 1)
		begin
			set @dest_lng = cast(@end_lng as decimal(12,9))
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
/****** Object:  UserDefinedFunction [dbo].[get_distinct_comma_seperated_ids]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[get_distinct_comma_seperated_ids] 
(
	@ids varchar(max)
	
)
RETURNS  varchar(max)
AS
BEGIN

    declare @distinct_list_ids varchar(max);

	set @ids = isnull(@ids, '')

	;WITH distinct_lists as (
		select 
			distinct ltrim(rtrim(value)) as value
		from 
			string_split(@ids, ',')
		where
			value <> ''
	)
	select  @distinct_list_ids = ISNULL(STUFF((SELECT ',' + value FROM distinct_lists order by value asc
												FOR XML PATH('')), 1, 1, ''), '')

	Return @distinct_list_ids

END
GO
/****** Object:  UserDefinedFunction [dbo].[GetNumeric]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetNumeric]
(
	@string nvarchar(max)
)
RETURNS nvarchar(max)
AS
BEGIN

	declare @integer int

	set @integer = patindex('%[^0-9]%', @string)

	BEGIN
		WHILE @integer > 0
			BEGIN
				SET @string = stuff(@string, @integer, 1, '' )
				SET @integer = patindex('%[^0-9]%', @string )
			END
		END
	RETURN ISNULL(@string,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[ph_format]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ph_format] 
(
	@phone_number varchar(20)
)
RETURNS varchar(10)
AS
/*
 select [dbo].ph_format('+919912312311')
 -------------------------------------------         
 Copyright 2017 & 2018  

 PURPOSE        
formst phone
    
 PROCESSES        
    
 MODIFICATIONS        
 Date			 Author			Work Tracker Id				Description          
 -------------------------------------------------------------------------------------        
 08/21/2018	  Power Sports        Created
 --------------------------------------------------------------------------------------      
    
*/ 
BEGIN
	 return case when len(replace(replace(replace(replace(replace(isnull(@phone_number,''),'-',''),'(',''),')',''),'+',''),' ','')) = 12 
				 then SUBSTRING(replace(replace(replace(replace(replace(isnull(@phone_number,''),'-',''),'(',''),')',''),'+',''),' ',''),3,10)
				 when len(replace(replace(replace(replace(replace(isnull(@phone_number,''),'-',''),'(',''),')',''),'+',''),' ','')) = 11 
				 then SUBSTRING(replace(replace(replace(replace(replace(isnull(@phone_number,''),'-',''),'(',''),')',''),'+',''),' ',''),2,10)  
				 else replace(replace(replace(replace(replace(isnull(@phone_number,''),'-',''),'(',''),')',''),'+',''),' ','')
				 end
END
GO
/****** Object:  UserDefinedFunction [dbo].[segment_id_format]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[segment_id_format] 
(
	@owner_id int = 0,
	@segment_id int
)
RETURNS varchar(20)
AS
/*
 select [dbo].[segment_id_format](5,-1) 
 -------------------------------------------         
 Copyright 2017 & 2018  

 PURPOSE        
formst phone
    
 PROCESSES        
    
 MODIFICATIONS        
 Date			 Author			Work Tracker Id				Description          
 -------------------------------------------------------------------------------------        
 08/21/2018	  Power Sports        Created
 --------------------------------------------------------------------------------------      
    
*/ 
BEGIN

	DECLARE @contact_list_ids varchar(max);
	DECLARE @listStr varchar(max);

	IF(@owner_id = 0)
	  BEGIN
		IF(@segment_id = -1)
		 SET @contact_list_ids = '-1'
		ELSE
		 SET @contact_list_ids = '-1' + ',' + CAST(@segment_id as varchar(10));
	  END
	ELSE
	 BEGIN
	  SELECT top(1) @contact_list_ids = contact_list_ids from owner.owner where owner_id = @owner_id

	   SET @contact_list_ids = @contact_list_ids + ',' + CAST(@segment_id as varchar(10))

	   SELECT @listStr = COALESCE(@listStr+',' ,'') + CAST(LTRIM(RTRIM(Value)) as varchar(10)) 
						 FROM (SELECT DISTINCT Value FROM String_Split(@contact_list_ids,',')) d

		SET @contact_list_ids = @listStr
	 END
	 RETURN @contact_list_ids
END
GO
/****** Object:  UserDefinedFunction [message].[get_chat_id]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [message].[get_chat_id] 
(
	@sender_id int,
	@receiver_id int,
	@sender varchar(100),
	@receiver varchar(100)
)
RETURNS  int
AS
BEGIN
    Declare @chat_id int = 0;
	Declare @is_owner bit = 0;
	Declare @chat_type_id bit = 0;

	set @is_owner = case when @sender = 'owner' then 1 else 0 end

	set @chat_type_id = case when @sender = 'owner' and @receiver = 'owner' then 2 else 1 end

	;WITH sender_chats AS
     (
		select 
			  mcl.* 
		from 
			message.clients mcl with(nolock,readuncommitted)
			inner join message.chat mc with(nolock,readuncommitted)
			on mcl.chat_id = mc.chat_id
		where 
			 mcl.user_id = @sender_id 
			 and mcl.is_owner = @is_owner
			 and mcl.is_deleted = 0 
			 and mc.is_deleted = 0
     ),
     chat_receivers AS
     (
       select 
			 mcl.* 
	   from 
			message.clients mcl with(nolock,readuncommitted)
			inner join sender_chats sc with(nolock,readuncommitted)
			on sc.chat_id = mcl.chat_id 
	   where 
			mcl.is_deleted = 0 
			and mcl.user_id <> @sender_id
     )
	 select 
		  top 1 @chat_id = chat_id 
	 from 
		 chat_receivers with(nolock,readuncommitted)
	 where 
		 user_id = @receiver_id
		 and is_owner = case when @receiver = 'owner' then 1 else 0 end

	set @chat_id = isnull(@chat_id,0)

	Return @chat_id

END
GO
/****** Object:  UserDefinedFunction [owner].[get_distinct_contact_list_ids]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [owner].[get_distinct_contact_list_ids] 
(
	@contact_list_ids varchar(max)
	
)
RETURNS  varchar(max)
AS
BEGIN

    declare @distinct_contact_list_ids varchar(max);

	set @contact_list_ids = replace(@contact_list_ids, '''', '')

	set @contact_list_ids = '-1,' + @contact_list_ids

	;WITH distinct_lists as (
		select 
			distinct ltrim(rtrim(value)) as value
		from 
			string_split(@contact_list_ids, ',')
		where
			ltrim(rtrim(value)) <> ''
	)
	select 
	   @distinct_contact_list_ids = ISNULL(STUFF((SELECT ',' + value FROM distinct_lists
				FOR XML PATH('')), 1, 1, ''), '')

	Return @distinct_contact_list_ids

END
GO
/****** Object:  UserDefinedFunction [owner].[get_ids]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [owner].[get_ids] 
(
	@contact_list_ids varchar(max),
	@segment_id int
	
)
RETURNS  varchar(max)
AS
BEGIN

    declare @distinct_contact_list_ids varchar(max);

	set @contact_list_ids = replace(@contact_list_ids, '''', '')

	set @contact_list_ids = '-1,' + @contact_list_ids

	;WITH distinct_lists as (
		select 
			distinct ltrim(rtrim(value)) as value
		from 
			string_split(@contact_list_ids, ',')
		where
			value <> ''
			and value <> @segment_id
	)
	select 
	   @distinct_contact_list_ids = ISNULL(STUFF((SELECT ',' + value FROM distinct_lists
				FOR XML PATH('')), 1, 1, ''), '')

	Return ltrim(rtrim(@distinct_contact_list_ids))

END
GO
/****** Object:  UserDefinedFunction [owner].[is_selected_dealer_check]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [owner].[is_selected_dealer_check] 
(
	@dealer_id int,
	@owner_id int
	
)
RETURNS  bit
AS
BEGIN
    Declare @count int = 0;
	Declare @is_exist bit = 0;

	select 
	       @count = count(ood.owner_dealer_id) 
    from 
	     [owner].[owner_dealers] ood with(nolock,readuncommitted) 
	where 
	     ood.dealer_id = @dealer_id and 
		 ood.owner_id = @owner_id and 
		 ood.is_deleted = 0

		if(isnull(@count,0)>0)
		  begin
			set @is_exist = 1;
		  end
		else
		  begin
			set @is_exist = 0;
		  end

	Return @is_exist

END
GO
/****** Object:  UserDefinedFunction [ride].[get_avg_speed]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [ride].[get_avg_speed]
(
	-- Add the parameters for the function here
	@distance decimal(10,2),
	@time decimal(10,2)
)
RETURNS decimal(10,2)
AS
BEGIN
		-- Declare the return variable here
		DECLARE @result_text decimal(10,2)

		set @time = isnull(@time,0)

		if(@distance is not null and @time is not null and @time >= 1)
			begin

				set @result_text = cast((@distance/cast(cast(@time as float) as decimal(10,2))) as decimal(10,2))

			end
		else
			begin
				set @result_text = 0.00
			end

	RETURN @result_text

END

GO
/****** Object:  UserDefinedFunction [ride].[get_ride_distance]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [ride].[get_ride_distance]
(
	-- Add the parameters for the function here
	@ride_log nvarchar(max)
)
RETURNS nvarchar(max)
AS
BEGIN
		-- Declare the return variable here
		DECLARE @total_distance nvarchar(max) = 0;

		set @ride_log = nullif(ltrim(rtrim(@ride_log)),'')

		;with cteRideLog
		as
		(
		SELECT *  
			FROM OPENJSON(@ride_log)  
			  WITH (
					 distance decimal(10,2) '$.Distance'
				   )  
		) select  
				@total_distance = sum(distance)
		  from cteRideLog

	set @total_distance = isnull(@total_distance, 0)

	RETURN @total_distance

END

GO
/****** Object:  UserDefinedFunction [ride].[get_ride_duration]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [ride].[get_ride_duration]
(
	-- Add the parameters for the function here
	@start_date datetime,
	@end_date datetime
)
RETURNS nvarchar(max)
AS
BEGIN
		-- Declare the return variable here
		declare @result_text nvarchar(max)
		declare @time int = 0 

		set @time = DATEDIFF(SECOND, @start_date,@end_date)

		set @time = isnull(@time,0)

		if(@time is not null and @time <> 0)
			begin

				set @result_text = case when CAST(@time / 3600 AS int) < 10 then RIGHT('0' + CAST(@time / 3600 AS varchar),2) + ':' +
										RIGHT('0' + CAST((@time / 60) % 60 AS varchar),2) + ':' +
										RIGHT('0' + CAST(@time % 60 AS varchar),2)
										else CAST(@time / 3600 AS varchar) + ':' +
										RIGHT('0' + CAST((@time / 60) % 60 AS varchar),2) + ':' +
										RIGHT('0' + CAST(@time % 60 AS varchar),2) end	
											
				   
			end
		else
			begin
				set @result_text = '00:00:00'
			end

	RETURN @result_text

END

GO
/****** Object:  UserDefinedFunction [ride].[get_ride_happend]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [ride].[get_ride_happend]
(
	-- Add the parameters for the function here
	@end_date datetime
)
RETURNS nvarchar(max)
AS
BEGIN
	-- Declare the return variable here
	-- select ride.get_ride_happend(getdate() - 1) as ride_happend
	DECLARE @result_text nvarchar(max)
	DECLARE @time int

	if(@end_date is not null and isdate(@end_date) = 1)
		Begin
			set @result_text = ( SELECT 
									  CASE 
										WHEN DATEDIFF(SECOND, @end_date, GETDATE()) < 60 THEN CAST(DATEDIFF(SECOND, @end_date, GETDATE()) AS VARCHAR(10)) + ' sec ago'
										WHEN DATEDIFF(MINUTE, @end_date, GETDATE()) < 60 THEN CAST(DATEDIFF(MINUTE, @end_date, GETDATE()) AS VARCHAR(10)) + ' mi ago'
										WHEN DATEDIFF(HOUR, @end_date, GETDATE()) < 24 THEN CAST(FLOOR(DATEDIFF(HOUR, @end_date, GETDATE())) AS VARCHAR(10)) + ' h ago'
										WHEN DATEDIFF(DAY, @end_date, GETDATE()) <= 30  THEN CAST(FLOOR(DATEDIFF(DAY, @end_date, GETDATE())) AS VARCHAR(10)) + ' d ago'
										WHEN DATEDIFF(MONTH, @end_date, GETDATE()) < 12 THEN CAST(FLOOR(DATEDIFF(MONTH, @end_date, GETDATE())) AS VARCHAR(10)) + ' m ago'
										WHEN DATEDIFF(YEAR, @end_date, GETDATE()) = 0 THEN '1 year ago'
										ELSE CAST(FLOOR(DATEDIFF(YEAR, @end_date, GETDATE())) AS VARCHAR(10)) + ' year ago'
									END
								)
		End
	else
		Begin
			set @result_text = '0 sec ago'
		End

	RETURN @result_text

END

GO
/****** Object:  UserDefinedFunction [ride].[get_ride_log_distance]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [ride].[get_ride_log_distance]
(
	-- Add the parameters for the function here
	@ride_log nvarchar(max)
)
RETURNS decimal(10,2)
AS
BEGIN
		-- Declare the return variable here
		DECLARE @total_distance decimal(10,2) = 0;

		set @ride_log = nullif(ltrim(rtrim(@ride_log)),'')

		;with cteRideLog
		as
		(
		SELECT *  
			FROM OPENJSON(@ride_log)  
			  WITH (
					 distance decimal(10,2) '$.Distance'
				   )  
		) select  
				@total_distance = cast(sum(distance) as decimal)
		  from cteRideLog
		  where isnumeric(distance) = 1

	set @total_distance = cast(isnull(@total_distance, 0) as decimal)

	RETURN @total_distance

END

GO
/****** Object:  UserDefinedFunction [ride].[get_ride_log_duration]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [ride].[get_ride_log_duration]
(
	-- Add the parameters for the function here
	@ride_log nvarchar(max)
)
RETURNS nvarchar(max)
AS
BEGIN
		-- Declare the return variable here
		declare @time int = 0;
		declare @result_text varchar(20) = '00:00:00';

		set @ride_log = nullif(ltrim(rtrim(@ride_log)),'')

		;with cteRideLog
		as
		(
			SELECT 
				*  
			FROM OPENJSON(@ride_log)  
			WITH (
					time decimal(10,2) '$.Time'
				 )  
		) select  
				@time = sum(time)
		  from cteRideLog

		set @time = isnull(@time, 0)

		if(@time is not null and @time > 0)
			begin

				set @result_text = case when CAST(@time / 3600 AS int) < 10 then RIGHT('0' + CAST(@time / 3600 AS varchar),2) + ':' +
										RIGHT('0' + CAST((@time / 60) % 60 AS varchar),2) + ':' +
										RIGHT('0' + CAST(@time % 60 AS varchar),2)
										else CAST(@time / 3600 AS varchar) + ':' +
										RIGHT('0' + CAST((@time / 60) % 60 AS varchar),2) + ':' +
										RIGHT('0' + CAST(@time % 60 AS varchar),2) end	
											
				   
			end
		else
			begin
				set @result_text = '00:00:00'
			end

	RETURN @result_text

END

GO
/****** Object:  UserDefinedFunction [ride].[get_ride_log_time]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [ride].[get_ride_log_time]
(
	-- Add the parameters for the function here
	@ride_log nvarchar(max)
)
RETURNS int
AS
BEGIN
		-- Declare the return variable here
		declare @time int = 0;

		set @ride_log = nullif(ltrim(rtrim(@ride_log)),'')

		;with cteRideLog
		as
		(
			SELECT 
				*  
			FROM OPENJSON(@ride_log)  
			WITH (
					time decimal(10,2) '$.Time'
				 )  
		) select  
				@time = sum(time)
		  from cteRideLog

		set @time = isnull(@time, 0)

	RETURN @time

END

GO
/****** Object:  UserDefinedFunction [ride].[get_ride_log_time_by_cycle_id]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [ride].[get_ride_log_time_by_cycle_id]
(
	-- Add the parameters for the function here
	@cycle_id int,
	@owner_id int
)
RETURNS varchar(50)
AS
BEGIN
		-- Declare the return variable here
		declare @time int = 0;
		declare @result_text varchar(50)

		set @time =  ( select 
								ABS(SUM(isnull([ride].[get_ride_log_time](rr.ride_log),0)))
							  from 
								  ride.ride rr with (nolock,readuncommitted)
								  left join ride.ride_type rrt  with (nolock,readuncommitted)
								  on rrt.ride_type_id = rr.ride_type_id
							  where 
								  cycle_id = @cycle_id and 
								  owner_id = @owner_id and
								  rr.is_ride_saved = 1 and
								  rr.is_deleted = 0
						    )

		set @time = isnull(@time,0)
		
		if(@time is not null and @time <> 0)
			begin

				set @result_text = case when CAST(@time / 3600 AS int) < 10 then RIGHT('0' + CAST(@time / 3600 AS varchar),2) + ':' +
										RIGHT('0' + CAST((@time / 60) % 60 AS varchar),2) + ':' +
										RIGHT('0' + CAST(@time % 60 AS varchar),2)
										else CAST(@time / 3600 AS varchar) + ':' +
										RIGHT('0' + CAST((@time / 60) % 60 AS varchar),2) + ':' +
										RIGHT('0' + CAST(@time % 60 AS varchar),2) end	
											
				   
			end
		else
			begin
				set @result_text = '00:00:00'
			end

	RETURN @result_text

END

GO
/****** Object:  UserDefinedFunction [ride].[get_ride_speed]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [ride].[get_ride_speed]
(
	-- Add the parameters for the function here
	@distance decimal(10,2),
	@time decimal(10,2)
)
RETURNS decimal(10,2)
AS
BEGIN
		-- Declare the return variable here
		DECLARE @result_text decimal(10,2)

		if(@distance is not null and @time is not null and @time >= 1)
			begin

				set @result_text = cast((@distance)/cast(cast(isnull((@time),0) as float) as decimal(10,2)) as decimal(10,2))

			end
		else
			begin
				set @result_text = 0.00
			end

	RETURN @result_text

END

GO
/****** Object:  UserDefinedFunction [ride].[get_ride_time_from_seconds]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [ride].[get_ride_time_from_seconds]
(
	-- Add the parameters for the function here
	@time int

)
RETURNS varchar(50)
AS
BEGIN
		-- Declare the return variable here
		declare @result_text varchar(50)

		if(@time is not null and @time <> 0)
			begin

				set @result_text = case when CAST(@time / 3600 AS int) < 10 then RIGHT('0' + CAST(@time / 3600 AS varchar),2) + ':' +
										RIGHT('0' + CAST((@time / 60) % 60 AS varchar),2) + ':' +
										RIGHT('0' + CAST(@time % 60 AS varchar),2)
										else CAST(@time / 3600 AS varchar) + ':' +
										RIGHT('0' + CAST((@time / 60) % 60 AS varchar),2) + ':' +
										RIGHT('0' + CAST(@time % 60 AS varchar),2) end	
											
				   
			end
		else
			begin
				set @result_text = '00:00:00'
			end

	RETURN @result_text

END


GO
/****** Object:  UserDefinedFunction [ride].[get_total_ride_time]    Script Date: 1/25/2022 4:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create FUNCTION [ride].[get_total_ride_time]
(
	-- Add the parameters for the function here
	@start_date datetime,
	@end_date datetime
)
RETURNS int
AS
BEGIN
		-- Declare the return variable here
		DECLARE @result_text int

		if(@start_date is not null and @end_date is not null)
			begin

				set @result_text = cast(datediff(ss, @start_date,@end_date) as int)
					   
			end
		else
			begin
				set @result_text = 0
			end

	RETURN @result_text

END
GO

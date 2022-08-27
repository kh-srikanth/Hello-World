USE [auto_mobile]
GO
/****** Object:  StoredProcedure [portal].[get_dealer_details]    Script Date: 1/25/2022 4:45:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[get_dealer_details]
       
	@dealer_id int = null,
	@latitude decimal (12, 9)=null,
	@longitude decimal (12, 9)=null,
	@owner_id int = null  

AS        
      
/*
	exec  [portal].[get_dealer_details] 0,0,0,0
	 ------------------------------------------------------------         
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2018     Ready2Ride                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 
  	SET NOCOUNT ON 
 
		BEGIN        

			if(@dealer_id <> 0)      

				 begin
					SELECT  
					      isnull(pd.dealer_id,0) as dealer_id,
						  isnull(pdh.parent_dealer_hierarchy_id,0) as parent_dealer_hierarchy_id,
						  isnull(pdh.dealer_hierarchy_id,0) as dealer_hierarchy_id,
						  isnull(pd.dealer_name,'') as dealer_name,
						  isnull((select email from r2r_portal.dbo.Users du inner join r2r_portal.portal.user_claims puc on du.UserId = puc.user_id and puc.claim_type_id = 1 and puc.claim_value = pd.dealer_id and email is not null),'') as email, 
						  isnull(pd.dealer_phone,'') as dealer_phone,
						  isnull(pd.custom_image_path,'') as background_image,
						  isnull(pd.web_site,'') as web_site,
						  isnull(pd.dealer_latitude,0) as dealer_latitude,
						  isnull(pd.dealer_longitude,0) as dealer_longitude,
						  isnull(([dbo].[get_distance_by_lat_long](@latitude,@longitude,CAST(pd.dealer_latitude AS decimal(12, 9)),CAST(pd.dealer_longitude AS decimal(12, 9)))/1609.34),0) as dealer_distance,
						  isnull(pddd.address1,'') as street_address,
					      isnull((select state_name from area.states where state_code=pddd.state_code),'') as state_name,    
						  isnull(pddd.city,'') as city,
						  isnull(pddd.zipcode,'') as zip_code,
						  isnull((select top 1 is_default from owner.owner ow with(nolock,readuncommitted) where dealer_id = pd.dealer_id and owner_id = @owner_id and is_deleted = 0 order by is_default desc),0) as is_default,
						  [owner].[is_selected_dealer_check](pd.dealer_id,@owner_id)  as is_selected
					  FROM portal.dealer pd with(nolock,readuncommitted)
					  inner join portal.dealer_dept_details pddd with(nolock,readuncommitted)
					  on pd.dealer_id = pddd.dealer_id
					  inner join r2r_portal.portal.dealer_hierarchy pdh with(nolock,readuncommitted)
					  on pdh.dealer_id = pd.dealer_id
					  WHERE  pd.dealer_id = @dealer_id  and 
							 pd.is_deleted = 0
							 and isnull(pd.is_oem,0) = 0
							 and pd.is_approved = 1
							 and len(pd.dealer_name)>0							 
							
		   UNION ALL 

					SELECT  
					      isnull(pd.dealer_id,0) as dealer_id,
						  isnull(pdh.parent_dealer_hierarchy_id,0) as parent_dealer_hierarchy_id,
						  isnull(pdh.dealer_hierarchy_id,0) as dealer_hierarchy_id,
						  isnull(pd.dealer_name,'') as dealer_name,
						  isnull((select top 1 email from r2r_portal.dbo.Users du inner join r2r_portal.portal.user_claims puc on du.UserId = puc.user_id and puc.claim_type_id = 1 and puc.claim_value = pd.dealer_id and email is not null),'') as email, 
						  isnull(pd.dealer_phone,'') as dealer_phone,
						  isnull(pd.custom_image_path,'') as background_image,
						  isnull(pd.web_site,'') as web_site,
						  isnull(pd.dealer_latitude,0) as dealer_latitude,
						  isnull(pd.dealer_longitude,0) as dealer_longitude,
						  isnull(([dbo].[get_distance_by_lat_long](@latitude,@longitude,CAST(pd.dealer_latitude AS decimal(12, 9)),CAST(pd.dealer_longitude AS decimal(12, 9)))/1609.34),0) as dealer_distance,
						  isnull(pddd.address1,'') as street_address,
					      isnull((select top 1 state_name from area.states where state_code=pddd.state_code),'') as state_name,    
						  isnull(pddd.city,'') as city,
						  isnull(pddd.zipcode,'') as zip_code,
						  isnull((select top 1 is_default from owner.owner ow with(nolock,readuncommitted) where dealer_id = pd.dealer_id and owner_id = @owner_id and is_deleted = 0 order by is_default desc),0) as is_default,
						  [owner].[is_selected_dealer_check](pd.dealer_id,@owner_id)  as is_selected
					  FROM portal.dealer pd with(nolock,readuncommitted)
					  inner join portal.dealer_dept_details pddd with(nolock,readuncommitted)
					  on pd.dealer_id = pddd.dealer_id
					  inner join r2r_portal.portal.dealer_hierarchy pdh with(nolock,readuncommitted)
					  on pdh.dealer_id = pd.dealer_id
					  WHERE  pd.dealer_id = 4035  
							and pd.is_deleted = 0
							and isnull(pd.is_oem,0) = 0						 
							order by is_default desc,dealer_distance asc 						        
				  end      

			else      

				  begin      

					   SELECT  
					      isnull(pd.dealer_id,0) as dealer_id,
						  isnull(pdh.parent_dealer_hierarchy_id,0) as parent_dealer_hierarchy_id,
						  isnull(pdh.dealer_hierarchy_id,0) as dealer_hierarchy_id,
						  isnull(pd.dealer_name,'') as dealer_name,
						  isnull((select top 1 email from r2r_portal.dbo.Users du inner join r2r_portal.portal.user_claims puc on du.UserId = puc.user_id and puc.claim_type_id = 1 and puc.claim_value = pd.dealer_id and email is not null),'') as email, 
						  isnull(pd.dealer_phone,'') as dealer_phone,   
						  isnull(pd.custom_image_path,'') as background_image,
						  isnull(pd.web_site,'') as web_site,
						  isnull(pd.dealer_latitude,0) as dealer_latitude,
						  isnull(pd.dealer_longitude,0) as dealer_longitude,
						  isnull(([dbo].[get_distance_by_lat_long](@latitude,@longitude,CAST(pd.dealer_latitude AS decimal(12, 9)),CAST(pd.dealer_longitude AS decimal(12, 9)))/1609.34),0) as dealer_distance,
						  isnull(pddd.address1,'') as street_address,
					      isnull((select top 1 state_name from area.states where state_code=pddd.state_code),'') as state_name,    
						  isnull(pddd.city,'') as city,
						  isnull(pddd.zipcode,'') as zip_code,
						  isnull((select top 1 is_default from owner.owner ow with(nolock,readuncommitted) where dealer_id = pd.dealer_id and owner_id = @owner_id and is_deleted = 0 order by is_default desc),0) as is_default,
						  [owner].[is_selected_dealer_check](pd.dealer_id,@owner_id) as is_selected
						  FROM portal.dealer pd with(nolock,readuncommitted)
						  inner join portal.dealer_dept_details pddd with(nolock,readuncommitted)
						  on pd.dealer_id = pddd.dealer_id
						  inner join r2r_portal.portal.dealer_hierarchy pdh with(nolock,readuncommitted)
					  on pdh.dealer_id = pd.dealer_id
						  WHERE pd.is_deleted = 0
							 and isnull(pd.is_oem,0) = 0
							 and pd.is_approved = 1
							 and len(pd.dealer_name)>0

				UNION ALL 

					SELECT  
					      isnull(pd.dealer_id,0) as dealer_id,
						  isnull(pdh.parent_dealer_hierarchy_id,0) as parent_dealer_hierarchy_id,
						  isnull(pdh.dealer_hierarchy_id,0) as dealer_hierarchy_id,
						  isnull(pd.dealer_name,'') as dealer_name,
						  isnull((select top 1 email from r2r_portal.dbo.Users du inner join r2r_portal.portal.user_claims puc on du.UserId = puc.user_id and puc.claim_type_id = 1 and puc.claim_value = pd.dealer_id and email is not null),'') as email, 
						  isnull(pd.dealer_phone,'') as dealer_phone,
						  isnull(pd.custom_image_path,'') as background_image,
						  isnull(pd.web_site,'') as web_site,
						  isnull(pd.dealer_latitude,0) as dealer_latitude,
						  isnull(pd.dealer_longitude,0) as dealer_longitude,
						  isnull(([dbo].[get_distance_by_lat_long](@latitude,@longitude,CAST(pd.dealer_latitude AS decimal(12, 9)),CAST(pd.dealer_longitude AS decimal(12, 9)))/1609.34),0) as dealer_distance,
						  isnull(pddd.address1,'') as street_address,
					      isnull((select top 1 state_name from area.states where state_code=pddd.state_code),'') as state_name,    
						  isnull(pddd.city,'') as city,
						  isnull(pddd.zipcode,'') as zip_code,
						  isnull((select top 1 is_default from owner.owner ow with(nolock,readuncommitted) where dealer_id = pd.dealer_id and owner_id = @owner_id and is_deleted = 0 order by is_default desc),0) as is_default,
						  [owner].[is_selected_dealer_check](pd.dealer_id,@owner_id)  as is_selected
					  FROM portal.dealer pd with(nolock,readuncommitted)
					  inner join portal.dealer_dept_details pddd with(nolock,readuncommitted)
					  on pd.dealer_id = pddd.dealer_id
					  inner join r2r_portal.portal.dealer_hierarchy pdh with(nolock,readuncommitted)
					  on pdh.dealer_id = pd.dealer_id
					  WHERE  pd.dealer_id = 4035  
							and pd.is_deleted = 0
							and isnull(pd.is_oem,0) = 0										 
							order by is_default desc,dealer_distance asc  

				  end       

		END 

    SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [portal].[get_fcm_token_by_dealer_id]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[get_fcm_token_by_dealer_id]

		@dealer_id int
AS        
      
/*
	 exec [portal].[get_fcm_token_by_dealer_id] 4035
	 ------------------------------------------------------------         
    
	 select * from portal.user_fcm       
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2018     Ready2Ride                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 
		
                select
					distinct 
					uf.fcm_token,
					uf.platform,
					uf.owner_id as user_id,
					uf.owner_id as owner_id
				from
					portal.user_fcm uf with(nolock,readuncommitted)
					inner join owner.owner oo with(nolock,readuncommitted)
					on oo.owner_id = uf.owner_id
				where 
					oo.dealer_id = @dealer_id and 
					oo.is_deleted = 0 and 
					uf.is_deleted = 0 and
					len(uf.fcm_token) > 0
					and isnull(uf.device_id,'') <> ''

    SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [portal].[get_fcm_token_by_owner_id]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[get_fcm_token_by_owner_id]

		@owner_id int = 0
AS        
      
/*
	 exec [portal].[get_fcm_token_by_owner_id] 404923
	 ------------------------------------------------------------         
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2018     Ready2Ride                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 
		
                select 
					uf.fcm_token,
					uf.platform,
					uf.owner_id as user_id,
					uf.owner_id
				from
					portal.user_fcm uf with(nolock,readuncommitted)
					inner join owner.owner oo with(nolock,readuncommitted)
					on oo.owner_id = uf.owner_id
				where 
					oo.owner_id = @owner_id 
					and oo.is_deleted = 0 
					and uf.is_deleted = 0 
					and len(uf.fcm_token) > 0 
					and isnull(uf.device_id,'') <> ''

    SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [portal].[get_parking_details]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[get_parking_details]
       
	@latitude decimal(12,9)=null,
	@longitude decimal(12,9)=null  

AS        
      
/*
	 exec  [portal].[get_parking_details] 17.4472,78.3778
	 ------------------------------------------------------------         
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2018     Ready2Ride                           Created
	 -----------------------------------------------------------      
                  Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 
 
		BEGIN        
					SELECT  	
						pp.parking_id,
						pp.parking_name,
						pp.photo_path,
						([dbo].[get_distance_by_lat_long](@latitude,@longitude,pp.parking_lat,pp.parking_lon)/1609.34) as parking_distance

					  FROM r2r_admin.parking.parking pp with(nolock,readuncommitted)
		END 

    SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [portal].[insert_update_user_fcm]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[insert_update_user_fcm]  

    @id int = 0, 
    @user_id int,
	@owner_id int = 0,         
    @fcm_token nvarchar(max),
	@platform char(1),
	@device_id nvarchar(max) = null
    
   
AS        
      
/*
	 exec [portal].[insert_update_user_fcm]  0,404923,0,'asdfgh:Ssdfgh567','A','GHJKS-852-SDF'
	 ------------------------------------------------------------         
	 PURPOSE        
	 select * from portal.user_fcm
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON
	
	declare @device_count int = 0
	
	set  @device_count = ( select
								count(id)
						    from
								portal.user_fcm with(nolock,readuncommitted)
							where
								device_id = @device_id and is_deleted = 0)

	set @device_count = isnull(@device_count,0)

	if(@device_count = 0)
		Begin
			INSERT INTO portal.user_fcm
				(user_id,
				 owner_id,
				 device_id, 
				 fcm_token,
				 platform)      
			VALUES 
				(@user_id,
				 @user_id,
				 @device_id, 
				 @fcm_token,
				 @platform) 
		End

	else
		Begin
			update 
				portal.user_fcm 
			set 
				user_id = @user_id,
				owner_id = @user_id,
				fcm_token = @fcm_token,
				platform = @platform,
				updated_date = getdate()
			where 
				is_deleted = 0 and device_id = @device_id
		End

SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [portal].[insert_update_user_topic]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[insert_update_user_topic]  

    @user_id int,      
    @id int,    
    @topic VARCHAR(100),
	@platform char(1),
	@device_id nvarchar(max) = null    
    
   
AS        
      
/*
	 exec [portal].[insert_update_user_topic]  1,'akshaykumar.druva@gmail.com','8867283510'
	 ------------------------------------------------------------         
	 PURPOSE        
	 Insert mobile
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker id     Description          
	 -----------------------------------------------------------        
	 06/25/2019    Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

	declare @device_count int = 0
	
	set  @device_count = ( select
								count(id)
						    from
								portal.user_topics with(nolock,readuncommitted)
							where
								device_id = @device_id and is_deleted = 0)

	set @device_count = isnull(@device_count,0)

	if(@device_id = 0)
		Begin
			INSERT INTO portal.user_topics
				(user_id, 
				 topic,
				 device_id,
				 platform)      
			VALUES 
				(@user_id,
				 @topic,
				 @device_id,
				 @platform) 
		End

	else
		Begin
		update portal.user_topics
		set 
			user_id = @user_id,
			topic = @topic
		where 
			is_deleted = 0 and device_id = @device_id
		End

SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [portal].[upate_is_lime_opted_in_by_owner_id]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[upate_is_lime_opted_in_by_owner_id]
   
   @mobile varchar(50),
   @owner_id int,
   @is_lime_opted_in bit    

AS        
      
/*
	 exec  [portal].[upate_is_lime_opted_in_by_owner_id] 
	 ------------------------------------------------------------         
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2018     Ready2Ride                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 

	  declare @segment_id int
	  declare @dealer_id int
	  declare @seg_is_exist int
	  declare @contact_list_ids nvarchar(100)


	set @dealer_id = (	select
							dealer_id
						from
							owner.owner with(nolock,readuncommitted)
						where
							owner_id = @owner_id)

	set @segment_id = (	select
							contact_list_id
						from
							owner.contact_list with(nolock,readuncommitted)
						where
							is_deleted = 0 and
							dealer_id = @dealer_id and
							is_default = 1 and
							list_name = 'All SMS Subscribers')


         update 
		     owner.owner
         set
	        mobile = @mobile,
	        is_lime_opted_in = @is_lime_opted_in
         where
	       owner_id = @owner_id

	if(@segment_id is not null and @is_lime_opted_in = 1)
	begin

		set @contact_list_ids = (	select
										contact_list_ids
									from
										owner.owner with(nolock,readuncommitted)
									where
										owner_id = @owner_id)
		
		set @seg_is_exist = (	select
									CHARINDEX(cast(@segment_id as varchar(20)), @contact_list_ids))

		if(@seg_is_exist = 0)
		begin
			update owner.owner
			set
				contact_list_ids = concat(contact_list_ids ,',' , CAST(@segment_id as varchar(20)))
			where
				owner_id = @owner_id
		end
	end

END
	 


GO
/****** Object:  StoredProcedure [ride].[get_comments]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [ride].[get_comments]  

@rated_route_id int

AS        
      
/*
	 exec  [ride].[get_comments] 23
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Data
	     
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 03/27/2020     Mohan                           Created
	 -----------------------------------------------------------      
                   Copyright 2019 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

	select  
	     isnull(oo.fname + oo.lname,'') as profile_name,
		 isnull(oo.photo_path,'') as profile_pic,
	     rrc.routed_id,
		 rrc.comment,
		 rrc.created_dt,
		 ride.get_ride_happend(rrc.created_dt) as comment_happend
     from
	    ride.routes_comments rrc
		inner join [ride].[rated_routes] rrr 
		on rrc.routed_id = rrr.routed_id
		inner join owner.owner oo on
		rrc.owner_id = oo.owner_id
     where 
	    rrc.routed_id = @rated_route_id
		and rrc.is_deleted = 0
		and rrr.is_deleted = 0 order by created_dt desc

	SET NOCOUNT OFF

END



GO
/****** Object:  StoredProcedure [ride].[get_ride_details_by_id]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [ride].[get_ride_details_by_id]  
	  @ride_id int
AS        
      
/*
	 exec  [ride].[get_ride_details_by_id]   3987
	 ----------------------------------------------
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 10/16/2019     Raviteja                        Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 

	SET NOCOUNT ON 

	SELECT TOP 1
		isnull(rr.ride_id, 0) as ride_id,
		isnull(rr.cycle_id, 0) as cycle_id,
		isnull(rr.name,'') as ride_name,
		isnull(rrt.name,'') as ride_type_name,
		isnull(rr.description,'') as ride_description,
		isnull(rr.owner_id,0) as owner_id,
		isnull(rr.start_geo_lat,'') as start_geo_lat,
		isnull(rr.start_geo_lon,'') as start_geo_lon,
		isnull(rr.end_geo_lat,'') as end_geo_lat,
		isnull(rr.end_geo_long,'') as end_geo_long,
		isnull(rr.start_date,'') as start_date,
		isnull(rr.end_date,'') as end_date
	from 
		ride.ride rr with (nolock,readuncommitted)
		left join ride.ride_type rrt  with (nolock,readuncommitted) on 
			rrt.ride_type_id = rr.ride_type_id
	where  
		rr.is_deleted = 0 
		and rr.is_ride_saved = 1
		and rr.ride_id = @ride_id
		 
SET NOCOUNT OFF

	END
GO
/****** Object:  StoredProcedure [ride].[get_ride_lat_lng_log]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE procedure [ride].[get_ride_lat_lng_log]

	 @ride_id int = null
	
	AS

/* 
	exec [ride].[get_ride_lat_lng_log] 3
	------------------------------------  
	
	select * from ride.ride where ride_id = 3498
	   
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	------------------------------------------------------------    
    06/07/2019      Warrous       R2R MObile                      
	-------------------------------------------------------------
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 SET NOCOUNT ON;

	declare @ride_log nvarchar(max) = null

	set @ride_log = (select top 1 ride_log from ride.ride with(nolock,readuncommitted) where ride_id = @ride_id)

 IF(isnull(@ride_id,0) > 0)
 BEGIN

	;with cteRideLatLog
		as
		(
		SELECT *  
			FROM OPENJSON(@ride_log)  
			  WITH (ride_id int '$.RideId',  
					sub_ride_id int '$.SubRideId',
					start_latitude decimal(9,6) '$.StartLatitude',  
					start_longitude decimal(9,6) '$.StartLongitude',  
					end_latitude decimal(9,6) '$.EndLatitude',
					end_longitude decimal(9,6) '$.EndLongitude',  
					distance decimal(10,2) '$.Distance',  
					time decimal(10,2) '$.Time',
					speed decimal(10,2) '$.Speed',  
					color varchar(10) '$.Color',
					is_paused bit '$.IsPaused')  
		) select
				isnull(start_latitude,0) as latitude, 
				isnull(start_longitude,0) as longitude,
				end_latitude as end_latitude,
				end_longitude as end_longitude,
				isnull(is_paused,0) as is_paused,
				color as color  
		  from cteRideLatLog 

 END
 ELSE 
 BEGIN
		;with cteRideLatLog
		as
		(
		SELECT *  
			FROM OPENJSON(@ride_log)  
			  WITH (ride_id int '$.RideId',  
					sub_ride_id int '$.SubRideId',
					start_latitude decimal(9,6) '$.StartLatitude',  
					start_longitude decimal(9,6) '$.StartLongitude',  
					end_latitude decimal(9,6) '$.EndLatitude',
					end_longitude decimal(9,6) '$.EndLongitude',  
					distance decimal(10,2) '$.Distance',  
					time decimal(10,2) '$.Time',
					speed decimal(10,2) '$.Speed',  
					color varchar(10) '$.Color',
					is_paused bit '$.IsPaused')   
		) select 
				isnull(start_latitude,0) as latitude, 
				isnull(start_longitude,0) as longitude,
				end_latitude as end_latitude,
				end_longitude as end_longitude,
				isnull(is_paused,0) as is_paused,
				color as color  
		  from cteRideLatLog 
 END
GO
/****** Object:  StoredProcedure [ride].[get_ride_log]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE procedure [ride].[get_ride_log]

	 @ride_id int = null
	
	AS

/* 
	exec [ride].[get_ride_log] 10068
	--------------------------------     
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	-------------------------------------------------------------  
    06/07/2019      Warrous       R2R MObile       get ride log                
	-------------------------------------------------------------
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 SET NOCOUNT ON;

	declare @ride_log nvarchar(max) = null

	set @ride_log = (select top 1 ride_log from ride.ride with(nolock,readuncommitted) where ride_id = @ride_id)

	set @ride_log = nullif(ltrim(rtrim(@ride_log)),'')

 IF(isnull(@ride_id,0) > 0)
 BEGIN

	;with cteRideLog
		as
		(
		SELECT *  
			FROM OPENJSON(@ride_log)  
			  WITH (ride_id int '$.RideId',  
					sub_ride_id int '$.SubRideId',
					start_latitude decimal(9,6) '$.StartLatitude',  
					start_longitude decimal(9,6) '$.StartLongitude',  
					end_latitude decimal(9,6) '$.EndLatitude',
					end_longitude decimal(9,6) '$.EndLongitude',  
					distance decimal(10,2) '$.Distance',  
					time decimal(10,2) '$.Time',
					speed decimal(10,2) '$.Speed',  
					color varchar(10) '$.Color',
					is_paused bit '$.IsPaused')  
		) select  
				sum(distance) as distance,
				sum(time) as time,
				max(speed) as speed,
				ride.get_ride_time_from_seconds(isnull(sum(time),0)) as duration,
				ride.get_avg_speed(isnull(sum(speed),0), isnull(count(speed),0)) as avg_speed, 
				isnull(max(cast(is_paused AS tinyint)),1) as is_paused,
				max(color) as color  
		  from cteRideLog group by sub_ride_id 

 END
 ELSE 
 BEGIN
		;with cteRideLog
		as
		(
		SELECT *  
			FROM OPENJSON(null)  
			  WITH (ride_id int '$.RideId',  
					sub_ride_id int '$.SubRideId',
					start_latitude decimal(9,6) '$.StartLatitude',  
					start_longitude decimal(9,6) '$.StartLongitude',  
					end_latitude decimal(9,6) '$.EndLatitude',
					end_longitude decimal(9,6) '$.EndLongitude',  
					distance decimal(10,2) '$.Distance',  
					time decimal(10,2) '$.Time',
					speed decimal(10,2) '$.Speed',  
					color varchar(10) '$.Color',
					is_paused bit '$.IsPaused')  
		) select  
				sum(distance) as distance,
				sum(time) as time,
				max(speed) as speed,
				ride.get_ride_time_from_seconds(isnull(sum(time),0)) as duration,
				ride.get_avg_speed(isnull(sum(distance),0),isnull(sum(time),0)) as avg_speed, 
				isnull(MAX(CAST(is_paused AS tinyint)),1) as is_paused,
				max(color) as color 
		  from cteRideLog group by sub_ride_id 
 END
GO
/****** Object:  StoredProcedure [ride].[get_ride_media]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [ride].[get_ride_media]  

	  @ride_id int
	 	  
AS        
      
/*
	 exec   [ride].[get_ride_media]  3
	 ------------------------------------------------------------         
	 PURPOSE        
	Create/Edit Promotion
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/04/2020     siva                          Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 

    select 
	      ride_id,
		  media_type_id,
		  media_url,
		  thumbnail
    from
	    [ride].[ride_media] with(nolock,readuncommitted)
   where
        ride_id = @ride_id
		and is_deleted = 0
		
	
END


GO
/****** Object:  StoredProcedure [ride].[get_routes_by_route_id]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [ride].[get_routes_by_route_id]  

@route_id int,
@owner_id int = null

AS        
      
/*
		 exec  [ride].[get_routes_by_route_id]  24
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Data
	     
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 03/27/2020     Mohan                           Created
	 -----------------------------------------------------------      
                   Copyright 2019 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

               Select top 1
			        z.*,
					case when s.routed_id=@route_id and s.owner_id = @owner_id then 'Yes' else 'No' end as is_Rating 
		       from 
			        (
					  select
					        x.routed_id, 
							x.routed_name,
							x.file_url,
		                    x.description,
		                    x.start_latitude,
                            x.start_longitude,
		                    x.end_latitude,
		                    x.end_longitude,
	                        x.rating_count,
							x.rating_value,
							y.comments_count,
							x.distance,
							x.total_distance
                       from
                           (
						     select 
							      rrr.routed_id as routed_id,
								  isnull(rrr.routed_name ,'') as routed_name,
		                          isnull(rrr.file_url , '') as file_url,
		                          isnull(rrr.description , '') as description,
		                          cast(isnull(nullif(ltrim(rtrim(rrr.start_latitude)),''),0) as decimal(9,6)) as start_latitude,
		                          cast(isnull(nullif(ltrim(rtrim(rrr.start_longitude)),''),0) as decimal(9,6)) as start_longitude,
		                          cast(isnull(nullif(ltrim(rtrim(rrr.end_latitude)),''),0) as decimal(9,6)) as end_latitude,
		                          cast(isnull(nullif(ltrim(rtrim(rrr.end_longitude)),''),0) as decimal(9,6)) as end_longitude,
		                          isnull(count(a.routed_id),0) as rating_count,
								  isnull(sum(rating)/count(rating),0) as rating_value,
								  --isnull(([dbo].[get_distance_by_lat_long](@current_latitude,@current_longitude,start_latitude,start_longitude) / 1609.344),0) as distance,
								  0 as distance,
								  cast(isnull(nullif(ltrim(rtrim(rrr.total_distance)),''),0) as decimal(18,6)) as total_distance
		                     from 
							      [ride].[rated_routes] rrr
								  left join ride.routes_rating a
								  on a.routed_id = rrr.routed_id
								  and a.is_deleted = 0 
								  and rrr.is_deleted = 0 
								  where
								   rrr.routed_id = @route_id
                                  group by  rrr.routed_id,rrr.routed_name,rrr.file_url,rrr.description,rrr.start_latitude,rrr.start_longitude,rrr.end_latitude,rrr.end_longitude,rrr.total_distance
				    ) x inner join
                                 (
								   select 
								        rrr.routed_id as route_id,
		                                isnull(count(a.routed_id),0) as comments_count
                                    from
									    [ride].[rated_routes] rrr 
										left join ride.routes_comments a 
										on a.routed_id = rrr.routed_id 
										and a.is_deleted = 0
									    and rrr.is_deleted = 0 
										 where
								        rrr.routed_id = @route_id
                                        group by rrr.routed_id
										) y 
										on x.routed_id = y.route_id
										)z left join  
										 ride.routes_rating S
										 on z.routed_id = s.routed_id
										 and s.routed_id = @route_id
										 and s.owner_id = @owner_id


	SET NOCOUNT OFF

END


GO
/****** Object:  StoredProcedure [ride].[get_routes_by_route_type]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [ride].[get_routes_by_route_type]  

@owner_id int ,
@current_latitude decimal(9,6),
@current_longitude decimal(9,6)

AS        
      
/*
	 exec  [ride].[get_routes_by_route_type]  425305, '37.317450','-121.918220'
	 ------------------------------------------------------------         
	 PURPOSE        
	 get routes

	     
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 03/27/2020     Mohan                           Created
	 -----------------------------------------------------------      
                   Copyright 2019 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

               ;WITH route_values AS
				(
					select
						rrr.routed_id as routed_id,
						count(rrt.routed_id) as rating_count,
						case when count(rrt.rating_id) = 0  then 0
							 else isnull(sum(isnull(rrt.rating,0))/count(rrt.rating),0) end as rating_value,
						count(rrc.comment_id) as comments_count
					from
						[ride].[rated_routes] rrr with(nolock,readuncommitted)
						left join ride.routes_rating rrt
						on rrr.routed_id = rrt.routed_id and rrt.is_deleted = 0
						left outer join ride.routes_comments rrc
						on rrr.routed_id = rrc.routed_id and rrc.is_deleted = 0
					where
						rrr.is_deleted = 0
					group by
						rrr.routed_id
				),
				routed_routes AS
				(
					select 
						rv.*,
						isnull(([dbo].[get_distance_by_lat_long](@current_latitude, @current_longitude, start_latitude, start_longitude) / 1609.344),0)  as distance,
						case when ort.owner_id = @owner_id then 'Yes' else 'No' end as is_rating
					from
						[ride].[rated_routes] rrr with(nolock,readuncommitted) 
						inner join route_values rv	
						on rrr.routed_id = rv.routed_id
						left join ride.routes_rating ort
						on rv.routed_id = ort.routed_id 
							and ort.owner_id = @owner_id 
							and ort.is_deleted = 0
				)
				SELECT  top 10
					rrr.routed_id as routed_id,
					isnull(rrr.routed_name, '') as routed_name,
					isnull(rrr.description, '') as description,
					isnull(rrr.file_url, '') as file_url,
					cast(isnull(nullif(ltrim(rtrim(rrr.start_latitude)),''),0) as decimal(9,6)) as start_latitude,
					cast(isnull(nullif(ltrim(rtrim(rrr.start_longitude)),''),0) as decimal(9,6)) as start_longitude,
					cast(isnull(nullif(ltrim(rtrim(rrr.end_latitude)),''),0) as decimal(9,6)) as end_latitude,
					cast(isnull(nullif(ltrim(rtrim(rrr.end_longitude)),''),0) as decimal(9,6)) as end_longitude,
					cast(isnull(nullif(ltrim(rtrim(rrr.total_distance)),''),0) as decimal(18,6)) as total_distance,
					isnull(rrr.is_processed, 0) as is_processed,
					rr.rating_count,
					rr.rating_value,
					rr.comments_count,
					isnull(rr.distance, 0) as distance,
					rr.is_rating
				FROM
					[ride].[rated_routes] rrr with(nolock,readuncommitted)   
					inner join routed_routes rr
					on rrr.routed_id = rr.routed_id
				WHERE
					rrr.is_deleted = 0
					and distance <= 150
				ORDER BY
					distance, 
					rrr.routed_id

	SET NOCOUNT OFF

END


GO
/****** Object:  StoredProcedure [ride].[insert_update_ride_log]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [ride].[insert_update_ride_log] 

	@ride_log_id INT = 0,  
    @ride_id INT,    
    @speed DECIMAL(10,4) = NULL,   
    @distance DECIMAL(10,4) = NULL,  
    @latitude DECIMAL(9,6) = NULL,     
    @longitude DECIMAL(9,6) = NULL   
     
   						  
AS        
      
/*
	 exec  [ride].[insert_update_ride_log] 0,3,110.0000,50.0000,17.4486,78.3908
	 ------------------------------------------------------------         
   

    select top 10 * from ride.ride order by ride_id desc
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 10/30/2017     Powersports                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

		IF (isnull(@ride_log_id,0)  = 0)           
			BEGIN          

				INSERT INTO ride.ride_log 
									(ride_id,
									speed,
									distance,
									latitude,
									longitude)          
					VALUES 
						( @ride_id,		
						  @speed,
						  @distance,
						  @latitude,
						  @longitude
				)
	
			SET @ride_log_id = SCOPE_IDENTITY() 
			
	
END         
		ELSE          
			BEGIN

					UPDATE 
					     ride.ride_log  
					SET   
						ride_id = @ride_id,		  
						speed = @speed,
						distance = @distance,
						latitude = @latitude,
						longitude = @longitude        
					WHERE ride_log_id = @ride_log_id   
	
	END

		select @ride_log_id as ride_log_id

SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [ride].[insert_update_route_comments]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [ride].[insert_update_route_comments]  

@owner_id int,
@rated_route_id int,
@comment varchar(500),
@comment_id int = 0

AS        
      
/*
	 exec  [ride].[insert_update_route_comments]   425305,25,'Hello123'
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Data
	     
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 03/27/2020     Mohan                           Created
	 -----------------------------------------------------------      
                   Copyright 2019 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 


	 if(@comment_id = 0)

	 BEGIN
			  insert into
					ride.routes_comments
					(
						comment,
						routed_id,
						owner_id,
						is_deleted 
					)
					values
					(
		    			@comment,
						@rated_route_id,
						@owner_id,
						0
					)

	END

	else

	 BEGIN

	 		update
					 ride.routes_comments
				set
					 comment = @comment
				where 
					 comment_id = @comment_id
					  
	 END

	SET NOCOUNT OFF

END



GO
/****** Object:  StoredProcedure [ride].[insert_update_route_rating]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [ride].[insert_update_route_rating]  

@owner_id int,
@rated_route_id int,
@rating decimal(9,2)

AS        
      
/*
	 exec  [ride].[insert_update_route_rating]  312607,23,2.29
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Data
	     
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 03/27/2020     Mohan                           Created
	 -----------------------------------------------------------      
                   Copyright 2019 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

	declare @is_exist int;
	declare @is_route_id_exist int;

	select @is_exist = (
	                     select 
						   count(owner_id)
						 from 
						     ride.routes_rating with(nolock,readuncommitted) 
						 where
						     owner_id = @owner_id
							 and routed_id = @rated_route_id 
							 and is_deleted = 0  
						)

      set @is_exist = isnull(@is_exist,0)



			if(@is_exist > 0)

			 BEGIN

				update
					ride.routes_rating
				set
					 rating = @rating
				where 
					 routed_id = @rated_route_id
					 and owner_id = @owner_id
					 and is_deleted = 0
 
			END

			else

			BEGIN
	 
			  insert into
					ride.routes_rating
					(
						rating,
						routed_id,
						owner_id,
						is_deleted 
					)
					values
					(
		    			@rating,
						@rated_route_id,
						@owner_id,
						0
					)

			END

	SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [ride].[save_ride_media]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [ride].[save_ride_media]

    @ride_id int,
	@media_type varchar(100) = 'Text',
	@media_url nvarchar(max) = null,
	@thumbnail nvarchar(max) = null
AS        
      
/*
	 exec  [ride].[save_ride_media] 3,'Video','http://fb.com'
	 ------------------------------------------------------------         
	 PURPOSE        
	 Insert Update Ride
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     description          
	 -----------------------------------------------------------        
	11/02/2018     Ready2Ride                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

  declare @media_type_id int;
  set @media_type_id = (
                           select 
						        media_type_id
                           from
						       [ride].[media_type]
                           where
						       name = @media_type
							   and is_deleted = 0
                       )

    insert into
	       [ride].[ride_media]
		    (
		       ride_id,
			   media_type_id,
			   media_url,
			   thumbnail
		    )
		   values
		    (
		       @ride_id,
			   @media_type_id,
			   @media_url,
			   @thumbnail
		    )

SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [ride].[update_ride_id]    Script Date: 1/25/2022 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [ride].[update_ride_id]
   
	@ride_id int = NULL,  
    @message_id int = NUll

AS        
      
/*
	 exec  [ride].[update_ride_id]
	 ------------------------------------------------------------         
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2019     Ready2Ride                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

	UPDATE message.message
	SET
		ride_id = @ride_id,
		message_type_id = 6
	WHERE
		message_id= @message_id

SET NOCOUNT OFF

END
GO

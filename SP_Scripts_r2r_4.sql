USE [auto_mobile]
GO
/****** Object:  StoredProcedure [owner].[attend_event]    Script Date: 1/25/2022 4:33:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[attend_event]
 @owner_id int = null,  
 @event_id int null
 

AS

/* 
	exec [owner].[attend_event] 404821,5524
	--------------------------------------------------------------       
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
    15/09/2019      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 SET NOCOUNT ON;
 
 BEGIN

	declare @count int = 0

	select @count = count(*) from  owner.owner_events with(nolock,readuncommitted)  where is_deleted = 0 and owner_id = @owner_id and event_id = @event_id
	
	set @count = isnull(@count,0)

	if(@count = 0)
		begin
			insert into owner.owner_events 
				(
					owner_id,
					status,
					event_id,
					is_attending
				) 
			values
				(
					@owner_id,
					'',
					@event_id,
					1
				)
		end
	else
		begin
			update 
				owner.owner_events 
			set
				is_attending = 1,
				updated_dt = getdate()
			where
				owner_id = @owner_id
				and event_id = @event_id
		end
	
 END      
GO
/****** Object:  StoredProcedure [owner].[check_app_user]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[check_app_user]  

	@owner_id int  

AS        
      
/*
	 exec [owner].[check_app_user] 
	 ------------------------------------------------------------         
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	select 
		isnull(owner_user_id, 0) as user_id
	from 
		owner.owner oo with(nolock,readuncommitted)
	where
		is_deleted = 0
		and oo.owner_id = @owner_id

END
	 


GO
/****** Object:  StoredProcedure [owner].[check_app_users_mobile]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[check_app_users_mobile]  

	@mobile nvarchar(100) = null    

AS        
      
/*
	 exec [owner].[check_app_users_mobile] '9000689107'
	 ------------------------------------------------------------         
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	select 
		count(oo.owner_id) as count
	from 
		owner.owner oo with(nolock,readuncommitted)
	where
		is_deleted = 0
		and oo.owner_user_id > 0
		and right(rtrim(ltrim(replace(replace(replace(replace(oo.mobile,'(',''),')',''),'-',''),' ',''))),10) = right(rtrim(ltrim(replace(replace(replace(replace(@mobile,'(',''),')',''),'-',''),' ',''))),10)

END
	 


GO
/****** Object:  StoredProcedure [owner].[check_instore_signup]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[check_instore_signup]
  
	@user_id int,
	@owner_id int,
	@email varchar(500),
	@mobile varchar(100) 

AS        
      
/*
	 exec  [owner].[check_instore_signup] 9580,412968,'servicestesting3@gmail.com',''
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Chech Instore Singup
	 select * from  owner.instore_signup
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     siva                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	declare @instore_signup_id int = 0
	declare @dealer_id int = 0
	declare @dealer_dept_id int = 0
	declare @instore_user_count int = 0
	declare @promotion_id int = 0

	select top 1
		@instore_signup_id = isnull(instore_signup_id, 0),
		@dealer_id = isnull(dealer_id, 0),
		@dealer_dept_id = isnull(department_id, 0)
	from 
		owner.instore_signup ois with(nolock,readuncommitted)
	where
		is_deleted = 0
		and ( ltrim(rtrim(ois.email)) = ltrim(rtrim(@email)) or right(rtrim(ltrim(replace(replace(replace(replace(ois.phone_number,'(',''),')',''),'-',''),' ',''))),10) = right(rtrim(ltrim(replace(replace(replace(replace(@mobile,'(',''),')',''),'-',''),' ',''))),10) )
	order by
		instore_signup_id desc

	update 
		 owner.owner
	set
		instore_signup_id = isnull(@instore_signup_id, 0)
	where
		owner_id = @owner_id
			
	set @promotion_id  =  ( select top 1
								promotion_id
							from 
								event.promotions ep with(nolock,readuncommitted)
							where
								ep.is_deleted = 0
								and ep.type = 2
								and ep.dealer_id = @dealer_id
								and ep.start_date <= getdate() 
								and getdate() <= ep.end_date 
								and isnull(ep.is_archived,0) = 0	
							order by
								ep.promotion_id desc
						   )

	set @promotion_id = isnull(@promotion_id,0)

	if(@instore_signup_id > 0)
		begin
			if(@promotion_id > 0)
				begin
					if not exists (select * from owner.owner_promotions where is_deleted = 0 and owner_id = @owner_id and promotion_id = @promotion_id)
						begin
							insert into owner.owner_promotions
							(
								owner_id,
								promotion_id,
								is_saved,
								is_deleted
							)
							values
							(
								@owner_id,
								@promotion_id,
								1,
								0
							)
						end
					else
						begin
							update 
								owner.owner_promotions
							set
								is_saved = 1,
								is_deleted = 0
							where 
								owner_id = @owner_id 
								and promotion_id = @promotion_id
						end
				end
		end

	select @promotion_id as promotion_id

END

GO
/****** Object:  StoredProcedure [owner].[check_mobile_number]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[check_mobile_number]  

	@mobile nvarchar(100) = null    

AS        
      
/*
	 exec [owner].[check_mobile_number] '9000689107'
	 ------------------------------------------------------------         
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  

	select 
		count(oo.owner_id) as count
	from 
		owner.owner oo with(nolock,readuncommitted)
	where
		is_deleted = 0
		and right(rtrim(ltrim(replace(replace(replace(replace(oo.mobile,'(',''),')',''),'-',''),' ',''))),10) = right(rtrim(ltrim(replace(replace(replace(replace(@mobile,'(',''),')',''),'-',''),' ',''))),10)

SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [owner].[check_owner_mobile_number]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[check_owner_mobile_number]  

	@mobile nvarchar(100) = null,
	@owner_id int    

AS        
      
/*
	 exec [owner].[check_owner_mobile_number] '9000689107',411628
	 ------------------------------------------------------------         
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  

	select 
		count(oo.owner_id) as count
	from 
		owner.owner oo with(nolock,readuncommitted)
	where
		is_deleted = 0
		and is_app_user = 1
		and owner_id <> @owner_id
		and right(rtrim(ltrim(replace(replace(replace(replace(oo.mobile,'(',''),')',''),'-',''),' ',''))),10) = right(rtrim(ltrim(replace(replace(replace(replace(@mobile,'(',''),')',''),'-',''),' ',''))),10)


END
	 


GO
/****** Object:  StoredProcedure [owner].[dealer_update]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[dealer_update]
 @owner_id int = null,  
 @dealer_id int null
 

AS

/* 
	--------------------------------------------------------------       
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
    09/12/2018      Ready2Ride                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 SET NOCOUNT ON;
 
 BEGIN
 
	UPDATE [owner].[owner] 
	SET
		dealer_id=@dealer_id
	WHERE
		owner_id = @owner_id and is_deleted = 0

	--SELECT isnull(dealer_id,0) from owner.owner where owner_id=@owner_id
 END      
GO
/****** Object:  StoredProcedure [owner].[delete_selected_dealer]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[delete_selected_dealer]
 @owner_id int,
 @dealer_id int

AS

/*     
	exec [owner].[delete_selected_dealer] 405851,2345
	--------------------------------------------------------------       
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
    09/12/2018      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
SET NOCOUNT ON;
 
BEGIN
 
		update owner.owner_dealers
		set 
			is_deleted = 1 
		where owner_id = @owner_id and
			  dealer_id = @dealer_id
	  select 'deleted' as message
END

SET NOCOUNT OFF;    

GO
/****** Object:  StoredProcedure [owner].[get_admin_groups_by_owner_id]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_admin_groups_by_owner_id]

	@owner_id int = null 

AS        
     
/*
	 exec  [owner].[get_admin_groups_by_owner_id] 404923
	 ------------------------------------------------------------         
    
	 PROCESSES
	 
	 select * from owner.owner where owner_id =  404923        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

	set @owner_id = isnull(@owner_id,0)

	BEGIN

		select
			og.owner_group_id, 
			bg.group_id,
			bg.name,
			isnull(bg.description,'') as description,
			isnull(bg.icon,'') as icon,
			bg.latitude,
			bg.longitude,
			bg.address,
			bgm.mode,
			isnull(og.owner_id,0) as owner_id,
			--isnull(bg.group_member_count,0)  as group_member_count,
			isnull((select 
					count(oog.owner_group_id)
					from 
						[owner].[owner_group] oog with(nolock,readuncommitted)
						inner join owner.owner oo with(nolock,readuncommitted)
						on oo.owner_id =  oog.owner_id
					where 
					group_id = bg.group_id 
					and oog.is_deleted = 0
					and oo.is_deleted = 0),0)  as group_member_count,
			case when og.owner_group_id > 0 then 1 else 0 end as is_joined,
			isnull(og.is_created,0) as is_created
		from
			buddy.groups bg with(nolock,readuncommitted) 
			inner join owner.owner_group og with(nolock,readuncommitted) on
			bg.group_id = og.group_id 
			inner join buddy.groups_mode bgm with(nolock,readuncommitted)
			on bg.mode_id = bgm.mode_id
				
		where
			bg.is_deleted = 0
			and bgm.is_deleted = 0
			and og.is_deleted = 0
			and og.owner_id = @owner_id
		order by
			bg.group_id desc

	END

SET NOCOUNT OFF
END

GO
/****** Object:  StoredProcedure [owner].[get_alert]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_alert]  
	 @owner_id int,
	 @cycle_id int = null
AS        
      
/*
	 exec  [owner].[get_alert] 1187928
	
	 ------------------------------------------------------------         
	 PURPOSE        
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     Warrous                           Created
	 -----------------------------------------------------------      
                 
*/        
BEGIN 
  
	SET NOCOUNT ON 

	set @owner_id = isnull(@owner_id,0)
	set @cycle_id = isnull(@cycle_id,0)

	IF(@owner_id > 0 and @cycle_id > 0)
		BEGIN
			 SELECT
					alert_id,
					service_category_id,
					alert_by,
					last_serviced,
					suggested,
					every,
					remainder,
					cycle_id,
					oa.owner_id,
					isnull(oo.dealer_id, 0) as dealer_id
			 FROM 
				 owner.alerts oa with(nolock,readuncommitted)
				 left join owner.owner oo with(nolock,readuncommitted) 
				 on oa.owner_id=oo.owner_id and oo.is_deleted = 0

			 where 
				 oa.owner_id = @owner_id 
				 and cycle_id = @cycle_id
				 and oa.is_deleted = 0
			 order by 
				alert_id desc
		END
	ELSE
		BEGIN
			 SELECT
					alert_id,
					service_category_id,
					alert_by,
					last_serviced,
					suggested,
					every,
					remainder,
					cycle_id,
					oa.owner_id,
					isnull(oo.dealer_id, 0) as dealer_id
			 FROM 
				 owner.alerts oa with(nolock,readuncommitted)
				 left join owner.owner oo with(nolock,readuncommitted) 
				on oa.owner_id=oo.owner_id and oo.is_deleted = 0
			 where 
				oa.owner_id = @owner_id 
				 and oa.is_deleted = 0
			 order by 
				alert_id desc
		END

	SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [owner].[get_dealer_data]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[get_dealer_data]  

 @owner_id int


AS

/* 
	exec [owner].[get_dealer_data]  133237
	--------------------------------------------------------------       
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
	               Copyright 2019 Ready2Ride
*/ 

 /* Setup */ 
 BEGIN
SET NOCOUNT ON;

BEGIN TRY

		select 
		   isnull(fname,'') as first_name,
		   isnull(lname,'') as last_name,
		   isnull(email,'') as email_address
		from
			[owner].[owner] with(nolock,readuncommitted)
		where 
			  owner_id = @owner_id
END TRY

BEGIN CATCH

       select ERROR_MESSAGE() as err_message
   
END CATCH

SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [owner].[get_dealer_name]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[get_dealer_name]  

 @dealer_id int


AS

/* 
	exec [owner].[get_dealer_name]  
	--------------------------------------------------------------       
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
	               Copyright 2019 Ready2Ride
*/ 

 /* Setup */ 
 BEGIN
SET NOCOUNT ON;

BEGIN TRY

		select 
		   dealer_name 
		from
			portal.dealer with(nolock,readuncommitted)
		where 
			  dealer_id = @dealer_id
END TRY

BEGIN CATCH

       select ERROR_MESSAGE() as err_message
   
END CATCH

SET NOCOUNT OFF
END;
GO
/****** Object:  StoredProcedure [owner].[get_discussion_comments]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[get_discussion_comments]
	
	@discussion_id int

AS

/* 
	exec [owner].[get_discussion_comments] 2079
	--------------------------------------------------------------       
    MODIFICATIONS       
	select * from [owner].[discussion_comments]
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
	04/29/2019      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 SET NOCOUNT ON;
	 BEGIN
		 select 
			odc.discussion_comment_id,
			isnull(odc.discussion_comments,'') as discussion_comments,
			isnull(odc.image_url,'') as image_url,
			odc.owner_id,
			isnull(oo.fname,'') as fname,
			isnull(oo.lname,'') as lname,
			isnull(oo.fname,'')+' '+isnull(oo.lname,'') as name,
			isnull(oo.bground_image,'') as profile_pic,
			odc.created_dt
		 from 
			[owner].[discussion_comments] odc with(nolock,readuncommitted)
			inner join owner.owner oo with(nolock,readuncommitted) 
			on(odc.owner_id = oo.owner_id)
		 where 
			  discussion_id = @discussion_id 
			  and odc.is_deleted = 0 
			  and oo.is_deleted = 0
		order by
			odc.discussion_comment_id desc
	 END 
GO
/****** Object:  StoredProcedure [owner].[get_featured_groups]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_featured_groups] 

	@owner_id int = null,
	@group_type varchar(100) = 'featured'  

AS        
     
/*
	 exec  [owner].[get_featured_groups] 404923,'featured'
	 ------------------------------------------------------------         
    
	 PROCESSES
	 
	 select * from owner.owner where owner_id =  404923        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

	set @owner_id = isnull(@owner_id,0)

	IF (isnull(@group_type,'featured') = 'featured')

		BEGIN

			;WITH owner_groups AS (
			   select 
					 owner_group_id,
					 owner_id,
					 group_id,
					 is_created 
				from 
					owner.owner_group with(nolock,readuncommitted)
				where 
					owner_id = @owner_id 
					and is_deleted = 0
			),
			featured_groups AS
			(select 
					bg.group_id,
					bg.name,
					isnull(bg.description,'') as description,
					isnull(bg.icon,'') as icon,
					bg.latitude,
					bg.longitude,
					bg.address,
					bgm.mode,
					isnull(og.owner_id,0) as owner_id,
					--isnull(bg.group_member_count,0)  as group_member_count,
					isnull((select 
							count(oog.owner_group_id)
						 from 
							  [owner].[owner_group] oog with(nolock,readuncommitted)
							  inner join owner.owner oo with(nolock,readuncommitted)
							  on oo.owner_id =  oog.owner_id
						 where 
							group_id = bg.group_id 
							and oog.is_deleted = 0
							and oo.is_deleted = 0),0)  as group_member_count,
					case when og.owner_group_id > 0 then 1 else 0 end as is_joined,
					isnull(og.is_created,0) as is_created
				from 
					buddy.groups bg with(nolock,readuncommitted)
					inner join buddy.groups_mode bgm with(nolock,readuncommitted)
					on bg.mode_id = bgm.mode_id
					left join owner_groups og with(nolock,readuncommitted) on
					bg.group_id = og.group_id
				
				where
					bg.is_deleted = 0
					and bgm.is_deleted = 0
			
        )
		SELECT  * FROM  featured_groups order by group_id desc

		END

	ELSE

		BEGIN

			select 
				bg.group_id,
				bg.name,
				bg.description,
				isnull(bg.icon,'') as icon,
				bg.latitude,
				bg.longitude,
				bg.address,
				bgm.mode,
				og.owner_id,
				isnull((select 
							count(oog.owner_group_id)
						 from 
							  [owner].[owner_group] oog with(nolock,readuncommitted)
							  inner join owner.owner oo with(nolock,readuncommitted)
							  on oo.owner_id =  oog.owner_id
						 where 
							group_id = bg.group_id 
							and oog.is_deleted = 0
							and oo.is_deleted = 0),0)  as group_member_count,
				1 as is_joined,
				isnull(og.is_created,0) as is_created
			from 
				 [owner].[owner_group] og  with(nolock,readuncommitted)
				 inner join buddy.groups bg with(nolock,readuncommitted)
				 on og.group_id = bg.group_id
				 inner join buddy.groups_mode bgm with(nolock,readuncommitted)
				 on bg.mode_id = bgm.mode_id
		 
			where 
				  og.owner_id = @owner_id and 
				  bg.is_deleted=0 and
				  og.is_deleted=0
			order by
				  bg.group_id desc
   
		END

SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [owner].[get_feed_by_type]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_feed_by_type] 
   
   @current_latitude decimal(9,6),
   @current_longitude decimal(9,6),
   @owner_id int = 0,
   @feed_type varchar(250) = 'Local',
   @page_no int = 1

AS        
      
/*
	 exec [owner].[get_feed_by_type]  '17.462429','78.395103',1200877,'local'
	 ---------------------------------------------------------       
	 PURPOSE        
	 Get Owner location
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker id     description          
	 -----------------------------------------------------------        
	 10/25/2019     Powersports                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Powersports Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

   
        declare @page_size int =  30

		set @page_no = isnull(@page_no, 1) - 1
	
		set @page_no = IIF(@page_no < 0, 0, @page_no )

        if(@feed_type = 'Local')
begin

     select
			ofeed.owner_id,
			ofeed.owner_name,
			ofeed.current_latitude,
			ofeed.current_longitude,
			ofeed.profile_pic,
			ofeed.distance,
			ofeed.feed_id,
			ofeed.text,
			ofeed.feed_type,
			ofeed.media_type_id,
			ofeed.media_url,
			ofeed.thumbnail,
			ofeed.created_dt,
			isnull(ofeed.likes,0) as likes,
			isnull(ofeed.comments,0) as comments,
			--isnull(ofeed.is_liked_user,0) as is_liked_user,
			case when ofeed.is_liked_user = 0 then convert(bit,0) else convert(bit,1) end as is_liked_user,
			ofeed.ride_id,
			ofeed.name as ride_name,
			ofeed.start_latitude,
			ofeed.start_longitude,
			ofeed.end_latitude,
			ofeed.end_longitude,
			ofeed.duration,
			ofeed.ride_distance,
			ofeed.ride_date
       from
           (
		      select 
				   oo.owner_id as owner_id,
				   isnull(oo.fname,'')+ ' ' + isnull(oo.lname,'') as owner_name,
				   oo.current_latitude as current_latitude,
				   oo.current_longitude as current_longitude,
				   isnull(oo.photo,isnull(oo.photo_path,'')) as profile_pic,
				   isnull(([dbo].[get_distance_by_lat_long](@current_latitude,@current_longitude,oo.current_latitude,oo.current_longitude) / 1609.344),0) as distance,
				   ofd.feed_id as feed_id,
				   isnull(ofd.feed_text,'') as text,
				   oft.feed_type_code as feed_type,
				   ofd.media_type_id  as media_type_id,
				   isnull(ofd.media_url,'') as media_url,
				   isnull(ofd.thumbnail,'') as thumbnail,
				   ofd.created_dt as created_dt,
				   ofd.likes as likes,
				   ofd.comments as comments,
				--   ofd.self_like as is_liked_user,
				(select count(feed_like_id) from feed.likes with(nolock,readuncommitted) where is_deleted = 0 and feed_id = ofd.feed_id and owner_id = @owner_id) as is_liked_user,
				   isnull(ofd.ride_id,0) as ride_id,
				   rr.name,
				   rr.start_geo_lat as start_latitude,
				   rr.start_geo_lon as start_longitude,
				   rr.end_geo_lat as end_latitude,
				   rr.end_geo_long as end_longitude,
				   isnull([ride].get_ride_log_duration(rr.ride_log),0) as duration,
				   isnull((([ride].[get_ride_distance](rr.ride_log))),0) as ride_distance,
				   rr.created_dt as ride_date
			from
					[owner].[feeds] ofd with(nolock,readuncommitted)
					inner join [owner].[feed_type] oft with(nolock,readuncommitted) 
					on oft.feed_type_id = ofd.feed_type_id
					inner join owner.owner oo with(nolock,readuncommitted)
					on oo.owner_id = ofd.owner_id
					left join ride.ride	rr with(nolock,readuncommitted)
					on rr.ride_id = ofd.ride_id			 
		    where
				  oo.is_app_user = 1 
				  and oo.is_deleted = 0
				  and ofd.is_deleted = 0
				  and oo.owner_user_id > 0
				  and oo.current_latitude is not null
				  and oo.current_longitude is not null
				 -- and oo.owner_id <> 716081
			  ) ofeed 
			   order by ofeed.created_dt desc
			   offset (@page_no * @page_size) rows fetch next @page_size rows only
			 
end

        if(@feed_type = 'Following')	
begin

        select
			  ofeed.owner_id,
			  ofeed.owner_name,
			  ofeed.current_latitude,
			  ofeed.current_longitude,
			  ofeed.profile_pic,
			  ofeed.distance,
			  ofeed.feed_id,
			  ofeed.text,
			  ofeed.feed_type,
			  ofeed.media_type_id,
			  ofeed.media_url,
			  ofeed.thumbnail,
			  ofeed.created_dt,
			  isnull(ofeed.likes,0) as likes,
			  isnull(ofeed.comments,0) as comments,
			--  ofeed.is_liked_user as is_liked_user,
			  case when ofeed.is_liked_user = 0 then convert(bit,0) else convert(bit,1) end as is_liked_user,
			  ofeed.ride_id,
			  ofeed.name as ride_name,
			  ofeed.start_latitude,
			  ofeed.start_longitude,
			  ofeed.end_latitude,
			  ofeed.end_longitude,
			  ofeed.duration,
			  ofeed.ride_distance,
			  ofeed.ride_date
       from
	        (
	          select 
				   oo.owner_id,
				   isnull(oo.fname,'')+ ' ' + isnull(oo.lname,'') as owner_name,
				   oo.current_latitude,
				   oo.current_longitude,
				   isnull(oo.photo,isnull(oo.photo_path,'')) as profile_pic,
				   isnull(([dbo].[get_distance_by_lat_long](@current_latitude,@current_longitude,oo.current_latitude,oo.current_longitude) / 1609.344),0) as distance,
				   ofd.feed_id as feed_id,
				   isnull(ofd.feed_text,'') as text,
				   oft.feed_type_code as feed_type,
				   ofd.media_type_id,
				   isnull(ofd.media_url,'') as media_url,
				   isnull(ofd.thumbnail,'') as thumbnail,
				   ofd.created_dt,
				   ofd.likes as likes,
				   ofd.comments as comments,
				 --  ofd.self_like as is_liked_user,
				 (select count(feed_like_id) from feed.likes with(nolock,readuncommitted) where is_deleted = 0 and feed_id = ofd.feed_id and owner_id = @owner_id) as is_liked_user,
				   isnull(ofd.ride_id,0) as ride_id,
					rr.name,
					rr.start_geo_lat as start_latitude,
					rr.start_geo_lon as start_longitude,
					rr.end_geo_lat as end_latitude,
					rr.end_geo_long as end_longitude,
					isnull([ride].get_ride_log_duration(rr.ride_log),0) as duration,
				    isnull((([ride].[get_ride_distance](rr.ride_log))),0) as ride_distance,
					rr.created_dt as ride_date
			from
					--owner.feed_followers offo with(nolock,readuncommitted)
					--inner join [owner].[feeds] ofd with(nolock,readuncommitted)
					--on offo.following_id = ofd.owner_id
					--inner join [owner].[feed_type] oft with(nolock,readuncommitted) 
					--on oft.feed_type_id = ofd.feed_type_id
					--inner join owner.owner oo with(nolock,readuncommitted)
					--on oo.owner_id = ofd.owner_id
					--left join ride.ride	rr with(nolock,readuncommitted)
					--on rr.ride_id = ofd.ride_id
					  owner.owner oo  with(nolock,readuncommitted)
					 inner join [owner].[feeds] ofd with(nolock,readuncommitted)
					 on ofd.owner_id = oo.owner_id
					 left join ride.ride rr with(nolock,readuncommitted)
					on rr.ride_id = ofd.ride_id	
					inner join [owner].[feed_type] oft with(nolock,readuncommitted) 
					on oft.feed_type_id = ofd.feed_type_id	
				 
		    where
				  oo.is_app_user = 1 
				  and oo.is_deleted = 0
				  and ofd.is_deleted = 0
				 -- and offo.is_deleted = 0
				  and oo.owner_user_id > 0
				  and oo.current_latitude is not null
				  and oo.current_longitude is not null
				  --and offo.following_id is not null 
				  and  oo.owner_id  in (select receiver_id from [buddy].[buddy] where sender_id = @owner_id and is_request_accepted = 1 and is_deleted = 0)
				  and oo.owner_id <> @owner_id				  
				 -- order by ofd.created_dt desc			 
			  )	ofeed 
			   order by ofeed.created_dt desc
			   offset (@page_no * @page_size) rows fetch next @page_size rows only


end


        if(@feed_type = 'other')	
begin

        select
			  ofeed.owner_id,
			  ofeed.owner_name,
			  ofeed.current_latitude,
			  ofeed.current_longitude,
			  ofeed.profile_pic,
			  ofeed.distance,
			  ofeed.feed_id,
			  ofeed.text,
			  ofeed.feed_type,
			  ofeed.media_type_id,
			  ofeed.media_url,
			  ofeed.thumbnail,
			  ofeed.created_dt,
			  isnull(ofeed.likes,0) as likes,
			  isnull(ofeed.comments,0) as comments,
			 -- ofeed.is_liked_user as is_liked_user,
			  case when ofeed.is_liked_user = 0 then convert(bit,0) else convert(bit,1) end as is_liked_user,
			  ofeed.ride_id,
			  ofeed.name as ride_name,
			  ofeed.start_latitude,
			  ofeed.start_longitude,
			  ofeed.end_latitude,
			  ofeed.end_longitude,
			  ofeed.duration,
		   	  ofeed.ride_distance,
			  ofeed.ride_date
       from
	        (
	          select 
				   oo.owner_id,
				   isnull(oo.fname,'')+ ' ' + isnull(oo.lname,'') as owner_name,
				   oo.current_latitude,
				   oo.current_longitude,
				   isnull(oo.photo,isnull(oo.photo_path,'')) as profile_pic,
				   isnull(([dbo].[get_distance_by_lat_long](@current_latitude,@current_longitude,oo.current_latitude,oo.current_longitude) / 1609.344),0) as distance,
				   ofd.feed_id as feed_id,
				   isnull(ofd.feed_text,'') as text,
				   oft.feed_type_code as feed_type,
				   ofd.media_type_id,
				   isnull(ofd.media_url,'') as media_url,
				   isnull(ofd.thumbnail,'') as thumbnail,
				   ofd.created_dt,
				   ofd.likes as likes,
				   ofd.comments as comments,
				--   ofd.self_like as is_liked_user,
				   (select count(feed_like_id) from feed.likes with(nolock,readuncommitted) where is_deleted = 0 and feed_id = ofd.feed_id and owner_id = @owner_id) as is_liked_user,
				   isnull(ofd.ride_id,0) as ride_id,
					rr.name,
					rr.start_geo_lat as start_latitude,
					rr.start_geo_lon as start_longitude,
					rr.end_geo_lat as end_latitude,
					rr.end_geo_long as end_longitude,
				    isnull([ride].get_ride_log_duration(rr.ride_log),0) as duration,
				    isnull((([ride].[get_ride_distance](rr.ride_log))),0) as ride_distance,
					rr.created_dt as ride_date
			from
					owner.owner oo with(nolock,readuncommitted)
					inner join [owner].[feeds] ofd with(nolock,readuncommitted)
					on oo.owner_id = ofd.owner_id
					left join ride.ride	rr with(nolock,readuncommitted)
					on rr.ride_id = ofd.ride_id and rr.is_deleted = 0
					inner join [owner].[feed_type] oft with(nolock,readuncommitted) 
					on oft.feed_type_id = ofd.feed_type_id				 
		    where
				  oo.is_app_user = 1 
				  and oo.is_deleted = 0
				  and ofd.is_deleted = 0
				  and oo.owner_user_id > 0
				  and oo.current_latitude is not null
				  and oo.current_longitude is not null
				  and oo.owner_id = @owner_id				  
				 -- order by ofd.created_dt desc			 
			  )	ofeed 
			   order by ofeed.created_dt desc
			   offset (@page_no * @page_size) rows fetch next @page_size rows only

end

        if(@feed_type = 'RideLog')	
begin

        select
			  ofeed.owner_id,
			  ofeed.owner_name,
			  ofeed.current_latitude,
			  ofeed.current_longitude,
			  ofeed.profile_pic,
			  ofeed.distance,
			  ofeed.feed_id,
			  ofeed.text,
			  ofeed.feed_type,
			  ofeed.media_type_id,
			  ofeed.media_url,
			  ofeed.thumbnail,
			  ofeed.created_dt,
			  isnull(ofeed.likes,0) as likes,
			  isnull(ofeed.comments,0) as comments,
			  ofeed.is_liked_user as is_liked_user,
			  ofeed.ride_id,
			  ofeed.name as ride_name,
			  ofeed.start_latitude,
			  ofeed.start_longitude,
			  ofeed.end_latitude,
			  ofeed.end_longitude,
			  ofeed.duration,
		   	  ofeed.ride_distance,
			  ofeed.ride_date
       from
	        (
	          select 
				   oo.owner_id,
				   isnull(oo.fname,'')+ ' ' + isnull(oo.lname,'') as owner_name,
				   oo.current_latitude,
				   oo.current_longitude,
				   isnull(oo.photo,isnull(oo.photo_path,'')) as profile_pic,
				   isnull(([dbo].[get_distance_by_lat_long](@current_latitude,@current_longitude,oo.current_latitude,oo.current_longitude) / 1609.344),0) as distance,
				   0 as feed_id,
				   '' as text,
				   'RIDE' as feed_type,
				   0 as media_type_id,
				   '' as media_url,
				   '' as thumbnail,
				   rr.created_dt,
				   0 as likes,
				   0 as comments,
				   convert(bit,0) as is_liked_user,
				   isnull(rr.ride_id,0) as ride_id,
					rr.name,
					rr.start_geo_lat as start_latitude,
					rr.start_geo_lon as start_longitude,
					rr.end_geo_lat as end_latitude,
					rr.end_geo_long as end_longitude,
				    isnull([ride].get_ride_log_duration(rr.ride_log),0) as duration,
				    isnull((([ride].[get_ride_distance](rr.ride_log))),0) as ride_distance,
					rr.created_dt as ride_date
			from
					--owner.owner oo with(nolock,readuncommitted)
					--inner join [owner].[feeds] ofd with(nolock,readuncommitted)
					--on oo.owner_id = ofd.owner_id
					--left join ride.ride	rr with(nolock,readuncommitted)
					--on rr.ride_id = ofd.ride_id and rr.is_deleted = 0
					--inner join [owner].[feed_type] oft with(nolock,readuncommitted) 
					--on oft.feed_type_id = ofd.feed_type_id
					
					ride.ride rr with(nolock,readuncommitted)
				   inner join ride.ride_type rrt with(nolock,readuncommitted)
				   on rr.ride_type_id = rrt.ride_type_id
				   left join owner.owner oo with(nolock,readuncommitted)
				   on oo.owner_id = rr.owner_id
		    where
			      rr.is_deleted = 0
				  and rr.is_ride_saved = 1
				  and oo.is_app_user = 1 
				  and oo.is_deleted = 0
				  and oo.owner_user_id > 0
				  and oo.current_latitude is not null
				  and oo.current_longitude is not null
				  and rr.owner_id = @owner_id				  
				 -- order by ofd.created_dt desc			 
			  )	ofeed 
			   order by ofeed.created_dt desc
			   offset (@page_no * @page_size) rows fetch next @page_size rows only


end

SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [owner].[get_feed_likes]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_feed_likes]  
   
   @feed_id int ,
   @sender_id int null,
   @page_no int = 1

AS        
      
/*
	 exec [owner].[get_feed_likes]  1108, 425247
	 ---------------------------------------------------------       
	 PURPOSE        
	 Get Owner location
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker id     description          
	 -----------------------------------------------------------        
	 10/25/2019     Powersports                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Powersports Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

        declare @page_size int =  30

		set @page_no = isnull(@page_no, 1) - 1
	
		set @page_no = IIF(@page_no < 0, 0, @page_no )

		
		 create table #temp1
		  (
		    owner_id int,
		    feed_id int,
		    fname varchar(250),
		    lname varchar(250),
		    email varchar(250),
		    profile_pic varchar(500),
			created_dt date
		  )

		insert into #temp1
         (
          owner_id,
          feed_id,
          fname,
          lname,
          email,
          profile_pic,
		  created_dt
         )

		select
 	       oo.owner_id,
	       offo.feed_id,
	       isnull(oo.fname,'') as fname,
	       isnull(oo.lname,'') as lname,
	       isnull(oo.email,'') as email,
	       isnull(oo.photo,isnull(oo.photo_path,'')) as profile_pic,
		   offo.created_dt
       from  
           owner.owner oo with(nolock,readuncommitted)
           inner join feed.likes offo with(nolock,readuncommitted)
           on oo.owner_id = offo.owner_id
      where 
          offo.feed_id = @feed_id
          and oo.is_deleted = 0
          and offo.is_deleted = 0

        create table #chat1
        (
         sender_id int,
         receiver_id int,
         buddy_id int,
         owner_id int,
         feed_id int
        )
	    insert into #chat1
        (
         sender_id,
         receiver_id,
         buddy_id,
         owner_id,
         feed_id
        )
        select
           bb.sender_id,
           bb.receiver_id,
           bb.buddy_id,
           t1.owner_id,
           t1.feed_id
        from  
		    [buddy].[buddy] bb with(nolock,readuncommitted)
            inner join #temp1 t1 
			on (bb.sender_id = @sender_id 
			and bb.receiver_id = t1.owner_id) or
			(bb.sender_id = t1.owner_id and bb.receiver_id = @sender_id  )
       where 
            bb.is_deleted = 0


      create table #follow_count
        (
         sender_id int,
         receiver_id int,
		 is_request_accepted bit
        )
     insert into #follow_count
        (
         sender_id,
         receiver_id,
		 is_request_accepted
        )
		 select 
		     sender_id,
			 receiver_id,
			 is_request_accepted 
		 from
             [buddy].[buddy] bb WITH(NOLOCK,readuncommitted)
             inner join #temp1 t1 on 
             (bb.sender_id = @sender_id and bb.receiver_id = t1.owner_id and bb.is_deleted = 0  and bb.is_request_accepted = 1)
            or 
             (bb.sender_id = t1.owner_id and bb.receiver_id = @sender_id and bb.is_deleted = 0 and bb.is_request_accepted = 1)
       where 
	        bb.is_deleted = 0 

     
	  create table #followers_count
        (
         sender_id int,
         receiver_id int,
		 is_request_accepted bit
        )
		 insert into #followers_count
        (
         sender_id,
         receiver_id,
		 is_request_accepted
        )
	    select
		     sender_id,
			 receiver_id,
			 is_request_accepted
	   from
            [buddy].[buddy] bb WITH(NOLOCK,readuncommitted)
            inner join #temp1 t1 on 
           (bb.sender_id = @sender_id and bb.receiver_id = t1.owner_id and bb.is_deleted = 0  and bb.is_request_accepted = 0)
            or 
           (bb.sender_id = t1.owner_id and bb.receiver_id = @sender_id and bb.is_deleted = 0 and bb.is_request_accepted = 0)
      where 
	      bb.is_deleted = 0 


       select
            t1.fname,
            t1.lname,
            t1.email,
            t1.profile_pic,
			@feed_id as feed_id,
            @sender_id as sender_id,
            t1.owner_id,
			t1.created_dt,
            isnull(c1.buddy_id,0) as buddy_id,
         --   case when c1.sender_id is null then convert (bit, 0) else convert (bit, 1)  end  is_followed_by_user,
			case when  fc.is_request_accepted = 1 then 'Accepted'
			when fcc.is_request_accepted = 0 then 'Requested'
			when fc.is_request_accepted is null and fcc.is_request_accepted is null then ''
			end is_followed_by_user,
            --0 as common_riders
			isnull([buddy].[fn_get_common_riders_count](@sender_id,t1.owner_id),0) as common_riders
      from 
	       #temp1 t1
		   left join #chat1 c1 
		   on (c1.receiver_id = t1.owner_id 
		   and c1.sender_id = @sender_id) or (c1.sender_id = t1.owner_id  and c1.receiver_id = @sender_id)
		   left join #follow_count fc on
		    (fc.sender_id = @sender_id and fc.receiver_id = t1.owner_id  and fc.is_request_accepted = 1)
              or 
            (fc.sender_id = t1.owner_id and fc.receiver_id = @sender_id  and fc.is_request_accepted = 1) 
         left join #followers_count fcc on
		 (fcc.sender_id = @sender_id and fcc.receiver_id = t1.owner_id  and fcc.is_request_accepted = 0)
              or 
            (fcc.sender_id = t1.owner_id and fcc.receiver_id = @sender_id  and fcc.is_request_accepted = 0) 

			order by t1.created_dt desc
		    offset (@page_no * @page_size) rows fetch next @page_size rows only	

drop table #temp1
drop table #chat1



    --      select
				--	oo.owner_id,
				--	bb.buddy_id,
				--	offo.feed_id,
				--	isnull(oo.fname,'') as fname,
				--	isnull(oo.lname,'') as lname,
				--	isnull(oo.email,'') as email,
				--	isnull(oo.photo,isnull(oo.photo_path,'')) as profile_pic,
				--	case when bb.sender_id is null then convert (bit, 0) else convert (bit, 1)  end  is_followed_by_user,
				--	0 as common_riders				   
				--from
				--	owner.owner oo with(nolock,readuncommitted)
				--	inner join [owner].[feeds] offo with(nolock,readuncommitted)
				--	on oo.owner_id = offo.owner_id
				--	left join [buddy].[buddy] bb with(nolock,readuncommitted)
				--	on oo.owner_id = bb.sender_id and bb.is_deleted = 0 and bb.is_request_accepted = 1
    --            where 
				--     offo.feed_id = @feed_id
				--	 and oo.is_deleted = 0
				--	 and offo.is_deleted = 0
					
			  

		
SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [owner].[get_group_discussion]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[get_group_discussion]
 @group_id int

AS

/* 
	exec [owner].[get_group_discussion] 97
	--------------------------------------------------------------    
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
	04/29/2019      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 SET NOCOUNT ON;
	 BEGIN
		 select
			ogd.discussion_id,
			ogd.group_id, 
			isnull(oo.fname,'')+' '+isnull(oo.lname,'') as name,
			isnull(ogd.owner_id,0) as owner_id,
			isnull(ogd.discussion_title,'') as discussion_title,
			isnull(discussion_title,'') as discussion_tittle,
			isnull(ogd.discussion_description,'') as discussion_description,
			isnull(ogd.image,'') as image,
			isnull(oo.photo,isnull(oo.photo_path,'')) as profile_pic,
			odt.discussion_type_code as discussion_type,
			isnull(ogd.ride_id,0) as ride_id,
		  (case when odt.discussion_type_code = 'ROUTE' then rrr.start_latitude else rr.start_geo_lat end) as start_latitude,
		   (case when odt.discussion_type_code = 'ROUTE' then rrr.start_longitude else rr.start_geo_lon end) as start_longitude,
		   (case when odt.discussion_type_code = 'ROUTE' then rrr.end_latitude else rr.end_geo_lat end) as end_latitude,
		   (case when odt.discussion_type_code = 'ROUTE' then rrr.end_longitude else rr.end_geo_long end) as end_longitude,
			--rr.start_geo_lat as start_latitude,
			--rr.start_geo_lon as start_longitude,
			--rr.end_geo_lat as end_latitude,
			--rr.end_geo_long as end_longitude,
			ogd.created_dt,
			rrr.file_url as gpx_file
		 from 
			  [owner].[group_discussion] ogd with(nolock,readuncommitted)
			  inner join owner.discussion_type odt with(nolock,readuncommitted)
			  on odt.discussion_type_id = ogd.discussion_type_id
			  inner join owner.owner oo with(nolock,readuncommitted)
			  on oo.owner_id = ogd.owner_id
			  left join ride.ride rr with(nolock,readuncommitted)
			  on rr.ride_id = ogd.ride_id and rr.is_deleted = 0
			  left join [ride].[rated_routes] rrr
			 on ogd.ride_id = rrr.routed_id
		 where 
			group_id = @group_id 
			and ogd.is_deleted = 0
			and odt.is_deleted = 0
			and oo.is_deleted = 0
			and isnumeric(isnull(rr.start_geo_lat,0)) = 1 
			and isnumeric(isnull(rr.start_geo_lon,0)) = 1
			and isnumeric(isnull(rr.end_geo_lat,0)) = 1
			and isnumeric(isnull(rr.end_geo_long,0)) = 1
		order by
			ogd.discussion_id desc
	 END 
 SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [owner].[get_group_ownercount]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_group_ownercount]

	@group_id int = NULL  

AS        
      
/*
	 exec  [owner].[get_group_ownercount] 1
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Date
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON
		
		set @group_id = isnull(@group_id,0)

		select  			
			isnull((select 
						count(oog.owner_group_id)
					from 
						[owner].[owner_group] oog with(nolock,readuncommitted)
						inner join owner.owner oo with(nolock,readuncommitted)
						on oo.owner_id = oog.owner_id
					where 
					group_id = @group_id
					and oog.is_deleted = 0
					and oo.is_deleted = 0),0) as owners,
			isnull(oo.fname,'') as fname,
			isnull(oo.lname,'') as lname,
			isnull(oo.photo,'') as image
		from 
			owner.owner_group oog with(nolock,readuncommitted)
			inner join owner.owner oo with(nolock,readuncommitted)
			on oo.owner_id = oog.owner_id
		where 
			oog.group_id = @group_id
			and oog.is_deleted = 0
			and oo.is_deleted = 0

	
SET NOCOUNT OFF
END

GO
/****** Object:  StoredProcedure [owner].[get_group_owners]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[get_group_owners]
 
	@group_id int

AS

/* 
	exec [owner].[get_group_owners] 120
	--------------------------------------------------------------       
    MODIFICATIONS       

	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
    04/29/2019      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 SET NOCOUNT ON;
	 BEGIN

		 declare @is_admin int = 0;

		 set @is_admin = ( select 
								count(owner_group_id) 
							from 
								owner.owner_group with(nolock,readuncommitted) 
							where 
								group_id = @group_id 
								and is_deleted = 0
								and isnull(is_admin,0) = 1
						  )

		 if(@is_admin = 0)
			begin
				update 
					[owner].[owner_group]
				set
					is_admin = 1
				where owner_group_id in 
				(
				   select 
						top 1 oog.owner_group_id
				   from 
					   [owner].[owner_group] oog with(nolock,readuncommitted)
					   inner join owner.owner oo with(nolock,readuncommitted)
					   on oo.owner_id = oog.owner_id
				   where 
					 group_id = @group_id 
					 and oog.is_deleted = 0
					 and oo.is_deleted = 0
				 )
			end

		 select 
			oog.owner_group_id,
			isnull(oo.fname,'')+' '+isnull(oo.lname,'') as name,
			isnull(oog.owner_id,0) as owner_id,
			isnull(oo.photo,isnull(oo.photo_path,'')) as profile_pic,
			isnull(oog.is_created,0) as is_created,
			isnull(oog.is_admin,0) as is_admin,
			oog.created_dt
		 from 
			  owner.owner_group oog with(nolock,readuncommitted)
			  inner join owner.owner oo with(nolock,readuncommitted)
			  on oo.owner_id = oog.owner_id
		 where 
			group_id = @group_id 
			and oog.is_deleted = 0
			and oo.is_deleted = 0

	 END 
GO
/****** Object:  StoredProcedure [owner].[get_owner_by_email_or_mobile]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_owner_by_email_or_mobile]  

@email VARCHAR (100) = NULL,     
@mobile VARCHAR (12) = NULL
   
AS        
      
/*
	 exec  [owner].[get_owner_by_email_or_mobile] '8867283510'
	 ------------------------------------------------------------         
	 PURPOSE        
	 Insert mobile
    
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

DECLARE @owner_id AS BIGINT =NULL
SET NOCOUNT ON;
	
IF(@email is not null AND @email !='')   
BEGIN
	SELECT TOP 1 @owner_id=owner_id FROM owner.owner WHERE email=@email ORDER BY owner_id DESC;
END
	  
If(@owner_id is NULL AND @mobile is not NULL AND @mobile !='')
	BEGIN
SELECT TOP 1 @owner_id=owner_id FROM owner.owner WHERE mobile=@mobile ORDER BY owner_id DESC;
END

Select @owner_id AS owner_id;
	
SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [owner].[get_owner_feed]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_owner_feed]  
   
  @owner_feed_id int

AS        
      
/*
	 exec [owner].[get_owner_feed]   8
	 ---------------------------------------------------------       
	 PURPOSE        
	 Get Owner location
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker id     description          
	 -----------------------------------------------------------        
	 10/25/2019     Powersports                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Powersports Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

declare @owner_id int;
set @owner_id = (
                       select 
					        owner_id
                       from
                            [owner].[feeds] with(nolock,readuncommitted)
					   where 
					        feed_id = @owner_feed_id
                     )

	;WITH nearby_riders AS
        (
          select top 1
			   oo.owner_id,
			   isnull(oo.fname,'')+ ' ' + isnull(oo.lname,'') as owner_name,
			   oo.current_latitude,
			   oo.current_longitude,
			   isnull(oo.photo,isnull(oo.photo_path,'')) as profile_pic,
			   --isnull(([dbo].[get_distance_by_lat_long](@current_latitude,@current_longitude,oo.current_latitude,oo.current_longitude) / 1609.344),0) as distance,
			   0 as distance,
			   isnull(oof.feed_text,'') as text,
			   oof.media_type_id,
			   isnull(oof.media_url,'') as media_url,
			   isnull(oof.thumbnail,'') as thumbnail,
			   oof.created_dt,
			   0 as likes,
			   0 as commnets,
			   0 as is_liked_user
			from
				 [owner].[owner] oo with(nolock,readuncommitted)
				 left join [owner].[feeds] oof with(nolock,readuncommitted)
				 on oo.owner_id = oof.owner_id
		   where
			  oo.is_app_user = 1 
			  and oo.is_deleted = 0
			  and oof.is_deleted = 0
			  and oo.owner_user_id > 0
			  and oo.current_latitude is not null
			  and oo.current_longitude is not null
			  and oo.owner_id = @owner_id
			  order by oof.created_dt desc
         )
       select * from nearby_riders  order by created_dt desc
	
SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [owner].[get_owner_followers]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_owner_followers]  
   
   @owner_id int = 0,
   @type varchar(250) = 'following',
   @page_no int = 1

AS        
      
/*
	 exec [owner].[get_owner_followers] 425247, 'follower'
	 ---------------------------------------------------------       
	 PURPOSE        
	 Get Owner location
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker id     description          
	 -----------------------------------------------------------        
	 10/25/2019     Powersports                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Powersports Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

        declare @page_size int =  30

		set @page_no = isnull(@page_no, 1) - 1
	
		set @page_no = IIF(@page_no < 0, 0, @page_no )

		if(@type = 'following')
		begin
          select
					oo.owner_id,
					--bb.receiver_id,
					@owner_id as receiver_id,
					bb.buddy_id,
					isnull(oo.fname,'') as fname,
					isnull(oo.lname,'') as lname,
					isnull(oo.email,'') as email,
					isnull(oo.photo,isnull(oo.photo_path,'')) as profile_pic,
					case when bb.sender_id is null then convert (bit, 0) else convert (bit, 1)  end  is_followed_by_user,
					0 as common_riders				   
				from
					owner.owner oo with(nolock,readuncommitted)
					left join [buddy].[buddy] bb with(nolock,readuncommitted)
					on oo.owner_id = bb.receiver_id and bb.is_deleted = 0 and bb.is_request_accepted = 1
					
				where
				    bb.sender_id = @owner_id
					and oo.is_deleted = 0
			 order by bb.created_dt desc
			 offset (@page_no * @page_size) rows fetch next @page_size rows only	  
        end

		if(@type = 'follower')
		begin
          select
					oo.owner_id,
					bb.receiver_id,
					bb.buddy_id,
					isnull(oo.fname,'') as fname,
					isnull(oo.lname,'') as lname,
					isnull(oo.email,'') as email,
					isnull(oo.photo,isnull(oo.photo_path,'')) as profile_pic,
					case when bb.sender_id is null then convert (bit, 0) else convert (bit, 1)  end  is_followed_by_user,
					0 as common_riders			   
				from
					owner.owner oo with(nolock,readuncommitted)
					left join [buddy].[buddy] bb with(nolock,readuncommitted)
					on oo.owner_id = bb.sender_id and bb.is_deleted = 0 and bb.receiver_id = @owner_id and bb.is_request_accepted = 1
					
				where
				    bb.receiver_id = @owner_id
					and oo.is_deleted = 0
			 order by bb.created_dt desc
			 offset (@page_no * @page_size) rows fetch next @page_size rows only	  
        end

		if(@type = 'requested')
		begin
          select
					oo.owner_id,
					bb.receiver_id,
					bb.buddy_id,
					isnull(oo.fname,'') as fname,
					isnull(oo.lname,'') as lname,
					isnull(oo.email,'') as email,
					isnull(oo.photo,isnull(oo.photo_path,'')) as profile_pic,
					case when bb.sender_id is null then convert (bit, 0) else convert (bit, 1)  end  is_followed_by_user,
					0 as common_riders
				from
					owner.owner oo with(nolock,readuncommitted)
					left join [buddy].[buddy] bb with(nolock,readuncommitted)
					on oo.owner_id = bb.sender_id and bb.is_deleted = 0 and bb.receiver_id = @owner_id and bb.is_request_accepted = 0
					
				where
				    bb.receiver_id = @owner_id
					and oo.is_deleted = 0
			 order by bb.created_dt desc
			 offset (@page_no * @page_size) rows fetch next @page_size rows only	  
        end
		
SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [owner].[get_owner_group_discussion]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[get_owner_group_discussion]

	@group_id int,
	@owner_id int

AS

/* 
	exec [owner].[get_owner_group_discussion] 68,814296
	--------------------------------------------------------------

    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
    04/29/2019      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 SET NOCOUNT ON;
	 BEGIN
		 select
			ogd.group_id, 
			ogd.discussion_id,
			isnull(oo.fname,'')+' '+isnull(oo.lname,'') as name,
			isnull(ogd.owner_id,0) as owner_id,
			isnull(ogd.discussion_title,'') as discussion_title,
			isnull(ogd.discussion_description,'') as discussion_description,
			isnull(ogd.image,'') as image,
			isnull(oo.bground_image,'') as profile_pic,
			isnull(ee.event_id,0) as event_id,
			isnull(ee.event_name,'') as event_name,
			isnull(ee.event_description,'') as event_description,
			isnull(ee.google_map_url,'') as goole_map_url,
			isnull(ee.start_time,'') as start_time,
			isnull(ee.end_time,'') as end_time,
			CONVERT(VARCHAR(10), ee.start_date, 101) as event_start_date,
			odt.discussion_type_code as discussion_type,
			isnull(ogd.ride_id,0) as ride_id,
			rr.start_geo_lat as start_latitude,
			rr.start_geo_lon as start_longitude,
			rr.end_geo_lat as end_latitude,
			rr.end_geo_long as end_longitude,
			ogd.created_dt
		 from 
			  [owner].[group_discussion] ogd with(nolock,readuncommitted)
			  inner join owner.discussion_type odt with(nolock,readuncommitted)
			  on odt.discussion_type_id =  ogd.discussion_type_id
			  left join event.events ee with(nolock,readuncommitted) 
			  on ee.event_id = ogd.event_id
			  inner join owner.owner oo with(nolock,readuncommitted)			
			  on oo.owner_id =  ogd.owner_id
			  left join ride.ride rr with(nolock,readuncommitted)
			  on rr.ride_id = ogd.ride_id and rr.is_deleted = 0		  
		 where 
			group_id = @group_id 
			and ogd.owner_id = @owner_id
			and ogd.is_deleted = 0
			and odt.is_deleted = 0
			and oo.is_deleted = 0
	  END 
GO
/****** Object:  StoredProcedure [owner].[get_owner_id]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_owner_id] 
	 @user_id int=null
AS        
      
/*
	 exec  [owner].[get_owner_id]  14178
	 ------------------------------------------------------------         
	 PURPOSE        
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     Warrous                           Created
	 -----------------------------------------------------------      
                 
*/        
BEGIN 
  
	SET NOCOUNT ON 

		SELECT top 1
				oo.owner_id
		FROM 
				owner.owner oo with(nolock,readuncommitted)
		where 
			oo.owner_user_id = @user_id
			and oo.is_deleted = 0
		order by 
				oo.owner_id desc

	SET NOCOUNT OFF

	END
GO
/****** Object:  StoredProcedure [owner].[get_owner_location]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_owner_location]  
   
   @current_latitude decimal(9,6),
   @current_longitude decimal(9,6),
   @owner_id int = 0,
   @page_no int = 1

AS        
      
/*
	 exec [owner].[get_owner_location] '17.462429','78.395103'
	 ---------------------------------------------------------       
	 PURPOSE        
	 Get Owner location
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker id     description          
	 -----------------------------------------------------------        
	 10/25/2019     Powersports                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Powersports Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

	;WITH nearby_riders AS
        (
          select
			   oo.owner_id,
			   isnull(oo.fname,'') as fname,
			   isnull(oo.lname,'') as lname,
			   isnull(oo.email,'') as email,
			   oo.current_latitude,
			   oo.current_longitude,
			   isnull(oo.photo,isnull(oo.photo_path,'')) as profile_pic,
			   isnull(([dbo].[get_distance_by_lat_long](@current_latitude,@current_longitude,oo.current_latitude,oo.current_longitude) / 1609.344),0) as distance
			from
				 owner.owner oo with(nolock,readuncommitted)
		   where
			  oo.is_app_user = 1 
			  and oo.is_deleted = 0
			  and oo.owner_user_id > 0
			  and oo.current_latitude is not null
			  and oo.current_longitude is not null
			  and oo.owner_id <> @owner_id
         )
         select *, ceiling(distance * 300) as duration from nearby_riders where distance <= 10

	
SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [owner].[get_owner_parking]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_owner_parking]
       
	@owner_id int = null

AS        
      
/*
	 exec [owner].[get_owner_parking] 1
	 ----------------------------------  

	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2018     Ready2Ride                      Created
	 -----------------------------------------------------------      
                  Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 

	SET NOCOUNT ON

	set @owner_id = isnull(@owner_id,0)

	select top 1
		op.parking_id,	
		op.owner_id,
		op.cycle_id,
		isnull(op.photo_path,'') as photo_path,
		postion_lat as latitude,
		postion_lon as longitude,
		isnull(op.parking_notes,'') as parking_notes,
		convert(varchar(20), op.parked_dt, 101) as parked_date,
		isnull(unmark_spot,0) as unmark_spot
	from 
		owner.parking op with(nolock,readuncommitted)
		inner join owner.owner oo with(nolock,readuncommitted)
		on oo.owner_id = op.owner_id
	where
		op.owner_id = @owner_id
		and op.is_deleted = 0
		and oo.is_deleted = 0
		and unmark_spot = 0
	order by
		parking_id desc

    SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [owner].[get_owner_settings]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_owner_settings]
       
	@owner_id int

AS        
      
/*
	 exec [owner].[get_owner_settings] 412844
	 ---------------------------------  

    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2018     Ready2Ride                           Created
	 -----------------------------------------------------------      
                  Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 

	SET @owner_id = isnull(@owner_id,0)

	SET NOCOUNT ON
      
			select top 1
				oos.owner_settings_id
			   ,oos.owner_id
			   ,oos.units
			   ,oos.share_my_location_with_friends
			   ,oos.odometer_updates
			   ,oos.gps_logging_frequency
			   ,oos.friend_requests
			   ,oos.accepted_friend_requests
			   ,oos.buddy_who_join_r2r
			   ,oos.direct_messages
			   ,oos.promotion_alerts
			   ,oos.event_alerts
			   ,isnull(oo.is_private_profile,0) as private_profile
			   ,oos.facebook
			   ,oos.google
			from 
				owner.owner_settings oos with(nolock,readuncommitted)
				left join owner.owner oo with(nolock,readuncommitted)
				on oos.owner_id = oo.owner_id
			where
					oos.owner_id = @owner_id
					and oos.is_deleted = 0
					and oo.is_deleted = 0



    SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [owner].[get_ride_details]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_ride_details]  
	 @ride_id int 
AS        
      
/*
	 exec  [owner].[get_ride_details]   5730

	 ------------------------------------------------------------         
	 PURPOSE    
	 
	 select top 10 * from ride.ride    
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     Warrous                           Created
	 -----------------------------------------------------------      
                 
*/        
BEGIN 
  
	SET NOCOUNT ON 

		SELECT
				rr.ride_id,
				rr.name,
				rrt.name as ride_type,
				rr.description,
				rr.start_geo_lat,
				rr.start_geo_lon,
				rr.end_geo_lat,
				rr.end_geo_long,
				rr.start_date,
				rr.end_date,
				rr.is_ride_saved,
				rr.is_read,
				rr.created_dt,
				ride.get_ride_happend(rr.end_date) as ride_happend
		FROM 
				ride.ride rr with(nolock,readuncommitted) 
				inner join ride.ride_type rrt with(nolock,readuncommitted)
				on rr.ride_type_id = rrt.ride_type_id

		where 
				rr.is_deleted = 0  
				and rr.is_ride_saved = 1 
				and rr.ride_id = @ride_id
		order by
				rr.ride_id desc

	SET NOCOUNT OFF

	END
GO
/****** Object:  StoredProcedure [owner].[get_riders]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_riders] 

	@dealer_id int = null 

AS        
      
/*
	 exec  [owner].[get_riders] 2999
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Date
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 05/09/2019                                Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON

	set @dealer_id = isnull(@dealer_id,0)

	if(@dealer_id = 0 or @dealer_id is null)
		begin
			select 
				oo.dealer_id,
				oo.fname,
				oo.lname,
				oo.owner_id,
				oo.address1,
				oo.mobile
			from
				owner.owner oo with(nolock,readuncommitted)
				inner join dbo.Users du with(nolock,readuncommitted)
				on du.UserId = oo.owner_user_id
			where 
				oo.is_deleted = 0 
				and du.IsDeleted = 0
				and isnull(oo.owner_user_id,0) > 0
		end
	else
		begin
			select 
				oo.dealer_id,
				oo.fname,
				oo.lname,
				oo.owner_id,
				oo.address1,
				oo.mobile
			from
				owner.owner oo with(nolock,readuncommitted) 
				inner join dbo.Users du with(nolock,readuncommitted)
				on du.UserId = oo.owner_user_id
			where 
				oo.dealer_id = @dealer_id 
				and oo.is_deleted = 0 
				and du.IsDeleted = 0
				and isnull(oo.owner_user_id,0) > 0
				and is_private_profile = 0
		end
	

SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [owner].[get_rides]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[get_rides]  
	 @owner_id int 
AS        
      
/*
	 exec  [owner].[get_rides] 259866

	 ------------------------------------------------------------         
	 PURPOSE    
	 
	 select top 10 * from ride.ride    
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     Warrous                           Created
	 -----------------------------------------------------------      
                 
*/        
BEGIN 
  
	SET NOCOUNT ON 

		SELECT
				rr.cycle_id,
				rr.ride_id,
				rr.name,
				rrt.name as ride_type,
				rr.description,
				rr.start_geo_lat,
				rr.start_geo_lon,
				rr.end_geo_lat,
				rr.end_geo_long,
				rr.start_location,
				rr.end_location,
				rr.is_mileage_share,
				rr.is_weather_alert,
				rr.is_buddy_invite,
				rr.is_ride,
				rr.start_date,
				rr.end_date,
				rr.is_ride_started,
				rr.is_ride_ended,
				rr.is_ride_saved,
				rr.is_read,
				rr.created_dt,
				ride.get_ride_happend(rr.end_date) as ride_happend
		FROM 
				ride.ride rr with(nolock,readuncommitted) 
				inner join ride.ride_type rrt with(nolock,readuncommitted)
				on rr.ride_type_id = rrt.ride_type_id

		where 
				rr.is_deleted = 0  
				and rr.is_ride_saved = 1 
				and owner_id = @owner_id
		order by
				rr.ride_id desc

	SET NOCOUNT OFF

	END
GO
/****** Object:  StoredProcedure [owner].[get_selected_dealer]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[get_selected_dealer]
 @owner_id int

AS

/*     
	exec [owner].[get_selected_dealer] 406269 
	--------------------------------------------------------------       
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
    09/12/2018      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
SET NOCOUNT ON;
 
BEGIN

 With selected_dealers As
		(select ood.dealer_id,
			    ood.owner_id,
			    ood.is_default,
			    isnull(pd.dealer_name,'') as dealer_name,
			    isnull((select email from r2r_portal.dbo.Users du inner join r2r_portal.portal.user_claims puc on du.UserId = puc.user_id and puc.claim_type_id = 1 and puc.claim_value = pd.dealer_id and email is not null),'') as email, 
				isnull(pd.dealer_phone,'') as dealer_phone,
				isnull(pd.custom_image_path,'') as background_image,
				isnull(pd.web_site,'') as web_site,
				isnull(pddd.address1,'') as street_address,
				isnull((select state_name from area.states where state_code=pddd.state_code),'') as state_name,    
				isnull(pddd.city,'') as city,
				isnull(pddd.zipcode,'') as zip_code
			    
		from owner.owner_dealers  ood with (nolock,readuncommitted)
			inner join portal.dealer pd with(nolock,readuncommitted) on
			pd.dealer_id = ood.dealer_id
			left join portal.dealer_dept_details pddd with(nolock,readuncommitted)
			on pd.dealer_id = pddd.dealer_id
		WHERE   
			ood.owner_id=@owner_id and
			ood.is_deleted = 0 and 
			pd.is_deleted = 0						   				
	union all
		select top 1
				oo.dealer_id,
				oo.owner_id,
				oo.is_default,
				isnull(pd.dealer_name,'') as dealer_name,
			    isnull((select email from r2r_portal.dbo.Users du inner join r2r_portal.portal.user_claims puc on du.UserId = puc.user_id and puc.claim_type_id = 1 and puc.claim_value = pd.dealer_id and email is not null),'') as email, 
				isnull(pd.dealer_phone,'') as dealer_phone,
				isnull(pd.custom_image_path,'') as background_image,
				isnull(pd.web_site,'') as web_site,
				isnull(pddd.address1,'') as street_address,
				isnull((select state_name from area.states where state_code=pddd.state_code),'') as state_name,    
				isnull(pddd.city,'') as city,
				isnull(pddd.zipcode,'') as zip_code
		from owner.owner oo with (nolock,readuncommitted)
		inner join portal.dealer pd with(nolock,readuncommitted) on
			pd.dealer_id = oo.dealer_id
			left join portal.dealer_dept_details pddd with(nolock,readuncommitted)
			on pd.dealer_id = pddd.dealer_id
		WHERE   
			oo.owner_id=@owner_id and
			oo.is_deleted = 0 and
			pd.is_deleted = 0 and
			oo.is_default = 1

	order by is_default desc)

	select distinct * from selected_dealers order by is_default desc

END

SET NOCOUNT OFF;    
GO
/****** Object:  StoredProcedure [owner].[group_owner_profile_details]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE procedure [owner].[group_owner_profile_details]

	@owner_id int,
	@group_id int
AS        
      
/*
	 exec [owner].[group_owner_profile_details] 412859,116
	 ------------------------------------------------------------         
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 05/15/2019     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

	declare @attending_events_count int = 0;
	declare @saved_promotions_count int = 0;
	declare @dealership_count int = 0;
	declare @buddies_count int = 0;
	declare @groups_count int = 0
	declare @groups_discussions_count int = 0;

	;WITH CTE_AttendingEvents AS 
	(SELECT distinct
		isnull(ev.event_id ,0)as id,
		isnull(ev.event_name,'') as name,
		isnull(ev.event_title,'') as title,
		isnull(ev.event_description,'') as description,
		ev.start_date,
		ev.exp_date,
		isnull(ev.start_time,'12:00 AM') as start_time,
		isnull(ev.end_time,'12:00 PM') as end_time,
		isnull(ev.street,'') as address,
		isnull(ev.city,'') as city,
		isnull(ev.zip_code,'') as zip_code,
		isnull(ev.state,'') as state,
		isnull(lattitude,0) as latitude,
		isnull(longitude,0) as longitude,
		isnull(footer_description,'') as footer_description,
		isnull(event_image_path,'') as image,
		'Event' as type

	 FROM 
		event.events ev WITH(NOLOCK,readuncommitted)
		inner join owner.owner_events oe
		on ev.event_id = oe.event_id
		inner join owner.owner oo WITH(NOLOCK,readuncommitted)
		on oo.owner_id = oe.owner_id

	 WHERE
		ev.is_deleted = 0 and 
		oo.owner_id = @owner_id
		and ev.is_attending = 1
		and oe.is_deleted = 0
		and oo.is_deleted = 0)
		select @attending_events_count  = count(*) from CTE_AttendingEvents

	;WITH CTE_SavedPromotions AS 
	(SELECT distinct
		isnull(ep.promotion_id,0) as id,
		isnull(ep.promotion_name,'') as name,
		isnull(ep.title,'') as title,
		isnull(ep.description,'') as description,
		ep.start_date,
		ep.end_date as exp_date,
		isnull(ep.promo_code,'') as promo_code,
		0 as latitude,
		0 as longitude,
		isnull(footer_description,'') as footer_description,
		isnull(promotion_image_path,'') as image,
		'Promotion' as type

	FROM 
		event.promotions ep WITH(NOLOCK,readuncommitted)
		inner join owner.owner_promotions op
		on ep.promotion_id = op.promotion_id
		inner join owner.owner oo WITH(NOLOCK,readuncommitted)
		on oo.owner_id = op.owner_id
		
	WHERE
		ep.is_deleted = 0 and 
		oo.owner_id = @owner_id
		and op.is_saved = 1
		and op.is_deleted = 0
		and oo.is_deleted = 0)
		select @saved_promotions_count  = count(*) from CTE_SavedPromotions

	;WITH CTE_Buddies AS 
	(SELECT distinct
		isnull(bb.buddy_id ,0)as buddy_id,
		'Buddies' as type
	 FROM 
		buddy.buddy bb with(nolock,readuncommitted)
		inner join owner.owner oo with(nolock,readuncommitted)
		on oo.owner_id = bb.sender_id

	 WHERE
		bb.is_deleted = 0 and 
		bb.sender_id = @owner_id
		and bb.is_request_accepted = 1
		and oo.is_deleted = 0)
		select @buddies_count  = count(*) from CTE_Buddies

	;WITH CTE_Groups AS 
	(select 
		   bg.group_id
	 from 
		 buddy.groups bg with(nolock,readuncommitted)
		 inner join [owner].[owner_group] og with(nolock,readuncommitted)
		 on (og.group_id=bg.group_id)
	 where 
		  og.owner_id = @owner_id and 
		  bg.is_deleted=0 and
		  og.is_deleted=0)
	 select @groups_count  = count(*) from CTE_Groups

	;WITH CTE_GroupDiscussions AS
		(select 
			ogd.discussion_id
		 from 
			  [owner].[group_discussion] ogd with(nolock,readuncommitted)
			  inner join owner.owner oo with(nolock,readuncommitted)
			  on oo.owner_id =  ogd.owner_id
		 where 
			ogd.owner_id = @owner_id
			and ogd.group_id = @group_id
			and ogd.is_deleted = 0
			and oo.is_deleted = 0)
	  select @groups_discussions_count  = count(*) from CTE_GroupDiscussions
		 			  
	select isnull(oo.fname,'') as fname,
		   isnull(oo.lname,'') as lname,
		   isnull(oo.photo,'') as photo,
		   isnull(oo.bground_image,'') as bground_image,
		   isnull(oo.mobile,'') as mobile,
		   isnull((select count(distinct dealer_id) from owner.owner_dealers with(nolock,readuncommitted) where owner_id = @owner_id and dealer_id is not null and is_deleted=0),0) as dealership_count,
		   isnull(@groups_count,0) as group_count,
		   isnull((Select sum(([dbo].[get_distance_by_lat_long](rr.start_geo_lat,rr.start_geo_lon,rr.end_geo_lat,rr.end_geo_long)/1609.34) )from r2r_admin.ride.ride rr with (nolock,readuncommitted) where owner_id = @owner_id),0) as ride_distance ,
		   cast(convert(varchar, cast(isnull((select sum(([dbo].[get_distance_by_lat_long](rr.start_geo_lat,rr.start_geo_lon,rr.end_geo_lat,rr.end_geo_long)/1609.34) )from r2r_admin.ride.ride rr with (nolock,readuncommitted) where rr.owner_id = @owner_id),0) as money), 1) as varchar) as mile_distance,
		   isnull((select count(*) from r2r_admin.ride.ride r with(nolock,readuncommitted) where r.owner_id = @owner_id and r.is_deleted=0 and r.is_ride_saved = 1),0) as rides_count,
		   isnull(0,0) as rides_time,
		   isnull((select count(*) from cycle.cycle with(nolock,readuncommitted) where owner_id = @owner_id and is_deleted=0),0) as garage,
		   isnull(@buddies_count,0) as buddies,
		   isnull((@attending_events_count + @saved_promotions_count),0) as wallet,
		   isnull(@groups_discussions_count,0) as posts,
		   case when isnull(oo.is_private_profile,0) = 1 then 'Private' else 'Public' end as profile_mode 
		   from 
				owner.owner as oo with(nolock,readuncommitted) 
           where 
				oo.owner_id=@owner_id and 
				oo.is_deleted = 0

	

SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [owner].[insert_deeplink_json]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[insert_deeplink_json]  

@deeplink_json nvarchar(max)
   
AS        
      
/*
	 exec  [owner].[insert_deeplink_json]   
	 ------------------------------------------------------------         
    
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

      insert into
	         owner.deeplink_data
			  (
			    deeplink_json
			  )
			  values
			  (
			   @deeplink_json
			  )
	
SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [owner].[join_group]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[join_group]

	@owner_id int = null,
	@group_id int = null,
	@name varchar(max) = ''

AS        
      
/*
	 exec [owner].[join_group] 404923,2,''
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Date
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 05/15/2019     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

	declare @is_exists int = 0
	declare @members_count int = 0

	set @is_exists = ( select 
							count(owner_group_id) 
						from 
							owner.owner_group with(nolock,readuncommitted) 
						where 
							group_id = @group_id 
							and owner_id = @owner_id
							and is_deleted = 0
					 )

	set @is_exists = isnull(@is_exists,0)

	IF(@is_exists = 0)
		BEGIN

			insert into owner.owner_group
			(
				group_id,
				owner_id,
				is_deleted
			)
			values
			(
				@group_id,
				@owner_id,
				0
			)

		END
	ELSE If(@is_exists = 1)
		BEGIN

			update 
				 owner.owner_group
			set
				group_id = @group_id,
				owner_id = @owner_id
			where
				group_id = @group_id and
				owner_id = @owner_id and
				is_deleted = 0

		END
	ELSE
		BEGIN

			update 
				 owner.owner_group
			set
				is_deleted = 1
			where
				group_id = @group_id and
				owner_id = @owner_id and
				is_deleted = 0

			insert into owner.owner_group
			(
				group_id,
				owner_id,
				is_deleted
			)
			values
			(
				@group_id,
				@owner_id,
				0
			)

		END

	set @members_count = (  select 
								count(oog.owner_group_id)
						    from 
							    owner.owner_group oog with(nolock,readuncommitted)
								inner join owner.owner oo with(nolock,readuncommitted)
								on oo.owner_id = oog.owner_id
							where 
								oog.group_id = @group_id 
								and oog.is_deleted = 0
								and oo.is_deleted = 0 
						  )

	set @members_count = isnull(@members_count,0)

	update 
		 buddy.groups
	set
		group_member_count = isnull(@members_count,0)
	where
		group_id = @group_id


SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [owner].[leave_group]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[leave_group]

	@owner_id int = null,
	@group_id int = null
	
AS        
      
/*
	 exec [owner].[leave_group] 404923,9
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Date
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

	declare @members_count int = 0

	update 
		owner.owner_group
	set 
		is_deleted=1
	where 
		owner_id = @owner_id 
		and group_id = @group_id

	set @members_count = (  select 
								count(oog.owner_group_id)
						    from 
							    owner.owner_group oog with(nolock,readuncommitted)
								inner join owner.owner oo with(nolock,readuncommitted)
								on oo.owner_id = oog.owner_id
							where 
								oog.group_id = @group_id 
								and oog.is_deleted = 0
								and oo.is_deleted = 0 )

	set @members_count = isnull(@members_count,0)

	update 
		 buddy.groups
	set
		group_member_count = isnull(@members_count,0)
	where
		group_id = @group_id

SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [owner].[owner_details]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE procedure [owner].[owner_details]

	@owner_id int = null
AS        
      
/*
	 exec [owner].[owner_details] 829685
	 ------------------------------------------------------------         
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 05/15/2019     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 
	 
		 			  
	select 
		   top 1
		   isnull(oo.fname,'') as fname,
		   isnull(oo.lname,'') as lname,
		   isnull(oo.photo,'') as photo,
		   isnull(oo.bground_image,'') as bground_image,
		   isnull(oo.mobile,'') as mobile,
		   oo.owner_id,
		   isnull(oo.is_private_profile,0) as is_private_profile,
		   isnull(bio,'') as owner_bio
	from 
		[owner].[owner] as oo with(nolock,readuncommitted) 
    where 
		oo.owner_id = @owner_id

	

SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [owner].[owner_profile_details]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE procedure [owner].[owner_profile_details]

	@owner_id int,
	@following_id int = 0
AS        
      
/*
	 exec [owner].[owner_profile_details] 425247,717751
	 ------------------------------------------------------------         
    
	 PROCESSES			
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 05/15/2019     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

	declare @attending_events_count int = 0;
	declare @saved_promotions_count int = 0;
	declare @dealership_count int = 0;
	declare @buddies_count int = 0;
	declare @groups_count int = 0;
	declare @groups_discussions_count int = 0;
	declare @rides_distance decimal(10,2) = 0;
	declare @rides_duration decimal(10,2) = 0;
	declare @followers_count int;
	declare @following_count int;
	declare @primary_bike int;
	declare @is_follow_count int;
	declare @is_follow_request_count int;

	set @followers_count = (
	                          select count(receiver_id) from
							   [buddy].[buddy] WITH(NOLOCK,readuncommitted)
							   where is_deleted = 0 and receiver_id = @owner_id
							   and is_request_accepted = 1
	                       )
     set @following_count = (
	                          select count(sender_id) from
							   [buddy].[buddy] WITH(NOLOCK,readuncommitted)
							   where is_deleted = 0 and sender_id = @owner_id 
							  and is_request_accepted = 1
	                       )
     
	  set @is_follow_count = (
	                          select sender_id from
							   [buddy].[buddy] WITH(NOLOCK,readuncommitted)
							   where 
							   (sender_id =  @following_id
							   and receiver_id = @owner_id and is_request_accepted = 1 and is_deleted = 0)
							   or (sender_id = @owner_id and receiver_id = @following_id and is_request_accepted = 1 and is_deleted = 0	)
							   						   
	                       )
     set @is_follow_count = isnull(@is_follow_count,'')

     set @is_follow_request_count = (
	                              select sender_id from
							      [buddy].[buddy] WITH(NOLOCK,readuncommitted)
							    where 
							       (sender_id = @following_id
							      and receiver_id = @owner_id and is_deleted = 0 and is_request_accepted = 0)
								  or (sender_id = @owner_id and receiver_id = @following_id and is_deleted = 0 and is_request_accepted = 0)
							      
	                       )
set @is_follow_request_count = isnull(@is_follow_request_count,'')
						   

	;WITH CTE_AttendingEvents AS 
	(SELECT distinct
		isnull(ev.event_id ,0)as id,
		'Event' as type
	 FROM 
		owner.owner_events oe  WITH(NOLOCK,readuncommitted)
		inner join event.events ev
		on ev.event_id = oe.event_id

	 WHERE
		ev.is_deleted = 0 and 
		oe.owner_id = @owner_id
		and oe.is_attending = 1
		and oe.is_deleted = 0)
		select @attending_events_count  = count(*) from CTE_AttendingEvents

	;WITH CTE_SavedPromotions AS 
	(SELECT distinct
		isnull(ep.promotion_id,0) as id,
		'Promotion' as type

	FROM 
		event.promotions ep WITH(NOLOCK,readuncommitted)
		inner join owner.owner_promotions op
		on ep.promotion_id = op.promotion_id
		inner join owner.owner oo WITH(NOLOCK,readuncommitted)
		on oo.owner_id = op.owner_id
		
	WHERE
		ep.is_deleted = 0 and 
		oo.owner_id = @owner_id
		and op.is_saved = 1
		and op.is_deleted = 0
		and oo.is_deleted = 0)
		select @saved_promotions_count  = count(*) from CTE_SavedPromotions

	;WITH CTE_Buddies AS 
	(SELECT
			isnull(bb.buddy_id,0) as buddy_id,
			isnull(oo.owner_id,0) as owner_id
		FROM
			buddy.buddy bb with(nolock,readuncommitted)
			inner join owner.owner oo with(nolock,readuncommitted)
			on oo.owner_id = bb.receiver_id
		WHERE
			bb.is_deleted = 0
			and oo.is_deleted = 0   
			and sender_id = @owner_id
			and is_request_accepted = 1
			and oo.owner_id is not null

	 UNION

		SELECT
			isnull(bb.buddy_id,0) as buddy_id,
			isnull(oo.owner_id,0) as owner_id
		FROM
			buddy.buddy bb with(nolock,readuncommitted)
			inner join owner.owner oo with(nolock,readuncommitted)
			on oo.owner_id = bb.sender_id
		WHERE
			bb.is_deleted = 0
			and oo.is_deleted = 0  
			and receiver_id = @owner_id
			and is_request_accepted = 1	
			and oo.owner_id is not null 
	),CTE_Distinct_Buddies as 
		(select  
			min(buddy_id) as buddy_id,
			owner_id
		from 
			CTE_Buddies cte with(nolock,readuncommitted)
		group by 
			owner_id
		)
		select @buddies_count = count(buddy_id) from CTE_Distinct_Buddies

	;WITH CTE_Groups AS 
	(select 
		   bg.group_id
	 from 
		 buddy.groups bg with(nolock,readuncommitted)
		 inner join [owner].[owner_group] og with(nolock,readuncommitted)
		 on (og.group_id=bg.group_id)
	 where 
		  og.owner_id = @owner_id and 
		  bg.is_deleted=0 and
		  og.is_deleted=0)
	 select @groups_count  = count(*) from CTE_Groups

	;WITH CTE_GroupDiscussions AS
		(select 
			ogd.discussion_id
		 from 
			  [owner].[group_discussion] ogd with(nolock,readuncommitted)
			  inner join owner.owner oo with(nolock,readuncommitted)
			  on oo.owner_id =  ogd.owner_id
		 where 
			ogd.owner_id = @owner_id
			and ogd.is_deleted = 0
			and oo.is_deleted = 0)
	  select @groups_discussions_count  = count(*) from CTE_GroupDiscussions

	;WITH CTE_RidesDistance AS
		 (  SELECT
					isnull([ride].[get_ride_log_distance](rr.ride_log),0) as distance
			FROM 
					ride.ride rr with(nolock,readuncommitted) 
					inner join ride.ride_type rrt with(nolock,readuncommitted)
					on rr.ride_type_id = rrt.ride_type_id

			where 
					rr.is_deleted = 0  
					and rr.is_ride_saved = 1 
					and owner_id = @owner_id
		  )
		 select @rides_distance  = sum(distance) from CTE_RidesDistance where isnumeric(distance) = 1

	;WITH CTE_RidesDuration AS
		 (  select 
				isnull([ride].[get_ride_log_time](rr.ride_log),0) as duration
			from 
				ride.ride rr with (nolock,readuncommitted)
				left join ride.ride_type rrt  with (nolock,readuncommitted)
				on rrt.ride_type_id = rr.ride_type_id
			where 
				owner_id = @owner_id and
				rr.is_ride_saved = 1 and
				rr.is_deleted = 0
		  )
		 select @rides_duration  = abs(sum(duration)) from CTE_RidesDuration where isnumeric(duration) = 1
		 			  
	select top 1
	    oo.owner_id,
		isnull(oo.fname,'') as fname,
		isnull(oo.lname,'') as lname,
		isnull(oo.photo,'') as photo,
		isnull(oo.bground_image,'') as bground_image,
		isnull(oo.mobile,'') as mobile,
		isnull((select count(distinct dealer_id) from owner.owner_dealers with(nolock,readuncommitted) where owner_id = @owner_id and dealer_id is not null and is_deleted=0),0) as dealership_count,
		isnull(@groups_count,0) as group_count,
		cast(isnull((@rides_distance/1609.34),0) as decimal(10,4)) as ride_distance,
		isnull([ride].[get_ride_time_from_seconds](@rides_duration),'00:00:00') as rides_duration,
		cast(convert(varchar, cast(isnull((@rides_distance/1609.34),0) as money), 1) as varchar) as mile_distance,
		isnull((select count(*) from ride.ride r with(nolock,readuncommitted) where r.owner_id = @owner_id and r.is_deleted=0 and r.is_ride_saved = 1),0) as rides_count,
		cast(isnull(@rides_duration,0) as int) as rides_time,
		isnull((select count(*) from cycle.cycle with(nolock,readuncommitted) where owner_id = @owner_id and is_deleted=0),0) as garage,
		isnull(@buddies_count,0) as buddies,
		isnull((@attending_events_count + @saved_promotions_count),0) as wallet,
		isnull(@groups_discussions_count,0) as posts,
		case when isnull(oo.is_private_profile,0) = 1 then 'Private' else 'Public' end as profile_mode,
		@followers_count as followers_count,
		@following_count as following_count,
		case when cc.brand_id != 0 then (select brand_name from [cycle].[brand_v1] where is_deleted = 0 and brand_id = cc.brand_id) else '' end as brand_name,
		case when cc.model_id != 0 then (select model from [cycle].[model_v1] where is_deleted = 0 and model_id = cc.model_id) else '' end as model_name,
		cc.year,
		oo.bio as owner_bio,
		--case when @is_follow_count = 0 then convert (bit, 0) else convert (bit, 1)  end  is_followed_by_user,
		case when @is_follow_count != '' then 'Accepted'
		when @is_follow_request_count != '' then 'Requested'
		when @is_follow_count = '' and @is_follow_request_count = '' then '' 
	    end  is_followed_by_user,
		isnull(oo.address1,'') as address1,
		isnull(oo.address2,'') as address2,
		isnull(oo.city,'') as city,
		isnull(oo.state,'') as state,
		isnull(oo.zip,'') as zip,
		isnull((select buddy_id from [buddy].[buddy] where (sender_id = @following_id and receiver_id = @owner_id and is_deleted = 0) or (sender_id = @owner_id and receiver_id = @following_id and is_deleted = 0) and is_request_accepted = 1 and is_deleted = 0),0) as buddy_id
		from 
			[owner].[owner] as oo with(nolock,readuncommitted)
			left join [cycle].[cycle] cc  with(nolock,readuncommitted)
			on oo.owner_id = cc.owner_id and cc.is_default = 1 and cc.is_deleted = 0
			left join [buddy].[buddy] bb with(nolock,readuncommitted)
			on oo.owner_id = bb.sender_id and bb.is_request_accepted = 1
        where 
			oo.owner_id = @owner_id 
	

SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [owner].[owner_user_id_save]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[owner_user_id_save]  
 @owner_user_id int,
 @email varchar(500),
 @mobile varchar(20)= '',
 @fname nvarchar(50),
 @lname nvarchar(50),
 @profile_image varchar(max) = '',
 @bg_image varchar(max) = '',
 @dealer_id int = 37429

AS

/* 
	exec [owner].[owner_user_id_save] 
	--------------------------------------------------------------       
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
    10/31/2019      Vishnu T                            Created 
	-------------------------------------------------------------- 
	               Copyright 2019 Ready2Ride
*/ 

 /* Setup */ 
 SET NOCOUNT ON;

	declare @count int = 0;
	declare @owner_id int = 0; 
	declare @settings_count int = 0

	set @mobile = nullif(ltrim(rtrim(@mobile)),'')
	set @dealer_id = IIF(@dealer_id > 0, @dealer_id, 37429);
					
	update 
		 dbo.Users
	set
		FirstName = isnull(@fname,''),
		LastName = isnull(@lname,''),
		PhoneNumber = @mobile,
		UpdatedDt = getdate()
	where
		UserId = @owner_user_id

	select @count = (	select 
							count(oo.owner_id) 
						from 
							owner.owner oo with(nolock,readuncommitted) 
						where 
							ltrim(rtrim(oo.email)) = ltrim(rtrim(@email))
							and oo.is_deleted = 0 
					 )

	if(isnull(@count,0) = 0)
	begin
		select @count = ( select 
							 count(oo.owner_id) 
						  from 
							 owner.owner oo with(nolock,readuncommitted) 
						  where 
							 right(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(oo.mobile,'(',''),')',''),'-',''),' ',''))),10) = right(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(@mobile,'(',''),')',''),'-',''),' ',''))),10)
							 and oo.is_deleted = 0 
						)
	end

	if(isnull(@count,0) = 0)
	BEGIN
	
			INSERT INTO owner.owner
			(
				dealer_id,
				email,
				owner_user_id,
				is_app_user,
				photo,
				photo_path,
				app_user_sign_up_dt,
				mobile,
				fname,
				lname,
			    bground_image,
				is_deleted
			)
			VALUES
			(
				 @dealer_id,
				 @email,
				 @owner_user_id,
				 1,
				 @profile_image,
				 @profile_image,
				 getdate(),
				 @mobile,
				 @fname,
				 @lname,
				 @bg_image,
				 0
			) 

			SET @owner_id = SCOPE_IDENTITY()

	END
	ELSE
	BEGIN

			set @owner_id = (	select 
									top 1 owner_id
								from 
									owner.owner with(nolock, readuncommitted) 
								where 
									ltrim(rtrim(email)) = ltrim(rtrim(@email))
								    and is_deleted = 0
								order by 
									owner_id asc
							)

			if(@owner_id is null or @owner_id = 0)
			begin
				set @owner_id = (	select 
										top 1 owner_id
									from 
										owner.owner with(nolock, readuncommitted) 
									where 
										right(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(mobile,'(',''),')',''),'-',''),' ',''))),10) = right(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(@mobile,'(',''),')',''),'-',''),' ',''))),10)
										and is_deleted = 0
									order by 
										owner_id asc
								)
			end

			if(@owner_id is not null)
			begin
 
			UPDATE 
				owner.owner
			SET
				owner_user_id = @owner_user_id,
				dealer_id = IIF(isnull(nullif(dealer_id,37429),0) > 0, dealer_id, @dealer_id),
				is_app_user = 1,
				photo = @profile_image,
				photo_path = @profile_image,
				bground_image = @bg_image,
				app_user_sign_up_dt = getdate(),
				fname = @fname,
				lname = @lname,
				mobile = @mobile,
				email = isnull(email, @email),
				is_deleted = 0,
				updated_dt = getdate()
			WHERE
				owner_id = @owner_id

			UPDATE 
				owner.owner
			SET
				email = @email
			WHERE
				owner_id = @owner_id
				and (email is null or ltrim(rtrim(email)) = '')

			end

		 END

	set @settings_count = (	select
								count(*)
							from
								owner.owner_settings with(nolock,readuncommitted)
							where
								is_deleted = 0 and
								owner_id = @owner_id
						  )

	if(isnull(@settings_count,0) = 0)
	begin
	 insert into owner.owner_settings
	 (owner_id)
	 values
	 (@owner_id)
	end

	set @dealer_id = ( select top 1 isnull(nullif(dealer_id, 37429),0) from owner.owner (nolock) where owner_id = @owner_id )

	if(@dealer_id > 0)
	begin
		update owner.owner_dealers set is_deleted = 1 where owner_id = @owner_id and dealer_id = @dealer_id

		insert into owner.owner_dealers (owner_id, dealer_id, is_default, is_deleted) values (@owner_id, @dealer_id, 1, 0)
	end

	select @owner_id as owner_id

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [owner].[promotion_department_details]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[promotion_department_details]

	@owner_id int
AS

/* 
	exec [owner].[promotion_department_details] 412968
	--------------------------------------------------------------      
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
    15/09/2019      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 SET NOCOUNT ON;
 
	declare @instore_signup_id int = 0
	declare @first_name varchar(100) = ''
	declare @last_name varchar(100) = ''
	declare @email_address varchar(500) = ''
	declare @dept_email_address varchar(500) = ''

	select top 1
		@first_name = isnull(fname,''),
		@last_name = isnull(lname,''),
		@email_address = isnull(email,''),
		@instore_signup_id = isnull(instore_signup_id,0)
	from
		owner.owner with(nolock,readuncommitted)
	where 
		is_deleted = 0 
		and owner_id = @owner_id

	set @dept_email_address = (  select top 1 
									isnull(pddd.email_address,'')
								 from
									 r2r_portal.portal.dealer_dept_details pddd with(nolock,readuncommitted)
									 left join owner.instore_signup ois with(nolock,readuncommitted)
									 on pddd.department_id = ois.department_id and pddd.dealer_id = ois.dealer_id
								 where
									 pddd.is_deleted = 0 and
									 ois.instore_signup_id = @instore_signup_id
								)	 
	
	print @dept_email_address

	select @first_name as first_name,
		   @last_name as last_name,
		   @dept_email_address as email_address				
	
 SET NOCOUNT OFF    
GO
/****** Object:  StoredProcedure [owner].[redeem_promotion]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[redeem_promotion]

	@owner_id int,  
	@promotion_id int
 
AS

/* 
	exec [owner].[redeem_promotion] 404923,9874
	--------------------------------------------------------------
	select * from  owner.owner_promotions      
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
    15/09/2019      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 SET NOCOUNT ON;
 
	 BEGIN
	
		update 
			 owner.owner_promotions
		set
			is_redeemed = 1,
			updated_dt = getdate()
		where
			owner_id = @owner_id
			and promotion_id = @promotion_id
	
	 END  
 
 SET NOCOUNT OFF    
GO
/****** Object:  StoredProcedure [owner].[remove_feed_follower]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[remove_feed_follower]

    @owner_id int,
	@following_id int
AS        
      
/*
	 exec [owner].[remove_feed_follower] 0
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


		     update
			     owner.feed_followers
             set
			    is_deleted = 1
             where
				   owner_id = @owner_id
				   and following_id = @following_id
				   and is_deleted = 0

 
SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [owner].[remove_owner_feed]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[remove_owner_feed]

    @owner_id int,
    @feed_id int
	
AS        
      
/*
	 exec [owner].[save_feed_follower] 716081,
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

	    
		     update
			     [owner].[feeds]
             set
			     is_deleted = 1
             where
			      is_deleted = 0
				  and feed_id = @feed_id
				  and owner_id = @owner_id

 
SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [owner].[save_alert]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[save_alert]  
 @alert_id int=null,
 @owner_id int = null,
 @cycle_id int = null,
 @service_category_id int = null,
 @alert_by varchar(100) = null,
 @last_serviced varchar(100) = null,
 @every varchar(100) = null,
 @remainder varchar(100) = null

AS

/*	
	exec [owner].[save_alert] 
	select * from owner.alerts
	--------------------------------------------------------------       
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
	04/29/2019      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 SET NOCOUNT ON;

    

 IF(@alert_id is null or  @alert_id=0)
 BEGIN
	
	INSERT INTO [owner].[alerts] 
	(
		 owner_id,
		 cycle_id,
		 service_category_id,
		 alert_by,
		 last_serviced,
		 suggested,
		 every,
		 remainder
	)
	VALUES
	(
		 @owner_id,
		 @cycle_id,
		 @service_category_id,
		 @alert_by,
		 @last_serviced,
		 [alert].[get_service_suggestion](@last_serviced,@alert_by,@every),
		 @every,
		 @remainder
	)

	update cycle.cycle set last_service = @last_serviced where cycle_id = @cycle_id and owner_id = @owner_id
	
 END  
 ELSE
 BEGIN
 
	UPDATE 
		[owner].[alerts] 
	SET
		owner_id = @owner_id,
		service_category_id = @service_category_id,
		alert_by = @alert_by,
		last_serviced = @last_serviced,
		suggested = [alert].[get_service_suggestion](@last_serviced,@alert_by,@every),
		every = @every,
		@remainder = @remainder
		
	WHERE
		alert_id = @alert_id  

		update cycle.cycle set last_service = @last_serviced where cycle_id = @cycle_id and owner_id = @owner_id
 END 
GO
/****** Object:  StoredProcedure [owner].[save_discussion_comments]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE procedure [owner].[save_discussion_comments]
 @discussion_comment_id int,
 @discussion_comments varchar(max) = null,
 @image_url varchar(max) = null,
 @discussion_id int,
 @owner_id int

AS

/* exec [owner].[save_discussion_comments]
	--------------------------------------------------------------       
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
  04/29/2019      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 SET NOCOUNT ON;

    declare @id int
	declare @count int
	declare @group_id int
	select  @group_id = group_id from owner.group_discussion where discussion_id = @discussion_id
	select  @count = count(*) from owner.owner_group where group_id = @group_id and owner_id = @owner_id and is_deleted = 0

if(@discussion_comment_id = 0 and @count > 0)
	 BEGIN
	
		INSERT INTO [owner].[discussion_comments]
		(
			 discussion_id,
			 discussion_comments,
			 image_url,
			 owner_id
		)
		VALUES
		(
			@discussion_id,
			@discussion_comments,
			@image_url,
			@owner_id
		)
		select 'Success' as message
	 END  
 ELSE
	 BEGIN
 
		UPDATE [owner].[discussion_comments]
		SET
			discussion_comments = @discussion_comments,
			image_url = @image_url	
		
		WHERE
			discussion_comment_id = @discussion_comment_id and is_deleted = 0
			select 'Success' as message
	 END 
GO
/****** Object:  StoredProcedure [owner].[save_feed_comments]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[save_feed_comments]

	@owner_id int,
    @feed_id int,
	@comment nvarchar(max)= null,
	@image_url nvarchar(max) = null
AS        
      
/*
	 exec [owner].[save_feed_comments] 412998,48,'Hi1',''
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

		declare @is_exists int;
		declare @comments int = 0;
		declare @feed_comment_id int;
		--set @is_exists = (
  --                    select 
		--			       feed_comment_id
  --                    from
		--			      feed.comments with(nolock,readuncommitted)
  --                     where
		--			       feed_id = @feed_id
		--				   and owner_id = @owner_id
		--				   and is_deleted = 0 
  --                 )


		--if(isnull(@is_exists,0) = 0)    
		--begin

		    insert into feed.comments
			(
				feed_id,
				owner_id,
				feed_comments,
				image_url
			)
			values
			(
				@feed_id,
				@owner_id,
				@comment,
				@image_url
			)
	--	end
	 --   else
		--begin
		  
		--	update
		--		feed.comments
		--	set
		--		feed_comments = @comment,
		--		image_url = @image_url
		--	where
		--		feed_id = @feed_id
		--		and owner_id = @owner_id
		--		and is_deleted = 0

		--end
        set @feed_comment_id = SCOPE_IDENTITY()

		set @comments = ( select
							 count([feed_comment_id])
						  from
							 [feed].[comments] fc with(nolock,readuncommitted)
							 inner join [owner].[feeds] ofd with(nolock,readuncommitted)
							 on ofd.feed_id = fc.feed_id
						  where
							 ofd.feed_id = @feed_id
							 and ofd.is_deleted = 0
						 )
		update
			[owner].[feeds]
		set
			comments = @comments
		where
			feed_id = @feed_id


		 select
			      isnull(oo.fname,'')+ ' ' + isnull(oo.lname,'') as owner_name,
				  isnull(oo.photo,isnull(oo.photo_path,'')) as profile_pic,
				  fc.owner_id,
				  fc.feed_id,
				  fc.feed_comments,
				  fc.image_url,
				  fc.created_dt
		from
					feed.comments fc with(nolock,readuncommitted)
					inner join owner.owner oo with(nolock,readuncommitted)
				    on oo.owner_id = fc.owner_id
	   where
				  fc.is_deleted = 0
				  and oo.is_deleted = 0
				  and fc.feed_comment_id= @feed_comment_id

 
SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [owner].[save_feed_follower]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[save_feed_follower]

    @feed_follower_id int,
	@owner_id int,
	@following_id nvarchar(max)
AS        
      
/*
	 exec [owner].[save_feed_follower] 716081,
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

   if(@feed_follower_id = 0)
   begin
    
	insert into
	       owner.feed_followers
		    (
			  owner_id,
			  following_id
			)
			values
			(
			  @owner_id,
			  @following_id
			)

   end
    
	  else
	     begin
		     update
			     owner.feed_followers
             set
			     owner_id = @owner_id,
				 following_id = @following_id
             where
			      is_deleted = 0
				  and feed_follower_id = @feed_follower_id
		 end
 
SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [owner].[save_feed_like]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[save_feed_like]

    @feed_id int,
	@owner_id int
AS        
      
/*
	 exec [owner].[save_feed_like] 1109,425247
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

		declare @is_exists int;
		declare @likes int = 0;
		declare @self_like int = 0;
		declare @total_count int = 0;
		set @is_exists = (
                           select 
					          feed_like_id
                           from
					         feed.likes with(nolock,readuncommitted)
                          where
					          feed_id = @feed_id
						      and owner_id = @owner_id
						      and is_deleted = 0 
                        )

		if(isnull(@is_exists,0) = 0 or @is_exists = '')    
		begin

		     insert into  feed.likes
             (
				feed_id,
				owner_id
             )
             values
             (
                @feed_id,
                @owner_id
             )

			 SELECT SCOPE_IDENTITY() AS feed_like_id 
		end
	 

	else
		begin
		  
		  update
		     feed.likes
		  set
		     is_deleted = 1
          where
		      feed_id = @feed_id
			  and owner_id = @owner_id
			  and is_deleted = 0
		

		--begin

		 --set @total_count = (	select
			--				         count(fl.feed_like_id)
			--			        from
			--				         [owner].[feeds] f with(nolock,readuncommitted)
			--				         inner join feed.likes fl with(nolock,readuncommitted)
			--				    on  f.feed_id = fl.feed_id
			--			        where
			--					    fl.is_deleted = 0
			--					    and f.feed_id = @feed_id
			--		 )
			--  update
			--	 [owner].[feeds]
			--  set
			--	 self_like = @total_count - 1
			--  where
			--	  feed_id = @feed_id
			--	  and is_deleted = 0

		--end
end


		set @likes = (	select
							count(fl.feed_like_id)
						from
							[owner].[feeds] f with(nolock,readuncommitted)
							inner join feed.likes fl with(nolock,readuncommitted)
							on f.feed_id = fl.feed_id
						where
								fl.is_deleted = 0
								and f.feed_id = @feed_id
					 )

		update
		      [owner].[feeds]
		set
		    likes = isnull(@likes,likes)
		where
			 feed_id = @feed_id		 
			 
			 
	--set @self_like = (	select
	--						count(fl.feed_like_id)
	--					from
	--						[owner].[feeds] f with(nolock,readuncommitted)
	--						inner join feed.likes fl with(nolock,readuncommitted)
	--						on f.feed_id = fl.feed_id and f.owner_id = fl.owner_id
	--					where
	--							fl.is_deleted = 0
	--							and f.is_deleted = 0
	--							and f.feed_id = @feed_id
	--							and f.owner_id = @owner_id
	--				 )

	--	update
	--	      [owner].[feeds]
	--	set
	--	    self_like = isnull(@self_like,self_like)
	--	where
	--		 feed_id = @feed_id		


SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [owner].[save_group]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[save_group]

	@owner_id int = null,
	@name varchar(100) = null,
	@description varchar(500) = null,
	@icon varchar(150) = null,
	@mode varchar(50) = 'private',
	@dealer_id int = 0,
	@address varchar(250) = '',
	@latitude decimal(9,6) = 0,
	@longitude decimal(9,6) = 0   

AS        
      
/*
	 exec [owner].[save_group] 327800
	 ------------------------------------------------------------         
	 PURPOSE        
	 select * from [buddy].[groups]
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON

	declare @mode_id int = 0;
	declare @group_id int = 0;
	declare @group_name_count int = 0;

	set @mode = isnull(@mode,'public')

	set @name = isnull(@name,'')

	set @mode_id = ( select top 1
						  bgm.mode_id
					 from 
						  buddy.groups_mode bgm with(nolock,readuncommitted)
					 where
						 bgm.mode = @mode
						 and bgm.is_deleted = 0 )

	set @group_name_count = ( select
									  count(bg.group_id)
								 from 
									  buddy.groups bg with(nolock,readuncommitted)
								 where
									 bg.is_deleted = 0 
									 and bg.name = @name)

	set @group_name_count = isnull(@group_name_count,0)

if(isnull(@group_name_count,0) = 0)
	begin
							  
	insert into buddy.groups 
	(	name,
		description,
		icon,
		mode_id,
		address,
		latitude,
		longitude,
		dealer_id,
		creator_id,
		group_member_count
	)
	values
	(	@name,
		@description,
		@icon,
		@mode_id,
		@address,
		@latitude,
		@longitude,
		@dealer_id,
		@owner_id,
		1
	)

	SET @group_id  = SCOPE_IDENTITY()

	insert into owner.owner_group
	(
		group_id,
		owner_id,
		is_created
	)
	values
	(	@group_id,
		@owner_id,
		1
	)

	select @group_name_count as group_name_count

	end
else
	begin
		select @group_name_count as group_name_count
	end


SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [owner].[save_group_discussion]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE procedure [owner].[save_group_discussion]
	 @group_id int,
	 @owner_id int,
	 @disc_tittle varchar(50) = null,
	 @disc_desc varchar(50) = null,
	 @discussion_id int = 0,
	 @image varchar(250) = null

AS

/* 
	exec [owner].[save_group_discussion]
	--------------------------------------------------------------       
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
	04/29/2019      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 

    declare @id int = 0;
	declare @owner_count int = 0;

	set @owner_count = ( select 
							count(oog.owner_group_id)
						from 
							owner.owner_group oog with(nolock,readuncommitted)
							inner join owner.owner oo with(nolock,readuncommitted)
							on oo.owner_id = oog.owner_id
						where 
							oog.owner_id = @owner_id
							and oog.group_id = @group_id 
							and oog.is_deleted = 0
							and oo.is_deleted = 0
						)

	set @owner_count = isnull(@owner_count,0)

	set @discussion_id = isnull(@discussion_id,0)

	if(@discussion_id = 0)
		begin
			if(@owner_count > 0)
				begin
					insert into [owner].[group_discussion]
					(
						group_id,
						owner_id,
						discussion_title,
						discussion_description,
						image
					)
					values
					(
						@group_id,
						@owner_id,
						@disc_tittle,
						@disc_desc,
						@image
					)
				select 'Success' as message
				end
			else
				begin
					select 'Discussion must be created by group member' as message
				end
		end
	 else
		begin
			update 
				[owner].[group_discussion]
			set
				discussion_title = @disc_tittle,
				discussion_description = @disc_desc,
				image = @image		
			where
				discussion_id = @discussion_id  
				and is_deleted = 0
			select 'Success' as message
		 end 
GO
/****** Object:  StoredProcedure [owner].[save_owner_feed]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[save_owner_feed]

    @owner_id int,
	@media_type varchar(100) = 'Text',
	@media_url nvarchar(max) = null,
	@thumbnail nvarchar(max) = null,
	@text nvarchar(max) = null
AS        
      
/*
	 exec  [owner].[save_owner_feed] 413115,'Text','','','Just Text Feed Only12355'
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
	declare @feed_id int

    set @media_type_id = ( select 
						        media_type_id
                           from
						       [ride].[media_type]
                           where
						       name = @media_type
							   and is_deleted = 0
                       )

    insert into [owner].[feeds]
	(
		owner_id,
		media_type_id,
		media_url,
		thumbnail,
		feed_text
	)
	values
	(
		@owner_id,
		@media_type_id,
		@media_url,
		@thumbnail,
		@text
	)

	--	select  SCOPE_IDENTITY() as owner_feed_id 

	set @feed_id = SCOPE_IDENTITY()

	select top 1
		oof.feed_id,
		oo.owner_id,
		isnull(oo.fname,'')+ ' ' + isnull(oo.lname,'') as owner_name,
		oo.current_latitude,
		oo.current_longitude,
		isnull(oo.photo,isnull(oo.photo_path,'')) as profile_pic,
		0 as distance,
		isnull(oof.feed_text,'') as text,
		oof.media_type_id,
		isnull(oof.media_url,'') as media_url,
		isnull(oof.thumbnail,'') as thumbnail,
		oof.created_dt,
		oof.likes as likes,
		oof.comments,
		oof.self_like as is_liked_user
	from
		[owner].[feeds] oof with(nolock,readuncommitted)
		inner join [owner].[owner] oo with(nolock,readuncommitted)
		on oo.owner_id = oof.owner_id
	where
		 oof.feed_id = @feed_id

SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [owner].[save_owner_profile_type]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[save_owner_profile_type]
       
	@owner_id INT = NULL,    
    @is_private_profile BIT = 0

AS        
      
/*
	 exec   [owner].[save_owner_profile_type] 404923,0
	 ------------------------------------------------------------         
	  exec   [owner].[get_owner_settings] 404923
	 PROCESSES  
	 
	 select * from owner.owner_settings 

	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2018     Ready2Ride                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

		set @owner_id = isnull(@owner_id,0)

		set @is_private_profile = isnull(@is_private_profile,0)
           
		   if(@owner_id > 0)
			  begin
					update
						owner.owner
					set
						is_private_profile = @is_private_profile
					where
						owner_id = @owner_id
			  end
 
    SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [owner].[save_owner_settings]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[save_owner_settings]
       
	@owner_id INT = NULL,    
    @units varchar(100) = 'miles',
    @share_my_location_with_friends BIT = 1,
    @odometer_updates BIT = 1,
    @gps_logging_frequency varchar(100) = 'aggressive',
    @friend_requests BIT = 1,
    @accepted_friend_requests BIT = 1,
    @buddy_who_join_r2r BIT = 1,
    @direct_messages BIT = 1,
    @promotion_alerts BIT = 1,
    @event_alerts BIT = 1,
    @private_profile BIT = 0,
    @facebook BIT = 1,
    @google BIT = 1

AS        
      
/*
	 exec   [owner].[save_owner_settings] 404923
	 ------------------------------------------------------------         

	 PROCESSES  
	 
	 select * from owner.owner_settings 

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
           
		   Declare @owners_count int = 0;

		   SET @owner_id = isnull(@owner_id,0)

		   SET @units = isnull(@units,'Miles')

		   SET @gps_logging_frequency = isnull(@gps_logging_frequency,'Aggressive')

		   SET @owners_count = ( Select 
									  count(owner_settings_id) 
								 from 
									 [owner].[owner_settings] oos with(nolock,readuncommitted)
								 where
									 oos.is_deleted = 0
									 and oos.owner_id = @owner_id )

		   SET @owners_count = isnull(@owners_count,0)

		   IF (@owners_count = 0)   

			   BEGIN 
			    
					INSERT INTO 
					    owner.owner_settings
							(owner_id, 
							 units
							,share_my_location_with_friends
							,odometer_updates
							,gps_logging_frequency
							,friend_requests
							,accepted_friend_requests
							,buddy_who_join_r2r
							,direct_messages
							,promotion_alerts
							,event_alerts
							,facebook
							,google)

					VALUES (@owner_id, 
							UPPER(LEFT(@units,1))+LOWER(SUBSTRING(@units,2,LEN(@units))),
							@share_my_location_with_friends,
							@odometer_updates,
							UPPER(LEFT(@gps_logging_frequency,1))+LOWER(SUBSTRING(@gps_logging_frequency,2,LEN(@gps_logging_frequency))),
							@friend_requests,
							@accepted_friend_requests,
							@buddy_who_join_r2r,
							@direct_messages,
							@promotion_alerts,
							@event_alerts,
							@facebook,
							@google)    

				END    

		   ELSE IF (@owners_count = 1)   

				BEGIN 
				  
					UPDATE 
						owner.owner_settings
					SET     
						 units = UPPER(LEFT(@units,1))+LOWER(SUBSTRING(@units,2,LEN(@units)))
						,share_my_location_with_friends = @share_my_location_with_friends
						,odometer_updates = @odometer_updates
						,gps_logging_frequency = UPPER(LEFT(@gps_logging_frequency,1))+LOWER(SUBSTRING(@gps_logging_frequency,2,LEN(@gps_logging_frequency)))
						,friend_requests = @friend_requests
						,accepted_friend_requests = @accepted_friend_requests
						,buddy_who_join_r2r = @buddy_who_join_r2r
						,direct_messages = @direct_messages
						,promotion_alerts = @promotion_alerts
						,event_alerts = @event_alerts
						,facebook = @facebook
						,google = @google
					WHERE 
						owner_id = @owner_id  
						and is_deleted = 0
				END 
				
		   ELSE

				BEGIN 

					UPDATE 
						owner.owner_settings
					SET 
						is_deleted = 1
					WHERE 
						owner_id = @owner_id
				  
					INSERT INTO 
					    owner.owner_settings
							(owner_id, 
							 units
							,share_my_location_with_friends
							,odometer_updates
							,gps_logging_frequency
							,friend_requests
							,accepted_friend_requests
							,buddy_who_join_r2r
							,direct_messages
							,promotion_alerts
							,event_alerts
							,private_profile
							,facebook
							,google)

					VALUES (@owner_id, 
							UPPER(LEFT(@units,1))+LOWER(SUBSTRING(@units,2,LEN(@units))),
							@share_my_location_with_friends,
							@odometer_updates,
							UPPER(LEFT(@gps_logging_frequency,1))+LOWER(SUBSTRING(@gps_logging_frequency,2,LEN(@gps_logging_frequency))),
							@friend_requests,
							@accepted_friend_requests,
							@buddy_who_join_r2r,
							@direct_messages,
							@promotion_alerts,
							@event_alerts,
							@private_profile,
							@facebook,
							@google) 
				END    
			
		END
 
    SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [owner].[save_parking]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[save_parking]
       
	@owner_id int,
	@cycle_id int,
	@photo_path varchar(500),
	@notes varchar(max),
	@unmark_spot  bit = 0,
	@postion_lat decimal(9,6) = null,
	@postion_lon decimal(9,6) = null,
	@parking_id  int = 0

AS        
      
/*
	 exec   [owner].[insert_update_parking]
	 ------------------------------------------------------------         

	 PROCESSES  
	 
	 select * from owner.parking 

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
           
		   SET @parking_id = isnull(@parking_id,0)

		   IF (@parking_id = 0)   

			   BEGIN 
			    
					insert into owner.parking 
					 (
						owner_id, 
						cycle_id, 
						postion_lat, 
						postion_lon,
						parking_notes, 
						photo_path,
						unmark_spot,
						is_closed,
						parked_dt
					 ) 
					output INSERTED.parking_id
					values 
					(
						@owner_id, 
						@cycle_id, 
						@postion_lat, 
						@postion_lon,
						@notes, 
						@photo_path, 
						@unmark_spot,
						0,
						getdate()
					)    

				END    

		   ELSE 

				BEGIN 
				  
					update 
						owner.parking
					set    
						postion_lat = @postion_lat, 
						postion_lon = @postion_lon,
						parking_notes = @notes,    
						photo_path = @photo_path,
						unmark_spot = @unmark_spot,
						updated_dt = getdate()     
					where 
						parking_id = @parking_id  
    
					select @parking_id as parking_id
				END    
			
		END
 
    SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [owner].[save_selected_dealers]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[save_selected_dealers]
	 @owner_id int,    
	 @dealer_id int,
	 @is_default bit = 0

	AS

/* 
	exec [owner].[save_selected_dealers] 405851,6111
	--------------------------------------------------------------       
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
    05/10/2019      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 
 
BEGIN

 declare @dealers_count int;
 declare @is_exist int;
 declare @default_dealer_id int = null;
 declare @app_users_contact_list_id int = null;

 if(@owner_id > 0 and @dealer_id > 0)
	begin
	 set @default_dealer_id = ( select 
									top 1 dealer_id
								 from 
									 owner.owner with(nolock,readuncommitted)
								 where
									 owner_id = @owner_id 
							   )

	 set @app_users_contact_list_id = ( select 
											top 1 contact_list_id 
										from 
											owner.contact_list with(nolock,readuncommitted) 
										where 
											dealer_id = @dealer_id 
											and is_deleted = 0 
											and is_default = 1 
											and list_name = 'App Users'
									   )

	 if(@default_dealer_id is null or @default_dealer_id <= 0)
		begin
			update 
				owner.owner 
			set 
				dealer_id = @dealer_id 
			where 
				owner_id = @owner_id

			update 
				owner.owner 
			set 
				contact_list_ids = owner.get_distinct_contact_list_ids(contact_list_ids + ',' + isnull(cast(@app_users_contact_list_id as varchar(10)),''))
			where 
				owner_id = @owner_id

			set @default_dealer_id = @dealer_id
		end

	 if(@default_dealer_id = @dealer_id)
	   begin
			set @is_default = 1
	   end
	 else
		begin
			set @is_default = 0
		end

	 set @dealers_count = (  select
								count(*) 
							 from 
								owner.owner_dealers with(nolock,readuncommitted) 
							 where 
								owner_id = @owner_id 
								and is_deleted = 0
						   )

	 set @is_exist = (  select 
							count(*) 
						from 
							owner.owner_dealers with(nolock,readuncommitted)
						where
							owner_id = @owner_id 
							and dealer_id = @dealer_id 
							and is_deleted = 0
					  )

	 set @dealers_count = isnull(@dealers_count, 0)

	 set @is_exist = isnull(@is_exist, 0)

	 if(isnull(@dealers_count,0) < 5)
		BEGIN
			if(isnull(@is_exist,0) = 0)
				Begin

					INSERT INTO owner.owner_dealers
					(
						owner_id,
						dealer_id,
						is_default,
						is_deleted
					)
					VALUES
					(
						@owner_id,    
						@dealer_id,
						isnull(@is_default,0),
						0
					)

					select 'Success' as message
				End
			else if(isnull(@is_exist,0) = 1)
				BEGIN
					select 'Dealer Already Exists' as message
				END
			else if(isnull(@is_exist,0) > 1)
				BEGIN

					update
						owner.owner_dealers
					set
						is_deleted = 1
					where
						owner_id = @owner_id 
						and dealer_id = @dealer_id 
						and is_deleted = 0

					INSERT INTO owner.owner_dealers
					(
						owner_id,
						dealer_id,
						is_default,
						is_deleted
					)
					VALUES
					(
						@owner_id,    
						@dealer_id,
						isnull(@is_default,0),
						0
					)

					select 'Success' as message

				END
			else 
				BEGIN
					select 'Dealer Already Exists' as message
				END
		END
	 else
		BEGIN
			select 'Limit Exceeded' as message
		END
   end
 else
   begin
		select 'Failed' as message
   end

END
 
    
GO
/****** Object:  StoredProcedure [owner].[search_owner_groups]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[search_owner_groups] 

	@owner_id int = null,
	@group_type varchar(100) = 'featured',
	@search varchar(max) = ''  

AS        
     
/*
	 exec  [owner].[search_owner_groups] 404923,'featured',null
	 ------------------------------------------------------------         
    
	 PROCESSES
	 
	 select * from owner.owner where owner_id =  404923        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/
BEGIN 
  
SET NOCOUNT ON 

	set @owner_id = isnull(@owner_id,0)

	set @search = isnull(@search,'')

	IF (isnull(@group_type,'featured') = 'featured')

		BEGIN

			;WITH owner_groups AS (
			   select 
					 owner_group_id,
					 owner_id,
					 group_id,
					 is_created 
				from 
					owner.owner_group with(nolock,readuncommitted)
				where 
					owner_id = @owner_id 
					and is_deleted = 0
			),
			featured_groups AS
			(select 
					bg.group_id,
					bg.name,
					isnull(bg.description,'') as description,
					isnull(bg.icon,'') as icon,
					bg.latitude,
					bg.longitude,
					bg.address,
					bgm.mode,
					isnull(og.owner_id,0) as owner_id,
					--isnull(bg.group_member_count,0)  as group_member_count,
					isnull((select 
							count(oog.owner_group_id)
						 from 
							  [owner].[owner_group] oog with(nolock,readuncommitted)
							  inner join owner.owner oo with(nolock,readuncommitted)
							  on oo.owner_id =  oog.owner_id
						 where 
							group_id = bg.group_id 
							and oog.is_deleted = 0
							and oo.is_deleted = 0),0)  as group_member_count,
					case when og.owner_group_id > 0 then 1 else 0 end as is_joined,
					isnull(og.is_created,0) as is_created
				from 
					buddy.groups bg with(nolock,readuncommitted)
					inner join buddy.groups_mode bgm with(nolock,readuncommitted)
					on bg.mode_id = bgm.mode_id
					left join owner_groups og with(nolock,readuncommitted) on
					bg.group_id = og.group_id
				
				where
					bg.is_deleted = 0
					and bg.name like '%'+ @search +'%'
					and bgm.is_deleted = 0
			
        )
		SELECT  * FROM  featured_groups order by group_id desc

		END

	ELSE

		BEGIN

			select 
				bg.group_id,
				bg.name,
				bg.description,
				isnull(bg.icon,'') as icon,
				bg.latitude,
				bg.longitude,
				bg.address,
				bgm.mode,
				og.owner_id,
				isnull((select 
							count(oog.owner_group_id)
						 from 
							  [owner].[owner_group] oog with(nolock,readuncommitted)
							  inner join owner.owner oo with(nolock,readuncommitted)
							  on oo.owner_id =  oog.owner_id
						 where 
							group_id = bg.group_id 
							and oog.is_deleted = 0
							and oo.is_deleted = 0),0)  as group_member_count,
				1 as is_joined,
				isnull(og.is_created,0) as is_created
			from 
				 [owner].[owner_group] og  with(nolock,readuncommitted)
				 inner join buddy.groups bg with(nolock,readuncommitted)
				 on og.group_id = bg.group_id
				 inner join buddy.groups_mode bgm with(nolock,readuncommitted)
				 on bg.mode_id = bgm.mode_id
		 
			where 
				  og.owner_id = @owner_id 
				  and bg.is_deleted=0
				  and bg.name like '%'+ @search +'%'
				  and og.is_deleted=0
			order by
				  bg.group_id desc
   
		END

SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [owner].[set_default_dealer]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [owner].[set_default_dealer]
	 @owner_id int,  
	 @dealer_id int
	
	AS

/* 
	 exec [owner].[set_default_dealer] 722660,2990
	--------------------------------------------------------------       
    MODIFICATIONS 
	
	select top 10 * from owner.owner order by owner_id desc
	     
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
    05/28/2019     siva                           Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
SET NOCOUNT ON;
 
	BEGIN

		declare @dealers_count int = 0;
		declare @is_exist int = 0;
		declare @default_dealer_id int = 0;
		declare @owner_dealer_id int = 0;
		declare @app_users_contact_list_id int = null;

		set @default_dealer_id = ( select 
										top 1 nullif(dealer_id, 37429)
									from 
										owner.owner with(nolock,readuncommitted)
									where
										owner_id = @owner_id
								 )

		if(@default_dealer_id is null or @default_dealer_id <= 0)
			begin
				update 
					owner.owner 
				set 
					dealer_id = @dealer_id 
				where 
					owner_id = @owner_id
		    end

		set @dealers_count = (  select
									count(*) 
								 from 
									owner.owner_dealers with(nolock,readuncommitted) 
								 where 
									owner_id = @owner_id 
									and is_deleted = 0
							  )

		set @is_exist =  (  select 
								count(*) 
							from 
								owner.owner_dealers with(nolock,readuncommitted)
							where
								owner_id = @owner_id 
								and dealer_id = @dealer_id 
								and is_deleted = 0
						  )

		set @dealers_count = isnull(@dealers_count, 0)

		set @is_exist = isnull(@is_exist, 0)

		if(isnull(@is_exist,0) <= 0)
			begin
				update 
					owner.owner_dealers
				set
					is_default = 0
				where
					owner_id = @owner_id 
					and is_deleted = 0

				insert into owner.owner_dealers
				(
					owner_id,
					dealer_id,
					is_default,
					is_deleted
				)
				values
				(
					@owner_id,
					@dealer_id,
					1,
					0
				)
			end
		else if(isnull(@is_exist,0) = 1)
			begin
				update 
					owner.owner_dealers
				set
					is_default = 0
				where
					owner_id = @owner_id 
					and is_deleted = 0

				update
					owner.owner_dealers
				set
					is_default = 1
				where
					owner_id = @owner_id 
					and dealer_id = @dealer_id 
					and is_deleted = 0
			end
		else if(isnull(@is_exist,0) > 1)
			begin
				
				update 
					owner.owner_dealers
				set
					is_default = 0
				where
					owner_id = @owner_id 
					and is_deleted = 0
							
				update
					owner.owner_dealers
				set
					is_deleted = 1
				where
					owner_id = @owner_id 
					and dealer_id = @dealer_id 
					and is_deleted = 0

				insert into owner.owner_dealers
				(
					owner_id,
					dealer_id,
					is_default,
					is_deleted
				)
				values
				(
					@owner_id,    
					@dealer_id,
					1,
					0
				)

			end

		set @owner_dealer_id = ( select 
									top 1 dealer_id
								 from 
									owner.owner with(nolock,readuncommitted)
								 where
									owner_id = @owner_id 
							    )

		set @app_users_contact_list_id = ( select 
												top 1 contact_list_id 
											from 
												owner.contact_list with(nolock,readuncommitted) 
											where 
												dealer_id = @owner_dealer_id 
												and is_deleted = 0 
												and is_default = 1 
												and list_name = 'App Users'
										 )

		update 
			owner.owner 
		set 
			contact_list_ids = owner.get_distinct_contact_list_ids(contact_list_ids + ',' + isnull(cast(@app_users_contact_list_id as varchar(10)),''))
		where 
			owner_id = @owner_id 
		
		set @dealers_count = (  select
									count(*) 
								 from 
									owner.owner_dealers with(nolock,readuncommitted) 
								 where 
									owner_id = @owner_id 
									and is_deleted = 0
							  )
							  	
		set @is_exist =  (  select 
								count(*) 
							from 
								owner.owner_dealers with(nolock,readuncommitted)
							where
								owner_id = @owner_id 
								and dealer_id = @owner_dealer_id 
								and is_deleted = 0
						  )

		set @dealers_count = isnull(@dealers_count, 0)	
		
		set @is_exist = isnull(@is_exist, 0)
		
		if(isnull(@is_exist,0) = 0)
			begin
				if(@dealers_count < 5 and @owner_id > 0 and @owner_dealer_id > 0)
					begin
						update 
							owner.owner_dealers
						set
							is_default = 0
						where
							owner_id = @owner_id 
							and is_deleted = 0

						insert into owner.owner_dealers
						(
							owner_id,
							dealer_id,
							is_default,
							is_deleted
						)
						values
						(
							@owner_id,
							@owner_dealer_id,
							1,
							0
						)
					end
			end	

	END
    
SET NOCOUNT OFF; 
GO
/****** Object:  StoredProcedure [owner].[share_ride_to_buddy]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[share_ride_to_buddy]  

	  @chat_id int = null,
	  @message nvarchar(max) = null,
	  @message_type varchar(50) = 'Text',
	  @sender_id int = null,
	  @receiver_id int = null,
	  @sender varchar(100) = null,
	  @receiver varchar(100) = null,
	  @ride_id int
AS        
      
/*
	 exec [owner].[share_ride_to_buddy] 
	 --------------------------------------------       
    
	 select * from message.message   
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 01/11/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON
	
	declare @message_type_id int = 1 

	set @chat_id = isnull(@chat_id,0)

	set @message_type_id = ( select top 1 
									message_type_id
							  from
									message.message_type mmt with(nolock,readuncommitted)
							  where
									is_deleted = 0
									and message_type_code = @message_type )

	if(@chat_id = 0)
		begin
			set @chat_id = [message].[get_chat_id](@sender_id,@receiver_id,@sender,@receiver) 
		end

							  

	if(@chat_id > 0)
		begin

			update 
				  message.chat
			set
				recent_message = isnull(@message,''),
				updated_dt = getdate()
			where
				chat_id = @chat_id

			insert into message.message
			(
				chat_id,
				ride_id,
				message_type_id,
				sender_id,
				receiver_id,
				message,
				is_owner,
				is_dealer,
				is_sent,
				created_date
			)output inserted.message_id
			values
			(
				@chat_id,
				@ride_id,
				isnull(@message_type_id,1),
				@sender_id,
				@receiver_id,
				isnull(@message,''),
				case when @sender = 'owner' then 1 else 0 end,
				case when @sender = 'dealer' then 1 else 0 end,
				1,
				getdate()
			)

		end
	else
		begin
			
			insert into message.chat
			(
				chat_type_id,
				recent_message,
				is_dealer_communication,
				is_deleted
			)
			values
			(
				case when @sender = 'owner' and @receiver = 'owner' then 2 else 1 end,
				isnull(@message,''),
				case when @sender = 'owner' and @receiver = 'owner' then 0 else 1 end,
				0
			)

			SET @chat_id = SCOPE_IDENTITY()

			insert into message.clients
			(
				chat_id,
				user_id,
				is_owner,
				is_dealer
			)
			values
			(
				@chat_id,
				@sender_id,
				case when @sender = 'owner' then 1 else 0 end,
				case when @sender = 'dealer' then 1 else 0 end
			)

			insert into message.clients
			(
				chat_id,
				user_id,
				is_owner,
				is_dealer
			)
			values
			(
				@chat_id,
				@receiver_id,
				case when @receiver = 'owner' then 1 else 0 end,
				case when @receiver = 'dealer' then 1 else 0 end
			)

			insert into message.message
			(
				chat_id,
				ride_id,
				message_type_id,
				sender_id,
				receiver_id,
				message,
				is_owner,
				is_dealer,
				is_sent,
				created_date
			)output inserted.message_id
			values
			(
				@chat_id,
				@ride_id,
				isnull(@message_type_id,1),
				@sender_id,
				@receiver_id,
				isnull(@message,''),
				case when @sender = 'owner' then 1 else 0 end,
				case when @sender = 'dealer' then 1 else 0 end,
				1,
				getdate()
			)

		end
		
		
		

	SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [owner].[share_ride_to_feed]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[share_ride_to_feed]

 @owner_id int,
 @feed_text nvarchar(max) = '',
 @media_url nvarchar(max) = '',
 @thumnail nvarchar(max) = '',
 @ride_id int

AS

/* 
	exec [owner].[share_ride_to_feed] 425247,'Ride Test','http://ready2rideassets.s3.amazonaws.com/r2randroidassets/rides/425247-1599220810131.jpeg','',8671  
	--------------------------------------------------------------       
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
	01/11/2019      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 

BEGIN

		insert into [owner].[feeds]
		(
			owner_id,
			feed_type_id,
			media_type_id,
			feed_text,
			media_url,
			thumbnail,
			ride_id
		)
		values
		(
			@owner_id,
			2,
			1,
			@feed_text,
			@media_url,
			@thumnail,
			@ride_id
		)

		SELECT SCOPE_IDENTITY() AS feed_id 

END
GO
/****** Object:  StoredProcedure [owner].[share_ride_to_group]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE procedure [owner].[share_ride_to_group]
 @group_id int,
 @owner_id int,
 @disc_tittle varchar(50) = '',
 @disc_desc varchar(50) = '',
 @discussion_id int = 0,
 @image varchar(250) = '',
 @ride_id int

AS

/*  
	exec [owner].[share_ride_to_group] 404923,412916,'','',0,'',3851  
	---------------------------------------------------------------       
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
	01/11/2019      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 

	declare @owner_count int = 0;
	declare @ride_name varchar(100) = '';
	declare @discussion_type_id int = 2

	set @discussion_type_id = ( select top 1 
									 discussion_type_id
								from
									[owner].[discussion_type] owt with(nolock,readuncommitted)
								where
									is_deleted = 0
									and discussion_type_code = @disc_tittle )

	set @discussion_type_id = isnull(@discussion_type_id, 2)

	set @owner_count = ( select 
							count(oog.owner_group_id)
						from 
							owner.owner_group oog with(nolock,readuncommitted)
							inner join owner.owner oo with(nolock,readuncommitted)
							on oo.owner_id = oog.owner_id
						where 
							oog.owner_id = @owner_id
							and oog.group_id = @group_id 
							and oog.is_deleted = 0
							and oo.is_deleted = 0
						)

	set @ride_name = (  select top 1
							isnull(name,'')
						from 
							ride.ride rr with(nolock,readuncommitted)
							
						where 
							rr.ride_id = @ride_id
						)

	set @owner_count = isnull(@owner_count,0)

	set @discussion_id = isnull(@discussion_id,0)

	if(@discussion_id = 0)
		begin
			if(@owner_count > 0)
				begin
					insert into [owner].[group_discussion]
					(
						group_id,
						owner_id,
						discussion_title,
						discussion_description,
						image,
						ride_id,
						discussion_type_id
					)
					values
					(
						@group_id,
						@owner_id,
						@ride_name,
						@disc_desc,
						@image,
						@ride_id,
						@discussion_type_id
					)
					select 'Success' as message
				end
			else
			begin
				select 'Discussion must be created by group member' as message
			end
		end
	 else
		begin
			update 
				[owner].[group_discussion]
			set
				discussion_title = @disc_tittle,
				discussion_description = @disc_desc,
				image = @image,
				discussion_type_id = @discussion_type_id		
			where
				discussion_id = @discussion_id  
				and is_deleted = 0
			select 'Success' as message
		 end 
GO
/****** Object:  StoredProcedure [owner].[unmark_parking_spot]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[unmark_parking_spot]

	@parking_id  int

AS        
      
/*
	 exec  [owner].[unmark_parking_spot]
	 ------------------------------------------------------------         

	 PROCESSES  
	 
	 select * from owner.parking 

	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2018     Raviteja.V.V                     Created
	 -----------------------------------------------------------      
                   Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 
  
	set @parking_id = isnull(@parking_id,0)

	update 
		owner.parking
	set    
		unmark_spot = 1,
		updated_dt = getdate()     
	where 
		parking_id = @parking_id  
 

END
	 


GO
/****** Object:  StoredProcedure [owner].[update_owner_data]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[update_owner_data]  
	  @owner_id int = null,
	  @first_name varchar(50) = null,
	  @last_name varchar(50) = null,
	  @profile_image varchar(max) = null,
	  @bground_image varchar(max) = null,
	  @mobile varchar(50) = null,
	  @bio nvarchar(max) = null
AS        
      
/*
	 exec  [owner].[update_owner_data]    405553
	 ------------------------------------------------------------         
	 PURPOSE        
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

		update 
			[owner].[owner]
		set 
			fname = @first_name,
			lname = @last_name,
			photo = @profile_image,
			photo_path = @profile_image,
			bground_image = @bground_image,
			mobile = @mobile,
			bio = @bio
		where 
			owner_id = @owner_id
	
	SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [owner].[update_owner_location]    Script Date: 1/25/2022 4:33:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [owner].[update_owner_location]  
	  @owner_id int = null,
	  @latitude decimal(9,6) = null,
	  @longitude decimal(9,6) = null
AS        
      
/*
	 exec  [owner].[update_owner_location] 405553,'0','0'
	 ------------------------------------------------------------         
	 PURPOSE        
	 Update Owner Location
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	update 
		 owner.owner
	set 
		current_latitude = @latitude,
		current_longitude = @longitude,
		last_location_updated_dt = getdate()
	where 
		owner_id = @owner_id

END
GO

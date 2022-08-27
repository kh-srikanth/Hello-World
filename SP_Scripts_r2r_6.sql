USE [auto_mobile]
GO
/****** Object:  StoredProcedure [dbo].[update_forgot_password_otp]    Script Date: 1/25/2022 5:32:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[update_forgot_password_otp]  
 
 @org_id int,
 @otp nvarchar(10),
 @user_name nvarchar(256)
    
AS  
	/*         
	exec [dbo].[update_forgot_password_otp]  
	---------------------------------------------------       
    MODIFICATIONS       
	Date		   Author	    Work Tracker Id    Description         
	------------------------------------------------------------       
	07/02/2018     Warrous         Vishnu T	                 Created  
	-------------------------------------------------------------
	               Copyright 2018 Warrous Pvt Ltd        
	*/       
 /* Setup */ 
 SET NOCOUNT ON; 

 	BEGIN  
		begin
			UPDATE [dbo].[Users] SET ForgotPasswordOtp=@otp,UpdatedDt=getdate() WHERE  UserName = @user_name and org_id=@org_id
		end
	END

GO
/****** Object:  StoredProcedure [portal].[add_requestd_dealer]    Script Date: 1/25/2022 5:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [portal].[add_requestd_dealer]
	@dealer_name varchar(200),
	@mobile varchar(20),
	@owner_name varchar(200)
    
AS  
	/*
	 exec [portal].[add_requestd_dealer]  60,''
	 -------------------------------------------          
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author    Work Tracker Id    Description          
	 -----------------------------------------------------------        
	 01/02/2020     Raviteja.V.V                     Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd   
	*/  
 /* Setup */ 
SET NOCOUNT ON; 

	BEGIN
		insert into [portal].[requested_dealers]
		(
			[dealer_name],
			[mobile],
			[owner_name]
		)
		values
		(
			@dealer_name,
			@mobile,
			@owner_name
		)
	END
			 
SET NOCOUNT OFF




GO
/****** Object:  StoredProcedure [portal].[check_mobile_user]    Script Date: 1/25/2022 5:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[check_mobile_user] 

	@email nvarchar(256),
	@org_id int = 62,
	@user_type_id int = 5

AS        
      
/*
 exec [portal].[check_mobile_user] 'demotes@gmail.com'

 -------------------------------------------         
 PURPOSE        
 To check if the user is exists or not
    
 PROCESSES        
    
 MODIFICATIONS        
 Date			Author      Work Tracker Id    Description          
 -----------------------------------------------------------        
 17/09/2019		Raviteja.v.V			             Created     
 -----------------------------------------------------------      
              Copyright 2018 Warrous Pvt Ltd     
*/        
BEGIN 
  
    declare @is_exists int = 0

	set @is_exists = (	select 
							count(du.UserId)
						from 
							dbo.Users du with(nolock,readuncommitted)
						where
							du.IsDeleted = 0 and 
							Email = @email and
							org_id = @org_id and
							user_type_id = @user_type_id and
							(is_active = 1 or isnull(is_active,0) = 0)
						)

	set @is_exists = isnull(@is_exists,0)

	select @is_exists as is_exists
		  

END
GO
/****** Object:  StoredProcedure [portal].[get_app_push_settings]    Script Date: 1/25/2022 5:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[get_app_push_settings] 

	@app_name varchar(100),
	@platform varchar(25)
	
AS        
      
/*
 exec [portal].[get_app_push_settings] 'Ready2Ride','ANDROID'
 -------------------------------------------         
 PURPOSE        
     
 PROCESSES        
    
 MODIFICATIONS        
 Date			Author      Work Tracker Id    Description          
 ------------------------------------------------------------------------------------------------------------       
 05/24/2018		Raviteja.V.V	             Created - This procedure to insert or update dealer push settings     
 ------------------------------------------------------------------------------------------------------------      
              Copyright 2017 Warrous Pvt Ltd     
*/        
BEGIN 
  
   SET NOCOUNT ON 

		Begin

			select top 1
					paps.app_push_id,
					paps.app_id,
					ltrim(rtrim(paps.server_key)) as server_key,
					ltrim(rtrim(paps.legacy_server_key)) as legacy_server_key,
					ltrim(rtrim(paps.sender_id)) sender_id,
					paps.platform
			 from 
			        [portal].[app_push_settings] paps  with(nolock,readuncommitted)
					inner join [portal].[app] pa with(nolock,readuncommitted)
					on pa.app_id = paps.app_id
			 where 
					paps.is_deleted = 0 and
					pa.app_name = @app_name and
					paps.platform = @platform

			 order by
			        app_push_id desc
			 
		End

	SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [portal].[get_app_version]    Script Date: 1/25/2022 5:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[get_app_version]     
      
     @platform varchar(20),
	 @app_name varchar(50) = 'Ready2Ride'  
AS        
      
/*
 exec [portal].[get_app_version] 'IOS','           '
 ---------------------------------------------------
 PROCESSES        
    
 MODIFICATIONS        
 Date          Author      Work Tracker Id      Description          
 -----------------------------------------------------------        
 12/12/2019	   Ready2Ride                            Created      
 -----------------------------------------------------------      
                Copyright 2017 Warrous Pvt Ltd     
*/        
BEGIN 
  
SET NOCOUNT ON 

		set @app_name = isnull(nullif(ltrim(rtrim(@app_name)),''),'Ready2Ride')

		select top 1
			pav.app_name,
			pav.version_number,
			pav.release_date,
			pp.platform,
			pav.is_force_update
		from 
			[portal].[app_versions] pav with(nolock,readuncommitted)
			inner join [portal].[platforms] pp with(nolock,readuncommitted)
			on pav.platform_id = pp.platform_id
		where 
			pav.is_deleted = 0
			and pp.is_deleted = 0
			and pav.app_name = @app_name
			and pp.platform = @platform
		order by
			pav.app_version_id desc
	     

SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [portal].[get_dealer_data_by_dealer_id]    Script Date: 1/25/2022 5:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[get_dealer_data_by_dealer_id]   
@dealer_id int = null
 
AS        
      
	/*
	 exec [portal].[get_dealer_data_by_dealer_id]  4035
	 -------------------------------------------               
	 PURPOSE        
	 Get all roles '444 Washington St'

	 select top 10 * from portal.dealer where dealer_name = 'Motorsports International'
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id    Description          
	 -----------------------------------------------------------        
	 08/03/2017	    Warrous                         Created    
	  
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd   
	*/        
      
 SET NOCOUNT ON  
	    
		select top 1 
			   pd.dealer_id,
			   pd.dealer_name,
			   pd.dealer_phone,
			   (case when isnull(pddd.address2,'') <> '' then isnull(pddd.address1,'') + ' ' + isnull(pddd.address2,'') 
					else isnull(pddd.address1,'') end) as address,
			   isnull(pddd.country_code,'USA') as country_code,
			   isnull(pddd.state_code,'') as state_code,
			   isnull(pddd.city,'') as city,
			   isnull(pddd.zipcode,'') as zipcode,
			   isnull(pd.business_logo,'') as business_logo,
			   isnull(nullif(ltrim(rtrim(dealer_email)),''), pddd.email_address) as dealer_email	  
		from 
			  [portal].[dealer] pd with(nolock,readuncommitted) 
			  inner join [portal].[dealer_dept_details] pddd with(nolock,readuncommitted) 
			  on pd.dealer_id = pddd.dealer_id
		where 
			  pd.dealer_id = @dealer_id 
			  and pd.is_deleted = 0
			  and pddd.is_deleted = 0


			
 SET NOCOUNT OFF
 
GO
/****** Object:  StoredProcedure [portal].[get_dealer_phone_number]    Script Date: 1/25/2022 5:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[get_dealer_phone_number]

    @dealer_id int = 0

AS        
      
/*
 exec  [portal].[get_dealer_phone_number] 4035
 -------------------------------------------         
	    
 PROCESSES        
    
 MODIFICATIONS        
 Date          Author    Work Tracker Id   Description  
 ------------------------------------------------------------------
 1/3/2019        Akshay                 To  Get Dealer Phone number
 ------------------------------------------------------------------      
    
*/        
BEGIN 
  
   SET NOCOUNT ON 

   set @dealer_id = isnull(@dealer_id,0)

	   select 
			isnull(dealer_phone,'') as dealer_phone
	   from
			portal.dealer pd with(nolock,readuncommitted)
	   where
			is_deleted = 0
			and dealer_id = @dealer_id

   
   SET NOCOUNT OFF

END


GO
/****** Object:  StoredProcedure [portal].[get_dealers]    Script Date: 1/25/2022 5:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[get_dealers]
       
	@latitude decimal (18, 9)=null,
	@longitude decimal (18, 9)=null

AS        
      
/*
	 exec  [portal].[get_dealers] 0,0
	 --------------------------------------------------------         
      
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2018     Ready2Ride                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 
  	SET NOCOUNT ON 
      
			SELECT  
				 isnull(pd.dealer_id,0) as dealer_id,
				 isnull(pd.dealer_name,'') as dealer_name,
				 isnull(pd.custom_image_path,'') as background_image,
				 isnull(pd.web_site,'') as web_site,
				 isnull(pddd.address1,'') as street_address,
				 isnull(pddd.state_code,'') as state_name,    
				 isnull(pddd.city,'') as city,
				 isnull(pddd.zipcode,'') as zip_code,
				 isnull(pd.dealer_phone,'') as dealer_phone,
				 isnull(pd.dealer_latitude,0) as dealer_latitude,
				 isnull(pd.dealer_longitude,0) as dealer_longitude,
				 isnull(case when isnumeric(pd.dealer_latitude) = 0 or isnumeric(pd.dealer_longitude) = 0 then 0.0
				 else isnull(([dbo].[get_distance_by_lat_long](@latitude,@longitude,CAST(pd.dealer_latitude AS decimal(18, 9)),CAST(pd.dealer_longitude AS decimal(18, 9)))/1609.34),0.0) end,0.0) as dealer_distance
			FROM portal.dealer pd with(nolock,readuncommitted)
				 inner join portal.dealer_dept_details pddd with(nolock,readuncommitted)
				 on pd.dealer_id = pddd.dealer_id and pddd.department_id = 1
				 inner join portal.dealer_hierarchy pdh with(nolock,readuncommitted)
				 on pdh.dealer_id = pd.dealer_id
			WHERE   pd.is_deleted = 0
					and isnull(pd.is_oem,0) = 0
					and pd.is_approved = 1
			order by 
					dealer_distance,pd.dealer_id asc
											 
    SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [portal].[get_mobile_app_users]    Script Date: 1/25/2022 5:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[get_mobile_app_users] 
     
AS        
      
/*
 exec [portal].[get_mobile_app_users]
 ------------------------------------
    
 PROCESSES        
    select * from portal.user_type
 MODIFICATIONS        
 Date			Author      Work Tracker Id    Description          
 -----------------------------------------------------------        
 08/22/2017	    Raviteja.V.V			            Created      
 -----------------------------------------------------------      
            Copyright 2017 Warrous Pvt Ltd      
*/        
BEGIN 
   
   SET NOCOUNT ON

	;WITH CTE_MobileAppUsers AS 
			(
			select  distinct
				    du.UserId as user_id,
					oo.email as email,
					ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(oo.mobile,'(',''),')',''),'-',''),' ',''),'') as mobile
			from 
				 dbo.Users du with(nolock,readuncommitted)
				 inner join r2r_admin.owner.owner oo with(nolock,readuncommitted)
				 on du.UserId = oo.owner_user_id
			where 
			du.IsDeleted = 0
			and oo.is_deleted = 0 
			and du.user_type_id = 5
			and isnull(oo.owner_user_id,0) > 0
			)
			select * from CTE_MobileAppUsers

   SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [portal].[get_mobile_app_users_by_owner_id]    Script Date: 1/25/2022 5:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[get_mobile_app_users_by_owner_id] 

	@owner_id int = null
     
AS        
      
/*
 exec [portal].[get_mobile_app_users_by_owner_id] 698134
 ------------------------------------
    
 PROCESSES        
 select * from portal.user_type
 MODIFICATIONS        
 Date			Author      Work Tracker Id    Description          
 -----------------------------------------------------------        
 08/22/2017	    Raviteja.V.V			            Created      
 -----------------------------------------------------------      
            Copyright 2017 Warrous Pvt Ltd      
*/        
BEGIN 
   
   SET NOCOUNT ON

     set @owner_id = isnull(@owner_id,0)

	;WITH CTE_MobileAppUsersByOwnerId AS 
			(
			 select  distinct
					 oo.owner_id,
				     du.UserId as user_id,
					 oo.email as email,
					 isnull(ltrim(rtrim(oo.fname + ' ' + oo.lname)),'') as name,
					 ISNULL(right(REPLACE(REPLACE(REPLACE(REPLACE(oo.mobile,'(',''),')',''),'-',''),' ',''),10),'') as mobile,
					 isnull((case when EXISTS(SELECT bb.buddy_id FROM buddy.buddy bb WHERE ((bb.sender_id = oo.owner_id and bb.receiver_id = @owner_id) or (bb.receiver_id = oo.owner_id and bb.sender_id = @owner_id)) and isnull(bb.receiver_id,0) <> 0 and bb.is_request_accepted = 1) then 1
							else 0 end),0) as is_buddy
					
			from 
				 dbo.Users du with(nolock,readuncommitted)
				 inner join owner.owner oo with(nolock,readuncommitted)
				 on du.UserId = oo.owner_user_id
			where 
			du.IsDeleted = 0
			and oo.is_deleted = 0 
			and du.user_type_id = 5
			and oo.owner_id <> @owner_id
			and isnull(oo.owner_user_id,0) > 0
			)
			select * from CTE_MobileAppUsersByOwnerId order by owner_id

   SET NOCOUNT OFF

END


GO
/****** Object:  StoredProcedure [portal].[get_page]    Script Date: 1/25/2022 5:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[get_page]
     
     @page_code varchar(100)

AS        
      
/*
	 exec [portal].[get_page] 'ACTIVATIONEMAIL'
	 
	 ----------------------------------------------------------               
	 PURPOSE        
	 get media content 
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date          Author     Work Tracker Id   Description          
	 -----------------------------------------------------------        
	 09/21/2017	   Raviteja.V.v                      Created      
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
      
 SET NOCOUNT ON  
			    
		select top 1
			[page_id],
			[page_code],
			[page],
			[html_content]
		from 
			[portal].[pages] with(nolock,readuncommitted)
		where 
		    is_deleted = 0 and
			page_code = @page_code
		order by
		    page_id desc
		     

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [portal].[get_selected_dealer_details]    Script Date: 1/25/2022 5:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[get_selected_dealer_details]
       
	@owner_id int = null  

AS        
      
/*
	 exec  [portal].[get_selected_dealer_details] 456020
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

		set @owner_id = isnull(@owner_id,0)
 
		BEGIN        

			WITH selected_dealers as (

			SELECT  distinct
					isnull(pd.dealer_id,0) as dealer_id,
					isnull(pd.dealer_name,'') as dealer_name,
					isnull(pd.dealer_email,isnull(pddd.email_address,'')) as email, 
					isnull(pd.dealer_phone,'') as dealer_phone,
					isnull(pd.custom_image_path,'') as background_image,
					isnull(pd.web_site,'') as web_site,
					isnull(pddd.address1,'') as street_address,
					isnull(pddd.state_code,'') as state_name,    
					isnull(pddd.city,'') as city,
					isnull(pddd.zipcode,'') as zip_code,
					isnull(pd.dealer_latitude,0) as dealer_latitude,
					isnull(pd.dealer_longitude,0) as dealer_longitude,
					isnull(ood.is_default,0)  as is_default
				FROM [owner].[owner_dealers] ood with(nolock,readuncommitted)
					 inner join portal.dealer pd with(nolock,readuncommitted)
					 on ood.dealer_id = pd.dealer_id
					 inner join portal.dealer_dept_details pddd with(nolock,readuncommitted)
					 on pd.dealer_id = pddd.dealer_id and pddd.department_id = 1
					 inner join portal.dealer_hierarchy pdh with(nolock,readuncommitted)
					 on pdh.dealer_id = pd.dealer_id
				WHERE
					pd.is_deleted = 0
					and isnull(pd.is_oem,0) = 0
					and pd.is_approved = 1
					and ood.is_deleted = 0
					and ood.owner_id = @owner_id						 		
		  )
		  select top 5 * from selected_dealers order by is_default desc

		END 

    SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [portal].[get_selected_dealer_details_by_id]    Script Date: 1/25/2022 5:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[get_selected_dealer_details_by_id]
       
	@dealer_id int = null  

AS        
      
/*
	exec  [portal].[get_selected_dealer_details_by_id] 2990
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

		set @dealer_id = isnull(@dealer_id,0)
 
		BEGIN        

			   SELECT top 1
					isnull(pd.dealer_id,0) as dealer_id,
					isnull(pd.dealer_name,'') as dealer_name,
					isnull(pd.dealer_email,isnull(pddd.email_address,'')) as email, 
					isnull(pd.dealer_phone,'') as dealer_phone,
					isnull(pd.custom_image_path,'') as background_image,
					isnull(pd.web_site,'') as web_site,
					isnull(pddd.address1,'') as street_address,
					isnull(pddd.state_code,'') as state_name,    
					isnull(pddd.city,'') as city,
					isnull(pddd.zipcode,'') as zip_code,
					isnull(pd.dealer_latitude,0) as dealer_latitude,
					isnull(pd.dealer_longitude,0) as dealer_longitude
				FROM portal.dealer pd with(nolock,readuncommitted)
					 inner join portal.dealer_dept_details pddd with(nolock,readuncommitted)
					 on pd.dealer_id = pddd.dealer_id and pddd.department_id = 1
					 inner join portal.dealer_hierarchy pdh with(nolock,readuncommitted)
					 on pdh.dealer_id = pd.dealer_id
				WHERE
					pd.is_deleted = 0
					and isnull(pd.is_oem,0) = 0
					and pd.is_approved = 1
					and pd.dealer_id  = @dealer_id
				order by 
					pd.dealer_id asc							 		
		  
		END 

    SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [portal].[get_selected_dealers]    Script Date: 1/25/2022 5:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[get_selected_dealers]
       
	@owner_id int = 0

AS        
      
/*
	 exec  [portal].[get_selected_dealers] 0
	 ---------------------------------------------------------         
      
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2018     Ready2Ride                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 
  	SET NOCOUNT ON 
      
			SELECT  
				 isnull(pd.dealer_id,0) as dealer_id,
				 isnull(pd.dealer_name,'') as dealer_name,
				 isnull(pd.custom_image_path,'') as background_image,
				 isnull(pddd.address1,'') as street_address,
				 isnull(pddd.state_code,'') as state_name,    
				 isnull(pddd.city,'') as city,
				 isnull(pddd.zipcode,'') as zip_code,
				 isnull((select top 1 is_default from owner.owner ow with(nolock,readuncommitted) where dealer_id = pd.dealer_id and owner_id = @owner_id and is_deleted = 0 order by is_default desc),0) as is_default,
				 isnull([r2r_admin].[owner].[is_selected_dealer_check](pd.dealer_id,@owner_id),0) as is_selected

			FROM portal.dealer pd with(nolock,readuncommitted)
				 inner join portal.dealer_dept_details pddd with(nolock,readuncommitted)
				 on pd.dealer_id = pddd.dealer_id and pddd.department_id = 1
				 inner join portal.dealer_hierarchy pdh with(nolock,readuncommitted)
				 on pdh.dealer_id = pd.dealer_id
			WHERE   pd.is_deleted = 0
					and isnull(pd.is_oem,0) = 0
					and pd.is_approved = 1	
			order by 
					pd.dealer_id asc
											 
    SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [portal].[is_mobile_user_exists]    Script Date: 1/25/2022 5:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [portal].[is_mobile_user_exists] 
	@user_name varchar(255),
	@org_id int
AS        
      
/*
 exec [portal].[is_mobile_user_exists] 'shrujanr2r002@gmail.com',62
 -------------------------------------------         
 PURPOSE        
 To Check if the mobile user already exists
    
 PROCESSES        
    
 MODIFICATIONS        
 Date			Author      Work Tracker Id    Description          
 -----------------------------------------------------------        
 06/01/2018		Vishnu T			             Created 
 06/18/2018		Vishnu T						Modified - added org_id filtering     
 -----------------------------------------------------------      
              Copyright 2018 Warrous Pvt Ltd     
*/        
BEGIN 
  
SET NOCOUNT ON 
   
   declare @is_exist int
   declare @user_type_id int = 5;

   set @user_type_id = ( select 
							top 1 user_type_id 
						 from 
							portal.user_type with(nolock,readuncommitted)
						 where 
							user_type_name = 'Owner'
						)

   set @is_exist = ( select
						 count(*)
					 from
						 dbo.Users u with(nolock,readuncommitted)
					 where
						 isdeleted = 0 and
						 org_id = @org_id and
						 user_type_id = @user_type_id and
						 UserName = @user_name
					)

   select @is_exist as is_exist
		     

SET NOCOUNT OFF

END
GO

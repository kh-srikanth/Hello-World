USE [auto_mobile]
GO
/****** Object:  StoredProcedure [buddy].[get_buddies_list]    Script Date: 1/25/2022 3:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [buddy].[get_buddies_list]  

		@owner_id int = 0

AS        
      
/*
	 exec  [buddy].[get_buddies_list]  456020
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Brand
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 

		SELECT
			isnull(bb.buddy_id,0) as buddy_id,
			isnull(oo.owner_id,0) as owner_id,  
			isnull(oo.email,'') as email,
			isnull(oo.fname,'') as first_name,
			isnull(oo.lname,'') as last_name,
			isnull(oo.mobile,'') as mobile,
			isnull(oo.photo,'') as photo,
			isnull(oo.photo_path,'') as photo_path
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
			isnull(oo.owner_id,0) as owner_id,  
			isnull(oo.email,'') as email,
			isnull(oo.fname,'') as first_name,
			isnull(oo.lname,'') as last_name,
			isnull(oo.mobile,'') as mobile,
			isnull(oo.photo,'') as photo,
			isnull(oo.photo_path,'') as photo_path
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
		ORDER BY
				first_name
		
END
	 


GO
/****** Object:  StoredProcedure [buddy].[get_buddies_you_may_know]    Script Date: 1/25/2022 3:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [buddy].[get_buddies_you_may_know] 

	@owner_id int = 0
     
AS        
      
/*
 exec [buddy].[get_buddies_you_may_know] 404923
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

    ;WITH CTE_BuddiesYouMayknow AS 
			(
			select  distinct
					du.UserId as user_id,
					isnull(oo.fname,'') as first_name,
					isnull(oo.lname,'') as last_name,
					oo.email as email,
					ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(oo.mobile,'(',''),')',''),'-',''),' ',''),'') as mobile,
					oo.owner_id,
					isnull((case when EXISTS(SELECT bb.buddy_id FROM buddy.buddy bb WHERE ((bb.sender_id = oo.owner_id and bb.receiver_id = @owner_id) or (bb.receiver_id = oo.owner_id and bb.sender_id = @owner_id)) and isnull(bb.receiver_id,0) <> 0 and bb.is_request_accepted = 1) then 1
							else 0 end),0) as is_buddy
			from 
					r2r_portal.dbo.Users du with(nolock,readuncommitted)
					inner join owner.owner oo with(nolock,readuncommitted)
					on du.UserId = oo.owner_user_id
			where 
			du.IsDeleted = 0
			and oo.is_deleted = 0
			and oo.is_private_profile = 0 
			and du.user_type_id = 5
			and isnull(oo.owner_user_id,0) > 0
			and 1 = 0
			)
			select * from CTE_BuddiesYouMayknow order by user_id 


   SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [buddy].[get_chat_receiver_info]    Script Date: 1/25/2022 3:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [buddy].[get_chat_receiver_info]  

 @message_id int

AS        
      
/*
	 exec  [buddy].[get_chat_receiver_info]  829755
	 ------------------------------------------------------------          
		select top 10 * from [message].[message] order by message_id desc
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

	select
		mm.chat_id,
		mm.sender_id,
		mm.receiver_id,
		ltrim(rtrim(isnull(o.fname,'') + ' ' + isnull(o.lname,''))) as name,
		case when mm.is_owner = 1 then 'Buddy'
			 when mm.is_dealer = 1 then 'Dealer'
			 else 'Buddy' end as user_type,
		isnull(o.photo,isnull(o.photo_path,'')) as profile_pic
	from 
		message.message mm with(nolock,readuncommitted)
		left join owner.owner o with(nolock,readuncommitted) on
				mm.receiver_id = o.owner_id
	where 
		message_id = @message_id    
      
SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [buddy].[get_invited_buddies_list]    Script Date: 1/25/2022 3:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [buddy].[get_invited_buddies_list]  

		@owner_id int = null

AS        
      
/*
	 exec  [buddy].[get_invited_buddies_list]  404923
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
  
	SET NOCOUNT ON 
	
			Begin
				SELECT
					distinct
					bbi.buddy_invite_id, 
					bbi.email,
					bbi.first_name,
					bbi.last_name,
					bbi.mobile,
					bbi.is_invited
				FROM
					buddy.buddy_invite bbi with(nolock,readuncommitted)
				WHERE
					bbi.is_deleted = 0
					and bbi.is_invited = 1
					and bbi.sender_id = @owner_id

				order by bbi.email
			END

	SET NOCOUNT OFF

	END
	 


GO
/****** Object:  StoredProcedure [buddy].[insert_update_buddy_request]    Script Date: 1/25/2022 3:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [buddy].[insert_update_buddy_request]  

    @sender_id int = NULL,  
    @receiver_id int = NULL, 
	@is_request_accepted bit = 0,
	@buddy_id int = NULL
	 
AS        
      
/*
	 [buddy].[insert_update_buddy_request] 412998,412895
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Date
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     PowerSports                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 PowerSports Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

	set @buddy_id = isnull(@buddy_id,0)

	set @buddy_id = ( select top 1
							buddy_id 
					  from 
						  buddy.buddy with(nolock,readuncommitted) 
					  where 
							is_deleted = 0 and
							( (sender_id = @sender_id and receiver_id = @receiver_id) or 
							  (receiver_id = @sender_id and sender_id = @receiver_id) ) )

	set @buddy_id = isnull(@buddy_id,0)

if(isnull(@sender_id,0) <> isnull(@receiver_id,0))
	Begin 	

		if (isnull(@buddy_id,0) = 0) 
			Begin
				INSERT INTO buddy.buddy 
				(
				    sender_id, 
					receiver_id,
					is_request_accepted,
					created_dt
				)
				VALUES 
				(
					@sender_id, 
					@receiver_id,
					isnull(@is_request_accepted,0),
					GETDATE()
				)
				       
				SET @buddy_id = SCOPE_IDENTITY()        
		          
		   End 
	   else
		   Begin

				UPDATE 
					buddy.buddy 
				SET    
					is_request_accepted= (case when isnull(is_request_accepted,0) = 1 then 1
											  else 0 end),
					updated_dt = GETDATE()  
				WHERE 
					buddy_id =  @buddy_id
			    
			End
	End
else
	Begin
		set @buddy_id = isnull(@buddy_id,0)
	End

select isnull(@buddy_id,0) as buddy_id
      
SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [buddy].[insert_update_invited_buddy]    Script Date: 1/25/2022 3:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [buddy].[insert_update_invited_buddy]  

	@buddy_invite_id int = 0,
    @sender_id int,
	@first_name varchar(100) = null,
	@last_name varchar(100) = null,
    @email varchar(100) = null,    
    @mobile varchar(12) = null,
	@is_invited bit = true
	
   
AS        
      
/*
	 exec [buddy].[insert_update_invited_buddy]
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

	if(@buddy_invite_id = 0)
		begin
			INSERT INTO 
				buddy.buddy_invite 
				(sender_id,
				 first_name,
				 last_name,
				 email, 
				 mobile,
				 is_invited,
				 created_dt
				 )      
				VALUES 
				(@sender_id,
				 @first_name,
				 @last_name,
				 @email, 
				 @mobile,
				 @is_invited,
				 GETDATE()) 
		end
	else
		begin
			update 
				  buddy.buddy_invite 
			set 
				 sender_id = @sender_id,
				 first_name = @first_name,
				 last_name = @last_name,
				 email = @last_name, 
				 mobile = @mobile,
				 is_invited = @is_invited,
				 updated_dt = getdate()
		    where 
				 @buddy_invite_id = @buddy_invite_id and is_deleted = 0

		end

	SET @buddy_invite_id = SCOPE_IDENTITY() 

	select @buddy_invite_id as buddy_invite_id
	
SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [buddy].[unfriend_buddy]    Script Date: 1/25/2022 3:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [buddy].[unfriend_buddy]  

		@buddy_id int = 0

AS        
      
/*
	 exec  [buddy].[unfriend_buddy] 0
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Brand
    
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
	
	declare @sender_id int
	declare @receiver_id int

	SELECT
		 @sender_id = sender_id,
		 @receiver_id = receiver_id
	 from
		buddy.buddy
	 where
		buddy_id = @buddy_id

	UPDATE
		buddy.buddy
	SET
		is_request_accepted = 0,
		is_deleted = 1
	Where 
		buddy_id = @buddy_id

	UPDATE
		buddy.buddy
	SET
		is_request_accepted = 0,
		is_deleted = 1
	Where 
		sender_id = @sender_id
		and receiver_id = @receiver_id

	UPDATE
		buddy.buddy
	SET
		is_request_accepted = 0,
		is_deleted = 1
	Where 
		sender_id = @receiver_id
		and receiver_id = @sender_id

  SET NOCOUNT OFF

	END
	 


GO
/****** Object:  StoredProcedure [coupon].[redeem_coupon_by_id]    Script Date: 1/25/2022 3:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [coupon].[redeem_coupon_by_id]  
	@owner_id BIGINT,
	@coupon_id INT
AS        
      
/*
	 exec  [coupon].[redeem_coupon_by_id] 2,1
	 ------------------------------------------------------------         
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     PowerSports                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 PowerSports Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 
	
			UPDATE 
			      coupon.coupon 
		    SET 
			    is_redeemed=1,
				redeem_owner_id=@owner_id,
				redeemed_dt=GETDATE() 
			WHERE 
			     coupon_id=@coupon_id;

	SET NOCOUNT OFF

END

GO

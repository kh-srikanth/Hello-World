USE [auto_mobile]
GO
/****** Object:  StoredProcedure [message].[chat_receiver_details]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE procedure [message].[chat_receiver_details]

	@receiver_id int,
	@receiver varchar(100)
AS        
      
/*
	 exec [message].[chat_receiver_details] 404923,'owner'
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

	 
	 if(@receiver = 'owner')
		begin
		   select isnull(oo.fname,'') as fname,
			   isnull(oo.lname,'') as lname,
			   isnull(oo.photo,'') as photo,
			   isnull(oo.bground_image,'') as bground_image,
			   isnull(oo.mobile,'') as mobile,
			   oo.owner_id as receiver_id
		   from 
				owner.owner as oo with(nolock,readuncommitted) 
           where 
				oo.owner_id = @receiver_id and 
				oo.is_deleted = 0
		end
	 else if(@receiver = 'dealer')
		begin
		   select isnull(pd.dealer_name,'') as fname,
			   isnull(pd.dealer_last_name,'') as lname,
			   isnull(pd.business_logo,'') as photo,
			   isnull(pd.background_image,'') as bground_image,
			   isnull(pd.direct_phone_number,'') as mobile,
			   pd.dealer_id as receiver_id
		   from 
				portal.dealer as pd with(nolock,readuncommitted) 
           where 
				pd.dealer_id = @receiver_id and 
				pd.is_deleted = 0
		end
		 			 

	

SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [message].[delete_message]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [message].[delete_message] 
 
	 @message_id int
AS        
      
/*
	 exec [message].[delete_message] 
	 ------------------------------------------------------------         
	 PURPOSE        
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 ----------------------------------------------------------------------      
	 06/06/2019    siva        mobile API'S V.2     to get messages between
													owner and dealer
	 ----------------------------------------------------------------------     
                 
*/        
BEGIN 
  
	SET NOCOUNT ON 

		update
				[message].[message]			
		set
				is_deleted = 1 
		where
				message_id = @message_id and is_deleted = 0
			   
	SET NOCOUNT OFF

	END
GO
/****** Object:  StoredProcedure [message].[get_dealer_chats]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [message].[get_dealer_chats] 

   @dealer_id int null 
AS 

/* 
exec [message].[get_dealer_chats] 4035 
--------------------------------------- 

PROCESSES 

MODIFICATIONS 
Date Author WorkTracker Id Description 
----------------------------------------------------------- 
09/09/2017 Warrous Created 
----------------------------------------------------------- 
Copyright 2017 Warrous Pvt Ltd 
*/ 
BEGIN 

SET NOCOUNT ON 

		create table #chats 
		( 
		chat_id int, 
		recent_message varchar(max), 
		recent_date datetime 
		) 

--Get all the Chats associated with user/owner/customer and save them in chats temp table 

		insert into #chats 
		( 
		chat_id, 
		recent_message, 
		recent_date 
		) 
		select 
		mc.chat_id, 
		mch.recent_message, 
		mch.updated_dt 
		from 
		message.clients mc with(nolock,readuncommitted) 
		inner join message.chat mch with(nolock,readuncommitted) 
		on mch.chat_id = mc.chat_id 
		where 
		mc.user_id = @dealer_id and 
		mc.is_deleted = 0 and 
		mc.is_owner = 0 


		create table #chats1 
		( 
		chat_id int, 
		user_id int, 
		is_owner bit, 
		recent_message varchar(max), 
		recent_date datetime 
		) 

-- fetching and saving the owners/dealers with whom the owner has chatted into chats1 temp table 

			insert into #chats1 
			( 
			chat_id, 
			user_id, 
			is_owner, 
			recent_message, 
			recent_date 
			) 
			select 
			mc.chat_id, 
			mc.user_id, 
			mc.is_owner, 
			c.recent_message, 
			c.recent_date 
			from 
			message.clients mc with(nolock,readuncommitted) 
			inner join #chats c on 
			mc.chat_id = c.chat_id 
			where 
			mc.user_id != @dealer_id and 
			mc.is_deleted = 0 

--joining the two results obtained from owner and dealer table based on "is_owner" column 

			select 
			c1.chat_id, 
			o.fname + ' ' + o.lname as name, 
			'Buddy' as user_type, 
			isnull(o.photo,'') as profile_pic, 
			c1.user_id, 
			isnull(c1.recent_message,'') as recent_message, 
			c1.recent_date 
			from 
			#chats1 c1 with(nolock,readuncommitted) 
			inner join owner.owner o with(nolock,readuncommitted) on 
			c1.user_id = o.owner_id 
			where 
			c1.is_owner = 1 
union 
			select 
			c1.chat_id, 
			d.dealer_name as name, 
			'Dealer' as user_type, 
			isnull(d.business_logo,'') as profile_pic, 
			c1.user_id, 
			isnull(c1.recent_message,'') as recent_message, 
			c1.recent_date 
			from 
			#chats1 c1 inner join 
			r2r_portal.portal.dealer d with(nolock,readuncommitted) on 
			c1.user_id = d.dealer_id 
			where 
			c1.is_owner = 0 
			order by c1.recent_date desc 


drop table #chats 
drop table #chats1 

SET NOCOUNT OFF 
END 

GO
/****** Object:  StoredProcedure [message].[get_message]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [message].[get_message] 
 
	 @owner_id int = null,
	 @dealer_id int = null
AS        
      
/*
	 exec  [message].[get_message] 
	 ------------------------------------------------------------         
	 PURPOSE        
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 ----------------------------------------------------------------------      
	 06/06/2019    siva        mobile API'S V.2     to get messages between
													owner and dealer
	 ----------------------------------------------------------------------     
                 
*/        
BEGIN 
  
	SET NOCOUNT ON 

		SELECT
				isnull(sender_id,0) as owner_id,
				isnull(receiver_id,0) as dealer_id,
				isnull(message,'') as message,
				is_owner,
				is_dealer
		FROM 
				[message].[message]			
		where 
				is_deleted = 0 
				and sender_id = @owner_id 
				and receiver_id = @dealer_id
			    order by created_date desc
	SET NOCOUNT OFF

	END
GO
/****** Object:  StoredProcedure [message].[get_owner_chat_messages]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [message].[get_owner_chat_messages]  

	  @sender_id int = null,
	  @receiver_id int = null,
	  @page_no int = 0,
	  @chat_id int = 0
AS        
      
/*
	 exec   [message].[get_owner_chat_messages] 829685,1205262
	 --------------------------------------------       
    
	 select * from message.message   where chat_id = 6
     update message.message set is_deleted = 1 where message_id  = 2050
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

	  declare @id int;
	    declare @type varchar(50);
		declare @page_size int = 100
		declare @owner_chat_id int = 0

	    set @id = (select top 1 owner_id from [owner].[owner] with(nolock,readuncommitted) where owner_id = @receiver_id and is_deleted = 0 and is_app_user = 1)
	    
		if(@id is null)begin set @type = 'dealer' end else begin set @type = 'owner' end

		set @page_no = isnull(@page_no, 1) - 1

		set @page_no = IIF(@page_no <= 0, 0, @page_no )

		set @owner_chat_id = [message].[get_chat_id](@sender_id, @receiver_id, 'owner', @type)

		set @owner_chat_id = isnull(@owner_chat_id, 0)

		set @owner_chat_id = IIF(@owner_chat_id <= 0, @chat_id, @owner_chat_id)

		print @owner_chat_id


select * from (

		select
			  mm.message_id,
			  mm.chat_id,
			  mm.sender_id,
			  mm.receiver_id,
			  mm.message,
			  mm.is_sent,
			  mm.is_delivered,
			  mm.is_read,
			  mm.is_dealer,
			  mm.is_owner,
			  mmt.message_type_code as message_type,
			  isnull(mm.ride_id, 0) as ride_id,
			  rr.start_geo_lat as start_latitude,
			  rr.start_geo_lon as start_longitude,
			  rr.end_geo_lat as end_latitude,
			  rr.end_geo_long as end_longitude,
			  mm.created_date,
			  rrr.file_url as gpx_file,
			  mm.attachment,
			  mm.thumbnail
		from
			 [message].[message] mm with(nolock,readuncommitted)
			 inner join [message].[message_type] mmt with(nolock,readuncommitted)
			 on mmt.message_type_id = mm.message_type_id
			 left join [ride].[ride] rr with(nolock,readuncommitted)
			 on rr.ride_id = mm.ride_id and rr.is_deleted = 0
			 left join [ride].[rated_routes] rrr
			 on mm.ride_id = rrr.routed_id and rrr.is_deleted = 0
		where
			 mm.chat_id = @owner_chat_id
			 and mm.is_deleted = 0
			 and mmt.is_deleted = 0
		order by
			 mm.created_date desc
			 offset (@page_no * @page_size) rows fetch next @page_size rows only

) msg order by msg.created_date asc
		

	SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [message].[get_owner_chats]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [message].[get_owner_chats]  

	  @owner_id int null
AS        
      
/*
	 exec   [message].[get_owner_chats] 404923
	 ---------------------------------------       
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     WorkTracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 


		create table #chats
		(
			chat_id int,
			recent_message varchar(max),
			recent_date datetime
		)

		--Get all the Chats associated with user/owner/customer and save them in chats temp table
		insert into #chats
		(
			chat_id,
			recent_message,
			recent_date
		)
		select 
			mc.chat_id,
			mch.recent_message,
			mch.updated_dt
		from 
			message.clients mc with(nolock,readuncommitted)
			inner join message.chat mch with(nolock,readuncommitted)
			on mch.chat_id = mc.chat_id
		where
			mc.user_id = @owner_id and
			mc.is_deleted = 0 and
			mc.is_owner = 1

		create table #chats1
		(
			chat_id int,
			user_id int,
			is_owner bit,
			recent_message varchar(max),
			recent_date datetime
		)

		-- fetching and saving the owners/dealers with whom the owner has chatted into chats1 temp table
		insert into #chats1
		(
			chat_id,
			user_id,
			is_owner,
			recent_message,
			recent_date
		)
		select
			mc.chat_id,
			mc.user_id,
			mc.is_owner,
			c.recent_message,
			c.recent_date
		from 
			message.clients mc with(nolock,readuncommitted)
			inner join #chats c on
				mc.chat_id = c.chat_id
		where
			mc.user_id != @owner_id and
			mc.is_deleted = 0

		--joining the two results obtained from owner and dealer table based on "is_owner" column
		select
			c1.chat_id,
			o.fname + ' ' + o.lname as name,
			'Buddy' as user_type,
			isnull(o.photo,'') as profile_pic,
			c1.user_id,
			isnull(c1.recent_message,'') as recent_message,
			c1.recent_date
		from
			#chats1 c1 with(nolock,readuncommitted)
			inner join owner.owner o with(nolock,readuncommitted) on
				c1.user_id = o.owner_id
		where
			c1.is_owner = 1
		union 
		select
			c1.chat_id, 
			d.dealer_name as name,
			'Dealer' as user_type,
			isnull(d.business_logo,'') as profile_pic,
			c1.user_id,
			isnull(c1.recent_message,'') as recent_message,
			c1.recent_date
		from
			#chats1 c1 inner join
			r2r_portal.portal.dealer d  with(nolock,readuncommitted) on
				c1.user_id = d.dealer_id
		where
			c1.is_owner = 0
		order by c1.recent_date desc
		
		drop table #chats
		drop table #chats1

	SET NOCOUNT OFF

	END
	 


GO
/****** Object:  StoredProcedure [message].[get_owner_last_chat_message]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [message].[get_owner_last_chat_message]  

@chat_id int null

AS        
      
/*
	 exec  [message].[get_owner_last_chat_message]   13
	 --------------------------------------------       
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

		select top 1
			  mm.message_id,
			  mm.chat_id,
			  mm.sender_id,
			  mm.receiver_id,
			  mm.message,
			  mm.is_sent,
			  mm.is_delivered,
			  mm.is_read,
			  mm.is_dealer,
			  mm.is_owner,
			  mmt.message_type_code as message_type,
			  isnull(mm.ride_id, 0) as ride_id,
			  rr.start_geo_lat as start_latitude,
			  rr.start_geo_lon as start_longitude,
			  rr.end_geo_lat as end_latitude,
			  rr.end_geo_long as end_longitude,
			  mm.created_date,
			  rrr.file_url as gpx_file,
			  mm.attachment,
			  mm.thumbnail
		from
			 [message].[message] mm with(nolock,readuncommitted)
			 inner join [message].message_type mmt with(nolock,readuncommitted)
			 on mmt.message_type_id = mm.message_type_id
			 left join ride.ride rr with(nolock,readuncommitted)
			 on rr.ride_id = mm.ride_id and rr.is_deleted = 0
			 left join [ride].[rated_routes] rrr
			 on mm.ride_id = rrr.routed_id
		where
		     mm.chat_id = @chat_id
			 and mm.is_deleted = 0
			 and mmt.is_deleted = 0
		order by
			 mm.created_date desc

	SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [message].[get_user_last_chat_message]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [message].[get_user_last_chat_message]  

      @owner_id int,
	  @chat_id int null
AS        
      
/* 
	 exec   [message].[get_user_last_chat_message]   425247, 77
	 --------------------------------------------       
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

	if(@chat_id = 0)
	begin
	 Select * 
          from
		      (
				
		select top 1
			  mm.message_id,
			  mm.chat_id,
			  mm.sender_id,
			  mm.receiver_id,
			  mm.message,
			  mm.is_sent,
			  mm.is_delivered,
			  mm.is_read,
			  mm.is_dealer,
			  mm.is_owner,
			  mmt.message_type_code as message_type,
			  isnull(mm.ride_id, 0) as ride_id,
			  rr.start_geo_lat as start_latitude,
			  rr.start_geo_lon as start_longitude,
			  rr.end_geo_lat as end_latitude,
			  rr.end_geo_long as end_longitude,
			  mm.created_date,
			  rrr.file_url as gpx_file,
			  mm.attachment,
			  mm.thumbnail
		from
			 message.message mm with(nolock,readuncommitted)
			 inner join message.message_type mmt with(nolock,readuncommitted)
			 on mmt.message_type_id = mm.message_type_id
			 left join ride.ride rr with(nolock,readuncommitted)
			 on rr.ride_id = mm.ride_id and rr.is_deleted = 0
			 left join [ride].[rated_routes] rrr
			 on mm.ride_id = rrr.routed_id
		where
		     mm.sender_id = @owner_id
			 and mm.is_deleted = 0
			 and mmt.is_deleted = 0
		order by
			 mm.created_date desc
		   	 ) msgs
			     order by 
				     msgs.created_date desc

	end

	else
	begin
  Select * 
          from
		      (
				
		select top 1
			  mm.message_id,
			  mm.chat_id,
			  mm.sender_id,
			  mm.receiver_id,
			  mm.message,
			  mm.is_sent,
			  mm.is_delivered,
			  mm.is_read,
			  mm.is_dealer,
			  mm.is_owner,
			  mmt.message_type_code as message_type,
			  isnull(mm.ride_id, 0) as ride_id,
			  rr.start_geo_lat as start_latitude,
			  rr.start_geo_lon as start_longitude,
			  rr.end_geo_lat as end_latitude,
			  rr.end_geo_long as end_longitude,
			  mm.created_date,
			  rrr.file_url as gpx_file,
			  mm.attachment,
			  mm.thumbnail
		from
			 message.message mm with(nolock,readuncommitted)
			 inner join message.message_type mmt with(nolock,readuncommitted)
			 on mmt.message_type_id = mm.message_type_id
			 left join ride.ride rr with(nolock,readuncommitted)
			 on rr.ride_id = mm.ride_id and rr.is_deleted = 0
			 left join [ride].[rated_routes] rrr
			 on mm.ride_id = rrr.routed_id
		where
		     mm.sender_id = @owner_id
			 and mm.is_deleted = 0
			 and mmt.is_deleted = 0	
			 order by mm.created_date desc
		   	 ) msgs
			     order by 
				     msgs.created_date desc
end

	SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [message].[save_message]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [message].[save_message]  
 @owner_id int = null,
 @dealer_id int = null,
 @message varchar(max) = null,
 @is_owner bit = 0,
 @is_dealer bit = 0

AS

/* exec [message].[save_message]   
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
	
	INSERT INTO [message].[message]
	(
		 sender_id,
		 receiver_id,
		 message,
		 is_owner,
		 is_dealer,
		 is_sent
	)
	VALUES
	(
		 @owner_id,
		 @dealer_id,
		 @message,
		 @is_owner,
		 @is_dealer,
		 1
	)

	SELECT
	SCOPE_IDENTITY() as message_id
	
 END  

 SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [message].[save_message_by_chat_id]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [message].[save_message_by_chat_id]  

	  @chat_id int = null,
	  @message nvarchar(max) = null,
	  @message_type varchar(50) = 'Text',
	  @sender_id int = null,
	  @receiver_id int = null,
	  @sender varchar(100) = null,
	  @receiver varchar(100) = null,
	  @attachment varchar(max) = null,
	  @thumbnail nvarchar(max) = null
AS        
      
/*
	 exec [message].[save_message_by_chat_id] 1
	 --------------------------------------------       
    
	 select * from message.message   
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON
	
	declare @message_type_id int = 1 

	set @chat_id = isnull(@chat_id,0)

	set @sender = iif(@sender = 'Dealer', 'Dealer', 'Owner')
	set @receiver = iif(@receiver = 'Dealer', 'Dealer', 'Owner')

	set @message_type_id = ( select top 1 
									message_type_id
							  from
									message.message_type mmt with(nolock,readuncommitted)
							  where
									is_deleted = 0
									and message_type_code = @message_type )

    set @message_type_id = isnull(@message_type_id, 1)

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
				message_type_id,
				sender_id,
				receiver_id,
				message,
				is_owner,
				is_dealer,
				is_sent,
				created_date,
				attachment,
				thumbnail
			)output inserted.message_id
			values
			(
				@chat_id,
				isnull(@message_type_id,1),
				@sender_id,
				@receiver_id,
				isnull(@message,''),
				case when @sender = 'owner' then 1 else 0 end,
				case when @sender = 'dealer' then 1 else 0 end,
				1,
				getdate(),
				@attachment,
				@thumbnail
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
				message_type_id,
				sender_id,
				receiver_id,
				message,
				is_owner,
				is_dealer,
				is_sent,
				created_date,
				attachment,
				thumbnail
			)output inserted.message_id
			values
			(
				@chat_id,
				isnull(@message_type_id,1),
				@sender_id,
				@receiver_id,
				isnull(@message,''),
				case when @sender = 'owner' then 1 else 0 end,
				case when @sender = 'dealer' then 1 else 0 end,
				1,
				getdate(),
				@attachment,
				@thumbnail
			)

		end
		
		
		

	SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [message].[send_message_to_buddy]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [message].[send_message_to_buddy]  
 @sender_id int = null,
 @receiver_id int = null,
 @message varchar(max) = null,
 @is_owner bit = 0,
 @is_dealer bit = 0

AS

/* exec [message].[send_message_to_buddy]   
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
	
	INSERT INTO [message].[message]
	(
		 sender_id,
		 receiver_id,
		 message,
		 is_owner,
		 is_dealer,
		 is_sent
	)
	VALUES
	(
		 @sender_id,
		 @receiver_id,
		 @message,
		 @is_owner,
		 @is_dealer,
		 1
	)

	SELECT
	SCOPE_IDENTITY() as message_id
	
 END  

 SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [notification].[get_notifications]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [notification].[get_notifications]
       
	@owner_id int 

AS        
      
/*
	 exec  [notification].[get_notifications] 405960
	 ------------------------------------------------------------         
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 05/08/2019      Ready2Ride                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 Ready2Ride Pvt Ltd
*/        

  
SET NOCOUNT ON 
 
	BEGIN        

		set @owner_id = isnull(@owner_id,0)

		if(@owner_id > 0)     

			begin      

				SELECT  
					distinct
					mn.notification_id,
					isnull(mn.notification_type_id,3) as notification_type_id,
					isnull(nnt.notification_type,'Welcome') as notification_type,
					isnull(mn.owner_id,0) as owner_id,
					isnull(mn.sender_owner_id,0) as sender_owner_id,
					isnull(mn.dealer_id,0) as dealer_id,
					isnull(mn.id,0) as id,
					isnull(mn.name,0) as name,
					isnull(mn.title,0) as title,
					isnull(mn.description,'') as description,
					isnull(mn.image,'') as image,
					isnull(mn.sent_by,0) as sent_by,
					isnull(mn.is_read,0) as is_read,
					isnull(mn.is_accepted,0) as is_accepted,
					isnull(mn.cycle_id,0) as cycle_id,
					isnull(mn.subject,'') as subject,
					isnull(mn.created_dt,getdate()) as created_dt,
					isnull(mn.notification_date,getdate()) as notification_date,
					mn.start_date,
					mn.end_date,
					case when mn.notification_type_id = 4 then ''
                    when mm.thumbnail is null then ''
                    else  mm.thumbnail end thumbnail,
                    case when mn.notification_type_id = 4 then 'Buddy Request'
                    when mmt.message_type_code is null then isnull(mmt.message_type_code,'')
                    else mmt.message_type_code end message_type_code 
				FROM 
					 message.notification mn with(nolock,readuncommitted)
					 inner join notification.notification_type nnt with(nolock,readuncommitted)
					 on mn.notification_type_id = nnt.notification_type_id
					 left join message.message mm with(nolock,readuncommitted) 
                     on mm.message_id = mn.id
                     left join [message].[message_type] mmt with(nolock,readuncommitted)
                     on mm.message_type_id = mmt.message_type_id and mmt.is_deleted = 0
				WHERE  
					mn.owner_id=@owner_id and
					mn.is_deleted = 0  and
					mn.is_removed = 0 and
					isnull(mn.id,0) > 0
				ORDER BY 
					mn.notification_id desc
						        
			end      

		else      

			begin      

				SELECT  distinct
					mn.notification_id,
					isnull(mn.notification_type_id,3) as notification_type_id,
					isnull(nnt.notification_type,'Welcome') as notification_type,
					isnull(mn.owner_id,0) as owner_id,
					isnull(mn.sender_owner_id,0) as sender_owner_id,
					isnull(mn.dealer_id,0) as dealer_id,
					isnull(mn.id,0) as id,
					isnull(mn.name,0) as name,
					isnull(mn.title,0) as title,
					isnull(mn.description,'') as description,
					isnull(mn.image,'') as image,
					isnull(mn.sent_by,0) as sent_by,
					isnull(mn.is_read,0) as is_read,
					isnull(mn.is_accepted,0) as is_accepted,
					isnull(mn.cycle_id,0) as cycle_id,
					isnull(mn.subject,'') as subject,
					isnull(mn.created_dt,getdate()) as created_dt,
					isnull(mn.notification_date,getdate()) as notification_date,
					mn.start_date,
					mn.end_date,
					isnull(mm.thumbnail,'') as thumbnail,
					isnull(mmt.message_type_code,'') as message_type_code
				FROM 
					message.notification mn with(nolock,readuncommitted)
					inner join notification.notification_type nnt with(nolock,readuncommitted)
					on mn.notification_type_id = nnt.notification_type_id
					left join message.message mm with(nolock,readuncommitted) 
					on mm.message_id = mn.id
					left join [message].[message_type] mmt with(nolock,readuncommitted)
					on mm.message_type_id = mmt.message_type_id and mmt.is_deleted = 0
				WHERE 
					mn.is_deleted = 0 and
					mn.is_removed = 0 and
					isnull(mn.id,0) > 0
				ORDER BY 
					mn.notification_id desc

			end       

	END 

SET NOCOUNT OFF




GO
/****** Object:  StoredProcedure [notification].[get_notifications_all]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [notification].[get_notifications_all]
       
	@dealer_id int = null,
	@owner_id int = null 

AS        
      
/*
	 exec  [notification].[get_notifications_all] 1,2
	 ------------------------------------------------------------         
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 05/08/2019      Ready2Ride                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 
 
		BEGIN        

			if(@dealer_id <> 0 and @owner_id <> 0)      

				 begin      

					SELECT  
					      mn.notification_id,
						  mn.dealer_id,
						  mn.cycle_id,
						  mn.description,
						  mn.subject,
						  mn.owner_id,
						  mn.created_dt,
						  mn.notification_date

					  FROM 
						 message.notification mn with(nolock,readuncommitted)

					  WHERE  
							mn.dealer_id = @dealer_id  and 
						    mn.owner_id=@owner_id and
							mn.is_deleted = 0  
					  ORDER BY 
							mn.notification_id desc
						        
				  end      

			else      

				  begin      

					   SELECT  
					      mn.notification_id,
						  mn.dealer_id,
						  mn.cycle_id,
						  mn.description,
						  mn.subject,
						  mn.owner_id,
						  mn.created_dt,
						  mn.notification_date

					  FROM 
						message.notification mn with(nolock,readuncommitted)
					  WHERE 
						 mn.is_deleted = 0 
					  ORDER BY 
							mn.notification_id desc
				  end       

		END 

    SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [notification].[perform_notification_action]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [notification].[perform_notification_action]

    @id int,
	@owner_id int = null ,
	@notification_id int = 0,
	@action bit = 0,
	@notification_type varchar(100) = 'Welcome'

AS        
      
/*
	 exec  [notification].[perform_notification_action] 10082,404923,355,1,'Promotion'
	 ------------------------------------------------------------         
     select * from message.notification
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 05/08/2019      Ready2Ride                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

		declare @count int = 0;
		declare @is_saved_count int = 0;
		declare @is_attending_count int = 0;
 
		BEGIN
			        

			if(@id > 0)      

				 begin      

					if(@notification_type = 'Event')      

						begin 
							set @count = 0

							select @count = count(*) from  owner.owner_events with(nolock,readuncommitted)  where is_deleted = 0 and owner_id = @owner_id and event_id = @id
							
							set @count = isnull(@count,0)

							if(isnull(@count,0) = 0)
								begin
									insert into owner.owner_events 
												(owner_id,
												 status,
												 event_id,
												 is_attending) 
										  values
												(@owner_id,
												 '',
												 @id,
												 @action)
								end
							else
								begin
									update 
										owner.owner_events 
									set
										is_attending = 1
									where
										owner_id = @owner_id
										and event_id = @id
								end

							update 
								 message.notification
							set
								is_read = 1
							where 
								notification_id = @notification_id
						end

					else if(@notification_type = 'Promotion')      

						begin
							set @count = 0

							select @count = count(*) from  owner.owner_promotions with(nolock,readuncommitted)  where is_deleted = 0 and owner_id = @owner_id and promotion_id = @id

							if(isnull(@count,0) = 0)
								begin
									insert into owner.owner_promotions
											(owner_id,
											 status,
											 promotion_id,
											 is_saved) 
									   values
											(@owner_id,
											 '',
											 @id,
											 @action)
								end 
							else
								begin
									update 
										owner.owner_promotions 
									set
										is_saved = 1
									where
										owner_id = @owner_id
										and promotion_id = @id
								end

							update 
								 message.notification
							set
								is_read = 1
							where 
								notification_id = @notification_id
							
						end

					else if(@notification_type = 'Welcome')      

						begin 

							update 
								 message.notification
							set
								is_read = 1
							where 
								notification_id = @notification_id

						end

					else if(@notification_type = 'Friend Request')      

						begin 

							update 
								 buddy.buddy
							set
								is_request_accepted = @action
							where 
								buddy_id = @id

							update 
								 message.notification
							set
								is_read = 1,
								is_accepted = isnull(@action,0),
								is_removed =  case when isnull(@action,0) = 0 then 1  
												   else 0 end
							where 
								notification_id = @notification_id

						end
						        
				  end      

		END 

    SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [notification].[request_notification_action]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [notification].[request_notification_action]

    @buddy_id int,
	@owner_id int = null,
	@action bit = 0

AS        
      
/*
	 exec  [notification].[request_notification_action] 1199,425247,1
	 ------------------------------------------------------------         
     select * from message.notification
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 05/08/2019      Ready2Ride                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 
    					if(@action = 1)	
						begin
							update 
								 buddy.buddy
							set
								is_request_accepted = @action
							where 
								buddy_id = @buddy_id
                        end
						
    					if(@action = 0)	
						begin
							update 
								 buddy.buddy
							set
								is_deleted = 1
							where 
								buddy_id = @buddy_id
                        end

							update 
								 message.notification
							set
								is_read = 1,
								is_accepted = isnull(@action,0),
								is_removed =  case when isnull(@action,0) = 0 then 1  
												   else 0 end
							where 
								notification_type_id = 4
								and owner_id = @owner_id	
								and id =@buddy_id	
								and is_deleted = 0										        				    		

    SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [notification].[save_notification]    Script Date: 1/25/2022 4:15:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [notification].[save_notification] 
 
 @notification_id int = 0,
 @id int,
 @owner_id int,
 @dealer_id int = 0,
 @name varchar(250) = null,
 @notification_type varchar(100) = 'Welcome',
 @title varchar(250) = '',
 @description varchar(max) = '',
 @subject varchar(100) = '',
 @image varchar(max) = '',
 @start_date datetime = null,
 @end_date datetime = null

AS

/* 
	exec [notification].[save_notification]   
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

	declare @notification_type_id int = 3;
	declare @count int = 0;

	select top 1 @notification_type_id = notification_type_id from notification.notification_type where notification_type = @notification_type

	select @count = count(*) from message.notification where owner_id = @owner_id and id = @id and notification_type_id = @notification_type_id and is_deleted = 0

	if(@count = 0)

		Begin

			IF(isnull(@notification_id,0) = 0)

				Begin
					INSERT INTO [message].[notification]
					(
						 notification_type_id,
						 owner_id,
						 dealer_id,
						 id,
						 name,
						 title,
						 description,
						 image,
						 subject,
						 notification_date,
						 is_read,
						 is_removed
					)
					VALUES
					(
						 @notification_type_id,
						 @owner_id,
						 isnull(@dealer_id,0),
						 @id,
						 isnull(@name,''),
						 isnull(@title,''),
						 isnull(@description,''),
						 isnull(@image,''),
						 isnull(@subject,''),
						 getdate(),
						 0,
						 0
					)
				End

			Else

				Begin

					update 
						[message].[notification]
					set
						notification_type_id = @notification_type_id,
						owner_id = @owner_id,
						dealer_id = isnull(@dealer_id,0),
						id = @id,
						name = isnull(@name,''),
						title = isnull(@title,''),
						description = isnull(@description,''),
						subject = isnull(@subject,''),
						image = isnull(@image,''),
						is_read = 0,
						is_removed = 0,
						notification_date = getdate(),
						updated_dt = getdate()
					where 
						notification_id = @notification_id

				End

		End

	Else 

		Begin

			set @notification_id = ( select
										top 1 notification_id
									 from 
										[message].[notification] with(nolock, readuncommitted)
									 where 
										owner_id = @owner_id 
										and id = @id 
										and notification_type_id = @notification_type_id 
										and is_deleted = 0
									 order by
										notification_id desc
									)
												
			set @notification_id = isnull(@notification_id, 0)

			update 
				[message].[notification]
			set
				notification_type_id = @notification_type_id,
				owner_id = @owner_id,
				dealer_id = isnull(@dealer_id,0),
				id = @id,
				name = isnull(@name,''),
				title = isnull(@title,''),
				description = isnull(@description,''),
				subject = isnull(@subject,''),
				image = isnull(@image,''),
				is_read = 0,
				is_removed = 0,
				notification_date = getdate(),
				updated_dt = getdate()
			where 
				notification_id = @notification_id

		End
		
 END  

 SET NOCOUNT OFF;
GO

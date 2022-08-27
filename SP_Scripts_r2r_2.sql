USE [auto_mobile]
GO
/****** Object:  StoredProcedure [cycle].[book_appointment]    Script Date: 1/25/2022 4:04:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE procedure [cycle].[book_appointment]  
 @cycle_id int,
 @Service_Category_id int = null,
 @date varchar(50) = null,
 @time varchar(50) = null,
 @cycle_service_id int,
 @dealer_id int = null,
 @request_from varchar(100) = null


AS

/*  
	exec [cycle].[book_appointment] 
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

     declare @id int = 0
	
	 set @cycle_service_id = isnull(@cycle_service_id,0)

	 IF(@cycle_service_id = 0)
		 BEGIN
	
			INSERT INTO [cycle].[cycle_service]
			(
				 cycle_id,
				 service_category_id,
				 request_date,
				 request_time,
				 dealer_id,
				 request_from
			)
			VALUES
			(
				@cycle_id,
				@service_category_id,
				@date,
				@time,
				@dealer_id,
				@request_from
			)

			set @id = SCOPE_IDENTITY() 

			INSERT INTO service.service_notification
			(
				 cycle_id,
				 cycle_service_id,
				 notification_type,
				 is_read,
				 status
			)
			VALUES
			(
				@cycle_id,
				@id,
				'U',
				0,
				'Active'
			)
	
		 END  
	 ELSE
		 BEGIN
 
			UPDATE 
				[cycle].[cycle_service] 
			SET
				cycle_id = @cycle_id,
				service_category_id = @service_category_id,
				request_date = @date,
				request_time = @time	
			WHERE
				cycle_service_id = @cycle_service_id 

		 END 

 SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [cycle].[cycle_brand_get]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [cycle].[cycle_brand_get]  

		@brand_id int = 0

AS        
      
/*
	 exec  [cycle].[cycle_brand_get] 0
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
	
	   IF(@brand_id = 0)
			Begin
				SELECT
					 br.brand_id 
					,br.brand_name 

				FROM
					cycle.brand_v1 br with(nolock,readuncommitted)
				WHERE
					br.is_deleted = 0
					and isnull(ltrim(rtrim(br.brand_name)),'') <> ''

				order by br.brand_name asc
			END
		Else
		   Begin
			 SELECT
					 br.brand_id 
					,br.brand_name 

				FROM
					cycle.brand_v1 br with(nolock,readuncommitted)
				WHERE
					br.is_deleted = 0 
					and br.brand_id = @brand_id
					and isnull(ltrim(rtrim(br.brand_name)),'') <> ''

				order by br.brand_name asc
		   END

	SET NOCOUNT OFF

	END
	 


GO
/****** Object:  StoredProcedure [cycle].[cycle_model_get_v2]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [cycle].[cycle_model_get_v2]
	@brand_year_id int = 0
AS        
      
/*
	 exec [cycle].[cycle_model_get_v2] 8577
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Model
    
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
		BEGIN
			select 
				  cmv.model as model_name
				 ,cmv.model_id 
			from 
				cycle.brand_year_model cbym with(nolock,readuncommitted) 
				inner join cycle.model_v1 cmv with(nolock,readuncommitted)
				on cmv.model_id = cbym.model_id
			where 
				cbym.brand_year_id = @brand_year_id
				and cbym.is_deleted = 0
				and cmv.is_deleted = 0
				and isnull(ltrim(rtrim(cmv.model)),'') <> ''
			order by 
				cmv.model
		END

SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [cycle].[cycle_year_get]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [cycle].[cycle_year_get]  

		@brand_id int = 0

AS        
      
/*
	 exec  [cycle].[cycle_year_get]  
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get yaer by Brand
    
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
	
	   IF(@brand_id = 0 or @brand_id is null)
			Begin
				SELECT
					 cy.year_id 
					,cy.year
					,0 as brand_year_id
				FROM
					cycle.year cy with(nolock,readuncommitted)
				WHERE
					cy.is_deleted = 0
					and isnumeric(cy.year) = 1

				order by cy.year desc
			END
		Else
		   Begin
			 SELECT
					 cy.year_id 
					,cy.year
					,cby.brand_year_id

				FROM
					cycle.year cy with(nolock,readuncommitted)
					inner join cycle.brand_year cby with(nolock,readuncommitted)
					on cby.year_id = cy.year_id
					and cby.brand_id = @brand_id
				WHERE
					cby.is_deleted = 0 
					and cy.is_deleted = 0
					and isnumeric(cy.year) = 1

				order by cy.year desc 
		   END

	SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [cycle].[delete_cycle_by_id]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [cycle].[delete_cycle_by_id]

	 @cycle_id int = NULL

AS        
      
/*
	 exec  [cycle].[delete_cycle_by_id]
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

		set @cycle_id = isnull(@cycle_id,0)

		update 
		     cycle.cycle 
		set 
			is_deleted = 1 
	    where 
			cycle_id  = @cycle_id
    
        update
		     cycle.cycle_preference 
	    set 
			primary_bike_id = null 
		where 
			primary_bike_id  = @cycle_id
		
		update
		     ride.ride 
		set 
			 is_deleted = 1 
		where 
			 cycle_id  = @cycle_id

    SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [cycle].[delete_owner_cycle]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [cycle].[delete_owner_cycle]

	 @cycle_ids varchar(max) = NULL

AS        
      
/*
	 exec  [cycle].[delete_owner_cycle]
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get cycle service log
    
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

		set @cycle_ids = isnull(@cycle_ids,'')

		update 
		     cycle.cycle 
		set 
			is_deleted = 1 
	    where 
			cycle_id in  (select LTRIM(RTRIM(value)) from String_Split(@cycle_ids,','))  
    
        update
		     cycle.cycle_preference 
	    set 
			primary_bike_id = null 
		where 
			primary_bike_id in (select LTRIM(RTRIM(value)) from String_Split(@cycle_ids,','))
		
		update
		     ride.ride 
		set 
			 is_deleted = 1 
		where 
			 cycle_id in (select LTRIM(RTRIM(value)) from String_Split(@cycle_ids,','))      

    SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [cycle].[get_cycle_details]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE procedure [cycle].[get_cycle_details]
	@owner_id int = NULL,
	@cycle_id int = NULL
AS        
      
/*
	 exec  [cycle].[get_cycle_details] 829685,296004
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get cycle service log
    
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
	
	 declare @total_time int = 0 

	 set @owner_id = isnull(@owner_id,0)
	 set @cycle_id = isnull(@cycle_id,0)

	 set @total_time =  ( select 
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

	 set @total_time = isnull(@total_time,0)

	 BEGIN
                
		 if(@owner_id > 0 and @cycle_id > 0)                    
		    begin  
			
			   ;WITH owner_services as 
			   (select
					ccs.cycle_id,
					max(ccs.service_date) as service_date
				from  
					cycle.cycle_service ccs with (nolock,readuncommitted)
					left join cycle.cycle cc  with (nolock,readuncommitted)
					on cc.cycle_id = ccs.cycle_id
					left join owner.owner oo with (nolock,readuncommitted)
					on oo.owner_id = cc.owner_id  
				 where 
						oo.owner_id = @owner_id
						and cc.is_deleted = 0
						and ccs.is_deleted = 0
				 group by
					ccs.cycle_id),

				owner_cycles as (

				select isnull(cc.model_id,0) as model_id,
					  isnull(cc.cycle_id,0) as cycle_id,
					  isnull(cc.owner_id,0) as owner_id,
					  isnull(cc.year,'') as year,
					  isnull(cc.name,'') as cycle_name,
					  isnull(cc.odometer_reading,0) as odometer_reading,
					  isnull(cc.photo,'') as photo,
					  isnull(cc.brand_id,0) as brand_id,
					  isnull(cc.photo_path,'') as photo_path,
					  isnull(cct.name,'') as category_name,
					  isnull(cbv1.brand_name,'') as brand_name,
					  isnull(cmv1.model,'') as model_name,
					  isnull(cc.vin,'') as vin,
					 -- isnull(cc.purchase_date,'') as purchase_date,
					 coalesce( convert( varchar(10), cc.purchase_date, 103 ), '') as purchase_date,
					  isnull(cc.is_default,0) as is_default,
					  isnull(convert(varchar(20), os.service_date, 101),'') as last_service,
					  case when os.service_date >= DATEADD(month, -6, GETDATE()) then 'Healthy'
						   when os.service_date < DATEADD(month, -6, GETDATE()) and os.service_date >= DATEADD(month, -24, GETDATE()) then 'Time for Service'
						   when os.service_date < DATEADD(month, -24, GETDATE()) then 'Needs Attention'
						   when os.service_date is null or os.service_date = '' then '----' end as health_description,
					  isnull([ride].[get_ride_time_from_seconds](@total_time),'00:00:00') as total_time,
					  case when oo.mobile is null or oo.mobile = '' then CAST(0 as bit) else CAST(1 as bit) end as mobile
				FROM cycle.cycle cc with (nolock,readuncommitted)
					  Left join cycle.brand_v1 cbv1 with (nolock,readuncommitted)
					  on cbv1.brand_id=cc.brand_id 
					  Left join cycle.model_v1 cmv1 with (nolock,readuncommitted)      
					  on cmv1.model_id= cc.model_id 
					  Left join cycle.category cct with (nolock,readuncommitted)
					  on cct.category_id= cc.category_id              
					  Left Join ride.ride_type rrt with (nolock,readuncommitted)
					  On rrt.ride_type_id =cc.riding_style_id
					  Left Join r2r_portal.portal.dealer pd with (nolock,readuncommitted)
					  on pd.dealer_id= cc.dealer_id  
					  left join cycle.year cy with (nolock,readuncommitted)
					  on cc.year=cy.year_id
					  left join owner_services as os with (nolock,readuncommitted)
					  on(os.cycle_id=cc.cycle_id)	
					  left join owner.owner oo with (nolock,readuncommitted)
				      on cc.owner_id = oo.owner_id    
				 WHERE  
					 cc.owner_id = @owner_id 
					 and cc.cycle_id = @cycle_id
					 and cc.is_deleted <> 1 
					 and cc.owner_id <> 0 
				)
				select 
						* 
				from 
					owner_cycles oc with (nolock,readuncommitted)
				order by 
					 isnull(oc.is_default,0) desc    
		    
			end 
			                  
		 else if(@owner_id > 0	and @cycle_id = 0)                     
		    begin                    
                
				BEGIN TRY
				   ;WITH owner_services as 
				   (select
						ccs.cycle_id,
						max(ccs.service_date) as service_date
					from  
						cycle.cycle_service ccs with (nolock,readuncommitted)
						left join cycle.cycle cc  with (nolock,readuncommitted)
						on cc.cycle_id = ccs.cycle_id
						left join owner.owner oo with (nolock,readuncommitted)
						on oo.owner_id = cc.owner_id  
					 where 
							oo.owner_id = @owner_id
							and cc.is_deleted = 0
							and ccs.is_deleted = 0
					 group by
						ccs.cycle_id),

					owner_cycles as (

					select isnull(cc.model_id,0) as model_id,
						  isnull(cc.cycle_id,0) as cycle_id,
						  isnull(cc.owner_id,0) as owner_id,
						  isnull(cc.year,'') as year,
						  isnull(cc.name,'') as cycle_name,
						  isnull(cc.odometer_reading,0) as odometer_reading,
						  isnull(cc.photo,'') as photo,
						  isnull(cc.brand_id,0) as brand_id,
						  isnull(cc.photo_path,'') as photo_path,
						  isnull(cct.name,'') as category_name,
						  isnull(cbv1.brand_name,'') as brand_name,
						  isnull(cmv1.model,'') as model_name,
						  isnull(cc.vin,'') as vin,
						 -- isnull(cc.purchase_date,'') as purchase_date,
						 coalesce( convert( varchar(10), cc.purchase_date, 103 ), '') as purchase_date,
						  isnull(cc.is_default,0) as is_default,
						  isnull(convert(varchar(20), os.service_date, 101),'') as last_service,
						  case when os.service_date >= DATEADD(month, -6, GETDATE()) then 'Healthy'
							   when os.service_date < DATEADD(month, -6, GETDATE()) and os.service_date >= DATEADD(month, -24, GETDATE()) then 'Time for Service'
							   when os.service_date < DATEADD(month, -24, GETDATE()) then 'Needs Attention'
							   when os.service_date is null or os.service_date = '' then '----' end as health_description,
						  isnull([ride].[get_ride_log_time_by_cycle_id](cc.cycle_id,@owner_id),'00:00:00') as total_time,
						  case when oo.mobile is null or oo.mobile = '' then CAST(0 as bit) else CAST(1 as bit) end as mobile
					FROM cycle.cycle cc with (nolock,readuncommitted)
						  Left join cycle.brand_v1 cbv1 with (nolock,readuncommitted)
						  on cbv1.brand_id=cc.brand_id 
						  Left join cycle.model_v1 cmv1 with (nolock,readuncommitted)      
						  on cmv1.model_id= cc.model_id 
						  Left join cycle.category cct with (nolock,readuncommitted)
						  on cct.category_id= cc.category_id              
						  Left Join ride.ride_type rrt with (nolock,readuncommitted)
						  On rrt.ride_type_id =cc.riding_style_id
						  Left Join r2r_portal.portal.dealer pd with (nolock,readuncommitted)
						  on pd.dealer_id= cc.dealer_id  
						  left join cycle.year cy with (nolock,readuncommitted)
						  on cc.year=cy.year_id
						  left join owner_services as os with (nolock,readuncommitted)
						  on(os.cycle_id=cc.cycle_id)	
						   left join owner.owner oo with (nolock,readuncommitted)
						  on cc.owner_id = oo.owner_id 
						       
					 WHERE  
						 cc.owner_id = @owner_id 
						 and cc.is_deleted <> 1 
						 and cc.owner_id <> 0 
					)
					select 
							* 
					from 
						owner_cycles oc with (nolock,readuncommitted)
					order by 
						 isnull(oc.is_default,0) desc    
				END TRY
				BEGIN CATCH
				   ;WITH owner_services as 
				   (select
						ccs.cycle_id,
						max(ccs.service_date) as service_date
					from  
						cycle.cycle_service ccs with (nolock,readuncommitted)
						left join cycle.cycle cc  with (nolock,readuncommitted)
						on cc.cycle_id = ccs.cycle_id
						left join owner.owner oo with (nolock,readuncommitted)
						on oo.owner_id = cc.owner_id  
					 where 
							oo.owner_id = @owner_id
							and cc.is_deleted = 0
							and ccs.is_deleted = 0
					 group by
						ccs.cycle_id),

					owner_cycles as (

					select isnull(cc.model_id,0) as model_id,
						  isnull(cc.cycle_id,0) as cycle_id,
						  isnull(cc.owner_id,0) as owner_id,
						  isnull(cc.year,'') as year,
						  isnull(cc.name,'') as cycle_name,
						  isnull(cc.odometer_reading,0) as odometer_reading,
						  isnull(cc.photo,'') as photo,
						  isnull(cc.brand_id,0) as brand_id,
						  isnull(cc.photo_path,'') as photo_path,
						  isnull(cct.name,'') as category_name,
						  isnull(cbv1.brand_name,'') as brand_name,
						  isnull(cmv1.model,'') as model_name,
						  isnull(cc.vin,'') as vin,
						 -- isnull(cc.purchase_date,'') as purchase_date,
						  coalesce( convert( varchar(10), cc.purchase_date, 103 ), '') as purchase_date,
						  isnull(cc.is_default,0) as is_default,
						  isnull(convert(varchar(20), os.service_date, 101),'') as last_service,
						  case when os.service_date >= DATEADD(month, -6, GETDATE()) then 'Healthy'
							   when os.service_date < DATEADD(month, -6, GETDATE()) and os.service_date >= DATEADD(month, -24, GETDATE()) then 'Time for Service'
							   when os.service_date < DATEADD(month, -24, GETDATE()) then 'Needs Attention'
							   when os.service_date is null or os.service_date = '' then '----' end as health_description,
						  isnull([ride].[get_ride_time_from_seconds](@total_time),'00:00:00') as total_time,
						  case when oo.mobile is null or oo.mobile = '' then CAST(0 as bit) else CAST(1 as bit) end as mobile
					FROM cycle.cycle cc with (nolock,readuncommitted)
						  Left join cycle.brand_v1 cbv1 with (nolock,readuncommitted)
						  on cbv1.brand_id=cc.brand_id 
						  Left join cycle.model_v1 cmv1 with (nolock,readuncommitted)      
						  on cmv1.model_id= cc.model_id 
						  Left join cycle.category cct with (nolock,readuncommitted)
						  on cct.category_id= cc.category_id              
						  Left Join ride.ride_type rrt with (nolock,readuncommitted)
						  On rrt.ride_type_id =cc.riding_style_id
						  Left Join r2r_portal.portal.dealer pd with (nolock,readuncommitted)
						  on pd.dealer_id= cc.dealer_id  
						  left join cycle.year cy with (nolock,readuncommitted)
						  on cc.year=cy.year_id
						  left join owner_services as os with (nolock,readuncommitted)
						  on(os.cycle_id=cc.cycle_id)
						   left join owner.owner oo with (nolock,readuncommitted)
							on cc.owner_id = oo.owner_id	    
					 WHERE  
						 cc.owner_id = @owner_id 
						 and cc.is_deleted <> 1 
						 and cc.owner_id <> 0 
					)
					select 
							* 
					from 
						owner_cycles oc with (nolock,readuncommitted)
					order by 
						 isnull(oc.is_default,0) desc    
				END CATCH

			end  	                        
        
	 END
 
    SET NOCOUNT OFF

END
	 


GO
/****** Object:  StoredProcedure [cycle].[get_cycle_details_v1]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [cycle].[get_cycle_details_v1]
	@owner_id int = NULL,
	@cycle_id int = NULL
AS        
      
/*
	 exec  [cycle].[get_cycle_details_v1] 404923,6391
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get cycle service log
    
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
     
                  
		 if(@cycle_id <> 0 and @owner_id <> 0)                    
		    begin  
			
		   select isnull(cc.model_id,0) as model_id,
		          isnull(cc.cycle_id,0) as cycle_id,
				  isnull(cc.owner_id,0) as owner_id,
				  isnull(cc.year,'') as year,
				  isnull(cc.name,'') as cycle_name,
				  isnull(cc.last_service,'') as last_service,
				  isnull(cc.odometer_reading,0) as odometer_reading,
				  isnull(cc.photo,'') as photo,
				  isnull(cc.brand_id,0) as brand_id,
				  isnull(cc.photo_path,'') as photo_path,
				  isnull(cct.name,'') as category_name,
				  isnull(cbv1.brand_name,'') as brand_name,
				  isnull(cmv1.model,'') as model_name,
				  isnull(ch.description,'') as health_description,
				  isnull(cc.vin,'') as vin,
				  isnull(cc.purchase_date,'') as purchase_date
				  --,ride.get_ride_duration(rr.start_date,rr.end_date) as TotalTime

				  
			FROM cycle.cycle cc with (nolock,readuncommitted)
				  Left join cycle.brand_v1 cbv1 with (nolock,readuncommitted)
				  on cbv1.brand_id=cc.brand_id 
				  Left join cycle.model_v1 cmv1 with (nolock,readuncommitted)      
				  on cmv1.model_id= cc.model_id 
				  Left join cycle.category cct with (nolock,readuncommitted)
				  on cct.category_id= cc.category_id              
				  Left Join ride.ride_type rrt with (nolock,readuncommitted)
				  On rrt.ride_type_id =cc.riding_style_id
				  Left Join r2r_portal.portal.dealer pd with (nolock,readuncommitted)
				  on pd.dealer_id= cc.dealer_id  
				  left join cycle.year cy with (nolock,readuncommitted)
				  on cc.year=cy.year_id
				  left join r2r_admin.cycle.cycle_health as ch with (nolock,readuncommitted)
				  on(ch.cycle_id=cc.cycle_id)	
				  --left join dev_r2r_admin.ride.ride rr with (nolock,readuncommitted)
				  --on(rr.cycle_id = cc.cycle_id)
		     WHERE cc.cycle_id = @cycle_id and owner_id = @owner_id and cc.is_deleted <> 1 and cc.owner_id <>0         
		    
			end 
			
			                   
		 else if(@cycle_id = 0 and @owner_id <> 0)                     
		    begin                    
                
		   select isnull(cc.model_id,0) as model_id,
		          isnull(cc.cycle_id,0) as cycle_id,
				  isnull(cc.owner_id,0) as owner_id,
				  isnull(cc.year,'') as year,
				  isnull(cc.name,'') as cycle_name,
				  isnull(cc.last_service,'') as last_service,
				  isnull(cc.odometer_reading,0) as odometer_reading,
				  isnull(cc.photo,'') as photo,
				  isnull(cc.brand_id,0) as brand_id,
				  isnull(cc.photo_path,'') as photo_path,
				  isnull(cct.name,'') as category_name,
				  isnull(cbv1.brand_name,'') as brand_name,
				  isnull(cmv1.model,'') as model_name,
				  isnull(ch.description,'') as health_description,
				  isnull(cc.vin,'') as vin,
				  isnull(cc.purchase_date,'') as purchase_date
				   FROM cycle.cycle cc with (nolock,readuncommitted)
				  Left join cycle.brand_v1 cbv1 with (nolock,readuncommitted)
				  on cbv1.brand_id=cc.brand_id 
				  Left join cycle.model_v1 cmv1 with (nolock,readuncommitted)      
				  on cmv1.model_id= cc.model_id 
				  Left join cycle.category cct with (nolock,readuncommitted)
				  on cct.category_id= cc.category_id              
				  Left Join ride.ride_type rrt with (nolock,readuncommitted)
				  On rrt.ride_type_id =cc.riding_style_id
				  Left Join r2r_portal.portal.dealer pd with (nolock,readuncommitted)
				  on pd.dealer_id= cc.dealer_id  
				  left join cycle.year cy with (nolock,readuncommitted)
				  on cc.year=cy.year_id
				  left join r2r_admin.cycle.cycle_health as ch with (nolock,readuncommitted)
				  on(ch.cycle_id=cc.cycle_id)	                 
		     WHERE cc.owner_id = @owner_id  and cc.is_deleted <> 1 and cc.owner_id <>0
			end  
			                  
		 else if(@cycle_id <> 0 and @owner_id = 0)                     
		    begin                    
                   
		   select isnull(cc.model_id,0) as model_id,
		          isnull(cc.cycle_id,0) as cycle_id,
				  isnull(cc.owner_id,0) as owner_id,
				  isnull(cc.year,'') as year,
				  isnull(cc.name,'') as cycle_name,
				  isnull(cc.last_service,'') as last_service,
				  isnull(cc.odometer_reading,0) as odometer_reading,
				  isnull(cc.photo,'') as photo,
				  isnull(cc.brand_id,0) as brand_id,
				  isnull(cc.photo_path,'') as photo_path,
				  isnull(cct.name,'') as category_name,
				  isnull(cbv1.brand_name,'') as brand_name,
				  isnull(cmv1.model,'') as model_name,
				  isnull(ch.description,'') as health_description,
				  isnull(cc.vin,'') as vin,
				  isnull(cc.purchase_date,'') as purchase_date

				   FROM cycle.cycle cc with (nolock,readuncommitted)
				  Left join cycle.brand_v1 cbv1 with (nolock,readuncommitted)
				  on cbv1.brand_id=cc.brand_id 
				  Left join cycle.model_v1 cmv1 with (nolock,readuncommitted)      
				  on cmv1.model_id= cc.model_id 
				  Left join cycle.category cct with (nolock,readuncommitted)
				  on cct.category_id= cc.category_id              
				  Left Join ride.ride_type rrt with (nolock,readuncommitted)
				  On rrt.ride_type_id =cc.riding_style_id
				  Left Join r2r_portal.portal.dealer pd with (nolock,readuncommitted)
				  on pd.dealer_id= cc.dealer_id  
				  left join cycle.year cy with (nolock,readuncommitted)
				  on cc.year=cy.year_id
				  left join r2r_admin.cycle.cycle_health as ch with (nolock,readuncommitted)
				  on(ch.cycle_id=cc.cycle_id)	                 
		     WHERE cc.cycle_id = @cycle_id and cc.is_deleted <> 1 and cc.owner_id <>0               
		   
		    end  
			                  
	     else                    
		    begin                    
                   
		   select isnull(cc.model_id,0) as model_id,
		          isnull(cc.cycle_id,0) as cycle_id,
				  isnull(cc.owner_id,0) as owner_id,
				  isnull(cc.year,'') as year,
				  isnull(cc.name,'') as cycle_name,
				  isnull(cc.last_service,'') as last_service,
				  isnull(cc.odometer_reading,0) as odometer_reading,
				  isnull(cc.photo,'') as photo,
				  isnull(cc.brand_id,0) as brand_id,
				  isnull(cc.photo_path,'') as photo_path,
				  isnull(cct.name,'') as category_name,
				  isnull(cbv1.brand_name,'') as brand_name,
				  isnull(cmv1.model,'') as model_name,
				  isnull(ch.description,'') as health_description,
				  isnull(cc.vin,'') as vin,
				  isnull(cc.purchase_date,'') as purchase_date

				   FROM cycle.cycle cc with (nolock,readuncommitted)
				  Left join cycle.brand_v1 cbv1 with (nolock,readuncommitted)
				  on cbv1.brand_id=cc.brand_id 
				  Left join cycle.model_v1 cmv1 with (nolock,readuncommitted)      
				  on cmv1.model_id= cc.model_id 
				  Left join cycle.category cct with (nolock,readuncommitted)
				  on cct.category_id= cc.category_id              
				  Left Join ride.ride_type rrt with (nolock,readuncommitted)
				  On rrt.ride_type_id =cc.riding_style_id
				  Left Join r2r_portal.portal.dealer pd with (nolock,readuncommitted)
				  on pd.dealer_id= cc.dealer_id  
				  left join cycle.year cy with (nolock,readuncommitted)
				  on cc.year=cy.year_id
				  left join r2r_admin.cycle.cycle_health as ch with (nolock,readuncommitted)
				  on(ch.cycle_id=cc.cycle_id)	                 
		   where  cc.is_deleted <> 1 
                  
		    end       
        
	 END
 
    SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [cycle].[get_cycle_total_rides_time]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE procedure [cycle].[get_cycle_total_rides_time]
	@owner_id int = NULL,
	@cycle_id int = NULL
AS        
      
/*
	 exec  [cycle].[get_cycle_Total_Rides_Time] 829685,296004
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get cycle service log
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author         Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2018     satheesh raju    Created
	 -----------------------------------------------------------      
                   Copyright 2019 Ready2Ride Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

	 BEGIN
		  declare @total_time int
     
		   select  
				--@total_time = isnull(sum(ride.get_total_ride_time(start_date,end_date)),0)
				@total_time = isnull(sum(ride.get_ride_log_time(rr.ride_log)),0)
		   from 
				r2r_admin.ride.ride rr with(nolock,readuncommitted)
				left join r2r_admin.ride.ride_type as rrt with(nolock,readuncommitted)
				on rrt.ride_type_id = rr.ride_type_id 
		   where 
				 cycle_id = @cycle_id and 
				 owner_id = @owner_id and
				 rr.is_ride_saved = 1 and
				 rr.is_deleted = 0
		
		   select 
				 isnull(ride.get_ride_time_from_seconds(@total_time),'00:00:00') as total_rides_time
		   
		    
		END 
			
    SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [cycle].[get_cycle_total_rides_time_by_owner_id]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [cycle].[get_cycle_total_rides_time_by_owner_id]
	@owner_id int = NULL
	
AS        
      
/*
	 exec  [cycle].[get_cycle_total_rides_time_by_owner_id] 404923
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get cycle service log
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author         Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2018     satheesh raju    Created
	 -----------------------------------------------------------      
                   Copyright 2019 Ready2Ride Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

	 BEGIN
		   declare @total_time decimal(10,2) = 0
     
		   select  
				@total_time = abs(sum(isnull([ride].[get_ride_log_time](rr.ride_log),0)))
		   from 
			  ride.ride rr with (nolock,readuncommitted)
			  inner join ride.ride_type rrt with(nolock,readuncommitted)
			  on rrt.ride_type_id = rr.ride_type_id
			  inner join cycle.cycle cc with(nolock,readuncommitted)
			  on cc.cycle_id = rr.cycle_id
			  inner join owner.owner oo with(nolock,readuncommitted)
			  on cc.owner_id = oo.owner_id
		   where 
				 rr.owner_id = @owner_id and
				 rr.is_deleted = 0 and
				 rr.is_ride_saved = 1
		
		   select 
				 isnull([ride].[get_ride_time_from_seconds](@total_time),'00:00:00') as profile_total_rides_time
		   
		    
		END 
			
    SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [cycle].[get_owner_ride_details]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [cycle].[get_owner_ride_details]  
	@owner_id int = null
AS        
      
/*
	 exec  [cycle].[get_owner_ride_details]   404923
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Info By Event Id
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 10/16/2019     Dheeraj                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 

	SET NOCOUNT ON 

	SELECT  
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
		isnull(rr.start_location,'') as start_location,
		isnull(rr.end_location,'') as end_location,
		--isnull((([dbo].[get_distance_by_lat_long](rr.start_geo_lat,rr.start_geo_lon,rr.end_geo_lat,rr.end_geo_long)/1609.34)),0) as ride_distance,
		--isnull((select count(*) from r2r_admin.ride.ride(nolock)  where cycle_id = rr.cycle_id),0)as total_rides,
		isnull(rrt.name,'') as ride_type_name,
		isnull(rr.start_date,'') as start_date,
		isnull(rr.end_date,'') as end_date,
		ride.get_ride_duration(rr.start_date,rr.end_date) as duration,
		ride.get_ride_happend(rr.end_date) as ride_happend
	from
			r2r_admin.ride.ride rr with (nolock,readuncommitted)
			inner join r2r_admin.ride.ride_type rrt  with (nolock,readuncommitted) on
				rrt.ride_type_id = rr.ride_type_id
				inner join r2r_admin.cycle.cycle cc  with (nolock,readuncommitted) on
					cc.cycle_id = rr.cycle_id

	where  
		cc.owner_id = @owner_id and
		cc.is_deleted = 0 and 
		rr.is_deleted = 0 and
		rr.is_ride_saved = 1
order by 
		rr.ride_id  desc
		 
SET NOCOUNT OFF

	END
GO
/****** Object:  StoredProcedure [cycle].[get_ride_details_by_cycleid]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [cycle].[get_ride_details_by_cycleid]  
	  @cycle_id int = null,
	  @owner_id int = null
AS        
      
/*
	 exec  [cycle].[get_ride_details_by_cycleid]  296004,829685
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Info By Event Id
    
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

	declare @total_cycle_rides int = 0

	set @total_cycle_rides = ( select 
									count(ride_id) 
							   from 
									ride.ride with(nolock,readuncommitted)
							   where 
									owner_id = @owner_id 
									and cycle_id = @cycle_id 
									and is_ride_saved = 1 
									and is_deleted = 0 
							  )

	set @total_cycle_rides = isnull(@total_cycle_rides,0) 

	SELECT  
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
			isnull(rr.start_location,'') as start_location,
			isnull(rr.end_location,'') as end_location,
			isnull((([ride].[get_ride_distance](rr.ride_log))),0) as ride_distance,
			isnull(@total_cycle_rides,0) as total_rides,
			isnull(rrt.name,'') as ride_type_name,
			isnull(rr.start_date,'') as start_date,
			isnull(rr.end_date,'') as end_date,
			ride.get_ride_log_duration(rr.ride_log) as duration,
			ride.get_ride_happend(rr.end_date) as ride_happend
	from ride.ride rr with (nolock,readuncommitted)
		 left join ride.ride_type rrt  with (nolock,readuncommitted)
		 on rrt.ride_type_id = rr.ride_type_id
	where 
		 cycle_id = @cycle_id and 
		 owner_id = @owner_id and
		 rr.is_ride_saved = 1 and
		 rr.is_deleted = 0
	order by 
		 rr.ride_id  desc

	SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [cycle].[get_speed_details_by_ride_id]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [cycle].[get_speed_details_by_ride_id]

	 @ride_id int = null
	
	AS

/* 
	exec [cycle].[get_speed_details_by_ride_id] 10068
	-------------------------------------------------------------------------------------------      
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	-------------------------------------------------------------------------------------------     
    06/07/2019      Warrous       R2R MObile       Insert, update Ride
								     API                 
	-------------------------------------------------------------------------------------------
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 SET NOCOUNT ON;

	declare @ride_log nvarchar(max) = null

	set @ride_log = (select top 1 ride_log from ride.ride with(nolock,readuncommitted) where ride_id = @ride_id)

 IF(isnull(@ride_id,0) <> 0)
	 BEGIN

		;with cteRideLog
			as
			(
			SELECT *  
				FROM OPENJSON(@ride_log)  
				  WITH (
						speed decimal(10,2) '$.Speed',
						distance decimal(10,2) '$.Distance',  
						time decimal(10,2) '$.Time'
						)  
			) SELECT 
					--(case when isnull(sum(time),0) = 0 then 0.00
					--	else cast(cast(sum(distance) as float) / cast(sum(time) as float) as decimal(10,2)) end) as speed
					(case when isnull(count(speed),0) = 0 then 0.00
						else cast(cast(sum(speed) as float) / cast(count(speed) as float) as decimal(10,2)) end) as speed
			  from 
					cteRideLog 

	 END
 Else
	 BEGIN
		select 0 as speed
	 END

 
GO
/****** Object:  StoredProcedure [cycle].[insert_update_ride_details]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE procedure [cycle].[insert_update_ride_details]
	 @cycle_id int = null,
	 @owner_id int = null,  
	 @ride_name varchar(50) = null,
	 @ride_description varchar(100) = null,
	 @start_lat varchar (10) = null,
	 @start_long varchar (10) = null,
	 @end_lat varchar (10) = null,
	 @end_long varchar (10) = null,
	 @is_ride varchar(10) = null,
	 @ride_type_id int = null,
	 @ride_id int = null,
	 @odometer_reading int = null,
	 @is_ride_ended bit = 0,
	 @is_ride_saved bit = 0,
	 @ride_log nvarchar(max) = ''

	AS

/* 
	exec [cycle].[insert_update_ride_details] 91489,412998,'save_ride_i','','17.4893','78.3927','17.4893','78.3927','',1,4593,0,1,0,''
	-------------------------------------------------------------------------------------------      
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	-------------------------------------------------------------------------------------------     
    06/07/2019      Warrous       R2R MObile       Insert, update Ride
								     API                 
	-------------------------------------------------------------------------------------------
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 BEGIN
 SET NOCOUNT ON;


   declare @is_exists int;
   set @is_exists = (
						 select 
							 count(name)
						 from
							[ride].[ride] with(nolock,readuncommitted)
						 where
							 is_deleted = 0
							 and cycle_id = @cycle_id
							 and owner_id = @owner_id
							 and len(ltrim(rtrim(name))) > 0
							 and name = @ride_name
                   )
  set @is_exists = isnull(@is_exists,0);

IF(@is_exists = 0)
BEGIN

 IF(@odometer_reading is null)
	begin
		set @odometer_reading = 0
	end

 IF(@is_ride_ended is null)
	begin
		set @is_ride_ended = 0
	end

 IF(@is_ride_saved is null)
	begin
		set @is_ride_saved = 0
	end

 SET @ride_id = isnull(@ride_id,0)

 IF(@ride_id = 0)
	 BEGIN

		INSERT INTO [ride].[ride] 
		(
			owner_id,
			cycle_id,
			name,
			ride_type_id,
			description,
			start_geo_lat,
			start_geo_lon,
			is_ride,
			end_geo_lat,
			end_geo_long,
			start_date,
			is_ride_started,
			ride_log
		)
		VALUES
		(
			@owner_id,
			@cycle_id,
			@ride_name,
			@ride_type_id,
			@ride_description,
			@start_lat,
			@start_long,
			@is_ride,
			@end_lat,
			@end_long,
			getdate(),
			1,
			@ride_log
		)

		set @ride_id = SCOPE_IDENTITY()

		select top 1 
			ride_id, 
			created_dt 
		from 
			ride.ride with(nolock,readuncommitted) 
		where
			ride_id = @ride_id 

	 END
 ELSE IF(@ride_id > 0)
	 BEGIN 

		UPDATE 
			[ride].[ride]
		SET
			owner_id = @owner_id,
			cycle_id = @cycle_id,
			name = @ride_name,
			ride_type_id = @ride_type_id,
			description = @ride_description,
			start_geo_lat = @start_lat,
			start_geo_lon = @start_long,
			end_geo_lat = @end_lat,
			end_geo_long = @end_long,
			is_ride	= @is_ride,
			is_ride_ended = @is_ride_ended,
			is_ride_saved = @is_ride_saved,
			ride_log = case when @ride_log = '[]' or ltrim(rtrim(@ride_log)) = '' or @ride_log is null then ride_log else @ride_log end
		WHERE
			ride_id = @ride_id

		if(@is_ride_ended = 1)
		begin
			UPDATE 
				[ride].[ride]
			SET
				is_ride_ended = 1,
				end_date = getdate()
			WHERE
				ride_id = @ride_id
		end

		if(@is_ride_ended = 1 and @is_ride_saved = 0)
		begin
			UPDATE 
				[ride].[ride]
			SET
				is_ride_ended = 1,
				ride_log = @ride_log,
				end_date = getdate()
			WHERE
				ride_id = @ride_id
		end
			  
		select 
			top 1 ride_id,
			updated_dt as created_dt 
		from 
			ride.ride with(nolock,readuncommitted) 
		where 
			ride_id = @ride_id 

	 END
 ELSE 
	 BEGIN  
		select top 1 
			ride_id, 
			created_dt 
		from 
			ride.ride with(nolock,readuncommitted) 
		where
			ride_id = @ride_id
	 END 
END

 SET NOCOUNT OFF
 END;
GO
/****** Object:  StoredProcedure [cycle].[save_cycle_new]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [cycle].[save_cycle_new]
	 @cycle_id int = 0,
	 @owner_id int = null,    
	 @model_id int = null,
	 @make_id int = null,
	 @year varchar(MAX) = null,
	 @purchase_date date = null,
	 @image varchar(MAX) = null,
	 @name varchar(100) = null,
	 @odometer_reading int = null,
	 @vin varchar(100) = null,
	 @is_default bit = 0
	AS

/* 
	exec [cycle].[save_cycle_new] 
	--------------------------------------------------------------       
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
    05/10/2019      Warrous                            Created 
	-------------------------------------------------------------- 
	               Copyright 2017 Warrous Pvt Ltd   
*/ 

 /* Setup */ 
 SET NOCOUNT ON;
 
    declare @count int;
    set @count = (
				   select 
					  count(owner_id)
				   from
					  [cycle].[cycle] with(nolock,readuncommitted)
				   where 
					 is_deleted = 0 
					 and owner_id = @owner_id
			     )

    if(@count = 0)
begin
    set @is_default = 1
end
 
 BEGIN

 if(isnull(@cycle_id,0) = 0)

	Begin

			INSERT INTO [cycle].[cycle] 
			(
				 owner_id,
				 model_id,
				 brand_id,
				 year,
				 purchase_date,
				 photo_path,
				 name,
				 odometer_reading,
				 vin,
				 is_default
			)
			VALUES
			(
				@owner_id,    
				@model_id,
				@make_id,
				@year,
				@purchase_date,
				@image,
				@name,
				@odometer_reading,
				@vin,
				@is_default
			)

			set @cycle_id = SCOPE_IDENTITY()
	End

 else

	Begin
		Update 
			 [cycle].[cycle] 
		Set
			owner_id = @owner_id,
			model_id = @model_id,
			brand_id = @make_id,
			year = @year,
			purchase_date = @purchase_date,
			photo_path = @image,
			name = @name,
			odometer_reading = @odometer_reading,
			vin = @vin,
			is_default = @is_default
		Where 
			cycle_id = @cycle_id and
			is_deleted = 0
	End

	if(isnull(@is_default,0) = 1)
		begin
			update 
				  cycle.cycle 
			set 
				is_default = 0 
			where 
				owner_id = @owner_id 
				and cycle_id not in (@cycle_id)
		end

 SET NOCOUNT OFF
 END
 
    
GO
/****** Object:  StoredProcedure [cycle].[update_cycle_odometer]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [cycle].[update_cycle_odometer]
      
    @cycle_id int,    
    @odometer_reading int
AS        
      
/*
	 exec  [cycle].[update_cycle_odometer]
	 ------------------------------------------------------------         
	 PURPOSE        
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 09/09/2018     Ready2Ride                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 Ready2Ride Pvt Ltd
*/        
BEGIN 

	 set @odometer_reading = isnull(@odometer_reading,0)

	 if(@odometer_reading > 100000)
		begin
			set @odometer_reading = 100000
		end

	 update 
		 cycle.cycle 
	 set 
		 odometer_reading = @odometer_reading 
	 where 
		 cycle_id = @cycle_id         

END
	 


GO
/****** Object:  StoredProcedure [dbo].[save_deep_link]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[save_deep_link]
	@deep_link nvarchar(max)
	AS
	

/*
	EXEC [dbo].[save_deep_link] 
	--------------------------------------------------------------       
    MODIFICATIONS       
	Date			Author	    Work Tracker Id    Description         
	--------------------------------------------------------------       
    02/14/2019                                     Save Deep link
	-------------------------------------------------------------- 
	               Copyright 2019 Ironhorse Funding 
*/ 

 /* Setup */ 
 SET NOCOUNT ON;

       insert into
	         [dbo].[deep_link]
			   (
			     deep_link
			   )
			   values
			   (
			     @deep_link
			   )
 

 SET NOCOUNT off
GO
/****** Object:  StoredProcedure [event].[delete_promotion]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[delete_promotion]  
       @promotion_id int ,    
       @owner_id int   
AS        
      
/*
	 exec  [event].[delete_promotion] 3
	 ------------------------------------------------------------         
	 PURPOSE        
	 Delete Promotion
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 11/1/2017     PowerSports                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 PowerSports Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

	Insert INTO event.promotion_delete(promotion_id,owner_id,status,date) values(@promotion_id,@owner_id,'D',GETDATE())  

	select @owner_id as owner_id
       
SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [event].[get_all_events_promotions]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[get_all_events_promotions]  

	@dealer_id int null


AS        
      
/*
	 exec  [event].[get_all_events_promotions]  4035
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Date

	 select * from event.events where is_deleted = 0

	 select * from event.promotions where is_deleted = 0
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     siva                           Created
	 1/14/2020      ravi                           need to change in respective sp's in [event].[get_owner_events],[event].[get_owner_promotions]
	-----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 
	
	SELECT distinct
		isnull(ev.event_id ,0)as id,
		ev.dealer_id as dealer_id,
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
		'' as promo_code,
		cast(isnull(nullif(ltrim(rtrim(ev.lattitude)),''),0) as decimal(9,6)) as latitude,
		cast(isnull(nullif(ltrim(rtrim(ev.longitude)),''),0) as decimal(9,6)) as longitude,
		ev.end_latitude,
		ev.end_longitude,
		isnull(footer_description,'') as footer_description,
		isnull(event_image_path,'') as image,
		isnull(link_url,'') as url,
		isnull(google_map_url,'') as google_map_url,
		ev.created_dt,
		isnull(evt.event_type_name,'EVENTS') as event_type,
		'' as promotion_type,
		'Event' as type

	FROM 
		event.events ev WITH(NOLOCK,readuncommitted)
		--left join event.event_type evt with(nolock,readuncommitted)
		inner join event.event_type evt with(nolock,readuncommitted)
		on ev.event_type_id = evt.event_type_id and evt.is_deleted = 0

	WHERE
		ev.is_deleted = 0 
		and ev.dealer_id = @dealer_id
		and (ev.is_active = 1 or ev.is_publish = 1)
		and isnull(ev.is_template, 0) = 0 
		and isnull(is_archived,0) = 0
		and ev.event_type_id not in (2,3)
		--and ev.start_date <=  GETDATE() 
		and ev.exp_date >= GETDATE()

 UNION 

	SELECT distinct
		isnull(ep.promotion_id,0) as id,
		ep.dealer_id as dealer_id,
		isnull(ep.promotion_name,'') as name,
		isnull(ep.title,'') as title,
		isnull(ep.description,'') as description,
		ep.start_date,
		ep.end_date as exp_date,
		'' as start_time,
		'' as end_time,
		'' as address,
		'' as city,
		'' as zip_code,
		'' as state,
		isnull(ep.promo_code,'') as promo_code,
		isnull(ep.latitude,0) as latitude,
		isnull(ep.longitude,0) as longitude,
		0 as end_latitude,
		0 as end_longitude,
		isnull(footer_description,'') as footer_description,
		isnull(promotion_image_path,'') as image,
		isnull(promo_url,'') as url,
		'' as google_map_url,
		ep.created_dt,
		'' as event_type,
		isnull(promotion_type_name,'PROMOTIONS') as promotion_type,
		'Promotion' as type

	FROM 
		event.promotions ep WITH(NOLOCK,readuncommitted)
		left join event.promotion_type ept with(nolock,readuncommitted)
	   -- inner join event.promotion_type ept with(nolock,readuncommitted)
		on ep.promotion_type_id = ept.promotion_type_id and ept.is_deleted = 0

	WHERE
		ep.is_deleted = 0 
		and isnull(ep.is_template, 0) = 0 
		and ep.dealer_id = @dealer_id
		and (ep.start_date <= GETDATE () and ep.end_date >= GETDATE () and ep.status_id not in(1,5))
		-- and isnull(is_archived,0) = 0
	--	 and (ep.is_fulfilled = 1 or ep.is_publish = 1)
	ORDER BY 
			start_date asc--created_dt DESC

	SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [event].[get_attendeing_events]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[get_attendeing_events]  

	@owner_id int


AS        
      
/*
	 exec  [event].[get_attendeing_events] 456020
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Date

	 select * from event.events where is_deleted = 0

	 select * from event.promotions where is_deleted = 0
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     siva                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

	
	SELECT distinct
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
		ev.end_latitude,
		ev.end_longitude,
		isnull(footer_description,'') as footer_description,
		isnull(event_image_path,'') as image,
		isnull(link_url,'') as link_url,
		isnull(oe.is_attending,0) as is_attending,
		isnull(link_url,'') as link_url,
		isnull(google_map_url,'') as google_map_url,
		ev.created_dt,
		isnull(evt.event_type_name,'EVENTS') as event_type,
		'Event' as type

	FROM 
		owner.owner_events oe WITH(NOLOCK,readuncommitted)
		inner join event.events ev WITH(NOLOCK,readuncommitted)
		on ev.event_id = oe.event_id
		left join event.event_type evt WITH(NOLOCK,readuncommitted)
		on ev.event_type_id = evt.event_type_id

	WHERE
		ev.is_deleted = 0 
		and evt.is_deleted = 0  
		and oe.owner_id = @owner_id
		and oe.is_attending = 1
		and oe.is_deleted = 0 
	ORDER BY
		ev.created_dt desc

	SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [event].[get_dealer_events]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[get_dealer_events]  

	@dealer_id int null


AS        
      
/*
	 exec  [event].[get_dealer_events]   4035
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Date

	 select * from event.events where is_deleted = 0

	 select * from event.promotions where is_deleted = 0
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     siva                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 
	
	SELECT 
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

	WHERE
		ev.is_deleted = 0 
		and ev.dealer_id = @dealer_id
		and ev.is_publish = 1 
		and ev.exp_date > = GETDATE()
	ORDER BY
		ev.event_id desc


	SET NOCOUNT OFF

	END

GO
/****** Object:  StoredProcedure [event].[get_dealer_promotions]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[get_dealer_promotions]  

	@dealer_id int null


AS        
      
/*
	 exec  [event].[get_dealer_promotions]  4035
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Date

	 select * from event.events where is_deleted = 0

	 select * from event.promotions where is_deleted = 0
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     siva                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

	SELECT
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

	WHERE
		ep.is_deleted = 0 
		and ep.dealer_id = @dealer_id
		and (ep.start_date>=GETDATE () and ep.end_date>=GETDATE () and ep.status_id not in(1,5))
	ORDER BY
		ep.promotion_id desc

	SET NOCOUNT OFF

	END

GO
/****** Object:  StoredProcedure [event].[get_event_by_event_id]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [event].[get_event_by_event_id]  

	@owner_id int,
	@event_id int 


AS        
      
/*
	 exec  [event].[get_event_by_event_id]  404923, 1099
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Event
     select * from event.events
	 update event.events set exp_date = getdate() + 1 where event_id = 1099
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     siva                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 

	SELECT top 1
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
		ev.end_latitude,
		ev.end_longitude,
		isnull(footer_description,'') as footer_description,
		isnull(event_image_path,'') as image,
		isnull(ooe.is_attending,0) as is_attending,
		isnull(link_url,'') as link_url,
		isnull(google_map_url,'') as google_map_url,
		ev.created_dt,
		isnull(evt.event_type_name,'EVENTS') as event_type,
		'Event' as type

	FROM 
		event.events ev with(nolock,readuncommitted)
		left join owner.owner_events ooe with(nolock,readuncommitted)
		on ev.event_id = ooe.event_id and ooe.owner_id = @owner_id and ooe.is_deleted = 0
		left join event.event_type evt WITH(NOLOCK,readuncommitted)
		on ev.event_type_id = evt.event_type_id

	WHERE
		ev.is_deleted = 0
		and evt.is_deleted = 0  
		and ev.event_id = @event_id

	END

GO
/****** Object:  StoredProcedure [event].[get_events_by_event_type]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[get_events_by_event_type]  

	@owner_id int,
	@event_type varchar(100)


AS        
      
/*
	 exec  [event].[get_events_by_event_type]  896437,'SPONSORED ROUTES'
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Data
	     
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     Mohan                           Created
	 -----------------------------------------------------------      
                   Copyright 2019 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

	declare @event_type_id int
	declare @dealer_id int

	set @event_type = ltrim(rtrim(@event_type))

	set @event_type_id = ( select 
							  top 1 event_type_id
						   from 
								event.event_type with(nolock,readuncommitted)
							where
								event_type_name = @event_type
								and is_deleted = 0
						  )

	set @dealer_id = (  select 
							top 1 dealer_id
						from 
							owner.owner with(nolock,readuncommitted)
						where
							owner_id = @owner_id
					 )
	
    ;WITH owner_events
	AS
	(
		select 
			ev.event_id
		from 
			event.events ev with(nolock, readuncommitted)
		where
			ev.dealer_id = @dealer_id
			and ev.is_deleted = 0
	union
		select 
			ev.event_id
		from 
			event.events ev with(nolock, readuncommitted)
			inner join [owner].[owner_dealers] ood with(nolock,readuncommitted)
			on ev.dealer_id = ood.dealer_id
		where
			ood.owner_id = @owner_id
			and ev.is_deleted = 0
			and ood.is_deleted = 0
	)
	select 
		isnull(ev.event_id ,0) as event_id,
		ev.dealer_id,
		isnull(ev.event_name,'') as name,
		isnull(ev.event_title,'') as title,
		isnull(ev.event_description,'') as description,
  	    convert(varchar(10), cast(ev.start_date as date), 101) as start_date,
		convert(varchar(10), cast(ev.exp_date as date), 101) as exp_date,
		isnull(ev.start_time,'12:00 AM') as start_time,
		isnull(ev.end_time,'12:00 PM') as end_time,
		isnull(ev.street,'') as address,
		isnull(ev.city,'') as city,
		isnull(ev.zip_code,'') as zip_code,
		isnull(ev.state,'') as state,
		'' as promo_code,
		cast(isnull(nullif(ltrim(rtrim(ev.lattitude)),''),0) as decimal(9,6)) as latitude,
		cast(isnull(nullif(ltrim(rtrim(ev.longitude)),''),0) as decimal(9,6)) as longitude,
		ev.end_latitude,
		ev.end_longitude,
		isnull(footer_description,'') as footer_description,
		isnull(event_image_path,'') as image,
		isnull(link_url,'') as link_url,
		isnull(google_map_url,'') as google_map_url,
		ev.created_dt,
		isnull(evt.event_type_name,'EVENTS') as event_type,
		0 as is_attending,
		'Event' as type
	from 
		event.events ev WITH(NOLOCK,readuncommitted)
		inner join owner_events oe with(nolock,readuncommitted)
		on ev.event_id = oe.event_id
		inner join event.event_type evt with(nolock,readuncommitted)
		on ev.event_type_id = evt.event_type_id 
	where
		ev.is_deleted = 0 
		and (ev.is_active = 1 or ev.is_publish = 1)
		and isnull(ev.is_template, 0) = 0 
		and isnull(is_archived,0) = 0
		and ev.exp_date >= GETDATE()
		and evt.event_type_id = @event_type_id
		and evt.is_deleted = 0
	ORDER BY
		ev.event_id desc

	SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [event].[get_owner_events]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[get_owner_events]  

	@owner_id int,
	@dealer_id int


AS        
      
/*
	 exec  [event].[get_owner_events]  456020,4035
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Date

	 select * from event.events where is_deleted = 0

	 select * from event.promotions where is_deleted = 0
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     siva                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON
	
	set @dealer_id = isnull(@dealer_id,0)

		;WITH owner_events as 
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
			ev.end_latitude,
			ev.end_longitude,
			isnull(footer_description,'') as footer_description,
			isnull(event_image_path,'') as image,
			isnull(link_url,'') as url,
			isnull(google_map_url,'') as google_map_url,
			ev.created_dt,
			isnull(evt.event_type_name,'EVENTS') as event_type,
			'Event' as type

		FROM 
			event.events ev with(nolock,readuncommitted)
			left join event.event_type evt with(nolock,readuncommitted)
			on ev.event_type_id = evt.event_type_id 

		WHERE
			ev.is_deleted = 0 
			and ev.dealer_id = @dealer_id
			and (ev.is_active = 1 or ev.is_publish = 1)
			and isnull(ev.is_template, 0) = 0 
			and isnull(is_archived,0) = 0
			and ev.event_type_id not in (2,3)
			--and ev.start_date <=  GETDATE() 
			and ev.exp_date >= GETDATE()
		)
		select * from owner_events order by start_date asc --id desc

	SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [event].[get_owner_events_promotions]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[get_owner_events_promotions]  

	@owner_id int,
	@dealer_id int = null


AS        
      
/*
	 exec  [event].[get_owner_events_promotions]  456020,2961
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Date

	 select * from event.events where is_deleted = 0

	 select * from event.promotions where is_deleted = 0
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     siva                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 

	If(isnull(@dealer_id,0) = 0)
		Begin
			
			select top 1 @dealer_id = dealer_id from owner.owner oo with(nolock,readuncommitted) where oo.is_deleted = 0 and oo.owner_id = @owner_id

		End
  
	SET NOCOUNT ON 
	
	SELECT
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
		'' as promo_code,
		isnull(nullif(ltrim(rtrim(ev.lattitude)),''),0) as latitude,
		isnull(nullif(ltrim(rtrim(ev.longitude)),''),0) as longitude,
		isnull(footer_description,'') as footer_description,
		isnull(event_image_path,'') as image,
		'Event' as type,
		0 as is_redeemed,
		isnull(ooe.is_attending,0) as is_attending

	FROM 
		event.events ev with(nolock,readuncommitted)
		left join owner.owner_events ooe with(nolock,readuncommitted)
		on ev.event_id = ooe.event_id and ooe.is_deleted = 0 and isnull(ooe.is_attending,0) = 0 and ooe.owner_id = @owner_id

	WHERE
		ev.is_deleted = 0 and 
		ev.dealer_id = @dealer_id and
		ev.start_date is not null and
		ev.exp_date is not null
		and (ev.is_active = 1 or ev.is_publish = 1)
		and isnull(ev.is_template, 0) = 0 
		and DATEADD(day, DATEDIFF(day, 0, ev.start_date), ev.start_time) <= GETDATE()
		and DATEADD(day, DATEDIFF(day, 0, ev.exp_date), ev.end_time) >= GETDATE()

 UNION 

	SELECT
		isnull(ep.promotion_id,0) as id,
		isnull(ep.promotion_name,'') as name,
		isnull(ep.title,'') as title,
		isnull(ep.description,'') as description,
		ep.start_date,
		ep.end_date as exp_date,
		'' as start_time,
		'' as end_time,
		'' as address,
		'' as city,
		'' as zip_code,
		'' as state,
		isnull(ep.promo_code,'') as promo_code,
		isnull(ep.latitude,0) as latitude,
		isnull(ep.longitude,0) as longitude,
		isnull(footer_description,'') as footer_description,
		isnull(promotion_image_path,'') as image,
		'Promotion' as type,
		isnull(oop.is_redeemed,0) as is_redeemed,
		0 as is_attending

	FROM 
		event.promotions ep WITH(NOLOCK,readuncommitted)
		left join owner.owner_promotions oop with(nolock,readuncommitted)
		on ep.promotion_id = oop.promotion_id and oop.is_deleted = 0 and isnull(oop.is_saved,0) = 0 and oop.owner_id = @owner_id
	WHERE
		ep.is_deleted = 0 and 
		ep.dealer_id = @dealer_id and
		ep.start_date is not null and
		ep.end_date is not null
		and isnull(ep.is_publish,0) = 1
		and isnull(ep.is_template, 0) = 0 
		and ep.start_date <= GETDATE()
		and ep.end_date >= GETDATE()
	Order By
		start_date asc

	SET NOCOUNT OFF

	END

GO
/****** Object:  StoredProcedure [event].[get_owner_promotions]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[get_owner_promotions]
  
	@owner_id int,
	@dealer_id int


AS        
      
/*
	 exec  [event].[get_owner_promotions] 404923,4035
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Date

	 select * from event.events where is_deleted = 0

	 select * from event.promotions where is_deleted = 0
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     siva                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON
	
		 set @dealer_id = isnull(@dealer_id,0) 

		;WITH owner_promotions as 
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
			isnull(promo_url,'') as promo_url,
			isnull(promotion_type_name,'PROMOTIONS') as promotion_type,
			'Promotion' as type

		FROM 
			event.promotions ep WITH(NOLOCK,readuncommitted)
			left join event.promotion_type ept with(nolock,readuncommitted)
			on ep.promotion_type_id = ept.promotion_type_id and ept.is_deleted = 0

		WHERE
			ep.is_deleted = 0 
			and isnull(ep.is_template, 0) = 0 
			and ep.dealer_id = @dealer_id
			and (ep.start_date <= GETDATE () and ep.end_date >= GETDATE () and ep.status_id not in(1,5))
		)
		select * from owner_promotions order by id desc 

	SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [event].[get_point_of_interest_events]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[get_point_of_interest_events]

        @latitude decimal(9,6) = null,
        @longitude decimal(9,6) = null 


AS        
      
/*
         exec  [event].[get_point_of_interest_events] 17.4377, 78.3880
         ------------------------------------------------------------         
         PURPOSE        
         Get Events Date

         select * from event.events where is_deleted = 0

         select * from event.promotions where is_deleted = 0
    
         PROCESSES        
    
         MODIFICATIONS        
         Date           Author     Work Tracker Id     Description          
         -----------------------------------------------------------        
         04/29/2019     siva                           Created
         -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
        SET NOCOUNT ON 
        
        ;with nearby_events as
        (
        SELECT 
                isnull(ev.event_id ,0)as id,
                isnull(ev.event_name,'') as name,
                isnull(ev.event_title,'') as title,
                isnull(ev.event_description,'') as description,
                ev.start_date,
                ev.exp_date,
                isnull(ev.start_time,'12:00 AM') as start_time,
                isnull(ev.end_time,'11:59 PM') as end_time,
                isnull(ev.street,'') as address,
                isnull(ev.city,'') as city,
                isnull(ev.zip_code,'') as zip_code,
                isnull(ev.state,'') as state,
                isnull(lattitude,0) as latitude,
                isnull(longitude,0) as longitude,
                isnull(footer_description,'') as footer_description,
                isnull(event_image_path,'') as image,
                'Event' as type,
                isnull(([dbo].[get_distance_by_lat_long](@latitude,@longitude,lattitude,longitude) / 1609.344), 0) as distance

        FROM 
                event.events ev WITH(NOLOCK,readuncommitted)

        WHERE
                ev.is_deleted = 0 and
                DATALENGTH(lattitude) > 0 and
                DATALENGTH(longitude) > 0
   )
   select *, ceiling(distance * 300) as duration from nearby_events where distance <= 10 order by distance asc

        SET NOCOUNT OFF

        END

GO
/****** Object:  StoredProcedure [event].[get_point_of_interest_promotions]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[get_point_of_interest_promotions]

        @latitude decimal(9,6) = null,
        @longitude decimal(9,6) = null 


AS        
      
/*
         exec  [event].[get_point_of_interest_promotions] 17.4369, 78.3937
         ------------------------------------------------------------         
         PURPOSE        
         Get Events Date

         select * from event.events where is_deleted = 0

         select * from event.promotions where is_deleted = 0
    
         PROCESSES        
    
         MODIFICATIONS        
         Date           Author     Work Tracker Id     Description          
         -----------------------------------------------------------        
         04/29/2019     Dheeraj                           Created
         -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
        SET NOCOUNT ON 
        ;WITH nearby_promotions AS
        (
        SELECT
                isnull(ep.promotion_id,0) as id,
                isnull(ep.promotion_name,'') as name,
                isnull(ep.title,'') as title,
                isnull(ep.description,'') as description,
                ep.start_date,
                ep.end_date as exp_date,
                isnull(ep.promo_code,'') as promo_code,
                ep.latitude,
                ep.longitude,
                isnull(footer_description,'') as footer_description,
                isnull(promotion_image_path,'') as image,
                isnull(([dbo].[get_distance_by_lat_long](@latitude,@longitude,ep.latitude,ep.longitude) / 1609.344),0) as distance,
                'Promotion' as type

        FROM 
                event.promotions ep WITH(NOLOCK,readuncommitted)

        WHERE
                ep.is_deleted = 0 and
                DATALENGTH( latitude ) > 0 and
                DATALENGTH( longitude ) > 0 
                )
                select *, ceiling(distance * 300) as duration from nearby_promotions where distance <= 10 order by distance asc

        SET NOCOUNT OFF

        END

GO
/****** Object:  StoredProcedure [event].[get_promotion_by_promotion_id]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[get_promotion_by_promotion_id]
  
	@owner_id int,
	@promotion_id int 


AS        
      
/*
	 exec  [event].[get_promotion_by_promotion_id] 406269, 8818
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Promotion

	 select * from owner.owner_promotions where is_deleted = 0
	 update event.promotions set promotion_type_id = 4,exp_date = getdate() + 100 where promotion_id = 8818
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     siva                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	SELECT top 1
		isnull(ep.promotion_id,0) as id,
		isnull(ep.promotion_name,'') as name,
		isnull(ep.title,'') as title,
		isnull(ep.description,'') as description,
		ep.start_date,
		ep.end_date as exp_date,
		isnull(ep.promo_code,'') as promo_code,
		ep.latitude as latitude,
		ep.longitude as longitude,
		isnull(footer_description,'') as footer_description,
		isnull(promotion_image_path,'') as image,
		isnull(oop.is_redeemed,0) as is_redeemed,
		isnull(promo_url,'') as promo_url,
		case when isnull(oop.owner_promotion_id,0) > 0 then 1 
			 else 0 end as is_saved_to_wallet,
		isnull(promotion_type_name,'PROMOTIONS') as promotion_type,
		'Promotion' as type

	FROM 
		event.promotions ep WITH(NOLOCK,readuncommitted)
		left join owner.owner_promotions oop WITH(NOLOCK,readuncommitted)
		on ep.promotion_id = oop.promotion_id and oop.owner_id = @owner_id and oop.is_deleted = 0
		left join event.promotion_type ept with(nolock,readuncommitted)
		on ep.promotion_type_id = ept.promotion_type_id and ept.is_deleted = 0

	WHERE
		ep.is_deleted = 0  
		and ep.promotion_id = @promotion_id
		--and isnull(ep.is_template, 0) = 0 
		--and (ep.start_date <= GETDATE() 
		--and ep.end_date >= GETDATE() 
		--and ep.status_id not in(1,5))
		--and isnull(ep.is_archived,0) = 0


	END

GO
/****** Object:  StoredProcedure [event].[get_promotion_list]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[get_promotion_list]  

		@owner_id int,        
		@dealer_id int = NULL  
   
AS        
      
/*
	 exec [event].[get_promotion_list] 2,2936
	 ------------------------------------------------------------         
	 PURPOSE   
	 Get Promotion List     
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker id     description          
	 -----------------------------------------------------------        
	 09/09/2017     PowerSports                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 PowerSports Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

IF(@owner_id <> 0 and @dealer_id <> 0)            
BEGIN            
	SELECT 
	promotion_id,
	title,
	description,
	promo_code,
	created_dt,
	exp_date,
	type,
	footer_description,
	promotion_image_path,
	is_read,
	is_publish            
	from 
	event.promotions 
	where 
	promotion_id not in
	(
		select 
		promotion_id 
		from event.promotion_delete
		where owner_id=@owner_id 
		and Status='D'
	) 
	and is_publish=1 
	and dealer_id=@dealer_id  
	and  cast(exp_date as date) >= cast(getdate() as date)   
	ORDER BY promotion_id DESC              
END            
ELSE            
BEGIN            
	SELECT 
	promotion_id,
	title,
	description,
	promo_code,
	created_dt,
	exp_date,
	type,
	footer_description,
	promotion_image_path,
	is_read,
	is_publish           
	from 
	event.promotions  
	where cast(exp_date as date) >= cast(getdate() as date)  
	ORDER BY promotion_id DESC                
END    
	
SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [event].[get_saved_promotions]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[get_saved_promotions]  

	@owner_id int null


AS        
      
/*
	 exec  [event].[get_saved_promotions]  412073
	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Events Date

	 select * from event.events where is_deleted = 0

	 select * from event.promotions where is_deleted = 0
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 04/29/2019     siva                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 

	SELECT distinct
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
		isnull(promo_url,'') as promo_url,
		isnull(promotion_type_name,'PROMOTIONS') as promotion_type,
		ep.created_dt,
		'Promotion' as type

	FROM 
		event.promotions ep WITH(NOLOCK,readuncommitted)
		inner join owner.owner_promotions op
		on ep.promotion_id = op.promotion_id
		inner join owner.owner oo WITH(NOLOCK,readuncommitted)
		on oo.owner_id = op.owner_id
		left join event.promotion_type ept with(nolock,readuncommitted)
		on ep.promotion_type_id = ept.promotion_type_id and ept.is_deleted = 0
		
	WHERE
		ep.is_deleted = 0 and 
		oo.owner_id = @owner_id
		and op.is_saved = 1
		and op.is_deleted = 0
		and oo.is_deleted = 0
	ORDER BY
		ep.created_dt desc
 

	SET NOCOUNT OFF

	END

GO
/****** Object:  StoredProcedure [event].[mark_is_read_special]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[mark_is_read_special]  
  @dealer_id int=NULL, 
  @owner_id int=NULL  
AS        
      
/*
	 exec  [event].[mark_is_read_special]
	 ------------------------------------------------------------         
	 PURPOSE        
	 Mark Is Read Special
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 11/1/2018     PowerSports                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 PowerSports Pvt Ltd
*/        
BEGIN 
  
SET NOCOUNT ON 

	if(@owner_id <> 0)          
	begin    
		Insert INTO event.promotion_delete
		(promotion_id,owner_id,status,date)  
		SELECT 
		promotions.promotion_id,
		@owner_id,
		'R', 
		getdate() 
		from 
		event.promotions promotions
		where 
		promotions.is_publish=1     
		and promotions.promotion_id not in 
		(Select promotion_id from promotion_delete where status = 'R' and owner_id=@owner_id and dealer_id=@dealer_id )     
	end   

	select @owner_id as owner_id
       
SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [event].[update_promotion]    Script Date: 1/25/2022 4:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [event].[update_promotion]  
	@promotion_id int = null
AS        
      
/*
	 exec  [event].[update_promotion]
	 ------------------------------------------------------------         
	 PURPOSE        
	 Update Promotion
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 11/1/2017     PowerSports                           Created
	 -----------------------------------------------------------      
                   Copyright 2018 PowerSports Pvt Ltd
*/        
BEGIN 
  
	SET NOCOUNT ON 
		IF(@promotion_id IS NOT NULL AND @Promotion_id <> 0)  
	       
		   BEGIN  
				
				UPDATE 
				      event.promotions 
				SET 
				      is_read=1
			    WHERE 
				      promotion_id=@promotion_id   
		  
		   End

				select @promotion_id as promotion_id
       
	SET NOCOUNT OFF

END

GO

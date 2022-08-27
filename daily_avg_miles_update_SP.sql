USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [master].[estimated_mileage_update]    Script Date: 11/26/2021 11:22:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--ALTER procedure [master].[estimated_mileage_update]  
  declare
 @file_process_id int   
--as            
/*     
       -----------------------------------------         
       Copyright 2021 Clictell 
         
       PURPOSE  
         
       Calucualting Avg Daily Miles
  
       MODIFICATIONS        
       Date          Author							Description          
       ---------------------------------------------------------        
       06/09/2021    Santhosh B		Created			Calucualting Avg Daily Miles
       ---------------------------------------------------------       

       exec [master].[move_estimated_mileage_calculation] 1  

*/     
Begin  

DROP TABLE IF EXISTS #master_customer	
DROP TABLE IF EXISTS #master_cust_2_vehicle	
DROP TABLE IF EXISTS #pending_vins
DROP TABLE IF EXISTS #min_max_ros
DROP TABLE IF EXISTS #sale_ros
DROP TABLE IF EXISTS #sale_records
DROP TABLE IF EXISTS #service_records
DROP TABLE IF EXISTS #no_service_records
/**  declare variables **/  
  
	/*** Get Pending vins for ADM & LEM Calculation ***/  
    
	--Declare @file_process_id int
	declare @dealer_id int = 3407
	select * into #master_customer from master.customer (nolock) where parent_dealer_id = @dealer_id
	select * into #master_cust_2_vehicle from master.cust_2_vehicle (nolock) where parent_dealer_id  = @dealer_id

	select   
		c2v.parent_dealer_id,  
		c2v.natural_key,  
		c2v.master_customer_id,  
		vin,  
		last_sale_mileage,  
		last_ro_mileage as last_visit_mileage,  
		daily_average_mile,  
		last_estimated_mileage,  
		cast(cast(last_sale_date as varchar(15))as date) as last_sale_date,  
		cast(cast(last_activity_date as varchar(15))as date) as last_visit_date,  
		0 is_processed   
	into 
		#pending_vins  
	from   
		#master_cust_2_vehicle c2v with(nolock)  
	inner join #master_customer mc with(nolock) on   
		c2v.master_customer_id = mc.master_customer_id  
	where   
			isnull(c2v.is_deleted, 0) = 0 
		and isnull(mc.is_deleted, 0) = 0
		--and c2v.file_process_id = @file_process_id

  
	--- Getting min and max Service RO Records  
         
	select   
		pv.master_customer_id,  
		pv.natural_key,  
		pv.vin,   
		max(cast(cast(ro_close_date as varchar(15))as date)) as max_ro_date,  
		min(cast(cast(ro_close_date as varchar(15))as date)) as min_ro_date,  
		null as max_ro_mileage,  
		null as min_ro_mileage   
	into
		#min_max_ros  
	from   
		master.repair_order_header ro (nolock)    
		inner join #pending_vins pv (nolock) on  
			ro.vin = pv.vin 
		and ro.natural_key = pv.natural_key  
	where isnull(ro.is_deleted, 0) = 0 
	group by   
		pv.master_customer_id, pv.natural_key, pv.vin  --577899  
  
  
	-- delete max and min date equl records and max and min differance < 30 reocrds 
	delete from #min_max_ros where (min_ro_date=max_ro_date or datediff(day,min_ro_date,max_ro_date) < 30)  --214928  
  
  
	-- update max mileage  
  
	update   
		a 
	set   
		a.max_ro_mileage = roh.mileage_out  
	from   
		#min_max_ros a (nolock)  
	inner join master.repair_order_header roh on  
		a.natural_key = roh.natural_key and  
		a.vin = roh.vin and  
		Convert(varchar(10), a.max_ro_date, 112) = roh.ro_close_date 
	where  1=1
		--and roh.file_process_id = @file_process_id  
		and roh.parent_dealer_id = @dealer_id
  
	-- update min mileage  
	update   
		a      
	set   
		a.min_ro_mileage = roh.mileage_out  
	from   
		#min_max_ros a (nolock)  
	inner join master.repair_order_header roh on  
		a.natural_key = roh.natural_key and  
		a.vin = roh.vin and  
		Convert(varchar(10), a.min_ro_date, 112) = roh.ro_close_date 
	where  1=1
		--and roh.file_process_id = @file_process_id  
		and roh.parent_dealer_id = @dealer_id
  
  
	/*** Calculate Avg Daily Miles & Last Estimated Mileage based on min and max (mileage and repair order dates) started ***/  
  
	UPDATE mc  
	SET    mc.daily_average_mile = CASE  
						 WHEN (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date) < 10 then 10  
						 WHEN (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date) > 80 then 80  
						 else (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date)  
						 End   
	--select mc.master_customer_id, 	
	--CASE  
	--					 WHEN (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date) < 10 then 10  
	--					 WHEN (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date) > 80 then 80  
	--					 else (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date)  
	--					 End   
	--					 ,mc.daily_average_mile
	FROM   #min_max_ros a (nolock)   
	inner join #master_cust_2_vehicle c2v (nolock) on  
		a.natural_key = c2v.natural_key and  
		a.vin = c2v.vin  
	inner join #master_customer mc with(nolock) on   
		mc.master_customer_id = c2v.master_customer_id  
	and (mc.daily_average_mile is null or mc.daily_average_mile != (CASE  
						 WHEN (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date) < 10 then 10  
						 WHEN (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date) > 80 then 80  
						 else (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date)  
						 End   ))
  
   --update mc  
   --set    mc.last_estimated_mileage = last_ro_mileage+(daily_average_mile*datediff(dd,cast(cast(last_activity_date as varchar(15)) as date),getdate()))  
   --from  
   --     #min_max_ros mmr (nolock)   
   --          inner join #master_cust_2_vehicle pv (nolock) on  
   --                 mmr.natural_key =pv.natural_key and  
   --                 mmr.vin=pv.vin  
   --       inner join #master_customer mc  with(nolock) on   
   --           mc.master_customer_id = pv.master_customer_id  
   --where  
   --   last_activity_date <> 10101   
   --and last_activity_date is not null   
   --and mc.is_deleted=0  --362971  
  
	update 
		c2v  
	set     
		c2v.is_processed=1  
  	from  
		#min_max_ros mmr (nolock)   
	inner join #pending_vins c2v (nolock) on  
		mmr.natural_key = c2v.natural_key and  
		mmr.vin = c2v.vin  
  
	/*** Calculate Avg Daily Miles & Last Estimated Mileage based on min and max (mileage and repair order dates) ended ***/  
  
	select   
		pv.* 
	into 
		#sale_ros  
	from     
		#pending_vins pv (nolock)  
	where  
		pv.is_processed=0 and  
		pv.last_sale_date is not null and   
		pv.last_visit_date is not null and  
		pv.last_sale_date <> pv.last_visit_date and  
		datediff(day,pv.last_sale_date,pv.last_visit_date) > 30  --47975  
  
  
	/*** Calculate Avg Daily Miles & Last Estimated Mileage based on one sale and one ro started ***/  
  
	  update mc  
	  set    mc.daily_average_mile = CASE  
						 WHEN (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date) < 10 then 10  
						 WHEN (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date) > 80 then 80  
						 else (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date)  
						 End    
		--select mc.master_customer_id, mc.daily_average_mile, CASE  
	 --                    WHEN (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date) < 10 then 10  
	 --                    WHEN (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date) > 80 then 80  
	 --                    else (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date)  
	 --                    End  
	   from   #sale_ros a (nolock)   
			  inner join #master_cust_2_vehicle c2v (nolock) on  
					 a.natural_key = c2v.natural_key and  
					 a.vin = c2v.vin  
		 inner join #master_customer mc with(nolock) on   
			   c2v.master_customer_id = mc.master_customer_id and   
		 c2v.natural_key = mc.natural_key  
	   where  
		   mc.is_deleted=0     
		   and (mc.daily_average_mile is null or mc.daily_average_mile != ( CASE  
	                     WHEN (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date) < 10 then 10  
	                     WHEN (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date) > 80 then 80  
	                     else (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date)  
	                     End ))
  
  
  
	--update mc  
	--set    mc.last_estimated_mileage = iif(pv.last_sale_mileage is null,pv.last_ro_mileage,mmr.last_sale_mileage)+(mc.daily_average_mile*datediff(dd,cast(cast(last_activity_date as varchar(15)) as date),getdate()))   
                
  
	--from    #sale_ros mmr (nolock)   
	--		inner join #master_cust_2_vehicle pv (nolock) on  
	--				mmr.natural_key=pv.natural_key and  
	--				mmr.vin=pv.vin  
	--	inner join #master_customer mc with(nolock) on   
	--		pv.master_customer_id = mc.master_customer_id and   
	--	pv.natural_key = mc.natural_key   
	--where  
	--	last_activity_date <> 10101   
	--	and last_activity_date is not null   
	--	and mc.is_deleted=0     

     update  
		c2v  
     set      
	     c2v.is_processed=1  
     from     
		#sale_ros mmr (nolock)   
	inner join #pending_vins c2v (nolock) on  
        mmr.natural_key = c2v.natural_key and  
        mmr.vin = c2v.vin  
  
	/*** Calculate Avg Daily Miles & Last Estimated Mileage based on sale records started ***/  
  
	select   
		a.* into #sale_records  
	from  
		#pending_vins a (nolock)   
	left join master.repair_order_header c2v (nolock) on  
		a.natural_key = c2v.natural_key and  
		a.vin = c2v.vin  
	where  
		is_processed = 0 and  
		c2v.master_ro_header_id is null and  
		a.last_sale_date is not null   --114110  
  
	update 
		mc  
	set     
		mc.daily_average_mile = 80
	--mc.last_estimated_mileage = c2v.last_sale_mileage+(30*datediff(dd,cast(cast(c2v.last_sale_date as varchar(15)) as date),getdate()))   
	--select mc.master_customer_id, mc.daily_average_mile
	from 
		#sale_records a (nolock)   
	inner join #master_cust_2_vehicle c2v (nolock) on  
		a.natural_key = c2v.natural_key and  
		a.vin = c2v.vin  
	inner join #master_customer mc with(nolock) on   
		mc.master_customer_id = c2v.master_customer_id  
	where  
		mc.is_deleted=0  
		and mc.daily_average_mile is null
       
	update 
		c2v  
	set    
		c2v.is_processed = 1  
	from   
		#sale_records a (nolock)   
	inner join #pending_vins c2v (nolock) on  
		a.natural_key = c2v.natural_key and  
		a.vin = c2v.vin  
  
	/*** Calculate Avg Daily Miles & Last Estimated Mileage based on service (single ro) records  started ***/  
  
	select   
		a.* 
	into 
		#service_records  
	from   
		#pending_vins a (nolock)   
	inner join master.repair_order_header roh (nolock) on  
		a.natural_key = roh.natural_key and  
		a.vin = roh.vin  
	where  
		is_processed=0     
  
	update 
		mc  
	set    
		mc.daily_average_mile = 80  
	--mc.last_estimated_mileage = iif(c2v.last_sale_mileage is null,c2v.last_ro_mileage,c2v.last_sale_mileage)+(30*datediff(dd,cast(cast(last_activity_date as varchar(15)) as date),getdate()))   
	--select mc.master_customer_id, mc.daily_average_mile, mc.parent_dealer_id
	from
		#service_records a (nolock)   
	inner join #master_cust_2_vehicle c2v (nolock) on  
			a.natural_key = c2v.natural_key and  
			a.vin = c2v.vin  
	inner join #master_customer mc with(nolock) on   
		mc.master_customer_id = c2v.master_customer_id  
	where  
		mc.last_activity_date is not null   
		and mc.is_deleted=0    
		and mc.daily_average_mile is null
  
	update 
		pv  
	set    
		pv.is_processed=1  
	from   
		#service_records mmr (nolock)   
	inner join #pending_vins pv (nolock) on  
		mmr.natural_key=pv.natural_key and  
		mmr.vin=pv.vin  
  
	/*** Calculate Avg Daily Miles & Last Estimated Mileage based on customer records (no ro) started ***/  
  
	select   
		a.* 
	into 
		#no_service_records  
	from   
		#pending_vins a (nolock)  
	where  
		is_processed=0  
	and last_visit_date is not null  
       
    --select distinct dealer_code,vin from #service_records  
       
     update mc  
     set    mc.daily_average_mile = 80  
            --mc.last_estimated_mileage = iif(c2v.last_sale_mileage is null,c2v.last_ro_mileage,c2v.last_sale_mileage)+(30*datediff(dd,cast(cast(last_activity_date as varchar(15)) as date),getdate()))   
	 --select mc.master_customer_id, mc.daily_average_mile
     from   #no_service_records a (nolock)   
            inner join #master_cust_2_vehicle c2v (nolock) on  
                a.natural_key = c2v.natural_key and  
                a.vin = c2v.vin  
   inner join #master_customer mc with(nolock) on   
       mc.master_customer_id = c2v.master_customer_id  
           
     where  
        mc.last_activity_date is not null   
     and mc.is_deleted=0 
	 and mc.daily_average_mile is null
       
	update 
		b  
	set    
		b.is_processed=1  
	from   
		#no_service_records a (nolock)   
	inner join #pending_vins b (nolock) on  
		a.natural_key = b.natural_key and  
		a.vin = b.vin  
      
        drop table #min_max_ros,#pending_vins   
end  


--select 	c.parent_dealer_id,c.master_customer_id,
update c set
	c.daily_average_mile = tc.daily_average_mile 
from #master_customer tc
inner join master.customer c (nolock) on c.master_customer_id = tc.master_customer_id and c.parent_dealer_id = tc.parent_dealer_id
where tc.daily_average_mile <> c.daily_average_mile



  
  
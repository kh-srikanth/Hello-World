----USE [clictell_auto_master]
----GO
----/****** Object:  StoredProcedure [master].[estimated_mileage_update]    Script Date: 7/15/2021 6:12:39 PM ******/
----SET ANSI_NULLS ON
----GO
----SET QUOTED_IDENTIFIER ON
----GO
  
------ALTER procedure [master].[estimated_mileage_update]  
----  declare
---- @file_process_id int   
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
  
	/**  declare variables **/  
  
	/*** Get Pending vins for ADM & LEM Calculation ***/  
    
	--Declare @file_process_id int
	IF OBJECT_ID('tempdb..#pending_vins') IS NOT NULL DROP TABLE #pending_vins
	IF OBJECT_ID('tempdb..#min_max_ros') IS NOT NULL DROP TABLE #min_max_ros
	IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result
	IF OBJECT_ID('tempdb..#result1') IS NOT NULL DROP TABLE #result1
	IF OBJECT_ID('tempdb..#sale_ros') IS NOT NULL DROP TABLE #sale_ros


	--select last_sale_date, * from master.cust_2_vehicle (nolock)  
	--where	last_sale_date is not null 
	--		and vin in (select vin from master.cust_2_vehicle (nolock) 	group by vin having count(vin)>1) 
	--order by vin,cust_dms_number

	select   
		c2v.parent_dealer_id,  
		c2v.natural_key,  
		c2v.master_customer_id, 
		c2v.cust_dms_number,
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
		master.cust_2_vehicle c2v with(nolock)  
	inner join master.customer mc with(nolock) on  c2v.master_customer_id = mc.master_customer_id  and c2v.parent_dealer_id=mc.parent_dealer_id
	order by vin		
	
	--where   
	--		c2v.is_deleted = 0 
	--	and c2v.file_process_id = @file_process_id

  
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
			ro.vin = pv.vin and ro.master_customer_id = pv.master_customer_id
		and ro.natural_key = pv.natural_key  
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
		a.vin = roh.vin and  a.master_customer_id =roh.master_customer_id and
		Convert(varchar(10), a.max_ro_date, 112) = roh.ro_close_date 
	--where  
	--	roh.file_process_id = @file_process_id  
  
	-- update min mileage  
	update   
		a      
	set   
		a.min_ro_mileage = roh.mileage_out  
	from   
		#min_max_ros a (nolock)  
	inner join master.repair_order_header roh on  
		a.natural_key = roh.natural_key and  
		a.vin = roh.vin and  a.master_customer_id =roh.master_customer_id and
		Convert(varchar(10), a.min_ro_date, 112) = roh.ro_close_date 
	--where  
	--	roh.file_process_id = @file_process_id  
  


  select 
		   c2v.master_customer_id
		  ,c2v.vin
		  ,min_ro_mileage
		  ,max_ro_mileage
		  ,isnull(max_ro_mileage,0)-isnull(min_ro_mileage,0) as net_mileage
		  ,min_ro_date
		  ,max_ro_date
		  ,datediff(day,min_ro_date,max_ro_date) as days_gap
		  ,daily_average_mile
		  ,(cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date) as calc_avg_mile
		  ,(CASE  WHEN (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date) < 10 then 10  
				  WHEN (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date) > 40 then 40
				  ELSE null end) as limit_check
into #result
  	FROM   #min_max_ros a (nolock)  
	inner join master.cust_2_vehicle c2v (nolock) on a.natural_key = c2v.natural_key and a.vin = c2v.vin  and a.master_customer_id =c2v.master_customer_id
	inner join master.customer mc with(nolock) on mc.master_customer_id = c2v.master_customer_id 
	 order by vin, master_customer_id

--select * from #result where vin in (select vin from #result group by vin having count(vin)>1) order by vin


/*
  --select cust_dms_number,ro_close_date,* from master.repair_order_header(nolock) where cust_dms_number ='056664'

	/*** Calculate Avg Daily Miles & Last Estimated Mileage based on min and max (mileage and repair order dates) started ***/  
  
	UPDATE mc  
	SET    mc.daily_average_mile = CASE  
						 WHEN (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date) < 10 then 10  
						 WHEN (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date) > 40 then 40  
						 else (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date)  
						 End   
	--select mc.master_customer_id, 	
	--CASE  
	--					 WHEN (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date) < 10 then 10  
	--					 WHEN (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date) > 40 then 40  
	--					 else (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date)  
	--					 End   
	--					 ,mc.daily_average_mile
	FROM   #min_max_ros a (nolock)   
	inner join master.cust_2_vehicle c2v (nolock) on  
		a.natural_key = c2v.natural_key and  
		a.vin = c2v.vin  
	inner join master.customer mc with(nolock) on   
		mc.master_customer_id = c2v.master_customer_id  
	and (mc.daily_average_mile is null or mc.daily_average_mile != (CASE  
						 WHEN (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date) < 10 then 10  
						 WHEN (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date) > 40 then 40  
						 else (cast(a.max_ro_mileage as int) - cast(a.min_ro_mileage as int))/DateDiff(DAY, a.min_ro_date, a.max_ro_date)  
						 End   ))
  
   --update mc  
   --set    mc.last_estimated_mileage = last_ro_mileage+(daily_average_mile*datediff(dd,cast(cast(last_activity_date as varchar(15)) as date),getdate()))  
   --from  
   --     #min_max_ros mmr (nolock)   
   --          inner join master.cust_2_vehicle pv (nolock) on  
   --                 mmr.natural_key =pv.natural_key and  
   --                 mmr.vin=pv.vin  
   --       inner join master.customer mc  with(nolock) on   
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
		mmr.vin = c2v.vin  */
  
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
  
  select
		 s.parent_dealer_id
		,ROW_NUMBER() over (partition by s.vin, s.cust_dms_number order by ro_close_date desc) as rnk
		,s.vin
		,s.cust_dms_number
		,s.master_customer_id
		,last_sale_mileage
		,s.mileage_in as sales_mileage_in
		,r.mileage_out as ro_mileage_out
		,last_ro_mileage
		,last_mileage_odometer
		,first_ro_mileage
		,purchase_date
		,ro_close_date
		,ro_number
		,(r.mileage_out -s.mileage_in) as mileage
		,DATEDIFF(day,convert(date,convert(char(8),purchase_date)),convert(date,convert(char(8),ro_close_date))) as date_diff
		,(r.mileage_out -s.mileage_in)/DATEDIFF(day,convert(date,convert(char(8),purchase_date)),convert(date,convert(char(8),ro_close_date))) as calc_avg_mileage_sales
	into #result1
  from master.fi_Sales s (nolock) inner join master.repair_order_header r (nolock) on s.vin=r.vin and s.cust_dms_number =r.cust_dms_number
  where  ro_close_date is not null 
		and deal_status in ('Sold','Finalized')
		and DATEDIFF(day,convert(date,convert(char(8),purchase_date)),convert(date,convert(char(8),ro_close_date))) >30
  order by vin,cust_dms_number,purchase_date,ro_close_date

/*
 
		select distinct
		
				a.parent_dealer_id
				,a.natural_key
				,a.vin
				,a.master_customer_id
				,a.last_visit_mileage
				,a.last_sale_mileage
				,a.last_visit_mileage-a.last_sale_mileage as milage_gap
				,a.last_sale_date
				,a.last_visit_date
				,DateDiff(DAY, a.last_sale_date, a.last_visit_date) as days_gap
				,(cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date) as calc_avg_daily_mile_sale
  	   into #result1
	   from  #sale_ros a (nolock)   
			  inner join master.cust_2_vehicle c2v (nolock) on  
					 a.natural_key = c2v.natural_key and  
					 a.vin = c2v.vin  and a.master_customer_id = c2v.master_customer_id
		 inner join master.customer mc with(nolock) on   
			   c2v.master_customer_id = mc.master_customer_id and   
		 c2v.natural_key = mc.natural_key 
		 where last_visit_mileage is not null
*/
return;

select * from #result order by vin, master_customer_id
select * from #result1 order by vin, master_customer_id




select count(*) from master.fi_sales (nolock) where parent_dealer_id=1806 and deal_status in ('Sold','Finalized')--500
select count(*) from master.repair_order_header (nolock) where parent_dealer_id=1806 and ro_close_date is not null --114751

select 
	count(distinct s.vin) 
from master.fi_sales s (nolock) 
	inner join master.repair_order_header r (nolock) on s.vin=r.vin and s.master_customer_id=r.master_customer_id
where s.parent_dealer_id=1806 and deal_status in ('Sold','Finalized')and ro_close_date is not null --69
and DATEDIFF(day,convert(date,convert(char(8),purchase_date)),convert(date,convert(char(8),ro_close_date))) >10 --28


select a.*,b.calc_avg_daily_mile_sale
from #result a left outer join #result1 b on a.vin =b.vin and a.master_customer_id =b.master_customer_id where calc_avg_daily_mile_sale is not null



	/*** Calculate Avg Daily Miles & Last Estimated Mileage based on one sale and one ro started ***/  
  
	  update mc  
	  set    mc.daily_average_mile = CASE  
						 WHEN (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date) < 10 then 10  
						 WHEN (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date) > 40 then 40  
						 else (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date)  
						 End    
		--select mc.master_customer_id, mc.daily_average_mile, CASE  
	 --                    WHEN (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date) < 10 then 10  
	 --                    WHEN (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date) > 40 then 60  
	 --                    else (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date)  
	 --                    End  
	   from   #sale_ros a (nolock)   
			  inner join master.cust_2_vehicle c2v (nolock) on  
					 a.natural_key = c2v.natural_key and  
					 a.vin = c2v.vin  
		 inner join master.customer mc with(nolock) on   
			   c2v.master_customer_id = mc.master_customer_id and   
		 c2v.natural_key = mc.natural_key  
	   where  
		   mc.is_deleted=0     
		   and (mc.daily_average_mile is null or mc.daily_average_mile != ( CASE  
	                     WHEN (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date) < 10 then 10  
	                     WHEN (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date) > 40 then 60  
	                     else (cast(a.last_visit_mileage as int) - cast(a.last_sale_mileage as int))/DateDiff(DAY, a.last_sale_date, a.last_visit_date)  
	                     End ))
  
  
  
	--update mc  
	--set    mc.last_estimated_mileage = iif(pv.last_sale_mileage is null,pv.last_ro_mileage,mmr.last_sale_mileage)+(mc.daily_average_mile*datediff(dd,cast(cast(last_activity_date as varchar(15)) as date),getdate()))   
                
  
	--from    #sale_ros mmr (nolock)   
	--		inner join master.cust_2_vehicle pv (nolock) on  
	--				mmr.natural_key=pv.natural_key and  
	--				mmr.vin=pv.vin  
	--	inner join master.customer mc with(nolock) on   
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
		mc.daily_average_mile = 40
	--mc.last_estimated_mileage = c2v.last_sale_mileage+(30*datediff(dd,cast(cast(c2v.last_sale_date as varchar(15)) as date),getdate()))   
	--select mc.master_customer_id, mc.daily_average_mile
	from 
		#sale_records a (nolock)   
	inner join master.cust_2_vehicle c2v (nolock) on  
		a.natural_key = c2v.natural_key and  
		a.vin = c2v.vin  
	inner join master.customer mc with(nolock) on   
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
		mc.daily_average_mile = 40  
	--mc.last_estimated_mileage = iif(c2v.last_sale_mileage is null,c2v.last_ro_mileage,c2v.last_sale_mileage)+(30*datediff(dd,cast(cast(last_activity_date as varchar(15)) as date),getdate()))   
	--select mc.master_customer_id, mc.daily_average_mile, mc.parent_dealer_id
	from
		#service_records a (nolock)   
	inner join master.cust_2_vehicle c2v (nolock) on  
			a.natural_key = c2v.natural_key and  
			a.vin = c2v.vin  
	inner join master.customer mc with(nolock) on   
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
     set    mc.daily_average_mile = 40  
            --mc.last_estimated_mileage = iif(c2v.last_sale_mileage is null,c2v.last_ro_mileage,c2v.last_sale_mileage)+(30*datediff(dd,cast(cast(last_activity_date as varchar(15)) as date),getdate()))   
	 --select mc.master_customer_id, mc.daily_average_mile
     from   #no_service_records a (nolock)   
            inner join master.cust_2_vehicle c2v (nolock) on  
                a.natural_key = c2v.natural_key and  
                a.vin = c2v.vin  
   inner join master.customer mc with(nolock) on   
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
  
  
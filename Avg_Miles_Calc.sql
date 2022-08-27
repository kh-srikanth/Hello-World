	USE clictell_auto_master
	GO
	IF OBJECT_ID('tempdb..#pending_vins') IS NOT NULL DROP TABLE #pending_vins
	IF OBJECT_ID('tempdb..#min_max_ros') IS NOT NULL DROP TABLE #min_max_ros
	IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result
	IF OBJECT_ID('tempdb..#result1') IS NOT NULL DROP TABLE #result1
	IF OBJECT_ID('tempdb..#sale_ros') IS NOT NULL DROP TABLE #sale_ros

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
	from master.cust_2_vehicle c2v with(nolock)  
		inner join master.customer mc with(nolock) on  
				c2v.master_customer_id = mc.master_customer_id  
				and c2v.parent_dealer_id=mc.parent_dealer_id
	where c2v.is_deleted =0 and mc.is_deleted=0 and len(c2v.vin)=17 
	order by vin	--vin count:78,575
	

	
	--- Getting min and max Service RO Records  
         
	select   
		pv.master_customer_id,  
		pv.natural_key,  
		pv.vin,   
		max(cast(cast(ro_close_date as varchar(15))as date)) as max_ro_date,  
		min(cast(cast(ro_close_date as varchar(15))as date)) as min_ro_date,  
		null as max_ro_mileage,  
		null as min_ro_mileage   
	into		#min_max_ros  
	from   
		master.repair_order_header ro (nolock)    
		inner join #pending_vins pv (nolock) on  
					ro.vin = pv.vin 
				and ro.master_customer_id = pv.master_customer_id
				and ro.natural_key = pv.natural_key  
		where ro_close_date is not null
	group by   
		pv.natural_key,  pv.vin,pv.master_customer_id  --577899  vin count :17,479


		/*select --distinct 			
		pv.master_customer_id,  
		pv.natural_key,  
		pv.parent_dealer_id,
		pv.vin,   
		max(cast(cast(ro_close_date as varchar(15))as date)) as max_ro_date,  
		min(cast(cast(ro_close_date as varchar(15))as date)) as min_ro_date,  
		null as max_ro_mileage,  
		null as min_ro_mileage
			from   
		master.repair_order_header ro (nolock)    
		inner join #pending_vins pv (nolock) on  
					ro.vin = pv.vin 
				and ro.master_customer_id = pv.master_customer_id
				and ro.natural_key = pv.natural_key  
		where ro_close_date is not null 
		group by pv.natural_key,pv.parent_dealer_id, pv.vin,pv.master_customer_id
		
		order by pv.natural_key,pv.vin, pv.master_customer_id*/
  
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
  
  --select * from #min_max_ros

  select 
		   c2v.parent_dealer_id
		  ,c2v.master_customer_id
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
			inner join master.cust_2_vehicle c2v (nolock) on 
						a.natural_key = c2v.natural_key and a.vin = c2v.vin  and a.master_customer_id =c2v.master_customer_id
			inner join master.customer mc with(nolock) on 
						mc.master_customer_id = c2v.master_customer_id 
	 order by vin, master_customer_id

--select * from #result where vin in (select vin from #result group by vin having count(vin)>1) order by vin

  
	/*** Calculate Avg Daily Miles & Last Estimated Mileage based on min and max (mileage and repair order dates) ended ***/  
  
  
  select
		 s.parent_dealer_id
		,ROW_NUMBER() over (partition by s.vin, s.cust_dms_number order by ro_close_date desc) as rnk
		,s.vin
		,s.cust_dms_number
		,s.master_customer_id
		,s.mileage_out as sales_mileage_out
		,r.mileage_out as ro_mileage_out
		,purchase_date
		,ro_close_date
		,ro_number
		,(r.mileage_out -s.mileage_out) as mileage
		,DATEDIFF(day,convert(date,convert(char(8),purchase_date)),convert(date,convert(char(8),ro_close_date))) as date_diff
		,(r.mileage_out -s.mileage_in)/DATEDIFF(day,convert(date,convert(char(8),purchase_date)),convert(date,convert(char(8),ro_close_date))) as calc_avg_mileage_sales
	
	into #result1
  from master.fi_Sales s (nolock) 
		inner join master.repair_order_header r (nolock) on s.vin=r.vin and s.cust_dms_number =r.cust_dms_number
  where  ro_close_date is not null 
		and deal_status in ('Sold','Finalized')
		and DATEDIFF(day,convert(date,convert(char(8),purchase_date)),convert(date,convert(char(8),ro_close_date))) >30
  order by vin,cust_dms_number,purchase_date,ro_close_date


--select * from #result where vin in (select vin from #result1 where rnk=1) order by vin, master_customer_id
--select * from #result1 where rnk=1 order by vin, master_customer_id 


	select 
		 p.parent_dealer_id
		,p.vin
		,p.master_customer_id
		,p.cust_dms_number
		,p.daily_average_mile as daily_average_mile_in_DB
		--,calc_avg_mile as avg_mile_calc
		--,calc_avg_mileage_sales as avg_mile_sale
		--,limit_check
		,iif(calc_avg_mile is null,'yes','no') as default_set
		,(case --when calc_avg_mile >=40 then 40
				when calc_avg_mile is null then 40
				when calc_avg_mile <=10 then 10
				else calc_avg_mile end ) as avgerage_daily_miles_calculated
	from #pending_vins p left outer join #result r on p.parent_dealer_id=r.parent_dealer_id and p.vin=r.vin and p.master_customer_id=r.master_customer_id
	left outer join #result1 r1 on 	r.vin =r1.vin 	and r.master_customer_id =r1.master_customer_id and r.parent_dealer_id=r1.parent_dealer_id

	--order by vin, master_customer_id


--where (daily_average_mile != calc_avg_mile) and (daily_average_mile != limit_check)

--select * from master.fi_sales (nolock) where vin ='5J6YH28615L800967' order by purchase_date
--select * from master.repair_order_header (nolock) where vin ='5J6YH28615L800967' order by ro_close_date

--select * from master.fi_sales (nolock) where vin ='5FNYF484X9B034400' order by purchase_date
--select * from master.repair_order_header (nolock) where vin ='5FNYF484X9B034400' order by ro_close_date

--select * from master.fi_sales (nolock) where vin ='5FNYF6H93JB005669' order by purchase_date
--select * from master.repair_order_header (nolock) where vin ='5FNYF6H93JB005669' order by ro_close_date

--select * from master.fi_sales (nolock) where vin ='1HGCR2F81GA042534' order by purchase_date
--select * from master.repair_order_header (nolock) where vin ='1HGCR2F81GA042534' order by ro_close_date




--select count(*) from master.fi_sales (nolock) where parent_dealer_id=1806 and deal_status in ('Sold','Finalized')--500
--select count(*) from master.repair_order_header (nolock) where parent_dealer_id=1806 and ro_close_date is not null --114751

--select 
--	count(distinct s.vin) 
--from master.fi_sales s (nolock) 
--	inner join master.repair_order_header r (nolock) on s.vin=r.vin and s.master_customer_id=r.master_customer_id
--where s.parent_dealer_id=1806 and deal_status in ('Sold','Finalized')and ro_close_date is not null --69
--and DATEDIFF(day,convert(date,convert(char(8),purchase_date)),convert(date,convert(char(8),ro_close_date))) >10 --28
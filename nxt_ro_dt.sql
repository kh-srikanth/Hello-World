use clictell_auto_master
go

	IF OBJECT_ID('tempdb..#maintenance_schedule') IS NOT NULL DROP TABLE #maintenance_schedule
	IF OBJECT_ID('tempdb..#roh') IS NOT NULL DROP TABLE #roh
	IF OBJECT_ID('tempdb..#com1') IS NOT NULL DROP TABLE #com1
	IF OBJECT_ID('tempdb..#com2') IS NOT NULL DROP TABLE #com2
	IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result
	IF OBJECT_ID('tempdb..#nxt_service_miles') IS NOT NULL DROP TABLE #nxt_service_miles
	IF OBJECT_ID('tempdb..#nxt_service_sales') IS NOT NULL DROP TABLE #nxt_service_sales
	IF OBJECT_ID('tempdb..#temp_result') IS NOT NULL DROP TABLE #temp_result
	IF OBJECT_ID('tempdb..#temp_result1') IS NOT NULL DROP TABLE #temp_result1
	IF OBJECT_ID('tempdb..#nxt_ro_clc') IS NOT NULL DROP TABLE #nxt_ro_clc

	select a.parent_dealer_id, a.cust_vehicle_id, a.vin, a.cust_dms_number, a.master_customer_id, b.daily_average_mile,  a.master_vehicle_id, 
			a.first_ro_date, a.first_ro_mileage, a.last_ro_date, a.last_ro_mileage, a.last_sale_date, a.last_sale_mileage,
			'1900-01-01' as next_service_date_4srv, '1900-01-01' as next_service_date_4sales
	into #temp_result
	from master.cust_2_vehicle a (nolock)
	inner join master.customer b (nolock) on
		a.master_customer_id = b.master_customer_id
	where a.is_deleted = 0
	and a.inactive_date is null
	and a.parent_dealer_id = 1806 
	--and a.file_process_id = @file_process_id


	create table #maintenance_schedule

	(
		s_no int identity(1,1)
		,parent_dealer_id int
		,general_service_start_miles int
		,general_service_end_miles int
		,general_service_start_months int
		,general_service_end_months int
		,minor_service_miles int
		,minor_service_months int
		,major_service_miles int
		,major_service_months int
		,is_deleted bit default 0
		,created_by varchar(50) default suser_name()
		,created_date datetime default getdate()
		,updated_by varchar(50) default suser_name()
		,updated_date datetime default getdate()
	)

	insert into #maintenance_schedule
	(parent_dealer_id,general_service_start_miles,general_service_end_miles,general_service_start_months, general_service_end_months,minor_service_miles,minor_service_months,major_service_miles,major_service_months)
	values 
		(1806,7500,22500,1,6,15000,12,30000,24),
		(1806,22501,37500,7,18,45000,36,60000,48),
		(1806,37501,52500,19,30,75000,60,90000,72),
		(1806,52501,67500,31,42,105000,84,120000,96),
		(1806,67501,82500,43,54,135000,108,150000,120),
		(1806,82501,97500,55,66,165000,132,180000,144),
		(1806,97501,112500,67,78,195000,156,210000,168),
		(1806,112501,127500,79,90,225000,180,240000,192),
		(1806,127501,142500,91,102,255000,204,270000,216),
		(1806,142501,157500,103,114,285000,228,300000,240),
		(1806,157501,172500,115,126,null,null,null,null),
		(1806,172501,187500,127,138,null,null,null,null),
		(1806,187501,187500,139,150,null,null,null,null),
		(1806,202501,217500,151,162,null,null,null,null),
		(1806,217501,232500,163,174,null,null,null,null),
		(1806,232501,247500,175,186,null,null,null,null),
		(1806,247501,262500,187,198,null,null,null,null),
		(1806,262501,277500,199,210,null,null,null,null),
		(1806,277501,292500,211,222,null,null,null,null),
		(1806,292501,null,221,234,null,null,null,null)

		--select * from #maintenance_schedule


	--select a.parent_dealer_id, a.cust_vehicle_id, a.vin, a.cust_dms_number, a.master_customer_id, a.master_vehicle_id, a.last_ro_mileage, last_ro_date, 
	--b.general_service_start_miles, b.general_service_end_miles, a.daily_average_mile, (general_service_end_miles - last_ro_mileage)/daily_average_mile as days_due,
	--DateAdd(day, (general_service_end_miles - last_ro_mileage)/daily_average_mile, Cast(Cast(last_ro_date as varchar(10)) as date)) as nxt_ro_clc,
	--datediff(day,getdate(),DateAdd(day, (general_service_end_miles - last_ro_mileage)/daily_average_mile, Cast(Cast(last_ro_date as varchar(10)) as date))) as lapsed_days
	Update a set a.next_service_date_4srv = DateAdd(day, (general_service_end_miles - last_ro_mileage)/Isnull(daily_average_mile, 40), Cast(Cast(last_ro_date as varchar(10)) as date))
		
	from #temp_result a
	inner join #maintenance_schedule b  on 
		a.last_ro_mileage between b.general_service_start_miles and b.general_service_end_miles
	where a.last_ro_mileage is not null and a.last_ro_date is not null



	--select a.parent_dealer_id, a.cust_vehicle_id, a.vin, a.cust_dms_number, a.master_customer_id, a.master_vehicle_id, isnull(a.last_sale_date, a.first_ro_date), 
	--b.general_service_start_months, b.general_service_end_months, dateDiff(month, Cast(Cast(isnull(a.last_sale_date, a.first_ro_date) as varchar(10)) as date), getdate()),
	--DateAdd(month, dateDiff(month, Cast(Cast(isnull(a.last_sale_date, a.first_ro_date) as varchar(10)) as date), getdate()), Cast(Cast(isnull(a.last_sale_date, a.first_ro_date) as varchar(10)) as date))
	Update a set a.next_service_date_4sales = 
				DateAdd(month
						--, dateDiff(month, Cast(Cast(isnull(a.last_sale_date, a.first_ro_date) as varchar(10)) as date), getdate())
						,b.general_service_end_months
						, Cast(Cast(isnull(a.last_sale_date, a.first_ro_date) as varchar(10)) as date)
						)
	from #temp_result a
	inner join #maintenance_schedule b  on 
		dateDiff(month, Cast(Cast(isnull(a.last_sale_date, a.first_ro_date) as varchar(10)) as date), getdate()) between b.general_service_start_months and b.general_service_end_months
	where isnull(a.last_sale_date, a.first_ro_date) is not null
	
	
	select * 
	,datediff(day,getdate(),next_service_date_4srv) as nxt_srv_4srv_today_diff
	,datediff(day,getdate(),next_service_date_4sales) as nxt_srv_4sales_today_diff
	,case when datediff(day,getdate(),next_service_date_4srv) > 0 
			  and datediff(day,getdate(),next_service_date_4sales) > 0 
			  and (datediff(day,getdate(),next_service_date_4srv)) < ABS(datediff(day,getdate(),next_service_date_4sales)) then next_service_date_4srv
		  when datediff(day,getdate(),next_service_date_4srv) > 0 
		  	  and datediff(day,getdate(),next_service_date_4sales) > 0 
		  	  and (datediff(day,getdate(),next_service_date_4srv)) > ABS(datediff(day,getdate(),next_service_date_4sales)) then next_service_date_4sales
		  when datediff(day,getdate(),next_service_date_4srv) > 0 and datediff(day,getdate(),next_service_date_4sales) < 0 then next_service_date_4srv
		  when datediff(day,getdate(),next_service_date_4srv) < 0 and datediff(day,getdate(),next_service_date_4sales) > 0 then next_service_date_4sales
		  end as final_next_service_due_date
		into #temp_result1
	from #temp_result --50975

	select * from #temp_result1 where vin = '1HGCP2F33AA098752'
return;
	select a.cust_vehicle_id,a.vin,a.cust_dms_number, a.last_ro_date,a.last_sale_date, a.next_service_date, b.final_next_service_due_date
	--Update a set a.next_service_date = b.final_next_service_due_date
	from master.cust_2_vehicle a (nolock)
	inner join #temp_result1 b on a.cust_vehicle_id = b.cust_vehicle_id
	where final_next_service_due_date >= getdate()


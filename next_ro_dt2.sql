use clictell_auto_master
go
	drop table if exists #maintenance_schedule
	drop table if exists #temp_result
	drop table if exists #lsd
	drop table if exists #sale
	drop table if exists #mileage
	drop table if exists #result

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


	select a.parent_dealer_id, a.cust_vehicle_id, a.vin, a.cust_dms_number, a.master_customer_id, b.daily_average_mile,  a.master_vehicle_id, 
			a.first_ro_date, a.first_ro_mileage, a.last_ro_date, a.last_ro_mileage, a.last_sale_date, a.last_sale_mileage
			--cast(null as date) as next_service_date_4srv1, Cast(null as date) as next_service_date_4sales1, cast(null as date) as next_service_date_4srv2, Cast(null as date) as next_service_date_4sales2
		into #temp_result
	from 
	master.cust_2_vehicle a (nolock)
	inner join master.customer b (nolock) 
		on a.master_customer_id = b.master_customer_id
	where a.is_deleted = 0
			and a.inactive_date is null
			and a.parent_dealer_id = 1806 



	select	parent_dealer_id
			,cust_dms_number
			,vin
			,convert(varchar(10),dateadd(day,-1*(last_ro_mileage/daily_average_mile),convert(date,convert(varchar(10),last_ro_date))),112) as sale_dt
	into #lsd
	from #temp_result

	select	a.parent_dealer_id
			,a.cust_dms_number
			,a.vin
			,a.sale_dt
			,datediff(month,convert(date,convert(varchar(10),a.sale_dt)),getdate()) as mileage_age
			,dateadd(month,b.general_service_end_months,convert(date,convert(varchar(10),a.sale_dt))) as nxt_ro_dt_mileage
		into #mileage
	from #lsd a
	left outer join #maintenance_schedule b 
			on a.parent_dealer_id = b.parent_dealer_id 
			and getdate() between 
						dateadd(month,b.general_service_start_months-1,convert(date,convert(varchar(10),a.sale_dt))) 
					and dateadd(month,b.general_service_end_months,convert(date,convert(varchar(10),a.sale_dt)))


		select		
				a.parent_dealer_id
				,a.cust_dms_number
				,a.vin
				,a.last_sale_date 
				,datediff(month,convert(date,convert(varchar(10),a.last_sale_date)),getdate()) as sale_age
				,dateadd(month,b.general_service_end_months,convert(date,convert(varchar(10),a.last_sale_date))) as nxt_ro_dt_sale
			into #sale
		from #temp_result a
		left outer join #maintenance_schedule b
				on a.parent_dealer_id = b.parent_dealer_id
				and getdate() between 
						dateadd(month,b.general_service_start_months-1,convert(date,convert(varchar(10),a.last_sale_date))) 
					and dateadd(month,b.general_service_end_months,convert(date,convert(varchar(10),a.last_sale_date)))


			select 
					a.parent_dealer_id
					,a.cust_dms_number
					,a.vin
					,a.sale_age
					,b.mileage_age
					,a.nxt_ro_dt_sale
					,b.nxt_ro_dt_mileage
					,case	when nxt_ro_dt_sale is null and nxt_ro_dt_mileage is not null then nxt_ro_dt_mileage
							when nxt_ro_dt_sale is not null and nxt_ro_dt_mileage is null then nxt_ro_dt_sale
							when (nxt_ro_dt_sale is not null and nxt_ro_dt_mileage is not null) and nxt_ro_dt_sale < nxt_ro_dt_mileage then nxt_ro_dt_sale
							when (nxt_ro_dt_sale is not null and nxt_ro_dt_mileage is not null) and nxt_ro_dt_sale > nxt_ro_dt_mileage then nxt_ro_dt_mileage
							else null end		as nxt_ro_dt
					into #result
			from #sale a 
			inner join #mileage b 
					on a.parent_dealer_id = b.parent_dealer_id 
						and a.cust_dms_number = b.cust_dms_number 
						and a.vin = b.vin


select * from #result --51548

select count(*) from master.cust_2_vehicle a (nolock)  where parent_dealer_id =1806  --65215
select a.parent_dealer_id,a.cust_dms_number,a.vin,a.next_service_date,b.nxt_ro_dt,b.nxt_ro_dt_mileage,b.nxt_ro_dt_sale from master.cust_2_vehicle a (nolock) 
left outer join #result b on a.parent_dealer_id = b.parent_dealer_id and a.cust_dms_number = b.cust_dms_number and a.vin = b.vin
where next_service_date is not null and a.parent_dealer_id = 1806 and next_service_date < nxt_ro_dt
	--where nxt_ro_dt < getdate() and nxt_ro_dt <> '1901-01-01' and mileage_age < 234
	--where a.cust_dms_number ='1002370' and a.vin ='SHHFK7H53JU416798'
				
/*
select * from #mileage where cust_dms_number ='1002370' and vin ='SHHFK7H53JU416798'
select * from master.cust_2_vehicle (nolock) where cust_dms_number ='1002370' and vin ='SHHFK7H53JU416798'

daily_avg_miles  =40
last_ro_date =20180509
last_ro_mileage =10
next_service_due = 2021-11-09
select dateadd(month,,'2018-05-09')
select datediff(month,'2018-05-09',getdate())

*/
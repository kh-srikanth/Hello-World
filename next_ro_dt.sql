USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [master].[service_kpi_update]    Script Date: 7/14/2021 3:00:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter Procedure [master].[nxt_service_dt_cust_2_veh_update]
--declare
@dealer_id int =1806
as
/*
*************************************************************************************************   
 Copyright 2021 Clictell  
  
 PURPOSE    
 Update column 'next_service_date' in  'master.cust_2_vehicle' using maintenance_schedule 
  
 PROCESSES    
  
 MODIFICATIONS    
 Date(dd-mm-yyyy)	Author		Work		Tracker Id		Description      
 ---------------------------------------------------------------------------------------------------    
 07/14/2021		K.Srikanth  Created    Update column 'next_service_date' in  'master.cust_2_vehicle'
 ---------------------------------------------------------------------------------------------------  
 exec [master].[nxt_service_dt_cust_2_veh_update] 1806
***************************************************************************************************
*/

begin

	IF OBJECT_ID('tempdb..#maintenance_schedule') IS NOT NULL DROP TABLE #maintenance_schedule
	IF OBJECT_ID('tempdb..#roh') IS NOT NULL DROP TABLE #roh
	IF OBJECT_ID('tempdb..#com1') IS NOT NULL DROP TABLE #com1
	IF OBJECT_ID('tempdb..#com2') IS NOT NULL DROP TABLE #com2
	IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result
	IF OBJECT_ID('tempdb..#nxt_service_miles') IS NOT NULL DROP TABLE #nxt_service_miles
	IF OBJECT_ID('tempdb..#nxt_service_sales') IS NOT NULL DROP TABLE #nxt_service_sales

	-------- creating a temp table for miles and month margins for repair orders as given in excel sheet
	/*
	create table #gis ( s_no int identity(1,1), miles int, months int)

	insert into #gis  (miles, months)
				values  
						(7500,6),
						(22500,18),
						(37500,30),
						(52500,42),
						(67500,54),
						(82500,66),
						(97500,78),
						(112500,90),
						(127500,102),
						(142500,114),
						(157500,126),
						(172500,138),
						(187500,150),
						(202500,162),
						(217500,174),
						(232500,186),
						(247500,198),
						(262500,210),
						(277500,222),
						(292500,234)
	*/

	create table #maintenance_schedule

	(
		s_no int identity(1,1)
		,parent_dealer_id int
		,general_service_miles int
		,general_service_months int
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
	(parent_dealer_id,general_service_miles,general_service_months,minor_service_miles,minor_service_months,major_service_miles,major_service_months)
	values 
		(1806,7500,6,15000,12,30000,24),
		(1806,22500,18,45000,36,60000,48),
		(1806,37500,30,75000,60,90000,72),
		(1806,52500,42,105000,84,120000,96),
		(1806,67500,54,135000,108,150000,120),
		(1806,82500,66,165000,132,180000,144),
		(1806,97500,78,195000,156,210000,168),
		(1806,112500,90,225000,180,240000,192),
		(1806,127500,102,255000,204,270000,216),
		(1806,142500,114,285000,228,300000,240),
		(1806,157500,126,null,null,null,null),
		(1806,172500,138,null,null,null,null),
		(1806,187500,150,null,null,null,null),
		(1806,202500,162,null,null,null,null),
		(1806,217500,174,null,null,null,null),
		(1806,232500,186,null,null,null,null),
		(1806,247500,198,null,null,null,null),
		(1806,262500,210,null,null,null,null),
		(1806,277500,222,null,null,null,null),
		(1806,292500,234,null,null,null,null)


	---------------giving ranks based on ro_closed_date to get latest RO data
	select 
			h.ro_close_date
			,h.mileage_in
			,h.vin
			,h.cust_dms_number
			,isnull(c.daily_average_mile,40) as daily_average_mile
			,ROW_NUMBER() over (partition by h.vin,h.cust_dms_number order by h.ro_close_date desc) as rkn
			,h.parent_dealer_id
		into #roh
	from master.repair_order_header h (nolock) 
		inner join master.customer c (nolock) on h.master_customer_id =c.master_customer_id
		inner join master.cust_2_vehicle cv (nolock) on cv.master_customer_id =c.master_customer_id
	where h.parent_dealer_id =@dealer_id 
		and ro_close_date is not null 
		and isnull(h.is_deleted,0)=0 and isnull(c.is_deleted,0)=0 and isnull(cv.is_deleted,0)=0
	order by cv.vin,ro_close_date

	--------next service date calculation based on  mileage_in and daily_avg_mileage

			-----considering miles ranges which are greater than vehicle mileage and giving them ranks with least miles as rnk=1
	select 
			ro_close_date
			,mileage_in
			,g.general_service_miles as miles
			,vin
			,cust_dms_number
			,daily_average_mile
			,ROW_NUMBER() over(partition by vin,cust_dms_number order by general_service_miles) as rnk
			,c.parent_dealer_id
		into #com1

	from #roh c inner join #maintenance_schedule g  on c.mileage_in <= g.general_service_miles
	where rkn =1
	order by vin, cust_dms_number

				------calculating next service date depending on mileage and daily_average_mile
	select 
			vin
			,cust_dms_number
			,ro_close_date
			,daily_average_mile
			,mileage_in
			,miles
			,miles-mileage_in as mile_margin
			,(miles -mileage_in)/daily_average_mile as days_ser
			,dateadd(day,(miles - mileage_in)/daily_average_mile , convert(date,convert(varchar(8),ro_close_date))) as nxt_service_date
			,parent_dealer_id
		into #nxt_service_miles
	from #com1 
	where rnk =1
	order by vin,cust_dms_number

	----------------- nxt_service_date from sales data
	select 
			vin
			,cust_dms_number
			,purchase_date
			,datediff(month,convert(date,convert(char(8),s.purchase_date)),getdate()) as months_purchased
			,g.general_service_months as months
			,ROW_NUMBER() over(partition by vin,cust_dms_number order by purchase_date) as rnk
			,s.parent_dealer_id
		into #com2
	from master.fi_sales s (nolock) 
		inner join #maintenance_schedule g on datediff(month,convert(date,convert(char(8),s.purchase_date)),getdate()) < = g.general_service_months
	where s.parent_dealer_id =@dealer_id and deal_status in ('Sold','Finalized')
	order by vin, cust_dms_number

	select
			vin
			,cust_dms_number
			,purchase_date
			,months_purchased
			,months
			,rnk
			,dateadd(month,months,convert(date,convert(char(8),purchase_date))) as nxt_service_sales
			,parent_dealer_id
		into #nxt_service_sales
	from #com2
	where rnk =1 
	order by vin, cust_dms_number

	select
			 m.vin
			,m.cust_dms_number
			,m.ro_close_date
			,m.mileage_in
			,m.miles
			,m.daily_average_mile
			,m.mile_margin
			,m.days_ser
			,m.nxt_service_date
			,s.purchase_date
			,s.months_purchased
			,s.months
			,s.nxt_service_sales
			,(case when m.nxt_service_date <= isnull(s.nxt_service_sales,m.nxt_service_date) then m.nxt_service_date else s.nxt_service_sales end) as nxt_dt
			,(case when m.nxt_service_date <= isnull(s.nxt_service_sales,m.nxt_service_date) then 'service' else 'sales' end) as updated_from
			,m.parent_dealer_id
		into #result
	from #nxt_service_miles m left outer join #nxt_service_sales s on m.vin =s.vin and m.cust_dms_number =s.cust_dms_number

	---validating data
	--where s.nxt_service_sales >getdate() and m.nxt_service_date >getdate()

	--select * from #result where updated_from='sale' order by vin, cust_dms_number

	--select * from #result   where vin ='SHHFK7G42JU206007' order by vin,cust_dms_number
	--select * from #result   where vin ='19UUA66255A061180' order by vin,cust_dms_number
	--select * from #result   where vin ='19XFB2F55CE334071' order by vin,cust_dms_number

	--select * from master.fi_sales (nolock) where vin ='19XFB2F55CE334071' order by purchase_date desc
	--select cust_dms_number,vin,ro_close_date,mileage_in,* from master.repair_order_header h (nolock) where vin ='19XFB2F55CE334071' order by h.ro_close_date desc

	--select cust_dms_number,vin,ro_close_date,mileage_in,* from master.repair_order_header h (nolock) where vin ='SHHFK7G42JU206007' and cust_dms_number in ('064803','1002268','USEINV0002') order by h.ro_close_date desc

	--select * from master.fi_sales (nolock) where vin ='19UUA66255A061180' order by purchase_date desc
	--select cust_dms_number,vin,ro_close_date,mileage_in,* from master.repair_order_header h (nolock) where vin ='19UUA66255A061180'  order by h.ro_close_date desc

	--select vin from #result group by vin having count(vin)>1

	--select * from #nxt_service_sales order by nxt_service_sales
	--select * from #nxt_service_miles order by nxt_service_date

	--select count(*) from #result where updated_from ='service'

	--select distinct deal_status from master.fi_sales (nolock) where parent_dealer_id=681

	--return;
	--	select a.next_service_date,b.nxt_dt
	--from master.cust_2_vehicle a inner join #result b on a.vin =b.vin and a.cust_dms_number =b.cust_dms_number and a.parent_dealer_id=b.parent_dealer_id

	update a set a.next_service_date=b.nxt_dt
	from master.cust_2_vehicle a inner join #result b on a.vin =b.vin and a.cust_dms_number =b.cust_dms_number and a.parent_dealer_id=b.parent_dealer_id


	
end
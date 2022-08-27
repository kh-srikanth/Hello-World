
USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [dbo].[Master_cust_veh_inactiveupadte]    Script Date: 7/12/2021 1:14:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [master].[risk_level_update_cust_2_vehicle]

--declare 
@file_process_id int

/*
-----------------------------------------------------------------------  
	Copyright 2021 Clictell

	PURPOSE  
	Update pred_risk, decile, risk_level columns in cust_2_vehicle table

	PROCESSES  

	MODIFICATIONS  
	Date			Author		Work Tracker Id		Description    
	------------------------------------------------------------------------  
	22/07/2021		Srikanth.K	Created				Calculate the customer defection risk level
	------------------------------------------------------------------------


*/

as
begin



IF OBJECT_ID('tempdb..#vehicle') IS NOT NULL DROP TABLE #vehicle
IF OBJECT_ID('tempdb..#customer') IS NOT NULL DROP TABLE #customer
IF OBJECT_ID('tempdb..#roh') IS NOT NULL DROP TABLE #roh
IF OBJECT_ID('tempdb..#last_ro') IS NOT NULL DROP TABLE #last_ro
IF OBJECT_ID('tempdb..#last_ro_data') IS NOT NULL DROP TABLE #last_ro_data
IF OBJECT_ID('tempdb..#prior_ro_data') IS NOT NULL DROP TABLE #prior_ro_data
IF OBJECT_ID('tempdb..#cust_2_veh_update') IS NOT NULL DROP TABLE #cust_2_veh_update
IF OBJECT_ID('tempdb..#cust_2_veh_risk_pred') IS NOT NULL DROP TABLE #cust_2_veh_risk_pred
IF OBJECT_ID('tempdb..#risk_level') IS NOT NULL DROP TABLE #risk_level

---------joining cust_2_vehicle and vehicle tables to get vehicle data
select --88,550/50,194
		cv.parent_dealer_id
		,cv.cust_vehicle_id
		,cv.master_vehicle_id
		,cv.master_customer_id
		,make
		,model_year

	into #vehicle
from master.cust_2_vehicle cv (nolock)
inner join master.vehicle v (nolock) on cv.master_vehicle_id =v.master_vehicle_id and cv.parent_dealer_id=v.parent_dealer_id
where isnull(cv.is_deleted,0)=0 and isnull(v.is_deleted,0)=0 --and cv.parent_dealer_id=1806
		and cv.file_process_id =@file_process_id

-----------joining cust_2_vehicle and customer table to get customer data
select --50,194
		cv.parent_dealer_id
		,cv.cust_vehicle_id
		,cv.master_customer_id
		,cust_do_not_call
		,cust_do_not_email
		,cust_do_not_mail
		,cust_miles_distance
		,daily_average_mile
	into #customer
from master.cust_2_vehicle cv (nolock)
inner join master.customer c(nolock) on cv.master_customer_id = c.master_customer_id and cv.parent_dealer_id=c.parent_dealer_id
where isnull(cv.is_deleted,0)=0 and isnull(c.is_deleted,0)=0 --and cv.parent_dealer_id=1806
		and cv.file_process_id =@file_process_id
---------------joining cust_2_vehicle and repair_order_header to get RO data into #roh table
select 
		cv.parent_dealer_id
		,cv.cust_vehicle_id
		,cv.master_customer_id
		,cv.master_vehicle_id
		,mileage_in
		,total_repair_order_price
		,ro_close_date
	into #roh	
from master.cust_2_vehicle cv (nolock)
inner join master.repair_order_header r (nolock) 
			on cv.master_customer_id =r.master_customer_id 
			and cv.master_vehicle_id =r.master_vehicle_id 
			and cv.parent_dealer_id=r.parent_dealer_id
where isnull(cv.is_deleted,0)=0 and isnull(r.is_deleted,0)=0 --and cv.parent_dealer_id=1806
		and cv.file_process_id =@file_process_id

--select count(distinct cust_vehicle_id) from #roh  --38913

-------------------finding last RO 
select 
		parent_dealer_id
		,cust_vehicle_id
		,max(ro_close_date) as last_ro_date
into #last_ro
from #roh 
group by parent_dealer_id,cust_vehicle_id
order by cust_vehicle_id

--------------Extracting data for last RO
select 
		r.parent_dealer_id
		,r.cust_vehicle_id
		,mileage_in
		,total_repair_order_price
		,ro_close_date
		,last_ro_date
	into #last_ro_data
from #roh r inner join  #last_ro o on r.parent_dealer_id=o.parent_dealer_id and r.cust_vehicle_id=o.cust_vehicle_id and r.ro_close_date=o.last_ro_date

order by r.cust_vehicle_id

--------Extracting data for  ROs Prior to last_ro
select
		r.parent_dealer_id
		,r.cust_vehicle_id
		,count(ro_close_date) as prior_ros
		,sum(total_repair_order_price) as tot_cost
	into #prior_ro_data
from #roh r left outer join #last_ro o on r.parent_dealer_id=o.parent_dealer_id and r.cust_vehicle_id=o.cust_vehicle_id
where r.ro_close_date <> o.last_ro_date
group by r.parent_dealer_id,r.cust_vehicle_id


--select * from #prior_ro_data where cust_vehicle_id=69637
--select * from #roh where cust_vehicle_id=69637

----------------- Joining all the temp tables to get the final update temp table
select
		c.parent_dealer_id
		,c.cust_vehicle_id
		,isnull(lr.mileage_in,0) as mileage_in
		,isnull(lr.total_repair_order_price,0) as total_repair_order_price
		,iif(v.make='HONDA',1,0) as makex
		,v.model_year
		,isnull(c.cust_do_not_call,0) as cust_do_not_call
		,isnull(c.cust_do_not_email,0) as cust_do_not_email
		,isnull(c.cust_do_not_mail,0) as cust_do_not_mail
		,isnull(c.cust_miles_distance,0) as cust_miles_distance
		,iif(c.cust_miles_distance>100,1,0) as long_distance
		,isnull(c.daily_average_mile,40) as DAILY_AVERAGE_MILE       ----------taking 40 if null
		,isnull(pr.prior_ros,0) as prior_ros
		,isnull(pr.tot_cost,0) as tot_cost
	into #cust_2_veh_update
from #customer c inner join #vehicle v on c.parent_dealer_id=v.parent_dealer_id and c.cust_vehicle_id=v.cust_vehicle_id
left outer join #last_ro_data lr on  c.parent_dealer_id=lr.parent_dealer_id and c.cust_vehicle_id=lr.cust_vehicle_id
left outer join #prior_ro_data pr on c.parent_dealer_id=pr.parent_dealer_id and c.cust_vehicle_id=pr.cust_vehicle_id

select 

		parent_dealer_id
		,cust_vehicle_id
		,mileage_in
		,total_repair_order_price
		,makex
		,model_year
		,cust_do_not_call
		,cust_do_not_email
		,cust_do_not_mail
		,cust_miles_distance
		,long_distance
		,DAILY_AVERAGE_MILE
		,prior_ros
		,tot_cost
		,1 / (1 + exp(
				-(351.199268700178
				-3.44671201491825E-06*cast(MILEAGE_IN as int)
				-3.69709233666388E-06*cast(TOTAL_REPAIR_ORDER_PRICE as decimal(18,2))
				-8.89807206090177E-02*cast(MAKEX as int)
				-0.174648592731505*cast(MODEL_YEAR as int)
				+2.6025809001233*cast(CUST_DO_NOT_CALL as int)
				-1.37228704879033*cast(CUST_DO_NOT_EMAIL as int)
				+0.38990209767191*cast(CUST_DO_NOT_MAIL as int)
				-7.65013079425711E-07*cast(CUST_MILES_DISTANCE as int)
				+0.920091952763274*cast(LONG_DISTANCE as int)
				+5.10436870935915E-02*cast(DAILY_AVERAGE_MILE as int)
				-0.1570601835013*cast(PRIOR_ROS as int)
				-4.79847840450587E-04*cast(TOT_COST as decimal(18,2))))) as pred_high_risk

	into #cust_2_veh_risk_pred

from #cust_2_veh_update


select 
		parent_dealer_id
		,cust_vehicle_id
		,mileage_in
		,total_repair_order_price
		,makex
		,model_year
		,cust_do_not_call
		,cust_do_not_email
		,cust_do_not_mail
		,cust_miles_distance
		,long_distance
		,DAILY_AVERAGE_MILE
		,prior_ros
		,tot_cost
		,round(pred_high_risk,2) as pred_risk
		,(case when pred_high_risk between 0.0 and 0.26 then 10
			when pred_high_risk between 0.26 and 0.34 then 9
			when pred_high_risk between 0.34 and 0.42 then 8
			when pred_high_risk between 0.42 and 0.50 then 7
			when pred_high_risk between 0.50 and 0.58 then 6
			when pred_high_risk between 0.58 and 0.63 then 5
			when pred_high_risk between 0.63 and 0.65 then 4
			when pred_high_risk between 0.65 and 0.72 then 3
			when pred_high_risk between 0.72 and 0.82 then 2
			when pred_high_risk between 0.82 and 1.00 then 1
			else convert(int,pred_high_risk) end ) as decile

		,(case when pred_high_risk between 0.0 and 0.26 then 'Low Risk'
			when pred_high_risk between 0.26 and 0.34 then 'Low Risk'
			when pred_high_risk between 0.34 and 0.42 then 'Low Risk'
			when pred_high_risk between 0.42 and 0.50 then 'Mod Risk'
			when pred_high_risk between 0.50 and 0.58 then 'Mod Risk'
			when pred_high_risk between 0.58 and 0.63 then 'Mod Risk'
			when pred_high_risk between 0.63 and 0.65 then 'High Risk'
			when pred_high_risk between 0.65 and 0.72 then 'High Risk'
			when pred_high_risk between 0.72 and 0.82 then 'High Risk'
			when pred_high_risk between 0.82 and 1.00 then 'High Risk'
			else convert(varchar,pred_high_risk) end ) as risk_level

	into #risk_level

from #cust_2_veh_risk_pred 

--select * from #risk_level order by risk_level,decile,pred_risk
--select distinct risk_level,count(*) from #risk_level group by risk_level

 update cv set 
		 cv.pred_risk = r.pred_risk
		,cv.decile = r.decile
		,cv.risk_level =r.risk_level
 from master.cust_2_vehicle cv (nolock) 
		inner join #risk_level r 
			on cv.parent_dealer_id=r.parent_dealer_id 
			and cv.cust_vehicle_id =r.cust_vehicle_id




END

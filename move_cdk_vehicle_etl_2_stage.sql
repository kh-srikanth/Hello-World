USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [etl].[move_cdk_vehicles_etl_2_stage]    Script Date: 8/31/2021 2:45:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 
 ALTER procedure  [etl].[move_cdk_vehicles_etl_2_stage]   
  
  @file_process_id int

as 
/*

-----------------------------------------------------------------------  
	Copyright 2021 Clictell

	PURPOSE  
	Loading Vehicle data from etl to Stage from CDK Source(Sales, Service and Service Appointments)

	PROCESSES  

	MODIFICATIONS  
	----------------------------------------------------------------------------------------------------  
	Date			Author		Work Tracker Id   Description    
	----------------------------------------------------------------------------------------------------  
	02/15/2021		Santhosh	Created				Loading Vehicle data from etl to Stage from CDK Source(Sales, Service and Service Appointments)
	----------------------------------------------------------------------------------------------------  

	exec [etl].[move_cdk_vehicles_etl_2_stage] 1047
----------------------------------------------------------------------------------------------------  
*/  
begin 


	Create table #vehicle_insert
	( 
			 veh_insert_id int identity(1,1)
			,natural_key varchar(50)
			,parent_dealer_id int
			,cust_dms_number varchar(250)
			,customer_id  varchar(250)
			,vin varchar(20)
			,vin_pattern varchar(15)
			,make varchar(100)
			,model varchar(250)
			,model_no varchar(50)
			,model_year varchar(10)
			,transmission varchar(250)
			,ext_clr_code varchar(500)
			,body_type varchar(500)
			,vehicle_color varchar(50)
			,vehicle_mileage int
			,file_process_id int
			,file_process_detail_id int
			,new_used varchar(500)
	)

print 'Insert from stg.service_appts'
	insert into #vehicle_insert
	( 
			 natural_key
			,parent_dealer_id
			,cust_dms_number
			,customer_id
			,vin
			,vin_pattern
			,make
			,model
			--,model_no
			,model_year
			--,transmission
			,vehicle_mileage
			,file_process_id
			,file_process_detail_id
	)		

	select 
			 natural_key		
			,parent_dealer_id
			,cust_dms_number
			,cust_dms_number
			,VIN
			,left(vin,8)+' '+ substring(vin,len(vin)/2+2,1)
			,Make
			,model_desc
			--,nofModel
			,year
			--,TransType
			,OdomReading
			,file_process_id
			,file_process_detail_id
	from stg.service_appts a with(nolock) 
	where 
		a.file_process_id = @file_process_id


print 'Insert from stg.fi_sales'
	insert into #vehicle_insert 
	( 
			 natural_key
			,parent_dealer_id
			,cust_dms_number
			,customer_id
			,vin
			,vin_pattern
			,make
			,model
			,model_no
			,model_year
			,body_type
			,vehicle_color
			,vehicle_mileage
			,file_process_id
			,file_process_detail_id
			,ext_clr_code
			,new_used
	)
	select 
			 c.natural_key
			,c.parent_dealer_id
			,buyer_id as cust_dms_number
			,customer_id
			,VIN
			,left(vin,8)+' '+ substring(vin,len(vin)/2+2,1)
			,Make
			,Model
			,model_num
			,model_year
			,body_descr
			,ext_clr_code
			,mileage_in
			,file_process_id
			,file_process_detail_id
			,ext_clr_code
			,nuo_flag
	from stg.fi_sales a with(nolock)
		inner join master.dealer c with(nolock) on 
			a.natural_key = c.natural_key
	where 
		a.file_process_id = @file_process_id
	

print 'Insert from stg.service_ro_header'
	insert into #vehicle_insert 
	( 
			 natural_key
			,parent_dealer_id
			,cust_dms_number
			,customer_id
			,vin
			,vin_pattern
			,make
			,model
			,model_year
			,transmission
			,vehicle_color
			,vehicle_mileage
			,ext_clr_code
			,file_process_id
			,file_process_detail_id
	) 
	select 
			 c.natural_key
			,c.parent_dealer_id
			,cust_dms_number
			,cust_dms_number
			,VIN
			,left(vin,8)+' '+ substring(vin,len(vin)/2+2,1)
			,Make
			,Model
			,Year
			,TransactionType
			,ext_clr_desc
			,Mileage_Out
			,ext_clr_desc
			,file_process_id
			,file_process_detail_id
	from stg.service_ro_header a with(nolock) 
		inner join master.dealer c with(nolock) on 
			a.natural_key = c.natural_key
	where 
		a.file_process_id = @file_process_id 



--------------------------------------updating missing make & models from sales & service ---------------------------------------------------------------------------
 --   update 
	--    vr 
	--set 
	--	vr.make = rr.make,
	--	vr.model = rr.model, 
	--	vr.model_year = rr.year
	--	--vr.last_ro_mileage = rr.mileage_out 
 --   from
	--    #vehicle_insert vr 
 --   inner join stg.repair_order_detail rr with(nolock) on 
	--	vr.vin = rr.vin	
 --   where 	    
	--	1 = 1	   
	--	and vr.make = '' or vr.make is null 
	--	and vr.model = '' or vr.model is null 
	--	and vr.model_year = '' or vr.model_year is null		

print 'Update Make Model from stg.fi_sales'
	update 
		vr 
	set 
	    vr.make = fs.make, 
		vr.model = fs.model, 
		vr.model_year = fs.model_year,
		vr.body_type = fs.body_descr

	from
	    #vehicle_insert vr 
    inner join stg.fi_sales fs with(nolock) on 
		vr.vin = fs.vin	 
    where 
		1 = 1	    
		and vr.make = '' or vr.make is null 
		and vr.model = '' or vr.model is null 
		and vr.model_year = '' or vr.model_year is null

-----------------------------------------------------Rank to get distinct/unique vehicles to avoid duplicate --------------------------------------------
print 'Ranking the records based on Mileage,veh_insert_id'
	select 
			 natural_key 
			,parent_dealer_id 
			,cust_dms_number 
			,customer_id  
			,vin 
			,vin_pattern 
			,make 
			,model 
			,model_no 
			,model_year 
			,transmission 
			,ext_clr_code 
			,body_type 
			,vehicle_color 
			,vehicle_mileage 
			,file_process_id 
			,file_process_detail_id
			,new_used 
			,row_number() over(partition by vin,natural_key order by vehicle_mileage desc ,veh_insert_id desc ) as rnk
	into #vehicle_rnk 
	from #vehicle_insert 

	print 'Insert into Stg.vehicle from Temp tables'		

	insert into stg.vehicle 
	( 
			 natural_key 
			,parent_dealer_id 
			,cust_dms_number 
			,customer_id  
			,vin 
			,vin_pattern 
			,make 
			,model 
			,model_no 
			,model_year 
			,transmission 
			,ext_clr_code 
			,body_type 
			,vehicle_color 
			,vehicle_mileage 
			,file_process_id 
			,file_process_detail_id 
			,new_used
			--,vehicle_type
	) 
	select 
			 a.natural_key 
			,a.parent_dealer_id 
			,a.cust_dms_number 
			,a.customer_id  
			,a.vin 
			,a.vin_pattern 
			,a.make 
			,a.model 
			,a.model_no 
			,a.model_year 
			,a.transmission 
			,a.ext_clr_code 
			,a.body_type 
			,a.vehicle_color 
			,a.vehicle_mileage 
			,a.file_process_id 
			,a.file_process_detail_id 
			,a.new_used
			--,a.new_used
	from #vehicle_rnk a 
	left join stg.vehicle b with(nolock) on 
		a.vin = b.vin and 
		a.parent_dealer_id = b.parent_dealer_id
	where a.rnk =1

print 'Update Invalid VIN column'
		   update a
			set a.invalid_vin = 1
		from
			stg.vehicle a
		where 
			len(a.vin)<>17 and
			file_process_id = @file_process_id



  drop table #vehicle_insert ,#vehicle_rnk

end



		










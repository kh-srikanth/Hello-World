USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [stg].[move_vehicles_etl_2_stage]    Script Date: 1/19/2021 1:54:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
  ALTER procedure  [stg].[move_vehicles_etl_2_stage]   
  
  @file_log_id int

as 
/*
	exec [stg].[move_vehicles_etl_2_stage]  139
-----------------------------------------------------------------------  

	PURPOSE  
	To split vehicles data from vehicle, sales,service & service appointment customers based on etl

	PROCESSES  

	MODIFICATIONS  
	Date			Author    Work Tracker Id   Description    
	----------------------------------------------------------------------------------------------------  

	-----------------------------------------------------------------------------------------------------
	*/  

begin


	create table #vehicle_insert 
	(
	     vech_insert_id int identity 
		,natural_key nvarchar(50)
		,parent_dealer_id int		
		,vin varchar(25) 
		,vin_pattern varchar(10) 
		,make varchar(100)   
		,model varchar(250)   
		,model_year varchar(10)   
		,body_type varchar(50)   
		,cylinders varchar(20)   
		,transmission varchar(100)   
		,fuel_type varchar (50)   
		,engine_type varchar(50)   
		,engine_size varchar(50)   
		,engine_number varchar(50)   
		,engine_desc varchar(50)   
		,vehicle_trim varchar(50)   
		,vehicle_type varchar(50)   
		,vehicle_weight varchar(10)   
		,vehicle_color varchar(50)   
		,drive_train varchar(50)   
		,ext_svc_contract_num varchar(50)    
		,ext_svc_contract_name varchar(250)   
		,ext_svc_contract_exp_date int    
		,ext_svc_contract_exp_mileage int    
		,warr_term varchar (50)   
		,warr_miles int    
		,vehicle_mileage int		    
		,last_ro_mileage int    
		,last_ro_dt int 
		,purchase_date int 
		,last_sale_mileage int  
		,vehicle_prod_date int 		 
		,job_log_id int
		,is_file_stat int
		,license_plat_num varchar(50)
        ,four_wd varchar(3)
        ,front_wd varchar(3)
        ,gm_cert varchar(3)
        ,exterior_color_desc varchar(800)
        ,model_no varchar(50)		       
        ,int_color_desc varchar(800)
        ,car_line varchar(800)
		,car_line_desc varchar(8000)
        ,accent_color varchar(100)		 	
		,file_log_detail_id int	
		,model_score_100 int
		,model_score_110 int
		,model_score_200 int
		,model_score_550 int
		,model_score_555 int
		,model_score_650 int
    	)
	
		

	-- Loading vehicles info from RO File
	insert into #vehicle_insert
	  (
          
		 natural_key
		,parent_dealer_id              
        ,vin  
        ,vin_pattern 
        ,make    
        ,model        
        ,model_year      
        ,body_type        
        ,cylinders      
        ,transmission  
        ,fuel_type  
        ,engine_type            
        ,engine_size            
        ,engine_number            
        ,engine_desc            
        ,vehicle_trim            
        ,vehicle_type            
        ,vehicle_weight            
        ,vehicle_color            
        ,drive_train            
        ,ext_svc_contract_num              
        ,ext_svc_contract_name            
        ,ext_svc_contract_exp_date        
        ,ext_svc_contract_exp_mileage          
        ,warr_term     
        ,warr_miles          
        ,vehicle_mileage  
        ,last_ro_mileage          
        ,last_ro_dt    
        ,purchase_date    
        ,last_sale_mileage      
        ,vehicle_prod_date    
        ,job_log_id  
        ,is_file_stat  
        ,license_plat_num      
        ,four_wd  
        ,front_wd  
        ,gm_cert 
        ,exterior_color_desc      
        ,model_no                    
        ,int_color_desc      
        ,car_line      
        ,car_line_desc 
		,file_log_detail_id
		,model_score_100 
		,model_score_110 
		,model_score_200 
		,model_score_550 
		,model_score_555 
		,model_score_650 
	  )
	     
	select distinct 
		natural_key
	   ,parent_Dealer_id        
       ,vin
       ,left(vin,8)+' '+ substring(vin,len(vin)/2+2,1) as vin_pattern
       ,make
       ,model
       --,iif(len(year) = 1 , iif(year ='' , null , year) , iif(year ='' , null , year(year)))
	   ,iif(len(year) != 4 , iif(year ='' , null , year) , iif(year ='' , null , year(year)))
       ,null
       ,null
       ,transmission_desc
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,ext_svc_contract_number
       ,ext_svc_contract_name
       ,ext_svc_contract_exp_date
       ,replace(ext_svc_contract_exp_mileage,'.0','')
       ,null
       ,null
       ,replace(delivery_odometer,'.0','')
       ,replace(last_roo_dom,'.0','')
       ,convert(varchar(8),cast(last_ro_date as date),112) as last_ro_date
       ,null
       ,null
       ,null
       ,file_log_id
       ,1
       ,cust_lic_no
       ,null
       ,null
       ,null
       ,ext_clr_desc
       ,model_maint_code
       ,int_clr_desc
       ,carline
       ,carline_desc
	   ,file_load_detail_id
	   ,iif(ascii(replace(replace(replace(Model_Score_100,'.00',''),'.',''),'#','')) in (13,32),'0',replace(replace(replace(Model_Score_100,'.00',''),'.',''),'#','')) as Model_Score_100
	   ,iif(ascii(replace(replace(replace(Model_Score_110,'.00',''),'.',''),'#','')) in (13,32),'0',replace(replace(replace(Model_Score_110,'.00',''),'.',''),'#','')) as Model_Score_110
	   ,iif(ascii(replace(replace(replace(Model_Score_200,'.00',''),'.',''),'#','')) in (13,32),'0',replace(replace(replace(Model_Score_200,'.00',''),'.',''),'#','')) as Model_Score_200
	   ,iif(ascii(replace(replace(replace(Model_Score_550,'.00',''),'.',''),'#','')) in (13,32),'0',replace(replace(replace(Model_Score_550,'.00',''),'.',''),'#','')) as Model_Score_550
	   ,iif(ascii(replace(replace(replace(Model_Score_555,'.00',''),'.',''),'#','')) in (13,32),'0',replace(replace(replace(Model_Score_555,'.00',''),'.',''),'#','')) as Model_Score_555
	   ,replace( replace(replace(replace(replace(isnull(model_score_650,0),'.00',''),'.0',''),'.',''),'#',''),
        char(ascii(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(model_score_650,1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,'')
        ,9,''),0,''))),'')  as Model_Score_650

	  from 
	    stg.repair_order_detail ro with(nolock)
	  where --natural_key = '4500416'
		ro.file_log_id=@file_log_id
		
		
			

	-- Loading vehicles info from FI File
	insert into #vehicle_insert
	  (
		    
		    natural_key
		   ,parent_Dealer_id                
           ,vin 
           ,vin_pattern
           ,make    
           ,model    
           ,model_year   
           ,body_type    
           ,cylinders   
           ,transmission   
           ,fuel_type 
           ,engine_type    
           ,engine_size    
           ,engine_number    
           ,engine_desc    
           ,vehicle_trim    
           ,vehicle_type    
           ,vehicle_weight   
           ,vehicle_color    
           ,drive_train    
           ,ext_svc_contract_num     
           ,ext_svc_contract_name  
           ,ext_svc_contract_exp_date     
           ,ext_svc_contract_exp_mileage     
           ,warr_term    
           ,warr_miles     
           ,vehicle_mileage 
           ,last_ro_mileage     
           ,last_ro_dt  
           ,purchase_date  
           ,last_sale_mileage   
           ,vehicle_prod_date  
           ,job_log_id 
           ,is_file_stat 
           ,license_plat_num 
           ,four_wd 
           ,front_wd 
           ,gm_cert 
           ,exterior_color_desc 
           ,model_no        
           ,int_color_desc 
           ,car_line
           ,car_line_desc
           ,accent_color 
		   ,file_log_detail_id
		   ,Model_Score_100
		   ,Model_Score_110
		   ,Model_Score_200
		   ,Model_Score_550
		   ,Model_Score_555
		   ,Model_Score_650
	  )
	     
	select distinct
			 
			 natural_key
			,parent_dealer_id            
            ,vin
            ,left(vin,8)+' '+ substring(vin,len(vin)/2+2,1) as vin_pattern
            ,make
            ,model
            ,year(model_year)
            ,body_descr
            ,no_of_cycle
            ,transmission_desc
            ,iif(fuel_type = 'G','GAS',fuel_type)
            ,null
            ,null
            ,null
            ,engine_descr
            ,trim
            ,veh_class
            ,null
            ,accent_clr
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,replace(replace(replace(delivery_odometer,'.0','') , '.7',''),'.6','')
            ,null
            ,null
            ,convert(varchar(8),cast(purchase_date as date),112) as purchase_date			
            ,replace(replace(replace(delivery_odometer,'.0','') , '.7',''),'.6','')
            ,convert(varchar(8),cast(inventory_date as date),112) as inventory_date
            ,file_log_id
            ,2
            ,license_num
            ,four_wheel_drive
            ,front_wheel_drive
            ,gm_cert
            ,ext_clr_desc
            ,model_num
            ,int_clr_desc
            ,car_line
            ,null
            ,accent_clr
			,file_log_detail_id
			,iif(ascii(replace(replace(replace(Model_Score_100,'.00',''),'.',''),'#','')) in (13,32),'0',replace(replace(replace(Model_Score_100,'.00',''),'.',''),'#','')) as Model_Score_100
			,iif(ascii(replace(replace(replace(Model_Score_110,'.00',''),'.',''),'#','')) in (13,32),'0',replace(replace(replace(Model_Score_110,'.00',''),'.',''),'#','')) as Model_Score_110
			,iif(ascii(replace(replace(replace(Model_Score_200,'.00',''),'.',''),'#','')) in (13,32),'0',replace(replace(replace(Model_Score_200,'.00',''),'.',''),'#','')) as Model_Score_200
			,iif(ascii(replace(replace(replace(Model_Score_550,'.00',''),'.',''),'#','')) in (13,32),'0',replace(replace(replace(Model_Score_550,'.00',''),'.',''),'#','')) as Model_Score_550
			,iif(ascii(replace(replace(replace(Model_Score_555,'.00',''),'.',''),'#','')) in (13,32),'0',replace(replace(replace(Model_Score_555,'.00',''),'.',''),'#','')) as Model_Score_555
	        ,replace( replace(replace(replace(replace(isnull(model_score_650,0),'.00',''),'.0',''),'.',''),'#',''),
             char(ascii(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(model_score_650,1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,'')
            ,9,''),0,''))),'')  as Model_Score_650

	  from 
	    stg.fi_sales fi with(nolock)		 	
	  where 	--natural_key = '4500416'   	 
		fi.file_log_id = @file_log_id
		
		



insert into #vehicle_insert
	( 
		 natural_key
		,parent_dealer_id
		--,cust_dms_number
		,vin
		,vin_pattern
		,make
		,model
		,model_year
		,vehicle_type
		,vehicle_mileage
		,exterior_color_desc
		,int_color_desc
		,license_plat_num
		,car_line
		,job_log_id
		,file_log_detail_id
		--,vehicle_type
	) 
	select distinct 
		 natural_key
		,parent_dealer_id
		--,cust_dms_number
		,vin
		,left(vin,8)+' '+ substring(vin,len(vin)/2+2,1)
		,make
		,model_desc
		,iif(len(year) = 1 , iif(year ='' , null , year) , iif(year ='' , null , year(year))) ---??
		,vehicle_type
		,OdomReading
		,ExtClrDesc
		,IntClrDesc
		,vehicle_license_plate
		,carline
		,file_log_id
		,file_log_detail_id
		--,vehicle_type
	from stg.service_appts with(nolock)
	where file_log_id = @file_log_id
	--natural_key = '101452'


		insert into #vehicle_insert
		( 
			 natural_key
			,parent_dealer_id
			,vin
			,vin_pattern
			,make
			,model
			,model_year
			,body_type
			,transmission
			,fuel_type
			,engine_number
			,vehicle_trim
			,vehicle_type
			,vehicle_color
			,vehicle_mileage
			,purchase_date
			,job_log_id
			,license_plat_num
			,exterior_color_desc
			,model_no
			,int_color_desc
			,car_line
			,accent_color
			,file_log_detail_id
			,cylinders

		)

		select distinct 
			 c.natural_key
			,c.parent_dealer_id
			,vin
			,left(vin,8)+' '+ substring(vin,len(vin)/2+2,1)
			,vehicle_make
			,model_desc
			,year(vehicle_yr)
			,body_size
			,transm
			,fuel
			,eng_no
			,trim
			,isnull(vehicle_type,VehClass)
			,ext_clr_code
			,odom_reading
			,replace(purch_date,'/','') purch_date
			,file_log_id
			,lic_no
			,ext_clr_desc
			,mdl_no
			,int_clr_desc
			,carline
			,AccentClr
			,file_log_detail_id
			,no_of_cyl
		from [etl].[kia_rci_vehicle_xml] a with(nolock) 
		inner join master.dealer_mapping b with(nolock) on 
			a.src_dealer_code = b.src_dealer_code
		inner join master.dealer c with(nolock) on 
			b.parent_dealer_id = c.parent_dealer_id
		where 
			--b.is_deleted = 1 and 
			c.is_deleted = 0 and 
			a.file_log_id = @file_log_id 


		insert into #vehicle_insert
		(
			 natural_key
			,parent_dealer_id
			,vin
			,vin_pattern
			,ext_svc_contract_num
			,ext_svc_contract_name
			,ext_svc_contract_exp_date
			,ext_svc_contract_exp_mileage
			,warr_term
			,warr_miles
			,vehicle_prod_date
			,job_log_id
			,file_log_detail_id
		) 
		select distinct 
			 b.natural_key
			,b.parent_dealer_id
			,vin
			,left(vin,8)+' '+ substring(vin,len(vin)/2+2,1)
			,sc_num
			,sc_name
			,sc_exp_date
			,sc_exp_mileage
			,warr_term
			,warr_miles
			,prod_date
			,file_log_id
			,file_log_detail_id
		from [etl].[integralink_vehicle] a with(nolock) 
		inner join master.dealer b with(nolock) on 
			a.dealer_code =  b.natural_key 
		where file_log_id = @file_log_id and oem_code = 'DD'


--------------------------------------updating missing make & models from sales & service ---------------------------------------------------------------------------
    update 
	    vr 
	set 
		vr.make = rr.make,
		vr.model = rr.model, 
		vr.model_year = rr.year,
		vr.last_ro_mileage = replace(rr.mileage_out,'.0','') 
    from
	    #vehicle_insert vr 
    inner join stg.repair_order_detail rr with(nolock) on 
		vr.vin = rr.vin	
    where 	    
		1 = 1	   
		and vr.make = '' or vr.make is null 
		and vr.model = '' or vr.model is null 
		and vr.model_year = '' or vr.model_year is null	
		and rr.file_log_id = @file_log_id	
		

	update 
		vr 
	set 
	    vr.make = fs.make, 
		vr.model = fs.model, 
		vr.model_year = fs.model_year,
		vr.body_type = fs.body_descr,
		vr.cylinders = fs.no_of_cycle,
		vr.fuel_type = fs.fuel_type,
		vr.engine_desc = fs.engine_descr,
		vr.vehicle_trim = fs.trim,
		vr.gm_cert = fs.gm_cert,
		vr.car_line = fs.car_line

	from
	    #vehicle_insert vr 
    inner join stg.fi_sales fs with(nolock) on 
		vr.vin = fs.vin	 
    where 
		1 = 1	    
		and vr.make = '' or vr.make is null 
		and vr.model = '' or vr.model is null 
		and vr.model_year = '' or vr.model_year is null
		and fs.file_log_id = @file_log_id
		

-----------------------------------------------------Rank to get distinct/unique vehicles to avoid duplicate --------------------------------------------

  	select 
		distinct			 
			 natural_key
			,parent_dealer_id 			      
			,vin   
			,vin_pattern
			,make 
			,model    
			,model_year 
			,body_type 
			,cylinders 
			,transmission  
			,fuel_type 
			,engine_type 
			,engine_size 
			,engine_number   
			,engine_desc 
			,vehicle_trim  
			,vehicle_type  
			,vehicle_weight   
			,vehicle_color   
			,drive_train 
			,ext_svc_contract_num     
			,ext_svc_contract_name 
			,ext_svc_contract_exp_date     
			,ext_svc_contract_exp_mileage   
			,warr_term   
			,warr_miles     
			,vehicle_mileage     
			,last_ro_mileage     
			,last_ro_dt
			,purchase_date 
			,last_sale_mileage 
			,vehicle_prod_date   
			,job_log_id
			,is_file_stat
			,license_plat_num
			,four_wd
			,front_wd
			,gm_cert
			,exterior_color_desc
			,model_no			
			,int_color_desc
			,car_line
			,accent_color  
			,car_line_desc
			,file_log_detail_id
			,Model_Score_100
			,Model_Score_110
			,Model_Score_200
			,Model_Score_550
			,Model_Score_555
			,Model_Score_650
			,rank()over(partition by vin,parent_dealer_id order by is_file_stat asc,vehicle_mileage desc,vech_insert_id desc) as rnk
	into 
		#vehicle_rnk 
	from 
		#vehicle_insert 

	select
	     distinct 
		a.vin,
		b.ro_number,		 
		b.parent_Dealer_id,
		convert(varchar(8),cast(ro_close_date as date),112) as ro_close_date,
		b.mileage_in,
		b.mileage_out,
		rank() over (Partition by a.vin, b.parent_dealer_id order by b.ro_open_date desc) as rnk
	into
		#last_ro_date
	from 
		#vehicle_rnk a
	inner join stg.repair_order_detail b with(nolock) on 
	 a.vin = b.vin and 	 
	 a.parent_dealer_id=b.parent_dealer_id
	where 
		rnk = 1  
		--and b.file_log_id= @file_log_id
		
	order by 1
 
---------------------------------------------Inserting into stg.vehicle from sales,service--------------------------------	

	insert into stg.vehicle
		 (
	        natural_key
		   ,parent_dealer_id         
           ,vin
		   ,vin_pattern
           ,make
           ,model
           ,model_year
           ,body_type
           ,cylinders
           ,transmission
           ,fuel_type
           ,engine_type
           ,engine_size
           ,engine_number
           ,engine_desc
           ,vehicle_trim
           ,vehicle_type
           ,vehicle_weight
           ,vehicle_color
           ,drive_train
           ,ext_svc_contract_num
           ,ext_svc_contract_name
           ,ext_svc_contract_exp_date
           ,ext_svc_contract_exp_mileage           
           ,warr_term
           ,warr_miles
           ,vehicle_mileage
           ,last_ro_mileage
           ,last_ro_date
		   ,last_sale_date
		   ,last_sale_mileage
           ,vehicle_prod_date
           ,file_log_id
		   ,license_plat_num
		   ,four_wd
		   ,front_wd
		   ,gm_cert
		   ,exterior_color_desc
		   ,model_no			
		   ,int_color_desc
		   ,car_line
		   ,carline_desc
		   ,accent_color		 
		   ,file_log_detail_id
           ,Model_Score_100
		   ,Model_Score_110
		   ,Model_Score_200
		   ,Model_Score_550
		   ,Model_Score_555
		   ,Model_Score_650
         )
	   
  select distinct      
		   vi.natural_key
		  ,vi.parent_dealer_id           
          ,vi.vin  
		  ,vi.vin_pattern
          ,vi.make 
          ,vi.model    
          ,vi.model_year 
          ,vi.body_type 
          ,vi.cylinders 
          ,vi.transmission  
          ,vi.fuel_type 
          ,vi.engine_type 
          ,vi.engine_size 
          ,vi.engine_number   
          ,vi.engine_desc 
          ,vi.vehicle_trim  
          ,vi.vehicle_type  
          ,vi.vehicle_weight   
          ,vi.vehicle_color   
          ,vi.drive_train 
          ,vi.ext_svc_contract_num     
          ,vi.ext_svc_contract_name 
          ,vi.ext_svc_contract_exp_date     
          ,vi.ext_svc_contract_exp_mileage   
          ,vi.warr_term   
          ,vi.warr_miles     
          ,vi.vehicle_mileage     
          ,vi.last_ro_mileage     
          ,vi.last_ro_dt   
		  ,vi.purchase_date
		  ,vi.last_sale_mileage  
          ,vi.vehicle_prod_date     
          ,vi.job_log_id 
		  ,vi.license_plat_num
		  ,vi.four_wd
		  ,vi.front_wd
		  ,vi.gm_cert
		  ,vi.exterior_color_desc
		  ,vi.model_no		  
		  ,vi.int_color_desc
		  ,vi.car_line
		  ,vi.car_line_desc
		  ,vi.accent_color		 
		  ,vi.file_log_detail_id 
		  ,vi.Model_Score_100
		  ,vi.Model_Score_110
		  ,vi.Model_Score_200
		  ,vi.Model_Score_550
		  ,vi.Model_Score_555
		  ,vi.Model_Score_650         
	from 
	    #vehicle_rnk vi 
		 left outer join stg.vehicle mcs with(nolock) on 
		  vi.vin = mcs.vin and 
		 vi.parent_Dealer_id=mcs.parent_Dealer_id
	where 
	   mcs.vin is null and vi.rnk = 1
	   
---------------------------------------------Updating Last RO Date and Last RO Mileage--------------------------------	
 
	Update 
		a
	set
		a.last_ro_date = ro_close_date,
		a.last_ro_mileage = replace(mileage_out,'.0','')
	from
		stg.vehicle a
	inner join #last_ro_date b on 
		a.vin = b.vin and 		 
		a.parent_dealer_id=b.parent_dealer_id
	where b.rnk = 1 and a.file_log_id = @file_log_id
	
 ---------------------------------------------Updating last sale date and Last sale Mileage--------------------------------	
 	Update 
		a
	set

		a.last_sale_date =  b.purchase_date,
		a.last_sale_mileage = replace(b.last_sale_mileage,'.0','')
			
	from
		stg.vehicle a
	inner join #vehicle_rnk b on 
		a.vin = b.vin and 		 
		a.parent_Dealer_id=b.parent_Dealer_id
	where b.rnk = 1 and 
	a.file_log_id = @file_log_id
	

---------------------------------------------------------------updating invalid_vin-----------------------------------------
	   update a
			set a.invalid_vin = 1
		from
			stg.vehicle a
		where 
			(len(a.vin)<>17 or
			isnumeric(a.vin) = 1) and
			file_log_id = @file_log_id
			


		drop table #vehicle_rnk
		drop table #vehicle_insert
		drop table #last_ro_date
	 

end




USE [clictell_auto_etl]

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
select * from #vehicle_insert;	
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
       ,iif(len(year) = 1 , iif(year ='' , null , year) , iif(year ='' , null , year(year)))
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
		ro.file_log_id=1
		drop table #vehicle_insert


	--create table testtable(yr1 varchar(10))
	--declare @yr varchar(10) =21;
	--insert into testtable (yr1) values 
	--(CASE  
	--	when @yr >50 and @yr <100 then year('19'+@yr)
	--	WHEN @yr <10 THEN year('200'+@yr)
	--	when @yr > = 10 and @yr <=right(year(GETDATE()),2) then year('20'+@yr)
	--	else @yr
	--end)
	--select * from testtable
	
	--delete testtable

	--select right(year(GETDATE()),2)
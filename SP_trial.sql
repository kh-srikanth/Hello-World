use clictell_auto_etl
drop table #customer_insert
create table #customer_insert 
	(
          cust_insert_id int identity
		 ,parent_dealer_id int
		 ,natural_key varchar(50)  
		 ,src_dealer_code varchar(50) 
         ,customer_id bigint        
         ,cust_dms_number varchar(250)   
         ,cust_salutation_text varchar(50)   
         ,cust_full_name varchar(250)   
         ,cust_first_name varchar(250)   
         ,cust_middle_name varchar(250)   
         ,cust_last_name varchar(250)   
         ,cust_suffix varchar(50)   
         ,cust_address1 varchar(250)   
         ,cust_address2 varchar(250)   
         ,cust_city varchar(250)   
         ,cust_county varchar(250)
         ,cust_district varchar(250)
         ,cust_region  varchar(250)
         ,cust_country  varchar(250)
         ,cust_state_code varchar(250)   
         ,cust_zip_code varchar(50)   
         ,cust_zipcode varchar(50)
         ,cust_mobile_phone varchar(50)   
         ,cust_home_phone varchar(50)   
         ,cust_home_phone_ext varchar(50)
         ,cust_home_ph_country_code varchar(50)
         ,cust_work_phone varchar(50)   
         ,cust_work_phone_ext varchar(50)
         ,cust_work_ph_country_code varchar(50)
         ,cust_email_address1 varchar(250)   
         ,cust_email_address2 varchar(250)   
         ,cust_birth_date date
         ,cust_birth_type varchar(50)
         ,cust_status varchar(50)
         ,cust_gender varchar(50)   
         ,customer_type varchar(50)
         ,cust_driver_type  varchar(50)
         ,cust_occupation_id int    
         ,cust_ethnicity_id int    
         ,co_buyer_id varchar(250) 
         ,co_buyer_salutation_text varchar(50) 
         ,co_buyer_first_name varchar(250) 
         ,co_buyer_middle_name varchar(250) 
         ,co_buyer_last_name varchar(250) 
         ,co_buyer_suffix varchar(250) 
         ,co_buyer_full_name varchar(250) 
         ,co_buyer_address1 varchar(250) 
         ,co_buyer_address2 varchar(250) 
         ,co_buyer_city varchar(250) 
         ,co_buyer_district varchar(250) 
         ,co_buyer_region varchar(250) 
         ,co_buyer_zip_code varchar(250)          
         ,co_buyer_country varchar(250) 
         ,co_buyer_home_phone varchar(100) 
         ,co_buyer_home_phone_ext varchar(100) 
         ,co_buyer_home_ph_country_code varchar(100) 
         ,co_buyer_mobile_phone varchar(100) 
         ,co_buyer_work_phone varchar(100) 
         ,co_buyer_work_phone_ext varchar(100) 
         ,co_buyer_work_ph_country_code varchar(100) 
         ,co_buyer_email_address1 varchar(250) 
         ,co_buyer_email_address2 varchar(250) 
         ,co_buyer_birth_date date 
         ,has_children_12 bit    
         ,cust_do_not_data_share varchar(5)
         ,active_dt date
         ,inactive_dt date
         ,cust_do_not_call varchar(15)
         ,cust_do_not_email varchar(15)
         ,cust_do_not_mail varchar(15)
         ,cust_opt_out  varchar(15)
         ,latitude varchar(100)
         ,longitude varchar(100)
         ,cust_mail_block_flag bit 
         ,job_log_id int
		 ,file_log_detail_id int
         ,is_file_stat int
         ,make varchar(250)
         ,vin varchar(25)
         ,unique_no varchar(50)
         ,unique_cust_id bigint
		 ,cust_category varchar(100)
		 ,cust_work_address varchar(250)
         ,cust_work_address_district varchar(250)
         ,cust_work_address_city varchar(250)
         ,cust_work_address_region varchar(250)
         ,cust_work_address_postal_code varchar(250)
         ,cust_work_address_country varchar(250)
		 ,mailing_preference varchar(250)
		 ,cust_lic_number varchar(250)
         ,cust_driver_lic_exp_dt varchar(250)
		 ,cust_ib_flag varchar(50)
		 ,follow_up_type varchar(100)
		 ,follow_up_value varchar(100)
		 ,is_invalid_dms_num bit default(0)
		 ,model_score_100 int
		 ,model_score_110 int
		 ,model_score_200 int
		 ,model_score_550 int
		 ,model_score_555 int
		 ,model_score_650 int
		 ,prison_flag bit 
		 ,deceased_flag bit
		 ,under_14_flag bit 
		 ,name_based_suppress_flag bit 
		 ,upfitter_address_flag bit
		 ,household_id varchar(250)
		 ,is_vehicle_owner bit 
		 ,cust_age int
		 ,surrogate_id int
	)
	
	
	insert into #customer_insert
	 (
	     parent_dealer_id 
		,natural_key 
		,src_dealer_code   
		,cust_dms_number    
		,cust_salutation_text    
		,cust_full_name    
		,cust_first_name    
		,cust_middle_name    
		,cust_last_name    
		,cust_suffix    
		,cust_address1    
		,cust_address2    
		,cust_city    
		,cust_county 
		,cust_district 
		,cust_region  
		,cust_country  
		,cust_state_code    
		,cust_zip_code    
		,cust_zipcode 
		,cust_mobile_phone    
		,cust_home_phone    
		,cust_home_phone_ext 
		,cust_home_ph_country_code 
		,cust_work_phone    
		,cust_work_phone_ext 
		,cust_work_ph_country_code 
		,cust_email_address1    
		,cust_email_address2    
		,cust_birth_date 
		,cust_birth_type 
		,cust_status 
		,cust_gender    
		,customer_type 
		,cust_driver_type  
		,cust_driver_lic_exp_dt
		,cust_lic_number
		,mailing_preference
		,co_buyer_id  
		,co_buyer_salutation_text  
		,co_buyer_first_name  
		,co_buyer_middle_name  
		,co_buyer_last_name  
		,co_buyer_suffix  
		,co_buyer_full_name  
		,co_buyer_address1  
		,co_buyer_address2  
		,co_buyer_city  
		,co_buyer_district  
		,co_buyer_region  
		,co_buyer_zip_code 
		,co_buyer_country  
		,co_buyer_home_phone  
		,co_buyer_home_phone_ext  
		,co_buyer_home_ph_country_code  
		,co_buyer_mobile_phone  
		,co_buyer_work_phone  
		,co_buyer_work_phone_ext  
		,co_buyer_work_ph_country_code  
		,co_buyer_email_address1  
		,co_buyer_email_address2  
		,co_buyer_birth_date  
		,cust_do_not_data_share 
		,cust_opt_out  
		,cust_mail_block_flag  
		,job_log_id 
		,file_log_detail_id 
		,is_file_stat 
		,make 
		,vin 
		,unique_no 
		,unique_cust_id							----???
		,cust_category
		,cust_work_address
		,cust_work_address_district
		,cust_work_address_city
		,cust_work_address_region
		,cust_work_address_postal_code
		,cust_work_address_country
		,active_dt
		,follow_up_type
		,follow_up_value
		,model_score_100
		,model_score_110 
		,model_score_200 
		,model_score_550 
		,model_score_555 
		,model_score_650 
		,prison_flag  
		,deceased_flag 
		,under_14_flag  
		,name_based_suppress_flag  
		,upfitter_address_flag 
		,household_id  
		,is_vehicle_owner
		,cust_age
		,surrogate_id
	)

		select distinct 
	     parent_dealer_id 
		,natural_key 
		,src_dealer_code 
		,[dbo].[LRtrim](buyer_id) as cust_dms_number
		,[dbo].[LRtrim](buyer_salutation) as cust_salutation_text
        ,dbo.CamelCase(iif([dbo].[LRtrim]((replace(replace(isnull(buyer_first_name,''),' ','')+' '+iif((isnull(buyer_middle_name,'') ='' or buyer_middle_name = ' '),'',replace(buyer_middle_name,' ',''))+' '+ltrim(rtrim(isnull(buyer_last_name,''))),'  ',' '))) = '',[dbo].[LRtrim]((isnull(buyer_full_name,''))),[dbo].[LRtrim]((replace(replace(isnull(buyer_first_name,''),' ','')+' '+iif((isnull(buyer_middle_name,'') ='' or buyer_middle_name = ' '),'',replace(isnull(buyer_middle_name,''),' ',''))+' '+ltrim(rtrim(isnull(buyer_last_name,''))),'  ',' '))))) as cust_full_name    
	    ,[dbo].[LRtrim](isnull(buyer_first_name,'')) as cust_first_name
		,[dbo].[LRtrim](isnull(buyer_middle_name,'')) as cust_middle_name
		,[dbo].[LRtrim](isnull(buyer_last_name,'')) as cust_last_name
		,[dbo].[LRtrim](isnull(buyer_suffix,'')) as cust_suffix		
		,[dbo].[LRtrim](isnull(buyer_home_address,'')) as cust_address1
		,''as cust_address2		
		,[dbo].[LRtrim](isnull(buyer_home_address_city,'')) as cust_city
		,'' as cust_county		
		,buyer_home_address_district
		,[dbo].[LRtrim](isnull(buyer_home_address_region,'')) as cust_state
		,[dbo].[LRtrim](isnull(buyer_home_address_country,'')) as cust_country
		,[dbo].[LRtrim](isnull(buyer_home_address_region,'')) as cust_state_code  
		,case when len(buyer_home_address_postal_code)=10 then left(buyer_home_address_postal_code,5)
			  when len(buyer_home_address_postal_code)=9 then left(buyer_home_address_postal_code,5)
			  when len(buyer_home_address_postal_code)=8 then left(buyer_home_address_postal_code,5)
			  when len(buyer_home_address_postal_code)=4 then '0'+buyer_home_address_postal_code 
		                                   else buyer_home_address_postal_code end as cust_zip_code
		,buyer_home_address_postal_code as cust_zipcode
		,[dbo].[LRtrim](isnull(buyer_mobilephone_number,'')) as cust_mobile_phone
		,[dbo].[LRtrim](replace(replace(replace(replace(buyer_homephone_number,'(',''),')',''),'-',''),' ','')) as cust_home_phone  
		,[dbo].[LRtrim](isnull(buyer_homephone_extension,'')) as cust_home_phone_ext  
		,[dbo].[LRtrim](isnull(buyer_homephone_country_code,'')) as cust_home_ph_country_code 
		,[dbo].[LRtrim](iif(buyer_officephone_number is null or buyer_officephone_number = '' ,isnull(buyer_businessphone_number,''),isnull(buyer_officephone_number,''))) as cust_work_phone    
		,[dbo].[LRtrim](isnull(buyer_businessphone_extension,'')) as cust_work_phone_ext 
		,[dbo].[LRtrim](isnull(buyer_businessphone_country_code,'')) as cust_work_ph_country_code 
		,[dbo].[LRtrim](isnull(buyer_personal_email_address,'')) as cust_email_address		
		,'' as cust_email_address2
		,[dbo].[LRtrim](isnull(buyer_birth_date,'')) as cust_birth_date
		,[dbo].[LRtrim](isnull(buyer_birth_type,'')) as cust_birth_type
		,'' as cust_status
		,isnull(buyer_gender,'')
		,iif(buyer_ib_flag ='I','C',buyer_ib_flag)
		,isnull(buyer_driver_type,'')
		,isnull(buyer_driver_licexp_dt,'')
		,isnull(buyer_lic_number,'')
		,isnull(buyer_followup_type,'')
		,isnull(co_buyer_id,'')
		,isnull(co_buyer_salutation,'')
		,isnull(co_buyer_first_name,'')
		,isnull(co_buyer_middle_name,'')
		,isnull(co_buyer_last_name,'')
		,isnull(co_buyer_suffix,'')
		,isnull(co_buyer_full_name,'')
		,isnull(co_buyer_home_address,'')
		,''
		,isnull(co_buyer_home_address_city,'')
		,isnull(co_buyer_home_address_district,'')
		,isnull(co_buyer_home_address_region,'')
		,isnull(co_buyer_home_address_postal_code,'')		
		,isnull(co_buyer_home_address_country,'')
		,isnull(co_buyer_homephone_number,'')
		,isnull(co_buyer_homephone_extension,'')
		,isnull(co_buyer_homephone_country_code,'')
		,isnull(co_buyer_mobilephone_number,'')
		,isnull(co_buyer_officephone_number,'')
		,isnull(co_buyer_businessphone_extension,'')
		,isnull(co_buyer_businessphone_country_code,'')
		,isnull(co_buyer_personal_email_address,'')
		,''														
		,isnull(co_buyer_birth_date,'')
		,iif(buyer_optout ='Y' ,1,0)
		,iif(buyer_optout ='Y' ,1,0)
		,iif(buyer_optout ='Y' ,1,0)
		,file_log_id
		,file_log_detail_id
		,2
		,make
		,vin
		,[dbo].[LRtrim](isnull(deal_number_dms,'')) as unique_no
		,''														----???
		,isnull(buyer_cust_category,'')
		,isnull(buyer_business_address,'')
		,isnull(buyer_business_address_district,'')
		,isnull(buyer_business_address_city,'')
		,isnull(buyer_business_address_region,'')
		,isnull(buyer_business_address_postal_code,'')
		,isnull(buyer_business_address_country,'')
		,iif(deal_date is null ,cast(replace(purchase_date,'00000000','') as date ),cast(replace(deal_date,'00000000','') as date )) as active_dt
		,buyer_followup_value
		,buyer_followup_type
		,iif(ascii(replace(replace(replace(Model_Score_100,'.00',''),'.',''),'#','')) in (13,32),'0',replace(replace(replace(Model_Score_100,'.00',''),'.',''),'#','')) as Model_Score_100
	    ,iif(ascii(replace(replace(replace(Model_Score_110,'.00',''),'.',''),'#','')) in (13,32),'0',replace(replace(replace(Model_Score_110,'.00',''),'.',''),'#','')) as Model_Score_110
	    ,iif(ascii(replace(replace(replace(Model_Score_200,'.00',''),'.',''),'#','')) in (13,32),'0',replace(replace(replace(Model_Score_200,'.00',''),'.',''),'#','')) as Model_Score_200
	    ,iif(ascii(replace(replace(replace(Model_Score_550,'.00',''),'.',''),'#','')) in (13,32),'0',replace(replace(replace(Model_Score_550,'.00',''),'.',''),'#','')) as Model_Score_550
	    ,iif(ascii(replace(replace(replace(Model_Score_555,'.00',''),'.',''),'#','')) in (13,32),'0',replace(replace(replace(Model_Score_555,'.00',''),'.',''),'#','')) as Model_Score_555
	    ,replace( replace(replace(replace(replace(isnull(model_score_650,0),'.00',''),'.0',''),'.',''),'#',''),
         char(ascii(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(model_score_650,1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,'')
        ,9,''),0,''))),'')  as Model_Score_650
	    ,prison_flag  
		,deceased_flag 
		,under_14_flag  
		,name_based_suppress_flag
		,upfitter_address_flag 
		,household_id  
		,0
		,cust_age
		,surrogate_id
	  from 
	    stg.fi_sales etl with(nolock)
	  where  
	   etl.file_log_id=1
	  order by 
	    active_dt
--select * from #customer_insert
insert into #customer_insert
	 (
	     parent_dealer_id 
		,natural_key 
		,src_dealer_code        
		,cust_dms_number 
		,cust_salutation_text  
		,cust_full_name   
		,cust_first_name    
		,cust_middle_name 
		,cust_last_name 
		,cust_suffix 
		,cust_address1  
		,cust_address2 
		,cust_city
		,cust_state_code  
		,cust_zip_code   
		,cust_zipcode
		,cust_mobile_phone   
		,cust_home_phone    
		,cust_work_phone  
		,cust_email_address1 
		,cust_email_address2 
		,cust_birth_date  
		,cust_gender  
		,cust_occupation_id  
		,cust_ethnicity_id    
		,has_children_12   
		,cust_mail_block_flag   
		,cust_status 
		,active_dt
		,inactive_dt 
		,job_log_id			
		,file_log_detail_id	
		,is_file_stat		
		--,src_dealer_code
		,make 
		,cust_do_not_call
		,cust_do_not_email
		,cust_do_not_mail
		,cust_do_not_data_share
		,cust_opt_out
		,vin
		,unique_no
		,customer_type
	    ,cust_home_phone_ext 
        ,cust_home_ph_country_code         
        ,cust_work_phone_ext 
        ,cust_work_ph_country_code 
		,model_score_100
		,model_score_110 
		,model_score_200 
		,model_score_550 
		,model_score_555 
		,model_score_650 
		,prison_flag  
		,deceased_flag 
		,under_14_flag  
		,name_based_suppress_flag
		,upfitter_address_flag 
		,household_id  
		,is_vehicle_owner
		,cust_age
		,surrogate_id

	 )
	select distinct  
	     parent_dealer_id 
		,natural_key 
		,src_dealer_code 	 
		,[dbo].[LRtrim](ro.cust_dms_number)   as cust_dms_number
		,[dbo].[LRtrim](ro.cust_salutation_text) as cust_salutation_text 
		,dbo.camelcase(iif([dbo].[LRtrim]((replace(replace(isnull(cust_first_name,''),' ','')+' '+iif((isnull(cust_middle_name,'') ='' or cust_middle_name = ' '),'',replace(isnull(cust_middle_name,''),' ',''))+' '+ltrim(rtrim(isnull(cust_last_name,''))),'  ',' '))) = '',[dbo].[LRtrim]((isnull(cust_full_name,''))),[dbo].[LRtrim]((replace(replace(cust_first_name,' ','')+' '+iif((isnull(cust_middle_name,'') ='' or cust_middle_name = ' '),'',replace(isnull(cust_middle_name,''),' ',''))+' '+ltrim(rtrim(isnull(cust_last_name,''))),'  ',' '))))) as cust_full_name    
		,[dbo].[LRtrim](isnull(cust_first_name,'')) as cust_first_name
		,[dbo].[LRtrim](isnull(cust_middle_name,''))as cust_middle_name 
		,[dbo].[LRtrim](isnull(cust_last_name,'')) as cust_last_name
		,[dbo].[LRtrim](isnull(cust_suffix,'')) as cust_suffix
		,[dbo].[LRtrim](isnull(ro.cust_address1,'')) as cust_address1
		,[dbo].[LRtrim](isnull(ro.cust_address2,'')) as cust_address2
		,[dbo].[LRtrim](isnull(ro.cust_city,'')) as cust_city
		,[dbo].[LRtrim](isnull(ro.cust_state,''))  as cust_state
		,case when len(cust_zip_code)=10 then left(cust_zip_code,5)
			  when len(cust_zip_code)=9 then left(cust_zip_code,5)
			  when len(cust_zip_code)=8 then left(cust_zip_code,5)
			  when len(cust_zip_code)=4 then '0'+cust_zip_code 
		                                   else isnull(cust_zip_code,'') end as cust_zip_code
	    ,cust_zip_code    
		,[dbo].[LRtrim](isnull(ro.cust_mobile_phone,'')) as cust_mobile_phone
		,[dbo].[LRtrim](replace(replace(replace(replace(isnull(ro.cust_home_phone,''),'(',''),')',''),'-',''),' ','')) as cust_home_phone  
		,[dbo].[LRtrim](iif(cust_work_phone is null or cust_work_phone = '' ,isnull(cust_business_phone,''),isnull(cust_work_phone,''))) as cust_work_phone     
		,[dbo].[LRtrim](isnull(ro.cust_email_address,'')) as cust_email_address 
		,[dbo].[LRtrim](isnull(ro.cust_email_address2,'')) as cust_email_address2 
		,[dbo].[LRtrim](cast(replace(ro.cust_birth_date,'00000000','') as date )) as cust_birth_date
		,[dbo].[LRtrim](ro.cust_gender) as cust_gender
		,1  
		,1    
		,1   
		,iif(ro.cust_mail_block_flag ='Y' ,1,0)
		,'A'
		,cast(replace(ro_close_date,'00000000','') as date ) as active_dt
		,null 				
		,ro.file_log_id
		,ro.file_load_detail_id
		,1
		--,ro.src_dealer_code
		,make 
		,case when cust_do_not_call = 1 then 0 
		      when cust_do_not_call = 0 then 1
			  when (cust_do_not_call = null or cust_do_not_call = '') then 0 end
		,case when cust_do_not_email = 1 then 0 
		      when cust_do_not_email = 0 then 1
			  when (cust_do_not_email = null or cust_do_not_email = '')  then 0 end
		,case when cust_do_not_mail = 1 then 0 
		      when cust_do_not_mail = 0 then 1
			  when cust_do_not_mail = null then 0 end		 
		,isnull(cust_do_not_data_share,0)  
		,case when cust_opt_out = 1 then 0 
		      when cust_opt_out = 0 then 1
			  when cust_opt_out = null then 0 end
		,vin
		,ro_number
		,iif( cust_ib_flag ='I','C',cust_ib_flag)
		,isnull(cust_home_phone_ext,'')
        ,isnull(cust_home_phone_country_code,'')
		,isnull(cust_business_ext,'')
        ,isnull(cust_business_country_code,'')
		,iif(ascii(replace(replace(replace(Model_Score_100,'.00',''),'.',''),'#',''))  in (13,32),'0',replace(replace(replace(Model_Score_100,'.00',''),'.',''),'#','')) as Model_Score_100
	    ,iif(ascii(replace(replace(replace(Model_Score_110,'.00',''),'.',''),'#',''))  in (13,32),'0',replace(replace(replace(Model_Score_110,'.00',''),'.',''),'#','')) as Model_Score_110
	    ,iif(ascii(replace(replace(replace(Model_Score_200,'.00',''),'.',''),'#',''))  in (13,32),'0',replace(replace(replace(Model_Score_200,'.00',''),'.',''),'#','')) as Model_Score_200
	    ,iif(ascii(replace(replace(replace(Model_Score_550,'.00',''),'.',''),'#',''))  in (13,32),'0',replace(replace(replace(Model_Score_550,'.00',''),'.',''),'#','')) as Model_Score_550
	    ,iif(ascii(replace(replace(replace(Model_Score_555,'.00',''),'.',''),'#',''))  in (13,32),'0',replace(replace(replace(Model_Score_555,'.00',''),'.',''),'#','')) as Model_Score_555
	    ,replace( replace(replace(replace(replace(isnull(model_score_650,0),'.00',''),'.0',''),'.',''),'#',''),
         char(ascii(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(model_score_650,1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,'')
        ,9,''),0,''))),'')  as Model_Score_650
		,prison_flag  
		,deceased_flag 
		,under_14_flag  
		,name_based_suppress_flag
		,upfitter_address_flag 
		,household_id  
		,vehicle_owner_flag
		,age
		,surrogate_id
	  from 
	    stg.repair_order_detail ro with(nolock)	
	  where  	
	   ro.file_log_id=1
	   
	  order by 
	    active_dt
		select * from #customer_insert
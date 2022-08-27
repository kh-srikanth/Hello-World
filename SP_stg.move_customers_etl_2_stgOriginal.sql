USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [stg].[move_customers_etl_2_stage]    Script Date: 1/19/2021 7:10:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
  ALTER procedure  [stg].[move_customers_etl_2_stage]   
 
   @file_log_id int
   

as 
/*
	exec [stg].[move_customers_etl_2_stage]  139
-----------------------------------------------------------------------  

	PURPOSE  
	To split customer data from sales service & service appointment customers based on etl

	PROCESSES  

	MODIFICATIONS  
	Date			Author    Work Tracker Id   Description    
	------------------------------------------------------------------------  

	------------------------------------------------------------------------

	*/ 


Begin
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


	--Inserting sales customer data in customer temp table based on job_log_id
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
		,unique_cust_id 
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
		,[dbo].[clean_and_trim_string_space](buyer_id) as cust_dms_number
		,[dbo].[clean_and_trim_string_space](buyer_salutation) as cust_salutation_text
        ,dbo.CamelCase(iif([dbo].[clean_and_trim_string_space]((replace(replace(isnull(buyer_first_name,''),' ','')+' '+iif((isnull(buyer_middle_name,'') ='' or buyer_middle_name = ' '),'',replace(buyer_middle_name,' ',''))+' '+ltrim(rtrim(isnull(buyer_last_name,''))),'  ',' '))) = '',[dbo].[clean_and_trim_string_space]((isnull(buyer_full_name,''))),[dbo].[clean_and_trim_string_space]((replace(replace(isnull(buyer_first_name,''),' ','')+' '+iif((isnull(buyer_middle_name,'') ='' or buyer_middle_name = ' '),'',replace(isnull(buyer_middle_name,''),' ',''))+' '+ltrim(rtrim(isnull(buyer_last_name,''))),'  ',' '))))) as cust_full_name    
	    ,[dbo].[clean_and_trim_string_space](isnull(buyer_first_name,'')) as cust_first_name
		,[dbo].[clean_and_trim_string_space](isnull(buyer_middle_name,'')) as cust_middle_name
		,[dbo].[clean_and_trim_string_space](isnull(buyer_last_name,'')) as cust_last_name
		,[dbo].[clean_and_trim_string_space](isnull(buyer_suffix,'')) as cust_suffix		
		,[dbo].[clean_and_trim_string_space](isnull(buyer_home_address,'')) as cust_address1
		,''as cust_address2		
		,[dbo].[clean_and_trim_string_space](isnull(buyer_home_address_city,'')) as cust_city
		,'' as cust_county		
		,buyer_home_address_district
		,[dbo].[clean_and_trim_string_space](isnull(buyer_home_address_region,'')) as cust_state
		,[dbo].[clean_and_trim_string_space](isnull(buyer_home_address_country,'')) as cust_country
		,[dbo].[clean_and_trim_string_space](isnull(buyer_home_address_region,'')) as cust_state_code  
		,case when len(buyer_home_address_postal_code)=10 then left(buyer_home_address_postal_code,5)
			  when len(buyer_home_address_postal_code)=9 then left(buyer_home_address_postal_code,5)
			  when len(buyer_home_address_postal_code)=8 then left(buyer_home_address_postal_code,5)
			  when len(buyer_home_address_postal_code)=4 then '0'+buyer_home_address_postal_code 
		                                   else buyer_home_address_postal_code end as cust_zip_code
		,buyer_home_address_postal_code as cust_zipcode
		,[dbo].[clean_and_trim_string_space](isnull(buyer_mobilephone_number,'')) as cust_mobile_phone
		,[dbo].[clean_and_trim_string_space](replace(replace(replace(replace(buyer_homephone_number,'(',''),')',''),'-',''),' ','')) as cust_home_phone  
		,[dbo].[clean_and_trim_string_space](isnull(buyer_homephone_extension,'')) as cust_home_phone_ext  
		,[dbo].[clean_and_trim_string_space](isnull(buyer_homephone_country_code,'')) as cust_home_ph_country_code 
		,[dbo].[clean_and_trim_string_space](iif(buyer_officephone_number is null or buyer_officephone_number = '' ,isnull(buyer_businessphone_number,''),isnull(buyer_officephone_number,''))) as cust_work_phone    
		,[dbo].[clean_and_trim_string_space](isnull(buyer_businessphone_extension,'')) as cust_work_phone_ext 
		,[dbo].[clean_and_trim_string_space](isnull(buyer_businessphone_country_code,'')) as cust_work_ph_country_code 
		,[dbo].[clean_and_trim_string_space](isnull(buyer_personal_email_address,'')) as cust_email_address		
		,'' as cust_email_address2
		,[dbo].[clean_and_trim_string_space](isnull(buyer_birth_date,'')) as cust_birth_date
		,[dbo].[clean_and_trim_string_space](isnull(buyer_birth_type,'')) as cust_birth_type
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
		,[dbo].[clean_and_trim_string_space](isnull(deal_number_dms,'')) as unique_no
		,'' 
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
	   etl.file_log_id=@file_log_id
	  --natural_key='PRBD'		
	  order by 
	    active_dt

	--Inserting Service customer data in customer temp table based on job_log_id
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
		,[dbo].[clean_and_trim_string_space](ro.cust_dms_number)   as cust_dms_number
		,[dbo].[clean_and_trim_string_space](ro.cust_salutation_text) as cust_salutation_text 
		,dbo.camelcase(iif([dbo].[clean_and_trim_string_space]((replace(replace(isnull(cust_first_name,''),' ','')+' '+iif((isnull(cust_middle_name,'') ='' or cust_middle_name = ' '),'',replace(isnull(cust_middle_name,''),' ',''))+' '+ltrim(rtrim(isnull(cust_last_name,''))),'  ',' '))) = '',[dbo].[clean_and_trim_string_space]((isnull(cust_full_name,''))),[dbo].[clean_and_trim_string_space]((replace(replace(cust_first_name,' ','')+' '+iif((isnull(cust_middle_name,'') ='' or cust_middle_name = ' '),'',replace(isnull(cust_middle_name,''),' ',''))+' '+ltrim(rtrim(isnull(cust_last_name,''))),'  ',' '))))) as cust_full_name    
		,[dbo].[clean_and_trim_string_space](isnull(cust_first_name,'')) as cust_first_name
		,[dbo].[clean_and_trim_string_space](isnull(cust_middle_name,''))as cust_middle_name 
		,[dbo].[clean_and_trim_string_space](isnull(cust_last_name,'')) as cust_last_name
		,[dbo].[clean_and_trim_string_space](isnull(cust_suffix,'')) as cust_suffix
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_address1,'')) as cust_address1
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_address2,'')) as cust_address2
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_city,'')) as cust_city
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_state,''))  as cust_state
		,case when len(cust_zip_code)=10 then left(cust_zip_code,5)
			  when len(cust_zip_code)=9 then left(cust_zip_code,5)
			  when len(cust_zip_code)=8 then left(cust_zip_code,5)
			  when len(cust_zip_code)=4 then '0'+cust_zip_code 
		                                   else isnull(cust_zip_code,'') end as cust_zip_code
	    ,cust_zip_code    
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_mobile_phone,'')) as cust_mobile_phone
		,[dbo].[clean_and_trim_string_space](replace(replace(replace(replace(isnull(ro.cust_home_phone,''),'(',''),')',''),'-',''),' ','')) as cust_home_phone  
		,[dbo].[clean_and_trim_string_space](iif(cust_work_phone is null or cust_work_phone = '' ,isnull(cust_business_phone,''),isnull(cust_work_phone,''))) as cust_work_phone     
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_email_address,'')) as cust_email_address 
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_email_address2,'')) as cust_email_address2 
		,[dbo].[clean_and_trim_string_space](cast(replace(ro.cust_birth_date,'00000000','') as date )) as cust_birth_date
		,[dbo].[clean_and_trim_string_space](ro.cust_gender) as cust_gender
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
	   ro.file_log_id=@file_log_id
	   
	  order by 
	    active_dt


	-------------------------------------------------Updating Customer DMS Number based on existing data--------------------------------------------------
	
	-- Updating Customer DMS Number based on Customer Full Name and Cust Mobile No
	update  mc set
		 mc.cust_dms_number = mcs.cust_dms_number
	from
	#customer_insert mc
	inner join master.customer mcs on 
		ltrim(rtrim(mc.cust_full_name)) = ltrim(rtrim(mcs.cust_full_name)) and 
		ltrim(rtrim(mc.cust_mobile_phone)) = ltrim(rtrim(mcs.cust_mobile_phone))and 
		mc.natural_key = mcs.natural_key
	where
	len(mcs.cust_mobile_phone) > 0 and
	mc.cust_dms_number = '' 
	and len(mcs.cust_dms_number) > 0
	and  mcs.cust_full_name <> '' and mcs.cust_address1 <> '' and mcs.cust_city <> '' and mcs.cust_zip_code <> ''

	-- Updating Customer DMS Number based on Customer Full Name and Cust Home No
	
	update 
	    mc 
	 set
	   mc.cust_dms_number = mcs.cust_dms_number	
	from
	   #customer_insert mc
	     inner join master.customer mcs on 
		   ltrim(rtrim(mc.cust_full_name)) = ltrim(rtrim(mcs.cust_full_name)) and 
		   ltrim(rtrim(mc.cust_home_phone)) = ltrim(rtrim(mcs.cust_home_phone))and 
		   mc.natural_key = mcs.natural_key
	where
	   len(mcs.cust_home_phone) > 0 and
	   mc.cust_dms_number = '' 
	   and len(mcs.cust_dms_number) > 0  	   
	   and  mcs.cust_full_name <> '' and mcs.cust_address1 <> '' and mcs.cust_city <> '' and mcs.cust_zip_code <> ''
	
	-- Updating Customer DMS Number based on Customer Full Name, Address and ZipCode

	 update  mc set
		 mc.cust_dms_number = mcs.cust_dms_number
	from
	   #customer_insert mc
	     inner join master.customer mcs on 
		    ltrim(rtrim(mc.cust_full_name)) = ltrim(rtrim(mcs.cust_full_name)) and 
		    ltrim(rtrim(mc.cust_address1)) = ltrim(rtrim(mcs.cust_address1)) and 
	        ltrim(rtrim(mc.cust_address2)) = ltrim(rtrim(mcs.cust_address2)) and 
		    ltrim(rtrim(mc.cust_zip_code)) = ltrim(rtrim(mcs.cust_zip_code))and 
		    mc.natural_key = mcs.natural_key
	where
	    len(mcs.cust_address1+mcs.cust_address2) >0 and
	    mc.cust_dms_number = '' 
	    and len(mcs.cust_dms_number) > 0 
		 
	and  mcs.cust_full_name <> '' and mcs.cust_address1 <> '' and mcs.cust_city <> '' and mcs.cust_zip_code <> ''

   --Cust Full + Substring(VIN,11,7) 

   update ci 
     set ci.cust_dms_number = mc.cust_dms_number
  from
	   master.customer mc
	inner join master.cust_2_vehicle mcv on 
	   mc.master_customer_id = mcv.master_customer_id
	inner join #customer_insert ci on 	     
	     Substring(ci.VIN,11,7) = Substring(mcv.VIN,11,7) and 
		 ltrim(rtrim(ci.cust_full_name)) = ltrim(rtrim(mc.cust_full_name))and 
		 ci.natural_key = mcv.natural_key 
  where 
      mc.cust_dms_number = ''  and  len(mc.cust_dms_number) > 0	   
	  and  mc.cust_full_name <> '' and mc.cust_address1 <> '' and mc.cust_city <> '' and mc.cust_zip_code <> ''
     -------------------------------------------------------------------------------
	
	select rank() over (partition by cust_dms_number, natural_key, cust_full_name, vin order by active_dt desc) as rnk, * into #temp from #customer_insert

-- Loading Customer data into temptable
	select 
		 parent_dealer_id 
		,natural_key 
		,src_dealer_code        
		,isnull(cust_dms_number,'') as cust_dms_number
		,cust_salutation_text 
		,[dbo].[CamelCase](cust_full_name) as cust_full_name
		,[dbo].[CamelCase](cust_first_name) as cust_first_name 
		,[dbo].[CamelCase](cust_middle_name)as cust_middle_name
		,[dbo].[CamelCase](cust_last_name) as cust_last_name
		,cust_suffix 
		,[dbo].[CamelCase](cust_address1) as  cust_address1
		,cust_address2 
		,[dbo].[CamelCase](cust_city) as cust_city
		,cust_state_code 
		,cust_zip_code
		,case when len(cust_zipcode)=10 then Replace(SubString(cust_zipcode, 6, 2000), '-', '')
			  when len(cust_zipcode)=9 then right(cust_zipcode,4)
			  when len(cust_zipcode)=8 then right(cust_zipcode,3) end as cust_zipcode4  
		,replace(replace(replace(replace(cust_mobile_phone,'(',''),')',''),'-',''),' ','') as cust_mobile_phone   
		,replace(replace(replace(replace(cust_home_phone,'(',''),')',''),'-',''),' ','') as cust_home_phone   
		,replace(replace(replace(replace(cust_work_phone,'(',''),')',''),'-',''),' ','') as cust_work_phone   
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
		,make
		,cust_do_not_call
		,cust_do_not_email
		,cust_do_not_mail
		,cust_do_not_data_share
		,cust_opt_out
		,vin
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
		,replace(replace(replace(replace(co_buyer_home_phone,'(',''),')',''),'-',''),' ','') as co_buyer_home_phone  
		,co_buyer_home_phone_ext  
		,co_buyer_home_ph_country_code  
		,replace(replace(replace(replace(co_buyer_mobile_phone,'(',''),')',''),'-',''),' ','') as co_buyer_mobile_phone   
		,replace(replace(replace(replace(co_buyer_work_phone,'(',''),')',''),'-',''),' ','') as co_buyer_work_phone    
		,co_buyer_work_phone_ext 
		,co_buyer_work_ph_country_code 
		,co_buyer_email_address1  
		,co_buyer_email_address2 
		,co_buyer_birth_date  
		,cust_category
		,cust_work_address
		,cust_work_address_district
		,cust_work_address_city
		,cust_work_address_region
		,cust_work_address_postal_code
		,cust_work_address_country
		,cust_home_phone_ext 
		,cust_home_ph_country_code
		,cust_birth_type
		,customer_type
		,cust_driver_type
		,cust_lic_number
		,cust_driver_lic_exp_dt
		,is_invalid_dms_num
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
		,rank()over(partition by cust_dms_number,parent_dealer_id,vin,cust_full_name order by active_dt desc) as rnk
		into 
		  #cust_rnk
	  from 
	     #temp
	  where 
	     rnk = 1

	    create nonclustered index idx_cust_rnk on  #cust_rnk (cust_dms_number,natural_key)
		
		/*Updating blank cust_dms_number flag is_invalid_dms_num */ 

	 update #cust_rnk set is_invalid_dms_num =1 where cust_dms_number = ''	  


	-- Loading customer data into mail table 
	   insert into stg.customers
	     (
	     parent_dealer_id
		,vin 
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
		,cust_zip_code4
	    ,cust_mobile_phone 
	    ,cust_home_phone 
	    ,cust_work_phone 
	    ,cust_email_address1 
	    ,cust_email_address2 
	    ,cust_birth_date 
	    ,cust_gender	   
	    ,cust_status
		,active_date
		,inactive_date 
		,file_log_id  
		,file_log_detail_id		 
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
		,cust_work_address_district
        ,cust_work_address_city
        ,cust_work_address_zip_code
        ,cust_work_address_region
        ,cust_work_address_country		
        ,cust_birth_type		
		,cust_category
        ,customer_type
        ,cust_driver_type
        ,cust_lic_number
        ,cust_driver_lic_exp_dt
		,created_date
        ,updated_date
        ,created_by
        ,updated_by	
		,cust_do_not_call
		,cust_do_not_email
		,cust_do_not_mail
		,is_invalid_dms_num 
		,is_deleted  
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
		,is_blank_record
		,is_invalid_email
   )
	   
     select distinct
       	 
		 ci.parent_dealer_id 
		,ci.vin
		,ci.natural_key 
		,ci.src_dealer_code   
		,iif(ci.cust_dms_number = '',ci.natural_key+'*'+right(ci.vin,8) ,ci.cust_dms_number)
		,isnull(ci.cust_salutation_text,'') 
		,isnull(ci.cust_full_name,'') 
		,isnull(ci.cust_first_name,'')   
		,isnull(ci.cust_middle_name,'')
		,isnull(ci.cust_last_name,'')
		,isnull(ci.cust_suffix,'') 
		,isnull(ci.cust_address1,'')  
		,isnull(ci.cust_address2,'') 
		,isnull(ci.cust_city,'')
		,isnull(ci.cust_state_code,'')  
		,isnull(ci.cust_zip_code,'')
	    ,isnull(ci.cust_zipcode4,'')
		,isnull(ci.cust_mobile_phone,'')   
		,isnull(ci.cust_home_phone,'')    
		,isnull(ci.cust_work_phone,'')  
		,lower(isnull(ci.cust_email_address1,'')) 
		,isnull(ci.cust_email_address2,'') 
		,iif(ci.cust_birth_date= '1900-01-01','',convert(varchar(8),cast(ci.cust_birth_date as date),112)) as  cust_birth_date  
		,isnull(ci.cust_gender,'')		 
		,isnull(ci.cust_status,'') 
		,convert(varchar(8),cast(ci.active_dt as date),112) as active_dt
		,convert(varchar(8),cast(ci.inactive_dt as date),112) as inactive_dt 
		,ci.job_log_id 
		,ci.file_log_detail_id		 
		,ci.co_buyer_id 
		,isnull(ci.co_buyer_salutation_text,'')  
		,isnull(ci.co_buyer_first_name,'')  
		,isnull(ci.co_buyer_middle_name,'')  
		,isnull(ci.co_buyer_last_name,'')  
		,isnull(ci.co_buyer_suffix,'')  
		,isnull(ci.co_buyer_full_name,'')  
		,isnull(ci.co_buyer_address1,'') 
		,isnull(ci.co_buyer_address2,'')  
		,isnull(ci.co_buyer_city,'')  
		,isnull(ci.co_buyer_district,'')  
		,isnull(ci.co_buyer_region,'')  
		,isnull(ci.co_buyer_zip_code,'') 		 
		,isnull(ci.co_buyer_country,'')  
		,isnull(ci.co_buyer_home_phone,'')  
		,isnull(ci.co_buyer_home_phone_ext,'')  
		,isnull(ci.co_buyer_home_ph_country_code,'')  
		,isnull(ci.co_buyer_mobile_phone,'') 
		,isnull(ci.co_buyer_work_phone,'')  
		,isnull(ci.co_buyer_work_phone_ext,'') 
		,isnull(ci.co_buyer_work_ph_country_code,'') 
		,isnull(ci.co_buyer_email_address1,'')  
		,isnull(ci.co_buyer_email_address2,'') 
		,iif(ci.co_buyer_birth_date=  '1900-01-01','',convert(varchar(8),cast(ci.co_buyer_birth_date as date),112)) as co_buyer_birth_date   	
		,isnull(ci.cust_work_address_district,'')
        ,isnull(ci.cust_work_address_city,'')
        ,isnull(ci.cust_work_address_postal_code,'')
        ,isnull(ci.cust_work_address_region,'')
        ,isnull(ci.cust_work_address_country,'')		
        ,isnull(ci.cust_birth_type,'')		
		,isnull(ci.cust_category,'')
        ,isnull(ci.customer_type,'')
        ,isnull(ci.cust_driver_type,'')
        ,isnull(ci.cust_lic_number,'')
        ,iif(ci.cust_driver_lic_exp_dt= '1900-01-01','',convert(varchar(8),cast(ci.cust_driver_lic_exp_dt as date),112)) as cust_driver_lic_exp_dt
		,getdate()
        ,getdate()
        ,suser_name()
        ,suser_name()
		,0
		,0
		,0	  
		,is_invalid_dms_num 
		,0
		,isnull(model_score_100,'')
		,isnull(model_score_110,'') 
		,isnull(model_score_200,'') 
		,isnull(model_score_550,'') 
		,isnull(model_score_555,'') 
		,isnull(model_score_650,'') 
		,prison_flag
		,deceased_flag
		,under_14_flag
		,name_based_suppress_flag
		,upfitter_address_flag
		,household_id 
		,ci.is_vehicle_owner
		,cust_age
		,0
		,0
	 from 
	    #cust_rnk ci  
	where 1 = 1	    
	   and ci.rnk = 1

	 update stg.customers  
	 set is_blank_record =1 
	 where (cust_address1 = '' or cust_address1 is null) and (cust_full_name = '' or cust_full_name is null) 

	 update stg.customers  
	 set is_blank_record =1 
	 where (cust_address1 = '' or cust_address1 is null) and (cust_full_name = '' or cust_full_name is null) and 
	 (cust_email_address1 = '' or cust_email_address1 is null) 

	 

	-- Loading Customer DNC data

	create table  #master_customers 
	(
	    natural_key varchar(10)
	   ,cust_dms_number varchar(100)
	   ,vin varchar(20)
	)

	insert into  #master_customers
	 (
	    natural_key
	   ,cust_dms_number	  
	   ,vin
	 )

	select distinct
	    natural_key
	   ,cust_dms_number
	   ,vin 
	from 
	    stg.customers with(nolock) 
    where file_log_id = @file_log_id 
	

	create nonclustered index idx_mast_cust on  #master_customers (cust_dms_number,natural_key)
	
	create table #master_customer_dnc
	    (
	      dealer_id int
	     ,customer_id int
	     ,cust_dms_number varchar(100)
	     ,cust_do_not_call bit
	     ,cust_do_not_email bit
	     ,cust_do_not_mail bit
	     ,cust_do_not_data_share bit
	     ,cust_opt_out_all bit
	     ,natural_key varchar(10)
	     ,vin varchar(20)
	    )	
	insert into #master_customer_dnc
	   (
		 dealer_id		 
		,cust_dms_number
		,cust_do_not_call
		,cust_do_not_email
		,cust_do_not_mail
		,cust_do_not_data_share
		,cust_opt_out_all
		,natural_key
		,vin		
	   )
	select distinct
		
		 ci.parent_dealer_id		 
		,isnull(ci.cust_dms_number,'')
		,isnull(ci.cust_do_not_call,0)
		,isnull(ci.cust_do_not_email,0)
		,isnull(ci.cust_do_not_mail,0)
		,isnull(ci.cust_do_not_data_share,0)
		,isnull(ci.cust_opt_out,0)
		,mcs.natural_key
		,ci.vin
		
	from
		#cust_rnk ci (nolock)
	    inner join #master_customers mcs (nolock) on
		  mcs.natural_key=ci.natural_key and 
		  mcs.cust_dms_number = ci.cust_dms_number and 
		  mcs.vin = ci.vin
	   left join  #master_customer_dnc mc (nolock) on
		  ci.cust_dms_number=mc.cust_dms_number and
		  ci.natural_key=mc.natural_key and 
		  ci.vin = mc.vin
	where
		mc.cust_dms_number is null and
		ci.rnk=1 

--------------------------------------------------updating cust data---------------------------------------------------------
	--update
	--    mcs
	-- set 
	--    mcs.cust_do_not_call= iif(ci.[cust_opt_out]= 1,1,ci.[cust_do_not_call]),
	--	mcs.cust_do_not_email= iif(ci.[cust_opt_out]= 1,1,ci.[cust_do_not_email]),
	--	mcs.cust_do_not_mail=  iif(ci.[cust_opt_out]= 1,1,ci.[cust_do_not_mail]),
	--	mcs.cust_do_not_data_share=  ci.[cust_do_not_data_share],
	--	mcs.cust_opt_out_all= ci.[cust_opt_out],
	--	mcs.updated_by=suser_name(),
	--	mcs.updated_date=getdate()
	-- from 
	--	 #cust_rnk ci 
	--      inner join stg.customers mcs on
	--	   ci.cust_dms_number=mcs.cust_dms_number and
	--	   ci.natural_key=mcs.natural_key and 
	--	   ci.vin = mcs.vin 
--------------------------------------------------Updating Fleet or  Customers --------------------------------------------
	 
	 update  stg.customers   
	   set 
		customer_type = iif(cust_full_name like '% INC%' or cust_full_name like '% LLC%','F','C') 
	 where 
		1 = 1 
		and file_log_id = @file_log_id 
		

	 update  stg.customers   
	   set 
		customer_type = iif(cust_first_name is null or cust_first_name = '' ,'B','C') 
	 where 
		1 = 1		 
		and customer_type <> 'F'-- and oem_id<>34
		and file_log_id = @file_log_id 
		


--------------------------------------------------Updating mail_flag and mail preferance --------------------------------------------


		update
			mcs
		set 		 
				mcs.mailing_preference= case when ci.cust_do_not_email=0  and ci.cust_do_not_mail= 1  and ci.[cust_do_not_call]= 1  then 'Email only'
											 when ci.cust_do_not_email=1  and ci.cust_do_not_mail= 0  and ci.[cust_do_not_call]= 1  then 'Mail only'
											 when ci.cust_do_not_email=1  and ci.cust_do_not_mail= 1  and ci.[cust_do_not_call]= 0  then 'Phone only'
											 when ci.cust_do_not_email=1  and ci.cust_do_not_mail= 1  and ci.[cust_do_not_call]= 1  then 'optout'  
											 else 'Mail or Email or Phone'  end,
				mcs.updated_by=system_user,
				mcs.updated_date=getdate() 
		from 
			stg.customers mcs 
			inner join #master_customer_dnc ci on
			ci.cust_dms_number =mcs.cust_dms_number and 
			ci.vin = mcs.vin and 
			ci.natural_key = mcs.natural_key 


----------------------------------follow_up_mail perference-------------------------------------------------------------------------------------------------

	 select distinct b.ro_number 'cust_dms_number',b.id,b.items as follow_up_type,ro.natural_key,vin into #mail1 from #customer_insert ro with(nolock) 
     cross apply  [etl].[split_ro_detail](ro.cust_dms_number,ro.follow_up_type,'|') as b  	  

	 select distinct b.ro_number 'cust_dms_number',b.id,b.items as follow_up_value,ro.natural_key,vin into #mail2  from #customer_insert ro with(nolock) 
     cross apply  [etl].[split_ro_detail](ro.cust_dms_number,ro.follow_up_value,'|') as b 
	 
	 select distinct cust_dms_number,id,follow_up_type as value,natural_key,vin,'follow_up_type' as name into #mail3 from #mail1 
	 union
	 select distinct *,'follow_up_value' from #mail2

	 select * into #mail4
     from 
     (
     select cust_dms_number,id,natural_key,name,value,vin
     from #mail3
     ) src
     pivot
      (
      max(value)
      for name  in ( [follow_up_type],[follow_up_value])
     ) piv;

	 select
	         cust_dms_number
	        ,id
			,natural_key
			,case when follow_up_value = 'P' then 'Phone'
                  when follow_up_value = 'E' then 'Email'
				  when follow_up_value = 'M' then 'Mail'
			 else follow_up_value end as status 
			,follow_up_type  
			,vin
	 into
	    #mail5 
	 from  
	    #mail4 

    select * into #mail6
    from 
    (
    select follow_up_type,cust_dms_number,status,vin
    from #mail5
    ) src
    pivot
    (
    max(follow_up_type)
    for status  in ([phone],[Email],[Mail],[OPT])
    ) piv;

	select 
	      cust_dms_number
       	 ,iif(phone = 'N',1, 0)as  cust_do_not_call
		 ,iif(email = 'N',1, 0)as  cust_do_not_email
		 ,iif(mail  = 'N',1, 0)as  cust_do_not_mail
		 ,iif(email = 'N' and phone = 'N' and mail = 'N',1, 0) as cust_opt_out
		 ,vin
    into 
	  #mail7
	from 
	   #mail6 

	update stg.customers set cust_do_not_call =  0 where cust_do_not_call is null  
    update stg.customers set cust_do_not_email = 0 where cust_do_not_email is null 
	update stg.customers set cust_do_not_mail =  0 where cust_do_not_mail is null 
    
	update mc 
	 set mailing_preference = case when cust_do_not_call  = 0 and cust_do_not_email = 0 and cust_do_not_mail = 0 then 'Mail or Email or Phone'
		                           when cust_do_not_email = 1 and cust_do_not_call  = 1 and cust_do_not_mail = 1 then 'optout' 
                                   when cust_do_not_call  = 0 and cust_do_not_email = 1 and cust_do_not_mail = 1 then 'Phone only'
		                           when cust_do_not_email = 0 and cust_do_not_call  = 1 and cust_do_not_mail = 1 then 'Email only'
			                       when cust_do_not_call  = 0 and cust_do_not_email = 0 and cust_do_not_mail = 1 then 'Phone or Email only'
		                           when cust_do_not_email = 0 and cust_do_not_call  = 1 and cust_do_not_mail = 0 then 'Email or Mail only'
		                           when cust_do_not_mail  = 0 and cust_do_not_call  = 1 and cust_do_not_email= 1 then 'Mail only'
		                           when cust_do_not_call  = 0 and cust_do_not_mail  = 0 and cust_do_not_email= 1 then 'Phone or Mail only'
		                      end  
         from
	       stg.customers mc 
		   where file_log_id = @file_log_id	
		   
	 
--------------------------------------------------Updating invalid_email_flag ----------------------------------------------------------------------------------------------
				update mcs
					set mcs.is_invalid_email=1,
						mcs.updated_by=system_user,
						mcs.updated_date=getdate()
				from 
					stg.customers mcs (nolock)
					 inner join master.email_dnc ie (nolock) on
					  mcs.cust_email_address1=ie.email_address

				update mcs	
					set mcs.is_invalid_email=1,
						mcs.updated_by=system_user,
						mcs.updated_date=getdate()
				from 
					stg.customers mcs (nolock)
				where
					mcs.is_invalid_email=0 and
					dbo.validEmail(mcs.cust_email_address1)=0 

			update mcs
					set mcs.is_invalid_email=1,
						mcs.updated_by=system_user,
						mcs.updated_date=getdate()
				from 
					stg.customers mcs (nolock)
				where (cust_email_address1 = '' or cust_email_address1 is null)


drop table #customer_insert,#temp,#cust_rnk 
drop table #mail1,#mail2,#mail3,#mail4,#mail5,#mail6,#mail7

end






		

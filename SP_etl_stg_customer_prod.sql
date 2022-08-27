USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [etl].[move_cdk_customers_etl_2_stage]    Script Date: 8/3/2021 12:35:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 
  ALTER procedure  [etl].[move_cdk_customers_etl_2_stage]   
 
   @file_process_id int
   

as 
/*
	exec [etl].[move_cdk_customers_etl_2_stage]  1047
-----------------------------------------------------------------------  
	

	PURPOSE  
	To split customer data from sales service & service appointment customers based on etl

	PROCESSES  

	MODIFICATIONS  
	Date			Author    Work Tracker Id   Description    
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------

	exec [stg].[move_cdk_employee_raw_etl_2_master] @file_log_id

	*/ 


Begin

	/* processing Employee data to Master Table*/
	--declare @file_process_id int = 1

	IF OBJECT_ID('tempdb..#customer_insert') IS NOT NULL DROP TABLE #customer_insert
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
	IF OBJECT_ID('tempdb..#cust_rnk') IS NOT NULL DROP TABLE #cust_rnk
	IF OBJECT_ID('tempdb..#mail1') IS NOT NULL DROP TABLE #mail1
	IF OBJECT_ID('tempdb..#mail2') IS NOT NULL DROP TABLE #mail2
	IF OBJECT_ID('tempdb..#mail3') IS NOT NULL DROP TABLE #mail3
	IF OBJECT_ID('tempdb..#mail4') IS NOT NULL DROP TABLE #mail4
	IF OBJECT_ID('tempdb..#mail5') IS NOT NULL DROP TABLE #mail5
	IF OBJECT_ID('tempdb..#mail6') IS NOT NULL DROP TABLE #mail6
	IF OBJECT_ID('tempdb..#mail7') IS NOT NULL DROP TABLE #mail7


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
         --,cust_email_address3 varchar(250)   
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
         ,file_process_id int
		 ,file_process_detail_id int
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
		 ,cust_work_email_address varchar(250) 
		 ,file_source varchar(20)
		 ,preferred_language varchar(25)
		 ,last_activity_date date
	)
	
	/*
	--Inserting customer data in customer temp table based on file_log_id from customer table
	insert into #customer_insert
	 (
	     parent_dealer_id 
		,natural_key 
		,src_dealer_code        
		,cust_dms_number 
		,cust_salutation_text  
		--,cust_full_name   
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
		,cust_work_email_address
		,cust_birth_date  
		,cust_gender  
		,cust_occupation_id  
		,cust_ethnicity_id    
		,has_children_12   
		,cust_mail_block_flag   
		,cust_status 
		,active_dt
		,inactive_dt 
		,file_process_id 
		,file_process_detail_id
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
		--,model_score_100
		--,model_score_110 
		--,model_score_200 
		--,model_score_550 
		--,model_score_555 
		--,model_score_650 
		--,prison_flag  
		--,deceased_flag 
		--,under_14_flag  
		--,name_based_suppress_flag
		--,upfitter_address_flag 
		--,household_id  
		 ,is_vehicle_owner
		--,cust_age
		--,surrogate_id
		,file_source
	 )
	
	select distinct 
	     c.parent_dealer_id 
		,c.natural_key 
		,a.src_dealer_code 	 
		,[dbo].[clean_and_trim_string_space](a.CustNo)   as cust_dms_number
		,[dbo].[clean_and_trim_string_space](a.Title1) as cust_salutation_text
		--,isnull(cust_full_name,'')
		--,isnull(iif([dbo].[clean_and_trim_string_space]((replace(replace(cust_first_name,' ','')+' '+iif((cust_middle_name ='' or cust_middle_name = ' '),'',replace(cust_middle_name,' ',''))+' '+ltrim(rtrim(cust_last_name)),'  ',' '))) = '',[dbo].[clean_and_trim_string_space]((isnull(cust_full_name,''))),[dbo].[clean_and_trim_string_space]((replace(replace(cust_first_name,' ','')+' '+iif((cust_middle_name ='' or cust_middle_name = ' '),'',replace(cust_middle_name,' ',''))+' '+ltrim(rtrim(cust_last_name)),'  ',' ')))),cust_full_name) as cust_full_name    
		,[dbo].[clean_and_trim_string_space](FirstName) as cust_first_name
		,[dbo].[clean_and_trim_string_space](MiddleName)as cust_middle_name 
		,[dbo].[clean_and_trim_string_space](LastName) as cust_last_name
		,[dbo].[clean_and_trim_string_space](NameSuffix) as cust_suffix
		,[dbo].[clean_and_trim_string_space]([Address]) as cust_address1
		,[dbo].[clean_and_trim_string_space](AddressSecondLine) as cust_address2
		,[dbo].[clean_and_trim_string_space](a.City) as cust_city
		,[dbo].[clean_and_trim_string_space](a.[State])  as cust_state
		,case when len(ZipOrPostalCode)=10 then left(ZipOrPostalCode,5)
			  when len(ZipOrPostalCode)=9 then left(ZipOrPostalCode,5)
			  when len(ZipOrPostalCode)=8 then left(ZipOrPostalCode,5)
			  when len(ZipOrPostalCode)=4 then '0'+ZipOrPostalCode 
		                                   else isnull(ZipOrPostalCode,'') end as cust_zip_code
	    ,ZipOrPostalCode    
		,[dbo].[clean_and_trim_string_space](isnull(Cellular,'')) as cust_mobile_phone
		,[dbo].[clean_and_trim_string_space](replace(replace(replace(replace(isnull(HomePhone,''),'(',''),')',''),'-',''),' ','')) as cust_home_phone  
		,[dbo].[clean_and_trim_string_space](replace(replace(replace(replace(isnull(BusinessPhone,''),'(',''),')',''),'-',''),' ','')) as cust_work_phone     
		,[dbo].[clean_and_trim_string_space](Email) as cust_email_address1 
		,[dbo].[clean_and_trim_string_space](Email2) as cust_email_address2 
		,[dbo].[clean_and_trim_string_space](Email3) as cust_email_address3
		,BirthDate as cust_birth_date -- [dbo].[clean_and_trim_string_space](cast(replace(NULLIF(Birthdate,''),'00000000','') as date )) as cust_birth_date
		,Gender as Gender --,[dbo].[clean_and_trim_string_space](a.Gender) as cust_gender
		,'' as Occupation--[dbo].[clean_and_trim_string_space](Occupation) as Occupation
		,NULL    
		,Null    
		,iif(BlockEMail ='Y' ,1,0)
		,NULL
		,NULL --cast(replace(NULLIF(ro_close_date,''),'00000000','') as date ) as active_dt
		,null 				
		,a.file_process_id
		,a.file_process_detail_id
		,1
		--,ro.src_dealer_code
		,null --make 
		,case when BlockPhone = 'N' then 0 
		      when BlockPhone = 'Y' then 1
			  when (BlockPhone = null or BlockPhone = '') then 0 end
		,case when BlockEMail = 'N' then 0 
		      when BlockEMail = 'Y' then 1
			  when (BlockEMail = null or BlockEMail = '')  then 0 end
		,case when BlockMail = 'N' then 0 
		      when BlockMail = 'Y' then 1
			  when BlockMail = null then 0 end		 
		,0 as BlockDataShare-- isnull(BlockDataShare,0)  
		,case when OptOutFlag = 'N' then 0 
		      when OptOutFlag = 'Y' then 1
			  when OptOutFlag = null then 0 end
		,NULL --vin
		,NULL --ro_number
		,NULL --iif( cust_ib_flag ='I','C',cust_ib_flag)
		,NULL --isnull(cust_home_phone_ext,'')
        ,NULL --isnull(cust_home_phone_country_code,'')
		,isnull(BusinessPhoneExt,'')
        ,NULL --isnull(cust_business_country_code,'')
		--,iif(ascii(replace(replace(replace(Model_Score_100,'.00',''),'.',''),'#',''))  in (13,32),'0',replace(replace(replace(Model_Score_100,'.00',''),'.',''),'#','')) as Model_Score_100
	 --   ,iif(ascii(replace(replace(replace(Model_Score_110,'.00',''),'.',''),'#',''))  in (13,32),'0',replace(replace(replace(Model_Score_110,'.00',''),'.',''),'#','')) as Model_Score_110
	 --   ,iif(ascii(replace(replace(replace(Model_Score_200,'.00',''),'.',''),'#',''))  in (13,32),'0',replace(replace(replace(Model_Score_200,'.00',''),'.',''),'#','')) as Model_Score_200
	 --   ,iif(ascii(replace(replace(replace(Model_Score_550,'.00',''),'.',''),'#',''))  in (13,32),'0',replace(replace(replace(Model_Score_550,'.00',''),'.',''),'#','')) as Model_Score_550
	 --   ,iif(ascii(replace(replace(replace(Model_Score_555,'.00',''),'.',''),'#',''))  in (13,32),'0',replace(replace(replace(Model_Score_555,'.00',''),'.',''),'#','')) as Model_Score_555
	 --   ,replace( replace(replace(replace(replace(isnull(model_score_650,0),'.00',''),'.0',''),'.',''),'#',''),
  --       char(ascii(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(model_score_650,1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,'')
  --      ,9,''),0,''))),'')  as Model_Score_650
		--,prison_flag  
		--,deceased_flag 
		--,under_14_flag  
		--,name_based_suppress_flag
		--,upfitter_address_flag 
		--,household_id  
		 ,0  --,vehicle_owner_flag
		--,age
		--,surrogate_id
		,'Customer'
	  from 
	    [etl].[cdk_customer] a with(nolock)	
		inner join master.dealer c with(nolock) on 
			a.src_dealer_code = c.natural_key
		--left join [etl].[cdk_customer] a with(nolock) on 
		--	ro.cust_dms_number = a.CustNo and 
		--	ro.src_Dealer_code  = a.src_dealer_code 
		 where  
	   a.file_process_id = @file_process_id 
	
	Update 
		a
	set
		a.co_buyer_id   = isnull(etl.co_buyer_id, '')
		,co_buyer_salutation_text  = isnull(etl.co_buyer_salutation, '')
		,co_buyer_first_name   = isnull(etl.co_buyer_first_name, '')
		,co_buyer_middle_name   = isnull(etl.co_buyer_middle_name, '')
		,co_buyer_last_name   = isnull(etl.co_buyer_last_name, '')
		,co_buyer_suffix   = isnull(etl.co_buyer_suffix, '')
		,co_buyer_full_name   = isnull(etl.co_buyer_full_name, '')
		,co_buyer_address1   = isnull(etl.co_buyer_home_address, '')
		,co_buyer_city   = isnull(etl.co_buyer_home_address_city, '')
		,co_buyer_district   = isnull(etl.co_buyer_home_address_district, '')
		,co_buyer_region   = isnull(etl.co_buyer_home_address_region, '')
		,co_buyer_zip_code  = isnull(etl.co_buyer_home_address_postal_code, '')
		,co_buyer_country   = isnull(etl.co_buyer_home_address_country, '')
		,co_buyer_home_phone   = isnull(etl.co_buyer_homephone_number, '')
		,co_buyer_home_phone_ext   = isnull(etl.co_buyer_homephone_extension, '')
		,co_buyer_home_ph_country_code   = isnull(etl.co_buyer_homephone_country_code, '')
		,co_buyer_mobile_phone   = isnull(etl.co_buyer_mobilephone_number, '')
		,co_buyer_work_phone   = isnull(etl.co_buyer_officephone_number, '')
		,co_buyer_work_phone_ext   = isnull(etl.co_buyer_businessphone_extension, '')
		,co_buyer_work_ph_country_code   = isnull(etl.co_buyer_businessphone_country_code, '')
		,co_buyer_email_address1   = isnull(etl.co_buyer_personal_email_address, '')
		,co_buyer_birth_date   = isnull(NULLIF(etl.co_buyer_birth_date, ''), '')
		,make  = etl.make
		,vin  = etl.vin
		,unique_no = [dbo].[clean_and_trim_string_space](deal_number_dms)
		,file_source = 'Sales Update'
	from 
	    #customer_insert a
		inner join master.dealer c with(nolock) on 
			a.src_dealer_code = c.natural_key
		INNER join stg.fi_sales etl with(nolock) on 
			etl.buyer_id = a.cust_dms_number and 
			etl.src_Dealer_code  = a.src_dealer_code 
		 where  
	   etl.file_process_id= 2 and--@file_process_id and 
	   --a.cdk_dealer_code in('3PA0003483','3PA29280') and
	   a.cust_insert_id is not null
	   */
	--Inserting sales customer data in customer temp table based on file_log_id
	
	print '/*Inserting data from stg.fi_sales*/'
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
		,file_process_id 
		,file_process_detail_id 
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
		,is_vehicle_owner
		,file_source
		,last_activity_date
	)

		select distinct 
	     c.parent_dealer_id 
		,c.natural_key 
		,a.src_dealer_code 
		,[dbo].[clean_and_trim_string_space](isnull(buyer_id,a.CustNo)) as cust_dms_number
		,[dbo].[clean_and_trim_string_space](buyer_salutation) as cust_salutation_text--------------------
		,isnull(buyer_full_name,a.Name1)
        --,isnull(iif([dbo].[clean_and_trim_string_space]((replace(replace(isnull(buyer_first_name, ''),' ','')+' '+iif((Isnull(buyer_middle_name,'') ='' or Isnull(buyer_middle_name,'') = ' '),'',replace(Isnull(buyer_middle_name,''),' ',''))+' '+ltrim(rtrim(Isnull(buyer_last_name,''))),'  ',' '))) = '',[dbo].[clean_and_trim_string_space]((isnull(buyer_full_name,''))),[dbo].[clean_and_trim_string_space]((replace(replace(buyer_first_name,' ','')+' '+iif((buyer_middle_name ='' or buyer_middle_name = ' '),'',replace(buyer_middle_name,' ',''))+' '+ltrim(rtrim(buyer_last_name)),'  ',' ')))),buyer_full_name) as cust_full_name    
	    ,[dbo].[clean_and_trim_string_space](isnull(buyer_first_name,a.FirstName)) as cust_first_name
		,[dbo].[clean_and_trim_string_space](isnull(buyer_middle_name,a.MiddleName)) as cust_middle_name
		,[dbo].[clean_and_trim_string_space](isnull(buyer_last_name,a.LastName)) as cust_last_name
		,[dbo].[clean_and_trim_string_space](isnull(buyer_suffix,a.NameSuffix)) as cust_suffix		
		,[dbo].[clean_and_trim_string_space](isnull(buyer_home_address,a.Address)) as cust_address1
		,'' as cust_address2		---------------------------------------------------------------------------------
		,[dbo].[clean_and_trim_string_space](isnull(buyer_home_address_city,a.City)) as cust_city
		,isnull(a.County,'') as cust_county		
		,buyer_home_address_district--------------------------------------------------------------
		,[dbo].[clean_and_trim_string_space](isnull(buyer_home_address_region,a.State)) as cust_state
		,[dbo].[clean_and_trim_string_space](isnull(buyer_home_address_country,a.Country)) as cust_country
		,[dbo].[clean_and_trim_string_space](isnull(buyer_home_address_region,'')) as cust_state_code ---------------------------- 
		,case when len(buyer_home_address_postal_code)=10 then left(buyer_home_address_postal_code,5)
			  when len(buyer_home_address_postal_code)=9 then left(buyer_home_address_postal_code,5)
			  when len(buyer_home_address_postal_code)=8 then left(buyer_home_address_postal_code,5)
			  when len(buyer_home_address_postal_code)=4 then '0'+buyer_home_address_postal_code 
		                                   else isnull(buyer_home_address_postal_code,a.ZipOrPostalCode) end as cust_zip_code
		,isnull(buyer_home_address_postal_code,a.ZipOrPostalCode) as cust_zipcode
		,[dbo].[clean_and_trim_string_space](isnull(buyer_mobilephone_number,a.Cellular)) as cust_mobile_phone
		,[dbo].[clean_and_trim_string_space](replace(replace(replace(replace(isnull(buyer_homephone_number,a.HomePhone),'(',''),')',''),'-',''),' ','')) as cust_home_phone  
		,[dbo].[clean_and_trim_string_space](isnull(buyer_homephone_extension,'')) as cust_home_phone_ext  ----------
		,[dbo].[clean_and_trim_string_space](isnull(buyer_homephone_country_code,'')) as cust_home_ph_country_code --------------
		,[dbo].[clean_and_trim_string_space](iif(buyer_officephone_number is null or buyer_officephone_number = '' ,isnull(buyer_businessphone_number,a.BusinessPhone),isnull(buyer_officephone_number,''))) as cust_work_phone    
		,[dbo].[clean_and_trim_string_space](isnull(buyer_businessphone_extension,a.BusinessPhoneExt)) as cust_work_phone_ext 
		,[dbo].[clean_and_trim_string_space](isnull(buyer_businessphone_country_code,'')) as cust_work_ph_country_code ----------------------------
		,[dbo].[clean_and_trim_string_space](isnull(buyer_personal_email_address,a.Email)) as cust_email_address		
		,isnull(a.Email2,'') as cust_email_address2
		,[dbo].[clean_and_trim_string_space](isnull(cast(NULLIF([buyer_birth_date],'') AS DATE),a.BirthDate)) as cust_birth_date
		,[dbo].[clean_and_trim_string_space](isnull(buyer_birth_type,'')) as cust_birth_type
		,'' as cust_status
		,isnull(buyer_gender,a.Gender)
		,iif(buyer_ib_flag ='I','C',buyer_ib_flag)---------------
		,isnull(buyer_driver_type,'')----------------------
		,isnull(buyer_driver_licexp_dt,a.DriverLicenseExpdate)
		,isnull(buyer_lic_number,'')---------------
		,isnull(buyer_followup_type,'')-------------
		,isnull(etl.co_buyer_id,'')-------------
		,isnull(etl.co_buyer_salutation,'')------------
		,isnull(etl.co_buyer_first_name,'')---------------
		,isnull(etl.co_buyer_middle_name,'')-----------------
		,isnull(etl.co_buyer_last_name,'')------------
		,isnull(etl.co_buyer_suffix,'')--------------a.Name2Suffix
		,isnull(etl.co_buyer_full_name,'')-------------a.Name2
		,isnull(etl.co_buyer_home_address,'')-------
		,''
		,isnull(etl.co_buyer_home_address_city,'')--------
		,isnull(etl.co_buyer_home_address_district,'')
		,isnull(etl.co_buyer_home_address_region,'')
		,isnull(etl.co_buyer_home_address_postal_code,'')		
		,isnull(etl.co_buyer_home_address_country,'')
		,isnull(etl.co_buyer_homephone_number,'')
		,isnull(etl.co_buyer_homephone_extension,'')
		,isnull(etl.co_buyer_homephone_country_code,'')
		,isnull(etl.co_buyer_mobilephone_number,'')
		,isnull(etl.co_buyer_officephone_number,'')
		,isnull(etl.co_buyer_businessphone_extension,'')
		,isnull(etl.co_buyer_businessphone_country_code,'')
		,isnull(etl.co_buyer_personal_email_address,'')
		,''
		,isnull(NULLIF(etl.co_buyer_birth_date,''),'')
		,iif(buyer_optout ='Y' ,1,0)
		,iif(buyer_optout ='Y' ,1,0)
		,iif(buyer_optout ='Y' ,1,0)
		,etl.file_process_id
		,etl.file_process_detail_id
		,2
		,etl.make
		,etl.vin
		,[dbo].[clean_and_trim_string_space](deal_number_dms ) as unique_no
		,'' 
		,isnull(buyer_cust_category,'')
		,isnull(buyer_business_address,'')
		,isnull(buyer_business_address_district,'')
		,isnull(buyer_business_address_city,'')
		,isnull(buyer_business_address_region,'')
		,isnull(buyer_business_address_postal_code,'')
		,isnull(buyer_business_address_country,'')
		,iif(deal_date is null ,cast(replace(NULLIF(purchase_date,''),'00000000','') as date ),cast(replace(NULLIF(deal_date,''),'00000000','') as date )) as active_dt
		,buyer_followup_value
		,buyer_followup_type
		,0
		,'Sales'
		,iif(deal_date is null ,cast(replace(NULLIF(purchase_date,''),'00000000','') as date ),cast(replace(NULLIF(deal_date,''),'00000000','') as date )) as last_activity_date
		
	  from 
	    stg.fi_sales etl with(nolock)
		inner join master.dealer c with(nolock) on 
			etl.natural_key = c.natural_key
		inner join etl.cdk_customer a with(nolock) on 
			etl.buyer_id = a.CustNo and 
			etl.src_Dealer_code  = a.src_dealer_code 
		 where  
	   etl.file_process_id= @file_process_id 
	   --a.cdk_dealer_code in('3PA0003483','3PA29280') and

	--Inserting Service customer data in customer temp table based on file_log_id

	print '/*Inserting data from stg.service_ro_header*/'
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
		,file_process_id 
		,file_process_detail_id
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
		 ,is_vehicle_owner
		,file_source
		,last_activity_date
	 )
	select distinct  
	     c.parent_dealer_id 
		,c.natural_key 
		,ro.src_dealer_code 	 
		,[dbo].[clean_and_trim_string_space] (isnull(ro.cust_dms_number,a.CustNo) )  as cust_dms_number
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_salutation_text,'')) as cust_salutation_text 
		,isnull(ro.cust_full_name,a.Name1)
		--,isnull(iif([dbo].[clean_and_trim_string_space]((replace(replace(cust_first_name,' ','')+' '+iif((cust_middle_name ='' or cust_middle_name = ' '),'',replace(cust_middle_name,' ',''))+' '+ltrim(rtrim(cust_last_name)),'  ',' '))) = '',[dbo].[clean_and_trim_string_space]((isnull(cust_full_name,''))),[dbo].[clean_and_trim_string_space]((replace(replace(cust_first_name,' ','')+' '+iif((cust_middle_name ='' or cust_middle_name = ' '),'',replace(cust_middle_name,' ',''))+' '+ltrim(rtrim(cust_last_name)),'  ',' ')))),cust_full_name) as cust_full_name    
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_first_name,a.FirstName)) as cust_first_name
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_middle_name,a.MiddleName))as cust_middle_name 
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_last_name,a.LastName)) as cust_last_name
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_suffix,a.NameSuffix)) as cust_suffix
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_address1,a.Address)) as cust_address1
		,[dbo].[clean_and_trim_string_space](ro.cust_address2) as cust_address2
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_city,a.City)) as cust_city
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_state,a.State))  as cust_state
		,case when len(ro.cust_zip_code)=10 then left(ro.cust_zip_code,5)
			  when len(ro.cust_zip_code)=9 then left(ro.cust_zip_code,5)
			  when len(ro.cust_zip_code)=8 then left(ro.cust_zip_code,5)
			  when len(ro.cust_zip_code)=4 then '0'+ ro.cust_zip_code 
		                                   else isnull(ro.cust_zip_code,a.ZipOrPostalCode) end as cust_zip_code
	    ,isnull(ro.cust_zip_code,a.ZipOrPostalCode)    
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_mobile_phone,a.Cellular)) as cust_mobile_phone
		,[dbo].[clean_and_trim_string_space](replace(replace(replace(replace(isnull(ro.cust_home_phone,a.HomePhone),'(',''),')',''),'-',''),' ','')) as cust_home_phone  
		,[dbo].[clean_and_trim_string_space](iif(ro.cust_work_phone is null or ro.cust_work_phone = '' ,isnull(ro.cust_business_phone,a.BusinessPhone),isnull(ro.cust_work_phone,''))) as cust_work_phone     
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_email_address,a.Email)) as cust_email_address 
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_email_address2,a.Email2)) as cust_email_address2 
		,[dbo].[clean_and_trim_string_space](cast(replace(NULLIF(isnull(ro.cust_birth_date,a.BirthDate),''),'00000000','') as date )) as cust_birth_date
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_gender,'Gender')) as cust_gender
		,1  
		,1    
		,1   
		,iif(ro.cust_mail_block_flag ='Y' ,1,0)
		,'A'
		,cast(replace(NULLIF(ro_close_date,''),'00000000','') as date ) as active_dt
		,null 				
		,ro.file_process_id
		,ro.file_process_detail_id
		,1
		--,ro.src_dealer_code
		,ro.make 
		,case when ro.cust_do_not_call = 1 then 0 
		      when ro.cust_do_not_call = 0 then 1
			  when (ro.cust_do_not_call = null or ro.cust_do_not_call = '') then a.BlockPhone end
		,case when ro.cust_do_not_email = 1 then 0 
		      when ro.cust_do_not_email = 0 then 1
			  when (ro.cust_do_not_email = null or ro.cust_do_not_email = '')  then a.BlockEMail end
		,case when ro.cust_do_not_mail = 1 then 0 
		      when ro.cust_do_not_mail = 0 then 1
			  when ro.cust_do_not_mail = null then a.BlockMail end		 
		,isnull(ro.cust_do_not_data_share,0)  
		,case when ro.cust_opt_out = 1 then 0 
		      when ro.cust_opt_out = 0 then 1
			  when ro.cust_opt_out = null then 0 end
		,ro.vin
		,ro_number
		,iif(ro.cust_ib_flag ='I','C',ro.cust_ib_flag)
		,isnull(ro.cust_home_phone_ext,'')
        ,isnull(cust_home_phone_country_code,'')
		,isnull(cust_business_ext,a.BusinessPhoneExt)
        ,isnull(cust_business_country_code,'')
		 ,0  --,vehicle_owner_flag
		,'Service'
		,cast(replace(NULLIF(ro_close_date,''),'00000000','') as date ) as last_activity_date
	  from 
	    stg.service_ro_header ro with(nolock)	
		inner join master.dealer c with(nolock) on 
			ro.natural_key = c.natural_key
		inner join etl.cdk_customer a with(nolock) on 
			ro.cust_dms_number = a.CustNo and 
			ro.src_Dealer_code  = a.src_dealer_code 
		 where  
	   ro.file_process_id = @file_process_id 
	  --- a.cdk_dealer_code in('3PA0003483','3PA29280') and

	--Inserting Service Appointment customer data in customer temp table based on file_log_id

	print '/*Inserting data from stg.service_appts*/'
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
		,file_process_id 
		,file_process_detail_id
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
		,is_vehicle_owner
		,file_source
		,last_activity_date
	 )
	
	select distinct  
	     c.parent_dealer_id 
		,c.natural_key 
		,ro.src_dealer_code 	 
		,[dbo].[clean_and_trim_string_space] (isnull(ro.cust_dms_number,a.CustNo) )  as cust_dms_number
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_salut,'')) as cust_salutation_text 
		,isnull(ro.cust_fullname,a.Name1)
		--,isnull(iif([dbo].[clean_and_trim_string_space]((replace(replace(cust_first_name,' ','')+' '+iif((cust_middle_name ='' or cust_middle_name = ' '),'',replace(cust_middle_name,' ',''))+' '+ltrim(rtrim(cust_last_name)),'  ',' '))) = '',[dbo].[clean_and_trim_string_space]((isnull(cust_full_name,''))),[dbo].[clean_and_trim_string_space]((replace(replace(cust_first_name,' ','')+' '+iif((cust_middle_name ='' or cust_middle_name = ' '),'',replace(cust_middle_name,' ',''))+' '+ltrim(rtrim(cust_last_name)),'  ',' ')))),cust_full_name) as cust_full_name    
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_firstname,a.FirstName)) as cust_first_name
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_middlename,a.MiddleName))as cust_middle_name 
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_lastname,a.LastName)) as cust_last_name
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_suffix,a.NameSuffix)) as cust_suffix
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_address1,a.Address)) as cust_address1
		,[dbo].[clean_and_trim_string_space](ro.cust_address2) as cust_address2
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_city,a.City)) as cust_city
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_state,a.State))  as cust_state
		,case when len(ro.cust_zip)=10 then left(ro.cust_zip,5)
			  when len(ro.cust_zip)=9 then left(ro.cust_zip,5)
			  when len(ro.cust_zip)=8 then left(ro.cust_zip,5)
			  when len(ro.cust_zip)=4 then '0'+ ro.cust_zip 
		                                   else isnull(ro.cust_zip,a.ZipOrPostalCode) end as cust_zip_code
	    ,isnull(ro.cust_zip,a.ZipOrPostalCode)    
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_cell_phone,a.Cellular)) as cust_mobile_phone
		,[dbo].[clean_and_trim_string_space](replace(replace(replace(replace(isnull(ro.cust_home_phone,a.HomePhone),'(',''),')',''),'-',''),' ','')) as cust_home_phone  
		,[dbo].[clean_and_trim_string_space](iif(ro.cust_work_phone is null or ro.cust_work_phone = '' ,isnull(ro.cust_business_phone,a.BusinessPhone),isnull(ro.cust_work_phone,''))) as cust_work_phone     
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_email_address1,a.Email)) as cust_email_address 
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_email_address2,a.Email2)) as cust_email_address2 
		,[dbo].[clean_and_trim_string_space](cast(replace(NULLIF(isnull(ro.cust_birth_date,a.BirthDate),''),'00000000','') as date )) as cust_birth_date
		,[dbo].[clean_and_trim_string_space](isnull(ro.cust_gender,'Gender')) as cust_gender
		,1  
		,1    
		,1   
		,0--iif(ro.cust_mail_block_flag ='Y' ,1,0)
		,'A'
		,cast(replace(NULLIF(appt_date,''),'00000000','') as date ) as active_dt
		,null 				
		,ro.file_process_id
		,ro.file_process_detail_id
		,1
		--,ro.src_dealer_code
		,ro.make 
		,case when ro.cust_do_not_call = 1 then 0 
		      when ro.cust_do_not_call = 0 then 1
			  when (ro.cust_do_not_call = null or ro.cust_do_not_call = '') then a.BlockPhone end
		,case when ro.cust_do_not_email = 1 then 0 
		      when ro.cust_do_not_email = 0 then 1
			  when (ro.cust_do_not_email = null or ro.cust_do_not_email = '')  then a.BlockEMail end
		,case when ro.cust_do_not_mail = 1 then 0 
		      when ro.cust_do_not_mail = 0 then 1
			  when ro.cust_do_not_mail = null then a.BlockMail end		 
		,isnull(ro.cust_do_not_data_share,0)  
		,case when ro.cust_opt_out = 1 then 0 
		      when ro.cust_opt_out = 0 then 1
			  when ro.cust_opt_out = null then 0 end
		,ro.vin
		,ro.appt_id
		,iif(ro.cust_ibflag ='I','C',ro.cust_ibflag)
		,'' --isnull(ro.cust_home_phone_ext,'')
        ,'' -- isnull(cust_home_phone_country_code,'')
		,'' --isnull(cust_business_ext,a.BusinessPhoneExt)
        ,'' --isnull(cust_business_country_code,'')
		 ,0  --,vehicle_owner_flag
		,'SrvAppts'
		,cast(replace(NULLIF(appt_date,''),'00000000','') as date ) as last_activity_date
	  from 
	    stg.service_appts ro with(nolock)	
		inner join master.dealer c with(nolock) on 
			ro.natural_key = c.natural_key
		inner join etl.cdk_customer a with(nolock) on 
			ro.cust_dms_number = a.CustNo and 
			ro.src_Dealer_code  = a.src_dealer_code 
		 where  
	   ro.file_process_id = @file_process_id 
	  --- a.cdk_dealer_code in('3PA0003483','3PA29280') and

	print '/*Inserting data from etl.cdk_customer + stg.fi_sales + stg.service_ro_header LEFT OUTER JOIN*/'
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
			,cust_country
			,cust_state_code
			,cust_zip_code
			,cust_zipcode
			,cust_mobile_phone
			,cust_home_phone
			,cust_work_phone
			,cust_email_address1
			,cust_email_address2
			,cust_work_email_address
			,file_process_id
			,file_process_detail_id
			,active_dt
			,vin
			,file_source
			,cust_do_not_call
			,cust_do_not_email
			,cust_do_not_mail
			,cust_do_not_data_share
			,cust_opt_out
			,cust_gender
			,preferred_language
			,last_activity_date
		)
		
	select distinct 
			 c.parent_dealer_id
			,c.natural_key
			,[dbo].[clean_and_trim_string_space](isnull(c.natural_key,''))
			,[dbo].[clean_and_trim_string_space](isnull(CustNo,''))
			,[dbo].[clean_and_trim_string_space](a.Title1) as cust_salutation_text
			,isnull(name1,'')
		 	,[dbo].[clean_and_trim_string_space]([dbo].[CamelCase](isnull(FirstName  ,''))) 
			,[dbo].[clean_and_trim_string_space]([dbo].[CamelCase](isnull(MiddleName ,'')))  
			,[dbo].[clean_and_trim_string_space]([dbo].[CamelCase](isnull(LastName	 ,'')))   
			,[dbo].[clean_and_trim_string_space](NameSuffix) as cust_suffix
			,[dbo].[clean_and_trim_string_space](isnull(Address , ''))
			,[dbo].[clean_and_trim_string_space](AddressSecondLine) as cust_address2
			,[dbo].[clean_and_trim_string_space](isnull(a.City    , ''))
			,[dbo].[clean_and_trim_string_space](isnull(a.Country , ''))
			,[dbo].[clean_and_trim_string_space](isnull(a.State   , ''))  
			,case when ZipOrPostalCode like '%-%' then substring(ZipOrPostalCode,1,charindex('-',ZipOrPostalCode)-1)
				  when ZipOrPostalCode not like '%-%' and len(ZipOrPostalCode)=10 then left(ZipOrPostalCode,5)
				  when ZipOrPostalCode not like '%-%' and len(ZipOrPostalCode)=9 then left(ZipOrPostalCode,5)
				  when ZipOrPostalCode not like '%-%' and len(ZipOrPostalCode)=8 then left(ZipOrPostalCode,5)
				  when ZipOrPostalCode not like '%-%' and len(ZipOrPostalCode)=4 then '0'+ZipOrPostalCode 
			end 
			,case when ZipOrPostalCode like '%-%' then substring(ZipOrPostalCode,charindex('-',ZipOrPostalCode)+1,len(ZipOrPostalCode))
				  when ZipOrPostalCode not like '%-%' and len(ZipOrPostalCode)=10 then Replace(SubString(ZipOrPostalCode, 6, 2000), '-', '')
				  when ZipOrPostalCode not like '%-%' and len(ZipOrPostalCode)=9 then right(ZipOrPostalCode,4)
				  when ZipOrPostalCode not like '%-%' and len(ZipOrPostalCode)=8 then  right(ZipOrPostalCode,3)  
			end 
			,[dbo].[clean_and_trim_string_space](replace(replace(replace(replace(Cellular,'(',''),')',''),'-',''),' ','')) as Cellular
			,[dbo].[clean_and_trim_string_space](replace(replace(replace(replace(HomePhone,'(',''),')',''),'-',''),' ','')) as HomePhone
			,[dbo].[clean_and_trim_string_space](replace(replace(replace(replace(Telephone,'(',''),')',''),'-',''),' ','')) as Telephone
			,iif( EmailDesc = 'home' , Email ,'') 
			,iif( EmailDesc2 = 'home' , Email2 ,'')   
			,case when EmailDesc = 'work' then Email
				  when EmailDesc2 = 'work' then Email2
				  when EmailDesc3 = 'work' then Email3
			 end 
			,a.file_process_id
			,a.file_process_detail_id
			,DateAdded as active_dt --iif(deal_date is null ,cast(replace(NULLIF(purchase_date,''),'00000000','') as date ),cast(replace(NULLIF(deal_date,''),'00000000','') as date )) as active_dt
			,'' -- vin
			,'Customer'
			,case when BlockPhone = 'N' then 0 
		      when BlockPhone = 'Y' then 1
			  when (BlockPhone = null or BlockPhone = '') then 0 end
			,case when BlockEMail = 'N' then 0 
		      when BlockEMail = 'Y' then 1
			  when (BlockEMail = null or BlockEMail = '')  then 0 end
			,case when BlockMail = 'N' then 0 
		      when BlockMail = 'Y' then 1
			  when BlockMail = null then 0 end		 
			,0 as BlockDataShare-- isnull(BlockDataShare,0)  
			,case when OptOutFlag = 'N' then 0 
		      when OptOutFlag = 'Y' then 1
			  when OptOutFlag = null then 0 end
			,a.Gender
			,a.PreferredLanguage
			,LastUpdated as last_activity_date
	from [etl].[cdk_customer] a with(nolock) 
	inner join master.dealer c with(nolock) on 
		a.src_dealer_code = c.natural_key
	left outer join stg.fi_sales fi with(nolock) on 
		a.src_dealer_code = fi.src_Dealer_code and 
		a.custno = fi.buyer_id 
	left outer join stg.service_ro_header srh with(nolock) on 
		a.src_dealer_code = srh.src_Dealer_code and 
		a.custno = srh.cust_dms_number
	where  
		  c.is_deleted=0
		  --c.oem_code in('GM','DD','POR','LEXUS','FCA','MTB') and
		  --b.source_of_dealer in('OC','Peak') and
		  --( b.dealer_source = 'CDK 3PA' or b.dealer_source = '3PACDK'  ) and
		 -- a.cdk_dealer_code in('3PA0003483','3PA29280') and
		  and a.file_process_id = @file_process_id 
		  and (fi.deal_number_dms is null and srh.ro_number is null)
	
	/*	  		
	insert into #customer_insert
		( 
			 parent_dealer_id
			,natural_key
			,src_dealer_code
			,cust_dms_number
			,cust_full_name
			,cust_first_name
			,cust_middle_name
			,cust_last_name
			,cust_address1
			,cust_city
			,cust_country
			,cust_state_code
			,cust_zip_code
			,cust_zipcode
			,cust_mobile_phone
			,cust_home_phone
			,cust_work_phone
			,cust_email_address1
			,cust_email_address2
			,cust_work_email_address
			,file_process_id
			,file_process_detail_id
			,active_dt
			,vin
			,file_source
		)
		
	select distinct 
			 c.parent_dealer_id
			,c.natural_key
			,[dbo].[clean_and_trim_string_space](isnull(a.src_dealer_code,''))
			,[dbo].[clean_and_trim_string_space](isnull(CustNo,''))
			,isnull(name1,'')
			--,isnull(dbo.camelcase(iif([dbo].[clean_and_trim_string_space]((replace(replace(isnull(FirstName,''),' ','')+' '+iif((isnull(MiddleName,'') ='' or MiddleName = ' '),'',replace(MiddleName,' ',''))+' '+ltrim(rtrim(isnull(LastName,''))),'  ',' '))) = '',[dbo].[clean_and_trim_string_space]((isnull(name1,''))),[dbo].[clean_and_trim_string_space]((replace(replace(isnull(FirstName,''),' ','')+' '+iif((isnull(middlename,'') ='' or middlename = ' '),'',replace(middlename,' ',''))+' '+ltrim(rtrim(isnull(lastname,''))),'  ',' '))))),name1) as cust_full_name    
		 	,[dbo].[clean_and_trim_string_space]([dbo].[CamelCase](isnull(FirstName  ,''))) 
			,[dbo].[clean_and_trim_string_space]([dbo].[CamelCase](isnull(MiddleName ,'')))  
			,[dbo].[clean_and_trim_string_space]([dbo].[CamelCase](isnull(LastName	 ,'')))   
			,[dbo].[clean_and_trim_string_space](isnull(Address , ''))
			,[dbo].[clean_and_trim_string_space](isnull(a.City    , ''))
			,[dbo].[clean_and_trim_string_space](isnull(a.Country , ''))
			,[dbo].[clean_and_trim_string_space](isnull(a.State   , ''))  
			,case when ZipOrPostalCode like '%-%' then substring(ZipOrPostalCode,1,charindex('-',ZipOrPostalCode)-1)
				  when ZipOrPostalCode not like '%-%' and len(ZipOrPostalCode)=10 then left(ZipOrPostalCode,5)
				  when ZipOrPostalCode not like '%-%' and len(ZipOrPostalCode)=9 then left(ZipOrPostalCode,5)
				  when ZipOrPostalCode not like '%-%' and len(ZipOrPostalCode)=8 then left(ZipOrPostalCode,5)
				  when ZipOrPostalCode not like '%-%' and len(ZipOrPostalCode)=4 then '0'+ZipOrPostalCode 
			end 
			,case when ZipOrPostalCode like '%-%' then substring(ZipOrPostalCode,charindex('-',ZipOrPostalCode)+1,len(ZipOrPostalCode))
				  when ZipOrPostalCode not like '%-%' and len(ZipOrPostalCode)=10 then Replace(SubString(ZipOrPostalCode, 6, 2000), '-', '')
				  when ZipOrPostalCode not like '%-%' and len(ZipOrPostalCode)=9 then right(ZipOrPostalCode,4)
				  when ZipOrPostalCode not like '%-%' and len(ZipOrPostalCode)=8 then  right(ZipOrPostalCode,3)  
			end 
			,[dbo].[clean_and_trim_string_space](replace(replace(replace(replace(Cellular,'(',''),')',''),'-',''),' ','')) as Cellular
			,[dbo].[clean_and_trim_string_space](replace(replace(replace(replace(HomePhone,'(',''),')',''),'-',''),' ','')) as HomePhone
			,[dbo].[clean_and_trim_string_space](replace(replace(replace(replace(Telephone,'(',''),')',''),'-',''),' ','')) as Telephone
			,iif( EmailDesc = 'home' , Email ,'') 
			,iif( EmailDesc2 = 'home' , Email2 ,'')   
			,case when EmailDesc = 'work' then Email
				  when EmailDesc2 = 'work' then Email2
				  when EmailDesc3 = 'work' then Email3
			 end 
			,ro.file_process_id
			,ro.file_process_detail_id
			,cast(replace(NULLIF(ro_close_date,''),'00000000','') as date ) as active_dt
			,vin
			,'Service'
	from [etl].[cdk_customer] a with(nolock) 
	inner join master.dealer c with(nolock) on 
		a.src_dealer_code = c.natural_key 
	left outer join stg.service_ro_header ro with(nolock) on 
		a.src_dealer_code = ro.src_dealer_code and 
		a.custno = ro.cust_dms_number 
	where 
		  c.is_deleted=0 and
		  --b.is_deleted=0 and
		  --b.source_of_dealer in('OC','Peak') and
		  --c.oem_code in('GM','DD','POR','LEXUS','FCA','MTB') and
		  --( b.dealer_source = 'CDK 3PA' or b.dealer_source = '3PACDK'  ) and
		  ---a.cdk_dealer_code in('3PA0003483','3PA29280') and
		  ro.file_process_id = @file_process_id 
		  and ro.ro_number is null
*/
	
	create nonclustered index idx_cust_rnk_customer_insert on  #customer_insert (cust_dms_number,natural_key) include(vin);

	print '/*Updating preferredLanguage*/'
	update 
		a 
	set 
		a.preferred_language = b.PreferredLanguage
	from #customer_insert a
	inner join etl.cdk_customer b (nolock) on 
			a.cust_dms_number = b.CustNo
	where a.file_process_id = @file_process_id
	and a.preferred_language is null and b.PreferredLanguage is not null

	Update 
		a 
	set 
		a.active_dt = b.DateAdded
	from #customer_insert a
	inner join etl.cdk_customer b (nolock) on 
			a.cust_dms_number = b.CustNo
	where 
	a.file_process_id = @file_process_id
	and a.active_dt != Cast(b.DateAdded as date)


----------------------------------------update cust_do_not..... data from etl.cdk_customer table
print 'Updating Cust_do_not_call,mail,email coulnms from etl.cdk_customer'
update c set

		 c.cust_do_not_call=iif(ec.BlockPhone='Y',1,0)
		,c.cust_do_not_email=iif(ec.BlockEMail='Y',1,0)
		,c.cust_do_not_mail=iif(ec.BlockMail='Y',1,0)

from #customer_insert  c 
	inner join etl.cdk_customer ec (nolock) 
	on c.file_process_id=ec.file_process_id 
		and c.cust_dms_number=ec.CustNo
		and c.natural_key =ec.src_dealer_code

where  c.file_process_id=@file_process_id
		and (BlockEMail='Y'or BlockMail='Y'or BlockPhone='Y')
-------------------------------------------------------------------------------------------------
print 'Updating Email address from etl.cdk_customer'
update c set

		 c.cust_email_address1=lower(ec.Email)
		,c.cust_email_address2=lower(ec.Email2)
		,c.cust_work_email_address=lower(ec.Email3)

from #customer_insert  c 
	inner join etl.cdk_customer ec (nolock) 
	on c.file_process_id=ec.file_process_id 
		and c.cust_dms_number=ec.CustNo
		and c.natural_key =ec.src_dealer_code

where  c.file_process_id=@file_process_id
	and len(c.cust_email_address1)<2

--------------------------------------------------------------------------------------------------



-------------------------------------------------Updating Customer DMS Number based on existing data--------------------------------------------------
	
	print '/*Updating Customer DMS Number based on Customer Full Name and Cust Mobile No */'
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

	print '/*Updating Customer DMS Number based on Customer Full Name and Cust Home No */'
	
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
	
	print '/*Updating Customer DMS Number based on Customer Full Name, Address and ZipCode */'

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

	print '/*Cust Full + Substring(VIN,11,7) */'

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
	
	select rank() over (partition by cust_dms_number, natural_key, cust_full_name, vin order by last_activity_date desc, cust_insert_id desc) as rnk, * into #temp from #customer_insert

	print '/*Loading Customer data into temptable */'
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
		,file_process_id
		,file_process_detail_id
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
		
	print '/*Updating blank cust_dms_number flag is_invalid_dms_num */ '
		
	 update #cust_rnk set is_invalid_dms_num =1 where cust_dms_number = ''	  

	-- Loading customer data into mail table 
	   insert into stg.customers
	     (
	     parent_dealer_id --1
		,vin  --2
		,natural_key  --3
		,src_dealer_code   --4
		,cust_dms_number  --5
		,cust_salutation_text  --6
		,cust_full_name --7
		,cust_first_name --8
		,cust_middle_name  --9
		,cust_last_name --10
		,cust_suffix --11
		,cust_address1 --12
		,cust_address2 --13
		,cust_city --14
		,cust_state_code --15
		,cust_zip_code --16
		,cust_zip_code4 --17
		,cust_mobile_phone  --18
		,cust_home_phone  --19
		,cust_work_phone  --20
		,cust_email_address1  --21
		,cust_email_address2  --22
		,cust_birth_date  --23
		,cust_gender --24
		,cust_status --25
		,active_date --26
		,inactive_date  --27
		,file_process_id   --28
		,file_process_detail_id --29
		,co_buyer_id  --30
		,co_buyer_salutation_text   --31
		,co_buyer_first_name --32
		,co_buyer_middle_name  --33
		,co_buyer_last_name --34
		,co_buyer_suffix --35
		,co_buyer_full_name --36
		,co_buyer_address1  --37
		,co_buyer_address2   --38
		,co_buyer_city   --39
		,co_buyer_district   --40
		,co_buyer_region   --41
		,co_buyer_zip_code  --42
		,co_buyer_country   --43
		,co_buyer_home_phone   --44
		,co_buyer_home_phone_ext   --45
		,co_buyer_home_ph_country_code   --46
		,co_buyer_mobile_phone  --47
		,co_buyer_work_phone   --48
		,co_buyer_work_phone_ext  --49
		,co_buyer_work_ph_country_code  --50
		,co_buyer_email_address1   --51
		,co_buyer_email_address2  --52
		,co_buyer_birth_date   --53
		,cust_work_address_district --54
		,cust_work_address_city --55
		,cust_work_address_zip_code --56
		,cust_work_address_region --57
		,cust_work_address_country --58
		,cust_birth_type --59
		,cust_category --60
		,customer_type --61
		,cust_driver_type --62
		,cust_lic_number --63
		,cust_driver_lic_exp_dt --64
		,created_date --65
		,updated_date --66
		,created_by --67
		,updated_by --68
		,cust_do_not_call --69
		,cust_do_not_email --70
		,cust_do_not_mail --71
		,is_invalid_dms_num  --72
		,is_deleted   --73
		,model_score_100 --74
		,model_score_110  --75
		,model_score_200  --76
		,model_score_550  --77
		,model_score_555  --78
		,model_score_650  --79
		,prison_flag   --80
		,deceased_flag  --81
		,under_14_flag   --82
		,name_based_suppress_flag --83
		,upfitter_address_flag  --84
		,household_id  --85
		,is_vehicle_owner  --86
		,cust_age --87
		,is_blank_record --88
		,is_invalid_email --89
   )
	   
     select distinct
		 ci.parent_dealer_id  --1
		,ci.vin --2
		,ci.natural_key  --3
		,ci.src_dealer_code    --4
		,iif(ci.cust_dms_number = '',ci.natural_key+'*'+right(ci.vin,8) ,ci.cust_dms_number) --5
		,isnull(ci.cust_salutation_text,'')  --6
		,isnull(ci.cust_full_name,'')  --7
		,isnull(ci.cust_first_name,'')    --8
		,isnull(ci.cust_middle_name,'') --9
		,isnull(ci.cust_last_name,'') --10
		,isnull(ci.cust_suffix,'')  --11
		,isnull(ci.cust_address1,'')   --12
		,isnull(ci.cust_address2,'')  --13
		,isnull(ci.cust_city,'') --14
		,isnull(ci.cust_state_code,'')   --15
		,isnull(ci.cust_zip_code,'') --16
		,isnull(ci.cust_zipcode4,'') --17
		,isnull(ci.cust_mobile_phone,'')    --18
		,isnull(ci.cust_home_phone,'')     --19
		,isnull(ci.cust_work_phone,'')   --20
		,lower(isnull(ci.cust_email_address1,''))  --21
		,isnull(ci.cust_email_address2,'')  --22
		,iif(ci.cust_birth_date= '1900-01-01','',convert(varchar(8),cast(ci.cust_birth_date as date),112)) as  cust_birth_date   --23
		,isnull(ci.cust_gender,'') --24
		,isnull(ci.cust_status,'')  --25
		,convert(varchar(8),cast(ci.active_dt as date),112) as active_dt --26
		,convert(varchar(8),cast(ci.inactive_dt as date),112) as inactive_dt  --27
		,ci.file_process_id  --28
		,ci.file_process_detail_id --29
		,ci.co_buyer_id  --30
		,isnull(ci.co_buyer_salutation_text,'')   --31
		,isnull(ci.co_buyer_first_name,'')   --32
		,isnull(ci.co_buyer_middle_name,'')   --33
		,isnull(ci.co_buyer_last_name,'')   --34
		,isnull(ci.co_buyer_suffix,'')   --35
		,isnull(ci.co_buyer_full_name,'')   --36
		,isnull(ci.co_buyer_address1,'')  --37
		,isnull(ci.co_buyer_address2,'')   --38
		,isnull(ci.co_buyer_city,'')   --39
		,isnull(ci.co_buyer_district,'')   --40
		,isnull(ci.co_buyer_region,'')   --41
		,isnull(ci.co_buyer_zip_code,'')  --42
		,isnull(ci.co_buyer_country,'')   --43
		,isnull(ci.co_buyer_home_phone,'')   --44
		,isnull(ci.co_buyer_home_phone_ext,'')   --45
		,isnull(ci.co_buyer_home_ph_country_code,'')   --46
		,isnull(ci.co_buyer_mobile_phone,'')  --47
		,isnull(ci.co_buyer_work_phone,'')   --48
		,isnull(ci.co_buyer_work_phone_ext,'')  --49
		,isnull(ci.co_buyer_work_ph_country_code,'')  --50
		,isnull(ci.co_buyer_email_address1,'')   --51
		,isnull(ci.co_buyer_email_address2,'')  --52
		,iif(ci.co_buyer_birth_date=  '1900-01-01','',convert(varchar(8),cast(ci.co_buyer_birth_date as date),112)) as co_buyer_birth_date    --53
		,isnull(ci.cust_work_address_district,'') --54
		,isnull(ci.cust_work_address_city,'') --55
		,isnull(ci.cust_work_address_postal_code,'') --56
		,isnull(ci.cust_work_address_region,'') --57
		,isnull(ci.cust_work_address_country,'') --58
		,isnull(ci.cust_birth_type,'') --59
		,isnull(ci.cust_category,'') --60
		,isnull(ci.customer_type,'') --61
		,isnull(ci.cust_driver_type,'') --62
		,isnull(ci.cust_lic_number,'') --63
		,iif(ci.cust_driver_lic_exp_dt= '1900-01-01','',convert(varchar(8),cast(ci.cust_driver_lic_exp_dt as date),112)) as cust_driver_lic_exp_dt --64
		,getdate() --65
		,getdate() --66
		,suser_name() --67
		,suser_name() --68
		,0 --69
		,0 --70
		,0 --71
		,is_invalid_dms_num  --72
		,0 --73
		,isnull(model_score_100,'') --74
		,isnull(model_score_110,'')  --75
		,isnull(model_score_200,'')  --76
		,isnull(model_score_550,'')  --77
		,isnull(model_score_555,'')  --78
		,isnull(model_score_650,'')  --79
		,prison_flag --80
		,deceased_flag --81
		,under_14_flag --82
		,name_based_suppress_flag --83
		,upfitter_address_flag --84
		,household_id  --85
		,ci.is_vehicle_owner --86
		,cust_age --87
		,0 --88
		,0 --89
	 from 
	    #cust_rnk ci  
	where 1 = 1	
		and len(cust_dms_number)>0    
	   and ci.rnk = 1
	   order by 5

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
    where file_process_id = @file_process_id 
	

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
print '/*Updating Fleet or  Customers */'	 
	 update  stg.customers   
	   set 
		customer_type = iif(cust_full_name like '% INC%' or cust_full_name like '% LLC%','F','C') 
	 where 
		1 = 1 
	 and file_process_id = @file_process_id 
		

	 update  stg.customers   
	   set 
		customer_type = iif(cust_first_name is null or cust_first_name = '' ,'B','C') 
	 where 
		1 = 1		 
		and customer_type <> 'F'-- and oem_id<>34
		and file_process_id = @file_process_id 
		


--------------------------------------------------Updating mail_flag and mail preferance --------------------------------------------

print '/*Updating mail_flag and mail preferance */'
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

	-- select distinct b.ro_number 'cust_dms_number',b.id,b.items as follow_up_type,ro.natural_key,vin into #mail1 from #customer_insert ro with(nolock) 
 --    cross apply  [etl].[split_ro_detail](ro.cust_dms_number,ro.follow_up_type,'|') as b  	  

	-- select distinct b.ro_number 'cust_dms_number',b.id,b.items as follow_up_value,ro.natural_key,vin into #mail2  from #customer_insert ro with(nolock) 
 --    cross apply  [etl].[split_ro_detail](ro.cust_dms_number,ro.follow_up_value,'|') as b 
	 
	-- select distinct cust_dms_number,id,follow_up_type as value,natural_key,vin,'follow_up_type' as name into #mail3 from #mail1 
	-- union
	-- select distinct *,'follow_up_value' from #mail2

	-- select * into #mail4
 --    from 
 --    (
 --    select cust_dms_number,id,natural_key,name,value,vin
 --    from #mail3
 --    ) src
 --    pivot
 --     (
 --     max(value)
 --     for name  in ( [follow_up_type],[follow_up_value])
 --    ) piv;

	-- select
	--         cust_dms_number
	--        ,id
	--		,natural_key
	--		,case when follow_up_value = 'P' then 'Phone'
 --                 when follow_up_value = 'E' then 'Email'
	--			  when follow_up_value = 'M' then 'Mail'
	--		 else follow_up_value end as status 
	--		,follow_up_type  
	--		,vin
	-- into
	--    #mail5 
	-- from  
	--    #mail4 

 --   select * into #mail6
 --   from 
 --   (
 --   select follow_up_type,cust_dms_number,status,vin
 --   from #mail5
 --   ) src
 --   pivot
 --   (
 --   max(follow_up_type)
 --   for status  in ([phone],[Email],[Mail],[OPT])
 --   ) piv;

	--select 
	--      cust_dms_number
 --      	 ,iif(phone = 'N',1, 0)as  cust_do_not_call
	--	 ,iif(email = 'N',1, 0)as  cust_do_not_email
	--	 ,iif(mail  = 'N',1, 0)as  cust_do_not_mail
	--	 ,iif(email = 'N' and phone = 'N' and mail = 'N',1, 0) as cust_opt_out
	--	 ,vin
 --   into 
	--  #mail7
	--from 
	--   #mail6 
print '/*Updating mailing_preference*/'
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
		   where file_process_id = @file_process_id	
		   
	 
--------------------------------------------------Updating invalid_email_flag ----------------------------------------------------------------------------------------------
print '/*Updating invalid_email_flag*/'			
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
					dbo.IsValidEmail(mcs.cust_email_address1)=0 

			update mcs
					set mcs.is_invalid_email=1,
						mcs.updated_by=system_user,
						mcs.updated_date=getdate()
				from 
					stg.customers mcs (nolock)
				where (cust_email_address1 = '' or cust_email_address1 is null)



	IF OBJECT_ID('tempdb..#customer_insert') IS NOT NULL DROP TABLE #customer_insert
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
	IF OBJECT_ID('tempdb..#cust_rnk') IS NOT NULL DROP TABLE #cust_rnk
	IF OBJECT_ID('tempdb..#mail1') IS NOT NULL DROP TABLE #mail1
	IF OBJECT_ID('tempdb..#mail2') IS NOT NULL DROP TABLE #mail2
	IF OBJECT_ID('tempdb..#mail3') IS NOT NULL DROP TABLE #mail3
	IF OBJECT_ID('tempdb..#mail4') IS NOT NULL DROP TABLE #mail4
	IF OBJECT_ID('tempdb..#mail5') IS NOT NULL DROP TABLE #mail5
	IF OBJECT_ID('tempdb..#mail6') IS NOT NULL DROP TABLE #mail6
	IF OBJECT_ID('tempdb..#mail7') IS NOT NULL DROP TABLE #mail7

end






		

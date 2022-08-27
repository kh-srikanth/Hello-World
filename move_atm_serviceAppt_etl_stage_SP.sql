USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [etl].[move_atm_serviceAppt_etl_stage]    Script Date: 10/8/2021 7:38:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [etl].[move_atm_serviceAppt_etl_stage]
--declare
	@file_process_id int 
AS
/*
-----------------------------------------------------------------------  
	Copyright 2021 Clictell

	PURPOSE  
	Loading Service Appointment Data from etl to stage

	PROCESSES  

	MODIFICATIONS  
	Date			Author		Work Tracker Id		Description    
	------------------------------------------------------------------------  
	05/11/2021		Srikanth	Created				Loading Service Appointment Data from etl to stage.
	------------------------------------------------------------------------

	exec [etl].[move_atm_serviceAppt_etl_stage] 10

	--SELECT natural_key, file_process_detail_id,  count(*) FROM [stg].[service_appts] (NOLOCK) group by natural_key, file_process_detail_id order by 1,2

	SELECT * FROM [stg].[service_appts] (NOLOCK) 
	select file_process_id, count(*) from [stg].[service_appts]  (nolock) group by file_process_id order by 1
	--select file_process_id, count(*) from [etl].[atm_service_appts] (nolock) group by file_process_id

	truncate table clictell_auto_stg.[stg].[service_appts]
	
	1	4
	3	39297
	4	352
	5	268
	6	190
	7	172
	8	199
	9	251
	10	1

	*/

Begin

	--declare @file_process_id int = 3

	IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
	IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3
	IF OBJECT_ID('tempdb..#temp4') IS NOT NULL DROP TABLE #temp4
	IF OBJECT_ID('tempdb..#temp7') IS NOT NULL DROP TABLE #temp7
	IF OBJECT_ID('tempdb..#temp8') IS NOT NULL DROP TABLE #temp8
	IF OBJECT_ID('tempdb..#temp9') IS NOT NULL DROP TABLE #temp9
	IF OBJECT_ID('tempdb..#temp10') IS NOT NULL DROP TABLE #temp10
	IF OBJECT_ID('tempdb..#temp11') IS NOT NULL DROP TABLE #temp11
	IF OBJECT_ID('tempdb..#temp12') IS NOT NULL DROP TABLE #temp12
	IF OBJECT_ID('tempdb..#temp_SrvAppts') IS NOT NULL DROP TABLE #temp_SrvAppts
	IF OBJECT_ID('tempdb..#temp_OwnerParty') IS NOT NULL DROP TABLE #temp_OwnerParty
	IF OBJECT_ID('tempdb..#temp_OwnerParty_address') IS NOT NULL DROP TABLE #temp_OwnerParty_address
	IF OBJECT_ID('tempdb..#temp_OwnerParty_Ids') IS NOT NULL DROP TABLE #temp_OwnerParty_Ids
	IF OBJECT_ID('tempdb..#temp_OwnerParty_communication') IS NOT NULL DROP TABLE #temp_OwnerParty_communication
	IF OBJECT_ID('tempdb..#temp_vehicle_colors') IS NOT NULL DROP TABLE #temp_vehicle_colors
	IF OBJECT_ID('tempdb..#temp_ServiceAdvisorParty') IS NOT NULL DROP TABLE #temp_ServiceAdvisorParty

	Print 'Step 1'
	Print getdate()
	select 
		a.*,
		d.parent_dealer_id,
		Rank() Over (Partition by documentId, serviceAppointmentNumber, a.natural_key, a.roNumber order by etl_srv_appt_id desc) as rnk
	into 
		#temp_SrvAppts
	from 
		[etl].[atm_service_appts] a (nolock)
	inner join master.dealer d (nolock) on d.natural_key = a.[natural_key]
	where 
		a.file_process_id = @file_process_id

	---------------------------------------------------------------- serviceAppointmentParties -----------------------------------------------
	Print 'Step 2'
	Print getdate()
	select etl_srv_appt_id, serviceAppointmentNumber
		,JSON_VALUE(b.[value], '$.partyType') as partyType
		,Json_Value([value], '$.customerTypeCode') as CustomerTypeCode
		,Json_Value([value], '$.specialRemarksDescription') as specialRemarksDescription
		,Json_Value([value], '$.businessTypeCode') as businessTypeCode
		,Json_Value([value], '$.title') as title
		,Json_Value([value], '$.salutation') as salutation
		,Json_Value([value], '$.nameSuffix') as nameSuffix
		,Json_Value([value], '$.givenName') as givenName
		,Json_Value([value], '$.middleName') as middleName
		,Json_Value([value], '$.familyName') as familyName
		,Json_Value([value], '$.companyName') as companyName
		,Json_Value([value], '$.birthDate') as birthDate
		,Json_Query([value], '$.idList') as idList
		,Json_Query([value], '$.primaryContact') as primaryContact
		,(Case when Json_Query([value], '$.address') is not null then Json_Query([value], '$.address')  else Json_Query([value], '$.primaryContact.address') end) as [address]
		,(Case when Json_Query([value], '$.communication') is not null then Json_Query([value], '$.communication')  else Json_Query([value], '$.primaryContact.communication') end) as communication
		--,Json_Query([value], '$.communication') as communication
		,Json_Value([value], '$.maritalStatusCode') as maritalStatusCode
		,Json_Value([value], '$.genderCode') as genderCode
		,Json_Value([value], '$.preferredName') as preferredName
		,Json_Value([value], '$.driverLicense.licenseNumber') as licenseNumber
		,Json_Value([value], '$.driverLicense.licenseState') as licenseState
		,Json_Value([value], '$.driverLicense.licenseExpiration') as licenseExpiration
		,Json_Value([value], '$.driverLicense.licenseIssuedDate') as licenseIssuedDate
		,Json_Value([value], '$.doingBusinessAsName') as doingBusinessAsName
		,Json_Value([value], '$.contactMethodTypeCode') as contactMethodTypeCode
		,Json_Value([value], '$.legalClassificationCode') as legalClassificationCode
		,Json_Value([value], '$.inceptionDateTime') as inceptionDateTime
		,Json_Value([value], '$.specifiedOccupationTitle') as specifiedOccupationTitle
		,Json_Value([value], '$.notes') as notes
		,Json_Query([value], '$.customerInformationRewardsCard') as customerInformationRewardsCard
		,Json_Query([value], '$.partyActionEvent') as partyActionEvent
		, 0 as [Block Phone]
		, 0 as [Block Email] 
		, 0 as [Block Mail]
		, 0 as [Do Not Sahre Email]
		, 0 as [Do Not Sahre Phone]
		, 0 as [Do Not Sahre Mail]
	into #temp_OwnerParty
	from #temp_SrvAppts a
	Cross Apply OpenJSon(a.serviceAppointmentParties) as b
	where a.rnk = 1 and
	JSON_VALUE(b.[value], '$.partyType') in ('OwnerParty')

		---------------------------------------------------------------- serviceAppointmentParties IDs -----------------------------------------------
		Print 'Step 3'
		Print getdate()
		select etl_srv_appt_id, serviceAppointmentNumber
			,Json_value(b.[value], '$.id') as id
			,Json_value(b.[value], '$.typeId') as typeId
		into 
			#temp1
		from #temp_OwnerParty a
		CROSS APPLY OpenJSon(IdList) b

		Print 'Step 4'
		Print getdate()
		select etl_srv_appt_id, serviceAppointmentNumber, DMSId, OEMId, Other as OtherID, ThirdPartyId 
		into #temp_OwnerParty_Ids
		from
		(
			select etl_srv_appt_id, serviceAppointmentNumber, id, typeid
			from #temp1
		) d
		pivot
		(
			max(id)
			for [typeid] in (DMSId, OEMId, Other, ThirdPartyId)
		) piv;	
		-------------------------------------------------------------- ServiceAppointmentParties Ids ----------------------------------------------
		---------------------------------------------------------------- serviceAppointmentParties -----------------------------------------------
		Print 'Step 5'
		Print getdate()
		select etl_srv_appt_id, serviceAppointmentNumber, b.[key] as Index_id
			,Json_Value([value], '$.addressType') as addressType
			,Json_Value([value], '$.addressId') as addressId
			,Json_Value([value], '$.lineOne') as lineOne
			,Json_Value([value], '$.lineTwo') as lineTwo
			,Json_Value([value], '$.lineThree') as lineThree
			,Json_Value([value], '$.lineFour') as lineFour
			,Json_Value([value], '$.cityName') as cityName
			,Json_Value([value], '$.countryId') as countryId
			,Json_Value([value], '$.postCode') as postCode
			,Json_Value([value], '$.stateOrProvinceCountrySubDivisionId') as stateOrProvinceCountrySubDivisionId
			,Json_Value([value], '$.countyCountrySubDivision') as countyCountrySubDivision
			,Json_Query([value], '$.privacy') as privacy
		into #temp3
		from #temp_OwnerParty a
		Cross apply OpenJson([address]) b

		Print 'Step 6'
		Print getdate()
		select etl_srv_appt_id, serviceAppointmentNumber, addressType, a.Index_id
			,Json_Value(b.[value], '$.privacyIndicator') as privacyIndicator
			,Json_Value(b.[value], '$.privacyIndicatorDescription') as privacyIndicatorDescription
			,Json_Value(b.[value], '$.privacyType') as privacyType
			,Json_Value(b.[value], '$.startDateTime') as startDateTime
			,Json_Value(b.[value], '$.endDateTime') as endDateTime
		into #temp4
		from #temp3 a
		Cross Apply OpenJSon(privacy) b

		Print 'Step 7'
		Print getdate()
		select a.etl_srv_appt_id, a.serviceAppointmentNumber, a.addressType, a.addressId, a.lineOne, a.lineTwo, a.lineThree, a.lineFour, a.cityName, a.stateOrProvinceCountrySubDivisionId, a.countyCountrySubDivision, a.countryId,
				a.postCode, b.privacyIndicator, b.privacyIndicatorDescription, b.privacyType, b.startDateTime, b.endDateTime
		into #temp_OwnerParty_address
		from #temp3 a
		left outer join #temp4 b on a.etl_srv_appt_id = b.etl_srv_appt_id and a.Index_id = b.Index_id 
		Order by 1
		---------------------------------------------------------------- serviceAppointmentParties Address -----------------------------------------------
		---------------------------------------------------------------- serviceAppointmentParties Communication -----------------------------------------------

		Print 'Step 8'
		Print getdate()
		select  etl_srv_appt_id, serviceAppointmentNumber, Index_id, channelCode, (Case When channelCode like '%Email' then emailAddress else completeNumber end) as completeNumber, privacy
		into #temp10
		from 
		(
		select  a.etl_srv_appt_id, a.serviceAppointmentNumber, b.[Key] as Index_id
			,Json_Value(b.[value], '$.channelCode') + '_' + Json_Value(b.[value], '$.channelType') as channelCode
			,Isnull(Json_Value(b.[value], '$.completeNumber'), '') + '#' + Isnull(Json_Value(b.[value], '$.extensionNumber'), '') as completeNumber
			,Json_Value(b.[value], '$.emailAddress') as emailAddress
			,Json_Query(b.[value], '$.privacy') as privacy
		from #temp_OwnerParty a
		Cross apply OpenJson(communication) b
		) as a

		Print 'Step 9'
		Print getdate()
		select  a.etl_srv_appt_id, a.serviceAppointmentNumber, Index_id
			,Json_Value(b.[value], '$.privacyIndicator') as privacyIndicator
			,Json_Value(b.[value], '$.privacyIndicatorDescription') as privacyIndicatorDescription
			,Json_Value(b.[value], '$.privacyType') as privacyType
			,Json_Value(b.[value], '$.startDateTime') as startDateTime
			,Json_Value(b.[value], '$.endDateTime') as endDateTime
		into #temp11
		from #temp10 a
		Cross Apply OpenJSon(privacy) b
			
		Print 'Step 10'
		Print getdate()
		select  a.etl_srv_appt_id, a.serviceAppointmentNumber, Isnull(a.channelCode, 'Other_Phone') as channelCode, a.completeNumber, b.privacyIndicator, b.privacyIndicatorDescription, b.privacyType, b.startDateTime, b.endDateTime
		into #temp12
		from #temp10 a
		left outer join #temp11 b on a.etl_srv_appt_id = b.etl_srv_appt_id and a.Index_id = b.Index_id
		Order by 1

		Print 'Step 11'
		Print getdate()

		select  etl_srv_appt_id, serviceAppointmentNumber, Cell_Phone, Home_Phone, Other_Phone, Personal_Email, Work_Phone, Fax_Phone
		into #temp_OwnerParty_communication
		from
		(
			select  etl_srv_appt_id, serviceAppointmentNumber, channelCode, completeNumber
			from #temp12
		) d
		pivot
		(
			max(completeNumber)
			for channelCode in (Cell_Phone, Home_Phone, Other_Phone, Personal_Email, Work_Phone, Fax_Phone)
		) piv;	

		Update a set a.[Block Phone] = b.[Block Phone]
		from #temp_OwnerParty a 
		inner join (select distinct etl_srv_appt_id, 1 as [Block Phone] from #temp12  where channelcode like '%Phone' and PrivacyType is null) b on a.etl_srv_appt_id = b.etl_srv_appt_id
			
		Update a set a.[Block Email] = b.[Block Email]
		from #temp_OwnerParty a 
		inner join (select distinct etl_srv_appt_id, 1 as [Block Email] from #temp12  where channelcode like '%Email' and PrivacyType is null) b on a.etl_srv_appt_id = b.etl_srv_appt_id

		Update a set a.[Do Not Sahre Email] = b.[Do Not Sahre Email]
		from #temp_OwnerParty a 
		inner join (select distinct etl_srv_appt_id, 1 as [Do Not Sahre Email] from #temp12  where channelcode like '%Email' and privacyIndicator = 'false') b on a.etl_srv_appt_id = b.etl_srv_appt_id

		Update a set a.[Do Not Sahre Phone] = b.[Do Not Sahre Phone]
		from #temp_OwnerParty a 
		inner join (select distinct etl_srv_appt_id, 1 as [Do Not Sahre Phone] from #temp12  where channelcode like '%Phone' and privacyIndicator = 'false') b on a.etl_srv_appt_id = b.etl_srv_appt_id


		---------------------------------------------------------------- serviceAppointmentParties Communication-----------------------------------------------
		-------------------------------------------------------------- serviceAppointmentParties ServiceAdvisorParty ----------------------------------------------
		Print 'Step 12'
		Print getdate()
		select etl_srv_appt_id, serviceAppointmentNumber
			,JSON_VALUE(b.[value], '$.partyType') as partyType
			,Json_Value([value], '$.customerTypeCode') as CustomerTypeCode
			,Json_Value([value], '$.givenName') as givenName
			,Json_Value([value], '$.middleName') as middleName
			,Json_Value([value], '$.familyName') as familyName
			,Json_Query([value], '$.idList') as idList
		into #temp8
		from #temp_SrvAppts a
		Cross Apply OpenJSon(a.serviceAppointmentParties) as b
		where a.rnk = 1 and
		JSON_VALUE(b.[value], '$.partyType') in ('ServiceAdvisorParty', 'ServiceTechnicianParty')

		Print 'Step 13'
		Print getdate()
		select a.etl_srv_appt_id, a.serviceAppointmentNumber, a.partyType
			,JSon_Value(b.[value], '$.typeId') as typeID
			,JSon_Value(b.[value], '$.id') as id
		into #temp7
		from #temp8 a
		Cross Apply OpenJSon(idList) b 

		Print 'Step 14'
		Print getdate()

		select etl_srv_appt_id, serviceAppointmentNumber, partyType, DMSId, OEMId, Other, ThirdPartyId 
		into #temp9
		from
		(
			select etl_srv_appt_id, serviceAppointmentNumber, partyType, id, typeid
			from #temp7
		) d
		pivot
		(
			max(id)
			for [typeid] in (DMSId, OEMId, Other, ThirdPartyId)
		) piv;	

		Print 'Step 15'
		Print getdate()
		select a.etl_srv_appt_id, a.serviceAppointmentNumber, a.partyType, a.CustomerTypeCode, a.givenName, a.middleName, a.familyName, b.DMSId, b.Other as OtherID, b.OEMId, b.ThirdPartyId
		into #temp_ServiceAdvisorParty
		from #temp8 a
		inner join #temp9 b on a.etl_srv_appt_id = b.etl_srv_appt_id and a.partyType = b.partyType
	
		-------------------------------------------------------------- serviceAppointmentParties ServiceAdvisorParty ----------------------------------------------
---------------------------------------------------------------- serviceAppointmentParties -----------------------------------------------
---------------------------------------------------------------- serviceAppointment Vehicle Colors -----------------------------------------------
	Print 'Step 16'
	Print getdate()

	select a.etl_srv_appt_id
			,JSon_Value([value], '$.colorItemCode') as colorItemCode
			,JSon_Value([value], '$.manufacturerColorCode') as manufacturerColorCode
			,JSon_Value([value], '$.colorDescription') as colorDescription
			,JSon_Value([value], '$.colorName') as colorName
	into #temp_vehicle_colors
	from 
		#temp_SrvAppts a
	Cross Apply OpenJson(colorGroup) b
	where a.rnk = 1

---------------------------------------------------------------- serviceAppointment Vehicle Colors -----------------------------------------------

	--Update a set a.ext_clr = Isnull(b.colorName, b.colorDescription), a.ext_clr_code  = b.manufacturerColorCode
	--from #temp a
	--inner join #temp1 b on a.etl_srv_appt_id = b.etl_srv_appt_id and b.colorItemCode = 'Exterior'

	--Update a set a.int_clr = Isnull(b.colorName, b.colorDescription), a.int_clr_code  = b.manufacturerColorCode
	--from #temp a
	--inner join #temp1 b on a.etl_srv_appt_id = b.etl_srv_appt_id and b.colorItemCode = 'Interior'

	   /*
	IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2

	select a.[natural_key], a.[serviceAppointmentNumber], a.[appointmentDateTime], b.* into #temp2
	from 
	(
	select a.[natural_key], a.[serviceAppointmentNumber], a.[appointmentDateTime], b.*

	from #temp_SrvAppts a
	CROSS APPLY OPENJSON([requestedService]) as b
	) as a
	CROSS APPLY OPENJSON([value]) as b

	IF OBJECT_ID('tempdb..#requestedService') IS NOT NULL DROP TABLE #requestedService
	select distinct natural_key,serviceAppointmentNumber,[appointmentDateTime]
	,(select [value] from #temp2 b where a.serviceAppointmentNumber = b.serviceAppointmentNumber and a.[appointmentDateTime] = b.[appointmentDateTime] and b.[key] = 'jobNumber') as jobNumber
	,(select [value] from #temp2 b where a.serviceAppointmentNumber = b.serviceAppointmentNumber and a.[appointmentDateTime] = b.[appointmentDateTime] and b.[key] = 'jobType') as jobType
	,(select [value] from #temp2 b where a.serviceAppointmentNumber = b.serviceAppointmentNumber and a.[appointmentDateTime] = b.[appointmentDateTime] and b.[key] = 'serviceTechnicianId') as serviceTechnicianId
	,(select [value] from #temp2 b where a.serviceAppointmentNumber = b.serviceAppointmentNumber and a.[appointmentDateTime] = b.[appointmentDateTime] and b.[key] = 'sublet') as sublet
	,(select [value] from #temp2 b where a.serviceAppointmentNumber = b.serviceAppointmentNumber and a.[appointmentDateTime] = b.[appointmentDateTime] and b.[key] = 'serviceLaborScheduling') as serviceLaborScheduling
	,(select [value] from #temp2 b where a.serviceAppointmentNumber = b.serviceAppointmentNumber and a.[appointmentDateTime] = b.[appointmentDateTime] and b.[key] = 'codesAndCommentsExpanded') as codesAndCommentsExpanded
	into #requestedService
	from #temp2 a where serviceAppointmentNumber = 3181

	select * from #requestedService where serviceAppointmentNumber = 3181
	*/


	--IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3

	--select a.[natural_key], a.[serviceAppointmentNumber], a.[appointmentDateTime], b.* into #temp3
	--from 
	--(
	--select a.[natural_key], a.[serviceAppointmentNumber], a.[appointmentDateTime], b.*

	--from #temp a
	--CROSS APPLY OPENJSON([serviceAppointmentParties]) as b
	--) as a
	--CROSS APPLY OPENJSON([value]) as b


	--IF OBJECT_ID('tempdb..#cust_type_code') IS NOT NULL DROP TABLE #cust_type_code

	--select distinct natural_key,serviceAppointmentNumber,[appointmentDateTime]
	--		,(select [value] from #temp3 b where a.serviceAppointmentNumber = b.serviceAppointmentNumber and a.[appointmentDateTime] = b.[appointmentDateTime] and b.[key] = 'customerTypeCode') as customerTypeCode
	--into #cust_type_code
	--from #temp3 a

	--IF OBJECT_ID('tempdb..#temp_serviceadvisor') IS NOT NULL DROP TABLE #temp_serviceadvisor
	--select a.etl_srv_appt_id, a.givenName, a.middleName, a.familyName
	--	,JSON_VALUE(b.[value], '$.id') as Id
	--	,JSON_VALUE(b.[value], '$.typeId') as typeId
	--into #temp_serviceadvisor
	--  from 
	--  (
	--  select a.etl_srv_appt_id, b.*
	--	,JSon_Value(b.[value], '$.givenName') as givenName
	--	,JSon_Value(b.[value], '$.middleName') as middleName
	--	,JSon_Value(b.[value], '$.familyName') as familyName
	--	,JSon_Query(b.[value], '$.idList') as idList
	--  from #temp a
	--  Cross Apply OpenJson(serviceAppointmentParties) as b
	--  where JSon_VAlue(b.[value], '$.partyType') = 'ServiceAdvisorParty'
	--  ) as a
	--  Cross Apply OpenJson(idList) as b
	--  where JSon_VAlue(b.[value], '$.typeId') = 'DMSId'

	 -- ------------------------------------------------------ Code to get the Primary Contact Information for Business people--------------------------------------
	 -- select
		-- a.etl_srv_appt_id, b.*
	 --into #temp_primaryContact		
	 -- from 
	 -- (
	 -- select a.etl_srv_appt_id, b.*
		--,JSon_Query(b.[value], '$.primaryContact') as primaryContact
	 -- from #temp a
	 -- Cross Apply OpenJson(serviceAppointmentParties) as b
	 -- where JSon_Query(b.[value], '$.primaryContact') is not null
	 -- ) as a
	 -- CROSS APPLY OpenJSon(primaryContact) as b


	 -- select distinct a.etl_srv_appt_id 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'jobTitle')  
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'typeCode')  
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'idList') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'personName') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'givenName') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'middleName') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'familyName') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'title') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'salutation') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'nameSuffix') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'maritalStatusCode') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'genderCode') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'birthDate') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'preferredName') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'driverLicense') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'address') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'specifiedOccupationTitle') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'contactMethodTypeCode') 
		--,(select [value] from #temp_primaryContact b where a.etl_srv_appt_id = b.etl_srv_appt_id and [key] = 'communication') 
	 -- from #temp_primaryContact a

	  ------------------------------------------------------ Code to get the Primary Contact Information for Business people--------------------------------------

	Print 'Step 17'
	Print getdate()

	insert into [stg].[service_appts]
	(
       [parent_dealer_id]
      ,[natural_key]
	  ,[appt_id]
      ,[appt_time]
      ,[appt_date]
      ,[cust_dms_number]
      ,[cust_firstname]
	  ,[cust_middlename]
	  ,[cust_lastname]
      ,[cust_suffix]
      ,[cust_fullname]
      ,[cust_salut]
      ,[cust_address1]
      ,[cust_address2]
      ,[cust_city]
	  ,[cust_county]
      ,[cust_state]
      ,[cust_zip]
      ,[cust_country]
      ,[cust_home_phone]
      ,[cust_cell_phone]
      ,[cust_work_phone]
      ,[cust_email_address1]
	  ,[cust_gender]
      ,[cust_birth_date]
      --,[cust_opt_out]
      ,[vehicle_license_plate]
      ,[vin]
      ,[make]
      ,[year]
      ,[model_desc]
      --,[ExtClrDesc]
      ,[OdomReading]
      ,[vehicle_type]
      ,[vehicle_series]
      ,[vehicle_body_description]
      ,[carline]
      ,[trans_type]
      ,[customer_id]
      ,[cust_business_address1]
      ,[cust_business_address2]
      ,[cust_business_city]
      ,[cust_business_state]
      ,[cust_business_zip]
      ,[cust_business_country]
      ,[cust_business_phone]
      ,[MakeName]
      ,[Comments]
      --,[AdtlCustomer_CustNo]
      ,[cust_ibflag]
      ,[file_process_id]
      ,[file_process_detail_id]
      ,[appt_open_date]
      ,[appt_open_time]
	  ,[src_dealer_code]
      ,[adv_name_recid]
	  ,[adv_fullname]
      ,[adv_lastname]
      ,[adv_firstname]
	  --,[IntClrDesc]
	  ,[SpecialOrderNo]
	  ,last_updated_date
	  ,[cust_created_dt]
	  ,[cust_do_not_call]
      ,[cust_do_not_email]
      ,[cust_do_not_mail]

	  /* These columns in stg are not mapped with etl
	  ,[cust_email_address2]
      ,[cust_do_not_data_share]
      ,[stock_num]
      ,[stock_type]
      ,[dispatcher]
      ,[Complaint]
      ,[SpecialOrderNo]
      ,[Outsidesrc_Appointment]
      ,[AdtlCustomer_CustName]
      ,[AdtlCustomer_LanguagePref]
      ,[language]
      
      ,[cust_last_activity_dt]
	  */
	) 
	select 
	   a.parent_dealer_id
      ,a.[natural_key]
      ,a.[serviceAppointmentNumber]
      ,Convert(varchar(10), a.[appointmentDateTime], 108) as openAppointmentTime
	  ,Convert(varchar(10), a.[appointmentDateTime], 112) as openAppointmentDate
      ,t1.OtherID
      ,(Case when t.CustomerTypeCode = 'Business' then t.companyName else t.[givenName] end) as givenName
	  ,t.[middleName]
	  ,t.[familyName]
      ,[nameSuffix]
	  ,(Case when t.CustomerTypeCode = 'Business' then t.companyName else 
			((Case when t.[givenName] is not null then t.[givenName] else '' end) + (Case when t.middlename is not null then ' ' + t.middlename else '' end) + (Case when t.[familyName] is not null then ' ' + t.[familyName] else '' end)) 	  
	  end) as full_name
      --,[preferredName]
      ,[salutation]
	  , (Case when t2.lineOne is not null then t2.lineOne else '' end) + (Case when t2.lineTwo is not null then ' ' + t2.lineTwo else '' end) 
	  , (Case when t2.lineThree is not null then t2.lineThree else '' end) + (Case when t2.lineFour is not null then ' ' + t2.lineFour else '' end)
      ,t2.[cityName]
	  ,t2.countyCountrySubDivision
	  ,t2.stateOrProvinceCountrySubDivisionId
      ,t2.postCode
	  ,t2.countryId
	  ,Substring(t3.Home_Phone, 1, CHARINDEX('#',t3.Home_Phone, 1) - 1)
	  ,Substring(t3.Cell_Phone, 1, CHARINDEX('#',t3.Cell_Phone, 1) - 1)
	  ,Substring(t3.[Work_Phone], 1, CHARINDEX('#',t3.[Work_Phone], 1) - 1)
      ,t3.Personal_Email
      ,[genderCode]
      ,[birthDate]
      --,[Residence_privacyIndicator]
      ,[licenseNumber]
      ,[vehicleId]
      ,[make]
      ,[modelYear]
      ,[modelDescription]
      --,[colorGroup] --
	  --,Isnull(ext_clr, ext_clr_code)
      ,[actualOdometer]
      ,[vehicleClassCode]
      ,[seriesCode]
      ,[bodyStyle]
      ,[modelClass]
      ,[transmissionTypeName]
	  , t1.DMSID
      --[OwnerParty_ThirdPartyId]
	  , (Case when t4.lineOne is not null then t4.lineOne else '' end) + (Case when t4.lineTwo is not null then ' ' + t4.lineTwo else '' end) 
	  , (Case when t4.lineThree is not null then t4.lineThree else '' end) + (Case when t4.lineFour is not null then ' ' + t4.lineFour else '' end)
      ,t4.[cityName]
	  ,t4.stateOrProvinceCountrySubDivisionId
      ,t4.postCode
	  ,t4.countryId
	  ,Substring(t3.[Work_Phone], 1, CHARINDEX('#',t3.[Work_Phone], 1) - 1)
      ,[manufacturerName]
      ,[appointmentNotes]
      --,[OwnerParty_Other]
      --,[serviceAppointmentParties] -- 
	  ,iif(t.customertypecode = 'Person','I','B') as ib_flag
      ,[file_process_id]
      ,[file_process_detail_id]
      ,Convert(varchar(10), [openAppointmentDateTime], 112) as openAppointmentDate
      ,Convert(varchar(10), [openAppointmentDateTime], 1108) as openAppointmentTime
	  ,a.[natural_key]
	  ,t5.DMSId
	  ,Isnull(t5.givenName, '') + ' ' + Isnull(t5.middleName, '') + ' ' +  Isnull(t5.familyName, '')
	  ,t5.familyName
	  ,t5.givenName
	  --,Isnull(int_clr, int_clr_code)
	  ,a.roNumber
	  ,Isnull(a.lastUpdateDateTime, [appointmentDateTime])
	  ,isnull(inceptionDateTime, [appointmentDateTime])
	  ,t.[Block Phone] as [cust_do_not_call]
      ,t.[Block Email] as [cust_do_not_email]
      ,(Case when t2.privacyType is not null then 1 else 0 end) as [cust_do_not_mail]
	from #temp_SrvAppts a
	--inner join master.dealer d on a.natural_key = d.natural_key
	left outer join #temp_OwnerParty t on a.etl_srv_appt_id = t.etl_srv_appt_id
	left outer join #temp_OwnerParty_Ids t1 on a.etl_srv_appt_id = t1.etl_srv_appt_id
	left outer join #temp_OwnerParty_address t2 on a.etl_srv_appt_id = t2.etl_srv_appt_id and t2.addressType = 'Residence'--(Case when t.CustomerTypeCode = 'Business' then 'Mail' else 'Residence' end)
	left outer join #temp_OwnerParty_communication t3 on a.etl_srv_appt_id = t3.etl_srv_appt_id
	left outer join #temp_OwnerParty_address t4 on a.etl_srv_appt_id = t4.etl_srv_appt_id and t4.addressType = 'Work'
	left outer join #temp_ServiceAdvisorParty t5 on a.etl_srv_appt_id = t5.etl_srv_appt_id and t5.partyType = 'ServiceAdvisorParty'
	where a.rnk = 1 

end

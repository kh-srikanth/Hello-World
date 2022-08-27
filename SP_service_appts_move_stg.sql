USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [etl].[cdk_etl_serviceAppt_xml]    Script Date: 5/10/2021 2:16:01 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--alter PROCEDURE [etl].[atm_move_stg_serviceAppt]
declare
@file_process_detail_id int 
/*
exec [etl].[atm_move_stg_serviceAppt] 1051
*/
--AS
Begin

IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
select 
		d.parent_dealer_id
      ,a.[natural_key]
      ,[serviceAppointmentNumber]
      ,[appointmentDateTime]
      ,[dateAppointmentInitiated]
      ,[OwnerParty_DMSId]
      ,[familyName]
      ,[givenName]
      ,[preferredName]
      ,[salutation]
      ,[Residence_lineOne]
      ,[Residence_lineTwo]
      ,[Residence_cityName]
      ,[Residence_stateOrProvinceCountrySubDivisionId]
      ,[Residence_postCode]
      ,[Residence_countryId]
      ,[HomePhone]
      ,[CellPhone]
      ,[WorkPhone]
      ,[emailAddress]
      ,[genderCode]
      ,[birthDate]
      ,[Residence_privacyIndicator] --
      ,[Residence_privacyIndicatorDescription]
      ,[Residence_privacyType]
      ,[Residence_startDateTime]	
      ,[Residence_endDateTime] --
      ,[licenseNumber]
      ,[vehicleId]
      ,[make]
      ,[modelYear]
      ,[modelDescription]
      ,[colorGroup]  -- 
      ,[actualOdometer]
      ,[vehicleClassCode]
      ,[seriesCode]
      ,[bodyStyle]
      ,[modelClass]
      ,[transmissionTypeName]
      ,[OwnerParty_ThirdPartyId]
      ,[mail_lineOne]
      ,[mail_lineTwo]
      ,[mail_cityName]
      ,[mail_stateOrProvinceCountrySubDivisionId]
      ,[mail_postCode]
      ,[mail_countryId]
      ,[OtherPhone]
      ,[manufacturerName]
      ,[requestedService] --
      ,[appointmentNotes]
      ,[OwnerParty_Other]
      ,[serviceAppointmentParties] --
	  ,[serviceAppointmentVehicleLineItem]
      ,[file_process_id]
      ,[file_process_detail_id]
      ,[created_date]
      ,[created_by]
      ,[updated_date]
      ,[updated_by]
      ,[middleName]
      ,[nameSuffix]
      ,[openAppointmentDateTime]

	  into #temp
	  from [clictell_auto_etl].[etl].[atm_service_appts] a (nolock)
	  inner join master.dealer  d (nolock) on d.natural_key = a.[natural_key]
	  where @file_process_detail_id = [file_process_detail_id]
	  order by [serviceAppointmentNumber]


--select * from #temp
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1

select a.[natural_key], a.[serviceAppointmentNumber], a.[appointmentDateTime], b.* into #temp1
from 
(
select a.[natural_key], a.[serviceAppointmentNumber], a.[appointmentDateTime], b.*

from #temp a
CROSS APPLY OPENJSON([colorGroup]) as b
) as a
CROSS APPLY OPENJSON([value]) as b

--select * from #temp1

IF OBJECT_ID('tempdb..#colorgroup') IS NOT NULL DROP TABLE #colorgroup
select distinct natural_key,serviceAppointmentNumber,[appointmentDateTime]
,(select [value] from #temp1 b where a.serviceAppointmentNumber = b.serviceAppointmentNumber and a.[appointmentDateTime] = b.[appointmentDateTime] and b.[key] = 'colorItemCode') as colorItemCode
,(select [value] from #temp1 b where a.serviceAppointmentNumber = b.serviceAppointmentNumber and a.[appointmentDateTime] = b.[appointmentDateTime] and b.[key] = 'colorName') as colorName
into #colorgroup
from #temp1 a

--select * from #colorgroup


IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2

select a.[natural_key], a.[serviceAppointmentNumber], a.[appointmentDateTime], b.* into #temp2
from 
(
select a.[natural_key], a.[serviceAppointmentNumber], a.[appointmentDateTime], b.*

from #temp a
CROSS APPLY OPENJSON([requestedService]) as b
) as a
CROSS APPLY OPENJSON([value]) as b



/*IF OBJECT_ID('tempdb..#requestedService') IS NOT NULL DROP TABLE #requestedService
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


IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3

select a.[natural_key], a.[serviceAppointmentNumber], a.[appointmentDateTime], b.* into #temp3
from 
(
select a.[natural_key], a.[serviceAppointmentNumber], a.[appointmentDateTime], b.*

from #temp a
CROSS APPLY OPENJSON([serviceAppointmentParties]) as b
) as a
CROSS APPLY OPENJSON([value]) as b


IF OBJECT_ID('tempdb..#cust_type_code') IS NOT NULL DROP TABLE #cust_type_code

select distinct natural_key,serviceAppointmentNumber,[appointmentDateTime]
		,(select [value] from #temp3 b where a.serviceAppointmentNumber = b.serviceAppointmentNumber and a.[appointmentDateTime] = b.[appointmentDateTime] and b.[key] = 'customerTypeCode') as customerTypeCode
into #cust_type_code
from #temp3 a


/*insert into [clictell_auto_stg].[stg].[service_appts]
(
      [parent_dealer_id]
      ,[natural_key]
	  ,[appt_id]
      ,[appt_time]
      ,[appt_date]
      ,[cust_dms_number]
      ,[cust_lastname]
      ,[cust_firstname]
      ,[cust_fullname]
      ,[cust_salut]
      ,[cust_address1]
      ,[cust_address2]
      ,[cust_city]
      ,[cust_state]
      ,[cust_zip]
      ,[cust_country]
      ,[cust_home_phone]
      ,[cust_cell_phone]
      ,[cust_work_phone]
      ,[cust_email_address1]
	  ,[cust_gender]
      ,[cust_birth_date]
      ,[cust_opt_out]
      ,[vehicle_license_plate]
      ,[vin]
      ,[make]
      ,[year]
      ,[model_desc]
      ,[ExtClrDesc]
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
      ,[AdtlCustomer_CustNo]
      ,[cust_ibflag]
      ,[file_process_id]
      ,[file_process_detail_id]
      ,[created_date]
      ,[created_by]
      ,[updated_date]
      ,[updated_by]
      ,[cust_middlename]
      ,[cust_suffix]
      ,[appt_open_date]
      ,[appt_open_time]
	  /* These columns in stg are not mapped with etl
	   ,[src_dealer_code]
      ,[adv_name_recid]
      ,[adv_fullname]
	  ,[cust_email_address2]
      ,[cust_do_not_call]
      ,[cust_do_not_email]
      ,[cust_do_not_mail]
      ,[cust_do_not_data_share]
      ,[stock_num]
      ,[stock_type]
      ,[IntClrDesc]
      ,[adv_lastname]
      ,[adv_firstname]
      ,[dispatcher]
      ,[Complaint]
      ,[SpecialOrderNo]
      ,[Outsidesrc_Appointment]
      ,[AdtlCustomer_CustName]
      ,[AdtlCustomer_LanguagePref]
      ,[language]
      ,[cust_created_dt]
      ,[cust_last_activity_dt]
	  */

) */
select 
	   parent_dealer_id
      ,t.[natural_key]
      ,t.[serviceAppointmentNumber]
      ,t.[appointmentDateTime]
      ,[dateAppointmentInitiated]
      ,[OwnerParty_DMSId]
      ,[familyName]
      ,[givenName]
      ,[preferredName]
      ,[salutation]
      ,[Residence_lineOne]
      ,[Residence_lineTwo]
      ,[Residence_cityName]
      ,[Residence_stateOrProvinceCountrySubDivisionId]
      ,[Residence_postCode]
      ,[Residence_countryId]
      ,[HomePhone]
      ,[CellPhone]
      ,[WorkPhone]
      ,[emailAddress]
      ,[genderCode]
      ,[birthDate]
      ,[Residence_privacyIndicator]
      ,[licenseNumber]
      ,[vehicleId]
      ,[make]
      ,[modelYear]
      ,[modelDescription]
      --,[colorGroup] --
	  ,iif(c.coloritemcode = 'Exterior',c.colorName,null) as ext_color
      ,[actualOdometer]
      ,[vehicleClassCode]
      ,[seriesCode]
      ,[bodyStyle]
      ,[modelClass]
      ,[transmissionTypeName]
      ,[OwnerParty_ThirdPartyId]
      ,[mail_lineOne]
      ,[mail_lineTwo]
      ,[mail_cityName]
      ,[mail_stateOrProvinceCountrySubDivisionId]
      ,[mail_postCode]
      ,[mail_countryId]
      ,[OtherPhone]
      ,[manufacturerName]
      ,[appointmentNotes]
      ,[OwnerParty_Other]
      --,[serviceAppointmentParties] -- 
	  ,iif(tc.customertypecode = 'Person','I','B') as ib_flag
      ,[file_process_id]
      ,[file_process_detail_id]
      ,[created_date]
      ,[created_by]
      ,[updated_date]
      ,[updated_by]
      ,[middleName]
      ,[nameSuffix]
      ,[openAppointmentDateTime]
      ,[openAppointmentDateTime]
from #temp t
inner join #colorgroup c on t.natural_key = c.natural_key and t.serviceAppointmentNumber = c.serviceAppointmentNumber and t.appointmentDateTime =c.appointmentDateTime
inner join #cust_type_code tc on t.natural_key = tc.natural_key and t.serviceAppointmentNumber = tc.serviceAppointmentNumber and t.appointmentDateTime =tc.appointmentDateTime

end

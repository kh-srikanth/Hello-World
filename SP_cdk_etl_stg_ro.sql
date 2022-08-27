

--USE [clictell_auto_etl]
--GO
--/****** Object:  StoredProcedure [etl].[move_act_service_raw_etl_2_stage]    Script Date: 2/19/2021 4:11:26 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
-- /*
-- exec [etl].[move_cdk_ro_roh_stage] 1
-- select *  from [stg].[repair_orders]
-- select * from [stg].[repair_order_detail]
-- */
--  alter procedure  [etl].[move_cdk_ro_roh_stage]   
	declare   
   @file_process_id int =1

--as 

begin
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2



select 
      [ServiceAdvisor]      ,[Mileage]      ,[lbrOpCodeDesc1]      ,[lbrOpCode1]      ,[HasCustPayFlag]      ,[RONumber]
      ,[VehId]      ,[VIN]	  ,CloseDate	  ,file_process_id	  ,file_process_detail_id	  ,suser_name() as created_by
	  ,GETDATE() as created_dt	  ,suser_name() as update_by	  ,GETDATE() as updated_dt,src_dealer_id
	  into #temp
from [etl].[cdk_etl_repair_order_header]
union all

select 
      [ServiceAdvisor]      ,[Mileage]      ,[lbrOpCodeDesc2]      ,[lbrOpCode2]      ,[HasCustPayFlag]      ,[RONumber]
      ,[VehId]      ,[VIN]	  ,CloseDate	  ,file_process_id	  ,file_process_detail_id	  ,suser_name() as created_by
	  ,GETDATE() as created_dt	  ,suser_name() as update_by	  ,GETDATE() as updated_dt,src_dealer_id
from [etl].[cdk_etl_repair_order_header]
union all

select 
      [ServiceAdvisor]      ,[Mileage]      ,[lbrOpCodeDesc3]      ,[lbrOpCode3]      ,[HasCustPayFlag]      ,[RONumber]
      ,[VehId]      ,[VIN]	  ,CloseDate	  ,file_process_id	  ,file_process_detail_id	  ,suser_name() as created_by
	  ,GETDATE() as created_dt	  ,suser_name() as update_by	  ,GETDATE() as updated_dt,src_dealer_id
from [etl].[cdk_etl_repair_order_header]
union all

select 
      [ServiceAdvisor]      ,[Mileage]      ,[lbrOpCodeDesc4]      ,[lbrOpCode4]      ,[HasCustPayFlag]      ,[RONumber]
      ,[VehId]      ,[VIN]	  ,CloseDate	  ,file_process_id	  ,file_process_detail_id	  ,suser_name() as created_by
	  ,GETDATE() as created_dt	  ,suser_name() as update_by	  ,GETDATE() as updated_dt,src_dealer_id
from [etl].[cdk_etl_repair_order_header] 
union all

select 
      [ServiceAdvisor]      ,[Mileage]      ,[lbrOpCodeDesc5]      ,[lbrOpCode5]      ,[HasCustPayFlag]      ,[RONumber]
      ,[VehId]      ,[VIN]	  ,CloseDate	  ,file_process_id	  ,file_process_detail_id	  ,suser_name() as created_by
	  ,GETDATE() as created_dt	  ,suser_name() as update_by	  ,GETDATE() as updated_dt,src_dealer_id

from [etl].[cdk_etl_repair_order_header] order by RONumber



--insert into [stg].[repair_orders]
-- (     [advisor]      ,[mileage]      ,[op_code_desc]      ,[opcodes]      ,[pay_type]      ,[ro_number]      ,[vehicle_id]
--      ,[vin]	  ,ro_close_date	  ,file_process_id	  ,file_process_detail_id	  ,created_by	  ,created_dt
--	  ,updated_by	  ,updated_dt
	  
--)
--select 
--      [ServiceAdvisor]      ,[Mileage]      ,[lbrOpCodeDesc1]      ,[lbrOpCode1]      ,[HasCustPayFlag]      ,[RONumber]
--      ,[VehId]      ,[VIN]	  ,CloseDate	  ,file_process_id	  ,file_process_detail_id	  ,d.created_by
--	  ,d.created_dt	  ,d.update_by	  ,d.updated_dt
	  
--from #temp d inner join master.dealer md with(nolock) on d.src_dealer_id = md.natural_key
--	where file_process_id = @file_process_id

--------------------------------------------------------------------------------------------------------------------------



select

      [totLubeSale1]      ,[totLubeCost1]      ,[totLaborCost1]      ,[totLaborSale1]      ,[totMiscCost1]      ,[totMiscSale1]
      ,[totRoCost1]      ,[totRoSale1]      ,[totSubletCost1]      ,[totSubletSale1]      ,[totRoTax1]	  ,OpenDate	  ,CloseDate
	  ,RONumber	  ,file_process_id	  ,file_process_detail_id	  ,suser_name() as created_by	  ,GETDATE() as created_dt
	  ,suser_name() as updated_by	  ,GETDATE() as updated_dt 
	 
	 into #temp1

from [etl].[cdk_etl_repair_order_details] d (nolock) 
inner join master.dealer md with(nolock) on d.src_dealer_id = md.natural_key
	where file_process_id = @file_process_id
union

select

      [totLubeSale2]      ,[totLubeCost2]      ,[totLaborCost2]      ,[totLaborSale2]      ,[totMiscCost2]      ,[totMiscSale2]
      ,[totRoCost2]      ,[totRoSale2]      ,[totSubletCost2]      ,[totSubletSale2]      ,[totRoTax2]	  ,OpenDate	  ,CloseDate
	  ,RONumber	  ,file_process_id	  ,file_process_detail_id	  ,suser_name() as created_by	  ,GETDATE() as created_dt
	  ,suser_name() as updated_by	  ,GETDATE() as updated_dt 

from [etl].[cdk_etl_repair_order_details] d (nolock) 
inner join master.dealer md with(nolock) on d.src_dealer_id = md.natural_key
	where file_process_id = @file_process_id
union

select

      [totLubeSale3]      ,[totLubeCost3]      ,[totLaborCost3]      ,[totLaborSale3]      ,[totMiscCost3]      ,[totMiscSale3]
      ,[totRoCost3]      ,[totRoSale3]      ,[totSubletCost3]      ,[totSubletSale3]      ,[totRoTax3]	  ,OpenDate	  ,CloseDate
	  ,RONumber	  ,file_process_id	  ,file_process_detail_id	  ,suser_name() as created_by	  ,GETDATE() as created_dt
	  ,suser_name() as updated_by	  ,GETDATE() as updated_dt 

from [etl].[cdk_etl_repair_order_details] d (nolock) 
inner join master.dealer md with(nolock) on d.src_dealer_id = md.natural_key
	where file_process_id = @file_process_id
union

select

      [totLubeSale4]      ,[totLubeCost4]      ,[totLaborCost4]      ,[totLaborSale4]      ,[totMiscCost4]      ,[totMiscSale4]
      ,[totRoCost4]      ,[totRoSale4]      ,[totSubletCost4]      ,[totSubletSale4]      ,[totRoTax4]	  ,OpenDate	  ,CloseDate
	  ,RONumber	  ,file_process_id	  ,file_process_detail_id	  ,suser_name() as created_by	  ,GETDATE() as created_dt
	  ,suser_name() as updated_by	  ,GETDATE() as updated_dt 

from [etl].[cdk_etl_repair_order_details] d (nolock) 
inner join master.dealer md with(nolock) on d.src_dealer_id = md.natural_key
	where file_process_id = @file_process_id
union

select

      [totLubeSale5]      ,[totLubeCost5]      ,[totLaborCost5]      ,[totLaborSale5]      ,[totMiscCost5]      ,[totMiscSale5]
      ,[totRoCost5]      ,[totRoSale5]      ,[totSubletCost5]      ,[totSubletSale5]      ,[totRoTax5]	  ,OpenDate	  ,CloseDate
	  ,RONumber	  ,file_process_id	  ,file_process_detail_id	  ,suser_name() as created_by	  ,GETDATE() as created_dt
	  ,suser_name() as updated_by	  ,GETDATE() as updated_dt 

from [etl].[cdk_etl_repair_order_details] d (nolock) 
inner join master.dealer md with(nolock) on d.src_dealer_id = md.natural_key
	where file_process_id = @file_process_id



	

select 
      [Appdate]      ,[ApptFlag]      ,[Address]      ,[CityStateZip]      ,[CustNo]      ,[BlockAutoMsg]      ,[EmailAddress]
      ,[ContactEmailAddress]      ,[Name1]      ,[ContactPhoneNumber]      ,[RentalFlag]      ,[BookedDate]      ,[Name2]
      ,[LicenseNumber]      ,d.[Zip]      ,[ErrorMessage]      ,[VehicleColor]      ,[LastServiceDate]      ,[Make]
      ,[MileageOut]      ,[mlsCost]      ,[mlsSale]      ,[model]      ,[MakeDesc]      ,[HasCustPayFlag]      ,[PostedDate]
      ,[PromisedDate]      ,[PromisedTime]     ,[Remarks]      ,[Comments]      ,[ServiceAdvisor]      ,[BookerNo]
      ,[src_dealer_id]      ,[TagNo]      ,[lbrTechNo1]      ,[hrsTimeCardHours1]      ,[lbrTimeCardHours1]      ,[DeliveryDate]
      ,[PriorityValue]      ,[VoidedDate]      ,[Year]	  ,d.RONumber
	  into #temp2
from [etl].[cdk_etl_repair_order_header] d (nolock) 
inner join master.dealer md with(nolock) on d.src_dealer_id = md.natural_key
	where file_process_id = @file_process_id
union

select 
      [Appdate]      ,[ApptFlag]      ,[Address]      ,[CityStateZip]      ,[CustNo]      ,[BlockAutoMsg]      ,[EmailAddress]
      ,[ContactEmailAddress]      ,[Name1]      ,[ContactPhoneNumber]      ,[RentalFlag]      ,[BookedDate]      ,[Name2]
      ,[LicenseNumber]      ,d.[Zip]      ,[ErrorMessage]      ,[VehicleColor]      ,[LastServiceDate]      ,[Make]
      ,[MileageOut]      ,[mlsCost]      ,[mlsSale]      ,[model]      ,[MakeDesc]      ,[HasCustPayFlag]      ,[PostedDate]
      ,[PromisedDate]      ,[PromisedTime]     ,[Remarks]      ,[Comments]      ,[ServiceAdvisor]      ,[BookerNo]
      ,[src_dealer_id]      ,[TagNo]      ,[lbrTechNo2]      ,[hrsTimeCardHours2]      ,[lbrTimeCardHours2]      ,[DeliveryDate]
      ,[PriorityValue]      ,[VoidedDate]      ,[Year]	  ,d.RONumber
	  
from [etl].[cdk_etl_repair_order_header] d (nolock) 
inner join master.dealer md with(nolock) on d.src_dealer_id = md.natural_key
	where file_process_id = @file_process_id
union
	select 
      [Appdate]      ,[ApptFlag]      ,[Address]      ,[CityStateZip]      ,[CustNo]      ,[BlockAutoMsg]      ,[EmailAddress]
      ,[ContactEmailAddress]      ,[Name1]      ,[ContactPhoneNumber]      ,[RentalFlag]      ,[BookedDate]      ,[Name2]
      ,[LicenseNumber]      ,d.[Zip]      ,[ErrorMessage]      ,[VehicleColor]      ,[LastServiceDate]      ,[Make]
      ,[MileageOut]      ,[mlsCost]      ,[mlsSale]      ,[model]      ,[MakeDesc]      ,[HasCustPayFlag]      ,[PostedDate]
      ,[PromisedDate]      ,[PromisedTime]     ,[Remarks]      ,[Comments]      ,[ServiceAdvisor]      ,[BookerNo]
      ,[src_dealer_id]      ,[TagNo]      ,[lbrTechNo3]      ,[hrsTimeCardHours3]      ,[lbrTimeCardHours3]      ,[DeliveryDate]
      ,[PriorityValue]      ,[VoidedDate]      ,[Year]	  ,d.RONumber
	 
from [etl].[cdk_etl_repair_order_header] d (nolock) 
inner join master.dealer md with(nolock) on d.src_dealer_id = md.natural_key
	where file_process_id = @file_process_id
union
select 
      [Appdate]      ,[ApptFlag]      ,[Address]      ,[CityStateZip]      ,[CustNo]      ,[BlockAutoMsg]      ,[EmailAddress]
      ,[ContactEmailAddress]      ,[Name1]      ,[ContactPhoneNumber]      ,[RentalFlag]      ,[BookedDate]      ,[Name2]
      ,[LicenseNumber]      ,d.[Zip]      ,[ErrorMessage]      ,[VehicleColor]      ,[LastServiceDate]      ,[Make]
      ,[MileageOut]      ,[mlsCost]      ,[mlsSale]      ,[model]      ,[MakeDesc]      ,[HasCustPayFlag]      ,[PostedDate]
      ,[PromisedDate]      ,[PromisedTime]     ,[Remarks]      ,[Comments]      ,[ServiceAdvisor]      ,[BookerNo]
      ,[src_dealer_id]      ,[TagNo]      ,[lbrTechNo4]      ,[hrsTimeCardHours4]      ,[lbrTimeCardHours4]      ,[DeliveryDate]
      ,[PriorityValue]      ,[VoidedDate]      ,[Year]	  ,d.RONumber
	  
from [etl].[cdk_etl_repair_order_header] d (nolock) 
inner join master.dealer md with(nolock) on d.src_dealer_id = md.natural_key
	where file_process_id = @file_process_id
union
select 
      [Appdate]      ,[ApptFlag]      ,[Address]      ,[CityStateZip]      ,[CustNo]      ,[BlockAutoMsg]      ,[EmailAddress]
      ,[ContactEmailAddress]      ,[Name1]      ,[ContactPhoneNumber]      ,[RentalFlag]      ,[BookedDate]      ,[Name2]
      ,[LicenseNumber]      ,d.[Zip]      ,[ErrorMessage]      ,[VehicleColor]      ,[LastServiceDate]      ,[Make]
      ,[MileageOut]      ,[mlsCost]      ,[mlsSale]      ,[model]      ,[MakeDesc]      ,[HasCustPayFlag]      ,[PostedDate]
      ,[PromisedDate]      ,[PromisedTime]     ,[Remarks]      ,[Comments]      ,[ServiceAdvisor]      ,[BookerNo]
      ,[src_dealer_id]      ,[TagNo]      ,[lbrTechNo5]      ,[hrsTimeCardHours5]      ,[lbrTimeCardHours5]      ,[DeliveryDate]
      ,[PriorityValue]      ,[VoidedDate]      ,[Year]	  ,d.RONumber
	 
from [etl].[cdk_etl_repair_order_header] d (nolock) 
inner join master.dealer md with(nolock) on d.src_dealer_id = md.natural_key
	where file_process_id = @file_process_id

alter table #temp1 add id1 int identity(1,1)
alter table #temp2 add id2 int identity(1,1)

--insert into [stg].[repair_order_detail]

--(

--      [total_gog_cost]
--      ,[total_gog_price]
--      ,[total_labor_cost]
--      ,[total_labor_price]
--      ,[total_misc_cost]
--      ,[total_misc_price]
--      ,[total_repair_order_cost]
--      ,[total_repair_order_price]
--      ,[total_sublet_cost]
--      ,[total_sublet_price]
--      ,[total_tax_price]
--	  ,ro_open_date
--	  ,ro_close_date
--	  ,ro_number
--	  ,file_process_id
--	  ,file_process_detail_id
--	  ,created_by
--	  ,created_date
--	  ,updated_by
--	  ,updated_date
--      ,[appointment_date]
--      ,[appointment_flag]
--      ,[cust_address1]
--      ,[cust_city]
--      ,[cust_dms_number]
--      ,[cust_do_not_call]
--      ,[cust_email_address]
--      ,[cust_email_address2]
--      ,[cust_first_name]
--      ,[cust_home_phone]
--      ,[cust_ib_flag]
--      ,[cust_invoice_date]
--      ,[cust_last_name]
--      ,[cust_lic_no]
--      ,[cust_zip_code]
--      --,[delivery_odometer]
--      ,[error_desc]
--      ,[ext_clr_desc]
--      ,[last_activity_date]
--      ,[make]
--      ,[mileage_out]
--      ,[misc_cost]
--      ,[misc_sale]
--      ,[model]
--      ,[model_maint_code]
--      ,[paytype]
--      ,[post_time]
--      ,[promise_date]
--      ,[promise_time]
--      --,[ro_close_date]
--      ,[ro_cust_comment]
--      ,[ro_tech_comment]
--      ,[sa_name]
--      ,[sa_number]
--      ,[src_dealer_code]
--      ,[tag_no]
--		,[tech_id]
--      ,[total_actual_labor_hours]
--      ,[total_billed_labor_hours]
--      ,[vehicle_pickup_date]
--      ,[vehicle_priority]
--      ,[void_date]
--      ,[year]
--)
--select
--      [totLubeSale1]
--      ,[totLubeCost1]
--      ,[totLaborCost1]
--      ,[totLaborSale1]
--      ,[totMiscCost1]
--      ,[totMiscSale1]
--      ,[totRoCost1]
--      ,[totRoSale1]
--      ,[totSubletCost1]
--      ,[totSubletSale1]
--      ,[totRoTax1]
--	  ,OpenDate
--	  ,CloseDate
--	  ,t1.RONumber
--	  ,file_process_id
--	  ,file_process_detail_id
--	  ,created_by
--	  ,created_dt
--	  ,updated_by
--	  ,updated_dt
--	  ,[Appdate]
--      ,[ApptFlag]
--      ,[Address]
--      ,[CityStateZip]
--      ,[CustNo]
--      ,[BlockAutoMsg]
--      ,[EmailAddress]
--      ,[ContactEmailAddress]
--      ,[Name1]
--      ,[ContactPhoneNumber]
--      ,[RentalFlag]
--      ,[BookedDate]
--      ,[Name2]
--      ,[LicenseNumber]
--      ,[Zip]
--      ,[ErrorMessage]
--      ,[VehicleColor]
--      ,[LastServiceDate]
--      ,[Make]
--      ,[MileageOut]
--      ,[mlsCost]
--      ,[mlsSale]
--      ,[model]
--      ,[MakeDesc]
--      ,[HasCustPayFlag]
--      ,[PostedDate]
--      ,[PromisedDate]
--      ,[PromisedTime]
--      --,[CloseDate]
--      ,[Remarks]
--      ,[Comments]
--      ,[ServiceAdvisor]
--      ,[BookerNo]
--      ,[src_dealer_id]
--      ,[TagNo]
--      ,isnull([lbrTechNo1],0)  --??
--      ,[hrsTimeCardHours1]
--      ,[lbrTimeCardHours1]
--      ,[DeliveryDate]
--      ,[PriorityValue]
--      ,[VoidedDate]
--      ,[Year]

--from #temp1 t1 left outer join #temp2 t2 on t1.id1 = t2.id2

end


select * from #temp1
select * from #temp2
--select * from [stg].[repair_order_detail]
--select * from [etl].[cdk_etl_repair_order_details]
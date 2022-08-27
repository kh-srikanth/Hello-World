select * from master.fi_sales order by file_process_id desc

select top 10 file_process_id,* from master.fi_sales(nolock) where file_process_id in (72)	
select top 10 file_process_id,* from master.repair_order_header (nolock) where file_process_id in (72)
select top 10 file_process_id,* from master.repair_order_header_detail (nolock) where file_process_id in (72)
select top 10 file_process_id,* from master.service_appts (nolock) where file_process_id in (72,67) --
select top 10 file_process_id,* from master.inventory (nolock) where file_process_id in (72)
select top 10 file_process_id,* from master.cust_2_vehicle (nolock) where file_process_id in (72,67) --
select top 10 file_process_id,* from master.customer (nolock) where file_process_id in (72)
select top 10 file_process_id,* from master.fi_sales_people (nolock) where file_process_id in (72,67)	--
select top 10 file_process_id,* from master.fi_sales_trade_vehicles (nolock) where file_process_id in (72,67)	--
select top 10 file_process_id,* from master.inventory (nolock) where file_process_id in (72)
select top 10 file_process_id,* from master.ro_detail_technicians (nolock) where file_process_id in (72,67) --
select top 10 file_process_id,* from master.ro_parts_details(nolock) where file_process_id in (72)



select top 10 file_process_id,* from [stg].[fi_sales]	(nolock) where file_process_id in (72)		
select top 10 file_process_id,* from [stg].[service_appts] (nolock) where file_process_id in (72)
select top 10 file_process_id,* from [stg].[service_ro_header] (nolock) where file_process_id in (72)
select top 10 file_process_id,* from [stg].[service_ro_operations] (nolock) where file_process_id in (72)
select top 10 file_process_id,* from [stg].[service_ro_parts] (nolock) where file_process_id in (72)
select top 10 file_process_id,* from [stg].[service_ro_technicians] (nolock) where file_process_id in (72,67)  --
select top 10 file_process_id,* from [stg].[vehicle] (nolock) where file_process_id in (72)
select top 10 file_process_id,* from [stg].[customers] (nolock) where file_process_id in (72)
select top 10 file_process_id,* from [stg].[fi_sales_people] (nolock) where file_process_id in (72,67) --
select top 10 file_process_id,* from [stg].[fi_sales_trade_vehicles] (nolock) where file_process_id in (72) 



select top 10 file_process_id,* from [etl].[atm_customer]  (nolock) where file_process_id in (72)
select top 10 file_process_id,* from [etl].[atm_employee] (nolock) where file_process_id in (72) --
select top 10 file_process_id,* from [etl].[atm_fi_sales] (nolock) where file_process_id in (72) 
select top 10 file_process_id,* from [etl].[atm_labor_operations] (nolock) where file_process_id in (72) --
select top 10 file_process_id,* from [etl].[atm_partsOrder] (nolock) where file_process_id in (72) --
select top 10 file_process_id,* from [etl].[atm_sales1] (nolock) where file_process_id in (72) 
select top 10 file_process_id,* from [etl].[atm_sales2] (nolock) where file_process_id in (72)
select top 10 file_process_id,* from [etl].[atm_sales3] (nolock) where file_process_id in (72)
select top 10 file_process_id,* from [etl].[atm_service] (nolock) where file_process_id in (72)
select top 10 file_process_id,* from [etl].[atm_service_appts] (nolock) where file_process_id in (72)
select top 10 file_process_id,* from [etl].[atm_vehicle_inventory] (nolock) where file_process_id in (72)

[etl].[atm_etl_fiDeal_json]


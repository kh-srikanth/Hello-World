use clictell_auto_master
go
truncate table [master].[fi_sales]
truncate table [master].[repair_order_header]
truncate table [master].[repair_order_header_detail]
truncate table [master].[service_appts]
truncate table [master].[inventory]
truncate table [master].[cust_2_vehicle]
truncate table [master].[customer]
truncate table [master].[fi_sales_people]
truncate table [master].[fi_sales_trade_vehicles]
truncate table [master].[inventory]
truncate table [master].[ro_detail_technicians]
truncate table [master].[ro_parts_details]


truncate table [stg].[fi_sales]
truncate table [stg].[service_appts]
truncate table [stg].[service_ro_header]
truncate table [stg].[service_ro_operations]
truncate table [stg].[service_ro_parts]
truncate table [stg].[service_ro_technicians]
truncate table [stg].[vehicle]
truncate table [stg].[customers]
truncate table [stg].[fi_sales_people]
truncate table [stg].[fi_sales_trade_vehicles]

truncate table [etl].[atm_customer]
truncate table [etl].[atm_employee]
truncate table [etl].[atm_fi_sales]
truncate table [etl].[atm_labor_operations]
truncate table [etl].[atm_partsOrder]
truncate table [etl].[atm_sales1]
truncate table [etl].[atm_sales2]
truncate table [etl].[atm_sales3]
truncate table [etl].[atm_service]
truncate table [etl].[atm_service_appts]
truncate table [etl].[atm_vehicle_inventory]
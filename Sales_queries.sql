select * from [stg].[sales1]
select * from [stg].[sales2]
select * from [stg].[sales3]
select * from [stg].[fi_sales_trade_vehicles]
select * from [stg].[fi_sales_people]
select * from [stg].[fi_sales_totals]

select * from [stg].[vehicle]
select * from [stg].[fi_sales_dd]
select * from [stg].[fi_sales_gm]
select * from [stg].[fi_sales_people]
select * from [stg].[fi_sales_totals]
select * from master.fi_sales_totals
select * from [stg].[fi_sales_trade_vehicles]
select * from [stg].[inventory_images]
select * from [stg].[customers]

select * from [stg].[cust_vehicle] --empty

select * from master.customer
select * from master.cust_2_vehicle
select * from master.vehicle
select * from master.sale_people_type
select * from master.fi_sales
select * from master.fi_sales_people
select * from master.fi_sales_totals  --empty
select * from master.fi_sales_trade_vehicles



exec [etl].[move_atc_sale_raw_etl_2_stage] 1  --loads etl.sales1,sales2,sales3,[stg].[fi_sales_trade_vehicles],[stg].[fi_sales_people],[stg].[fi_sales_totals]
exec [stg].[move_customers_etl_2_stage] 1
exec [stg].[move_vehicles_etl_2_stage] 1

exec [master].[move_vehicle_stage_2_master] 1
exec [master].[move_customer_stage_2_master] 1
exec [master].[move_customers_2_vehicle_stage_2_master] 1
exec [master].[move_customer_stage_2_master] 1
exec [master].[move_customers_2_vehicle_stage_2_master] 1
exec [master].[move_cust_2_vehicle_updates] 1 

exec [master].[move_fi_sales_people_stage_2_master] 1
exec [master].[move_fi_sales_stage_2_master] 1 
exec [master].[move_fi_sales_trade_vehicle_stage_2_master] 1


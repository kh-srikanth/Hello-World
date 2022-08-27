--ETL to STG
exec clictell_auto_etl.[etl].[move_atc_Servicero_operations_etl_2_stage]  2803
exec clictell_auto_etl.[etl].[move_atc_Service_parts_etl_2_stage]   2803
exec clictell_auto_etl.[etl].[move_atc_service_etl_2_stage] 2803
exec clictell_auto_etl.[etl].[move_atc_fi_sale_raw_etl_2_stage] 2803
exec clictell_auto_etl.[etl].[move_atc_service_appts_raw_etl_2_stage] 2803
exec clictell_auto_etl.[etl].[move_atc_vehicles_etl_2_stage] 2803
exec clictell_auto_etl.[etl].[move_atc_customers_etl_2_stage]  2803

--STG to Master
exec clictell_auto_stg.stg.move_customer_stage_2_master 2803
exec clictell_auto_stg.[stg].[move_vehicles_stage_2_master] 2803
exec clictell_auto_stg.stg.move_customers_2_vehicle_stage_2_master  2803
exec clictell_auto_stg.stg.move_fi_sales_stage_2_master 2803
exec clictell_auto_stg.stg.move_fi_sales_trade_vehicle_stage_2_master 2803
exec clictell_auto_stg.stg.move_fi_sales_people_stage_2_master 2803
exec clictell_auto_stg.stg.move_service_ro_header_stage_2_master 2803
exec clictell_auto_stg.stg.move_servicero_detail_stage_2_master 2803
exec clictell_auto_stg.stg.move_service_appts_stage_2_master  2803


--Update SPs
exec clictell_auto_stg.master.move_cust_2_vehicle_updates
exec clictell_auto_master.[master].[Update_Dashboard_Counts]
exec clictell_auto_master.[master].[Update_customer_KPI_graph_data]
exec clictell_auto_master.[master].[Update_RO_KPI_graph_data]
exec clictell_auto_master.[master].[Update_Sales_KPI_graph_data]
exec clictell_auto_master.[master].[service_kpi_update]
exec clictell_auto_master.[master].[sales_kpi_update]
exec clictell_auto_stg.[master].[cust2vehicle_inactivedate_update] 2803
exec clictell_auto_master.[master].[update_customer_status] 2803

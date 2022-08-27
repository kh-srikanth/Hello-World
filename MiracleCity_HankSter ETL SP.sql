select * from clictell_auto_master.master.dealer (nolock) where accountname like 'hankst%'

select * from clictell_auto_etl.etl.file_process_details (nolock) where source like 'authe%' order by 1 desc

		select file_process_id,count(*) from clictell_auto_etl.etl.atc_service (nolock) where file_process_id in (2849) group by file_process_id
		select file_process_id,count(*) from clictell_auto_etl.etl.atc_sales1 (nolock) where file_process_id in  (2849) group by file_process_id
		select file_process_id,count(*) from clictell_auto_etl.etl.atc_sales2 (nolock) where file_process_id in  (2849) group by file_process_id
		select file_process_id,count(*) from clictell_auto_etl.etl.atc_service_appts (nolock) where file_process_id in  (2849) group by file_process_id
		select file_process_id,count(*) from clictell_auto_etl.etl.atc_inventory (nolock) where file_process_id in  (2850) group by file_process_id


		select * from clictell_auto_etl.etl.atc_sales1 (nolock) where file_process_id in  (2849)
		select * from clictell_auto_etl.etl.atc_inventory (nolock) where file_process_id in  (2850)


		select count(*) from clictell_auto_stg.stg.service_ro_header (nolock) where file_process_id  = 2849
		select count(*) from clictell_auto_stg.[stg].[service_ro_operations] (nolock) where file_process_id  = 2849
		select count(*) from clictell_auto_stg.[stg].[service_ro_parts] (nolock) where file_process_id  = 2849
		select count(*) from clictell_auto_stg.[stg].[vehicle] (nolock) where file_process_id  = 2849
		select count(*) from clictell_auto_stg.stg.fi_sales (nolock) where file_process_id  = 2849
		select count(*) from clictell_auto_stg.stg.service_appts (nolock) where file_process_id  = 2849
		select count(*) from clictell_auto_stg.stg.customers (nolock) where file_process_id = 2849
		select count(*) from clictell_auto_stg.[stg].[fi_sales_people] (nolock) where file_process_id  = 2849


--2856,,2860,2861,,2862,2863

exec clictell_auto_etl.[etl].[move_atc_Servicero_operations_etl_2_stage]  2863
exec clictell_auto_etl.[etl].[move_atc_Service_parts_etl_2_stage]   2863
exec clictell_auto_etl.[etl].[move_atc_service_etl_2_stage] 2863
exec clictell_auto_etl.[etl].[move_atc_fi_sale_raw_etl_2_stage] 2863
exec clictell_auto_etl.[etl].[move_atc_service_appts_raw_etl_2_stage] 2863
exec clictell_auto_etl.[etl].[move_atc_vehicles_etl_2_stage] 2863
exec clictell_auto_etl.[etl].[move_atc_customers_etl_2_stage]  2863

--STG to Master
exec clictell_auto_stg.stg.move_customer_stage_2_master 2863
exec clictell_auto_stg.[stg].[move_vehicles_stage_2_master] 2863
exec clictell_auto_stg.stg.move_customers_2_vehicle_stage_2_master  2863
exec clictell_auto_stg.stg.move_fi_sales_stage_2_master 2863
exec clictell_auto_stg.stg.move_fi_sales_trade_vehicle_stage_2_master 2863
exec clictell_auto_stg.stg.move_fi_sales_people_stage_2_master 2863
exec clictell_auto_stg.stg.move_service_ro_header_stage_2_master 2863
exec clictell_auto_stg.stg.move_servicero_detail_stage_2_master 2863
exec clictell_auto_stg.stg.move_service_appts_stage_2_master  2863


--Update SPs
exec clictell_auto_stg.master.move_cust_2_vehicle_updates
exec clictell_auto_master.[master].[Update_Dashboard_Counts]
exec clictell_auto_master.[master].[Update_customer_KPI_graph_data]
exec clictell_auto_master.[master].[Update_RO_KPI_graph_data]
exec clictell_auto_master.[master].[Update_Sales_KPI_graph_data]
exec clictell_auto_master.[master].[service_kpi_update]
exec clictell_auto_master.[master].[sales_kpi_update]
exec clictell_auto_stg.[master].[cust2vehicle_inactivedate_update] 2863
exec clictell_auto_master.[master].[update_customer_status] 2863




	select file_process_id, count(*) from clictell_auto_master.master.repair_order_header (nolock) where file_process_id in (2849,2850,2851,2853,2854) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.master.repair_order_header_detail (nolock) where file_process_id in (2849,2850,2851,2853,2854) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.master.fi_sales (nolock) where file_process_id in (2849,2850,2851,2853,2854) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.[master].[fi_sales_people] (nolock) where file_process_id in (2849,2850,2851,2853,2854) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.master.inventory (nolock) where file_process_id in (2849,2850,2851,2853,2854) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.master.customer (nolock) where file_process_id in (2849,2850,2851,2853,2854) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.master.vehicle (nolock) where file_process_id in (2849,2850,2851,2853,2854) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.[master].[cust_2_vehicle] (nolock) where file_process_id  in (2849,2850,2851,2853,2854)group by file_process_id




	select * from clictell_auto_master.master.dealer (nolock) where accountname like 'miracle%'  --4601/miracle
	select * from clictell_auto_etl.etl.file_process_details (nolock) where source like 'authe%' order by 1 desc  --2856


		select file_process_id,count(*) from clictell_auto_etl.etl.atc_service (nolock) where file_process_id in (2856,2860,2861,2862,2863) group by file_process_id
		select file_process_id,count(*) from clictell_auto_etl.etl.atc_sales1 (nolock) where file_process_id in  (2856,2860,2861,2862,2863) group by file_process_id
		select file_process_id,count(*) from clictell_auto_etl.etl.atc_sales2 (nolock) where file_process_id in  (2856,2860,2861,2862,2863)  group by file_process_id
		select file_process_id,count(*) from clictell_auto_etl.etl.atc_service_appts (nolock) where file_process_id in (2856,2860,2861,2862,2863) group by file_process_id
		select file_process_id,count(*) from clictell_auto_etl.etl.atc_inventory (nolock) where file_process_id in  (2856,2860,2861,2862,2863) group by file_process_id


		select * from clictell_auto_etl.etl.atc_service (nolock) where file_process_id in (2856) 
		select * from clictell_auto_etl.etl.atc_sales1 (nolock) where file_process_id in  (2856) 
		select * from clictell_auto_etl.etl.atc_sales2 (nolock) where file_process_id in  (2856) 
		select * from clictell_auto_etl.etl.atc_service_appts (nolock) where file_process_id in (2856) 
		select * from clictell_auto_etl.etl.atc_inventory (nolock) where file_process_id in  (2856) 

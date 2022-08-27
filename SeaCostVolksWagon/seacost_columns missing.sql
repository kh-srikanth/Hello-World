	----Sales Missing: [Deal Status] =1 , [Deal Type] = P
	select deal_status,deal_type,sale_type,nuo_flag,purchase_date,* from master.fi_sales (nolock) where file_process_id = 2562 and cust_dms_number = 'ACV010313'
	select deal_status,deal_type,sale_type,nuo_flag,purchase_date,* from clictell_auto_stg.stg.fi_sales (nolock) where file_process_id = 2562 and buyer_id = 'ACV010313'
	select [Deal Status],[Deal Type],[Sale Type],[New Used],[Finalized Date],* from clictell_auto_etl.etl.atc_sales1 (nolock) where file_process_id = 2562 and [Customer Number] = 'ACV010313'
	select distinct [Deal Type] from clictell_auto_etl.etl.atc_sales1 (nolock) where file_process_id = 2562

	--Service missing: [Operation Line Number] is empty, [RO Status] is empty, [Tech Labor Line] is empty, [New Used] is empty, [parts line Number] is empty
	select op_code,op_code_sequence,* from master.repair_order_header_detail (nolock) where file_process_id = 2562
	select opcode,opcode_seq_number,* from clictell_auto_stg.stg.service_ro_operations (nolock) where file_process_id  = 2562
	select [Operation Codes],[Operation Line Number],[Tech Labor Line],[New Used],* from clictell_auto_etl.etl.atc_service (nolock) where file_process_id = 2562

		select count(*) from clictell_auto_etl.etl.atc_service (nolock) where file_process_id =2562 and [Block Email] = 'N'		
		select count(*) from clictell_auto_etl.etl.atc_sales1 (nolock) where file_process_id = 2562 and [Block Email] = 'N'		
		select * from clictell_auto_etl.etl.atc_sales2 (nolock) where file_process_id = 2562
		select * from clictell_auto_etl.etl.atc_service_appts (nolock) where file_process_id = 2562 and [Block Email] = 'N'
		select * from clictell_auto_etl.etl.atc_inventory (nolock) where file_process_id = 2562



	select * from clictell_auto_master.master.dealer (nolock) where _id = '2baf4dc4-d82b-4994-a5a1-291dcf52b793'
		
	select ro_status,* from master.repair_order_header (nolock) where file_process_id = 2562
	select ro_status,* from clictell_auto_stg.stg.service_ro_header (nolock) where file_process_id  = 2562
	select [RO Status],[Block Phone],[Customer Number],* from clictell_auto_etl.etl.atc_service (nolock) where file_process_id = 2562 

	select * from clictell_auto_etl.etl.atc_service_appts (nolock) where file_process_id = 2562
	select cust_do_not_call,* from master.customer (nolock) where file_process_id = 2562
		
	----service missing : 	[RO Status], [Opertaion Line Number]
	select [RO Status],[Block Phone],[Customer Number],* from clictell_auto_etl.etl.atc_service (nolock) where file_process_id = 2562 and [Customer Number] = 'BUE406164'
	select cust_do_not_call,* from master.customer (nolock) where file_process_id = 2562 and cust_dms_number = 'BUE406164'


	select [RO Status],[Block Phone],[Customer Number],* from clictell_auto_etl.etl.atc_service (nolock) where file_process_id = 2562 and [Block Phone] = 'Y'
	select cust_do_not_call,* from master.customer (nolock) where file_process_id = 2562 and cust_dms_number = 'BUE406164'
	select [Customer Number],[Block Phone],* from clictell_auto_etl.etl.atc_sales1 (nolock) where file_process_id = 2562 and [BLock Phone] = 'Y'
	select cust_do_not_call,* from master.customer (nolock) where file_process_id = 2562 and cust_dms_number = 'DUM318654'


	select [RO Status],[Block Phone],[Block Email],[Customer Number],* from clictell_auto_etl.etl.atc_service (nolock) where file_process_id = 2562 and [Block Email] = ''
	select cust_do_not_call,cust_do_not_email,* from clictell_auto_master.master.customer (nolock) where file_process_id = 2562 and cust_dms_number = 'BUE406164'

	select cust_do_not_call,cust_do_not_email,* from clictell_auto_stg.stg.customers (nolock) where file_process_id = 2562
	select [Customer Number],[Block Phone],[Block Email],* from clictell_auto_etl.etl.atc_sales1 (nolock) where file_process_id = 2562 and [Block Email] = ''
	select cust_do_not_call,* from master.customer (nolock) where file_process_id = 2562 and cust_dms_number = 'DUM318654'

	select buyer_optout,* from clictell_auto_stg.stg.fi_sales (nolock) where file_process_id  = 2562


		select file_process_id,count(*) from clictell_auto_etl.etl.atc_service (nolock) where file_process_id in (2796,2799,2800,2801,2802,2803) group by file_process_id
		select file_process_id,count(*) from clictell_auto_etl.etl.atc_sales1 (nolock) where file_process_id in (2796,2799,2800,2801,2802,2803) group by file_process_id
		select file_process_id,count(*) from clictell_auto_etl.etl.atc_sales2 (nolock) where file_process_id in (2796,2799,2800,2801,2802,2803) group by file_process_id
		select file_process_id,count(*) from clictell_auto_etl.etl.atc_service_appts (nolock) where file_process_id in (2796,2799,2800,2801,2802,2803) group by file_process_id
		select file_process_id,count(*) from clictell_auto_etl.etl.atc_inventory (nolock) where file_process_id in (2796,2799,2800,2801,2802,2803) group by file_process_id


		select * from clictell_auto_etl.etl.atc_inventory (nolock) where file_process_id = 2798


select distinct process_id from clictell_auto_etl.etl.file_process_details (nolock) where source like 'authe%'

select * from clictell_auto_etl.etl.file_process_details (nolock) where source like 'authe%'
(2552,2553,2554,2555,2556,2557,2558,2562,2796,2797,2799,2800,2801,2802,2803)

		select file_process_id,count(*) from clictell_auto_etl.etl.atc_service (nolock) where file_process_id in (2552,2553,2554,2555,2556,2557,2558,2562,2796,2797,2799,2800,2801,2802,2803) group by file_process_id order by file_process_id
		
				select * from clictell_auto_etl.etl.atc_service (nolock) where file_process_id =2562		
				select * from clictell_auto_stg.stg.service_ro_header a (nolock) where file_process_id  =2562
				select top 10 * from clictell_auto_stg.stg.service_ro_operations sg with(nolock) where file_process_id  =2562
				select top 10 * 
				update sg set natural_key = 'Seacoast'
				from clictell_auto_stg.stg.service_ro_operations sg with(nolock) where file_process_id   in (2801,2802,2803)

				select * 
				--update a set  natural_key = 'Seacoast'
				from clictell_auto_stg.stg.service_ro_header a (nolock) where file_process_id  in (2801,2802,2803)



		select top 10 * from clictell_auto_etl.etl.atc_service (nolock) where file_process_id =2796		
		select top 10 * from clictell_auto_etl.etl.atc_sales1 (nolock) where file_process_id = 2796
		select top 10 * from clictell_auto_etl.etl.atc_sales2 (nolock) where file_process_id = 2796
		select top 10 * from clictell_auto_etl.etl.atc_service_appts (nolock) where file_process_id = 2796
		select top 10 * from clictell_auto_etl.etl.atc_inventory (nolock) where file_process_id = 2796


		select count(*) from clictell_auto_etl.etl.atc_service (nolock) where file_process_id =2833		
		select count(*) from clictell_auto_etl.etl.atc_sales1 (nolock) where file_process_id = 2833
		select count(*) from clictell_auto_etl.etl.atc_sales2 (nolock) where file_process_id = 2833
		select count(*) from clictell_auto_etl.etl.atc_service_appts (nolock) where file_process_id = 2833
		select count(*) from clictell_auto_etl.etl.atc_inventory (nolock) where file_process_id = 2833



		select count(*) from clictell_auto_stg.stg.service_ro_header (nolock) where file_process_id  = 2800
		select count(*) from clictell_auto_stg.[stg].[service_ro_operations] (nolock) where file_process_id  = 2800
		select count(*) from clictell_auto_stg.[stg].[service_ro_parts] (nolock) where file_process_id  = 2800
		--select count(*) from clictell_auto_stg.[stg].[service_ro_technicians] (nolock) where file_process_id  = 2799
		select count(*) from clictell_auto_stg.[stg].[vehicle] (nolock) where file_process_id  = 2800
		select count(*) from clictell_auto_stg.stg.fi_sales (nolock) where file_process_id  = 2800
		select count(*) from clictell_auto_stg.stg.service_appts (nolock) where file_process_id  = 2800
		--select count(*) from clictell_auto_stg.stg.inventory (nolock) where file_process_id  = 2796
		select count(*) from clictell_auto_stg.stg.customers (nolock) where file_process_id = 2800
		select count(*) from clictell_auto_stg.[stg].[fi_sales_people] (nolock) where file_process_id  = 2800
--2796,2799,2800,2801,2802,2803
--2796,2799,2800 moved to master

	select file_process_id, count(*) from clictell_auto_master.master.repair_order_header (nolock) where file_process_id in (2796,2799,2800,2801,2802,2803) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.master.repair_order_header_detail (nolock) where file_process_id in (2796,2799,2800,2801,2802,2803) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.master.fi_sales (nolock) where file_process_id in (2796,2799,2800,2801,2802,2803) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.[master].[fi_sales_people] (nolock) where file_process_id in (2796,2799,2800,2801,2802,2803) group by file_process_id
	--select count(*) from clictell_auto_master.master.inventory (nolock) where file_process_id = 2800
	select file_process_id, count(*) from clictell_auto_master.master.customer (nolock) where file_process_id in (2796,2799,2800,2801,2802,2803) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.master.vehicle (nolock) where file_process_id in (2796,2799,2800,2801,2802,2803) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.[master].[cust_2_vehicle] (nolock) where file_process_id  in (2796,2799,2800,2801,2802,2803) group by file_process_id



exec clictell_auto_etl.[etl].[move_atc_Servicero_operations_etl_2_stage]  2803
exec clictell_auto_etl.[etl].[move_atc_Service_parts_etl_2_stage]   2803
exec clictell_auto_etl.[etl].[move_atc_service_etl_2_stage] 2803
exec clictell_auto_etl.[etl].[move_atc_fi_sale_raw_etl_2_stage] 2803
exec clictell_auto_etl.[etl].[move_atc_service_appts_raw_etl_2_stage] 2803
exec clictell_auto_etl.[etl].[move_atc_vehicles_etl_2_stage] 2803
exec clictell_auto_etl.[etl].[move_atc_customers_etl_2_stage]  2803


		select count(*) from clictell_auto_stg.stg.service_ro_header (nolock) where file_process_id  = 2848
		select count(*) from clictell_auto_stg.[stg].[service_ro_operations] (nolock) where file_process_id  = 2848
		select count(*) from clictell_auto_stg.[stg].[service_ro_parts] (nolock) where file_process_id  = 2803
		select count(*) from clictell_auto_stg.[stg].[vehicle] (nolock) where file_process_id  = 2803
		select count(*) from clictell_auto_stg.stg.fi_sales (nolock) where file_process_id  = 2803
		select count(*) from clictell_auto_stg.stg.service_appts (nolock) where file_process_id  = 2803
		select count(*) from clictell_auto_stg.stg.customers (nolock) where file_process_id = 2803
		select count(*) from clictell_auto_stg.[stg].[fi_sales_people] (nolock) where file_process_id  = 2803

		select count(*) from clictell_auto_etl.etl.atc_service (nolock) where file_process_id =2848		
		select count(*) from clictell_auto_etl.etl.atc_sales1 (nolock) where file_process_id = 2848
		select count(*) from clictell_auto_etl.etl.atc_sales2 (nolock) where file_process_id = 2848
		select count(*) from clictell_auto_etl.etl.atc_service_appts (nolock) where file_process_id = 2848
		select count(*) from clictell_auto_etl.etl.atc_inventory (nolock) where file_process_id = 2848


select * from clictell_auto_etl.etl.file_process_details (nolock) order by 1 desc

--ETL to STG
exec clictell_auto_etl.[etl].[move_atc_Servicero_operations_etl_2_stage]  2836
exec clictell_auto_etl.[etl].[move_atc_Service_parts_etl_2_stage]   2848
exec clictell_auto_etl.[etl].[move_atc_service_etl_2_stage] 2848
exec clictell_auto_etl.[etl].[move_atc_fi_sale_raw_etl_2_stage] 2848
exec clictell_auto_etl.[etl].[move_atc_service_appts_raw_etl_2_stage] 2848
exec clictell_auto_etl.[etl].[move_atc_vehicles_etl_2_stage] 2848
exec clictell_auto_etl.[etl].[move_atc_customers_etl_2_stage]  2848

--STG to Master
exec clictell_auto_stg.stg.move_customer_stage_2_master 2848
exec clictell_auto_stg.[stg].[move_vehicles_stage_2_master] 2848
exec clictell_auto_stg.stg.move_customers_2_vehicle_stage_2_master  2848
exec clictell_auto_stg.stg.move_fi_sales_stage_2_master 2848
exec clictell_auto_stg.stg.move_fi_sales_trade_vehicle_stage_2_master 2848
exec clictell_auto_stg.stg.move_fi_sales_people_stage_2_master 2848
exec clictell_auto_stg.stg.move_service_ro_header_stage_2_master 2848
exec clictell_auto_stg.stg.move_servicero_detail_stage_2_master 2848
exec clictell_auto_stg.stg.move_service_appts_stage_2_master  2848


--Update SPs
exec clictell_auto_stg.master.move_cust_2_vehicle_updates
exec clictell_auto_master.[master].[Update_Dashboard_Counts]
exec clictell_auto_master.[master].[Update_customer_KPI_graph_data]
exec clictell_auto_master.[master].[Update_RO_KPI_graph_data]
exec clictell_auto_master.[master].[Update_Sales_KPI_graph_data]
exec clictell_auto_master.[master].[service_kpi_update]
exec clictell_auto_master.[master].[sales_kpi_update]
exec clictell_auto_stg.[master].[cust2vehicle_inactivedate_update] 2848
exec clictell_auto_master.[master].[update_customer_status] 2848




	select file_process_id, count(*) from clictell_auto_master.master.repair_order_header (nolock) where file_process_id in (2801,2802,2803) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.master.repair_order_header_detail (nolock) where file_process_id in (2801,2802,2803) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.master.fi_sales (nolock) where file_process_id in (2801,2802,2803) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.[master].[fi_sales_people] (nolock) where file_process_id in (2801,2802,2803) group by file_process_id
	--select count(*) from clictell_auto_master.master.inventory (nolock) where file_process_id = 2800
	select file_process_id, count(*) from clictell_auto_master.master.customer (nolock) where file_process_id in (2801,2802,2803) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.master.vehicle (nolock) where file_process_id in (2801,2802,2803) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.[master].[cust_2_vehicle] (nolock) where file_process_id  in (2801,2802,2803) group by file_process_id


	select * from auto_customers.portal.account with (nolock) where accountname like 'seaco%'




exec clictell_auto_stg.master.move_cust_2_vehicle_updates
exec clictell_auto_master.[master].[Update_Dashboard_Counts]
exec clictell_auto_master.[master].[Update_customer_KPI_graph_data]
exec clictell_auto_master.[master].[Update_RO_KPI_graph_data]
exec clictell_auto_master.[master].[Update_Sales_KPI_graph_data]
exec clictell_auto_master.[master].[service_kpi_update]
exec clictell_auto_master.[master].[sales_kpi_update]
exec clictell_auto_stg.[master].[cust2vehicle_inactivedate_update] 2803
exec clictell_auto_master.[master].[update_customer_status] 2803


--2796,2799,2800,2801,2802,2803


	select * 
	--update a set ro_status = 'COMPLETED'
	--from clictell_auto_master.master.repair_order_header a (nolock) where file_process_id in (2796,2799,2800,2801,2802,2803)
	select * from clictell_auto_master.master.repair_order_header_detail (nolock) where file_process_id in (2801,2802,2803)
	select * from clictell_auto_master.master.repair_order_header (nolock) where file_process_id in (2801,2802,2803)
select  top 3 * from clictell_auto_master.master.repair_order_header (nolock) where file_process_id in (2562) -- 'COMPLETED'
select  top 3 * from clictell_auto_master.master.repair_order_header (nolock) where file_process_id in (2801) -- 'COMPLETED'


select * from clictell_auto_master.master.repair_order_header_detail (nolock)
where natural_key = 'seacoast'
--file_process_id in (2796,2799,2800,2801,2802,2803) 
and is_declined = 1 -- 'COMPLETED'
order by ro_closed_date



	select file_process_id, count(*) from clictell_auto_master.master.repair_order_header (nolock) where file_process_id in (2833) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.master.repair_order_header_detail (nolock) where file_process_id in (2833) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.master.fi_sales (nolock) where file_process_id in (2833) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.[master].[fi_sales_people] (nolock) where file_process_id in (2833) group by file_process_id
	--select count(*) from clictell_auto_master.master.inventory (nolock) where file_process_id = 2800
	select file_process_id, count(*) from clictell_auto_master.master.customer (nolock) where file_process_id in (2833) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.master.vehicle (nolock) where file_process_id in (2833) group by file_process_id
	select file_process_id, count(*) from clictell_auto_master.[master].[cust_2_vehicle] (nolock) where file_process_id  in (2833) group by file_process_id






		select Natural_key,*
		--update a set natural_key = 'miracle'
		from clictell_auto_master.master.dealer a with (nolock) where accountname like 'miracle%' and parent_dealer_id = 4601
		select Natural_key,* 
		--update a set natural_key = 'hankster'
		from clictell_auto_master.master.dealer a with (nolock) where accountname like 'hanks%' and parent_dealer_id = 4587


		select len('Miracle')
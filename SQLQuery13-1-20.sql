use clictell_auto_etl
insert into stg.repair_order_detail (total_customer_cost ,tech_id) select [Total Cost]  ,100 from etl.atc_service;

select * from stg.repair_order_detail nolock;

delete from stg.repair_order_detail;

insert into stg.repair_order_detail (total_customer_cost) select [Total Cost]  from etl.atc_service;

exec [etl].[move_act_service_raw_etl_2_stage] 1;

select * from [etl].[atc_service] nolock

select * from [stg].[repair_order_detail] nolock;

SELECT 
    IIF(10 < 20, 'True', 'False') Result


use clictell_auto_etl
exec [etl].[move_atc_sale_raw_etl_2_stage] @file_log_detail_id = 13 --5
select nuo_flag from stg.fi_sales;
select * from etl.atc_sales1;
select * from master.dealer;
select * from error.records_2_validate;


delete from stg.fi_sales;

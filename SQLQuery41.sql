use clictell_auto_etl 
go
select * from etl.atm_sales1 where file_process_detail_id =1089
select * from etl.atm_sales2 where file_process_detail_id =1089
select * from etl.atm_service where file_process_detail_id =1090

select * from [etl].[file_process_details] 
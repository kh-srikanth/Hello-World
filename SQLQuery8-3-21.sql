use clictell_auto_etl
select * from [etl].[cdk_servicero_details]
select * from [etl].[cdk_customer]
select * from [etl].[cdk_servicero_header]
select * from [etl].[cdk_servicero_part_detail_xml]
select * from [etl].[cdk_servicero_technician_details]

select * from [stg].[service_ro_header]
select * from [stg].[service_ro_operations]
select * from [stg].[service_ro_parts]
select * from [stg].[service_ro_technicians]
select * from [stg].[service_appts]
select * from [stg].[vehicle]
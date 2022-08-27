select * from auto_campaigns.[campaign].[reports] (nolock) 
select * from auto_campaigns.[campaign].[report_type] (nolock)

select distinct top 100  
	primary_phone_number,primary_phone_number_valid,clictell_auto_etl.dbo.isPhoneNoValid(primary_phone_number) 
from auto_customers.customer.customers (nolock) 
where 
	is_deleted =0 and account_id = '26239573-9C57-44A1-B209-391C7B564B7E'
order by primary_phone_number

select 
		report_name
		,report_desc
		,report_type_id
		,report_url
		,thumbnail_url
		,sort_order
		,is_group_report
		,vertical_id

from auto_campaigns.[campaign].[reports] (nolock) where vertical_id =2
--insert into auto_campaigns.[campaign].[reports] 
--(
--		report_name
--		,report_desc
--		,report_type_id
--		,report_url
--		,thumbnail_url
--		,sort_order
--		,is_group_report
--		,vertical_id

--)
select
		'R2R Follow-up Report(Sales)' as report_name
		,'' as report_desc
		,1 as report_type_id
		,'https://rpt.clictell.com/report/DMSReports?reportName=R2R%20Follow-up%20Report(Sales)' as report_url
		,'' as thumbnail_url
		,10 as sort_order
		,0 as is_group_report
		,2 as vertical_id

union

select
'R2R Sales Trend by Revenue Type' as report_name
,'' as report_desc
,1 as report_type_id
,'https://rpt.clictell.com/report/DMSReports?reportName=R2R%20Sales%20Trend%20by%20Revenue%20Type' as report_url
,'' as thumbnail_url
,10 as sort_order
,0 as is_group_report
,2 as vertical_id

union 

select
'R2R Sales Trend Monthly' as report_name
,'' as report_desc
,1 as report_type_id
,'https://rpt.clictell.com/report/DMSReports?reportName=R2R%20Sales%20Trend%20Monthly' as report_url
,'' as thumbnail_url
,10 as sort_order
,0 as is_group_report
,2 as vertical_id

union 
---ServiceReports
select
'R2R Follow-up Report (Service)' as report_name
,'' as report_desc
,2 as report_type_id
,'https://rpt.clictell.com/report/DMSReports?reportName=R2R%20Follow-up%20Report%20(Service)' as report_url
,'' as thumbnail_url
,10 as sort_order
,0 as is_group_report
,2 as vertical_id

union 

select
'R2R Master Service Customer' as report_name
,'' as report_desc
,2 as report_type_id
,'https://rpt.clictell.com/report/DMSReports?reportName=R2R%20Master%20Service%20Customer' as report_url
,'' as thumbnail_url
,10 as sort_order
,0 as is_group_report
,2 as vertical_id

union

select
'R2R Response Trend Monthly' as report_name
,'' as report_desc
,2 as report_tpe_id
,'https://rpt.clictell.com/report/DMSReports?reportName=R2R%20Response%20Trend%20Monthly' as report_url
,'' as thumbnail_url
,10 as sort_order
,0 as is_group_report
,2 as vertical_id

union

select
'R2R RO Listing' as report_name
,'' as report_desc
,2 as report_tpe_id
,'https://rpt.clictell.com/report/DMSReports?reportName=R2R%20RO%20Listing' as report_url
,'' as thumbnail_url
,10 as sort_order
,0 as is_group_report
,2 as vertical_id

union

select
'R2R Service by Vehicle Mileage (All Service Customers)' as report_name
,'' as report_desc
,2 as report_tpe_id
,'https://rpt.clictell.com/report/DMSReports?reportName=R2R%20Service%20by%20Vehicle%20Mileage%20(All%20Service%20Customers)' as report_url
,'' as thumbnail_url
,10 as sort_order
,0 as is_group_report
,2 as vertical_id

union

select
'R2R Service by Zip Code' as report_name
,'' as report_desc
,2 as report_tpe_id
,'https://rpt.clictell.com/report/DMSReports?reportName=R2R%20Service%20by%20Zip%20Code' as report_url
,'' as thumbnail_url
,10 as sort_order
,0 as is_group_report
,2 as vertical_id

union

select
'R2R Top Service Types Performed' as report_name
,'' as report_desc
,2 as report_tpe_id
,'https://rpt.clictell.com/report/DMSReports?reportName=R2R%20Top%20Service%20Types%20Performed' as report_url
,'' as thumbnail_url
,10 as sort_order
,0 as is_group_report
,2 as vertical_id


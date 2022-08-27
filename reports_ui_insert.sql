 	-- insert into master.dealer_mapping 
 (
 natural_key
 ,parent_dealer_id
 ,account_id
 ,_id
 ,account_name
 ,src_dealer_code
 ,dealer_source
 )
 select
 '76195211' as natural_key
 ,4538 as parent_dealer_id
 ,4538 as account_id
 ,'2928EACC-A39D-4743-BF02-F9689F16E79F' as _id
 ,'Lone Star Yamaha' as accountname
 ,'76195211' as src_dealer_code
 ,'cdk_lgt' as dealer_source

select * from auto_campaigns.campaign.reports (nolock) where is_deleted=0 and  vertical_id = 2 and report_type_id = 1 



use auto_campaigns
select * 
--update a set is_deleted = 1
from auto_campaigns.campaign.reports a (nolock) where is_deleted=0 and  vertical_id = 2 and report_type_id = 1 and report_id = 88


--insert into auto_campaigns.campaign.reports
(
vertical_id
,report_name
,report_type_id
,report_url
,thumbnail_url
,sort_order
,is_group_report
)
select
2 as vertical_id
,'R2R Service Trend by Pay Type (All Service Customers)' as report_name
,2 as report_type_id
,'https://rpt.clictell.com/report/DMSReports?reportName=R2R%20Service%20Trend%20by%20Pay%20Type%20(All%20Service%20Customers)&verticalId=2' as report_url
,'' as thumbnail_url
,10 as sort_order
,0 as is_group_report



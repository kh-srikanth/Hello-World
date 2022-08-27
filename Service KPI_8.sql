use clictell_auto_master
go
IF OBJECT_ID('tempdb..#gross') IS NOT NULL DROP TABLE #gross
IF OBJECT_ID('tempdb..#gross_ly') IS NOT NULL DROP TABLE #gross_ly
IF OBJECT_ID('tempdb..#result1') IS NOT NULL DROP TABLE #result1
IF OBJECT_ID('tempdb..#result2') IS NOT NULL DROP TABLE #result2
IF OBJECT_ID('tempdb..#header1') IS NOT NULL DROP TABLE #header1
IF OBJECT_ID('tempdb..#header') IS NOT NULL DROP TABLE #header

select
	parent_dealer_id
	,total_repair_order_price - total_repair_order_cost as total_gross
	,total_warranty_price - total_warranty_cost as warranty_gross
	,total_customer_price - total_customer_cost as customer_gross
	,total_internal_price - total_internal_cost as internal_gross
	,ro_number

	into #gross
from master.repair_order_header (nolock)
where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()

select
	parent_dealer_id
	,sum(total_gross) as total_gross_ytd
	,avg(total_gross) as avg_gross_ytd
	,Avg(warranty_gross) as avg_wp_gross
	,avg(customer_gross) as avg_cp_gross
	,avg(internal_gross) as avg_ip_gross
	into #result1
from #gross
group by parent_dealer_id


---------LY Calculations

select
	parent_dealer_id
	,total_repair_order_price - total_repair_order_cost as total_gross
	,total_warranty_price - total_warranty_cost as warranty_gross
	,total_customer_price - total_customer_cost as customer_gross
	,total_internal_price - total_internal_cost as internal_gross
	,ro_number

	into #gross_ly
from master.repair_order_header (nolock)
where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())

select
	parent_dealer_id
	,sum(total_gross) as total_gross_ytd_ly
	,avg(total_gross) as avg_gross_ytd_ly
	,Avg(warranty_gross) as avg_wp_gross_ly
	,avg(customer_gross) as avg_cp_gross_ly
	,avg(internal_gross) as avg_ip_gross_ly
	into #result2
from #gross_ly
group by parent_dealer_id

select 
	c.parent_dealer_id as accountId
	,'Number' as chart_type
	,'Average Gross per RO' as chart_title
	,convert(decimal(18,1),convert(decimal(18,1),(total_gross_ytd - total_gross_ytd_ly)*100)/total_gross_ytd_ly) as total_gross_ly_perc_change
	,convert(decimal(18,1),convert(decimal(18,1),(avg_gross_ytd - avg_gross_ytd_ly)*100)/avg_gross_ytd_ly) as avg_gross_ly_perc_change
	,total_gross_ytd
	into #header1
from #result1 c inner join #result2 l on c.parent_dealer_id =l.parent_dealer_id


select 
	accountId
	,chart_type
	,chart_title
	,datename(year,getdate())+' Total Gross = ' + convert(varchar(100),total_gross_ytd)+', LY Change % = '+convert(varchar(100),total_gross_ly_perc_change)+'%' as chart_subtitle_1
	,datename(year,getdate())+' YTD Total Gross = ' + convert(varchar(100),total_gross_ytd) as chart_subtitle_2
	into #header
from #header1

declare @graph_data varchar(5000) = (
select 
	 header.accountId
	,header.chart_type
	,header.chart_title
	,header.chart_subtitle_1
	,header.chart_subtitle_2
	,number_data.total_gross_ytd
	--,number_data.avg_gross_ytd
	,number_data.avg_cp_gross
	,number_data.avg_wp_gross
	,number_data.avg_ip_gross

from #header header inner join #result1 number_data on header.accountId =number_data.parent_dealer_id
for json auto  )

select @graph_data

--insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, graph_data)
--	values (
--		(select top 1 accountId from #header) 
--		,'service'
--		,'Average gross ($) per Hour for CP, WP and Int'
--		,'Average Gross per RO'
--		,@graph_data
--	)

--	select * from master.dashboard_kpis
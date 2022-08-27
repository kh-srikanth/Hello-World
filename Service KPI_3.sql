use clictell_auto_master
go
/*

Total Gross ($) by CP, WP and INT KPI - 3
select * from master.dashboard_kpis
*/
IF OBJECT_ID('tempdb..#gross_ytd') IS NOT NULL DROP TABLE #gross_ytd
IF OBJECT_ID('tempdb..#gross_ytd_ly') IS NOT NULL DROP TABLE #gross_ytd_ly
IF OBJECT_ID('tempdb..#gross_mtd') IS NOT NULL DROP TABLE #gross_mtd
IF OBJECT_ID('tempdb..#data') IS NOT NULL DROP TABLE #data
IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result
IF OBJECT_ID('tempdb..#result1') IS NOT NULL DROP TABLE #result1
IF OBJECT_ID('tempdb..#result2') IS NOT NULL DROP TABLE #result2
IF OBJECT_ID('tempdb..#header') IS NOT NULL DROP TABLE #header



	select 	
		sum(total_customer_price ) - sum(total_customer_cost ) as gross_cp_ytd	
		,sum(total_internal_price) - sum(total_internal_cost) as gross_ip_ytd
		,sum(total_warranty_price) - sum(total_internal_cost) as gross_wp_ytd
		,parent_Dealer_id 
	into #gross_ytd	
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	group by parent_Dealer_id


	select 	
		sum(total_customer_price ) - sum(total_customer_cost ) as gross_cp_ytd_ly	
		,sum(total_internal_price) - sum(total_internal_cost) as gross_ip_ytd_ly
		,sum(total_warranty_price) - sum(total_internal_cost) as gross_wp_ytd_ly
		,parent_Dealer_id 
	into #gross_ytd_ly
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
	group by parent_Dealer_id

	select 
			l.parent_dealer_id
			,'Gross by Pay Type' as chart_title
			,datename(year,getdate())+' Total Gross profit = $' + convert(varchar(50),convert(decimal(18,1),gross_cp_ytd+gross_ip_ytd+gross_wp_ytd)) 
				+ ' and ' + 'LY Change % = ' + convert(varchar(50),convert(int,((gross_cp_ytd+gross_ip_ytd+gross_wp_ytd) - (gross_cp_ytd_ly+gross_ip_ytd_ly+gross_wp_ytd_ly))*100 / (gross_cp_ytd_ly+gross_ip_ytd_ly+gross_wp_ytd_ly))) + '%' as chart_subtitle_1
			,'YTD Total = $' + convert(varchar(50),(gross_cp_ytd+gross_ip_ytd+gross_wp_ytd))  as chart_subtitle_2

		into #header
	from #gross_ytd y inner join #gross_ytd_ly l on y.parent_dealer_id =l.parent_dealer_id
	

	select 	
			sum(total_customer_price ) - sum(total_customer_cost ) as gross_cp_ytd	
			,sum(total_internal_price) - sum(total_internal_cost) as gross_ip_ytd
			,sum(total_warranty_price) - sum(total_internal_cost) as gross_wp_ytd
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name
			,parent_Dealer_id 
		into #result1
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
declare @graph_data varchar(5000) = (	
	select 
			[header].parent_dealer_id as accountId
			,[header].chart_title
			,[header].chart_subtitle_1
			,[header].chart_subtitle_2
			,mnt_name
			,gross_cp_ytd 
			,gross_ip_ytd 
			,gross_wp_ytd 
	from #result1 chart_data 
	inner join #header header on chart_data.parent_dealer_id = header.parent_dealer_id
	
		order by mnt

	for json auto
	)
select @graph_data


--	insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, chart_subtitle1, chart_subtitle2, graph_data)

--	values (
--		(select top 1 parent_dealer_id from #result1) 
--		,'service'
--		,'Total Gross ($) by CP, WP and INT'
--		,(select chart_title from #header)
--		,(select chart_subtitle_1 from #header)
--		,(select chart_subtitle_2 from #header)
--		,@graph_data
--	)

--select * from master.dashboard_kpis
	
/*	create table #result2 ( parent_dealer_id int, Gross_type varchar(20), January decimal(18,2), February decimal(18,2), 
						March decimal(18,2), April decimal(18,2), May decimal(18,2)	,June decimal(18,2), July decimal(18,2), 
						August decimal(18,2),September decimal(18,2),October decimal(18,2),November decimal(18,2),December decimal(18,2) )
	
	insert into  #result2 (parent_dealer_id, Gross_type,January,February,March,April,May,June,July,August,September,October,November,December)
	values
	(
		(select top 1 parent_dealer_id from #result1)
		,'gross_cp_ytd'
		,(select gross_cp_ytd from #result1 where mnt_name = 'January')
		,(select gross_cp_ytd from #result1 where mnt_name = 'February')
		,(select gross_cp_ytd from #result1 where mnt_name = 'March')
		,(select gross_cp_ytd from #result1 where mnt_name = 'April')
		,(select gross_cp_ytd from #result1 where mnt_name = 'May')
		,(select gross_cp_ytd from #result1 where mnt_name = 'June')
		,(select gross_cp_ytd from #result1 where mnt_name = 'July')
		,(select gross_cp_ytd from #result1 where mnt_name = 'August')
		,(select gross_cp_ytd from #result1 where mnt_name = 'September')
		,(select gross_cp_ytd from #result1 where mnt_name = 'October')
		,(select gross_cp_ytd from #result1 where mnt_name = 'November')
		,(select gross_cp_ytd from #result1 where mnt_name = 'December')
	)


	insert into  #result2 (parent_dealer_id, Gross_type,January,February,March,April,May,June,July,August,September,October,November,December)
	values
	(
		(select top 1 parent_dealer_id from #result1)
		,'gross_wp_ytd'
		,(select gross_wp_ytd from #result1 where mnt_name = 'January')
		,(select gross_wp_ytd from #result1 where mnt_name = 'February')
		,(select gross_wp_ytd from #result1 where mnt_name = 'March')
		,(select gross_wp_ytd from #result1 where mnt_name = 'April')
		,(select gross_wp_ytd from #result1 where mnt_name = 'May')
		,(select gross_wp_ytd from #result1 where mnt_name = 'June')
		,(select gross_wp_ytd from #result1 where mnt_name = 'July')
		,(select gross_wp_ytd from #result1 where mnt_name = 'August')
		,(select gross_wp_ytd from #result1 where mnt_name = 'September')
		,(select gross_wp_ytd from #result1 where mnt_name = 'October')
		,(select gross_wp_ytd from #result1 where mnt_name = 'November')
		,(select gross_wp_ytd from #result1 where mnt_name = 'December')
	)

		insert into  #result2 (parent_dealer_id, Gross_type,January,February,March,April,May,June,July,August,September,October,November,December)
	values
	(
		(select top 1 parent_dealer_id from #result1)
		,'gross_ip_ytd'
		,(select gross_ip_ytd from #result1 where mnt_name = 'January')
		,(select gross_ip_ytd from #result1 where mnt_name = 'February')
		,(select gross_ip_ytd from #result1 where mnt_name = 'March')
		,(select gross_ip_ytd from #result1 where mnt_name = 'April')
		,(select gross_ip_ytd from #result1 where mnt_name = 'May')
		,(select gross_ip_ytd from #result1 where mnt_name = 'June')
		,(select gross_ip_ytd from #result1 where mnt_name = 'July')
		,(select gross_ip_ytd from #result1 where mnt_name = 'August')
		,(select gross_ip_ytd from #result1 where mnt_name = 'September')
		,(select gross_ip_ytd from #result1 where mnt_name = 'October')
		,(select gross_ip_ytd from #result1 where mnt_name = 'November')
		,(select gross_ip_ytd from #result1 where mnt_name = 'December')
	)

	select 
	[accountId].parent_dealer_id
	,[accountId].chart_title
	,[accountId].chart_subtitle_1
	,[accountId].chart_subtitle_2
	,[data].Gross_type
	,[data].January --as Gross_type.January
	,[data].February
	,[data].March
	,[data].April
	,[data].May
	,[data].June
	,[data].July
	,[data].August
	,[data].September
	,[data].October
	,[data].November
	,[data].December
	
	from #result2	[data] inner join #header [accountId] on [data].parent_dealer_id = [accountId].parent_dealer_id

	for json auto */

use clictell_auto_master
go

IF OBJECT_ID('tempdb..#gross_ytd') IS NOT NULL DROP TABLE #gross_ytd
IF OBJECT_ID('tempdb..#gross_ytd_ly') IS NOT NULL DROP TABLE #gross_ytd_ly
IF OBJECT_ID('tempdb..#gross_mtd') IS NOT NULL DROP TABLE #gross_mtd
IF OBJECT_ID('tempdb..#data') IS NOT NULL DROP TABLE #data
IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result
IF OBJECT_ID('tempdb..#result1') IS NOT NULL DROP TABLE #result1
IF OBJECT_ID('tempdb..#result2') IS NOT NULL DROP TABLE #result2

	----YTD calcualtions
	select 	sum(total_repair_order_price ) - sum(total_repair_order_cost ) as gross_ytd	,parent_Dealer_id into #gross_ytd	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	group by parent_Dealer_id
	---- LY Calculations
	select  sum(total_repair_order_price ) - sum(total_repair_order_cost ) as gross_ytd_ly	,parent_Dealer_id into #gross_ytd_ly	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
	group by parent_Dealer_id
	----MTD calculations
	select 	sum(total_repair_order_price ) - sum(total_repair_order_cost ) as gross_mtd		,parent_Dealer_id	into #gross_mtd from master.repair_order_header (nolock)
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), month(getdate()), 1) and getdate()
	group by parent_Dealer_id

	---YTD monthly calculations
	select 
		sum(total_repair_order_price ) - sum(total_repair_order_cost ) as total_gross_profit
		,month(convert(date,convert(char(8),ro_close_date))) as mnt
		,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name
		,parent_dealer_id 
		
		into #data 
		from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))


	---joining all data for result
	select 
			l.parent_Dealer_id
			,'Total Gorss Profit' as chart_title
			,datename(year,getdate())+' Total Gross profit = $' + convert(varchar(50),convert(decimal(18,1),gross_ytd)) + ' and ' + 'LY Change % = ' + convert(varchar(50),convert(int,(gross_ytd - gross_ytd_ly)*100 / gross_ytd_ly)) + '%' as chart_subtitle_1
			,datename(month,getdate())+' Gross Profit = $'+convert(varchar(50),convert(decimal(18,1),gross_mtd))  as chart_subtitle_2
			,[data].mnt_name
			,[data].mnt
			,[data].total_gross_profit

	into #result
	from 	#gross_ytd y 
	inner join #gross_ytd_ly l on y.parent_Dealer_id = l.parent_Dealer_id
	inner join #gross_mtd m on m.parent_Dealer_id =y.parent_Dealer_id
	inner join #data [data] on [data].parent_Dealer_id = y.parent_Dealer_id
	order by mnt


	----pivoting the result table to get data all data in a single JSON node
	select * into #result1 from 
	( select 
			parent_Dealer_id
			,chart_title
			,chart_subtitle_1
			,chart_subtitle_2
			,mnt_name
			,total_gross_profit

	from #result
	) as t
	pivot (
			sum(total_gross_profit)

			FOR mnt_name in (
								January
								,February
								,March
								,April
								,May
								,June
								,July
								,August
								,September
								,October
								,November
								,December
							)
		) as pivot_table;

declare @graph_data varchar(5000) = (

	select 
				parent_dealer_id as accountId
				,'Horizonital Bar' as Chart_type
				,chart_title
				,chart_subtitle_1
				,chart_subtitle_2
				,January as "graph_data.January"
				,February as "graph_data.February"
				,March as "graph_data.March"
				,April as "graph_data.April"
				,May as "graph_data.May"
				,June as "graph_data.June"
				,July as "graph_data.July"
				,August as "graph_data.August"
				,September as "graph_data.September"
				,October  as "graph_data.October"
				,November as "graph_data.November"
				,December as "graph_data.December"
	
	from #result1
	--union select * from #result2

	for JSON path
	)

	select @graph_data


	--	insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, chart_subtitle1, chart_subtitle2, graph_data)

	--values (
	--	(select top 1 parent_dealer_id from #result1) 
	--	,'service'
	--	,'Gross Profit and pace'
	--	,(select top 1 chart_title from #result)
	--	,(select top 1 chart_subtitle_1 from #result)
	--	,(select top 1 chart_subtitle_2 from #result)
	--	,@graph_data
	--)

	--select * from master.dashboard_kpis
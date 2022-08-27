use clictell_auto_master
go

IF OBJECT_ID('tempdb..#lbr_sale_ytd') IS NOT NULL DROP TABLE #lbr_sale_ytd
IF OBJECT_ID('tempdb..#lbr_sale_ytd_ly') IS NOT NULL DROP TABLE #lbr_sale_ytd_ly
IF OBJECT_ID('tempdb..#lbr_sale_mtd') IS NOT NULL DROP TABLE #lbr_sale_mtd
IF OBJECT_ID('tempdb..#data') IS NOT NULL DROP TABLE #data
IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result
IF OBJECT_ID('tempdb..#result1') IS NOT NULL DROP TABLE #result1
IF OBJECT_ID('tempdb..#result2') IS NOT NULL DROP TABLE #result2

	----YTD calcualtions
	select 	sum(total_labor_price) as lbr_sale_ytd	,parent_Dealer_id into #lbr_sale_ytd	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	group by parent_Dealer_id
	---- LY Calculations
	select  sum(total_labor_price) as lbr_sale_ytd_ly,parent_Dealer_id into #lbr_sale_ytd_ly	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
	group by parent_Dealer_id
	----MTD calculations
	select 	sum(total_labor_price) as lbr_sale_mtd	,parent_Dealer_id	into #lbr_sale_mtd from master.repair_order_header (nolock)
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), month(getdate()), 1) and getdate()
	group by parent_Dealer_id
	---YTD monthly calculations
	select 
		sum(total_labor_price) as labor_sale_amount
		,month(convert(date,convert(char(8),ro_close_date))) as mnt
		,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name
		,parent_dealer_id 
		
		into #data 
		from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))


	---joining all data tables for result
	select 
			l.parent_Dealer_id
			,'Labor Sales' as chart_title
			,datename(year,getdate())+' Sales = $' + convert(varchar(50),convert(decimal(18,1),lbr_sale_ytd)) + ' and ' + 'LY Change % = ' + convert(varchar(50),convert(int,(lbr_sale_ytd - lbr_sale_ytd_ly)*100 / lbr_sale_ytd_ly)) + '%' as chart_subtitle_1
			,datename(month,getdate())+' Total = $'+convert(varchar(50),convert(decimal(18,1),lbr_sale_mtd))  as chart_subtitle_2
			,[data].mnt_name
			,[data].mnt
			,[data].labor_sale_amount

	into #result
	from 	#lbr_sale_ytd y 
	inner join #lbr_sale_ytd_ly l on y.parent_Dealer_id = l.parent_Dealer_id
	inner join #lbr_sale_mtd m on m.parent_Dealer_id =y.parent_Dealer_id
	inner join #data [data] on [data].parent_Dealer_id = y.parent_Dealer_id
	order by mnt

----pivoting the result table to get data all data in a single JSON node
select * into #result1 from 
( 
select 
		parent_Dealer_id
		,chart_title
		,chart_subtitle_1
		,chart_subtitle_2
		,mnt_name
		,labor_sale_amount

from #result
) as t
pivot (
		sum(labor_sale_amount)

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


--	select * into #result2 from 
--( select 
--		parent_Dealer_id
--		,chart_subtitle_1
--		,chart_subtitle_2
--		,mnt_name
--		,labor_gross
--		,'Labour gross' as chart_title

--from #result
--) as t
--pivot (
--		sum(labor_gross)

--		FOR mnt_name in (
--							January
--							,February
--							,March
--							,April
--							,May
--							,June
--							,July
--							,August
--							,September
--							,October
--							,November
--							,December
--							)
--	) as pivot_table;
declare @graph_data varchar(5000) = (
select 
		parent_dealer_id as accountId
		,'vertical bar' as chart_type
		,chart_title
		,chart_subtitle_1
		,chart_subtitle_2
		,January as "graph_data.January"
		,February as "graph_data.february"
		,March as "graph_data.March"
		,April as "graph_data.April"
		,May as "graph_data.May"
		,June as "graph_data.June"
		,July as "graph_data.July"
		,August as "graph_data.August"
		,September as "graph_data.September"
		,October as "graph_data.October"
		,November as "graph_data.November"
		,December as "graph_data.December"
from #result1
--union select * from #result2

	for JSON path
	)

	select @graph_data

	--insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, chart_subtitle1, chart_subtitle2, graph_data)

	--values (
	--	(select top 1 parent_dealer_id from #result1) 
	--	,'service'
	--	,'Labour Sales and pace'
	--	,(select top 1 chart_title from #result)
	--	,(select top 1 chart_subtitle_1 from #result)
	--	,(select top 1 chart_subtitle_2 from #result)
	--	,@graph_data
	--)

	--select * from master.dashboard_kpis



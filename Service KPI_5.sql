use clictell_auto_master
go
IF OBJECT_ID('tempdb..#ro_cp') IS NOT NULL DROP TABLE #ro_cp
IF OBJECT_ID('tempdb..#ro_wp') IS NOT NULL DROP TABLE #ro_wp
IF OBJECT_ID('tempdb..#ro_ip') IS NOT NULL DROP TABLE #ro_ip

IF OBJECT_ID('tempdb..#ro_cp_ly') IS NOT NULL DROP TABLE #ro_cp_ly
IF OBJECT_ID('tempdb..#ro_wp_ly') IS NOT NULL DROP TABLE #ro_wp_ly
IF OBJECT_ID('tempdb..#ro_ip_ly') IS NOT NULL DROP TABLE #ro_ip_ly

IF OBJECT_ID('tempdb..#header1') IS NOT NULL DROP TABLE #header1
IF OBJECT_ID('tempdb..#header2') IS NOT NULL DROP TABLE #header2
IF OBJECT_ID('tempdb..#header') IS NOT NULL DROP TABLE #header

IF OBJECT_ID('tempdb..#ro_cp_graph') IS NOT NULL DROP TABLE #ro_cp_graph
IF OBJECT_ID('tempdb..#ro_wp_graph') IS NOT NULL DROP TABLE #ro_wp_graph
IF OBJECT_ID('tempdb..#ro_ip_graph') IS NOT NULL DROP TABLE #ro_ip_graph

IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result



-----YTD calculations
	select 	
		count(distinct ro_number) as ro_cp_count
		,parent_Dealer_id 

	into #ro_cp
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	and total_customer_price >0
	group by parent_Dealer_id

	select 	
		count(distinct ro_number) as ro_wp_count
		,parent_Dealer_id 

	into #ro_wp
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	and total_warranty_price >0
	group by parent_Dealer_id

	select 	
		count(distinct ro_number) as ro_ip_count
		,parent_Dealer_id 

	into #ro_ip
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	and total_internal_price >0
	group by parent_Dealer_id




------LY Calculations
	select 	
		count(distinct ro_number) as ro_cp_count_ly
		,parent_Dealer_id 

	into #ro_cp_ly
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
	and total_customer_price >0
	group by parent_Dealer_id

	select 	
		count(distinct ro_number) as ro_wp_count_ly
		,parent_Dealer_id 

	into #ro_wp_ly
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
	and total_warranty_price >0
	group by parent_Dealer_id

	select 	
		count(distinct ro_number) as ro_ip_count_ly
		,parent_Dealer_id 

	into #ro_ip_ly
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
	and total_internal_price >0
	group by parent_Dealer_id

	--------Headings
	select 
			c.parent_dealer_id
			,ro_cp_count
			,ro_wp_count
			,ro_ip_count
			into #header1
		from #ro_cp c inner join #ro_wp w on c.parent_dealer_id=w.parent_dealer_id
		inner join #ro_ip i on i.parent_dealer_id =w.parent_dealer_id

		select 
			c.parent_dealer_id
			,ro_cp_count_ly
			,ro_wp_count_ly
			,ro_ip_count_ly
			into #header2
		from #ro_cp_ly c inner join #ro_wp_ly w on c.parent_dealer_id=w.parent_dealer_id
		inner join #ro_ip_ly i on i.parent_dealer_id =w.parent_dealer_id


	select 
		h1.parent_dealer_id
		,'Line Trend' as chart_type
		,'ROs by Pay Type' as chart_title
		,datename(year,getdate()) +' CP RO Count = '+ convert(varchar(100),ro_cp_count)+', LY Change % = '+ convert(varchar(200),(ro_cp_count - ro_cp_count_ly)*100/ro_cp_count_ly)+'%; '
			+ datename(year,getdate()) +' WP RO Count = '+ convert(varchar(100),ro_wp_count)+', LY Change % = '+ convert(varchar(200),(ro_wp_count - ro_wp_count_ly)*100/ro_wp_count_ly)+'%; '
			+ datename(year,getdate()) +' IP RO Count = '+ convert(varchar(100),ro_ip_count)+', LY Change % = '+ convert(varchar(200),(ro_ip_count - ro_ip_count_ly)*100/ro_ip_count_ly)+'%; ' as chart_subtitle_1
		, datename(year, getdate()) + ' CP Total RO Count = ' + convert(varchar(100),ro_cp_count)+'; WP Total RO Count = ' + convert(varchar(100),ro_wp_count)+'; IP Total RO Count = ' + convert(varchar(100),ro_ip_count) as chart_subtitle_2
	into #header
	from #header1 h1 inner join #header2 h2 on h1.parent_dealer_id =h2.parent_dealer_id

	----------graph_data

	select 	
		count(distinct ro_number) as ro_cp_count
		,parent_Dealer_id 
		,month(convert(date,convert(char(8),ro_close_date))) as mnt
		,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

	into #ro_cp_graph
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	and total_customer_price >0
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))

	select 	
		count(distinct ro_number) as ro_wp_count
		,parent_Dealer_id 
		,month(convert(date,convert(char(8),ro_close_date))) as mnt
		,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name
	into #ro_wp_graph
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	and total_warranty_price >0
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))

	select 	
		count(distinct ro_number) as ro_ip_count
		,parent_Dealer_id 
		,month(convert(date,convert(char(8),ro_close_date))) as mnt
		,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name
	into #ro_ip_graph
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	and total_internal_price >0
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))

	select
			w.parent_dealer_id
			,w.mnt
			,w.mnt_name
			,ro_cp_count
			,ro_wp_count
			,ro_ip_count
		into #result
	from #ro_cp_graph c 
	inner join #ro_wp_graph w on c.parent_dealer_id =w.parent_dealer_id and c.mnt =w.mnt
	inner join #ro_ip_graph i on i.parent_dealer_id =w.parent_dealer_id and i.mnt =w.mnt
	order by mnt


declare @graph_data varchar(5000)=(
	select
		header.parent_dealer_id
		,header.chart_type
		,header.chart_title
		,header.chart_subtitle_1
		,header.chart_subtitle_2
		,graph_data.mnt
		,graph_data.mnt_name
		,graph_data.ro_cp_count
		,graph_data.ro_wp_count
		,graph_data.ro_ip_count
	from #header header inner join #result graph_data on header.parent_dealer_id = graph_data.parent_dealer_id
	order by mnt
	for JSON AUTO )
select @graph_data
		
	--insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, chart_subtitle1, chart_subtitle2, graph_data)
	--values (
	--	(select top 1 parent_dealer_id from #header) 
	--	,'service'
	--	,'CP, Warranty-Pay and Internal RO count'
	--	,(select chart_title from #header)
	--	,(select chart_subtitle_1 from #header)
	--	,(select chart_subtitle_2 from #header)
	--	,@graph_data
	--)

	--select * from master.dashboard_kpis
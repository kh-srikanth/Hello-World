use clictell_auto_master
go
IF OBJECT_ID('tempdb..#age') IS NOT NULL DROP TABLE #age
IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result
IF OBJECT_ID('tempdb..#result1') IS NOT NULL DROP TABLE #result1
IF OBJECT_ID('tempdb..#cp_hrs') IS NOT NULL DROP TABLE #cp_hrs
IF OBJECT_ID('tempdb..#wp_hrs') IS NOT NULL DROP TABLE #wp_hrs
IF OBJECT_ID('tempdb..#ip_hrs') IS NOT NULL DROP TABLE #ip_hrs
IF OBJECT_ID('tempdb..#cwi_hrs') IS NOT NULL DROP TABLE #cwi_hrs
IF OBJECT_ID('tempdb..#cp_hrs_ly') IS NOT NULL DROP TABLE #cp_hrs_ly
IF OBJECT_ID('tempdb..#wp_hrs_ly') IS NOT NULL DROP TABLE #wp_hrs_ly
IF OBJECT_ID('tempdb..#ip_hrs_ly') IS NOT NULL DROP TABLE #ip_hrs_ly
IF OBJECT_ID('tempdb..#cwi_hrs_ly') IS NOT NULL DROP TABLE #cwi_hrs_ly
IF OBJECT_ID('tempdb..#header') IS NOT NULL DROP TABLE #header

IF OBJECT_ID('tempdb..#cp_hrs_ytd') IS NOT NULL DROP TABLE #cp_hrs_ytd
IF OBJECT_ID('tempdb..#wp_hrs_ytd') IS NOT NULL DROP TABLE #wp_hrs_ytd
IF OBJECT_ID('tempdb..#ip_hrs_ytd') IS NOT NULL DROP TABLE #ip_hrs_ytd
IF OBJECT_ID('tempdb..#graph_data') IS NOT NULL DROP TABLE #graph_data


	select 
			parent_dealer_id
			,sum(total_billed_labor_hours) as cp_hrs

			into #cp_hrs
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	and total_customer_price >0
	group by parent_Dealer_id


	select 
			parent_dealer_id
			,sum(total_billed_labor_hours) as wp_hrs

			into #wp_hrs
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	and total_warranty_price >0
	group by parent_Dealer_id

	select 
			parent_dealer_id
			,sum(total_billed_labor_hours) as ip_hrs
			into #ip_hrs
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	and total_internal_price >0
	group by parent_Dealer_id


	select 
		c.parent_dealer_id
		,cp_hrs
		,wp_hrs
		,ip_hrs
		into #cwi_hrs
	from #cp_hrs c inner join #wp_hrs w on c.parent_dealer_id = w.parent_dealer_id
	inner join #ip_hrs i on i.parent_dealer_id=w.parent_dealer_id


	--------------------------LY caluclations

		select 
			parent_dealer_id
			,sum(total_billed_labor_hours) as cp_hrs_ly

			into #cp_hrs_ly
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
	and total_customer_price >0
	group by parent_Dealer_id


	select 
			parent_dealer_id
			,sum(total_billed_labor_hours) as wp_hrs_ly

			into #wp_hrs_ly
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
	and total_warranty_price >0
	group by parent_Dealer_id

	select 
			parent_dealer_id
			,sum(total_billed_labor_hours) as ip_hrs_ly
			into #ip_hrs_ly
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
	and total_internal_price >0
	group by parent_Dealer_id


	select 
		c.parent_dealer_id
		,cp_hrs_ly
		,wp_hrs_ly
		,ip_hrs_ly
		into #cwi_hrs_ly
	from #cp_hrs_ly c inner join #wp_hrs_ly w on c.parent_dealer_id = w.parent_dealer_id
	inner join #ip_hrs_ly i on i.parent_dealer_id=w.parent_dealer_id


	--select * from #cwi_hrs
	--select * from #cwi_hrs_ly

	select 
		c.parent_dealer_id
		,'Stacked bar trend' as chart_type
		,'Hours Sold' as chart_title
		,datename(year,getdate())+' CP hrs Sold = '+convert(varchar(50),convert(decimal(18,1),c.cp_hrs))+ ', LY Change % = '+ convert(varchar(50),convert(decimal(18,1),(c.cp_hrs - l.cp_hrs_ly)*100/l.cp_hrs_ly))+'%' 
								+'; WP hrs sold = '+convert(varchar(50),convert(decimal(18,1),c.wp_hrs))+ ', LY Change % = '+ convert(varchar(50),convert(decimal(18,1),(c.wp_hrs - l.wp_hrs_ly)*100/l.wp_hrs_ly))+'%' 
								+'; IP hrs sold = '+convert(varchar(50),convert(decimal(18,1),c.ip_hrs))+ ', LY Change % = '+ convert(varchar(50),convert(decimal(18,1),(c.ip_hrs - l.ip_hrs_ly)*100/l.ip_hrs_ly))+'%'  as chart_subtitle_1
		,datename(year,getdate())+ ' Total CP hrs sold = '+convert(varchar(50),convert(decimal(18,1),c.cp_hrs))
								+ '; Total WP hrs sold = '+convert(varchar(50),convert(decimal(18,1),c.wp_hrs))
								+ '; Total IP hrs sold = '+convert(varchar(50),convert(decimal(18,1),c.ip_hrs)) as chart_subtitle_2

		into #header
	from #cwi_hrs c inner join #cwi_hrs_ly l on c.parent_dealer_id =l.parent_dealer_id


	----YTD Trend Calculations


		select 
			parent_dealer_id
			,sum(total_billed_labor_hours) as cp_hrs
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #cp_hrs_ytd
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	and total_customer_price >0
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))


	select 
			parent_dealer_id
			,sum(total_billed_labor_hours) as wp_hrs
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #wp_hrs_ytd
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	and total_warranty_price >0
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))

	select 
			parent_dealer_id
			,sum(total_billed_labor_hours) as ip_hrs
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #ip_hrs_ytd
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	and total_internal_price >0
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))


	select 
		c.parent_dealer_id
		,c.mnt
		,c.mnt_name
		,cp_hrs
		,wp_hrs
		,ip_hrs
	into #graph_data
	from #cp_hrs_ytd c inner join #wp_hrs_ytd w on c.parent_dealer_id = w.parent_dealer_id and c.mnt =w.mnt
	inner join #ip_hrs_ytd i on i.parent_dealer_id =c.parent_dealer_id and c.mnt =i.mnt
	order by mnt

declare @graph_data varchar(5000) = (

	select 
	header.parent_dealer_id
	,header.chart_type
	,header.chart_title
	,header.chart_subtitle_1
	,header.chart_subtitle_2
	,graph_data.mnt
	,graph_data.mnt_name
	,graph_data.cp_hrs
	,graph_data.wp_hrs
	,graph_data.ip_hrs

	from #header header inner join #graph_data graph_data on header.parent_dealer_id = graph_data.parent_dealer_id
	order by mnt

	for json auto )

	select @graph_data

	--	insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, graph_data)
	--values (
	--	(select top 1 parent_dealer_id from #header) 
	--	,'service'
	--	,'Hours stacked by CP, WP and Internal'
	--	,'Hours Sold'
	--	,@graph_data
	--)

	--select * from master.dashboard_kpis
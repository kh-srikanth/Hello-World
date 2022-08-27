use clictell_auto_master
go
IF OBJECT_ID('tempdb..#ro_ytd') IS NOT NULL DROP TABLE #ro_ytd
IF OBJECT_ID('tempdb..#ro_ytd_ly') IS NOT NULL DROP TABLE #ro_ytd_ly
IF OBJECT_ID('tempdb..#ro_mtd') IS NOT NULL DROP TABLE #ro_mtd
IF OBJECT_ID('tempdb..#header') IS NOT NULL DROP TABLE #header
IF OBJECT_ID('tempdb..#data') IS NOT NULL DROP TABLE #data


	----YTD calcualtions
	select 	count(distinct ro_number) as ro_vol_ytd	,parent_Dealer_id into #ro_ytd	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	group by parent_Dealer_id

	---- LY Calculations
	select  count(distinct ro_number) as ro_vol_ytd_ly	,parent_Dealer_id into #ro_ytd_ly	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
	group by parent_Dealer_id
	----MTD calculations
	select 	count(distinct ro_number) as ro_vol_mtd	,parent_Dealer_id	into #ro_mtd from master.repair_order_header (nolock)
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), month(getdate()), 1) and getdate()
	group by parent_Dealer_id


	select 
			y.parent_dealer_id
			,'Closed ROs' as chart_title
			,'Horizonital Bar' as chart_type
			,datename(year,getdate()) + ' Total RO Count = '+ convert(varchar(100),y.ro_vol_ytd) 
				+ ' and LY change % = '+ convert(varchar(100),(y.ro_vol_ytd - l.ro_vol_ytd_ly)*100/l.ro_vol_ytd_ly)+'%' as chart_subtitle_1
			,datename(month, getdate()) + ' RO Count = ' + convert(varchar(100),m.ro_vol_mtd) as chart_subtitle_2
		into #header
	from #ro_ytd y inner join #ro_ytd_ly l on y.parent_dealer_id = l.parent_dealer_id
	inner join #ro_mtd m on m.parent_dealer_id = l.parent_dealer_id

		
	select 
		count(distinct ro_number) as RO_count
		,month(convert(date,convert(char(8),ro_close_date))) as mnt
		,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name
		,parent_dealer_id 
		
		into #data 
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))


	declare @graph_data varchar(5000) = (
	select 
	header.parent_dealer_id as accountId
	,header.chart_type
	,header.chart_title
	,header.chart_subtitle_1
	,header.chart_subtitle_2
	,mnt_name
	,RO_count
	from #header header inner join #data graph_data on header.parent_dealer_id = graph_data.parent_dealer_id
	order by mnt
	for json auto )

	select @graph_data

	--	insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, chart_subtitle1, chart_subtitle2, graph_data)

	--values (
	--	(select top 1 parent_dealer_id from #header) 
	--	,'service'
	--	,'Total RO Count vs Pace'
	--	,(select chart_title from #header)
	--	,(select chart_subtitle_1 from #header)
	--	,(select chart_subtitle_2 from #header)
	--	,@graph_data
	--)

	--select * from master.dashboard_kpis
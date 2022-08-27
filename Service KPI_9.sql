use clictell_auto_master
go
IF OBJECT_ID('tempdb..#hrs_ro') IS NOT NULL DROP TABLE #hrs_ro

	select 	

			parent_Dealer_id 
			,sum(total_billed_labor_hours)/count(ro_number) as hrs_per_ro
	into #hrs_ro	
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	group by parent_Dealer_id


	declare @graph_data varchar(5000) = (
	select 
			parent_dealer_id
			,'Number' as chart_type
			,'Hours per RO' as chart_title
			,convert(decimal(18,1),hrs_per_ro) as hrs_per_ro
	from #hrs_ro
	FOR JSON AUTO )
	select @graph_data

	--		insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, graph_data)
	--values (
	--	(select top 1 parent_dealer_id from #hrs_ro) 
	--	,'service'
	--	,'Hours per RO'
	--	,'Hours per RO'
	--	,@graph_data
	--)

	--select * from master.dashboard_kpis
use clictell_auto_master
go
IF OBJECT_ID('tempdb..#elr') IS NOT NULL DROP TABLE #elr
	select 
		sum(total_customer_price)/sum(total_billed_labor_hours) as ELR
		,parent_Dealer_id 

into #elr
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	and total_customer_price >0
	group by parent_Dealer_id

	declare @graph_data varchar(500) = (
	select
			 parent_dealer_id
			 ,'Number ($)' as chart_type
			 ,'ELR' as chart_title
			 ,ELR
		from #elr
	FOR JSON AUTO
	)
	select @graph_data

	--	insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, graph_data)
	--values (
	--	(select top 1 parent_dealer_id from #elr) 
	--	,'service'
	--	,'Effective Labour Rate'
	--	,'ELR'
	--	,@graph_data
	--)

	--select * from master.dashboard_kpis
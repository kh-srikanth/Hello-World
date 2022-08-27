USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [dbo].[Master_cust_veh_inactiveupadte]    Script Date: 7/12/2021 1:14:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter Procedure [master].[service_kpi_update]



/*
exec [master].[service_kpi_update]
*/

as
begin

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


		--update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Labour Sales and pace'

		---------------------KPI--2
	
	IF OBJECT_ID('tempdb..#gross_ytd') IS NOT NULL DROP TABLE #gross_ytd
	IF OBJECT_ID('tempdb..#gross_ytd_ly') IS NOT NULL DROP TABLE #gross_ytd_ly
	IF OBJECT_ID('tempdb..#gross_mtd') IS NOT NULL DROP TABLE #gross_mtd
	IF OBJECT_ID('tempdb..#data_k2') IS NOT NULL DROP TABLE #data_k2
	IF OBJECT_ID('tempdb..#result_k2') IS NOT NULL DROP TABLE #result_k2
	IF OBJECT_ID('tempdb..#result1_k2') IS NOT NULL DROP TABLE #result1_k2
	IF OBJECT_ID('tempdb..#result2_k2') IS NOT NULL DROP TABLE #result2_k2

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
		
			into #data_k2 
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

		into #result_k2
		from 	#gross_ytd y 
		inner join #gross_ytd_ly l on y.parent_Dealer_id = l.parent_Dealer_id
		inner join #gross_mtd m on m.parent_Dealer_id =y.parent_Dealer_id
		inner join #data_k2 [data] on [data].parent_Dealer_id = y.parent_Dealer_id
		order by mnt


		----pivoting the result table to get data all data in a single JSON node
		select * into #result1_k2 from 
		( select 
				parent_Dealer_id
				,chart_title
				,chart_subtitle_1
				,chart_subtitle_2
				,mnt_name
				,total_gross_profit

		from #result_k2
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

	set @graph_data  = (

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
	
		from #result1_k2
		--union select * from #result2_k2

		for JSON path
		)
	

		select @graph_data

		--update master.dashboard_kpis set graph_data = @graph_data where chart_title = 'Gross Profit and pace'

		--	insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, chart_subtitle1, chart_subtitle2, graph_data)

		--values (
		--	(select top 1 parent_dealer_id from #result1) 
		--	,'service'
		--	,'Gross Profit and pace'
		--	,(select top 1 chart_title from #result_k2)
		--	,(select top 1 chart_subtitle_1 from #result_k2)
		--	,(select top 1 chart_subtitle_2 from #result_k2)
		--	,@graph_data
		--)

		--select * from master.dashboard_kpis
------------KPI--3
		/*

	Total Gross ($) by CP, WP and INT KPI - 3
	select * from master.dashboard_kpis
	*/
	IF OBJECT_ID('tempdb..#gross_ytd_k3') IS NOT NULL DROP TABLE #gross_ytd_k3
	IF OBJECT_ID('tempdb..#gross_ytd_ly_k3') IS NOT NULL DROP TABLE #gross_ytd_ly_k3
	IF OBJECT_ID('tempdb..#gross_mtd_k3') IS NOT NULL DROP TABLE #gross_mtd_k3
	IF OBJECT_ID('tempdb..#data_k3') IS NOT NULL DROP TABLE #data_k3
	IF OBJECT_ID('tempdb..#reult_k3') IS NOT NULL DROP TABLE #reult_k3
	IF OBJECT_ID('tempdb..#result1_k3') IS NOT NULL DROP TABLE #result1_k3
	IF OBJECT_ID('tempdb..#result2_k3') IS NOT NULL DROP TABLE #result2_k3
	IF OBJECT_ID('tempdb..#header_k3') IS NOT NULL DROP TABLE #header_k3



		select 	
			sum(total_customer_price ) - sum(total_customer_cost ) as gross_cp_ytd	
			,sum(total_internal_price) - sum(total_internal_cost) as gross_ip_ytd
			,sum(total_warranty_price) - sum(total_internal_cost) as gross_wp_ytd
			,parent_Dealer_id 
		into #gross_ytd_k3	
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		group by parent_Dealer_id


		select 	
			sum(total_customer_price ) - sum(total_customer_cost ) as gross_cp_ytd_ly	
			,sum(total_internal_price) - sum(total_internal_cost) as gross_ip_ytd_ly
			,sum(total_warranty_price) - sum(total_internal_cost) as gross_wp_ytd_ly
			,parent_Dealer_id 
		into #gross_ytd_ly_k3
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
		group by parent_Dealer_id

		select 
				l.parent_dealer_id
				,'Gross by Pay Type' as chart_title
				,'Stacked Trend' as chart_type
				,datename(year,getdate())+' Total Gross profit = $' + convert(varchar(50),convert(decimal(18,1),gross_cp_ytd+gross_ip_ytd+gross_wp_ytd)) 
					+ ' and ' + 'LY Change % = ' + convert(varchar(50),convert(int,((gross_cp_ytd+gross_ip_ytd+gross_wp_ytd) - (gross_cp_ytd_ly+gross_ip_ytd_ly+gross_wp_ytd_ly))*100 / (gross_cp_ytd_ly+gross_ip_ytd_ly+gross_wp_ytd_ly))) + '%' as chart_subtitle_1
				,'YTD Total = $' + convert(varchar(50),(gross_cp_ytd+gross_ip_ytd+gross_wp_ytd))  as chart_subtitle_2

			into #header_k3
		from #gross_ytd_k3 y inner join #gross_ytd_ly_k3 l on y.parent_dealer_id =l.parent_dealer_id
	

		select 	
				sum(total_customer_price ) - sum(total_customer_cost ) as gross_cp_ytd	
				,sum(total_internal_price) - sum(total_internal_cost) as gross_ip_ytd
				,sum(total_warranty_price) - sum(total_internal_cost) as gross_wp_ytd
				,month(convert(date,convert(char(8),ro_close_date))) as mnt
				,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name
				,parent_Dealer_id 
			into #result1_k3
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))


	set @graph_data = (	
		select 
				[header].parent_dealer_id as accountId
				,[header].chart_title
				,[header].chart_type
				,[header].chart_subtitle_1
				,[header].chart_subtitle_2
				,mnt_name
				,gross_cp_ytd 
				,gross_ip_ytd 
				,gross_wp_ytd 
		from #result1_k3 chart_data 
		inner join #header_k3 header on chart_data.parent_dealer_id = header.parent_dealer_id
	
			order by mnt

		for json auto
		)
	select @graph_data

	--update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Total Gross ($) by CP, WP and INT'
	
		------------ KPI --4


		IF OBJECT_ID('tempdb..#ro_ytd') IS NOT NULL DROP TABLE #ro_ytd
	IF OBJECT_ID('tempdb..#ro_ytd_ly') IS NOT NULL DROP TABLE #ro_ytd_ly
	IF OBJECT_ID('tempdb..#ro_mtd') IS NOT NULL DROP TABLE #ro_mtd
	IF OBJECT_ID('tempdb..#header_k4') IS NOT NULL DROP TABLE #header_k4
	IF OBJECT_ID('tempdb..#data_k4') IS NOT NULL DROP TABLE #data_k4

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
			into #header_k4
		from #ro_ytd y inner join #ro_ytd_ly l on y.parent_dealer_id = l.parent_dealer_id
		inner join #ro_mtd m on m.parent_dealer_id = l.parent_dealer_id

		
		select 
			count(distinct ro_number) as RO_count
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name
			,parent_dealer_id 
		
			into #data_k4 
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))


		set @graph_data  = (
		select 
		header.parent_dealer_id as accountId
		,header.chart_type
		,header.chart_title
		,header.chart_subtitle_1
		,header.chart_subtitle_2
		,mnt_name
		,RO_count
		from #header_k4 header inner join #data_k4 graph_data on header.parent_dealer_id = graph_data.parent_dealer_id
		order by mnt
		for json auto )

		select @graph_data
		--update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Closed ROs'



		-------KPI--5


		IF OBJECT_ID('tempdb..#ro_cp') IS NOT NULL DROP TABLE #ro_cp
	IF OBJECT_ID('tempdb..#ro_wp') IS NOT NULL DROP TABLE #ro_wp
	IF OBJECT_ID('tempdb..#ro_ip') IS NOT NULL DROP TABLE #ro_ip

	IF OBJECT_ID('tempdb..#ro_cp_ly') IS NOT NULL DROP TABLE #ro_cp_ly
	IF OBJECT_ID('tempdb..#ro_wp_ly') IS NOT NULL DROP TABLE #ro_wp_ly
	IF OBJECT_ID('tempdb..#ro_ip_ly') IS NOT NULL DROP TABLE #ro_ip_ly

	IF OBJECT_ID('tempdb..#header1_k5') IS NOT NULL DROP TABLE #header1_k5
	IF OBJECT_ID('tempdb..#header2_k5') IS NOT NULL DROP TABLE #header2_k5
	IF OBJECT_ID('tempdb..#header_k5') IS NOT NULL DROP TABLE #header_k5

	IF OBJECT_ID('tempdb..#ro_cp_graph') IS NOT NULL DROP TABLE #ro_cp_graph
	IF OBJECT_ID('tempdb..#ro_wp_graph') IS NOT NULL DROP TABLE #ro_wp_graph
	IF OBJECT_ID('tempdb..#ro_ip_graph') IS NOT NULL DROP TABLE #ro_ip_graph

	IF OBJECT_ID('tempdb..#result_k5') IS NOT NULL DROP TABLE #result_k5



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
				into #header1_k5
			from #ro_cp c inner join #ro_wp w on c.parent_dealer_id=w.parent_dealer_id
			inner join #ro_ip i on i.parent_dealer_id =w.parent_dealer_id

			select 
				c.parent_dealer_id
				,ro_cp_count_ly
				,ro_wp_count_ly
				,ro_ip_count_ly
				into #header2_k5
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
		into #header_k5
		from #header1_k5 h1 inner join #header2_k5 h2 on h1.parent_dealer_id =h2.parent_dealer_id

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
			into #result_k5
		from #ro_cp_graph c 
		inner join #ro_wp_graph w on c.parent_dealer_id =w.parent_dealer_id and c.mnt =w.mnt
		inner join #ro_ip_graph i on i.parent_dealer_id =w.parent_dealer_id and i.mnt =w.mnt
		order by mnt


	set @graph_data =(
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
		from #header_k5 header inner join #result_k5 graph_data on header.parent_dealer_id = graph_data.parent_dealer_id
		order by mnt
		for JSON AUTO )


		select @graph_data
			--update master.dashboard_kpis set graph_data = @graph_data where chart_title ='ROs by Pay Type'

			--------KPI--6


	IF OBJECT_ID('tempdb..#age') IS NOT NULL DROP TABLE #age
	IF OBJECT_ID('tempdb..#result_k6') IS NOT NULL DROP TABLE #result_k6
	IF OBJECT_ID('tempdb..#result1_k6') IS NOT NULL DROP TABLE #result1_k6
	IF OBJECT_ID('tempdb..#cp_hrs') IS NOT NULL DROP TABLE #cp_hrs
	IF OBJECT_ID('tempdb..#wp_hrs') IS NOT NULL DROP TABLE #wp_hrs
	IF OBJECT_ID('tempdb..#ip_hrs') IS NOT NULL DROP TABLE #ip_hrs
	IF OBJECT_ID('tempdb..#cwi_hrs') IS NOT NULL DROP TABLE #cwi_hrs
	IF OBJECT_ID('tempdb..#cp_hrs_ly') IS NOT NULL DROP TABLE #cp_hrs_ly
	IF OBJECT_ID('tempdb..#wp_hrs_ly') IS NOT NULL DROP TABLE #wp_hrs_ly
	IF OBJECT_ID('tempdb..#ip_hrs_ly') IS NOT NULL DROP TABLE #ip_hrs_ly
	IF OBJECT_ID('tempdb..#cwi_hrs_ly') IS NOT NULL DROP TABLE #cwi_hrs_ly
	IF OBJECT_ID('tempdb..#header_k6') IS NOT NULL DROP TABLE #header_k6

	IF OBJECT_ID('tempdb..#cp_hrs_ytd') IS NOT NULL DROP TABLE #cp_hrs_ytd
	IF OBJECT_ID('tempdb..#wp_hrs_ytd') IS NOT NULL DROP TABLE #wp_hrs_ytd
	IF OBJECT_ID('tempdb..#ip_hrs_ytd') IS NOT NULL DROP TABLE #ip_hrs_ytd
	IF OBJECT_ID('tempdb..#graph_data_k6') IS NOT NULL DROP TABLE #graph_data_k6


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

			into #header_k6
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
		into #graph_data_k6
		from #cp_hrs_ytd c inner join #wp_hrs_ytd w on c.parent_dealer_id = w.parent_dealer_id and c.mnt =w.mnt
		inner join #ip_hrs_ytd i on i.parent_dealer_id =c.parent_dealer_id and c.mnt =i.mnt
		order by mnt

	set @graph_data  = (

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

		from #header_k6 header inner join #graph_data_k6 graph_data on header.parent_dealer_id = graph_data.parent_dealer_id
		order by mnt

		for json auto )

		select @graph_data
				--update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Hours Sold'



	---------KPI --7

	IF OBJECT_ID('tempdb..#elr') IS NOT NULL DROP TABLE #elr
		select 
			sum(total_customer_price)/sum(total_billed_labor_hours) as ELR
			,parent_Dealer_id 

	into #elr
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and total_customer_price >0
		group by parent_Dealer_id

		set @graph_data  = (
		select
				 parent_dealer_id
				 ,'Number ($)' as chart_type
				 ,'ELR' as chart_title#
				 ,ELR
			from #elr
		FOR JSON AUTO
		)
		select @graph_data
		--update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Number ($)'



	----KPI--8


	IF OBJECT_ID('tempdb..#gross') IS NOT NULL DROP TABLE #gross
	IF OBJECT_ID('tempdb..#gross_ly') IS NOT NULL DROP TABLE #gross_ly
	IF OBJECT_ID('tempdb..#result1_k8') IS NOT NULL DROP TABLE #result1_k8
	IF OBJECT_ID('tempdb..#result2_k8') IS NOT NULL DROP TABLE #result2_k8
	IF OBJECT_ID('tempdb..#header1_k8') IS NOT NULL DROP TABLE #header1_k8
	IF OBJECT_ID('tempdb..#header_k8') IS NOT NULL DROP TABLE #header_k8

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
		into #result1_k8
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
		into #result2_k8
	from #gross_ly
	group by parent_dealer_id

	select 
		c.parent_dealer_id as accountId
		,'Number' as chart_type
		,'Average Gross per RO' as chart_title
		,convert(decimal(18,1),convert(decimal(18,1),(total_gross_ytd - total_gross_ytd_ly)*100)/total_gross_ytd_ly) as total_gross_ly_perc_change
		,convert(decimal(18,1),convert(decimal(18,1),(avg_gross_ytd - avg_gross_ytd_ly)*100)/avg_gross_ytd_ly) as avg_gross_ly_perc_change
		,total_gross_ytd
		into #header1_k8
	from #result1_k8 c inner join #result2_k8 l on c.parent_dealer_id =l.parent_dealer_id


	select 
		accountId
		,chart_type
		,chart_title
		,datename(year,getdate())+' Total Gross = ' + convert(varchar(100),total_gross_ytd)+', LY Change % = '+convert(varchar(100),total_gross_ly_perc_change)+'%' as chart_subtitle_1
		,datename(year,getdate())+' YTD Total Gross = ' + convert(varchar(100),total_gross_ytd) as chart_subtitle_2
		into #header_k8
	from #header1_k8

	set @graph_data  = (
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

	from #header_k8 header inner join #result1_k8 number_data on header.accountId =number_data.parent_dealer_id
	for json auto  )

	select @graph_data

		--update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Average Gross per RO'



		-------KPI--9

		IF OBJECT_ID('tempdb..#hrs_ro') IS NOT NULL DROP TABLE #hrs_ro

		select 	

				parent_Dealer_id 
				,sum(total_billed_labor_hours)/count(ro_number) as hrs_per_ro
		into #hrs_ro	
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		group by parent_Dealer_id


		set @graph_data  = (
		select 
				parent_dealer_id
				,'Number' as chart_type
				,'Hours per RO' as chart_title
				,convert(decimal(18,1),hrs_per_ro) as hrs_per_ro
		from #hrs_ro
		FOR JSON AUTO )

		select @graph_data
		--update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Hours per RO'


		--------KPI---10

		IF OBJECT_ID('tempdb..#prts_lbr') IS NOT NULL DROP TABLE #prts_lbr

		select 	

				parent_Dealer_id 
				,sum(total_parts_price)/100000 as parts_price
				,sum(total_labor_price)/100000 as labor_price	
		into #prts_lbr	
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		group by parent_Dealer_id

	----Finding HCF for parts price and labour price to get ratio
	DECLARE @num1 int = (select convert(int,parts_price) from #prts_lbr)
	DECLARE @num2 int = (select convert(int,labor_price) from #prts_lbr)
	DECLARE @count INT = 1, @hcf int 

	WHILE (@count < @num1 or @count < @num2)
	BEGIN
		IF (@num1 % @count = 0 and @num2 % @count = 0)
		BEGIN
			set @hcf = @count
		END
		set @count = @count + 1
	END
	----divide parts price and labour price by HCF, calculated above to get the least ratio

		set @graph_data  = (
		select 
				parent_dealer_id as accountId
				,'Number' as chart_type
				,'Parts to Labour Ratio' as chart_title
				,convert(varchar(50),convert(int,parts_price)/@hcf) +':' +convert(varchar(50),convert(int,labor_price)/@hcf) as prt_lbr_ratio
		from #prts_lbr
		FOR JSON AUTO )

		select @graph_data
		--update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Parts to Labour Ratio'


	--------KPI--11


	IF OBJECT_ID('tempdb..#age') IS NOT NULL DROP TABLE #age
	IF OBJECT_ID('tempdb..#result_k11') IS NOT NULL DROP TABLE #result_k11
	IF OBJECT_ID('tempdb..#result1_k11') IS NOT NULL DROP TABLE #result1_k11

		select 	

				h.parent_Dealer_id 
				,datediff(year,convert(date,convert(char(8),iif(len(model_year)=0,0,model_year))),getdate())  as age
				,model_year
				,v.master_vehicle_id
		into #age
		from master.repair_order_header h (nolock) 
		inner join master.vehicle v (nolock) on h.master_vehicle_id = v.master_vehicle_id
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		--group by parent_Dealer_id

		--select * from #age order by age
	
		select 
		parent_dealer_id
		,(case when age <=1 then 1
			when age>1 and age <=2 then 2
			when age>2 and age<=3 then 3
			when age>3 and age<=4 then 4
			when age>4 and age <=5 then 5
			when age>5 and age <=10 then 6
			else 7 end) as age_seg
		into #result_k11
		from #age

		declare @1yr int = (select count(*) from #result_k11 where age_seg =1)
		declare @2yr int = (select count(*) from #result_k11 where age_seg =2)
		declare @3yr int = (select count(*) from #result_k11 where age_seg =3)
		declare @4yr int = (select count(*) from #result_k11 where age_seg =4)
		declare @5yr int = (select count(*) from #result_k11 where age_seg =5)
		declare @6yr int = (select count(*) from #result_k11 where age_seg =6)

		select distinct(parent_dealer_id), @1yr as seg_1,@2yr as seg_2,@3yr as seg_3,@4yr as seg_4,@5yr as seg_5,@6yr as seg_6
				,@1yr+@2yr+@3yr+@4yr+@5yr+@6yr as total
			into #result1_k11
		from #result_k11
		--select * from #result1_k11


		set @graph_data = (
		select 
				parent_dealer_id
				,'Pie' as chart_type
				,'Vehicle Age' as chart_title
				,convert(decimal(18,1),convert(decimal(18,1),seg_1*100)/total) as  perc_1yr_old
				,convert(decimal(18,1),convert(decimal(18,1),seg_2*100)/total) as  perc_2yr_old
				,convert(decimal(18,1),convert(decimal(18,1),seg_3*100)/total) as  perc_3yr_old
				,convert(decimal(18,1),convert(decimal(18,1),seg_4*100)/total) as  perc_4yr_old
				,convert(decimal(18,1),convert(decimal(18,1),seg_5*100)/total) as  perc_5yr_10yr_old
				,convert(decimal(18,1),convert(decimal(18,1),seg_6*100)/total) as  perc_more_10yr_old


	
		from #result1_k11
		for json path )
	
		select @graph_data
		--update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Vehicle Age'


	------KPI---12

	IF OBJECT_ID('tempdb..#age_k12') IS NOT NULL DROP TABLE #age_k12
	IF OBJECT_ID('tempdb..#result_k12') IS NOT NULL DROP TABLE #result_k12
	IF OBJECT_ID('tempdb..#result1_k12') IS NOT NULL DROP TABLE #result1_k12
	IF OBJECT_ID('tempdb..#age1') IS NOT NULL DROP TABLE #age1
	IF OBJECT_ID('tempdb..#age2') IS NOT NULL DROP TABLE #age2
	IF OBJECT_ID('tempdb..#age3') IS NOT NULL DROP TABLE #age3
	IF OBJECT_ID('tempdb..#age4') IS NOT NULL DROP TABLE #age4
	IF OBJECT_ID('tempdb..#age5') IS NOT NULL DROP TABLE #age5
	IF OBJECT_ID('tempdb..#age6') IS NOT NULL DROP TABLE #age6
	IF OBJECT_ID('tempdb..#age7') IS NOT NULL DROP TABLE #age7
	IF OBJECT_ID('tempdb..#graph_data_k12') IS NOT NULL DROP TABLE #graph_data_k12
	IF OBJECT_ID('tempdb..#header_k12') IS NOT NULL DROP TABLE #header_k12

		select 	

				 h.parent_Dealer_id 
				,datediff(year,convert(date,convert(char(8),iif(len(model_year)=0,0,model_year))),getdate())  as age
				,ro_close_date

		into #age_k12
		from master.repair_order_header h (nolock) 
		inner join master.vehicle v (nolock) on h.master_vehicle_id = v.master_vehicle_id
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		--group by parent_Dealer_id


		select 
			parent_dealer_id
			,	(case when age <=1 then 1
			when age>1 and age <=2 then 2
			when age>2 and age<=3 then 3
			when age>3 and age<=4 then 4
			when age>4 and age <=5 then 5
			when age>5 and age <=10 then 6
			else 7 end) as age_seg
			,ro_close_date
		into #result1_k12
		from #age_k12

		select 
			parent_dealer_id
			,count(*) as age_1
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #age1
		from #result1_k12 where age_seg =1
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
		order by mnt

		select 
			parent_dealer_id
			,count(*) as age_2
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #age2
		from #result1_k12 where age_seg =2
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
		order by mnt

		select 
			parent_dealer_id
			,count(*) as age_3
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #age3
		from #result1_k12 where age_seg =3
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
		order by mnt

		select 
			parent_dealer_id
			,count(*) as age_4
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #age4
		from #result1_k12 where age_seg =4
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
		order by mnt

		select 
			parent_dealer_id
			,count(*) as age_5
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #age5
		from #result1_k12 where age_seg =5
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
		order by mnt
		
		
		select 
			parent_dealer_id
			,count(*) as age_6
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #age6
		from #result1_k12 where age_seg =6
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
		order by mnt
		
		select 
			parent_dealer_id
			,count(*) as age_7
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #age7
		from #result1_k12 where age_seg =7
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
		order by mnt

		select 
				a1.parent_dealer_id
				,a1.mnt
				,a1.mnt_name
				,convert(decimal(18,1),convert(decimal(18,1),a1.age_1*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_1
				,convert(decimal(18,1),convert(decimal(18,1),a2.age_2*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_2
				,convert(decimal(18,1),convert(decimal(18,1),a3.age_3*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_3
				,convert(decimal(18,1),convert(decimal(18,1),a4.age_4*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_4
				,convert(decimal(18,1),convert(decimal(18,1),a5.age_5*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_5
				,convert(decimal(18,1),convert(decimal(18,1),a6.age_6*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_6
				,convert(decimal(18,1),convert(decimal(18,1),a7.age_7*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_7
				,convert(decimal(18,1),a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7) as total
		into #graph_data_k12
		from #age1 a1 
		inner join #age2 a2 on a1.parent_dealer_id = a2.parent_dealer_id and a1.mnt = a2.mnt
		inner join #age3 a3 on a1.parent_dealer_id = a3.parent_dealer_id and a1.mnt = a3.mnt
		inner join #age4 a4 on a1.parent_dealer_id = a4.parent_dealer_id and a1.mnt = a4.mnt
		inner join #age5 a5 on a1.parent_dealer_id = a5.parent_dealer_id and a1.mnt = a5.mnt
		inner join #age6 a6 on a1.parent_dealer_id = a6.parent_dealer_id and a1.mnt = a6.mnt
		inner join #age7 a7 on a1.parent_dealer_id = a7.parent_dealer_id and a1.mnt = a7.mnt
		order by mnt

		select 
			parent_dealer_id
			,'Line Trend' as chart_type
			,'Vehicle Age Trend' as chart_title
			into #header_k12
		from #result1_k12

		set @graph_data = (
		select 
			header.parent_Dealer_id as accountId
			,header.chart_type
			,header.chart_title
			,graph_data.mnt
			,graph_data.mnt_name
			,graph_data.perc_seg_1
			,graph_data.perc_seg_2
			,graph_data.perc_seg_3
			,graph_data.perc_seg_4
			,graph_data.perc_seg_5
			,graph_data.perc_seg_6
			,graph_data.perc_seg_7
		

		from #header_k12 header inner join #graph_data_k12 graph_data on header.parent_Dealer_id =graph_data.parent_dealer_id
		order by mnt
		for json auto )


		select @graph_data
	--update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Vehicle Age Trend'


end
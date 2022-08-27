use clictell_auto_master
GO


---- Inserting Rows for Sales KPIs in master.dashboard_kpis table

insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, chart_subtitle1, chart_subtitle2, graph_data)
		values (
				'1806'
			,'Sales - Gross Profit'
			,'Gross Profit and pace'
			,'New/Used Car Retail Gross Profit'
			,null
			,null
			,null
		)

		insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, chart_subtitle1, chart_subtitle2, graph_data)
		values (
				'1806'
			,'Sales - Car units'
			,'Cars Retailed vs Pace'
			,null 
			,null 
			,null 
			,null 
		)


		insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, chart_subtitle1, chart_subtitle2, graph_data)
		values (
				'1806'
			,'Sales - PNVR'
			,'Total Gross Profit PNVR Including F&I ($)'
			,'New/Used Cars PNVR'
			,null
			,null
			,null
		)

		insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, chart_subtitle1, chart_subtitle2, graph_data)
		values (
				'1806'
			,'Sales - Total F&I Income PNVR'
			,'Total Finance Income PNVR'
			,'Total F&I Income PNVR'
			,null
			,null
			,null
		)

		insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, chart_subtitle1, chart_subtitle2, graph_data)
		values (
				'1806'
			,'Sales - Inventory'
			,'Inventory Units and Dollar Value'
			,'Inventory Units'
			,null
			,null
			,null
		)

		insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, chart_subtitle1, chart_subtitle2, graph_data)
		values (
				'1806'
			,'Sales - Inventory unit Aging'
			,'Inventory Unit Aging'
			,'Inventory Unit Aging'
			,null
			,null
			,null
		)


		 insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, chart_subtitle1, chart_subtitle2, graph_data)
		values (
				'1806'
			,'Sales - Vehicle Days Supply'
			,'Vehicle Days Supply (Units and $)'
			,'Inventory Days Supply'
			,null
			,null
			,null
		)

		insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, chart_subtitle1, chart_subtitle2, graph_data)
		values (
				'1806'
			,'Sales - Finance Penetration'
			,'Finance Penetration'
			,'Finance Penetration'
			,null
			,null
			,null
		)
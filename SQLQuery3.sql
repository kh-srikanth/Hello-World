USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[Retail_Sales_Transactions]    Script Date: 3/11/2021 2:02:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec [reports].[OpCodeAnalysis_LY_per] '2013-01-01','2021-01-01','All','3PADEV1'
*/

alter procedure  [reports].[OpCodeAnalysis_LY_per]
--declare
@FromDate date = '2013-01-01',
@ToDate date = '2021-01-01',
@opcode varchar(10) = 'All',
@dealer_id varchar(10) = '3PADEV1'


as
begin
	
	
	IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
	IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2

	select 
	rd.op_code
	,rd.natural_key
	,count(*) as units_sold
	,sum(rh.total_labor_price-rh.total_labor_cost) as labor_gross_profit
	,sum(rh.total_repair_order_price) as gross_totalRO
	,sum(rd.billed_labor_hours) as sum_billed_hrs_unit
	,sum(rh.total_billed_labor_hours) as sum_billed_lbr_hrs

	into #temp1
	from master.repair_order_header_detail rd
	left outer join master.repair_order_header rh on rd.ro_number = rh.ro_number
	left outer join master.ro_parts_details p on rd.ro_number = p.ro_number and p.master_ro_detail_id = rd.master_ro_detail_id

	where 
	convert(date,convert(char(8),rh.ro_close_date)) between @FromDate and @ToDate
	and (@opcode = 'All' or (@opcode !='All' and @opcode = rd.op_code))
	and @dealer_id = rd.natural_key

	group by op_code,rd.natural_key
	order by op_code
	/*calculation till last year amounts*/
	select 
	rd.op_code
	,rd.natural_key
	,count(*) as units_sold_ly
	,sum(rh.total_labor_price-rh.total_labor_cost) as labor_gross_profit
	,sum(rh.total_repair_order_price) as gross_totalRO
	,sum(rd.billed_labor_hours) as sum_billed_hrs_unit
	,sum(rh.total_billed_labor_hours) as sum_billed_lbr_hrs

	into #temp2
	from master.repair_order_header_detail rd
	left outer join master.repair_order_header rh on rd.ro_number = rh.ro_number
	left outer join master.ro_parts_details p on rd.ro_number = p.ro_number and p.master_ro_detail_id = rd.master_ro_detail_id

	where 
	convert(date,convert(char(8),rh.ro_close_date)) between @FromDate and dateadd(year,-1,@ToDate)
	and (@opcode = 'All' or (@opcode !='All' and @opcode = op_code))
	and @dealer_id = rd.natural_key

	group by rd.op_code,rd.natural_key
	order by op_code

	/*#temp1 data till @todate
	#temp2 data is till @todate -1 yr
	Calculatuion for LY% change
	*/
	select 
	t1.op_code as op_code
	,t1.units_sold
	,iif(t2.units_sold_ly = 0, null, (t1.units_sold -t2.units_sold_ly)/t2.units_sold_ly) as ly_perc_units_sold
	,t1.labor_gross_profit as labor_gross_profit
	,iif(t2.labor_gross_profit = 0,null,(t1.labor_gross_profit-t2.labor_gross_profit)/(t2.labor_gross_profit)) as ly_perc_labor_profit
	,t1.labor_gross_profit/t1.units_sold as gross_per_unit_labor
	,t1.gross_totalRO as gross_per_totalRO
	,t1.sum_billed_lbr_hrs as hours_sold
	,iif(t2.sum_billed_lbr_hrs =0, null,(t1.sum_billed_lbr_hrs - t2.sum_billed_lbr_hrs)/(t2.sum_billed_lbr_hrs)) as ly_perc_hours_sold
	,t1.sum_billed_hrs_unit as hours_sold_per_unit

	from #temp1 t1
	left outer join #temp2 t2 on t1.op_code = t2.op_code and t1.natural_key = t2.natural_key

end
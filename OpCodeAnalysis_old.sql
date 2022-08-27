USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[OpCodeAnalysis_LY_per]    Script Date: 7/2/2021 3:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec [reports].[OpCodeAnalysis_LY_per] '2021-06-01','2021-06-30','All','1806'
*/

ALTER procedure  [reports].[OpCodeAnalysis_LY_per]
--declare
@FromDate date = '2013-01-01',
@ToDate date = '2021-01-01',
@opcode varchar(10) = 'All',
@dealer_id varchar(10) = '524'


as
begin
		
	IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
	IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2
	IF OBJECT_ID('tempdb..#temp11') IS NOT NULL DROP TABLE #temp11
	IF OBJECT_ID('tempdb..#temp22') IS NOT NULL DROP TABLE #temp22
	IF OBJECT_ID('tempdb..#tempA') IS NOT NULL DROP TABLE #tempA
	IF OBJECT_ID('tempdb..#tempB') IS NOT NULL DROP TABLE #tempB

	select 
	rd.op_code
	,rd.natural_key
	,count(*) as units_sold
	,sum(rd.total_labor_price-isnull(rd.total_labor_cost,0)) as labor_gross_profit
	,sum(rd.billed_labor_hours) as billed_lbr_hrs
	,sum(rh.total_repair_order_price) - isnull(sum(rh.total_repair_order_cost),0) as gross_totalRO

	into #temp1
	from master.repair_order_header_detail rd
	left outer join master.repair_order_header rh on rd.ro_number = rh.ro_number and rh.master_ro_header_id = rd.master_ro_header_id
	where 
	convert(date,convert(char(8),rh.ro_close_date)) between @FromDate and @ToDate
	and (@opcode = 'All' or (@opcode !='All' and @opcode = rd.op_code))
	--and rd.op_code is not null and rd.op_code != ''
	and @dealer_id = rd.parent_Dealer_id

	group by op_code,rd.natural_key	order by op_code desc



	select 
	sum(units_sold) as total_units_sold
	,sum(labor_gross_profit) as total_labor_gross
	,sum(billed_lbr_hrs) as total_hrs
	into #tempA
	from #temp1

	select * into #temp11 from #temp1 left outer join #tempA on 1=1
		
	--	return;



	/*calculation till last year amounts*/
	select 
			rd.op_code
			,rd.natural_key
			,count(*) as units_sold_ly
			,sum(rd.total_labor_price-isnull(rd.total_labor_cost,0)) as labor_gross_profit_ly
			,sum(rd.billed_labor_hours) as billed_lbr_hrs_ly
			,sum(rh.total_repair_order_price) - isnull(sum(rh.total_repair_order_cost),0) as gross_totalRO
			--,sum(rh.total_billed_labor_hours) as sum_billed_lbr_hrs
	into #temp2
	from master.repair_order_header_detail rd
		left outer join master.repair_order_header rh on rd.ro_number = rh.ro_number and rh.master_ro_header_id = rd.master_ro_header_id
	where 
			convert(date,convert(char(8),rh.ro_close_date)) between dateadd(year,-1,@FromDate) and dateadd(year,-1,@ToDate)
			and (@opcode = 'All' or (@opcode !='All' and @opcode = op_code))
			--and rd.op_code is not null and rd.op_code != ''
			and @dealer_id = rd.parent_Dealer_id
	group by rd.op_code,rd.natural_key 	order by op_code desc

	select 
			sum(units_sold_ly) as total_units_sold_ly
			,sum(labor_gross_profit_ly) as total_labor_gross_ly
			,sum(billed_lbr_hrs_ly) as total_hrs_ly
	into #tempB
	from #temp2

	select *  into #temp22 from #temp2 left outer join #tempB on 1=1


	/*#temp1 data till @todate
	#temp2 data is till @todate -1 yr
	Calculatuion for LY% change
	*/
	select distinct
			d.dealer_name as store
			,t1.op_code as op_code
			,t1.units_sold
			,iif(t2.units_sold_ly = 0, null, (convert(decimal(8,2),t1.units_sold -t2.units_sold_ly))/convert(decimal(8,2),t2.units_sold_ly)) as ly_perc_units_sold
			,t1.labor_gross_profit as labor_gross_profit
			,iif(t2.labor_gross_profit_ly = 0,null,(t1.labor_gross_profit-t2.labor_gross_profit_ly)/(t2.labor_gross_profit_ly)) as ly_perc_labor_profit
			,t1.labor_gross_profit/t1.units_sold as gross_per_unit_labor
			,t1.gross_totalRO as gross_per_totalRO
			,t1.billed_lbr_hrs as hours_sold
			,iif(t2.billed_lbr_hrs_ly =0, null,(t1.billed_lbr_hrs - t2.billed_lbr_hrs_ly)/(t2.billed_lbr_hrs_ly)) as ly_perc_hours_sold
			,t1.billed_lbr_hrs/t1.units_sold as hours_sold_per_unit
			,convert(decimal(10,2),(t1.total_units_sold - isnull(t2.total_units_sold_ly,0)))/iif(t1.total_units_sold=0,null,t1.total_units_sold) as ly_perc_change_total_units_sold
			,(t1.total_labor_gross - isnull(t2.total_labor_gross_ly,0))/iif(t1.total_labor_gross=0,null,t1.total_labor_gross) as ly_perc_change_total_lbr_gross
			,(t1.total_hrs - isnull(t2.total_hrs_ly,0))/iif(t1.total_hrs=0,null,t1.total_hrs) as ly_perc_change_lbr_hrs

	from #temp11 t1 
		inner join master.dealer d (nolock) on t1.natural_key = d.natural_key
		left outer join #temp22 t2 on t1.op_code = t2.op_code and t1.natural_key = t2.natural_key

		order by t1.op_code desc
	
end


use clictell_auto_master
go

IF OBJECT_ID('tempdb..#fin_units') IS NOT NULL DROP TABLE #fin_units
IF OBJECT_ID('tempdb..#total_units') IS NOT NULL DROP TABLE #total_units

select
		parent_dealer_id
		,ltrim(rtrim(nuo_flag)) as nuo_flag
		,count(vin) as units_sold_finance

	into #fin_units
from master.fi_sales (nolock)
	where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
			and parent_dealer_id =1806 
			and deal_status in ('Finalized','Sold') 
			and total_finance_amount is not null
	group by parent_dealer_id, nuo_flag




select
		parent_dealer_id
		,ltrim(rtrim(nuo_flag)) as nuo_flag
		,count(vin) as units_sold_total

	into #total_units
from master.fi_sales (nolock)
	where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
			and parent_dealer_id =1806 
			and deal_status in ('Finalized','Sold') 
	group by parent_dealer_id, nuo_flag


	select 
		f.parent_dealer_id
		,f.nuo_flag
		,'Table' as chart_type
		,convert(varchar(100),ltrim(rtrim(f.nuo_flag)))+' Finance Penetration' as chart_title
		,convert(varchar(100),ltrim(rtrim(f.nuo_flag)))+' Finance Penetration = '
				+convert(varchar(100),convert(decimal(18,1),(convert(decimal(18,2),units_sold_finance)/units_sold_total)*100))+'%' as chart_subtitle_1
		,convert(varchar(100),convert(decimal(18,1),(convert(decimal(18,2),units_sold_finance)/units_sold_total)*100))+'%' as "graph_data.finance_penetration"

	from #fin_units f inner join #total_units t on t.parent_dealer_id=f.parent_dealer_id and t.nuo_flag=f.nuo_flag
	--where f.nuo_flag = 'New'
	for json path
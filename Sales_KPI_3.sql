use clictell_auto_master
go

select 

	parent_dealer_id
	,'Number' as chart_type
	,ltrim(rtrim(nuo_flag)) + ' Car PNVR' as chart_title
	,ltrim(rtrim(nuo_flag)) as nuo_flag
	--,count(vin) as "graph_data.units_sold"
	--,sum(frontend_gross_profit+isnull(backend_gross_profit,0)) as "graph_data.total_gross"
	,convert(decimal(18,1),sum(frontend_gross_profit+isnull(backend_gross_profit,0))/count(vin))  as "graph_data.pnvr"

from master.fi_sales (nolock)
where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
and parent_dealer_id =1806 and deal_status in ('Finalized','Sold')

group by parent_dealer_id, nuo_flag

for json path


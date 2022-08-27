use clictell_auto_master
go

select 

parent_dealer_id
,ltrim(rtrim(nuo_flag)) as nuo_flag
,'Number' as chart_type
,'Total F&I Income PNVR' as chart_title
,'Total F&I Income PNVR = $' + convert(varchar(100),convert(decimal(18,1),sum(isnull(total_fin_res,0) + isnull(frontend_gross_profit,0)+isnull(backend_gross_profit,0))/count(vin))) as chart_subtitle_1
,'Total F&I = $' + convert(varchar(100),sum(isnull(total_fin_res,0) + isnull(frontend_gross_profit,0)+isnull(backend_gross_profit,0))) as chart_subtitle_2

--,afm_finance_price
--,finance_charge
--,total_finance_amount
,count(vin) as units_retailed
,sum(isnull(total_fin_res,0) + isnull(frontend_gross_profit,0)+isnull(backend_gross_profit,0)) as  fin_prod_gross
,convert(decimal(18,1),sum(isnull(total_fin_res,0) + isnull(frontend_gross_profit,0)+isnull(backend_gross_profit,0))/count(vin)) as "graph_data.PNVR"

from master.fi_sales (nolock)
where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
and parent_dealer_id =1806 and deal_status in ('Finalized','Sold') and total_finance_amount is not null

group by parent_dealer_id,nuo_flag

for json path	
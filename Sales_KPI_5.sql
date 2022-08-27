use clictell_auto_master
go


select 
		parent_dealer_id
		,ltrim(rtrim(nuo_flag)) as nuo_flag
		,'Numbers' as chart_type
		,'New Inventory Units' as chart_title
		,count(vin) as "graph_data.inventory_units"
		,sum(vehicle_price) as "graph_data.inventory_value"

from master.fi_sales s (nolock) 
where inventory_date is not null
		and convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and parent_dealer_id =1806
group by parent_dealer_id,nuo_flag

for json path


--inner join master.vehicle h (nolock) on h.vin=i.vin
--where vehicle_status not in ('Sold','INACTIVE','NOT_AVAILABLE','ASSIGNED_BY_MANUFACTURER')
--order by i.vin
--group by parent_dealer_id

--select * from master.inventory (nolock) where vin = '1HGCV2F37KA002127'
--select * from master.fi_sales (nolock) where inventory_date is  null and parent_dealer_id =1806 and deal_status='Sold'
--select distinct deal_status from master.fi_sales (nolock) where inventory_date is  null and parent_dealer_id =1806 
--where vin ='5FNYF6H26MB094483'

--vin = '19UDE2F87GA011529'

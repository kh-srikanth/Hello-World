use clictell_auto_master
go
IF OBJECT_ID('tempdb..#header') IS NOT NULL DROP TABLE #header
IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result
IF OBJECT_ID('tempdb..#graph_data') IS NOT NULL DROP TABLE #graph_data
IF OBJECT_ID('tempdb..#avg_sale') IS NOT NULL DROP TABLE #avg_sale
IF OBJECT_ID('tempdb..#avg1') IS NOT NULL DROP TABLE #avg1
IF OBJECT_ID('tempdb..#avg2') IS NOT NULL DROP TABLE #avg2
IF OBJECT_ID('tempdb..#avg3') IS NOT NULL DROP TABLE #avg3

IF OBJECT_ID('tempdb..#days_supply') IS NOT NULL DROP TABLE #days_supply

--select
--		 parent_dealer_id
--		,ltrim(rtrim(nuo_flag)) as nuo_flag
--		,avg(vehicle_price) as avg_sale
--	into #avg_sale
--from master.fi_sales s (nolock) 
--where deal_status in ('Sold','Finalized')
--		and convert(date,convert(char(8),purchase_date)) 
--				between DATEFROMPARTS(YEAR(GETDATE()), MONTH(dateadd(month,-3,getdate())), 1) 
--					and DATEFROMPARTS(YEAR(GETDATE()), MONTH(dateadd(month,-1,getdate())), day(EOMONTH(dateadd(month,-1,getdate()))))
--		and parent_dealer_id =1806
--group by parent_dealer_id,nuo_flag

--select DATEFROMPARTS(YEAR(GETDATE()), MONTH(dateadd(month,-3,getdate())), 1)
--select DATEFROMPARTS(YEAR(GETDATE()), MONTH(dateadd(month,-1,getdate())), day(EOMONTH(dateadd(month,-1,getdate()))))
select					---last month sales average
	parent_dealer_id
	,ltrim(rtrim(nuo_flag)) as nuo_flag
	--,sum(isnull(vehicle_price,0))/day(EOMONTH(dateadd(month,-1,getdate()))) as avg_sale_1
	,count(vin)/day(EOMONTH(dateadd(month,-1,getdate()))) as avg_sale_1
	into #avg1
from master.fi_sales s (nolock) 
where deal_status in ('Sold','Finalized')
		and convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), MONTH(dateadd(month,-1,getdate())), 1) and DATEFROMPARTS(YEAR(GETDATE()), MONTH(dateadd(month,-1,getdate())), day(EOMONTH(dateadd(month,-1,getdate()))))
		and parent_dealer_id =1806
group by parent_dealer_id,nuo_flag

select				---this month -2 month average
	parent_dealer_id
	,ltrim(rtrim(nuo_flag)) as nuo_flag
	--,sum(isnull(vehicle_price,0))/day(EOMONTH(dateadd(month,-2,getdate()))) as avg_sale_2
	,count(vin)/day(EOMONTH(dateadd(month,-2,getdate()))) as avg_sale_2
	into #avg2
from master.fi_sales s (nolock) 
where deal_status in ('Sold','Finalized')
		and convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), MONTH(dateadd(month,-2,getdate())), 1) and DATEFROMPARTS(YEAR(GETDATE()), MONTH(dateadd(month,-2,getdate())), day(EOMONTH(dateadd(month,-2,getdate()))))
		and parent_dealer_id =1806
group by parent_dealer_id,nuo_flag


select					-----current month average
	parent_dealer_id
	,ltrim(rtrim(nuo_flag)) as nuo_flag
	--,sum(isnull(vehicle_price,0))/day(getdate()) as avg_sale_3
	,count(vin)/day(getdate()) as avg_sale_3
	into #avg3

from master.fi_sales s (nolock) 
where deal_status in ('Sold','Finalized')
		and convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), MONTH(getdate()), 1) and DATEFROMPARTS(YEAR(GETDATE()), MONTH(getdate()), day(getdate()))
		and parent_dealer_id =1806
group by parent_dealer_id,nuo_flag


select			--- Average of three months sales
a1.parent_dealer_id
,a1.nuo_flag
,(isnull(a1.avg_sale_1,0)+isnull(a2.avg_sale_2,0)+isnull(a3.avg_sale_3,0))/3 as avg_sale
into #avg_sale
from #avg1 a1 inner join #avg2 a2 on a1.parent_dealer_id =a2.parent_dealer_id and a1.nuo_flag=a2.nuo_flag
inner join #avg3 a3 on a3.parent_dealer_id =a1.parent_dealer_id and a3.nuo_flag=a1.nuo_flag



select 
		 parent_dealer_id
		,(case when odometer > 1000 then 'Used' else 'New' end) as nuo_flag
		,count(vin) as current_inventory_units

		into #graph_data

from master.inventory (nolock) where vehicle_status in ('AVAILABLE')
 group by parent_dealer_id,(case when odometer > 1000 then 'Used' else 'New' end)


 select 
		  a.parent_dealer_id
		 ,a.nuo_flag
		 ,convert(decimal(18,2),(convert(decimal(18,2),a.current_inventory_units)/b.avg_sale)*30) as days_supply
	into #days_supply
 from #graph_data a inner join #avg_sale b on a.parent_dealer_id =b.parent_dealer_id and a.nuo_flag =b.nuo_flag


 select
		  parent_dealer_id
		 ,nuo_flag
		 ,'Number' as chart_type
		 ,nuo_flag+' Inventory Days Supply' as chart_title
		 ,days_supply as "graph_data.days_supply"

 from #days_supply

 for json path
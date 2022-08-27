use clictell_auto_master
go

IF OBJECT_ID('tempdb..#gross') IS NOT NULL DROP TABLE #gross
IF OBJECT_ID('tempdb..#gross_total') IS NOT NULL DROP TABLE #gross_total

IF OBJECT_ID('tempdb..#gross_ly') IS NOT NULL DROP TABLE #gross_ly
IF OBJECT_ID('tempdb..#gross_mtd') IS NOT NULL DROP TABLE #gross_mtd
IF OBJECT_ID('tempdb..#header') IS NOT NULL DROP TABLE #header


select
	parent_dealer_id
 
	,frontend_gross_profit
	,backend_gross_profit
	,frontend_gross_profit + backend_gross_profit as total_gross_profit
	,ltrim(rtrim(nuo_flag)) as nuo_flag
	,convert(decimal(18,2),(frontend_gross_profit /datediff(day,DATEFROMPARTS(YEAR(GETDATE()), 1, 1),GETDATE()))/365) as pace_fgross_ytd
	,convert(decimal(18,2),(isnull(backend_gross_profit,0)/datediff(day,DATEFROMPARTS(YEAR(GETDATE()), 1, 1),GETDATE()))/365) as pace_bgross_ytd
	,convert(decimal(18,2),((frontend_gross_profit + isnull(backend_gross_profit,0))/datediff(day,DATEFROMPARTS(YEAR(GETDATE()), 1, 1),GETDATE()))/365) as pace_gross_ytd
	--,month(convert(date,convert(char(8),purchase_date))) as mnt
	--,datename(month,convert(date,convert(char(8),purchase_date))) as mnt_name
	into #gross
from master.fi_sales (nolock)
where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
and parent_dealer_id =1806 and deal_status in ('Finalized','Sold')



select
	parent_dealer_id
	,sum(frontend_gross_profit) as front_gross
	,sum(backend_gross_profit) as back_gross	
	,sum(total_gross_profit) as total_gross
	,sum(pace_gross_ytd) as pace_gross
	,sum(pace_fgross_ytd) as pace_fgross
	,sum(pace_bgross_ytd) as pace_bgross
	,nuo_flag

	into #gross_total
from #gross
group by parent_dealer_id,nuo_flag

 ---LY calculations

 select
		parent_dealer_id
		,sum(frontend_gross_profit + backend_gross_profit) as total_gross_ly
		,ltrim(rtrim(nuo_flag)) as nuo_flag
	into #gross_ly
from master.fi_sales (nolock)
where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
and parent_dealer_id =1806 and deal_status in ('Finalized','Sold')
group by parent_dealer_id, nuo_flag


--select distinct deal_status from  master.fi_sales (nolock)
---MTD Caluclations

 select
		parent_dealer_id
		,sum(frontend_gross_profit + backend_gross_profit) as total_gross_mtd
		,ltrim(rtrim(nuo_flag)) as nuo_flag

	into #gross_mtd
from master.fi_sales (nolock)
where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), month(getdate()), 1) and getdate()
and parent_dealer_id =1806 and deal_status in ('Finalized','Sold')
group by parent_dealer_id, nuo_flag


select
	t.parent_dealer_id
	,t.nuo_flag
	,'Vertical Bar' as chart_type
	,'New Car Retail Gross Profit' as chart_title
	,convert(varchar(100),YEAR(GETDATE())) + ' Total Gross = $'+convert(varchar(100),convert(decimal(18,1),t.total_gross)) +'and LY Change % = '+isnull(convert(varchar(100),((t.total_gross-l.total_gross_ly)*100)/l.total_gross_ly),100)+'%' as chart_subtitle_1
	,convert(varchar(100),datename(month,getdate()))+' Gross Profit = $'+convert(varchar(100),m.total_gross_mtd) as chart_subtitle_2
	into #header
from  #gross_total t 
left outer join #gross_ly l on t.parent_dealer_id =l.parent_dealer_id and t.nuo_flag =l.nuo_flag
inner join #gross_mtd m on m.parent_dealer_id =t.parent_dealer_id and m.nuo_flag =t.nuo_flag

--select * from #gross_total
--select * from #gross_ly
select * from #header

select 
  header.parent_dealer_id
 ,header.nuo_flag
 ,header.chart_type
 ,header.chart_title
 ,header.chart_subtitle_1
 ,header.chart_subtitle_2
 ,graph_data.front_gross
 ,graph_data.pace_fgross
 ,graph_data.back_gross
 ,graph_data.pace_bgross
 ,graph_data.total_gross
 ,graph_data.pace_gross

from #header header left outer join #gross_total graph_data on header.parent_dealer_id = graph_data.parent_dealer_id and header.nuo_flag =graph_data.nuo_flag

for json auto
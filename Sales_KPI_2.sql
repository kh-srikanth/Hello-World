use clictell_auto_master
go

IF OBJECT_ID('tempdb..#units_ytd') IS NOT NULL DROP TABLE #units_ytd
IF OBJECT_ID('tempdb..#units_ly') IS NOT NULL DROP TABLE #units_ly 
IF OBJECT_ID('tempdb..#units_mtd') IS NOT NULL DROP TABLE #units_mtd
IF OBJECT_ID('tempdb..#header') IS NOT NULL DROP TABLE #header
IF OBJECT_ID('tempdb..#graph_data') IS NOT NULL DROP TABLE #graph_data





select 
	parent_dealer_id
	,ltrim(rtrim(nuo_flag)) as nuo_flag
	,count(vin) as units_sold_ytd
	,convert(decimal(18,1),(convert(decimal(18,2),count(vin))/DATEDIFF(day,DATEFROMPARTS(YEAR(GETDATE()), 1, 1),GETDATE()))*365) as pace_ytd
into #units_ytd
from master.fi_sales (nolock)
where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
and parent_dealer_id =1806 and deal_status in ('Finalized','Sold')

group by parent_dealer_id, nuo_flag

--select convert(decimal(18,2),55)/DATEDIFF(day,DATEFROMPARTS(YEAR(GETDATE()), 1, 1),GETDATE())
select 
	parent_dealer_id
	,ltrim(rtrim(nuo_flag)) as nuo_flag
	,count(vin) as units_sold_ly
	,convert(decimal(18,2),(convert(decimal(18,2),count(vin))/DATEDIFF(day,DATEFROMPARTS(YEAR(GETDATE()), 1, 1),GETDATE()))*365) as pace_ly
into #units_ly
from master.fi_sales (nolock)
where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
and parent_dealer_id =1806 and deal_status in ('Finalized','Sold')

group by parent_dealer_id, nuo_flag


select 
	parent_dealer_id
	,ltrim(rtrim(nuo_flag)) as nuo_flag
	,count(vin) as units_sold_mtd
	,convert(decimal(18,1),(convert(decimal(18,2),count(vin))/DATEDIFF(day,DATEFROMPARTS(YEAR(GETDATE()), MONTH(getdate()), 1),GETDATE()))*(day(EOMONTH(getdate())))) as pace_mtd
into #units_mtd
from master.fi_sales (nolock)
where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), MONTH(getdate()), 1) and getdate()
and parent_dealer_id =1806 and deal_status in ('Finalized','Sold')

group by parent_dealer_id, nuo_flag

--select * from #units_ytd
--select * from #units_ly
--select * from #units_mtd


select
	y.parent_dealer_id
	,y.nuo_flag
	,'Horizontal' as chart_type
	,'New Units Retailed' as chart_title
	,convert(varchar(100),YEAR(GETDATE())) + ' Units retailed = ' + convert(varchar(50),units_sold_ytd)+', LY Change % = '+convert(varchar(100), convert(decimal(18,1),convert(decimal(18,2),(units_sold_ytd -units_sold_ly)*100)/units_sold_ly))+'%' as chart_subtitle_1
	,convert(varchar(50),DATENAME(MONTH,getdate())) +' units sale = '+ convert(varchar(50),units_sold_mtd) as chart_subtitle_2
into #header
from #units_ytd y inner join #units_ly l on y.parent_dealer_id = l.parent_dealer_id and y.nuo_flag =l.nuo_flag
inner join #units_mtd m on m.parent_dealer_id =l.parent_dealer_id and m.nuo_flag = l.nuo_flag

--group by y.parent_dealer_id,y.nuo_flag

select * from #header


select 
	parent_dealer_id
	,nuo_flag
	,units_sold_ytd
	,pace_ytd
	into #graph_data
from #units_ytd


select 
header.parent_dealer_id
,header.chart_type
,header.chart_title
,header.chart_subtitle_1
,header.chart_subtitle_2
,header.nuo_flag
,graph_data.units_sold_ytd
,graph_data.pace_ytd

from #header header inner join #graph_data  graph_data on header.parent_dealer_id =graph_data.parent_dealer_id and header.nuo_flag =graph_data.nuo_flag
--where header.nuo_flag ='New'
for json auto
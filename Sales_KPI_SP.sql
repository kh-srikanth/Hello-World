USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [dbo].[Master_cust_veh_inactiveupadte]    Script Date: 7/12/2021 1:14:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [master].[sales_kpi_update]

/*
exec [master].[sales_kpi_update]
*/

as
begin

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
and parent_dealer_id =1806 
and deal_status in ('Finalized','Sold')



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


---MTD Caluclations

 select
		parent_dealer_id
		,sum(frontend_gross_profit + backend_gross_profit) as total_gross_mtd
		,ltrim(rtrim(nuo_flag)) as nuo_flag

	into #gross_mtd
from master.fi_sales (nolock)
where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), month(getdate()), 1) and getdate()
and parent_dealer_id =1806 
and deal_status in ('Finalized','Sold')
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

declare @graph_data_kpi1 varchar(5000) = (
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
)

	 ------------------Updating master.dashboard_kpis table
update master.dashboard_kpis set 
	graph_data = @graph_data_kpi1 
	,chart_title =(select top 1 chart_title from #header)
	,chart_subtitle1=(select top 1 chart_subtitle_1 from #header)
	,chart_subtitle2=(select top 1 chart_subtitle_2 from #header)
where kpi_type = 'Sales - Gross Profit'
	-----------------------------------------------------------

-------------Sales KPI--2


IF OBJECT_ID('tempdb..#units_ytd') IS NOT NULL DROP TABLE #units_ytd
IF OBJECT_ID('tempdb..#units_ly') IS NOT NULL DROP TABLE #units_ly 
IF OBJECT_ID('tempdb..#units_mtd') IS NOT NULL DROP TABLE #units_mtd
IF OBJECT_ID('tempdb..#header_2') IS NOT NULL DROP TABLE #header_2
IF OBJECT_ID('tempdb..#graph_data_2') IS NOT NULL DROP TABLE #graph_data_2

select 
		parent_dealer_id
		,ltrim(rtrim(nuo_flag)) as nuo_flag
		,count(vin) as units_sold_ytd
		,convert(decimal(18,1),(convert(decimal(18,2),count(vin))/DATEDIFF(day,DATEFROMPARTS(YEAR(GETDATE()), 1, 1),GETDATE()))*365) as pace_ytd
	into #units_ytd
from master.fi_sales (nolock)
where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
and parent_dealer_id =1806 
and deal_status in ('Finalized','Sold')

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
and parent_dealer_id =1806 
and deal_status in ('Finalized','Sold')

group by parent_dealer_id, nuo_flag


select 
		parent_dealer_id
		,ltrim(rtrim(nuo_flag)) as nuo_flag
		,count(vin) as units_sold_mtd
		,convert(decimal(18,1),(convert(decimal(18,2),count(vin))/DATEDIFF(day,DATEFROMPARTS(YEAR(GETDATE()), MONTH(getdate()), 1),GETDATE()))*(day(EOMONTH(getdate())))) as pace_mtd
	into #units_mtd
from master.fi_sales (nolock)
where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), MONTH(getdate()), 1) and getdate()
and parent_dealer_id =1806 
and deal_status in ('Finalized','Sold')

group by parent_dealer_id, nuo_flag


select
		y.parent_dealer_id
		,y.nuo_flag
		,'Horizontal' as chart_type
		,'New Units Retailed' as chart_title
		,convert(varchar(100),YEAR(GETDATE())) + ' Units retailed = ' + convert(varchar(50),units_sold_ytd)+', LY Change % = '+convert(varchar(100), convert(decimal(18,1),convert(decimal(18,2),(units_sold_ytd -units_sold_ly)*100)/units_sold_ly))+'%' as chart_subtitle_1
		,convert(varchar(50),DATENAME(MONTH,getdate())) +' units sale = '+ convert(varchar(50),units_sold_mtd) as chart_subtitle_2
	into #header_2
from #units_ytd y inner join #units_ly l on y.parent_dealer_id = l.parent_dealer_id and y.nuo_flag =l.nuo_flag
inner join #units_mtd m on m.parent_dealer_id =l.parent_dealer_id and m.nuo_flag = l.nuo_flag
--group by y.parent_dealer_id,y.nuo_flag



select 
		parent_dealer_id
		,nuo_flag
		,units_sold_ytd
		,pace_ytd
	into #graph_data_2
from #units_ytd

declare @graph_data_kpi2 varchar(5000) = (
select 
		header.parent_dealer_id
		,header.chart_type
		,header.chart_title
		,header.chart_subtitle_1
		,header.chart_subtitle_2
		,header.nuo_flag
		,graph_data.units_sold_ytd
		,graph_data.pace_ytd

from #header_2 header inner join #graph_data_2  graph_data on header.parent_dealer_id =graph_data.parent_dealer_id and header.nuo_flag =graph_data.nuo_flag
--where header.nuo_flag ='New'
for json auto
)

	 ------------------Updating master.dashboard_kpis table
update master.dashboard_kpis set 
graph_data = @graph_data_kpi2 
,chart_title=(select top 1 chart_title from #header_2)
,chart_subtitle1=(select top 1 chart_subtitle_1 from #header_2)
,chart_subtitle2=(select top 1 chart_subtitle_2 from #header_2)
where kpi_type = 'Sales - Car units'
	---------------------------------------------------------


--------Sales KPI--3

declare @graph_data_kpi3 varchar(5000) =(
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
and parent_dealer_id =1806 
and deal_status in ('Finalized','Sold')

group by parent_dealer_id, nuo_flag

for json path
)

	 ------------------Updating master.dashboard_kpis table
update master.dashboard_kpis set graph_data = @graph_data_kpi3 where kpi_type = 'Sales - PNVR'
	--------------------------------------------------------


---------------------------sales KPI--4

declare @graph_data_kpi4 varchar(5000)= (
select 

		parent_dealer_id
		,ltrim(rtrim(nuo_flag)) as nuo_flag
		,'Number' as chart_type
		,'Total F&I Income PNVR' as chart_title
		,'Total F&I Income PNVR = $' + convert(varchar(100),convert(decimal(18,1),sum(isnull(total_fin_res,0) + isnull(frontend_gross_profit,0)+isnull(backend_gross_profit,0))/count(vin))) as chart_subtitle_1
		,'Total F&I = $' + convert(varchar(100),sum(isnull(total_fin_res,0) + isnull(frontend_gross_profit,0)+isnull(backend_gross_profit,0))) as chart_subtitle_2
		,count(vin) as units_retailed
		,sum(isnull(total_fin_res,0) + isnull(frontend_gross_profit,0)+isnull(backend_gross_profit,0)) as  fin_prod_gross
		,convert(decimal(18,1),sum(isnull(total_fin_res,0) + isnull(frontend_gross_profit,0)+isnull(backend_gross_profit,0))/count(vin)) as "graph_data.PNVR"

from master.fi_sales (nolock)
where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
and parent_dealer_id =1806 
and deal_status in ('Finalized','Sold') 
and total_finance_amount is not null

group by parent_dealer_id,nuo_flag

for json path	
)

	 ------------------Updating master.dashboard_kpis table
update master.dashboard_kpis set graph_data = @graph_data_kpi4 where kpi_type = 'Sales - Total F&I Income PNVR'
	--------------------------------------------------------

------Sales KPI--5

declare @graph_data_kpi5 varchar(5000)= (
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
)


	 ------------------Updating master.dashboard_kpis table
update master.dashboard_kpis set 
		graph_data = @graph_data_kpi5
where kpi_type = 'Sales - Inventory'
	-------------------------------------------------------


----Sales KPI--6

IF OBJECT_ID('tempdb..#header_6') IS NOT NULL DROP TABLE #header_6
IF OBJECT_ID('tempdb..#result_6') IS NOT NULL DROP TABLE #result_6
IF OBJECT_ID('tempdb..#result1_6') IS NOT NULL DROP TABLE #result1_6
IF OBJECT_ID('tempdb..#graph_data_6') IS NOT NULL DROP TABLE #graph_data_6
IF OBJECT_ID('tempdb..#seg1') IS NOT NULL DROP TABLE #seg1
IF OBJECT_ID('tempdb..#seg2') IS NOT NULL DROP TABLE #seg2
IF OBJECT_ID('tempdb..#seg3') IS NOT NULL DROP TABLE #seg3
IF OBJECT_ID('tempdb..#seg4') IS NOT NULL DROP TABLE #seg4

select 
		parent_dealer_id
		,ltrim(rtrim(nuo_flag)) as nuo_flag
		,'Numbers' as chart_type
		,ltrim(rtrim(nuo_flag))+' Inventory Aging' as chart_title
		,count(vin) as inventory_units
		,sum(vehicle_price) as inventory_value
into #header_6
from master.fi_sales s (nolock) 
where inventory_date is not null
		and convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and parent_dealer_id =1806
group by parent_dealer_id,nuo_flag


select 
		parent_dealer_id
		,ltrim(rtrim(nuo_flag)) as nuo_flag
		,vin
		,datediff(day,convert(date,convert(char(8),inventory_date)),isnull(convert(date,convert(char(8),purchase_date)),getdate())) as diff
into #result_6
from master.fi_sales s (nolock) 
where inventory_date is not null
		and convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and parent_dealer_id =1806


select 
	parent_dealer_id
	,nuo_flag
	,diff
	,vin
	,(case when diff <= 30 then 1
		when diff between 31 and 60 then 2
		when diff between 61 and 90 then 3
		else 4 end )						as age_seg

into #result1_6 
from #result_6 

select	parent_dealer_id,nuo_flag,count(vin) as count_seg1 into #seg1 from #result1_6 where age_seg =1 group by parent_dealer_id,nuo_flag

select	parent_dealer_id,nuo_flag,count(vin) as count_seg2 into #seg2 from #result1_6 where age_seg =2 group by parent_dealer_id,nuo_flag

select	parent_dealer_id,nuo_flag,count(vin) as count_seg3 into #seg3 from #result1_6 where age_seg =3 group by parent_dealer_id,nuo_flag

select  parent_dealer_id,nuo_flag,count(vin) as count_seg4 into #seg4 from #result1_6 where age_seg =4 group by parent_dealer_id,nuo_flag


select 
s1.parent_dealer_id
,s1.nuo_flag
,s1.count_seg1 
,count_seg2
,count_seg3
,count_seg4


into #graph_data_6
from #seg1 s1 inner join #seg2 s2 on s1.parent_dealer_id =s2.parent_dealer_id and s1.nuo_flag=s2.nuo_flag
inner join #seg3 s3 on s3.parent_dealer_id =s1.parent_dealer_id and s3.nuo_flag=s1.nuo_flag
inner join #seg4 s4 on s4.parent_dealer_id =s1.parent_dealer_id and s4.nuo_flag=s1.nuo_flag

declare @graph_data_kpi6 varchar(5000)= (
select
		 header.parent_dealer_id as "header.accountId"
		,header.nuo_flag as "header.nuo_flag"
		,header.chart_type as "header.chart_type"
		,header.chart_title as "header.chart_title"
		,'Total Value = $'+convert(varchar(50),convert(decimal(18,1),inventory_value)) as "header.chart_subtitle_1"
		,'Total Value' as "header.chart_subtitle_2"

		,graph_data.count_seg1 as "graph_data.age_30_below"
		,graph_data.count_seg2 as "graph_data.age_31_60"
		,graph_data.count_seg3 as "graph_data.age_61_90"
		,graph_data.count_seg4 as "graph_data.age_90_above"


from #header_6 header inner join #graph_data_6 graph_data on header.parent_dealer_id =graph_data.parent_dealer_id and header.nuo_flag =graph_data.nuo_flag
for json path
)



	 ------------------Updating master.dashboard_kpis table
update master.dashboard_kpis set 
		graph_data = @graph_data_kpi6 
		,chart_title =(select top 1 chart_title from #header_6)
		,chart_subtitle1 =(select top 1 chart_subtitle1 from #header_6)
		,chart_subtitle2 =(select top 1 chart_subtitle2 from #header_6)
where kpi_type = 'Sales - Inventory unit Aging'
	--------------------------------------------------------

-------Sales KPI-7



IF OBJECT_ID('tempdb..#header_7') IS NOT NULL DROP TABLE #header_7
IF OBJECT_ID('tempdb..#result_7') IS NOT NULL DROP TABLE #result_7
IF OBJECT_ID('tempdb..#graph_data_7') IS NOT NULL DROP TABLE #graph_data_7
IF OBJECT_ID('tempdb..#avg_sale') IS NOT NULL DROP TABLE #avg_sale
IF OBJECT_ID('tempdb..#avg1') IS NOT NULL DROP TABLE #avg1
IF OBJECT_ID('tempdb..#avg2') IS NOT NULL DROP TABLE #avg2
IF OBJECT_ID('tempdb..#avg3') IS NOT NULL DROP TABLE #avg3

IF OBJECT_ID('tempdb..#days_supply') IS NOT NULL DROP TABLE #days_supply

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

		into #graph_data_7

from master.inventory (nolock) where vehicle_status in ('AVAILABLE')
 group by parent_dealer_id,(case when odometer > 1000 then 'Used' else 'New' end)


 select 
		  a.parent_dealer_id
		 ,a.nuo_flag
		 ,convert(decimal(18,2),(convert(decimal(18,2),a.current_inventory_units)/b.avg_sale)*30) as days_supply
	into #days_supply
 from #graph_data_7 a inner join #avg_sale b on a.parent_dealer_id =b.parent_dealer_id and a.nuo_flag =b.nuo_flag

 declare @graph_data_kpi7 varchar(5000) = (
 select
		  parent_dealer_id
		 ,nuo_flag
		 ,'Number' as chart_type
		 ,nuo_flag+' Inventory Days Supply' as chart_title
		 ,days_supply as "graph_data.days_supply"

 from #days_supply

 for json path
 )

	 ------------------Updating master.dashboard_kpis table
update master.dashboard_kpis set 
	graph_data = @graph_data_kpi7 
	,chart_title =(select top 1 chart_title from #days_supply)
	,chart_subtitle1 =(select top 1 chart_subtitle1 from #days_supply)
	,chart_subtitle2 =(select top 1 chart_subtitle2 from #days_supply)
where kpi_type = 'Sales - Vehicle Days Supply'
	------------------------------------------------------


 ------Sales KPI--8

 
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

declare @graph_data_kpi8 varchar(5000)=(
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
	)

	 ------------------Updating master.dashboard_kpis table
update master.dashboard_kpis set 
		graph_data = @graph_data_kpi8 
		,chart_title=(select top 1 chart_title from #fin_units)
		,chart_subtitle1 =(select top 1 chart_subtitle1 from #fin_units)
		,chart_subtitle2 =(select top 1 chart_subtitle2 from #fin_units)
where kpi_type = 'Sales - Finance Penetration'
	-----------------------------------------------------------

	end
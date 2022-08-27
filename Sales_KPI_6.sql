use clictell_auto_master
go
IF OBJECT_ID('tempdb..#header') IS NOT NULL DROP TABLE #header
IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result
IF OBJECT_ID('tempdb..#result1') IS NOT NULL DROP TABLE #result1
IF OBJECT_ID('tempdb..#graph_data') IS NOT NULL DROP TABLE #graph_data
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
into #header
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
into #result
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

into #result1 
from #result 

select	parent_dealer_id,nuo_flag,count(vin) as count_seg1 into #seg1 from #result1 where age_seg =1 group by parent_dealer_id,nuo_flag

select	parent_dealer_id,nuo_flag,count(vin) as count_seg2 into #seg2 from #result1 where age_seg =2 group by parent_dealer_id,nuo_flag

select	parent_dealer_id,nuo_flag,count(vin) as count_seg3 into #seg3 from #result1 where age_seg =3 group by parent_dealer_id,nuo_flag

select  parent_dealer_id,nuo_flag,count(vin) as count_seg4 into #seg4 from #result1 where age_seg =4 group by parent_dealer_id,nuo_flag


select 
s1.parent_dealer_id
,s1.nuo_flag
,s1.count_seg1 
,count_seg2
,count_seg3
,count_seg4


into #graph_data
from #seg1 s1 inner join #seg2 s2 on s1.parent_dealer_id =s2.parent_dealer_id and s1.nuo_flag=s2.nuo_flag
inner join #seg3 s3 on s3.parent_dealer_id =s1.parent_dealer_id and s3.nuo_flag=s1.nuo_flag
inner join #seg4 s4 on s4.parent_dealer_id =s1.parent_dealer_id and s4.nuo_flag=s1.nuo_flag

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


from #header header inner join #graph_data graph_data on header.parent_dealer_id =graph_data.parent_dealer_id and header.nuo_flag =graph_data.nuo_flag
for json path
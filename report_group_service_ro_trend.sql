USE [clictell_auto_master]
GO
--/****** Object:  StoredProcedure [reports].[group_service_ro_trend]    Script Date: 3/25/2021 3:58:46 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--ALTER procedure  [reports].[group_service_ro_trend]
declare
@dealer varchar(4000) = '500,144,157,51,170,181,184,290,317,216,70',
@FromDate date ='2010-01-01',
@ToDate date = '2011-12-31'

--as 
/*
	exec [reports].[group_service_ro_trend]  '500,144,157,51,170,181,184,290,317,216,70','2010-01-01','2011-12-30'
*/

begin

IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2
IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3
IF OBJECT_ID('tempdb..#temp4') IS NOT NULL DROP TABLE #temp4
IF OBJECT_ID('tempdb..#temp5') IS NOT NULL DROP TABLE #temp5
IF OBJECT_ID('tempdb..#temp6') IS NOT NULL DROP TABLE #temp6

select 
rh.natural_key
,ro_number
,(case  when total_customer_labor_price!=0 or total_customer_parts_price!=0 or total_customer_misc_price!=0 then 'Customer Pay'
		when total_warranty_labor_price!=0 or total_warranty_parts_price!=0 or total_warranty_misc_price!=0 then 'Warranty Pay'
		when total_internal_labor_price!=0 or total_internal_parts_price!=0 or total_internal_misc_price!=0 then 'Internal Pay'
		else '' end) as p_t
--,pay_type
,total_labor_price
,total_parts_price
,total_billed_labor_hours
,convert(date,convert(char(8),ro_open_date)) as ro_open_date,
Month(convert(date,convert(char(8),ro_open_date))) as m1,
DateName(MM, convert(varchar(10),ro_open_date, 111)) + ' - ' + DateName(YY, convert(varchar(10),ro_open_date, 111)) as m
--,month(@ToDate) - month(convert(date,convert(char(8),ro_open_date))) as m
into #temp
from master.repair_order_header rh (nolock) inner join master.dealer d (nolock) on rh.natural_key = d.natural_key 
where d.parent_dealer_id in (select value from [dbo].[fn_split_string_to_column] (@dealer, ','))
and convert(date,convert(char(8),ro_open_date)) between @FromDate and @ToDate 

return;
select DateName(mm,getdate())
select * from #temp

select 
m
,p_t
,count(ro_number) as ro_count_pt
,sum(total_labor_price) as labor_gross_pt
,sum(total_parts_price) as parts_gross_pt
,sum(total_billed_labor_hours) as labor_hrs_pt 
,sum(total_labor_price) + sum(total_parts_price) as gross_pt
,sum(total_labor_price)/count(ro_number) as labor_gross_per_ro_pt
,sum(total_parts_price)/count(ro_number) as parts_gross_per_ro_pt
,sum(total_billed_labor_hours)/count(ro_number) as labor_hrs_per_ro_pt
into #temp1 
from #temp where m is not null group by m,p_t

select 
m
,sum(ro_count_pt) as total_ro_count
,sum(labor_gross_pt) as labor_gross
,sum(labor_hrs_pt) as labor_hrs
,sum(parts_gross_pt) as parts_gross
,sum(labor_gross_pt) + sum(parts_gross_pt) as total_gross
,(sum(labor_gross_pt) + sum(parts_gross_pt))/sum(ro_count_pt) as total_gross_per_ro
into #temp2
from #temp1  group by m

alter table #temp1 add total_ro_count decimal(18,2),labor_gross decimal(18,2),labor_hrs decimal(18,2)
,parts_gross decimal(18,2),total_gross decimal(18,2),total_gross_per_ro decimal(18,2),perc_of_total_ro decimal(18,2)

update t1 set
t1.total_ro_count= t2.total_ro_count
,t1.labor_gross = t2.labor_gross
,t1.labor_hrs = t2.labor_hrs
,t1.parts_gross = t2.parts_gross
,t1.total_gross = t2.parts_gross
,t1.total_gross_per_ro = t2.total_gross_per_ro
,t1.perc_of_total_ro  = t1.gross_pt/t2.total_gross
from #temp1 t1 left outer join #temp2 t2 on t1.m =t2.m 

select p_t,sum(ro_count_pt) as total_ro_count_pt,sum(labor_gross_pt) as total_labor_gross_pt
,sum(parts_gross_pt) as total_parts_gross_pt,sum(labor_hrs_pt) as total_labor_hrs_pt,sum(gross_pt) as total_gross_pt
,sum(labor_gross_per_ro_pt) as total_labor_gross_per_ro_pt,sum(parts_gross_per_ro_pt) as total_parts_gross_per_ro_pt
,sum(labor_hrs_per_ro_pt) as total_labor_hrs_per_ro_pt, avg(perc_of_total_ro) as total_perc_of_total_ro_pt,-9999 as m
into #temp5
from #temp1 group by p_t

select sum(total_ro_count) as total_total_ro_count,sum(labor_gross) as total_labor_gross,sum(labor_hrs) as total_labor_hrs
,sum(parts_gross) as total_parts_gross,sum(total_gross) as total_total_gross
,sum(total_gross_per_ro) as total_total_gross_per_ro, -9999 as m 
into #temp6
from #temp1 





insert into #temp1
(m
,p_t
 ,ro_count_pt
,labor_gross_pt
,parts_gross_pt
,labor_hrs_pt
,gross_pt
,labor_gross_per_ro_pt
,parts_gross_per_ro_pt
,labor_hrs_per_ro_pt
,perc_of_total_ro
,total_ro_count
,labor_gross
,labor_hrs
,parts_gross
,total_gross
,total_gross_per_ro

)
select
 t5.m
,t5.p_t
,t5.total_ro_count_pt
,t5.total_labor_gross_pt
,t5.total_parts_gross_pt
,t5.total_labor_hrs_pt
,t5.total_gross_pt
,t5.total_labor_gross_per_ro_pt
,t5.total_parts_gross_per_ro_pt
,t5.total_labor_hrs_per_ro_pt
,t5.total_perc_of_total_ro_pt
,t6.total_total_ro_count
,t6.total_labor_gross
,t6.total_labor_hrs
,t6.total_parts_gross
,t6.total_total_gross
,t6.total_total_gross_per_ro
from #temp5 t5 inner join #temp6 t6 on t5.m =t6.m

select p_t,avg(ro_count_pt) as avg_ro_count_pt,avg(labor_gross_pt) as avg_labor_gross_pt
,avg(parts_gross_pt) as avg_parts_gross_pt,avg(labor_hrs_pt) as avg_labor_hrs_pt,avg(gross_pt) as avg_gross_pt
,avg(labor_gross_per_ro_pt) as avg_labor_gross_per_ro_pt,avg(parts_gross_per_ro_pt) as avg_parts_gross_per_ro_pt
,avg(labor_hrs_per_ro_pt) as avg_labor_hrs_per_ro_pt, avg(perc_of_total_ro) as avg_perc_of_total_ro_pt,-8888 as m
into #temp3
from #temp1 group by p_t

select avg(total_ro_count) as avg_total_ro_count,avg(labor_gross) as avg_labor_gross,avg(labor_hrs) as avg_labor_hrs
,avg(parts_gross) as avg_parts_gross,avg(total_gross) as avg_total_gross
,avg(total_gross_per_ro) as avg_total_gross_per_ro, -8888 as m 
into #temp4
from #temp1 

insert into #temp1
(m
,p_t
 ,ro_count_pt
,labor_gross_pt
,parts_gross_pt
,labor_hrs_pt
,gross_pt
,labor_gross_per_ro_pt
,parts_gross_per_ro_pt
,labor_hrs_per_ro_pt
,perc_of_total_ro
,total_ro_count
,labor_gross
,labor_hrs
,parts_gross
,total_gross
,total_gross_per_ro

)
select
t3.m
,t3.p_t
,t3.avg_ro_count_pt
,t3.avg_labor_gross_pt
,t3.avg_parts_gross_pt
,t3.avg_labor_hrs_pt
,t3.avg_gross_pt
,t3.avg_labor_gross_per_ro_pt
,t3.avg_parts_gross_per_ro_pt
,t3.avg_labor_hrs_per_ro_pt
,t3.avg_perc_of_total_ro_pt
,t4.avg_total_ro_count
,t4.avg_labor_gross
,t4.avg_labor_hrs
,t4.avg_parts_gross
,t4.avg_total_gross
,t4.avg_total_gross_per_ro
from #temp3 t3 inner join #temp4 t4 on t3.m =t4.m



select * from #temp1 order by m,p_t
end
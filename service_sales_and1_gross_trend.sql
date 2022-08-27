USE clictell_auto_master
GO

IF OBJECT_ID('tempdb..#report') IS NOT NULL DROP TABLE #report
IF OBJECT_ID('tempdb..#report_ly') IS NOT NULL DROP TABLE #report_ly
declare
@FromDate date = '2010-01-01',
@ToDate date = '2021-01-01',
@dealer varchar(4000) = '500,144,157,51,170,181,184,290,317,216,70'

IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2
IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3

select 
rh.parent_dealer_id
,(case  when total_customer_labor_price!=0 or total_customer_parts_price!=0 or total_customer_misc_price!=0 then 'Customer Pay'
		when total_warranty_labor_price!=0 or total_warranty_parts_price!=0 or total_warranty_misc_price!=0 then 'Warranty Pay'
		when total_internal_labor_price!=0 or total_internal_parts_price!=0 or total_internal_misc_price!=0 then 'Internal Pay'
		else '' end) as p_t
,'Labor' as lbr_prt
,total_labor_cost as indi_gross
,total_labor_price as indi_sales

into #temp
from master.repair_order_header rh (nolock) 
inner join master.dealer d (nolock) on rh.parent_dealer_id = d.parent_dealer_id
where convert(date,convert(char(8),rh.ro_open_date)) between @FromDate and @ToDate
and rh.parent_dealer_id in (select value from [dbo].[fn_split_string_to_column] (@dealer, ','))

union

select 
rh.parent_dealer_id
,(case  when total_customer_labor_price!=0 or total_customer_parts_price!=0 or total_customer_misc_price!=0 then 'Customer Pay'
		when total_warranty_labor_price!=0 or total_warranty_parts_price!=0 or total_warranty_misc_price!=0 then 'Warranty Pay'
		when total_internal_labor_price!=0 or total_internal_parts_price!=0 or total_internal_misc_price!=0 then 'Internal Pay'
		else '' end) as p_t
,'Part' as lbr_prt
,convert(decimal(18,2),total_parts_cost) as indi_gross
,convert(decimal(18,2),total_parts_price) as indi_sales

from master.repair_order_header rh (nolock) 
inner join master.dealer d (nolock) on rh.parent_dealer_id = d.parent_dealer_id
where convert(date,convert(char(8),rh.ro_open_date)) between @FromDate and @ToDate
and rh.parent_dealer_id in (select value from [dbo].[fn_split_string_to_column] (@dealer, ','))

select 
t.parent_dealer_id
,d.dealer_name
,lbr_prt
,p_t
,sum(convert(decimal(18,2),indi_gross)) as gross
,sum(convert(decimal(18,2),indi_sales)) as sales
,0 as total_sales_lp
,0 as total_gross_lp
,0 as total_sales
,0 as total_gross
,0 as perc_sales_lp
,0 as perc_gross_lp
,0 as perc_sales_dlr
,0 as perc_gross_dlr
,0 as gross_marg_perc
into #temp1
from #temp t inner join master.dealer d (nolock) on t.parent_dealer_id =d.parent_dealer_id
group by t.parent_dealer_id,dealer_name,lbr_prt,p_t


select 
parent_dealer_id
,lbr_prt
,sum(convert(decimal(18,2),gross)) as total_gross_lp
,sum(convert(decimal(18,2),sales)) as total_sales_lp
into #temp2
from #temp1 group by parent_dealer_id,lbr_prt


select 
parent_dealer_id
,sum(convert(decimal(18,2),total_gross_lp)) as total_gross
,sum(convert(decimal(18,2),total_sales_lp)) as total_sales
into #temp3
from #temp2 group by parent_dealer_id


update t1 set
t1.total_sales_lp=t2.total_sales_lp
,t1.total_gross_lp=t2.total_gross_lp
,t1.total_sales=t3.total_sales
,t1.total_gross=t3.total_gross
,t1.perc_sales_lp = (t1.sales*100)/t2.total_sales_lp
,t1.perc_gross_lp = (t1.gross*100)/t2.total_gross_lp
,t1.perc_sales_dlr = (t2.total_sales_lp*100)/t3.total_sales
,t1.perc_gross_dlr = (t2.total_gross_lp*100)/t3.total_gross
,t1.gross_marg_perc = ((t3.total_sales -t3.total_gross)*100)/t3.total_gross

from #temp1 t1 
left outer join #temp2 t2 on t1.parent_dealer_id =t2.parent_dealer_id and t1.lbr_prt =t2.lbr_prt
left outer join #temp3 t3 on t1.parent_dealer_id = t3.parent_dealer_id 


insert into #temp1 (
parent_dealer_id,dealer_name, lbr_prt,p_t,gross,sales,total_gross_lp,total_sales_lp,total_gross,total_sales,perc_gross_lp,perc_sales_lp,perc_gross_dlr,perc_sales_dlr,gross_marg_perc )
select 
'001','Total',lbr_prt,p_t,sum(gross),sum(sales),sum(total_gross_lp),sum(total_sales_lp),sum(total_gross),sum(total_sales)
,(sum(gross)*100)/sum(total_gross_lp),sum(sales)*100/sum(total_sales_lp),sum(total_gross_lp)*100/sum(total_gross),sum(total_sales_lp)*100/sum(total_sales), (sum(total_sales)-sum(total_gross))*100/sum(total_gross)
from #temp1 group by lbr_prt,p_t

return;
select * from #temp1 order by parent_dealer_id,lbr_prt,p_t


insert into #temp1 (
parent_dealer_id,dealer_name, lbr_prt,p_t,gross,sales,total_gross_lp,total_sales_lp,total_gross,total_sales,perc_gross_lp,perc_sales_lp,perc_gross_dlr,perc_sales_dlr,gross_marg_perc )
select 
'002','Avg',lbr_prt,p_t,avg(gross),avg(sales),avg(total_gross_lp),avg(total_sales_lp),avg(total_gross),avg(total_sales)
,(sum(gross)*100)/sum(total_gross_lp),sum(sales)*100/sum(total_sales_lp),sum(total_gross_lp)*100/sum(total_gross),sum(total_sales_lp)*100/sum(total_sales), (sum(total_sales)-sum(total_gross))*100/sum(total_gross)
from #temp1 group by lbr_prt,p_t

insert into #temp1 (
parent_dealer_id,dealer_name, lbr_prt,p_t
,gross,sales,total_gross_lp,total_sales_lp,total_gross,total_sales
,perc_gross_lp,perc_sales_lp,perc_gross_dlr,perc_sales_dlr,gross_marg_perc )
select 
d.parent_dealer_id,d.dealer_name,isnull(lbr_prt,'Labor'),isnull(p_t,'Customer pay')
,0,0,0,0,0,0
,0,0,0,0,0
from master.dealer d (nolock)
left outer join #temp1 t1 on t1.parent_dealer_id = d.parent_dealer_id
 where d.parent_dealer_id in (select value from [dbo].[fn_split_string_to_column] (@dealer, ','))
 and t1.parent_dealer_id is null


select 
parent_dealer_id
,dealer_name
,lbr_prt
,p_t
,gross
,perc_gross_lp
,sales
,perc_sales_lp
,total_gross_lp
,perc_gross_dlr
,total_sales_lp
,perc_sales_dlr
,total_gross
,total_sales
,gross_marg_perc
into #report
from #temp1 order by parent_dealer_id,lbr_prt,p_t

select * from #report order by parent_dealer_id,lbr_prt,p_t

---------------------------------------------------------------------
/*


IF OBJECT_ID('tempdb..#temp_ly') IS NOT NULL DROP TABLE #temp_ly
IF OBJECT_ID('tempdb..#temp1_ly') IS NOT NULL DROP TABLE #temp1_ly
IF OBJECT_ID('tempdb..#temp2_ly') IS NOT NULL DROP TABLE #temp2_ly
IF OBJECT_ID('tempdb..#temp3_ly') IS NOT NULL DROP TABLE #temp3_ly

select 
rh.parent_dealer_id
,(case  when total_customer_labor_price!=0 or total_customer_parts_price!=0 or total_customer_misc_price!=0 then 'Customer Pay'
		when total_warranty_labor_price!=0 or total_warranty_parts_price!=0 or total_warranty_misc_price!=0 then 'Warranty Pay'
		when total_internal_labor_price!=0 or total_internal_parts_price!=0 or total_internal_misc_price!=0 then 'Internal Pay'
		else '' end) as p_t
,'Labor' as lbr_prt
,total_labor_cost as indi_gross
,total_labor_price as indi_sales

into #temp_ly
from master.repair_order_header rh (nolock) 
inner join master.dealer d (nolock) on rh.parent_dealer_id = d.parent_dealer_id
where convert(date,convert(char(8),rh.ro_open_date)) between dateadd(year,-1,@FromDate) and @ToDate
and rh.parent_dealer_id in (select value from [dbo].[fn_split_string_to_column] (@dealer, ','))

union

select 
rh.parent_dealer_id
,(case  when total_customer_labor_price!=0 or total_customer_parts_price!=0 or total_customer_misc_price!=0 then 'Customer Pay'
		when total_warranty_labor_price!=0 or total_warranty_parts_price!=0 or total_warranty_misc_price!=0 then 'Warranty Pay'
		when total_internal_labor_price!=0 or total_internal_parts_price!=0 or total_internal_misc_price!=0 then 'Internal Pay'
		else '' end) as p_t
,'Part' as lbr_prt
,convert(decimal(18,2),total_parts_cost) as indi_gross
,convert(decimal(18,2),total_parts_price) as indi_sales

from master.repair_order_header rh (nolock) 
inner join master.dealer d (nolock) on rh.parent_dealer_id = d.parent_dealer_id
where convert(date,convert(char(8),rh.ro_open_date)) between dateadd(year,-1,@FromDate) and @ToDate
and rh.parent_dealer_id in (select value from [dbo].[fn_split_string_to_column] (@dealer, ','))

select 
t.parent_dealer_id
,d.dealer_name
,lbr_prt
,p_t
,sum(convert(decimal(18,2),indi_gross)) as gross
,sum(convert(decimal(18,2),indi_sales)) as sales
,0 as total_sales_lp
,0 as total_gross_lp
,0 as total_sales
,0 as total_gross
,0 as perc_sales_lp
,0 as perc_gross_lp
,0 as perc_sales_dlr
,0 as perc_gross_dlr
,0 as gross_marg_perc
into #temp1_ly
from #temp_ly t inner join master.dealer d (nolock) on t.parent_dealer_id =d.parent_dealer_id
group by t.parent_dealer_id,dealer_name,lbr_prt,p_t


select 
parent_dealer_id
,lbr_prt
,sum(convert(decimal(18,2),gross)) as total_gross_lp
,sum(convert(decimal(18,2),sales)) as total_sales_lp
into #temp2_ly
from #temp1_ly group by parent_dealer_id,lbr_prt


select 
parent_dealer_id
,sum(convert(decimal(18,2),total_gross_lp)) as total_gross
,sum(convert(decimal(18,2),total_sales_lp)) as total_sales
into #temp3_ly
from #temp2_ly group by parent_dealer_id


update t1 set
t1.total_sales_lp=t2.total_sales_lp
,t1.total_gross_lp=t2.total_gross_lp
,t1.total_sales=t3.total_sales
,t1.total_gross=t3.total_gross
,t1.perc_sales_lp = (t1.sales*100)/t2.total_sales_lp
,t1.perc_gross_lp = (t1.gross*100)/t2.total_gross_lp
,t1.perc_sales_dlr = (t2.total_sales_lp*100)/t3.total_sales
,t1.perc_gross_dlr = (t2.total_gross_lp*100)/t3.total_gross
,t1.gross_marg_perc = ((t3.total_sales -t3.total_gross)*100)/t3.total_gross

from #temp1_ly t1 
left outer join #temp2_ly t2 on t1.parent_dealer_id =t2.parent_dealer_id and t1.lbr_prt =t2.lbr_prt
left outer join #temp3_ly t3 on t1.parent_dealer_id = t3.parent_dealer_id 
--order by parent_dealer_id,lbr_prt,p_t


insert into #temp1_ly (
parent_dealer_id,dealer_name, lbr_prt,p_t,gross,sales,total_gross_lp,total_sales_lp,total_gross,total_sales,perc_gross_lp,perc_sales_lp,perc_gross_dlr,perc_sales_dlr,gross_marg_perc )
select 
'001','Total',lbr_prt,p_t,sum(gross),sum(sales),sum(total_gross_lp),sum(total_sales_lp),sum(total_gross),sum(total_sales)
,(sum(gross)*100)/sum(total_gross_lp),sum(sales)*100/sum(total_sales_lp),sum(total_gross_lp)*100/sum(total_gross),sum(total_sales_lp)*100/sum(total_sales), (sum(total_sales)-sum(total_gross))*100/sum(total_gross)
from #temp1_ly group by lbr_prt,p_t

insert into #temp1_ly (
parent_dealer_id,dealer_name, lbr_prt,p_t,gross,sales,total_gross_lp,total_sales_lp,total_gross,total_sales,perc_gross_lp,perc_sales_lp,perc_gross_dlr,perc_sales_dlr,gross_marg_perc )
select 
'002','Avg',lbr_prt,p_t,avg(gross),avg(sales),avg(total_gross_lp),avg(total_sales_lp),avg(total_gross),avg(total_sales)
,(sum(gross)*100)/sum(total_gross_lp),sum(sales)*100/sum(total_sales_lp),sum(total_gross_lp)*100/sum(total_gross),sum(total_sales_lp)*100/sum(total_sales), (sum(total_sales)-sum(total_gross))*100/sum(total_gross)
from #temp1_ly group by lbr_prt,p_t

insert into #temp1_ly (
parent_dealer_id,dealer_name, lbr_prt,p_t
,gross,sales,total_gross_lp,total_sales_lp,total_gross,total_sales
,perc_gross_lp,perc_sales_lp,perc_gross_dlr,perc_sales_dlr,gross_marg_perc )
select 
d.parent_dealer_id,d.dealer_name,isnull(lbr_prt,'Labor'),isnull(p_t,'Customer pay')
,0,0,0,0,0,0
,0,0,0,0,0
from master.dealer d (nolock)
left outer join #temp1_ly t1 on t1.parent_dealer_id = d.parent_dealer_id
 where d.parent_dealer_id in (select value from [dbo].[fn_split_string_to_column] (@dealer, ','))
 and t1.parent_dealer_id is null


select 
parent_dealer_id
,dealer_name
,lbr_prt
,p_t
,gross
,perc_gross_lp
,sales
,perc_sales_lp
,total_gross_lp
,perc_gross_dlr
,total_sales_lp
,perc_sales_dlr
,total_gross
,total_sales
,gross_marg_perc
into #report_ly
from #temp1_ly order by parent_dealer_id,lbr_prt,p_t


insert into #report (
parent_dealer_id,dealer_name,lbr_prt,p_t,gross,sales,total_gross_lp,total_sales_lp,total_gross,total_sales
,perc_gross_lp,perc_sales_lp,perc_gross_dlr,perc_sales_dlr,gross_marg_perc
)

select
3,'LastYearChange',l.lbr_prt,l.p_t
,r.gross -l.gross,r.sales - l.sales, r.total_gross_lp - l.total_gross_lp, r.total_sales_lp-l.total_sales_lp,r.total_gross-l.total_gross,r.total_sales-l.total_sales
,r.perc_gross_lp-l.perc_gross_lp,r.perc_sales_lp-l.perc_sales_lp,r.perc_gross_dlr-l.perc_gross_dlr,r.perc_sales_dlr-l.perc_sales_dlr,r.gross_marg_perc-l.gross_marg_perc
from #report l inner join #report_ly r on r.parent_dealer_id = l.parent_dealer_id and r.lbr_prt = l.lbr_prt and r.p_t = l.p_t where r.parent_dealer_id =1

select * from #report order by parent_dealer_id,lbr_prt,p_t
select * from #report_ly order by parent_dealer_id,lbr_prt,p_t

*/


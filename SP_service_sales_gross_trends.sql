USE clictell_auto_master
GO
declare
@dealer varchar(4000) = '524,513,514,512',
@FromDate date = '2020-01-01',
@ToDate date = '2021-01-01',
@DateRange int = 6

IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2
IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3
IF OBJECT_ID('tempdb..#temp4') IS NOT NULL DROP TABLE #temp4
IF OBJECT_ID('tempdb..#temp5') IS NOT NULL DROP TABLE #temp5
IF OBJECT_ID('tempdb..#temp6') IS NOT NULL DROP TABLE #temp6

select
left(ro_close_date,6) as m1
,left(DateName(MM, convert(varchar(10),ro_close_date, 111)),3) + ' - ' + DateName(YY, convert(varchar(10),ro_close_date, 111)) as m
,total_customer_labor_cost
,total_customer_labor_price
,total_warranty_labor_cost
,total_warranty_labor_price
,total_internal_labor_cost
,total_internal_labor_price
,total_customer_parts_cost
,total_customer_parts_price
,total_warranty_parts_cost
,total_warranty_parts_price
,total_internal_parts_cost
,total_internal_parts_price
,(select count(ro_number) from master.repair_order_header roh where
convert(date,convert(char(8),roh.ro_close_date)) between @FromDate and @ToDate
and roh.parent_dealer_id in (select value from [dbo].[fn_split_string_to_column](@dealer,','))) as ro_count
into #temp
from master.repair_order_header r (nolock)
where
 (r.parent_dealer_id in (select value from [dbo].[fn_split_string_to_column] (@dealer, ',')))
and (convert(date,convert(char(8),r.ro_close_date)) between @FromDate and @ToDate)
order by ro_number




select 
m1
,m
,sum(total_customer_labor_cost) as cp_gross
,sum(total_customer_labor_price) as cp_sale
,sum(total_warranty_labor_cost) as wp_gross
,sum(total_warranty_labor_price) as wp_sale
,sum(total_internal_labor_cost) as ip_gross
,sum(total_internal_labor_price) as ip_sale
,sum(total_customer_labor_cost) + sum(total_warranty_labor_cost) +  sum(total_internal_labor_cost) as total_lbr_prt_gross
,sum(total_customer_labor_price) + sum(total_warranty_labor_price) +  sum(total_internal_labor_price) as total_lbr_prt_sale
,0 as perc_of_lbrprt_sale_cp
,0 as perc_of_lbrprt_gross_cp
,0 as perc_of_lbrprt_sale_wp
,0 as perc_of_lbrprt_gross_wp
,0 as perc_of_lbrprt_sale_ip
,0 as perc_of_lbrprt_gross_ip
,0 as total_sale
,0 as total_gross
,0 as perc_of_total_sale
,0 as perc_of_total_gross
,'Labor' as lbr_prt
,avg(ro_count) as ro_count
into #temp1
from #temp group by m1,m
union
select 
m1
,m
,sum(total_customer_parts_cost) as cp_sales
,sum(total_customer_parts_price) as cp_gross
,sum(total_warranty_parts_cost) as wp_sales
,sum(total_warranty_parts_price) as wp_gross
,sum(total_internal_parts_cost) as ip_sales
,sum(total_internal_parts_price) as ip_gross
,sum(total_customer_parts_cost) + sum(total_warranty_parts_cost) +  sum(total_internal_parts_cost) as total_lbr_prt_gross
,sum(total_customer_parts_price) + sum(total_warranty_parts_price) +  sum(total_internal_parts_price) as total_lbr_prt_sale
,0 as perc_of_lbrprt_sale_cp
,0 as perc_of_lbrprt_gross_cp
,0 as perc_of_lbrprt_sale_wp
,0 as perc_of_lbrprt_gross_wp
,0 as perc_of_lbrprt_sale_ip
,0 as perc_of_lbrprt_gross_ip
,0 as total_sale
,0 as total_gross
,0 as perc_of_total_sale
,0 as perc_of_total_gross
,'Parts' as lbr_prt
,avg(ro_count) as ro_count
from #temp group by m1,m

select m1,m, sum(total_lbr_prt_gross) as total_gross, sum(total_lbr_prt_sale) as total_sale
into #temp2
from #temp1
group by m1,m

update t1 set
t1.total_sale = t2.total_sale
,t1.total_gross = t2.total_gross
,t1.perc_of_lbrprt_sale_cp = t1.cp_sale/t1.total_lbr_prt_sale
,t1.perc_of_lbrprt_gross_cp = t1.cp_gross/t1.total_lbr_prt_gross
,t1.perc_of_lbrprt_sale_wp = t1.wp_sale/t1.total_lbr_prt_sale
,t1.perc_of_lbrprt_gross_wp = t1.wp_gross/t1.total_lbr_prt_gross
,t1.perc_of_lbrprt_sale_ip = t1.ip_sale/t1.total_lbr_prt_sale
,t1.perc_of_lbrprt_gross_ip = t1.ip_gross/t1.total_lbr_prt_gross
,t1.perc_of_total_sale = t1.total_lbr_prt_sale/t1.total_sale
,t1.perc_of_total_gross = t1.total_lbr_prt_gross/t1.total_gross
from #temp1 t1 left outer join #temp2 t2 on t1.m1 = t2.m1 

insert into #temp1 (m1,m,cp_gross,cp_sale,wp_gross,wp_sale,ip_gross,ip_sale,total_lbr_prt_gross,total_lbr_prt_sale,total_sale,total_gross
,perc_of_lbrprt_sale_cp,perc_of_lbrprt_gross_cp,perc_of_lbrprt_sale_wp,perc_of_lbrprt_gross_wp,perc_of_lbrprt_sale_ip,perc_of_lbrprt_gross_ip
,perc_of_total_sale,perc_of_total_gross
			,lbr_prt,ro_count)
select 1,'Total',sum(cp_gross),sum(cp_sale),sum(wp_gross),sum(wp_sale),sum(ip_gross),sum(ip_sale),sum(total_lbr_prt_gross),sum(total_lbr_prt_sale),sum(total_sale),sum(total_gross)
,sum(cp_sale)/sum(total_lbr_prt_sale),sum(cp_gross)/sum(total_lbr_prt_gross),sum(wp_sale)/sum(total_lbr_prt_sale),sum(wp_gross)/sum(total_lbr_prt_gross),sum(ip_sale)/sum(total_lbr_prt_sale),sum(ip_gross)/sum(total_lbr_prt_gross)
,0,0
,lbr_prt,ro_count
from #temp1 group by ro_count ,lbr_prt


select * from #temp1 order by lbr_prt,m1
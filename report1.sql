USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[group_retail_sales]    Script Date: 3/19/2021 3:35:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter procedure  [reports].[group_retail_sales]
@dealer varchar(4000),
@FromDate date,
@ToDate date,
@DateRange int
as 
/*
	exec [reports].[group_retail_sales]  '500,144,157,51,170,181,184,290,317,216,70'
*/

begin

select @FromDate= (case when @DateRange =1 then  dateadd(day,-7,@ToDate)
			when @DateRange =2 then  dateadd(month,-1,@ToDate)
			when @DateRange =3 then dateadd(month,-2,@ToDate)
			when @DateRange =4 then dateadd(month,-6,@ToDate)
			when @DateRange =5 then  dateadd(year,-1,@ToDate)
			else ''
			end) 
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3
IF OBJECT_ID('tempdb..#temp4') IS NOT NULL DROP TABLE #temp4

select distinct
			--declare @count_rows int 
--select 
-- @count_rows = count(*)
--from master.fi_sales s (nolock)
--inner join master.dealer d (nolock) on s.parent_dealer_id = d.parent_dealer_id
--where (deal_status = 'Finalized' or deal_status = 'Delivered') 
--and (nuo_flag ='N' or nuo_flag = 'U')
			--,pay_type
			--,contract_type
			--,vehicle_price
			--,list_price
			--,total_accessories
			--,total_feeandaccessories
			--,total_drive_off_amount
			--,net_captilized_cost
			--,resiudal_amount
			--,service_contract_cost
			--,service_contract_reserve
			--,total_afm_cost
			--,vehicle_gross
			--,gross_cap_cost
			--,init_veh_cost
			--,deposit
		--	,(case when nuo_flag ='N' then 'New'
		--when nuo_flag='U' then 'Used'
		--when nuo_flag ='L' then 'Lease'
		--when nuo_flag is null  or nuo_flag = 'F' or nuo_flag = 'S'or nuo_flag = 'W'or nuo_flag = 'D' or nuo_flag = 'R' or nuo_flag = 'M'then 'Purchase'
		--else nuo_flag end ) as nuo_flag
--,deal_status_date
--,deal_type
--,msrp
--,total_sale_credit_amount
--,total_pickup_payment
--,total_cashdown_payment
--,total_rebate_amount
--,total_trade_allownce_amount
--,total_trade_actuval_cashvalue
--,total_trade_payoff
--,total_net_trade_amount
--,total_finance_amount
--,contract_term
--,monthly_payment
--,total_of_payments
--,ballon_payment
--,buy_rate
--,finance_apr
--,purch_optfee
--,cash
--,s.parent_dealer_id
--,@count_rows as sale_number

sale_type
,deal_status
,vehicle_cost
,total_taxes
,total_gross_profit
,backend_gross_profit
,frontend_gross_profit
,net_profit
,vin
,purchase_date
,s.natural_key
,d.dealer_name
,d.parent_dealer_id
,(case when nuo_flag = 'U' then 'Used' else 'New' end) as nuo_flag
,(vehicle_cost + total_taxes+ net_profit) as sale
,0 as sale_count
,0 as sum_cost
,0 as sum_sale
,convert(decimal(18,0),0) as total_count
,convert(decimal(18,2),0) as total_cost
,convert(decimal(18,2),0) as total_sale
into #temp
from master.fi_sales s (nolock)
inner join master.dealer d (nolock) on s.parent_dealer_id = d.parent_dealer_id
where convert(date,convert(char(8),s.purchase_date)) between @FromDate and @ToDate
and (/*deal_status = 'Finalized' or */deal_status = 'Delivered') 
and (nuo_flag ='N' or nuo_flag = 'U') and s.parent_dealer_id in (select value from [dbo].[fn_split_string_to_column] (@dealer, ','))


select natural_key, nuo_flag, sale_type, count(*) as sale_count, sum(vehicle_cost) as sum_cost, sum(sale) as sum_sale
into #temp1
from #temp
group by natural_key, nuo_flag, sale_type 

select natural_key, nuo_flag, sum(sum_cost) as total_cost, sum(sum_sale) as total_sale, sum(sale_count) as total_count
into #temp3
from #temp1
group by natural_key, nuo_flag 



update t
set 
t.sale_count = t1.sale_count,
t.sum_cost = t1.sum_cost,
t.sum_sale= t1.sum_sale,
t.total_count=t3.total_count,
t.total_cost = t3.total_cost,
t.total_sale = t3.total_sale
from #temp t left outer join #temp1 t1 on t.natural_key = t1.natural_key and t.nuo_flag = t1.nuo_flag and t.sale_type = t1.sale_type
left outer join #temp3 t3 on t.natural_key = t3.natural_key and t.nuo_flag =t3.nuo_flag


select 
natural_key
,dealer_name
,parent_dealer_id
,nuo_flag
,sale_type
,purchase_date
,vin
,deal_status
,vehicle_cost
,total_taxes
,total_gross_profit
,backend_gross_profit
,frontend_gross_profit
,net_profit
,sale
,sale_count
,sum_cost
,sum_sale
,total_count
,total_cost
,total_sale
,((total_count - sale_count)/total_count) as perc_of_tot_count
,((total_cost -sum_cost)/total_cost) as perc_of_tot_cost
,((total_sale -sum_cost)/total_sale) as perc_of_tot_sale
into #temp4
 from #temp 


 insert into #temp4 (parent_dealer_id, dealer_name, natural_key, sum_sale,nuo_flag,sale_count,sum_cost,sale_type)
 select distinct d.parent_dealer_id, d.dealer_name,isnull(d.natural_key,''), 0, 'New',0,0,'Cash' from master.dealer d(nolock) 
 left outer join #temp4 t4 on d.parent_dealer_id = t4.parent_dealer_id 
 where d.parent_dealer_id in (select value from [dbo].[fn_split_string_to_column] (@dealer, ','))
 and t4.parent_dealer_id is null


 select * from #temp4 order by parent_dealer_id


end


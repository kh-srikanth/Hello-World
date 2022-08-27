USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[group_retail_sales]    Script Date: 9/3/2021 8:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER procedure  [reports].[group_retail_sales]  
--declare  
@dealer varchar(4000) = '3407',  
@FromDate date = '2021-08-01',  
@ToDate date = '2021-08-24',  
@DateRange int = 6  
as   
/*  
 exec [reports].[group_retail_sales]  '1806','2021-04-01','2021-04-30',2  
*/  
  
begin  

	Set @daterange = (case when @daterange = null then 9 else @daterange end)
  
--declare  
--@dealer varchar(4000) = '1806',  
--@FromDate date = '2021-04-01',  
--@ToDate date = '2021-04-30',  
--@DateRange int = 6 
  
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp  
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1  
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2  
IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3  
IF OBJECT_ID('tempdb..#temp4') IS NOT NULL DROP TABLE #temp4  
IF OBJECT_ID('tempdb..#temp5') IS NOT NULL DROP TABLE #temp5  
  
	select distinct  
		s.master_fi_sales_id  
		--,s.natural_key  
		--,(case when nuo_flag = 'U' then 'Used' when nuo_flag ='N' then 'New' else ltrim(rtrim(nuo_flag)) end) as nuo_flag  
		,(case when ltrim(rtrim(s.nuo_flag)) ='N' then 'New'
				when ltrim(rtrim(s.nuo_flag))='U' then 'Used'
				When ltrim(rtrim(s.nuo_flag)) ='F' then 'Fleet'
				when ltrim(rtrim(s.nuo_flag)) ='W' then 'Wholesale'
				when ltrim(rtrim(s.nuo_flag)) ='L' then 'Lease'
				else ltrim(rtrim(s.nuo_flag)) end ) as nuo_flag

		,sale_type  
		,(case when vehicle_gross is null then (Isnull(vehicle_price,0) - Isnull(vehicle_cost, 0)) else vehicle_gross end ) as gross  
		,(case when vehicle_price is null then isnull(vehicle_cost,0) + isnull(vehicle_gross,0) else vehicle_price end) as sale  
		,((case when invoice_price is null then isnull(vehicle_cost,0) + isnull(vehicle_gross,0) else Isnull(invoice_price,0) end) - Isnull(vehicle_cost, 0) + Isnull(backend_gross_profit, 0) + Isnull(frontend_gross_profit, 0)) as  total_pvr  -- total_gross_profit
		,Isnull(backend_gross_profit, 0) as back_pvr  
		,isnull(frontend_gross_profit, 0) as front_pvr  
		,vin  
		,d.dealer_name  
		,d.parent_dealer_id  
	into 
		#temp  
	from master.fi_sales s (nolock)  
	inner join master.dealer d (nolock) on 
	s.parent_dealer_id = d.parent_dealer_id  
	where 
			convert(date,convert(char(8),s.purchase_date)) between @FromDate and @ToDate  
		and (deal_status in ('Finalized','Sold', 'Booked','Booked/Recapped' ))   
		and (ltrim(rtrim(nuo_flag)) in ('New','Used','N','U','L','F','W')) 
	and s.parent_dealer_id in (select value from [dbo].[fn_split_string_to_column] (@dealer, ','))  
   
	select   
	parent_dealer_id  
	,nuo_flag  
	,iif(sale_type='L','Lease',iif(sale_type='R','Finance',sale_type)) as sale_type  
	,count(vin) as units_st  
	,sum(gross) as total_gross_st  
	,sum(sale) as total_sale_st  
	,sum(total_pvr) as total_pvr_st  
	,sum(back_pvr) as total_back_pvr_st  
	,sum(front_pvr) as total_front_pvr_st  
	into #temp1  
	from #temp group by parent_dealer_id,nuo_flag,sale_type  
  
	select   
	parent_dealer_id  
	,nuo_flag  
	,count(vin) as units_nu  
	,sum(gross) as total_gross_nu  
	,sum(sale) as total_sale_nu  
	,sum(total_pvr) as total_pvr_nu  
	,sum(back_pvr) as total_back_pvr_nu  
	,sum(front_pvr) as total_front_pvr_nu  
	into #temp2  
	from #temp group by parent_dealer_id,nuo_flag  
  
  
  
	select   
	t1.parent_dealer_id  
	,d.dealer_name  
	,t1.nuo_flag  
	,sale_type  
	,units_st,total_gross_st,total_sale_st,total_pvr_st,total_back_pvr_st,total_front_pvr_st  
	,units_nu,total_gross_nu,total_sale_nu,total_pvr_nu,total_back_pvr_nu,total_front_pvr_nu  
	,total_sale_st/iif(total_sale_nu=0,1,total_sale_nu) as perc_sales_st  
	,total_gross_st/iif(total_gross_nu=0,1,total_gross_nu) as perc_gross_st  
	,convert(decimal(6,2),units_st)/convert(decimal(6,2),isnull(units_nu,1)) as perc_units_st  
	into #temp3  
  
	from  #temp1 t1 inner join master.dealer d (nolock) on t1.parent_dealer_id = d.parent_dealer_id  
	left outer join #temp2 t2 on t1.parent_dealer_id = t2.parent_dealer_id and t1.nuo_flag = t2.nuo_flag  
  
  
  
  
	select t3.*  
	into #temp4  
	from #temp3 t3 inner join master.dealer d (nolock) on t3.parent_dealer_id = d.parent_dealer_id  
	order by parent_dealer_id,nuo_flag,sale_type  
  
	insert into #temp4   
	(  
	parent_dealer_id, dealer_name, nuo_flag, sale_type  
	,units_st,total_gross_st,total_sale_st,total_pvr_st,total_back_pvr_st,total_front_pvr_st  
	,units_nu,total_gross_nu,total_sale_nu,total_pvr_nu,total_back_pvr_nu,total_front_pvr_nu  
	,perc_sales_st,perc_gross_st,perc_units_st  
	)  
	select   
	d.parent_dealer_id, d.dealer_name,'New','Cash'  
	,0,0,0,0,0,0  
	,0,0,0,0,0,0  
	,0,0,0  
	from master.dealer d (nolock)  
	left outer join #temp4 t4 on t4.parent_dealer_id = d.parent_dealer_id  
	 where d.parent_dealer_id in (select value from [dbo].[fn_split_string_to_column] (@dealer, ','))  
	 and t4.parent_dealer_id is null  
  
  
  
	 insert into #temp4   
	 (parent_dealer_id,dealer_name,nuo_flag,sale_type  
	,units_st,total_gross_st,total_sale_st,total_pvr_st,total_back_pvr_st,total_front_pvr_st  
	,units_nu,total_gross_nu,total_sale_nu,total_pvr_nu,total_back_pvr_nu,total_front_pvr_nu  
	,perc_sales_st,perc_gross_st,perc_units_st)  
	select   
	1,'Total',nuo_flag,sale_type  
	,sum(units_st),sum(total_gross_st),sum(total_sale_st),sum(total_pvr_st),sum(total_back_pvr_st),sum(total_front_pvr_st)  
	,sum(units_nu),sum(total_gross_nu),sum(total_sale_nu),sum(total_pvr_nu),sum(total_back_pvr_nu),sum(total_front_pvr_nu)  
	,sum(total_sale_st)/(case when sum(total_sale_nu)>0 then sum(total_sale_nu) else 1 end)    
	,sum(total_gross_st)/(case when sum(total_gross_nu)>0 then sum(total_gross_nu) else 1 end)  
	,sum(convert(decimal(18,2),units_st))/(case when sum(units_nu)>0 then sum(units_nu) else 1 end)  
	from #temp4  
	group by nuo_flag,sale_type  
  
	alter table #temp4 add ordr int  
	update #temp4 set ordr =case when dealer_name = 'Total' then 1 else 2 end  
  
	 select * 
	 from #temp4 order by parent_dealer_id,nuo_flag,sale_type  
  
end  
  
USE clictell_auto_etl
GO
/****** Object:  StoredProcedure [etl].[move_d2d_dmi_sale_raw_etl_2_stage]    Script Date: 1/7/2021 5:59:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


alter procedure  reports.salesByModel
--declare
@FromDate date = '2013-01-01',
@ToDate date = '2021-01-01',
@Make varchar(50) = 'ALL',
@Model_Year varchar(50)='ALL',
@Model varchar(10) = 'ALL',
@dealer_naturalkey varchar(20) = '3PADEV1'
as 


begin
	select 
	v.model_year
	,v.model
	,v.make
	,d.dealer_name
	,iif(s.nuo_flag='N','New',iif(s.nuo_flag='U','Used',s.nuo_flag)) as nuo_flag
	,s.purchase_date
	,s.total_gross_profit
	,s.frontend_gross_profit
	,s.backend_gross_profit
	from [master].[fi_sales] s
	inner join master.vehicle v on s.master_fi_sales_id = v.master_vehicle_id
	inner join master.customer c on s.master_fi_sales_id = c.master_customer_id
	inner join master.dealer d on s.natural_key = d.natural_key

	where 
		convert(date,convert(char(8),s.purchase_date)) between @FromDate and @ToDate
	and (@Make = 'All' or (@Make != 'All' and @Make = make))
	and (@Model = 'All' or (@Model !='All' and @Model = model))
	and (@Model_Year = 'All' or (@Model_Year!='All' and @Model_Year = model_year))
	and (@dealer_naturalkey = s.natural_key)
end

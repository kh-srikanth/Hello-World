USE clictell_auto_etl
GO
/****** Object:  StoredProcedure [etl].[move_d2d_dmi_sale_raw_etl_2_stage]    Script Date: 1/7/2021 5:59:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure  reports.Retail_Sales_Transactions
--declare
@FromDate date = '2013-01-01',
@ToDate date = '2021-01-01',
@vehicleCondition varchar(50) = 'ALL',
@vehicleMake varchar(50) = 'ALL',
@Model varchar(50)='ALL',
@Year varchar(10) = 'ALL',
@dealer_id varchar(20) = '3PADEV1'
as 


begin
	select 
	v.model_year
	,v.model
	,v.make
	,v.vehicle_mileage
	,d.dealer_name
	,s.nuo_flag
	,s.purchase_date
	,s.vehicle_cost
	,s.purchase_date as contract_date
	,c.cust_dms_number
	,c.cust_first_name
	,c.cust_last_name
	,s.sale_type
	,s.finance_apr
	,s.monthly_payment
	,s.contract_term
	,s.total_trade_actuval_cashvalue
	,p.sale_full_name
	,s.total_gross_profit
	,s.frontend_gross_profit
	,s.backend_gross_profit
	from [master].[fi_sales] s
	inner join master.vehicle v on s.master_fi_sales_id = v.master_vehicle_id
	inner join master.customer c on s.master_fi_sales_id = c.master_customer_id
	inner join master.dealer d on s.natural_key = d.natural_key
	inner join master.fi_sales_people p on s.master_fi_sales_id = p.master_fi_sales_id
	where 
		convert(date,convert(char(8),s.purchase_date)) < @FromDate 
	and convert(date, convert(char(8),s.purchase_date)) > @ToDate
	and (@vehicleCondition = 'All' or (@vehicleCondition != 'All' and nuo_flag = @vehicleCondition))
	and (@vehicleMake = 'All' or (@vehicleMake != 'All' and @vehicleMake = make))
	and (@Model = 'All' or (@Model !='All' and @Model = model))
	and (@Year = 'All' or (@Year!='All' and @Year = model_year))
	and (@dealer_id = s.natural_key)
end
--select * from master.fi_sales
--select * from master.customer
--select * from master.vehicle
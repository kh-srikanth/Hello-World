USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [etl].[load_cdk_lite_customer_vehicle]    Script Date: 12/16/2021 2:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [etl].[load_cdk_lite_customer_vehicle]
    @file_process_id int 
AS

BEGIN

	drop table if exists #service_sales
	drop table if exists #rnk_service_sales
	drop table if exists #customer_vehicle
	drop table if exists #result
	drop table if exists #rnk_insert

	declare @dealer_id int = (select parent_dealer_id from clictell_auto_master.master.dealer (nolock) where natural_key = '76024859')

	print 'Inserting customer.vehicle into #customer_vehicle'
	select * into #customer_vehicle from auto_customers.customer.vehicles (nolock) where dealer_id <> @dealer_id
	alter table #customer_vehicle add default newid() for vehicle_guid
	alter table #customer_vehicle add default 'system' for created_by
	alter table #customer_vehicle add default 'system' for updated_by
	alter table #customer_vehicle add default getdate() for created_dt
	alter table #customer_vehicle add default getdate() for updated_dt
	alter table #customer_vehicle add default 0 for is_deleted

	print'loading etl service data to #service considering valid VIN'
	select distinct
			 c.customer_id as customer_id
			,a.parent_dealer_id
			,d._id as account_id
			,a.Class as body_style
			,a.closedate as date
			,a.odometer as delivery_mileage
			,a.Engineno as  engine_number
			,null as fuel_type
			,null as color
			,null as plateno
			,a.Make
			,a.Model
			,a.Year
			,salestype as salesType
			,null as Newused
			,a.StockNumber as vehicle_stock
			,a.VIN
			,a.closedate as last_service_date
			,'service' as source
			,status as deal_status
			,null as purchase_date
		into #service_sales
	from clictell_auto_etl.etl.cdkLgt_Service_Details a(nolock)
	inner join clictell_auto_master.master.dealer d (nolock) on a.parent_dealer_id = d.parent_dealer_id
	inner join [auto_customers].[customer].[customers] c (nolock) on d._id = c.account_id and a.custID = c.src_cust_id
	where 
			 len(a.vin) <> 0 
			 and len(a.vin) <=17 
			 and a.file_process_id = @file_process_id

	 union 

	 select distinct
			 c.customer_id as customer_id
			,a.parent_dealer_id
			,d._id as account_id
			,a.bodytype as body_style
			,a.DeliveryDate
			,a.Odometer
			,a.enginenumber
			,a.fueltype
			,a.Color as color
			,a.plateno
			,a.Make
			,a.Model
			,a.Year
			,a.SalesType
			,a.Newused
			,a.stocknumber
			,a.VIN
			,null as last_service_date
			,'sale' as source
			,dealstate as deal_status
			,a.DeliveryDate as purchase_date

	from clictell_auto_etl.etl.cdkLgt_Deals_Details a (nolock)
	inner join clictell_auto_master.master.dealer d (nolock) on a.parent_dealer_id = d.parent_dealer_id
	inner join [auto_customers].[customer].[customers] c (nolock) on d._id = c.account_id and a.custID = c.src_cust_id
	where 
			 len(a.vin) <> 0 
			 and len(a.vin) <=17 
			 and a.file_process_id = @file_process_id


	select *, 1 as is_active into #rnk_service_sales from 
		(select *,ROW_NUMBER() over (partition by VIN,customer_id,source order by [date] desc,delivery_mileage desc, customer_id desc,vehicle_stock desc) as rnk  from #service_sales) a 
	where rnk =1 order by VIN

	select *, ROW_NUMBER() over (partition by vin,customer_id order by date desc) as rnk_ins into #rnk_insert from #rnk_service_sales

	insert into #customer_vehicle

	(
			customer_id
			,dealer_id
			,account_id
			,body_style
			,delivery_date
			,delivery_mileage
			,engine_number
			,engine_type
			,exterior_color
			,license_plate_no
			,make
			,model
			,year
			,sale_classs
			,vehicle_status
			,vehicle_stock
			,vin
			,last_service_date
			,src
			,deal_status
			,is_active
			,purchase_date
	)

	select distinct
			a.customer_id
			,a.parent_dealer_id
			,a.account_id
			,a.body_style
			,convert(date,a.date) as date
			,a.delivery_mileage
			,a.engine_number
			,a.fuel_type
			,a.color as color
			,a.plateno
			,a.Make
			,a.Model
			,a.Year
			,a.salesType as salesType
			,a.Newused
			,a.vehicle_stock
			,a.VIN
			,case when a.last_service_date like '1000-01-01%' then '1900-01-01' else a.last_service_date end  as last_service_date
			,a.source
			,a.deal_status
			,a.is_active
			,convert(date,a.purchase_date) as purchase_date


	from #rnk_insert a
	left outer join #customer_vehicle b on a.vin = b.vin and a.customer_id = b.customer_id and a.parent_dealer_id = b.dealer_id
	where 
			b.vehicle_id is null 
			and a.rnk_ins =1
	order by 
			a.vin

	update b set 
			b.customer_id = a.customer_id
			,b.delivery_date = convert(date,a.date)
			,b.vehicle_status = a.Newused
			,b.last_service_date = iif(a.source = 'service',a.last_service_date,b.last_service_date)
			,b.purchase_date = iif(a.source = 'sale',a.purchase_date,b.purchase_date)
			,b.src = a.source
			,b.deal_status = a.deal_status
			,b.ro_date = b.last_service_date
	from #rnk_insert a
	inner join #customer_vehicle b on a.vin = b.vin and a.customer_id = b.customer_id and a.parent_dealer_id = b.dealer_id
	where a.rnk_ins <> 1

	update #customer_vehicle set delivery_date = 
			case when purchase_date > last_service_date or last_service_date is null then purchase_date 
				 when last_service_date >= purchase_date or purchase_date is null then last_service_date 
				 end
	where dealer_id  = @dealer_id


	select *,ROW_NUMBER() over (partition by vin order by delivery_date desc,delivery_mileage desc,customer_id desc) as rnk  into #result from #customer_vehicle order by vin

	update a set is_active =0
	from #customer_vehicle a 
	inner join #result b on a.customer_id = b.customer_id and a.vin = b.vin
	where b.rnk > 1

	--select customer_id,vin,ro_date,delivery_date,last_service_date,purchase_date,src,is_active from #customer_vehicle where dealer_id =1600
	--select customer_id,vin,ro_date,delivery_date,last_service_date,purchase_date,src,is_active from auto_customers.customer.vehicles (nolock) where dealer_id = 1600

	update b set 
	--select 
	-- b.customer_id		,	 a.customer_id
	--,b.dealer_id		,	a.dealer_id
	--,b.account_id		,	a.account_id,
	 b.body_style		=	a.body_style
	,b.delivery_date	=	a.delivery_date
	,b.delivery_mileage	=	a.delivery_mileage
	,b.engine_number	=	a.engine_number
	,b.engine_type		=	a.engine_type
	,b.exterior_color	=	a.exterior_color
	,b.license_plate_no	=	a.license_plate_no
	,b.make				=	a.make
	,b.model			=	a.model
	,b.year				=	a.year
	,b.sale_classs		=	a.sale_classs
	,b.vehicle_status	=	a.vehicle_status
	,b.vehicle_stock	=	a.vehicle_stock
	,b.vin				=	a.vin
	,b.is_deleted		=	a.is_deleted
	,b.src				=	a.src
	,b.deal_status		=	a.deal_status
	,b.is_active		=	a.is_active
	,b.purchase_date	=	a.purchase_date
	,b.ro_date			=	a.ro_date
	,b.last_service_date=	a.last_service_date


	from #customer_vehicle a
	inner join auto_customers.customer.vehicles b (nolock) on a.account_id =b.account_id and a.customer_id = b.customer_id and a.vin = b.vin



	insert into auto_customers.customer.vehicles 
	(
			customer_id
			,dealer_id
			,account_id
			,body_style
			,delivery_date
			,delivery_mileage
			,engine_number
			,engine_type
			,exterior_color
			,license_plate_no
			,make
			,model
			,year
			,sale_classs
			,vehicle_status
			,vehicle_stock
			,vin
			,is_deleted
			,src
			,deal_status
			,is_active
	)
	select 
			 a.customer_id
			,a.dealer_id
			,a.account_id
			,a.body_style
			,a.delivery_date
			,a.delivery_mileage
			,a.engine_number
			,a.engine_type
			,a.exterior_color
			,a.license_plate_no
			,a.make
			,a.model
			,a.year
			,a.sale_classs
			,a.vehicle_status
			,a.vehicle_stock
			,a.vin
			,a.is_deleted
			,a.src
			,a.deal_status
			,a.is_active


	from #customer_vehicle a
	left outer join auto_customers.customer.vehicles b (nolock) on a.account_id =b.account_id and a.customer_id = b.customer_id and a.vin = b.vin
	where 
		b.vehicle_id is null


END
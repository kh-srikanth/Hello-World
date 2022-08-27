USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [etl].[load_cdk_lite_etl_customer]    Script Date: 12/10/2021 4:21:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [etl].[load_cdk_lite_customer_vehicle]
    @file_process_id int 
AS

BEGIN

drop table if exists #service_sales
drop table if exists #rnk_service_sales
drop table if exists #customer_vehicle

print 'Inserting customer.vehilce into #customer_vehicle'
select *,cast(null as varchar(10)) as src,cast(null as varchar(100)) as deal_status into #customer_vehicle from auto_customers.customer.vehicles (nolock)
truncate table #customer_vehicle


print'loading etl service data to #service considering valid VIN'
select distinct
		 c.customer_id as cust_id
		,NEWID() as vehicle_guid
		,a.parent_dealer_id
		,trim(a.Class) as body_style
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
		,null as last_service_date
		,0 as is_deleted
		,convert(date,getdate()) as created_dt
		,convert(date,getdate()) as updated_dt
		,SUSER_NAME() as created_by
		,suser_name() as updated_by
		,'sales' as source
		,status as deal_status
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
		 c.customer_id as cust_id
		,newid() as vehicle_guid
		,a.parent_dealer_id
		,left(trim(a.bodytype),20) as body_style
		,a.DeliveryDate
		,a.Odometer
		,a.enginenumber
		,a.fueltype
		,left(trim(a.Color),20) as color
		,a.plateno
		,a.Make
		,a.Model
		,a.Year
		,a.SalesType
		,a.Newused
		,a.stocknumber
		,a.VIN
		,null as last_service_date
		,0 as is_deleted
		,getdate() as created_dt
		,getdate() as updated_dt
		,SUSER_NAME() as created_by
		,suser_name() as updated_by
		,'service' as source
		,dealstate as deal_status

from clictell_auto_etl.etl.cdkLgt_Deals_Details a (nolock)
inner join clictell_auto_master.master.dealer d (nolock) on a.parent_dealer_id = d.parent_dealer_id
inner join [auto_customers].[customer].[customers] c (nolock) on d._id = c.account_id and a.custID = c.src_cust_id
where 
		 len(a.vin) <> 0 
		 and len(a.vin) <=17 
		 and a.file_process_id = @file_process_id




 select * into #rnk_service_sales from 
	(select *,ROW_NUMBER() over (partition by VIN order by last_service_date desc,cust_id desc,vehicle_stock desc) as rnk  from #service_sales) a 
where rnk =1 order by VIN





insert into #customer_vehicle

(
		customer_id
		,vehicle_guid
		,dealer_id
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
		,is_deleted
		,created_dt
		,updated_dt
		,created_by
		,updated_by
		,src
		,deal_status
)

select 
		a.cust_id
		,a.vehicle_guid
		,a.parent_dealer_id
		,a.body_style
		,convert(date,a.date) as date
		,a.delivery_mileage
		,a.engine_number
		,a.fuel_type
		,a.color
		,a.plateno
		,a.Make
		,a.Model
		,a.Year
		,left(a.salesType,15) as salesType
		,a.Newused
		,a.vehicle_stock
		,a.VIN
		,a.last_service_date
		,a.is_deleted
		,a.created_dt
		,a.updated_dt
		,a.created_by
		,a.updated_by
		,a.source
		,a.deal_status


from #rnk_service_sales a
left outer join #customer_vehicle b on a.vin = b.vin and a.cust_id = b.customer_id and a.parent_dealer_id = b.dealer_id

where 
		b.vehicle_id is null
order by a.vin


select * from #customer_vehicle
--update b set 
select 
		b.vin, a.vin
		,b.customer_id , a.cust_id
		,b.delivery_date , a.date
		,b.vehicle_status , a.Newused
		,b.last_service_date , a.last_service_date
		,b.src , a.source
		,b.deal_status , a.deal_status
from #rnk_service_sales a
inner join #customer_vehicle b on a.vin = b.vin and a.cust_id = b.customer_id --and a.parent_dealer_id = b.dealer_id
order by a.vin

 --select * from clictell_auto_etl.etl.cdkLgt_Deals_Details a (nolock)

 END
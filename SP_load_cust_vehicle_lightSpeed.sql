use clictell_auto_etl
GO

drop table if exists #service
drop table if exists #sales
drop table if exists #rnk_sales
drop table if exists #rnk_service
drop table if exists #customer_vehicle

BEGIN


print 'Inserting customer.vehilce into #customer_vehicle'
select * into #customer_vehicle from auto_customers.customer.vehicles (nolock)
truncate table #customer_vehicle


print'loading etl service data to #service considering valid VIN'
select distinct
		 a.CustID
		,a.parent_dealer_id as dealer_id
		,a.Class as body_style
		,a.Odometer as delivery_mileage
		,a.Engineno as engine_number
		,a.Make
		,a.Model
		,a.Year
		--,a.SourceCode
		,a.StockNumber as vehicle_stock
		,a.VIN
		--,a.Price
		,convert(date,convert(varchar(30),a.closedate)) as ro_date
		,convert(date,convert(varchar(30),a.previousinvoicedate)) as last_service_date
		,a.Odometer as miles_ridden
	into #service
from clictell_auto_etl.etl.cdkLgt_Service_Details a(nolock)
where 
 len(a.vin) <> 0 and len(a.vin) <=17 


 print'loading etl service data to #sales considering valid VIN'

select distinct
		CustID
		,parent_dealer_id as dealer_id
		,a.bodytype
		,convert(date,convert(varchar(25),a.DeliveryDate)) as DeliveryDate
		,a.Odometer
		,a.enginenumber
		,a.fueltype
		,a.Color
		,a.plateno
		,a.Make
		,a.Model
		,a.Year
		,a.SalesType
		,a.sourceprospectid
		,a.source
		,a.Newused
		,a.stocknumber
		,a.VIN
		--,a.Price

	into #sales
from clictell_auto_etl.etl.cdkLgt_Deals_Details a (nolock)
where 
 len(a.vin) <> 0 and len(a.vin) <=17 



 select * from #service order by vin
print 'giving rank to service and sales date to get latest and unique vin data '
select * into #rnk_service from 
	(select *,ROW_NUMBER() over (partition by VIN order by last_service_date desc,CustID desc,vehicle_stock desc) as rnk  from #service) a 
where rnk =1

select * into  #rnk_sales from 
	(select *, ROW_NUMBER() over (partition by vin order by DeliveryDate desc, CustID desc,stocknumber desc ) as rnk  from #sales ) a 
where rnk =1




print 'inserting data to mater table from sales '
insert into #customer_vehicle
(
		src_cust_id
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
		--,source_code_value
		--,source_code_description
		,vehicle_status
		,vehicle_stock
		,vin
		,is_deleted
		,created_dt
		,updated_dt
		,created_by
		,updated_by
)
select 
		CustID
		,newid()
		,a.dealer_id
		,left(trim(a.bodytype),20) as body_style
		,a.DeliveryDate
		,a.Odometer
		,a.enginenumber
		,a.fueltype
		,left(trim(a.Color),20)
		,a.plateno
		,a.Make
		,a.Model
		,a.Year
		,a.SalesType
		--,a.sourceprospectid
		--,a.source
		,a.Newused
		,a.stocknumber
		,a.VIN
		,0
		,convert(date,getdate())
		,convert(date,getdate())
		,SUSER_NAME()
		,suser_name()

from #rnk_sales a
left outer join auto_customers.customer.vehicles  b(nolock) 
				on 
					 a.CustID = b.src_cust_id 
					and a.vin = b. vin 

where b.vehicle_id is null 

print 'inserting data to mater table from service '

insert into #customer_vehicle 
(
		customer_id
		,vehicle_guid
		,dealer_id
		,body_style
		,delivery_mileage
		,engine_number
		,make
		,model
		,year
		--,source_code_value
		,vehicle_stock
		,vin
		--,price
		,ro_date
		,last_service_date
		,miles_ridden
		,is_deleted
		,created_dt
		,updated_dt
		,created_by
		,updated_by

)

select 
		 isnull(a.CustID,0)
		,NEWID()
		,a.dealer_id
		,trim(a.body_style) as body_style
		,a.delivery_mileage
		,a.engine_number
		,a.Make
		,a.Model
		,a.Year
		--,a.SourceCode
		,a.vehicle_stock
		,a.VIN
		--,a.Price
		,iif(convert(date,a.ro_date) < = '1000-01-01', '1900-01-01',convert(date,a.ro_date))
		,convert(date,a.last_service_date)
		,a.miles_ridden
		,0
		,convert(date,getdate())
		,convert(date,getdate())
		,SUSER_NAME()
		,suser_name()

from #rnk_service a
left outer join auto_customers.customer.vehicles  b(nolock) 
					on 1=1
						and a.CustID = b.src_cust_id
						and a.vin = b. vin
where b.vehicle_id is null 

return;
select * from #rnk_sales where vin = '1fdxe459cda00000'
select * from #rnk_service where vin = '1fdxe459cda00000'

select * from #customer_vehicle where vin = '1fdxe459cda00000'



--update b set
select 
	 b.delivery_date , a.DeliveryDate
	,b.delivery_mileage , a.Odometer
	,b.sale_classs , a.SalesType
	,b.vehicle_status , a.Newused
	,b.updated_dt , convert(date,getdate())
	,b.updated_by , SUSER_NAME()

from #rnk_sales a 
inner join #customer_vehicle b on a.CustID = b.customer_id and a.vin  = b.vin --and a.dealer_id = b.dealer_id
where 1=1
--and a.rnk =1 
--and b.vehicle_id is not null
order by a.vin

--update b set 
select 
	 b.delivery_mileage , a.delivery_mileage 
	,b.ro_date			, a.ro_date
	,b.last_service_date , a.last_service_date
	,b.updated_dt		, convert(date,getdate())
	,b.updated_by		, SUSER_NAME()
	,b.customer_id , a.CustID
	,b.vin ,a.vin

from #rnk_service a 
inner join #customer_vehicle b on a.CustID = b.customer_id and a.VIN = b.vin --and a.dealer_id = b.dealer_id
where 1=1
--and a.rnk=1
--and b.vehicle_id is not null
order by a.vin


END


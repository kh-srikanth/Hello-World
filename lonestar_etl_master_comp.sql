use auto_customers
select a.customer_id,first_name,primary_phone_number,secondary_phone_number,primary_email
,b.vin,make,model,year,ro_date,last_service_date,purchase_date,is_valid_vin
from auto_customers.customer.customers a (nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_Deleted =0
and a.account_id = '2928eacc-a39d-4743-bf02-f9689f16e79f'
and (isnull(last_service_date ,getdate()) >= '05-01-2022' or isnull(purchase_date,getdate()) >= '05-01-2022')



select convert(date,last_service_date) as last_service_date,count(*) as number_of_services
from auto_customers.customer.customers a (nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_Deleted =0 and b.is_deleted =0
and a.account_id = '2928eacc-a39d-4743-bf02-f9689f16e79f'
and isnull(last_service_date,b.created_dt) >= '05-01-2022'
group by  convert(date,last_service_date)
order by convert(date,last_service_date)




select convert(date,purchase_date) as purchase_date,count(*) as number_of_sales
from auto_customers.customer.customers a (nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_Deleted =0 and b.is_deleted =0
and a.account_id = '2928eacc-a39d-4743-bf02-f9689f16e79f'
and isnull(purchase_date,b.created_dt) > '05-01-2022'
group by  convert(date,purchase_date)
order by convert(date,purchase_date)



select top 10 * from auto_customers.customer.vehicles b (nolock)


select --167closedate,pudate,custID,rono,vin,case when isdate(closedate) = 0 then pudate else  closedate end as last_ro_date,convert(date,created_dt) as created_dt,custID,ronofrom clictell_auto_etl.[etl].[cdkLgt_Service_Details] a (nolock)where  parent_dealer_id = 4538and (case when isdate(closedate) = 0 then convert(date,pudate) else  convert(date,closedate) end) >= '5/1/2022'order by a.created_dtselect   --84
	convert(date,last_service_date) as last_service_date
	,convert(date,b.created_dt) as created_dt
	,convert(date,b.updated_dt) as updated_dt
	,ro_number,src_cust_id,vin
from auto_customers.customer.customers a (nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_Deleted =0 and b.is_deleted =0
and a.account_id = '2928eacc-a39d-4743-bf02-f9689f16e79f'
and isnull(last_service_date,b.created_dt) >= '05-01-2022'order by b.updated_dtselect   --90
distinct
	convert(date,last_service_date) as last_service_date
	,convert(date,b.created_dt) as created_dt
	,convert(date,b.updated_dt) as updated_dt
	,ro_number,src_cust_id,vin
from auto_customers.customer.vehicles b (nolock)
left join auto_customers.customer.customers a (nolock) on a.customer_id = b.customer_id
where 
a.is_Deleted =0 and b.is_deleted =0
and a.account_id = '2928eacc-a39d-4743-bf02-f9689f16e79f'
and last_service_date >= '05-01-2022'order by b.updated_dtselect --90distinct custID,rono,vinfrom clictell_auto_etl.[etl].[cdkLgt_Service_Details] a (nolock)where  parent_dealer_id = 4538and (case when isdate(closedate) = 0 then convert(date,pudate) else  convert(date,closedate) end) >= '05-01-2022'order by custIDselect a.custID,b.src_cust_id,a.created_dt,a.closedate,a.pudate,a.rono,a.vin,b.vin,b.last_service_date,b.ro_datefrom  clictell_auto_etl.[etl].[cdkLgt_Service_Details] a (nolock)left outer join (select a.customer_id,b.vehicle_id,a.src_cust_id,vin,last_service_date,b.ro_date,ro_number from auto_customers.customer.customers a (nolock)
				inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
				where 
				a.is_Deleted =0 and b.is_deleted =0
				and a.account_id = '2928eacc-a39d-4743-bf02-f9689f16e79f'
				and last_service_date >= '05-01-2022') as b  on  a.custID = b.src_cust_idwhere b.vehicle_id is nulland parent_dealer_id = 4538and(case when isdate(a.closedate) = 0 then convert(date,a.pudate) else  convert(date,a.closedate) end) >= '5/1/2022'select   --84
	convert(date,last_service_date) as last_service_date
	,count(*) as number_of_services
from auto_customers.customer.customers a (nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_Deleted =0 and b.is_deleted =0
and a.account_id = '2928eacc-a39d-4743-bf02-f9689f16e79f'
and isnull(last_service_date,b.created_dt) >= '05-01-2022'
group by  convert(date,last_service_date)
order by convert(date,last_service_date)

select src_cust_id,last_service_date,ro_date,b.created_dt,b.updated_dt from 
auto_customers.customer.vehicles a (nolock)
left outer join auto_customers.customer.customers b (nolock)
 on a.customer_id = b.customer_id
where src_cust_id in (
9090669
,9138167
,9139350
,9003111
)

select custID,pudate,closedate,created_dt,updated_dt
from  clictell_auto_etl.[etl].[cdkLgt_Service_Details] a (nolock)
where custID  in (
9090669
,9138167
,9139350
,9003111
)



select last_service_date,ro_date,purchase_Date,a.src_cust_id,vehicle_id,b.customer_id,vin,make,model,b.is_deleted 
from auto_customers.customer.customers a (nolock)
right outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where b.vin ='JYARN48E8JA001890'

a.src_cust_id  = 9090669


select closedate,pudate,rono,vin,file_process_id from   clictell_auto_etl.[etl].[cdkLgt_Service_Details] a (nolock) where custID = 9090669
	select distinct a.DealNo,
			case when isdate(a.DeliveryDate) = 0 then null else DeliveryDate end as DeliveryDate
			, a.CustID, Units,
		Json_Value(b.[value], '$.DealUnitid') as DealUnitID,
		Json_Value(b.[value], '$.Newused') as Newused,
		Json_Value(b.[value], '$.Year') as [ModelYear],
		Json_Value(b.[value], '$.Make') as Make,
		Json_Value(b.[value], '$.Model') as Model,
		Json_Value(b.[value], '$.VIN') as VIN,
		Json_Value(b.[value], '$.Class') as Class,
		Json_Value(b.[value], '$.SalesType') as SalesType,
		Json_Value(b.[value], '$.Color') as Color,
		Json_Value(b.[value], '$.Odometer') as Odometer,
		Json_Value(b.[value], '$.bodytype') as bodytype,
		Json_Value(b.[value], '$.cylinders') as cylinders,
		Json_Value(b.[value], '$.plateno') as plateno,
		'sales' as source
		,parent_dealer_id, file_process_id, file_process_detail_id
	from
		clictell_auto_etl.[etl].[cdkLgt_Deals_Details] a(nolock)
	Cross Apply OpenJson(Units) b
	where custID = 9090669

select * from 	[etl].[cdkLgt_Deals_Details] a(nolock)




select last_service_date,ro_date,purchase_Date,a.customer_id,vehicle_id,vin,make,model,b.is_deleted 
from auto_customers.customer.customers a (nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where a.is_deleted =0 and b.is_deleted =1


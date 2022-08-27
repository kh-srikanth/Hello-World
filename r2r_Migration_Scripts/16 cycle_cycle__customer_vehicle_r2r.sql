use [auto_customers]
go

insert into [customer].[vehicles]
(

vehicle_guid
,customer_id
,check_sum
,dealer_id
,account_id
,inventory_account
,app_error_no
,app_error_text
,axle_code
,axcle_count
,body_style
,brake_system
,cab_type
,certified_preowned_ind
,certified_preowned_number
,chassis
,delivery_date
,delivery_mileage
,doors_quantity
,engine_number
,engine_type
,exterior_color
,fleet_customer_vehicles_id
,front_tire_code
,gmrpo_code
,ignition_key_number
,interior_color
,license_plate_no
,make
,model
,year
,make_id
,make_model_id
,model_year_id
,number_of_engine_cylinders
,odometer_status
,rear_tire_code
,restraint_system
,sale_classs
,sale_class_value
,source_code_value
,source_code_description
,standard_equipment
,sticker_number
,transmission_type
,trim_code
,vehicle_status
,vehicle_stock
,vehicle_weight
,vin
,warranty_exp_date
,wheel_base
,vehicle_pricing_type
,price
,ro_date
,purchase_date
,last_service_date
,is_deleted
,created_dt
,created_by
,updated_dt
,updated_by
--,photo
--,photo_path
--,name
--,brand_id
--,model_id
--,identity_number
--,tire_size
--,tire_install_date
--,tire_pressure
--,riding_style_id
--,last_oil_change
--,is_default
,r2r_vehicle_id
)

select
a.cycle_guid as vehicle_guid
,b.customer_id as customer_id 
,null as check_sum
,c.account_id as dealer_id  
,c._id as account_id
,null as inventory_amount
,null as app_error_no
,null as app_error_text
,null as axle_code
,null as axle_count
,null as body_style
,null as break_system
,(case when category_id = 1 then 'Roadster'
	when category_id = 2  then 'Cruiser'
	when category_id = 3 then 'Sport bike'
	when category_id = 4  then 'Touring'
	when category_id = 5 then 'Sport touring'
	when category_id = 6  then 'Dual-sport'
	when category_id = 7 then 'Off-Road'
	when category_id = 8  then 'Watercraft'
	when category_id = 9  then 'Other'
	end) as cab_type
,null as certified_preowned_ind
,null as certiifed_preowned_number
,null as chassis
,null as delivery_date
,a.odometer_reading as delivery_mileage
,null as doors_quantity
,null as engine_number
,null as engine_type
,null as exterior_color
,null as fleet_customer_vehicle_id
,null as front_tire_code
,null as gmrpo_code
,null as ignition_key_number
,null as interior_color
,null as lisence_plate_no
,a.brand as make
,a.model
,(Case when Isnumeric(a.[year]) = 1 then a.[year] else null end) as [year]
,null as make_id
,null as make_model_id
,null as model_year_id
, null as number_of_engine_cylinders
,null as odometer_status
,null as rear_tire_code
,null as restraint_system
,null as sale_classs
,null as sale_class_value
,null as source_code_value
,null as source_code_description
,null as standard_equipment
,null as sticker_number
,null as transission_type
,null as trim_code
,null as vehicle_status
,null as vehicle_stock
,null as vehicle_weight
,substring(a.vin, 1, 20) as vin
,null as warranty_exp_date
,null as wheel_base
,null as vehicle_pricing_type
,null as price
,null as ro_date
,a.purchase_date
,a.last_service as last_service_date
,a.is_deleted
,a.created_dt
,Isnull(a.created_by, 'system')
,a.updated_dt
,Isnull(a.updated_by, 'system')
--,a.photo
--,a.photo_path
--,a.name
--,a.brand_id
--,a.model_id
--,a.identity_number
--,a.tire_size
--,a.tire_install_date
--,a.tire_pressure
--,a.riding_style_id
--,a.last_oil_change
--,a.is_default
,a.cycle_id
--into #temp_cust_vehicle1
from [18.216.140.206].[r2r_admin].[cycle].[cycle] a with (nolock)
inner join [customer].[customers] b (nolock) on a.owner_id = b.r2r_customer_id
inner join [portal].[account] c (nolock) on a.dealer_id = c.r2r_dealer_id
--left outer join [18.216.140.206].[r2r_admin].[cycle].[year] e with (nolock) on a.[year] = Cast(e.[year_id] as varchar(10))
left outer join [customer].[vehicles] d (nolock) on a.cycle_id = d.r2r_vehicle_id
where a.dealer_id in (select r2r_dealer_id from auto_portal.portal.account with (nolock) where r2r_dealer_id is not null and lower(accountstatus) = 'active')
and d.vehicle_id is null
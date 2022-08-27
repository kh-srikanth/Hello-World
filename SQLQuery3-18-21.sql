select * from master.repair_order_header_detail
select vin,last_ro_date from master.vehicle
select vin,last_ro_date from master.cust_2_vehicle


select 
v.vin,v.last_ro_date,c.vin,c.last_ro_date
from master.vehicle v inner join master.cust_2_vehicle c on v.vin = c.vin


select file_process_id,* from stg.service_ro_operations
select top 10 parent_dealer_id,* from master.repair_order_header
update stg.service_ro_operations set parent_dealer_id = 500

select * from stg.service_ro_operations a inner join master.repair_order_header b on a.parent_dealer_id = b.parent_dealer_id

select * from master.ro_parts_details

select * from stg.service_ro_parts
update stg.service_ro_parts set parent_dealer_id =500

select part_number, part_desc,* from master.ro_parts_details order by master.ro_parts_details.part_number

select total_actual_labor_hours,total_billed_labor_hours	 from master.repair_order_header

select ro_number,* from master.repair_order_header_detail

select part_number,part_desc,rh.ro_number,indv_unit_part_cost,indv_unit_part_sale
	from master.repair_order_header rh
	left outer join master.ro_parts_details pd on rh.ro_number = pd.ro_number order by ro_number

	

	select ro_number, count(*) from master.ro_parts_details (nolock) group by ro_number having count(*) > 1
	order by 2 desc
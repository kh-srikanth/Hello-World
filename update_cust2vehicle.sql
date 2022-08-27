select last_sale_date, * from stg.fi_sales

use clictell_auto_etl
select * from etl.cdk_sales1
select date ,* from etl.cdk_sales2
select * from etl.cdk_sales3
use clictell_auto_master
select * from master.fi_sales_trade_vehicles

use clictell_auto_master
select distinct cust_dms_number, vin,* from master.cust_2_vehicle
select delivery_date,close_deal_date,purchase_date,deal_date,deal_status_date,termination_date from master.fi_sales where cust_dms_number is not null

select * from master.fi_sales


update c
set 


c.last_sale_date = iif(s.purchase_date is null,s.deal_date,s.purchase_date) 

from master.cust_2_vehicle c (nolock)
inner join master.fi_sales s (nolock) on c.master_customer_id = s.master_customer_id and c.master_vehicle_id = s.master_vehicle_id
where c.file_process_id = s.file_process_id




select * from master.cust_2_vehicle

select vin, ro_open_date,ro_close_date from master.repair_order_header order by vin

select 
c.first_ro_date
s.ro_open_date
,c.last_ro_date

from master.cust_2_vehicle c
inner 




select ro_number from master.repair_order_header where vin ='1D4GP24R97B103918'

select ro_number, min(ro_open_date) from master.repair_order_header group by ro_number
select ro_number, ro_open_date from master.repair_order_header


select a.master_ro_header_id,min(b.ro_open_date),max(b.ro_open_date) from master.repair_order_header a inner join master.repair_order_header b on a.master_customer_id = b.master_customer_id and a.vin = b.vin
where
a.ro_open_date < b.ro_open_date
group by a.master_ro_header_id
order by master_ro_header_id

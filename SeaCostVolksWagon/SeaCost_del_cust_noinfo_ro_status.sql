select 
master_customer_id,cust_first_name,cust_last_name,cust_address1,cust_address2,cust_mobile_phone,cust_home_phone,cust_email_address1,cust_email_address2
--update a set is_deleted =1,updated_by = 'sk_invalid_address', updated_date = getdate()  --4029/1473
from clictell_auto_master.master.customer a (nolock) 
where is_deleted =0 and parent_dealer_id  = 4592
and clictell_auto_etl.dbo.isphonenovalid(cust_mobile_phone) =0
and clictell_auto_etl.dbo.isphonenovalid(cust_home_phone) =0
and clictell_auto_etl.dbo.isvalidemail(cust_email_address1) = 0
and clictell_auto_etl.dbo.isvalidemail(cust_email_address2) = 0
and len(cust_address1) = 0
order by cust_address1

select top 10 * from clictell_auto_master.master.customer a (nolock) 


select top 10 * from clictell_auto_master.master.dealer (nolock) where dealer_name like 'sea%'


select 
master_customer_id,cust_first_name,cust_last_name,cust_address1,cust_address2,cust_mobile_phone,cust_home_phone,cust_email_address1,cust_email_address2
--update a set is_deleted =1,updated_by = 'sk_invalid_address', updated_date = getdate()  --4029/1473
from clictell_auto_master.master.customer b (nolock) 
where 
	is_deleted =0 
	and parent_dealer_id  = 4592
	and Len(Isnull(b.[cust_mobile_phone],'')) = 0
	and Len(Isnull(b.[cust_home_phone],'')) = 0
	and Len(Isnull(b.[cust_work_phone],'')) = 0



select 
master_customer_id,cust_first_name,cust_last_name,cust_address1,cust_address2,cust_mobile_phone,cust_home_phone,cust_email_address1,cust_email_address2
--update a set is_deleted =1,updated_by = 'sk_invalid_address', updated_date = getdate()  --4029/1473
from clictell_auto_master.master.customer b (nolock) 
where 
	is_deleted =0 
	and parent_dealer_id  = 4592
	and cust_first_name is null
	and cust_last_name is null
	and cust_email_address1 is null
	and cust_email_address2 is null

	select * from clictell_auto_master.master.vehicle (nolock) where vin = 'WVGRMPE21NP044291'
	select * from clictell_auto_master.master.cust_2_vehicle (nolock) where master_vehicle_id = 192439 

	select is_deleted,* from clictell_auto_master.master.customer b (nolock) where parent_dealer_id = 4592 and cust_dms_number in ('22253','22246')


		select * 
		--update a set is_deleted =1, update_by = 'sk_invalid',update_date = getdate()
		from clictell_auto_master.master.cust_2_vehicle a (nolock) where  cust_vehicle_id = 209578



select 
b.master_customer_id,cust_first_name,cust_last_name,cust_address1,cust_address2,cust_mobile_phone,cust_home_phone,cust_work_phone,cust_email_address1,cust_email_address2

--update c set is_deleted =1, update_by = 'sk_no_cust_detail',update_date = getdate()
from clictell_auto_master.master.customer b (nolock)
inner join  clictell_auto_master.master.cust_2_vehicle (nolock) c on b.master_customer_id = c.master_customer_id
where b.parent_dealer_id = 4592 and b.is_deleted = 1


select 
master_customer_id,cust_first_name,cust_last_name,cust_address1,cust_address2,cust_mobile_phone,cust_home_phone,cust_work_phone,cust_email_address1,cust_email_address2
--update a set is_deleted =0,updated_by = 'srikanth', updated_date = getdate()  --4029/1473
from clictell_auto_master.master.customer a (nolock) 
where is_deleted =1 and parent_dealer_id  = 4592
and (clictell_auto_etl.dbo.isphonenovalid(cust_work_phone) =1 or len(cust_address1) >0)



select * 
--update a set ro_status = 'COMPLETED'
from clictell_auto_master.master.repair_order_header a (nolock) where parent_dealer_id = 4592

select *  from clictell_auto_master.master.repair_order_header (nolock) where ro_status = 'COMPLETED' -- 'COMPLETED'


select * from clictell_auto_master.master.customer b (nolock) where parent_dealer_id = 4592

select * from clictell_auto_master.master.vehicle (nolock) where parent_dealer_id = 4592

select * from clictell_auto_master.master.cust_2_vehicle (nolock) where parent_dealer_id = 4592

select * from clictell_auto_master.master.fi_sales (nolock) where parent_dealer_id = 4592

select * from clictell_auto_master.master.repair_order_header (nolock) where parent_dealer_id = 4592




select make,count(customer_id)
from auto_customers.customer.vehicles a (nolock)
where 
is_deleted=0
and account_id = ''



inner join auto_customers.customer.vehicles b(nolock) on a.customer_id = b.customer_id and a.account_id = b.account_id
where a.account_id = ''






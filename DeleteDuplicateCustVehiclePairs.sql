
	use auto_customers
	--Find Duplicate records
	select vin, customer_id, count(*) from customer.vehicles (nolock) where is_deleted=0 group by vin, customer_id having count(*) > 1


	-- Rank duplicate records on VIN & Customer_id into temp table
	drop table if exists #temp_vehi
	select 
			 row_number() over (partition by vin,customer_id order by isnull(last_service_date,purchase_date) desc,vehicle_id desc) as rnk
			,vin
			,customer_id
			,is_deleted
			,model
		into #temp_vehi
	from customer.vehicles (nolock)
	where  is_deleted =0
			--and len(vin) <> 0 
	order by vin
	
	--count of delete records
	select count(*) from #temp_vehi where rnk <> 1

	--Soft delete the duplicate records
	--update customer.vehicles (nolock) set is_deleted =1 where vin in (select vin from #temp_vehi where rnk <> 1)

	select * from auto_customers.customer.customers (nolock) where first_name like '%robert%' and last_name like '%harvy%' and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and is_deleted =0
	select * from auto_customers.customer.vehicles (nolock) where customer_id in (1947821,1947823,1915181,1915403)
	update auto_customers.customer.customers set is_deleted = 1, updated_by='SK_dupli_del' where customer_id in(1915181,1915403) and account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
	update auto_customers.customer.customers set segment_list = '-1,3557, 3563',list_ids ='-1,603,609,' where first_name like '%robert%' and last_name like '%harvy%' and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and is_deleted =0



	select * from clictell_auto_etl.etl.cdklgt_customer (nolock) where customerid in (266703,228531)


	select primary_email,primary_email_valid,IIF((primary_email) Like '%_@__%.__%',1,0) from auto_customers.customer.customers (nolock) where primary_email_valid is null and is_deleted =0
--	update auto_customers.customer.customers  set primary_email_valid =IIF((a.primary_email) Like '%_@__%.__%',1,0) where len(primary_email) =0 and primary_email_valid is null and is_deleted =0

select 
	src_cust_id,first_name,last_name,primary_email,primary_phone_number,count(*) 
from 
	auto_customers.customer.customers (nolock) 
where is_deleted =0 
		and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
		and last_name in ('VANN')
group by src_cust_id,first_name,last_name,primary_email,primary_phone_number having count(*) >1


select * from auto_customers.customer.customers (nolock)  where last_name in ('VANN')
select * from auto_customers.customer.customers (nolock)  where secondary_phone_number = '3604163950' and is_deleted =0
select * from auto_customers.customer.vehicles (nolock)  where customer_id in (3446049,1943647)

--update auto_customers.customer.customers  set last_name = 'LIFESTYLES HONDA', updated_by = 'SK_last_name_update' where customer_id in (3446049)


--update auto_customers.customer.vehicles set customer_id =3446049, updated_by='SK_Business_Cust_id' where customer_id =1943647


select * from auto_customers.customer.vehicles where customer_id = 3446049
select * from auto_customers.customer.vehicles where customer_id = 1943647
select * from auto_customers.customer.customers (nolock)  where customer_id in (3446049,1943647)

select * from auto_customers.customer.customers (nolock)  where len(isnull(company_name,'')) <> 0 and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'  and is_deleted =0 and len(isnull(full_name,'')) = 0 

--update auto_customers.customer.customers  set last_name = company_name, updated_by=updated_by + 'lastNm=compName' where len(isnull(company_name,'')) <> 0 and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'  and is_deleted =0 and len(isnull(full_name,'')) = 0 


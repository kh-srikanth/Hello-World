use auto_customers

drop table if exists #vehicles
drop table if exists #customers
select * into #vehicles from auto_customers.customer.vehicles a (nolock) where account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and is_deleted =0
select * into #customers from auto_customers.customer.customers a (nolock) where  account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and  r2r_customer_id is not null  and is_deleted =0


--select count(*) from auto_customers.customer.customers where account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and lead_status_id is null and is_subscriber =1 

-- Soft deleting Duplicate Vehicles  by VIN
update #vehicles set is_deleted =1 where vehicle_id in (
select vehicle_id from (
select 
	a.vehicle_id
	,a.customer_id
	,vin 
	,last_service_date
	,purchase_Date
	,row_number() over (partition by vin order by isnull(last_service_date,purchase_date) desc) as rnk
	,b.is_deleted
from #vehicles a
inner join #customers b (nolock) on a.customer_id = b.customer_id and a.account_id = b.account_id
where  is_valid_vin =1
) as a 
where rnk <> 1)


--Soft deleting vehicles without customers
update #vehicles set is_deleted =1 where 
--select vin,customer_id from #vehicles where 
is_valid_vin =1 and
customer_id not in (select customer_id from #customers)


--Delete customers who don't have valid phone/email
update  #customers set is_deleted =1 where  
primary_phone_number_valid = 0 and secondary_phone_number_valid =0 and  primary_email_valid =0


--Soft deleting vehicles without customers
update #vehicles set is_deleted =1 where 
--select vin,customer_id from #vehicles where 
customer_id not in (select customer_id from #customers)


--Soft deleteing customer records with DUPLICATE PRIMARY EMAIL AND WITHOUT VALID VEHICLE
update #customers set is_deleted =1  where customer_id in (
select customer_id/*,primary_email,rnk,created_dt*/ from (
select 
*,row_number() over (partition by primary_email order by created_dt desc) as rnk 
from 
#customers where 
primary_email in (select primary_email from #customers where primary_email_valid =1 group by primary_email having count(*) > 1)
and 
customer_id not in (select customer_id from #vehicles)
) as a 
where rnk <> 1
) 


---Duplicate Primary_phone_numbers

--Remove '1' from Phone Numbers
-- CHECK
--select customer_id,primary_phone_number , reverse(left(reverse(primary_phone_number),10))
update a set primary_phone_number = reverse(left(reverse(primary_phone_number),10))
from #customers a where primary_phone_number_valid =1 and len(primary_phone_number) > 10  
--Remove '1' from Sec Phone Numbers
--select customer_id,secondary_phone_number , reverse(left(reverse(secondary_phone_number),10))
update a set secondary_phone_number = reverse(left(reverse(secondary_phone_number),10))
from #customers a where secondary_phone_number_valid =1 and len(secondary_phone_number) > 10  


--Soft delete duplicate primary phone number customers without vehilces
update #customers set is_deleted =1 where customer_id in (
select customer_id/*,primary_phone_number,primary_phone_number_valid,rnk,created_dt*/ from (
select 
*,row_number() over (partition by primary_phone_number order by primary_email desc ) as rnk 
from #customers where 
primary_phone_number in (select primary_phone_number from #customers where  primary_phone_number_valid =1 group by primary_phone_number having count(*) > 1)
and 
customer_id not in (select customer_id from #vehicles  )
) as a 
where rnk <> 1 
)


--Soft delete duplicate secondary phone numbers without vehilces
update #customers set is_deleted =1 where customer_id in (
select customer_id/*,secondary_phone_number,secondary_phone_number_valid,rnk,created_dt*/ from (
select *,row_number() over (partition by secondary_phone_number order by primary_email desc) as rnk from #customers where 
secondary_phone_number in (select secondary_phone_number from #customers where  secondary_phone_number_valid =1 group by secondary_phone_number having count(*) > 1)
and 
customer_id not in (select customer_id from #vehicles where is_deleted =0  )
) as a 
where rnk <> 1 
)

--Joined primary and secondary phone numbers as phone
drop table if exists #cust_phone
select 
	customer_id
	,primary_phone_number
	,secondary_phone_number
	,case when primary_phone_number_valid =1 then primary_phone_number
			when isnull(primary_phone_number_valid,0) =0 and secondary_phone_number_valid =1 then secondary_phone_number
			else ''  end as phone
	,created_dt
	,primary_email
	into #cust_phone
from #customers
where  (primary_phone_number_valid =1 or secondary_phone_number_valid =1)

--deleted customers with duplicate phone and without vehicle
update #customers set is_deleted =1 where customer_id in (
select customer_id/*,phone,rnk,created_dt*/ from (
select *,row_number() over (partition by phone order by primary_email desc) as rnk from #cust_phone where 
phone in (select phone from #cust_phone group by phone having count(*) > 1)
and 
customer_id not in (select customer_id from #vehicles )
) as a 
where rnk <> 1 
)


--Duplicate phone with vehicles

-- Join Pri and Sec phone as phone
drop table if exists #cust_phone1
select 
	customer_id
	,primary_phone_number
	,secondary_phone_number
	,case when primary_phone_number_valid =1 then primary_phone_number
			when primary_phone_number_valid =0 and secondary_phone_number_valid =1 then secondary_phone_number
			else ''  end as phone
	,created_dt
	,primary_email
	into #cust_phone1
from #customers
where (primary_phone_number_valid =1 or secondary_phone_number_valid =1)

--ranked phone based on created_dt
drop table if exists #dup_cust
select customer_id,phone,rnk  into #dup_cust from (
select customer_id,primary_phone_number,secondary_phone_number,
case  when primary_phone_number_valid =1 then primary_phone_number when primary_phone_number_valid =0 and secondary_phone_number_valid =1 then secondary_phone_number end as phone,
created_dt
,row_number() over 
(partition by case  when primary_phone_number_valid =1 then primary_phone_number when primary_phone_number_valid =0 and secondary_phone_number_valid =1 then secondary_phone_number end
order by primary_email desc) as rnk

from #customers 
where  (primary_phone_number_valid =1 or secondary_phone_number_valid =1) and 
(primary_phone_number in (select phone from #cust_phone1 group by phone having count(*) > 1)
or
secondary_phone_number in (select phone from #cust_phone1 group by phone having count(*) > 1))
--order by case when primary_phone_number_valid =1 then primary_phone_number
--			when primary_phone_number_valid =0 and secondary_phone_number_valid =1 then secondary_phone_number end
) as a


--select * from #dup_cust

--pivoting ranks and phone
drop table if exists #dup_pivot
SELECT * into #dup_pivot FROM (
  SELECT
    [phone],
    [rnk],
    [customer_id]
  FROM #dup_cust
) a
PIVOT (
  SUM([customer_id])
  FOR [rnk]
  IN (
    [1], 
    [2],
	[3],
	[4]
  ) 
) AS PivotTable

--select * from #dup_pivot where [4] is not null

---Shift vehilces to one customer from other duplicate customer
--select a.customer_id,b.[2],b.[1]  
update a set a.customer_id = b.[1]
from #vehicles a
inner join #dup_pivot b on a.customer_id = b.[2]


update a set a.customer_id = b.[1]
from #vehicles a
inner join #dup_pivot b on a.customer_id = b.[3]

update a set a.customer_id = b.[1]
from #vehicles a
inner join #dup_pivot b on a.customer_id = b.[4]



--Remove Dupplicate Customer
--select customer_id,is_deleted
update a set a.is_deleted =1
from #customers a
inner join #dup_pivot b on a.customer_id = b.[2]


update a set a.is_deleted =1
from #customers a
inner join #dup_pivot b on a.customer_id = b.[3]


update a set a.is_deleted =1
from #customers a
inner join #dup_pivot b on a.customer_id = b.[4]

/*
select secondary_phone_number, count(*) from #customers where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and secondary_phone_number_valid=1 group by secondary_phone_number having count(*) > 1
select primary_phone_number, count(*) from #customers where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and primary_phone_number_valid=1 group by primary_phone_number having count(*) > 1

select customer_id,primary_phone_number,secondary_phone_number,primary_email from #customers where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and primary_phone_number in (
select primary_phone_number from #customers where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and primary_phone_number_valid=1 group by primary_phone_number having count(*) > 1
)
order by primary_email

-------------------------**********************validating after deleting duplicate records

--These VINs don't have a customer/customer phone & email not available
select * from auto_customers.customer.vehicles where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and is_valid_vin =1 and 
vin not in (select vin from #vehicles where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and is_valid_vin =1)


select count(*) from auto_customers.customer.customers where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and 
primary_phone_number not in (select primary_phone_number from #customers where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304')

select count(*) from auto_customers.customer.customers where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and 
secondary_phone_number not in (select secondary_phone_number from #customers where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304')

--missing valid primary_email due to eliminating duplicate phone numbers
select customer_id,primary_email,primary_email_valid from auto_customers.customer.customers where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and 
primary_email not in (select primary_email from #customers where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304') and primary_email_valid =1

*/
--Recalling softdeleted customers who's emails are missing
update #customers set is_deleted = 0 where customer_id in (
select customer_id from (
select customer_id,primary_email,primary_email_valid from auto_customers.customer.customers where  
primary_email not in (select primary_email from #customers where  primary_email_valid =1)
) as a
)

return;

----Updating original tables***********************
--select a.customer_id,b.customer_id,a.is_deleted,b.is_deleted
--update a set a.is_deleted = b.is_deleted
--from auto_customers.customer.customers a (nolock) 
--inner join #customers b on a.customer_id = b.customer_id and a.account_id = b.account_id
--where  a.is_deleted =0 and b.is_deleted =1

--select a.vehicle_id,b.vehicle_id,a.is_deleted,b.is_deleted
--update a set a.is_deleted = b.is_deleted
--from auto_customers.customer.vehicles a (nolock) 
--inner join #vehicles b on a.vehicle_id = b.vehicle_id and a.account_id = b.account_id
--where  a.is_deleted =0 and b.is_deleted =1
--*********************************************************



--COUNTS
select count(*) from #customers  --49,892
select count(*) from auto_customers.customer.customers (nolock) where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' --55,413


select count(*) from #vehicles  --25,155
select count(*) from auto_customers.customer.vehicles (nolock) where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' --25,188



select count(*) from auto_customers.customer.customers where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and 
primary_phone_number not in (select primary_phone_number from #customers )

select count(*) from auto_customers.customer.customers where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and 
secondary_phone_number not in (select secondary_phone_number from #customers )

--missing valid primary_email due to eliminating duplicate phone numbers
select customer_id,primary_email,primary_email_valid from auto_customers.customer.customers where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and 
primary_email not in (select primary_email from #customers) and primary_email_valid =1

select * 
--update a set is_deleted =0 
from auto_customers.customer.customers a where account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and r2r_customer_id in (
select owner_id  from [18.216.140.206].[r2r_admin].owner.owner with (nolock) where is_deleted =0 and dealer_id =2990 and is_app_user=1
except
select r2r_customer_id from auto_customers.customer.customers where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and is_app_user =1
)

select is_deleted,* from auto_customers.customer.customers where account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and r2r_customer_id =533089

select is_deleted,* from auto_customers.customer.customers where account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and (secondary_phone_number like '%8654480408' or primary_phone_number like '%8654480408')
select * from auto_customers.customer.customers where account_id = '7DB79611-A797-4938-AAC8-F3A887384304'  and r2r_customer_id in (
149049
,149054
,149094
,149096
,149174
,149185
,149209
,320725
,708769)

66618
select customer_id,a.is_deleted,primary_phone_number,secondary_phone_number,primary_email,is_app_user,* from auto_customers.customer.customers a (nolock) where (secondary_phone_number like '%8653604667' or primary_phone_number like '%8653604667') order by a.is_deleted


select * from [18.216.140.206].[r2r_admin].owner.owner with (nolock) where is_deleted =0 and dealer_id =2990 and owner_id in (860557
,320725
,493470
,321483)


select owner_id  from [18.216.140.206].[r2r_admin].owner.owner with (nolock) where is_deleted =0 and dealer_id =2990 and is_app_user=1
except
select r2r_customer_id from auto_customers.customer.customers where is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304' and is_app_user =1

use auto_customers

drop table if exists #vehicles
drop table if exists #customers
select * into #vehicles from auto_customers.customer.vehicles a (nolock) where account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559'
select * into #customers from auto_customers.customer.customers a (nolock) where  account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and  r2r_customer_id is not null  


--select count(*) from auto_customers.customer.customers where account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and lead_status_id is null and is_subscriber =1 

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
where a.is_deleted =0 and b.is_deleted =0 and is_valid_vin =1
and a.account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559'
) as a 
where rnk <> 1)


--Soft deleting vehicles without customers
update #vehicles set is_deleted =1 where 
--select vin,customer_id from #vehicles where 
	account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and is_deleted =0 and is_valid_vin =1 and
customer_id not in (select customer_id from #customers where account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and is_deleted =0)

/*
--check duplicate VINs
select vin, count(*) from #vehicles where is_deleted =0 and is_valid_vin =1  group by vin having count(*) > 1  

--check duplicate primary_email
select primary_email, count(*) from #customers where is_deleted =0 and primary_email_valid =1 group by primary_email having count(*) > 1


select * from #customers where primary_email ='JEFFCRALSTON@GMAIL.COM' and is_Deleted =0
select * from #vehicles where is_deleted =0 and customer_id in (64245,64246)
--validating primary_email
--update #customers set primary_email_valid = 0 where primary_email = 'NOEMAIL@GMAIL.COM'
*/

--Delete customers who don't have valid phone/email
update  #customers set is_deleted =1 where account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and is_deleted =0 and  
primary_phone_number_valid = 0 and secondary_phone_number_valid =0 and  primary_email_valid =0


--Soft deleting vehicles without customers
update #vehicles set is_deleted =1 where 
--select vin,customer_id from #vehicles where 
	account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and is_deleted =0  and
customer_id not in (select customer_id from #customers where account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and is_deleted =0)




--Soft deleteing customer records with DUPLICATE PRIMARY EMAIL AND WITHOUT VALID VEHICLE
update #customers set is_deleted =1  where customer_id in (
select customer_id/*,primary_email,rnk,created_dt*/ from (
select *,row_number() over (partition by primary_email order by created_dt desc) as rnk from #customers where 
primary_email in (select primary_email from #customers where is_deleted =0 and primary_email_valid =1 group by primary_email having count(*) > 1)
and 
customer_id not in (select customer_id from #vehicles where is_deleted =0 )
and 
is_deleted  =0
) as a 
where rnk <> 1
) 

/*
select primary_email, count(*) from #customers where is_deleted =0 and primary_email_valid =1 group by primary_email having count(*) > 1
select is_deleted,primary_email,primary_email_valid,* from #customers where primary_email = 'pearldragon13@yahoo.com' and is_deleted =0
*/


---Duplicate Primary_phone_numbers


--Remove '1' from Phone Numbers
--select --> CHECK
--customer_id,primary_phone_number , reverse(left(reverse(primary_phone_number),10))
update a set primary_phone_number = reverse(left(reverse(primary_phone_number),10))
from #customers a where is_deleted  =0 and account_id ='6B9537BD-115F-4019-B3AA-7F981EC69559' and primary_phone_number_valid =1 and len(primary_phone_number) > 10  
--Remove '1' from Sec Phone Numbers
--select 
--customer_id,secondary_phone_number , reverse(left(reverse(secondary_phone_number),10))
update a set secondary_phone_number = reverse(left(reverse(secondary_phone_number),10))
from #customers a where is_deleted  =0 and account_id ='6B9537BD-115F-4019-B3AA-7F981EC69559' and secondary_phone_number_valid =1 and len(secondary_phone_number) > 10  


/*select primary_phone_number, count(*) from #customers where account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and primary_phone_number_valid =1 and 
is_deleted =0 group by primary_phone_number having count(*) >1 
*/

--Soft delete primary phone numbers without vehilces
update #customers set is_deleted =1 where customer_id in (
select customer_id/*,primary_phone_number,primary_phone_number_valid,rnk,created_dt*/ from (
select *,row_number() over (partition by primary_phone_number order by primary_email desc ) as rnk from #customers where 
primary_phone_number in (select primary_phone_number from #customers where is_deleted =0 and primary_phone_number_valid =1 group by primary_phone_number having count(*) > 1)
and 
customer_id not in (select customer_id from #vehicles where is_deleted =0  )
and is_deleted  =0
and account_id ='6B9537BD-115F-4019-B3AA-7F981EC69559'
) as a 
where rnk <> 1 
)


--Soft delete duplicate secondary phone numbers without vehilces
update #customers set is_deleted =1 where customer_id in (
select customer_id/*,secondary_phone_number,secondary_phone_number_valid,rnk,created_dt*/ from (
select *,row_number() over (partition by secondary_phone_number order by primary_email desc) as rnk from #customers where 
secondary_phone_number in (select secondary_phone_number from #customers where is_deleted =0 and secondary_phone_number_valid =1 group by secondary_phone_number having count(*) > 1)
and 
customer_id not in (select customer_id from #vehicles where is_deleted =0  )
and is_deleted  =0
and account_id ='6B9537BD-115F-4019-B3AA-7F981EC69559'
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
			when primary_phone_number_valid =0 and secondary_phone_number_valid =1 then secondary_phone_number
			else ''  end as phone
	,created_dt
	,primary_email
	into #cust_phone
from #customers
where is_deleted =0
and account_id ='6B9537BD-115F-4019-B3AA-7F981EC69559'
and (primary_phone_number_valid =1 or secondary_phone_number_valid =1)

--deleted customers with duplicate phone and without vehicle
update #customers set is_deleted =1 where customer_id in (
select customer_id/*,phone,rnk,created_dt*/ from (
select *,row_number() over (partition by phone order by primary_email desc) as rnk from #cust_phone where 
phone in (select phone from #cust_phone group by phone having count(*) > 1)
and 
customer_id not in (select customer_id from #vehicles where is_deleted =0 )
) as a 
where rnk <> 1 
)


--Duplicate phone with vehicles
--select phone, count(*) from #cust_phone group by phone having count(*) > 1

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
where is_deleted =0
and account_id ='6B9537BD-115F-4019-B3AA-7F981EC69559'
and (primary_phone_number_valid =1 or secondary_phone_number_valid =1)

/*
select phone, count(*) from #cust_phone1 group by phone having count(*) > 1

select * from #cust_phone where phone = '2245634463'
select is_deleted,* from #customers where is_deleted =0 and account_id  ='6B9537BD-115F-4019-B3AA-7F981EC69559' and customer_id in (72723,77007)
select is_deleted,* from #vehicles where is_deleted =0 and account_id  ='6B9537BD-115F-4019-B3AA-7F981EC69559' and customer_id in (72723,77007)
*/
--ranked phone based on created_dt
drop table if exists #dup_cust
select customer_id,phone,rnk  into #dup_cust from (
select customer_id,primary_phone_number,secondary_phone_number,
case  when primary_phone_number_valid =1 then primary_phone_number when primary_phone_number_valid =0 and secondary_phone_number_valid =1 then secondary_phone_number end as phone,
created_dt,row_number() over 
(partition by case  when primary_phone_number_valid =1 then primary_phone_number when primary_phone_number_valid =0 and secondary_phone_number_valid =1 then secondary_phone_number end
order by primary_email desc) as rnk

from #customers where is_deleted =0 and account_id ='6B9537BD-115F-4019-B3AA-7F981EC69559' and (primary_phone_number_valid =1 or secondary_phone_number_valid =1) and 
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
where is_deleted =0  and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559'


update a set a.customer_id = b.[1]
from #vehicles a
inner join #dup_pivot b on a.customer_id = b.[3]
where is_deleted =0  and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559'

update a set a.customer_id = b.[1]
from #vehicles a
inner join #dup_pivot b on a.customer_id = b.[4]
where is_deleted =0  and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559'



--Remove Dupplicate Customer
--select customer_id,is_deleted
update a set a.is_deleted =1
from #customers a
inner join #dup_pivot b on a.customer_id = b.[2]
where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559'


update a set a.is_deleted =1
from #customers a
inner join #dup_pivot b on a.customer_id = b.[3]
where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559'


update a set a.is_deleted =1
from #customers a
inner join #dup_pivot b on a.customer_id = b.[4]
where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559'

/*
select secondary_phone_number, count(*) from #customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and secondary_phone_number_valid=1 group by secondary_phone_number having count(*) > 1
select primary_phone_number, count(*) from #customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and primary_phone_number_valid=1 group by primary_phone_number having count(*) > 1

select customer_id,primary_phone_number,secondary_phone_number,primary_email from #customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and primary_phone_number in (
select primary_phone_number from #customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and primary_phone_number_valid=1 group by primary_phone_number having count(*) > 1
)
order by primary_email

-------------------------**********************validating after deleting duplicate records

--These VINs don't have a customer/customer phone & email not available
select * from auto_customers.customer.vehicles where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and is_valid_vin =1 and 
vin not in (select vin from #vehicles where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and is_valid_vin =1)


select count(*) from auto_customers.customer.customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and 
primary_phone_number not in (select primary_phone_number from #customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559')

select count(*) from auto_customers.customer.customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and 
secondary_phone_number not in (select secondary_phone_number from #customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559')

--missing valid primary_email due to eliminating duplicate phone numbers
select customer_id,primary_email,primary_email_valid from auto_customers.customer.customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and 
primary_email not in (select primary_email from #customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559') and primary_email_valid =1

*/
--Recalling softdeleted customers who's emails are missing
update #customers set is_deleted = 0 where customer_id in (
select customer_id from (
select customer_id,primary_email,primary_email_valid from auto_customers.customer.customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and 
primary_email not in (select primary_email from #customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559') and primary_email_valid =1

) as a 
)

update #customers set is_deleted = 0 where customer_id in (
select customer_id from auto_customers.customer.customers a where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and 
reverse(left(reverse(primary_phone_number),10)) not in (select primary_phone_number from #customers b where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559')
)

----Updating original tables
select a.customer_id,b.customer_id,a.is_deleted,b.is_deleted
update a set a.is_deleted = b.is_deleted
from auto_customers.customer.customers a (nolock) 
inner join #customers b on a.customer_id = b.customer_id and a.account_id = b.account_id
where a.account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and a.is_deleted =0 and b.is_deleted =1 and a.r2r_customer_id is not null

select a.vehicle_id,b.vehicle_id,a.is_deleted,b.is_deleted
update a set a.is_deleted = b.is_deleted
from auto_customers.customer.vehicles a (nolock) 
inner join #vehicles b on a.vehicle_id = b.vehicle_id and a.account_id = b.account_id
where a.account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and a.is_deleted =0 and b.is_deleted =1




--COUNTS
select count(*) from #customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' --20438
select count(*) from auto_customers.customer.customers (nolock) where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and  r2r_customer_id is not null  --20444


select count(*) from #vehicles where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' --15
select count(*) from auto_customers.customer.vehicles (nolock) where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559'  --15



select * from auto_customers.customer.customers a where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and r2r_customer_id is not null and 
reverse(left(reverse(primary_phone_number),10)) not in (select primary_phone_number from #customers b where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559')

select count(*) from auto_customers.customer.customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and  r2r_customer_id is not null and
secondary_phone_number not in (select secondary_phone_number from #customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559')

--missing valid primary_email due to eliminating duplicate phone numbers
select customer_id,primary_email,primary_email_valid from auto_customers.customer.customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' and r2r_customer_id is not null and
primary_email not in (select primary_email from #customers where is_deleted =0 and account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559') and primary_email_valid =1



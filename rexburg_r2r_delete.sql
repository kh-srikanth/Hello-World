use auto_customers

drop table if exists #vehicles
drop table if exists #customers
select * into #vehicles from auto_customers.customer.vehicles a (nolock) where account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' 
select * into #customers from auto_customers.customer.customers a (nolock) where  account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and  r2r_customer_id is not null  




--select count(*) from auto_customers.customer.customers where account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and lead_status_id is null and is_subscriber =1 

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
and a.account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF'
) as a 
where rnk <> 1)


--Soft deleting vehicles without customers
update #vehicles set is_deleted =1 where 
--select vin,customer_id from #vehicles where 
	account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and is_deleted =0 and is_valid_vin =1 and
customer_id not in (select customer_id from #customers where account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and is_deleted =0)

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
update  #customers set is_deleted =1 where account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and is_deleted =0 and  
primary_phone_number_valid = 0 and secondary_phone_number_valid =0 and  primary_email_valid =0


--Soft deleting vehicles without customers
update #vehicles set is_deleted =1 where 
--select vin,customer_id from #vehicles where 
	account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and is_deleted =0  and
customer_id not in (select customer_id from #customers where account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and is_deleted =0)




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
from #customers a where is_deleted  =0 and account_id ='A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and primary_phone_number_valid =1 and len(primary_phone_number) > 10  
--Remove '1' from Sec Phone Numbers
--select 
--customer_id,secondary_phone_number , reverse(left(reverse(secondary_phone_number),10))
update a set secondary_phone_number = reverse(left(reverse(secondary_phone_number),10))
from #customers a where is_deleted  =0 and account_id ='A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and secondary_phone_number_valid =1 and len(secondary_phone_number) > 10  


/*select primary_phone_number, count(*) from #customers where account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and primary_phone_number_valid =1 and 
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
and account_id ='A1478891-4F48-4B55-9D64-B5FB5B99B1EF'
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
and account_id ='A1478891-4F48-4B55-9D64-B5FB5B99B1EF'
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
and account_id ='A1478891-4F48-4B55-9D64-B5FB5B99B1EF'
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
and account_id ='A1478891-4F48-4B55-9D64-B5FB5B99B1EF'
and (primary_phone_number_valid =1 or secondary_phone_number_valid =1)

/*
select phone, count(*) from #cust_phone1 group by phone having count(*) > 1

select * from #cust_phone where phone = '2245634463'
select is_deleted,* from #customers where is_deleted =0 and account_id  ='A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and customer_id in (72723,77007)
select is_deleted,* from #vehicles where is_deleted =0 and account_id  ='A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and customer_id in (72723,77007)
*/
--ranked phone based on created_dt
drop table if exists #dup_cust
select customer_id,phone,rnk  into #dup_cust from (
select customer_id,primary_phone_number,secondary_phone_number,
case  when primary_phone_number_valid =1 then primary_phone_number when primary_phone_number_valid =0 and secondary_phone_number_valid =1 then secondary_phone_number end as phone,
created_dt,row_number() over 
(partition by case  when primary_phone_number_valid =1 then primary_phone_number when primary_phone_number_valid =0 and secondary_phone_number_valid =1 then secondary_phone_number end
order by primary_email desc) as rnk

from #customers where is_deleted =0 and account_id ='A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and (primary_phone_number_valid =1 or secondary_phone_number_valid =1) and 
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
where is_deleted =0  and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF'


update a set a.customer_id = b.[1]
from #vehicles a
inner join #dup_pivot b on a.customer_id = b.[3]
where is_deleted =0  and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF'

update a set a.customer_id = b.[1]
from #vehicles a
inner join #dup_pivot b on a.customer_id = b.[4]
where is_deleted =0  and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF'



--Remove Dupplicate Customer
--select customer_id,is_deleted
update a set a.is_deleted =1
from #customers a
inner join #dup_pivot b on a.customer_id = b.[2]
where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF'


update a set a.is_deleted =1
from #customers a
inner join #dup_pivot b on a.customer_id = b.[3]
where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF'


update a set a.is_deleted =1
from #customers a
inner join #dup_pivot b on a.customer_id = b.[4]
where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF'

/*
select secondary_phone_number, count(*) from #customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and secondary_phone_number_valid=1 group by secondary_phone_number having count(*) > 1
select primary_phone_number, count(*) from #customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and primary_phone_number_valid=1 group by primary_phone_number having count(*) > 1

select customer_id,primary_phone_number,secondary_phone_number,primary_email from #customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and primary_phone_number in (
select primary_phone_number from #customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and primary_phone_number_valid=1 group by primary_phone_number having count(*) > 1
)
order by primary_email

-------------------------**********************validating after deleting duplicate records

--These VINs don't have a customer/customer phone & email not available
select * from auto_customers.customer.vehicles where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and is_valid_vin =1 and 
vin not in (select vin from #vehicles where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and is_valid_vin =1)


select count(*) from auto_customers.customer.customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and 
primary_phone_number not in (select primary_phone_number from #customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF')

select count(*) from auto_customers.customer.customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and 
secondary_phone_number not in (select secondary_phone_number from #customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF')

--missing valid primary_email due to eliminating duplicate phone numbers
select customer_id,primary_email,primary_email_valid from auto_customers.customer.customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and 
primary_email not in (select primary_email from #customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF') and primary_email_valid =1

*/
--Recalling softdeleted customers who's emails are missing
update #customers set is_deleted = 0 where customer_id in (
select customer_id from (
select customer_id,primary_email,primary_email_valid from auto_customers.customer.customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and primary_email_valid =1 and 
primary_email not in (select primary_email from #customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and primary_email_valid =1) 

) as a 
)

update #customers set is_deleted = 0 where customer_id in (
select customer_id from auto_customers.customer.customers a where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and 
reverse(left(reverse(primary_phone_number),10)) not in (select primary_phone_number from #customers b where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF')
)

----Updating original tables
select a.customer_id,b.customer_id,a.is_deleted,b.is_deleted
update a set a.is_deleted = b.is_deleted
from auto_customers.customer.customers a (nolock) 
inner join #customers b on a.customer_id = b.customer_id and a.account_id = b.account_id
where a.account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and a.is_deleted =0 and b.is_deleted =1

select a.vehicle_id,b.vehicle_id,a.is_deleted,b.is_deleted
update a set a.is_deleted = b.is_deleted
from auto_customers.customer.vehicles a (nolock) 
inner join #vehicles b on a.vehicle_id = b.vehicle_id and a.account_id = b.account_id
where a.account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and a.is_deleted =0 and b.is_deleted =1




--COUNTS
select count(*) from #customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' --44555
select count(*) from auto_customers.customer.customers (nolock) where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' --46711


select count(*) from #vehicles where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' --18653
select count(*) from auto_customers.customer.vehicles (nolock) where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' --18656



select * from auto_customers.customer.customers a where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and r2r_customer_id is not null and 
reverse(left(reverse(primary_phone_number),10)) not in (select primary_phone_number from #customers b where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF')

select count(*) from auto_customers.customer.customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and  r2r_customer_id is not null and
secondary_phone_number not in (select secondary_phone_number from #customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF')

--missing valid primary_email due to eliminating duplicate phone numbers
select customer_id,primary_email,primary_email_valid from auto_customers.customer.customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and r2r_customer_id is not null and
primary_email not in (select primary_email from #customers where is_deleted =0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF') and primary_email_valid =1



select owner_id from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where is_deleted =0 and dealer_id = 48884  and is_lime_opted_in =1
except
select r2r_customer_id from  auto_customers.customer.customers a (nolock) where is_deleted=0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and do_not_sms =0

select mobile,phone,* from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where is_deleted =0 and dealer_id = 48884  and is_lime_opted_in =1 and mobile = '14064516206'
select r2r_customer_id,primary_phone_number,secondary_phone_number,is_deleted,* from  auto_customers.customer.customers a (nolock) where account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and do_not_sms =0 and (primary_phone_number = '4064516206' or secondary_phone_number = '4064516206')



select  from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where is_deleted =0 and dealer_id = 48884  and is_lime_opted_in =1
except
select r2r_customer_id from  auto_customers.customer.customers a (nolock) where is_deleted=0 and account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and do_not_sms =0




select 
a.customer_id
,primary_phone_number
,mobile
,secondary_phone_number
,phone
--update a set is_deleted =0
from auto_customers.customer.customers a (nolock)
inner join [18.216.140.206].[r2r_admin].owner.owner b with (nolock) on a.r2r_customer_id = b.owner_id 
where a.account_id = '96DBF74D-C8BD-459B-B751-B93F961EF884' and b.dealer_id = 48570
and a.is_deleted =1 and b.is_deleted =0
and reverse(left(reverse(a.primary_phone_number),10))   <> reverse(left(reverse(REPLACE(translate(upper(mobile),'ABCDEFGHIJKLMNOPQRSTUVWXYZ+-;,.()[]{}* ','@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),'@','')),10)) 



select 
a.customer_id
,primary_phone_number
,mobile
,secondary_phone_number
,phone

--update a set is_deleted =0 
from auto_customers.customer.customers a (nolock)
inner join [18.216.140.206].[r2r_admin].owner.owner b with (nolock) on a.r2r_customer_id = b.owner_id 
where a.account_id = '96DBF74D-C8BD-459B-B751-B93F961EF884' and b.dealer_id = 48570
and a.is_deleted =1 and b.is_deleted =0
and reverse(left(reverse(a.secondary_phone_number),10))  <> reverse(left(reverse(REPLACE(translate(upper(phone),'ABCDEFGHIJKLMNOPQRSTUVWXYZ+-;,.()[]{}* ','@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),'@','')),10)) 



drop table if exists #old
select owner_id,reverse(left(reverse(REPLACE(translate(upper(mobile),'ABCDEFGHIJKLMNOPQRSTUVWXYZ+-;,.()[]{}* ','@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),'@','')),10)) as mobile
,reverse(left(reverse(REPLACE(translate(upper(phone),'ABCDEFGHIJKLMNOPQRSTUVWXYZ+-;,.()[]{}* ','@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),'@','')),10)) as phone
,is_deleted
into #old
from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where dealer_id = 48755

drop table if exists #new
select r2r_customer_id,reverse(left(reverse(a.primary_phone_number),10)) primary_phone_number,reverse(left(reverse(a.secondary_phone_number),10)) secondary_phone_number, is_deleted
into #new
from auto_customers.customer.customers a (nolock) where account_id = 'F0590E45-19AA-4597-A2B5-67553DD7B113'

update auto_customers.customer.customers  set is_deleted =0 where account_id = 'F0590E45-19AA-4597-A2B5-67553DD7B113' and r2r_customer_id in (
select r2r_customer_id from #new where case when len(primary_phone_number) =10 then primary_phone_number when len(primary_phone_number) <10 and len(secondary_phone_number) =10 then secondary_phone_number else '' end in (

select case when len(mobile) =10 then mobile when len(mobile) <10 and len(phone) =10 then phone else '' end from #old where is_deleted =0
except
select case when len(primary_phone_number) =10 then primary_phone_number when len(primary_phone_number) <10 and len(secondary_phone_number) =10 then secondary_phone_number else '' end from #new where is_deleted =0
)
)
--rexburg

select customer_id,do_not_sms,is_deleted,* 
--update a set is_deleted =0
from auto_customers.customer.customers a (nolock) where account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and r2r_customer_id in (
select owner_id from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where dealer_id = 48884 and is_deleted =0 and is_lime_opted_in =1
except
select r2r_customer_id from auto_customers.customer.customers a (nolock) where account_id = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and is_deleted =0 and do_not_sms =0 
)


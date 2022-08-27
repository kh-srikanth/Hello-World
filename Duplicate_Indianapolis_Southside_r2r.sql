use auto_customers

drop table if exists #vehicles
drop table if exists #customers
select * into #vehicles from auto_customers.customer.vehicles a (nolock) where account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' and is_deleted =0
select * into #customers from auto_customers.customer.customers a (nolock) where  account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' and  r2r_customer_id is not null  and is_deleted =0
/*
select a.customer_id,a.r2r_customer_id,b.owner_id
--update a set a.is_deleted =b.is_deleted
from #customers a (nolock)
inner join [18.216.140.206].[r2r_admin].owner.owner b with (nolock) on a.r2r_customer_id = b.owner_id 
where  b.dealer_id = 48570 
and a.is_deleted =1 and b.is_deleted =0

select count(*) from #customers a inner join #vehicles b on a.customer_id = b.customer_id
where a.is_deleted =0 and b.is_deleted =0 and do_not_email =0
select count(*) from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) inner join [18.216.140.206].[r2r_admin].cycle.cycle c with (nolock) on c.owner_id =b.owner_id
where b.dealer_id = 48570 and b.is_deleted =0 and c.is_deleted =0 and is_email_suppressed =0


select count(*) from #customers a where a.is_deleted =0  and do_not_email =0 and is_email_bounce =0
select count(*) from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) 
where b.dealer_id = 48570 and b.is_deleted =0  and is_email_suppressed =0 and is_email_bounced =0

select a.is_email_bounce , b.is_email_bounced
update a set a.is_email_bounce = b.is_email_bounced
from auto_customers.customer.customers  a (nolock)
inner join [18.216.140.206].[r2r_admin].owner.owner b with (nolock) on a.r2r_customer_id =b.owner_id
where 
b.dealer_id = 48570 and b.is_deleted =0  and is_email_suppressed =0 
and a.is_deleted =0  and a.do_not_email =0 
and a.is_email_bounce <> b.is_email_bounced
*/

-- Soft deleting Duplicate Vehicles  by VIN
update #vehicles set is_deleted =1 where is_deleted =0 and  vehicle_id in (
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


select primary_phone_number,primary_phone_number_valid, secondary_phone_number,secondary_phone_number_valid,primary_email,primary_email_valid 
--update a set primary_phone_number_valid = 0
from auto_customers.customer.customers a (nolock) where 
account_id = '96DBF74D-C8BD-459B-B751-B93F961EF884' and  r2r_customer_id is not null and len(isnull(primary_phone_number,''))=0 and primary_phone_number_valid is null

--Delete customers who don't have valid phone/email --14125
update  #customers set is_deleted =1 where is_deleted =0 and r2r_customer_id is not null and 
primary_phone_number_valid = 0 and secondary_phone_number_valid =0 and  primary_email_valid =0


--Soft deleting vehicles without customers
--update #vehicles set is_deleted =1 where is_deleted =0 and
----select vin,customer_id from #vehicles where 
--customer_id not in (select customer_id from #customers)


--Soft deleteing customer records with DUPLICATE PRIMARY EMAIL AND WITHOUT VEHICLE
update #customers set is_deleted =1  where is_deleted =0 and r2r_customer_id is not null and customer_id in (
select customer_id/*,primary_email,rnk,created_dt*/ from (
select 
*,row_number() over (partition by primary_email order by created_dt desc) as rnk 
from 
#customers where 
primary_email in (select primary_email from #customers where primary_email_valid =1 group by primary_email having count(*) > 1)
) as a 
where rnk <> 1
and 
customer_id not in (select customer_id from #vehicles)
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
update #customers set is_deleted =1 where is_deleted =0 and r2r_customer_id is not null and customer_id in (
select customer_id/*,primary_phone_number,primary_phone_number_valid,rnk,created_dt*/ from (
select 
*,row_number() over (partition by primary_phone_number order by primary_email desc ) as rnk 
from #customers where 
primary_phone_number in (select primary_phone_number from #customers where  primary_phone_number_valid =1 group by primary_phone_number having count(*) > 1)
) as a 
where rnk <> 1 
and 
customer_id not in (select customer_id from #vehicles  )
)


--Soft delete duplicate secondary phone numbers without vehilces
update #customers set is_deleted =1 where is_deleted =0 and r2r_customer_id is not null and customer_id in (
select customer_id/*,secondary_phone_number,secondary_phone_number_valid,rnk,created_dt*/ from (
select *,row_number() over (partition by secondary_phone_number order by primary_email desc) as rnk from #customers where 
secondary_phone_number in (select secondary_phone_number from #customers where  secondary_phone_number_valid =1 group by secondary_phone_number having count(*) > 1)
) as a 
where rnk <> 1
and 
customer_id not in (select customer_id from #vehicles where is_deleted =0  )
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
update #customers set is_deleted =1 where is_deleted =0 and  r2r_customer_id is not null and customer_id in (
select customer_id/*,phone,rnk,created_dt*/ from (
select *,row_number() over (partition by phone order by primary_email desc) as rnk from #cust_phone where 
phone in (select phone from #cust_phone group by phone having count(*) > 1)
) as a 
where rnk <> 1 
and 
customer_id not in (select customer_id from #vehicles )
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
 where a.is_deleted =0

update a set a.is_deleted =1
from #customers a
inner join #dup_pivot b on a.customer_id = b.[3]
 where a.is_deleted =0

update a set a.is_deleted =1
from #customers a
inner join #dup_pivot b on a.customer_id = b.[4]
 where a.is_deleted =0


--Recalling softdeleted customers who's emails are missing
update #customers set is_deleted = 0 where is_deleted =1 and customer_id in (
select customer_id from (
select customer_id,primary_email,primary_email_valid from auto_customers.customer.customers where  account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' and
primary_email_valid =1 and 
primary_email not in (select primary_email from #customers where  primary_email_valid =1)
) as a
)

return;

select * from auto_customers.customer.customers a (nolock) 
where a.account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' --and customer_id = 2804119
--and primary_email like 'sean.atkinson@southsideharley.com'
and primary_phone_number like '%7322418022' or secondary_phone_number like '%7322418022'

--Updating original tables***********************
select a.customer_id,b.customer_id,a.is_deleted,b.is_deleted
--update a set a.is_deleted = b.is_deleted
from auto_customers.customer.customers a (nolock) 
inner join #customers b on a.customer_id = b.customer_id and a.account_id = b.account_id
where  a.is_deleted <> b.is_deleted and a.is_deleted =0
and a.primary_email_valid =0
and a.account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A'
--order by a.customer_id
select a.vehicle_id,b.vehicle_id,a.customer_id,b.customer_id,a.is_deleted,b.is_deleted
--update a set a.is_deleted = b.is_deleted,a.customer_id =b.customer_id
from auto_customers.customer.vehicles a (nolock) 
inner join #vehicles b on a.vehicle_id = b.vehicle_id and a.account_id = b.account_id
where  
--a.is_deleted =0 and b.is_deleted =1
--and
a.customer_id <> b.customer_id
--*********************************************************



--COUNTS
select count(*) from #customers where is_deleted =0 --7623
select count(*) from auto_customers.customer.customers (nolock) where  account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' and is_deleted =0--12323
select count(*) from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where dealer_id = 48878 and is_deleted =0


select count(*) from #vehicles where is_deleted =0 --5298
select count(*) from auto_customers.customer.vehicles (nolock) where is_deleted =0 and account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' --5298
--select count(*) from auto_customers.customer.vehicles (nolock) where  account_id = '6B9537BD-115F-4019-B3AA-7F981EC69559' --15

--checking for Duplicates

drop table if exists #dupe_check
select 
		customer_id
		,r2r_customer_id
		,primary_email
		,primary_phone_number
		,secondary_phone_number
		,case when primary_phone_number_valid =1 then primary_phone_number 
			  when primary_phone_number_valid =0 and secondary_phone_number_valid =1 then secondary_phone_number 
			  else '' end as phone
		,created_dt
into #dupe_check
from #customers where is_deleted =0


update #customers set is_deleted =1  where is_deleted =0 and r2r_customer_id is not null and  customer_id in (
select customer_id from (
select *,row_number() over (partition by phone order by created_dt desc) as rnk
from #dupe_check where phone in (
select phone from #dupe_check group by phone,primary_email having count(*) > 1
)
) as a
where rnk <> 1
)

------********Comparing with r2r Old DB to see if data missing
---Phone_numbers::::
drop table if exists #old
select * into #old from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where dealer_id = 48878 and is_deleted =0 

drop table if exists #old_data
select owner_id,mobile,phone
,reverse(left(reverse(REPLACE(translate(upper(mobile),'ABCDEFGHIJKLMNOPQRSTUVWXYZ+-;,.()[]{}* ','@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),'@','')),10)) as mobile1 
,reverse(left(reverse(REPLACE(translate(upper(phone),'ABCDEFGHIJKLMNOPQRSTUVWXYZ+-;,.()[]{}* ','@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),'@','')),10)) as phone1 
into #old_data
from #old


drop table if exists #missing_data
select case when len(mobile1) =10 then mobile1 when len(mobile1) <> 10 and len(phone1) =10 then phone1 else '' end as phone_mix
	into #missing_data
from #old_data 
except
select case when primary_phone_number_valid =1 then primary_phone_number when primary_phone_number_valid =0 and secondary_phone_number_valid =1 then secondary_phone_number else '' end as ph from #customers

select is_deleted,r2r_customer_id,* 
--update a set is_deleted =0
from #customers a where r2r_customer_id in (
select owner_id from #old_data where is_deleted =1 and r2r_customer_id is not null and ( mobile1 in (select phone_mix from #missing_data) or phone1 in (select phone_mix from #missing_data))
)

---------------------***** Email
drop table if exists #miss_email
select email into #miss_email from #old
except
select primary_email from #customers where is_deleted =0


select * from #miss_email


--update a set is_deleted =0 
select is_deleted,r2r_customer_id,* 
from #customers a where primary_email_valid =1 and
primary_email in (select email from #miss_email)  

--------****** Comparision finished for email


select is_deleted,customer_id,r2r_customer_id,primary_phone_number,secondary_phone_number,primary_email from auto_customers.customer.customers (nolock) where account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' and primary_email in (select email from #miss_email)




select count(*) from #customers where is_deleted =0 and do_not_sms =0 and (primary_phone_number_valid=1 or secondary_phone_number_valid =1)
select count(*) from auto_customers.customer.customers (nolock) where  account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' and is_Deleted =0 and do_not_sms =0 and (primary_phone_number_valid=1 or secondary_phone_number_valid =1)


select count(*) from #customers where is_deleted =0 and do_not_email =0 and primary_email_valid =1
select count(*) from auto_customers.customer.customers (nolock) where  account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' and is_Deleted =0 and do_not_email =0 and primary_email_valid =1


drop table if exists #old_data1
select owner_id,mobile,phone,email
,reverse(left(reverse(REPLACE(translate(upper(mobile),'ABCDEFGHIJKLMNOPQRSTUVWXYZ+-;,.()[]{}* ','@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),'@','')),10)) as mobile1 
,reverse(left(reverse(REPLACE(translate(upper(phone),'ABCDEFGHIJKLMNOPQRSTUVWXYZ+-;,.()[]{}* ','@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),'@','')),10)) as phone1 
,is_lime_opted_in,is_email_suppressed,is_email_bounced
into #old_data1
from #old

select owner_id,mobile,phone,mobile1,phone1, case when len(mobile1) =10 then mobile1 when len(mobile1) <> 10 and len(phone1) =10 then phone1 else '' end as phone_mix
,email,is_lime_opted_in,is_email_suppressed,is_email_bounced
into #old_data2
 from #old_data1

select count(*) from #old_data2 where  is_email_suppressed =0
select count(*) from #customers where is_deleted =0 and do_not_email =0

select count(*) from #old_data2 where  is_lime_opted_in =1
select count(*) from #customers where is_deleted =0 and do_not_sms =0


select count(*)
from #old_data2 a
inner join #customers b on b.primary_email = a.email
where b.is_deleted =0 and
a.is_email_suppressed <> b.do_not_email
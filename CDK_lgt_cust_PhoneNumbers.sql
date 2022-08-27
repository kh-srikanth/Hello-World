use auto_customers

select			--22,181
	 a.src_cust_id as customerID
	,a.first_name
	,a.middle_name
	,a.last_name
	,a.primary_phone_number
	,a.secondary_phone_number
	,iif(len(a.primary_phone_number) =0, a.secondary_phone_number, a.primary_phone_number) as Phone_number
	,case when a.r2r_customer_id is not null then 'YES' else 'NO' end as existing_customer
from auto_customers.customer.customers a (nolock)
inner join clictell_auto_etl.etl.cdklgt_customer b (nolock) 
			on a.src_cust_id = b.CustomerId 
where	a.is_deleted =0
		and a.account_id  = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
		--and isnull(primary_phone_number_valid,0) = 1
		and a.do_not_sms =0
------------***************
drop table if exists #vehicles
select * 
into #vehicles
from 
(
select 
*
,row_number() over (partition by vin order by isnull(last_service_date,purchase_date) desc) as rnk
from auto_customers.customer.vehicles b (nolock) 
where b.is_deleted =0 and b.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and len(isnull(vin,'')) <> 0 --and customer_id in  (3462862,1970179)
UNION
select 
*
,row_number() over (partition by make,model,year order by isnull(last_service_date,purchase_date) desc) as rnk
from auto_customers.customer.vehicles b (nolock) 
where b.is_deleted =0 and b.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and len(isnull(vin,'')) = 0 --and customer_id in  (3462862,1970179)

)
as a
where rnk =1


select * from #vehicles
--UNION

--select 
-- *
-- ,row_number() over (partition by vin order by isnull(last_service_date,purchase_date) desc) as rnk
--from auto_customers.customer.vehicles b (nolock) 
--where b.is_deleted =0 and b.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and len(isnull(vin,'')) = 0

select count(*) from #vehicles
--select count(vin) from auto_customers.customer.vehicles b (nolock) where b.is_deleted =0 and  b.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
--select count(vin) from #vehicles

--select * from clictell_auto_etl.etl.cdklgt_customer b (nolock) where CustomerId in (253191,261533)
drop table if exists #temp
use auto_customers
select			--22,713
	 a.src_cust_id as customerID
	,a.r2r_customer_id
	,a.customer_id
	,a.first_name
	,a.middle_name
	,a.last_name
	,iif(len(a.primary_phone_number) =0, a.secondary_phone_number, a.primary_phone_number) as Phone_number
	,do_not_sms as sms_optout
	,b.vin
	,b.make
	,b.model
	,b.year as model_year
	,b.rnk
	,case when a.r2r_customer_id is not null then 'YES' else 'NO' end as existing_customer
into #temp
from auto_customers.customer.customers a (nolock)
inner join #vehicles b on a.customer_id = b.customer_id and b.is_deleted =0
where	a.is_deleted =0
		and a.account_id  = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
		--and a.do_not_sms =0
		--and src_cust_id is not null
		

select * from #temp where len(phone_number) = 10 order by vin, make,model,model_year
--select Phone_number,vin,make,model,model_year, count(*) from #temp group by Phone_number,vin,make,model,model_year having count(*) > 1

--select * from auto_customers.customer.customers a (nolock) where primary_phone_number = '2062559194' or secondary_phone_number = '2062559194'

--select * from auto_customers.customer.vehicles a (nolock) where customer_id in  (3458461,3458768)
drop table if exists #result
select customer_id,first_name,middle_name,last_name,Phone_number,
case when sms_optout =0 then 'No' else 'Yes' end as sms_optout,vin,make,model,model_year,iif(existing_customer='YES','Yes','No') as [Existing Customer] 
into #result from #temp where isnull(rnk,1) =1


select count(*) from #result where sms_optout = 'No' and [Existing Customer] = 'Yes'  --2654(new)  7599(existing)

select  * from #result

drop table if exists #result1
select *,row_number()over(partition by phone_number order by customer_id) as rnk1 
into #result1
from #result 
where len(phone_number) <> 0 
and phone_number in (select Phone_number from #temp group by Phone_number,vin,make,model,model_year having count(*) > 1)


--select * from #result1 where rnk1 <> 1

select distinct customer_id,first_name,last_name,Phone_number,sms_optout,[Existing Customer],ROW_NUMBER() over (partition by phone_number order by last_name) as rnk into #rest from #result where customer_id not in (select customer_id from #result1 where rnk1 <> 1) and len(phone_number) = 10  order by [Existing Customer]
--select phone_number,count(*) from #rest where rnk =1 group by phone_number having count(*) >1

select * from #rest where rnk =1 order  by Phone_number


select * from customer.customers (nolock) where customer_id = 1952513

--(nolock) where customer_id in  (3462862,1970179)
--select * from #vehicles a (nolock) where customer_id in  (3462862,1970179)


--vin based active customer

--vin make model first name

--***************Service Data Brothers******************
select 
	 isnull(a.first_name,'') as first_name
	,isnull(a.last_name,'') as last_name
	,isnull(a.first_name,'')+' '+isnull(a.last_name,'') as full_name
	,isnull(a.address_line,'') as address_line
	,isnull(a.address_line2,'') as address_line2
	,isnull(a.city,'') as city
	,isnull(a.state,'') as state
	,isnull(a.zip,'') as zip
	,'' as miles_radius
	,isnull(a.primary_email,'') as primary_email
	,isnull(a.primary_phone_number,'') as mobilePhone
	,'' as workPhone
	,isnull(a.secondary_phone_number,'') as HomePhone
	,isnull(b.vin,'') as vin
	,isnull(b.make,'') as make
	,isnull(b.model,'') as model
	,isnull(b.year,'') as year
	,case when b.vehicle_status='N' then 'New' when b.vehicle_status='U' then 'Used' when b.vehicle_status is null then '' end as vehicle_status
	,isnull(b.last_service_date,'') as roDate
	,isnull(b.ro_number,'') as roNumber
	,'' as totalRoAmount
	,'' as customerPay
	,case when a.do_not_email =0 then 'Y' when a.do_not_email =1 then 'N' when a.do_not_email is null then '' end as email_optin
	,case when a.do_not_sms =0 then 'Y' when a.do_not_sms =1 then 'N' when a.do_not_sms is null then '' end  as phone_optin
from auto_customers.customer.customers a (nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id and b.is_deleted =0
where	a.is_deleted =0
		and a.account_id  = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
		--and a.src_cust_id is not null
		and b.last_service_date is not null
		and convert(date,b.last_service_Date) >= convert(date,'2021-01-01')


----SALES DATA Brothers
select 
	 isnull(a.first_name,'') as first_name
	,isnull(a.last_name,'') as last_name
	,isnull(a.first_name,'')+' '+isnull(a.last_name,'') as full_name
	,isnull(a.address_line,'') as address_line
	,isnull(a.address_line2,'') as address_line2
	,isnull(a.city,'') as city
	,isnull(a.state,'') as state
	,isnull(a.zip,'') as zip
	,'' as miles_radius
	,isnull(a.primary_email,'') as primary_email
	,isnull(a.primary_phone_number,'') as mobilePhone
	,'' as workPhone
	,isnull(a.secondary_phone_number,'') as HomePhone
	,isnull(b.vin,'') as vin
	,isnull(b.make,'') as make
	,isnull(b.model,'') as model
	,isnull(b.year,'') as year
	,case when b.vehicle_status='N' then 'New' when b.vehicle_status='U' then 'Used' when b.vehicle_status is null then '' end as saleType
	,isnull(convert(date,purchase_date),'') as saleDate
	,case when a.do_not_email =0 then 'Y' when a.do_not_email =1 then 'N' when a.do_not_email is null then '' end as email_optin
	,case when a.do_not_sms =0 then 'Y' when a.do_not_sms =1 then 'N' when a.do_not_sms is null then '' end  as phone_optin


from auto_customers.customer.customers a (nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id and b.is_deleted =0
where	a.is_deleted =0
		and a.account_id  = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
		--and a.src_cust_id is not null
		and b.purchase_date is not null
		and convert(date,b.purchase_date) > =convert(date,'2018-01-01')


----SALE DATA without Service
select 
	isnull(a.first_name,'') as first_name
	,isnull(a.last_name,'') as last_name
	,isnull(a.first_name,'')+' '+isnull(a.last_name,'') as full_name
	,isnull(a.address_line,'') as address_line
	,isnull(a.address_line2,'') as address_line2
	,isnull(a.city,'') as city
	,isnull(a.state,'') as state
	,isnull(a.zip,'') as zip
	,'' as miles_radius
	,isnull(a.primary_email,'') as primary_email
	,isnull(a.primary_phone_number,'') as mobilePhone
	,'' as workPhone
	,isnull(a.secondary_phone_number,'') as HomePhone
	,isnull(b.vin,'') as vin
	,isnull(b.make,'') as make
	,isnull(b.model,'') as model
	,isnull(b.year,'') as year
	,case when b.vehicle_status='N' then 'New' when b.vehicle_status='U' then 'Used' when b.vehicle_status is null then '' end  as saleType
	,isnull(purchase_date,'') as saleDate
	,case when a.do_not_email =0 then 'Y' when a.do_not_email =1 then 'N' when a.do_not_email is null then '' end as email_optin
	,case when a.do_not_sms =0 then 'Y' when a.do_not_sms =1 then 'N' when a.do_not_sms is null then '' end  as phone_optin

from auto_customers.customer.customers a (nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id and b.is_deleted =0
where	a.is_deleted =0
		and a.account_id  = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
		--and a.src_cust_id is not null
		and convert(date,b.purchase_date) >= convert(date,'2021-01-01')
		and b.last_service_date is null


--LAST 6 MONTHS SERVICE
select distinct
	isnull(a.first_name,'') as first_name
	,isnull(a.last_name,'') as last_name
	,isnull(a.first_name,'')+' '+isnull(a.last_name,'') as full_name
	,isnull(a.address_line,'') as address_line
	,isnull(a.address_line2,'') as address_line2
	,isnull(a.city,'') as city
	,isnull(a.state,'') as state
	,isnull(a.zip,'') as zip
	,'' as miles_radius
	,isnull(a.primary_email,'') as primary_email
	,isnull(a.primary_phone_number,'') as PhoneNumber
	,'' as workPhone
	,isnull(a.secondary_phone_number,'') as HomePhone
	,isnull(b.vin,'') as vin
	,isnull(b.make,'') as make
	,isnull(b.model,'') as model
	,isnull(b.year,'') as year
	,case when b.vehicle_status='N' then 'New' when b.vehicle_status='U' then 'Used' when b.vehicle_status is null then '' end  as saleType
	,isnull(purchase_date,'') as saleDate
	,case when len(isnull(a.primary_phone_number,''))=0 then a.secondary_phone_number else a.primary_phone_number end as phoneNumber
	,case when a.do_not_email =0 then 'Y' when a.do_not_email =1 then 'N' when a.do_not_email is null then '' end as email_optin
	,case when a.do_not_sms =0 then 'Y' when a.do_not_sms =1 then 'N' when a.do_not_sms is null then '' end  as phone_optin
--select count(*)
from auto_customers.customer.customers a (nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id and b.is_deleted =0
where	a.is_deleted =0
		and a.account_id  = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
		and b.last_service_date < dateadd(month,-6,getdate())
		and len(a.last_name) >0 


use auto_customers

---LAPSED CUSTOMERS
drop table if exists #lapsed_customer
select 
	 a.customer_id
	 ,isnull(a.first_name,'') as first_name
	,isnull(a.last_name,'') as last_name
	,isnull(a.first_name,'')+' '+isnull(a.last_name,'') as full_name
	,isnull(a.address_line,'') as address_line
	,isnull(a.address_line2,'') as address_line2
	,isnull(a.city,'') as city
	,isnull(a.state,'') as state
	,isnull(a.zip,'') as zip
	,'' as miles_radius
	,isnull(a.primary_email,'') as primary_email
	,primary_email_valid
	,isnull(a.primary_phone_number,'') as PhoneNumber
	,primary_phone_number_valid
	,'' as workPhone
	,isnull(a.secondary_phone_number,'') as HomePhone
	,isnull(b.vin,'') as vin
	,isnull(b.is_valid_vin,'') as is_valid_vin
	,isnull(b.make,'') as make
	,isnull(b.model,'') as model
	,isnull(b.year,'') as year
	,case when b.vehicle_status='N' then 'New' when b.vehicle_status='U' then 'Used' when b.vehicle_status is null then '' end  as saleType
	,iif(convert(date,isnull(purchase_date,''))='1900-01-01','',isnull(purchase_date,'')) as saleDate
	,isnull(b.last_service_date,'') as service_date
	,case when a.do_not_email =0 then 'Y' when a.do_not_email =1 then 'N' when a.do_not_email is null then '' end as email_optin
	,case when a.do_not_sms =0 then 'Y' when a.do_not_sms =1 then 'N' when a.do_not_sms is null then '' end  as phone_optin
	--into 
	--drop table if exists #lapsed_customer
--select 
--a.customer_id,b.vin,b.make,b.model, convert(date,b.purchase_date) as purchase_date, convert(date,b.last_service_date) as last_service_date,a.primary_email
--	,case when len(isnull(a.primary_phone_number,''))=0 then a.secondary_phone_number else a.primary_phone_number end as phoneNumber
--	,do_not_email,do_not_sms
	into #lapsed_customer
	from 
		auto_customers.customer.customers a(nolock)
		inner join auto_customers.customer.vehicles b (nolock) on a.customer_id =b.customer_id and b.is_deleted =0
		where	
			a.is_deleted =0
		and a.account_id  = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
		and (a.primary_email_valid =1 or a.primary_phone_number_valid=1 or len(secondary_phone_number) =10)
		and (
			(
					Isnull(b.purchase_date, '') between '2020-01-01' and '2020-12-31'
				and b.last_service_date is null
			)	
			or 
			(
				Isnull(b.last_service_date,'') between '2020-01-01' and '2021-06-01'
			)
		)


select * from #lost_customer  where customer_id  in  
(
3453020
,1956229
,3458393
,1958329
,3459690
,1958651
,3461230
,1944727
,3449822
,1972237
,3449822
,1972237
,3462217
,1942133
,3446542
,1942203
,3447578
,1942333
,3446542
,1942203
,3462945
,1972237
,3459194
,1972237
,3462802
,1972237

)
and customer_id not in (1972237)
(3460284,3460603,1941345,3448768,1894205)
select * from #lapsed_customer where primary_email like '%@yahoo%'
select * from #lapsed_customer where vin ='YAMA3097J415'
select vin, count(*) from #lapsed_customer group by vin having count(*) >1


(3447578,1942333)
-----LOST CUSTOMERS		
drop table if exists #lost_customer
select 
	a.customer_id
	,isnull(a.first_name,'') as first_name
	,isnull(a.last_name,'') as last_name
	,isnull(a.first_name,'')+' '+isnull(a.last_name,'') as full_name
	,isnull(a.address_line,'') as address_line
	,isnull(a.address_line2,'') as address_line2
	,isnull(a.city,'') as city
	,isnull(a.state,'') as state
	,isnull(a.zip,'') as zip
	,'' as miles_radius
	,isnull(a.primary_email,'') as primary_email
	,primary_email_valid
	,isnull(a.primary_phone_number,'') as PhoneNumber
	,primary_phone_number_valid
	,'' as workPhone
	,isnull(a.secondary_phone_number,'') as HomePhone
	,isnull(b.vin,'') as vin
	,isnull(b.is_valid_vin,'') as is_valid_vin
	,isnull(b.make,'') as make
	,isnull(b.model,'') as model
	,isnull(b.year,'') as year
	,case when b.vehicle_status='N' then 'New' when b.vehicle_status='U' then 'Used' when b.vehicle_status is null then '' end  as saleType
	,iif(convert(date,isnull(purchase_date,''))='1900-01-01','',isnull(purchase_date,'')) as saleDate
	,isnull(b.last_service_date,'') as service_date
	--,case when len(isnull(a.primary_phone_number,''))=0 then a.secondary_phone_number else a.primary_phone_number end as phoneNumber
	,case when a.do_not_email =0 then 'Y' when a.do_not_email =1 then 'N' when a.do_not_email is null then '' end as email_optin
	,case when a.do_not_sms =0 then 'Y' when a.do_not_sms =1 then 'N' when a.do_not_sms is null then '' end  as phone_optin
	into #lost_customer
	from 
		auto_customers.customer.customers a(nolock)
		inner join auto_customers.customer.vehicles b (nolock) on a.customer_id =b.customer_id and b.is_deleted =0
		where	
			a.is_deleted =0
		and a.account_id  = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
		and (a.primary_email_valid =1 or a.primary_phone_number_valid =1 or len(secondary_phone_number) =10)
		and	( 
				b.last_service_date < '2020-01-01' 
					or
			  (b.purchase_date <= '2019-12-31' and b.last_service_date is null)
			 )
		order by vin desc

--select PhoneNumber,count(*) from #lost_customer group by PhoneNumber having count(*) > 1

select * from #lost_customer where primary_email not like '%.com' and primary_email not like '%.net' order by primary_email		--13694
select * from #lost_customer where vin ='YAMA3097J415'
select * from #lost_customer where service_date > '2021-01-01'
--13,347
--1045
--lost customers : 12363 with service condition
--Lost Customers : 1047 without service condition
--------------------*******************************************
select * from customer.customers (nolock) where primary_phone_number = '2062295060' or secondary_phone_number = '2062295060'
		kreidhead@intuitivesafetysoluti

select distinct vin from auto_customers.customer.vehicles b (nolock) where  account_id  = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and is_deleted =0 order by vin

select customer_id,src_cust_id,primary_phone_number,secondary_phone_number from auto_customers.customer.customers b (nolock)  where customer_id in (3459574,3451330,3448741,3461338,3459537)

select CellPhone,HomePhone,CustomerId from clictell_auto_etl.etl.cdkLgt_customer (nolock) where CustomerId in (243029,249105,268859,269033,274443)

use auto_customers
--=====-=-=-
select * from customer.customers (nolock) where primary_email like '%kreidhead@intuitivesafetysoluti%' and is_deleted =0

select
	 a.customer_id
	,a.first_name
	,a.last_name
	,case when len(isnull(a.primary_phone_number,''))=0 then a.secondary_phone_number else a.primary_phone_number end as phoneNumber
	,vin
	,make
	,model
	
into #duplicates
from auto_customers.customer.customers a (nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id and b.is_deleted =0
where	a.is_deleted =0
		and a.account_id  = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'




select phoneNumber,first_name,last_name,count(*) from #duplicates where len(isnull(phoneNumber,'')) =10 group by phoneNumber,first_name,last_name having count(*) > 1


select * from auto_customers.customer.vehicles b (nolock) where customer_id in 
(select customer_id from auto_customers.customer.customers b (nolock) where src_cust_id is not null and is_deleted =0 and account_id  = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB')
and vin is null


--select top 3 * from auto_customers.customer.vehicles b (nolock) 

--update auto_customers.customer.vehicles set vin =''  where 
----select vin,* from auto_customers.customer.vehicles b (nolock)  where 
--(vin like '%WHEEL%' or vin like '%carry%' or vin like '%shock%' or vin like '%fork%' or vin like'%EST%'or vin like'%and%'or vin like'%over%' or vin like'%find%'
--or vin like'%get%'or vin like'%gold%'or vin like'%install%'or vin like'%illegi%'or vin like'%head%'or vin like'%please%'or vin like'%race%'or vin like'%program%'
--or vin like'%phone%'or vin like'%ADD%'or vin like'%bike%'or vin like'%washer%'or vin like'%tire%'or vin like'%ride%'or vin like'%rust%'or vin like'%OFF%'or vin like'%RUCKAS%'
--or vin like'%only%'or vin like'%TOWED%'or vin like'%clamp%'or vin like'%phone%'or vin like'%locate%'or vin like'%tainable%'or vin like'%unit%'or vin like'%painted%'
--or vin like'%ZONGSHEN%'or vin like'%***%'or vin like'%..%'or vin like'%--%'or vin like'%rubbed%'or vin like'%info%'or vin like'%unit%'or vin like'%steering%'or vin like'%?%')
--and account_id  = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and is_deleted =0
--order by b.vin

--select vin,purchase_date,last_service_date, ROW_NUMBER() over (partition by vin order by last_service_date desc,purchase_date desc) as rnk from auto_customers.customer.vehicles b (nolock) 
--where  is_deleted=0 and account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and purchase_date is not null and last_service_date is not null and len(vin) <>0
--and vin in 

--(select vin from auto_customers.customer.vehicles b (nolock) where  is_deleted=0 and account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' group by vin   having count(*) > 1)

select * from auto_customers.customer.vehicles b (nolock) where is_deleted=0 and account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and vin = '000VCAXX9JJ203081'    order by created_dt,last_service_date 
select top 10 * from auto_customers.customer.vehicles b (nolock) where vehicle_id in (1442155)
select * from auto_customers.customer.customers b (nolock) where customer_id = 1916627

select * from clictell_auto_etl.etl.cdkLgt_Deals_Details where custID = 272851
select * from clictell_auto_etl.etl.cdkLgt_Service_Details where custID = 272851

--update  auto_customers.customer.vehicles  set is_deleted=1,updated_by = 'SK_del_dupe' where is_deleted=0 and account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB'  and vehicle_id in (1441517)


select  a.do_not_email,b.is_email_list, a.do_not_sms,b.is_sms_list,b.*
from auto_customers.customer.customers a (nolock) 
inner join [18.216.140.206].r2r_admin.owner.owner b with  (nolock) on a.r2r_customer_id = b.owner_id
where a.is_deleted=0 
and a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
and b.is_deleted =0 and b.dealer_id = 2998


select  lower(a.primary_email) as primary_email,lower(b.email) as email,a.do_not_email,b.is_email_suppressed--,b.* 
--update a set a.do_not_email = b.is_email_suppressed, a.updated_by = 'email_supres'
from auto_customers.customer.customers a (nolock) 
inner join [18.216.140.206].r2r_admin.owner.owner b with  (nolock) on a.primary_email = b.email and a.r2r_customer_id = b.owner_id
where 
a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and a.is_deleted =0
and b.is_deleted =0 and b.dealer_id = 2998 and len(b.email) <> 0
--and a.do_not_email <> b.is_email_suppressed

--163 changed to opt out  --7,705 as it is



--select  a.primary_phone_number,b.mobile,a.secondary_phone_number,b.phone, a.do_not_sms,iif(b.is_lime_opted_in=1,0,b.is_lime_opted_in) as lime_opt_out, b.*
--from auto_customers.customer.customers a (nolock) 
--inner join [18.216.140.206].r2r_admin.owner.owner b with  (nolock) 
--		on (a.primary_phone_number = replace(replace(replace(replace(b.mobile,'-',''),' ',''),'(',''),')','') 
--			or 
--			a.secondary_phone_number = replace(replace(replace(replace(b.phone,'-',''),' ',''),'(',''),')','')
--			)
--		and a.r2r_customer_id = b.owner_id
--where 
--a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and a.is_deleted =0
--and b.is_deleted =0 and b.dealer_id = 2998 and (len(b.mobile) <> 0 or len(b.phone) <> 0)



--select  
--update  a set --5035
--a.do_not_sms = case when b.is_lime_opted_in =1 then 0 when b.is_lime_opted_in = 0 then 1 end 
--,a.updated_by = 'lime_opt_out'
--from auto_customers.customer.customers a (nolock) 
--inner join [18.216.140.206].r2r_admin.owner.owner b with  (nolock) 
--		on a.primary_phone_number = replace(replace(replace(replace(b.mobile,'-',''),' ',''),'(',''),')','') 			
--		and a.r2r_customer_id = b.owner_id
--where 
--a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and a.is_deleted =0
--and b.is_deleted =0 and b.dealer_id = 2998 and (len(b.mobile) <> 0 or len(b.phone) <> 0)
----and len(b.mobile) <> 0
--and a.do_not_sms <> case when b.is_lime_opted_in =1 then 0 when b.is_lime_opted_in=0 then 1 end 
select 
--update a set
a.do_not_sms = case when b.is_lime_opted_in =1 then 0 when b.is_lime_opted_in = 0 then 1 end 
,a.updated_by = 'lime_opt_out2'
from auto_customers.customer.customers a (nolock) 
inner join [18.216.140.206].r2r_admin.owner.owner b with  (nolock) 
		on a.secondary_phone_number = replace(replace(replace(replace(b.phone,'-',''),' ',''),'(',''),')','') 			
		and a.r2r_customer_id = b.owner_id
where 
a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and a.is_deleted =0
and b.is_deleted =0 and b.dealer_id = 2998 and (len(b.mobile) <> 0 or len(b.phone) <> 0)
--and len(b.mobile) <> 0
and a.do_not_sms <> case when b.is_lime_opted_in =1 then 0 when b.is_lime_opted_in=0 then 1 end 



--11209
select * from #temp_vin where vin_valid = 1 order by vin

select * from auto_customers.customer.customers a (nolock) where 
(primary_phone_number = '7075066563'	or secondary_phone_number = '7075066563')	
and
a.account_id ='DE352067-1436-40B0-8BA4-86D036A3CE0D' and a.is_deleted =0


select * from auto_customers.customer.customers a (nolock) where 
(primary_phone_number = '4654646546'	or secondary_phone_number = '4654646546')	
and
a.account_id ='DE352067-1436-40B0-8BA4-86D036A3CE0D' and a.is_deleted =0

select vin,make,model,* from auto_customers.customer.vehicles a (nolock) where 
  a.account_id ='AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and a.is_deleted =0

use auto_customers
select Customer_id, first_name, last_name, primary_email, primary_phone_number, secondary_phone_number, phone_numbers, created_dt, updated_dt 
from customer.customers (nolock) where phone_numbers like '%7075066563%' and (primary_phone_number not like '%7075066563' and Secondary_phone_number not like '%7075066563')
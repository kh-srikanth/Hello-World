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
	,isnull(a.primary_phone_number,'') as Primary_Phone_number
	,primary_phone_number_valid
	,isnull(a.secondary_phone_number,'') as Secondary_phone_number
	, secondary_phone_number_valid
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
	,a.r2r_customer_id
	,a.src_cust_id
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
		and (a.primary_email_valid = 1 or a.primary_phone_number_valid = 1 or a.secondary_phone_number_valid = 1)
		and Isnull(a.fleet_flag, 0) != 1
		--and is_valid_vin = 1
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
	,isnull(a.primary_phone_number,'') as Primary_phone_number
	,primary_phone_number_valid
	,isnull(a.secondary_phone_number,'') as Secondary_phone_number
	,secondary_phone_number_valid
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
	,r2r_customer_id
	,src_cust_id
	into #lost_customer
	from 
		auto_customers.customer.customers a(nolock)
		inner join auto_customers.customer.vehicles b (nolock) on a.customer_id =b.customer_id and b.is_deleted =0
		where	
			a.is_deleted =0
		and a.account_id  = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
		and (a.primary_email_valid =1 or a.primary_phone_number_valid =1 or secondary_phone_number_valid = 1)
		and Isnull(a.fleet_flag, 0) != 1
		--and is_valid_vin = 1
		and	( 
				Cast(b.last_service_date as date) < '2020-01-01' 
					or
			  (Cast(b.purchase_date as date) < '2020-01-01' and b.last_service_date is null)
			 )
		order by vin desc

drop table if exists #unique_customer_lapsed
drop table if exists #unique_customer_lost
select distinct Customer_id as CustomerID, first_name as FirstName, last_name as LastName, full_name as FullName, address_line, address_line2, city, state, zip, miles_radius,
primary_email as [Primary Email], primary_email_valid as [Primary Email Valid], 
Primary_Phone_number as [Primary Phone Number], primary_phone_number_valid as [Primary Phone Number Valid], Secondary_phone_number as [Secondary Phone Number], secondary_phone_number_valid as [Secondary Phone Number Valid], 
email_optin as [Email Optin], phone_optin as [Sms Optin] into #unique_customer_lapsed from #lapsed_customer



select distinct Customer_id as CustomerID, first_name as FirstName, last_name as LastName, full_name as FullName, address_line, address_line2, city, state, zip, miles_radius,
primary_email as [Primary Email], primary_email_valid as [Primary Email Valid], 
Primary_Phone_number as [Primary Phone Number], primary_phone_number_valid as [Primary Phone Number Valid], Secondary_phone_number as [Secondary Phone Number], secondary_phone_number_valid as [Secondary Phone Number Valid], 
email_optin as [Email Optin], phone_optin as [Sms Optin] into #unique_customer_lost from #lost_customer


-------------------***************
select [Primary Email],count(*) from #unique_customer_lapsed  group by [Primary Email] having count(*) > 1
select [Primary Phone Number],count(*) from #unique_customer_lapsed group by [Primary Phone Number] having count(*) > 1
select [Secondary Phone Number],count(*) from #unique_customer_lapsed group by [Secondary Phone Number] having count(*) > 1

select * from #unique_customer_lapsed where [Secondary Phone Number] = '6144832300'

delete from #unique_customer_lapsed where CustomerID = '3458525'


delete from #unique_customer_lapsed where CustomerID in (
select CustomerID from (
select *, row_number() over (partition by [primary phone number] order by customerID desc) as rnk from  #unique_customer_lapsed
) as a where rnk <> 1
)
select [Primary Email],count(*) from #unique_customer_lost group by [Primary Email] having count(*) > 1

---Deleted Duplicate records from Lost Customers
delete from #unique_customer_lost where CustomerID in (
select CustomerID from (
select *, ROW_NUMBER() over (partition by [secondary phone number] order by customerID) as rnk from #unique_customer_lost where len([Secondary Phone Number])<>0 
) as a
where rnk <> 1
)

delete from #unique_customer_lost where CustomerID in (
select CustomerID from (
select *, ROW_NUMBER() over (partition by [primary phone number] order by customerID) as rnk from #unique_customer_lost where len([Primary Phone Number])<>0 
) as a
where rnk <> 1
)


delete from #unique_customer_lost where CustomerID in (
select CustomerID from (
select *, ROW_NUMBER() over (partition by [primary email] order by customerID) as rnk from #unique_customer_lost where len([Primary email])<>0 
) as a
where rnk <> 1
)


---Deleting records from Lost customer which are in lapsed Customer
drop table if exists #lost_not_lapsed
select * into #lost_not_lapsed from #unique_customer_lost
except
select * from #unique_customer_lapsed



select * from #lost_not_lapsed a inner join #unique_customer_lapsed b on a.CustomerID = b.CustomerID

delete from #unique_customer_lost where CustomerID in (
select b.CustomerID from #unique_customer_lapsed a  inner join #unique_customer_lost b on a.customerID = b.CustomerID 
)


delete from #unique_customer_lost where CustomerID in (
select b.CustomerID from #unique_customer_lapsed a  inner join #unique_customer_lost b on a.[Primary Phone Number] = b.[Primary Phone Number] where len(a.[Primary Phone Number]) <> 0
)


delete from #unique_customer_lost where CustomerID in (
select b.CustomerID from #unique_customer_lapsed a  inner join #unique_customer_lost b on a.[Secondary Phone Number] = b.[Secondary Phone Number] where len(a.[Secondary Phone Number]) <> 0
)


delete from #unique_customer_lost where CustomerID in (
select b.CustomerID from #unique_customer_lapsed a  inner join #unique_customer_lost b on a.[Primary Email] = b.[Primary Email] where len(a.[Primary Email]) <> 0
)


select * from #unique_customer_lapsed where CustomerID =1956901
except
select * from #unique_customer_lost where CustomerID =1946835


select * from #lost_customer where customer_id =1946835
select * from #lapsed_customer where customer_id =1956901

select a.*,b.CustomerID
from #unique_customer_lapsed a
inner join #unique_customer_lost b on a.[Primary Phone Number] =b.[Secondary Phone Number] and a.CustomerID <> b.CustomerID
where a.[Primary Phone Number Valid] =1 and b.[Secondary Phone Number Valid] =1
and a.[Primary Phone Number] ='3605365969' 


select a.*,b.CustomerID
from #unique_customer_lapsed a
inner join #unique_customer_lost b on a.[Secondary Phone Number] =b.[Primary Phone Number] and a.CustomerID <> b.CustomerID
where b.[Primary Phone Number Valid] =1 and a.[Secondary Phone Number Valid] =1


select * from #unique_customer_lost where [Secondary Phone Number] = '3605365969'
select * from #unique_customer_lapsed where [Primary Phone Number] = '3605365969'

3605365969

select 
	customer_id
	,primary_phone_number
	,primary_phone_number_valid
	,secondary_phone_number
	,substring(secondary_phone_number,1,PATINDEX('%[A-Z]%',upper(secondary_phone_number)))
from  auto_customers.customer.customers a(nolock) 
where a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' and a.is_deleted =0 
and customer_id in (1868849,1878287,1947283)

select convert(date,'06-30-2021')
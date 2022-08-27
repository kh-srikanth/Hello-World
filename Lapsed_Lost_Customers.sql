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


select * from #lapsed_customer  where primary_email not like '%.com' and primary_email not like '%.net' and len(primary_email) <> 0
select * from #lapsed_customer where primary_email like '%@yahoo%'
select vin, count(*) from #lapsed_customer group by vin having count(*) >1

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
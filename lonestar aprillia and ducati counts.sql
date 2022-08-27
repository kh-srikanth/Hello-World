

-----------LONESTAR APRILLIA VEHICLES COUNT
select 
a.customer_id,a.first_name,last_name,vin,make,model,year
,case when primary_phone_number_valid=1 then primary_phone_number
		when primary_phone_number_valid=0 and secondary_phone_number_valid = 1 then secondary_phone_number else primary_phone_number end as phone,primary_phone_number_valid,secondary_phone_number_valid
,primary_email
,address_line,do_not_email,do_not_sms,is_email_bounce
from auto_customers.customer.customers a (nolock) 
inner join  auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
	a.account_id = '2928EACC-A39D-4743-BF02-F9689F16E79F' 
	and a.is_deleted = 0 and b.is_deleted =0
	and make like 'Apri%'
	and		(
				(primary_email_valid = 1 and do_not_email = 0 and is_email_bounce = 0) 
			or len(isnull(address_line,''))>0 
			or ((primary_phone_number_valid=1 or secondary_phone_number_valid=1)  and do_not_sms = 0)
			) 
	and isnull(fleet_flag,0) = 0
	and isnull(is_unsubscribed,0) <> 1


-----------------------LONESTAR DUCATI VEHICLES COUNT-----------
select 
a.customer_id,a.first_name,last_name,vin,make,model,year
,case when primary_phone_number_valid=1 then primary_phone_number
		when primary_phone_number_valid=0 and secondary_phone_number_valid = 1 then secondary_phone_number else primary_phone_number end as phone,primary_phone_number_valid,secondary_phone_number_valid
,primary_email
,address_line,do_not_email,do_not_sms,is_email_bounce
from auto_customers.customer.customers a (nolock) 
inner join  auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
	a.account_id = '2928EACC-A39D-4743-BF02-F9689F16E79F' 
	and a.is_deleted = 0 and b.is_deleted =0
	and make like 'DUCA%'
	and		(
				(primary_email_valid = 1 and do_not_email = 0 and is_email_bounce = 0) 
			or len(isnull(address_line,''))>0 
			or ((primary_phone_number_valid=1 or secondary_phone_number_valid=1)  and do_not_sms = 0)
			) 
	and isnull(fleet_flag,0) = 0
	and isnull(is_unsubscribed,0) <> 1


----Entire DB

	-----------LONESTAR APRILLIA VEHICLES COUNT
select  do_not_email,count(distinct customer_id) from (
select --871
a.customer_id,a.first_name,last_name,vin,make,model,year
,case when primary_phone_number_valid=1 then primary_phone_number
		when primary_phone_number_valid=0 and secondary_phone_number_valid = 1 then secondary_phone_number else primary_phone_number end as phone,primary_phone_number_valid,secondary_phone_number_valid
,primary_email
,address_line,do_not_email,do_not_sms,is_email_bounce
from auto_customers.customer.customers a (nolock) 
inner join  auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
	a.account_id in  (select _id from auto_customers.portal.account with (nolock) where parentid in ('C994B4F4-666E-446B-9A2F-C4985EBEA150'
																					,'2FFC0052-6D81-46B5-AD31-E47BBA081346'
																					,'5FB8E2CB-36CD-48C3-9CC7-03B0414D5013'))
	and a.is_deleted = 0 and b.is_deleted =0
	and make like 'Apri%'
	and		(
				(primary_email_valid = 1 and do_not_email = 0 and is_email_bounce = 0) 
			or len(isnull(address_line,''))>0 
			or ((primary_phone_number_valid=1 or secondary_phone_number_valid=1)  and do_not_sms = 0)
			) 
	and isnull(fleet_flag,0) = 0
	and isnull(is_unsubscribed,0) <> 1
) as a 
group by do_not_email

-----------------------DUCATI VEHICLES COUNT-----------
select  do_not_email,count(distinct customer_id) from (

select --2152
a.customer_id,a.first_name,last_name,vin,make,model,year
,case when primary_phone_number_valid=1 then primary_phone_number
		when primary_phone_number_valid=0 and secondary_phone_number_valid = 1 then secondary_phone_number else primary_phone_number end as phone,primary_phone_number_valid,secondary_phone_number_valid
,primary_email
,address_line,do_not_email,do_not_sms,is_email_bounce
from auto_customers.customer.customers a (nolock) 
inner join  auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
	a.account_id in  (select _id from auto_customers.portal.account with (nolock) where parentid in ('C994B4F4-666E-446B-9A2F-C4985EBEA150'
																					,'2FFC0052-6D81-46B5-AD31-E47BBA081346'
																					,'5FB8E2CB-36CD-48C3-9CC7-03B0414D5013'))
	and
	a.is_deleted = 0 and b.is_deleted =0
	and make like 'DUCA%'
	and		(
				(primary_email_valid = 1 and do_not_email = 0 and is_email_bounce = 0) 
			or len(isnull(address_line,''))>0 
			or ((primary_phone_number_valid=1 or secondary_phone_number_valid=1)  and do_not_sms = 0)
			) 
	and isnull(fleet_flag,0) = 0
	and isnull(is_unsubscribed,0) <> 1
) as a 
group by do_not_email



select  a.customer_id
	,case when primary_phone_number_valid=1 then primary_phone_number 
	when primary_phone_number_valid=0 and secondary_phone_number_valid = 1 then secondary_phone_number 
	else primary_phone_number end as phone
	, primary_email, primary_email_valid, do_not_email, is_email_bounce,do_not_sms
	,make,model
from auto_customers.customer.customers a (nolock) 
inner join  auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
	a.is_deleted = 0 and b.is_deleted =0
	and make like 'DUCA%'
	--and a.account_id in  (select _id from auto_customers.portal.account with (nolock) where parentid in ('C994B4F4-666E-446B-9A2F-C4985EBEA150'
	--																				,'2FFC0052-6D81-46B5-AD31-E47BBA081346'
	--																				,'5FB8E2CB-36CD-48C3-9CC7-03B0414D5013'))
	and do_not_sms is null



	select  count(distinct a.customer_id)

	from auto_customers.customer.customers a (nolock) 
inner join  auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
	a.is_deleted = 0 and b.is_deleted =0
	and make like 'DUCA%'
	and a.account_id in  (select _id from auto_customers.portal.account with (nolock) where parentid in ('C994B4F4-666E-446B-9A2F-C4985EBEA150'
																					,'2FFC0052-6D81-46B5-AD31-E47BBA081346'
																					,'5FB8E2CB-36CD-48C3-9CC7-03B0414D5013'))
group by do_not_sms





	select  do_not_sms,count(distinct a.customer_id)

	from auto_customers.customer.customers a (nolock) 
inner join  auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
	a.is_deleted = 0 and b.is_deleted =0
	and make like 'Apri%'
	and a.account_id in  (select _id from auto_customers.portal.account with (nolock) where parentid in ('C994B4F4-666E-446B-9A2F-C4985EBEA150'
																					,'2FFC0052-6D81-46B5-AD31-E47BBA081346'
																					,'5FB8E2CB-36CD-48C3-9CC7-03B0414D5013'))
group by do_not_sms



select  a.customer_id
	,case when primary_phone_number_valid=1 then primary_phone_number 
	when primary_phone_number_valid=0 and secondary_phone_number_valid = 1 then secondary_phone_number 
	else primary_phone_number end as phone
	, primary_email, primary_email_valid, do_not_email, is_email_bounce,do_not_sms
	,make,model
from auto_customers.customer.customers a (nolock) 
inner join  auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
	a.is_deleted = 0 and b.is_deleted =0
	and make like 'DUCA%'
	--and a.account_id in  (select _id from auto_customers.portal.account with (nolock) where parentid in ('C994B4F4-666E-446B-9A2F-C4985EBEA150'
	--																				,'2FFC0052-6D81-46B5-AD31-E47BBA081346'
	--																				,'5FB8E2CB-36CD-48C3-9CC7-03B0414D5013'))
	and do_not_email =1






--------Active Customers lonestar (6 months)
	select distinct
			a.customer_id
			,first_name
			,last_name
			,case when primary_phone_number_valid=1 then primary_phone_number 
				when primary_phone_number_valid=0 and secondary_phone_number_valid = 1 then secondary_phone_number 
				else primary_phone_number end as phone
			,convert(date,last_service_date) as last_service_date
	from auto_customers.customer.customers a (nolock)
	inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
	where a.is_deleted =0 and b.is_deleted =0
	and a.account_id ='2928EACC-A39D-4743-BF02-F9689F16E79F'
	and convert(date,last_service_date) > '2022-02-09'
	and (primary_phone_number_valid=1 or secondary_phone_number_valid=1)
order by convert(date,last_service_date) desc




----Lapsed Customes Calculations excluding Active customers
	drop table if exists #active
	select distinct b.vehicle_id,a.customer_id into #active
		from auto_customers.customer.customers a (nolock)
	inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
	where a.is_deleted =0 and b.is_deleted =0
	and a.account_id ='2928EACC-A39D-4743-BF02-F9689F16E79F'
	and convert(date,last_service_date) > '2021-08-09'



	select  distinct top 500
		a.customer_id
		,first_name
		,last_name
		,case when primary_phone_number_valid=1 then primary_phone_number 
			when primary_phone_number_valid=0 and secondary_phone_number_valid = 1 then secondary_phone_number 
			else primary_phone_number end as phone
		,convert(date,last_service_date) as last_service_date
	from auto_customers.customer.customers a (nolock)
	inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
	where a.is_deleted =0 and b.is_deleted =0
	and a.account_id ='2928EACC-A39D-4743-BF02-F9689F16E79F'
	and (primary_phone_number_valid=1 or secondary_phone_number_valid=1)
	and convert(date,last_service_date) < '2021-08-09'
	and vehicle_id not in (select vehicle_id from #active)
	and a.customer_id not in (select customer_id from #active)
	order by last_service_date desc
select 
a.customer_id
from auto_customers.customer.customers a (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id and b.is_deleted =0
where a.is_deleted =0 
	and a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
	and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1 or primary_email_valid = 1)
	and Isnull(is_unsubscribed, 0) = 0
	and Isnull(fleet_flag, 0) = 0
	and first_name like  '%JO%'
	and do_not_sms = 0
	and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1)




select distinct
a.customer_id
from auto_customers.customer.customers a (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id and b.is_deleted =0
where a.is_deleted =0 
	and a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
	and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1 or primary_email_valid = 1)
	and Isnull(is_unsubscribed, 0) = 0
	and Isnull(fleet_flag, 0) = 0
	and ((primary_email_valid = 1 and isnull(do_not_email,1) = 0 and isnull(is_email_bounce,0) = 0) 
		or 
		(isnull(do_not_mail,1) = 0 and Len(Isnull(address_line,'')) > 0) 
		or 
		((primary_phone_number_valid = 1 or secondary_phone_number_valid = 1) and isnull(do_not_sms,1) = 0)	)
	and first_name like  '%JO%'



select distinct
a.customer_id
from auto_customers.customer.customers a (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id and b.is_deleted =0
where a.is_deleted =0 
	and a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
	and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1 or primary_email_valid = 1)
	and Isnull(is_unsubscribed, 0) = 0
	and Isnull(fleet_flag, 0) = 0
	and ((primary_email_valid = 1 and isnull(do_not_email,1) = 0 and isnull(is_email_bounce,0) = 0) 
		or 
		(isnull(do_not_mail,1) = 0 and Len(Isnull(address_line,'')) > 0) 
		or 
		((primary_phone_number_valid = 1 or secondary_phone_number_valid = 1) and isnull(do_not_sms,1) = 0)	)
	and (first_name like  '%a%') and  (make in ('HARLEY-DAVIDSON'))




drop table if exists #temp
select 
a.customer_id
,primary_phone_number
,secondary_phone_number
,case when primary_phone_number_valid = 1 then primary_phone_number when primary_phone_number_valid = 0 and secondary_phone_number_valid = 1 then secondary_phone_number else primary_phone_number end as phone

into #temp
from auto_customers.customer.customers a (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id and b.is_deleted =0
where a.is_deleted =0 
	and a.account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
	and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1 or primary_email_valid = 1)
	and Isnull(is_unsubscribed, 0) = 0
	and Isnull(fleet_flag, 0) = 0
	and do_not_sms is null
	and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1)


	select * from auto_customers.portal.account with (nolock) where accountname like 'Big%'

	select * from #temp--186080

		select * from #temp where isnumeric(phone) = 1 and len(phone) <> 10--186080



	
	
	select 
	 secondary_phone_number
	,right(secondary_phone_number,10)
	,substring(secondary_phone_number,1,len(secondary_phone_number) - len(right(secondary_phone_number,10)))
	,secondary_phone_country_code 

	--update a set secondary_phone_number = right(secondary_phone_number,10)
	--			,secondary_phone_country_code = substring(secondary_phone_number,1,len(secondary_phone_number) - len(right(secondary_phone_number,10)))
	from auto_customers.customer.customers a (nolock)
	where is_deleted =0 and secondary_phone_number_valid = 1 
	and account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
	and len(secondary_phone_number) > 10



drop table if exists #temp
select 
		a.customer_id,case when primary_phone_number_valid =1 then primary_phone_number when primary_phone_number_valid = 0 and secondary_phone_number_valid =1 then secondary_phone_number else primary_phone_number end as phone
		,primary_email as email
		,vin
		,make,model,year
		into #temp
from auto_customers.customer.customers a (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id and b.is_deleted =0
where a.is_deleted =0 
	and a.account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
	and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1 or primary_email_valid = 1)
	and Isnull(is_unsubscribed, 0) = 0
	and Isnull(fleet_flag, 0) = 0
	--and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1)
	and (len(isnull(primary_phone_number,'')) >= 10 or len(isnull(secondary_phone_number,'')) >=10)
	and purchase_date between '08-01-2019' and '08-01-2022'

drop table if exists #temp2
select *,row_number() over (partition by phone,email,vin order by customer_id desc) as rnk  into #temp2 from #temp

select * from #temp2 where rnk = 1   --10752/





drop table if exists #temp
select 
		a.customer_id,case when primary_phone_number_valid =1 then primary_phone_number when primary_phone_number_valid = 0 and secondary_phone_number_valid =1 then secondary_phone_number else primary_phone_number end as phone
		,primary_email as email
		,vin
		,make,model,year
		into #temp
from auto_customers.customer.customers a (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id and b.is_deleted =0
where a.is_deleted =0 
	and a.account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
	and (len(isnull(primary_phone_number,'')) >= 10 or len(isnull(secondary_phone_number,'')) >=10 or primary_email_valid = 1)
	and Isnull(is_unsubscribed, 0) = 0
	and Isnull(fleet_flag, 0) = 0
	--and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1)
	--and (isnull(primary_phone_number,'') <> '' or isnull(secondary_phone_number,'') <> '')
	and (len(trim(primary_phone_number)) >= 10 or len(trim(secondary_phone_number)) >=10)
	and purchase_date between '08-01-2015' and '08-01-2022'

drop table if exists #temp2
select *,row_number() over (partition by phone,email,vin order by customer_id desc) as rnk  into #temp2 from #temp

select * from #temp2 where rnk = 1   --24451/24446






drop table if exists #temp
select 
		a.customer_id,case when primary_phone_number_valid =1 then primary_phone_number when primary_phone_number_valid = 0 and secondary_phone_number_valid =1 then secondary_phone_number else primary_phone_number end as phone
		,primary_email as email
		,vin
		,make,model,year
		into #temp
from auto_customers.customer.customers a (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id and b.is_deleted =0
where a.is_deleted =0 
	and a.account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
	and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1 or primary_email_valid = 1)
	and Isnull(is_unsubscribed, 0) = 0
	and Isnull(fleet_flag, 0) = 0
	--and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1)
	and (isnull(primary_phone_number,'') <> '' or isnull(secondary_phone_number,'') <> '')
	and purchase_date between '08-01-2017' and '08-01-2022'

drop table if exists #temp2
select *,row_number() over (partition by phone,email,vin order by customer_id desc) as rnk  into #temp2 from #temp

select * from #temp2 where rnk = 1   --17953


	
use auto_customers
drop table if exists #customers
select *
into #customers
from auto_customers.customer.customers a (nolock)
where is_deleted =0
and account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'
and Isnull(is_unsubscribed, 0) = 0
and Isnull(fleet_flag, 0) = 0
and (primary_phone_number_valid = 1 or Secondary_Phone_number_valid = 1 or Primary_email_valid = 1)



drop table if exists #vehicles
select 	*
into #vehicles
from Customer.vehicles (nolock)
where is_deleted = 0 
and account_id = '2AB7B512-7D61-4C6D-8AED-710075AA6306'



drop table if exists #temp
select 
			a.customer_id
			,customer_guid, ltrim(rtrim([primary_email])) as [primary_email], 
			(Case when Len(ltrim(rtrim([primary_phone_number]))) >= 10 then ltrim(rtrim([primary_phone_number]))
				 when Len(ltrim(rtrim(secondary_Phone_number))) >= 10 then ltrim(rtrim([secondary_Phone_number]))
				 else ltrim(rtrim([primary_phone_number])) end) as [primary_phone_number], 
			  make, model, 
			[Year],
			(Case when last_service_date is not null then Dateadd(month, 6, last_service_date) else null end) as next_service_date,
			Convert(varchar(10), b.ro_date, 112) as ro_date,vin, b.vehicle_id, do_not_email, do_not_sms,
			(Case when Len(ltrim(rtrim([primary_phone_number]))) >= 10 then Isnull(primary_phone_number_valid, 1)
				 when Len(ltrim(rtrim(secondary_Phone_number))) >= 10 then Isnull(secondary_phone_number_valid, 1)
				 else 0 end) as is_valid_phone, 
			Isnull(primary_email_valid, 0) as is_valid_email, a.list_ids, Convert(varchar(10), b.purchase_date, 112) as purchase_date
			, a.is_email_bounce, isNull(fleet_flag, 0) as fleet_flag, Convert(varchar(10), b.last_service_date, 112) as last_service_date


			into #temp
from #customers a with (nolock)    
left outer join #vehicles b with (nolock) on a.customer_id = b.customer_id 



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



	select distinct
    a.customer_id,
	a.first_name,
	a.last_name,
	a.full_name,
	a.company_name,
	a.primary_phone_number,
	a.secondary_phone_number,
	a.primary_email,
	a.do_not_email,
	a.do_not_sms,
	b.vin,
	b.purchase_date
	
	--max(purchase_date) as purchasedate

	select count(*)
from auto_customers.customer.customers (nolock) a 
left outer join auto_customers.customer.vehicles (nolock) b 
on a.customer_id = b.customer_id
where a.is_deleted =0 and b.is_deleted =0 
and b.account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244'
and (primary_phone_number_valid = 1 or secondary_phone_number_valid = 1 or primary_email_valid = 1) 
and a.account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244'
and isnull(a.is_unsubscribed,0) = 0 
and isnull(a.fleet_flag,0)=0
and (trim(primary_phone_number) <>'' or trim(secondary_phone_number) <>'')
and  ((primary_email_valid = 1 and isnull(do_not_email,1) = 0 and isnull(is_email_bounce,0) = 0) or len(isnull(address_line,'')) > 0 or 
((primary_phone_number_valid = 1 or secondary_phone_number_valid = 1) and isnull(do_not_sms,1) = 0))
--and convert(date,purchase_date) between '08-04-2015' and '08-04-2022'
and purchase_date > '08-05-2015'
and do_not_sms is null




	select count(*)
from auto_customers.customer.customers (nolock) a 
--left outer join auto_customers.customer.vehicles (nolock) b on a.customer_id = b.customer_id
where a.is_deleted =0 --and b.is_deleted =0 
and a.account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244'
and (primary_phone_number_valid = 1 or secondary_phone_number_valid = 1 or primary_email_valid = 1) 
and isnull(a.is_unsubscribed,0) = 0 
and isnull(a.fleet_flag,0)=0
--and (trim(primary_phone_number) <>'' or trim(secondary_phone_number) <>'')
and  ((primary_email_valid = 1 and isnull(do_not_email,1) = 0 and isnull(is_email_bounce,0) = 0) or len(isnull(address_line,'')) > 0 or 
((primary_phone_number_valid = 1 or secondary_phone_number_valid = 1)and isnull(do_not_sms,1) = 0))

--and customer_id not in (select distinct customer_id from auto_customers.customer.vehicles b (nolock) where b.is_Deleted =0 and b.account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244' )



	select count(*)
from auto_customers.customer.customers (nolock) a 
left outer join auto_customers.customer.vehicles (nolock) b 
on a.customer_id = b.customer_id
where a.is_deleted =0 and b.is_deleted =0 
and b.account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244'
and (primary_phone_number_valid = 1 or secondary_phone_number_valid = 1 or primary_email_valid = 1) 
and purchase_date is null
and a.account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244'
and isnull(a.is_unsubscribed,0) = 0 
and isnull(a.fleet_flag,0)=0
and (trim(primary_phone_number) <>'' or trim(secondary_phone_number) <>'')
and  ((primary_email_valid = 1 and isnull(do_not_email,1) = 0 and isnull(is_email_bounce,0) = 0) or len(isnull(address_line,'')) > 0 or 
((primary_phone_number_valid = 1 or secondary_phone_number_valid = 1)and isnull(do_not_sms,1) = 0))


	select count(*)
from auto_customers.customer.customers (nolock) a 
left outer join auto_customers.customer.vehicles (nolock) b 
on a.customer_id = b.customer_id
where a.is_deleted =0 and b.is_deleted =0 
and b.account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244'
and (primary_phone_number_valid = 1 or secondary_phone_number_valid = 1 or primary_email_valid = 1) 
and purchase_date < '08-04-2015'
and a.account_id = '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244'
and isnull(a.is_unsubscribed,0) = 0 
and isnull(a.fleet_flag,0)=0
and (trim(primary_phone_number) <>'' or trim(secondary_phone_number) <>'')
and  ((primary_email_valid = 1 and isnull(do_not_email,1) = 0 and isnull(is_email_bounce,0) = 0) or len(isnull(address_line,'')) > 0 or 
((primary_phone_number_valid = 1 or secondary_phone_number_valid = 1)and isnull(do_not_sms,1) = 0))



/*
Out of the 72789 customers with phone numbers
64139 customers don'nt have vehicles so no purchase date
6650 customers have vehicles but did'nt have purchase date in DB. these customers are from RO
1993 customers have purchasd date < 8-4-2015
*/
72789


select top 10 * from auto_customers.portal.account with (nolock)
select * from auto_customers.portal.account with (nolock) where accountname like 'garden%'

select 
	customer_id
	,first_name
	,last_name
	,primary_phone_number
	,primary_phone_number_valid
	,secondary_phone_number
	,secondary_phone_number_valid
	,primary_email
	,primary_email_valid
	,do_not_sms
	,do_not_email
	,is_deleted
from auto_customers.customer.customers (nolock)
where
	is_deleted =0
	and account_id  = '8CB2CED2-D574-4DEB-9C21-258EE7FD9C11'
	and list_ids like '%,3227,%'
order by 
		primary_phone_number

select * from auto_customers.list.lists (nolock) where is_Deleted =0 and account_id  = '8CB2CED2-D574-4DEB-9C21-258EE7FD9C11' and list_name like 'E-%'


select 
		customer_id
		,first_name
		,last_name
		,primary_phone_number
		,secondary_phone_number
		,primary_email
		,list_id
		,is_subscriber
		,tags
		,lead_status_id
		,lead_source_id
		,service_status_id
		,last_status_updated_date
		,list_ids
		,bdc_status_id
		,is_bdc
		,is_deleted
		,updated_by
		,updated_dt
from auto_customers.customer.customers (nolock)
where 
	--is_deleted =0
	account_id  = '8CB2CED2-D574-4DEB-9C21-258EE7FD9C11'
	and primary_phone_number = '9738019287'




	select
	list_ids,concat(list_ids,'3218,3226,3227,')
	--update a set list_ids = concat(list_ids,'3226,3218,')
	--update a set is_subscriber =1 ,tags = 'Garden State - E-Board',lead_status_id =2572,lead_source_id = 0,service_status_id =0,last_status_updated_date = '2022-06-21 15:16:21.637',bdc_status_id = 2705,is_bdc =0
	from auto_customers.customer.customers a (nolock)where customer_id  = 3533341



	--update a set is_deleted =1 
		from auto_customers.customer.customers a (nolock) where customer_id  = 3836343




		--------------------------#gardens_customers

drop table if exists #gardens_customers
select 
	 a.customer_id
	 ,first_name
	,last_name
	,list_id
	,is_subscriber
	,tags
	,lead_status_id
	,lead_source_id
	,service_status_id
	,last_status_updated_date
	,bdc_status_id
	,is_bdc
	,a.primary_phone_number
	,a.primary_phone_number_valid
	,a.secondary_phone_number
	,a.secondary_phone_number_valid
	,case when len(a.primary_phone_number) >= 10 then a.primary_phone_number
		  when len(a.primary_phone_number) < 10 and  len(a.secondary_phone_number) >= 10 then a.secondary_phone_number else '' end as phone_number
	,a.primary_email
	,b.vehicle_id
	,b.vin
	,b.make
	,b.model
	,b.year
	,a.is_deleted
	,list_ids

	into #gardens_customers
from auto_customers.customer.customers a  (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_deleted =0 and b.is_deleted =0
and (primary_phone_number_valid =1 or secondary_phone_number_valid =1 or primary_email_valid = 1)
and a.account_id  = '8CB2CED2-D574-4DEB-9C21-258EE7FD9C11'

drop table if exists #gardens_customers1
select *,Rank() over (partition by phone_number,primary_email,vin,make,model,year order by customer_id desc) as rnk
into #gardens_customers1
 from #gardens_customers

drop table if exists #rnk1
drop table if exists #rnk2
select * into #rnk1 from #gardens_customers1 where rnk = 1
select * into #rnk2 from #gardens_customers1 where rnk <> 1

select * from #rnk1 
select * from #rnk2 



---------------------------------considering only customers

drop table if exists #dup_cust
select 
	 a.customer_id
	 ,first_name
	,last_name
	,list_ids
	,is_subscriber
	,tags
	,lead_status_id
	,lead_source_id
	,service_status_id
	,last_status_updated_date
	,bdc_status_id
	,is_bdc
	,a.primary_phone_number
	,a.primary_phone_number_valid
	,a.secondary_phone_number
	,a.secondary_phone_number_valid
	,case when len(a.primary_phone_number) >= 10 then a.primary_phone_number
		  when len(a.primary_phone_number) < 10 and  len(a.secondary_phone_number) >= 10 then a.secondary_phone_number else '' end as phone_number
	,a.primary_email
into #dup_cust
from auto_customers.customer.customers a  (nolock)
where 
a.is_deleted =0 
and (primary_phone_number_valid =1 or secondary_phone_number_valid =1 or primary_email_valid = 1)
and a.account_id  = '8CB2CED2-D574-4DEB-9C21-258EE7FD9C11'



drop table if exists #dup_cust_rnk
select 
	*,Rank() over (partition by phone_number,primary_email order by primary_email desc,customer_id desc) as rnk
into #dup_cust_rnk
from #dup_cust

 select * from #dup_cust_rnk where rnk <> 1


  

 drop table if exists #rnk1_cust
 drop table if exists #rnk2_cust
 select customer_id,phone_number,rnk  into #rnk1_cust from #dup_cust_rnk where rnk = 1
 select customer_id,phone_number,rnk into #rnk2_cust from #dup_cust_rnk where rnk <> 1

 
 select 
 a.vehicle_id
 ,a.customer_id as veh_cust_id
 ,b.customer_id as rnk2_cust_id
 ,c.customer_id as rnk1_cust_id


 --update a set a.customer_id = c.customer_id, updated_by = 'sk_veh_change',updated_dt = getdate()
 from auto_customers.customer.vehicles a (nolock) 
 inner join #rnk2_cust b on a.customer_id  = b.customer_id
 inner join #rnk1_cust c on b.phone_number = c.phone_number
 where  is_deleted =0



 select *
 --update a set is_deleted =1, updated_by = 'sk_dupe_Del3', updated_dt = getdate()
 from auto_customers.customer.customers a (nolock)
 inner join #rnk2_cust b on a.customer_id = b.customer_id

-----------------------------------------------------Soft del done
 select * from #rnk2_cust
 select *
 from auto_customers.customer.customers (nolock) where customer_id in (3530035,3530036)


  select *
 from auto_customers.customer.vehicles (nolock) where customer_id in (3530035,3530036)


 select customer_id,phone_number,rnk from #dup_cust_rnk where trim(phone_number) in (select trim(phone_number) from #dup_cust_rnk where rnk <> 1)
 order by phone_number

 select 
  a.customer_id
 ,b.customer_id
 ,a.phone_number,b.phone_number
 ,a.primary_email,b.primary_email
 ,a.is_subscriber,b.is_subscriber
 ,a.list_ids,b.list_ids
 ,a.lead_status_id,b.lead_status_id
 ,a.lead_source_id,b.lead_source_id
 ,a.tags,b.tags
 from #rnk1 a
 inner join #rnk2 b on a.phone_number = b.phone_number and isnull(a.primary_email,'') = isnull(b.primary_email,'')
 where b.customer_id not in (3526998)



  select a.customer_id,b.customer_id, a.is_deleted

  --update a set is_Deleted =1, updated_by ='sk_dupe_del2',updated_dt = getdate()
  from auto_customers.customer.customers a  (nolock)
inner join #rnk2 b on a.customer_id = b.customer_id


select * into #rnk1 from (
  select *,Rank() over (partition by phone_number,vin,make,model,year order by primary_email desc,customer_id desc) as rnk
 from #gardens_customers
 ) as a where rnk = 1 and len(phone_number) <> 0



select * into #rnk2 from (
  select *,Rank() over (partition by phone_number,vin,make,model,year order by primary_email desc,customer_id desc) as rnk
 from #gardens_customers
 ) as a where rnk <> 1 and len(phone_number) <> 0

select distinct customer_id from #rnk2

  select distinct
	 a.customer_id
	 ,b.customer_id
	 ,a.phone_number,b.phone_number
	 ,a.primary_email,b.primary_email
	 ,a.is_subscriber,b.is_subscriber
	 ,a.list_ids,b.list_ids
	 ,a.lead_status_id,b.lead_status_id
	 ,a.lead_source_id,b.lead_source_id
	 ,a.tags,b.tags
 from #rnk1 a
 inner join #rnk2 b on a.phone_number = b.phone_number 

 drop table if exists #list_concat
 select a.customer_id as customer_id1
 ,b.customer_id as customer_id2
 ,a.list_ids as list_ids1
 ,b.list_ids as list_ids2
 ,concat(a.list_ids,b.list_ids) as tot_list

 	 into #list_concat
 from #rnk1 a
 inner join #rnk2 b on a.phone_number = b.phone_number 

 drop table if exists #list_concat2
 select distinct
customer_id1,customer_id2,list_ids1,list_ids2,value
into #list_concat2
 from #list_concat 
 cross apply string_split(tot_list,',')
where len(value) <> 0



drop table if exists #list_concat3
select customer_id1,customer_id2,list_ids1,list_ids2,concat(string_agg([value],','),',') as new_list_ids
into #list_concat3
from #list_concat2
group by customer_id1,customer_id2,list_ids1,list_ids2

select * from #list_concat3




 select * from (
 select customer_id,primary_phone_number,secondary_phone_number,primary_email
 	,case when len(a.primary_phone_number) >= 10 then a.primary_phone_number
		  when len(a.primary_phone_number) < 10 and  len(a.secondary_phone_number) >= 10 then a.secondary_phone_number else '' end as phone_number

 from auto_customers.customer.customers a  (nolock)
 where 
a.is_deleted =0 
and (primary_phone_number_valid =1 or secondary_phone_number_valid =1 or primary_email_valid = 1)
and a.account_id  = '8CB2CED2-D574-4DEB-9C21-258EE7FD9C11'
and (primary_phone_number in (  select phone_number from #rnk2)
		or
		secondary_phone_number in (  select phone_number from #rnk2)
	)	) as a order by phone_number,primary_Email
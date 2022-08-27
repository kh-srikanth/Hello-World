select * 
from auto_customers.customer.customers (nolock) 
where 
	is_Deleted =0 
	and account_id  = 'eff907ca-21c5-4703-8bdc-c0d06218908f'



select * from auto_customers.portal.account with (nolock) where _id  = 'eff907ca-21c5-4703-8bdc-c0d06218908f'


select * from auto_customers.list.lists (nolock) where is_Deleted =0 and account_id  = 'eff907ca-21c5-4703-8bdc-c0d06218908f'

select * from [18.216.140.206].[r2r_admin].[owner].[contact_list] with (nolock) where dealer_id  = 48654 and is_deleted =0 --18


select count(*) from [18.216.140.206].[r2r_admin].[owner].[owner] with (nolock) where is_deleted =0 and dealer_id  = 48654 and contact_list_ids like '%,13229%' 
and (is_lime_opted_in =1 or (is_email_suppressed = 0 and is_email_bounced = 0) or is_app_user = 1) 

select count(*) from auto_customers.customer.customers (nolock) where 	is_Deleted =0 	and account_id  = 'eff907ca-21c5-4703-8bdc-c0d06218908f' and list_ids like '%,1116,%'
and (primary_email_valid = 1 or primary_phone_number_Valid =1 or secondary_phone_number_valid = 1)


drop table if exists #temp
select 
	 a.customer_id
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

	into #temp
from auto_customers.customer.customers a  (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_deleted =0 
and (primary_phone_number_valid =1 or secondary_phone_number_valid =1 or primary_email_valid = 1)
and a.account_id  = 'eff907ca-21c5-4703-8bdc-c0d06218908f'




drop table if exists #temp1
select *
,Rank() over (partition by phone_number,primary_email,vin,make,model,year order by customer_id desc) as rnk
into #temp1
from #temp


select * from #temp1 where rnk <> 1


drop table if exists #rnk1
select * into #rnk1 from #temp1 where rnk =1

drop table if exists #rnk2
select * into #rnk2 from #temp1 where rnk <> 1




drop table if exists #lists_concat
select 
		a.customer_id as customer_id1
		,b.customer_id as customer_id2
		,a.list_ids as list_ids1
		,b.list_ids as list_ids2
		,concat(a.list_ids,b.list_ids) as tot_list
into #lists_concat
from #rnk2 a
inner join #rnk1 b on a.phone_number = b.phone_number and a.primary_email = b.primary_email


drop table if exists #lists_concat2
select distinct
customer_id1,customer_id2,list_ids1,list_ids2,value
into #lists_concat2
from #lists_concat
cross apply string_split(tot_list,',')
where len(value) <> 0



drop table if exists #lists_concat3
select customer_id1,customer_id2,list_ids1,list_ids2,concat(string_agg([value],','),',') as new_list_ids
into #lists_concat3
from #lists_concat2
group by customer_id1,customer_id2,list_ids1,list_ids2


select * from #lists_concat3



select 
customer_id,customer_id2
,list_ids,new_list_ids

--update a set a.list_ids = b.new_list_ids
from auto_customers.customer.customers a  (nolock) 
inner join #lists_concat3  b on a.customer_id = b.customer_id2
where 
is_deleted =0 and a.account_id  = 'eff907ca-21c5-4703-8bdc-c0d06218908f'
and list_ids <> new_list_ids




select a.customer_id
--update a set is_deleted =1, updated_by = 'sk_dupe_del',updated_dt = getdate()
from auto_customers.customer.customers a  (nolock) 
inner join #rnk2 b on a.customer_id =b.customer_id
where a.is_deleted =0 and a.account_id  = 'eff907ca-21c5-4703-8bdc-c0d06218908f'



select * from auto_customers.customer.customers a  (nolock) where 
is_deleted =0 and a.account_id  = 'eff907ca-21c5-4703-8bdc-c0d06218908f' and primary_email = 'NONE@USA.COM'



select * from #temp1 where primary_email = 'NONE@USA.COM' and phone_number = '4087185550'


select * 
--update a set is_deleted =1 ,updated_by = 'sk_dupe_del',updated_dt = getdate()
from auto_customers.customer.customers a  (nolock) where 
is_deleted =0 and a.account_id  = 'eff907ca-21c5-4703-8bdc-c0d06218908f' and customer_id in 
(
2677679
,2677675
,2677673
,2677671
,2677669
,2677667
,2677665
,2677663
,2673761
,2673759
,2673757
,2673755
,2673753
,2673751
)
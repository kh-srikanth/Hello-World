--------------------------------------------------------------------------------------
use auto_customers
drop table if exists #makemodel
select distinct
	a.make
	,a.model
	,a.year
	,c.account_id
	,c.accountname
into #makemodel
from auto_customers.customer.vehicles a (nolock)
inner join auto_customers.customer.customers b (nolock) on a.customer_id = b.customer_id
inner join auto_customers.portal.account c with (nolock) on b.account_id = c._id and c.accountstatus not in ('inactive')
where 
		a.is_deleted =0 
		and parentid in ('C994B4F4-666E-446B-9A2F-C4985EBEA150','2FFC0052-6D81-46B5-AD31-E47BBA081346','5FB8E2CB-36CD-48C3-9CC7-03B0414D5013')


select * from #makemodel order by account_id,make,model,year

select * from auto_customers.portal.account c with (nolock) where _id IN ('9dbf432c-0da6-4337-80bf-e24f03e9d821','de352067-1436-40b0-8ba4-86d036a3ce0d')
select * from auto_customers.portal.account c with (nolock) where accountname like 'garden%'
select * from auto_customers.portal.account c with (nolock) where accountstatus = 'inactive'

insert into clictell_auto_master.master.vehicle_makemodel
(
	 make
	,makedesc
	,model
	,modeldesc
	,modelyear
	,parent_dealer_id
	,vertical_id
	,created_by
	,updated_by
	,created_dt
	,updated_dt
)


select distinct 
	 a.make
	,a.make as makedesc
	,a.model
	,a.model as modeldesc
	,a.year as modelyear
	,a.account_id as parent_dealer_id
	--,a.accountname
	,2 as vertical_id
	,concat(suser_name(),' acc_id') as created_by
	,SUSER_NAME() AS updated_by
	,getdate() as created_dt
	,getdate() as updated_dt
	--into #temp
from #makemodel a
left outer join clictell_auto_master.master.vehicle_makemodel b (nolock) on 
																			isnull(a.make,'') = isnull(b.make,'')
																			and isnull(a.model,'') = isnull(b.model,'') 
																			and isnull(a.year,'') = isnull(b.modelyear,'') 
																			and a.account_id  = b.parent_dealer_id
																			and b.is_deleted =0
where b.makemodel_id is null
and a.account_id not in (4301)

order by a.account_id,a.make,a.model,year



select accountname,parent_dealer_id,count(*) from #temp group by accountname,parent_dealer_id order by accountname 

select accountname,account_id, count(*) from #makemodel where account_id not in (4301) group by accountname,account_id order by accountname 



select count(*) from #temp where parent_dealer_id = 4335
select distinct count(*) from #makemodel where account_id = 4335

select * from clictell_auto_master.master.vehicle_makemodel (nolock) where is_Deleted =0 and parent_dealer_id is not null and vertical_id = 2
select * from dbo.brother_map_makemodel (nolock)  --446
select * from auto_customers.portal.account with (nolock) where accountname like 'brother%'

drop table if exists #temp_customer
select 
	a.customer_id
	,a.first_name
	,a.last_name
	,case when primary_phone_number_valid =1 then primary_phone_number 
			when primary_phone_number_valid = 0 and secondary_phone_number_valid = 1 then secondary_phone_number 
			else primary_phone_number end as phone
	,b.vehicle_id
	,b.make
	,b.model
	,b.year
	into #temp_customer
from auto_customers.customer.customers a (nolock)
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id and b.is_deleted = 0
where 
		a.is_deleted =0 
		and a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'

select * from #temp_customer order by vehicle_id


drop table if exists #result
		select 
			b.customer_id
			,a.[First Name]
			,b.first_name
			,a.[Last Name]
			,b.last_name
			,a.Number
			,b.phone
			,b.vehicle_id
			,b.make
			,b.model
			,b.year
			,a.[option]
		into #result
		from dbo.brother_map_makemodel a (nolock)
		left outer join #temp_customer b on convert(varchar(100),a.Number) = concat('1',convert(varchar(100),b.phone))

		order by a.[option],a.Number

		select 
			[First Name],[Last Name],Number,isnull(make,'') as Make,isnull(model,'') as Model,isnull(convert(varchar(20),year),'') as Year,[option] 
		from #result 
		--where make is not null
		order by [option], phone
		
		select count(distinct customer_id) from (
		select 
			*
			,rank() over (partition by phone order by customer_id desc) as rnk 
			,rank() over (partition by phone order by vehicle_id desc) as rnk2
		from #result
		--where phone = '9123227826'
		) as a where rnk = case when vehicle_id is null then 2 else 1 end
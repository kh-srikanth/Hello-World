use auto_customers
select * from dbo.cycledesign_models (nolock)


drop table if exists #model_yrs
;with cte as
(
select 1970 as [year]
union all
select [year]+1 from cte
where [year] < 2022
)
select * into #model_yrs from cte


select * from #model_yrs




select top 10 * from clictell_auto_master.master.vehicle_makemodel
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
select 
	 make
	,make as makedesc
	,model
	,model as modeldesc
	,year as modelyear
	,4301 as parent_dealer_id
	,2 as vertical_id
	,suser_name()
	,suser_name()
	,getdate()
	,getdate()
from dbo.cycledesign_models (nolock)
cross apply #model_yrs
order by make,model,year


select * 
from clictell_auto_master.master.vehicle_makemodel a (nolock) where parent_dealer_id  = 4301 and vertical_id =2 




select * from portal.account with (nolock) where accountname like 'Cycle Design%' and accountstatus = 'active' --4301

select * from clictell_auto_master.master.dealer (nolock) where _id = 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A'
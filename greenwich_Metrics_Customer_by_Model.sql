use clictell_auto_master
go
IF OBJECT_ID('tempdb..#new_customers') IS NOT NULL DROP TABLE #new_customers
IF OBJECT_ID('tempdb..#active_customers') IS NOT NULL DROP TABLE #active_customers
IF OBJECT_ID('tempdb..#lapsed_customers') IS NOT NULL DROP TABLE #lapsed_customers
IF OBJECT_ID('tempdb..#lost_customers') IS NOT NULL DROP TABLE #lost_customers

select --161
	v.make
	,v.model
	,count(distinct(s.cust_dms_number)) as new_customers
into #new_customers
from master.fi_sales s (nolock) 
inner join master.vehicle v (nolock) on v.vin =s.vin
left outer join master.repair_order_header rh (nolock) on s.vin = rh.vin


where	s.parent_dealer_id =1806 
		and rh.ro_open_date is null 
		and datediff(month,convert(date,convert(varchar(8),s.purchase_date)),getdate()) < 12

group by v.make,v.model



select			--198
	v.make
	,v.model
	,count(distinct(cust_dms_number)) as active_customers
into #active_customers
from master.repair_order_header rh (nolock) 
inner join master.vehicle v (nolock) on v.vin =rh.vin

where	rh.parent_dealer_id =1806 
		and datediff(month,convert(date,convert(varchar(8),rh.ro_open_date)),getdate()) < 12

group by v.make,v.model


select		--219
	v.make
	,v.model
	,count(distinct(s.cust_dms_number)) as lapsed_customers
into #lapsed_customers
from master.fi_sales s (nolock) 
inner join master.vehicle v (nolock) on v.vin =s.vin
full join master.repair_order_header rh (nolock) on s.vin = rh.vin


where	s.parent_dealer_id =1806 
		and 
		((datediff(month,convert(date,convert(varchar(8),s.purchase_date)),getdate()) between 12 and 24 and rh.ro_close_date is null)
		or datediff(month,convert(date,convert(varchar(8),rh.ro_close_date)),getdate()) between 12 and 24)

group by v.make,v.model


select		--97
	v.make
	,v.model
	,count(distinct(s.cust_dms_number)) as lost_customers
into #lost_customers
from master.fi_sales s (nolock) 
inner join master.vehicle v (nolock) on v.vin =s.vin
full join master.repair_order_header rh (nolock) on s.vin = rh.vin


where	s.parent_dealer_id =1806 
		and 
		((datediff(month,convert(date,convert(varchar(8),s.purchase_date)),getdate()) > 24 and rh.ro_close_date is null)
		or datediff(month,convert(date,convert(varchar(8),rh.ro_close_date)),getdate()) > 24)

group by v.make,v.model


select -- distinct --536
		isnull(n.make,isnull(a.make,isnull(l.make,lo.make))) as make
		,isnull(n.model,isnull(a.model,isnull(l.model,lo.model))) as model
		,isnull(new_customers,0) as new_customers
		,isnull(active_customers,0) as active_customers
		,isnull(lapsed_customers,0) as lapsed_customers
		,isnull(lost_customers,0) as lost_customers

from #new_customers n
full join #active_customers a on a.make =n.make and a.model=n.model
full join #lapsed_customers l on l.make =n.make and l.model=n.model
full join #lost_customers lo on lo.make =n.make and lo.model=n.model

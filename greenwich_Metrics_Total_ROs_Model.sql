use clictell_auto_master
go

select
		year(convert(date,convert(varchar(10),ro_close_date))) as yr
		,datename(month,convert(date,convert(varchar(10),ro_close_date)))  as mnt
		,month(convert(date,convert(varchar(10),ro_close_date))) as mnt_num
		,make
		,model
		,sum(total_customer_price) as cp
		,sum(total_warranty_price) as wp
		,sum(total_internal_price) as ip
		,sum(total_labor_price) as lc
		,count(distinct(ro_number)) as ro_count
		,count(is_declined) as total_declines
from master.repair_order_header rh (nolock) 
inner join master.vehicle v (nolock) on rh.vin =v.vin

where ro_close_date is not null 
	and rh.parent_dealer_id = 1806

group by year(convert(date,convert(varchar(10),ro_close_date))),
		month(convert(date,convert(varchar(10),ro_close_date))),
		datename(month,convert(date,convert(varchar(10),ro_close_date))),
		make,model

order by year(convert(date,convert(varchar(10),ro_close_date))),
		month(convert(date,convert(varchar(10),ro_close_date))),
		datename(month,convert(date,convert(varchar(10),ro_close_date))),
		make,model


select 
convert(date,convert(varchar(10),min(ro_close_date))) as min_service_date 
,convert(date,convert(varchar(10),max(ro_close_date))) as max_service_date 
from master.repair_order_header (nolock) 
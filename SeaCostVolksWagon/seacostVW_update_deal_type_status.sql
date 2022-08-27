    ,(case when a.[Deal Status]  = '1' then 'Sold' when a.[Deal Status]  = '2' then 'Delivered' when a.[Deal Status]  = '3' then 'Booked' else a.[Deal Status] end)---** 



	select 
	deal_status, case when deal_status  = '1' then 'Sold' when deal_status  = '2' then 'Delivered' when deal_status  = '3' then 'Booked' else deal_status end
	--update a set
	--	deal_status = case when deal_status  = '1' then 'Sold' when deal_status  = '2' then 'Delivered' when deal_status  = '3' then 'Booked' else deal_status end
	--select *
	from clictell_auto_master.master.fi_sales a (nolock) where parent_dealer_id = 4592

	select top 10 * from clictell_auto_master.master.dealer (nolock) where dealer_name like 'sea%'

	select distinct deal_status from clictell_auto_master.master.fi_sales (nolock)
	select distinct deal_type from clictell_auto_master.master.fi_sales (nolock)
	select distinct deal_type from clictell_auto_stg.stg.fi_sales (nolock)


--,(case when a.[Deal Type] = 'L' then 'Lease' when a.[Deal Type] = 'P' then 'Purchased' when a.[Deal Type] = 'F' then 'Financed' else a.[Deal Type] end) ---***

select --top 10 
	a.[Deal Number]
	,b.deal_number_dms
	,c.deal_number_dms
	,a.[Deal Status]
	,b.deal_status
	,c.deal_status
	,a.[Deal Type]
	,b.deal_type
	,c.deal_type
	,(case when a.[Deal Type] = 'L' then 'Lease' when a.[Deal Type] = 'P' then 'Purchased' when a.[Deal Type] = 'F' then 'Financed' else a.[Deal Type] end)

--update c set c.deal_type = (case when a.[Deal Type] = 'L' then 'Lease' when a.[Deal Type] = 'P' then 'Purchased' when a.[Deal Type] = 'F' then 'Financed' else a.[Deal Type] end)
from clictell_auto_etl.etl.atc_sales1 a (nolock)
inner join clictell_auto_stg.stg.fi_sales b (nolock) on a.[Deal Number] = b.deal_number_dms
inner join clictell_auto_master.master.fi_sales c(nolock) on a.[Deal Number] = c.deal_number_dms
where 
c.parent_dealer_id = 4592



select top 3 * from clictell_auto_etl.etl.atc_sales1 a (nolock)
select top 3 * from clictell_auto_stg.stg.fi_sales b (nolock) 
select top 3 * from clictell_auto_master.master.fi_sales c(nolock) 

select distinct sale_type from clictell_auto_master.master.fi_sales c(nolock) where parent_dealer_id not in (4592)
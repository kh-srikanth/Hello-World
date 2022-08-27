USE clictell_auto_master
GO

declare @dealer_id int =1806
--select top 10 * from clictell_auto_stg.stg.fi_sales_people (nolock)
--select top 10 * from clictell_auto_master.master.fi_sales_people (nolock) where deal_number_dms = '0008281'
--select top 10 * from clictell_auto_master.master.fi_sales (nolock) where parent_dealer_id =1806 and deal_number_dms = '0008281'
--select top 10 sales_rep1_name,sales_rep1_number,sales_rep2_name,sales_rep2_number,* from clictell_auto_stg.stg.fi_sales (nolock) where parent_dealer_id =1806 and deal_number_dms = '0008281'
--select count(*) from clictell_auto_stg.stg.fi_sales (nolock) where parent_dealer_id =3407 and len(sales_rep2_name) <> 0
--select * from clictell_auto_etl.etl.atm_employee (nolock) where dmsid in ( '997','876','444')

/*insert into clictell_auto_stg.stg.fi_sales_people (
		natural_key
		,parent_dealer_id
		,deal_number_dms
		,deal_date
		,purchase_date
		,sales_people_type_id
		,sales_people_slno
		,sale_contact_id
		,sale_full_name
		,vin
		,file_process_id
		,file_process_detail_id
)*/


select 
		a.natural_key
		,a.parent_dealer_id
		,a.deal_number_dms
		,a.deal_date
		,a.purchase_date
		,2 as sales_people_type_id
		,0 as sales_people_slno
		,a.sales_manager_id
		,a.sales_manager_fullname
		,a.vin
		,a.file_process_id
		,a.file_process_detail_id


from clictell_auto_stg.stg.fi_sales a (nolock)
--left outer join clictell_auto_etl.etl.atm_employee b(nolock) on a.sales_rep1_number = b.DMSId
left outer join clictell_auto_stg.stg.fi_sales_people b (nolock) 
			on a.parent_dealer_id=b.parent_dealer_id 
				and a.deal_number_dms = b.deal_number_dms
				and a.sales_manager_id = b.sale_contact_id
where 
		b.stg_sales_people_id is null
		and a.deal_status in ('Sold','Finalized','Booked/Recapped')
		and a.parent_dealer_id = @dealer_id

union
select 
		a.natural_key
		,a.parent_dealer_id
		,a.deal_number_dms
		,a.deal_date
		,a.purchase_date
		,3 as sales_people_type_id
		,0 as sales_people_slno
		,a.fin_manger_id
		,a.fin_manager_fullname
		,a.vin
		,a.file_process_id
		,a.file_process_detail_id


from clictell_auto_stg.stg.fi_sales a (nolock)
left outer join clictell_auto_stg.stg.fi_sales_people b (nolock) 
			on a.parent_dealer_id=b.parent_dealer_id 
				and a.deal_number_dms = b.deal_number_dms
				and a.fin_manger_id = b.sale_contact_id
where 
		b.stg_sales_people_id is null
		and a.deal_status in ('Sold','Finalized','Booked/Recapped')
		and a.parent_dealer_id = @dealer_id

union
select 
		a.natural_key
		,a.parent_dealer_id
		,a.deal_number_dms
		,a.deal_date
		,a.purchase_date
		,1 as sales_people_type_id
		,0 as sales_people_slno
		,a.sales_rep1_number
		,a.sales_rep1_name
		,a.vin
		,a.file_process_id
		,a.file_process_detail_id


from clictell_auto_stg.stg.fi_sales a (nolock)
left outer join clictell_auto_stg.stg.fi_sales_people b (nolock) 
			on a.parent_dealer_id=b.parent_dealer_id 
				and a.deal_number_dms = b.deal_number_dms
				and a.sales_rep1_number = b.sale_contact_id

inner join master.fi_sales c (nolock) on a.deal_number_dms = c.deal_number_dms and a.parent_dealer_id = c.parent_dealer_id

where 
		b.stg_sales_people_id is null
		and a.deal_status in ('Sold','Finalized','Booked/Recapped')
		and a.parent_dealer_id = @dealer_id


--select * from master.fi_sales (nolock) where deal_number_dms = '0007229'
--select deal_status,file_process_detail_id,* from clictell_auto_stg.stg.fi_sales a (nolock) where deal_number_dms = '0007229' and deal_status = 'Finalized'

--select distinct * from clictell_auto_stg.stg.fi_sales a (nolock) where parent_dealer_id =1806 and purchase_date is  null

select * from master.cust_2_vehicle a (nolock)
inner join master.repair_order_header
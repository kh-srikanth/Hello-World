use clictell_auto_master
go
IF OBJECT_ID('tempdb..#rh') IS NOT NULL DROP TABLE #rh
IF OBJECT_ID('tempdb..#rd') IS NOT NULL DROP TABLE #rd
IF OBJECT_ID('tempdb..#t1') IS NOT NULL DROP TABLE #t1


--select distinct opcode_pay_type from master.repair_order_header_detail (nolock)  --
--,2167,2220,2203,2218,2183,2195,2186,2211,2159
select * 
into #rh 
from master.repair_order_header (nolock) where parent_dealer_id =1806 -- and ro_number in (2167,2220,2203,2218,2183,2195,2186,2211,2159)

select *, row_number() over (partition by ro_number,opcode_pay_type,op_code_sequence,op_code order by op_code_sequence) as rnk
into #rd
from master.repair_order_header_detail (nolock) where parent_dealer_id =1806 -- and ro_number in (2167,2220,2203,2218,2183,2195,2186,2211,2159)


select 
	master_ro_header_id
	,opcode_pay_type as opcode_pay_type
	,sum(total_labor_price) as labor_price
	,sum(total_parts_price) as parts_price
	,sum(total_misc_price) as misc_price

into #t1
from #rd where rnk =1
group by master_ro_header_id, opcode_pay_type

/*
replace #rh with master.repair_order_header (nolock) from here
*/


update a set
a.total_customer_labor_price = b.labor_price
from #rh a 
inner join #t1 b on a.master_ro_header_id = b.master_ro_header_id 
where b.opcode_pay_type = 'Customerpay'
and a.total_customer_labor_price != b.labor_price

update a set
a.total_warranty_labor_price = b.labor_price
from #rh a 
inner join #t1 b on a.master_ro_header_id = b.master_ro_header_id 
where b.opcode_pay_type = 'Warranty'
and a.total_warranty_labor_price != b.labor_price


update a set
a.total_internal_labor_price = b.labor_price
from #rh a 
inner join #t1 b on a.master_ro_header_id = b.master_ro_header_id 
where b.opcode_pay_type in  ('Internal','ServiceContract')
and a.total_internal_labor_price != b.labor_price

update a set
a.total_customer_parts_price = b.parts_price
from #rh a 
inner join #t1 b on a.master_ro_header_id = b.master_ro_header_id 
where b.opcode_pay_type = 'Customerpay'
and a.total_customer_parts_price != b.parts_price

update a set
a.total_warranty_parts_price = b.parts_price
from #rh a 
inner join #t1 b on a.master_ro_header_id = b.master_ro_header_id 
where b.opcode_pay_type = 'Warranty'
and a.total_warranty_parts_price != b.parts_price


update a set
a.total_internal_parts_price = b.parts_price
from #rh a 
inner join #t1 b on a.master_ro_header_id = b.master_ro_header_id 
where b.opcode_pay_type in  ('Internal','ServiceContract')
and a.total_internal_parts_price != b.parts_price


/*
update #rh set  
	total_customer_labor_price = (select labor_price from #t1 where opcode_pay_type = 'CustomerPay' and #rh.ro_number = #t1.ro_number),
	total_customer_parts_price = (select parts_price from #t1 where opcode_pay_type = 'CustomerPay' and #rh.ro_number = #t1.ro_number),
	total_customer_misc_price =  (select misc_price from #t1 where opcode_pay_type = 'CustomerPay' and #rh.ro_number = #t1.ro_number),

	total_internal_labor_price = (select labor_price from #t1 where opcode_pay_type = 'internal' and #rh.ro_number = #t1.ro_number),
	total_internal_parts_price = (select parts_price from #t1 where opcode_pay_type = 'internal' and #rh.ro_number = #t1.ro_number),
	total_internal_misc_price =  (select misc_price from #t1 where opcode_pay_type = 'internal' and #rh.ro_number = #t1.ro_number),

	total_warranty_labor_price = (select labor_price from #t1 where opcode_pay_type = 'warranty' and #rh.ro_number = #t1.ro_number),
	total_warranty_parts_price = (select parts_price from #t1 where opcode_pay_type = 'warranty' and #rh.ro_number = #t1.ro_number),
	total_warranty_misc_price =  (select misc_price from #t1 where opcode_pay_type = 'warranty' and #rh.ro_number = #t1.ro_number)
*/
update #rh set
	total_customer_price = isnull(total_customer_labor_price,0) + isnull(total_customer_parts_price,0) + isnull(total_customer_misc_price,0), 
	total_internal_price = isnull(total_internal_labor_price,0) + isnull(total_internal_parts_price,0) + isnull(total_internal_misc_price,0), 
	total_warranty_price = isnull(total_warranty_labor_price,0) + isnull(total_warranty_parts_price,0) + isnull(total_warranty_misc_price,0) 

update #rh set
	total_parts_price = isnull(total_customer_parts_price,0) + isnull(total_internal_parts_price,0) + isnull(total_warranty_parts_price,0),
	total_labor_price = isnull(total_customer_labor_price,0) + isnull(total_internal_labor_price,0) + isnull(total_warranty_labor_price,0)

update #rh set
	total_repair_order_price = isnull(total_parts_price,0) + isnull(total_labor_price,0)

select 
ro_number
,total_customer_labor_price
,total_warranty_labor_price
,total_internal_labor_price
,total_labor_price
,total_customer_parts_price
,total_warranty_parts_price
,total_internal_parts_price
,total_parts_price
,total_customer_price
,total_warranty_price
,total_internal_price
,total_repair_order_price
from #rh order by ro_number
USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[OpCodeAnalysis]    Script Date: 3/26/2021 5:15:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec [reports].[OpCodeAnalysis] 'All',500
*/

ALTER PROCEDURE [reports].[OpCodeAnalysis]
--declare
@opcode varchar(10) = 'All',
@dealer_id varchar(10) = '500'
--@opcode_desc varchar(100) = ''

as
begin

select distinct
rd.op_code
,rd.op_code_desc
,rd.ro_number
,p.part_number
,rh.total_labor_price-rh.total_labor_cost as labor_gross_profit
,rh.total_parts_price-rh.total_parts_cost as gross_unit
,rh.total_repair_order_price-rh.total_repair_order_cost as gross_totalRO
,rd.billed_labor_hours
,rh.total_billed_labor_hours


from master.repair_order_header_detail rd
left outer join master.repair_order_header rh on rd.ro_number = rh.ro_number
left outer join master.ro_parts_details p on rd.ro_number = p.ro_number and p.master_ro_detail_id = rd.master_ro_detail_id
where (@opcode = 'All' or (@opcode !='All' and @opcode = op_code))
and @dealer_id = rd.parent_Dealer_id
--or (@opcode_desc = 'All' or (@opcode_desc !='All' and @opcode_desc = op_code_desc))

end

use clictell_auto_master
GO

drop table if exists #temp_opcode
drop table if exists #opcode_cat
drop table if exists #opcode

--load data to temp tables
select distinct op_code, op_code_desc into #temp_opcode from master.ro_op_codes (nolock) where op_code_desc is not null 
select * into #opcode_cat from [master].[OpCode_category] (nolock) where is_deleted =0

--aggrigating all opcode_desc group by op_code
select distinct 
		op_code
		,string_agg(convert(varchar(max),op_code_desc),',') as op_desc_agg
		,null as op_category_id 
	into #opcode 
from #temp_opcode 
group by op_code
order by op_code

--Joining op_code_categories and op_code tables with search by key words and aggregating opcode_category_id::result
select op_code,op_desc_agg,string_agg(convert(varchar(max),OpCode_category_id),',') as opcode_cat_id
into #result
from #opcode a 
left outer join #opcode_cat b on a.op_desc_agg like '%'+OpCode_category_desc+'%'
group by op_code,op_desc_agg
order by op_code

select * from #result

/*

select distinct op_code from master.ro_op_codes (nolock) where op_code_desc is not null
select * from #opcode
select * from #opcode_cat
--select distinct op_code from master.ro_op_codes (nolock) where op_code_desc is not null
--select * from #opcode 

--select * from master.ro_op_codes (nolock) where op_code_desc is not null

select 
--update a set
a.op_category_id_del , b.opcode_cat_id

from master.ro_op_codes a (nolock)
inner join #result b on a.op_code = b.op_code

select op_code_desc,count(*) from master.ro_op_codes a (nolock) where op_code ='05' group by op_code_desc

*/
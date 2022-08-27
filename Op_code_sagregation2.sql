use clictell_auto_master
GO

drop table if exists #temp_opcode
drop table if exists #opcode_cat
drop table if exists #opcode
drop table if exists #result

--load data to temp tables
select distinct op_code, op_code_desc into #temp_opcode from master.ro_op_codes (nolock) where op_code_desc is not null 
--split opcode_category_desc and load into temp table
select 
		a.OpCode_category_id, OpCode_category_code, value as OpCode_category_desc 
	into #opcode_cat 
from 
[master].[OpCode_category] a (nolock) 
cross apply string_split(OpCode_category_desc,' ') 
where is_deleted =0

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
select 
		op_code,
		op_desc_agg, 
		string_agg(convert(varchar(max),b.OpCode_category_id),',') as opcode_cat_id
	into #result
from 
#opcode a 
left outer join #opcode_cat b on a.op_desc_agg like   '%'+ b.OpCode_category_desc + '%'
group by op_code,op_desc_agg
order by op_code

--select * from #opcode
select * from #result --where opcode_cat_id is null
--select * from #opcode_cat order by OpCode_category_id
--select distinct op_code from master.ro_op_codes (nolock) where op_code_desc is not null
--select * from #opcode 

--select *,value from #opcode_cat cross apply string_split(OpCode_category_desc,' ')
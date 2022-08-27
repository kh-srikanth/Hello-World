use clictell_auto_master
GO
drop table if exists #temp_opcode_desc
drop table if exists #opcode_cat
drop table if exists #result
drop table if exists #sort
drop table if exists #list
drop table if exists #soln
drop table if exists #soln1
drop table if exists #final

--load master.ro_op_codes data to temp tables
select distinct 
		 op_code
		,op_code_desc
		,null as opcode_desc_cat_id  
	into #temp_opcode_desc 
from master.ro_op_codes (nolock) 
where op_code_desc is not null 
--load [master].[OpCode_category] data to temp tables
select * into #opcode_cat from [master].[OpCode_category] (nolock) where is_deleted =0


--joining #temp_opcode_desc and #opcode_cat to segrigate op_code_desc
select 
		 a.op_code
		,a.op_code_desc
		,b.OpCode_category_id as opcode_cat_id
	into #result
from #temp_opcode_desc a
left outer join #opcode_cat b on a.op_code_desc like '%'+b.OpCode_category_desc+'%'

--give ranks for op_code_desc coming under multiple categories
select 
		*
		,ROW_NUMBER() over (partition by op_code,opcode_cat_id  order by op_code_desc) as row_no  
	into #sort 
from #result where opcode_cat_id is not null 

--Pulling categories which are frequently joined to an op_code_desc
select 
		op_code
		,max(row_no) as max_ro_no 
	into #list 
from #sort 
group by op_code

--get records with categories got by above query
select a.*
	into #soln
from #sort a 
inner join #list b on a.op_code = b.op_code and a.row_no = b.max_ro_no

-- getting category_desc column to analyze op_codes still falling under more than two categories
select a.*,b.OpCode_category_desc
	into #soln1 
from #soln a
inner join #opcode_cat b on a.opcode_cat_id = b.OpCode_category_id


--select * from #soln1 where op_code = '01'
 
select 
		a.master_ro_op_code_id,a.op_code,a.op_code_desc,b.opcode_cat_id,b.OpCode_category_desc 
	into #final
from master.ro_op_codes a (nolock)
left outer join #soln1 b on a.op_code = b.op_code
where a.op_code_desc is not null
order by op_code


select * from #final where opcode_cat_id is not null order by op_code ---Total Records: 146,658; Records Categorized: 120,684


select distinct opcode_cat_id from #final where opcode_cat_id is not null order by opcode_cat_id




--select distinct op_code,opcode_cat_id,OpCode_category_desc from #final order by op_code

/*
select op_code,count(*) from #soln1 group by op_code having count(*) >1

select * from #soln1 where op_code = 'MT'


select b.op_code,a.op_code_desc,
--update b set 
b.op_desc_category_id_del , a.opcode_cat_id

from #result1 a
inner join master.ro_op_codes b (nolock) on a.op_code_desc= b.op_code_desc

select * from #temp_opcode_desc order by op_code_desc

select * from master.ro_op_codes b (nolock) where op_code_desc is not null order by op_code

select * into #master_opcodes from master.ro_op_codes b (nolock) where op_code_desc is not null

select distinct master_ro_op_code_id,op_code,op_code_desc,value as op_desc_cat from #master_opcodes cross apply string_split(op_desc_category_id_del,',')
where op_code = '12' order by op_code_desc

select * from #master_opcodes where op_code = '12' and op_desc_category_id_del is not null



select difference('plug','spark')
select difference('juicy','lucy')


select a.op_code_desc,string_agg(convert(varchar(max),b.OpCode_category_id),',') as opcode_cat_id
into #result1
from #temp_opcode_desc a
left outer join #opcode_cat b on a.op_code_desc like '%'+b.OpCode_category_desc+'%'
group by a.op_code_desc
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

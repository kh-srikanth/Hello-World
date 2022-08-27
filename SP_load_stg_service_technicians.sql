USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [master].[move_ro_header_detail_stage_2_master]    Script Date: 2/2/2021 2:57:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
   
  alter procedure  [etl].[move_service_technicians_etl_stg]    
      
  @file_process_id int 
  
as   
/*  
    exec [etl].[move_service_technicians_etl_stg] 1008  
	select * from stg.service_technicians
	truncate table stg.service_technicians
-----------------------------------------------------------------------    

  
 PURPOSE    
 To split customer data from sales service & service appointment customers based on etl  
  
 PROCESSES    
  
 MODIFICATIONS    
 Date   Author    Work Tracker Id   Description      
 ------------------------------------------------------------------------    

 ------------------------------------------------------------------------  
  
 */    
  
begin


 
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#temp0') IS NOT NULL DROP TABLE #temp0
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2
IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3
IF OBJECT_ID('tempdb..#temp4') IS NOT NULL DROP TABLE #temp4
IF OBJECT_ID('tempdb..#temp5') IS NOT NULL DROP TABLE #temp5
IF OBJECT_ID('tempdb..#temp6') IS NOT NULL DROP TABLE #temp6
IF OBJECT_ID('tempdb..#tmpA') IS NOT NULL DROP TABLE #tmpA
IF OBJECT_ID('tempdb..#tp') IS NOT NULL DROP TABLE #tp


select
		[RO Number]
		,[Vendor Dealer ID]
		,[Operation Codes]--
		,[Tech Number]--
		,[Tech Name]--
		,[Labor Cost]--
		,[file_process_id]
		,[file_process_detail_id]
		,[DV Dealer ID]
		,b.parent_dealer_id as parent_dealer_id
		,[Labor Tech Hours]--
		,[Open Date]
		,[Close Date]
		,[Labor Tech Rate]
into #temp
from [etl].[atc_service](nolock) a
	  inner join master.dealer b (nolock) on a.[DV Dealer ID] = b.natural_key
	  where [file_process_id] =@file_process_id

select * from #temp
select 
		b.items as [Operation_code]
		,t.[RO Number]
		,t.[Vendor Dealer ID]
		,t.[file_process_id]
		,t.[file_process_detail_id]
		,t.[DV Dealer ID]
		,t.parent_dealer_id
		,t.[Open Date]
		,t.[Close Date]
into #temp1 
from #temp t with(nolock) 
cross apply  [dbo].[fn_SplitRows](t.[RO Number], t.[Operation Codes],'|') as b
select 
b.items as [Tech_Number]
into #temp2 
from #temp t with(nolock) 
cross apply  [dbo].[fn_SplitRows](t.[RO Number], t.[Tech Number],'|') as b
select 
b.items as [Tech_Name]
into #temp3 
from #temp t with(nolock) 
cross apply  [dbo].[fn_SplitRows](t.[RO Number], t.[Tech Name],'|') as b
select 
b.items as [Labor_Cost]
into #temp4 
from #temp t with(nolock) 
cross apply  [dbo].[fn_SplitRows](t.[RO Number], t.[Labor Cost],'|') as b

select 
b.items as [labor_tech_Hours]
into #temp6 
from #temp t with(nolock) 
cross apply  [dbo].[fn_SplitRows](t.[RO Number], t.[Labor Tech Hours],'|') as b

select 
b.items as [labor_tech_rate]
into #temp5 
from #temp t with(nolock) 
cross apply  [dbo].[fn_SplitRows](t.[RO Number], t.[Labor Tech Rate],'|') as b

alter table #temp1 add id1 int identity(1,1)
alter table #temp2 add id2 int identity(1,1)
alter table #temp3 add id3 int identity(1,1)
alter table #temp4 add id4 int identity(1,1)
alter table #temp5 add id5 int identity(1,1)
alter table #temp6 add id6 int identity(1,1)

select 
t1.*,t2.Tech_Number,t3.Tech_Name,t4.Labor_Cost,t5.Labor_tech_rate ,t6.labor_tech_Hours
into #temp0
from #temp1 t1 
left join #temp2 t2 on t1.id1 = t2.id2 
left join #temp3 t3 on t1.id1 = t3.id3 
left join #temp4 t4 on t1.id1 = t4.id4
left join #temp5 t5 on t1.id1 = t5.id5 
left join #temp6 t6 on t1.id1 = t6.id6


truncate table #temp2
truncate table #temp3
truncate table #temp4
truncate table #temp5

create table #tmpA (c1 varchar(max) null,c2 varchar(max) null,
c3 varchar(max) null,c4 varchar(max) null,ida1 int)


declare @count int, @i int
set @count =1
set @i =1
select @count = count(id1) from #temp0
while @i <= @count 
begin
	insert into #temp2 (Tech_Number)
	select items from [dbo].[fn_SplitByDeli]((select [Tech_Number] from #temp0 where #temp0.id1 = @i), '^')
	insert into #temp3 (Tech_Name) 												   
	select items from [dbo].[fn_SplitByDeli]((select [Tech_Name] from #temp0 where #temp0.id1 = @i), '^')
	insert into #temp4 (Labor_Cost) 												   
	select items from [dbo].[fn_SplitByDeli]((select [labor_tech_Hours] from #temp0 where #temp0.id1 = @i), '^')
	insert into #temp5 (Labor_tech_rate) 												   
	select items from [dbo].[fn_SplitByDeli]((select [labor_tech_rate] from #temp0 where #temp0.id1 = @i), '^')

	insert into #tmpA (c1,c2,c3,c4,ida1) 
	select #temp2.Tech_Number, #temp3.Tech_Name, #temp4.Labor_Cost,#temp5.labor_tech_rate, @i
	from  #temp2  
	left outer join #temp3 on #temp2.id2 = #temp3.id3 
	left outer join #temp4 on #temp2.id2 = #temp4.id4
	left outer join #temp5 on #temp2.id2 = #temp5.id5

	truncate table #temp2
	truncate table #temp3
	truncate table #temp4
	truncate table #temp5

	set @i = @i+1;	
end

select * into #tp 
from #tmpA left outer join #temp0 on #tmpA.ida1 = #temp0.id1

insert into stg.service_technicians
(
		[RoNo]
		,[src_dealer_code]
		,[opcode]
		,[Techno]
		,[Techname]
		,[file_process_id]
		,[file_process_detail_id]
		,[natural_key]
		,[parent_dealer_id]
		,[job_total_hrs]
		,RO_opendate
		,RO_closedate
		,Labor_Tech_Rate
)
select 
		[RO Number]
		,[Vendor Dealer ID]
		,[Operation_code]
		,c1
		,c2
		,[file_process_id]
		,[file_process_detail_id]
		,[DV Dealer ID]
		,parent_dealer_id
		,c3
		,[Open Date]
		,[Close Date]
		,c4
from #tp

end


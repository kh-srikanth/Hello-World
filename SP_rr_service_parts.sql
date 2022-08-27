USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [stg].[move_service_parts]    Script Date: 1/26/2021 3:57:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--truncate table stg.service_parts
--exec [stg].[move_service_parts]
alter PROCEDURE [stg].[move_service_parts]
AS
BEGIN

IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2
IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3
IF OBJECT_ID('tempdb..#temp4') IS NOT NULL DROP TABLE #temp4
IF OBJECT_ID('tempdb..#temp5') IS NOT NULL DROP TABLE #temp5
IF OBJECT_ID('tempdb..#temp6') IS NOT NULL DROP TABLE #temp6
IF OBJECT_ID('tempdb..#temp7') IS NOT NULL DROP TABLE #temp7
IF OBJECT_ID('tempdb..#tempA') IS NOT NULL DROP TABLE #tempA
IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
IF OBJECT_ID('tempdb..#tmp2') IS NOT NULL DROP TABLE #tmp2
IF OBJECT_ID('tempdb..#tmpA') IS NOT NULL DROP TABLE #tmpA
IF OBJECT_ID('tempdb..#t') IS NOT NULL DROP TABLE #t
IF OBJECT_ID('tempdb..#tp') IS NOT NULL DROP TABLE #tp

create table #temp
  (   
       [header_xml_id] int
      ,[RoNo] varchar(50)
      ,[FinalPostDate] varchar(50)
      ,[src_dealer_code] varchar(50)
      ,[jobno] nvarchar(50)
      ,[opcode] nvarchar(500)
      ,[parts_amt_type] nvarchar(500)
      ,[parts_pay_type] nvarchar(500)
      ,[parts_dlr_cost] nvarchar(max)
      ,[parts_ntxbl_amt] nvarchar(500)
      ,[parts_txbl_amt] nvarchar(500)
      ,[parts_num] nvarchar(max)
      ,[parts_num_desc] nvarchar(max)
      ,[parts_seq_no] nvarchar(max)
      ,[file_log_id] int
      ,[file_log_detail_id] int
      ,[parent_Dealer_id] int
      ,[natural_key] varchar(50)
      ,[opcode_desc] nvarchar(max)
      ,[parts_extprice] nvarchar(500)
      ,[parts_custprice] varchar(500)
      ,[intrjob_txblamtcore] varchar(1000)
      ,[warrjob_txblamtcore] varchar(1000)
      ,[custjob_txblamtcore] varchar(1000)
      ,[intrjob_costcore] varchar(500)
      ,[warrjob_costcore] varchar(500)
      ,[custjob_costcore] varchar(500)
      ,[total_ro_dlrcost] varchar(2000)
      ,[total_ro_ntablamt] varchar(2000)
      ,[total_ro_txblamt] varchar(2000)
	  ,[total_ro_payttype] varchar(2000)
      ,[total_ro_amttype] varchar(2000)
      ,[part_cust_mfgwarrcost] varchar(2000)
      ,[part_cust_txblntxblflag] varchar(2000)
      ,[part_cust_paytypeflag] varchar(2000)
      ,[part_cust_qtyship] varchar(2000)
      ,[part_cust_qtyord] varchar(2000)
      ,[part_cust_txblntxblcoreflag] varchar(2000)
      ,[part_transCode] varchar(1000)
	  )
insert into #temp
	  (
	   [header_xml_id]
      ,[RoNo]
      ,[FinalPostDate]
      ,[src_dealer_code]
      ,[jobno]
      ,[opcode]
      ,[parts_amt_type]
      ,[parts_pay_type]
      ,[parts_dlr_cost]
      ,[parts_ntxbl_amt]
      ,[parts_txbl_amt]
      ,[parts_num]
      ,[parts_num_desc]
      ,[parts_seq_no]
      ,[file_log_id]
      ,[file_log_detail_id]
      ,[parent_Dealer_id]
      ,[natural_key]
	  ,[opcode_desc]
      ,[parts_extprice]
      ,[parts_custprice]
      ,[intrjob_txblamtcore]
      ,[warrjob_txblamtcore]
      ,[custjob_txblamtcore]
      ,[intrjob_costcore]
      ,[warrjob_costcore]
      ,[custjob_costcore]
      ,[total_ro_dlrcost]
      ,[total_ro_ntablamt]
      ,[total_ro_txblamt]
      ,[total_ro_payttype]
      ,[total_ro_amttype]
      ,[part_cust_mfgwarrcost]
      ,[part_cust_txblntxblflag]
      ,[part_cust_paytypeflag]
      ,[part_cust_qtyship]
      ,[part_cust_qtyord]
      ,[part_cust_txblntxblcoreflag]
      ,[part_transCode]
	  )
	
	select 
	   0
	  ,[RO Number]
	  ,0
	  ,0
	  ,0
	  ,[Operation Codes]
	  ,0
	  ,0
	  ,[Parts Cost]
	  ,0
	  ,0
	  ,[Part Number]
	  ,[Part Description]
	  ,[Parts Line Number]
	  ,[process_id]
	  ,[file_process_detail_id]
	  ,0
	  ,[DV Dealer ID]
	  ,[Operation Code Descriptions]
	  ,0
	  ,[Customer Parts Cost]
	  ,0
	  ,0
	  ,0
	  ,0
	  ,0
	  ,0
	  ,0
	  ,0
	  ,0
   	  ,0
	  ,0
	  ,[Warranty Parts Cost]
	  ,0
	  ,0
	  ,[Part Quantity]
	  ,0
   	  ,0
	  ,0
	 from etl.atc_service
declare @count int=1, @i int =1
select @count = count(file_log_detail_id) from #temp
create table #temp1 (ID INT IDENTITY(1, 1),	col1 varchar(100) null)
create table #temp2 (ID INT IDENTITY(1, 1),	col2 varchar(max) null)
create table #temp3 (ID INT IDENTITY(1, 1),	col3 varchar(max) null)
create table #temp4 (ID INT IDENTITY(1, 1),	col4 varchar(max) null)
create table #temp5 (ID INT IDENTITY(1, 1),	col5 varchar(max) null)
create table #temp6 (ID INT IDENTITY(1, 1),	col6 varchar(max) null)
create table #tempA (ID INT IDENTITY(1, 1),c1 varchar(100) null,c2 varchar(max) null,c3 varchar(max) null,c4 varchar(max) null
,c5 varchar(max) null,c6 varchar(max) null,file_log_d_id int)

while @i <= @count 
begin
	insert into #temp1 (col1) 
	select * from string_split((select [opcode] from #temp where file_log_detail_id = @i), '|')
	insert into #temp2 (col2) 
	select * from string_split((select [parts_dlr_cost] from #temp where file_log_detail_id = @i), '|')
	insert into #temp3 (col3) 
	select * from string_split((select [parts_num] from #temp where file_log_detail_id = @i), '|')
	insert into #temp4 (col4) 
	select * from string_split((select [parts_num_desc] from #temp where file_log_detail_id = @i), '|')
	insert into #temp5 (col5) 
	select * from string_split((select [part_cust_qtyship] from #temp where file_log_detail_id = @i), '|')
	insert into #temp6 (col6) 
	select * from string_split((select [opcode_desc] from #temp where file_log_detail_id = @i), '|')
	insert into #tempA (c1,c2,c3,c4,c5,c6,file_log_d_id) 
	select #temp1.col1, #temp2.col2, #temp3.col3, #temp4.col4, #temp5.col5, #temp6.col6, @i
	from #temp1 
	left outer join #temp2 on #temp1.ID = #temp2.ID 
	left outer join #temp3 on #temp1.ID = #temp3.ID 
	left outer join #temp4 on #temp1.ID = #temp4.ID
	left outer join #temp5 on #temp1.ID = #temp5.ID
	left outer join #temp6 on #temp1.ID = #temp6.ID
	truncate table #temp1
	truncate table #temp2
	truncate table #temp3
	truncate table #temp4
	truncate table #temp5
	truncate table #temp6
	set @i = @i +1;
end

create table #tmpA (ID INT IDENTITY(1, 1),c22 varchar(max) null,c33 varchar(max) null,c44 varchar(max) null
,c55 varchar(max) null,id1 int)

select * into #tmp 
from #tempA left outer join #temp on #temp.file_log_detail_id = #tempA.file_log_d_id

--select * from #tempA left outer join #temp on #temp.file_log_detail_id = #tempA.file_log_d_id

select * from #tmp
--truncate table #temp2
set @count =1
set @i =1
select @count = count(ID) from #tmp
while @i <= @count 
begin
	insert into #temp2 (col2)
	select items from [dbo].[fn_SplitByDeli]((select [c2] from #tmp where #tmp.ID = @i), '^')
	insert into #temp3 (col3) 												   
	select items from [dbo].[fn_SplitByDeli]((select [c3] from #tmp where #tmp.ID = @i), '^')
	insert into #temp4 (col4) 												   
	select items from [dbo].[fn_SplitByDeli]((select [c4] from #tmp where #tmp.ID = @i), '^')
	insert into #temp5 (col5) 												   
	select items from [dbo].[fn_SplitByDeli]((select [c5] from #tmp where #tmp.ID = @i), '^')

	insert into #tmpA (c22,c33,c44,c55,id1) 
	select #temp2.col2, #temp3.col3, #temp4.col4, #temp5.col5, @i
	from  #temp2  
	left outer join #temp3 on #temp2.ID = #temp3.ID 
	left outer join #temp4 on #temp2.ID = #temp4.ID
	left outer join #temp5 on #temp2.ID = #temp5.ID

	truncate table #temp2
	truncate table #temp3
	truncate table #temp4
	truncate table #temp5
	set @i = @i+1;
	
end
--select * from #tmp
--select * from #tmpA

 SELECT * into #t FROM #tmpA
 ALTER TABLE #t DROP column ID;
 --SELECT * FROM #tmp;

select * into #tp 
from #t left outer join #tmp on #tmp.ID = #t.id1
--insert into #temp2 (col2) select b.items from #tmp t with(nolock) cross apply  [dbo].[fn_SplitRows](t.ID,t.c2,'^') as b
--insert into #temp3 (col3) select b.items from #tmp t with(nolock) cross apply  [dbo].[fn_SplitRows](t.ID,t.c3,'^') as b
--insert into #temp4 (col4) select b.items from #tmp t with(nolock) cross apply  [dbo].[fn_SplitRows](t.ID,t.c4,'^') as b
--insert into #temp5 (col5) select b.items from #tmp t with(nolock) cross apply  [dbo].[fn_SplitRows](t.ID,t.c5,'^') as b

--select #temp2.col2,#temp3.Col3, #temp4.col4, #temp5.col5 from #temp2 left outer join #temp3 on #temp2.ID = #temp3.ID 
--left outer join #temp4 on #temp2.ID = #temp4.ID 
--left outer join #temp5 on #temp2.ID = #temp5.ID	
--select * from string_split((select [c2] from #tmp where ID = 6), '^')
--select * from string_split((select [c3] from #tmp where ID = 6), '^')
--select * from string_split((select [c4] from #tmp where ID = 6), '^')
--select * from string_split((select [c5] from #tmp where ID = 6), '^')
--select * from #temp2
--select * from #tp

insert into stg.service_parts
(
      [file_log_detail_id]
      ,[file_log_id]
      ,[natural_key]
      ,[RoNo]
      ,[opcode_desc]
      ,[parts_dlr_cost]
      ,[parts_num]
      ,[parts_num_desc]
      ,[opcode]
      ,[parts_seq_no]
      ,[part_cust_qtyship]
      ,[part_cust_mfgwarrcost]
      ,[parts_custprice]
)
select 
file_log_d_id
,file_log_id
,[natural_key]
,[RoNO]
,c6
,c22
,c33
,c44
,c1
,0
,c55
,0
,0

from #tp
select * from stg.service_parts
end
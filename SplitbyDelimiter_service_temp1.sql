use clictell_auto_etl
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
create table #temp1 (ID INT IDENTITY(1, 1),	col1 varchar(100) null)
declare @count int, @i int = 0, @j int =0;;
select @count = count(file_process_detail_id) from etl.atc_service
while @i <= @count
begin
	insert into #temp1  ([col1]) 
	select * from string_split((select [Operation Codes] from [etl].[atc_service] where file_process_detail_id = @i), '|')
	set @i = @i +1;
end
--select * from #temp1

IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2
create table #temp2 (ID INT IDENTITY(1, 1),	col2 varchar(100) null)
set @i = 0;
while @i <= @count
begin
	insert into #temp2  ([col2]) 
	select * from string_split((select [Tech Number] from [etl].[atc_service] where file_process_detail_id = @i), '|')
	set @i = @i +1;
end
--select * from #temp2

IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
select  #temp1.col1, #temp2.col2 from #temp1 inner join #temp2 on #temp1.ID = #temp2.ID 
--select col1 from #temp1 union select col2 from #temp2
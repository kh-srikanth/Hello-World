use clictell_auto_etl 
--initiallize temp tables
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2
create table #temp1 (ID INT IDENTITY(1, 1),	col1 varchar(100) null)
create table #temp2 (ID INT IDENTITY(1, 1),	col1 varchar(100) null, col2 varchar(100) null)
--initialize variables
declare @count int, @i int = 0;
select @count = count(file_process_detail_id) from etl.atc_service
-- pass through all cells in etl.atc_service.[Operation Codes], split each cell with | as delimiter and insert into #temp1.col1
while @i <= @count
begin
	insert into #temp1  ([col1]) 
	select * from string_split((select [Operation Codes] from [etl].[atc_service] where file_process_detail_id = @i), '|')
	set @i = @i +1;
end
select * from #temp1
-- pass through all cells in etl.atc_service.[Tech Number], split each cell with | as delimiter and insert into #temp2.col1
set @i = 0;
while @i <= @count
begin
	insert into #temp2  ([col1]) 
	select * from string_split((select [Tech Number] from [etl].[atc_service] where file_process_detail_id = @i), '|')
	set @i = @i +1;
end
-- pass through all cells in the #temp2.col2, split each cell with ^ as delimiter and insert into #temp2.col2
select @count =  count(ID) from #temp2
set @i = 0;
while @i <= @count
begin
	insert into #temp2  ([col2]) 
	select * from string_split((select [col1] from #temp2 where ID = @i), '^')
	set @i = @i +1;
end
--drop unwanted columns
delete from #temp2 where col2 is null;
alter table #temp2 drop column ID, col1;
--re-initialize an identity column 
alter table #temp2 add id1 int identity(1,1);
select * from #temp2
-- full join tables #temp1 and #temp2
select  #temp1.col1, #temp2.col2 from #temp1 full join #temp2 on #temp1.ID = #temp2.id1 
--drop #temp1 and #temp2 tables
drop table #temp1
drop table #temp2
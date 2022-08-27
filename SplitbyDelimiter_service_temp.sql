use clictell_auto_etl
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
select [Tech Labor Line]
,[Tech Name]
into #temp from etl.atc_service;
delete #temp
declare @count int, @i int = 0;
select @count = count(file_process_detail_id) from etl.atc_service
select @count;
while @i <= @count
begin
	insert into #temp  ([Tech Labor Line]) 
	select * from string_split((select [Tech Labor Line] from [etl].[atc_service] where file_process_detail_id = @i), '|')
	insert into #temp  ([Tech Name]) 
	select * from string_split((select [Tech Name] from [etl].[atc_service] where file_process_detail_id = @i), '|')
	set @i = @i +1;
end
select * from #temp
select * from [etl].[atc_service]

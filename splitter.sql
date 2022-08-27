IF OBJECT_ID('tempdb..#temptable') IS NOT NULL DROP TABLE #temptable

declare @idx int       
   declare @slice varchar(100) 
   declare @String varchar(100)='1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^2^1^1^1^1^1^1^1^1^1^1^1^1^1^1^2^1^1', @Delimiter char ='^', @id int =1; 
   create table #temptable (id int, items varchar(100));

   select @idx = 1       
       if len(@String)<1 or @String is null  return       

   while @idx!= 0       
   begin       
       set @idx = charindex(@Delimiter,@String)       
       if @idx!=0       
           set @slice = left(@String,@idx - 1)       
       else       
           set @slice = @String       

       if(len(@slice)>0)  
           insert into #temptable(id, Items) values(@id, @slice)       

       set @String = right(@String,len(@String) - @idx)       
      -- if len(@String) = 0 break 
	end
	select * from #temptable
--	drop table #temptable
--truncate table #temptable
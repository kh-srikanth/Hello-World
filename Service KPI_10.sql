use clictell_auto_master
go
IF OBJECT_ID('tempdb..#prts_lbr') IS NOT NULL DROP TABLE #prts_lbr

	select 	

			parent_Dealer_id 
			,sum(total_parts_price)/100000 as parts_price
			,sum(total_labor_price)/100000 as labor_price	
	into #prts_lbr	
	from master.repair_order_header (nolock) 
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	group by parent_Dealer_id

----Finding HCF for parts price and labour price to get ratio
DECLARE @num1 int = (select convert(int,parts_price) from #prts_lbr)
DECLARE @num2 int = (select convert(int,labor_price) from #prts_lbr)
DECLARE @count INT = 1, @hcf int 

WHILE (@count < @num1 or @count < @num2)
BEGIN
	IF (@num1 % @count = 0 and @num2 % @count = 0)
	BEGIN
		set @hcf = @count
	END
	set @count = @count + 1
END
----divide parts price and labour price by HCF, calculated above to get the least ratio

	declare @graph_data varchar(5000) = (
	select 
			parent_dealer_id as accountId
			,'Number' as chart_type
			,'Parts to Labour Ratio' as chart_title
			,convert(varchar(50),convert(int,parts_price)/@hcf) +':' +convert(varchar(50),convert(int,labor_price)/@hcf) as prt_lbr_ratio
	from #prts_lbr
	FOR JSON AUTO )
	select @graph_data

	--insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, graph_data)
	--values (
	--	(select top 1 parent_dealer_id from #prts_lbr) 
	--	,'service'
	--	,'Parts to Labour Ratio'
	--	,'Parts to Labour Ratio'
	--	,@graph_data
	--)

	--select * from master.dashboard_kpis
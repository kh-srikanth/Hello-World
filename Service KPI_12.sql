use clictell_auto_master
go
IF OBJECT_ID('tempdb..#age') IS NOT NULL DROP TABLE #age
IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result
IF OBJECT_ID('tempdb..#result1') IS NOT NULL DROP TABLE #result1
IF OBJECT_ID('tempdb..#age1') IS NOT NULL DROP TABLE #age1
IF OBJECT_ID('tempdb..#age2') IS NOT NULL DROP TABLE #age2
IF OBJECT_ID('tempdb..#age3') IS NOT NULL DROP TABLE #age3
IF OBJECT_ID('tempdb..#age4') IS NOT NULL DROP TABLE #age4
IF OBJECT_ID('tempdb..#age5') IS NOT NULL DROP TABLE #age5
IF OBJECT_ID('tempdb..#age6') IS NOT NULL DROP TABLE #age6
IF OBJECT_ID('tempdb..#age7') IS NOT NULL DROP TABLE #age7
IF OBJECT_ID('tempdb..#graph_data') IS NOT NULL DROP TABLE #graph_data
IF OBJECT_ID('tempdb..#header') IS NOT NULL DROP TABLE #header

	select 	

			 h.parent_Dealer_id 
			,datediff(year,convert(date,convert(char(8),iif(len(model_year)=0,0,model_year))),getdate())  as age
			,ro_close_date

	into #age
	from master.repair_order_header h (nolock) 
	inner join master.vehicle v (nolock) on h.master_vehicle_id = v.master_vehicle_id
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
	--group by parent_Dealer_id


	select 
		parent_dealer_id
		,	(case when age <=1 then 1
		when age>1 and age <=2 then 2
		when age>2 and age<=3 then 3
		when age>3 and age<=4 then 4
		when age>4 and age <=5 then 5
		when age>5 and age <=10 then 6
		else 7 end) as age_seg
		,ro_close_date
	into #result1
	from #age

	select 
		parent_dealer_id
		,count(*) as age_1
		,month(convert(date,convert(char(8),ro_close_date))) as mnt
		,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

		into #age1
	from #result1 where age_seg =1
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
	order by mnt

	

	select 
		parent_dealer_id
		,count(*) as age_2
		,month(convert(date,convert(char(8),ro_close_date))) as mnt
		,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

		into #age2
	from #result1 where age_seg =2
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
	order by mnt

	select 
		parent_dealer_id
		,count(*) as age_3
		,month(convert(date,convert(char(8),ro_close_date))) as mnt
		,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

		into #age3
	from #result1 where age_seg =3
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
	order by mnt

	select 
		parent_dealer_id
		,count(*) as age_4
		,month(convert(date,convert(char(8),ro_close_date))) as mnt
		,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

		into #age4
	from #result1 where age_seg =4
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
	order by mnt

	select 
		parent_dealer_id
		,count(*) as age_5
		,month(convert(date,convert(char(8),ro_close_date))) as mnt
		,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

		into #age5
	from #result1 where age_seg =5
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
	order by mnt
		
		
	select 
		parent_dealer_id
		,count(*) as age_6
		,month(convert(date,convert(char(8),ro_close_date))) as mnt
		,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

		into #age6
	from #result1 where age_seg =6
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
	order by mnt
		
	select 
		parent_dealer_id
		,count(*) as age_7
		,month(convert(date,convert(char(8),ro_close_date))) as mnt
		,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

		into #age7
	from #result1 where age_seg =7
	group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
	order by mnt

	select 
			a1.parent_dealer_id
			,a1.mnt
			,a1.mnt_name
			,convert(decimal(18,1),convert(decimal(18,1),a1.age_1*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_1
			,convert(decimal(18,1),convert(decimal(18,1),a2.age_2*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_2
			,convert(decimal(18,1),convert(decimal(18,1),a3.age_3*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_3
			,convert(decimal(18,1),convert(decimal(18,1),a4.age_4*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_4
			,convert(decimal(18,1),convert(decimal(18,1),a5.age_5*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_5
			,convert(decimal(18,1),convert(decimal(18,1),a6.age_6*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_6
			,convert(decimal(18,1),convert(decimal(18,1),a7.age_7*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_7
			,convert(decimal(18,1),a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7) as total
	into #graph_data
	from #age1 a1 
	inner join #age2 a2 on a1.parent_dealer_id = a2.parent_dealer_id and a1.mnt = a2.mnt
	inner join #age3 a3 on a1.parent_dealer_id = a3.parent_dealer_id and a1.mnt = a3.mnt
	inner join #age4 a4 on a1.parent_dealer_id = a4.parent_dealer_id and a1.mnt = a4.mnt
	inner join #age5 a5 on a1.parent_dealer_id = a5.parent_dealer_id and a1.mnt = a5.mnt
	inner join #age6 a6 on a1.parent_dealer_id = a6.parent_dealer_id and a1.mnt = a6.mnt
	inner join #age7 a7 on a1.parent_dealer_id = a7.parent_dealer_id and a1.mnt = a7.mnt
	order by mnt
	--select * from #graph_data
	--select * from #header
	select 
		distinct parent_dealer_id
		,'Line Trend' as chart_type
		,'Vehicle Age Trend' as chart_title
		into #header
	from #result1

	declare @graph_data varchar(max) = (
	select 
		header.parent_Dealer_id as accountId
		,header.chart_type
		,header.chart_title
		,graph_data.mnt
		,graph_data.mnt_name
		,graph_data.perc_seg_1
		,graph_data.perc_seg_2
		,graph_data.perc_seg_3
		,graph_data.perc_seg_4
		,graph_data.perc_seg_5
		,graph_data.perc_seg_6
		,graph_data.perc_seg_7
		

	from #header header inner join #graph_data graph_data on header.parent_Dealer_id =graph_data.parent_dealer_id
	order by mnt
	for json auto )

select @graph_data
	--		insert into master.dashboard_kpis (parent_dealer_id, kpi_type, subject, chart_title, graph_data)
	--values (
	--	(select top 1 parent_dealer_id from #header) 
	--	,'service'
	--	,'Vehicle Age'
	--	,'Vehicle Age Trend'
	--	,@graph_data
	--)

	--select * from master.dashboard_kpis
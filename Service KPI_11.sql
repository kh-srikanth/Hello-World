use clictell_auto_master
go
declare @graph_data varchar(5000)
	IF OBJECT_ID('tempdb..#age') IS NOT NULL DROP TABLE #age
	IF OBJECT_ID('tempdb..#result_k11') IS NOT NULL DROP TABLE #result_k11
	IF OBJECT_ID('tempdb..#result1_k11') IS NOT NULL DROP TABLE #result1_k11
	IF OBJECT_ID('tempdb..#result11') IS NOT NULL DROP TABLE #result11
	IF OBJECT_ID('tempdb..#head') IS NOT NULL DROP TABLE #head
	IF OBJECT_ID('tempdb..#gd') IS NOT NULL DROP TABLE #gd

		select 	

				h.parent_Dealer_id 
				,datediff(year,convert(date,convert(char(8),iif(len(model_year)=0,0,model_year))),getdate())  as age
				,model_year
				,v.master_vehicle_id
		into #age
		from master.repair_order_header h (nolock) 
		inner join master.vehicle v (nolock) on h.master_vehicle_id = v.master_vehicle_id
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		--group by parent_Dealer_id

		--select * from #age order by age
	
		select 
		parent_dealer_id
		,(case when age <=1 then 1
			when age>1 and age <=2 then 2
			when age>2 and age<=3 then 3
			when age>3 and age<=4 then 4
			when age>4 and age <=5 then 5
			when age>5 and age <=10 then 6
			else 7 end) as age_seg
		into #result_k11
		from #age

		declare @1yr int = (select count(*) from #result_k11 where age_seg =1)
		declare @2yr int = (select count(*) from #result_k11 where age_seg =2)
		declare @3yr int = (select count(*) from #result_k11 where age_seg =3)
		declare @4yr int = (select count(*) from #result_k11 where age_seg =4)
		declare @5yr int = (select count(*) from #result_k11 where age_seg =5)
		declare @6yr int = (select count(*) from #result_k11 where age_seg =6)

		select distinct(parent_dealer_id), @1yr as seg_1,@2yr as seg_2,@3yr as seg_3,@4yr as seg_4,@5yr as seg_5,@6yr as seg_6
				,@1yr+@2yr+@3yr+@4yr+@5yr+@6yr as total
			into #result1_k11
		from #result_k11
		
		select 
				parent_dealer_id as accountId
				,'Pie' as chart_type
				,'Vehicle Age' as chart_title
				,convert(decimal(18,1),convert(decimal(18,1),seg_1*100)/total) as  perc_1yr_old
				,convert(decimal(18,1),convert(decimal(18,1),seg_2*100)/total) as  perc_2yr_old
				,convert(decimal(18,1),convert(decimal(18,1),seg_3*100)/total) as  perc_3yr_old
				,convert(decimal(18,1),convert(decimal(18,1),seg_4*100)/total) as  perc_4yr_old
				,convert(decimal(18,1),convert(decimal(18,1),seg_5*100)/total) as  perc_5yr_10yr_old
				,convert(decimal(18,1),convert(decimal(18,1),seg_6*100)/total) as  perc_more_10yr_old
			into #result11
		from #result1_k11

		create table #head  (accountId int,chart_type varchar(20),chart_title varchar(50),[type] varchar(50), [count] decimal(18,1))

		insert into #head (accountId,chart_type,chart_title, [type],[count]) 
		values 
		 ((select accountId from #result11),'Pie','Vehicle Age','1 year old %', (select perc_1yr_old from #result11))
		,((select accountId from #result11),'Pie','Vehicle Age','2 year old %',(select perc_2yr_old from #result11))
		,((select accountId from #result11),'Pie','Vehicle Age','3 year old %',(select perc_3yr_old from #result11))
		,((select accountId from #result11),'Pie','Vehicle Age','4 year old %',(select perc_4yr_old from #result11))
		,((select accountId from #result11),'Pie','Vehicle Age','5 to 10 year old %',(select perc_5yr_10yr_old from #result11))
		,((select accountId from #result11),'Pie','Vehicle Age','> 10 year old %',(select perc_more_10yr_old from #result11))
		
		set @graph_data = (
		select 
				 r.accountId
				,r.chart_type
				,r.chart_title
			,[type] as "Type"
			,[count] as "Count"
				
		from #head graph_data inner join #result11 r on graph_data.accountId = r.accountId
		for json auto)
	
		select @graph_data

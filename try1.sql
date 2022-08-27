USE [clictell_auto_etl]
declare @file_process_id int  =1008
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
		,[Operation Sale Types]
		
into #temp
from [etl].[atc_service](nolock) a
	  inner join master.dealer b (nolock) on a.[DV Dealer ID] = b.natural_key
	  where [file_process_id] =@file_process_id

alter table #temp add W_rate varchar(100), C_rate varchar(100), I_rate varchar(100)
insert into #temp (W_rate,C_rate, I_rate) values select 
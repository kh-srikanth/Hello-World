USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [stg].[stg.rr_service_labor]***** Error data loading in ro_labor_dlr_cost and final_post_data*/
--exec [stg].[move_rr_service_labor]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure  [stg].[move_rr_service_labor]
as 

Begin

IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2
IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3
IF OBJECT_ID('tempdb..#temp4') IS NOT NULL DROP TABLE #temp4
create table #temp (
      [header_xml_id] int
      ,[rono] varchar(50)
      ,[src_dealer_code] varchar(50)
      ,[dealer_id] int
      ,[finalpostdate] varchar(50) ---??
      ,[opcode] varchar(50)
      ,[ro_labor_amttype] varchar(50)
      ,[ro_labor_paytype] varchar(50)
      ,[ro_labor_dlr_cost] varchar(50)
      ,[ro_labor_ntxblamt] varchar(50)
      ,[ro_labor_txblamt] varchar(50)
      ,[file_log_id] int
      ,[file_log_detail_id] int
      ,[parent_dealer_id] int
      ,[natural_key] varchar(50)
      ,[opcode_desc] varchar(50)
      ,[jobno] varchar(50)
      ,[tx_PayType] varchar(50)
      ,[TaxCode] varchar(50)
      ,[job_dlr_cost] varchar(50)
      ,[job_paytype] varchar(50)
      ,[job_totalamt] varchar(50)
      ,[TxblGrossAmt] varchar(50)
      ,[TxblSupplAmt] varchar(50)
      ,[TxblSuppl2Amt] varchar(50)
	  )
	  
insert into #temp
(
      [header_xml_id]
      ,[rono]
      ,[src_dealer_code]
      ,[dealer_id]
      ,[finalpostdate]
      ,[opcode]
      ,[ro_labor_amttype]
      ,[ro_labor_paytype]
      ,[ro_labor_dlr_cost]
      ,[ro_labor_ntxblamt]
      ,[ro_labor_txblamt]
      ,[file_log_id]
      ,[file_log_detail_id]
      ,[parent_dealer_id]
      ,[natural_key]
      ,[opcode_desc]
      ,[jobno]
      ,[tx_PayType]
      ,[TaxCode]
      ,[job_dlr_cost]
      ,[job_paytype]
      ,[job_totalamt]
      ,[TxblGrossAmt]
      ,[TxblSupplAmt]
      ,[TxblSuppl2Amt]
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
		,[Labor Cost]
		,0
		,0
		,[process_id]
		,[file_process_detail_id]
		,0
		,[DV Dealer ID]
		,[Operation Code Descriptions]
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
from etl.atc_service
select distinct  
	 b.id
	,b.items as [Operation_codes]
	,t.[header_xml_id]
	,t.[rono]
	,t.[src_dealer_code]
	,t.[dealer_id]
	,t.[finalpostdate]     
	,t.[ro_labor_amttype]
	,t.[ro_labor_paytype]
	,t.[ro_labor_ntxblamt]
	,t.[ro_labor_txblamt]
	,t.[file_log_id]
	,t.[file_log_detail_id]
	,t.[parent_dealer_id]
	,t.[natural_key]
	,t.[jobno]
	,t.[tx_PayType]
	,t.[TaxCode]
	,t.[job_dlr_cost]
	,t.[job_paytype]
	,t.[job_totalamt]
	,t.[TxblGrossAmt]
	,t.[TxblSupplAmt]
	,t.[TxblSuppl2Amt]
into #temp1 
from #temp t with(nolock) 
cross apply  [dbo].[fn_SplitRows](t.rono, t.opcode,'|') as b 

select distinct 
b.id
,b.items as [Labor_dlr_cost]
into #temp2 
from #temp t with(nolock) 
cross apply  [dbo].[fn_SplitRows](t.rono, t.ro_labor_dlr_cost,'|') as b 

select distinct 
b.id
,b.items as [Operation_code_desc]
into #temp3 
from #temp t with(nolock) 
cross apply  [dbo].[fn_SplitRows](t.rono, t.opcode_desc,'|') as b 

alter table #temp1 add id1 int identity(1,1)
alter table #temp2 add id2 int identity(1,1)
alter table #temp3 add id3 int identity(1,1)

select #temp1.*,#temp3.Operation_code_desc ,#temp2.Labor_dlr_cost
into #temp4
from #temp1 join #temp3 on #temp1.id1 = #temp3.id3 
left join #temp2 on #temp1.id1 = #temp2.id2;
insert into stg.rr_service_labor (
      [header_xml_id]
      ,[rono]
      ,[src_dealer_code]
      ,[dealer_id]
     --,[finalpostdate]
      ,[opcode]
      ,[ro_labor_amttype]
      ,[ro_labor_paytype]
      ,[ro_labor_dlr_cost]
      ,[ro_labor_ntxblamt]
      ,[ro_labor_txblamt]
      ,[file_log_id]
      ,[file_log_detail_id]
      ,[parent_dealer_id]
      ,[natural_key]
      ,[opcode_desc]
      ,[jobno]
      ,[tx_PayType]
      ,[TaxCode]
      ,[job_dlr_cost]
      ,[job_paytype]
      ,[job_totalamt]
      ,[TxblGrossAmt]
      ,[TxblSupplAmt]
      ,[TxblSuppl2Amt]
	  )
	 select 
		header_xml_id
		,rono
		,src_dealer_code
		,dealer_id
		--,finalpostdate 
		,Operation_codes
		,ro_labor_amttype
		,ro_labor_paytype
		,Labor_dlr_cost
		,ro_labor_ntxblamt
		,ro_labor_txblamt
		,file_log_id
		,file_log_detail_id
		,parent_dealer_id
		,natural_key
		,Operation_code_desc
		,jobno
		,tx_PayType
		,TaxCode
		,job_dlr_cost
		,job_paytype
		,job_totalamt
		,TxblGrossAmt
		,TxblSupplAmt
		,TxblSuppl2Amt  
	  from #temp4
end

select * from stg.rr_service_labor
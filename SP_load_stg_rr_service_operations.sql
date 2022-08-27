USE clictell_auto_etl
GO
/****** Object:  StoredProcedure  to fill [stg].[rr_service_operations]******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
create procedure  [etl].[move_stg_rr_service_oprations]   

as 

begin

IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2
IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3
IF OBJECT_ID('tempdb..#temp4') IS NOT NULL DROP TABLE #temp4
IF OBJECT_ID('tempdb..#temp5') IS NOT NULL DROP TABLE #temp5
IF OBJECT_ID('tempdb..#temp6') IS NOT NULL DROP TABLE #temp6
IF OBJECT_ID('tempdb..#temp7') IS NOT NULL DROP TABLE #temp7
IF OBJECT_ID('tempdb..#temp8') IS NOT NULL DROP TABLE #temp8
IF OBJECT_ID('tempdb..#temp0') IS NOT NULL DROP TABLE #temp0
create table #temp (
      [header_xml_id] int
      ,[RoNo] varchar(100)
      ,[src_dealer_code] varchar(100)
      ,[Finalpostdate] varchar(100)
      ,[jobno] varchar(100)
      ,[JobStatus] varchar(100)
      ,[UpSellFlag] varchar(100)
      ,[opcode] varchar(100)
      ,[opcode_desc] varchar(100)
      ,[complaint] varchar(100)
      ,[Cause] varchar(100)
      ,[correction] varchar(100)
      ,[Billrate] varchar(100)
      ,[tech_note] varchar(100)
      ,[opcode_dlrcost] varchar(200)
      ,[opcode_amttype] varchar(100)
      ,[opcode_paytype] varchar(100)
      ,[opcode_total_amt] varchar(100)
      ,[ro_labor_amttype] varchar(100)
      ,[ro_labor_paytype] varchar(100)
      ,[ro_labor_dlr_cost] varchar(100)
      ,[ro_labor_ntxblamt] varchar(100)
      ,[ro_labor_txblamt] varchar(100)
      ,[file_log_id] int
      ,[file_log_detail_id] int
      ,[parent_dealer_id] varchar(100)
      ,[natural_key] varchar(100)
      ,[labor_department_type] varchar(100)
      ,[labor_standard_operation_code] varchar(100)
	  ,[created_dt] date
      ,[created_by] varchar(100)
      ,[updated_dt] date
      ,[updated_by] varchar(100)
      ,[billtime] varchar(100)
      ,[JobTotalHrs] varchar(100)
	  )

insert into #temp (
	   [header_xml_id]
      ,[RoNo]
      ,[src_dealer_code]
      ,[Finalpostdate]
      ,[jobno]
      ,[JobStatus]
      ,[UpSellFlag]
      ,[opcode]
      ,[opcode_desc]
      ,[complaint]
      ,[Cause]
      ,[correction]
      ,[Billrate]
      ,[tech_note]
      ,[opcode_dlrcost]
      ,[opcode_amttype]
      ,[opcode_paytype]
      ,[opcode_total_amt]
      ,[ro_labor_amttype]
      ,[ro_labor_paytype]
      ,[ro_labor_dlr_cost]
      ,[ro_labor_ntxblamt]
      ,[ro_labor_txblamt]
      ,[file_log_id]
      ,[file_log_detail_id]
      ,[parent_dealer_id]
      ,[natural_key]
      ,[labor_department_type]
      ,[labor_standard_operation_code]
	  ,[created_dt]
      ,[created_by]
      ,[updated_dt]
      ,[updated_by]
	  ,[billtime]
      ,[JobTotalHrs]
	  )
	  select 
		0
      ,[RO Number]
		,0
      ,[Close Date]
		,0
      ,[RO Status]
      ,[Upsell]
      ,[Operation Codes]
      ,[Operation Code Descriptions]
      ,[Labor Complaint]
      ,[Labor Cause]
      ,[Labor Correction]
      ,[Labor Bill Rate]
      ,[Labor Comments]
      ,0
      ,0
      ,[Payment Method]
      ,[Total Sale]
      ,[Operation Sale Types]
		,0
      ,[Labor Cost]
		,0
		,0
      ,[process_id]
      ,[file_process_detail_id]
      ,[Vendor Dealer ID]
      ,[DV Dealer ID]
      ,[RO Department]
      ,[Recommended Operation Codes]
	  ,getdate()
      ,suser_name()
      ,getdate()
      ,suser_name()
	  ,[Labor Bill Hours]
      ,[Labor Tech Hours]
	  from etl.atc_service
	  		
		select 
			b.items as [Operation_codes]
			,t.[header_xml_id]
			,t.[RoNo]
			,t.[src_dealer_code]
			,t.[Finalpostdate]
			,t.[jobno]
			,t.[JobStatus]
			,t.[UpSellFlag]
			,t.[tech_note]
			,t.[opcode_paytype]
			,t.[opcode_total_amt]
			,t.[ro_labor_paytype]
			,t.[ro_labor_ntxblamt]
			,t.[ro_labor_txblamt]
			,t.[file_log_id]
			,t.[file_log_detail_id]
			,t.[parent_dealer_id]
			,t.[natural_key]
			,t.[labor_department_type]
			,t.[labor_standard_operation_code]
			,t.[created_dt]
			,t.[created_by]
			,t.[updated_dt]
			,t.[updated_by]
			,t.[billtime]
			,t.[opcode_dlrcost]
			,t.[opcode_amttype]
			,t.[complaint]

		into #temp1 
		from #temp t with(nolock) 
		cross apply  [dbo].[fn_SplitRows](t.RoNo, t.opcode,'|') as b 

		select 
			b.items as [Operation_code_desc]
			into #temp2 
		from #temp t with(nolock) 
		cross apply  [dbo].[fn_SplitRows](t.rono, t.opcode_desc,'|') as b 
		select 
			b.items as [Cause]
			into #temp3 
		from #temp t with(nolock) 
		cross apply  [dbo].[fn_SplitRows](t.rono, t.Cause,'|') as b 
		select 
			b.items as [Correction]
			into #temp4 
		from #temp t with(nolock) 
		cross apply  [dbo].[fn_SplitRows](t.rono, t.correction,'|') as b
		select 
			b.items as [BillRate]
			into #temp5 
		from #temp t with(nolock) 
		cross apply  [dbo].[fn_SplitRows](t.rono, t.Billrate,'|') as b
		select 
			b.items as [RO_Labor_Amttype]
			into #temp6 
		from #temp t with(nolock) 
		cross apply  [dbo].[fn_SplitRows](t.rono, t.ro_labor_amttype,'|') as b
		select 
			b.items as [RO_Labor_dlr_Cost]
			into #temp7 
		from #temp t with(nolock) 
		cross apply  [dbo].[fn_SplitRows](t.rono, t.ro_labor_dlr_cost,'|') as b
		select 
			b.items as [Job_Total_hrs]
			into #temp8 
		from #temp t with(nolock) 
		cross apply  [dbo].[fn_SplitRows](t.rono, t.JobTotalHrs,'|') as b
		
		alter table #temp1 add id1 int identity(1,1)
		alter table #temp2 add id2 int identity(1,1)
		alter table #temp3 add id3 int identity(1,1)
		alter table #temp4 add id4 int identity(1,1)
		alter table #temp5 add id5 int identity(1,1)
		alter table #temp6 add id6 int identity(1,1)
		alter table #temp7 add id7 int identity(1,1)
		alter table #temp8 add id8 int identity(1,1)
		
		select t1.*,t2.[Operation_code_desc],t3.[Cause]
		,t4.[Correction], t5.[BillRate], t6.[RO_Labor_Amttype], t7.[RO_Labor_dlr_Cost], t8.[Job_Total_hrs]
		into #temp0
		from #temp1 t1 left join #temp2 t2 on t1.id1 = t2.id2 left join #temp3 t3 on t1.id1 = t3.id3 
		left join #temp4 t4 on t1.id1 = t4.id4 left join #temp5 t5 on t1.id1 = t5.id5 left join #temp6 t6 on t1.id1 = t6.id6
		left join #temp7 t7 on t1.id1 = t7.id7 left join #temp8 t8 on t1.id1 = t8.id8
	
		insert into [stg].[rr_service_operations] (
		      [header_xml_id]
			  ,[RoNo]
			  ,[src_dealer_code]
			  ,[Finalpostdate]
			  ,[jobno]
			  ,[JobStatus]
			  ,[UpSellFlag]
			  ,[opcode]
			  ,[opcode_desc]
			  ,[complaint]
			  ,[Cause]
			  ,[correction]
			  ,[Billrate]
			  ,[tech_note]
			  ,[opcode_dlrcost]
			  ,[opcode_amttype]
			  ,[opcode_paytype]
			  ,[opcode_total_amt]
			  ,[ro_labor_amttype]
			  ,[ro_labor_paytype]
			  ,[ro_labor_dlr_cost]
			  ,[ro_labor_ntxblamt]
			  ,[ro_labor_txblamt]
			  ,[file_log_id]
			  ,[file_log_detail_id]
			  ,[parent_dealer_id]
			  ,[natural_key]
			  ,[labor_department_type]
			  ,[labor_standard_operation_code]
			  ,[created_dt]
			  ,[created_by]
			  ,[updated_dt]
			  ,[updated_by]
			  ,[billtime]
			  ,[JobTotalHrs]
			  )
			  select 
			  	 header_xml_id
				,RoNo
				,src_dealer_code
				,Finalpostdate
				,jobno
				,JobStatus
				,UpSellFlag
				,Operation_codes
				,Operation_code_desc
				,complaint --
				,Cause
				,Correction
				,BillRate
				,tech_note
				,opcode_dlrcost --
				,opcode_amttype --
				,opcode_paytype
				,opcode_total_amt
				,RO_Labor_Amttype
				,ro_labor_paytype
				,RO_Labor_dlr_Cost
				,ro_labor_ntxblamt
				,ro_labor_txblamt
				,file_log_id
				,file_log_detail_id
				,parent_dealer_id
				,natural_key
				,labor_department_type
				,labor_standard_operation_code
				,created_dt
				,created_by
				,updated_dt
				,updated_by
				,billtime
				,Job_Total_hrs

			from #temp0
		select * from stg.rr_service_operations with(nolock)
		end

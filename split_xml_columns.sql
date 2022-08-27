
USE [clictell_auto_etl]
--GO
--/****** Object:  StoredProcedure [etl].[cdk_etl_service_header_xml]    Script Date: 2/25/2021 2:12:07 PM *****
--exec [etl].[cdk_move_stg_service_ro_operations] 25
--select * from [stg].[service_ro_operations]
--drop table [stg].[service_ro_operations]
--select * from [etl].[cdk_servicero_details_xml]
--*/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

 
--create procedure  [etl].[cdk_move_stg_service_ro_operations]   
----declare
--   @file_process_detail_id int 

--as
begin
---------------------------------LaborCost
IF OBJECT_ID('tempdb..#LaborCost') IS NOT NULL DROP TABLE #LaborCost
IF OBJECT_ID('tempdb..#LaborCosttemp') IS NOT NULL DROP TABLE #LaborCosttemp
select convert(xml,LaborCost) as LaborCost, CloseDate, OpenDate, cdk_dealer_code,RONumber into #LaborCosttemp from [etl].[cdk_servicero_details_xml]
select  
a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code, V.value('(text())[1]', 'varchar(25)') as LaborCost, IDx.value('@Idx', 'varchar(10)') as LaborCostno
into #LaborCost from #LaborCosttemp a
CROSS APPLY a.LaborCost.nodes('/totLaborCost/V') AS LaborCost(V) CROSS APPLY V.nodes('.') as Y(IDx)
------------------------------------LaborSale
IF OBJECT_ID('tempdb..#LaborSale') IS NOT NULL DROP TABLE #LaborSale
IF OBJECT_ID('tempdb..#LaborSaletemp') IS NOT NULL DROP TABLE #LaborSaletemp
select convert(xml,LaborSale) as LaborSale, CloseDate, OpenDate, cdk_dealer_code,RONumber into #LaborSaletemp from [etl].[cdk_servicero_details_xml]
select  
a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code, V.value('(text())[1]', 'varchar(25)') as LaborSale, IDx.value('@Idx', 'varchar(10)') as LaborSaleno
into #LaborSale from #LaborSaletemp a
CROSS APPLY a.LaborSale.nodes('/totLaborSale/V') AS lbrcost(V) CROSS APPLY V.nodes('.') as Y(IDx)
------------------------------------SoldHours
IF OBJECT_ID('tempdb..#SoldHours') IS NOT NULL DROP TABLE #SoldHours
IF OBJECT_ID('tempdb..#SoldHourstemp') IS NOT NULL DROP TABLE #SoldHourstemp
select convert(xml,SoldHours) as SoldHours, CloseDate, OpenDate, cdk_dealer_code,RONumber into #SoldHourstemp from [etl].[cdk_servicero_details_xml]
select  
a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code, V.value('(text())[1]', 'varchar(25)') as SoldHours, IDx.value('@Idx', 'varchar(10)') as SoldHoursno
into #SoldHours from #SoldHourstemp a
CROSS APPLY a.SoldHours.nodes('/totSoldHours/V') AS lbrcost(V) CROSS APPLY V.nodes('.') as Y(IDx)
------------------------------------LaborType
IF OBJECT_ID('tempdb..#LaborType') IS NOT NULL DROP TABLE #LaborType
IF OBJECT_ID('tempdb..#LaborTypetemp') IS NOT NULL DROP TABLE #LaborTypetemp
select convert(xml,LaborType) as LaborType, CloseDate, OpenDate, cdk_dealer_code,RONumber into #LaborTypetemp from [etl].[cdk_servicero_details_xml]
select  
a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code, V.value('(text())[1]', 'varchar(25)') as LaborType, IDx.value('@Idx', 'varchar(10)') as LaborTypeno
into #LaborType from #LaborTypetemp a
CROSS APPLY a.LaborType.nodes('/lbrLaborType/V') AS LaborType(V) CROSS APPLY V.nodes('.') as Y(IDx)
------------------------------------LineCode
IF OBJECT_ID('tempdb..#LineCode') IS NOT NULL DROP TABLE #LineCode
IF OBJECT_ID('tempdb..#LineCodetemp') IS NOT NULL DROP TABLE #LineCodetemp
select convert(xml,LineCode) as linecode, CloseDate, OpenDate, cdk_dealer_code,RONumber into #LineCodetemp from [etl].[cdk_servicero_details_xml]
select  
a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code, V.value('(text())[1]', 'varchar(25)') as LineCode, IDx.value('@Idx', 'varchar(10)') as LineCodeno
into #LineCode from #LineCodetemp a
CROSS APPLY a.linecode.nodes('/linLineCode/V') AS linecode(V) CROSS APPLY V.nodes('.') as Y(IDx)
-----------------------------------ServiceRequest
IF OBJECT_ID('tempdb..#ServiceRequest') IS NOT NULL DROP TABLE #ServiceRequest
IF OBJECT_ID('tempdb..#ServiceRequesttemp') IS NOT NULL DROP TABLE #ServiceRequesttemp
select convert(xml,ServiceRequest) as ServiceRequest, CloseDate, OpenDate, cdk_dealer_code,RONumber into #ServiceRequesttemp from [etl].[cdk_servicero_details_xml]
select  
a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code, V.value('(text())[1]', 'varchar(25)') as ServiceRequest, IDx.value('@Idx', 'varchar(10)') as ServiceRequestno
into #ServiceRequest from #ServiceRequesttemp a
CROSS APPLY a.ServiceRequest.nodes('/linServiceRequest/V') AS ServiceRequest(V) CROSS APPLY V.nodes('.') as Y(IDx)
---------------------------------ActualHours
IF OBJECT_ID('tempdb..#ActualHours') IS NOT NULL DROP TABLE #ActualHours
IF OBJECT_ID('tempdb..#ActualHourstemp') IS NOT NULL DROP TABLE #ActualHourstemp
select convert(xml,ActualHours) as ActualHours, CloseDate, OpenDate, cdk_dealer_code,RONumber into #ActualHourstemp from [etl].[cdk_servicero_details_xml]
select  
a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code, V.value('(text())[1]', 'varchar(25)') as ActualHours, IDx.value('@Idx', 'varchar(10)') as ActualHoursno
into #ActualHours from #ActualHourstemp a
CROSS APPLY a.ActualHours.nodes('/hrsActualHours/V') AS ActualHours(V) CROSS APPLY V.nodes('.') as Y(IDx)
-------------------------------------DispatchLineStatus
IF OBJECT_ID('tempdb..#DispatchLineStatus') IS NOT NULL DROP TABLE #DispatchLineStatus
IF OBJECT_ID('tempdb..#DispatchLineStatustemp') IS NOT NULL DROP TABLE #DispatchLineStatustemp
select convert(xml,DispatchLineStatus) as DispatchLineStatus, CloseDate, OpenDate, cdk_dealer_code,RONumber into #DispatchLineStatustemp from [etl].[cdk_servicero_details_xml]
select  
a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code, V.value('(text())[1]', 'varchar(25)') as DispatchLineStatus, IDx.value('@Idx', 'varchar(10)') as DispatchLineStatusno
into #DispatchLineStatus from #DispatchLineStatustemp a
CROSS APPLY a.DispatchLineStatus.nodes('/lbrLineCode/V') AS DispatchLineStatus(V) CROSS APPLY V.nodes('.') as Y(IDx)
-------------------------------------PartsSale
IF OBJECT_ID('tempdb..#PartsSale') IS NOT NULL DROP TABLE #PartsSale
IF OBJECT_ID('tempdb..#PartsSaletemp') IS NOT NULL DROP TABLE #PartsSaletemp
select convert(xml,PartsSale) as PartsSale, CloseDate, OpenDate, cdk_dealer_code,RONumber into #PartsSaletemp from [etl].[cdk_servicero_details_xml]
select  
a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code, V.value('(text())[1]', 'varchar(25)') as PartsSale, IDx.value('@Idx', 'varchar(10)') as PartsSaleno
into #PartsSale from #PartsSaletemp a
CROSS APPLY a.PartsSale.nodes('/totPartsSale/V') AS PartsSale(V) CROSS APPLY V.nodes('.') as Y(IDx)
-------------------------------------Causes
IF OBJECT_ID('tempdb..#Causes') IS NOT NULL DROP TABLE #Causes
IF OBJECT_ID('tempdb..#Causestemp') IS NOT NULL DROP TABLE #Causestemp
select convert(xml,Causes) as Causes, CloseDate, OpenDate, cdk_dealer_code,RONumber into #Causestemp from [etl].[cdk_servicero_details_xml]
select  
a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code, V.value('(text())[1]', 'varchar(25)') as Causes, IDx.value('@Idx', 'varchar(10)') as Causesno
into #Causes from #Causestemp a
CROSS APPLY a.Causes.nodes('/linCause/V') AS Causes(V) CROSS APPLY V.nodes('.') as Y(IDx)
---------------------------------


IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

select RONumber,OpenDate,CloseDate,cdk_dealer_code,convert(xml,opcode) as opcode,convert(xml,TechNo) as TechNo,
convert(xml,ComplaintCode) as ComplaintCode,convert(xml,MiscSale) as MiscSale,convert(xml,DispatchCode) as DispatchCode,
convert(xml,OpCodeDescription) as OpCodeDescription,convert(xml,PartsCost) as PartsCost,convert(xml,MiscCost) as MiscCost
into #temp from etl.[cdk_servicero_details_xml]

--select * from  #temp
---------------------------------------------------------------------
IF OBJECT_ID('tempdb..#opcode') IS NOT NULL DROP TABLE #opcode

select a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code,
V.value('(text())[1]', 'varchar(25)') as OpCode,
IDx.value('@Idx', 'varchar(10)') as OpCodeNo
into
#opcode
from
#temp a
CROSS APPLY a.OpCode.nodes('/lbrOpCode/V') AS OpCode(V)
CROSS APPLY V.nodes('.') as Y(IDx)
--select * from #opcode
--------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#techno') IS NOT NULL DROP TABLE #techno

select a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code,
V.value('(text())[1]', 'varchar(25)') as TechNo,
IDx.value('@Idx', 'varchar(10)') as TechNo_No
into
#techno
from
#temp a
CROSS APPLY a.TechNo.nodes('/lbrTechNo/V') AS TechNo(V)
CROSS APPLY V.nodes('.') as Y(IDx)
--select * from #techno
-------------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#Complaintcode') IS NOT NULL DROP TABLE #Complaintcode

select a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code,
V.value('(text())[1]', 'varchar(25)') as Complaintcode,
IDx.value('@Idx', 'varchar(10)') as Complaintcode_No
into
#Complaintcode
from
#temp a
CROSS APPLY a.ComplaintCode.nodes('/linComplaintCode/V') AS ComplaintCode(V)
CROSS APPLY V.nodes('.') as Y(IDx)

--select * from #Complaintcode
------------------------------------------------------------
IF OBJECT_ID('tempdb..#MiscSale') IS NOT NULL DROP TABLE #MiscSale

select a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code,
V.value('(text())[1]', 'varchar(25)') as MiscSale,
IDx.value('@Idx', 'varchar(10)') as MiscSale_No
into
#MiscSale
from
#temp a
CROSS APPLY a.MiscSale.nodes('/totMiscSale/V') AS MiscSale(V)
CROSS APPLY V.nodes('.') as Y(IDx)
--select * from #MiscSale
------------------------------------------------------

IF OBJECT_ID('tempdb..#DispatchCode') IS NOT NULL DROP TABLE #DispatchCode

select a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code,
V.value('(text())[1]', 'varchar(25)') as DispatchCode,
IDx.value('@Idx', 'varchar(10)') as DispatchCode_No
into
#DispatchCode
from
#temp a
CROSS APPLY a.DispatchCode.nodes('/linDispatchCode/V') AS DispatchCode(V)
CROSS APPLY V.nodes('.') as Y(IDx)
--select * from #DispatchCode
---------------------------------------------------
IF OBJECT_ID('tempdb..#OpCodeDescription') IS NOT NULL DROP TABLE #OpCodeDescription

select a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code,
V.value('(text())[1]', 'varchar(25)') as OpCodeDescription,
IDx.value('@Idx', 'varchar(10)') as OpCodeDescription_No
into
#OpCodeDescription
from
#temp a
CROSS APPLY a.OpCodeDescription.nodes('/lbrOpCodeDesc/V') AS OpCodeDescription(V)
CROSS APPLY V.nodes('.') as Y(IDx)
--select * from #OpCodeDescription
------------------------------------------------------
IF OBJECT_ID('tempdb..#PartsCost') IS NOT NULL DROP TABLE #PartsCost

select a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code,
V.value('(text())[1]', 'varchar(25)') as PartsCost,
IDx.value('@Idx', 'varchar(10)') as PartsCost_No
into
#PartsCost
from
#temp a
CROSS APPLY a.PartsCost.nodes('/totPartsCost/V') AS PartsCost(V)
CROSS APPLY V.nodes('.') as Y(IDx)
--select * from #PartsCost
-----------------------------------------------------------

IF OBJECT_ID('tempdb..#MiscCost') IS NOT NULL DROP TABLE #MiscCost

select a.RONumber, a.OpenDate, a.CloseDate,  a.cdk_dealer_code,
V.value('(text())[1]', 'varchar(25)') as MiscCost,
IDx.value('@Idx', 'varchar(10)') as MiscCost_No
into
#MiscCost
from
#temp a
CROSS APPLY a.MiscCost.nodes('/totMiscCost/V') AS MiscCost(V)
CROSS APPLY V.nodes('.') as Y(IDx)

--select * from #MiscCost
---------------------------------------------------------------------------------


--select * from [etl].[cdk_servicero_details_xml] 
--select * from [stg].[service_ro_operations]

--	select * from #LaborCost --453
--	select * from #LaborSale --453
--	select * from #SoldHours --453
--	select * from #PartsSale --453
--	select * from #MiscSale	 --453
--	select * from #MiscCost  --453
--	select * from #PartsCost --453
--	select * from #LaborType --283
--	select * from #DispatchLineStatus --283
--	select * from #opcode --283
--	select * from #techno --283
--	select * from #OpCodeDescription --283
--	select * from #ActualHours       --276
--	select * from #LineCode          --261
--	select * from #ServiceRequest    --261
--	select * from #DispatchCode      --260
--	select * from #Complaintcode     --214
--	select * from #Causes			 --168


IF OBJECT_ID('tempdb..#service_ro_details') IS NOT NULL DROP TABLE #service_ro_details

select 
s.LaborSale,h.SoldHours,ms.MiscSale,mc.MiscCost,pc.PartsCost,ps.PartsSale, lt.LaborType, oc.OpCode,
ocd.OpCodeDescription, tn.TechNo,dls.DispatchLineStatus, ac.ActualHours,lc.LineCode,sr.ServiceRequest,
dc.DispatchCode,ca.Causes,cc.Complaintcode,

etl.cdk_dealer_code,etl.dealer_id,etl.ComeBack,etl.PickItemID,etl.AddOnFlag,etl.ErrorMessage,etl.BookerNo,etl.RONumber,
etl.DispatchEstimatedDuration,etl.PartsFlag,etl.DispatchLineCode,etl.LopSeqNo,etl.VehID,etl.CampaignCode,etl.ErrorLevel,
etl.HostItemID, etl.file_process_detail_id,etl.file_process_id,etl.OpenDate,etl.CloseDate,etl.cdk_servicero_detail_ID

into #service_ro_details
from #LaborCost c
inner join #LaborSale s	 on c.LaborCostno = s.LaborSaleno and c.RONumber = s.RONumber
inner join #SoldHours h	 on c.LaborCostno = h.SoldHoursno and c.RONumber = h.RONumber
inner join #MiscSale ms	 on c.LaborCostno = ms.MiscSale_No and c.RONumber = ms.RONumber
inner join #MiscCost mc	 on c.LaborCostno = mc.MiscCost_No and c.RONumber = mc.RONumber
inner join #PartsCost pc on c.LaborCostno = pc.PartsCost_No and c.RONumber = pc.RONumber
inner join #PartsSale ps on c.LaborCostno = ps.PartsSaleno and c.RONumber = ps.RONumber
left outer join #LaborType lt	on c.LaborCostno = lt.LaborTypeno and  c.RONumber = lt.RONumber
left outer join #opcode oc		on c.LaborCostno = oc.OpCodeNo and c.RONumber = oc.RONumber
left outer join #OpCodeDescription ocd on c.LaborCostno = ocd.OpCodeDescription and c.RONumber = ocd.RONumber
left outer join #techno tn		on c.LaborCostno = tn.TechNo and c.RONumber = tn.RONumber
left outer join #DispatchLineStatus dls on c.LaborCostno = dls.DispatchLineStatusno and c.RONumber = dls.RONumber
left outer join #ActualHours ac on c.LaborCostno = ac.ActualHoursno and c.RONumber = ac.RONumber
left outer join #LineCode lc	on c.LaborCostno = lc.LineCodeno and c.RONumber = lc.RONumber
left outer join #ServiceRequest sr on c.LaborCostno = sr.ServiceRequestno and c.RONumber = sr.RONumber
left outer join #DispatchCode dc on c.LaborCostno = dc.DispatchCode_No and c.RONumber = dc.RONumber
left outer join #Complaintcode cc on c.LaborCostno = cc.Complaintcode_No and c.RONumber = cc.RONumber
left outer join #Causes ca		on c.LaborCostno = ca.Causesno and c.RONumber = ca.RONumber
left outer join [etl].[cdk_servicero_details_xml] etl on c.RONumber = etl.RONumber
where file_process_detail_id = @file_process_detail_id

insert into [stg].[service_ro_operations]
 (     [RoNo]
      ,[Finalpostdate]
      ,[opcode]
      ,[opcode_desc]
      ,[complaint]
      ,[Cause]
      ,[tech_note]
      ,[ro_labor_paytype]
      ,[ro_labor_dlr_cost]
      ,[JobTotalHrs]
      ,[file_process_id]
      ,[file_process_detail_id]
      ,[natural_key]
      ,[created_dt]
      ,[created_by]
      ,[updated_dt]
      ,[updated_by]
)
select 
      [RONumber]
      ,[CloseDate]
      ,[OpCode]
      ,[OpCodeDescription]
      ,[ComplaintCode]
      ,[Causes]
      ,[TechNo]
      ,[LaborType]
      ,[LaborSale]
      ,[SoldHours]
      ,[file_process_id]
      ,[file_process_detail_id]
	  ,md.natural_key
		,[dealer_id]
		,getdate()
		,suser_name()
		,getdate()
		,suser_name()

from #service_ro_details -- 38 cols
inner join master.dealer md on md.natural_key = dealer_id



end

USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [etl].[dt_etl_customer_xml]    Script Date: 8/5/2022 4:02:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure  [etl].[dt_etl_service_appt_xml_loading]     
--declare  
   @file_process_detail_id int   = 2316
as  
/*
select * from etl.dt_service_appointments (nolock) where file_process_detail_id = 2316
--alter table etl.dt_service_appointments add parent_dealer_id int, src_dealer_code varchar(50)
exec [etl].[dt_etl_customer_xml_loading] 2316
*/

Begin
	declare 
	 @flle_path varchar(1000)
	,@file_process_id int
	,@file_name varchar(100) 
	,@xml_main xml
	,@xml nvarchar(max)
	,@xml1 nvarchar(max)
	,@xml2 xml
	,@parent_dealer_id int 
	,@src_dealer_code varchar(20) 
	
	drop table if exists #temp
	drop table if exists #temp1
	drop table if exists #tempA

	select 
		 @src_dealer_code = natural_key
		,@parent_dealer_id = parent_dealer_id  
	from clictell_auto_master.master.dealer(nolock) where accountname = 'Team Nissan'


	select
		@flle_path = [full_file_path], 
		@file_process_id = process_id, 
		@file_name = [file_name],
		@file_process_id = [process_id]
	from 
		etl.file_process_details (nolock)  
	where 
		file_process_detail_id = @file_process_detail_id  

	DECLARE @SQL NVARCHAR(1000)= 'SET @xml = (SELECT * FROM OPENROWSET (BULK ''' + @flle_path + ''', SINGLE_CLOB) AS XmlData)'  

	EXEC sp_executesql @SQL, N'@xml XML OUTPUT', @xml_main OUTPUT;  

	select @xml1 = convert(nvarchar(max),@xml_main)
	--select @xml1,@xml_main


	--select len(@xml1)
	--		,len(substring(@xml1,charindex('<soap:Envelope',@xml1),charindex('/transitional">',@xml1) + len('/transitional"') )) as l1
	--		,len(substring(@xml1,charindex('</AppointmentLookupResult>',@xml1),charindex('</soap:Envelope>',@xml1)  )) as l2
	--		,substring(@xml1,charindex('<soap:Envelope',@xml1),charindex('/transitional">',@xml1) + len('/transitional"') ) as repla1
	--		, substring(@xml1,charindex('</AppointmentLookupResult>',@xml1),charindex('</soap:Envelope>',@xml1)  ) as repla2

	select @xml1 = replace(@xml1,substring(@xml1,charindex('<soap:Envelope',@xml1),charindex('/transitional">',@xml1) + len('/transitional"') ),'<root>')
	--select len(@xml1),@xml1
	select @xml1 = replace(@xml1,substring(@xml1,charindex('</AppointmentLookupResult>',@xml1),charindex('</soap:Envelope>',@xml1)  ),'</root>')
	
	select @xml2 = convert(xml,@xml1)
	
	select 
			sd.d.value('(CompanyNumber/text())[1]', 'varchar(50)') as CompanyNumber,
			sd.d.value('(AppointmentNumber/text())[1]', 'varchar(50)') as AppointmentNumber,
			sd.d.value('(AppointmentDateTime /text())[1]', 'varchar(50)') as AppointmentDateTime,
			sd.d.value('(OpenTransactionDate /text())[1]', 'varchar(50)') as OpenTransactionDate ,
			sd.d.value('(ServiceWriterID  /text())[1]', 'varchar(50)') as ServiceWriterID  ,
			sd.d.value('(FranchiseCode  /text())[1]', 'varchar(50)') as FranchiseCode  ,
			sd.d.value('(TotalEstimate  /text())[1]', 'varchar(50)') as TotalEstimate  ,
			sd.d.value('(ROStatus  /text())[1]', 'varchar(50)') as ROStatus  ,
			sd.d.value('(CustomerKey  /text())[1]', 'varchar(50)') as CustomerKey  ,
			sd.d.value('(CustomerName  /text())[1]', 'varchar(250)') as CustomerName  ,
			sd.d.value('(CustomerAddress1   /text())[1]', 'varchar(250)') as CustomerAddress1   ,
			sd.d.value('(CustomerAddress2   /text())[1]', 'varchar(250)') as CustomerAddress2   ,
			sd.d.value('(CustomerCity   /text())[1]', 'varchar(50)') as CustomerCity   ,
			sd.d.value('(CustomerState    /text())[1]', 'varchar(50)') as CustomerState    ,
			sd.d.value('(CustomerZipCode    /text())[1]', 'varchar(50)') as CustomerZipCode    ,
			sd.d.value('(CustomerEmail    /text())[1]', 'varchar(50)') as CustomerEmail    ,
			sd.d.value('(CustomerPhoneNumber    /text())[1]', 'varchar(50)') as CustomerPhoneNumber    ,
			sd.d.value('(VIN    /text())[1]', 'varchar(50)') as VIN    ,
			sd.d.value('(StockNumber    /text())[1]', 'varchar(50)') as StockNumber    ,
			sd.d.value('(Make    /text())[1]', 'varchar(50)') as Make    ,
			sd.d.value('(Model    /text())[1]', 'varchar(50)') as Model    ,
			sd.d.value('(ModelYear     /text())[1]', 'varchar(50)') as ModelYear    ,
			sd.d.value('(Truck     /text())[1]', 'varchar(50)') as Truck     ,
			sd.d.value('(OdometerIn      /text())[1]', 'varchar(50)') as OdometerIn      ,
			sd.d.value('(AppointmentId      /text())[1]', 'varchar(50)') as AppointmentId      ,
			sd.d.query('Details') as Details      ,
			@file_process_id as file_process_id,
			@file_process_detail_id as file_process_detail_id

	into #temp		
	from   
		@xml2.nodes('/root/Result') AS sd(d)   

	select  a.CompanyNumber,a.AppointmentNumber,a.AppointmentDateTime,
			v.value('(ServiceLineNumber/text())[1]', 'varchar(50)') as ServiceLineNumber,
			v.value('(LineType/text())[1]', 'varchar(50)') as LineType,
			v.value('(SequenceNumber/text())[1]', 'varchar(50)') as SequenceNumber,
			v.value('(TransDate/text())[1]', 'varchar(50)') as TransDate,
			v.value('(Comments/text())[1]', 'varchar(50)') as Comments,
			v.value('(ServiceType/text())[1]', 'varchar(50)') as ServiceType,
			v.value('(LinePaymentMethod/text())[1]', 'varchar(50)') as LinePaymentMethod,
			v.value('(TechnicianID/text())[1]', 'varchar(50)') as TechnicianID,
			v.value('(LaborOpCode/text())[1]', 'varchar(50)') as LaborOpCode,
			v.value('(LaborHours/text())[1]', 'varchar(50)') as LaborHours,
			v.value('(LaborCostHours/text())[1]', 'varchar(50)') as LaborCostHours,
			v.value('(ActualRetailAmount/text())[1]', 'varchar(50)') as ActualRetailAmount,
			v.value('(PartNumber/text())[1]', 'varchar(50)') as PartNumber,
			v.value('(CounterPersonID/text())[1]', 'varchar(50)') as CounterPersonID,
			v.value('(StockGroup/text())[1]', 'varchar(50)') as StockGroup,
			v.value('(Manufacturer/text())[1]', 'varchar(50)') as Manufacturer,
			v.value('(Quantity/text())[1]', 'varchar(50)') as Quantity,
			v.value('(Cost/text())[1]', 'varchar(50)') as Cost,
			v.value('(ListPrice/text())[1]', 'varchar(50)') as ListPrice,
			v.value('(NetPrice/text())[1]', 'varchar(50)') as NetPrice,
			v.value('(TradePrice/text())[1]', 'varchar(50)') as TradePrice
	into #temp1
	from #temp a
	CROSS APPLY a.Details.nodes('/Details/AppointmentDetail') AS Details(v)


	select 
			t.*
			,t1.ServiceLineNumber,t1.SequenceNumber,t1.LineType,t1.TransDate,t1.Comments,t1.ServiceType,t1.LinePaymentMethod,t1.TechnicianID
			,t1.LaborOpCode,t1.LaborHours,t1.LaborCostHours,t1.ActualRetailAmount,t1.PartNumber,t1.CounterPersonID,t1.StockGroup,t1.Manufacturer,t1.Quantity
			,t1.Cost,t1.ListPrice,t1.NetPrice,t1.TradePrice
	into #tempA
	from #temp t 
	inner join #temp1 t1 on t.AppointmentNumber = t1.AppointmentNumber and t.CompanyNumber=t1.CompanyNumber

	insert into etl.dt_service_appointments
		(
			CompanyNumber
			,AppointmentNumber
			,AppointmentDateTime
			,OpenTransactionDate
			,ServiceWriterID	
			,FranchiseCode	
			,TotalEstimate	
			,ROStatus	
			,CustomerKey	
			,CustomerName	
			,CustomerAddress1
			,CustomerAddress2	
			,CustomerCity	
			,CustomerState	
			,CustomerZipCode
			,CustomerEmail	
			,CustomerPhoneNumber	
			,VIN	
			,StockNumber
			,Make	
			,Model	
			,ModelYear
			,Truck	
			,OdometerIn
			,AppointmentId
			,ServiceLineNumber
			,SequenceNumber	
			,LineType	
			,TransDate	
			,Comments
			,ServiceType	
			,LinePaymentMethod
			,TechnicianID	
			,LaborOpCode
			,LaborHours	
			,LaborCostHours
			,ActualRetailAmount	
			,PartNumber	
			,CounterPersonID
			,StockGroup	
			,Manufacturer
			,Quantity	
			,Cost	
			,ListPrice
			,NetPrice
			,TradePrice	
			,file_process_id	
			,file_process_detail_id	
			,parent_dealer_id
			,src_dealer_code
		)

	select 
			CompanyNumber
			,AppointmentNumber
			,AppointmentDateTime
			,OpenTransactionDate
			,ServiceWriterID	
			,FranchiseCode	
			,TotalEstimate	
			,ROStatus	
			,CustomerKey	
			,CustomerName	
			,CustomerAddress1
			,CustomerAddress2	
			,CustomerCity	
			,CustomerState	
			,CustomerZipCode
			,CustomerEmail	
			,CustomerPhoneNumber	
			,VIN	
			,StockNumber
			,Make	
			,Model	
			,ModelYear
			,Truck	
			,OdometerIn
			,AppointmentId
			,ServiceLineNumber
			,SequenceNumber	
			,LineType	
			,TransDate	
			,Comments
			,ServiceType	
			,LinePaymentMethod
			,TechnicianID	
			,LaborOpCode
			,LaborHours	
			,LaborCostHours
			,ActualRetailAmount	
			,PartNumber	
			,CounterPersonID
			,StockGroup	
			,Manufacturer
			,Quantity	
			,Cost	
			,ListPrice
			,NetPrice
			,TradePrice	
			,file_process_id	
			,file_process_detail_id	
			,@parent_dealer_id
			,@src_dealer_code
	from #tempA
end
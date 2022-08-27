USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [etl].[cdk_etl_service_header_xml]    Script Date: 2/25/2021 2:12:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
ALTER procedure  [etl].[cdk_etl_service_header_xml]   
--declare
   @file_process_detail_id int

as 

/*
	exec [etl].[cdk_etl_service_header_xml]  25
-----------------------------------------------------------------------  
	

	PURPOSE  
	direct load from etl to stage sale

	PROCESSES  

	MODIFICATIONS  
	Date			Author    Work Tracker Id   Description    
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------

	*/
	
begin
      --declare   @file_process_detail_id int = 25

	 IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

		declare @xml xml
		declare @xml_id int  
		declare @file_log_id int  
		declare @rowcount int
		declare @flle_path varchar(1000)
		declare @cdk_dealer_code varchar(1000) = '3PADEV1'
		declare @dealer_id varchar(1000) 
		declare @dealername varchar(1000) 
		declare @xml_main xml
		declare @file_process_id int

		--select  @dealername = 
		--	stuff(stuff(file_name,1,charindex('_',file_name),'') ,1,charindex('_',stuff(file_name,1,charindex('_',file_name),'')),'') from etl.file_log_details with(nolock) 
		--where file_log_detail_id = @file_log_detail_id

		--select @cdk_dealer_code = substring(@dealername , 1, CHARINDEX ( '_',@dealername)-1) 
				
		--select 
		--@dealer_id = replace( reverse( substring( reverse(file_name ) , 1 , CHARINDEX ( '_', reverse(file_name ) ) -1 ) ) ,'.xml','')
		--from etl.file_log_details with(nolock) 
		--where file_log_detail_id = @file_log_detail_id
		

 			--select top 1 
						   
				--		@xml_main = xml_text
				--		,@file_log_id = file_log_id,
				--		  @xml_id = xml_id 

				--		from 
				--			etl.file_xml dx (nolock) 
				--			 --inner join etl.header_xml eh (nolock) on
				--			 -- dx.xml_id=eh.xml_id
				--		where 
				--			dx.file_type like '%CDK%' and
				--          -- dx.process_status='P' and 
				--		   dx.xml_text is not null and
				--           dx.file_log_detail_id=  @file_log_detail_id  
				

			select @flle_path = [file_name], @file_process_id = process_id
			from etl.file_process_details (nolock)
			where file_process_detail_id = @file_process_detail_id

			DECLARE @SQL NVARCHAR(1000)= 'SET @xml = (SELECT * FROM OPENROWSET (BULK ''' + @flle_path + ''', SINGLE_CLOB) AS XmlData)'
			EXEC sp_executesql @SQL, N'@xml XML OUTPUT', @xml_main OUTPUT;

			

 if  cast(@xml_main as nvarchar(max) ) like '<ServiceRODetailHistory xmlns="http://www.dmotorworks.com/service-repair-order-history">%'
			begin 
			print 'If -1' 
				select @xml  = cast(replace(replace(cast(@xml_main as nvarchar(max)) ,'<ServiceRODetailHistory xmlns="http://www.dmotorworks.com/service-repair-order-history">','<root>'),'<ErrorCode>0</ErrorCode><ErrorMessage/></ServiceRODetailHistory>','</root>') as xml)  
			end 
		--else if  cast(@xml_main as nvarchar(max) ) like '<ServiceSalesHistory xmlns="http://www.dmotorworks.com/pip-extract-service-sales-history"><ErrorCode>0</ErrorCode><ErrorMessage/>%'
		--	begin
		--		print 'If ' 
		--		select @xml  = cast( replace(replace(cast(@xml_main as nvarchar(max)) ,'<ServiceSalesHistory xmlns="http://www.dmotorworks.com/pip-extract-service-sales-history"><ErrorCode>0</ErrorCode><ErrorMessage/>','<root>'),'</ServiceSalesHistory>','</root>') as xml)  
		--	end 
		
		--else 
		--	begin 
		--		select 	@xml = 	 cast( replace(replace(cast(@xml_main as nvarchar(max))+'data>','<ServiceSalesClosed xmlns="http://www.dmotorworks.com/pip-extract-service-sales-closed">','<root>'),'</ServiceSalesClosed>data>','</root>') as xml)  
		--	print 'Else ' 
		--	end 			

			--select @xml

-------------------------------- service appts xml file process started-----------------------------------------------------------

--select @xml

		select  

				sd.d.value('(CityStateZip/text())[1]', 'varchar(50)') as CityStateZip ,
				sd.d.value('(WaiterFlag/text())[1]', 'varchar(50)') as WaiterFlag ,
				sd.d.value('(Supp4TaxAmountCP/text())[1]', 'varchar(50)') as Supp4TaxAmountCP ,
				sd.d.value('(LastServiceDate/text())[1]', 'varchar(50)') as LastServiceDate ,
				sd.d.value('(LocalTaxAmountIP/text())[1]', 'varchar(50)') as LocalTaxAmountIP ,
				sd.d.value('(LocalTaxAmountWP/text())[1]', 'varchar(50)') as LocalTaxAmountWP ,
				sd.d.value('(ApptDate/text())[1]', 'varchar(50)') as ApptDate ,
				sd.d.value('(ApptFlag/text())[1]', 'varchar(50)') as ApptFlag ,
				sd.d.value('(ApptTime/text())[1]', 'varchar(50)') as ApptTime ,
				sd.d.value('(LaborCost/text())[1]', 'varchar(50)') as LaborCost ,
				sd.d.value('(LaborSaleWarranty/text())[1]', 'varchar(50)') as LaborSaleWarranty ,
				--sd.d.value('(PickItemID/text())[1]', 'varchar(50)') as PickItemID ,
				sd.d.value('(PostedDate/text())[1]', 'varchar(50)') as PostedDate ,
				sd.d.value('(PriorityValue/text())[1]', 'varchar(50)') as PriorityValue ,
				sd.d.value('(EstComplDate/text())[1]', 'varchar(50)') as EstCompletionDate ,
				sd.d.value('(PromisedTime/text())[1]', 'varchar(50)') as PromisedTime ,
				sd.d.value('(ROComment4/text())[1]', 'varchar(max)') as ROComment4 ,
				sd.d.value('(ROComment6/text())[1]', 'varchar(max)') as ROComment6 ,
				sd.d.value('(ROSaleCP/text())[1]', 'varchar(50)') as ROSaleCP ,
				sd.d.value('(StatusCode/text())[1]', 'varchar(50)') as ROStatusCode ,
				sd.d.value('(StatusDesc/text())[1]', 'varchar(50)') as ROStatusCodeDesc ,
				sd.d.value('(VehicleColor/text())[1]', 'varchar(50)') as Color ,
				sd.d.value('(CustNo/text())[1]', 'varchar(50)') as CustNo ,
				sd.d.value('(BookedDate/text())[1]', 'varchar(50)') as BookedDate ,
				sd.d.value('(ServiceAdvisor/text())[1]', 'varchar(50)') as ServiceAdvisor ,
				sd.d.value('(Supp2TaxAmountIP/text())[1]', 'varchar(50)') as Supp2TaxAmountIP ,
				sd.d.value('(PartsSaleWarranty/text())[1]', 'varchar(50)') as PartsSaleWarranty ,
				sd.d.value('(ROSubletSaleCP/text())[1]', 'varchar(50)') as ROSubletSaleCP ,
				sd.d.value('(ROSubletSaleIP/text())[1]', 'varchar(50)') as ROSubletSaleIP ,
				sd.d.value('(Name2/text())[1]', 'varchar(50)') as Name2 ,
				sd.d.value('(OpenDate/text())[1]', 'varchar(50)') as OpenDate ,
				sd.d.value('(ROComment1/text())[1]', 'varchar(max)') as ROComment1 ,
				sd.d.value('(ROComment2/text())[1]', 'varchar(max)') as ROComment2 ,
				sd.d.value('(ROComment7/text())[1]', 'varchar(max)') as ROComment7 ,
				sd.d.value('(ROMiscSaleIP/text())[1]', 'varchar(50)') as ROMiscSaleIP ,
				sd.d.value('(VIN/text())[1]', 'varchar(50)') as VIN ,
				sd.d.value('(VoidDate/text())[1]', 'varchar(50)') as VoidDate ,
				sd.d.value('(StateTaxAmountIP/text())[1]', 'varchar(50)') as StateTaxAmountIP ,
				sd.d.value('(Supp2TaxAmountWP/text())[1]', 'varchar(50)') as Supp2TaxAmountWP ,
				sd.d.value('(LocalTaxAmountCP/text())[1]', 'varchar(50)') as LocalTaxAmountCP ,
				sd.d.value('(LaborSaleInternal/text())[1]', 'varchar(50)') as LaborSaleInternal ,
				sd.d.value('(ErrorMessage/text())[1]', 'varchar(50)') as ErrorMessage ,
				sd.d.value('(ROMiscSaleWP/text())[1]', 'varchar(50)') as ROMiscSaleWP ,
				sd.d.value('(ROSaleIP/text())[1]', 'varchar(50)') as ROSaleIP ,
				sd.d.value('(ComebackFlag/text())[1]', 'varchar(50)') as ComebackFlag ,
				sd.d.value('(DeliveryDate/text())[1]', 'varchar(50)') as DeliveryDate ,
				sd.d.value('(SourceFile/text())[1]', 'varchar(50)') as SourceFile ,
				sd.d.value('(Mileage/text())[1]', 'varchar(50)') as Mileage ,
				sd.d.value('(PartsCostWarranty/text())[1]', 'varchar(50)') as PartsCostWarranty ,
				sd.d.value('(PartsSaleCustomerPay/text())[1]', 'varchar(50)') as PartsSaleCustomerPay ,
				sd.d.value('(Model/text())[1]', 'varchar(50)') as Model ,
				sd.d.value('(HostItemID/text())[1]', 'varchar(50)') as HostItemID ,
				sd.d.value('(StateTaxAmountCP/text())[1]', 'varchar(50)') as StateTaxAmountCP ,
				sd.d.value('(Supp2TaxAmountCP/text())[1]', 'varchar(50)') as Supp2TaxAmountCP ,
				sd.d.value('(MileageLastVisit/text())[1]', 'varchar(50)') as MileageLastVisit ,
				sd.d.value('(MiscSale/text())[1]', 'varchar(50)') as MiscSale ,
				sd.d.value('(LaborSaleCustomerPay/text())[1]', 'varchar(50)') as LaborSaleCustomerPay ,
				sd.d.value('(PartsCostCustomerPay/text())[1]', 'varchar(50)') as PartsCostCustomerPay ,
				sd.d.value('(ErrorLevel/text())[1]', 'varchar(50)') as ErrorLevel ,
				sd.d.value('(MiscSaleCustomerPay/text())[1]', 'varchar(50)') as MiscSaleCustomerPay ,
				sd.d.value('(MiscSaleWarranty/text())[1]', 'varchar(50)') as MiscSaleWarranty ,
				sd.d.value('(Name1/text())[1]', 'varchar(50)') as Name1 ,
				sd.d.value('(OpenedTime/text())[1]', 'varchar(50)') as OpenedTime ,
				sd.d.value('(ROComment3/text())[1]', 'varchar(max)') as ROComment3 ,
				sd.d.value('(ROComment5/text())[1]', 'varchar(max)') as ROComment5 ,
				sd.d.value('(RONumber/text())[1]', 'varchar(50)') as RONumber ,
				sd.d.value('(ContactEmailAddress/text())[1]', 'varchar(50)') as ContactEmailAddress ,
				sd.d.value('(CashierNo/text())[1]', 'varchar(50)') as CashierNo ,
				sd.d.value('(CloseDate/text())[1]', 'varchar(50)') as CloseDate ,
				sd.d.value('(VehID/text())[1]', 'varchar(50)') as VehID ,
				sd.d.value('(ShopChargeSaleAmountCP/text())[1]', 'varchar(50)') as ShopChargeSaleAmountCP ,
				sd.d.value('(Supp4TaxAmountWP/text())[1]', 'varchar(50)') as Supp4TaxAmountWP ,
				sd.d.value('(Address/text())[1]', 'varchar(50)') as Address ,
				sd.d.value('(ApptIDs/text())[1]', 'varchar(50)') as ApptIDs ,
				sd.d.value('(PartsCostInternal/text())[1]', 'varchar(50)') as PartsCostInternal ,
				sd.d.value('(ActualHours/text())[1]', 'varchar(50)') as ActualHours ,
				sd.d.value('(MiscSaleInternal/text())[1]', 'varchar(50)') as MiscSaleInternal ,
				sd.d.value('(OriginalPromiseDate/text())[1]', 'varchar(50)') as OriginalPromiseDate ,
				sd.d.value('(OriginalWaiterFlag/text())[1]', 'varchar(50)') as OriginalWaiterFlag ,
				sd.d.value('(ROComment9/text())[1]', 'varchar(max)') as ROComment9 ,
				sd.d.value('(ROSaleWP/text())[1]', 'varchar(50)') as ROSaleWP ,
				sd.d.value('(ContactPhoneNumber/text())[1]', 'varchar(50)') as ContactPhoneNumber ,
				sd.d.value('(Service/text())[1]', 'varchar(50)') as Service ,
				sd.d.value('(ShopChargeSaleAmountIP/text())[1]', 'varchar(50)') as ShopChargeSaleAmountIP ,
				sd.d.value('(ShopChargeSaleAmountWP/text())[1]', 'varchar(50)') as ShopChargeSaleAmountWP ,
				sd.d.value('(SoldHours/text())[1]', 'varchar(50)') as SoldHours ,
				sd.d.value('(StateTaxAmountWP/text())[1]', 'varchar(50)') as StateTaxAmountWP ,
				sd.d.value('(Supp3TaxAmountWP/text())[1]', 'varchar(50)') as Supp3TaxAmountWP ,
				sd.d.value('(Supp4TaxAmountIP/text())[1]', 'varchar(50)') as Supp4TaxAmountIP ,
				sd.d.value('(Tag/text())[1]', 'varchar(50)') as Tag ,
				sd.d.value('(Make/text())[1]', 'varchar(50)') as Make ,
				sd.d.value('(LaborSale/text())[1]', 'varchar(50)') as LaborSale ,
				sd.d.value('(PartsSale/text())[1]', 'varchar(50)') as PartsSale ,
				sd.d.value('(Rental/text())[1]', 'varchar(50)') as Rental ,
				sd.d.value('(AccountingAccount/text())[1]', 'varchar(50)') as AccountingAccount ,
				sd.d.value('(OriginalPromiseTime/text())[1]', 'varchar(50)') as OriginalPromiseTime ,
				sd.d.value('(TransType/text())[1]', 'varchar(50)') as TransType ,
				sd.d.value('(PromisedDate/text())[1]', 'varchar(50)') as PromisedDate ,
				sd.d.value('(ROComment8/text())[1]', 'varchar(max)') as ROComment8 ,
				sd.d.value('(ROLubeSaleCP/text())[1]', 'varchar(50)') as ROLubeSaleCP ,
				sd.d.value('(ROLubeSaleIP/text())[1]', 'varchar(50)') as ROLubeSaleIP ,
				sd.d.value('(ROLubeSaleWP/text())[1]', 'varchar(50)') as ROLubeSaleWP ,
				sd.d.value('(ROMiscSaleCP/text())[1]', 'varchar(50)') as ROMiscSaleCP ,
				sd.d.value('(Year/text())[1]', 'varchar(50)') as Year ,
				sd.d.value('(SoldByDealer/text())[1]', 'varchar(50)') as SoldByDealer ,
				sd.d.value('(SpecialCust/text())[1]', 'varchar(50)') as SpecialCust ,
				sd.d.value('(Supp3TaxAmountCP/text())[1]', 'varchar(50)') as Supp3TaxAmountCP ,
				sd.d.value('(Supp3TaxAmountIP/text())[1]', 'varchar(50)') as Supp3TaxAmountIP ,
				sd.d.value('(MileageOut/text())[1]', 'varchar(50)') as MileageOut ,
				sd.d.value('(MiscCost/text())[1]', 'varchar(50)') as MiscCost ,
				sd.d.value('(PartsCost/text())[1]', 'varchar(50)') as PartsCost ,
				sd.d.value('(PartsSaleInternal/text())[1]', 'varchar(50)') as PartsSaleInternal ,
				sd.d.value('(PriorityFlag/text())[1]', 'varchar(50)') as PriorityFlag ,
				sd.d.value('(EstComplTime/text())[1]', 'varchar(50)') as EstCompletionTime ,
				sd.d.value('(ROSubletSaleWP/text())[1]', 'varchar(50)') as ROSubletSaleWP ,
				sd.d.value('(Remarks/text())[1]', 'varchar(50)') as Remarks,
				@file_process_id as file_process_id,
				@file_process_detail_id as file_process_detail_id,
				@cdk_dealer_code as cdk_dealer_code,
				@dealer_id as dealer_id

		into #temp
		from
		   @xml.nodes('/root/service-repair-order-history') AS sd(d) 



		insert into [etl].[cdk_servicero_header]
		( 
				
				 cdk_dealer_code
				,dealer_id
				,Address
				,ApptTime
				,CashierNo
				,CityStateZip
				,Color
				,DeliveryDate
				,ErrorLevel
				,LaborSale
				,LaborSaleCustomerPay
				,LaborSaleWarranty
				,MileageOut
				,MiscCost
				,OriginalPromiseDate
				,PartsCostWarranty
				,ROSubletSaleIP
				,Remarks
				,Rental
				,ShopChargeSaleAmountCP
				,ShopChargeSaleAmountIP
				,StateTaxAmountCP
				,StateTaxAmountWP
				,Supp2TaxAmountWP
				,Supp3TaxAmountWP
				,Supp4TaxAmountCP
				,Supp4TaxAmountWP
				,TransType
				,ActualHours
				,CloseDate
				,LaborCost
				,LocalTaxAmountWP
				,Model
				,PartsCostCustomerPay
				,PartsCostInternal
				,PriorityValue
				,ROComment8
				,ROLubeSaleCP
				,ROMiscSaleWP
				,Year
				,EstCompletionDate
				,LaborSaleInternal
				,MiscSale
				,MiscSaleInternal
				,OriginalWaiterFlag
				,PartsCost
				,PickItemID
				,ROComment5
				,ROSaleCP
				,ROSaleWP
				,ROStatusCode
				,ROSubletSaleWP
				,ServiceAdvisor
				,SoldByDealer
				,Supp3TaxAmountIP
				,VIN
				,VoidDate
				,BookedDate
				,Mileage
				,Name2
				,PartsSale
				,PartsSaleWarranty
				,PriorityFlag
				,PromisedDate
				,PromisedTime
				,ROComment1
				,ROComment2
				,ROComment6
				,RONumber
				,ROSubletSaleCP
				,WaiterFlag
				,ContactEmailAddress
				,HostItemID
				,MileageLastVisit
				,MiscSaleCustomerPay
				,PartsSaleCustomerPay
				,ROComment9
				,ROMiscSaleCP
				,SpecialCust
				,Supp2TaxAmountIP
				,Supp3TaxAmountCP
				,AccountingAccount
				,ContactPhoneNumber
				,ErrorMessage
				,LocalTaxAmountIP
				,Make
				,MiscSaleWarranty
				,OriginalPromiseTime
				,PostedDate
				,ROLubeSaleIP
				,ROStatusCodeDesc
				,StateTaxAmountIP
				,Supp2TaxAmountCP
				,Tag
				,ApptDate
				,ApptIDs
				,LocalTaxAmountCP
				,OpenDate
				,OpenedTime
				,ROComment3
				,ROComment4
				,ROLubeSaleWP
				,ROMiscSaleIP
				,ShopChargeSaleAmountWP
				,SoldHours--
				,VehID
				,ApptFlag
				,ComebackFlag
				,CustNo
				,EstCompletionTime
				,LastServiceDate
				,Name1
				,PartsSaleInternal
				,ROComment7
				,ROSaleIP
				,Service
				,SourceFile
				,Supp4TaxAmountIP
				,file_process_id
				,file_process_detail_id
			)
		select 
				 cdk_dealer_code
				,dealer_id
				,Address
				---,ApptTime
				,case when ApptTime ='24:00:00' then '00:00:00' else ApptTime end
				,CashierNo
				,CityStateZip
				,Color
				,DeliveryDate
				,ErrorLevel
				,LaborSale
				,LaborSaleCustomerPay
				,LaborSaleWarranty
				,convert(bigint,MileageOut)
				,MiscCost
				,OriginalPromiseDate
				,PartsCostWarranty
				,ROSubletSaleIP
				,Remarks
				,Rental
				,ShopChargeSaleAmountCP
				,ShopChargeSaleAmountIP
				,StateTaxAmountCP
				,StateTaxAmountWP
				,Supp2TaxAmountWP
				,Supp3TaxAmountWP
				,Supp4TaxAmountCP
				,Supp4TaxAmountWP
				,TransType
				,ActualHours
				,CloseDate
				,LaborCost
				,LocalTaxAmountWP
				,Model
				,PartsCostCustomerPay
				,PartsCostInternal
				,PriorityValue
				,ROComment8
				,ROLubeSaleCP
				,ROMiscSaleWP
				,convert(bigint,Year)
				,EstCompletionDate
				,LaborSaleInternal
				,MiscSale
				,MiscSaleInternal
				,OriginalWaiterFlag
				,PartsCost
				,'' as PickItemID
				,ROComment5
				,ROSaleCP
				,ROSaleWP
				,ROStatusCode
				,ROSubletSaleWP
				,ServiceAdvisor
				,SoldByDealer
				,Supp3TaxAmountIP
				,VIN
				,VoidDate
				,BookedDate
				,convert(bigint, Mileage)
				,Name2
				,PartsSale
				,PartsSaleWarranty
				,PriorityFlag
				,PromisedDate
				--,PromisedTime
				,case when PromisedTime ='24:00:00' then '00:00:00' else PromisedTime end
				,ROComment1
				,ROComment2
				,ROComment6
				,RONumber
				,ROSubletSaleCP
				,WaiterFlag
				,ContactEmailAddress
				,HostItemID
				,convert(bigint,MileageLastVisit)
				,MiscSaleCustomerPay
				,PartsSaleCustomerPay
				,ROComment9
				,ROMiscSaleCP
				,SpecialCust
				,Supp2TaxAmountIP
				,Supp3TaxAmountCP
				,AccountingAccount
				--,ContactPhoneNumber
				,case when ContactPhoneNumber ='S' then NULL else ContactPhoneNumber end 
				,ErrorMessage
				,LocalTaxAmountIP
				,Make
				,MiscSaleWarranty
				--,OriginalPromiseTime
				,case when OriginalPromiseTime ='24:00:00' then '00:00:00' else OriginalPromiseTime end
				,PostedDate
				,ROLubeSaleIP
				,ROStatusCodeDesc
				,StateTaxAmountIP
				,Supp2TaxAmountCP
				,Tag
				,ApptDate
				,ApptIDs
				,LocalTaxAmountCP
				,OpenDate
				--,OpenedTime
				,case when OpenedTime ='24:00:00' then '00:00:00' else OpenedTime end
				,ROComment3
				,ROComment4
				,ROLubeSaleWP
				,ROMiscSaleIP
				,ShopChargeSaleAmountWP
				,SoldHours
				,VehID
				,ApptFlag
				,ComebackFlag
				,CustNo
				--,EstCompletionTime
				,case when EstCompletionTime ='24:00:00' then '00:00:00' else EstCompletionTime end
				,LastServiceDate
				,Name1
				,PartsSaleInternal
				,ROComment7
				,ROSaleIP
				,Service
				,SourceFile
				,Supp4TaxAmountIP
				,file_process_id
				,file_process_detail_id
		from #temp 
		

		--set @rowcount = @@ROWCOUNT
	

		--update
		--	etl.file_xml 
		--set
		--	process_status = 'C'
		--where
		--	file_log_detail_id =@file_log_detail_id

	 --  update
		--	etl.file_log_details 
		--set
		--	process_status = 'C',
		--	file_type = 'cdk_srv_header',
		--	file_count = @rowcount,
		--	insert_count = @rowcount
		--where
		--	file_log_detail_id =@file_log_detail_id


			--drop table #temp

end

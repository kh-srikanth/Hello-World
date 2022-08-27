
use clictell_auto_etl
go
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2


Declare @xml xml
Declare @xml_main xml
select @xml_main = xml_text from etl.file_xml (nolock) where xml_id = 1--1011

if  cast(@xml_main as nvarchar(max) ) like '<ServiceSalesHistory xmlns="http://www.dmotorworks.com/pip-extract-service-sales-history">%'
			begin 
			print 'If -1' 
				select @xml  = cast( replace(replace(cast(@xml_main as nvarchar(max)) ,'<ServiceSalesHistory xmlns="http://www.dmotorworks.com/pip-extract-service-sales-history">','<root>'),'<ErrorCode>0</ErrorCode><ErrorMessage/></ServiceSalesHistory>','</root>') as xml)  
			end 
		else if  cast(@xml_main as nvarchar(max) ) like '<ServiceSalesHistory xmlns="http://www.dmotorworks.com/pip-extract-service-sales-history"><ErrorCode>0</ErrorCode><ErrorMessage/>%'
			begin
				print 'If ' 
				select @xml  = cast( replace(replace(cast(@xml_main as nvarchar(max)) ,'<ServiceSalesHistory xmlns="http://www.dmotorworks.com/pip-extract-service-sales-history"><ErrorCode>0</ErrorCode><ErrorMessage/>','<root>'),'</ServiceSalesHistory>','</root>') as xml)  
			end 
		else if cast(@xml_main as nvarchar(max) ) like '<ServiceRODetailHistory xmlns="http://www.dmotorworks.com/service-repair-order-history">%'
			begin
				print 'If 1' 
				select @xml  = cast( replace(replace(cast(@xml_main as nvarchar(max)) ,'<ServiceRODetailHistory xmlns="http://www.dmotorworks.com/service-repair-order-history">','<root>'),'</ServiceRODetailHistory>','</root>') as xml)  
			end 
		else if cast(@xml_main as nvarchar(max) ) like '<ServiceRODetailHistory>%'
			begin
				print 'If 1' 
				select @xml  = cast( replace(replace(cast(@xml_main as nvarchar(max)) ,'<ServiceRODetailHistory>','<root>'),'</ServiceRODetailHistory>','</root>') as xml)  
			end 
		else 
			begin 
				select 	@xml = 	 cast( replace(replace(cast(@xml_main as nvarchar(max))+'data>','<ServiceSalesClosed xmlns="http://www.dmotorworks.com/pip-extract-service-sales-closed">','<root>'),'</ServiceSalesClosed>data>','</root>') as xml)  
			print 'Else ' 
end 


select 
sd.d.value('(dedMaximumAmount/text())[1]', 'varchar(50)') as dedMaximumAmount
,sd.d.value('(feeLOPorPartSeqNo/text())[1]', 'varchar(50)') as feeLOPorPartSeqNo
,sd.d.value('(disSequenceNo/text())[1]', 'varchar(50)') as disSequenceNo
,sd.d.value('(dedLineCodes/text())[1]', 'varchar(50)') as dedLineCodes
,sd.d.value('(EmailAddress/text())[1]', 'varchar(50)') as EmailAddress
,sd.d.value('(lbrComebackSA/text())[1]', 'varchar(50)') as lbrComebackSA
,sd.d.value('(dedActualAmount/text())[1]', 'varchar(50)') as dedActualAmount
,sd.d.value('(payCPTotal/text())[1]', 'varchar(50)') as payCPTotal
,sd.d.value('(disLevel/text())[1]', 'varchar(50)') as disLevel
,sd.d.value('(prtMultivalueCount/text())[1]', 'varchar(50)') as prtMultivalueCount
,sd.d.value('(disClassOrType/text())[1]', 'varchar(50)') as disClassOrType
,sd.d.value('(disLopSeqNo/text())[1]', 'varchar(50)') as disLopSeqNo
,sd.d.value('(disOverrideAmount/text())[1]', 'varchar(50)') as disOverrideAmount
,sd.d.value('(disOverridePercent/text())[1]', 'varchar(50)') as disOverridePercent
,sd.d.value('(EmailDesc/text())[1]', 'varchar(50)') as EmailDesc
,sd.d.value('(EmailMultivalueCount/text())[1]', 'varchar(50)') as EmailMultivalueCount
,sd.d.value('(feeType/text())[1]', 'varchar(50)') as feeType
,sd.d.value('(LicenseNumber/text())[1]', 'varchar(50)') as LicenseNumber
,sd.d.value('(StatusDesc/text())[1]', 'varchar(50)') as StatusDesc
,sd.d.value('(disLineCode/text())[1]', 'varchar(50)') as disLineCode
,sd.d.value('(disOriginalDiscount/text())[1]', 'varchar(50)') as disOriginalDiscount
,sd.d.value('(lbrMultivalueCount/text())[1]', 'varchar(50)') as lbrMultivalueCount
,sd.d.value('(prtLineCode/text())[1]', 'varchar(50)') as prtLineCode
,sd.d.value('(totMultivalueCount/text())[1]', 'varchar(50)') as totMultivalueCount
,sd.d.value('(warFailedPartNo/text())[1]', 'varchar(50)') as warFailedPartNo
,sd.d.value('(warLaborSequenceNo/text())[1]', 'varchar(50)') as warLaborSequenceNo
,sd.d.value('(warLineCode/text())[1]', 'varchar(50)') as warLineCode
,sd.d.value('(dedLaborAmount/text())[1]', 'varchar(50)') as dedLaborAmount
,sd.d.value('(disAppliedBy/text())[1]', 'varchar(50)') as disAppliedBy
,sd.d.value('(disTotalDiscount/text())[1]', 'varchar(50)') as disTotalDiscount
,sd.d.value('(HasWarrPayFlag/text())[1]', 'varchar(50)') as HasWarrPayFlag
,sd.d.value('(hrsMultivalueCount/text())[1]', 'varchar(50)') as hrsMultivalueCount
,sd.d.value('(lbrForcedShopCharge/text())[1]', 'varchar(50)') as lbrForcedShopCharge
,sd.d.value('(LotLocation/text())[1]', 'varchar(50)') as LotLocation
,sd.d.value('(mlsSequenceNo/text())[1]', 'varchar(50)') as mlsSequenceNo
,sd.d.value('(PhoneExt/text())[1]', 'varchar(50)') as PhoneExt
,sd.d.value('(PhoneMultivalueCount/text())[1]', 'varchar(50)') as PhoneMultivalueCount
,sd.d.value('(prtSequenceNo/text())[1]', 'varchar(50)') as prtSequenceNo
,sd.d.value('(warClaimType/text())[1]', 'varchar(50)') as warClaimType
,sd.d.value('(dedPartsAmount/text())[1]', 'varchar(50)') as dedPartsAmount
,sd.d.value('(disLaborDiscount/text())[1]', 'varchar(50)') as disLaborDiscount
,sd.d.value('(BlockAutoMsg/text())[1]', 'varchar(50)') as BlockAutoMsg
,sd.d.value('(disOverrideTarget/text())[1]', 'varchar(50)') as disOverrideTarget
,sd.d.value('(disPartsDiscount/text())[1]', 'varchar(50)') as disPartsDiscount
,sd.d.value('(HasCustPayFlag/text())[1]', 'varchar(50)') as HasCustPayFlag
,sd.d.value('(mlsOpCode/text())[1]', 'varchar(50)') as mlsOpCode
,sd.d.value('(payMultivalueCount/text())[1]', 'varchar(50)') as payMultivalueCount
,sd.d.value('(warConditionCode/text())[1]', 'varchar(50)') as warConditionCode
,sd.d.value('(Zip/text())[1]', 'varchar(50)') as Zip
,sd.d.value('(dedSequenceNo/text())[1]', 'varchar(50)') as dedSequenceNo
,sd.d.value('(disDesc/text())[1]', 'varchar(50)') as disDesc
,sd.d.value('(feeSequenceNo/text())[1]', 'varchar(50)') as feeSequenceNo
,sd.d.value('(HasIntPayFlag/text())[1]', 'varchar(50)') as HasIntPayFlag
,sd.d.value('(linStorySequenceNo/text())[1]', 'varchar(50)') as linStorySequenceNo
,sd.d.value('(mlsType/text())[1]', 'varchar(50)') as mlsType
,sd.d.value('(linStoryEmployeeNo/text())[1]', 'varchar(50)') as linStoryEmployeeNo
,sd.d.value('(prtEmployeeNo/text())[1]', 'varchar(50)') as prtEmployeeNo
,sd.d.value('(Address/text())[1]', 'varchar(50)') as Address
,sd.d.value('(Cashier/text())[1]', 'varchar(50)') as Cashier
,sd.d.value('(ComebackFlag/text())[1]', 'varchar(50)') as ComebackFlag
,sd.d.value('(Name2/text())[1]', 'varchar(50)') as Name2
,sd.d.value('(RentalFlag/text())[1]', 'varchar(50)') as RentalFlag
,sd.d.value('(ServiceAdvisor/text())[1]', 'varchar(50)') as ServiceAdvisor
,sd.d.value('(feeLineCode/text())[1]', 'varchar(50)') as feeLineCode
,sd.d.value('(linStatusDesc/text())[1]', 'varchar(50)') as linStatusDesc
,sd.d.value('(prtCompLineCode/text())[1]', 'varchar(50)') as prtCompLineCode
,sd.d.value('(prtDesc/text())[1]', 'varchar(50)') as prtDesc
,sd.d.value('(prtQtyOrdered/text())[1]', 'varchar(50)') as prtQtyOrdered
,sd.d.value('(BookedDate/text())[1]', 'varchar(50)') as BookedDate
,sd.d.value('(CustNo/text())[1]', 'varchar(50)') as CustNo
,sd.d.value('(ErrorLevel/text())[1]', 'varchar(50)') as ErrorLevel
,sd.d.value('(PostedDate/text())[1]', 'varchar(50)') as PostedDate
,sd.d.value('(VoidedDate/text())[1]', 'varchar(50)') as VoidedDate
,sd.d.value('(prtBin1/text())[1]', 'varchar(50)') as prtBin1
,sd.d.value('(prtList/text())[1]', 'varchar(50)') as prtList
,sd.d.value('(prtUnitServiceCharge/text())[1]', 'varchar(50)') as prtUnitServiceCharge
,sd.d.value('(prtMcdPercentage/text())[1]', 'varchar(50)') as prtMcdPercentage
,sd.d.value('(ApptDate/text())[1]', 'varchar(50)') as ApptDate
,sd.d.value('(ApptTime/text())[1]', 'varchar(50)') as ApptTime
,sd.d.value('(EstComplDate/text())[1]', 'varchar(50)') as EstComplDate
,sd.d.value('(MileageLastVisit/text())[1]', 'varchar(50)') as MileageLastVisit
,sd.d.value('(PurchaseOrderNo/text())[1]', 'varchar(50)') as PurchaseOrderNo
,sd.d.value('(Remarks/text())[1]', 'varchar(50)') as Remarks
,sd.d.value('(Year/text())[1]', 'varchar(50)') as Year
,sd.d.value('(linCampaignCode/text())[1]', 'varchar(50)') as linCampaignCode
,sd.d.value('(warFailureCode/text())[1]', 'varchar(50)') as warFailureCode
,sd.d.value('(Model/text())[1]', 'varchar(50)') as Model
,sd.d.value('(Name1/text())[1]', 'varchar(50)') as Name1
,sd.d.value('(disDebitControlNo/text())[1]', 'varchar(50)') as disDebitControlNo
,sd.d.value('(disUserID/text())[1]', 'varchar(50)') as disUserID

,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/payPaymentAmount') AS sd(d) 
  ) as payPaymentAmount1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/payPaymentAmount') AS sd(d) 
 ) as payPaymentAmount2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/payPaymentAmount') AS sd(d) 
  ) as payPaymentAmount3

,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totSubletCost') AS sd(d) 
  ) as totSubletCost1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totSubletCost') AS sd(d) 
 ) as totSubletCost2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totSubletCost') AS sd(d) 
  ) as totSubletCost3

  ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/hrsTimeCardHours') AS sd(d) 
  ) as hrsTimeCardHours1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/hrsTimeCardHours') AS sd(d) 
 ) as hrsTimeCardHours2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/hrsTimeCardHours') AS sd(d) 
  ) as hrsTimeCardHours3

  ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/lbrFlagHours') AS sd(d) 
  ) as lbrFlagHours1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrFlagHours') AS sd(d) 
 ) as lbrFlagHours2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrFlagHours') AS sd(d) 
  ) as lbrFlagHours3

,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/lbrSoldHours') AS sd(d) 
  ) as lbrSoldHours1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrSoldHours') AS sd(d) 
 ) as lbrSoldHours2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrSoldHours') AS sd(d) 
  ) as lbrSoldHours3


,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totForcedShopCharge') AS sd(d) 
  ) as totForcedShopCharge1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totForcedShopCharge') AS sd(d) 
 ) as totForcedShopCharge2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totForcedShopCharge') AS sd(d) 
  ) as totForcedShopCharge3


,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totLaborDiscount') AS sd(d) 
  ) as totLaborDiscount1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totLaborDiscount') AS sd(d) 
 ) as totLaborDiscount2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totLaborDiscount') AS sd(d) 
  ) as totLaborDiscount3


,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totLaborSalePostDed') AS sd(d) 
  ) as totLaborSalePostDed1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totLaborSalePostDed') AS sd(d) 
 ) as totLaborSalePostDed2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totLaborSalePostDed') AS sd(d) 
  ) as totLaborSalePostDed3


,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totPartsDiscount') AS sd(d) 
  ) as totPartsDiscount1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totPartsDiscount') AS sd(d) 
 ) as totPartsDiscount2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totPartsDiscount') AS sd(d) 
  ) as totPartsDiscount3


,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totPartsSalePostDed') AS sd(d) 
  ) as totPartsSalePostDed1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totPartsSalePostDed') AS sd(d) 
 ) as totPartsSalePostDed2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totPartsSalePostDed') AS sd(d) 
  ) as totPartsSalePostDed3


,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totRoTax') AS sd(d) 
  ) as totRoTax1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totRoTax') AS sd(d) 
 ) as totRoTax2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totRoTax') AS sd(d) 
  ) as totRoTax3

  ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totShopChargeCost') AS sd(d) 
  ) as totShopChargeCost1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totShopChargeCost') AS sd(d) 
 ) as totShopChargeCost2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totShopChargeCost') AS sd(d) 
  ) as totShopChargeCost3


,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/hrsSequenceNo') AS sd(d) 
  ) as hrsSequenceNo1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/hrsSequenceNo') AS sd(d) 
 ) as hrsSequenceNo2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/hrsSequenceNo') AS sd(d) 
  ) as hrsSequenceNo3

  

,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/PhoneNumber') AS sd(d) 
  ) as PhoneNumber1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/PhoneNumber') AS sd(d) 
 ) as PhoneNumber2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/PhoneNumber') AS sd(d) 
  ) as PhoneNumber3

,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totOtherHours') AS sd(d) 
  ) as totOtherHours1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totOtherHours') AS sd(d) 
 ) as totOtherHours2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totOtherHours') AS sd(d) 
  ) as totOtherHours3

,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totRoSalePostDed') AS sd(d) 
  ) as totRoSalePostDed1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totRoSalePostDed') AS sd(d) 
 ) as totRoSalePostDed2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totRoSalePostDed') AS sd(d) 
  ) as totRoSalePostDed3

,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totTimeCardHours') AS sd(d) 
  ) as totTimeCardHours1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totTimeCardHours') AS sd(d) 
 ) as totTimeCardHours2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totTimeCardHours') AS sd(d) 
  ) as totTimeCardHours3

,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/punAlteredFlag') AS sd(d) 
  ) as punAlteredFlag1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/punAlteredFlag') AS sd(d) 
 ) as punAlteredFlag2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/punAlteredFlag') AS sd(d) 
  ) as punAlteredFlag3

,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totCoreSale') AS sd(d) 
  ) as totCoreSale1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totCoreSale') AS sd(d) 
 ) as totCoreSale2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totCoreSale') AS sd(d) 
  ) as totCoreSale3


,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totFlagHours') AS sd(d) 
  ) as totFlagHours1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totFlagHours') AS sd(d) 
 ) as totFlagHours2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totFlagHours') AS sd(d) 
  ) as totFlagHours3


,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totPartsCount') AS sd(d) 
  ) as totPartsCount1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totPartsCount') AS sd(d) 
 ) as totPartsCount2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totPartsCount') AS sd(d) 
  ) as totPartsCount3


  ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/lbrOtherHours') AS sd(d) 
  ) as lbrOtherHours1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrOtherHours') AS sd(d) 
 ) as lbrOtherHours2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrOtherHours') AS sd(d) 
  ) as lbrOtherHours3


 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/linAddOnFlag') AS sd(d) 
  ) as linAddOnFlag1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/linAddOnFlag') AS sd(d) 
 ) as linAddOnFlag2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/linAddOnFlag') AS sd(d) 
  ) as linAddOnFlag3

,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totCoreCost') AS sd(d) 
  ) as totCoreCost1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totCoreCost') AS sd(d) 
 ) as totCoreCost2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totCoreCost') AS sd(d) 
  ) as totCoreCost3

,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totMiscCount') AS sd(d) 
  ) as totMiscCount1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totMiscCount') AS sd(d) 
 ) as totMiscCount2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totMiscCount') AS sd(d) 
  ) as totMiscCount3


 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totPayType') AS sd(d) 
  ) as totPayType1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totPayType') AS sd(d) 
 ) as totPayType2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totPayType') AS sd(d) 
  ) as totPayType3

,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/hrsMcdPercentage') AS sd(d) 
  ) as hrsMcdPercentage1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/hrsMcdPercentage') AS sd(d) 
 ) as hrsMcdPercentage2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/hrsMcdPercentage') AS sd(d) 
  ) as hrsMcdPercentage3


 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/lbrLineCode') AS sd(d) 
  ) as lbrLineCode1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrLineCode') AS sd(d) 
 ) as lbrLineCode2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrLineCode') AS sd(d) 
  ) as lbrLineCode3

 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totPartsCost') AS sd(d) 
  ) as totPartsCost1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totPartsCost') AS sd(d) 
 ) as totPartsCost2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totPartsCost') AS sd(d) 
  ) as totPartsCost3


,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totSupp4Tax') AS sd(d) 
  ) as totSupp4Tax1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totSupp4Tax') AS sd(d) 
 ) as totSupp4Tax2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totSupp4Tax') AS sd(d) 
  ) as totSupp4Tax3


,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/lbrTechNo') AS sd(d) 
  ) as lbrTechNo1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrTechNo') AS sd(d) 
 ) as lbrTechNo2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrTechNo') AS sd(d) 
  ) as lbrTechNo3

,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/hrsTechNo') AS sd(d) 
  ) as hrsTechNo1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/hrsTechNo') AS sd(d) 
 ) as hrsTechNo2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/hrsTechNo') AS sd(d) 
  ) as hrsTechNo3

 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totPartsSale') AS sd(d) 
  ) as totPartsSale1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totPartsSale') AS sd(d) 
 ) as totPartsSale2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totPartsSale') AS sd(d) 
  ) as totPartsSale3

,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/linCause') AS sd(d) 
  ) as linCause1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/linCause') AS sd(d) 
 ) as linCause2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/linCause') AS sd(d) 
  ) as linCause3

 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totMiscSale') AS sd(d) 
  ) as totMiscSale1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totMiscSale') AS sd(d) 
 ) as totMiscSale2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totMiscSale') AS sd(d) 
  ) as totMiscSale3


 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/hrsOtherHours') AS sd(d) 
  ) as hrsOtherHours1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/hrsOtherHours') AS sd(d) 
 ) as hrsOtherHours2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/hrsOtherHours') AS sd(d) 
  ) as hrsOtherHours3

 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/hrsSale') AS sd(d) 
  ) as hrsSale1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/hrsSale') AS sd(d) 
 ) as hrsSale2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/hrsSale') AS sd(d) 
  ) as hrsSale3

,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/lbrOpCode') AS sd(d) 
  ) as lbrOpCode1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrOpCode') AS sd(d) 
 ) as lbrOpCode2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrOpCode') AS sd(d) 
  ) as lbrOpCode3


       ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/linServiceRequest') AS sd(d) 
  ) as linServiceRequest1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/linServiceRequest') AS sd(d) 
 ) as linServiceRequest2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/linServiceRequest') AS sd(d) 
  ) as linServiceRequest3

 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/lbrOpCodeDesc') AS sd(d) 
  ) as lbrOpCodeDesc1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrOpCodeDesc') AS sd(d) 
 ) as lbrOpCodeDesc2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrOpCodeDesc') AS sd(d) 
  ) as lbrOpCodeDesc3

 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/lbrTimeCardHours') AS sd(d) 
  ) as lbrTimeCardHours1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrTimeCardHours') AS sd(d) 
 ) as lbrTimeCardHours2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrTimeCardHours') AS sd(d) 
  ) as lbrTimeCardHours3

 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/linDispatchCode') AS sd(d) 
  ) as linDispatchCode1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/linDispatchCode') AS sd(d) 
 ) as linDispatchCode2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/linDispatchCode') AS sd(d) 
  ) as linDispatchCode3

 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totLaborSale') AS sd(d) 
  ) as totLaborSale1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totLaborSale') AS sd(d) 
 ) as totLaborSale2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totLaborSale') AS sd(d) 
  ) as totLaborSale3

 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totLocalTax') AS sd(d) 
  ) as totLocalTax1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totLocalTax') AS sd(d) 
 ) as totLocalTax2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totLocalTax') AS sd(d) 
  ) as totLocalTax3

 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/linComplaintCode') AS sd(d) 
  ) as linComplaintCode1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/linComplaintCode') AS sd(d) 
 ) as linComplaintCode2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/linComplaintCode') AS sd(d) 
  ) as linComplaintCode3


 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/payInsuranceFlag') AS sd(d) 
  ) as payInsuranceFlag1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/payInsuranceFlag') AS sd(d) 
 ) as payInsuranceFlag2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/payInsuranceFlag') AS sd(d) 
  ) as payInsuranceFlag3


 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/totLaborCost') AS sd(d) 
  ) as totLaborCost1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totLaborCost') AS sd(d) 
 ) as totLaborCost2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/totLaborCost') AS sd(d) 
  ) as totLaborCost3


   ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/hrsLaborType') AS sd(d) 
  ) as hrsLaborType1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/hrsLaborType') AS sd(d) 
 ) as hrsLaborType2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/hrsLaborType') AS sd(d) 
  ) as hrsLaborType3

 ,( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks 
	from @xml.nodes('/root/service-repair-order-history/lbrMcdPercentage') AS sd(d) 
  ) as lbrMcdPercentage1
,( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrMcdPercentage') AS sd(d) 
 ) as lbrMcdPercentage2
,( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
	from @xml.nodes('/root/service-repair-order-history/lbrMcdPercentage') AS sd(d) 
  ) as lbrMcdPercentage3

  
,sd.d.value('(RONumber/text())[1]', 'varchar(50)') as RONumber1
,sd.d.value('(ClosedDate/text())[1]', 'varchar(50)') as ClosedDate1
,sd.d.value('(OpenDate/text())[1]', 'varchar(50)') as OpenDate1
into #temp1
from
@xml.nodes('/root/service-repair-order-history') AS sd(d) 
-------------------------------------------------------------------------------------------------------------------------------------
select 

sd.d.value('(linStatusCode/text())[1]', 'varchar(50)') as linStatusCode,	       
sd.d.value('(prtCoreSale/text())[1]', 'varchar(50)') as prtCoreSale,
sd.d.value('(prtLaborType/text())[1]', 'varchar(50)') as prtLaborType,
sd.d.value('(prtOutsideSalesmanNo/text())[1]', 'varchar(50)') as prtOutsideSalesmanNo, 
sd.d.value('(prtSource/text())[1]', 'varchar(50)') as prtSource,
		   
( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsHourType') AS sd(d) 
) as hrsHourType1,

( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsHourType') AS sd(d) 
) as hrsHourType2,

( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsHourType') AS sd(d) 
) as hrsHourType3,

sd.d.value('(ApptFlag/text())[1]', 'varchar(50)') as ApptFlag, 
sd.d.value('(CityStateZip/text())[1]', 'varchar(50)') as CityStateZip, 
sd.d.value('(ContactEmailAddress/text())[1]', 'varchar(50)') as ContactEmailAddress,
sd.d.value('(ErrorMessage/text())[1]', 'varchar(50)') as ErrorMessage, 
sd.d.value('(LastServiceDate/text())[1]', 'varchar(50)') as LastServiceDate, 
sd.d.value('(Make/text())[1]', 'varchar(50)') as Make, 
sd.d.value('(MakeDesc/text())[1]', 'varchar(50)') as MakeDesc, 
sd.d.value('(MileageOut/text())[1]', 'varchar(50)') as MileageOut,
sd.d.value('(OrigWaiterFlag/text())[1]', 'varchar(50)') as OrigWaiterFlag, 
sd.d.value('(RONumber/text())[1]', 'varchar(50)') as RONumber, 
sd.d.value('(VehID/text())[1]', 'varchar(50)') as VehID, 
sd.d.value('(WaiterFlag/text())[1]', 'varchar(50)') as WaiterFlag, 
sd.d.value('(disDebitTargetCo/text())[1]', 'varchar(50)') as disDebitTargetCo, 
sd.d.value('(feeOpCodeDesc/text())[1]', 'varchar(50)') as feeOpCodeDesc,

		   
( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsPercentage') AS sd(d) 
) as hrsPercentage1,

( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsPercentage') AS sd(d) 
) as hrsPercentage2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsPercentage') AS sd(d) 
) as hrsPercentage3,

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/linComebackFlag') AS sd(d) 
) as linComebackFlag1,

( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/linComebackFlag') AS sd(d) 
) as linComebackFlag2,

( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/linComebackFlag') AS sd(d) 
) as linComebackFlag3,

	
( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/linLineCode') AS sd(d) 
) as linLineCode1,

( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/linLineCode') AS sd(d) 
) as linLineCode2,

( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/linLineCode') AS sd(d) 
) as linLineCode3,

sd.d.value('(prtCoreCost/text())[1]', 'varchar(50)') as prtCoreCost ,
sd.d.value('(prtQtySold/text())[1]', 'varchar(50)') as prtQtySold, 
sd.d.value('(prtSpecialStatus/text())[1]', 'varchar(50)') as prtSpecialStatus, 

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totLubeSale') AS sd(d) 
) as totLubeSale1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totLubeSale') AS sd(d) 
) as totLubeSale2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totLubeSale') AS sd(d) 
) as totLubeSale3,

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totRoSale') AS sd(d) 
) as totRoSale1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totRoSale') AS sd(d) 
) as totRoSale2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totRoSale') AS sd(d) 
) as totRoSale3,

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totSoldHours') AS sd(d) 
) as totSoldHours1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totSoldHours') AS sd(d) 
) as totSoldHours2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totSoldHours') AS sd(d) 
) as totSoldHours3,

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totSubletSale') AS sd(d) 
) as totSubletSale1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totSubletSale') AS sd(d) 
) as totSubletSale2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totSubletSale') AS sd(d) 
) as totSubletSale3,

sd.d.value('(ClosedDate/text())[1]', 'varchar(50)') as ClosedDate,
sd.d.value('(EstComplTime/text())[1]', 'varchar(50)') as EstComplTime,
sd.d.value('(PriorityValue/text())[1]', 'varchar(50)') as PriorityValue, 
sd.d.value('(PromisedTime/text())[1]', 'varchar(50)') as PromisedTime, 
sd.d.value('(VIN/text())[1]', 'varchar(50)') as VIN,
sd.d.value('(feeCost/text())[1]', 'varchar(50)') as feeCost ,
sd.d.value('(feeFeeID/text())[1]', 'varchar(50)') as feeFeeID, 
sd.d.value('(feeOpCode/text())[1]', 'varchar(50)') as feeOpCode,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsSoldHours') AS sd(d) 
) as hrsSoldHours1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsSoldHours') AS sd(d) 
) as hrsSoldHours2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsSoldHours') AS sd(d) 
) as hrsSoldHours3,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrCost') AS sd(d) 
) as lbrCost1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrCost') AS sd(d) 
) as lbrCost2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrCost') AS sd(d) 
) as lbrCost3,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrLaborType') AS sd(d) 
) as lbrLaborType1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrLaborType') AS sd(d) 
) as lbrLaborType2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrLaborType') AS sd(d) 
) as lbrLaborType3,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrSequenceNo') AS sd(d) 
) as lbrSequenceNo1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrSequenceNo') AS sd(d) 
) as lbrSequenceNo2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrSequenceNo') AS sd(d) 
) as lbrSequenceNo3,

sd.d.value('(prtComp/text())[1]', 'varchar(50)') as prtComp,
sd.d.value('(prtCost/text())[1]', 'varchar(50)') as prtCost, 
sd.d.value('(prtPartNo/text())[1]', 'varchar(50)') as prtPartNo, 
sd.d.value('(prtSale/text())[1]', 'varchar(50)') as prtSale,
sd.d.value('(rapApptID/text())[1]', 'varchar(50)') as rapApptID,

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totShopChargeSale') AS sd(d) 
) as totShopChargeSale1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totShopChargeSale') AS sd(d) 
) as totShopChargeSale2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totShopChargeSale') AS sd(d) 
) as totShopChargeSale3,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totSupp2Tax') AS sd(d) 
) as totSupp2Tax1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totSupp2Tax') AS sd(d) 
) as totSupp2Tax2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totSupp2Tax') AS sd(d) 
) as totSupp2Tax3,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totSupp3Tax') AS sd(d) 
) as totSupp3Tax1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totSupp3Tax') AS sd(d) 
) as totSupp3Tax,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totSupp3Tax') AS sd(d) 
) as totSupp3Tax3,

sd.d.value('(AddOnFlag/text())[1]', 'varchar(50)') as AddOnFlag,
sd.d.value('(Comments/text())[1]', 'varchar(50)') as Comments, 
sd.d.value('(ContactPhoneNumber/text())[1]', 'varchar(50)') as ContactPhoneNumber, 
sd.d.value('(DeliveryDate/text())[1]', 'varchar(50)') as DeliveryDate,
sd.d.value('(HostItemID/text())[1]', 'varchar(50)') as HostItemID, 
sd.d.value('(Mileage/text())[1]', 'varchar(50)') as Mileage, 
sd.d.value('(OrigPromisedTime/text())[1]', 'varchar(50)') as OrigPromisedTime, 
sd.d.value('(SoldByDealerFlag/text())[1]', 'varchar(50)') as SoldByDealerFlag ,
sd.d.value('(feeLaborType/text())[1]', 'varchar(50)') as feeLaborType, 

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrSale') AS sd(d) 
) as lbrSale1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrSale') AS sd(d) 
) as lbrSale2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrSale') AS sd(d) 
) as lbrSale3,

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/linEstDuration') AS sd(d) 
) as linEstDuration1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/linEstDuration') AS sd(d) 
) as linEstDuration,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/linEstDuration') AS sd(d) 
) as linEstDuration3,

sd.d.value('(prtClass/text())[1]', 'varchar(50)') as prtClass,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totMiscCost') AS sd(d) 
) as totMiscCost1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totMiscCost') AS sd(d) 
) as totMiscCost2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totMiscCost') AS sd(d) 
) as totMiscCost3,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totStateTax') AS sd(d) 
) as totStateTax1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totStateTax') AS sd(d) 
) as totStateTax2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totStateTax') AS sd(d) 
) as totStateTax3,

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsCost') AS sd(d) 
) as hrsCost1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsCost') AS sd(d) 
) as hrsCost2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsCost') AS sd(d) 
) as hrsCost3,

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsLineCode') AS sd(d) 
) as hrsLineCode1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsLineCode') AS sd(d) 
) as hrsLineCode2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsLineCode') AS sd(d) 
) as hrsLineCode3,

sd.d.value('(BookerNo/text())[1]', 'varchar(50)') as BookerNo, 
sd.d.value('(OpenDate/text())[1]', 'varchar(50)') as OpenDate,
sd.d.value('(OrigPromisedDate/text())[1]', 'varchar(50)') as OrigPromisedDate,
sd.d.value('(PromisedDate/text())[1]', 'varchar(50)') as PromisedDate, 
sd.d.value('(SpecialCustFlag/text())[1]', 'varchar(50)') as SpecialCustFlag, 
sd.d.value('(TagNo/text())[1]', 'varchar(50)') as TagNo, 
sd.d.value('(VehicleColor/text())[1]', 'varchar(50)') as VehicleColor ,
sd.d.value('(disDebitAccountNo/text())[1]', 'varchar(50)') as disDebitAccountNo,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsActualHours') AS sd(d) 
) as hrsActualHours1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsActualHours') AS sd(d) 
) as hrsActualHours2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsActualHours') AS sd(d) 
) as hrsActualHours3,

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punTechNo') AS sd(d) 
) as punTechNo1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punTechNo') AS sd(d) 
) as punTechNo2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punTechNo') AS sd(d) 
) as punTechNo3,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punWorkDate') AS sd(d) 
) as punWorkDate1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punWorkDate') AS sd(d) 
) as punWorkDate2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punWorkDate') AS sd(d) 
) as punWorkDate3,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punWorkType') AS sd(d) 
) as punWorkType1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punWorkType') AS sd(d) 
) as punWorkType2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punWorkType') AS sd(d) 
) as punWorkType3,



( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punDuration') AS sd(d) 
) as punDuration1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punDuration') AS sd(d) 
) as punDuration2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punDuration') AS sd(d) 
) as punDuration3,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punTimeOn') AS sd(d) 
) as punTimeOn1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punTimeOn') AS sd(d) 
) as punTimeOn2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punTimeOn') AS sd(d) 
) as punTimeOn3,

sd.d.value('(punMultivalueCount/text())[1]', 'varchar(50)') as punMultivalueCount,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punLineCode') AS sd(d) 
) as punLineCode1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punLineCode') AS sd(d) 
) as punLineCode2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punLineCode') AS sd(d) 
) as punLineCode3,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punTimeOff') AS sd(d) 
) as punTimeOff1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punTimeOff') AS sd(d) 
) as punTimeOff2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/punTimeOff') AS sd(d) 
) as punTimeOff3,

sd.d.value('(mlsMultivalueCount/text())[1]', 'varchar(50)') as mlsMultivalueCount,
sd.d.value('(mlsSale/text())[1]', 'varchar(50)') as mlsSale,

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/payPaymentCode') AS sd(d) 
) as payPaymentCode1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/payPaymentCode') AS sd(d) 
) as payPaymentCode2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/payPaymentCode') AS sd(d) 
) as payPaymentCode3,


sd.d.value('(dedMultivalueCount/text())[1]', 'varchar(50)') as dedMultivalueCount,
sd.d.value('(lbrOperationType/text())[1]', 'varchar(50)') as lbrOperationType,

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/linBookerNo') AS sd(d) 
) as linBookerNo1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/linBookerNo') AS sd(d) 
) as linBookerNo2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/linBookerNo') AS sd(d) 
) as linBookerNo3,

sd.d.value('(mlsCost/text())[1]', 'varchar(50)') as mlsCost,
sd.d.value('(payPaymentsMade/text())[1]', 'varchar(50)') as payPaymentsMade,
sd.d.value('(StatusCode/text())[1]', 'varchar(50)') as StatusCode,
sd.d.value('(warAuthorizationCode/text())[1]', 'varchar(50)') as warAuthorizationCode,
sd.d.value('(disOverrideGPPercent/text())[1]', 'varchar(50)') as disOverrideGPPercent,
sd.d.value('(prtExtendedCost/text())[1]', 'varchar(50)') as prtExtendedCost,
	

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totLubeCost') AS sd(d) 
) as totLubeCost1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totLubeCost') AS sd(d) 
) as totLubeCost2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totLubeCost') AS sd(d) 
) as totLubeCost3,


sd.d.value('(warFailedPartsCount/text())[1]', 'varchar(50)') as warFailedPartsCount,
sd.d.value('(lbrComebackTech/text())[1]', 'varchar(50)') as lbrComebackTech,
sd.d.value('(disDiscountID/text())[1]', 'varchar(50)') as disDiscountID,



( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrComebackFlag') AS sd(d) 
) as lbrComebackFlag1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrComebackFlag') AS sd(d) 
) as lbrComebackFlag2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrComebackFlag') AS sd(d) 
) as lbrComebackFlag3,

sd.d.value('(disManagerOverride/text())[1]', 'varchar(50)') as disManagerOverride,
sd.d.value('(linMultivalueCount/text())[1]', 'varchar(50)') as linMultivalueCount,
sd.d.value('(OpenTime/text())[1]', 'varchar(50)') as OpenTime,
sd.d.value('(rapMultivalueCount/text())[1]', 'varchar(50)') as rapMultivalueCount,

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totLaborCount') AS sd(d) 
) as totLaborCount1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totLaborCount') AS sd(d) 
) as totLaborCount2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totLaborCount') AS sd(d) 
) as totLaborCount3,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totRoCost') AS sd(d) 
) as totRoCost1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totRoCost') AS sd(d) 
) as totRoCost2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totRoCost') AS sd(d) 
) as totRoCost3,


sd.d.value('(warMultivalueCount/text())[1]', 'varchar(50)') as warMultivalueCount, 
sd.d.value('(disOverrideGPAmount/text())[1]', 'varchar(50)') as disOverrideGPAmount, 
sd.d.value('(feeMultivalueCount/text())[1]', 'varchar(50)') as feeMultivalueCount, 
sd.d.value('(feeSale/text())[1]', 'varchar(50)') as feeSale ,
sd.d.value('(linStoryText/text())[1]', 'varchar(50)') as linStoryText, 
sd.d.value('(mlsLaborType/text())[1]', 'varchar(50)') as mlsLaborType ,
sd.d.value('(mlsMcdPercentage/text())[1]', 'varchar(50)') as mlsMcdPercentage, 
sd.d.value('(mlsOpCodeDesc/text())[1]', 'varchar(50)') as mlsOpCodeDesc ,
sd.d.value('(prtExtendedSale/text())[1]', 'varchar(50)') as prtExtendedSale,

( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totLubeCount') AS sd(d) 
) as totLubeCount1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totLubeCount') AS sd(d) 
) as totLubeCount2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totLubeCount') AS sd(d) 
) as totLubeCount3,

sd.d.value('(disMultivalueCount/text())[1]', 'varchar(50)') as disMultivalueCount,
sd.d.value('(feeLOPorPartFlag/text())[1]', 'varchar(50)') as feeLOPorPartFlag,
sd.d.value('(feeMcdPercentage/text())[1]', 'varchar(50)') as feeMcdPercentage,



( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsFlagHours') AS sd(d) 
) as hrsFlagHours1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsFlagHours') AS sd(d) 
) as hrsFlagHours2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/hrsFlagHours') AS sd(d) 
) as hrsFlagHours3,


	
( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrActualHours') AS sd(d) 
) as lbrActualHours1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrActualHours') AS sd(d) 
) as lbrActualHours2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/lbrActualHours') AS sd(d) 
) as lbrActualHours3,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/linActualWork') AS sd(d) 
) as linActualWork1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/linActualWork') AS sd(d) 
) as linActualWork2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/linActualWork') AS sd(d) 
) as linActualWork3,
		
		   
sd.d.value('(mlsLineCode/text())[1]', 'varchar(50)') as mlsLineCode,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/PhoneDesc') AS sd(d) 
) as PhoneDesc1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/PhoneDesc') AS sd(d) 
) as PhoneDesc2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/PhoneDesc') AS sd(d) 
) as PhoneDesc3,

sd.d.value('(prtLaborSequenceNo/text())[1]', 'varchar(50)') as prtLaborSequenceNo,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totActualHours') AS sd(d) 
) as totActualHours1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totActualHours') AS sd(d) 
) as totActualHours2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totActualHours') AS sd(d) 
) as totActualHours3,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totDiscount') AS sd(d) 
) as totDiscount1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totDiscount') AS sd(d) 
) as totDiscount2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totDiscount') AS sd(d) 
) as totDiscount3,


( select sd.d.value('(V/text())[1]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totSubletCount') AS sd(d) 
) as totSubletCount1,
( select sd.d.value('(V/text())[2]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totSubletCount') AS sd(d) 
) as totSubletCount2,
( select sd.d.value('(V/text())[3]', 'varchar(50)') as Remarks
from
@xml.nodes('/root/service-repair-order-history/totSubletCount') AS sd(d) 
) as totSubletCount3,



sd.d.value('(BookedTime/text())[1]', 'varchar(50)') as BookedTime,
sd.d.value('(dedLaborType/text())[1]', 'varchar(50)') as dedLaborType,
sd.d.value('(prtQtyOnHand/text())[1]', 'varchar(50)') as prtQtyOnHand,
sd.d.value('(prtQtyFilled/text())[1]', 'varchar(50)') as prtQtyFilled,
sd.d.value('(prtQtyBackordered/text())[1]', 'varchar(50)') as prtQtyBackordered

into #temp2

from
@xml.nodes('/root/service-repair-order-history') AS sd(d) 


select t1.*,t2.*
into #temp
from #temp1 t1 inner join #temp2 t2 on t1.RONumber1 = t2.RONumber and t1.ClosedDate1 = t2.ClosedDate and t1.OpenDate1 = t2.OpenDate


alter table #temp drop column RONumber1, ClosedDate1, OpenDate1 
select * from #temp
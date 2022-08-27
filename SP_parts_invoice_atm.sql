USE clictell_auto_etl
GO
IF OBJECT_ID('tempdb..#temp_parts_invoice_Json') IS NOT NULL DROP TABLE #temp_parts_invoice_Json
Create table #temp_parts_invoice_Json 
(
	[Key_id] int,
	[Key] varchar(100),
	[value] varchar(max),
	[type] int
)
IF OBJECT_ID('tempdb..#parts_invoice_JsonValues') IS NOT NULL DROP TABLE #parts_invoice_JsonValues
create table #parts_invoice_JsonValues
(
	id int identity(1,1) Primary key
	,[Key_id] int
	,documentId varchar(150)
	,documentDateTime datetime
	,dealerOrderNumber varchar(150)
	,invoiceDate date
	,shipmentNumber varchar(150)
	,shipDate date
	,shipmentMethod varchar(100)
	,deliveryDate date
	,totalPartPiecesNumeric int
	,invoiceState varchar(150)
	,invoiceTypeDescription varchar(150)
	,invoiceType varchar(150)
	,invoiceNumber varchar(50)
	,notes varchar(max)
	,cashieredIndicator varchar(5)
	,willCall  varchar(10)
	,partsInvoiceParties varchar(max)
	,pricing varchar(max)
	,tax varchar(max)
	,partsInvoiceLine varchar(max)
	,partsProductItem varchar(max)

)
Declare @partsJson NVARCHAR(max) 
--Declare @path nvarchar(250) = '\\192.168.0.108\etl_source\Automate\GetPartsInvoice_1.txt'
Declare @path nvarchar(250) = 'D:\etl\etl_process\Automate\ATM0001_GetPartsInvoice_1.txt'
Declare @sql nvarchar(1000)
Declare @key varchar(max)
Declare @value nvarchar(max)


set @sql = 'SELECT @partsJson = Cast(BulkColumn as nvarchar(max)) FROM OPENROWSET (BULK ''' + @path + ''', SINGLE_CLOB) as import'
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
EXEC sp_executesql @sql,N'@partsJson NVARCHAR(max) output',@partsJson output;
select *, 0 as is_processed into #temp from OpenJson(@partsJson)

--select * from #temp
While ((select count(*) from #temp where is_processed = 0) >0)

begin

	select top 1 @key = [key], @value = [value] from #temp where is_processed = 0
	insert into #temp_parts_invoice_Json
	select @key, * from OpenJson(@value)
	Insert into #parts_invoice_JsonValues 
	(
			[Key_id] 
			,documentId
			,documentDateTime
			,dealerOrderNumber
			,invoiceDate 
			,shipmentNumber
			,shipDate
			,shipmentMethod
			,deliveryDate 
			,totalPartPiecesNumeric 
			,invoiceState 
			,invoiceTypeDescription 
			,invoiceType 
			,invoiceNumber 
			,notes 
			,cashieredIndicator 
			,willCall  
			,partsInvoiceParties 
			,pricing 
			,tax 
			,partsInvoiceLine 
			,partsProductItem 
	)
	select @key, *	from OpenJson(@value)
	with
	(
			documentId varchar(150) '$.documentId'
			,documentDateTime datetime '$.documentDateTime'
			,dealerOrderNumber varchar(150) '$.dealerOrderNumber'
			,invoiceDate date '$.invoiceDate' 
			,shipmentNumber varchar(150) '$.shipmentNumber'
			,shipDate date '$.shipDate'
			,shipmentMethod varchar(100) '$.shipmentMethod'
			,deliveryDate date '$.deliveryDate'
			,totalPartPiecesNumeric int '$.totalPartPiecesNumeric'
			,invoiceState varchar(150) '$.invoiceState'
			,invoiceTypeDescription varchar(150) '$.invoiceTypeDescription'
			,invoiceType varchar(150) '$.invoiceType'
			,invoiceNumber varchar(50) '$.invoiceNumber'
			,notes varchar(max) '$.notes'
			,cashieredIndicator varchar(5) '$.cashieredIndicator'
			,willCall  varchar(10) '$.willCall'
			,partsInvoiceParties varchar(max) '$.partsInvoiceParties'
			,pricing varchar(max) '$.pricing'
			,tax varchar(max) '$.tax'
			,partsInvoiceLine varchar(max) '$.partsInvoiceLine'
			,partsProductItem varchar(max) '$.partsProductItem'
	)
		
			Update a set notes = replace(replace(b.value,'[',''),']','')
			from #parts_invoice_JsonValues a
			inner join #temp_parts_invoice_Json b on a.[Key_id] = b.[Key_id]
			where a.[Key_id] = @key and [Key] = 'notes'

			Update a set partsInvoiceParties = b.value
			from #parts_invoice_JsonValues a
			inner join #temp_parts_invoice_Json b on a.[Key_id] = b.[Key_id]
			where a.[Key_id] = @key and [Key] = 'partsInvoiceParties'

			Update a set pricing = b.value
			from #parts_invoice_JsonValues a
			inner join #temp_parts_invoice_Json b on a.[Key_id] = b.[Key_id]
			where a.[Key_id] = @key and [Key] = 'pricing'

			Update a set tax = b.value
			from #parts_invoice_JsonValues a
			inner join #temp_parts_invoice_Json b on a.[Key_id] = b.[Key_id]
			where a.[Key_id] = @key and [Key] = 'tax'

			Update a set partsInvoiceLine = b.value
			from #parts_invoice_JsonValues a
			inner join #temp_parts_invoice_Json b on a.[Key_id] = b.[Key_id]
			where a.[Key_id] = @key and [Key] = 'partsInvoiceLine'

			Update a set partsProductItem = b.value
			from #parts_invoice_JsonValues a
			inner join #temp_parts_invoice_Json b on a.[Key_id] = b.[Key_id]
			where a.[Key_id] = @key and [Key] = 'partsProductItem'


			Update #temp set is_processed = 1 where [Key] = @key
end
--select * from #parts_invoice_JsonValues

IF OBJECT_ID('tempdb..#temp10') IS NOT NULL DROP TABLE #temp10
select a.ID, a.[Key_id], a.[key] as [Key1],a.invoiceNumber, b.* into #temp10
from 
(
select a.ID, a.[Key_id], a.invoiceNumber, b.*

from #parts_invoice_JsonValues a
CROSS APPLY OPENJSON(partsInvoiceParties) as b
) as a
CROSS APPLY OPENJSON([value]) as b

--select * from #temp10 order by invoicenumber

IF OBJECT_ID('tempdb..#parts_invoice_parties') IS NOT NULL DROP TABLE #parts_invoice_parties
select distinct  id, [Key_id], [Key1] ,invoiceNumber
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'customerTypeCode') as customerTypeCode
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'givenName') as givenName
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'middleName') as middleName
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'familyName') as familyName
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'title') as title
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'salutation') as salutation
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'nameSuffix') as nameSuffix
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'genderCode') as genderCode
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'birthDate') as birthDate
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'driverLicense') as driverLicense
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'inceptionDateTime') as inceptionDateTime
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id]  and b.[key1] = 0 and b.[key] = 'address') as [address_residence] 
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id]  and b.[key1] = 1 and b.[key] = 'address') as [address_billing] 
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id]  and b.[key1] = 2 and b.[key] = 'address') as [address_shipping] 
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'idList') as idList
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'communication') as communication
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'partyType') as partyType
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'notes') as notes

into #parts_invoice_parties
from #temp10 a

--select distinct * from #parts_invoice_parties where invoiceNumber = 44724

IF OBJECT_ID('tempdb..#temp20') IS NOT NULL DROP TABLE #temp20
select a.ID, a.[Key_id], a.[key] as [Key1],a.invoiceNumber, b.* into #temp20
from 
(
select a.ID, a.[Key_id], a.invoiceNumber, b.*

from #parts_invoice_parties a
CROSS APPLY OPENJSON(communication) as b
) as a
CROSS APPLY OPENJSON([value]) as b

--select * from #temp20 where invoicenumber = 44745
IF OBJECT_ID('tempdb..#parts_invoice_parties_communication') IS NOT NULL DROP TABLE #parts_invoice_parties_communication
select distinct  id, [Key_id], [Key1] ,invoiceNumber
	--,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'emailAddress') as emailAddress
	--,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'channelType') as channelType
	--,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'channelCode') as channelCode
	--,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'privacy') as privacy_idlist
	--,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'completeNumber') as completeNumber
	  ,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and b.[key1] = 0 and a.invoicenumber = b.invoiceNumber and b.[key] = 'emailAddress') as emailAddress
	  ,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and b.[key1] = 1 and a.invoicenumber = b.invoiceNumber and b.[key] = 'completeNumber') as home_phone1
	  ,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and b.[key1] = 2 and a.invoicenumber = b.invoiceNumber and b.[key] = 'completeNumber') as home_phone2
	  ,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and b.[key1] = 3 and a.invoicenumber = b.invoiceNumber and b.[key] = 'completeNumber') as home_phone3


into #parts_invoice_parties_communication
from #temp20 a

--select * from #parts_invoice_parties_communication where invoiceNumber = 44754

/*
#parts_invoice_JsonValues
#parts_invoice_parties
#parts_invoice_parties_communication
*/

IF OBJECT_ID('tempdb..#temp30') IS NOT NULL DROP TABLE #temp30
select a.ID, a.[Key_id], a.[key] as [Key1],a.invoiceNumber, b.* into #temp30
from 
(
select a.ID, a.[Key_id], a.invoiceNumber, b.*

from #parts_invoice_JsonValues a
CROSS APPLY OPENJSON(pricing) as b
) as a
CROSS APPLY OPENJSON([value]) as b

--select * from #temp30
IF OBJECT_ID('tempdb..#parts_invoice_pricing') IS NOT NULL DROP TABLE #parts_invoice_pricing
select distinct  id, [Key_id], [Key1] ,invoiceNumber
	--,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'priceCode') as priceCode
	,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and  b.[key1] = 0 and a.invoicenumber = b.invoiceNumber and b.[key] = 'chargeAmount') as shipping_cost
	,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and  b.[key1] = 1 and a.invoicenumber = b.invoiceNumber and b.[key] = 'chargeAmount') as dealer_discount_amount
	,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and  b.[key1] = 2 and a.invoicenumber = b.invoiceNumber and b.[key] = 'chargeAmount') as total_cost
	--,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'priceDescription') as priceDescription
into #parts_invoice_pricing
from #temp30 a

--select * from #parts_invoice_pricing where invoiceNumber = 44754

IF OBJECT_ID('tempdb..#temp40') IS NOT NULL DROP TABLE #temp40
select a.ID, a.[Key_id], a.[key] as [Key1],a.invoiceNumber, b.* into #temp40
from 
(
select a.ID, a.[Key_id], a.invoiceNumber, b.*

from #parts_invoice_JsonValues a
CROSS APPLY OPENJSON(tax) as b
) as a
CROSS APPLY OPENJSON([value]) as b

--select * from #temp40

IF OBJECT_ID('tempdb..#parts_invoice_tax') IS NOT NULL DROP TABLE #parts_invoice_tax
select distinct  id, [Key_id], [Key1] ,invoiceNumber
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'taxTypeCode') as taxTypeCode
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'taxDescription') as taxDescription
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'taxAmount') as taxAmount
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'taxExemptIndicator') as taxExemptIndicator

into #parts_invoice_tax
from #temp40 a

--select * from #parts_invoice_tax


--------------------------------------------------------------partsInvoiceLine
IF OBJECT_ID('tempdb..#temp50') IS NOT NULL DROP TABLE #temp50
select a.ID, a.[Key_id], a.[key] as [Key1],a.invoiceNumber, b.* into #temp50
from 
(
select a.ID, a.[Key_id], a.invoiceNumber, b.*

from #parts_invoice_JsonValues a
CROSS APPLY OPENJSON(partsInvoiceLine) as b
) as a
CROSS APPLY OPENJSON([value]) as b

--select * from #temp50


IF OBJECT_ID('tempdb..#parts_invoice_partsInvoiceLine') IS NOT NULL DROP TABLE #parts_invoice_partsInvoiceLine
select distinct  id, [Key_id], [Key1] ,invoiceNumber
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'lineNumber') as lineNumber
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'coreCostIncluded') as coreCostIncluded
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'partManufacturer') as partManufacturer
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'vendorCode') as vendorCode
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'partsProductItem') as partsProductItem

into #parts_invoice_partsInvoiceLine
from #temp50 a

--select * from #parts_invoice_partsInvoiceLine
---------------------------------------------------------------partsProductItem
IF OBJECT_ID('tempdb..#temp60') IS NOT NULL DROP TABLE #temp60

select a.ID, a.[Key_id], a.[key1] as key1, a.invoiceNumber,b.* into #temp60

from #parts_invoice_partsInvoiceLine a
CROSS APPLY OPENJSON(partsProductItem) as b


--select * from #temp60


IF OBJECT_ID('tempdb..#parts_invoice_partsInvoiceLine_partsProductItem') IS NOT NULL DROP TABLE #parts_invoice_partsInvoiceLine_partsProductItem
select distinct  id, [Key_id], [Key1] ,invoiceNumber
	,(select [value] from #temp60 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'partItemDescription') as partItemDescription
	,(select [value] from #temp60 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'itemIdentificationGroup') as itemIdentificationGroup
	,(select [value] from #temp60 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'orderQuantity') as orderQuantity
	,(select [value] from #temp60 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and a.invoicenumber = b.invoiceNumber and b.[key] = 'pricing') as parts_invoice_pricing

into #parts_invoice_partsInvoiceLine_partsProductItem
from #temp60 a
--select * from #parts_invoice_partsInvoiceLine_partsProductItem

IF OBJECT_ID('tempdb..#temp70') IS NOT NULL DROP TABLE #temp70
select a.ID, a.[Key_id], a.[key] as [Key1],a.invoiceNumber, b.* into #temp70
from 
(
	select a.ID, a.[Key_id], a.invoiceNumber, b.*

	from #parts_invoice_partsInvoiceLine_partsProductItem a
	CROSS APPLY OPENJSON(parts_invoice_pricing) as b
) as a
CROSS APPLY OPENJSON([value]) as b

--select * from #temp70

IF OBJECT_ID('tempdb..#parts_invoice_partsInvoiceLine_partsProductItem_pricing') IS NOT NULL DROP TABLE #parts_invoice_partsInvoiceLine_partsProductItem_pricing
select distinct  id, [Key_id], [Key1] ,invoiceNumber
	--,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and b.[key1] =0 and a.invoicenumber = b.invoiceNumber and b.[key] = 'priceCode') as PartCost
	--,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and b.[key1] =1 and a.invoicenumber = b.invoiceNumber and b.[key] = 'priceCode') as list_price
	--,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and b.[key1] =2 and a.invoicenumber = b.invoiceNumber and b.[key] = 'priceCode') as unit_price
	,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and b.[key1] =0 and a.invoicenumber = b.invoiceNumber and b.[key] = 'chargeAmount') as PartCost
	,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and b.[key1] =1 and a.invoicenumber = b.invoiceNumber and b.[key] = 'chargeAmount') as list_price
	,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and b.[key1] =2 and a.invoicenumber = b.invoiceNumber and b.[key] = 'chargeAmount') as unit_price

into #parts_invoice_partsInvoiceLine_partsProductItem_pricing
from #temp70 a

--select distinct * from #parts_invoice_partsInvoiceLine_partsProductItem_pricing where invoiceNumber = 44754
--select * from #parts_invoice_JsonValues  ---31
--select * from #parts_invoice_parties order by invoiceNumber ---122
--select * from #parts_invoice_parties_communication ---36
--select * from #parts_invoice_pricing --93
--select * from #parts_invoice_tax --00
--select * from #parts_invoice_partsInvoiceLine --31
--select * from #parts_invoice_partsInvoiceLine_partsProductItem --31
--select * from #parts_invoice_partsInvoiceLine_partsProductItem_pricing order by invoiceNumber  --93

select distinct
p.id
,p.[Key_id]
,p.invoiceNumber
,p.customerTypeCode
,p.givenName
,p.middleName
,p.familyName
,p.title
,p.salutation
,p.nameSuffix
,p.genderCode
,p.birthDate
,p.driverLicense
,p.inceptionDateTime
,p.partyType
,p.address_residence
,p.address_billing
,p.address_shipping
,p.idList
,p.notes as invoice_parties_notes
,c.emailAddress
,c.emailAddress
,c.home_phone1
,c.home_phone2
,c.home_phone3
,v.dealerOrderNumber
,v.invoiceDate
,v.shipmentNumber
,v.shipDate
,v.shipmentMethod
,v.deliveryDate
,v.totalPartPiecesNumeric
,v.invoiceState
,v.invoiceTypeDescription
,v.invoiceType
,v.invoiceNumber
,v.cashieredIndicator
,v.willCall
,pp.shipping_cost
,pp.dealer_discount_amount
,pp.total_cost
--,pp.priceDescription
,il.lineNumber
,il.coreCostIncluded
,il.partManufacturer
,il.vendorCode
,i.partItemDescription
,i.orderQuantity
,i.itemIdentificationGroup
,pip.PartCost
,pip.list_price
,pip.unit_price
,t.taxAmount
,t.taxDescription
,t.taxTypeCode
,t.taxExemptIndicator

from #parts_invoice_parties p 
left outer join #parts_invoice_parties_communication c on p.id = c.id and p.[Key_id] =c.[Key_id] and p.invoiceNumber = c.invoiceNumber
left outer join #parts_invoice_JsonValues v on  p.id = v.id and p.[Key_id] =v.[Key_id] and p.invoiceNumber = v.invoiceNumber
left outer join #parts_invoice_pricing pp on  pp.id = p.id and pp.[Key_id] =p.[Key_id] and pp.invoiceNumber = p.invoiceNumber
left outer join #parts_invoice_partsInvoiceLine il on  il.id = p.id and il.[Key_id] =p.[Key_id] and il.invoiceNumber = p.invoiceNumber
left outer join #parts_invoice_partsInvoiceLine_partsProductItem i on  i.id = p.id and i.[Key_id] =p.[Key_id] and i.invoiceNumber = p.invoiceNumber
left outer join #parts_invoice_partsInvoiceLine_partsProductItem_pricing pip on  pip.id = p.id and pip.[Key_id] =p.[Key_id] and pip.invoiceNumber = p.invoiceNumber
left outer join #parts_invoice_tax t on  t.id = p.id and t.[Key_id] =p.[Key_id] and t.invoiceNumber = p.invoiceNumber

--where p.invoiceNumber = 44754 and partyType is not null and idList is not null



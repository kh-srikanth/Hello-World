USE clictell_auto_etl
GO
IF OBJECT_ID('tempdb..#temp_parts_inventory_Json') IS NOT NULL DROP TABLE #temp_parts_inventory_Json
Create table #temp_parts_inventory_Json 
(
	[Key_id] int,
	[Key] varchar(100),
	[value] varchar(max),
	[type] int
)
IF OBJECT_ID('tempdb..#parts_inventory_JsonValues') IS NOT NULL DROP TABLE #parts_inventory_JsonValues
create table #parts_inventory_JsonValues
(

	id int identity(1,1) Primary key
	,[Key_id] int
	,partNumber varchar(50)
	,stockingStatusCode varchar(25)
	,quantityBestStockingLevel  varchar(1000)
	,packageQuantity int
	,quantityOnHand	int
	,quantityOnOrder int 
	,quantityReOrderPoint int
	,partManufacturer varchar(50)
	,partSourceCode varchar(5)
	,systemSetupDate date
	,binLocation varchar(max)
	,pricing varchar(max)
	,quantitySold int
	,quantityOfLostSale int
	,quantityTwelveMonthSales int
	,quantityTwelveMonthLostSales int
	,backOrderQuantity int
	,lastSoldDate date
	,partSubSourceCode varchar(10)
	,notes varchar(max)
	,orderQuantityReceived int
	,lastReceiptDate date
	,dateOfLastOrder date
	,lastPhysicalInventoryDate date
	,lastReceiptQuantity int
	,partItemDescription varchar(50)
	,partSourceDescription varchar(20)
	,eligibleForReturnIndicator char
	,supercededFrom varchar(20)
	,supercededTo varchar(20)
	,quantitySoldHistory varchar(max)
	,partsActivityTransaction varchar(max)

)


Declare @partsJson NVARCHAR(max) 
--Declare @path nvarchar(250) = '\\192.168.0.108\etl_source\Automate\GetPartsInventory_1.txt'
--Declare @path nvarchar(250) = '\\3.23.227.224\etl_source\Automate\GetPartsInventory_1.txt'
Declare @path nvarchar(250) = 'D:\etl\etl_process\Automate\ATM0001_GetPartsInventory_1.txt'
Declare @sql nvarchar(1000)
Declare @key varchar(max)
Declare @value nvarchar(max)


set @sql = 'SELECT @partsJson = Cast(BulkColumn as nvarchar(max)) FROM OPENROWSET (BULK ''' + @path + ''', SINGLE_CLOB) as import'

EXEC sp_executesql @sql,N'@partsJson NVARCHAR(max) output',@partsJson output;

IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

select 0 as is_processed,b.* into #temp
from 
(
select *
from OpenJSon(@partsJson) as a
) as a
cross apply OpenJson([value]) as b

While ((select count(*) from #temp where is_processed = 0) >0)

begin

	select top 1 @key = [key], @value = [value] from #temp where is_processed = 0
	insert into #temp_parts_inventory_Json
	select @key, * from OpenJson(@value)
	Insert into #parts_inventory_JsonValues 
	(
	[Key_id] 
	,partNumber
	,stockingStatusCode
	,quantityBestStockingLevel
	,packageQuantity
	,quantityOnHand
	,quantityOnOrder
	,quantityReOrderPoint
	,partManufacturer
	,partSourceCode
	,systemSetupDate
	,binLocation
	,pricing
	,quantitySold 
	,quantityOfLostSale 
	,quantityTwelveMonthSales 
	,quantityTwelveMonthLostSales 
	,backOrderQuantity
	,lastSoldDate 
	,partSubSourceCode 
	,notes 
	,orderQuantityReceived 
	,lastReceiptDate 
	,dateOfLastOrder 
	,lastPhysicalInventoryDate 
	,lastReceiptQuantity 
	,partItemDescription 
	,partSourceDescription 
	,eligibleForReturnIndicator 
	,supercededFrom 
	,supercededTo
	,quantitySoldHistory 
	,partsActivityTransaction 


	)
	select @key, *	from OpenJson(@value)
	With
	(
	partNumber varchar(50)	'$.partNumber'						
	,stockingStatusCode varchar(25) '$.stockingStatusCode'
	,quantityBestStockingLevel  varchar(1000) '$.quantityBestStockingLevel'
	,packageQuantity int '$.packageQuantity'
	,quantityOnHand	int '$.quantityOnHand'
	,quantityOnOrder int  '$.quantityOnOrder'
	,quantityReOrderPoint int '$.quantityReOrderPoint'
	,partManufacturer varchar(50) '$.partManufacturer'
	,partSourceCode varchar(5) '$.partSourceCode'
	,systemSetupDate date '$.systemSetupDate'
	,binLocation varchar(max) '$.binLocation'
	,pricing varchar(max) '$.pricing' --
	,quantitySold int '$.quantitySold'
	,quantityOfLostSale int '$.quantityOfLostSale'
	,quantityTwelveMonthSales int '$.quantityTwelveMonthSales'
	,quantityTwelveMonthLostSales int '$.quantityTwelveMonthLostSales'
	,backOrderQuantity int '$.backOrderQuantity'
	,lastSoldDate date '$.lastSoldDate'
	,partSubSourceCode varchar(10) '$.partSubSourceCode'
	,notes varchar(max) '$.notes'
	,orderQuantityReceived int '$.orderQuantityReceived'
	,lastReceiptDate date '$.lastReceiptDate'
	,dateOfLastOrder date '$.dateOfLastOrder'
	,lastPhysicalInventoryDate date '$.lastPhysicalInventoryDate'
	,lastReceiptQuantity int '$.lastReceiptQuantity'
	,partItemDescription varchar(50) '$.partItemDescription'
	,partSourceDescription varchar(20) '$.partSourceDescription'
	,eligibleForReturnIndicator char '$.eligibleForReturnIndicator'
	,supercededFrom varchar(20) '$.supercededFrom'
	,supercededTo varchar(20) '$.supercededTo'
	,quantitySoldHistory varchar(max) '$.quantitySoldHistory' --
	,partsActivityTransaction varchar(max) '$.partsActivityTransaction' --

	)

	Update a set quantitySoldHistory = b.value
	from #parts_inventory_JsonValues a
	inner join #temp_parts_inventory_Json b on a.[Key_id] = b.[Key_id]
	where a.[Key_id] = @key and [Key] = 'quantitySoldHistory'

	Update a set partsActivityTransaction = b.value
	from #parts_inventory_JsonValues a
	inner join #temp_parts_inventory_Json b on a.[Key_id] = b.[Key_id]
	where a.[Key_id] = @key and [Key] = 'partsActivityTransaction'

	Update a set pricing = b.value
	from #parts_inventory_JsonValues a
	inner join #temp_parts_inventory_Json b on a.[Key_id] = b.[Key_id]
	where a.[Key_id] = @key and [Key] = 'pricing'

	Update a set notes = b.value
	from #parts_inventory_JsonValues a
	inner join #temp_parts_inventory_Json b on a.[Key_id] = b.[Key_id]
	where a.[Key_id] = @key and [Key] = 'notes'

	Update #temp set is_processed = 1 where [Key] = @key

end

--select * from #parts_inventory_JsonValues

IF OBJECT_ID('tempdb..#temp10') IS NOT NULL DROP TABLE #temp10
select a.ID, a.[Key_id], a.[key] as [Key1],a.partNumber, b.* into #temp10
from 
(
select a.ID, a.[Key_id], a.partNumber, b.*

from #parts_inventory_JsonValues a
CROSS APPLY OPENJSON(pricing) as b
) as a
CROSS APPLY OPENJSON([value]) as b

--select * from #temp10

IF OBJECT_ID('tempdb..#temp11') IS NOT NULL DROP TABLE #temp11
select distinct  id, [Key_id], [Key1] ,partNumber
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'priceCode') as priceCode
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'chargeAmount') as chargeAmount
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'priceDescription') as priceDescription
into #temp11
from #temp10 a
--select * from #temp11 order by partNumber

IF OBJECT_ID('tempdb..#temp20') IS NOT NULL DROP TABLE #temp20
select a.ID, a.[Key_id], a.[key] as [Key1],a.partNumber, b.* into #temp20
from 
(
select a.ID, a.[Key_id], a.partNumber, b.*

from #parts_inventory_JsonValues a
CROSS APPLY OPENJSON(quantitySoldHistory) as b
) as a
CROSS APPLY OPENJSON([value]) as b

--select * from #temp20
IF OBJECT_ID('tempdb..#temp21') IS NOT NULL DROP TABLE #temp21
select distinct  id, [Key_id], [Key1] ,partNumber
	,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'periodId') as periodId
	,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'quantitySold') as quantitySold
	,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'saleTypeId') as saleTypeId
	,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'forecastRelevantIndicator') as forecastRelevantIndicator

into #temp21
from #temp20 a

IF OBJECT_ID('tempdb..#temp30') IS NOT NULL DROP TABLE #temp30
select a.ID, a.[Key_id], a.[key] as [Key1],a.partNumber, b.* into #temp30
from 
(
select a.ID, a.[Key_id], a.partNumber, b.*

from #parts_inventory_JsonValues a
CROSS APPLY OPENJSON(partsActivityTransaction) as b
) as a
CROSS APPLY OPENJSON([value]) as b

--select * from #temp30
IF OBJECT_ID('tempdb..#temp31') IS NOT NULL DROP TABLE #temp31
select distinct  id, [Key_id], [Key1] ,partNumber
	,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'partActivityTransactionCode') as partActivityTransactionCode
	,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'partActivityTransactionQuantity') as partActivityTransactionQuantity
	,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'partTransactionDateTime') as partTransactionDateTime

into #temp31
from #temp30 a

--select * from #temp31  

--select * from #parts_inventory_JsonValues order by partNumber
--select * from #temp11 order by partNumber
--select * from #temp21
--select * from #temp31

select distinct
		v.id
		,v.[Key_id]
		,v.partNumber
		,v.stockingStatusCode
		,v.quantityBestStockingLevel
		,v.packageQuantity
		,v.quantityOnHand
		,v.quantityOnOrder
		,v.quantityReOrderPoint
		,v.partManufacturer
		,v.partSourceCode
		,v.systemSetupDate
		,v.binLocation
		,v.quantitySold
		,v.quantityOfLostSale
		,v.quantityTwelveMonthSales
		,v.quantityTwelveMonthLostSales
		,v.backOrderQuantity
		,v.lastSoldDate
		,v.partSubSourceCode
		,v.notes as part_inventory_notes
		,v.orderQuantityReceived
		,v.lastReceiptDate
		,v.dateOfLastOrder
		,v.lastPhysicalInventoryDate
		,v.lastReceiptQuantity
		,v.partItemDescription
		,v.partSourceDescription
		,v.eligibleForReturnIndicator
		,v.supercededFrom
		,v.supercededTo
		,t2.periodId
		,t2.quantitySold
		,t2.saleTypeId
		,t2.forecastRelevantIndicator
		,t3.partActivityTransactionCode
		,t3.partActivityTransactionQuantity
		,t3.partTransactionDateTime
from #temp11 t1 
left outer join #parts_inventory_JsonValues v on t1.[Key_id] = v.[Key_id] and t1.partNumber = v.partNumber
left outer join #temp21 t2 on t2.[Key_id] = v.[Key_id] and t2.partNumber = v.partNumber
left outer join #temp31 t3 on t3.[Key_id] = v.[Key_id] and t3.partNumber = v.partNumber

--where v.partNumber = '10297368'
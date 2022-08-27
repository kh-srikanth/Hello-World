USE clictell_auto_etl
GO
IF OBJECT_ID('tempdb..#temp_parts_Json') IS NOT NULL DROP TABLE #temp_parts_Json
Create table #temp_parts_Json 
(
	[Key_id] int,
	[Key] varchar(100),
	[value] varchar(max),
	[type] int
)
IF OBJECT_ID('tempdb..#parts_JsonValues') IS NOT NULL DROP TABLE #parts_JsonValues
create table #parts_JsonValues
(

	id int identity(1,1) Primary key
	,[Key_id] int
	,orderNumber	varchar(100)
	,alternateOrderNumber varchar(100)
	,orderType varchar(50) --
	,orderDate date
	,orderSourceType varchar(20) --
	,partsOrderReceivedDateTime datetime
	,partsOrderParties varchar(max) --
	,partsOrderLine varchar(max)
)

Declare @partsJson NVARCHAR(max) 
--Declare @path nvarchar(250) = '\\192.168.0.108\etl_source\Automate\GetPartsOrder.txt'
Declare @path nvarchar(250) =  'D:\etl\etl_process\Automate\ATM0001_GetPartsOrder.txt'
Declare @sql nvarchar(1000)
Declare @key int
Declare @value nvarchar(max)

IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

set @sql = 'SELECT @partsJson = Cast(BulkColumn as nvarchar(max)) FROM OPENROWSET (BULK ''' + @path + ''', SINGLE_CLOB) as import'
EXEC sp_executesql @sql,N'@partsJson NVARCHAR(max) output',@partsJson output;
select *, 0 as is_processed into #temp from OpenJson(@partsJson)

While ((select count(*) from #temp where is_processed = 0) >0)

begin

	select top 1 @key = [key], @value = [value] from #temp where is_processed = 0
	insert into #temp_parts_Json
	select @key, * from OpenJson(@value)

	Insert into #parts_JsonValues 
	(
	[Key_id] 
	,orderNumber	
	,alternateOrderNumber 
	,orderType
	,orderDate
	,orderSourceType
	,partsOrderReceivedDateTime 
	,partsOrderParties
	,partsOrderLine
	)
	select @key, *	from OpenJson(@value)
	With
	(
	orderNumber varchar(100) '$.orderNumber'
	,alternateOrderNumber varchar(100) '$.alternateOrderNumber'
	,orderType varchar(50) '$.orderType'
	,orderDate date '$.orderDate'
	,orderSourceType varchar(20) '$.orderSourceType'
	,partsOrderReceivedDateTime datetime '$.partsOrderReceivedDateTime'
	,partsOrderParties varchar(max) '$.partsOrderParties'
	,partsOrderLine varchar(max) '$.partsOrderLine'
	)

	Update a set partsOrderLine = b.value
	from #parts_JsonValues a
	inner join #temp_parts_Json b on a.[Key_id] = b.[Key_id]
	where a.[Key_id] = @key and [Key] = 'partsOrderLine'

	Update a set partsOrderParties = b.value
	from #parts_JsonValues a
	inner join #temp_parts_Json b on a.[Key_id] = b.[Key_id]
	where a.[Key_id] = @key and [Key] = 'partsOrderParties'

	Update #temp set is_processed = 1 where [Key] = @key

end

--select * from #temp_parts_Json
--select * from #parts_JsonValues
--select * from #temp
----------------------------------------------------------------partsOrderLine
IF OBJECT_ID('tempdb..#temp10') IS NOT NULL DROP TABLE #temp10

select a.ID, a.[Key_id], a.[key] as [Key1],a.orderNumber, b.* into #temp10
from 
(
select a.ID, a.[Key_id], a.ordernumber, a.partsOrderLine, b.*

from #parts_JsonValues a
CROSS APPLY OPENJSON(partsOrderLine) as b
) as a
CROSS APPLY OPENJSON([value]) as b

--
IF OBJECT_ID('tempdb..#temp11') IS NOT NULL DROP TABLE #temp11
select distinct  id, [Key_id], [Key1] ,orderNumber
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'itemId') as itemId
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'orderQuantity') as orderQuantity
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'receivedQuantity') as receivedQuantity
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'customerName') as customerName
	,replace(replace((select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'binLocation'),'[',''),']','') as binLocation
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'acknowledgementStatus') as acknowledgementStatus 
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'partSourceCode') as partSourceCode 
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'pricing') as pricing --array
into #temp11
from #temp10 a



IF OBJECT_ID('tempdb..#temp20') IS NOT NULL DROP TABLE #temp20

select a.ID, a.[Key_id], a.[key] as [Key1], a.itemId,a.orderNumber, b.* into #temp20
from
(
select a.ID, a.[Key_id], a.pricing, a.itemId,a.orderNumber, b.*
from #temp11 a
CROSS APPLY OPENJSON(pricing) as b
) as a 
CROSS APPLY OPENJSON([value]) as b


IF OBJECT_ID('tempdb..#temp21') IS NOT NULL DROP TABLE #temp21
select distinct  id, [Key_id], [Key1] ,orderNumber
		--,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and b.[key1] = a.[key1] and b.[key] = 'priceCode') as priceCode
		--,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and b.[key1] = a.[key1] and b.[key] = 'chargeAmount') as chargeAmount
		,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and b.[key1] = 0 and b.[key] = 'chargeAmount') as DealerCost
		,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and b.[key1] = 1 and b.[key] = 'chargeAmount') as MSRP

into #temp21
from #temp20 a

--select * from #parts_JsonValues
--select * from #temp11 order by [Key_id]
--select * from #temp21 order by [Key_id]

---------------------------------------------------------------------partsOrderParties
IF OBJECT_ID('tempdb..#temp30') IS NOT NULL DROP TABLE #temp30

select a.ID, a.[Key_id], a.[key] as [Key1],a.orderNumber, b.* into #temp30
from 
(
select a.ID, a.[Key_id], a.ordernumber, a.partsOrderParties, b.*

from #parts_JsonValues a
CROSS APPLY OPENJSON(partsOrderParties) as b
) as a
CROSS APPLY OPENJSON([value]) as b

IF OBJECT_ID('tempdb..#temp31') IS NOT NULL DROP TABLE #temp31
select distinct  id, [Key_id], [Key1] ,orderNumber
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'partyType') as partyType
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'customerTypeCode') as customerTypeCode
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'specialRemarksDescription') as specialRemarksDescription
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'businessTypeCode') as businessTypeCode
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'companyName') as companyName
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'doingBusinessAsName') as doingBusinessAsName
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'legalClassificationCode') as legalClassificationCode
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'inceptionDateTime') as inceptionDateTime
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'givenName') as givenName
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'middleName') as middleName
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'familyName') as familyName
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'title') as title
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'salutation') as salutation
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'nameSuffix') as nameSuffix
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'maritalStatusCode') as maritalStatusCode
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'genderCode') as genderCode
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'birthDate') as birthDate
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'preferredName') as preferredName
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'contactMethodTypeCode') as contactMethodTypeCode
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'specifiedOccupationTitle') as specifiedOccupationTitle
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'notes') as notes
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'primaryContact') as primaryContact --array
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'address') as [address] --array
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'idList') as idList --array
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'communication') as communication --array
		,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'partyActionEvent') as partyActionEvent --array


into #temp31
from #temp30 a
----------------------------------------------------------------------------partsOrderParties.primaryContact
IF OBJECT_ID('tempdb..#temp40') IS NOT NULL DROP TABLE #temp40

select a.ID, a.[Key_id], a.[key] as [Key1],a.orderNumber, b.* into #temp40
from 
(
select a.ID, a.[Key_id], a.ordernumber, a.primaryContact, b.*

from #temp31 a
CROSS APPLY OPENJSON(primaryContact) as b
) as a
CROSS APPLY OPENJSON([value]) as b

IF OBJECT_ID('tempdb..#temp41') IS NOT NULL DROP TABLE #temp41
select distinct  id, [Key_id], [Key1] ,orderNumber

	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'jobTitle') as					primary_contact_jobTitle
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'typeCode') as					primary_contact_typeCode
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'personName') as				primary_contact_personName
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'givenName') as					primary_contact_givenName
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'middleName') as				primary_contact_middleName
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'familyName') as				primary_contact_familyName
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'title') as						primary_contact_title
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'salutation') as				primary_contact_salutation
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'nameSuffix') as				primary_contact_nameSuffix
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'maritalStatusCode') as			primary_contact_maritalStatusCode
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'genderCode') as				primary_contact_genderCode
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'birthDate') as					primary_contact_birthDate
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'preferredName') as				primary_contact_preferredName
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'specifiedOccupationTitle') as	primary_contact_specifiedOccupationTitle
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'contactMethodTypeCode') as		primary_contact_contactMethodTypeCode
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'communication') as				primary_contact_communication --array
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'address') as					primary_contact_address --array
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'idList') as					primary_contact_idList --array
into #temp41
from #temp40 a

-----------------------------------------------------------------------------------partsOrderParties.primary_contact_address
IF OBJECT_ID('tempdb..#temp50') IS NOT NULL DROP TABLE #temp50

select a.ID, a.[Key_id], a.[key] as [Key1],a.orderNumber, b.* into #temp50
from 
(
select a.ID, a.[Key_id], a.ordernumber, a.primary_contact_address, b.*

from #temp41 a
CROSS APPLY OPENJSON(primary_contact_address) as b
) as a
CROSS APPLY OPENJSON([value]) as b

IF OBJECT_ID('tempdb..#temp51') IS NOT NULL DROP TABLE #temp51
select distinct  id, [Key_id], [Key1] ,orderNumber
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'addressId') as			pri_contact_addressId
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'addressType') as		pri_contact_addressType
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'lineOne') as			pri_contact_lineOne
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'lineTwo') as			pri_contact_lineTwo
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'lineThree') as			pri_contact_lineThree
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'lineFour') as			pri_contact_lineFour
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'cityName') as			pri_contact_cityName
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'countryId') as			pri_contact_countryId
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'postCode') as			pri_contact_postCode
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'stateOrProvinceCountrySubDivisionId') as pri_contact_stateOrProvinceCountrySubDivisionId
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'countyCountrySubDivision') as			  pri_contact_countyCountrySubDivision
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'privacy') as			pri_contact_privacy  --array


into #temp51
from #temp50 a
-----------------------------------------------------------------------------------partsOrderParties.primary_contact_idList
IF OBJECT_ID('tempdb..#temp60') IS NOT NULL DROP TABLE #temp60

select a.ID, a.[Key_id], a.[key] as [Key1],a.orderNumber, b.* into #temp60
from 
(
select a.ID, a.[Key_id], a.ordernumber, a.primary_contact_idList, b.*

from #temp41 a
CROSS APPLY OPENJSON(primary_contact_idList) as b
) as a
CROSS APPLY OPENJSON([value]) as b


IF OBJECT_ID('tempdb..#temp61') IS NOT NULL DROP TABLE #temp61
select distinct  id, [Key_id], [Key1] ,orderNumber
	,(select [value] from #temp60 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'id') as			pri_contact_address_idlist_id
	,(select [value] from #temp60 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'typeId') as		pri_contact_addressidlist_typeId

into #temp61
from #temp60 a

-----------------------------------------------------------------------------------partsOrderParties.primary_contact_communication
IF OBJECT_ID('tempdb..#temp70') IS NOT NULL DROP TABLE #temp70

select a.ID, a.[Key_id], a.[key] as [Key1],a.orderNumber, b.* into #temp70
from 
(
select a.ID, a.[Key_id], a.ordernumber, a.primary_contact_communication, b.*

from #temp41 a
CROSS APPLY OPENJSON(primary_contact_communication) as b
) as a
CROSS APPLY OPENJSON([value]) as b

IF OBJECT_ID('tempdb..#temp71') IS NOT NULL DROP TABLE #temp71
select distinct  id, [Key_id], [Key1] ,orderNumber
	,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'emailAddress') as			pri_contact_emailAddress
	,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'channelType') as		pri_contact_channelType
	,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'channelCode') as	pri_contact_channelCode
	,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'completeNumber') as	pri_contact_completeNumber
	,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'extensionNumber') as	pri_contact_extensionNumber

into #temp71
from #temp70 a


------------------------------------------------------partyActionEvent
IF OBJECT_ID('tempdb..#temp80') IS NOT NULL DROP TABLE #temp80

select a.ID, a.[Key_id], a.[key] as [Key1],a.orderNumber, b.* into #temp80
from 
(
select a.ID, a.[Key_id], a.ordernumber, a.partyActionEvent, b.*

from #temp31 a
CROSS APPLY OPENJSON(partyActionEvent) as b
) as a
CROSS APPLY OPENJSON([value]) as b

IF OBJECT_ID('tempdb..#temp81') IS NOT NULL DROP TABLE #temp81
select distinct  id, [Key_id], [Key1] ,orderNumber
	,(select [value] from #temp80 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'eventId') as			eventId
	,(select [value] from #temp80 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'eventDescription') as		eventDescription
	,(select [value] from #temp80 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'eventOccurrenceDateTime') as	eventOccurrenceDateTime

into #temp81
from #temp80 a



select distinct
		v.id
		,v.[Key_id]
		,v.orderNumber
		,v.alternateOrderNumber
		,v.orderType
		,orderDate
		,orderSourceType
		,partsOrderReceivedDateTime
		,partsOrderParties
		,itemId,orderQuantity
		,receivedQuantity
		,customerName
		,binLocation
		,acknowledgementStatus
		,partSourceCode
		,DealerCost
		,MSRP
		,partyType
		,customerTypeCode
		,specialRemarksDescription
		,businessTypeCode
		,companyName
		,doingBusinessAsName
		,legalClassificationCode
		,inceptionDateTime
		,givenName
		,middleName
		,familyName
		,title
		,salutation
		,nameSuffix
		,maritalStatusCode
		,genderCode
		,birthDate
		,preferredName
		,contactMethodTypeCode
		,specifiedOccupationTitle
		,notes
		,primary_contact_jobTitle
		,primary_contact_typeCode
		,primary_contact_personName
		,primary_contact_givenName
		,primary_contact_middleName
		,primary_contact_familyName
		,primary_contact_title
		,primary_contact_salutation
		,primary_contact_nameSuffix
		,primary_contact_maritalStatusCode
		,primary_contact_genderCode
		,primary_contact_birthDate
		,primary_contact_preferredName
		,primary_contact_specifiedOccupationTitle
		,primary_contact_contactMethodTypeCode
		,pri_contact_addressId
		,pri_contact_addressType
		,pri_contact_lineOne
		,pri_contact_lineTwo
		,pri_contact_lineThree
		,pri_contact_lineFour
		,pri_contact_cityName
		,pri_contact_countryId
		,pri_contact_postCode
		,pri_contact_stateOrProvinceCountrySubDivisionId
		,pri_contact_countyCountrySubDivision
		,pri_contact_privacy
		,pri_contact_address_idlist_id
		,pri_contact_addressidlist_typeId
		,pri_contact_emailAddress
		,pri_contact_channelType
		,pri_contact_channelCode
		,pri_contact_completeNumber
		,pri_contact_extensionNumber
		,eventId
		,eventDescription
		,eventOccurrenceDateTime

from 
#temp21 t2
left outer join #temp11 t1 on t2.id = t1.id and t2.[Key_id] = t1.[Key_id] and t1.orderNumber = t2.orderNumber
left outer join #parts_JsonValues v on v.id = t1.id and v.[Key_id] = t1.[Key_id] and v.orderNumber = t1.orderNumber
left outer join #temp31 t3 on t1.id =t3.id and t1.[Key_id] = t3.[Key_id] and t1.orderNumber = t3.orderNumber
left outer join #temp41 t4 on t1.id =t4.id and t1.[Key_id] = t4.[Key_id] and t1.orderNumber = t4.orderNumber
left outer join #temp51 t5 on t1.id = t5.id and t1.[Key_id] = t5.[Key_id] and t1.orderNumber = t5.orderNumber
left outer join #temp61 t6 on t1.id =t6.id and t1.[Key_id] = t6.[Key_id] and t1.orderNumber = t6.orderNumber
left outer join #temp71 t7 on t1.id =t7.id and t1.[Key_id] = t7.[Key_id] and t1.orderNumber = t7.orderNumber
left outer join #temp81 t8 on t1.id =t8.id and t1.[Key_id] = t8.[Key_id] and t1.orderNumber = t8.orderNumber 
order by v.orderNumber
--where t1.orderNumber ='8350Q'


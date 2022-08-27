USE clictell_auto_etl
GO

IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#temp_ROJson') IS NOT NULL DROP TABLE #temp_ROJson
IF OBJECT_ID('tempdb..#temp_ROJsonValues') IS NOT NULL DROP TABLE #temp_ROJsonValues
IF OBJECT_ID('tempdb..#temp_ROJsonParties') IS NOT NULL DROP TABLE #temp_ROJsonParties
IF OBJECT_ID('tempdb..#temp10') IS NOT NULL DROP TABLE #temp10
IF OBJECT_ID('tempdb..#temp11') IS NOT NULL DROP TABLE #temp11
IF OBJECT_ID('tempdb..#temp20') IS NOT NULL DROP TABLE #temp20
IF OBJECT_ID('tempdb..#temp21') IS NOT NULL DROP TABLE #temp21
IF OBJECT_ID('tempdb..#temp30') IS NOT NULL DROP TABLE #temp30
IF OBJECT_ID('tempdb..#temp31') IS NOT NULL DROP TABLE #temp31
IF OBJECT_ID('tempdb..#temp_address') IS NOT NULL DROP TABLE #temp_address
IF OBJECT_ID('tempdb..#temp_idList') IS NOT NULL DROP TABLE #temp_idList
IF OBJECT_ID('tempdb..#temp_communication') IS NOT NULL DROP TABLE #temp_communication
IF OBJECT_ID('tempdb..#temp_privacy') IS NOT NULL DROP TABLE #temp_privacy
IF OBJECT_ID('tempdb..#temp_ro_parties') IS NOT NULL DROP TABLE #temp_ro_parties
IF OBJECT_ID('tempdb..#temp_codes_comments') IS NOT NULL DROP TABLE #temp_codes_comments

Create table #temp_ROJson 
(
	[Key_id] int,
	[Key] varchar(100),
	[value] varchar(max),
	[type] int
)
create table #temp_ROJsonValues
(
	id int identity(1,1) Primary key,
	[Key_id] int, 
	inDistanceMeasure int, 
	repairOrderOpenedDate date, 
	repairOrderOpenedDateTime datetime, 
	lastUpdateDateTime datetime, 
	repairOrderNumber int, 
	repairOrderAlternateId varchar(500),
	repairOrderStatus varchar(20)

	,documentId							varchar(50) 
	,repairOrderCompletedDate			date		
	,repairOrderCompletedDateTime		datetime	
	,repairOrderInvoiceDate				date		
	,outDistanceMeasure					int		
	,legacyPromisedTime					varchar(50)	
	,orderNotes							varchar(max)
	,orderInternalNotes					varchar(max)
	,departmentType						varchar(20)	
	,rentLoanerNotes					varchar(max)
	,laborRateAmount					int			
	,jobCountNumeric					int			
	,laborAllowanceHoursNumeric			int		
	,laborActualHoursNumeric			int			
	,repairOrderPriorityCode			varchar(25)	
	,vehiclePickupDateTime				datetime	
	,customerAppointmentNumber			varchar(50)	
	,promisedRepairCompletionDateTime	datetime	
	,vehicleHatNumber					varchar(10)	
	,appointmentType					varchar(5)	
	,appointmentScheduledDateTime		datetime	
	,additionalWorkRequestedDateTime	datetime	
	,dateAppointmentInitiated			date		

	,repairOrderParties varchar(max)
	,job varchar(max)
	,repairOrderVehicleLineItem varchar(max)

	,warranty varchar(max)
	,serviceContract varchar(max)
	,serviceComponents varchar(max)
	,sublet varchar(max)
	,price varchar(max)
	,tax varchar(max)
)
Declare @ROJson NVARCHAR(max) 
Declare @path nvarchar(250) = '\\192.168.0.108\etl_source\Automate\GetRO_1.txt'
Declare @sql nvarchar(1000)
Declare @key int
Declare @value nvarchar(max)

set @sql = 'SELECT @ROJson = Cast(BulkColumn as nvarchar(max)) FROM OPENROWSET (BULK ''' + @path + ''', SINGLE_CLOB) as import'

EXEC sp_executesql @sql,N'@ROJson NVARCHAR(max) output',@ROJson output;

select *, 0 as is_processed into #temp from OpenJson(@ROJson)


While ((select count(*) from #temp where is_processed = 0) >0)

begin

	select top 1 @key = [key], @value = [value] from #temp where is_processed = 0

	Insert into #temp_ROJson
	
	select @key, * from OpenJson(@value)

	Insert into #temp_ROJsonValues ([Key_id], inDistanceMeasure, repairOrderOpenedDate, repairOrderOpenedDateTime, lastUpdateDateTime, repairOrderNumber, repairOrderAlternateId
		, repairOrderStatus
		,documentId					
		,repairOrderCompletedDate			
		,repairOrderCompletedDateTime		
		,repairOrderInvoiceDate				
		,outDistanceMeasure					
		,legacyPromisedTime					
		,orderNotes							
		,orderInternalNotes					
		,departmentType						
		,rentLoanerNotes					
		,laborRateAmount					
		,jobCountNumeric					
		,laborAllowanceHoursNumeric			
		,laborActualHoursNumeric			
		,repairOrderPriorityCode			
		,vehiclePickupDateTime				
		,customerAppointmentNumber			
		,promisedRepairCompletionDateTime	
		,vehicleHatNumber					
		,appointmentType					
		,appointmentScheduledDateTime		
		,additionalWorkRequestedDateTime	
		,dateAppointmentInitiated			
	
	)
	select @key, *	from OpenJson(@value)

	With
	(
		inDistanceMeasure			int			'$.inDistanceMeasure',
		repairOrderOpenedDate		date		'$.repairOrderOpenedDate',
		repairOrderOpenedDateTime	datetime	'$.repairOrderOpenedDateTime',
		lastUpdateDateTime			DateTime	'$.lastUpdateDateTime',
		repairOrderNumber			int			'$.repairOrderNumber',
		repairOrderAlternateId		Varchar(500)'$.repairOrderAlternateId',
		repairOrderStatus			Varchar(20) '$.repairOrderStatus'
		--------------------------------below not in dummy data
		,documentId							varchar(50) '$.documentId'
		,repairOrderCompletedDate			date		'$.repairOrderCompletedDate'
		,repairOrderCompletedDateTime		datetime		'$.repairOrderCompletedDateTime'
		,repairOrderInvoiceDate				date		'$.repairOrderInvoiceDate'
		,outDistanceMeasure					int		'$.outDistanceMeasure'
		,legacyPromisedTime					varchar(50)		'$.legacyPromisedTime'
		,orderNotes							varchar(max)		'$.orderNotes'
		,orderInternalNotes					varchar(max)		'$.orderInternalNotes'
		,departmentType						varchar(20)		'$.departmentType'
		,rentLoanerNotes					varchar(max)			'$.rentLoanerNotes'
		,laborRateAmount					int				'$.laborRateAmount'
		,jobCountNumeric					int			'$.jobCountNumeric'
		,laborAllowanceHoursNumeric			int		'$.laborAllowanceHoursNumeric'
		,laborActualHoursNumeric			int			'$.laborActualHoursNumeric'
		,repairOrderPriorityCode			varchar(25)			'$.repairOrderPriorityCode'
		,vehiclePickupDateTime				datetime		'$.vehiclePickupDateTime'
		,customerAppointmentNumber			varchar(50)		'$.customerAppointmentNumber'
		,promisedRepairCompletionDateTime	datetime		'$.promisedRepairCompletionDateTime'
		,vehicleHatNumber					varchar(10)		'$.vehicleHatNumber'
		,appointmentType					varchar(5)			'$.appointmentType'
		,appointmentScheduledDateTime		datetime		'$.appointmentScheduledDateTime'
		,additionalWorkRequestedDateTime	datetime			'$.additionalWorkRequestedDateTime'
		,dateAppointmentInitiated			date		'$.dateAppointmentInitiated'
	) as Core


	Update a set repairOrderParties = b.value
	from #temp_ROJsonValues a
	inner join #temp_ROJson b on a.[Key_id] = b.[Key_id]
	where a.[Key_id] = @key and [Key] = 'repairOrderParties'
	
	Update a set job = b.value
	from #temp_ROJsonValues a
	inner join #temp_ROJson b on a.[Key_id] = b.[Key_id]
	where a.[Key_id] = @key and [Key] = 'job'
	

	Update a set repairOrderVehicleLineItem = b.value
	from #temp_ROJsonValues a
	inner join #temp_ROJson b on a.[Key_id] = b.[Key_id]
	where a.[Key_id] = @key and [Key] = 'repairOrderVehicleLineItem'


	------------------------------------------------------below not in dummy data
	Update a set warranty = b.value
	from #temp_ROJsonValues a
	inner join #temp_ROJson b on a.[Key_id] = b.[Key_id]
	where a.[Key_id] = @key and [Key] = 'warranty'


	Update a set serviceContract = b.value
	from #temp_ROJsonValues a
	inner join #temp_ROJson b on a.[Key_id] = b.[Key_id]
	where a.[Key_id] = @key and [Key] = 'serviceContract'
	
	
	Update a set serviceComponents = b.value
	from #temp_ROJsonValues a
	inner join #temp_ROJson b on a.[Key_id] = b.[Key_id]
	where a.[Key_id] = @key and [Key] = 'serviceComponents'

	Update a set sublet = b.value
	from #temp_ROJsonValues a
	inner join #temp_ROJson b on a.[Key_id] = b.[Key_id]
	where a.[Key_id] = @key and [Key] = 'sublet'

	Update a set price = b.value
	from #temp_ROJsonValues a
	inner join #temp_ROJson b on a.[Key_id] = b.[Key_id]
	where a.[Key_id] = @key and [Key] = 'price'

	Update a set tax = b.value
	from #temp_ROJsonValues a
	inner join #temp_ROJson b on a.[Key_id] = b.[Key_id]
	where a.[Key_id] = @key and [Key] = 'tax'

	Update #temp set is_processed = 1 where [Key] = @key


End
-----------------------------------------repairOrderParties---------------------

select a.ID, a.[Key_id], a.[key] as [Key1], b.* into #temp10
from 
(
select a.ID, a.[Key_id], a.repairOrderParties, b.*

from #temp_ROJsonValues a
CROSS APPLY OPENJSON(repairOrderParties) as b
) as a
CROSS APPLY OPENJSON([value]) as b


select distinct  id, [Key_id], [Key1] 
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'customerTypeCode') as customerTypeCode
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'givenName') as givenName
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'familyName') as familyName
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'inceptionDateTime') as inceptionDateTime
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'partyType') as partyType
	
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'address') as address --arrays
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'idList') as idList --arrays
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'communication') as communication --arrays

--------------------below not in dummy data
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'specialRemarksDescription') as specialRemarksDescription
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'businessTypeCode') as businessTypeCode
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'companyName') as companyName
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'doingBusinessAsName') as doingBusinessAsName
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'legalClassificationCode') as legalClassificationCode
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'middleName') as middleName
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'title') as title
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'salutation') as salutation
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'nameSuffix') as nameSuffix
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'maritalStatusCode') as maritalStatusCode
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'genderCode') as genderCode
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'birthDate') as birthDate
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'preferredName') as preferredName
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'contactMethodTypeCode') as contactMethodTypeCode
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'specifiedOccupationTitle') as specifiedOccupationTitle
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'notes') as notes

	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'primaryContact') as primaryContact --arrays
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'driverLicense') as driverLicense --arrays
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'customerInformationRewardsCard') as customerInformationRewardsCard --arrays
	,(select [value] from #temp10 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'partyActionEvent') as partyActionEvent --arrays

into #temp11
from #temp10 a

------------------repairOrderParties.address

select a.id, a.[Key_id], a.partyType, a.[address]
	,Json_value(b.[value], '$.addressId') as addressId
	,Json_value(b.[value], '$.addressType') as addressType
	,Json_value(b.[value], '$.lineOne') as lineOne
	,Json_value(b.[value], '$.lineTwo') as lineTwo
	,Json_value(b.[value], '$.lineThree') as lineThree
	,Json_value(b.[value], '$.lineFour') as lineFour
	,Json_value(b.[value], '$.cityName') as cityName
	,Json_value(b.[value], '$.countryId') as countryId
	,Json_value(b.[value], '$.postCode') as postCode
	,Json_value(b.[value], '$.stateOrProvinceCountrySubDivisionId') as stateOrProvinceCountrySubDivisionId
	,Json_value(b.[value], '$.countyCountrySubDivision') as countyCountrySubDivision
	,JSON_Query(b.[value], '$.privacy') as privacy --array
	
into #temp_address
from #temp11 a
cross apply OpenJSon([address]) b

-----------repairOrderParties.address.privacy
select a.id, a.[Key_id], a.partyType, a.[privacy]
	,Json_value(b.[value], '$.privacyIndicator') as privacyIndicator
	,Json_value(b.[value], '$.privacyType') as privacyType
		----below not in dummy data
	,Json_value(b.[value], '$.privacyIndicatorDescription') as privacyIndicatorDescription
	,Json_value(b.[value], '$.startDateTime') as privacy_startDateTime
	,Json_value(b.[value], '$.endDateTime') as privacy_endDateTime
into #temp_privacy
from #temp_address a
cross apply OpenJSon([privacy]) b

----------------repairOrderParties.idList
select a.id, a.[Key_id], a.partyType, a.[idList]
	,Json_value(b.[value], '$.id') as id_idlist
	,Json_value(b.[value], '$.typeId') as typeId
	
into #temp_idList
from #temp11 a
cross apply OpenJSon([idList]) b

----------------repairOrderParties.communication
select a.id, a.[Key_id], a.partyType, a.[communication]
	,Json_value(b.[value], '$.channelType') as channelType
	,Json_value(b.[value], '$.channelCode') as channelCode
	,Json_value(b.[value], '$.completeNumber') as completeNumber
	
	,Json_value(b.[value], '$.emailAddress') as emailAddress
	,Json_value(b.[value], '$.extensionNumber') as extensionNumber

into #temp_communication
from #temp11 a
cross apply OpenJSon([communication]) b


----join -----------repairOrderParties

select 
	t11.id
	,t11.[Key_id]
	,t11.[Key1]
	,t11.customerTypeCode
	,t11.givenName
	,t11.familyName
	,t11.inceptionDateTime
	,t11.partyType
	,a.addressId
	,a.addressType
	,a.cityName
	,a.countryId
	,a.countyCountrySubDivision
	,a.lineOne
	,a.postCode
	,a.stateOrProvinceCountrySubDivisionId
	,p.privacyIndicator
	,p.privacyType
	,l.id_idlist
	,l.typeId
	,c.channelCode
	,c.channelType
	,c.completeNumber
into #temp_ro_parties	
from 
#temp11 t11 
			inner join #temp_address a			on t11.id = a.id and t11.[Key_id] = a.[Key_id] and t11.partyType = a.partyType 
			inner join #temp_privacy p			on a.id = p.id and a.[Key_id] = p.[Key_id] and a.partyType = p.partyType-- and a.privacy = p.privacy
			inner join #temp_idList l			on a.id = l.id and a.[Key_id] = l.[Key_id] and a.partyType = l.partyType-- and t11.idList = l.id_idlist
			inner join #temp_communication c	on t11.id = c.id and t11.[Key_id] = c.[Key_id] and t11.partyType = c.partyType-- and t11.communication = c.communication 


----------------------------------------------------------------------job
select a.ID, a.[Key_id], a.[key] as [Key1], b.* into #temp20
from 
(
select a.ID, a.[Key_id], a.job, b.*

from #temp_ROJsonValues a
CROSS APPLY OPENJSON(job) as b
) as a
CROSS APPLY OPENJSON([value]) as b

select distinct  id, [Key_id], [Key1] 
	,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'jobNumber') as jobNumber
	,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'operationId') as operationId
	,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'jobStatusCode') as jobStatusCode
	,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'jobType') as jobType
	,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'codesAndCommentsExpanded') as codesAndCommentsExpanded --arrays
	,(select [value] from #temp20 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'serviceLabor') as serviceLabor --arrays
into #temp21
from #temp20 a

------------------------------------job.serviceLabor
IF OBJECT_ID('tempdb..#temp_serviceLabor') IS NOT NULL DROP TABLE #temp_serviceLabor
select a.id, a.[Key_id], a.jobNumber, a.[serviceLabor]
	,Json_value(b.[value], '$.laborActualHoursNumeric') as laborActualHoursNumeric
	,Json_value(b.[value], '$.laborAllowanceHoursNumeric') as laborAllowanceHoursNumeric
	,Json_value(b.[value], '$.serviceTechnicianId') as serviceTechnicianId
	,Json_query(b.[value], '$.sublet') as sublet  --array
	,Json_query(b.[value], '$.pricing') as service_labor_pricing  --array
into #temp_serviceLabor
from #temp21 a
cross apply OpenJSon([serviceLabor]) b

------------------------------------job.serviceLabor.sublet


IF OBJECT_ID('tempdb..#temp_sublet') IS NOT NULL DROP TABLE #temp_sublet
select a.id, a.[Key_id], a.jobNumber, a.[sublet]
	,Json_value(b.[value], '$.subletCode') as subletCode
	,Json_value(b.[value], '$.subletInvoiceNumber') as subletInvoiceNumber
	,trim(replace(replace(Json_query(b.[value], '$.subletWorkDescription'),'[',''),']','')) as subletWorkDescription  --array
	,Json_query(b.[value], '$.pricing') as sublet_pricing  --array
into #temp_sublet 
from #temp_serviceLabor a
cross apply OpenJSon([sublet]) b
------------------------------------job.serviceLabor.sublet-pricing
IF OBJECT_ID('tempdb..#temp_sublet_pricing') IS NOT NULL DROP TABLE #temp_sublet_pricing
select a.id, a.[Key_id], a.jobNumber, a.[sublet_pricing]
	,Json_value(b.[value], '$.priceCode') as priceCode
	,Json_value(b.[value], '$.chargeAmount') as chargeAmount
into #temp_sublet_pricing
from #temp_sublet a
cross apply OpenJSon([sublet_pricing]) b
------------------------------------job.serviceLabor.pricing
IF OBJECT_ID('tempdb..#temp_service_labor_pricing') IS NOT NULL DROP TABLE #temp_service_labor_pricing
select a.id, a.[Key_id], a.jobNumber, a.[service_labor_pricing]
	,Json_value(b.[value], '$.priceCode') as priceCode
	,Json_value(b.[value], '$.chargeAmount') as chargeAmount
into #temp_service_labor_pricing
from #temp_serviceLabor a
cross apply OpenJSon([service_labor_pricing]) b

------------------------job.codesAndCommentsExpanded
IF OBJECT_ID('tempdb..#temp_codesAndCommentsExpanded') IS NOT NULL DROP TABLE #temp_codesAndCommentsExpanded
select a.id, a.[Key_id], a.jobNumber, a.[codesAndCommentsExpanded]	,b.[key] as [key]
	,replace(replace(b.[value],'[',''),'[','') as [value]
into #temp_codesAndCommentsExpanded
from #temp21 a
cross apply OpenJSon([codesAndCommentsExpanded]) b
order by [key_id]

IF OBJECT_ID('tempdb..#temp_codes_comments_exp') IS NOT NULL DROP TABLE #temp_codes_comments_exp
select distinct  id, [Key_id], [Key] ,jobNumber
	,(select [value] from #temp_codesAndCommentsExpanded b where a.[key_id] = b.[Key_id] and a.[jobNumber] = b.[jobNumber] and b.[key] = 'causeDescription') as causeDescription
	,(select [value] from #temp_codesAndCommentsExpanded b where a.[key_id] = b.[Key_id] and a.[jobNumber] = b.[jobNumber] and b.[key] = 'complaintDescription') as complaintDescription
	,(select [value] from #temp_codesAndCommentsExpanded b where a.[key_id] = b.[Key_id] and a.[jobNumber] = b.[jobNumber] and b.[key] = 'correctionDescription') as correctionDescription
	,(select [value] from #temp_codesAndCommentsExpanded b where a.[key_id] = b.[Key_id] and a.[jobNumber] = b.[jobNumber] and b.[key] = 'complaintCode') as complaintCode
	,(select [value] from #temp_codesAndCommentsExpanded b where a.[key_id] = b.[Key_id] and a.[jobNumber] = b.[jobNumber] and b.[key] = 'technicianNotes') as technicianNotes
	,(select [value] from #temp_codesAndCommentsExpanded b where a.[key_id] = b.[Key_id] and a.[jobNumber] = b.[jobNumber] and b.[key] = 'miscellaneousNotes') as miscellaneousNotes
	,(select [value] from #temp_codesAndCommentsExpanded b where a.[key_id] = b.[Key_id] and a.[jobNumber] = b.[jobNumber] and b.[key] = 'jobDenialCode') as jobDenialCode
	,(select [value] from #temp_codesAndCommentsExpanded b where a.[key_id] = b.[Key_id] and a.[jobNumber] = b.[jobNumber] and b.[key] = 'jobDenialDescription') as jobDenialDescription
	,(select [value] from #temp_codesAndCommentsExpanded b where a.[key_id] = b.[Key_id] and a.[jobNumber] = b.[jobNumber] and b.[key] = 'complaintCodeTypeString') as complaintCodeTypeString
	,(select [value] from #temp_codesAndCommentsExpanded b where a.[key_id] = b.[Key_id] and a.[jobNumber] = b.[jobNumber] and b.[key] = 'defectCode') as defectCode
	,(select [value] from #temp_codesAndCommentsExpanded b where a.[key_id] = b.[Key_id] and a.[jobNumber] = b.[jobNumber] and b.[key] = 'causalPartIndicator') as causalPartIndicator
into #temp_codes_comments_exp
from #temp_codesAndCommentsExpanded a

-------------------join -------------------job.*

--select * from #temp21
--select * from #temp_serviceLabor
--select * from #temp_sublet 
--select * from #temp_sublet_pricing
--select * from #temp_service_labor_pricing
--select * from #temp_codes_comments_exp

IF OBJECT_ID('tempdb..#job') IS NOT NULL DROP TABLE #job
select distinct   --520/distinct 240
	t21.id
	,t21.[Key_id]
	,t21.jobNumber
	,operationId
	,jobStatusCode
	,jobType
	,laborActualHoursNumeric
	,laborAllowanceHoursNumeric
	,serviceTechnicianId
	,subletCode
	,subletInvoiceNumber
	,subletWorkDescription
	,sp.priceCode as sublet_price_code
	,sp.chargeAmount as sublet_charge_amount
	,lp.priceCode as service_labor_price_code
	,lp.chargeAmount as service_labor_charge_amount
	,causeDescription
	,complaintDescription
	,correctionDescription
	,complaintCode
	,technicianNotes
	,miscellaneousNotes
	,jobDenialCode
	,jobDenialDescription
	,complaintCodeTypeString
	,defectCode
	,causalPartIndicator
into #job
 from 
	#temp21 t21 
		 inner join #temp_serviceLabor sl on t21.[Key_id]=sl.[Key_id] and t21.id = sl.id and t21.jobNumber = sl.jobNumber
		 inner join #temp_service_labor_pricing lp on t21.[Key_id]=lp.[Key_id] and t21.id = lp.id and t21.jobNumber = lp.jobNumber
		 left outer join #temp_sublet s on t21.[Key_id]=s.[Key_id] and t21.id = s.id and t21.jobNumber = s.jobNumber
		 left outer join #temp_sublet_pricing sp on t21.[Key_id]=sp.[Key_id] and t21.id = sp.id and t21.jobNumber = sp.jobNumber
		 left outer join #temp_codes_comments_exp cc on t21.[Key_id]=cc.[Key_id] and t21.id = cc.id and t21.jobNumber = cc.jobNumber


-------------------------------------------------------------repairOrderVehicleLineItem------------------------------------------------------------------

select a.ID, a.[Key_id], a.repairOrderVehicleLineItem, b.* into #temp30

from #temp_ROJsonValues a
CROSS APPLY OPENJSON(repairOrderVehicleLineItem) as b

select distinct  id, [Key_id]
	,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and b.[key] = 'licenseNumber') as licenseNumber
	,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and b.[key] = 'registrationStateProvince') as registrationStateProvince
	,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and b.[key] = 'deliveryDistanceMeasure') as deliveryDistanceMeasure
	,(select [value] from #temp30 b where a.[key_id] = b.[Key_id] and b.[key] = 'vehicle') as vehicle --array
into #temp31
from #temp30 a

-------------------------------------------------------------repairOrderVehicleLineItem.vehicle
IF OBJECT_ID('tempdb..#temp_veh') IS NOT NULL DROP TABLE #temp_veh
select a.id, a.[Key_id], a.[vehicle],b.*
into #temp_veh
from #temp31 a
cross apply OpenJSon([vehicle]) b

IF OBJECT_ID('tempdb..#temp_vehicle') IS NOT NULL DROP TABLE #temp_vehicle
select distinct  id, [Key_id]
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'model') as model
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'model') as modelCode
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'modelYear') as modelYear
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'modelDescription') as modelDescription
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'make') as make
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'saleClassCode') as saleClassCode
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'saleClassDescription') as saleClassDescription
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'condition') as condition --ex:Good
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'vehicleNote') as vehicleNote
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'trimCode') as trimCode
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'doorsQuantityNumeric') as doorsQuantityNumeric
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'bodyStyle') as bodyStyle
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'transmissionCode') as transmissionCode
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'transmissionTypeName') as transmissionTypeName
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'colorGroup') as colorGroup
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'actualOdometer') as actualOdometer
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'inServiceDate') as inServiceDate
	,(select [value] from #temp_veh b where a.[key_id] = b.[Key_id] and b.[key] = 'vehicleId') as vehicleId
into #temp_vehicle

from #temp_veh a


---------------------join ------repairOrderVehicleLineItem.*
--select * from #temp31
--select * from #temp_vehicle
IF OBJECT_ID('tempdb..#ro_veh_line_item') IS NOT NULL DROP TABLE #ro_veh_line_item
select 
		t.id
		,t.[Key_id]
		,licenseNumber
		,registrationStateProvince
		,deliveryDistanceMeasure
		,model
		,modelCode
		,modelYear
		,modelDescription
		,make
		,saleClassCode
		,saleClassDescription
		,condition
		,vehicleNote
		,trimCode
		,doorsQuantityNumeric
		,bodyStyle
		,transmissionCode
		,transmissionTypeName
		,colorGroup
		,actualOdometer
		,inServiceDate
		,vehicleId
into #ro_veh_line_item
from #temp31 t inner join #temp_vehicle v on t.id = v.id and t.[Key_id] = v.[Key_id]
--------------------------------------------------------Arrays not in dummy data
-------------------------------------warranty
IF OBJECT_ID('tempdb..#temp40') IS NOT NULL DROP TABLE #temp40
select a.ID, a.[Key_id], a.warranty, b.* into #temp40

from #temp_ROJsonValues a
CROSS APPLY OPENJSON(warranty) as b


IF OBJECT_ID('tempdb..#temp41') IS NOT NULL DROP TABLE #temp41
select distinct  id, [Key_id]
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and b.[key] = 'warrantyStartDate') as warrantyStartDate
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and b.[key] = 'warrantyExpirationDate') as warrantyExpirationDate
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and b.[key] = 'warrantyStartDistanceMeasure') as warrantyStartDistanceMeasure
	,(select [value] from #temp40 b where a.[key_id] = b.[Key_id] and b.[key] = 'warrantyEndDistanceMeasure') as warrantyEndDistanceMeasure --array
into #temp41
from #temp40 a


----------------------------------serviceContract
IF OBJECT_ID('tempdb..#temp50') IS NOT NULL DROP TABLE #temp50
select a.ID, a.[Key_id], a.serviceContract, b.* into #temp50

from #temp_ROJsonValues a
CROSS APPLY OPENJSON(serviceContract) as b


IF OBJECT_ID('tempdb..#temp51') IS NOT NULL DROP TABLE #temp51
select distinct  id, [Key_id]
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and b.[key] = 'contractCompanyName') as contractCompanyName
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and b.[key] = 'contractId') as contractId
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and b.[key] = 'contractPlanDescription') as contractPlanDescription
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and b.[key] = 'termMeasure') as termMeasure 
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and b.[key] = 'contractStartDate') as contractStartDate
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and b.[key] = 'contractDeductibleAmount') as contractDeductibleAmount
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and b.[key] = 'contractExpirationDate') as contractExpirationDate
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and b.[key] = 'totalContractAmount') as totalContractAmount
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and b.[key] = 'contractStartDistanceMeasure') as contractStartDistanceMeasure
	,(select [value] from #temp50 b where a.[key_id] = b.[Key_id] and b.[key] = 'contractTermDistanceMeasure') as contractTermDistanceMeasure
into #temp51
from #temp50 a

--------------------------------------------------------serviceComponents
IF OBJECT_ID('tempdb..#temp60') IS NOT NULL DROP TABLE #temp60
select a.ID, a.[Key_id], a.[key] as [Key1], b.* into #temp60
from 
(
select a.ID, a.[Key_id], a.serviceComponents, b.*

from #temp_ROJsonValues a
CROSS APPLY OPENJSON(serviceComponents) as b
) as a
CROSS APPLY OPENJSON([value]) as b


IF OBJECT_ID('tempdb..#temp61') IS NOT NULL DROP TABLE #temp61
select distinct  id, [Key_id], [Key1] 
	,(select [value] from #temp60 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'componentTypeCode') as componentTypeCode
	,(select [value] from #temp60 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'pricing') as service_compo_pricing --arrays
into #temp61
from #temp60 a
----------------------------------------serviceComponents.pricing
IF OBJECT_ID('tempdb..#service_compo_pricing') IS NOT NULL DROP TABLE #service_compo_pricing
select a.id, a.[Key_id], a.[Key1], a.[service_compo_pricing]
	,Json_query(b.[value], '$.priceCode') as service_compo_priceCode
	,Json_query(b.[value], '$.chargeAmount') as service_compo_chargeAmount
	,Json_query(b.[value], '$.priceDescription') as service_compo_priceDescription
into #service_compo_pricing
from #temp61 a
cross apply OpenJSon([service_compo_pricing]) b

--------------------------------------------------------------sublet
IF OBJECT_ID('tempdb..#temp70') IS NOT NULL DROP TABLE #temp70
select a.ID, a.[Key_id], a.[key] as [Key1], b.* into #temp70
from 
(
select a.ID, a.[Key_id], a.sublet, b.*

from #temp_ROJsonValues a
CROSS APPLY OPENJSON(sublet) as b
) as a
CROSS APPLY OPENJSON([value]) as b


IF OBJECT_ID('tempdb..#temp71') IS NOT NULL DROP TABLE #temp71
select distinct  id, [Key_id], [Key1] 
	,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'pricing') as sublet_pricing  --array
	,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'subletCode') as subletCode
	,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'subletWorkDescription') as subletWorkDescription
	,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'subletInvoiceNumber') as subletInvoiceNumber
	,(select [value] from #temp70 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'providerName') as providerName
into #temp71
from #temp70 a
-------------------------------------------sublet.pricing
IF OBJECT_ID('tempdb..#sublet_pricing') IS NOT NULL DROP TABLE #sublet_pricing
select a.id, a.[Key_id], a.[Key1], a.[sublet_pricing]
	,Json_query(b.[value], '$.priceCode') as sublet_priceCode
	,Json_query(b.[value], '$.chargeAmount') as sublet_chargeAmount
	,Json_query(b.[value], '$.priceDescription') as sublet_priceDescription
into #sublet_pricing
from #temp71 a
cross apply OpenJSon([sublet_pricing]) b

----------------------------------------------price
IF OBJECT_ID('tempdb..#temp80') IS NOT NULL DROP TABLE #temp80
select a.ID, a.[Key_id], a.[key] as [Key1], b.* into #temp80
from 
(
select a.ID, a.[Key_id], a.price, b.*

from #temp_ROJsonValues a
CROSS APPLY OPENJSON(price) as b
) as a
CROSS APPLY OPENJSON([value]) as b

IF OBJECT_ID('tempdb..#temp81') IS NOT NULL DROP TABLE #temp81
select distinct  id, [Key_id], [Key1] 
	,(select [value] from #temp80 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'priceCode') as priceCode 
	,(select [value] from #temp80 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'chargeAmount') as chargeAmount
	,(select [value] from #temp80 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'priceDescription') as priceDescription
	,(select [value] from #temp80 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'taxType') as taxType
into #temp81
from #temp80 a
----------------------------------------------tax
IF OBJECT_ID('tempdb..#temp90') IS NOT NULL DROP TABLE #temp90
select a.ID, a.[Key_id], a.[key] as [Key1], b.* into #temp90
from 
(
select a.ID, a.[Key_id], a.price, b.*

from #temp_ROJsonValues a
CROSS APPLY OPENJSON(tax) as b
) as a
CROSS APPLY OPENJSON([value]) as b

IF OBJECT_ID('tempdb..#temp91') IS NOT NULL DROP TABLE #temp91
select distinct  id, [Key_id], [Key1] 
	,(select [value] from #temp90 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'taxTypeCode') as taxTypeCode 
	,(select [value] from #temp90 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'taxDescription') as taxDescription
	,(select [value] from #temp90 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'taxAmount') as taxAmount
	,(select [value] from #temp90 b where a.[key_id] = b.[Key_id] and a.[Key1] = b.[key1] and b.[key] = 'taxExemptIndicator') as taxExemptIndicator
into #temp91
from #temp90 a

--------------------------------------------------------join ---------------------------columns not in dummy data

IF OBJECT_ID('tempdb..#join2') IS NOT NULL DROP TABLE #join2

--select * from #temp41
--select * from #temp51
--select * from #temp61
--select * from #service_compo_pricing
--select * from #temp71
--select * from #sublet_pricing
--select * from #temp81
--select * from #temp91

select 
		t4.id
		,t4.[Key_id]
		,warrantyStartDate
		,warrantyExpirationDate
		,warrantyStartDistanceMeasure
		,warrantyEndDistanceMeasure
		,contractCompanyName
		,contractId
		,contractPlanDescription
		,termMeasure
		,contractStartDate
		,contractDeductibleAmount
		,contractExpirationDate
		,totalContractAmount
		,contractStartDistanceMeasure
		,contractTermDistanceMeasure
		,componentTypeCode
		,cp.service_compo_pricing
		,service_compo_priceCode
		,service_compo_chargeAmount
		,service_compo_priceDescription
		,subletCode
		,subletWorkDescription
		,subletInvoiceNumber
		,providerName as sublet_provider_name
		,sp.sublet_pricing
		,sublet_priceCode
		,sublet_chargeAmount
		,sublet_priceDescription
		,priceCode as price_pricecode
		,chargeAmount 
		,priceDescription
		,taxType as price_taxtype
		,taxTypeCode
		,taxDescription
		,taxAmount
		,taxExemptIndicator
	into #join2
from #temp41 t4
inner join #temp51 t5 on t4.id =t5.id and t4.[Key_id]=t5.[Key_id]
left outer join #temp61 t6 on t4.id =t6.id and t4.[Key_id]=t6.[Key_id]
left outer join #service_compo_pricing cp on t4.id =cp.id and t4.[Key_id]=cp.[Key_id]
left outer join #temp71 t7 on t4.id =t7.id and t4.[Key_id]=t7.[Key_id]
left outer join #sublet_pricing sp on t4.id =sp.id and t4.[Key_id]=sp.[Key_id]
left outer join #temp81 t8 on t4.id =t8.id and t4.[Key_id]=t8.[Key_id]
left outer join #temp91 t9 on t4.id =t9.id and t4.[Key_id]=t9.[Key_id]

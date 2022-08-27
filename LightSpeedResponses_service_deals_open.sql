declare @path nvarchar(200) =  'D:\LigtSpeed Responses\Service Details - Opens.txt',
		@sql nvarchar(max),
		@Json nvarchar(max)

	set @sql = 'SELECT @Json = Cast(BulkColumn as nvarchar(max)) FROM OPENROWSET (BULK ''' + @path + ''', SINGLE_CLOB) as import'

	EXEC sp_executesql @sql,N'@Json NVARCHAR(max) output',@Json output;


drop table if exists #ro1
drop table if exists #ro2
drop table if exists #ro3
drop table if exists #parts
drop table if exists #labor


select 
		[key] as Index_id
		,JSON_VALUE([value], '$.Cmf') as Cmf
		,JSON_VALUE([value], '$.ROHeaderID') as ROHeaderID
		,JSON_VALUE([value], '$.rono') as rono
		,JSON_VALUE([value], '$.ROMiscInvoiceID') as ROMiscInvoiceID
		,JSON_VALUE([value], '$.CommonInvoiceID') as CommonInvoiceID
		,JSON_VALUE([value], '$.Rostatus') as Rostatus
		,JSON_VALUE([value], '$.CustID') as CustID
		,JSON_VALUE([value], '$.datein') as datein
		,JSON_VALUE([value], '$.closedate') as closedate
		,JSON_VALUE([value], '$.pudate') as pudate
		,JSON_VALUE([value], '$.lastmodifieddate') as lastmodifieddate
		,JSON_VALUE([value], '$.datecreated') as datecreated
		,JSON_VALUE([value], '$.shopsupply') as shopsupply
		,JSON_VALUE([value], '$.MiscCharge1') as MiscCharge1
		,JSON_VALUE([value], '$.MiscCharge2') as MiscCharge2
		,JSON_VALUE([value], '$.MiscCharge3') as MiscCharge3
		,JSON_VALUE([value], '$.MiscCharge4') as MiscCharge4
		,JSON_VALUE([value], '$.ServiceWriterName') as ServiceWriterName
		,JSON_VALUE([value], '$.ServiceWriterUserName') as ServiceWriterUserName
		,JSON_VALUE([value], '$.ServiceWriterId') as ServiceWriterId
		,JSON_VALUE([value], '$.TotsubCost') as TotsubCost
		,JSON_VALUE([value], '$.TotsubSales') as TotsubSales
		,JSON_VALUE([value], '$.category') as category
		,JSON_VALUE([value], '$.status') as status
		,JSON_VALUE([value], '$.Salestaxwarr') as Salestaxwarr
		,JSON_VALUE([value], '$.Salestaxmu') as Salestaxmu
		,JSON_VALUE([value], '$.Salestaxnw') as Salestaxnw
		,JSON_VALUE([value], '$.Totaltax') as Totaltax
		,JSON_VALUE([value], '$.totalowed') as totalowed
		,JSON_VALUE([value], '$.promiseddate') as promiseddate
		,JSON_QUERY([value], '$.Unit') as Unit
into #ro1
from OpenJson(@Json)


select 
		a.ROHeaderID
		,a.Index_id
		,a.rono
		,JSON_VALUE(b.[value], '$.ROUnitID') as ROUnitID
		,JSON_VALUE(b.[value], '$.VIN') as VIN
		,JSON_VALUE(b.[value], '$.Make') as Make
		,JSON_VALUE(b.[value], '$.Model') as Model
		,JSON_VALUE(b.[value], '$.Year') as Year
		,JSON_VALUE(b.[value], '$.Engineno') as Engineno
		,JSON_VALUE(b.[value], '$.Class') as Class
		,JSON_VALUE(b.[value], '$.Odometer') as Odometer
		,JSON_VALUE(b.[value], '$.StockNumber') as StockNumber
		,JSON_VALUE(b.[value], '$.manufacturer') as manufacturer
		,JSON_VALUE(b.[value], '$.keyboardnumber') as keyboardnumber
		,JSON_QUERY(b.[value], '$.Job') as Job
	into #ro2
from #ro1 a
cross apply OpenJSon(Unit) b


select a.ROHeaderID
		,a.rono
		,a.Index_id
		,JSON_VALUE(b.[value], '$.ROJobID') as ROJobID
		,JSON_VALUE(b.[value], '$.JobDescription') as JobDescription
		,JSON_VALUE(b.[value], '$.JobTitle') as JobTitle
		,JSON_VALUE(b.[value], '$.InternalJob') as InternalJob
		,JSON_VALUE(b.[value], '$.WarrantyJob') as WarrantyJob
		,JSON_VALUE(b.[value], '$.ShopSupply') as ShopSupply
		,JSON_VALUE(b.[value], '$.misccharge1') as misccharge1
		,JSON_VALUE(b.[value], '$.misccharge2') as misccharge2
		,JSON_VALUE(b.[value], '$.misccharge3') as misccharge3
		,JSON_VALUE(b.[value], '$.misccharge4') as misccharge4
		,JSON_VALUE(b.[value], '$.status') as status
		,JSON_VALUE(b.[value], '$.partsonly') as partsonly
		,JSON_VALUE(b.[value], '$.warrantyapproved') as warrantyapproved
		,JSON_VALUE(b.[value], '$.warrantyclaimnumber') as warrantyclaimnumber
		,JSON_VALUE(b.[value], '$.recommendations') as recommendations
		,JSON_VALUE(b.[value], '$.resolution') as resolution
		,JSON_VALUE(b.[value], '$.salestype') as salestype
		,JSON_VALUE(b.[value], '$.technotes') as technotes
		,JSON_VALUE(b.[value], '$.internalwarrantynumber') as internalwarrantynumber
		,JSON_VALUE(b.[value], '$.failuredate') as failuredate
		,JSON_VALUE(b.[value], '$.customercontentioncode') as customercontentioncode
		,JSON_VALUE(b.[value], '$.customercontention') as customercontention
		,JSON_VALUE(b.[value], '$.problemcode') as problemcode
		,JSON_VALUE(b.[value], '$.problemdescription') as problemdescription
		,JSON_VALUE(b.[value], '$.customitem1') as customitem1
		,JSON_VALUE(b.[value], '$.customitem2') as customitem2
		,JSON_VALUE(b.[value], '$.customitem3') as customitem3
		,JSON_VALUE(b.[value], '$.customitem4') as customitem4
		,JSON_VALUE(b.[value], '$.claimamountparts') as claimamountparts
		,JSON_VALUE(b.[value], '$.claimamounthandling') as claimamounthandling
		,JSON_VALUE(b.[value], '$.claimamountlabor') as claimamountlabor
		,JSON_VALUE(b.[value], '$.claimamountsublet') as claimamountsublet
		,JSON_VALUE(b.[value], '$.claimamountfreight') as claimamountfreight
		,JSON_VALUE(b.[value], '$.claimamounttax') as claimamounttax
		,JSON_VALUE(b.[value], '$.claimamounttotal') as claimamounttotal
		,JSON_VALUE(b.[value], '$.partsdeductiblealloc') as partsdeductiblealloc
		,JSON_VALUE(b.[value], '$.subletdeductiblealloc') as subletdeductiblealloc
		,JSON_VALUE(b.[value], '$.handlingdeductiblealloc') as handlingdeductiblealloc
		,JSON_VALUE(b.[value], '$.claimamountdeductible') as claimamountdeductible
		,JSON_VALUE(b.[value], '$.claimamountdeductibletax') as claimamountdeductibletax
		,JSON_VALUE(b.[value], '$.authorizationid') as authorizationid
		,JSON_VALUE(b.[value], '$.auth1') as auth1
		,JSON_VALUE(b.[value], '$.auth2') as auth2
		,JSON_VALUE(b.[value], '$.auth3') as auth3
		,JSON_VALUE(b.[value], '$.auth4') as auth4
		,JSON_VALUE(b.[value], '$.auth5') as auth5
		,JSON_VALUE(b.[value], '$.auth6') as auth6
		,JSON_VALUE(b.[value], '$.auth7') as auth7
		,JSON_VALUE(b.[value], '$.auth8') as auth8
		,JSON_VALUE(b.[value], '$.extrahours1') as extrahours1
		,JSON_VALUE(b.[value], '$.extrahours2') as extrahours2
		,JSON_VALUE(b.[value], '$.extrareason1') as extrareason1
		,JSON_VALUE(b.[value], '$.extrareason2') as extrareason2
		,JSON_VALUE(b.[value], '$.extralabordateclosed') as extralabordateclosed
		,JSON_VALUE(b.[value], '$.previousrepairordernumber') as previousrepairordernumber
		,JSON_VALUE(b.[value], '$.previousinvoicenumber') as previousinvoicenumber
		,JSON_VALUE(b.[value], '$.previousinvoicedate') as previousinvoicedate
		,JSON_VALUE(b.[value], '$.previoushours') as previoushours
		,JSON_VALUE(b.[value], '$.previousodometer') as previousodometer
		,JSON_VALUE(b.[value], '$.claimtype') as claimtype
		,JSON_VALUE(b.[value], '$.warrantystatus') as warrantystatus
		,JSON_VALUE(b.[value], '$.isnonusmodel') as isnonusmodel
		,JSON_VALUE(b.[value], '$.failedpartnumber') as failedpartnumber
		,JSON_VALUE(b.[value], '$.carriernumber') as carriernumber
		,JSON_VALUE(b.[value], '$.carrierinvoicenumber') as carrierinvoicenumber
		,JSON_VALUE(b.[value], '$.carrierinvoicedate') as carrierinvoicedate
		,JSON_VALUE(b.[value], '$.carrierdatefiled') as carrierdatefiled
		,JSON_VALUE(b.[value], '$.controlsequencenumber') as controlsequencenumber
		,JSON_VALUE(b.[value], '$.reasonfordelay') as reasonfordelay
		,JSON_VALUE(b.[value], '$.actiontaken') as actiontaken
		,JSON_QUERY(b.[value], '$.Parts') as Parts
		,JSON_QUERY(b.[value], '$.Labor') as Labor
	into #ro3
from #ro2 a
cross apply OpenJson(Job) b 



select 
		 a.ROHeaderID
		,a.rono
		,a.Index_id
		,JSON_VALUE(b.[value], '$.ROPartID') as ROPartID
		,JSON_VALUE(b.[value], '$.PartNumber') as PartNumber
		,JSON_VALUE(b.[value], '$.PartDescription') as PartDescription
		,JSON_VALUE(b.[value], '$.SourceCode') as SourceCode
		,JSON_VALUE(b.[value], '$.Qty') as Qty
		,JSON_VALUE(b.[value], '$.requestedqty') as requestedqty
		,JSON_VALUE(b.[value], '$.specialorderqty') as specialorderqty
		,JSON_VALUE(b.[value], '$.Cost') as Cost
		,JSON_VALUE(b.[value], '$.Price') as Price
		,JSON_VALUE(b.[value], '$.ExtPrice') as ExtPrice
		,JSON_VALUE(b.[value], '$.DiscountPrice') as DiscountPrice
	into #parts
from #ro3 a 
cross apply OpenJson(Parts) b

select 
		 a.ROHeaderID
		,a.rono
		,a.Index_id
		,JSON_VALUE(b.[value], '$.ROLaborID') as ROLaborID
		,JSON_VALUE(b.[value], '$.JobDescription') as JobDescription
		,JSON_VALUE(b.[value], '$.Hours') as Hours
		,JSON_VALUE(b.[value], '$.Rate') as Rate
		,JSON_VALUE(b.[value], '$.Total') as Total
		,JSON_VALUE(b.[value], '$.Actualhours') as Actualhours
		,JSON_VALUE(b.[value], '$.TechnicianName') as TechnicianName
		,JSON_VALUE(b.[value], '$.technicianusername') as technicianusername
		,JSON_VALUE(b.[value], '$.technicianid') as technicianid
		,JSON_VALUE(b.[value], '$.jobcode') as jobcode
		,JSON_VALUE(b.[value], '$.DiscountTotalCharge') as DiscountTotalCharge
		,JSON_VALUE(b.[value], '$.TotalCharge') as TotalCharge
		,JSON_VALUE(b.[value], '$.technicianrate') as technicianrate
		,JSON_VALUE(b.[value], '$.closetime') as closetime
	into #labor
from #ro3 a 
cross apply OpenJson(Labor) b


--select * from #labor


select
		 a.Index_id
		,a.Cmf
		,a.ROHeaderID
		,a.rono
		,a.ROMiscInvoiceID
		,a.CommonInvoiceID
		,a.Rostatus
		,a.CustID
		,a.datein
		,a.closedate
		,a.pudate
		,a.lastmodifieddate
		,a.datecreated
		,a.shopsupply
		,a.MiscCharge1
		,a.MiscCharge2
		,a.MiscCharge3
		,a.MiscCharge4
		,a.ServiceWriterName
		,a.ServiceWriterUserName
		,a.ServiceWriterId
		,a.TotsubCost
		,a.TotsubSales
		,a.category
		,a.status
		,a.Salestaxwarr
		,a.Salestaxmu
		,a.Salestaxnw
		,a.Totaltax
		,a.totalowed
		,a.promiseddate
		,b.ROUnitID
		,b.VIN
		,b.Make
		,b.Model
		,b.Year
		,b.Engineno
		,b.Class
		,b.Odometer
		,b.StockNumber
		,b.manufacturer
		,b.keyboardnumber
		,c.ROJobID
		,c.JobDescription --
		,c.JobTitle
		,c.InternalJob
		,c.WarrantyJob
		,c.ShopSupply as job_ShopSupply
		,c.misccharge1 as job_misccharge1
		,c.misccharge2 as job_misccharge2
		,c.misccharge3 as job_misccharge3
		,c.misccharge4 as job_misccharge4
		,c.status as job_status
		,c.partsonly
		,c.warrantyapproved
		,c.warrantyclaimnumber
		,c.recommendations
		,c.resolution
		,c.salestype
		,c.technotes
		,c.internalwarrantynumber
		,c.failuredate
		,c.customercontentioncode
		,c.customercontention
		,c.problemcode
		,c.problemdescription
		,c.customitem1
		,c.customitem2
		,c.customitem3
		,c.customitem4
		,c.claimamountparts
		,c.claimamounthandling
		,c.claimamountlabor
		,c.claimamountsublet
		,c.claimamountfreight
		,c.claimamounttax
		,c.claimamounttotal
		,c.partsdeductiblealloc
		,c.subletdeductiblealloc
		,c.handlingdeductiblealloc
		,c.claimamountdeductible
		,c.claimamountdeductibletax
		,c.authorizationid
		,c.auth1
		,c.auth2
		,c.auth3
		,c.auth4
		,c.auth5
		,c.auth6
		,c.auth7
		,c.auth8
		,c.extrahours1
		,c.extrahours2
		,c.extrareason1
		,c.extrareason2
		,c.extralabordateclosed
		,c.previousrepairordernumber
		,c.previousinvoicenumber
		,c.previousinvoicedate
		,c.previoushours
		,c.previousodometer
		,c.claimtype
		,c.warrantystatus
		,c.isnonusmodel
		,c.failedpartnumber
		,c.carriernumber
		,c.carrierinvoicenumber
		,c.carrierinvoicedate
		,c.carrierdatefiled
		,c.controlsequencenumber
		,c.reasonfordelay
		,c.actiontaken
		,p.ROPartID
		,p.PartNumber
		,p.PartDescription
		,p.SourceCode
		,p.Qty
		,p.requestedqty
		,p.specialorderqty
		,p.Cost
		,p.Price
		,p.ExtPrice
		,p.DiscountPrice
		,l.ROLaborID
		,l.JobDescription as labor_jobdescription
		,l.Hours
		,l.Rate
		,l.Total
		,l.Actualhours
		,l.TechnicianName
		,l.technicianusername
		,l.technicianid
		,l.jobcode
		,l.DiscountTotalCharge
		,l.TotalCharge
		,l.technicianrate
		,l.closetime


	into #service_details_opens
from #ro1 a
left outer join #ro2 b on a.Index_id = b.Index_id and a.ROHeaderID = b.ROHeaderID and a.rono = b.rono
left outer join #ro3 c on a.Index_id = c.Index_id and a.ROHeaderID = c.ROHeaderID and a.rono = c.rono
left outer join #parts p on a.Index_id = p.Index_id and a.ROHeaderID = p.ROHeaderID and a.rono = p.rono
left outer join #labor l on a.Index_id = l.Index_id and a.ROHeaderID = l.ROHeaderID and a.rono = l.rono


select * from #service_details_opens

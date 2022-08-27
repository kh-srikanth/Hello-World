declare @path nvarchar(200) =  'D:\LigtSpeed Responses\Deals Details.txt',
		@sql nvarchar(max),
		@Json nvarchar(max)

	set @sql = 'SELECT @Json = Cast(BulkColumn as nvarchar(max)) FROM OPENROWSET (BULK ''' + @path + ''', SINGLE_CLOB) as import'

	EXEC sp_executesql @sql,N'@Json NVARCHAR(max) output',@Json output;

	drop table if exists #temp

	select 
			[key] as Index_id
			,JSON_VALUE([value], '$.Cmf') as Cmf
			,JSON_VALUE([value], '$.DealNo') as DealNo
			,JSON_VALUE([value], '$.FinInvoiceId') as FinInvoiceId
			,JSON_VALUE([value], '$.CommonInvoiceID') as CommonInvoiceID
			,JSON_VALUE([value], '$.FinanceDate') as FinanceDate
			,JSON_VALUE([value], '$.OriginatingDate') as OriginatingDate
			,JSON_VALUE([value], '$.DeliveryDate') as DeliveryDate
			,JSON_VALUE([value], '$.lastmodifieddate') as lastmodifieddate
			,JSON_VALUE([value], '$.salesmanid') as salesmanid
			,JSON_VALUE([value], '$.clpremium') as clpremium
			,JSON_VALUE([value], '$.clcost') as clcost
			,JSON_VALUE([value], '$.sourcetype') as sourcetype
			,JSON_VALUE([value], '$.ahpremium') as ahpremium
			,JSON_VALUE([value], '$.ahcost') as ahcost
			,JSON_VALUE([value], '$.CustID') as CustID
			,JSON_VALUE([value], '$.lienholder') as lienholder
			,JSON_VALUE([value], '$.AmtFinanced') as AmtFinanced
			,JSON_VALUE([value], '$.Term') as Term
			,JSON_VALUE([value], '$.Rate') as Rate
			,JSON_VALUE([value], '$.Payment') as Payment
			,JSON_VALUE([value], '$.totaldownpayment') as totaldownpayment
			,JSON_VALUE([value], '$.fincharge') as fincharge
			,JSON_VALUE([value], '$.fincost') as fincost
			,JSON_VALUE([value], '$.DaysToFirst') as DaysToFirst
			,JSON_VALUE([value], '$.SalesmanName') as SalesmanName
			,JSON_VALUE([value], '$.lienaddressfirstline') as lienaddressfirstline
			,JSON_VALUE([value], '$.lienaddresssecondline') as lienaddresssecondline
			,JSON_VALUE([value], '$.liencity') as liencity
			,JSON_VALUE([value], '$.lienzip') as lienzip
			,JSON_VALUE([value], '$.lienstate') as lienstate
			,JSON_VALUE([value], '$.cobuyercustid') as cobuyercustid
			,JSON_VALUE([value], '$.cobuyername') as cobuyername
			,JSON_VALUE([value], '$.cobuyeraddr') as cobuyeraddr
			,JSON_VALUE([value], '$.cobuyeraddr2') as cobuyeraddr2
			,JSON_VALUE([value], '$.cobuyercity') as cobuyercity
			,JSON_VALUE([value], '$.cobuyerstate') as cobuyerstate
			,JSON_VALUE([value], '$.cobuyerzip') as cobuyerzip
			,JSON_VALUE([value], '$.cobuyercounty') as cobuyercounty
			,JSON_VALUE([value], '$.cobuyerhomephone') as cobuyerhomephone
			,JSON_VALUE([value], '$.cobuyerworkphone') as cobuyerworkphone
			,JSON_VALUE([value], '$.cobuyercellphone') as cobuyercellphone
			,JSON_VALUE([value], '$.cobuyeremail') as cobuyeremail
			,JSON_VALUE([value], '$.stagename') as stagename
			,JSON_VALUE([value], '$.source') as source
			,JSON_VALUE([value], '$.cobuyerbirthdate') as cobuyerbirthdate
			,JSON_VALUE([value], '$.Salesman2name') as Salesman2name
			,JSON_VALUE([value], '$.Salesman2id') as Salesman2id
			,JSON_VALUE([value], '$.Salesmanfi1id') as Salesmanfi1id
			,JSON_VALUE([value], '$.Salesmanfi1name') as Salesmanfi1name
			,JSON_VALUE([value], '$.Salesmanfi2id') as Salesmanfi2id
			,JSON_VALUE([value], '$.Salesmanfi2name') as Salesmanfi2name
			,JSON_VALUE([value], '$.Fincostoverride') as Fincostoverride
			,JSON_VALUE([value], '$.Salesman1split') as Salesman1split
			,JSON_VALUE([value], '$.Salestaxtotal') as Salestaxtotal
			,JSON_VALUE([value], '$.Vehicletaxtotal') as Vehicletaxtotal
			,JSON_VALUE([value], '$.Insurancetaxtotal') as Insurancetaxtotal
			,JSON_VALUE([value], '$.totalcashprice') as totalcashprice
			,JSON_VALUE([value], '$.totalprevpymt') as totalprevpymt
			,JSON_VALUE([value], '$.additionalpymttoday') as additionalpymttoday
			,JSON_VALUE([value], '$.deferredamt') as deferredamt
			,JSON_VALUE([value], '$.extra1amt') as extra1amt
			,JSON_VALUE([value], '$.balancetofinance') as balancetofinance
			,JSON_VALUE([value], '$.totalofpayments') as totalofpayments
			,JSON_VALUE([value], '$.addonrate') as addonrate
			,JSON_VALUE([value], '$.aprbuyrate') as aprbuyrate
			,JSON_VALUE([value], '$.addonbuyrate') as addonbuyrate
			,JSON_VALUE([value], '$.balloonterm') as balloonterm
			,JSON_VALUE([value], '$.balloonpayment') as balloonpayment
			,JSON_VALUE([value], '$.ahprice') as ahprice
			,JSON_VALUE([value], '$.clprice') as clprice
			,JSON_VALUE([value], '$.ins1amt') as ins1amt
			,JSON_VALUE([value], '$.ins1cost') as ins1cost
			,JSON_VALUE([value], '$.ins2amt') as ins2amt
			,JSON_VALUE([value], '$.ins2cost') as ins2cost
			,JSON_VALUE([value], '$.ins3amt') as ins3amt
			,JSON_VALUE([value], '$.ins3cost') as ins3cost
			,JSON_VALUE([value], '$.ins4amt') as ins4amt
			,JSON_VALUE([value], '$.ins4cost') as ins4cost
			,JSON_VALUE([value], '$.ins5amt') as ins5amt
			,JSON_VALUE([value], '$.ins5cost') as ins5cost
			,JSON_VALUE([value], '$.ins6amt') as ins6amt
			,JSON_VALUE([value], '$.ins6cost') as ins6cost
			,JSON_VALUE([value], '$.insurancetaxtotal') as insurancetaxtotal_2
			,JSON_VALUE([value], '$.femargin') as femargin
			,JSON_VALUE([value], '$.bemargin') as bemargin
			,JSON_VALUE([value], '$.createdate') as createdate
			,JSON_VALUE([value], '$.customerextraline') as customerextraline
			,JSON_VALUE([value], '$.customernotes') as customernotes
			,JSON_VALUE([value], '$.salesmanusername') as salesmanusername
			,JSON_VALUE([value], '$.fincostoverride') as fincostoverride_2
			,JSON_VALUE([value], '$.isfincostoverride') as isfincostoverride
			,JSON_VALUE([value], '$.firstlienaddressfirstline') as firstlienaddressfirstline
			,JSON_VALUE([value], '$.firstlienaddresssecondline') as firstlienaddresssecondline
			,JSON_VALUE([value], '$.firstliencity') as firstliencity
			,JSON_VALUE([value], '$.firstlienzip') as firstlienzip
			,JSON_VALUE([value], '$.firstlienstate') as firstlienstate
			,JSON_VALUE([value], '$.salestaxtotal') as salestaxtotal_2
			,JSON_VALUE([value], '$.vehicletaxtotal') as vehicletaxtotal_2
			,JSON_VALUE([value], '$.salesagent1') as salesagent1
			,JSON_VALUE([value], '$.salesagent2') as salesagent2
			,JSON_VALUE([value], '$.salesagent3') as salesagent3
			,JSON_VALUE([value], '$.salesmanager') as salesmanager
			,JSON_VALUE([value], '$.dealdescription') as dealdescription
			,JSON_QUERY([value], '$.Units') as Units
			,JSON_QUERY([value], '$.Trade') as Trade
			,JSON_QUERY([value], '$.DealExtraLines') as DealExtraLines
			,JSON_QUERY([value], '$.DealProspect') as DealProspect

	into #temp
	from OpenJson(@Json)

	select * from #temp
USE [clictell_auto_etl]
GO
/****** Object:  Table [etl].[cdkLgt_customer]    Script Date: 1/27/2022 12:47:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [etl].[cdkLgt_customer](
	[cdkl_customer_id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [varchar](50) NULL,
	[storename] [varchar](100) NULL,
	[DateGathered] [varchar](50) NULL,
	[CustFullName] [varchar](500) NULL,
	[FirstName] [varchar](200) NULL,
	[MIddleName] [varchar](200) NULL,
	[LastName] [varchar](200) NULL,
	[attention] [varchar](500) NULL,
	[Companyname] [varchar](100) NULL,
	[Address1] [varchar](300) NULL,
	[Address2] [varchar](300) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Zip] [varchar](50) NULL,
	[County] [varchar](50) NULL,
	[Country] [varchar](50) NULL,
	[HomePhone] [varchar](100) NULL,
	[WorkPhone] [varchar](100) NULL,
	[CellPhone] [varchar](100) NULL,
	[EMail] [varchar](100) NULL,
	[Birthdate] [varchar](50) NULL,
	[HasDriversLicenseNumber] [varchar](10) NULL,
	[LoyaltyCustomer] [varchar](10) NULL,
	[CustomerType] [varchar](50) NULL,
	[optoutmarketing] [varchar](10) NULL,
	[optoutsharedata] [varchar](10) NULL,
	[optoutselldata] [varchar](10) NULL,
	[removepersonalinformation] [varchar](10) NULL,
	[cmf] [varchar](50) NULL,
	[is_deleted] [bit] NULL,
	[src_dealer_code] [varchar](50) NULL,
	[parent_dealer_id] [int] NULL,
	[file_process_id] [int] NULL,
	[file_process_detail_id] [int] NULL,
	[created_dt] [datetime] NULL,
	[updated_dt] [datetime] NULL,
	[created_by] [varchar](100) NULL,
	[updated_by] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [etl].[cdkLgt_Deals_Details]    Script Date: 1/27/2022 12:47:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [etl].[cdkLgt_Deals_Details](
	[cdkl_sales_id] [int] IDENTITY(1,1) NOT NULL,
	[Cmf] [varchar](50) NULL,
	[DealerId] [varchar](50) NULL,
	[DealNo] [varchar](20) NULL,
	[FinInvoiceId] [varchar](30) NULL,
	[CommonInvoiceID] [varchar](30) NULL,
	[FinanceDate] [varchar](30) NULL,
	[OriginatingDate] [varchar](30) NULL,
	[DeliveryDate] [varchar](30) NULL,
	[lastmodifieddate] [varchar](30) NULL,
	[salesmanid] [varchar](30) NULL,
	[clpremium] [varchar](20) NULL,
	[clcost] [varchar](20) NULL,
	[sourcetype] [varchar](20) NULL,
	[ahpremium] [varchar](20) NULL,
	[ahcost] [varchar](20) NULL,
	[CustID] [varchar](20) NULL,
	[lienholder] [varchar](500) NULL,
	[AmtFinanced] [varchar](20) NULL,
	[Term] [varchar](20) NULL,
	[Rate] [varchar](20) NULL,
	[Payment] [varchar](20) NULL,
	[totaldownpayment] [varchar](20) NULL,
	[fincharge] [varchar](20) NULL,
	[fincost] [varchar](20) NULL,
	[DaysToFirst] [varchar](20) NULL,
	[SalesmanName] [varchar](200) NULL,
	[lienaddressfirstline] [varchar](300) NULL,
	[lienaddresssecondline] [varchar](300) NULL,
	[liencity] [varchar](30) NULL,
	[lienzip] [varchar](30) NULL,
	[lienstate] [varchar](30) NULL,
	[cobuyercustid] [varchar](30) NULL,
	[cobuyername] [varchar](300) NULL,
	[cobuyeraddr] [varchar](200) NULL,
	[cobuyeraddr2] [varchar](200) NULL,
	[cobuyercity] [varchar](30) NULL,
	[cobuyerstate] [varchar](30) NULL,
	[cobuyerzip] [varchar](30) NULL,
	[cobuyercounty] [varchar](30) NULL,
	[cobuyerhomephone] [varchar](30) NULL,
	[cobuyerworkphone] [varchar](30) NULL,
	[cobuyercellphone] [varchar](30) NULL,
	[cobuyeremail] [varchar](100) NULL,
	[stagename] [varchar](300) NULL,
	[source] [varchar](300) NULL,
	[cobuyerbirthdate] [varchar](30) NULL,
	[Salesman2name] [varchar](200) NULL,
	[Salesman2id] [varchar](30) NULL,
	[Salesmanfi1id] [varchar](30) NULL,
	[Salesmanfi1name] [varchar](200) NULL,
	[Salesmanfi2id] [varchar](30) NULL,
	[Salesmanfi2name] [varchar](200) NULL,
	[Fincostoverride] [varchar](10) NULL,
	[Salesman1split] [varchar](30) NULL,
	[Salestaxtotal] [varchar](50) NULL,
	[Vehicletaxtotal] [varchar](50) NULL,
	[Insurancetaxtotal] [varchar](50) NULL,
	[totalcashprice] [varchar](50) NULL,
	[totalprevpymt] [varchar](50) NULL,
	[additionalpymttoday] [varchar](50) NULL,
	[deferredamt] [varchar](50) NULL,
	[extra1amt] [varchar](50) NULL,
	[balancetofinance] [varchar](50) NULL,
	[totalofpayments] [varchar](50) NULL,
	[addonrate] [varchar](50) NULL,
	[aprbuyrate] [varchar](50) NULL,
	[addonbuyrate] [varchar](50) NULL,
	[balloonterm] [varchar](50) NULL,
	[balloonpayment] [varchar](50) NULL,
	[ahprice] [varchar](20) NULL,
	[clprice] [varchar](20) NULL,
	[ins1amt] [varchar](20) NULL,
	[ins1cost] [varchar](20) NULL,
	[ins2amt] [varchar](20) NULL,
	[ins2cost] [varchar](20) NULL,
	[ins3amt] [varchar](20) NULL,
	[ins3cost] [varchar](20) NULL,
	[ins4amt] [varchar](20) NULL,
	[ins4cost] [varchar](20) NULL,
	[ins5amt] [varchar](20) NULL,
	[ins5cost] [varchar](20) NULL,
	[ins6amt] [varchar](20) NULL,
	[ins6cost] [varchar](20) NULL,
	[insurancetaxtotal_2] [varchar](20) NULL,
	[femargin] [varchar](20) NULL,
	[bemargin] [varchar](20) NULL,
	[createdate] [varchar](50) NULL,
	[customerextraline] [varchar](2000) NULL,
	[customernotes] [varchar](max) NULL,
	[salesmanusername] [varchar](100) NULL,
	[fincostoverride_2] [varchar](50) NULL,
	[isfincostoverride] [varchar](50) NULL,
	[firstlienaddressfirstline] [varchar](200) NULL,
	[firstlienaddresssecondline] [varchar](200) NULL,
	[firstliencity] [varchar](50) NULL,
	[firstlienzip] [varchar](50) NULL,
	[firstlienstate] [varchar](50) NULL,
	[salestaxtotal_2] [varchar](50) NULL,
	[vehicletaxtotal_2] [varchar](50) NULL,
	[salesagent1] [varchar](100) NULL,
	[salesagent2] [varchar](100) NULL,
	[salesagent3] [varchar](100) NULL,
	[salesmanager] [varchar](100) NULL,
	[dealdescription] [varchar](2000) NULL,
	[Units] [varchar](max) NULL,
	[Trade] [varchar](max) NULL,
	[DealExtraLines] [varchar](max) NULL,
	[DealProspect] [varchar](max) NULL,
	[src_dealer_code] [varchar](50) NULL,
	[parent_dealer_id] [int] NULL,
	[is_deleted] [bit] NULL,
	[file_process_id] [int] NULL,
	[file_process_detail_id] [int] NULL,
	[created_dt] [datetime] NULL,
	[updated_dt] [datetime] NULL,
	[created_by] [varchar](100) NULL,
	[updated_by] [varchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [etl].[cdkLgt_Service_Details]    Script Date: 1/27/2022 12:47:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [etl].[cdkLgt_Service_Details](
	[cdkl_service_id] [int] IDENTITY(1,1) NOT NULL,
	[file_process_id] [int] NULL,
	[file_process_detail_id] [int] NULL,
	[src_dealer_code] [varchar](50) NULL,
	[parent_dealer_id] [int] NULL,
	[created_dt] [datetime] NULL,
	[updated_dt] [datetime] NULL,
	[created_by] [varchar](100) NULL,
	[updated_by] [varchar](100) NULL,
	[is_deleted] [bit] NULL,
	[ROHeaderID] [varchar](20) NULL,
	[rono] [varchar](20) NULL,
	[ROMiscInvoiceID] [varchar](20) NULL,
	[CommonInvoiceID] [varchar](20) NULL,
	[CustID] [varchar](40) NULL,
	[datein] [varchar](25) NULL,
	[closedate] [varchar](25) NULL,
	[pudate] [varchar](25) NULL,
	[lastmodifieddate] [varchar](50) NULL,
	[datecreated] [varchar](25) NULL,
	[shopsupply] [varchar](20) NULL,
	[MiscCharge1] [varchar](20) NULL,
	[MiscCharge2] [varchar](20) NULL,
	[MiscCharge3] [varchar](20) NULL,
	[MiscCharge4] [varchar](20) NULL,
	[ServiceWriterName] [varchar](200) NULL,
	[ServiceWriterUserName] [varchar](200) NULL,
	[TotsubCost] [varchar](20) NULL,
	[TotsubSales] [varchar](20) NULL,
	[Servicewriterid] [varchar](40) NULL,
	[Salestaxwarr] [varchar](20) NULL,
	[Salestaxmu] [varchar](20) NULL,
	[Salestaxnw] [varchar](20) NULL,
	[Totaltax] [varchar](20) NULL,
	[category] [varchar](50) NULL,
	[totalowed] [varchar](20) NULL,
	[promiseddate] [varchar](25) NULL,
	[unit] [varchar](max) NULL,
	[ROUnitID] [varchar](20) NULL,
	[VIN] [varchar](25) NULL,
	[Make] [varchar](50) NULL,
	[Model] [varchar](50) NULL,
	[Year] [varchar](10) NULL,
	[Engineno] [varchar](30) NULL,
	[Class] [varchar](50) NULL,
	[Odometer] [varchar](20) NULL,
	[StockNumber] [varchar](30) NULL,
	[manufacturer] [varchar](30) NULL,
	[keyboardnumber] [varchar](500) NULL,
	[modelname] [varchar](50) NULL,
	[job] [varchar](max) NULL,
	[Cmf] [varchar](50) NULL,
	[DealerId] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [etl].[cdkLgt_customer] ADD  CONSTRAINT [DF__cdk_l_cus__is_de__2799C73C]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [etl].[cdkLgt_customer] ADD  CONSTRAINT [DF__cdk_l_cus__creat__23C93658]  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [etl].[cdkLgt_customer] ADD  CONSTRAINT [DF__cdk_l_cus__updat__24BD5A91]  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [etl].[cdkLgt_customer] ADD  CONSTRAINT [DF__cdk_l_cus__creat__25B17ECA]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [etl].[cdkLgt_customer] ADD  CONSTRAINT [DF__cdk_l_cus__updat__26A5A303]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [etl].[cdkLgt_Deals_Details] ADD  CONSTRAINT [DF__cdk_l_Dea__is_de__34F3C25A]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [etl].[cdkLgt_Deals_Details] ADD  CONSTRAINT [DF__cdk_l_Dea__creat__31233176]  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [etl].[cdkLgt_Deals_Details] ADD  CONSTRAINT [DF__cdk_l_Dea__updat__321755AF]  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [etl].[cdkLgt_Deals_Details] ADD  CONSTRAINT [DF__cdk_l_Dea__creat__330B79E8]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [etl].[cdkLgt_Deals_Details] ADD  CONSTRAINT [DF__cdk_l_Dea__updat__33FF9E21]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [etl].[cdkLgt_Service_Details] ADD  CONSTRAINT [DF_cdkLgt_Service_Details_created_dt]  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [etl].[cdkLgt_Service_Details] ADD  CONSTRAINT [DF_cdkLgt_Service_Details_updated_dt]  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [etl].[cdkLgt_Service_Details] ADD  CONSTRAINT [DF_cdkLgt_Service_Details_created_by]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [etl].[cdkLgt_Service_Details] ADD  CONSTRAINT [DF_cdkLgt_Service_Details_updated_by]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [etl].[cdkLgt_Service_Details] ADD  CONSTRAINT [DF_cdkLgt_Service_Details_is_deleted]  DEFAULT ((0)) FOR [is_deleted]
GO

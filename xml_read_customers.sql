USE [clictell_auto_etl]
GO
/****** Object:  StoredProcedure [etl].[cdk_etl_service_header_xml]    Script Date: 8/4/2022 2:47:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure  [etl].[dt_customer_xml_loading]     
--declare  
   @file_process_detail_id int   
as   
 /*
 Developer			Role			Date			Desc
 K. Srikanth		Created			8/5/2022		Load Customer data from xml file to etl tables for Dealer Track

 exec [etl].[dt_customer_xml_loading] 2314

 select * from etl.dt_customer (nolock)

 select * from etl.file_process_details (nolock)

 */

BEGIN

declare 
 @flle_path varchar(1000)
,@file_process_id int
,@file_name varchar(100) 
,@xml_main xml
,@xml varchar(max)
,@xml1 varchar(max)
,@xml2 xml
,@parent_dealer_id int 
,@src_dealer_code varchar(20) 


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

	select @xml1 = replace(@xml1,substring(@xml1,charindex('<soap:Envelope',@xml1),charindex('/transitional">',@xml1) + len('/transitional"') ),'<root>')

	select @xml1 = replace(@xml1,substring(@xml1,charindex('</CustomerListResult>',@xml1),charindex('</soap:Envelope>',@xml1)  ),'</root>')

	select @xml2 = convert(xml,@xml1)


	select
			sd.d.value('(CompanyNumber/text())[1]', 'varchar(10)') as CompanyNumber
			,sd.d.value('(CustomerNumber/text())[1]', 'varchar(10)') as CustomerNumber
			,sd.d.value('(TypeCode/text())[1]', 'varchar(10)') as TypeCode
			,sd.d.value('(LastName/text())[1]', 'varchar(10)') as LastName
			,sd.d.value('(FirstName/text())[1]', 'varchar(10)') as FirstName
			,sd.d.value('(MiddleName/text())[1]', 'varchar(10)') as MiddleName
			,sd.d.value('(Salutation/text())[1]', 'varchar(10)') as Salutation
			,sd.d.value('(Gender/text())[1]', 'varchar(10)') as Gender
			,sd.d.value('(Language/text())[1]', 'varchar(10)') as Language
			,sd.d.value('(Address1/text())[1]', 'varchar(10)') as Address1
			,sd.d.value('(Address2/text())[1]', 'varchar(10)') as Address2
			,sd.d.value('(Address3/text())[1]', 'varchar(10)') as Address3
			,sd.d.value('(City/text())[1]', 'varchar(10)') as City
			,sd.d.value('(County/text())[1]', 'varchar(10)') as County
			,sd.d.value('(StateCode/text())[1]', 'varchar(10)') as StateCode
			,sd.d.value('(ZipCode/text())[1]', 'varchar(10)') as ZipCode
			,sd.d.value('(PhoneNumber/text())[1]', 'varchar(10)') as PhoneNumber
			,sd.d.value('(BusinessPhone/text())[1]', 'varchar(10)') as BusinessPhone
			,sd.d.value('(BusinessExt/text())[1]', 'varchar(10)') as BusinessExt
			,sd.d.value('(FaxNumber/text())[1]', 'varchar(10)') as FaxNumber
			,sd.d.value('(BirthDate/text())[1]', 'varchar(10)') as BirthDate
			,sd.d.value('(DriversLicense/text())[1]', 'varchar(10)') as DriversLicense
			,sd.d.value('(Contact/text())[1]', 'varchar(10)') as Contact
			,sd.d.value('(PreferredContact/text())[1]', 'varchar(10)') as PreferredContact
			,sd.d.value('(MailCode/text())[1]', 'varchar(10)') as MailCode
			,sd.d.value('(TaxExmptNumber/text())[1]', 'varchar(10)') as TaxExmptNumber
			,sd.d.value('(CustomerType/text())[1]', 'varchar(10)') as CustomerType
			,sd.d.value('(PreferredPhone/text())[1]', 'varchar(10)') as PreferredPhone
			,sd.d.value('(CellPhone/text())[1]', 'varchar(10)') as CellPhone
			,sd.d.value('(PagePhone/text())[1]', 'varchar(10)') as PagePhone
			,sd.d.value('(OtherPhone/text())[1]', 'varchar(10)') as OtherPhone
			,sd.d.value('(OtherPhoneDesc/text())[1]', 'varchar(10)') as OtherPhoneDesc
			,sd.d.value('(Email1/text())[1]', 'varchar(10)') as Email1
			,sd.d.value('(Email2/text())[1]', 'varchar(10)') as Email2
			,sd.d.value('(OptionalField/text())[1]', 'varchar(10)') as OptionalField
			,sd.d.value('(AllowContactByPostal/text())[1]', 'varchar(10)') as AllowContactByPostal
			,sd.d.value('(AllowContactByPhone/text())[1]', 'varchar(10)') as AllowContactByPhone
			,sd.d.value('(AllowContactByEmail/text())[1]', 'varchar(10)') as AllowContactByEmail
			,sd.d.value('(BusinessPhoneExtension/text())[1]', 'varchar(10)') as BusinessPhoneExtension
			,sd.d.value('(InternationalBusinessPhone/text())[1]', 'varchar(10)') as InternationalBusinessPhone
			,sd.d.value('(InternationalCellPhone/text())[1]', 'varchar(10)') as InternationalCellPhone
			,sd.d.value('(ExternalCrossReferenceKey/text())[1]', 'varchar(10)') as ExternalCrossReferenceKey
			,sd.d.value('(InternationalFaxNumber/text())[1]', 'varchar(10)') as InternationalFaxNumber
			,sd.d.value('(InternationalOtherPhone/text())[1]', 'varchar(10)') as InternationalOtherPhone
			,sd.d.value('(InternationalHomePhone/text())[1]', 'varchar(10)') as InternationalHomePhone
			,sd.d.value('(CustomerPreferredName/text())[1]', 'varchar(10)') as CustomerPreferredName
			,sd.d.value('(InternationalPagerPhone/text())[1]', 'varchar(10)') as InternationalPagerPhone
			,sd.d.value('(PreferredLanguage/text())[1]', 'varchar(10)') as PreferredLanguage
			,sd.d.value('(LastChangeDate/text())[1]', 'varchar(10)') as LastChangeDate
			,sd.d.query('Contacts') as Contacts
			,sd.d.query('Vehicles') as Vehicles
			,sd.d.value('(CCID/text())[1]', 'varchar(10)') as CCID
			,sd.d.value('(CCCD/text())[1]', 'varchar(10)') as CCCD

			into #temp
	from   
		@xml2.nodes('/root/Result') AS sd(d)   



		insert into etl.dt_customer
		(
				 CompanyNumber
				,CustomerNumber
				,TypeCode
				,LastName
				,FirstName
				,MiddleName
				,Salutation
				,Gender
				,Language
				,Address1
				,Address2
				,Address3
				,City
				,County
				,StateCode
				,ZipCode
				,PhoneNumber
				,BusinessPhone
				,BusinessExt
				,FaxNumber
				,BirthDate
				,DriversLicense
				,Contact
				,PreferredContact
				,MailCode
				,TaxExmptNumber
				,CustomerType
				,PreferredPhone
				,CellPhone
				,PagePhone
				,OtherPhone
				,OtherPhoneDesc
				,Email1
				,Email2
				,OptionalField
				,AllowContactByPostal
				,AllowContactByPhone
				,AllowContactByEmail
				,BusinessPhoneExtension
				,InternationalBusinessPhone
				,InternationalCellPhone
				,ExternalCrossReferenceKey
				,InternationalFaxNumber
				,InternationalOtherPhone
				,InternationalHomePhone
				,CustomerPreferredName
				,InternationalPagerPhone
				,PreferredLanguage
				,LastChangeDate
				,Contacts
				,Vehicles
				,CCID
				,CCCD
				,file_process_id
				,file_process_detail_id
				,parent_dealer_id
				,src_dealer_code
		)
		select 
				CompanyNumber
				,CustomerNumber
				,TypeCode
				,LastName
				,FirstName
				,MiddleName
				,Salutation
				,Gender
				,Language
				,Address1
				,Address2
				,Address3
				,City
				,County
				,StateCode
				,ZipCode
				,PhoneNumber
				,BusinessPhone
				,BusinessExt
				,FaxNumber
				,BirthDate
				,DriversLicense
				,Contact
				,PreferredContact
				,MailCode
				,TaxExmptNumber
				,CustomerType
				,PreferredPhone
				,CellPhone
				,PagePhone
				,OtherPhone
				,OtherPhoneDesc
				,Email1
				,Email2
				,OptionalField
				,AllowContactByPostal
				,AllowContactByPhone
				,AllowContactByEmail
				,BusinessPhoneExtension
				,InternationalBusinessPhone
				,InternationalCellPhone
				,ExternalCrossReferenceKey
				,InternationalFaxNumber
				,InternationalOtherPhone
				,InternationalHomePhone
				,CustomerPreferredName
				,InternationalPagerPhone
				,PreferredLanguage
				,LastChangeDate
				,convert(nvarchar(max),Contacts)
				,convert(nvarchar(max),Vehicles)
				,CCID
				,CCCD
				,@file_process_id as file_process_id
				,@file_process_detail_id as file_process_detail_id
				,@parent_dealer_id as parent_dealer_id
				,@src_dealer_code as src_dealer_code
		from #temp

END


















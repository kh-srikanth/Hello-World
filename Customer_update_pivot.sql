use clictell_auto_etl
go

IF OBJECT_ID('tempdb..#temp_customer_communication') IS NOT NULL DROP TABLE #temp_customer_communication
IF OBJECT_ID('tempdb..#privacy') IS NOT NULL DROP TABLE #privacy
IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result
IF OBJECT_ID('tempdb..#home_phone') IS NOT NULL DROP TABLE #home_phone
IF OBJECT_ID('tempdb..#work_phone') IS NOT NULL DROP TABLE #work_phone
IF OBJECT_ID('tempdb..#fax_phone') IS NOT NULL DROP TABLE #fax_phone
IF OBJECT_ID('tempdb..#sms_phone') IS NOT NULL DROP TABLE #sms_phone
IF OBJECT_ID('tempdb..#cell_phone') IS NOT NULL DROP TABLE #cell_phone
IF OBJECT_ID('tempdb..#other_phone') IS NOT NULL DROP TABLE #other_phone
IF OBJECT_ID('tempdb..#personal_email') IS NOT NULL DROP TABLE #personal_email
IF OBJECT_ID('tempdb..#home_email') IS NOT NULL DROP TABLE #home_email
IF OBJECT_ID('tempdb..#cust_id') IS NOT NULL DROP TABLE #cust_id
IF OBJECT_ID('tempdb..#customer_table') IS NOT NULL DROP TABLE #customer_table
IF OBJECT_ID('tempdb..#email_privacy') IS NOT NULL DROP TABLE #email_privacy
IF OBJECT_ID('tempdb..#sms_privacy') IS NOT NULL DROP TABLE #sms_privacy
IF OBJECT_ID('tempdb..#work_phone_privacy') IS NOT NULL DROP TABLE #work_phone_privacy
IF OBJECT_ID('tempdb..#fax_phone_privacy') IS NOT NULL DROP TABLE #fax_phone_privacy
IF OBJECT_ID('tempdb..#cell_phone_privacy') IS NOT NULL DROP TABLE #cell_phone_privacy
IF OBJECT_ID('tempdb..#other_phone_privacy') IS NOT NULL DROP TABLE #other_phone_privacy
IF OBJECT_ID('tempdb..#home_phone_privacy') IS NOT NULL DROP TABLE #home_phone_privacy


select etl_customer_id, customerTypeCode,  OtherID, inceptionDateTime, lastUpdateDateTime
	,JSON_VALUE(b.[value], '$.emailAddress') as emailAddress
	,JSON_VALUE(b.[value], '$.channelType') as channelType
	,JSON_VALUE(b.[value], '$.channelCode') as channelCode
	,JSON_VALUE(b.[value], '$.completeNumber') as completeNumber
	,JSON_Query(b.[value], '$.privacy') as privacy
into #temp_customer_communication
from etl.atm_customer_new a (nolock)
Cross Apply OpenJSon(Isnull(communication, JSon_Query(primaryContact, '$.communication'))) b

--select channelType, channelCode, privacy , count(*) as records
--from #temp_customer_communication /*where privacy is not null*/ group by channelType,channelCode,privacy order by channelType
--select * from etl.atm_customer_new (nolock) order by etl_customer_id
--select * from etl.atm_customer

select  etl_customer_id,channelCode,channelType,completeNumber,emailAddress
	,JSON_VALUE(b.[value], '$.privacyIndicator') as privacy_indicator
	,JSON_VALUE(b.[value], '$.privacyType') as privacy_type
into #privacy
from #temp_customer_communication a (nolock)
Cross Apply OpenJSon(privacy) b

select 
		c.etl_customer_id
		,c.customerTypeCode
		,c.OtherID
		,c.inceptionDateTime
		,c.lastUpdateDateTime
		,c.emailAddress
		,c.channelType
		,c.channelCode
		,c.completeNumber
		,p.privacy_indicator
		,p.privacy_type
	into #result
from #temp_customer_communication c 
left outer join #privacy p on c.etl_customer_id=p.etl_customer_id and c.channelCode=p.channelCode and c.channelType=p.channelType 

--select count(*) from #result where  channelType='Email' and channelCode='Personal' and privacy_indicator is not null --''SMS','Home','Work','Fax','Other' 
--select distinct channelType,channelCode from #result order by channelType

--select count(*) from #temp_customer_communication where privacy is not null
--select count(*) from etl.atm_customer_new (nolock)

	select distinct etl_customer_id, customerTypeCode,OtherID,inceptionDateTime,lastUpdateDateTime
		into #cust_id
	from #result

	select distinct etl_customer_id,
		  (select distinct completeNumber from #result b where a.etl_customer_id = b.etl_customer_id and a.completeNumber=b.completeNumber and  b.[channelType] = 'Phone' and b.channelCode='Home') as home_phone
		into #home_phone
	from #result a			

	select distinct etl_customer_id,
		  (select distinct completeNumber from #result b where a.etl_customer_id = b.etl_customer_id and a.completeNumber=b.completeNumber  and b.[channelType] = 'Phone' and b.channelCode='Work') as work_phone
		into #work_phone
	from #result a			
	
	select distinct etl_customer_id, 
		 (select distinct completeNumber from #result b where a.etl_customer_id = b.etl_customer_id and a.completeNumber=b.completeNumber  and b.[channelType] = 'Phone' and b.channelCode='Fax') as fax_phone
		into #fax_phone
	from #result a			

	select distinct etl_customer_id,	 
		 (select distinct completeNumber from #result b where a.etl_customer_id = b.etl_customer_id and a.completeNumber=b.completeNumber  and b.[channelType] = 'Phone' and b.channelCode='SMS') as sms_phone
		into #sms_phone
	from #result a		

	select distinct etl_customer_id,	 
		 (select distinct completeNumber from #result b where a.etl_customer_id = b.etl_customer_id and a.completeNumber=b.completeNumber  and b.[channelType] = 'Phone' and b.channelCode='Cell') as cell_phone
	into #cell_phone
	from #result a		

	select distinct etl_customer_id, 
		 (select distinct completeNumber from #result b where a.etl_customer_id = b.etl_customer_id and a.completeNumber=b.completeNumber  and b.[channelType] = 'Phone' and b.channelCode='Other') as other_phone
		into #other_phone
	from #result a		


	select distinct etl_customer_id, 
		 (select distinct emailAddress from #result b where a.etl_customer_id = b.etl_customer_id and a.emailAddress=b.emailAddress  and b.[channelType] = 'Email' and b.channelCode='Personal') as personal_email
		into #personal_email
	from #result a

	select distinct etl_customer_id, 
		 (select distinct privacy_indicator from #result b where a.etl_customer_id = b.etl_customer_id and a.privacy_indicator=b.privacy_indicator  and b.[channelType] = 'Email' and b.channelCode='Personal') as email_privacy_indicator,
		 (select distinct privacy_type from #result b where a.etl_customer_id = b.etl_customer_id and a.privacy_type=b.privacy_type  and b.[channelType] = 'Email' and b.channelCode='Personal') as email_privacy_type
		into #email_privacy
	from #result a

	select distinct etl_customer_id, 
		 (select distinct privacy_indicator from #result b where a.etl_customer_id = b.etl_customer_id and a.privacy_indicator=b.privacy_indicator  and b.[channelType] = 'Phone' and b.channelCode='SMS') as sms_privacy_indicator,
		 (select distinct privacy_type from #result b where a.etl_customer_id = b.etl_customer_id and a.privacy_type=b.privacy_type  and b.[channelType] = 'Phone' and b.channelCode='SMS') as sms_privacy_type
		into #sms_privacy
	from #result a

	select distinct etl_customer_id, 
		 (select distinct privacy_indicator from #result b where a.etl_customer_id = b.etl_customer_id and a.privacy_indicator=b.privacy_indicator  and b.[channelType] = 'Phone' and b.channelCode='Work') as work_phone_privacy_indicator,
		 (select distinct privacy_type from #result b where a.etl_customer_id = b.etl_customer_id and a.privacy_type=b.privacy_type  and b.[channelType] = 'Phone' and b.channelCode='Work') as work_phone_privacy_type
		into #work_phone_privacy
	from #result a

		select distinct etl_customer_id, 
		 (select distinct privacy_indicator from #result b where a.etl_customer_id = b.etl_customer_id and a.privacy_indicator=b.privacy_indicator  and b.[channelType] = 'Phone' and b.channelCode='Fax') as fax_phone_privacy_indicator,
		 (select distinct privacy_type from #result b where a.etl_customer_id = b.etl_customer_id and a.privacy_type=b.privacy_type  and b.[channelType] = 'Phone' and b.channelCode='Fax') as fax_phone_privacy_type
		into #fax_phone_privacy
	from #result a

	select distinct etl_customer_id, 
		 (select distinct privacy_indicator from #result b where a.etl_customer_id = b.etl_customer_id and a.privacy_indicator=b.privacy_indicator  and b.[channelType] = 'Phone' and b.channelCode='Cell') as cell_phone_privacy_indicator,
		 (select distinct privacy_type from #result b where a.etl_customer_id = b.etl_customer_id and a.privacy_type=b.privacy_type  and b.[channelType] = 'Phone' and b.channelCode='Cell') as cell_phone_privacy_type
		into #cell_phone_privacy
	from #result a


	select distinct etl_customer_id, 
		 (select distinct privacy_indicator from #result b where a.etl_customer_id = b.etl_customer_id and a.privacy_indicator=b.privacy_indicator  and b.[channelType] = 'Phone' and b.channelCode='Other') as other_phone_privacy_indicator,
		 (select distinct privacy_type from #result b where a.etl_customer_id = b.etl_customer_id and a.privacy_type=b.privacy_type  and b.[channelType] = 'Phone' and b.channelCode='Other') as other_phone_privacy_type
		into #other_phone_privacy
	from #result a

	select distinct etl_customer_id, 
		 (select distinct privacy_indicator from #result b where a.etl_customer_id = b.etl_customer_id and a.privacy_indicator=b.privacy_indicator  and b.[channelType] = 'Phone' and b.channelCode='Home') as home_phone_privacy_indicator,
		 (select distinct privacy_type from #result b where a.etl_customer_id = b.etl_customer_id and a.privacy_type=b.privacy_type  and b.[channelType] = 'Phone' and b.channelCode='Home') as home_phone_privacy_type
		into #home_phone_privacy
	from #result a
	--select * from #email_privacy where email_privacy_indicator is not null

		select	
				 c.etl_customer_id
				,c.customerTypeCode
				,c.OtherID
				,c.inceptionDateTime
				,c.lastUpdateDateTime
				,h.home_phone
				,f.fax_phone 
				,s.sms_phone 
				,w.work_phone
				,cp.cell_phone
				,o.other_phone
				,p.personal_email
				,ep.email_privacy_indicator
				,ep.email_privacy_type
				,sp.sms_privacy_indicator
				,sp.sms_privacy_type
				,wp.work_phone_privacy_indicator
				,wp.work_phone_privacy_type
				,fp.fax_phone_privacy_indicator
				,fp.fax_phone_privacy_type
				,cpp.cell_phone_privacy_indicator
				,cpp.cell_phone_privacy_type
				,op.other_phone_privacy_indicator
				,op.other_phone_privacy_type
				,hpp.home_phone_privacy_indicator
				,hpp.home_phone_privacy_type
				,row_number() over (partition by c.etl_customer_id order by cp.cell_phone,h.home_phone,w.work_phone,o.other_phone) as rnk

			into #customer_table
		from #cust_id c 
			
			left outer join #home_phone h on c.etl_customer_id=h.etl_customer_id and h.home_phone is not null
			left outer join #fax_phone f  on c.etl_customer_id=f.etl_customer_id and f.fax_phone is not null
			left outer join #sms_phone s  on c.etl_customer_id=s.etl_customer_id and s.sms_phone is not null
			left outer join #work_phone w on c.etl_customer_id=w.etl_customer_id and w.work_phone is not null
			left outer join #cell_phone cp on c.etl_customer_id=cp.etl_customer_id and cp.cell_phone is not null
			left outer join #other_phone o on c.etl_customer_id=o.etl_customer_id and o.other_phone is not null
			left outer join #personal_email p on c.etl_customer_id=p.etl_customer_id and p.personal_email is not null
			left outer join #email_privacy ep on c.etl_customer_id=ep.etl_customer_id and ep.email_privacy_type is not null
			left outer join #sms_privacy sp on c.etl_customer_id=sp.etl_customer_id and sp.sms_privacy_type is not null
			left outer join #work_phone_privacy wp on c.etl_customer_id=wp.etl_customer_id and wp.work_phone_privacy_type is not null
			left outer join #fax_phone_privacy fp on c.etl_customer_id=fp.etl_customer_id and fp.fax_phone_privacy_type is not null
			left outer join #cell_phone_privacy cpp on c.etl_customer_id =cpp.etl_customer_id and cpp.cell_phone_privacy_type is not null
			left outer join #other_phone_privacy op on c.etl_customer_id=op.etl_customer_id and op.other_phone_privacy_type is not null
			left outer join #home_phone_privacy hpp on c.etl_customer_id=hpp.etl_customer_id and hpp.home_phone_privacy_type is not null

	
	use clictell_auto_master

	update c set
	--select
			--parent_dealer_id,rnk
			--,c.master_customer_id, t.etl_customer_id
			--,c.cust_dms_number,t.OtherID


			c.cust_email_address1 = iif(t.personal_email is null, c.cust_email_address1, t.personal_email) 
			,c.cust_home_phone = iif((t.home_phone is null and t.cell_phone is null and t.work_phone is null),c.cust_home_phone,replace(t.home_phone,'-','')) 
			,c.cust_mobile_phone =iif((t.home_phone is null and t.cell_phone is null and t.work_phone is null),c.cust_mobile_phone,replace(t.cell_phone,'-','')) 
			,c.cust_work_phone = iif((t.home_phone is null and t.cell_phone is null and t.work_phone is null),replace(t.other_phone,'-',''),replace(t.work_phone,'-','')) 
			,c.cust_fax = replace(t.fax_phone,'-','') 
			,c.cust_do_not_call = iif(t.cell_phone_privacy_type='Dealer',0,iif(t.home_phone_privacy_type='Dealer',0,iif(t.work_phone_privacy_type='Dealer',0,null))) 
			,c.cust_do_not_text = iif(t.sms_privacy_type='Dealer',1,0) 
			,c.cust_do_not_email = iif(t.email_privacy_type='Dealer',1,0) 
	
	from master.customer as c (nolock) 
			inner join #customer_table t on c.cust_dms_number=t.OtherID 
	where rnk=1 and c.parent_dealer_id=1806



	--and cust_dms_number in ('1030113','065449' ,'065805') 
	--order by cust_dms_number
/*
return;


	drop table #temp
	select * from #temp order by cust_dms_number

	
	select * from #temp where home_phone_update is null and cell_phone_update is null and work_phone_update is null and fax_phone_update is null
	and (len(cust_home_phone)>0 or len(cust_mobile_phone)>0)
	order by cust_dms_number


	select * from #cell_phone order by etl_customer_id



	select * from #temp_customer_communication where OtherID ='067799'
	use clictell_auto_etl
	go
	select OtherID,cell_phone ,count(*) from #customer_table  group by OtherID,cell_phone having count(*) >1

	select distinct * from #cell_phone where etl_customer_id in ( select etl_customer_id from #cell_phone where cell_phone is not null group by etl_customer_id having count(etl_customer_id)>1) and cell_phone is not null order by etl_customer_id
	
	select * from #temp_customer_communication where etl_customer_id in  (10185,42169,44471)
	----select * from master.customer (nolock) where parent_dealer_id=1806 order by master_customer_id

	--[{"channelType":"Phone","channelCode":"Cell","completeNumber":"914-934-9420"},{"channelType":"Phone","channelCode":"Cell","completeNumber":"646-725-6086"}]

--return;

--select * from #customer_table   where etl_customer_id=1475
--select * from #temp_customer_communication where etl_customer_id=1475

--select etl_customer_id,count(*) from #temp_customer_communication group by etl_customer_id having count(etl_customer_id)>1 order by count(*) desc


--select distinct channelCode from #temp_customer_communication where channelType ='Email'

			--select * from #result where privacy_indicator is not null



select * from #temp_customer_communication where channelCode='Work' and channelType='Phone' order by etl_customer_id
select * from #temp_customer_communication where channelCode='Fax' and channelType='Phone' order by etl_customer_id 
select * from #temp_customer_communication where channelCode='SMS' and channelType='Phone' order by etl_customer_id 
select * from #temp_customer_communication where channelCode='Cell' and channelType='Phone' order by etl_customer_id 
select * from #temp_customer_communication where channelCode='Home' and channelType='Phone' order by etl_customer_id 
select * from #temp_customer_communication where channelCode='Other' and channelType='Phone' order by etl_customer_id 

select * from #temp_customer_communication where channelCode='Personal' and channelType='Email' order by etl_customer_id 
select * from #temp_customer_communication where channelCode='Home' and channelType='Email' order by etl_customer_id 
select distinct channelType,channelCode from #temp_customer_communication


channelType	channelCode
Phone	Fax
Phone	Work
Phone	Cell
Phone	Other
Phone	Home
Email	Personal
Phone	SMS
*/


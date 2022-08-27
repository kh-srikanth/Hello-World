select count(*) 

from auto_campaigns.email.campaigns (nolock) 
where 
is_Deleted =0 and is_flow_campaign <> 1
and account_id in (select _id from auto_customers.portal.account with (nolock) 
					where accountstatus not in ('inactive') 
					and parentid in ('C994B4F4-666E-446B-9A2F-C4985EBEA150','2FFC0052-6D81-46B5-AD31-E47BBA081346','5FB8E2CB-36CD-48C3-9CC7-03B0414D5013'))

drop table if exists #temp1

select campaign_id,target_audience,name--replace(replace(target_audience,'[',''),']','') as target_audience
into #temp1
from auto_campaigns.email.campaigns (nolock) 
where 
is_Deleted =0 
and is_flow_campaign <> 1
and target_audience <> '[]'
and account_id in (select _id from auto_customers.portal.account with (nolock) 
					where accountstatus not in ('inactive') 
					and parentid in ('C994B4F4-666E-446B-9A2F-C4985EBEA150','2FFC0052-6D81-46B5-AD31-E47BBA081346','5FB8E2CB-36CD-48C3-9CC7-03B0414D5013'))

drop table if exists #temp2
select 
		campaign_id
		,JSON_VALUE([value],'$.Name')  as list_name
		,JSON_VALUE([value],'$.Value')  as list_value
		,name
		into #temp2 
from #temp1 
cross apply openjson(target_audience)  b

drop table if exists #temp3
select 
	* 
into #temp3
from #temp2
where list_name = name


--list_segment_type_id =1 
select * from #temp3
select distinct list_value from #temp3


drop table if exists #seg_value 
select 
	segment_id,segment_query
	into #seg_value
from auto_customers.customer.segments (nolock) 
where 
		segment_id in (select distinct list_value from #temp3)
		and segment_query like '%List Name%'


select 
* 
from #seg_value a
inner join #temp3 b on a.segment_id = b.list_value

select campaign_id,list_segment_type_id,1 
--update a set list_segment_type_id = 1,updated_by = 'sk_list_seg_type_id',updated_dt = getdate()
from auto_campaigns.email.campaigns a (nolock) where campaign_id in (
																				select 
																				campaign_id
																				from #seg_value a
																				inner join #temp3 b on a.segment_id = b.list_value
																				)
																				and isnull(list_segment_type_id,0) <> 1



--drop table if exists #seg_query
--select 
--segment_id,segment_query,replace(replace(JSON_query(segment_query,'$.queries'),'[',''),']','') as queries

--into #seg_query
--from auto_customers.customer.segments (nolock) where segment_id = 5334

--select * from #seg_query






select *
from auto_campaigns.email.campaigns (nolock) 
where 
is_Deleted =0 and is_flow_campaign <> 1
and target_audience = '[]'
and account_id in (select _id from auto_customers.portal.account with (nolock) 
					where accountstatus not in ('inactive') 
					and parentid in ('C994B4F4-666E-446B-9A2F-C4985EBEA150','2FFC0052-6D81-46B5-AD31-E47BBA081346','5FB8E2CB-36CD-48C3-9CC7-03B0414D5013'))


select * 

from [18.216.140.206].[r2r_cm].campaign.campaign a (nolock)
where is_deleted =0 and
media_type = 'email'
and target_audience <> '[]'
and is_r2r_flow =0
and dealer_id in (select r2r_dealer_id from auto_customers.portal.account with (nolock) 
					where accountstatus not in ('inactive') 
					and parentid in ('C994B4F4-666E-446B-9A2F-C4985EBEA150','2FFC0052-6D81-46B5-AD31-E47BBA081346','5FB8E2CB-36CD-48C3-9CC7-03B0414D5013'))
and
campaign_id = 66759

and dealer_id = 2987

select * from auto_campaigns.email.campaigns (nolock) where r2r_campaign_id = 66759


select * from auto_customers.customer.segments (nolock) where  r2r_contactlist_id = 1022
select * from auto_customers.list.lists (nolock) where r2r_custsegment_id = 1022

select * from [18.216.140.206].[r2r_admin].[owner].[contact_list]  a with (nolock) where contact_list_id = 1022
dealer_id = 2936



select * from [18.216.140.206].[r2r_cm].campaign.campaign a (nolock) where campaign_id = 66759

select * from [18.216.140.206].[r2r_admin].[owner].[contact_list]  a with (nolock) where contact_list_id = 1022

select * from auto_customers.portal.account with (nolock) where r2r_dealer_id in (2936,2987)
is_deleted =0 and account_id = '7DB79611-A797-4938-AAC8-F3A887384304'

select * from auto_customers.portal.account with (nolock) where r2r_dealer_id = 2990



select top 10 * from [18.216.140.206].[r2r_cm].campaign.campaign b (nolock)
select top 10 * from auto_campaigns.email.campaigns a (nolock) 
----------------------------------

drop table if exists #temp_target
select a.campaign_id,a.target_audience as new_target_audience,b.target_audience,a.scheduled_date,b.created_dt

into #temp_target
from auto_campaigns.email.campaigns a (nolock) 
inner join [18.216.140.206].[r2r_cm].campaign.campaign b (nolock) on a.r2r_campaign_id  = b.campaign_id
where 
a.is_Deleted =0 and isnull(a.is_flow_campaign,0) <> 1
and a.target_audience = '[]' and b.target_audience <> '[]'
and a.account_id in (select _id from auto_customers.portal.account with (nolock) 
					where accountstatus not in ('inactive') 
					and parentid in ('C994B4F4-666E-446B-9A2F-C4985EBEA150','2FFC0052-6D81-46B5-AD31-E47BBA081346','5FB8E2CB-36CD-48C3-9CC7-03B0414D5013'))


select * from #temp_target


drop table if exists #json1
select 
	 campaign_id
	,target_audience
	,json_value([value],'$.source_type') as source_type
	,replace(replace(json_query([value],'$.criteria'),'[',''),']','') as criteria
	into #json1
from #temp_target
cross apply openjson(target_audience)

select * from #json1

drop table if exists #json2
select 
	 campaign_id
	,target_audience
	,source_type
	,json_value([criteria],'$.value') as contact_list_id
	into #json2
from #json1

select * from #json2 where source_type in ('Contact list','Customer Segments')



select 
		 campaign_id
		,target_audience
		,source_type
		,a.contact_list_id
		,b.customer_id
from #json2 a
inner join auto_customers.customer.customers b (nolock) on a.contact_list_id = b.r2r_customer_id
where 
a.source_type = ('')


select * from [18.216.140.206].[r2r_admin].[owner].[contact_list]  a with (nolock) where  contact_list_id in (select contact_list_id from #json2  where source_type in ('Contact list','Customer Segments'))


select  * from [18.216.140.206].[r2r_admin].[owner].[contact_list]  a with (nolock) order by 1
where contact_list_id in (258433
,259892
,312619
,319648
,320591
)

select * from [18.216.140.206].[r2r_cm].campaign.campaign_items b (nolock) where campaign_media_id = ''

select * from [18.216.140.206].[r2r_cm].campaign.campaign a (nolock) where  campaign_id = 3154
select * from [18.216.140.206].[r2r_cm].campaign.campaign_media d with (nolock) where campaign_id = 3154

use auto_campaigns

drop table if exists #json3
select 
	 campaign_id
	,contact_list_id
	,b.list_id
	,b.list_name
	,concat('{"queries":[{"element":"List Name","operator":"is","secondOperator":"","value":"' , b.list_id , '","match":"","elementTypeId":"13","order":1}]}') as segment_query
	,b.account_id
	into #json3
from #json2 a
inner join auto_customers.list.lists b (nolock) on a.contact_list_id = b.r2r_custsegment_id
where b.is_deleted =0

select * from #json3


insert into auto_customers.[customer].[segments]
	( 
		[account_id],
		[user_id],
		[program_id],
		[segment_name],
		[segment_description],
		[segment_query],
		[is_dynamic],
		[total_count],
		[list_type_id],
		[is_campaign],
		created_by,
		updated_by,
		created_dt,
		updated_dt


	)  
select distinct
	a.account_id
	,null as user_id
	,3 as program_id
	,list_name as segment_name
	,list_name as segment_description
	,segment_query
	,0 as is_dynamic
	,0 as total_count
	,3 as list_type_id
	,1 as is_campaign
	,suser_name()
	,suser_name()
	,getdate()
	,getdate()
from 
#json3 a 




drop table if exists #temp_result
select 

		a.account_id
		,a.campaign_id
		,b.segment_id
		,b.segment_name
	into #temp_result
from #json3 a
inner join auto_customers.[customer].[segments] b on a.account_id = b.account_id and a.list_name = b.segment_name
where 
b.is_deleted =0
and convert(date,b.created_dt) = convert(date,getdate())
and b.created_by = suser_name()


select * from #temp_result a where account_id = 'F0590E45-19AA-4597-A2B5-67553DD7B113'



select 
a.campaign_id
,b.target_audience
,'[{"Type":"Customer Segments","Name":"'+ b.name +'","Value":'+ cast(a.segment_id as varchar(10)) +'}]'
,b.segment_id
,a.segment_id

--update b set 
--b.target_audience
--='[{"Type":"Customer Segments","Name":"'+ b.name +'","Value":'+ cast(a.segment_id as varchar(10)) +'}]'
--,b.segment_id
--=a.segment_id
--,b.list_segment_type_id =1
from #temp_result a
inner join auto_campaigns.email.campaigns b (nolock) on a.campaign_id  = b.campaign_id



select top 10 * from auto_campaigns.email.counts (nolock)

select top 10 * from auto_customers.customer.segments (nolock) where segment_query like '%List Name%'

select top 10 * from auto_campaigns.email.campaigns (nolock) 

{"queries":[{"element":"List Name","operator":"is","secondOperator":"","value":"43","match":"","elementTypeId":"13","order":1}]}



select is_deleted,* from auto_campaigns.email.campaigns (nolock) where campaign_id in (15999
,16135
,16145
,16147
,16669
,16645
,16659
,16781
,16779
,16821
)


select * from auto_customers.portal.account with (nolock) where accountname like 'velocity%'


---------------------------------------------
---------------------------For root accounts

----------------------------------

drop table if exists #temp_target
select a.campaign_id,a.target_audience as new_target_audience,b.target_audience,a.scheduled_date,b.created_dt

into #temp_target
from auto_campaigns.email.campaigns a (nolock) 
inner join [18.216.140.206].[r2r_cm].campaign.campaign b (nolock) on a.r2r_campaign_id  = b.campaign_id
where 
a.is_Deleted =0 and isnull(a.is_flow_campaign,0) <> 1
and a.target_audience = '[]' and b.target_audience <> '[]'
and a.account_id in (select _id from auto_customers.portal.account with (nolock) 
					where accountstatus not in ('inactive') 
					and _id in ('C994B4F4-666E-446B-9A2F-C4985EBEA150','2FFC0052-6D81-46B5-AD31-E47BBA081346','5FB8E2CB-36CD-48C3-9CC7-03B0414D5013'))


select * from #temp_target


drop table if exists #json1
select 
	 campaign_id
	,target_audience
	,json_value([value],'$.source_type') as source_type
	,replace(replace(json_query([value],'$.criteria'),'[',''),']','') as criteria
	into #json1
from #temp_target
cross apply openjson(target_audience)

select * from #json1

drop table if exists #json2
select 
	 campaign_id
	,target_audience
	,source_type
	,json_value([criteria],'$.value') as contact_list_id
	into #json2
from #json1

select * from #json2 where source_type in ('Contact list','Customer Segments')





select * from [18.216.140.206].[r2r_admin].[owner].[contact_list]  a with (nolock) where  contact_list_id in (select contact_list_id from #json2  where source_type in ('Contact list','Customer Segments'))


select  * from [18.216.140.206].[r2r_admin].[owner].[contact_list]  a with (nolock) order by 1
where contact_list_id in (258433
,259892
,312619
,319648
,320591
)

select * from [18.216.140.206].[r2r_cm].campaign.campaign_items b (nolock) where campaign_media_id = ''

select * from [18.216.140.206].[r2r_cm].campaign.campaign a (nolock) where  campaign_id = 3154
select * from [18.216.140.206].[r2r_cm].campaign.campaign_media d with (nolock) where campaign_id = 3154

use auto_campaigns

drop table if exists #json3
select 
	 campaign_id
	,contact_list_id
	,b.list_id
	,b.list_name
	,concat('{"queries":[{"element":"List Name","operator":"is","secondOperator":"","value":"' , b.list_id , '","match":"","elementTypeId":"13","order":1}]}') as segment_query
	,b.account_id
	into #json3
from #json2 a
inner join auto_customers.list.lists b (nolock) on a.contact_list_id = b.r2r_custsegment_id
where b.is_deleted =0

select * from #json3


insert into auto_customers.[customer].[segments]
	( 
		[account_id],
		[user_id],
		[program_id],
		[segment_name],
		[segment_description],
		[segment_query],
		[is_dynamic],
		[total_count],
		[list_type_id],
		[is_campaign],
		created_by,
		updated_by,
		created_dt,
		updated_dt


	)  
select distinct
	a.account_id
	,null as user_id
	,3 as program_id
	,list_name as segment_name
	,list_name as segment_description
	,segment_query
	,0 as is_dynamic
	,0 as total_count
	,3 as list_type_id
	,1 as is_campaign
	,suser_name()
	,suser_name()
	,getdate()
	,getdate()
from 
#json3 a 




drop table if exists #temp_result
select 

		a.account_id
		,a.campaign_id
		,b.segment_id
		,b.segment_name
	into #temp_result
from #json3 a
inner join auto_customers.[customer].[segments] b on a.account_id = b.account_id and a.list_name = b.segment_name
where 
b.is_deleted =0
and convert(date,b.created_dt) = convert(date,getdate())
and b.created_by = suser_name()


select * from #temp_result a where account_id = 'F0590E45-19AA-4597-A2B5-67553DD7B113'



select 
a.campaign_id
,b.target_audience
,'[{"Type":"Customer Segments","Name":"'+ b.name +'","Value":'+ cast(a.segment_id as varchar(10)) +'}]'
,b.segment_id
,a.segment_id

--update b set 
--b.target_audience
--='[{"Type":"Customer Segments","Name":"'+ b.name +'","Value":'+ cast(a.segment_id as varchar(10)) +'}]'
--,b.segment_id
--=a.segment_id
--,b.list_segment_type_id =1
from #temp_result a
inner join auto_campaigns.email.campaigns b (nolock) on a.campaign_id  = b.campaign_id
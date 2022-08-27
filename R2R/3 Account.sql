use r2r_portal
GO


--select * from r2r_portal.portal.dealer (nolock) where dealer_name like '%Smoky%' 
--select * from r2r_portal.portal.dealer (nolock) where dealer_id in (48625, 2990, 2991)
--select * from r2r_portal.portal.dealer_hierarchy (nolock) where dealer_id = 48625
--select * from r2r_portal.portal.dealer_hierarchy (nolock) where parent_dealer_hierarchy_id = 48398


------------------ Step 1
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2
IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3

select 
	  a.dealer_guid
	, a.dealer_name
	, (Case when Is_oem = 1 then 'OEM' else 'Dealer' End) as account_type 
	, a.dealer_phone
	, a.dealer_state_code
	, a.acct_center_code
	, a.dealer_longitude
	, a.dealer_latitude
	, a.dealer_id
	, null as parent_dealer_id
	, Dense_Rank() over (order by a.dealer_name) as rnk
	, 1 as [Level]
	, a.dealer_name as parent_dealer_name
Into #temp
from portal.dealer a (nolock) 
inner join portal.dealer_hierarchy b (nolock) on a.dealer_id = b.dealer_id
where a.is_deleted = 0 and is_oem = 1
and a.dealer_id in (5202, 19204, 21827, 37429, 48885, 44115, 48282, 48428, 48625, 48738, 48839)

select 
	  d.dealer_guid
	, d.dealer_name
	, (Case when d.Is_oem = 1 then 'OEM' else 'Dealer' End) as account_type 
	, d.dealer_phone
	, d.dealer_state_code
	, d.acct_center_code
	, d.dealer_longitude
	, d.dealer_latitude
	, d.dealer_id
	, a.dealer_id as parent_dealer_id
	, Dense_Rank() over (order by a.dealer_name) as rnk
	, 2 as [Level]
	, a.dealer_name as parent_dealer_name
into #temp1
from portal.dealer a (nolock) 
inner join portal.dealer_hierarchy b (nolock) on a.dealer_id = b.dealer_id
inner join portal.dealer_hierarchy c (nolock) on b.dealer_hierarchy_id = c.parent_dealer_hierarchy_id
inner join portal.dealer d (nolock) on c.dealer_id = d.dealer_id
where a.is_deleted = 0 and d.is_deleted = 0 and a.is_oem = 1
and a.dealer_id in (5202, 19204, 21827, 37429, 48885, 44115, 48282, 48428, 48625, 48738, 48839)


select * into #temp2 from #temp
Union
select * from #temp1

select * into #temp3 from #temp2 order by rnk, Level


Insert into #temp3 (dealer_guid, dealer_name, account_type, dealer_phone, dealer_state_code, acct_center_code, dealer_longitude, dealer_latitude, dealer_id, parent_dealer_id, rnk, [level], parent_dealer_name)
select newid(), dealer_name, 'Dealer', dealer_phone, dealer_state_code, acct_center_code, dealer_latitude, dealer_latitude, 0, dealer_id, rnk, 2, parent_dealer_name from #temp3 where rnk in (select rnk from #temp3 group by rnk having count(distinct [Level]) <= 1)

--select * from #temp3 order by rnk, Level

select dealer_guid, dealer_name, account_type, dealer_phone, dealer_state_code, acct_center_code, dealer_longitude, dealer_latitude, dealer_id, parent_dealer_id, rnk, level, parent_dealer_name,
	'Insert into public.r2rdealer_del (dealer_guid, dealer_name, account_type, dealer_phone, dealer_state_code, acct_center_code, dealer_longitude, dealer_latitude, dealer_id, parent_dealer_id, rnk, level, parent_dealer_name) values (' +
	'''' + Cast(dealer_guid as varchar(50)) + ''',' +			
	'''' + dealer_name + ''',' +
	'''' + account_type + ''',' +
	(Case when dealer_phone is not null then '''' + Isnull(Cast(dealer_phone as varchar(50)), 'null') + ''',' else 'null,' end) +
	(Case when dealer_state_code is not null then '''' + Isnull(Cast(dealer_state_code as varchar(50)), 'null') + ''',' else 'null,' end) +
	'''' + acct_center_code + ''',' +
	(Case when dealer_longitude is not null then '''' + Isnull(Cast(dealer_longitude as varchar(50)), 'null') + ''',' else 'null,' end) +
	(Case when dealer_latitude is not null then '''' + Isnull(Cast(dealer_latitude as varchar(50)), 'null') + ''',' else 'null,' end) +
	'''' + Cast(dealer_id  as varchar(50)) + ''',' +
	(Case when parent_dealer_id is not null then '''' + Isnull(Cast(parent_dealer_id as varchar(50)), 'null') + ''',' else 'null,' end) +
	'''' + Cast(rnk  as varchar(50)) + ''',' +
	'''' + Cast([level]  as varchar(50)) + ''',' +
	'''' + parent_dealer_name + ''');'
from #temp3
Order by rnk, [Level]




------------------ Step 2
insert into account 
( _id,accountname, accountstatus, accounttype, createdate, phone, state, updatedate, updatetime, src_dealer_code,r2r_source_id)
select 
cast(dealer_guid as uuid),dealer_name,'active',account_type,current_date ,dealer_phone,dealer_state_code,current_date, current_time, acct_center_code, cast(dealer_id as bigint)
from r2rdealer_del where dealer_id in ('48839','48840')
order by rnk,level
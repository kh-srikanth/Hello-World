drop table if exists #customers
select 
	customer_id
	,src_cust_id
	,primary_phone_number
	,secondary_phone_number
	,primary_email
	,is_deleted
into #customers
from auto_customers.customer.customers (nolock) where account_id = '2928eacc-a39d-4743-bf02-f9689f16e79f'

drop table if exists #vehicles
select 
	vehicle_id
	,a.customer_id
	,vin
	,make
	,model
	,year
	,last_service_date
	,purchase_date
	,a.is_deleted
into #vehicles
from auto_customers.customer.vehicles a (nolock) 
--inner join #customers b on a.customer_id = b.customer_id
where a.account_id  = '2928eacc-a39d-4743-bf02-f9689f16e79f' 



select is_Deleted, count(*) from #vehicles  group by is_deleted with rollup
select is_Deleted, count(*) from #customers group by is_deleted



select * from #vehicles where is_deleted = 1
select * from #customers where customer_id in (select customer_id from #vehicles where is_deleted = 0) and is_deleted =1



select vehicle_id from (
select *
	,row_number() over (partition by vin order by is_deleted asc) as rnk
	, count(*) over (partition by vin) as cc  
from #vehicles 
where 
	vin in (select vin from #vehicles where is_deleted = 1)
) as a 

where rnk =1 and is_deleted =1





select * 
,row_number() over (partition by vin order by last_visit desc) as rnk2
from (
select *
	,row_number() over (partition by vin order by is_deleted) as rnk
	, count(*) over (partition by vin) as cc  
	,case when isnull(last_service_date,1900) >= isnull(purchase_date,1900) then last_service_date else purchase_date end as last_visit
from #vehicles 
where 
	vin in (select vin from #vehicles where is_deleted = 1)
) as a 

where 1=1 





---deleted customers need to be undelete
select customer_id
,(case when primary_phone_number_valid =1 then primary_phone_number 
	 when primary_phone_number_valid = 0  and secondary_phone_number_valid = 1 then secondary_phone_number else '' end) as phone
,primary_email
,is_deleted
from auto_customers.customer.customers (nolock) where customer_id in (
select customer_id from #customers where customer_id in (select customer_id from #vehicles where is_deleted =0) and is_deleted =1 
)


select is_deleted,* from auto_customers.customer.customers (nolock) where primary_phone_number = '4694947821' or secondary_phone_number = '4694947821'

select * from auto_customers.customer.vehicles (nolock) where customer_id in (3603339,3586932,3588741)

select * 
--update a set customer_id = 3603339
from auto_customers.customer.vehicles a (nolock) where vehicle_id in (1527005,1530130,1530894,1535593,1535598)

select *
--update a set is_deleted =1
from auto_customers.customer.customers a (nolock) where customer_id = 3588741







------ETL validation

Use auto_customers--select * from auto_customers.portal.account with (nolock) where account_id = 4538drop table if exists #temp_sales_dataselect a.DealNo, a.CustID, a.DeliveryDate,		JSON_VALUE(b.[value], '$.DealUnitId') as DealUnitId,		JSON_VALUE(b.[value], '$.Newused') as Newused,		JSON_VALUE(b.[value], '$.VIN') as VIN,		JSON_VALUE(b.[value], '$.Make') as Make,		JSON_VALUE(b.[value], '$.Model') as Model,		JSON_VALUE(b.[value], '$.Year') as Year,		JSON_VALUE(b.[value], '$.Class') as Class,		Cast(lastmodifieddate as date) as lastmodifieddate,		Rank() over (partition by DealNo, CustID, JSON_VALUE(b.[value], '$.VIN') order by Cast(Created_dt as datetime) desc) as rnkinto #temp_sales_datafrom [clictell_auto_etl].[etl].[cdkLgt_Deals_Details] a (nolock)cross apply OpenJson(Units) bwhere parent_dealer_id = 4538 drop table if exists #temp_service_dateselect a.RONo, a.CustID, a.closedate, a.pudate, 		(Case when a.closedate != '1000-01-01T00:00:00' then a.closedate else a.pudate end) as ROCloseDate,		JSON_VALUE(b.[value], '$.ROUnitID') as ROUnitID,		JSON_VALUE(b.[value], '$.VIN') as VIN,		JSON_VALUE(b.[value], '$.Make') as Make,		JSON_VALUE(b.[value], '$.Model') as Model,		JSON_VALUE(b.[value], '$.Year') as Year,		JSON_VALUE(b.[value], '$.Class') as Class,		Cast(lastmodifieddate as date) as lastmodifieddate,		Rank() over (partition by RoNo, CustID, JSON_VALUE(b.[value], '$.VIN') order by Cast(Created_dt as datetime) desc) as rnkinto #temp_service_datefrom [clictell_auto_etl].[etl].[cdkLgt_Service_Details] a (nolock)cross apply OpenJson(Unit) bwhere parent_dealer_id = 4538  and a.custID is not nulldrop table if exists #temp_salesservice_dateselect distinct 	a.CustID, a.VIN, a.Make, a.Model, a.[Year] as [ModelYear], a.DealNo, a.DeliveryDate, b.RONO, b.ROCloseDate 	into #temp_salesservice_datefrom #temp_sales_data aleft outer join #temp_service_date b on  a.CustID = b.CustID and a.VIN = b.VINwhere a.rnk = 1Unionselect distinct 	a.CustID, a.VIN, a.Make, a.Model, a.[Year] as [ModelYear], null as DealNo, null as DeliveryDate, a.RONO, a.ROCloseDatefrom #temp_service_date   aleft outer join #temp_sales_data b on  a.CustID = b.CustID and a.VIN = b.VINwhere a.rnk = 1 and b.DealNo is null--6447select distinct vin from (select *,row_number() over (partition by custID,vin order by last_date desc) as cust_vin_rnk		,row_number() over (partition by vin order by last_date desc) as vin_rnkfrom (select 		trim(custID) as custID		,VIN		,make		,model		,modelyear		,case when convert(date,DeliveryDate) >= Convert(date,isnull(ROCloseDate,'01-01-1900')) then convert(date,DeliveryDate) else Convert(date,ROCloseDate) end as last_date		,DeliveryDate		,ROCloseDatefrom #temp_salesservice_date ) as  a) as b where (len(trim(vin)) = 0 or vin_rnk =1)--order by vin   exceptselect distinct vin from #vehicles where is_deleted =0 select 4225 - 4007  --=218select 5799 -  5793 -- = 23select * from #vehicles where vin in ('5Y4AMD8Y4GA100320','5Y4AMH53XLA101031','JYACG27C17A005843'
,'JYACJ15C1DA021681'
,'JYARJ12E66A008766'
,'JYAVM01E6YA019030')select * from #temp_salesservice_date where vin in ('5Y4AMD8Y4GA100320','5Y4AMH53XLA101031','JYACG27C17A005843'
,'JYACJ15C1DA021681'
,'JYARJ12E66A008766'
,'JYAVM01E6YA019030')select * from #customers where src_cust_id in (8420133
,8782112
,1278721
,8828166
,8929012)select distinct * from #temp_sales_data where custID in (8420133
,8782112
,1278721
,8828166
,8929012) and rnk =1select distinct * from #temp_service_date where custID in (8420133
,8782112
,1278721
,8828166
,8929012) and rnk =1select * from [clictell_auto_etl].[etl].[cdkLgt_Deals_Details] a (nolock) where dealno in (4000333
,4000334
,4000335
,4001453
,4002451
,4002451)select * from [clictell_auto_etl].[etl].[cdkLgt_Service_Details] a (nolock) where rono in (307778
,308802
,308832
,308880)--service_data missingfile_process_id = 1934,2379,2380--sales data missingfile_process_id = 1934,2380---trial--4216select custID from (select *,row_number() over (partition by custID,vin order by last_date desc) as cust_vin_rnk		,row_number() over (partition by vin order by last_date desc) as vin_rnkfrom (select 		trim(custID) as custID		,VIN		,make		,model		,modelyear		,case when convert(date,DeliveryDate) >= Convert(date,isnull(ROCloseDate,'01-01-1900')) then convert(date,DeliveryDate) else Convert(date,ROCloseDate) end as last_date		,DeliveryDate		,ROCloseDatefrom #temp_salesservice_date ) as  a) as b where (len(trim(vin)) > 0 and vin_rnk =1)--order by vin   except --4077select customer_id from #vehicles where is_Deleted =0 and len(trim(vin)) > 0select is_Deleted,* from auto_customers.customer.customers (nolock) where src_cust_id  in (8684044
,8782112
,8929012
,8955788
,1278721
,9138232
,9139350
,8420133
,8927396
,9138287
,8847482
,8866082
,9138503
,8999065
,8874713
,9137826
,9138509
,9138337
,9138119
,9138120
,8828166)select * from auto_customers.customer.vehicles (nolock) where customer_id  in(3593388
,3633785
,3633786
,3633787
,3588741
,3607256
,3633789
,3633790
,3633793
,3633794
,3633795
,3633797) order by customer_idselect distinct b.* from #vehicles ainner join #customers b on a.customer_id  = b.customer_idwhere a.is_deleted = 0select is_Deleted, count(*) from #vehicles  group by is_deleted with rollup   --6601
drop table if exists #temp_etlselect distinct * into #temp_etlfrom (select *, rank() over (partition by CustID, Vin order by RoCloseDate desc) as rnk from #temp_salesservice_date ) as awhere a.rnk = 1 return;select * from #temp_etl order by vin
use clictell_auto_etl
go
select count(*) from etl.cdk_servicero_header (nolock) where file_process_id =102
select count(*) from [etl].[cdk_srv_appt_header] (nolock) where file_process_id =102
select count(*) from etl.cdk_ServiceAppontment_header (nolock) where file_process_id =102
select * from etl.file_process_details (nolock) where file_process_id=1
--------------------*******************
select --distinct
ec.CustNo , sc.cust_dms_number
,ec.BlockEMail,sc.cust_do_not_email
,ec.BlockMail,sc.cust_do_not_mail
,ec.BlockPhone,sc.cust_do_not_call
,ec.City,sc.cust_city
,ec.Address,sc.cust_address1
from etl.cdk_customer ec (nolock) inner join clictell_auto_stg.stg.customers sc (nolock) on ec.file_process_id =sc.file_process_id and ec.CustNo=sc.cust_dms_number
where ec.file_process_id =102 and upper(ec.City)<>upper(sc.cust_city)
and (BlockEMail='Y' or BlockMail='Y' or BlockPhone='Y')
--------------------*******************

-- and len(vin)<4

use clictell_auto_stg




select nuo_flag,* from stg.fi_sales (nolock) where file_process_id =102-- and len(vin)<4
select * from stg.service_ro_header (nolock) where file_process_id =102 --and len(vin)<4
select * from stg.service_appts (nolock) where file_process_id =102 --and len(vin)<4
select * from [stg].[customers] (nolock) where file_process_id =1 --and len(vin)<4  --VIN missing for some records from service /appts
select * from stg.vehicle  (nolock) where file_process_id =102 and invalid_vin=1 ---nuo_flag
and (make is null or model is null or model_year is null or vin is null )
and invalid_vin =1
select count(*) from [stg].[service_ro_operations] (nolock) where file_process_id =102 
select count(*) from [stg].[service_ro_parts] (nolock) where file_process_id =102 
select count(*) from [stg].[service_ro_technicians] (nolock) where file_process_id =102 
select count(*) from [stg].[fi_sales_people] (nolock) where file_process_id =102 
select count(*) from [stg].[fi_sales_trade_vehicles] (nolock) where file_process_id =102 

use clictell_auto_master
select top 10 * from master.vehicle (nolock) --where file_process_id =102 
use clictell_auto_stg
select * from stg.vehicle  (nolock) where file_process_id =102  ---nuo_flag

select len('3FAHP08138R16846') --16

use clictell_auto_master
select * from master.dealer (nolock) --where dealer_name like '%green%'

select cust_dms_number, count(cust_dms_number) from master.customer (nolock) where file_process_id=1 group by cust_dms_number having count(cust_dms_number)>1

select distinct a.natural_key,a.cust_dms_number,b.cust_dms_number,a.cust_full_name,b.cust_full_name,a.cust_zip_code,b.cust_zip_code
from clictell_auto_stg.stg.customers a (nolock) inner join clictell_auto_stg.stg.customers b (nolock) 
on a.cust_dms_number=b.cust_dms_number and a.cust_zip_code<>b.cust_zip_code and a.file_process_id=b.file_process_id
and upper(left(a.cust_full_name,1))!=upper(left(b.cust_full_name,1)) 
where a.file_process_id=102 order by a.cust_dms_number


select * from clictell_auto_stg.stg.customers where cust_dms_number ='127545'-- '129644'

use clictell_auto_etl
select src_dealer_code from etl.cdk_customer (nolock)
select * from etl.cdk_servicero_header (nolock)
use clictell_auto_stg
--delete from stg.customers where file_process_id=102

use clictell_auto_etl

select * from etl.cdk_customer

select 
		cust_dms_number,c.CustNo, cust_do_not_call,BlockPhone,cust_do_not_email,BlockEMail
from clictell_auto_stg.stg.customers sc (nolock) 
		inner join clictell_auto_etl.etl.cdk_customer c (nolock) 
on sc.file_process_id=c.file_process_id 
		and sc.cust_dms_number=c.custNo
where c.file_process_id=102 
	and sc.cust_do_not_call<>iif(c.BlockPhone='Y',1,0) 
	and sc.cust_do_not_email<>iif(c.BlockEMail='Y',1,0)
	and sc.cust_do_not_mail<>iif(c.BlockMail='Y',1,0)

	use clictell_auto_stg
	go
select 
		cust_dms_number,c.CustNo, cust_full_name,concat(LastName,MiddleName ,c.FirstName,NameCompany)
		,sc.cust_email_address1,sc.cust_email_address2,sc.cust_work_email_address ,c.Email,c.Email2,c.Email3
		,sc.cust_home_phone,sc.cust_mobile_phone,sc.cust_work_phone
		,c.HomePhone,c.Telephone,c.BusinessPhone
from clictell_auto_stg.stg.customers sc (nolock) 
		inner join clictell_auto_etl.etl.cdk_customer c (nolock) 
on sc.file_process_id=c.file_process_id 
		and sc.cust_dms_number=c.custNo
where len(concat(sc.cust_email_address1,sc.cust_email_address2,sc.cust_work_email_address)) <> len(concat(c.Email,c.Email2,c.Email3))
--len(concat(sc.cust_home_phone,sc.cust_mobile_phone,sc.cust_work_phone))<>len(concat(c.HomePhone,c.Telephone,BusinessPhone)) and len(concat(sc.cust_home_phone,sc.cust_mobile_phone)) <1
--len(sc.cust_email_address1) <> len(c.Email)
--cust_full_name like '%faith%'
84542


select * from stg.customers where file_process_id =102


use clictell_auto_master
select distinct top 1000
a.cust_dms_number,b.cust_dms_number,a.cust_full_name, b.cust_full_name,a.cust_address1,b.cust_address1
,a.cust_city,b.cust_city,a.cust_state_code,b.cust_state_code,a.cust_zip_code
,b.cust_zip_code

from clictell_auto_master.master.customer a (nolock) 
inner join clictell_auto_stg.stg.customers b (nolock) on a.file_process_id =b.file_process_id and a.cust_dms_number =b.cust_dms_number 
where a.file_process_id =102 and a.cust_zip_code<>b.cust_zip_code

select top 1000 * from master.customer (nolock) where file_process_id=102
--delete from master.customer where file_process_id =102

--select c.active_date,* from clictell_auto_stg.stg.customers(nolock) c where cust_dms_number='129644' order by c.active_date
use clictell_auto_master
select c.active_date,* from master.cust_2_vehicle (nolock) c where parent_dealer_id=3407 order by c.active_date


select distinct m.vin,s.vin, m.make,s.make,m.model,s.model,m.model_year,s.model_year,m.body_type,s.body_type

from master.vehicle m (nolock) inner join stg.vehicle s (nolock) on m.file_process_id=s.file_process_id and m.vin = s.vin
where m.file_process_id =102 --and exterior_color_desc is not null
and (m.make<>s.make or m.model<>s.model or m.model_year<>s.model_year or m.body_type<>s.body_type or m.vehicle_mileage<>s.vehicle_mileage)

select count(*) from master.vehicle(nolock) where file_process_id =102
select count(*) from clictell_auto_stg.stg.vehicle (nolock) where file_process_id =102


select * from master.cust_2_vehicle (nolock) where file_process_id =102 --and inactive_date is not null
order by cust_dms_number, vin


select * from clictell_auto_master.master.fi_sales (nolock) where file_process_id =102 order by cust_dms_number, vin

select * from clictell_auto_master.master.repair_order_header (nolock) where file_process_id =102 order by cust_dms_number, vin


select * from clictell_auto_master.master.repair_order_header_detail (nolock) where file_process_id =102 order by ro_number,op_code_sequence,op_code,op_code_desc


select * from clictell_auto_stg.stg.service_ro_operations (nolock) where file_process_id =102 

select SoldHours,* from clictell_auto_etl.etl.cdk_servicero_header



---8-3-2021 file_process_id =1047 and 

use clictell_auto_master
select m.total_customer_cost , e.ROCostCP
from master.repair_order_header m (nolock) 
inner join clictell_auto_etl.etl.cdk_servicero_header e (nolock) on m.natural_key =e.cdk_dealer_code and m.ro_number=e.RONumber
where parent_dealer_id=3407 and m.total_customer_cost <> e.ROCostCP

use clictell_auto_master
go
select 
		c.cust_dms_number,c.master_customer_id
		,min(ro_close_date) as min_ro_dt
		,max(ro_close_date) as max_ro_dt
		,count(*) as cc
		,'Service' as source
into #temp
from master.customer c (nolock) 
inner join master.repair_order_header r (nolock) on c.master_customer_id =r.master_customer_id 

where	c.parent_dealer_id=3407
		and c.is_deleted=0
		and is_smrtstreect_processed=1 
		and is_invalid_mail=1 
group by c.cust_dms_number,c.master_customer_id

union
select 
		c.cust_dms_number,c.master_customer_id
		,min(purchase_date) as min_ro_dt
		,max(purchase_date) as max_ro_dt
		,count(*) as cc
		,'sales' as source
from master.customer c (nolock) 
inner join master.fi_sales r (nolock) on c.master_customer_id =r.master_customer_id 

where	c.parent_dealer_id=3407
		and c.is_deleted=0
		and is_smrtstreect_processed=1 
		and is_invalid_mail=1 

group by c.cust_dms_number,c.master_customer_id
order by min_ro_dt


select * from #temp --order by cust_dms_number, min_ro_dt

where min_ro_dt >=20150101

select * from master.customer (nolock) where parent_dealer_id=3407 and is_smrtstreect_processed=1 and is_invalid_mail=1 order by master_customer_id

select * from master.repair_order_header (nolock) where master_customer_id =150629
select * from master.fi_sales (nolock) where master_customer_id =150629
select * from master.customer (nolock) where master_customer_id =150629

---------------------------------8-16-21
use clictell_Auto_master
go
select * from [master].[campaign_responses] (nolock) where parent_dealer_id=1806


select * from master.dealer (nolock) where parent_dealer_id =1806

select * from master.dealer (nolock) where _id='7113589E-B6E0-11EB-82D4-0A4357799CFA' --Greenwich Honda 1806

select * from master.dealer (nolock) where _id= 'E26CE42E-BD40-11EB-B988-0A4357799CFA' --District E

select * from master.dealer (nolock) where _id= '713B95A3-BD3E-11EB-B976-0A4357799CFA' --Zone5

select * from master.dealer (nolock) where _id= '24BF2DC4-BD3E-11EB-B972-0A4357799CFA' --Eastern

select * from master.dealer (nolock) where _id= '3397D8EA-BD3A-11EB-845D-0A4357799CFA' --Honda

;WITH dealers (parent_dealer_id,parentid,_id)
as
(
select parent_dealer_id,parentid,_id from master.dealer (nolock) where _id='7113589E-B6E0-11EB-82D4-0A4357799CFA'
union all
select c.parent_dealer_id,c.parentid,c._id from dealers c inner join master.dealer d (nolock) on c._id =d.parentid
where 
--c.parentid =d._id
c.parentid ='3397D8EA-BD3A-11EB-845D-0A4357799CFA'

)
select * from dealers

select 
--string_agg(b.parent_dealer_id,',')
c.parent_dealer_id
from master.dealer a(nolock) inner join master.dealer b(nolock) on a._id=b.parentid
inner join master.dealer c(nolock) on b._id=c.parentid
where b._id='3397D8EA-BD3A-11EB-845D-0A4357799CFA'


select _id, dealer_name from master.dealer (nolock) where parentid in
(
select distinct _id,dealer_name from master.dealer (nolock) where parentid in
(
select distinct _id from master.dealer (nolock) where parentid in
(
select distinct _id,dealer_name from master.dealer (nolock) where _id ='24BF2DC4-BD3E-11EB-B972-0A4357799CFA'
)))

declare @parent_id varchar(100)= '7113589E-B6E0-11EB-82D4-0A4357799CFA'
;with dealers (_id,parentid,parent_dealer_id, dealer_name)
as
(
select distinct _id,parentid,parent_dealer_id,dealer_name from master.dealer (nolock) where parentid =@parent_id
union all
select  m._id,m.parentid,m.parent_dealer_id,m.dealer_name from master.dealer m (nolock) inner join dealers d on m.parentid =d._id
and m.parentid is not null

)
select string_agg(cast(parent_dealer_id as varchar(max)),',') as parent_dealer_id   from dealers

declare @dealer_id varchar(max) = (
select string_agg(cast(parent_dealer_id as varchar(max)),',')  from #temp
)
select @dealer_id


select * from master.dealer (nolock) where dealer_name like 'honda'

----Extract all parent_dealer_id under parent_id
declare @parent_id varchar(100)= '3397D8EA-BD3A-11EB-845D-0A4357799CFA'
;with dealers (_id,parentid,parent_dealer_id, dealer_name)
as
(
select distinct _id,parentid,parent_dealer_id,dealer_name from master.dealer (nolock) where _id =@parent_id
union all
select  m._id,m.parentid,m.parent_dealer_id,m.dealer_name from master.dealer m (nolock) inner join dealers d on m.parentid =d._id
and m.parentid is not null

)
select distinct parent_dealer_id,dealer_name   from dealers order by dealer_name





	Declare @parent_dealer_id varchar(500),
	@dealer_name varchar(1000)
	

	select 
	@parent_dealer_id = string_agg(parent_dealer_id,',')
	,@dealer_name = string_agg(account_name,',')
	from master.dealer_mapping (nolock)
	where account_id in (select value from [dbo].[fn_split_string_to_column] (@dealer, ',')) 
	and is_deleted = 0






select * from auto_campaigns.campaign.reports (nolock) where parent_dealer_id=1806

select * from auto_campaigns.flow.flows (nolock)

select * from auto_campaigns.email.campaigns (nolock)
;with ROWCTE as  
   (  
      SELECT @RowNo as ROWNO    
		UNION ALL  
      SELECT  ROWNO+1  
  FROM  ROWCTE  
  WHERE RowNo < 10
    )  
 
SELECT * FROM ROWCTE 


--------------------------------------------8-17-2021
use clictell_auto_stg

exec [master].[cust2vehicle_inactivedate_update] 1081
exec [stg].[move_customers4smartstreet_process] 1081

use clictell_auto_etl
select * from etl.etl_process (nolock) order by process_date  desc
select * from etl.file_process_details (nolock) where file_process_detail_id =1083


use clictell_auto_master
select * from master.dealer_audit_log (nolock) order by file_process_id desc

exec [master].[update_customer_status] 1081

select * from master.ncoa_customers (nolock) where file_process_id=1081


select top 10 * from [master].[campaign_responses] r (nolock) where responders<>0 and parent_Dealer_id=1806
select top 10 * from master.repair_order_header (nolock) where parent_Dealer_id=1806
select * from master.campaign_items	(nolock) where parent_Dealer_id=1806

select * from master.dealer (nolock) where upper(accounttype) = 'REGION'

select * from master.dealer (nolock) where parent_dealer_id =1811

-----************************8-19-21

use clictell_auto_master
select * from master.ro_op_codes (nolock)
select * from [master].[OpCode_category] (nolock) order by OpCode_category_desc

select * from master.ro_op_codes (nolock) where op_code_desc like '% Air filter%'

select * from master.ro_op_codes (nolock) where op_code_desc in (select OpCode_category_desc from master.opcode_category (nolock))

select 
		 a.master_ro_op_code_id
		,a.op_category_id 
		,string_agg(b.OpCode_category_id,',')
		,string_agg(OpCode_category_desc,'|')
		--,OpCode_category_id
		,op_code_desc
		--,b.OpCode_category_desc
from master.ro_op_codes a (nolock)
inner join master.opcode_category b(nolock) on  a.op_code_desc  like (select '% '+ b.OpCode_category_desc+' %' )
group by master_ro_op_code_id,a.op_category_id,op_code_desc
order by master_ro_op_code_id

----------*********************************************************************
use clictell_auto_master

IF OBJECT_ID('tempdb..#temp_opcode') IS NOT NULL DROP TABLE #temp_opcode 
select 
		 a.master_ro_op_code_id
		,a.op_category_id 
		,b.OpCode_category_id
		,b.OpCode_category_desc
		,a.op_code_desc
		,(ROW_NUMBER() over (partition by master_ro_op_code_id order by OpCode_category_id)) as rnk
		into #temp_opcode
from master.ro_op_codes a (nolock)
inner join master.opcode_category b(nolock) on  a.op_code_desc  like (select '% '+ b.OpCode_category_desc+'%' )

where op_category_id is null


update a set
--a.master_ro_op_code_id
--,b.master_ro_op_code_id
--,a.op_code_desc
--,b.OpCode_category_desc
a.op_category_id
=b.OpCode_category_id

from master.ro_op_codes a (nolock) inner join #temp_opcode b on a.master_ro_op_code_id =b.master_ro_op_code_id
where rnk=1
----------------************************************************************************
use clictell_auto_master

select * from master.ro_op_codes a (nolock) where op_category_id is null
--and op_category_id is null and op_code_desc not like 'Moved %' and op_code <> 'MTIME'and op_code <> 'MTTIME'
order by op_code



IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1 

select 
		op_code
		,op_category_id
		,count(*) as cc
	--into #temp1
from master.ro_op_codes a (nolock)  
where op_code is not null and op_code_desc is not null and op_category_id is not null
group by op_code,op_category_id
order by op_code,cc desc




select * from master.ro_op_codes a (nolock) where op_category_id is not null
select * from master.opcode_category b(nolock)

select op_category_id,OpCode_category_desc, count(*)  as records_updated 
from master.ro_op_codes a (nolock)  inner join master.OpCode_category b (nolock) on a.op_category_id = b.OpCode_category_id
group by OpCode_category_desc ,op_category_id
order by op_category_id


--order by master_ro_op_code_id
--) as a  where rnk=2

use clictell_auto_master
select top 10 last_ro_mileage from master.repair_order_header (nolock) where parent_dealer_id =1806 and last_ro_mileage is not null
select top 10 * from master.customer (nolock) where parent_dealer_id =1806 

select distinct deal_status, parent_dealer_id 
from master.fi_sales (nolock) 
where parent_dealer_id in (1806,3407) 
order by parent_dealer_id


select * from 
master.repair_order_header_detail a (nolock) 
inner join master.ro_parts_details b (nolock) on a.master_ro_detail_id =b.master_ro_detail_id
where ro_number ='81057'


select * from master.ro_parts_details (nolock) where ro_number ='81057'

select op_code,op_code_desc,billed_labor_hours from 
master.repair_order_header_detail a (nolock) 
where parent_Dealer_id =3407 and total_labor_cost=0 and total_labor_price<>0

select op_code,op_code_desc from master.repair_order_header (nolock) where parent_dealer_id=3407

use clictell_auto_master

select * from etl.cdk_servicero_header (nolock) 


select a.ro_number,convert(date,convert(varchar(10),b.ro_open_date)) as ro_open_date,convert(date,convert(varchar(10),b.ro_close_date)) as ro_close_date,a.op_code,a.billed_labor_hours from 
master.repair_order_header_detail a (nolock) left outer join master.repair_order_header b (nolock) on a.master_ro_header_id=b.master_ro_header_id
where op_code ='WTRPUMP' and a.parent_Dealer_id=1806

select a.ro_number,total_repair_order_cost,total_repair_order_price from 
master.repair_order_header_detail a (nolock) 
left outer join master.repair_order_header b (nolock) on a.master_ro_header_id=b.master_ro_header_id
where total_repair_order_cost =0 and total_repair_order_price > 400

use clictell_auto_master
select 
	 op_code
	,total_labor
	,total_labor_price

from 
master.repair_order_header_detail (nolock) 
where total_labor_cost =0 and total_labor_price > 1000 and parent_Dealer_id =1806

select distinct parent_Dealer_id,/*deal_type,*/sale_type,deal_status,nuo_flag,count(*) from master.fi_sales (nolock) where parent_Dealer_id in (3407,1806) 
and deal_status in ('Finalized','Sold','Booked/Recapped')
and sale_type not in ('Lease','L','Wholesale','W')
and parent_Dealer_id = 1806
group by parent_dealer_id,deal_type,sale_type,deal_status,nuo_flag



select top 100  * from master.repair_order_header_detail (nolock)

select top 10 * from master.fi_sales (nolock) where parent_dealer_id=3407
select distinct sale_type, deal_status,deal_type,nuo_flag from master.fi_sales (nolock) where parent_dealer_id=3407

select * from master.inventory (nolock) where parent_dealer_id=3407
select dbo.CamelCase(cust_first_name), cust_last_name,dbo.CamelCase(null) from master.customer (nolock) where parent_dealer_id=3407

select top 10 *
--cust_email_address1,cust_email_address2
select *
from master.dealer (nolock) where parent_dealer_id in ('2132','2133','2134','1806','2136','2137','2138','2139','2140','2141','2142') 

select * from master.fi_sales


select ro_number,op_code,total_labor_price, total_labor_cost from master.repair_order_header_detail (nolock) 
where parent_Dealer_id=3407 and total_labor_cost=0 and total_labor_price<>0
order by op_code

select ro_number,op_code,total_labor_price, total_labor_cost from master.repair_order_header_detail (nolock) 
where parent_Dealer_id=3407 and op_code in (select op_code from master.repair_order_header_detail (nolock) 
where parent_Dealer_id=3407 and total_labor_cost=0 and total_labor_price<>0) 


select ro_number,op_code,op_code_desc,billed_labor_hours,actual_labor_hours from master.repair_order_header_detail (nolock) 
where parent_Dealer_id=3407 and billed_labor_hours >40 and op_code_desc is not null

select ro_number,total_billed_labor_hours from master.repair_order_header (nolock) where parent_dealer_id =1806 and total_billed_labor_hours >40

select * from master.customer (nolock) where cust_dms_number ='113468'


select * from master.dealer (nolock) where _id= 'DDE0911D-DB21-4CCF-A6F5-5A37B5296162'
select * from master.dealer (nolock) where parentid='dde0911d-db21-4ccf-a6f5-5a37b5296162'

select lower('DDE0911D-DB21-4CCF-A6F5-5A37B5296162')

	declare @accountId uniqueidentifier = 'DDE0911D-DB21-4CCF-A6F5-5A37B5296162'
	exec reports.oem_dealers_get @accountid

use clictell_auto_master
select * from [master].[campaign_responses] (nolock) where parent_dealer_id =1806

use auto_campaigns
select top 10 * from [email].[campaign_items] (nolock)
select top 10 * from [push].[campaign_items] (nolock)
select top 10 * from [print].[campaign_items] (nolock)
select top 10 * from [sms].[campaign_items] (nolock)


----***************************************8-27-21
--use clictell_auto_master
--go
--create table [reports].master_service_customer


select cust_address1,cust_address2 from master.customer (nolock)

select * from reports.master_service_customer

select * from master.repair_order_header (nolock) where cust_dms_number = '10' and parent_Dealer_id= 3407
select * from master.customer (nolock) where cust_dms_number ='10' and parent_Dealer_id=3407 
select * from master.fi_sales (nolock) where cust_dms_number = '10'and parent_Dealer_id= 3407

select * from reports.master_service_customer (nolock) where parent_dealer_id =3407 and customer_id ='10' and rnk=1 order by vin


----------------------------------***
use clictell_auto_master
select a.cust_dms_number,b.cust_dms_number,a.cust_first_name,b.cust_first_name,a.cust_address1,b.cust_address1,a.cust_mobile_phone,b.cust_mobile_phone
from 
master.customer a (nolock) 
inner join master.customer b (nolock) 
on a.cust_mobile_phone =b.cust_mobile_phone and a.cust_address1 =b.cust_address1 and a.cust_dms_number <> b.cust_dms_number and a.cust_mobile_phone <>'' and a.cust_first_name =b.cust_first_name
order by a.cust_dms_number,b.cust_dms_number
----------------------------------****

select * from reports.master_service_customer (nolock)

select * from master.vehicle (nolock) where file_process_id =1102

select distinct sale_type from master.fi_sales (nolock) where parent_dealer_id in (3407,1806)

use clictell_auto_master
declare
	@FromDate date = '2021-08-01',
	@ToDate date = '2021-08-24',
	@vehicle_type varchar(50) = 'All',
	@Make varchar(50) = 'ALL',
	@Model_Year varchar(50)='ALL',
	@Model varchar(10) = 'ALL',
	@dealer_id varchar(20) = '3407',
	@daterange int = null,
		@vehicle_condition varchar(50)='All',      
	@Customer_lastname varchar(50) = NULL,      
	@vehicle_sale_type varchar(50) = 'All',      
	@Year varchar(10) = 'ALL'     

	use clictell_auto_master
	select accident_health_reserve,credit_life_reserve,gap_reserve,loss_of_employement_reserve,mechanical_breakdown_reserve,service_contract_reserve,total_fin_res	from [master].[fi_sales] s (nolock) where parent_dealer_id =1806





select count(*)
	from [master].[fi_sales] s (nolock)
	inner join master.vehicle v (nolock) on s.master_vehicle_id = v.master_vehicle_id
	inner join master.dealer d (nolock) on s.natural_key = d.natural_key
	inner join master.vehicle_makemodel m (nolock) on v.make = m.make and v.model = m.model

	where 
			(@dealer_id = s.parent_dealer_id)
	and	convert(date,convert(char(8),s.purchase_date)) between @FromDate and @ToDate
	and (@vehicle_type='All' or (@vehicle_type!='All' and @vehicle_type = ltrim(rtrim(s.nuo_flag))))
	and (@Make = 'All' or (@Make != 'All' and @Make = makedesc))
	and (@Model = 'All' or (@Model !='All' and @Model = modeldesc))
	and (@Model_Year = 'All' or (@Model_Year!='All' and @Model_Year = model_year))
	and s.deal_status in ('Sold', 'Finalized', 'Booked','Booked/Recapped')   

select count(*)
		from [master].[fi_sales] s      
		inner join master.vehicle v (nolock) on s.master_vehicle_id = v.master_vehicle_id      
		inner join master.customer c  (nolock) on s.master_customer_id = c.master_customer_id      
		inner join master.dealer d  (nolock)  on s.natural_key = d.natural_key      
		inner join master.vehicle_makemodel m (nolock)  on v.make = m.make and v.model = m.model      
	--left outer join master.fi_sales_people p  (nolock) on s.master_fi_sales_id = p.master_fi_sales_id      
	where   1 = 1    
		and (s.parent_dealer_id in (select distinct value from dbo.fn_split_string_to_column(@dealer_id,',')))      
		and convert(date,convert(char(8),s.purchase_date)) between @FromDate and @ToDate      
		and (@vehicle_condition = 'All' or (@vehicle_condition != 'All' and @vehicle_condition = ltrim(rtrim(s.nuo_flag))))  
		and (@vehicle_sale_type = 'All' or (@vehicle_sale_type != 'All' and s.sale_type  in  (select distinct value from dbo.fn_split_string_to_column(@vehicle_sale_type,',')))) 
		and (@Make = 'All' or (@Make != 'All' and @Make = m.makedesc))      
		and (@Model = 'All' or (@Model !='All' and @Model = m.modeldesc))      
		and (@Year = 'All' or (@Year!='All' and @Year = model_year))      
		and (@Customer_lastname is null or (@Customer_lastname is not null and (case when c.customer_type = 'B' then c.cust_first_name else c.cust_last_name end) like @Customer_lastname))      
		and s.deal_status in ('Sold', 'Finalized', 'Booked','Booked/Recapped') 


		use clictell_auto_master
		select * from [master].[vehicle_makemodel] WITH (nolock)  where parent_dealer_id =1806 and make ='DODGE'

		select * from master.inventory (nolock) where parent_dealer_id in (3407,1806)


		select * from master.dealer_mapping (nolock)


	declare      
	@FromDate date = '2021-01-01',      
	@ToDate date = '2021-09-3',      
	@vehicle_condition varchar(50)='All',      
	@Customer_lastname varchar(50) = NULL,      
	@vehicle_sale_type varchar(50) = 'All',      
	@Make varchar(50) = 'ALL',      
	@Model varchar(50)='ALL',      
	@Year varchar(10) = 'ALL',      
	@dealer_id varchar(4000) = '3407' ,
	@daterange int = null,
	@cust_dms_number varchar(50) =null


			select count(distinct s.master_fi_sales_id)
	from [master].[fi_sales] s      
	where   1 = 1    
		and purchase_date is not null
		and (s.parent_dealer_id in (select distinct value from dbo.fn_split_string_to_column(@dealer_id,',')))      
		and convert(date,convert(char(8),s.purchase_date)) between @FromDate and @ToDate      
		and s.deal_status in ('Sold', 'Finalized', 'Booked','Booked/Recapped')  




declare       
@dealer_id varchar(4000) = '3407', --'500,144,157,51,170,181,184,290,317,216,70',      
@FromDate date ='2021-01-01',      
@ToDate date = '2021-09-3',      
@n_u varchar(10) = 'All'   


		select count(distinct master_fi_sales_id)     
from master.fi_sales s (nolock)       
where 
		purchase_date is not null      
		and (s.parent_dealer_id in (select value from [dbo].[fn_split_string_to_column] (@dealer_id, ',')))      
		and (convert(date,convert(char(8),purchase_date)) between @FromDate and @ToDate)      
		and (deal_status in ('Booked','Sold','Booked/Recapped','Finalized')) 


Select * from master.fi_sales (nolock) where parent_Dealer_id =3407 and cust_dms_number = '127345'

use clictell_auto_master
select 
		ro_number
		--,total_discount
		----,total_repair_order_cost
		--,total_repair_order_price
		--,total_sale_post_ded
		--,total_labor_price
		,total_labor_price
		,total_labor_discount
		
		,total_labor_sale_post_ded

		,total_customer_labor_price
		,total_laborsalepostded_cp
		,total_internal_labor_price
		,total_laborsalepostded_ip
		,total_warranty_labor_price
		,total_laborsalepostded_wp
		--,total_parts_price
		--,total_parts_sale_post_ded 
		--select top 10 *
from master.repair_order_header (nolock) where parent_dealer_id =3407 and total_labor_price <>total_labor_sale_post_ded


select top 10 * from master.fi_sales (nolock) where parent_dealer_id =3407 

use clictell_auto_stg
select top 10 * from stg.service_ro_header where parent_dealer_id =3407 and file_process_id =1124 and ro_close_date is not null


use [auto_campaigns]

[analytics].[get_all_analytics_by_guid] 
[analytics].[get_email_analytics_by_guid] 
[analytics].[get_email_domain_performance] 
[analytics].[get_fulfilled_campaigns] 
[analytics].[get_link_clicks_by_guid] 

use clictell_auto_master
select top 10 total_customer_labor_price, total_laborsalepostded_cp,total_sale_post_ded from master.repair_order_header (nolock) where parent_dealer_id= 3407
select top 10 * from master.repair_order_header_detail (nolock) where parent_Dealer_id =3407


select * from master.fi_sales (nolock) where parent_dealer_id  =3407 and vin='KNDKGCA38A7705961'
select * from master.vehicle (nolock) where parent_dealer_id  =3407 and vin='KNDKGCA38A7705961'
select * from master.vehicle_makemodel (nolock) where model in ('SPORK','SPORTAGE') and modelyear=2010 --and parent_dealer_id=3407
SPORK
SPORTAGE
nuo_flag
ro_status

select s.*
from   
  [master].[fi_sales] s (nolock)  
 inner join master.vehicle v (nolock) on s.master_vehicle_id = v.master_vehicle_id  
 --inner join master.customer c (nolock) on s.master_fi_sales_id = c.master_customer_id  
 inner join master.dealer d (nolock) on s.parent_dealer_id = d.parent_dealer_id  
 inner join master.vehicle_makemodel m (nolock) on v.model = m.model and v.make = m.make  and v.model_year =m.modelyear and v.parent_dealer_id=m.parent_dealer_id
 where  1=1  and s.vin = 'KNDKGCA38A7705961'
 -- and (@vehicle_condition = 'All' or (@vehicle_condition != 'All' and @vehicle_condition = ltrim(rtrim(nuo_flag))))
 --and (@make = 'All' or (@make != 'All' and @make = m.makedesc))  
 --and (@model = 'All' or (@model !='All' and @model = m.modeldesc))  
 --and (@model_year = 'All' or (@model_year!='All' and @model_year = model_year))  
 --and (s.parent_dealer_id in (select distinct value from dbo.fn_split_string_to_column(@parent_dealer_id,',')))  
 --and (@vin is null or (@vin is not null and @vin = v.vin))  
 -- and (@stock_id is null or (@stock_id is not null and @stock_id = s.stock_id))  

 use clictell_auto_master

 select * from master.dealer (nolock) where _id='93d00129-a276-49ff-bfeb-8c80b5443b72'
 '93D00129-A276-49FF-BFEB-8C80B5443B72'
 'da1f958a-18c8-4617-b4fb-174ab4e09796'

 select _id,dealer_name,parentid,accounttype,* from master.dealer (nolock) where _id = '9cf90424-7d5a-4c56-96f8-acef6890c6b5'

 select _id,dealer_name,parentid,accounttype,* from master.dealer (nolock) where parentid ='9cf90424-7d5a-4c56-96f8-acef6890c6b5'

 select distinct accounttype from master.dealer (nolock)

 insert into master.dealer (_id,dealer_name,parentid,accounttype,accountstatus)
 values (newid(),'Hyundai of Cape Girardeau','401335EA-B7D1-4A4A-9A3E-7A5AE63B98D2','Dealer','Active')

-- update master.dealer set accounttype ='State' where _id in ('32737607-432B-4049-AC20-BAE0EB1EE438',
--'401335EA-B7D1-4A4A-9A3E-7A5AE63B98D2',
--'A15FFF06-321D-44B6-ABC1-DC7768FF687F',
--'08ACE070-0CBC-4AF7-B10D-BACDAEBD6A59')
--and parent_dealer_id in (4309,4319,4313,4316)

 
 --update master.dealer set accounttype ='Dealer' where parent_dealer_id = 4317 and dealer_name ='Keyes Hyundai' and _id='9B6355B6-DD79-43E0-98D3-4DADEC6A1812'
 --update master.dealer set accountstatus='Active' where parent_dealer_id = 1595
  IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

 declare    
@from_date datetime ='2021-01-01',  
@to_date datetime ='2021-08-30',  
@months_since_purchased int = 12,  
@local_customer varchar(20) = 'All',  
@customer_id varchar(30) = null,  
@buyer_first_name varchar(100) = null,  
@buyer_last_name varchar(100) =null,  
@dealer_id varchar(30) = '1806',  
@state varchar(20) = 'All' 
declare @parent_dealer_id int = (select @dealer_id)

  select  distinct  
		 d.dealer_name as store  
		 --,d.natural_key  
		 ,isnull(datediff(month,convert(date,convert(char(10),rh.ro_open_date)),getdate()),'') as months_since_last_purchase  
		 ,convert(date,convert(char(10),s.purchase_date)) as contract_date  
		 ,iif(ltrim(rtrim(c.cust_state_code)) = ltrim(rtrim(d.state)), 'Local','Non-local') as local_customer  
		 ,c.cust_dms_number as customer_ID  
		 ,c.cust_first_name  
		 ,c.cust_last_name  
		 ,c.cust_state_code  
		 ,c.cust_zip_code  
		 ,convert(date,convert(char(8),rh.last_ro_date)) as last_service_date  
		 ,convert(date,convert(char(10),rh.last_activity_date)) as last_contacted  
		 ,(row_number() over(partition by v.vin order by rh.ro_close_date desc) ) as rnk
		 ,rh.ro_number  
		 , (case when s.nuo_flag = 'N' then 'New' when s.nuo_flag = 'U' then 'Used' else ltrim(rtrim(s.nuo_flag)) end) as nuo_flag
		 ,v.make  
		 ,v.model_year  
		 ,v.vin 
		 ,v.model
		 ,v.vehicle_mileage
		 ,s.sale_type  
		 ,s.deal_type  
		 ,s.deal_status  
		 ,s.delivery_date  
		 ,s.deal_status_date  
		 ,s.vehicle_price as sale_price  
		 ,s.finance_apr as finace_rate  
		 ,s.monthly_payment  
		 ,s.contract_term as finance_term  
		 ,s.total_trade_actuval_cashvalue as trade_acv  
		 --,sp.sale_full_name as salesman_name  
		 ,s.sales_manager_fullname as salesman_name
		 ,isnull(total_gross_profit,isnull(frontend_gross_profit,0) + isnull(backend_gross_profit,0))  as total_gross  
		 ,frontend_gross_profit as front_gross  
		 ,iif(isnull(backend_gross_profit,0)=0,total_gross_profit-frontend_gross_profit,backend_gross_profit) as back_gross  
into #temp
   from  master.fi_sales s (nolock)
  inner join master.dealer d (nolock) on d.parent_dealer_id = s.parent_dealer_id
  left outer join master.repair_order_header rh (nolock) on rh.master_customer_id = s.master_customer_id and rh.master_vehicle_id = s.master_vehicle_id
  inner join master.customer c (nolock) on c.master_customer_id =s.master_customer_id
  inner join master.cust_2_vehicle cv (nolock) on cv.master_customer_id = c.master_customer_id and cv.master_vehicle_id = s.master_vehicle_id
  inner join master.vehicle v (nolock) on v.master_vehicle_id = cv.master_vehicle_id
  --inner join master.fi_sales_people sp (nolock) on s.master_fi_sales_id = sp.master_fi_sales_id
        
  where    
	  d.parent_dealer_id = @parent_dealer_id  
	  and (convert(date,convert(char(8),s.purchase_date))  between @from_date and @to_date)  
	  --and (rh.ro_open_date is null or datediff(month,convert(date,convert(char(10),rh.ro_open_date)),getdate()) > = @months_since_purchased  )
	  --and (@local_customer = 'All' or (@local_customer !='All' and @local_customer = iif(ltrim(rtrim(c.cust_state_code)) = ltrim(rtrim(d.state)), 'Local','Non-local')))  
	  and (@customer_id is null or (@customer_id is not null and  @customer_id = c.cust_dms_number))  
	  and (@buyer_first_name is null or (@buyer_first_name is not null and  @buyer_first_name = cust_first_name))  
	  and (@buyer_last_name is null or (@buyer_last_name is not null and  @buyer_last_name = cust_last_name))  
	  and (@state = 'All' or (@state !='All' and @state =c.cust_state_code))  
	  and (s.sale_type not in ( 'Lease','L','W','Wholesale'))
	  --and (s.deal_type = 'Retail' or s.deal_type is null)
	  and (s.deal_status in ('Finalized','Sold','Booked/Recapped'))


select * from #temp where rnk=1


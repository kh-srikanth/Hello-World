USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[exec_summary_campaign_response]    Script Date: 5/18/2021 12:31:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [reports].[exec_summary]
--declare
@dealer varchar(4000) = '524,513,512,514',  
@FromDate date = '2011-01-01',  
@ToDate date = '2012-01-01'

/*
exec [reports].[exec_summary] 524,'2011-01-01','2012-05-14'
*/
AS
BEGIN
-----------------------------------creating campaign Temp table begin
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

create table #temp
(
	id int identity(1,1)
	,vin varchar(30)
	,cust_id varchar(30)
	,deal_number varchar(30)
	,sale_amount int
	,customer_pay int
	,warranty_pay int
	,campaign_date date
	,email_sent_date date
	,campaign_type varchar(30)
	,camp_investment int
	,dealer_id varchar(20)
)

IF OBJECT_ID('tempdb..#repair_order_header') IS NOT NULL DROP TABLE #repair_order_header
select * into #repair_order_header 
		from master.repair_order_header 
where convert(date,convert(char(8),ro_open_date)) between @FromDate and @ToDate



insert into #temp ( vin, cust_id,deal_number,sale_amount,customer_pay,warranty_pay, campaign_date,email_sent_date,  campaign_type, camp_investment, dealer_id)
select top 3
		vin
		,c.cust_dms_number
		,roh.ro_number
		,total_repair_order_price
		,total_customer_price
		,total_warranty_price
		,'2011-10-05'
		,'2011-10-01'
		,'MoreServices'
		,2000
		,'524'
from #repair_order_header roh 
inner join master.customer c (nolock) on roh.master_customer_id = c.master_customer_id
inner join master.repair_order_header_detail rd (nolock) on roh.master_ro_header_id = rd.master_ro_header_id
where 
op_code like '%declined%' or customer_comment like '%declined%'

insert into #temp ( vin, cust_id,deal_number,sale_amount,customer_pay,warranty_pay, campaign_date,email_sent_date, campaign_type,camp_investment,dealer_id)
select  top 5
		roh.vin
		,c.cust_dms_number
		,roh.ro_number
		,total_repair_order_price
		,total_customer_price
		,total_warranty_price
		,'2011-07-15'
		,'2011-07-15'
		,'Service Reminders'
		,5000
		,'524'
from #repair_order_header roh 
inner join master.customer c (nolock) on roh.master_customer_id = c.master_customer_id
left outer join #temp t on t.vin  = roh.vin
where	 t.cust_id  is null
		--and convert(date,convert(char(8),ro_open_date)) between @FromDate and @ToDate



insert into #temp ( vin, cust_id,deal_number,sale_amount,customer_pay,warranty_pay, campaign_date,email_sent_date,  campaign_type,camp_investment,dealer_id)
select  top 2
		roh.vin
		,c.cust_dms_number
		,roh.ro_number
		,total_repair_order_price
		,total_customer_price
		,total_warranty_price
		,'2011-7-15'
		,'2011-7-10'
		,'Over All'
		,1000
		,'524'
from #repair_order_header roh 
inner join master.customer c (nolock) on roh.master_customer_id = c.master_customer_id
left outer join #temp t on t.vin  = roh.vin
where	 t.cust_id  is null
		--and convert(date,convert(char(8),ro_open_date)) between @FromDate and @ToDate


insert into #temp ( vin, cust_id,deal_number,sale_amount,customer_pay,warranty_pay, campaign_date,email_sent_date,  campaign_type,camp_investment,dealer_id)
select  top 6
		roh.vin
		,c.cust_dms_number
		,roh.ro_number
		,total_repair_order_price
		,total_customer_price
		,total_warranty_price
		,'2011-07-15'
		,'2011-07-19'
		,'Recovery Phase'
		,500
		,'524'
from #repair_order_header roh 
inner join master.customer c (nolock) on roh.master_customer_id = c.master_customer_id
left outer join #temp t on t.vin  = roh.vin
where	 t.cust_id  is null
		--and convert(date,convert(char(8),ro_open_date)) between @FromDate and @ToDate



insert into #temp ( vin, cust_id,deal_number,sale_amount,customer_pay,warranty_pay, campaign_date,email_sent_date,  campaign_type,camp_investment,dealer_id)
select  top 4
		s.vin
		,cust_dms_number
		,deal_number_dms
		,vehicle_cost
		,null
		,null
		,'2011-04-05'
		,'2011-04-10'
		,'Vehicle Purchase'
		,7000
		,'524'
from master.fi_sales s
left outer join #temp t on t.vin  = s.vin
where	 t.cust_id  is null
		and convert(date,convert(char(8),purchase_date)) between @FromDate and @ToDate


-----------------------------------creating campaign Temp table end
--select * from #temp   --20

---------------------------------------------Charts Begin
IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1

select 
		campaign_type
		,count(t.vin) as response
		,avg(camp_investment) as investment
		,sum(sale_amount) as sale
		,sum(customer_pay) as cp
		,sum(warranty_pay) as wp
into #temp1
--select t.*, ro_open_date
from #temp t
inner join master.repair_order_header roh (nolock) on roh.vin = t.vin and roh.ro_number = t.deal_number

	where (datediff(day,campaign_date,convert(date,convert(char(8),ro_open_date))) between 0 and 60)

		--and (dealer_id in (select [value] from dbo.fn_split_string_to_column(@dealer,',')))
group by campaign_type

union

select 
		campaign_type
		,count(t.vin) as response
		,avg(camp_investment) as investment
		,sum(sale_amount) as sale
		,sum(customer_pay) as cp
		,sum(warranty_pay) as wp
--into #temp1

--select t.*
from #temp t
inner join master.fi_sales s (nolock) on s.vin = t.vin and s.cust_dms_number = t.cust_id and s.deal_number_dms = t.deal_number

		where (datediff(day,campaign_date,convert(date,convert(char(8),purchase_date))) between 0 and 60)

		--and (dealer_id in (select [value] from dbo.fn_split_string_to_column(@dealer,',')))

		group by campaign_type



insert into #temp1 (campaign_type, response,investment,sale,cp,wp)

select t.campaign_type,0,0,0,0,0
from 
	#temp t
	left outer join #temp1 t1	on t.campaign_type = t1.campaign_type
where t1.campaign_type is null 
group by t.campaign_type

--select * from #temp1 
-------------------------------------------------Charts End---------------


-----------------------------------table Begin-------
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2

select 
t.*
,iif(datediff(day,campaign_date,convert(date,convert(char(8),ro_open_date))) between 0 and 60,'1','0') as campaign_responce

into #temp2
from #temp t
inner join master.repair_order_header roh (nolock) on roh.vin = t.vin and roh.ro_number = t.deal_number

--select * from #temp2

IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3

select 
t.*
,iif(datediff(day,campaign_date,convert(date,convert(char(8),purchase_date))) between 0 and 60,'1','0') as campaign_responce

into #temp3
from #temp t
inner join master.fi_sales s (nolock) on s.vin = t.vin and s.deal_number_dms = t.deal_number

--select * from #temp3
IF OBJECT_ID('tempdb..#table') IS NOT NULL DROP TABLE #table
select 
		campaign_type
		,count(cust_address1) as mail
		,count(cust_email_address1) as email
		,count(cust_mobile_phone) as phone
		,sum(customer_pay) as total_cp
		,sum(warranty_pay) as total_wp
		,sum(total_repair_order_price) as total_sale
		,count(ro_number) as repair_orders
		,count(case when campaign_responce=1 then 1 end) as responders
		,convert(decimal,count(case when campaign_responce=1 then 1 end))/iif(convert(decimal,count(ro_number))=0,1,convert(decimal,count(ro_number))) as response_rate	
		,sum(total_repair_order_price)/iif(convert(decimal,count(case when campaign_responce=1 then 1 end))=0,1,convert(decimal,count(case when campaign_responce=1 then 1 end))) as sale_per_response
		,avg(camp_investment)/iif(convert(decimal,count(case when campaign_responce=1 then 1 end))=0,1,convert(decimal,count(case when campaign_responce=1 then 1 end))) as cost_per_response
		,0 as sales_roi
	into #table
from #temp2 t 
inner join master.repair_order_header roh (nolock) on roh.vin = t.vin and roh.ro_number = t.deal_number
inner join master.customer c (nolock) on t.cust_id = c.cust_dms_number
group by campaign_type
union
select 
		campaign_type
		,count(cust_address1)
		,count(cust_email_address1)
		,count(cust_mobile_phone)
		,sum(customer_pay)
		,sum(warranty_pay)
		,sum(vehicle_price)
		,count(deal_number_dms)
		,count(case when campaign_responce=1 then 1 end) as responders
		,convert(decimal,count(case when campaign_responce=1 then 1 end))/convert(decimal,count(deal_number_dms)) as response_rate	
		,sum(vehicle_price)/convert(decimal,count(case when campaign_responce=1 then 1 end)) as sale_per_response
		,avg(camp_investment)/convert(decimal,count(case when campaign_responce=1 then 1 end))as cost_per_response
		,0 as sales_roi
from #temp3 t 
inner join master.fi_sales s (nolock) on s.vin = t.vin and s.deal_number_dms = t.deal_number
inner join master.customer c (nolock) on t.cust_id = c.cust_dms_number
group by campaign_type

------------------------------------Table End



select 
	t.campaign_type
	,response
	,investment
	,sale
	,cp
	,wp
	,mail
	,email
	,phone
	,repair_orders
	,responders
	,response_rate
	,sale_per_response
	,cost_per_response
	,sales_roi

from #temp1 t left outer join #table tb on t.campaign_type = tb.campaign_type
end
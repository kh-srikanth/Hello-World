use clictell_auto_master
go
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
create table #temp
(
id int identity(1,1)
,vin varchar(30)
,cust_id varchar(30)
,campaign_date date
,email_sent_date date
,campaign_id varchar(30)
,campaign_type varchar(30)
)
insert into #temp ( vin, cust_id, campaign_date,email_sent_date, campaign_id , campaign_type)
select distinct top 3
vin
,c.cust_dms_number
,'2011-10-05'
,'2011-10-01'
,'clicmotion_service_camp1'
,'MoreServices'
from master.repair_order_header roh (nolock) 
inner join master.customer c (nolock) on roh.master_customer_id = c.master_customer_id
inner join master.repair_order_header_detail rd (nolock) on  roh.master_ro_header_id = rd.master_ro_header_id
where op_code like '%declined%' or customer_comment like '%declined%'

insert into #temp ( vin, cust_id, campaign_date,email_sent_date, campaign_id , campaign_type)
select distinct top 5
roh.vin
,c.cust_dms_number
,'2011-05-05'
,'2011-05-10'
,'clicmotion_service_camp2'
,'Service Reminders'
from master.repair_order_header roh (nolock) 
inner join master.customer c (nolock) on roh.master_customer_id = c.master_customer_id
left outer join #temp t on t.vin  = roh.vin
where 1=1 and t.cust_id  is null


insert into #temp ( vin, cust_id, campaign_date,email_sent_date, campaign_id , campaign_type)
select distinct top 2
roh.vin
,c.cust_dms_number
,'2011-05-05'
,'2011-05-10'
,'clicmotion_service_camp3'
,'Over All'
from master.repair_order_header roh (nolock) 
inner join master.customer c (nolock) on roh.master_customer_id = c.master_customer_id
left outer join #temp t on t.vin  = roh.vin
where 1=1 and t.cust_id  is null


IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1

select distinct
t.*,ro_open_date
,iif(datediff(day,campaign_date,convert(date,convert(char(8),ro_open_date)))<60,'1','0') as campaign_responce
into #temp1
from #temp t 
inner join master.repair_order_header roh (nolock) on roh.vin = t.vin
where campaign_type = 'MoreServices'
order by id
declare @MS int 
select @MS = count(distinct vin) from #temp1 where campaign_responce = 1

IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2
select distinct
t.*,ro_open_date
,iif(datediff(day,campaign_date,convert(date,convert(char(8),ro_open_date)))<60,'1','0') as campaign_responce
into #temp2
from #temp t 
inner join master.repair_order_header roh (nolock) on roh.vin = t.vin
where campaign_type = 'Service Reminders'
order by id
declare @SR int
select @SR = count(distinct vin) from #temp2 where campaign_responce = 1

IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3
select distinct
t.*,ro_open_date
,iif(datediff(day,campaign_date,convert(date,convert(char(8),ro_open_date)))<60,'1','0') as campaign_responce
into #temp3
from #temp t 
inner join master.repair_order_header roh (nolock) on roh.vin = t.vin
where campaign_type = 'Over All'
order by id
declare @OA int
select @OA = count(distinct vin) from #temp3 where campaign_responce = 1

IF OBJECT_ID('tempdb..#t') IS NOT NULL DROP TABLE #t

create table #t
(
campaign varchar(50)
,response int
)

insert into #t (campaign, response)
values ('Over All',@OA), ('Service Reminders',@SR), ('MoreServices', @MS)

select * from #t

/*
--select floor((rand()*100)*iif(rand()>0.5,-1,1))
declare @i int =1
while @i < 10
begin
update #temp set 
campain_date = dateadd(day,floor((rand()*100)*iif(rand()>0.5,-1,1)),campain_date) 
where id = @i
set @i = @i+1
end

set @i =1
while @i < 10
begin
update #temp set 
email_sent_date = dateadd(day,floor((rand()*10)),campain_date)
where id = @i
set @i = @i+1
end


select top 100 op_code, op_code_desc,customer_comment,master_ro_header_id from master.repair_order_header_detail (nolock) where op_code like '%declined%' or customer_comment like '%declined%' or op_code_desc like '%declined%' 

select top 100
master_customer_id
,master_vehicle_id
,cust_dms_number
,vin
,deal_date
from master.fi_sales (nolock)

select top 100 * from master.customer


--select top 100 * from master.repair_order_header_detail (nolock)
*/
use auto_campaigns
go



IF OBJECT_ID('tempdb..#email_campaigns') IS NOT NULL DROP TABLE #email_campaigns 
IF OBJECT_ID('tempdb..#email_campaign_items') IS NOT NULL DROP TABLE #email_campaign_items 
IF OBJECT_ID('tempdb..#sms_campaigns') IS NOT NULL DROP TABLE #sms_campaigns 
IF OBJECT_ID('tempdb..#sms_campaign_items') IS NOT NULL DROP TABLE #sms_campaign_items 
IF OBJECT_ID('tempdb..#print_campaigns') IS NOT NULL DROP TABLE #print_campaigns 
IF OBJECT_ID('tempdb..#print_campaign_items') IS NOT NULL DROP TABLE #print_campaign_items 
IF OBJECT_ID('tempdb..#ro_header') IS NOT NULL DROP TABLE #ro_header 
IF OBJECT_ID('tempdb..#campaigns') IS NOT NULL DROP TABLE #campaigns

select * into #email_campaigns from email.campaigns (nolock) where is_deleted =0 
select * into #email_campaign_items from email.campaign_items i (nolock) where is_deleted =0
select * into #sms_campaigns from sms.campaigns (nolock) where is_deleted =0
select * into #sms_campaign_items from sms.campaign_items i (nolock) where is_deleted =0
select * into #print_campaigns from [print].campaigns (nolock) where is_deleted =0
select * into #print_campaign_items from [print].campaign_items i (nolock) where is_deleted =0

select * into #ro_header from clictell_auto_master.master.repair_order_header r (nolock) where is_deleted =0
select * from #email_campaign_items


select distinct
		a.account_id
		,c.campaign_id
		,c.scheduled_date as campaign_date
		,c.program_id as [program_name]
		,c.media_type
		,sum(convert(int,i.is_sent)) as sent
		,sum(convert(int,i.is_delivered)) as delivered
		,sum(convert(int,i.is_opened)) as opened
		,sum(convert(int,i.is_clicked)) as clicked
		,sum(convert(int,i.is_bounced)) as bounced
		,sum(convert(int,i.is_failed)) as failed
		,0 as responders
		,0 as ro_amount
		,0 as is_deleted
		,0 as cp_amount
		,0 as wp_amount
		,0 as ip_amount
		,0 as parts_amount
		,0 as labor_amount
		,0 as sales_amount

from #email_campaigns c 
inner join #email_campaign_items i on c.campaign_id =i.campaign_id 
inner join portal.account a with (nolock) on c.account_id = a._id
where  lower(a.accountstatus) = 'active'
group by a.account_id, c.campaign_id,c.scheduled_date,c.program_id,c.media_type

select  top 3 * from #email_campaigns
select * from portal.account with (nolock) where _id = '8F792567-2829-43CB-8152-A15062468C9D' and lower(accountstatus) = 'active'
select * from #email_campaigns
union

select distinct
		a.account_id
		,c.campaign_id
		,c.scheduled_date as campaign_date
		,c.program_id as [program_name]
		,c.media_type
		,sum(convert(int,i.is_sent)) as sent
		,sum(convert(int,i.is_delivered)) as delivered
		,null as opened
		,null as clicked
		,null as bounced
		,sum(convert(int,i.is_failed)) as failed
		,0 as responders
		,0 as ro_amount
		,0 as is_deleted
		,0 as cp_amount
		,0 as wp_amount
		,0 as ip_amount
		,0 as parts_amount
		,0 as labor_amount
		,0 as sales_amount
from #sms_campaigns c (nolock) 
inner join #sms_campaign_items i (nolock) on c.campaign_id =i.campaign_id 
inner join portal.account a with (nolock) on c.account_id = a._id
where  lower(a.accountstatus) = 'active'
group by a.account_id, c.campaign_id,c.scheduled_date,c.program_id,c.media_type

union 

select distinct
		a.account_id
		,c.campaign_id
		,c.scheduled_date as campaign_date
		,c.program_id as [program_name]
		,c.media_type
		,sum(convert(int,i.is_sent)) as sent
		,sum(convert(int,i.is_delivered)) as delivered
		,sum(convert(int,i.is_opened)) as opened
		,sum(convert(int,i.is_clicked)) as clicked
		,sum(convert(int,i.is_bounced)) as bounced
		,sum(convert(int,i.is_failed)) as failed
		,0 as responders
		,0 as ro_amount
		,0 as is_deleted
		,0 as cp_amount
		,0 as wp_amount
		,0 as ip_amount
		,0 as parts_amount
		,0 as labor_amount
		,0 as sales_amount
from #print_campaigns c (nolock) 
inner join #print_campaign_items i (nolock) on c.campaign_id =i.campaign_id 
inner join portal.account a with (nolock) on c.account_id = a._id
where  lower(a.accountstatus) = 'active'
group by a.account_id, c.campaign_id,c.scheduled_date,c.program_id,c.media_type


select * from #campaigns order by campaign_id
--select * from clictell_auto_master.master.campaigns (nolock)



/*
insert into clictell_auto_master.master.campaigns 
(
parent_dealer_id
,campaign_id
,campaign_date
,program_name
,media_type
,sent
,delivered
,opened
,clicked
,bounced
,failed
,responders
,ro_amount
,cp_amount
,wp_amount
,ip_amount
,parts_amount
,labor_amount
,sales_amount
)

select 
account_id
,campaign_id
,campaign_date
,program_name
,media_type
,sent
,delivered
,opened
,clicked
,bounced
,failed
,responders
,ro_amount
,cp_amount
,wp_amount
,ip_amount
,parts_amount
,labor_amount
,sales_amount

from #campaigns*/

use auto_campaigns
go
IF OBJECT_ID('tempdb..#email_campaigns') IS NOT NULL DROP TABLE #email_campaigns 
IF OBJECT_ID('tempdb..#email_campaign_items') IS NOT NULL DROP TABLE #email_campaign_items 
IF OBJECT_ID('tempdb..#sms_campaigns') IS NOT NULL DROP TABLE #sms_campaigns 
IF OBJECT_ID('tempdb..#sms_campaign_items') IS NOT NULL DROP TABLE #sms_campaign_items 
IF OBJECT_ID('tempdb..#print_campaigns') IS NOT NULL DROP TABLE #print_campaigns 
IF OBJECT_ID('tempdb..#print_campaign_items') IS NOT NULL DROP TABLE #print_campaign_items 
IF OBJECT_ID('tempdb..#ro_header') IS NOT NULL DROP TABLE #ro_header 
IF OBJECT_ID('tempdb..#campaigns') IS NOT NULL DROP TABLE #campaigns

select * into #email_campaigns from email.campaigns (nolock) where is_deleted =0 
select * into #email_campaign_items from email.campaign_items  (nolock) where is_deleted =0
select * into #sms_campaigns from sms.campaigns (nolock) where is_deleted =0
select * into #sms_campaign_items from sms.campaign_items  (nolock) where is_deleted =0
select * into #print_campaigns from [print].campaigns (nolock) where is_deleted =0
select * into #print_campaign_items from [print].campaign_items (nolock) where is_deleted =0


select * from clictell_auto_master.master.campaign_items (nolock)
select * from #email_campaign_items
select top 3 * from #email_campaigns
select * from clictell_auto_master.master.campaigns (nolock)


select
b.account_id as parent_dealer_id
,a.campaign_id
,scheduled_date as campaign_date
,program_id as program_name
,a.media_type

from #email_campaigns a
inner join portal.account b (nolock) on a.account_id =b._id
use auto_campaigns
use clictell_auto_master
go

declare @dealer_id int =1806
declare @id uniqueidentifier = (select _id from portal.account with (nolock) where account_id =@dealer_id)

----------------------------------------------------------Updating from LastDay data
IF OBJECT_ID('tempdb..#email_campaigns_update') IS NOT NULL DROP TABLE #email_campaigns_update 
IF OBJECT_ID('tempdb..#email_campaign_items_update') IS NOT NULL DROP TABLE #email_campaign_items_update 
IF OBJECT_ID('tempdb..#ro_header_update') IS NOT NULL DROP TABLE #ro_header_update 
IF OBJECT_ID('tempdb..#master_campaigns_update') IS NOT NULL DROP TABLE #master_campaigns_update
IF OBJECT_ID('tempdb..#master_camp_1_update') IS NOT NULL DROP TABLE #master_camp_1_update
IF OBJECT_ID('tempdb..#master_camp_2_update') IS NOT NULL DROP TABLE #master_camp_2_update

-- Load existing data in master.campaigns into temptable
select * into #master_campaigns_update from clictell_auto_master.master.campaigns (nolock) where parent_dealer_id =@dealer_id

-- Load all email.campaigns data existing in master.campaigns into temp table
select * into #email_campaigns_update from email.campaigns (nolock) where is_deleted =0 and campaign_id in (select campaign_id from #master_campaigns_update)
-- Load email.campaign_items LastDay data only
select * into #email_campaign_items_update from email.campaign_items  (nolock) 
				where is_deleted =0 
				and campaign_id in (select distinct campaign_id from #master_campaigns_update)
				and created_dt  = dateadd(day,-1,getdate())
-- Load LastDay RO data only
select * into #ro_header_update from clictell_auto_master.master.repair_order_header (nolock) 
				where is_deleted =0 
				and parent_dealer_id = @dealer_id 
				and convert(date,convert(varchar(10),ro_open_date)) = dateadd(day,-1,getdate())

-- Loading sums from campaign_items to temp table
select        
		 a.campaign_id,
		 sum(convert(int,b.is_sent)) as sent, 
		 sum(convert(int,b.is_delivered)) as delivered, 
		 sum(convert(int,b.is_opened)) as opened,
		 sum(convert(int,b.is_clicked)) as clicked,
		 sum(convert(int,b.is_bounced)) as bounced,
		 sum(convert(int,b.is_failed)) as failed

	into #master_camp_1_update

from #master_campaigns_update a  
inner join #email_campaign_items_update b on a.campaign_id = b.campaign_id 
--where parent_dealer_id = 1806
group by a.campaign_id

--adding LastDay sums to existing sums
update a set
		 a.sent=b.sent + a.sent
		,a.delivered=b.delivered + a.delivered
		,a.opened=b.opened + a.opened
		,a.clicked=b.clicked + a.clicked
		,a.bounced=isnull(b.bounced,0) + isnull(a.bounced,0)
		,a.failed=b.failed + a.failed
from #master_campaigns_update a
inner join #master_camp_1_update b on a.campaign_id =b.campaign_id

--loading LastDay RO data to temp table, filtering by campaign reponse
select  
		a.campaign_id,
		count(ro_number) as responders,
		sum(total_customer_price) as cp_amount, 
		sum(total_warranty_price) as wp_amount, 
		sum(total_internal_price) as ip_amount,
		sum(total_parts_price) as parts_amount,
		sum(total_labor_price) as labor_amount,
		sum(total_repair_order_price) as ro_amount,
		sum(isnull(total_sale_post_ded,total_repair_order_price-total_repair_order_cost)) as sale_amount
	into #master_camp_2_update
from #master_campaigns_update a
inner join #email_campaign_items_update b on a.campaign_id = b.campaign_id
inner join #ro_header_update r on a.parent_dealer_id = r.parent_dealer_id and r.master_customer_id = b.list_member_id
where  Cast(Cast(ro_open_date as varchar(10)) as date) between DateAdd(day, 1, campaign_date) and Dateadd(day, 61, campaign_date)
group by a.campaign_id

--adding LastDay RO amounts to existing amounts
update a set 

		a.responders = b.responders + a.responders
		,a.cp_amount = b.cp_amount + a.cp_amount
		,a.wp_amount = b.wp_amount + a.wp_amount
		,a.ip_amount = b.ip_amount + a.ip_amount
		,a.parts_amount = b.parts_amount + a.parts_amount
		,a.labor_amount	= b.labor_amount + a.labor_amount
		,a.ro_amount = b.ro_amount + a.ro_amount
		,a.sales_amount = b.sale_amount + a.sales_amount
from #master_campaigns_update a
inner join #master_camp_2_update b on a.campaign_id =b.campaign_id

--update b set
select 
		b.sent , a.sent
		,b.delivered , a.delivered
		,b.opened , a.opened
		,b.clicked , a.clicked
		,b.bounced , a.bounced
		,b.failed , a.failed
		,b.responders , a.responders
		,b.ro_amount , a.ro_amount
		,b.cp_amount , a.cp_amount
		,b.wp_amount , a.wp_amount
		,b.ip_amount , a.ip_amount
		,b.parts_amount , a.parts_amount
		,b.labor_amount , a.labor_amount
		,b.sales_amount , a.sales_amount
		,b.updated_dt , getdate()
		,b.updated_by , SUSER_NAME()
from #master_campaigns_update a
inner join clictell_auto_master.master.campaigns b (nolock) on a.parent_dealer_id  =b.parent_dealer_id and a.campaign_id  = b.campaign_id and a.media_type = b.media_type




---------------------------------Creating records for New Campaigns

IF OBJECT_ID('tempdb..#email_campaigns') IS NOT NULL DROP TABLE #email_campaigns 
IF OBJECT_ID('tempdb..#email_campaign_items') IS NOT NULL DROP TABLE #email_campaign_items 
IF OBJECT_ID('tempdb..#ro_header') IS NOT NULL DROP TABLE #ro_header 
IF OBJECT_ID('tempdb..#master_campaigns') IS NOT NULL DROP TABLE #master_campaigns
IF OBJECT_ID('tempdb..#master_camp_1') IS NOT NULL DROP TABLE #master_camp_1
IF OBJECT_ID('tempdb..#master_camp_2') IS NOT NULL DROP TABLE #master_camp_2

--declare @dealer_id int =1806
--declare @id uniqueidentifier = (select _id from portal.account with (nolock) where account_id =@dealer_id)

--select * into #email_campaign_items from email.campaign_items  (nolock) where is_deleted =0 and campaign_id in (select campaign_id from email.campaigns (nolock) where is_deleted =0 and account_id = @id)
--select * into #email_campaigns from email.campaigns (nolock) where is_deleted =0 and campaign_id in (select campaign_id from #email_campaign_items)


select * into #master_campaigns from clictell_auto_master.master.campaigns (nolock) where parent_dealer_id =@dealer_id

-- Loading New Campaign records from email.campaigns (records not existing in #master_campaigns)
select a.* 
	into #email_campaigns 
from email.campaigns a (nolock)
	inner join portal.account b (nolock) on a.account_id =b._id
	left outer join #master_campaigns c (nolock) on c.parent_dealer_id = b.account_id and a.campaign_id = c.campaign_id
where a.is_deleted =0 
	and b.account_id = @dealer_id
	and c.master_campaign_id is null
--Loading campaign items not existing in master.campaigns
select * into #email_campaign_items from email.campaign_items  (nolock) where is_deleted =0 and campaign_id in (select distinct campaign_id from #email_campaigns)
-- Loading RO data for the dealer into temp table
select * into #ro_header from clictell_auto_master.master.repair_order_header (nolock) where is_deleted =0 and parent_dealer_id = @dealer_id


-- inserting new campaign records into temp table
insert into #master_campaigns (parent_dealer_id ,campaign_id,campaign_date,program_name,media_type,sent,delivered
,opened,clicked,bounced,failed,responders,ro_amount,cp_amount,wp_amount,ip_amount,parts_amount,labor_amount,sales_amount)
select
		@dealer_id as parent_dealer_id
		,a.campaign_id
		,scheduled_date as campaign_date
		,program_id as program_name
		,a.media_type
		,0 as sent
		,0 as delivered
		,0 as opened
		,0 as clicked
		,0 as bounced
		,0 as failed
		,0 as responders
		,0 as ro_amount
		,0 as cp_amount
		,0 as wp_amount
		,0 as ip_amount
		,0 as parts_amount
		,0 as labor_amount
		,0 as sales_amount
from #email_campaigns a


select 
		 b.campaign_id,
		 sum(convert(int,b.is_sent)) as sent, 
		 sum(convert(int,b.is_delivered)) as delivered, 
		 sum(convert(int,b.is_opened)) as opened,
		 sum(convert(int,b.is_clicked)) as clicked,
		 sum(convert(int,b.is_bounced)) as bounced,
		 sum(convert(int,b.is_failed)) as failed

	into #master_camp_1

from #email_campaign_items b 
group by b.campaign_id

--select a.campaign_id,b.campaign_id
update a set
		 a.sent=b.sent
		,a.delivered=b.delivered
		,a.opened=b.opened
		,a.clicked=b.clicked
		,a.bounced=isnull(b.bounced,0)
		,a.failed=b.failed
from #master_campaigns a
inner join #master_camp_1 b on a.campaign_id =b.campaign_id

select 
		b.campaign_id,
		count(ro_number) as responders,
		sum(total_customer_price) as cp_amount, 
		sum(total_warranty_price) as wp_amount, 
		sum(total_internal_price) as ip_amount,
		sum(total_parts_price) as parts_amount,
		sum(total_labor_price) as labor_amount,
		sum(total_repair_order_price) as ro_amount,
		sum(isnull(total_sale_post_ded,total_repair_order_price-total_repair_order_cost)) as sale_amount
	into #master_camp_2
from  #email_campaign_items b 
inner join #master_campaigns a on a.campaign_id = b.campaign_id
inner join #ro_header r on r.master_customer_id = b.list_member_id
where Cast(Cast(ro_open_date as varchar(10)) as date) between DateAdd(day, 1, campaign_date) and Dateadd(day, 61, campaign_date)
group by b.campaign_id

update a set 
--select a.campaign_id
		a.responders = b.responders
		,a.cp_amount = b.cp_amount
		,a.wp_amount = b.wp_amount
		,a.ip_amount = b.ip_amount
		,a.parts_amount = b.parts_amount
		,a.labor_amount = b.labor_amount
		,a.ro_amount = b.ro_amount
		,a.sales_amount = b.sale_amount
from #master_campaigns a
inner join #master_camp_2 b on a.campaign_id =b.campaign_id

--- Insert New records to master.campaigns
--insert into clictell_auto_master.master.campaigns ( parent_dealer_id ,campaign_id,campaign_date,program_name,media_type,sent,delivered
--,opened,clicked,bounced,failed,responders,ro_amount,cp_amount,wp_amount,ip_amount,parts_amount,labor_amount,sales_amount )
select parent_dealer_id ,campaign_id,campaign_date,program_name,media_type,sent,delivered
,opened,clicked,bounced,failed,responders,ro_amount,cp_amount,wp_amount,ip_amount,parts_amount,labor_amount,sales_amount 
from #master_campaigns


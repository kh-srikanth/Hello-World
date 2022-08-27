use auto_campaigns
go
/*
select customer_id,vin,delivery_date,ro_date,purchase_date,last_service_date,src,is_active from auto_customers.customer.vehicles (nolock) where dealer_id = 1600 order by vin
select * from auto_campaigns.campaign.campaign_run (nolock)
select * from auto_campaigns.flow.flows f (nolock)
select * from auto_campaigns.touchpoint.programs p (nolock)
*/

declare @natural_key varchar(20) = '76024859'
declare @id uniqueidentifier = (select _id from clictell_auto_master.master.dealer (nolock) where natural_key = @natural_key) 
declare @dealer_id int = (select parent_dealer_id from clictell_auto_master.master.dealer (nolock) where natural_key =@natural_key)
declare @response_margin int =60



drop table if exists #master_campaigns 
drop table if exists #ro 
drop table if exists #email_items
drop table if exists #master_campaign_items


select * into #master_campaigns from clictell_auto_master.master.campaigns (nolock)

select *,0 as is_response into #ro from auto_customers.customer.vehicles (nolock) where dealer_id = 1600 and is_active = 1



	insert into #master_campaigns
	( 
			parent_dealer_id 
			,campaign_id
			,campaign_date
			,program_name
			,touch_point
			,media_type 
			,campaign_run_id
	)
	select distinct
			@dealer_id as parent_dealer_id
			,a.campaign_id
			,convert(date,a.run_dt) as campaign_date
			,p.[program_name] as program
			,f.flow_name as touchpoint
			,lower(b.media_type) as media_type 
			,a.campaign_run_id

	from 
			campaign.campaign_run a (nolock)
		inner join email.campaigns b (nolock) 
					on a.campaign_id = b.campaign_id and a.media_type = b.media_type
		inner join auto_campaigns.flow.flows f (nolock)	-- to get program_name
					on f.flow_id = a.flow_id
		inner join auto_campaigns.touchpoint.programs p (nolock) -- to get touchpoint
					on f.program_id = p.program_id
		left outer join clictell_auto_master.master.campaigns d			-- avoid duplicate records
					on b.campaign_id  = d.campaign_id and a.run_dt = d.campaign_date and a.media_type = d.media_type
	where 
			d.master_campaign_id is null			-- avoid duplicate records insert
			and 
			b.account_id = '2FBFFF86-50E3-40F6-B59D-8335327E6BB1'  --filter by dealer


	select * from #master_campaigns
	
	select * into #master_campaign_items from clictell_auto_master.master.campaign_items (nolock) where parent_dealer_id = 1600


	select * from #master_campaign_items

	--select 	master_customer_id,vin,ro_open_date,master_ro_header_id,ROW_NUMBER() over (partition by master_customer_id,vin order by ro_open_date desc) as rnk, 0 as is_response
	--into #ro_header1
	--from master.repair_order_header (nolock) where datediff(day,convert(date,convert(varchar(10),ro_open_date)),getdate())  < 61
	--		and parent_dealer_id = 1806--@dealer_id


	select customer_id,vin,ro_date,last_service_date,purchase_date,src,is_active from #ro where last_service_date = '1000-01-01'


	select 	a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.created_dt,a.campaign_run_id, b.campaign_date,r.vehicle_id,r.is_response
	into #email_items
	from auto_campaigns.email.campaign_items a (nolock) 
	inner join #master_campaigns b on a.campaign_id =b.campaign_id and a.campaign_run_id = b.campaign_run_id
	inner join #ro r (nolock) on a.list_member_id  = r.customer_id 
										and a.vin = r.vin
										and datediff(day,b.campaign_date,r.last_service_date) between 1 and @response_margin

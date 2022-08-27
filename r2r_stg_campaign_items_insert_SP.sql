	USE [clictell_stg_auto_master]
GO
/****** Object:  StoredProcedure [master].[cdk_lgt_campaign_response_insert]    Script Date: 12/20/2021 6:33:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER procedure [master].[cdk_lgt_campaign_response_insert]     
--declare 
	--@dealer_id int =1806,
	--@natural_key varchar(50)
--	--,@process_id int
--As

--BEGIN
	--declare @natural_key varchar(20) = 'FreedomPowersports'
	--declare @id uniqueidentifier = (select _id from clictell_stg_auto_master.master.dealer (nolock) where natural_key = @natural_key and accounttype = 'OEM') 
	--declare @dealer_id int = (select parent_dealer_id from clictell_stg_auto_master.master.dealer (nolock) where natural_key =@natural_key and accounttype = 'OEM')
	declare @response_margin int = 60
	
	drop table if exists #insert_master_customer
	drop table if exists #master_campaigns1
	drop table if exists #master_campaigns
	drop table if exists #customer_vehicle
	drop table if exists #master_campaign_items
	drop table if exists #email_campaign_items
	drop table if exists #sms_campaign_items
	drop table if exists #print_campaign_items
	drop table if exists #email_items
	drop table if exists #sms_items
	drop table if exists #items

	select * into #master_campaigns1 from clictell_stg_auto_master.master.campaigns (nolock)
	

		select distinct
				b.account_id
				,a.campaign_id
				,a.run_dt as campaign_date
				,p.[program_name] as program
				,isnull(f.flow_name,b.name) as touchpoint
				,lower(b.media_type) as media_type 
				,a.campaign_run_id

			into #insert_master_customer
		from 
				auto_stg_campaigns.flow.campaign_run a (nolock)
			inner join auto_stg_campaigns.email.campaigns b (nolock) 
						on a.campaign_id = b.campaign_id and a.media_type = b.media_type
			left outer join auto_stg_campaigns.flow.flows f (nolock)	-- to get program_name
						on f.flow_id = b.flow_id
			left outer join auto_stg_campaigns.touchpoint.programs p (nolock) -- to get touchpoint
						on f.program_id = p.program_id
			left outer join clictell_stg_auto_master.master.campaigns d			-- avoid duplicate records
						on b.campaign_id  = d.campaign_id and a.run_dt = d.campaign_date and a.media_type = d.media_type
		where 
				d.master_campaign_id is null			-- avoid duplicate records insert
				and 
				convert(date,a.run_dt) >= convert(date,dateadd(day,-60,getdate()))  -- get previous days campaign runs
				--and 
				--b.account_id = @id  --filter by dealer
				and 
				a.media_type = 'email'

UNION

		select distinct
				b.account_id
				,a.campaign_id
				,a.run_dt as campaign_date
				--,p.[program_name] as program
				--,isnull(f.flow_name,b.name) as touchpoint
				,null as program
				,b.name as touchpoint
				,lower(b.media_type) as media_type 
				,a.campaign_run_id

		from 
				auto_stg_campaigns.flow.campaign_run a (nolock)
			inner join auto_stg_campaigns.sms.campaigns b (nolock) 
						on a.campaign_id = b.campaign_id and a.media_type = b.media_type
			--left outer join auto_stg_campaigns.flow.flows f (nolock)	-- to get program_name
			--			on f.flow_id = b.flow_id
			--left outer join auto_stg_campaigns.touchpoint.programs p (nolock) -- to get touchpoint
			--			on f.program_id = p.program_id
			left outer join clictell_stg_auto_master.master.campaigns d			-- avoid duplicate records
						on b.campaign_id  = d.campaign_id and a.run_dt = d.campaign_date and a.media_type = d.media_type
		where 
				d.master_campaign_id is null			-- avoid duplicate records insert
				and 
				convert(date,a.run_dt) >= convert(date,dateadd(day,-60,getdate()))  -- get previous days campaign runs
				--and 
				--b.account_id = @id  --filter by dealer
				and 
				a.media_type = 'sms'


				insert into #master_campaigns1
		( 
				parent_dealer_id 
				,campaign_id
				,campaign_date
				,program_name
				,touch_point
				,media_type 
				,campaign_run_id

		)
		select 
				b.parent_dealer_id
				,campaign_id
				,campaign_date
				,program
				,touchpoint
				,media_type
				,campaign_run_id

		from #insert_master_customer a
		inner join clictell_stg_auto_master.master.dealer b (nolock) on upper(a.account_id) = upper(b._id)



	select *,0 as is_response into #customer_vehicle from auto_stg_customers.customer.vehicles (nolock) where is_deleted =0
	--update  #cv  set last_service_date = '12/15/2021' where len(exterior_color) <> 0 and exterior_color = 'white' 
	select *,null as campaign_run_id into #master_campaign_items from clictell_stg_auto_master.master.campaign_items (nolock)
	select * into #email_campaign_items from auto_stg_campaigns.email.campaign_items (nolock)
	select * into #print_campaign_items from auto_stg_campaigns.[print].campaign_items (nolock)
	select * into #sms_campaign_items from auto_stg_campaigns.sms.campaign_items (nolock)


	truncate table #master_campaign_items


		select 	a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.created_dt,a.campaign_run_id, b.campaign_date,r.vehicle_id,r.is_response,'email' as src
			into #email_items
		from #email_campaign_items a (nolock) 
		inner join #master_campaigns1 b on a.campaign_id =b.campaign_id and a.campaign_run_id = b.campaign_run_id
		inner join #customer_vehicle r (nolock) on a.list_member_id  = r.customer_id 
											and a.vin = r.vin
											and datediff(day,b.campaign_date,r.last_service_date) between 1 and 60
	
		select 	a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.created_dt,a.campaign_run_id, b.campaign_date,r.vehicle_id,r.is_response,'sms' as src
			into #sms_items
		from #sms_campaign_items a (nolock) 
		inner join #master_campaigns1 b on a.campaign_id =b.campaign_id and a.campaign_run_id = b.campaign_run_id
		inner join #customer_vehicle r (nolock) on a.list_member_id  = r.customer_id 
											and a.vin = r.vin
											and datediff(day,b.campaign_date,r.last_service_date) between 1 and 60





		select * into #items from #email_items
		UNION
		select * from #sms_items

		select *,0 as is_processed into #master_campaigns from #master_campaigns1
		

		declare @campaign_id int, @campaign_date date, @media_type varchar(15), @campaign_run_id int, @parent_dealer_id int
		while ((select count(*) from #master_campaigns where is_processed =0 ) > 0 )
		BEGIN
					select top 1 
						 @campaign_id = campaign_id
						,@campaign_date = campaign_date
						,@media_type = media_type
						,@campaign_run_id = campaign_run_id
						,@parent_dealer_id = parent_dealer_id
					from #master_campaigns where is_processed =0 order by campaign_date asc

				insert into #master_campaign_items 
						(parent_dealer_id,campaign_id,campaign_item_id,list_member_id,vin,run_date,source,campaign_run_id,response_number)
				select 
						@parent_dealer_id as parent_dealer_id, a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.campaign_date,src, a.campaign_run_id, a.list_member_id
				from 
						#items a (nolock) 
				where 
						a.campaign_id =  @campaign_id
					and a.is_response <> 1  --check if the record is considered as response to other campaigns ?

			update a set a.is_response = 1 from #items a where list_member_id in (select response_number from #master_campaign_items) and a.vin in (select vin from #master_campaign_items)
				
			update #master_campaigns set is_processed =1 where campaign_id = @campaign_id and convert(date,campaign_date) = convert(date,@campaign_date)

		END

		select * from #master_campaign_items 
		select * from #items --where campaign_id = 1767
		select * from #master_campaigns
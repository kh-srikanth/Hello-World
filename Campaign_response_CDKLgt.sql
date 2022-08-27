USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [master].[campaign_response_insert]    Script Date: 12/17/2021 3:43:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure [master].[cdk_lgt_campaign_response_insert]     
--declare 
	--@dealer_id int =1806,
	@natural_key varchar(50)
--	--,@process_id int
As

BEGIN
	--declare @natural_key varchar(20) = '76024859'
	declare @id uniqueidentifier = (select _id from clictell_auto_master.master.dealer (nolock) where natural_key = @natural_key) 
	declare @dealer_id int = (select parent_dealer_id from clictell_auto_master.master.dealer (nolock) where natural_key =@natural_key)
	declare @response_margin int =60

	drop table if exists #master_campaigns 
	drop table if exists #ro 
	drop table if exists #email_items
	drop table if exists #print_items
	drop table if exists #master_campaign_items
	drop table if exists #items

	insert into master.campaigns
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
			left outer join master.campaigns d			-- avoid duplicate records
						on b.campaign_id  = d.campaign_id and a.run_dt = d.campaign_date and a.media_type = d.media_type
		where 
				d.master_campaign_id is null			-- avoid duplicate records insert
				and 
				convert(date,a.run_dt) = convert(date,dateadd(day,-20,getdate()))  -- get previous days campaign runs
				and 
				b.account_id = @id  --filter by dealer

	
		-- Inserting print_campaigns into master.campaigns
		insert into master.campaigns 
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
				@dealer_id as parent_dealer_id
				,a.campaign_id
				,convert(date,a.run_dt) as campaign_date
				,p.[program_name] as program
				,f.flow_name as touchpoint
				,lower(b.media_type) as media_type 
				,a.campaign_run_id
		from 
			campaign.campaign_run a (nolock)
			inner join [print].campaigns b (nolock) 
						on a.campaign_id = b.campaign_id and a.media_type = b.media_type
			inner join auto_campaigns.flow.flows f (nolock)	-- to get program_name
						on f.flow_id = a.flow_id
			inner join auto_campaigns.touchpoint.programs p (nolock)
						on f.program_id = p.program_id
			left outer join master.campaigns d				-- avoid duplicate records
						on b.campaign_id  = d.campaign_id and a.run_dt = d.campaign_date and a.media_type = d.media_type
		where 
				d.master_campaign_id is null				-- avoid duplicate records
				and 
				convert(date,a.run_dt) = convert(date,dateadd(day,-1,getdate()))  -- get previous days campaign runs
				and 
				b.account_id = @id


	select *,0 as is_processed into #master_campaigns from clictell_auto_master.master.campaigns (nolock) where parent_dealer_id = @dealer_id
	select *,0 as is_response into #cv from auto_customers.customer.vehicles (nolock) where dealer_id = @dealer_id and is_active = 1
	--update  #cv  set last_service_date = '12/15/2021' where len(exterior_color) <> 0 and exterior_color = 'white' 
	select * into #master_campaign_items from clictell_auto_master.master.campaign_items (nolock)




		select 	a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.created_dt,a.campaign_run_id, b.campaign_date,r.vehicle_id,r.is_response,'email' as src
			into #email_items
		from email.campaign_items a (nolock) 
		inner join #master_campaigns b on a.campaign_id =b.campaign_id and a.campaign_run_id = b.campaign_run_id
		inner join #cv r (nolock) on a.list_member_id  = r.customer_id 
											and a.vin = r.vin
											and datediff(day,b.campaign_date,r.last_service_date) between 1 and 60


		select 	a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.created_dt,a.run_id, b.campaign_date,r.vehicle_id,r.is_response,'print' as src
			into #print_items
		from [print].campaign_items a (nolock) 
		inner join #master_campaigns b on a.campaign_id =b.campaign_id and a.run_id = b.campaign_run_id
		inner join #cv r (nolock) on a.list_member_id  = r.customer_id 
											and a.vin = r.vin
											and datediff(day,b.campaign_date,r.last_service_date) between 1 and 60


		select * into #items from #email_items
		union 
		select * from #print_items


		declare @campaign_id int, @campaign_date date, @media_type varchar(15), @campaign_run_id int
		while ((select count(*) from #master_campaigns where is_processed =0 and sent is not null) > 0 )
		BEGIN
					select top 1 
						 @campaign_id = campaign_id
						,@campaign_date = campaign_date
						,@media_type = media_type
						,@campaign_run_id = campaign_run_id
					from #master_campaigns where is_processed =0 order by campaign_date asc

				insert into #master_campaign_items 
						(parent_dealer_id,campaign_id,campaign_item_id,list_member_id,vin,run_date,source,campaign_run_id,response_number)
				select 
						@dealer_id as parent_dealer_id, a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.campaign_date,src, a.campaign_run_id, a.list_member_id
				from 
						#items a (nolock) 
				where 
						a.campaign_run_id =  @campaign_run_id
					and a.is_response <> 1  --check if the record is considered as response to other campaigns ?

			update a set a.is_response = 1 from #items a where list_member_id in (select response_number from #master_campaign_items)
				
			update #master_campaigns set is_processed =1 where campaign_id = @campaign_id and convert(date,campaign_date) = convert(date,@campaign_date)



		END

	--select * from #master_campaign_items where campaign_run_id in (102,103)

	--select * from #master_campaigns



	insert into master.campaign_items 
			(parent_dealer_id,campaign_id,campaign_item_id,list_member_id,vin,run_date,source,campaign_run_id,response_number)
	
		select 
			a.parent_dealer_id,a.campaign_id,a.campaign_item_id,a.list_member_id,a.vin,a.run_date,a.source,a.campaign_run_id,a.response_number
		from #master_campaign_items a
		left outer join master.campaign_items b (nolock) --avoid duplicate insert
					on a.campaign_id  = b.campaign_id 
					and a.campaign_run_id  = b.campaign_run_id  
					and a.list_member_id =b.list_member_id
		where b.master_campaign_item_id is null



		select campaign_id,campaign_run_id, count(*) as sent 
			into #sent 
		from email.campaign_items (nolock) where campaign_run_id is not null group by campaign_id,campaign_run_id 
		union
		select campaign_id,run_id, count(*) 
		from [print].campaign_items (nolock) where run_id is not null group by campaign_id,run_id 
	
		select 
					 a.campaign_id
					,a.campaign_run_id
					,count(*) as responders

			into #responders_camp
		from  #master_campaign_items a 
		group by a.campaign_id,a.campaign_run_id

		--select b.campaign_id, a.campaign_id, b.campaign_run_id , a.campaign_run_id,
		update b set
				b.responders = a.responders
		from #responders_camp a
		inner join master.campaigns b (nolock) on a.campaign_id = b.campaign_id  and a.campaign_run_id = b.campaign_run_id

		update b set 
				b.sent = s.sent
		from master.campaigns b (nolock)
		inner join #sent s on b.campaign_id = s.campaign_id and b.campaign_run_id = s.campaign_run_id

END

/*
select * from #email_items order by list_member_id
select * from #master_campaign_items where campaign_run_id in (102,103) order by list_member_id

	declare @campaign_id int, @campaign_date date, @media_type varchar(15), @campaign_run_id int
	while ((select count(*) from #master_campaigns where is_processed =0 and sent is not null) > 0 )
	BEGIN
		select top 1 
				 @campaign_id = campaign_id
				,@campaign_date = campaign_date
				,@media_type = media_type
				,@campaign_run_id = campaign_run_id
			from #master_campaigns where is_processed =0 order by campaign_date asc

		if (@media_type = 'email')
			BEGIN
					insert into #master_campaign_items 
							(parent_dealer_id,campaign_id,campaign_item_id,list_member_id,vin,run_date,source,campaign_run_id,response_number)
					select 
							@dealer_id as parent_dealer_id, a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.campaign_date,@media_type, a.campaign_run_id, a.list_member_id
					from 
							#email_items a (nolock) 
					where 
							a.campaign_run_id =  @campaign_run_id
						and a.is_response <> 1  --check if the record is considered as response to other campaigns ?

					update a set a.is_response = 1   --setting the RO record as response in #master_campaign_items
					from #email_items a 
					where list_member_id in (select response_number from #master_campaign_items)

			END
	
		if (@media_type = 'print')
			BEGIN
					insert into #master_campaign_items 
							(parent_dealer_id,campaign_id,campaign_item_id,list_member_id,vin,run_date,source,campaign_run_id,response_number)
					select 
							@dealer_id as parent_dealer_id, a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.campaign_date,@media_type, a.run_id, a.list_member_id
					from 
							#print_items a (nolock) 
					where 
							a.run_id =  @campaign_run_id
						and a.is_response  <> 1  --check if the record is considered as response to other campaigns ?

					update a set a.is_response = 1   --setting the RO record as response in #master_campaign_items
					from #print_items a 
					where list_member_id in (select response_number from #master_campaign_items)

			END
		
		update #master_campaigns set is_processed =1 where campaign_id = @campaign_id and campaign_date = @campaign_date
		print 1

	END

	select * from #master_campaign_items where campaign_run_id in (102,103)

*/
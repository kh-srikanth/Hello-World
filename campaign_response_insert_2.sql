USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [master].[campaign_response_insert]    Script Date: 12/8/2021 11:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER procedure [master].[campaign_response_insert]     
declare 
	--@dealer_id int =1806,
	@natural_key varchar(50) = '8317'
--	--,@process_id int
--As

/*
	Copyright 2017 Warrous Pvt Ltd    

              
 Date           Author			Work Tracker Id			Description              
 ------------------------------------------------------------------------------            
 16/11/2021		Srikanth K		Created					1.Load data to master.campaigns from email.campaigns + sms.campaigns + print.campaigns
														2.loads responders data to master.campaign_items and 
														3.Updates the response column in master.campaigns
------------------------------------------------------------------------------            
exec [master].[campaign_response_insert] 8317

select * from master.campaigns (nolock)
select * from master.campaign_items(nolock) where response_number is  not null and campaign_run_id is not null
select * from master.repair_order_header (nolock) where master_ro_header_id = '400296'


*/


BEGIN
	--get account_id for @dealer_id

	declare @dealer_id int = (select parent_dealer_id from master.dealer (nolock) where natural_key = @natural_key)
	declare @id uniqueidentifier = (select _id from master.dealer (nolock) where natural_key = @natural_key)

	drop table if exists #campaign_run 
	drop table if exists #master_campaigns 
	drop table if exists #campaigns 
	drop table if exists #responders_camp 
	drop table if exists #master_campaign_items
	
	---- Inserting email_campaigns into master.campaigns
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
			,a.run_dt as campaign_date
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

 -------Inserting sms_campaigns into master.campaigns
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
			,a.run_dt as campaign_date
			,p.[program_name] as program
			,f.flow_name as touchpoint
			,lower(b.media_type) as media_type 
			,a.campaign_run_id

	from 
		campaign.campaign_run a (nolock)
		inner join sms.campaigns b (nolock) 
					on a.campaign_id = b.campaign_id and a.media_type = b.media_type
		inner join auto_campaigns.flow.flows f (nolock)	-- to get program_name
					on f.flow_id = a.flow_id
		inner join auto_campaigns.touchpoint.programs p (nolock)
					on f.program_id = p.program_id
		left outer join master.campaigns d			-- avoid duplicate records
					on b.campaign_id  = d.campaign_id and a.run_dt = d.campaign_date and a.media_type = d.media_type
	where 
			d.master_campaign_id is null			-- avoid duplicate records
			and 
			convert(date,a.run_dt) = convert(date,dateadd(day,-1,getdate()))  -- get previous days campaign runs
			and 
			b.account_id = @id

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
			,a.run_dt as campaign_date
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


	--get campaigns list which are < 60 days old and load into #campaigns 
	select *,0 as is_processed into #campaigns from master.campaigns (nolock) where datediff(day,campaign_date,getdate()) < 61
	--select * from #campaigns
	select * into #master_campaign_items from master.campaign_items (nolock)
	truncate table #master_campaign_items
	--select top 3 * from #master_campaign_items



	drop table if exists #email_items
	drop table if exists #sms_items
	drop table if exists #print_items
	drop table if exists #ro_header
	drop table if exists #sent
	drop table if exists #ro_header1



	select 	master_customer_id,vin,ro_open_date,master_ro_header_id,ROW_NUMBER() over (partition by master_customer_id,vin order by ro_open_date desc) as rnk, 0 as is_response
	into #ro_header1
	from master.repair_order_header (nolock) where datediff(day,convert(date,convert(varchar(10),ro_open_date)),getdate())  < 61
			and parent_dealer_id = 1806--@dealer_id


	select	master_customer_id, --Insert RO data into #ro_header table converting data type and considering the latest ROs only
			vin,
			convert(date,convert(varchar(10),ro_open_date)) as ro_open_date,
			master_ro_header_id,is_response 
		into #ro_header 
	from #ro_header1 where rnk=1

	declare @response_margin int = 60

	--load campaign_items data into temp tables after getting relavent data
	select 	a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.created_dt,a.campaign_run_id, b.campaign_date,r.master_ro_header_id,r.is_response
	into #email_items
	from email.campaign_items a (nolock) 
	inner join #campaigns b on a.campaign_id =b.campaign_id and a.campaign_run_id = b.campaign_run_id
	inner join #ro_header r (nolock) on a.list_member_id  = r.master_customer_id 
										and a.vin = r.vin
										and datediff(day,b.campaign_date,r.ro_open_date) between 1 and @response_margin



	select 	a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.created_dt,a.run_id, b.campaign_date,r.master_ro_header_id,r.is_response
	into #print_items
	from [print].campaign_items a (nolock) 
	inner join #campaigns b on a.campaign_id =b.campaign_id and a.run_id = b.campaign_run_id
	inner join #ro_header r (nolock) on a.list_member_id  = r.master_customer_id 
										and a.vin = r.vin
										and datediff(day,b.campaign_date,r.ro_open_date) between 1 and @response_margin

	



	--loading RO data into temp table after filtering by dealer, latest RO for acustomer and vehicle & ROs in past 60 days

	--Declare variable to use in while loop 
	declare @campaign_id int, @campaign_date date, @media_type varchar(15), @campaign_run_id int

	-- getting campaign_items for campaigns one by one
	while ((select count(*) from #campaigns where is_processed =0 and sent is not null) > 0 )
	BEGIN
		select top 1 
				 @campaign_id = campaign_id
				,@campaign_date = campaign_date
				,@media_type = media_type
				,@campaign_run_id = campaign_run_id
			from #campaigns where is_processed =0 order by campaign_date asc

		if (@media_type = 'email')
			BEGIN
					insert into #master_campaign_items 
							(parent_dealer_id,campaign_id,campaign_item_id,list_member_id,vin,run_date,source,campaign_run_id,response_number)
					select 
							@dealer_id as parent_dealer_id, a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.campaign_date,@media_type, a.campaign_run_id, a.master_ro_header_id
					from 
							#email_items a (nolock) 
					where 
							a.campaign_run_id =  @campaign_run_id
						and a.is_response =0  --check if the record is considered as response to other campaigns ?


					update a set a.is_response = 1   --setting the RO record as response in #master_campaign_items
					--select a.*
					from #email_items a 
					where master_ro_header_id in (select response_number from #master_campaign_items)
	


			END
	
		if (@media_type = 'print')
			BEGIN
					insert into #master_campaign_items 
							(parent_dealer_id,campaign_id,campaign_item_id,list_member_id,vin,run_date,source,campaign_run_id,response_number)
					select 
							@dealer_id as parent_dealer_id, a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.campaign_date,@media_type, a.run_id, a.master_ro_header_id
					from 
							#print_items a (nolock) 
					where 
							a.run_id =  @campaign_run_id
						and a.is_response =0  --check if the record is considered as response to other campaigns ?


					update a set a.is_response = 1   --setting the RO record as response in #master_campaign_items
					--select a.*
					from #print_items a 
					where master_ro_header_id in (select response_number from #master_campaign_items)

					
			END
		
		update #campaigns set is_processed =1 where campaign_id = @campaign_id and campaign_date = @campaign_date
		print 1
	END

	return;

	 --Insert new items to master.campaign_items from #master_campaign_items
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



	--find responders from #master_campaign_items, group by campaign_id and campaign_date
	select campaign_id,campaign_run_id, count(*) as sent into #sent from email.campaign_items (nolock) where campaign_run_id is not null group by campaign_id,campaign_run_id 
	union
	select campaign_id,run_id, count(*) from [print].campaign_items (nolock) where run_id is not null group by campaign_id,run_id 
	
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


use clictell_auto_master
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [master].[update_master_campaign_campaign_items]     
(
	--declare 
	@dealer_id int =1806
)
As




BEGIN

	declare @id uniqueidentifier = (select _id from master.dealer (nolock) where parent_dealer_id = @dealer_id)

	IF OBJECT_ID('tempdb..#campaign_run') IS NOT NULL DROP TABLE #campaign_run 
	IF OBJECT_ID('tempdb..#master_campaigns') IS NOT NULL DROP TABLE #master_campaigns 
	IF OBJECT_ID('tempdb..#campaigns') IS NOT NULL DROP TABLE #campaigns 
	IF OBJECT_ID('tempdb..#responders_camp') IS NOT NULL DROP TABLE #responders_camp 
	IF OBJECT_ID('tempdb..#master_campaign_items') IS NOT NULL DROP TABLE #master_campaign_items



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
			,b.media_type 
			,a.campaign_run_id

	from 
			campaign.campaign_run a (nolock)
		inner join email.campaigns b (nolock) 
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
			,b.media_type 
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
			,b.media_type 
			,a.campaign_run_id
	from 
		campaign.campaign_run a (nolock)
		inner join [print].campaigns b (nolock) 
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


	--get campaigns list which are < 60 days old and load into #campaigns 
	select *,0 as is_processed into #campaigns from master.campaigns (nolock) where datediff(day,campaign_date,getdate()) < 61
	--select * from #campaigns
	select * into #master_campaign_items from master.campaign_items (nolock)
	truncate table #master_campaign_items
	--select top 3 * from #master_campaign_items
	--Declare variable to use in while loop 
	declare @campaign_id int, @campaign_date date, @media_type varchar(15), @campaign_run_id int, @response_margin int = 61

	IF OBJECT_ID('tempdb..#email_items') IS NOT NULL DROP TABLE #email_items
	IF OBJECT_ID('tempdb..#sms_items') IS NOT NULL DROP TABLE #sms_items
	IF OBJECT_ID('tempdb..#print_items') IS NOT NULL DROP TABLE #print_items
	IF OBJECT_ID('tempdb..#ro_header') IS NOT NULL DROP TABLE #ro_header

	select 	a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.created_dt,a.campaign_run_id 
	into #email_items
	from email.campaign_items a (nolock) where campaign_run_id in (select campaign_run_id from #campaigns) 
	/*
	select 	a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.created_dt,a.campaign_run_id 
	into #sms_items
	from sms.campaign_items a (nolock) where campaign_run_id in (select campaign_run_id from #campaigns) 

	select 	a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.created_dt,a.campaign_run_id 
	into #print_items
	from [print].campaign_items a (nolock) where campaign_run_id in (select campaign_run_id from #campaigns) 
	*/
	select 	master_customer_id,vin,ro_open_date,ROW_NUMBER() over (partition by master_customer_id,vin order by ro_open_date asc) as rnk, 0 as is_response
	into #ro_header
	from master.repair_order_header (nolock) where datediff(day,convert(date,convert(varchar(10),ro_open_date)),getdate())  < 61
			and parent_dealer_id = @dealer_id


	while ((select count(*) from #campaigns where is_processed =0) > 0 )
	BEGIN
		select top 1 
				 @campaign_id = campaign_id
				,@campaign_date = campaign_date
				,@media_type = lower(media_type) 
				,@campaign_run_id = campaign_run_id
			from #campaigns where is_processed =0 order by campaign_date asc

		if (@media_type = 'email')
			BEGIN
					insert into #master_campaign_items 
							(campaign_id,campaign_item_id,list_member_id,vin,run_date,source,campaign_run_id)
					select 
							a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,b.campaign_date,'email', a.campaign_run_id
					from 
							#email_items a (nolock) 
						inner join #campaigns b (nolock)  -- to get campaign_date
									on a.campaign_id = b.campaign_id and a.campaign_run_id = b.campaign_run_id
						inner join #ro_header r (nolock) -- to get responces of campaign
									on a.list_member_id  = r.master_customer_id 
										and a.vin = r.vin
										and datediff(day,convert(date,convert(varchar(10),r.ro_open_date)),b.campaign_date) between 1 and @response_margin
						left outer join #master_campaign_items c  -- avoid duplicate records
									on  a.campaign_id = c.campaign_id 
										and a.list_member_id = c.list_member_id
										and a.campaign_run_id = c.campaign_run_id
					where 
							a.campaign_run_id =  @campaign_run_id
						and c.master_campaign_item_id is null
						and r.rnk =1
						and r.is_response =0

				update a set a.is_response = 1
				--select a.*
				from #ro_header a 
				where master_customer_id in (select list_member_id from #master_campaign_items)
				and vin in (select vin from #master_campaign_items)


			END
	/*
		if (@media_type = 'sms')
			BEGIN
					insert into #master_campaign_items (campaign_id,campaign_item_id,list_member_id,vin,run_date,source)
					select a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.created_dt,'sms'
					from #sms_items a (nolock) 
					inner join #ro_header r (nolock) 
									on a.list_member_id  = r.master_customer_id 
									and datediff(day,convert(date,convert(varchar(10),r.ro_open_date)),a.created_dt) between 1 and @response_margin	
					left outer join #master_campaign_items c 
									on a.campaign_id = c.campaign_id 
									and a.list_member_id = c.list_member_id
									and a.campaign_run_id = c.campaign_run_id
					where 
							a.campaign_run_id =  @campaign_run_id
						and c.master_campaign_item_id is null
			END

		if (@media_type = 'print')
			BEGIN
					insert into #master_campaign_items (campaign_id,campaign_item_id,list_member_id,vin,run_date,source)
					select a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,created_dt,'print'
					from #print_items a (nolock) 
					inner join #ro_header r (nolock) 
									on a.list_member_id  = r.master_customer_id 
									and datediff(day,convert(date,convert(varchar(10),r.ro_open_date)),a.created_dt) between 1 and @response_margin	
					left outer join #master_campaign_items c 
									on a.campaign_id = c.campaign_id 
									and a.list_member_id = c.list_member_id
									and a.campaign_run_id = c.campaign_run_id
					where 
							a.campaign_run_id =  @campaign_run_id
						and c.master_campaign_item_id is null
			END
	*/
		update #campaigns set is_processed =1 where campaign_id = @campaign_id and campaign_date = @campaign_date
		print 1
	END



	-- Insert new items to master.campaign_items from #master_campaign_items
	--insert into master.campaign_items ( campaign_id,campaign_item_id,list_member_id,vin,run_date,source,campaign_run_id)
	select a.campaign_id,a.campaign_item_id,a.list_member_id,a.vin,a.run_date,a.source,a.campaign_run_id
	from #master_campaign_items a
	left outer join master.campaign_items b (nolock) 
				on a.campaign_id  = b.campaign_id 
				and a.campaign_run_id  = b.campaign_run_id  
				and a.list_member_id =b.list_member_id
	where b.master_campaign_item_id is null

	---find responders from #master_campaign_items, group by campaign_id and campaign_date
		select 
				 a.campaign_id
				,a.campaign_run_id
				,count(*) as responders
			into #responders_camp
		from  #master_campaign_items a 
		group by a.campaign_id,a.campaign_run_id



		select b.campaign_id, a.campaign_id, b.campaign_run_id , a.campaign_run_id,
		--update b set
				b.responders , a.responders
		from #responders_camp a
		inner join master.campaigns b (nolock) on a.campaign_id = b.campaign_id  and a.campaign_run_id = b.campaign_run_id



END
USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [master].[cdk_lgt_campaign_response_insert]    Script Date: 12/20/2021 6:33:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure [master].[cdk_lgt_campaign_response_insert]     
--declare 
	--@dealer_id int =1806,
	@natural_key varchar(50)= '76013577'
--	--,@process_id int
As
/*
exec [master].[cdk_lgt_campaign_response_insert]
select * from clictell_auto_master.master.campaigns b (nolock) where campaign_id in (21898,21881)
--select * from auto_customers.email.campaign_items (nolock) where campaign_id in (21898,21881)
select * from clictell_auto_master.master.campaign_items (nolock) where campaign_id in (21898,21881)
select * from clictell_auto_master.master.dealer (nolock) where dealer_name like '%d2%'  --in ('76013577','76213638')
select * from clictell_auto_master.master.dealer (nolock) where _id = 

76213638  --> D2 Powersports
76013577 --> The Brothers Powersports
*/
BEGIN
	--declare @natural_key varchar(20) = '76013577'
	declare @id uniqueidentifier 
			,@dealer_id int 
			,@response_margin int = 60
	select 
		@dealer_id = parent_dealer_id,
		@id = _id
	from clictell_auto_master.master.dealer (nolock) where natural_key =@natural_key

	
	
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
	drop table if exists #response_items
	drop table if exists #insert_master_campaigns
	drop table if exists #lead_appointments
	drop table if exists #apt_email_response_items
	drop table if exists #email_response_items
	drop table if exists #sms_response_items
	drop table if exists #print_response_items
	drop table if exists #apt_email_response_items
	drop table if exists #apt_sms_response_items
	drop table if exists #service_response_items

	select * into #master_campaigns1 from clictell_auto_master.master.campaigns (nolock) where parent_dealer_id = @dealer_id
	
		select distinct
				b.account_id
				,a.campaign_id
				,b.campaign_guid
				,a.run_dt as campaign_date
				,p.[program_name] as program
				,isnull(f.flow_name,b.name) as touchpoint
				,lower(b.media_type) as media_type 
				,a.campaign_run_id
				,@dealer_id as parent_Dealer_id

			into #insert_master_campaigns			---campaigns in last 60 days, not in master.campaigns
		from 
				auto_campaigns.flow.campaign_run a (nolock)
			inner join auto_campaigns.email.campaigns b (nolock) 
						on a.campaign_id = b.campaign_id and a.media_type = b.media_type
			left outer join auto_campaigns.flow.flows f (nolock)	-- to get program_name
						on f.flow_id = b.flow_id
			left outer join auto_campaigns.touchpoint.programs p (nolock) -- to get touchpoint info
						on f.program_id = p.program_id
			left outer join #master_campaigns1 d			-- avoid duplicate records
						on b.campaign_id  = d.campaign_id and a.run_dt = d.campaign_date and a.media_type = d.media_type
		where 
				d.master_campaign_id is null			-- avoid duplicate records insert
				and 
				convert(date,a.run_dt) >= convert(date,dateadd(day,-60,getdate()))  
				and 
				b.account_id = @id  --filter by dealer
				and 
				a.media_type = 'email'

	UNION

		select distinct
				b.account_id
				,a.campaign_id
				,b.campaign_guid
				,a.run_dt as campaign_date
				--,p.[program_name] as program
				--,isnull(f.flow_name,b.name) as touchpoint
				,null as program
				,b.name as touchpoint
				,lower(b.media_type) as media_type 
				,a.campaign_run_id
				,@dealer_id as parent_Dealer_id

		from 
				auto_campaigns.flow.campaign_run a (nolock)
			inner join auto_campaigns.sms.campaigns b (nolock) 
						on a.campaign_id = b.campaign_id and a.media_type = b.media_type
			--left outer join auto_campaigns.flow.flows f (nolock)	-- to get program_name
			--			on f.flow_id = b.flow_id
			--left outer join auto_campaigns.touchpoint.programs p (nolock) -- to get touchpoint
			--			on f.program_id = p.program_id
			left outer join #master_campaigns1 d			-- avoid duplicate records
						on b.campaign_id  = d.campaign_id and a.run_dt = d.campaign_date and a.media_type = d.media_type
		where 
				d.master_campaign_id is null			-- avoid duplicate records insert
				and 
				convert(date,a.run_dt) >= convert(date,dateadd(day,-60,getdate()))  -- get previous days campaign runs
				and 
				b.account_id = @id  --filter by dealer
				and 
				a.media_type = 'sms'

	
		insert into #master_campaigns1			----Final master.campaigns table
		( 
				parent_dealer_id 
				,campaign_id
				,campaign_guid
				,campaign_date
				,program_name
				,touch_point
				,media_type 
				,campaign_run_id

		)
		select 
				parent_dealer_id
				,campaign_id
				,campaign_guid
				,campaign_date
				,program
				,touchpoint
				,media_type
				,campaign_run_id

		from #insert_master_campaigns a

	select *,0 as is_response into #customer_vehicle from auto_customers.customer.vehicles (nolock) where is_deleted =0 and account_id = @id
	select * into #master_campaign_items from clictell_auto_master.master.campaign_items (nolock) where is_deleted =0 and parent_dealer_id = @dealer_id
	select * into #email_campaign_items from auto_campaigns.email.campaign_items (nolock) where is_deleted =0
	select * into #print_campaign_items from auto_campaigns.[print].campaign_items (nolock) where is_deleted =0
	select * into #sms_campaign_items from auto_campaigns.sms.campaign_items (nolock) where is_deleted =0
	select * into #lead_appointments from auto_crm.lead.appointments a (nolock) where is_deleted =0 and account_id = @id


	truncate table #master_campaign_items   ---loaded master.campaign_items table columns and format and deleting data

-- Service Items
		select 	a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.created_dt,a.campaign_run_id, b.campaign_date,r.vehicle_id,r.is_response
				,'Service' as src, r.ro_number,r.last_service_date as ro_date,a.first_name,a.last_name,a.email_address,a.phone
			into #email_response_items
		from #email_campaign_items a (nolock) 
		inner join #master_campaigns1 b on a.campaign_id =b.campaign_id and a.campaign_run_id = b.campaign_run_id
		inner join #customer_vehicle r (nolock) on a.list_member_id  = r.customer_id 
											--and a.vin = r.vin
											and datediff(day,b.campaign_date,r.last_service_date) between 1 and @response_margin
	
		select 	a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.created_dt,a.campaign_run_id, b.campaign_date,r.vehicle_id,r.is_response
				,'Service' as src,r.ro_number,r.last_service_date as ro_date,a.first_name,a.last_name,a.email,a.phone
			into #sms_response_items
		from #sms_campaign_items a (nolock) 
		inner join #master_campaigns1 b on a.campaign_id =b.campaign_id and a.campaign_run_id = b.campaign_run_id
		inner join #customer_vehicle r (nolock) on a.list_member_id  = r.customer_id 
											--and a.vin = r.vin
											and datediff(day,b.campaign_date,r.last_service_date) between 1 and @response_margin


--Extracting Appointment items

		select 	a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.created_dt,a.campaign_run_id, b.campaign_date,null as vehicle_id,0 as is_response
				,'Appointment' as src, r.lead_id as ro_number,r.demo_scheduled_date__c as ro_date,a.first_name,a.last_name,a.email_address,a.phone
			into #apt_email_response_items
		from #email_campaign_items a (nolock) 
		inner join #master_campaigns1 b on a.campaign_id =b.campaign_id and a.campaign_run_id = b.campaign_run_id
		inner join #lead_appointments r (nolock) on a.list_member_id  = r.customer_id 
											and datediff(day,b.campaign_date,r.updated_dt) between 1 and @response_margin
											and r.status = 'Appointment Confirmed'

		select 	a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.created_dt,a.campaign_run_id, b.campaign_date,null as vehicle_id,0 as is_response
				,'Appointment' as src, r.lead_id as ro_number,r.demo_scheduled_date__c as ro_date,a.first_name,a.last_name,a.email,a.phone
			into #apt_sms_response_items
		from #sms_campaign_items a (nolock) 
		inner join #master_campaigns1 b on a.campaign_id =b.campaign_id and a.campaign_run_id = b.campaign_run_id
		inner join #lead_appointments r (nolock) on a.list_member_id  = r.customer_id 
											and datediff(day,b.campaign_date,r.updated_dt) between 1 and @response_margin
											and r.status = 'Appointment Confirmed'


		select * into #response_items
				 from #apt_email_response_items
		UNION
		select * from #apt_sms_response_items


		select * into #service_response_items 
				 from #email_response_items
		UNION
		select * from #sms_response_items


		update a set
			a.src = b.src
			,a.vehicle_id = b.vehicle_id
			,a.created_dt = b.created_dt
			,a.vin = b.vin
			,a.ro_number = b.ro_number
			,a.ro_date = b.ro_date
			,a.first_name = b.first_name
			,a.last_name = b.last_name
			,a.email_address = b.email_address
			,a.phone = b.phone
		from #response_items a
		inner join #service_response_items b on a.campaign_run_id = b.campaign_run_id 
											and a.campaign_item_id = b.campaign_item_id
											and a.list_member_id = b.list_member_id


		insert into #response_items 
		(campaign_id,campaign_item_id,list_member_id,vin,created_dt,campaign_run_id,campaign_date,vehicle_id,is_response,src,ro_number,ro_date,first_name,last_name,email_address,phone)
		select 
		a.campaign_id,a.campaign_item_id,a.list_member_id,a.vin,a.created_dt,a.campaign_run_id,a.campaign_date,a.vehicle_id,a.is_response,a.src,a.ro_number,a.ro_date
		,a.first_name,a.last_name,a.email_address,a.phone
		from #service_response_items a
		left outer join #response_items b on a.campaign_run_id = b.campaign_run_id 
										and a.campaign_item_id = b.campaign_item_id 
										and a.list_member_id = b.list_member_id
		where 
				b.src is null


		select *,0 as is_processed into #master_campaigns from #master_campaigns1 -- adding new column 'is_processed' 
		
		
		DELETE FROM #master_campaigns WHERE campaign_id = 21881 
		

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
						(parent_dealer_id, campaign_id, campaign_item_id, list_member_id, vin, run_date, source, campaign_run_id, response_number,response_date
						,first_name,last_name,email_address,phone_number)
				select 
						@parent_dealer_id, a.campaign_id, a.campaign_item_id,a.list_member_id, a.vin,a.campaign_date,src, a.campaign_run_id, a.ro_number,a.ro_date
						,first_name,last_name,email_address,phone
				from 
						#response_items a (nolock) 
				where 
						a.campaign_id =  @campaign_id
					and a.is_response = 0  --check if the record is considered as response to other campaigns ?

			update a set is_response = 1 from #response_items a where list_member_id in (select list_member_id from #master_campaign_items) 
																		
			update #master_campaigns set is_processed =1 where campaign_id = @campaign_id 
																and convert(date,campaign_date) = convert(date,@campaign_date)

		END



/*
return;


select * from clictell_auto_master.master.campaign_items (nolock) where campaign_id =21898 and list_member_id in (3447766
,3458335
,1963391
,1895423
,1969933
,3446494
,1972223
,1971461
,1970693)

select * from auto_crm.lead.appointments (nolock) where lead_id in (select response_number from clictell_auto_master.master.campaign_items (nolock) where campaign_id =21898)
select * from clictell_auto_master.master.campaign_items (nolock) where campaign_id =21898
select * from #master_campaigns where campaign_id in (21881,21898)
select * from auto_campaigns.flow.campaign_run a (nolock) where campaign_id in (21881,21898)

select * from #master_campaign_items where list_member_id = 1895423
select * from #lead_appointments where customer_id in (1895423)

--1895423
select list_member_id,count(*) from #master_campaign_items group by list_member_id
select * from #email_campaign_items
select * from #response_items where list_member_id in (1895423)
select * from #master_campaign_items where response_number in (1895423)
select * from #apt_email_response_items
select * from #lead_appointments
select * from clictell_auto_master.master.campaign_items (nolock)
select * from clictell_auto_master.master.campaigns (nolock) order by created_dt desc
select campaign_id, campaign_run_id, touch_point from clictell_auto_master.master.campaigns (nolock) where parent_dealer_id =4336
campaign_run_id =22627 and campaign_id = 21672 and parent_dealer_id =4336
campaign_run_id =22626 and campaign_id = 21672 and parent_dealer_id =4336

select * from #master_campaign_items order by  email_address
select * from #master_campaigns
*/
------------------------------INSERT INTO MASTER.CAMPAIGNS TABLE-----------------


		insert into clictell_auto_master.master.campaigns 
		( 
				parent_dealer_id 
				,campaign_id
				,campaign_guid
				,campaign_date
				,program_name
				,touch_point
				,media_type 
				,campaign_run_id

		)

		select 
				 a.parent_dealer_id
				 ,a.campaign_id
				 ,a.campaign_guid
				 ,a.campaign_date
				 ,a.program_name
				 ,a.touch_point
				 ,a.media_type
				 ,a.campaign_run_id
		from #master_campaigns a
		left outer join clictell_auto_master.master.campaigns b				-- avoid duplicate records
			on a.campaign_id  = b.campaign_id and a.campaign_date = b.campaign_date and a.media_type = b.media_type
		where 
			b.master_campaign_id is null
	


		--select 
		update a set 
		a.source = concat(left(a.source,3),' ',left(b.source,3))
		,a.response_number = b.response_number
		,a.response_date = b.response_date
		,a.vin = b.vin
		,a.first_name = b.first_name
		,a.last_name = b.last_name
		,a.email_address = b.email_address
		,a.phone_number = b.phone_number
		/* select 
		a.response_number , b.response_number
		,a.response_date , b.response_date
		,a.vin , b.vin
		,a.first_name , b.first_name
		,a.last_name , b.last_name
		,a.email_address , b.email_address
		,a.phone_number , b.phone_number
		*/
		from clictell_auto_master.master.campaign_items a (nolock)
		inner join #master_campaign_items b 
						on a.list_member_id = b.list_member_id and a.campaign_run_id = b.campaign_run_id and a.response_number <> b.response_number
	

		insert into clictell_auto_master.master.campaign_items 
			(parent_dealer_id,campaign_id,campaign_item_id,list_member_id,vin,run_date,source,campaign_run_id,response_number,response_date,first_name,last_name,email_address,phone_number)
		select 
			a.parent_dealer_id,a.campaign_id,a.campaign_item_id,a.list_member_id,a.vin,a.run_date,a.source,a.campaign_run_id,a.response_number,a.response_date,a.first_name,a.last_name,a.email_address,a.phone_number
		from #master_campaign_items a
		left outer join clictell_auto_master.master.campaign_items b (nolock) --avoid duplicate insert
					on a.campaign_id  = b.campaign_id 
					and a.campaign_run_id  = b.campaign_run_id  
					and a.list_member_id =b.list_member_id
		where b.master_campaign_item_id is null
		

	---Update sent column in master.campaigns	
		select campaign_id,campaign_run_id, count(*) as sent 
			into #sent 
											from auto_customers.[email].campaign_items (nolock) where campaign_run_id is not null group by campaign_id,campaign_run_id 
		UNION
		select campaign_id,run_id, count(*) from auto_customers.[print].campaign_items (nolock) where run_id is not null group by campaign_id,run_id 
		UNION
		select campaign_id,campaign_run_id, count(*) from auto_customers.[sms].campaign_items (nolock) where campaign_run_id is not null group by campaign_id,campaign_run_id 

		update b set 
				b.sent = s.sent
		--select s.campaign_id,s.campaign_run_id,b.sent,s.sent
		from clictell_auto_master.master.campaigns b (nolock)
		inner join #sent s 
						on b.campaign_id = s.campaign_id and b.campaign_run_id = s.campaign_run_id
		where isnull(b.sent,0) <> isnull(s.sent,0)


	---Update Responders column in master.campaigns				
		select 
				 a.campaign_id
				,a.campaign_run_id
				,count(*) as responders
			into #responders_camp
		from  clictell_auto_master.master.campaign_items a 
		group by a.campaign_id,a.campaign_run_id
		


		update b set
				b.responders = a.responders
		--select b.campaign_id,b.campaign_run_id,a.responders,b.responders --campaign_run_id = 22603
		from #responders_camp a
		inner join clictell_auto_master.master.campaigns b (nolock) 
						on a.campaign_id = b.campaign_id  and a.campaign_run_id = b.campaign_run_id
		where isnull(a.responders,0) <> isnull(b.responders,0)



		
END


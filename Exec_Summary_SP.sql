USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[exec_summary1]    Script Date: 10/4/2021 7:01:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [reports].[exec_summary1]	
--declare
--@dealer varchar(4000) = '1806', 
@parent_id varchar(100)= '7113589E-B6E0-11EB-82D4-0A4357799CFA',
--'E26CE42E-BD40-11EB-B988-0A4357799CFA',
--'3397D8EA-BD3A-11EB-845D-0A4357799CFA',
@FromDate date = '2020-01-01',  
@ToDate date = '2021-08-16'

/*
exec [reports].[exec_summary1] '3397D8EA-BD3A-11EB-845D-0A4357799CFA','2021-08-01','2021-08-17'
*/
AS
BEGIN

declare @is_test int = 1

IF @is_test = 1
BEGIN
	/*	select 
			'Email' as campaign_type
			,873 as emails
			,0 as smss
			0 as mails
			,1521.00 as cp_amnt
			,7841.00 as wp_amnt 
			,1521.00+7841.00 as total_ro_sale
			, 41 as responders_count, 873*0.10 as investment
			, 41.0/873 as response_rate
			,(1521.00+7841.00)/41 as total_sales_per_responce
			, (873*0.10)/41 as cost_per_response
			, ((1521.00+7841.0)-(873*0.10))/873 as sales_roi
			,'Honda' as parent_name

		union

		select 
			'Print'
			,0 
			,0 
			,500 
			,4861.00 
			,5512.00 
			,4861.00+5512.00
			, 150
			, 500*1.0
			, 150.0/500
			,(4861.00+5512.00)/150
			, (500*1)/150
			,((4861.00+5512.00)-500)/500
			,'Honda'
			*/



			select
			(select dealer_name from master.dealer (nolock) where _id=@parent_id) as dealer_name
			,'Ongoing Service' as program
			,'Maintenance Reminder' as touch_point
			,410 as total_sent
			,55 as mail
			,105 as email 
			,250 as text
			,320 as responders
			,320.00/410 as response_rate
			,10568 as total_cp
			,20014 as total_wp
			,7548 as total_ip
			,(7548+20014+10568)/320 as avg_responder_rev
			,(55.00*1+105.00*0.1+250.00+0.2) as investment
			,(7548.00+20014.00+10568.00)/(55.00*1+105.00*0.1+250.00+0.2) as roi

			union

			select
			(select dealer_name from master.dealer (nolock) where _id=@parent_id) as dealer_name
			,'Ongoing Service' as program
			,'Overdue Service' as touch_point
			,220 as total_sent
			,20 as mail
			,50 as email 
			,150 as text
			,170 as responders
			,170.00/220 as response_rate
			,7568 as total_cp
			,10014 as total_wp
			,2048 as total_ip
			,(2048+10014+7568)/170 as avg_responder_rev
			,(20.00*1+50.00*0.1+150.00*0.2)
			,(2048.00+10014.00+7568.00)/(20.00*1+50.00*0.1+150.00*0.2) as roi

			union

			select
			(select dealer_name from master.dealer (nolock) where _id=@parent_id) as dealer_name
			,'Ongoing Service' as program
			,'State Inspection Overdue' as touch_point
			,1042 as total_sent
			,200 as mail
			,500 as email 
			,342 as text
			,985 as responders
			,985.00/1042 as response_rate
			,15047 as total_cp
			,10230 as total_wp
			,152 as total_ip
			,(152+10230+15047)/985 as avg_responder_rev	
			,(200.00*1+500.00*0.1+342.00*0.2)
			,(152.00+10230.00+15047.00)/(200.00*1+500.00*0.1+342.00*0.2)

			union

			select
			(select dealer_name from master.dealer (nolock) where _id=@parent_id) as dealer_name
			,'Lapsed Customer' as program
			,'WinBack' as touch_point
			,521 as total_sent
			,150 as mail
			,220 as email 
			,151 as text
			,152 as responders
			,152.00/521 as response_rate
			,4589 as total_cp
			,6641 as total_wp
			,1054 as total_ip
			,(1054+6641+4589)/151 as avg_responder_rev	
			,(150.00*1+220.00*0.1+151.00*0.2)
			,(1054.00+6641.00+4589.00)/(150.00*1+220.00*0.1+151.00*0.2) 


			union

			select
			(select dealer_name from master.dealer (nolock) where _id=@parent_id) as dealer_name
			,'Lost Customer' as program
			,'Lost Customer' as touch_point
			,226 as total_sent
			,25 as mail
			,100 as email 
			,101 as text
			,56 as responders
			,56.00/226 as response_rate
			,6583 as total_cp
			,4586 as total_wp
			,1021 as total_ip
			,(1021+4586+6583)/56 as avg_responder_rev
			,(25.00*1+100.00*0.1+101.00*0.2)
			,(1021.00+4586.00+6583.00)/(25.00*1+100.00*0.1+101.00*0.2)

			union

			select
			(select dealer_name from master.dealer (nolock) where _id=@parent_id) as dealer_name
			,'Others' as program
			,'Next Best Service' as touch_point
			,1145 as total_sent
			,624 as mail
			,320 as email 
			,200 as text
			,927 as responders
			,927.00/1145 as response_rate
			,20428 as total_cp
			,22136 as total_wp
			,10045 as total_ip
			,(10045+22136+20428)/927 as avg_responder_rev	
			,(624.00*1+320.00*0.1+200.00*0.2)
			,(10045.00+22136.00+20428.00)/(624.00*1+320.00*0.1+200.00*0.2)

			union

			select
			(select dealer_name from master.dealer (nolock) where _id=@parent_id) as dealer_name
			,'Anniversary' as program
			,'Happy Anniversary - 1 Year' as touch_point
			,501 as total_sent
			,100 as mail
			,250 as email 
			,151 as text
			,480 as responders
			,480.00/501 as response_rate
			,4052 as total_cp
			,6641 as total_wp
			,528 as total_ip
			,(528+6641+4052)/480 as avg_responder_rev	
			,(100.00*1+250.00*0.1+151.00*0.2)
			,(528.00+6641.00+4052.00)/(100.00*1+250.00*0.1+151.00*0.2)

END

ELSE
BEGIN
		IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

		---------------------- extract parent_dealer_id of all the dealers under the hierarchy of @parent_id
		;with dealers (_id,parentid,parent_dealer_id, dealer_name)
		as
		(
		select distinct _id,parentid,parent_dealer_id,dealer_name from master.dealer (nolock) where _id =@parent_id
		union all
		select  m._id,m.parentid,m.parent_dealer_id,m.dealer_name from master.dealer m (nolock) inner join dealers d on m.parentid =d._id
		and m.parentid is not null
		)
		select string_agg(cast(parent_dealer_id as varchar(max)),',') as parent_dealer_id into #temp from dealers
		-----------------------------------------------------------------------------


		---------------------extracting dealers from recursive CTE and parent name from #temp
		declare @dealer varchar(max)=(select parent_dealer_id  from #temp)
		declare @parent_name varchar(100) = (select dealer_name from master.dealer (nolock) where _id=@parent_id)
		----------------------------------------------------


		----------------------Finding total Resonses for use in calculations (Pie Charts)
		declare @total_responces decimal(18,2) = (select sum(responders) from [master].[campaign_responses] r (nolock)
								where r.parent_dealer_id  in (select value from [dbo].[fn_split_string_to_column] (@dealer, ','))  
										and r.campaign_date between @FromDate and @ToDate
										and r.is_deleted=0 )
		-----------------------------------------------------

		select 
		
				 media_type as campaign_type
				,iif(media_type='Email', sum(sent),0) as emails
				,iif(media_type='SMS',	  sum(sent),0) as smss
				,iif(media_type='Print', sum(sent),0) as mails
				,sum(cp_amount) as cp_amnt
				,sum(wp_amount) as wp_amnt
				,sum(ro_amount) as total_ro_sale
				,sum(responders) as responders_count
				,(case  when media_type='Email' then sum([sent])*0.2
						when media_type='SMS'	then sum([sent])*0.1
						when media_type='Print' then sum([sent])*0.5
						else null end)	as investment
				--,convert(decimal(18,2),sum(responders))/iif(sum(sent)=0,1,sum(sent)) as response_rate
				,convert(decimal(18,2),sum(responders))/iif(@total_responces=0,1,@total_responces) as response_rate
				,sum(ro_amount) /iif(sum(isnull(responders,0))=0,1,sum(responders)) as total_sales_per_responce
				,sum([sent])*0.1/iif(sum(isnull(responders,0))=0,1,sum(responders)) as cost_per_response
				,(sum(ro_amount)/(iif(sum([sent])=0,1,sum([sent]))*(case when media_type='Email' then 0.2
													when media_type='SMS'	then 0.1
													when media_type='Print' then 0.5
													else null end)))*100	as sales_roi							/* FORMULA:: return on Investment = (profit/investment) * 100 */
				,@parent_name as parent_name
		 into #temp_result
		from [master].[campaign_responses] r (nolock)
		where r.parent_dealer_id  in (select value from [dbo].[fn_split_string_to_column] (@dealer, ','))  
				and r.campaign_date between @FromDate and @ToDate
				and r.is_deleted=0
		group by r.media_type



		select * from #temp_result

	END

end
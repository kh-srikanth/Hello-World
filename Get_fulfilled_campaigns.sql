USE [auto_campaigns]
GO
/****** Object:  StoredProcedure [analytics].[get_fulfilled_campaigns]    Script Date: 12/16/2021 1:05:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [analytics].[get_fulfilled_campaigns]
 --declare    
    @account_id uniqueidentifier = '95ac28d8-d513-4b0e-b234-d989c4d2f0bc',
	@media_type varchar(50) = 'email',
	@page_no int = 1,
	@page_size int = 20,
	@sort_column varchar(50) = 'CampaignId',
	@sort_order varchar(5) = 'desc',
	@search  varchar(5) = '',
	@campaign_name varchar(100) = '',
	@status varchar(50) = '',
	@campaign_type varchar(500) = '',
	@created_start_date Date = '',
	@created_end_date Date = ''

AS        
      
/*
	 exec [analytics].[get_fulfilled_campaigns]  '95ac28d8-d513-4b0e-b234-d989c4d2f0bc','email',1,50,'CampaignId','desc','','','','',''
	 ------------------------------------------------------------------------               
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date			Author					Work Tracker Id			Description          
	 -------------------------------------------------------------------------        
	 03/11/2021		Raviteja.V.V			Created -				To get campaigns   
	 10/05/2021		Santhosh.B				Modified				Modified logic to pick the active campaigns from flow.flow.
	 -------------------------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN

SET NOCOUNT ON  


		IF OBJECT_ID('tempdb..#temp_Json') IS NOT NULL    
		DROP TABLE #temp_Json    

		IF OBJECT_ID('tempdb..#temp_campaignguids') IS NOT NULL    
		DROP TABLE #temp_campaignguids    

		IF OBJECT_ID('tempdb..#temp_nonflow_campaigns') IS NOT NULL    
		DROP TABLE #temp_nonflow_campaigns    

		IF OBJECT_ID('tempdb..#temp_flow_campaigns') IS NOT NULL    
		DROP TABLE #temp_flow_campaigns    
			    
	 declare @start int, @end int

	 --init start page if page number is wrong.
	 set @page_no = IIF(@page_no > 0, @page_no, 1)
	 set @page_no = @page_no - 1

	 --set offset
	 set @start = (@page_no * @page_size);
	 set @end = @start + @page_size;
	 set @campaign_name = TRIM(@campaign_name)
	 set @status = TRIM(@status)
	 set @campaign_type = TRIM(@campaign_type)
	 set @campaign_name = isnull(@campaign_name, '')
	 set @status = isnull(@status,'')
	 set @campaign_type = isnull(@campaign_type,'')
	

	select 
		a.flow_id,
		a.flow_json,
		a.status_type_id,
		Json_Query(a.flow_json, '$.rules') as rules_json
	into 
		#temp_Json
	from 
		flow.flows a (nolock) 
	where 
			account_id = @account_id 
		and flow_json is not null 
		and status_type_id = 1

	select 
		a.flow_id, 
		a.status_type_id,
		JSON_VALUE(b.[value],'$.campaignGuid') as campaignguid
	into 
		#temp_campaignguids
	from 
	(
		select 
			a.*, 
			Json_query(b.[value], '$.rules') as rules_rules
		from 
			#temp_Json a
		cross apply OpenJson(rules_json) b
	) as a
	cross apply OpenJson(rules_rules) as b
	
   ;With CTE_Campaigns as
   (
	 select cc.campaign_id,
			cc.campaign_guid,
			cc.name,
			cc.status_type_id,		
			cc.media_type as media_name,
			isnull(cco.sent,0) as sent,
			isnull(cco.delivered,0) as delivered,
			isnull(cco.undelivered,0) as undelivered,
			isnull(cco.opened,0) as opened,
			isnull(cco.clicked,0) as clicked,
			isnull(cco.blocked,0) as blocked,
			isnull(cco.bounced,0) as bounced, 
			isnull(cco.unsubscribed,0) as unsubscribed,
			cc.scheduled_date as sent_on,
			isnull(cc.updated_dt,cc.created_dt) as created_date,
			cc.updated_dt,
			0 as responders_count,
		count(cc.[campaign_id]) over() as [total_count]
		--ROW_NUMBER() over (order by 
		--	case when (@sort_column = 'CampaignId' and @sort_order='asc') then cc.[campaign_id] end asc,
		--	case when (@sort_column = 'CampaignId' and @sort_order='desc') then cc.[campaign_id] end desc,
		--	case when (@sort_column = 'CampaignName' and @sort_order='asc') then cc.[name] end asc,
		--	case when (@sort_column = 'CampaignName' and @sort_order='desc') then cc.[name] end desc,
		--	case when (@sort_column = 'CreatedDt' and @sort_order='asc') then cc.[created_dt] end asc,
		--	case when (@sort_column = 'CreatedDt' and @sort_order='desc') then cc.[created_dt] end desc
		--) as [row_number]
	from
		[email].[campaigns] cc with(nolock,readuncommitted)
			inner join [program].[program] pp with(nolock,readuncommitted) on
			     (cc.program_id = pp.program_id)
			inner join [campaign].[status_type] cst with(nolock,readuncommitted) on
				cc.status_type_id = cst.status_type_id
			inner join [campaign].[campaign_type] cct with(nolock,readuncommitted) on
				cc.campaign_type_id = cct.campaign_type_id
			left outer join [email].[counts] cco with(nolock,readuncommitted) on
				cco.campaign_id = cc.campaign_id 

	where
	        cc.account_id  = @account_id and
			cc.media_type = @media_type and
			cc.status_type_id = 6 and
			cst.is_deleted = 0 and
			cc.is_deleted = 0  
			and cc.is_flow_campaign = 0
		and (@campaign_name='' or cc.[name] like '%'+ @campaign_name + '%')
		and (@status=''  or cst.status_type like '%'+ @status +'%')
		--and (@campaign_type=''  or cct.campaign_type_name like '%'+ @campaign_type +'%')
		and pp.[program_name] = case when (len(trim(@campaign_type)) = 0 or @campaign_type = 'All') then pp.[program_name] else @campaign_type end
		and	((@created_start_date = '' or cast(cc.created_dt as date) >= @created_start_date) 
					and
				(@created_end_date = '' or cast(cc.created_dt as date) <= @created_end_date))
	)
	select * into #temp_nonflow_campaigns from CTE_Campaigns 
	--where [row_number] > @start and [row_number] <= @end 

	--Print 'Row Count : ' + cast(@@RowCount as varchar(50))

	;With CTE_Campaigns as
	(
	 select cc.campaign_id,
			cc.campaign_guid,
			cc.name,
			cc.status_type_id,		
			cc.media_type as media_name,
			isnull(cco.sent,0) as sent,
			isnull(cco.delivered,0) as delivered,
			isnull(cco.undelivered,0) as undelivered,
			isnull(cco.opened,0) as opened,
			isnull(cco.clicked,0) as clicked,
			isnull(cco.blocked,0) as blocked,
			isnull(cco.bounced,0) as bounced, 
			isnull(cco.unsubscribed,0) as unsubscribed,
			cc.scheduled_date as sent_on,
			isnull(cc.updated_dt,cc.created_dt) as created_date,
			cc.updated_dt,
			0 as responders_count,
		count(cc.[campaign_id]) over() as [total_count]
		--ROW_NUMBER() over (order by 
		--	case when (@sort_column = 'CampaignId' and @sort_order='asc') then cc.[campaign_id] end asc,
		--	case when (@sort_column = 'CampaignId' and @sort_order='desc') then cc.[campaign_id] end desc,
		--	case when (@sort_column = 'CampaignName' and @sort_order='asc') then cc.[name] end asc,
		--	case when (@sort_column = 'CampaignName' and @sort_order='desc') then cc.[name] end desc,
		--	case when (@sort_column = 'CreatedDt' and @sort_order='asc') then cc.[created_dt] end asc,
		--	case when (@sort_column = 'CreatedDt' and @sort_order='desc') then cc.[created_dt] end desc
		--) as [row_number]
	from
		[email].[campaigns] cc with(nolock,readuncommitted)
			inner join [program].[program] pp with(nolock,readuncommitted) on
			     (cc.program_id = pp.program_id)
			inner join [campaign].[status_type] cst with(nolock,readuncommitted) on
				cc.status_type_id = cst.status_type_id
			inner join [campaign].[campaign_type] cct with(nolock,readuncommitted) on
				cc.campaign_type_id = cct.campaign_type_id
			left outer join [email].[counts] cco with(nolock,readuncommitted) on
				cco.campaign_id = cc.campaign_id 

	where
	        cc.account_id  = @account_id and
			cc.media_type = @media_type and
			--cc.status_type_id = 6 and
			cst.is_deleted = 0 and
			cc.is_deleted = 0  
			and cc.campaign_guid  in (select distinct campaignguid from #temp_campaignguids where campaignguid is not null)
		and (@campaign_name='' or cc.[name] like '%'+ @campaign_name + '%')
		and (@status=''  or cst.status_type like '%'+ @status +'%')
		--and (@campaign_type=''  or cct.campaign_type_name like '%'+ @campaign_type +'%')
		and pp.[program_name] = case when (len(trim(@campaign_type)) = 0 or @campaign_type = 'All') then pp.[program_name] else @campaign_type end
		and	((@created_start_date = '' or cast(cc.created_dt as date) >= @created_start_date) 
					and
				(@created_end_date = '' or cast(cc.created_dt as date) <= @created_end_date))
	)
	
	select * into #temp_flow_campaigns from CTE_Campaigns
	--where [row_number] > @start and [row_number] <= @end

	--Print 'Row Count : ' + cast(@@RowCount as varchar(50))

	select * into #temp_final_query from #temp_nonflow_campaigns 
	Union
	select * from #temp_flow_campaigns 
	order by campaign_id desc


IF OBJECT_ID('tempdb..#result') IS NOT NULL  DROP TABLE #result   

	select * into #result from 
	(
	select  
	        campaign_id,
		    campaign_guid,
			name,
			status_type_id,		
			media_name,
			isnull(sent,0) as sent,
			isnull(delivered,0) as delivered,
			isnull(undelivered,0) as undelivered,
			isnull(opened,0) as opened,
			isnull(clicked,0) as clicked,
			isnull(blocked,0) as blocked,
			isnull(bounced,0) as bounced, 
			isnull(unsubscribed,0) as unsubscribed,
			sent_on,
			created_date,
			updated_dt,
			0 as responders_count,
		   count([campaign_id]) over() as [total_count],
	       ROW_NUMBER() over (order by 
			case when (@sort_column = 'CampaignId' and @sort_order='asc') then [campaign_id] end asc,
			case when (@sort_column = 'CampaignId' and @sort_order='desc') then [campaign_id] end desc,
			case when (@sort_column = 'CampaignName' and @sort_order='asc') then [name] end asc,
			case when (@sort_column = 'CampaignName' and @sort_order='desc') then [name] end desc,
			case when (@sort_column = 'CreatedDt' and @sort_order='asc') then created_date end asc,
			case when (@sort_column = 'CreatedDt' and @sort_order='desc') then created_date end desc
		) as [row_number]

	from #temp_final_query 
	) as a  where [row_number] > @start and [row_number] <= @end
	
	
--select * from #result
--Adding Dummy Data into result

update #result set sent = 1376, delivered = 1325, undelivered = 1376-1325, opened = 500, clicked = 250, blocked =10, bounced = 10, unsubscribed =3, responders_count =30 where [name] = 'Blue Link Lifecycle Communications'
update #result set sent = 176, delivered = 120, undelivered = 176-120, opened = 54, clicked = 22, blocked =1, bounced = 0, unsubscribed =1, responders_count =12 where [name] = 'Monthly Vehicle Health Report'
update #result set sent = 45, delivered = 45, undelivered = 0, opened = 35, clicked = 30, blocked =0, bounced = 1, unsubscribed =0, responders_count =10 where [name] = 'Notification/Survey'
update #result set sent = 257, delivered = 244, undelivered = 257-244, opened = 200, clicked = 185, blocked =4, bounced = 6, unsubscribed =4, responders_count =22 where [name] = 'Lifecycle Communications'
update #result set sent = 44, delivered = 40, undelivered = 5, opened = 30, clicked = 20, blocked =2, bounced = 7, unsubscribed =3, responders_count =20 where [name] = 'Waiver'
update #result set sent = 150, delivered = 144, undelivered = 6, opened = 115, clicked = 100, blocked =2, bounced = 5, unsubscribed =0, responders_count =98 where [name] = 'PPM Lost Customer'
update #result set sent = 235, delivered = 198, undelivered = 235-198, opened = 152, clicked = 120, blocked =5, bounced = 0, unsubscribed =3, responders_count =85 where [name] = 'PPM WinBack'
update #result set sent = 150, delivered = 144, undelivered = 6, opened = 115, clicked = 100, blocked =2, bounced = 5, unsubscribed =3, responders_count =102 where [name] = 'Program Updates'
update #result set sent = 44, delivered = 40, undelivered = 5, opened = 35, clicked = 30, blocked =0, bounced = 0, unsubscribed =1, responders_count =20 where [name] = 'Upsell Opportunity'
update #result set sent = 257, delivered = 244, undelivered = 257-244, opened = 200, clicked = 185, blocked =4, bounced = 6, unsubscribed =4, responders_count =22 where [name] = 'Thank You for Service'
update #result set sent = 176, delivered = 120, undelivered = 176-120, opened = 54, clicked = 22, blocked =1, bounced = 0, unsubscribed =1, responders_count =12 where [name] = 'PPM Opportunity'
update #result set sent = 235, delivered = 198, undelivered = 235-198, opened = 152, clicked = 120, blocked =5, bounced = 0, unsubscribed =3, responders_count =85 where [name] = 'PPM Service Reminder'
update #result set sent = 45, delivered = 45, undelivered = 0, opened = 35, clicked = 30, blocked =0, bounced = 1, unsubscribed =0, responders_count =10 where [name] = 'Enrollment Thank You'
update #result set sent = 150, delivered = 144, undelivered = 6, opened = 115, clicked = 100, blocked =2, bounced = 5, unsubscribed =0, responders_count =98 where [name] = 'Welcome: Plan Options/Benifits'
update #result set sent = 1376, delivered = 1325, undelivered = 1376-1325, opened = 500, clicked = 250, blocked =2, bounced = 5, unsubscribed =3, responders_count =80 where [name] = 'Service & Protection Plans'
update #result set sent = 150, delivered = 144, undelivered = 6, opened = 115, clicked = 100, blocked =2, bounced = 5, unsubscribed =0, responders_count =98 where [name] = 'Defector Communication'
update #result set sent = 1376, delivered = 1325, undelivered = 1376-1325, opened = 500, clicked = 250, blocked =10, bounced = 10, unsubscribed =3, responders_count =30 where [name] = 'Happy Anniversary - 1 Year'
update #result set sent = 45, delivered = 45, undelivered = 0, opened = 35, clicked = 30, blocked =0, bounced = 1, unsubscribed =0, responders_count =10 where [name] = 'Happy Birthday'
update #result set sent = 45, delivered = 45, undelivered = 0, opened = 35, clicked = 30, blocked =0, bounced = 1, unsubscribed =0, responders_count =10 where [name] = 'Thank you for Service'
update #result set sent = 257, delivered = 244, undelivered = 257-244, opened = 200, clicked = 185, blocked =4, bounced = 6, unsubscribed =4, responders_count =22 where [name] = 'Monthly Statements'
update #result set sent = 44, delivered = 40, undelivered = 5, opened = 30, clicked = 20, blocked =2, bounced = 7, unsubscribed =3, responders_count =20 where [name] = 'Tire Campaign'
update #result set sent = 150, delivered = 144, undelivered = 6, opened = 115, clicked = 100, blocked =2, bounced = 5, unsubscribed =0, responders_count =98 where [name] = 'Recall Email # 1'
update #result set sent = 235, delivered = 198, undelivered = 235-198, opened = 152, clicked = 120, blocked =5, bounced = 0, unsubscribed =3, responders_count =85 where [name] = 'Battery Campaign'
update #result set sent = 150, delivered = 144, undelivered = 6, opened = 115, clicked = 100, blocked =2, bounced = 5, unsubscribed =3, responders_count =102 where [name] = 'Lease End of Term - 90 days'
update #result set sent = 44, delivered = 40, undelivered = 5, opened = 35, clicked = 30, blocked =0, bounced = 0, unsubscribed =1, responders_count =20 where [name] = 'End of Finance'
update #result set sent = 257, delivered = 244, undelivered = 257-244, opened = 200, clicked = 185, blocked =4, bounced = 6, unsubscribed =4, responders_count =22 where [name] = 'Introduction to Accessories Dept.'
update #result set sent = 176, delivered = 120, undelivered = 176-120, opened = 54, clicked = 22, blocked =1, bounced = 0, unsubscribed =1, responders_count =12 where [name] = 'Introduction to Service Dept'
update #result set sent = 235, delivered = 198, undelivered = 235-198, opened = 152, clicked = 120, blocked =5, bounced = 0, unsubscribed =3, responders_count =85 where [name] = 'Purchase Thank You'
update #result set sent = 1376, delivered = 1325, undelivered = 1376-1325, opened = 500, clicked = 250, blocked =10, bounced = 10, unsubscribed =3, responders_count =30 where [name] = 'Connected Care + Remote & Guidance #2'
update #result set sent = 176, delivered = 120, undelivered = 176-120, opened = 54, clicked = 22, blocked =1, bounced = 0, unsubscribed =1, responders_count =12 where [name] = 'Connected Care + Remote & Guidance #1'
update #result set sent = 45, delivered = 45, undelivered = 0, opened = 35, clicked = 30, blocked =0, bounced = 1, unsubscribed =0, responders_count =10 where [name] = 'Connected Care + Remote & Guidance '
update #result set sent = 257, delivered = 244, undelivered = 257-244, opened = 200, clicked = 185, blocked =4, bounced = 6, unsubscribed =4, responders_count =22 where [name] = 'Connected Care + Remote#2'
update #result set sent = 44, delivered = 40, undelivered = 5, opened = 30, clicked = 20, blocked =2, bounced = 7, unsubscribed =3, responders_count =20 where [name] = 'Connected Care + Remote#1'
update #result set sent = 150, delivered = 144, undelivered = 6, opened = 115, clicked = 100, blocked =2, bounced = 5, unsubscribed =0, responders_count =98 where [name] = 'Connected Care + Remote'
update #result set sent = 176, delivered = 120, undelivered = 176-120, opened = 54, clicked = 22, blocked =1, bounced = 0, unsubscribed =1, responders_count =12 where [name] = 'Connected Care Free Trail(no CC)#3'
update #result set sent = 235, delivered = 198, undelivered = 235-198, opened = 152, clicked = 120, blocked =5, bounced = 0, unsubscribed =3, responders_count =85 where [name] = 'Connected Care Free Trail(no CC)#2'
update #result set sent = 1376, delivered = 1325, undelivered = 1376-1325, opened = 500, clicked = 250, blocked =10, bounced = 10, unsubscribed =3, responders_count =30 where [name] = 'Connected Care Free Trail(no CC)'
update #result set sent = 176, delivered = 120, undelivered = 176-120, opened = 54, clicked = 22, blocked =1, bounced = 0, unsubscribed =1, responders_count =12 where [name] = 'Lease End of Term - 120 days'

	
	
	select 
		campaign_id
		,campaign_guid
		,name
		,status_type_id
		,media_name
		,sent
		,delivered
		,undelivered
		,opened
		,clicked
		,blocked
		,bounced
		,unsubscribed
		,sent_on
		,created_date
		,updated_dt
		,responders_count
		,[total_count]
		,[row_number]
	
	
	from #result
	
	





SET NOCOUNT OFF

END

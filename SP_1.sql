USE [auto_campaigns]
GO
/****** Object:  StoredProcedure [sms].[get_campaigns]    Script Date: 10/21/2021 6:16:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [sms].[get_campaigns]
 --declare    
    @account_id uniqueidentifier = '7DB79611-A797-4938-AAC8-F3A887384304',
	@page_no int = 1,
	@page_size int = 50,
	@sort_column varchar(50) = 'CampaignId',
	@sort_order varchar(5) = 'desc',
	@campaign_name varchar(100) = '',--'9.16.21',
	@status varchar(50) = 'Delivered',
	@campaign_type varchar(500) = '',
	@created_start_date Date = '',
	@created_end_date Date = ''
	,@account_level int = 0
	,@campaign_level int = 0
AS        
      
/*
	 exec [sms].[get_campaigns]  '93D00129-A276-49FF-BFEB-8C80B5443B72','1','12','0','desc','','','sa','','2021-03-30'
	 ------------------------------------------------------------------------               
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date          Author     Work Tracker Id   Description          
	 -------------------------------------------------------------------------        
	 03/11/2021		Raviteja.V.V				Created -  To get campaigns  
	5/20/21			madhavi						modified - multi_channe_campaign_id added
	  13/9/21		madhavi						modifed - account_level added
	   15/9/21		madhavi						modifed - camapgin_level added
	    16/9/21		madhavi						modifed - parent_campaign_id added
	 10-21-2021		Srikanth K					modified - Added Sent, delivered coulmns 
	 -------------------------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN

SET NOCOUNT ON  

	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp 
	IF OBJECT_ID('tempdb..#sent_deli') IS NOT NULL DROP TABLE #sent_deli 

		create table #temp
		(
			account_id uniqueidentifier
		)			    
	 declare @start int, @end int
	 declare @is_archive int = 0
	 set @is_archive = case when @status = 'archived' then 0
							else  14 end

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
	 set @created_end_date = isnull(@created_end_date,'')
	 set @created_start_date = isnull(@created_start_date,'')

	 if(@account_level > 1)
	 begin
		insert into #temp 
		select *  from [dbo].[get_account_ids](@account_level , @account_id)
	 end
-----------Added temp table to get sent and delivered count, group by campaign_id
	 select
			 a.campaign_id
			 ,sum(cast(is_sent as int)) as sent
			 ,sum(cast(is_delivered as int)) as delivered
		into #sent_deli
	 from sms.campaign_items a (nolock)
	 where is_deleted =0 
	 group by a.campaign_id
--------------------------
   ;With CTE_Campaigns as
   (
	 select 
		sm.[campaign_id],
		sm.[account_id] as [account_id],
		sm.[user_id] as [user_id],
		sm.[campaign_guid] as [campaign_guid],
		sm.[name] as [campaign_name],
		sm.[html_content],
		sm.[subject],
		sm.[image_url],
		sm.[insert_url],
		sm.[media_type],
		sm.[media_type_id],
		sm.[status_type_id],
		sm.[scheduled_date],
		sm.[target_audience],
		sm.[created_dt],
		sm.[program_id],
		sm.[sms_type_id],
		sm.[audience_type_id],
		sm.[list_type_id],
		sm.[segment_id],
		sm.[customer_count],
		ss.status_type as [status],
		'Scheduled' as [scheduled_type],
		isnull(pp.[program_name],'Sales') as [campaign_type],
		count(sm.[campaign_id]) over() as [total_count],
		parent_campaign_id ,
		ROW_NUMBER() over (order by 
			case when (@sort_column = 'CampaignId' and @sort_order='asc') then sm.[campaign_id] end asc,
			case when (@sort_column = 'CampaignId' and @sort_order='desc') then sm.[campaign_id] end desc,
			case when (@sort_column = 'CampaignName' and @sort_order='asc') then sm.[name] end asc,
			case when (@sort_column = 'CampaignName' and @sort_order='desc') then sm.[name] end desc,
			case when (@sort_column = 'CreatedDt' and @sort_order='asc') then sm.[created_dt] end asc,
			case when (@sort_column = 'CreatedDt' and @sort_order='desc') then sm.[created_dt] end desc,
			case when (@sort_column = 'Status' and @sort_order='asc') then ss.[status_type] end asc,
			case when (@sort_column = 'Status' and @sort_order='desc') then ss.[status_type] end desc
		) as [row_number]
		
		--,sent
		--,delivered

	from
		[sms].[campaigns] sm with(nolock,readuncommitted)
		inner join [program].[program] pp with(nolock,readuncommitted) on (sm.program_id = pp.program_id)
		inner join [campaign].[status_type] ss with(nolock,readuncommitted) on (sm.status_type_id = ss.status_type_id) and ss.status_type_id!=@is_archive
		inner join [campaign].[campaign_type] ct with(nolock,readuncommitted) on (sm.campaign_type_id = ct.campaign_type_id) 
		
		--left outer  join #sent_deli  t on sm.campaign_id =t.campaign_id
	where
		sm.[is_deleted] = 0
		and  sm.[account_id] in (case when (@account_level > 1 and (select count(*) from #temp) > 0 ) then (select * from #temp)  else  @account_id end)
	
		and (@campaign_name='' or sm.[name] like '%'+ @campaign_name + '%')
		and ss.status_type = case when (len(trim(@status)) = 0 or @status = 'All') then ss.status_type else @status end
		and pp.[program_name] = case when (len(trim(@campaign_type)) = 0 or @campaign_type = 'All') then pp.[program_name] else @campaign_type end
		and	((@created_start_date = '' or cast(sm.created_dt as date) >= @created_start_date) 
		and (@created_end_date = '' or cast(sm.created_dt as date) <= @created_end_date))
		and sm.multi_channel_campaign_id is  null
		and  ((@campaign_level = 1 and sm.parent_campaign_id is not null ) or -- OEM level campaigns only
					(@campaign_level = 2 and sm.parent_campaign_id is null ) or -- Dealer level Campaigns only
						(@campaign_level = 0)) -- OEM and Dealer level campaigns
	)
	select * from CTE_Campaigns where [row_number] > @start and [row_number] <= @end
		     
SET NOCOUNT OFF

END




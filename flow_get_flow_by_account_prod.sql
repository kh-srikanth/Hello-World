USE [auto_campaigns]
GO
/****** Object:  StoredProcedure [flow].[get_flows_by_program]    Script Date: 6/20/2022 7:23:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [flow].[get_flows_by_program]       
  @account_id  uniqueidentifier,
  @flow_category_id int = 1, 
  @search NVARCHAR(50) = '',
  @page_no int = 1,
  @page_size int = 20,
  @sort_column nvarchar(20) = 'CreatedDt',
  @sort_order nvarchar(20) = 'DESC',
  @created_date varchar(100) = null,
  @program_id int = 1
AS        
/*
  
  exec [flow].[get_flows_by_program]   '95ac28d8-d513-4b0e-b234-d989c4d2f0bc',19,'',1,20,'CreatedDt','DESC',null,3
  --------------------------------------------------------------------------------------------------         
  MODIFICATIONS        
  Date           Author     Work Tracker Id    Description          
  ---------------------------------------------------------------------------------------------------       
  7/29/2021    Madhavi                          Get folow list by program 
  8/2/21		Madhavi							schedule_form_date , schedule_to_date added
  6/9/21		Madhavi							group sort order changed added
  8/9/21		madhavi							 trigger type sort_order added
  ---------------------------------------------------------------------------------------------------      
                            Copyright 2017 Warrous Pvt Ltd
*/ 
BEGIN

SET NOCOUNT ON 

	 declare @start int, @end int

	 --init start page if page number is wrong
	 set @page_no = IIF(@page_no > 0, @page_no, 1)
	 set @page_no = @page_no - 1

	 --set offset
	 set @start = (@page_no * @page_size);
	 set @end = @start + @page_size;
	 set @search = isnull(@search, '')

	 IF OBJECT_ID('tempdb.dbo.#TempFlowRun', 'U') IS NOT NULL
	DROP TABLE #TempFlowRun; 

	create table #TempFlowRun
	(
		flow_id int,
		last_run_date datetime null,
		next_run_date datetime null
	)
	insert into #TempFlowRun
	(
		flow_id,
		last_run_date ,
		next_run_date
	) 
    select  fr.flow_id , max(fr.run_dt), max(fr.next_run_dt)
	from flow.run fr (nolock)   
	group by flow_id  


	;With CTE_Flows as
	( select 
		f.flow_id,
		f.flow_guid,
        f.flow_name,
		f.flow_description,
		f.trigger_id,
		f.flow_json,
		f.[touchpoint_id],
		fst.status_type as [status],
		f.status_type_id,
		fg.[flow_group],
		f.[flow_group_id],
		ftt.trigger_type,
		f.target_segment,
		f.duration,
		f.is_pinned,
		isnull(f.[is_enrolled], 0) as [is_enrolled],
		FORMAT (tf.last_run_date, 'MM/dd/yyyy') as last_run_dt,
		FORMAT (tf.next_run_date, 'MM/dd/yyyy') as next_run_dt,
		isnull(CONVERT(varchar(10), f.[activation_date], 101),'-') as [activation_date],
		f.created_dt,
		f.created_by,
		pp.[program_name],
		pp.program_id,
		f.updated_dt,
		isnull(f.email_enabled, 0) as email_enabled,
		isnull(f.mail_enabled, 0) as mail_enabled,
		isnull(f.text_enabled, 0) as text_enabled,
		isnull(f.social_enabled, 0) as social_enabled,
		isnull(f.call_enabled, 0) as call_enabled,
		isnull(STUFF( case when f.email_enabled = 1 then ',Email' else '' end +  
			   case when f.mail_enabled = 1 then ',Print' else '' end +  
			   case when f.text_enabled = 1 then ',SMS' else '' end +  
			   case when f.social_enabled = 1 then ',Social Media' else '' end +  
			   case when f.call_enabled = 1 then ',Call' else '' end ,1,1,''), '') as [channels],
		FORMAT (f.schedule_from_date, 'MM/dd/yyyy') as schedule_from_date,
		FORMAT (f.schedule_to_date, 'MM/dd/yyyy') as schedule_to_date,
		count(f.[flow_id]) over() as [total_count],
		fg.sort_order as 'flow_group_sort_order',
		ftt.sort_order as 'trigger_type_sort_order',
		ROW_NUMBER() over (order by 
			case when (@sort_column = 'CreatedDt' and @sort_order='asc') then f.[created_dt] end asc,
			case when (@sort_column = 'CreatedDt' and @sort_order='desc') then f.[created_dt] end desc,
			case when (@sort_column = 'FlowName' AND @sort_order='ASC') then f.[flow_name] end asc,
			case when (@sort_column = 'FlowName' AND @sort_order='DESC') then f.[flow_name] end desc,
			case when (@sort_column = 'FlowDescription' AND @sort_order='ASC') then f.[flow_description] end asc,
			case when (@sort_column = 'FlowDescription' AND @sort_order='DESC') then f.[flow_description] end desc,
			case when (@sort_column = 'LastRunDt' AND @sort_order='ASC') then f.[run_dt] end asc,
			case when (@sort_column = 'LastRunDt' AND @sort_order='DESC') then f.[run_dt] end desc,
			case when (@sort_column = 'NextRunDt' AND @sort_order='ASC') then f.[next_run_dt] end asc,
			case when (@sort_column = 'NextRunDt' AND @sort_order='DESC') then f.[next_run_dt] end desc,
			case when (@sort_column = 'CreatedDt' AND @sort_order='ASC') then f.[created_dt] end asc,
			case when (@sort_column = 'CreatedDt' AND @sort_order='DESC') then f.[created_dt] end desc,
			case when (@sort_column = 'Status' AND @sort_order='ASC') then fst.[status_type] end asc,
			case when (@sort_column = 'Status' AND @sort_order='DESC') then fst.[status_type] end desc
		) as [row_number]
		
	from 
		[flow].[flows] f  with(nolock,readuncommitted)
		inner join [flow].[triggers] ft with(nolock,readuncommitted) on	
			f.trigger_id = ft.trigger_id
		inner join flow.trigger_type ftt with(nolock,readuncommitted) on	
			ftt.trigger_type_id = ft.trigger_type_id
		inner join [touchpoint].[programs] pp with(nolock,readuncommitted) on
			pp.program_id = f.program_id 
			--and Lower(pp.[program_name] ) like 'service program'
		inner join flow.status_type fst with(nolock,readuncommitted) on
			f.status_type_id = fst.status_type_id
		inner join [flow].[groups] fg with(nolock,readuncommitted) on
			f.flow_group_id = fg.flow_group_id
		left join #TempFlowRun tf 
			on f.flow_id = tf.flow_id 
	where 
		f.account_id = @account_id
		and f.program_id = @program_id 
		and f.[is_enrolled] = 1
		and f.[touchpoint_id] > 0
		and f.[flow_category_id] = @flow_category_id
		and ft.trigger_type_id not in (10)
		and f.is_deleted = 0 
		and (@search = '' or 
			 f.flow_name like '%'+ @search +'%' or
			 f.flow_description like '%'+ @search +'%' or
			 fst.status_type like '%'+ @search +'%'
			)
	
		)
		select flow_id,
		flow_guid,
        flow_name,
		flow_description,
		trigger_id,
		flow_json,
		[touchpoint_id],
		[status],
		status_type_id,
		[flow_group],
		[flow_group_id],
		trigger_type,
		target_segment,
		duration,
		is_pinned,
		[is_enrolled],
		last_run_dt,
		next_run_dt,
		[activation_date],
		created_dt,
		created_by,
		[program_name],
		program_id,
		updated_dt,
		email_enabled,
		mail_enabled,
		text_enabled,
		social_enabled,
		call_enabled,
		[channels],
		schedule_from_date,
		schedule_to_date,
		[total_count],
		[row_number]
		from CTE_Flows where [row_number] > @start and [row_number] <= @end  
		--order by flow_group_id, trigger_id asc
		order by trigger_type_sort_order asc , flow_group_sort_order asc

SET NOCOUNT OFF

END  	


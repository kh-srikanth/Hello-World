USE [auto_campaigns]
GO
/****** Object:  StoredProcedure [analytics].[get_link_clicks_by_guid]    Script Date: 7/15/2022 4:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER procedure  [analytics].[get_link_clicks_by_guid]

 --declare
	@campaign_guid uniqueidentifier = '9727d8d2-c7be-4435-a8c3-20a533181002',
	@link nvarchar(max) = '',
	@page_no int = 1,
	@page_size int = 150,
	@sort_column nvarchar(20) = 'Clicks',
	@sort_order nvarchar(20) = 'asc'
AS        
  /*
 exec [analytics].[get_link_clicks_by_guid]  '9727d8d2-c7be-4435-a8c3-20a533181002','',1,20,'Clicks','asc'
 -----------------------------------------          
    
 MODIFICATIONS        
 Date          Author    Work Tracker Id   Description          
 ----------------------------------------------------------  
 29/01/2018     satheesh                   Getting  Propensity Score For Each Campaign
 -----------------------------------------------------------      
*/         
   
BEGIN 
SET NOCOUNT ON
declare @start int, @end int
set @start = (@page_no * @page_size);
set @end = @start + @page_size;

drop table if exists #temp2
drop table if exists #temp

select oc.* into #temp2
from 
		[email].[campaigns] cc with(nolock,readuncommitted) 
		inner join [email].[campaign_items] eci  with(nolock,readuncommitted) on
		 cc.campaign_id=eci.campaign_id 
		left outer join email.clicks oc with(nolock,readuncommitted) on
			eci.campaign_item_id = oc.campaign_item_id and oc.is_deleted = 0 

	where 
		cc.campaign_guid = @campaign_guid and  
		cc.is_deleted = 0 and
		oc.link is not null 


select distinct
		oc.link,
		count(oc.click_id) as clicks1,
		count(oc.click_id) as total_clicks1,
		'' as version
into #temp
	from 
		[email].[campaigns] cc with(nolock,readuncommitted) 
		inner join [email].[campaign_items] eci  with(nolock,readuncommitted) on
		 cc.campaign_id=eci.campaign_id 
		left outer join email.clicks oc with(nolock,readuncommitted) on
			eci.campaign_item_id = oc.campaign_item_id and oc.is_deleted = 0 

	where 
		cc.campaign_guid = @campaign_guid and  
		cc.is_deleted = 0 and
		oc.link is not null 
		--and oc.link = case when (len(trim(@link)) = 0 or @link = '') then oc.link else @link end
		and (@link = '' or oc.link  like '%'+ @link +'%')
		and oc.link not like '%/unsub%'


	group by oc.link,oc.click_id
	;with cte_result as (
	select *,
	(select count(*) from #temp) as total_count,
	(select count(*) from #temp2 t1 where t1.link = t.link) as clicks,
	(select count(distinct campaign_item_id) from #temp2 t2 where t2.link = t.link) as total_clicks
	from #temp t
	)
	select * from cte_result 
		order by
			case when (@sort_column = 'Link' and @sort_order='asc') then [link] end asc,
			case when (@sort_column = 'Link' and @sort_order='desc') then [link] end desc,
			case when (@sort_column = 'Clicks' and @sort_order='asc') then [clicks] end asc,
			case when (@sort_column = 'Clicks' and @sort_order='desc') then [clicks] end desc,
			case when (@sort_column = 'TotalClicks' and @sort_order='asc') then [total_clicks1] end asc,
			case when (@sort_column = 'TotalClicks' and @sort_order='desc') then [total_clicks1] end desc
			offset ((isnull(@page_no,1) - 1) * @page_size) rows fetch next @page_size rows only

		
SET NOCOUNT OFF

END




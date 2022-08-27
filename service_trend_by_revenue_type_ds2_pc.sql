			select 

					datename(month,convert(date,convert(varchar(10),ro_close_date))) + '-' + datename(year,(convert(date,convert(varchar(10),ro_close_date)))) As Month,
					--count(mc.campaign_item_id) As Response_Count,
					sum(cr.responders) as Response_Count,
					sum(isnull(mroh.total_sale_post_ded,total_repair_order_price-total_repair_order_cost)) As Total_Sales,
					iif(sum(isnull(mroh.total_sale_post_ded,total_repair_order_price-total_repair_order_cost))=0,1,sum(isnull (mroh.total_labor_sale_post_ded,total_labor_price-total_labor_cost))/sum(isnull(mroh.total_sale_post_ded,total_repair_order_price-total_repair_order_cost))) As Labour,
					sum(mroh.total_misc_price) As Parts_Misc,
					sum(isnull(mroh.total_labor_sale_post_ded,total_labor_price-total_labor_cost)) As Labour_Sales,
					sum(isnull(mroh.total_labor_sale_post_ded,total_labor_price-total_labor_cost))/count(isnull(mroh.master_ro_header_id,0)) As Avg_Labour_Per_RO,
					sum(mroh.total_parts_price) As Parts_Misc_Sales,
					sum(isnull(mroh.total_misc_price,0)-isnull(total_misc_cost,0))/count(isnull(mroh.master_ro_header_id,0)) As  Avg_Parts_Misc_Per_RO
					
              from 
			       master.repair_order_header(nolock) As mroh
				   inner join [master].[campaign_items](nolock) mc			   
				   on convert(varchar(25),mroh.cust_dms_number) = convert(varchar(25),mc.list_member_id) and mroh.parent_dealer_id = mc.parent_dealer_id
				  inner join master.campaign_responses cr (nolock) on mroh.parent_dealer_id =cr.parent_dealer_id  and mc.campaign_id = cr.campaign_id
             where 
			      mroh.parent_dealer_id = @dealer_id
                  and convert(date,(convert(varchar(10),ro_close_date))) between @FromDate and @ToDate
             group by datename(month,convert(date,convert(varchar(10),ro_close_date))) + '-' + datename(year,(convert(date,convert(varchar(10),ro_close_date))))
			

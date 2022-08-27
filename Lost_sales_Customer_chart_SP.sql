use clictell_auto_master
USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[lost_sales_customers]    Script Date: 8/31/2021 6:48:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--create PROCEDURE [reports].[lost_sales_customers_chart]    
declare    
@from_date datetime ='2021-01-01',  
@to_date datetime ='2021-08-30',  
@months_since_purchased int = 12,  
@local_customer varchar(20) = 'All',  
@customer_id varchar(30) = null,  
@buyer_first_name varchar(100) = null,  
@buyer_last_name varchar(100) =null,  
@dealer_id varchar(30) = '3407',  
@state varchar(20) = 'All'  


--AS
BEGIN

	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
	IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1

	select 
			 c.parent_dealer_id
			,c.cust_dms_number
			,isnull(datediff(day,convert(date,convert(char(10),rh.ro_open_date)),getdate()),'') as days_since_last_purchase 
		
	into #temp

	  from  master.fi_sales s (nolock)
	  inner join master.dealer d (nolock) on d.parent_dealer_id = s.parent_dealer_id
	  left outer join master.repair_order_header rh (nolock) on rh.master_customer_id = s.master_customer_id and rh.master_vehicle_id = s.master_vehicle_id
	  inner join master.customer c (nolock) on c.master_customer_id =s.master_customer_id
	  inner join master.cust_2_vehicle cv (nolock) on cv.master_customer_id = c.master_customer_id and cv.master_vehicle_id = s.master_vehicle_id
	  inner join master.vehicle v (nolock) on v.master_vehicle_id = cv.master_vehicle_id
	 where
		  d.parent_dealer_id = @dealer_id  
		  and (convert(date,convert(char(8),s.purchase_date))  between @from_date and @to_date)  
		  and (@customer_id is null or (@customer_id is not null and  @customer_id = c.cust_dms_number))  
		  and (@buyer_first_name is null or (@buyer_first_name is not null and  @buyer_first_name = cust_first_name))  
		  and (@buyer_last_name is null or (@buyer_last_name is not null and  @buyer_last_name = cust_last_name))  
		  and (@state = 'All' or (@state !='All' and @state =c.cust_state_code))  
		  and (s.deal_type = 'Retail' or s.deal_type is null)
		  and (s.deal_status in ('Finalized','Sold','Booked/Recapped'))

	select 
		 parent_Dealer_id
		,cust_dms_number
		,(case when days_since_last_purchase < = 60 then 'a60'
				when days_since_last_purchase < = 90 and days_since_last_purchase > 60 then 'b90'
				when days_since_last_purchase < = 180 and days_since_last_purchase > 90 then 'c180'
				when days_since_last_purchase < = 360 and days_since_last_purchase > 180 then 'd360'
				else 'e360more' end) as no_service_since

		into #temp1
	from #temp 



	select 
			parent_dealer_id
			,count(cust_dms_number) as customer_number
			,no_service_since
	from #temp1
	group by parent_dealer_id,no_service_since
	order by no_service_since 

END
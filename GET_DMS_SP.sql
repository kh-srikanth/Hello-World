USE [auto_customers]
GO
/****** Object:  StoredProcedure [customer].[dms_data_get]    Script Date: 9/17/2021 3:53:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER procedure [customer].[dms_data_get]   
@page_no int = 1,  
@page_size int = 20,  
@sort_column nvarchar(20) = 'CustFirstName',  
@sort_order nvarchar(20) = 'desc',  
@search nvarchar(50) = null,  
@FromDate varchar = '',  
@EndDate varchar = '',  
@parent_dealer_id int  
AS  
/*          
  
  exec [customer].[dms_data_get] 1,20,'CustFirstName',  'desc', null,'','',1806  
  ------------------------------------------------------------------------------          
             
	Date            Author			Work Tracker Id		Description            
  ------------------------------------------------------------------------------------------------------------------------------         
	3/22/2021       Madhavi.k							Created -  This procedure is used to get all the  DMSdata  
	6/2/21			Madhavi k							Modified - sort added for vin,make,model,model_year,fullname
	6/10/21			Madhavi k							Modified -  search in all pages of grid - solved
	06/11/2021		Santhosh B							Modified - Added is_deleted = 0 condition from cust2vehicle table.	
  ------------------------------------------------------------------------------------------------------------------------------        
                              Copyright 2017 Warrous Pvt Ltd   
*/          
      
   
SET NOCOUNT ON   
 
begin  



	IF OBJECT_ID('tempdb..#tempDealer') IS NOT NULL DROP TABLE #tempDealer
	IF OBJECT_ID('tempdb..#temp_dealer') IS NOT NULL DROP TABLE #temp_dealer

	 declare @start int, @end int
	  
	 SET @search = LTRIM(RTRIM(isnull(@search,'')))  
  
	 --init start page if page number is wrong.
	 set @page_no = IIF(@page_no > 0, @page_no, 1)
	 set @page_no = @page_no - 1

	 --set offset
	 set @start = (@page_no * @page_size);
	 set @end = @start + @page_size;

	 select * into #temp_dealer from clictell_auto_master.master.dealer with (nolock)

	  ;with CTE_Dealer_Results AS 
	 (  
		select parent_dealer_id, _id, dealer_name
		from #temp_dealer (nolock)
		where parent_dealer_id = @parent_dealer_id
		Union ALL
		select a.parent_dealer_id, a._id, a.dealer_name
		from #temp_dealer a (nolock)
		inner join CTE_Dealer_Results b on a.parentid = b._id
	 )

	select * into #tempDealer from CTE_Dealer_Results 
 
  
 ;with CTE_Results AS (  
  select    
		b.cust_dms_number,   
		b.master_customer_id,  
		dbo.CamelCase(b.cust_first_name) as cust_first_name,
		dbo.CamelCase(b.cust_last_name) as cust_last_name,   
		lower(b.cust_email_address1) as cust_email_address1,   
		lower(b.cust_email_address2) as cust_email_address2,   
		'' AS cust_email_address3,--b.cust_email_address3,   
		b.cust_home_phone,   
		b.cust_work_phone,  
		NULL AS cust_created_dt, --b.cust_created_dt,  
		c.vin,   
		c.make,   
		c.model,   
		c.model_year,   
		b.cust_do_not_call,   
		b.cust_do_not_email,   
		b.cust_do_not_mail,   
		b.cust_do_not_social,   
		b.cust_do_not_text,   
		replace(convert(varchar(10), convert(date,(convert(varchar(10),a.last_ro_date )), 111)),'/','-') as last_ro_date,   
		a.last_ro_mileage,   
		replace(convert(varchar(10), convert(date,(convert(varchar(10),a.last_sale_date )), 111)),'/','-') as last_sale_date,   
		a.last_sale_mileage  
		,count(b.master_customer_id) over() as [total_count]
		,ROW_NUMBER() over (ORDER BY  
		CASE WHEN (@sort_column = 'CustFirstName' AND @sort_order='ASC') THEN b.cust_first_name END ASC,  
		CASE WHEN (@sort_column = 'CustFirstName' AND @sort_order='DESC') THEN b.cust_first_name END DESC,  
		CASE WHEN (@sort_column = 'CustLastName' AND @sort_order='ASC') THEN b.cust_last_name END ASC,   
		CASE WHEN (@sort_column = 'CustLastName' AND @sort_order='DESC') THEN b.cust_last_name END DESC,  
		CASE WHEN (@sort_column = 'CustEmailAddress1' AND @sort_order='ASC') THEN b.cust_email_address1 END ASC,  
		CASE WHEN (@sort_column = 'CustEmailAddress1' AND @sort_order='DESC') THEN b.cust_email_address1 END DESC,  
		CASE WHEN (@sort_column = 'CustHomePhone' AND @sort_order='ASC') THEN b.cust_home_phone END ASC,  
		CASE WHEN (@sort_column = 'CustHomePhone' AND @sort_order='DESC') THEN b.cust_home_phone END DESC,  
		CASE WHEN (@sort_column = 'CustWorkPhone' AND @sort_order='ASC') THEN b.cust_work_phone END ASC,   
		CASE WHEN (@sort_column = 'CustWorkPhone' AND @sort_order='DESC') THEN b.cust_work_phone END DESC ,
   
		CASE WHEN (@sort_column = 'FullName' AND @sort_order='ASC') THEN b.cust_first_name END ASC,   
		CASE WHEN (@sort_column = 'FullName' AND @sort_order='DESC') THEN b.cust_first_name END DESC , 

		CASE WHEN (@sort_column = 'VIN' AND @sort_order='ASC') THEN c.vin END ASC,   
		CASE WHEN (@sort_column = 'VIN' AND @sort_order='DESC') THEN c.vin END DESC , 

		CASE WHEN (@sort_column = 'Make' AND @sort_order='ASC') THEN c.make END ASC,   
		CASE WHEN (@sort_column = 'Make' AND @sort_order='DESC') THEN c.make END DESC , 

		CASE WHEN (@sort_column = 'Model' AND @sort_order='ASC') THEN c.model END ASC,   
		CASE WHEN (@sort_column = 'Model' AND @sort_order='DESC') THEN c.model END DESC , 

		CASE WHEN (@sort_column = 'ModelYear' AND @sort_order='ASC') THEN c.model_year END ASC,   
		CASE WHEN (@sort_column = 'ModelYear' AND @sort_order='DESC') THEN c.model_year END DESC)
		as  [row_number]
  from    
		clictell_auto_master.master.cust_2_vehicle a (nolock)  
		inner join clictell_auto_master.master.customer b (nolock) on a.master_customer_id = b.master_customer_id  
		inner join clictell_auto_master.master.vehicle c (nolock) on a.master_vehicle_id = c.master_vehicle_id  
  where  
		--b.parent_dealer_id = @parent_dealer_id and  
		a.is_deleted = 0 and
		b.parent_dealer_id in (select distinct parent_dealer_id from #tempDealer) and
		(isnull(@search,'') = '' or   
		cust_first_name like '%'+ @search +'%' or  
		cust_last_name like '%'+ @search +'%' or
		cust_email_address1 like '%'+ @search +'%' or  
		cust_home_phone like '%'+ @search +'%' or
		c.vin like '%'+ @search +'%' or
		c.make like '%'+ @search +'%' or
		c.model like '%'+ @search +'%' or
		c.model_year like '%'+ @search +'%')  
		and
		( b.cust_do_not_call = 0 or b.cust_do_not_email = 0 or cust_do_not_mail = 0  )
  
  )
  
  select * from CTE_Results where [row_number] > @start and [row_number] <= @end

  IF OBJECT_ID('tempdb..#tempDealer') IS NOT NULL DROP TABLE #tempDealer
  IF OBJECT_ID('tempdb..#temp_dealer') IS NOT NULL DROP TABLE #temp_dealer

SET NOCOUNT OFF  
  
end
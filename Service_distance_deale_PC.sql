USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[service_by_distance_from_dealership_pc]    Script Date: 10/26/2021 3:43:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [reports].[service_by_distance_from_dealership_pc]
--Declare
@dealer_id int,
@FromDate date,
@ToDate date

as

/*
    exec [reports].[service_by_distance_from_dealership_pc] 1806,'1-1-2021','10-26-2021'
*/

begin

	Declare @is_test_data bit = 0,
	        @parent_dealer_id varchar(500),
			@dealer_name varchar(1000)
			
	if (@is_test_data = 1)
	
	begin
	        set	@FromDate = ''
			set	@ToDate = ''
	       ;with CTE(Distance,Total_of_Customers,Of_Database,Repair_Orders,CP_Amount,Avg_CP_Amount,Warranty_Amount,Avg_Warranty_Amount,Avg_RO_Amount,Created_Date)
AS
(
SELECT        CAST('0 to 5 miles' AS varchar(100)) AS 'Distance',
               CAST('1052' AS decimal(10,0)) AS 'Total_of_Customers',  
               CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
               CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
                CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
                CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
                 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
                 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
                 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
 '01/25/2017' AS Created_Date

UNION SELECT        CAST('5 to 10 miles' AS varchar(100)) AS 'Distance',
               CAST('494' AS decimal(10,0)) AS 'Total_of_Customers',
               CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
               CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
                CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
                CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
                 CAST('15674.34' AS decimal(10,2)) AS 'Warranty_Amount',
                 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
                 CAST('128.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
 '01/25/2017' AS Created_Date

UNION SELECT        CAST('10 to 15 miles' AS varchar(100)) AS 'Distance',
               CAST('618' AS decimal(10,0)) AS 'Total_of_Customers',
               CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
               CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
                CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
                CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
                 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
                 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
                 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
 '01/25/2017' AS Created_Date

UNION SELECT        CAST('15 to 20 miles' AS varchar(100)) AS 'Distance', 
               CAST('372' AS decimal(10,0)) AS 'Total_of_Customers',              
               CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
               CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
                CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
                CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
                 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
                 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
                 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
 '01/25/2017' AS Created_Date

UNION SELECT        CAST('20 to 25 miles' AS varchar(100)) AS 'Distance',
               CAST('24' AS decimal(10,0)) AS 'Total_of_Customers',
               CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
               CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
                CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
                CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
                 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
                 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
                 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
 '01/25/2017' AS Created_Date

UNION SELECT        CAST('25 to 35 miles' AS varchar(100)) AS 'Distance',
               CAST('284' AS decimal(10,0)) AS 'Total_of_Customers',
               CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
               CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
                CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
                CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
                 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
                 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
                 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
 '01/25/2017' AS Created_Date


UNION SELECT        CAST('35 to 50 miles' AS varchar(100)) AS 'Distance',
               CAST('214' AS decimal(10,0)) AS 'Total_of_Customers',
               CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
               CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
                CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
                CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
                 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
                 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
                 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
 '01/25/2017' AS Created_Date

UNION SELECT        CAST('50 to 75 miles' AS varchar(100)) AS 'Distance',
               CAST('134' AS decimal(10,0)) AS 'Total_of_Customers',
               CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
               CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
                CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
                CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
                 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
                 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
                 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
 '01/25/2017' AS Created_Date

UNION SELECT        CAST('75 to 100 miles' AS varchar(100)) AS 'Distance',
               CAST('137' AS decimal(10,0)) AS 'Total_of_Customers',
               CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
               CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
                CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
                CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
                 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
                 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
                 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
 '01/25/2017' AS Created_Date

)
SELECT  Distance,Total_of_Customers,Of_Database,Repair_Orders,CP_Amount,Avg_CP_Amount,Warranty_Amount,Avg_Warranty_Amount,Avg_RO_Amount,Created_Date  FROM CTE


--where 1 = CASE WHEN @FromDate ='' THEN 1
--		WHEN @FromDate IS NULL THEN 1
--	       WHEN  CAST(Created_Date AS DATE)>=CAST(@FromDate AS DATE) THEN 1
--	  END
--AND 1 = CASE WHEN @ToDate ='' THEN 1
--		WHEN @FromDate IS NULL THEN 1
--		WHEN  CAST(Created_Date AS DATE)<=CAST(@ToDate AS DATE) THEN 1
--	  END
END

ElSE
BEGIN
    select 
       case when c.cust_miles_distance < 100  then '0-100 Miles'
			when (c.cust_miles_distance < 500 and c.cust_miles_distance >= 100)  then '100 - 500 Miles'
			when (c.cust_miles_distance < 1000 and c.cust_miles_distance >= 500)  then '500 - 1000 Miles'
			when (c.cust_miles_distance < 1500 and c.cust_miles_distance >= 1000)  then '1000 - 1500 Miles'
			when (c.cust_miles_distance < 2000 and c.cust_miles_distance > 1500)  then '1500 - 2000 Miles'
			when (c.cust_miles_distance < 2500 and c.cust_miles_distance > 2000)  then '2000 - 2500 Miles'
			when (c.cust_miles_distance < 3000 and c.cust_miles_distance > 2500)  then '2500 - 3000 Miles'
			when c.cust_miles_distance > 3000 then ' > 3000 Miles' end
	   as Distance
	  ,count(r.cust_dms_number) as Total_of_Customers
	  ,count(r.ro_number) as Repair_Orders
	  ,sum(r.total_customer_price) as CP_Amount
	  ,sum(r.total_customer_price)/count(r.cust_dms_number) as Avg_CP_Amount
	  ,sum(r.total_warranty_price) As Warranty_Amount
	  ,sum(r.total_warranty_price)/count(r.cust_dms_number) As Avg_Warranty_Amount
      ,sum(r.total_repair_order_price)/*/count(r.cust_dms_number)*/ As Avg_RO_Amount

	  into #temp
    from master.customer(nolock) as c
	inner join master.repair_order_header(nolock) as r on c.master_customer_id =r.master_customer_id
	
where
      r.parent_dealer_id = @dealer_id
	  and convert(date,convert(varchar(10),ro_close_date))  between @FromDate and @ToDate
	  group by c.cust_miles_distance
	  order by c.cust_miles_distance desc


	select 
		Distance
		,sum(Total_of_Customers) as Total_of_Customers
		,sum(Repair_Orders) as Repair_Orders
		,sum(CP_Amount) as CP_Amount
		,sum(CP_Amount)/sum(Repair_Orders) as Avg_CP_Amount
		,sum(Warranty_Amount) as Warranty_Amount
		,sum(Warranty_Amount)/sum(Repair_Orders) as Avg_Warranty_Amount
		,sum(Avg_RO_Amount)/sum(Repair_Orders) as Avg_RO_Amount
	from #temp
	where Distance is not null
	group by Distance
end
END
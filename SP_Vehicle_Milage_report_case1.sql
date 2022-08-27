use clictell_auto_etl
/*SP service by Vehicle Mileage Reports Dataset-1*/
--exec [reports].[Vehicle_Mileage_Reports_DS1] null, null
go
create procedure [Reports].[Vehicle_Mileage_Reports_DS1]
@FromDate varchar(50), @ToDate varchar(50), @IsTestData bit =1
as
begin

IF(@IsTestData = 1)
begin
	;with CTE(Mileage,Total_of_Customers,Of_Database,Repair_Orders,CP_Amount,Avg_CP_Amount,Warranty_Amount
	,Avg_Warranty_Amount,Avg_RO_Amount,Created_Date)
	AS
	(
	SELECT        CAST('0 to 5k' AS varchar(100)) AS 'Mileage',
				   CAST('1052' AS decimal(10,0)) AS 'Total_of_Customers',  
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
										'01/25/2017' AS Created_Date

	UNION SELECT        CAST('5k to 10k' AS varchar(100)) AS 'Mileage',
				   CAST('494' AS decimal(10,0)) AS 'Total_of_Customers',
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15674.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('128.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
										'01/25/2017' AS Created_Date

	UNION SELECT        CAST('10k to 15k' AS varchar(100)) AS 'Mileage',
				   CAST('618' AS decimal(10,0)) AS 'Total_of_Customers',
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
										'01/25/2017' AS Created_Date

	UNION SELECT        CAST('15k to 20k' AS varchar(100)) AS 'Mileage', 
				   CAST('372' AS decimal(10,0)) AS 'Total_of_Customers',              
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
										'01/25/2017' AS Created_Date

	UNION SELECT        CAST('20k to 25k' AS varchar(100)) AS 'Mileage',
				   CAST('24' AS decimal(10,0)) AS 'Total_of_Customers',
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
										'01/25/2017' AS Created_Date

	UNION SELECT        CAST('25k to 35k' AS varchar(100)) AS 'Mileage',
				   CAST('284' AS decimal(10,0)) AS 'Total_of_Customers',
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
										'01/25/2017' AS Created_Date


	UNION SELECT        CAST('35k to 50k' AS varchar(100)) AS 'Mileage',
				   CAST('214' AS decimal(10,0)) AS 'Total_of_Customers',
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
										'01/25/2017' AS Created_Date

	UNION SELECT        CAST('50k to 75k' AS varchar(100)) AS 'Mileage',
				   CAST('134' AS decimal(10,0)) AS 'Total_of_Customers',
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
										'01/25/2017' AS Created_Date
) 
SELECT  Mileage,Total_of_Customers,Of_Database,Repair_Orders
,CP_Amount,Avg_CP_Amount,Warranty_Amount,Avg_Warranty_Amount,Avg_RO_Amount,Created_Date  FROM CTE


where 
1 = CASE 
				WHEN @FromDate ='' THEN 1
				WHEN @FromDate IS NULL THEN 1
				WHEN  CAST(Created_Date AS DATE)>=CAST(@FromDate AS DATE) THEN 1
		END
AND 
1 = CASE 
				WHEN @ToDate ='' THEN 1
				WHEN @FromDate IS NULL THEN 1
				WHEN  CAST(Created_Date AS DATE)<=CAST(@ToDate AS DATE) THEN 1
		END
end

else
begin
	
	;with CTE(Mileage,Total_of_Customers,Of_Database,Repair_Orders,CP_Amount,Avg_CP_Amount,Warranty_Amount
	,Avg_Warranty_Amount,Avg_RO_Amount,Created_Date)
	AS
	(
	SELECT        CAST('0 to 5k' AS varchar(100)) AS 'Mileage',
				   CAST('1052' AS decimal(10,0)) AS 'Total_of_Customers',  
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
										'01/25/2017' AS Created_Date

	UNION SELECT        CAST('5k to 10k' AS varchar(100)) AS 'Mileage',
				   CAST('494' AS decimal(10,0)) AS 'Total_of_Customers',
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15674.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('128.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
										'01/25/2017' AS Created_Date

	UNION SELECT        CAST('10k to 15k' AS varchar(100)) AS 'Mileage',
				   CAST('618' AS decimal(10,0)) AS 'Total_of_Customers',
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
										'01/25/2017' AS Created_Date

	UNION SELECT        CAST('15k to 20k' AS varchar(100)) AS 'Mileage', 
				   CAST('372' AS decimal(10,0)) AS 'Total_of_Customers',              
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
	 '01/25/2017' AS Created_Date

	UNION SELECT        CAST('20k to 25k' AS varchar(100)) AS 'Mileage',
				   CAST('24' AS decimal(10,0)) AS 'Total_of_Customers',
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
										'01/25/2017' AS Created_Date

	UNION SELECT        CAST('25k to 35k' AS varchar(100)) AS 'Mileage',
				   CAST('284' AS decimal(10,0)) AS 'Total_of_Customers',
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
										'01/25/2017' AS Created_Date


	UNION SELECT        CAST('35k to 50k' AS varchar(100)) AS 'Mileage',
				   CAST('214' AS decimal(10,0)) AS 'Total_of_Customers',
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
										'01/25/2017' AS Created_Date

	UNION SELECT        CAST('50k to 75k' AS varchar(100)) AS 'Mileage',
				   CAST('134' AS decimal(10,0)) AS 'Total_of_Customers',
				   CAST('3.2' AS decimal(10,1)) AS 'Of_Database',
				   CAST('138' AS decimal(10,0)) AS 'Repair_Orders',
					CAST('0.95' AS decimal(10,2)) AS 'CP_Amount',
					CAST('182.06' AS  decimal(10,2)) AS 'Avg_CP_Amount',
					 CAST('15644.34' AS decimal(10,2)) AS 'Warranty_Amount',
					 CAST('203.06' AS  decimal(10,2)) AS 'Avg_Warranty_Amount',
					 CAST('218.34' AS decimal(10,2)) AS 'Avg_RO_Amount',
										'01/25/2017' AS Created_Date
) 
SELECT  Mileage,Total_of_Customers,Of_Database,Repair_Orders
,CP_Amount,Avg_CP_Amount,Warranty_Amount,Avg_Warranty_Amount,Avg_RO_Amount,Created_Date  FROM CTE


where 
1 = CASE 
				WHEN @FromDate ='' THEN 1
				WHEN @FromDate IS NULL THEN 1
				WHEN  CAST(Created_Date AS DATE)>=CAST(@FromDate AS DATE) THEN 1
		END
AND 
1 = CASE 
				WHEN @ToDate ='' THEN 1
				WHEN @FromDate IS NULL THEN 1
				WHEN  CAST(Created_Date AS DATE)<=CAST(@ToDate AS DATE) THEN 1
		END
end

end

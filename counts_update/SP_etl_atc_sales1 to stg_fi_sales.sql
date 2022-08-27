use clicktell_auto_etl;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'etl.atc_sales1';

select top 1 * from etl.atc_sales1;
insert into [stg].[fi_sales](mechanical_breakdown_cost) values(100);
select * from [stg].[fi_sales];
select * from #temp
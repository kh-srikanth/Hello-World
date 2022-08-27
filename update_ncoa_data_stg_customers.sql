use clictell_auto_stg
go

IF OBJECT_ID('tempdb..#cust') IS NOT NULL DROP TABLE #cust

select  * into #cust from stg.customers (nolock) where parent_dealer_id =1806  --93859
--select  * from stg.ncoa_data (nolock)   -- 6932  


select				--42047
c.cust_full_name
,n.[Individual Name]

,c.cust_address1
,n.[Previous Delivery Address]
,n.[Current Delivery Address]

,c.cust_address2
,n.[Previous Alternate Address 2]
,n.[Current Alternate Address 2]

,c.cust_city
,n.[Previous City]
,n.[Current City]

--,c.cust_county
--,c.cust_district
--,c.cust_region
--,c.cust_country

,c.cust_state_code
,n.[Previous State]
,n.[Current State]

,c.cust_zip_code
,n.[Previous ZIP+4]
,n.[Current ZIP+4]

from #cust c (nolock)
inner join stg.ncoa_data n (nolock) on upper(ltrim(rtrim(c.cust_full_name))) = upper(ltrim(rtrim( n.[Individual Name]))) and ltrim(rtrim(c.cust_address1)) = ltrim(rtrim(n.[Previous Delivery Address]))


--select * from #cust
--select * from stg.customers (nolock) where cust_full_name = 'DANIELA PAIVA RIZZO' and vin is not null

alter table stg.customers add
ncoa_cust_address1 varchar(500)
,ncoa_cust_address2 varchar(500)
,ncoa_cust_city varchar(50)
,ncoa_cust_state_code varchar(50)
,ncoa_cust_zip_code int



update c set				--42047 in the select, but only 4934 in the update
c.ncoa_cust_address1 =n.[Current Delivery Address]
,c.ncoa_cust_address2 = n.[Current Alternate Address 2]
,c.ncoa_cust_city = n.[Current City]
,c.ncoa_cust_state_code = n.[Current State]
,c.ncoa_cust_zip_code = n.[Current ZIP+4]
from stg.customers c (nolock)
inner join stg.ncoa_data n (nolock) on upper(ltrim(rtrim(c.cust_full_name))) = upper(ltrim(rtrim( n.[Individual Name]))) and ltrim(rtrim(c.cust_address1)) = ltrim(rtrim(n.[Previous Delivery Address]))

select * from stg.customers where ncoa_cust_state_code is not null order by ncoa_cust_state_code, ncoa_cust_address1  --4934


ALTER TABLE stg.customers ALTER COLUMN ncoa_cust_zip_code int

--select --distinct
--n.[Individual Name],
--n.[Current Delivery Address]
--,n.[Current Alternate Address 2]
--,n.[Current City]
--,n.[Current State]
--,n.[Current ZIP+4]
--from #cust c (nolock)
--inner join stg.ncoa_data n (nolock) on upper(ltrim(rtrim(c.cust_full_name))) = upper(ltrim(rtrim( n.[Individual Name]))) and ltrim(rtrim(c.cust_address1)) = ltrim(rtrim(n.[Previous Delivery Address]))
--order by n.[Current ZIP+4]


--select * from stg.customers (nolock) where cust_full_name = 'Shedly  Justinien'
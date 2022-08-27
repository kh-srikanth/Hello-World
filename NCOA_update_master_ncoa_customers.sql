use clictell_auto_master
go

--select top 10 * from master.ncoa_customers order by master_customer_id
--select top 10 * from master.ncoa_data order by [Company Name]


update c set
c.cust_full_name		= n.[Individual name]
,c.ncoa_cust_address1	= n.[Current Delivery Address]
,c.ncoa_cust_address2	= n.[Current Alternate Address]
,c.ncoa_cust_city		= n.[Current City]
,c.ncoa_cust_state_code	= n.[Current State]
,c.ncoa_cust_zip_code	= left(n.[Current ZIP+4],5)
,c.ncoa_cust_zip4_code	= right(n.[Current ZIP+4],len(n.[Current ZIP+4])-5)

--,c.ncoa_customer_id, n.[Record ID]
from master.ncoa_customers c (nolock)
inner join master.ncoa_data n (nolock) on c.master_customer_id =n.[Company Name] --and c.ncoa_customer_id = n.[Record ID]

select * from master.ncoa_customers (nolock) where ncoa_cust_city is not null
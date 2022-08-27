--list_ids update 

drop table if exists #tp
drop table if exists #tep

select 
	b.customerid , a.src_cust_id,a.customer_id,a.list_ids--,len(a.list_ids) as lengt,row_number() over (partition by a.src_cust_id order by len(a.list_ids) desc) as rnk
	,a.is_deleted
into #tp
from [auto_customers].[customer].[customers] a (nolock)
inner join clictell_auto_etl.etl.cdkLgt_customer b (nolock) on a.src_cust_id = b.CustomerId and a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
order by b.CustomerId

--select * from #tp


select 
		src_cust_id, replace(replace(STRING_AGG(list_ids,','),',,-1,',','),',,',',') as lids
into #tep
from #tp  group by src_cust_id

--select * from #tep


select 
	 a.src_cust_id , b.src_cust_id  --delete
	,a.customer_id ---delete
	,a.list_ids , b.lids
from [auto_customers].[customer].[customers] a (nolock)
inner join #tep b on a.src_cust_id = b.src_cust_id
order by a.src_cust_id

/*
update a set
	a.list_ids = b.lids
from [auto_customers].[customer].[customers] a (nolock)
inner join #tep b on a.src_cust_id = b.src_cust_id
*/

use clictell_auto_master
select * from auto_customers.customer.customers (nolock)
select * from master.campaign_responses (nolock)
--email_bounced

use auto_customers
select * from [customer].[elements_type] (nolock) where element_type_id = 1 
select * from [customer].[element_operators] (nolock) where element_id in( 84,85,86)
select * from [customer].[element_operators] (nolock) where element_id = 109 --element_operator_id =436
select * from [customer].[segment_elements] (nolock) where element_id = 109
select * from [customer].[segment_elements] (nolock) where element_type_id = 1

select * from [customer].[operator_values] (nolock) where element_operator_id = 170
--insert into [customer].[segment_elements] (name,description,element_type_id,sort_order,created_by) values ('Email Bounced','Email Bounced',1,84,'SK')
--insert into [customer].[element_operators] (element_id,operator_name,operator_description,field_type_id, created_by) values (109,'is not','is not',3,'SK')
--insert into [customer].[operator_values] (element_operator_id,value,description,created_by) values(437,'Yes','Yes','SK')
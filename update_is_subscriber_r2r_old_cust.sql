select 
	a.account_id,b.accountname,is_subscriber,count(*) 
from auto_customers.customer.customers a (nolock) 
inner join auto_customers.portal.account b with (nolock) on upper(a.account_id)  = upper(b._id)
where a.is_deleted =0
and a.r2r_customer_id  is not null and a.is_subscriber =0
and a.account_id in ('7DB79611-A797-4938-AAC8-F3A887384304', '82abf13b-b9c9-4bab-b883-7613e964a1eb', 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
					,'96DBF74D-C8BD-459B-B751-B93F961EF884', '6B9537BD-115F-4019-B3AA-7F981EC69559', 'F0590E45-19AA-4597-A2B5-67553DD7B113'
					,'ef42def6-da60-4632-b879-b01b26cde74a', 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF', 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A')
group by a.account_id,b.accountname,is_subscriber


select * from auto_customers.portal.account with (nolock) where _id  in 
					('7DB79611-A797-4938-AAC8-F3A887384304', '82abf13b-b9c9-4bab-b883-7613e964a1eb', 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
					,'96DBF74D-C8BD-459B-B751-B93F961EF884', '6B9537BD-115F-4019-B3AA-7F981EC69559', 'F0590E45-19AA-4597-A2B5-67553DD7B113'
					,'ef42def6-da60-4632-b879-b01b26cde74a', 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF', 'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A')


select customer_id,is_subscriber
--update a set is_subscriber =  1
from auto_customers.customer.customers a (nolock) where 
is_deleted =0 
and account_id  = '9A9AC801-A7EE-40FB-99DA-B80F552A3A61'
and r2r_customer_id is not null
and is_subscriber = 0



--COMPLETED

'E2A9BEE6-A8D3-43AE-B975-FCCC15A7C95A' --CycleDesign

'F0590E45-19AA-4597-A2B5-67553DD7B113' --VelocityCycles --AC:7891; sales CRM: 7963; Service CRM:0

'96DBF74D-C8BD-459B-B751-B93F961EF884' --SouthernDevil HD -- 81,474; salesCRM: 81479; service CRM: 0

'82ABF13B-B9C9-4BAB-B883-7613E964A1EB' --WildCat HD -- 11,398; 

'7DB79611-A797-4938-AAC8-F3A887384304' --SmokyMountain HD --51938, Sales CRM: 51945, Service CRM: 0

'6B9537BD-115F-4019-B3AA-7F981EC69559'  --Greenly HD -- 20,436 salesCRM: 20,436,  Service CRM: 0

'EF42DEF6-DA60-4632-B879-B01B26CDE74A'  --IndianaPolis -- 12,651 Sales CRM: 12,689, Service CRM: 33

'9A9AC801-A7EE-40FB-99DA-B80F552A3A61'  --BlackJack HD -- 24,849 Sales CRM: 26829 Service CRM: 0
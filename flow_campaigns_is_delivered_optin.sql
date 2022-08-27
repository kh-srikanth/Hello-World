use auto_campaigns
select * from auto_campaigns.sms.campaigns a (nolock) where account_id = '26239573-9C57-44A1-B209-391C7B564B7E' and flow_id = 9174
select * from auto_campaigns.flow.flows (nolock) where account_id  = '26239573-9C57-44A1-B209-391C7B564B7E'

select * from auto_customers.portal.account with (nolock) where accountname like 'lone%'
select * from auto_campaigns.flow.flows (nolock) where account_id  in ('AEACFC4E-FADA-4FA1-A24D-EACED71020BB' --27892
																		,'489436CB-731A-4647-A26F-24BBD7034D28'--28138
																		,'2AB7B512-7D61-4C6D-8AED-710075AA6306' --28373
																		,'42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244' --29183
																		,'2928EACC-A39D-4743-BF02-F9689F16E79F')--email 27885
																	and flow_name like '%negative%'
/*
Brothers: 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
Hanksters: '489436CB-731A-4647-A26F-24BBD7034D28'
Big St. Charles Motorsports: '2AB7B512-7D61-4C6D-8AED-710075AA6306'
Kent Powersports of Austin: '42FDCA67-E5D5-4B3D-8DF2-FCCBBA08A244'
Lone Star Yamaha : '2928EACC-A39D-4743-BF02-F9689F16E79F'
(27892,28138,28373,29183,27885)
*/

drop table if exists #temp
select 
	a.campaign_id, a.name,a.account_id, b.accountname
into #temp
from auto_campaigns.sms.campaigns a (nolock)
inner join auto_customers.portal.account b with (nolock) on lower(a.account_id) = lower(b._id)
where   is_deleted =0
		and is_flow_campaign = 1
		and name like '%negative%'
		and campaign_id in (28138)

select * from #temp


drop table if exists #temp2
select 
	a.accountname,a.account_id,b.campaign_id,c.customer_id,b.phone,b.is_sent,b.is_delivered,c.do_not_sms
	, case when primary_phone_number_valid = 1 then primary_phone_number
			when primary_phone_number_valid = 0 and secondary_phone_number_valid = 1 then secondary_phone_number
			else primary_phone_number end as phone_db
--select 
		--a.accountname,a.account_id,b.campaign_id,a.name, count(campaign_item_id) [undelivered]
into #temp2
from #temp a (nolock)
inner join auto_campaigns.sms.campaign_items b (nolock) on a.campaign_id = b.campaign_id
inner join auto_customers.customer.customers c (nolock) on c.customer_id = b.list_member_id 
where 
	c.is_deleted =0
	and c.do_not_sms =0 
	and b.is_delivered = 0 

group by a.accountname, a.account_id, b.campaign_id,a.name


drop table if exists #temp_cust
select 
	b.customer_id
	, case when primary_phone_number_valid = 1 then primary_phone_number
			when primary_phone_number_valid = 0 and secondary_phone_number_valid = 1 then secondary_phone_number
			else primary_phone_number end as phone_db
	,do_not_sms
into #temp_cust
from auto_customers.customer.customers b (nolock) 
where b.account_id = '489436CB-731A-4647-A26F-24BBD7034D28'



select 
	b.do_not_sms,b.phone_db,b.customer_id
from #temp2 a 
inner join #temp_cust b on a.phone = b.phone_db
order by b.phone_db
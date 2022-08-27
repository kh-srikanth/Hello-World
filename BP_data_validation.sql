select * from auto_customers.portal.account with (nolock) where accountname like 'brother%' and _id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
select * from auto_campaigns.sms.campaigns (nolock) where is_deleted =0 and  account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'

drop table if exists #temp
select 
	case when primary_phone_number_valid =1 then primary_phone_number 
		when primary_phone_number_valid =0 and secondary_phone_number_valid = 1 then secondary_phone_number 
		else primary_phone_number end as phone
	,primary_email
	,a.customer_id
	,do_not_sms
	,b.is_delivered
	,b.campaign_item_id
	,a.r2r_customer_id
	,v.vehicle_id
	into #temp
from auto_customers.customer.customers a (nolock)
left outer join auto_customers.customer.vehicles v (nolock) on a.customer_id = v.customer_id and v.is_deleted=0
left outer join auto_campaigns.sms.campaign_items b (nolock) on a.customer_id = b.list_member_id and campaign_id = 27892
where 
	a.is_deleted =0
	and a.account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
	and (a.primary_phone_number_valid=1 or a.secondary_phone_number_valid=1)




	select 
		phone,primary_email,customer_id,do_not_sms,is_delivered,campaign_item_id,r2r_customer_id,min(vehicle_id) as vehicle_id 
	from #temp 
	where 
		clictell_auto_etl.dbo.isPhoneNovalid(phone)= 1 
	group by phone,primary_email,customer_id,do_not_sms,is_delivered,campaign_item_id,r2r_customer_id
	order by phone



--- Total Negative optin counts: 20434/15101
	select count(*) from auto_campaigns.sms.campaign_items b (nolock) where is_deleted =0 and  campaign_id = 27892 and is_delivered =1 --17656

-----Total SMS Subscriber Count : 28653
	select 
		count(*) 
	from auto_customers.customer.customers (nolock) 
	where 
		is_deleted =0 
		and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
		and do_not_sms =0
		and (primary_phone_number_valid = 1 or secondary_phone_number_valid = 1)
		--and r2r_customer_id is null

--customers from old r2r: 20419 for 4742 customers Neg.Optin is run ::customers from old r2r already opted-in: 14644:: customers from old r2r newly opted-in : 4699
	select 
		count(*) 
	from auto_customers.customer.customers a (nolock) 
	inner join auto_campaigns.sms.campaign_items b (nolock) on a.customer_id = b.list_member_id and campaign_id = 27892
	where 
		a.is_deleted =0 
		and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
		and r2r_customer_id is not null
		and do_not_sms = 0

--New customers from ETL : 15250 for 12923 customers Neg.Optin is run :: opted-in customers: 12326
	select 
		count(*) 
	from auto_customers.customer.customers a (nolock) 
	inner join auto_campaigns.sms.campaign_items b (nolock) on a.customer_id = b.list_member_id and campaign_id = 27892
	where 
		a.is_deleted =0 
		and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
		and r2r_customer_id is null
		and do_not_sms = 0



	select   --14642
		a.customer_id
		,case when primary_phone_number_valid =1 then primary_phone_number 
		when primary_phone_number_valid =0 and secondary_phone_number_valid = 1 then secondary_phone_number 
		else primary_phone_number end as phone
		,b.list_member_id
		,a.do_not_sms
		,a.r2r_customer_id
	from auto_customers.customer.customers a (nolock) 
	left outer join auto_campaigns.sms.campaign_items b (nolock) on a.customer_id = b.list_member_id and campaign_id = 27892
	where 
		a.is_deleted =0 
		and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
		and (primary_phone_number_valid = 1 or secondary_phone_number_valid = 1)
		--and r2r_customer_id is not null

	
	select --optin: 13954
		do_not_sms,count(*) 
	from auto_customers.customer.customers a (nolock) 
	left outer join auto_campaigns.sms.campaign_items b (nolock) on a.customer_id = b.list_member_id and campaign_id = 27892
	where 
		a.is_deleted =0 
		and account_id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 
		and (primary_phone_number_valid = 1 or secondary_phone_number_valid = 1)
		and r2r_customer_id is  null
	group by do_not_sms
	with rollup




	select * from auto_campaigns.sms.campaign_items (nolock) where campaign_id = 27892
	and 
	phone in (
'2539519711'
,'4253599775'
,'2064066966'
,'3604796943'
,'9076173994'
,'3609909880'
,'2532251952'
,'8325354390'
,'3607103754'
,'3602284506'
,'9076177515'
,'4049968190'
,'3104109777'
,'3602049990'
)
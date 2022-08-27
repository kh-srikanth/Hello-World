select * from auto_customers.portal.account with (nolock) where accountname like 'smoky%'  --2990
select * from auto_customers.portal.account with (nolock) where accountname like 'wildcat%'  --2991 '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'

select top 10 * from  [18.216.140.206].[r2r_cm].[media].[landing_page] a with (nolock) where dealer_id =2991
select * from [media].[landing_pages] (nolock) where account_id  in ('82ABF13B-B9C9-4BAB-B883-7613E964A1EB','c994b4f4-666e-446b-9a2f-c4985ebea150')
select * 
update a set is_default =0
from [media].[landing_pages] a (nolock) where account_id  = '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'


select * from auto_media.[template].[templates] c with (nolock) where account_id  = '7DB79611-A797-4938-AAC8-F3A887384304'  --13

select  * from [18.216.140.206].[r2r_cm].template.template a with (nolock) where dealer_id  = 2990  --9


select count(*) FROM
			[18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted)
			INNER JOIN [18.216.140.206].r2r_cm.campaign.campaign_media cm with(nolock,readuncommitted) on
			cm.campaign_id = a.campaign_id
			inner join auto_portal.[portal].[account] b with (nolock) on a.dealer_id = b.r2r_dealer_id
where b.r2r_dealer_id  = 2990
			and a.is_template = 1
			and a.media_type <> 'Email'
			and a.is_Deleted =0


select count(*) from auto_campaigns.email.campaigns (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304' and r2r_campaign_id is not null

select count(*) FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where a.media_type = 'Email' and dealer_id  = 2990

select count(*) from auto_campaigns.sms.campaigns (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304' and r2r_campaign_id is not null

select count(*) FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where a.media_type = 'sms' and dealer_id  = 2990

select count(*) from auto_campaigns.push.campaigns (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304' and r2r_campaign_id is not null

select count(*) FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where a.media_type = 'push' and dealer_id  = 2990





select top 10 * FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where a.media_type = 'sms' and dealer_id  = 2990 and name like 'blessing%'
select * 
--update a set schedule_type_id =1
from auto_campaigns.email.campaigns a (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304' and  schedule_type_id <> 1


and name like 'blessing%'
r2r_campaign_id = 78212
select * from auto_campaigns.sms.campaigns a (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304' and campaign_id in (24628,27742)

select * from auto_campaigns.email.campaigns a (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304' and name like 'Marketing 4/20/22'
'Marketing 4/27/22'

select * from auto_campaigns.email.campaigns a (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304' and campaign_id in
(23321,23320) and is_deleted =0
select top 10 * FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where campaign_id in ( 78206,78202)



select count(*) from auto_customers.customer.customers (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304'  and is_App_user =1  and is_deleted =0
select count(*) FROM [18.216.140.206].r2r_admin.owner.owner with (nolock) where dealer_id = 2990 and is_App_user =1 and is_deleted =0


select count(*) 
--update a set is_deleted =1
from auto_customers.customer.customers a (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304'  and is_App_user =1 and is_deleted =0
and r2r_customer_id in (select owner_id FROM [18.216.140.206].r2r_admin.owner.owner with (nolock) where dealer_id = 2990 and is_App_user =1 and is_deleted =1)



--'82ABF13B-B9C9-4BAB-B883-7613E964A1EB' -- Wild CAt

select count(*) from auto_customers.customer.customers (nolock) where account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'  and is_App_user =1  and is_deleted =0
select count(*) FROM [18.216.140.206].r2r_admin.owner.owner with (nolock) where dealer_id = 2991 and is_App_user =1 and is_deleted =0


select count(*) 
--update a set is_deleted =1
from auto_customers.customer.customers a (nolock) where account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'  and is_App_user =1 and is_deleted =1
and r2r_customer_id in (select owner_id FROM [18.216.140.206].r2r_admin.owner.owner with (nolock) where dealer_id = 2991 and is_App_user =1 and is_deleted =0)

select owner_id FROM [18.216.140.206].r2r_admin.owner.owner with (nolock) where dealer_id = 2991 and is_app_user =1  and owner_id in 
(
select r2r_customer_id from auto_customers.customer.customers (nolock) where account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'  
and is_app_user =0 and r2r_customer_id is not null
)

select is_app_user,* FROM [18.216.140.206].r2r_admin.owner.owner with (nolock) where dealer_id = 2991 and owner_id in 
(
626986
,701748
,326758
,1026430
,622945
,814423
,622487
,895310
,149210
,749679
,829796
)

select is_app_user,* from  auto_customers.customer.customers (nolock) where account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'  and r2r_customer_id  in 
(
626986
,701748
,326758
,1026430
,622945
,814423
,622487
,895310
,149210
,749679
,829796
)


select count(*) from auto_campaigns.email.campaigns (nolock) where account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'   and r2r_campaign_id is not null and is_deleted =0

select count(*) FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where a.media_type = 'Email'  and dealer_id  = 2991 and is_deleted =0

select count(*) from auto_campaigns.sms.campaigns (nolock) where account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'   and r2r_campaign_id is not null  and is_deleted =0

select count(*) FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where a.media_type = 'sms' and dealer_id  = 2991 and is_deleted =0

select count(*) from auto_campaigns.push.campaigns (nolock) where account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'   and r2r_campaign_id is not null and is_deleted =0

select count(*) FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where a.media_type = 'push' and dealer_id  = 2991 and is_deleted =0


select 
--update a set 
a.customer_id,a.do_not_email,b.is_email_suppressed,b.is_email_bounced,a.updated_by,a.updated_dt
from  auto_customers.customer.customers a (nolock)
inner join [18.216.140.206].r2r_admin.owner.owner b with (nolock) on a.r2r_customer_id = b.owner_id 
where a.account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'  
and b.dealer_id = 2991
and do_not_email=0
and a.is_email_bounce =0

select top 10 * from [18.216.140.206].r2r_admin.owner.owner b with (nolock)


select count(*) 
from auto_customers.customer.customers a (nolock)
where 
a.account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'
and do_not_email=0
and is_email_bounce =0
and is_Deleted =0


select count(*)
from [18.216.140.206].r2r_admin.owner.owner b with (nolock) 
where dealer_id = 2991
and is_deleted =0 
and is_email_suppressed =0
and is_email_bounced =0





select r2r_customer_id
from auto_customers.customer.customers a (nolock)
where 
a.account_id= '7DB79611-A797-4938-AAC8-F3A887384304'
and do_not_email=0
and is_email_bounce =0
and is_Deleted =0

except

select owner_id
from [18.216.140.206].r2r_admin.owner.owner b with (nolock) 
where dealer_id = 2990
and is_deleted =0 
and is_email_suppressed =0
and is_email_bounced =0


select a.customer_id,a.do_not_email,b.is_email_suppressed,a.is_email_bounce,b.is_email_bounced,a.updated_by,a.updated_dt

--update a set a.is_deleted =1
from  auto_customers.customer.customers a (nolock)
inner join [18.216.140.206].r2r_admin.owner.owner b with (nolock) on a.r2r_customer_id = b.owner_id 
where a.account_id= '7DB79611-A797-4938-AAC8-F3A887384304' 
and b.dealer_id = 2990
--and (do_not_email <>is_email_suppressed
--or a.is_email_bounce <> is_email_bounced)
and a.is_Deleted=0 and b.is_deleted =1


select is_deleted,do_not_email,is_email_bounce from auto_customers.customer.customers a (nolock) where r2r_customer_id = 698776

select is_deleted,is_email_suppressed,is_email_bounced from [18.216.140.206].r2r_admin.owner.owner b with (nolock) where owner_id = 698776



select count(*)
from auto_customers.customer.customers a (nolock)
where 
a.account_id= '7DB79611-A797-4938-AAC8-F3A887384304'
and do_not_sms=0
and is_Deleted =0

except

select count(*)
from [18.216.140.206].r2r_admin.owner.owner b with (nolock) 
where dealer_id = 2990
and is_deleted =0 
and is_lime_opted_in =1

select a.customer_id,a.do_not_sms,is_lime_opted_in,a.is_deleted,a.updated_by,a.updated_dt

--update a set a.is_deleted =0,updated_by ='sk_roll_back',updated_dt =getdate()
from  auto_customers.customer.customers a (nolock)
inner join [18.216.140.206].r2r_admin.owner.owner b with (nolock) on a.r2r_customer_id = b.owner_id 
where a.account_id= '7DB79611-A797-4938-AAC8-F3A887384304' 
and b.dealer_id = 2990
--and a.do_not_sms <> 0
and b.is_lime_opted_in =1
and a.is_deleted =1
and b.is_deleted =0


select 
	a.customer_id,a.do_not_sms,is_lime_opted_in,a.is_deleted,a.updated_by,a.updated_dt

select count(*)
from  auto_customers.customer.customers a (nolock)
left outer join [18.216.140.206].r2r_admin.owner.owner b with (nolock) on a.r2r_customer_id = b.owner_id and b.dealer_id = 2998
where a.account_id= 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'  
and b.owner_id is null

select count(*) from  [18.216.140.206].r2r_admin.owner.owner b with (nolock) where is_deleted  =0 and dealer_id = 2998 and is_lime_opted_in =1

select * from auto_customers.portal.account b (nolock) where _id = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB' 


and a.is_Deleted=0 and b.is_deleted =1



drop table if exists #temp_old
select owner_id,mobile,phone
,case when len(mobile) >=10 then mobile when len(mobile) < 10 and len(phone) >=10 then phone else ''  end as phone_old

into #temp_old
 from [18.216.140.206].r2r_admin.owner.owner b with (nolock)
where 
 b.dealer_id = 2990 and is_Deleted =0


 select * from #temp_old


 drop table if exists #temp_old1
 select owner_id, iif(len(phone_old1) >10 , substring(phone_old1,2,len(phone_old1)),phone_old1) as phone_old1 
 into #temp_old1
 from 
 (
 select owner_id,
 REPLACE(translate(upper(phone_old),'ABCDEFGHIJKLMNOPQRSTUVWXYZ+-;,.()[]{}* ','@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),'@','') as phone_old1 
 from #temp_old
 ) as a

 select customer_id, r2r_customer_id,
 case when len(primary_phone_number)>=10 then primary_phone_number
		when len(primary_phone_number) < 10 and len(secondary_phone_number) >=10 then secondary_phone_number
		else '' end as phone
into #temp_new1
from auto_customers.customer.customers (nolock)
where is_deleted =0 and account_id= '7DB79611-A797-4938-AAC8-F3A887384304' 


select phone_old1 from #temp_old1
except
select phone from #temp_new1





--WILDCAT

select count(*) from auto_campaigns.email.campaigns (nolock) where account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'   and r2r_campaign_id is not null and is_deleted =0

select count(*) FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where a.media_type = 'Email'  and dealer_id  = 2991 and is_deleted =0

select count(*) from auto_campaigns.sms.campaigns (nolock) where account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'   and r2r_campaign_id is not null  and is_deleted =0

select count(*) FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where a.media_type = 'sms' and dealer_id  = 2991 and is_deleted =0

select count(*) from auto_campaigns.push.campaigns (nolock) where account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'   and r2r_campaign_id is not null and is_deleted =0

select count(*) FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where a.media_type = 'push' and dealer_id  = 2991 and is_deleted =0


select 
a.is_deleted,b.is_deleted,a.updated_by,a.updated_dt

--update a set is_deleted =0, updated_by = 'sk_undel',updated_dt =getdate()
from auto_campaigns.email.campaigns a (nolock)
inner join [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) on a.r2r_campaign_id = b.campaign_id
where b.media_type = 'Email'  and dealer_id  = 2991 and a.account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB' 
and a.is_deleted =1 and b.is_Deleted =0



select 
a.is_deleted,b.is_deleted,a.updated_by,a.updated_dt

--update a set is_deleted =0, updated_by = 'sk_undel',updated_dt =getdate()
from auto_campaigns.sms.campaigns a (nolock)
inner join [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) on a.r2r_campaign_id = b.campaign_id
where b.media_type = 'sms'  and dealer_id  = 2991 and a.account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB' 
and a.is_deleted =1 and b.is_Deleted =0






----SMOKY

select campaign_id FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where a.media_type = 'Email'  and dealer_id  = 2990 and is_deleted =0
except
select r2r_campaign_id from auto_campaigns.email.campaigns (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304'   and r2r_campaign_id is not null and is_deleted =0




select count(*) from auto_campaigns.email.campaigns (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304'   and r2r_campaign_id is not null and is_deleted =0

select count(*) FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where a.media_type = 'Email'  and dealer_id  = 2990 and is_deleted =0

select count(*) from auto_campaigns.sms.campaigns (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304'   and r2r_campaign_id is not null  and is_deleted =0

select count(*) FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where a.media_type = 'sms' and dealer_id  = 2990 and is_deleted =0

select count(*) from auto_campaigns.push.campaigns (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304'   and r2r_campaign_id is not null and is_deleted =0

select count(*) FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where a.media_type = 'push' and dealer_id  = 2990 and is_deleted =0



select a.campaign_id,
a.is_deleted,b.is_deleted,a.updated_by,a.updated_dt

--update a set is_deleted =0, updated_by = 'sk_undel',updated_dt =getdate()
from auto_campaigns.email.campaigns a (nolock)
inner join [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) on a.r2r_campaign_id = b.campaign_id
where b.media_type = 'Email'  and dealer_id  = 2990 and a.account_id= '7DB79611-A797-4938-AAC8-F3A887384304'  
and a.is_deleted =1 and b.is_Deleted =0



select a.campaign_id,
a.is_deleted,b.is_deleted,a.updated_by,a.updated_dt

--update a set is_deleted =0, updated_by = 'sk_undel',updated_dt =getdate()
from auto_campaigns.sms.campaigns a (nolock)
inner join [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) on a.r2r_campaign_id = b.campaign_id
where b.media_type = 'sms'  and dealer_id  = 2990 and a.account_id= '7DB79611-A797-4938-AAC8-F3A887384304' 
and a.is_deleted =1 and b.is_Deleted =0


-----------------LISTS
--smoky
select * from [18.216.140.206].[r2r_admin].[owner].[contact_list] with (nolock) where dealer_id  = 2990 and is_deleted =0 --18
select *  from auto_customers.list.lists (nolock) where is_deleted = 0 and account_id= '7DB79611-A797-4938-AAC8-F3A887384304' --18


--WIldcat
select * from [18.216.140.206].[r2r_admin].[owner].[contact_list] with (nolock) where dealer_id  = 2991 and is_deleted =0  --10
select *  from auto_customers.list.lists (nolock) where is_deleted = 0 and account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB' --10



------------------------Sanjose lists update
select * from auto_customers.list.lists (nolock) where is_Deleted =0 and account_id  = 'eff907ca-21c5-4703-8bdc-c0d06218908f'

select * from [18.216.140.206].[r2r_admin].[owner].[contact_list] with (nolock) where dealer_id  = 48654 and is_deleted =0 --18


select count(*) from [18.216.140.206].[r2r_admin].[owner].[owner] with (nolock) where is_deleted =0 and dealer_id  = 48654 and contact_list_ids like '%,13229%' 
and (is_lime_opted_in =1 or (is_email_suppressed = 0 and is_email_bounced = 0) or is_app_user = 1) 

select count(*) from auto_customers.customer.customers (nolock) where 	is_Deleted =0 	and account_id  = 'eff907ca-21c5-4703-8bdc-c0d06218908f' and list_ids like '%,1116,%'
and (primary_email_valid = 1 or primary_phone_number_Valid =1 or secondary_phone_number_valid = 1)
--------------------------






select status_type_id,count(*) from auto_campaigns.email.campaigns (nolock) where account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'   and r2r_campaign_id is not null  and is_deleted =0
group by status_type_id with rollup

select status_type_id,count(*) from auto_campaigns.email.campaigns (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304'   and r2r_campaign_id is not null  and is_deleted =0
group by status_type_id with rollup


select * from auto_campaigns.[campaign].[status_type] (nolock)


select status_type_id,* from auto_campaigns.email.campaigns (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304'  and r2r_campaign_id is not null  and is_deleted =0
and name like '%Marketing 5/4/22'

select status_type_id,* from  [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) where dealer_id = 2990 and media_type = 'Email' and name like '%clone of marketing 1/5/22'

select * from [18.216.140.206].r2r_cm.[campaign].[status_type] with (nolock)



select status_type_id,* from  [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) where dealer_id = 2991 and media_type = 'Email' and campaign_id in (

select r2r_campaign_id from auto_campaigns.email.campaigns (nolock) where account_id= '82ABF13B-B9C9-4BAB-B883-7613E964A1EB'  and r2r_campaign_id is not null  and is_deleted =0
and status_type_id <> 5
)

select * 
update a set status_type_id = 6
from auto_campaigns.email.campaigns a (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304'  and r2r_campaign_id in 
(
78152,78159,78160,78174,78175,78177,78179,78181,78182,78183,78187,78188,78190,78192,78193,78206)


select status_type_id,*
from auto_campaigns.email.campaigns a (nolock) where account_id= '7DB79611-A797-4938-AAC8-F3A887384304'  and is_Deleted =0 and 
name like 'marketing 4/6/22'

status_type_id =2


select status_type_id,* from  [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) where dealer_id = 2990 and campaign_id = 78195



------------------Indianapolis sms preview fix

select * from  [18.216.140.206].r2r_cm.campaign.campaign b with(nolock,readuncommitted) where dealer_id = 48878 and media_type = 'sms' and is_r2r_flow =0 and is_deleted  =0

select * from auto_campaigns.sms.campaigns (nolock) where is_deleted =0 and account_id  = 'ef42def6-da60-4632-b879-b01b26cde74a'

select * from  [18.216.140.206].[r2r_cm].campaign.campaign_media d with (nolock) where campaign_id  = 75694

select a.html_content, b.html_content
--update a set a.html_content =  b.html_content
from auto_campaigns.sms.campaigns a (nolock) 
inner join [18.216.140.206].[r2r_cm].campaign.campaign_media b with (nolock) on a.r2r_campaign_id  = b.campaign_id

where a.is_deleted =0 
and a.html_content is null

and a.account_id  = 'ef42def6-da60-4632-b879-b01b26cde74a'



select * from auto_campaigns.email.campaigns (nolock) where account_id= 'ef42def6-da60-4632-b879-b01b26cde74a' and r2r_campaign_id is not null order by created_dt desc

select * from email.campaign_items (nolock) where campaign_id  = 24406

select * FROM [18.216.140.206].r2r_cm.campaign.campaign a with(nolock,readuncommitted) where a.media_type = 'Email' and dealer_id  = 48878 order by created_dt desc

select a.*
from [18.216.140.206].[r2r_cm].[email].[campaign_item] a with (nolock)
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign_media] b with (nolock) on a.campaign_media_id = b.campaign_media_id
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign] e with (nolock) on b.campaign_id = e.campaign_id
where e.campaign_id  = 78317


-----------------LISTS
--Rexburg
select * from [18.216.140.206].[r2r_admin].[owner].[contact_list] with (nolock) where dealer_id  = 48884 and is_deleted =0 order by list_name --18
select *  from auto_customers.list.lists (nolock) where is_deleted = 0 and account_id= 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' order by list_name --18

select * from portal.account with (nolock) where _id  = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF'


select * from auto_customers.list.lists (nolock) where  r2r_custsegment_id in (13806,13561) and account_id= 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' 




---Black Jack   '9A9AC801-A7EE-40FB-99DA-B80F552A3A61'  / 2999
use auto_campaigns

select c.name,c.campaign_id,
c.html_content,d.html_content
,c.content_json,d.content_json
,c.schedule_options,a.schedule_options
,c.thumbnail_url,d.thumbnail_url
from [18.216.140.206].[r2r_cm].campaign.campaign a (nolock)
inner join auto_portal.[portal].[account] b with (nolock) on a.dealer_id = b.r2r_dealer_id
left outer join [18.216.140.206].[r2r_cm].campaign.campaign_media d with (nolock) on a.campaign_id = d.campaign_id
inner join email.campaigns c with (nolock) on a.campaign_id = c.r2r_campaign_id 
where a.media_type = 'Email'-- and c.campaign_id is null
and a.dealer_id in (2999)
and b.accountstatus = 'active'
and isnull(a.is_r2r_flow,0) = 0
order by a.campaign_id


--Rexberg Vehicle discrepency
select 
	a.customer_id,primary_phone_number,first_name,last_name,secondary_phone_number,primary_email,vehicle_id,vin,make,model,year,b.updated_dt
	--select a.*
from auto_customers.customer.customers a (nolock)
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id = b.customer_id
where 
a.is_Deleted =0 
and a.account_id  = 'a1478891-4f48-4b55-9d64-b5fb5b99b1ef'
and (primary_phone_number_valid = 1 or secondary_phone_number_valid = 1 or primary_email_valid = 1 )
and primary_email like 'lnate2@yahoo.com'
--and secondary_phone_number = '3077602778'
--order by primary_email,primary_phone_number


select * from clictell_auto_master.master.vehicle_makemodel (nolock) where modeldesc like 'CATM8000SnoPro'



--update Campaign items

select 
top 10 *
from [18.216.140.206].[r2r_cm].[email].[campaign_item] a with (nolock)
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign_media] b with (nolock) on a.campaign_media_id = b.campaign_media_id
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign] e with (nolock) on b.campaign_id = e.campaign_id
inner join email.campaigns c with (nolock) on e.campaign_id = c.r2r_campaign_id
inner join auto_customers.customer.customers d with (nolock) on a.list_member_id = d.r2r_customer_id
left outer join email.campaign_items f with (nolock) on a.campaign_item_id = f.r2r_campaignitem_id and c.campaign_id = f.campaign_id
where e.dealer_id in (48878) 
and f.campaign_item_id is null 
and d.is_deleted = 0
and isnull(e.is_r2r_flow,0) =0


select * from auto_customers.portal.account with (nolock) where accountname like 'indiana%'
select * from auto_campaigns.email.campaigns b (nolock) where is_deleted =0 and account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' and status_type_id = 6 order by 1 desc
select top 10 * from [18.216.140.206].[r2r_cm].[email].[campaign_item] a with (nolock)
select top 10 * from auto_campaigns.email.campaign_items b (nolock)


select b.is_opened,a.is_opened--57
--update b set b.is_opened=a.is_opened
from [18.216.140.206].[r2r_cm].[email].[campaign_item] a with (nolock)
inner join auto_campaigns.email.campaign_items b (nolock) on a.campaign_item_id = b.r2r_campaignitem_id
where 
b.campaign_id = 23239
and 
b.is_opened<>a.is_opened


select b.is_clicked,a.is_clicked--57
--update b set b.is_clicked=a.is_clicked
from [18.216.140.206].[r2r_cm].[email].[campaign_item] a with (nolock)
inner join auto_campaigns.email.campaign_items b (nolock) on a.campaign_item_id = b.r2r_campaignitem_id
where 
b.campaign_id = 23239
and 
b.is_clicked<>a.is_clicked


select
	b.campaign_id,b.is_clicked,a.is_clicked
	--update b set b.is_clicked = a.is_clicked
from [18.216.140.206].[r2r_cm].[email].[campaign_item] a with (nolock)
inner join auto_campaigns.email.campaign_items b (nolock) on a.campaign_item_id = b.r2r_campaignitem_id
inner join auto_campaigns.email.campaigns c (nolock) on c.campaign_id = b.campaign_id
where 
	c.is_deleted =0
	and c.account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A'
	and b.is_clicked <> a.is_clicked



select
	b.campaign_id,b.is_opened,a.is_opened
	--update b set b.is_opened = a.is_opened
from [18.216.140.206].[r2r_cm].[email].[campaign_item] a with (nolock)
inner join auto_campaigns.email.campaign_items b (nolock) on a.campaign_item_id = b.r2r_campaignitem_id
inner join auto_campaigns.email.campaigns c (nolock) on c.campaign_id = b.campaign_id
where 
	c.is_deleted =0
	and c.account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A'
	and b.is_opened <> a.is_opened


select 
	b.name,a.* 
from auto_campaigns.email.counts a (nolock)
inner join auto_campaigns.email.campaigns b (nolock) on a.campaign_id = b.campaign_id
where
b.is_deleted =0 and account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' 
order by 2 desc



select * from auto_campaigns.email.clicks a (nolock)
select * from [18.216.140.206].[r2r_cm].email.clicks a (nolock)

select 
a.*
from auto_campaigns.email.clicks a (nolock)
inner join auto_campaigns.email.campaign_items b (nolock) on a.campaign_item_id = b.campaign_item_id
inner join auto_campaigns.email.campaigns b1 (nolock) on b1.campaign_id = b.campaign_id
inner join [18.216.140.206].[r2r_cm].[email].[campaign_item] c with (nolock) on c.campaign_item_id = b.r2r_campaignitem_id
where 
		b1.account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' 


-------------------insert email.clicks
 select 
	a.*,e.click_id
 from [18.216.140.206].[r2r_cm].email.clicks a (nolock)
 inner join [18.216.140.206].[r2r_cm].[email].[campaign_item] b with (nolock) on a.campaign_item_id = b.campaign_item_id
 inner join auto_campaigns.email.campaign_items c (nolock) on c.r2r_campaignitem_id = b.campaign_item_id
 inner join auto_campaigns.email.campaigns d (nolock) on d.campaign_id = c.campaign_id
 left outer join auto_campaigns.email.clicks e (nolock) on e.campaign_item_id = c.campaign_item_id  and e.link = a.link and e.is_deleted = 0
 where 
 d.account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A'
 and e.click_id is null
 


 select * from auto_campaigns.email.clicks e (nolock)
 select count(*)  from [18.216.140.206].[r2r_cm].email.clicks a (nolock)

 select 
 g.*
 from  [18.216.140.206].[r2r_cm].campaign.campaign a (nolock)
 inner join [18.216.140.206].[r2r_cm].campaign.campaign_media e with (nolock) on a.campaign_id = e.campaign_id
  inner join [18.216.140.206].[r2r_cm].[email].[campaign_item] b  (nolock) on e.campaign_media_id = b.campaign_media_id
  inner join [18.216.140.206].[r2r_cm].[email].clicks c (nolock) on b.campaign_item_id = c.campaign_item_id
  inner join auto_campaigns.email.campaign_items f (nolock) on f.r2r_campaignitem_id = b.campaign_item_id
  inner join auto_campaigns.email.clicks g (nolock) on f.campaign_item_id = g.campaign_item_id and g.link = c.link
  where
	a.campaign_id = 78323
	and g.is_deleted =0


select top 10 * from [18.216.140.206].[r2r_cm].[email].[campaign_item] b  (nolock)
select a.*
from auto_campaigns.email.campaigns b (nolock) 
inner join [18.216.140.206].[r2r_cm].campaign.campaign a (nolock) on b.r2r_campaign_id = a.campaign_id
where  account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A'
order by 1 desc



select
sum(convert(int,is_clicked))
from auto_campaigns.email.campaign_items b (nolock) 
where 
b.campaign_id = 24651


select * from auto_campaigns.email.campaigns (nolock) 
where account_id = 'EF42DEF6-DA60-4632-B879-B01B26CDE74A' and name like 'July Video Newsletter #1'

select * from auto_campaigns.email.counts (nolock) where 
campaign_id = 24651

campaign_item_id in 
(select campaign_item_id from auto_campaigns.email.campaign_items b (nolock) 
where 
b.campaign_id = 24651
)
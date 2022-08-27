use clictell_auto_etl
select * from clictell_auto_etl.etl.cdk_customer (nolock)	----241,323

use clictell_auto_master

select * from clictell_auto_master.master.customer (nolock) where parent_dealer_id =3407		--111,885


select  distinct
		cust_dms_number
		,cust_do_not_call
		,cust_do_not_email
		,ec.BlockPhone
		,cust_do_not_mail
		,cust_do_not_text
		,cust_do_not_social 
from clictell_auto_master.master.customer mc (nolock) 
inner join clictell_auto_etl.etl.cdk_customer ec (nolock) on mc.cust_dms_number = ec.CustNo and mc.natural_key = ec.src_dealer_code
where parent_dealer_id =3407
and (case when ec.BlockEmail = 'Y' then 1 else 0 end) <> mc.cust_do_not_email


select cust_do_not_call,* from clictell_auto_master.master.customer (nolock) where cust_dms_number in ('20570','24441')

select BlockPhone, * from clictell_auto_etl.etl.cdk_customer (nolock) where CustNo in ('20570','24441')
--'12216'  ('68782','22051')
select top 10 src_dealer_code, * from clictell_auto_etl.etl.cdk_sales1 (nolock) where src_dealer_code = '3PA0002269'
select top 10 * from clictell_auto_etl.etl.cdk_sales2 (nolock) --where src_dealer_code = '3PA0002269'
select top 10  * from clictell_auto_etl.etl.cdk_sales3 (nolock) --where src_dealer_code = '3PA0002269'
select top 10  * from clictell_auto_etl.etl.cdk_servicero_header (nolock) --where src_dealer_code = '3PA0002269'


select  cust_do_not_call,cust_do_not_email,cust_do_not_mail,ro_close_date, * from clictell_auto_stg.stg.service_ro_header a (nolock) where cust_dms_number = '12216' order by a.ro_close_date desc
select  cust_do_not_call,cust_do_not_email,cust_do_not_mail,* from clictell_auto_stg.stg.service_appts (nolock) where cust_dms_number = '12216' order by appt_open_Date desc
select buyer_optout,* from clictell_auto_stg.stg.fi_sales (nolock) where deal_number_dms = '12216'
--natural_key ='3PA0002269' and deal_number_dms = '12216'

stg.fi_sales
stg.service_appts

--parent_dealer_id=3407 and cust_do_not_call is not null
--update clictell_auto_master.master.customer set  cust_do_not_call = 1 where cust_dms_number in ('20570','24441') and parent_dealer_id = 3407
--241,323
use clictell_auto_master

select	c.natural_key
		,c.parent_dealer_id
		,c.master_customer_id
		,c.cust_dms_number
		,cust_first_name
		,cust_last_name
		,cust_full_name
		, cust_address1
		,cust_address2
		,cust_city
		,cust_state_code
		,cust_zip_code
		,cust_zip_code4
		,cust_mobile_phone
		,cust_home_phone
		,cust_email_address1
		,cust_email_address2 
		,customer_type
		--,cv.active_date
		--,cv.inactive_date
from clictell_auto_master.master.customer c (nolock) 
--inner join clictell_auto_master.master.cust_2_vehicle cv (nolock) 
--			on  c.cust_dms_number = cv.cust_dms_number 
--				and c.parent_dealer_id = cv.parent_dealer_id 
--				and c.master_customer_id = cv.master_customer_id

where c.parent_dealer_id =3407


use auto_campaigns
select report_name from campaign.reports (nolock) where is_deleted =1 and  report_url not like '%DMS%'
and report_name like '%Follow%'
--update campaign.reports set is_deleted =0

select * from campaign.reports (nolock) where report_name = 'Sales Executive Summary'

--update campaign.reports set thumbnail_url ='https://clicmotionassets.s3.amazonaws.com/Reportthumbnails/Sales-Executive-Summary.PNG' where report_name = 'Sales Executive Summary'


use r2r_admin
select top 20 * from [owner].[owner] (nolock)
--select * from [user].[customers] (nolock)
use r2r_admin
select top 20 * from [r2r_admin].[owner].[contact_list] (nolock)

use r2r_admin
select top 20 * from cycle.cycle (nolock)



select suser_name()



use clictell_auto_master
declare
@dealer_id varchar(4000) = null, 
@parent_id varchar(100)= 'E26CE42E-BD40-11EB-B988-0A4357799CFA',
--'7113589E-B6E0-11EB-82D4-0A4357799CFA',
--'E26CE42E-BD40-11EB-B988-0A4357799CFA',
--'3397D8EA-BD3A-11EB-845D-0A4357799CFA',
@FromDate date = '2020-01-01',  
@ToDate date = '2021-08-16'

IF (@dealer_id is null or @dealer_id = '')
BEGIN
		;with dealers (_id,parentid,parent_dealer_id, dealer_name)
		as
		(
		select distinct _id,parentid,parent_dealer_id,dealer_name from master.dealer (nolock) where _id =@parent_id
		union all
		select  m._id,m.parentid,m.parent_dealer_id,m.dealer_name from master.dealer m (nolock) inner join dealers d on m.parentid =d._id
		and m.parentid is not null
		)
		select string_agg(cast(parent_dealer_id as varchar(max)),',') as parent_dealer_id  into #temp from dealers

select * from #temp
END
drop table #temp

select * from master.dealer (nolock) where parent_dealer_id ='1535'

use clictell_auto_master
select * from [master].[dealer_hierarchy]('7113589E-B6E0-11EB-82D4-0A4357799CFA')

select * from master.dealer (nolock) where accountname like '%Honda%' and accounttype ='OEM'
1811

			set @parent_id = (select _id from master.dealer (nolock) where parent_dealer_id = 1811)

			select parent_dealer_id, accountname as dealer_name,accounttype  from [master].[dealer_hierarchy]('3397D8EA-BD3A-11EB-845D-0A4357799CFA') where accounttype = 'Dealer' and parent_dealer_id =1806

select convert(decimal(18,2),convert(varchar(10),0.) + convert(varchar(10),abs(checksum(NewId()))))*10
select 100 + ROUND( 100 *RAND(convert(varbinary, newid())), 0)


/*use clictell_auto_master
insert into master.dashboard_kpis ( 
parent_dealer_id 
,kpi_type
,vehiel_type
,subject
,chart_title
,chart_subtitle1
,chart_subtitle2
,graph_data
,is_deleted
,kpi_type_id
,is_default
,user_id
)
select 
2325
,kpi_type
,vehiel_type
,subject
,chart_title
,chart_subtitle1
,chart_subtitle2
,graph_data
,is_deleted
,kpi_type_id
,is_default
,user_id

 from master.dashboard_kpis (nolock) where parent_dealer_id =3407*/

select * from master.dealer (nolock) where dealer_name like '%hometown%'


use clictell_auto_master

select * from master.repair_order_header (nolock) where parent_dealer_id =1806

use clictell_auto_master
select top 1000 mileage_in from master.repair_order_header (nolock)


use clictell_auto_master
select top 10 * from master.campaign_items (nolock) where parent_dealer_id =1806 and cp_amount <> 0
select top 10 * from master.campaign_items_new (nolock)
select top 10 * from [master].[campaign_responce] (nolock)
select top 10 * from [master].[campaign_responses] (nolock) where parent_dealer_id =1806 and cp_amount <> 0
select * from [auto_campaigns].[email].[campaigns] (nolock) where campaign_id  = 1439

-------------------------------------**************************


/*insert into [customer].[r2r_customers_del]   
(    customer_guid  /*,account_id*/  ,user_id  ,first_name  ,last_name  ,company_name  ,address_line  ,city  ,state  ,zip  ,zip_valid  ,primary_phone_number  ,primary_phone_number_valid  ,secondary_phone_number  ,primary_email  ,primary_email_valid  ,birth_date  ,privacy_ind  ,pages_list  ,do_not_email  ,do_not_sms  ,notes  ,comments  ,is_deleted  ,address_line2  ,list_ids  ,r2r_customer_id  ,r2r_dealer_id  ,created_by  ,created_dt  ,updated_by  ,updated_dt  )    
values ('F04C4D57-4312-4309-A0DF-B66CB9BAFB2B','0','Smith','J','','','','','','0','(731) 587-7035','0','','smith111.j@gmail.com','0','1900-01-01','0','','0','0','','','0','','0','842032','48428','sa','Jan 10 2020  5:15AM','vishnu_06_10_master_','Jun 10 2020  9:47AM')

--r2r_customer_id ='842032'*/

/*
select top 10 * from [auto_stg_customers].[customer].[segments] where query_operator is not null and query_operator <>''

create table [auto_stg_customers].[customer].[r2r_segments_del]
(
segment_name varchar(100)
,segment_query varchar(max)
,query_operator  varchar(50)
,is_deleted int
,created_dt date
,created_by  varchar(100)
,updated_dt date
,updated_by  varchar(100)
,r2r_dealer_id int
,r2r_contact_list_id int


)

insert into [auto_stg_customers].[customer].[r2r_segments_del]  
(  segment_name  ,segment_query  ,query_operator  ,is_deleted  ,created_dt  ,created_by  ,updated_dt  ,updated_by  ,r2r_dealer_id  ,r2r_contact_list_id      )    
values 
('VIP''s Group','','','0','Oct  2 2018  6:11PM','sa','Oct  2 2018  6:11PM','sa','2936','1')
use [auto_stg_customers]
select * from [auto_stg_customers].[customer].[r2r_segments_del]  (nolock)

--insert into [auto_stg_customers].[customer].[r2r_segments_del]  (  segment_name  ,segment_query  ,query_operator  ,is_deleted  ,created_dt  ,created_by  ,updated_dt  ,updated_by  ,r2r_dealer_id  ,r2r_contact_list_id      )    values ('All Email Subscribers','','','0','Oct 11 2019  6:11AM','sa','Oct 11 2019  6:11AM','sa','48428','11953')
--insert into [auto_stg_customers].[customer].[r2r_segments_del]  (  segment_name  ,segment_query  ,query_operator  ,is_deleted  ,created_dt  ,created_by  ,updated_dt  ,updated_by  ,r2r_dealer_id  ,r2r_contact_list_id      )    values ('All SMS Subscribers','','','0','Oct 11 2019  6:11AM','sa','Oct 11 2019  6:11AM','sa','48428','11954')
--insert into [auto_stg_customers].[customer].[r2r_segments_del]  (  segment_name  ,segment_query  ,query_operator  ,is_deleted  ,created_dt  ,created_by  ,updated_dt  ,updated_by  ,r2r_dealer_id  ,r2r_contact_list_id      )    values ('App Users','','','0','Oct 11 2019  6:11AM','sa','Oct 11 2019  6:11AM','sa','48428','11952')
--insert into [auto_stg_customers].[customer].[r2r_segments_del]  (  segment_name  ,segment_query  ,query_operator  ,is_deleted  ,created_dt  ,created_by  ,updated_dt  ,updated_by  ,r2r_dealer_id  ,r2r_contact_list_id      )    values ('Default Push Segment','','','0','Jan 13 2020  5:51AM','sa','Jan 13 2020  5:51AM','sa','48428','12494')
--insert into [auto_stg_customers].[customer].[r2r_segments_del]  (  segment_name  ,segment_query  ,query_operator  ,is_deleted  ,created_dt  ,created_by  ,updated_dt  ,updated_by  ,r2r_dealer_id  ,r2r_contact_list_id      )    values ('Suppression List','','','0','Sep 30 2020  8:03AM','sa','Sep 30 2020  8:03AM','sa','48428','13349')

*/


select * from [auto_stg_customers].[customer].[r2r_customers_del] 


select top 10  * from [auto_stg_customers].[customer].[segments] (nolock)

select distinct segment_type_id from [auto_stg_customers].[customer].[segments] (nolock)

select top 10  * from [auto_stg_customers].[customer].[segment_type] (nolock)

insert into [auto_stg_customers].[customer].[segments]
(
		account_id
		,program_id
		,segment_name
		,segment_query
		,query_operator
		,is_deleted
		,created_dt
		,created_by
		,updated_dt
		,updated_by

)

select
		
		_id
		,a.segment_name
		,a.segment_query
		,a.query_operator
		,a.is_deleted
		,a.created_dt
		,a.created_by
		,a.updated_dt
		,a.updated_by
		,a.r2r_dealer_id
		,a.r2r_contact_list_id


from [auto_stg_customers].[customer].[r2r_segments_del] (nolock) a
inner join [auto_stg_portal].[portal].[accounts] (nolock) b  on a.r2r_dealer_id = b.account_id

select * from [auto_stg_customers].[customer].[r2r_customers_del] (nolock) 

inner join [auto_stg_portal].[dbo].[Users] (nolock) c on 


use auto_stg_portal
select * from [auto_stg_portal].[portal].[accounts] (nolock)
select * from [auto_stg_portal].[dbo].[Users] (nolock)

use auto_stg_customers
select * from customer.customers (nolock) where list_ids is not null


use [auto_stg_campaigns]
select * from [social].[social] (nolock) where dealer_id in (4289,4291,4290)
select  * from [dbo].[r2r_social_social_del] (nolock) where dealer_id in (48490, 48630, 48629, 48428)
use auto_stg_campaigns
go

update a set

a.r2r_social_id = b.social_id

from social.social a (nolock)
inner join [dbo].[r2r_social_social_del] b (nolock)  
on a.page_name = b.page_name 
and a.is_deleted = b.is_deleted 
and a.access_token =b.access_token 
and a.social_type_id =b.type_social_id
and a.page_id =b.page_id

 where b.dealer_id in (48490, 48630, 48629, 48428)


insert into [social].[social] 
(
dealer_id
,account_id
,social_type_id
,page_name
,page_id
,access_token
,acess_token_secret
,refresh_token
,token_updated_dt
,last_sync_date
,is_sync
,is_deleted
,created_dt
,created_by
,updated_dt
,updated_by
,last_token_updated_dt
,is_at_invalid
,last_renewal_mail_sent_dt


)

select 
	b.account_id as dealer_id
	,b._id as account_id --
	,(case  when  a.type_social_id =1 then 1 
			when  a.type_social_id =2 then 2
			when  a.type_social_id =3 then 3
			when  a.type_social_id =4 then 5
		end ) 	as social_type_id
	,a.page_name 
	,a.page_id
	,a.access_token
	,a.acess_token_secret
	,null as refresh_token
	,getdate() as token_update_dt-- column not in r2r social
	,getdate() as last_sink_date-- column not in r2r social
	,0 as is_sync
	,a.is_deleted
	,a.created_dt
	,a.created_by
	,a.updated_dt
	,a.updated_by
	,a.last_token_updated_dt
	,a.is_at_invalid
	,a.last_renewal_mail_sent_dt
from [dbo].[r2r_social_social_del] a (nolock)  
inner join portal.account b (nolock)  on a.dealer_id =b.r2r_source_id
where a.dealer_id in (48490, 48630, 48629, 48428)

select * from social.social_type (nolock)


-------------------------------

use clictell_auto_master


select top 10 * from master.campaign_items (nolock) where parent_dealer_id =1806
select top 10 * from [master].[campaign_responses] (nolock) where parent_dealer_id =1806
select top 10 * from master.campaign_items_new (nolock) where parent_dealer_id =1806
select top 10 * from [master].[campaign_responce] (nolock) where parent_dealer_id =1806

select * from [auto_campaigns].[email].[campaigns] (nolock) where campaign_id  = 1439


select a.*
from 
master.campaign_items a (nolock) 
inner join [master].[campaign_responses] b (nolock)  on a.parent_dealer_id =b.parent_dealer_id and a.campaign_id =b.campaign_id
where b.campaign_id =116 
and b.media_type = 'Email'


use auto_campaigns

select a.* from account.programs a (nolock) 
inner join clictell_auto_master.master.dealer b (nolock) on a.account_id = b._id
where b.parent_dealer_id =1806

select top 3 * from email.campaign_items (nolock) 
select top 3 * from [campaign].[campaign_type ] (nolock) 
select top 3 * from campaign.reports(nolock) 
select top 3 * from campaign.schedule_type(nolock)
select top 3 * from campaign.counts (nolock) 
use clictell_auto_master
select * from master.dealer (nolock) where _id  ='7113589E-B6E0-11EB-82D4-0A4357799CFA'

use auto_customers
GO

IF OBJECT_ID('tempdb..#temp_seg') IS NOT NULL DROP TABLE #temp_seg 
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp 

select top 10 * from customer.segments (nolock) where r2r_contactlist_id =13354 order by segment_id


select r2r_contactlist_id, count(*) as cc /*into #temp_seg*/ from customer.segments (nolock) where r2r_contactlist_id is not null and is_deleted =0
group by r2r_contactlist_id having count(*) >1

select * from #temp_seg



select *, rank() over (partition by r2r_contactlist_id order by segment_id desc ) as rnk into #temp from customer.segments (nolock) 
where r2r_contactlist_id in 
(
select r2r_contactlist_id from #temp_seg
) order by r2r_contactlist_id

update a set is_deleted =1
from #temp t 
inner join customer.segments a (nolock) on t.segment_id = a.segment_id and t.r2r_contactlist_id = a.r2r_contactlist_id
where rnk <> 1

select * from customer.segments a (nolock) where r2r_contactlist_id is not null and is_deleted =0

select * from #temp where rnk <> 1



select * from list.lists (nolock) where r2r_custsegment_id is not null order by r2r_custsegment_id

IF OBJECT_ID('tempdb..#temp_li') IS NOT NULL DROP TABLE #temp_li

select r2r_custsegment_id, count(*) as cc into #temp_lists from list.lists (nolock) group by r2r_custsegment_id having count(*) > 1

select *, rank() over (partition by r2r_custsegment_id order by list_id) as rnk into #temp_li from list.lists (nolock)  where r2r_custsegment_id in
(
select r2r_custsegment_id from #temp_lists

)

select a.*,b.rnk from list.lists a (nolock)
inner join #temp_li b on a.r2r_custsegment_id = b.r2r_custsegment_id and a.list_id =b.list_id
where rnk <> 1

update a set is_deleted =1
from list.lists a (nolock)
inner join #temp_li b on a.r2r_custsegment_id = b.r2r_custsegment_id and a.list_id =b.list_id
where rnk <> 1


;
-------------------------------------------

select 
a.campaign_item_id
from [18.216.140.206].[r2r_cm].[sms].[campaign_item] a with (nolock)
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign_media] b with (nolock) on a.campaign_media_id = b.campaign_media_id
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign] e with (nolock) on b.campaign_id = e.campaign_id
where e.dealer_id in (5202, 19204, 21827)

use r2r_admin
select * from portal.dealer with (nolock) where dealer_name like 'Black%'
dealer_id 2999
r2r_dealer_id 10149


use auto_campaigns
drop table #temp_r2r

select count(campaign_item_id) from sms.campaign_item a with (nolock) 
inner join [campaign].[campaign_media] b with (nolock) on a.campaign_media_id = b.campaign_media_id

where b.campaign_id = 76070

select count(r2r_campaignitem_id) 
from [auto_campaigns].[sms].[campaign_items] a with (nolock) 
inner join [auto_campaigns].sms.campaigns b with (nolock) on a.campaign_id = b.campaign_id
where r2r_campaignitem_id is not null and campaign_id = 11083
select * from auto_campaigns.sms.campaigns with (nolock) where r2r_campaign_id =76070 and is_deleted =0

------------------------------------------------------------

---- Extract campaign count from r2r server
select 
		 e.campaign_id
		 ,e.name
		 , count(a.campaign_item_id) as count_camp_item --count(*)
 into #temp_r2r
from [18.216.140.206].[r2r_cm].[sms].[campaign_item] a with (nolock)
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign_media] b with (nolock) on a.campaign_media_id = b.campaign_media_id
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign] e with (nolock) on b.campaign_id = e.campaign_id
where e.dealer_id = 2999 and e.is_deleted =0 and b.is_deleted=0 and a.is_deleted=0
group by e.name,e.campaign_id


--Extracting campaign count from clicmotion server
select 
		accountname
		,name as campaign_name
		,count(campaign_item_id) as count_camp_items

into #temp_clic
from auto_campaigns.portal.account a with (nolock) 
	inner join auto_campaigns.sms.campaigns b with (nolock) on a._id = b.account_id
	inner join auto_campaigns.sms.campaign_items c with (nolock) on b.campaign_id = c.campaign_id
where a.r2r_dealer_id =2999 and a.accountstatus ='active' and b.is_deleted=0 and c.is_deleted=0
group by accountname,name


--- count difference between r2r and clicmotion site SMS campaigns 
select a.name,a.count_camp_item - b.count_camp_items
from #temp_r2r a inner join #temp_clic b on a.name =b.campaign_name

------------------------------------------------------------------------------
--Find missing campaign items fron r2r
select 
		 e.campaign_id
		 ,e.name
		 , a.campaign_item_id--count(*)
	into #r2r
from [18.216.140.206].[r2r_cm].[sms].[campaign_item] a with (nolock)
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign_media] b with (nolock) on a.campaign_media_id = b.campaign_media_id
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign] e with (nolock) on b.campaign_id = e.campaign_id
where e.dealer_id = 2999 and e.is_deleted =0 and b.is_deleted=0 and a.is_deleted=0 and e.is_deleted =0

select 
		accountname
		,name as campaign_name
		,r2r_campaignitem_id

	into #clic
from auto_campaigns.portal.account a with (nolock) 
	inner join auto_campaigns.sms.campaigns b with (nolock) on a._id = b.account_id
	inner join auto_campaigns.sms.campaign_items c with (nolock) on b.campaign_id = c.campaign_id
where a.r2r_dealer_id =2999 and a.accountstatus ='active' and b.is_deleted=0 and c.is_deleted=0

select * 
	into #missing
from #r2r a left outer join #clic b on a.campaign_item_id =b.r2r_campaignitem_id
order by a.campaign_id


select * from #missing where r2r_campaignitem_id is null





select * from #r2r
select * from #clic
select top 10 * from [auto_campaigns].sms.campaigns b with (nolock)
select top 10 * from auto_campaigns.portal.account a with (nolock) 


use auto_campaigns
-- select 269264 - 269201

select count(*)
from [18.216.140.206].[r2r_cm].[sms].[campaign_item] a with (nolock)
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign_media] b with (nolock) on a.campaign_media_id = b.campaign_media_id
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign] e with (nolock) on b.campaign_id = e.campaign_id
inner join sms.campaigns c with (nolock) on e.campaign_id = c.r2r_campaign_id
inner join auto_customers.customer.customers d with (nolock) on a.list_member_id = d.r2r_customer_id
--left outer join sms.campaign_items f with (nolock) on a.campaign_item_id = f.r2r_campaignitem_id
where 
		e.dealer_id in (2999) --(5202, 19204, 21827) 
		--and  d.is_deleted = 0
		--f.campaign_id is null and
		and campaign_item_id in (56805496
,56822104
,57096791
,57121796
,57020500
,56817309
,56800588
,56809688
,56884161
,57077700
,57173474
,57672578
,56804200
,57033237
,56818216
,56820811
,56809778
,56893267
,56820900
,56804386
,56809287
,56821110
,56804412
,57143171
,56819740
,56818724
,56809990
,56808614
,57042649
,56804919
,57055397
,56969556
,56806166
,56960448
,57161196
,57244080
,56810497
,56809743
,56820865
,56804165
,57480756
,57201322
,57109046
,57514245
,56802019
,56803709
,56803036
,56807597
,56807088
,56801510
,56809964
,56911986
,56820410
,56810987
,56821085
,57182893
,56805650
,56924405
,56873910
,57225638
,56804110
,57653098
,56821614
)
order by a.created_dt


select * from auto_customers.customer.customers d with (nolock) 




from [18.216.140.206].[r2r_admin].[owner].[owner] a with (nolock)
inner join auto_portal.portal.account b (nolock) on a.dealer_id = b.r2r_dealer_id
left outer join customer.customers c (nolock) on a.owner_id = c.r2r_customer_id
where a.dealer_id in (5202, 19204, 21827) and c.customer_id is null
order by owner_id



select * from [18.216.140.206].[r2r_cm].[social].[social] with (nolock) where page_name = 'Smoky Mountain Harley-Davidson'
where dealer_id in (select r2r_dealer_id from [portal].[account] with (nolock) where accountstatus = 'active'  and r2r_dealer_id is not null)
group by 
--where page_name = 'Antelope Valley H-D'
select * from [social].[social] a (nolock) where r2r_social_id is not null and page_name ='Smoky Mountain Harley-Davidson'
page_name = 'Antelope Valley H-D'



select * from [18.216.140.206].[r2r_cm].[social].[social] with (nolock) where page_name = 'Smoky Mountain Harley-Davidson'
select * from [social].[social] a (nolock) where r2r_social_id is not null and page_name ='Smoky Mountain Harley-Davidson'

Husqvarna Motorcycles USA

select * from [18.216.140.206].[r2r_cm].[social].[social] with (nolock) where page_name = 'Husqvarna Motorcycles USA'
select * from [social].[social] a (nolock) where r2r_social_id is not null and page_name ='Husqvarna Motorcycles USA'
select account_id from [portal].[account] with (nolock) where accountstatus = 'active'and r2r_dealer_id =19204

--select * from [portal].[account] with (nolock) where accountstatus = 'active'  and r2r_dealer_id is not null
Last Minute Run

select * from [18.216.140.206].[r2r_cm].[social].[social] with (nolock) where page_name = 'Last Minute Run'
select * from [social].[social] a (nolock) where r2r_social_id is not null and page_name ='Last Minute Run'
select account_id from [portal].[account] with (nolock) where accountstatus = 'active'and r2r_dealer_id =37429

update [social].[social] set r2r_social_id =2875 where page_name ='Last Minute Run' and dealer_id =4400 and r2r_social_id is not null

Antelope Valley Harley Davidson

select * from [18.216.140.206].[r2r_cm].[social].[social] with (nolock) where page_name = 'Antelope Valley Harley Davidson'
select * from [social].[social] a (nolock) where r2r_social_id is not null and page_name ='Antelope Valley Harley Davidson'
select account_id from [portal].[account] with (nolock) where accountstatus = 'active'and r2r_dealer_id =2992

update [social].[social] set r2r_social_id =4101 where page_name ='Antelope Valley Harley Davidson' and dealer_id =4330 and r2r_social_id is not null

City Chevrolet

select * from [18.216.140.206].[r2r_cm].[social].[social] with (nolock) where page_name = 'City Chevrolet'
select * from [social].[social] a (nolock) where r2r_social_id is not null and page_name ='City Chevrolet'
select account_id from [portal].[account] with (nolock) where accountstatus = 'active'and r2r_dealer_id =2992
select r2r_dealer_id from [portal].[account] with (nolock) where accountstatus = 'active'and account_id =4377

update [social].[social] set r2r_social_id =4115 where page_name ='City Chevrolet' and dealer_id =4377 and r2r_social_id is not null

Cleo Pharmacy

select * from [18.216.140.206].[r2r_cm].[social].[social] with (nolock) where page_name = 'Cleo Pharmacy'
select * from [social].[social] a (nolock) where r2r_social_id is not null and page_name ='Cleo Pharmacy'
select account_id from [portal].[account] with (nolock) where accountstatus = 'active'and r2r_dealer_id =2992
select r2r_dealer_id from [portal].[account] with (nolock) where accountstatus = 'active'and account_id =4377

update [social].[social] set r2r_social_id =4105 where page_name ='Cleo Pharmacy' and dealer_id =4377 and r2r_social_id is not null


Cleoskinclinic

select * from [18.216.140.206].[r2r_cm].[social].[social] with (nolock) where page_name = 'Cleoskinclinic'
select * from [social].[social] a (nolock) where r2r_social_id is not null and page_name ='Cleoskinclinic'
select account_id from [portal].[account] with (nolock) where accountstatus = 'active'and r2r_dealer_id =2992
select r2r_dealer_id from [portal].[account] with (nolock) where accountstatus = 'active'and account_id =4377

update [social].[social] set r2r_social_id =4112 where page_name ='Cleoskinclinic' and dealer_id =4377 and r2r_social_id is not null


Contact Point Marketing

select * from [18.216.140.206].[r2r_cm].[social].[social] with (nolock) where page_name = 'Contact Point Marketing'
select * from [social].[social] a (nolock) where r2r_social_id is not null and page_name ='Contact Point Marketing'
select account_id from [portal].[account] with (nolock) where accountstatus = 'active'and r2r_dealer_id =2992
select r2r_dealer_id from [portal].[account] with (nolock) where accountstatus = 'active'and account_id =4377

update [social].[social] set r2r_social_id =4116 where page_name ='Contact Point Marketing' and dealer_id =4377 and r2r_social_id is not null


--update a set a.r2r_social_id = b.social_id
--from [social].[social] a with (nolock)
--inner join [18.216.140.206].[r2r_cm].[social].[social] b with (nolock) on a.page_name = b.page_name and a.access_token =b.access_token --and a.is_deleted = b.is_deleted
--inner join [portal].[account] c with (nolock) on b.dealer_id = c.r2r_dealer_id and c.account_id =a.dealer_id
--where a.r2r_social_id is not null and c.accountstatus ='active'

select * from [18.216.140.206].[r2r_cm].[social].[social] with (nolock) where page_name = 'Smoky Mountain Harley-Davidson'
select * from [social].[social] a (nolock) where r2r_social_id is not null and page_name ='Smoky Mountain Harley-Davidson'
select * from [social].[social] a (nolock) where r2r_social_id is not null order by r2r_social_id

;

drop table #r2r
drop table #clic
----------------------------------------------------------------------------------------------------
use auto_campaigns
select e.dealer_id,name,count(campaign_item_id) as ecamp_items
into #r2r
from [18.216.140.206].[r2r_cm].[email].[campaign_item] a with (nolock)
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign_media] b with (nolock) on a.campaign_media_id = b.campaign_media_id
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign] e with (nolock) on b.campaign_id = e.campaign_id
where 
e.dealer_id in
(select r2r_dealer_id from [portal].[account] with (nolock) where lower(accountstatus) = 'active' and r2r_dealer_id is not null) 
group by  e.dealer_id,name


select c.r2r_dealer_id,c.account_id,name,count(distinct a.campaign_item_id) as email_camp_items
into #clic
from email.campaign_items a (nolock) 
inner join email.campaigns b (nolock) on a.campaign_id =b.campaign_id 
inner join portal.account c with (nolock) on b.account_id = c._id and c.accountstatus ='active'
where b.r2r_campaign_id is not null 
and c.account_id in 
(select account_id from [portal].[account] with (nolock) where accountstatus = 'active' and r2r_dealer_id is not null) 
group by c.r2r_dealer_id,c.account_id,name




select a.dealer_id,a.name,b.name, a.ecamp_items, b.email_camp_items ,a.ecamp_items-isnull(b.email_camp_items,0) as diff
from #r2r a 
left outer join #clic b 
on a.dealer_id = b.r2r_dealer_id 
	and a.name = b.name 0
where b.name like '%Clone Of Clone Of Events%'
order by dealer_id,a.name

select count(distinct r2r_dealer_id) from #clic
select * from #r2r where dealer_id = 3001 order by name
select * from #clic where r2r_dealer_id  =3001
select * from email.campaigns b (nolock) where r2r_campaign_id =3001


---------------------------------------------------------------
use auto_media
GO
select a.*
from [18.216.140.206].[r2r_cm].template.template a (nolock)
inner join auto_portal.[portal].[account] b with (nolock) on a.dealer_id = b.r2r_dealer_id
left outer join [template].[templates] c with (nolock) on a.template_id = c.r2r_template_id
where a.dealer_id in (5202, 19204, 21827) and c.template_id is null


use auto_media
GO

select * from [18.216.140.206].[r2r_cm].template.template a (nolock) where dealer_id in 
(select r2r_dealer_id from [portal].[account] with (nolock) where accountstatus = 'active' and r2r_dealer_id is not null) 
order by template_id


select r2r_template_id, count(*) from [template].[templates] a (nolock) 
--inner join [portal].[account] b with (nolock) on a.account_id = b._id
where a.account_id in 
(select _id from [portal].[account] with (nolock) where accountstatus = 'active' and r2r_dealer_id is not null) 
group by r2r_template_id

select * from [portal].[account] with (nolock) where accountstatus = 'active' and r2r_dealer_id is not null

select  
		b.r2r_dealer_id
		,b.account_id
		,b.accountstatus
		,b.accountname
		,a.account_id
		,count(r2r_template_id) as cc
		,count(distinct r2r_template_id) as dist_cc
		,count(r2r_template_id)- count(distinct r2r_template_id) as diff

from [template].[templates] a (nolock) 
inner join portal.account b with (nolock) 
		on lower(a.account_id) = lower(b._id) 
			and r2r_dealer_id is not null 
			and lower(b.accountstatus) = 'active'
where r2r_template_id is not null 
		and lower(b.accountstatus) = 'active'
group by b.r2r_dealer_id,b.account_id,b.accountstatus,b.accountname,a.account_id 
 
---------------------Deleting Duplicates in template.template

----creating row_number() for distict account_id and  r2r_template_id into #temp_templates table
 select 
		 *
		 ,row_number() over (partition by account_id,r2r_template_id order by template_id desc) as rnk 
	into #temp_templates
 from [template].[templates] a (nolock)
 where r2r_template_id is not null order by account_id,r2r_template_id
 
 --checking for duplicates
 select * from #temp_templates where rnk = 1 --101
 select * from #temp_templates where rnk <> 1 --13
 ---deleting duplicate entries using #temp_templates
delete from [template].[templates] where template_id in (select template_id from #temp_templates where rnk <> 1) and r2r_template_id is not null

 -------------------------------------------------------------------
select count(*)
from [18.216.140.206].[r2r_cm].template.template a with (nolock)
inner join portal.account b with (nolock) on a.dealer_id = b.r2r_dealer_id
left outer join [template].[templates] c with (nolock) on a.template_id = c.r2r_template_id 
where --a.dealer_id in (select r2r_dealer_id from [portal].[account] with (nolock) where lower(accountstatus) = 'active' and r2r_dealer_id is not null) 
	--and 
	c.template_id is not null
	and b.r2r_dealer_id is not null 
	and lower(b.accountstatus) = 'active'

select 2346-101 = 2245 --should be loaded
2261 are loading
 select count(*) from [18.216.140.206].[r2r_cm].template.template a (nolock) 
 where dealer_id in (select r2r_dealer_id from [portal].[account] with (nolock) where lower(accountstatus) = 'active' and r2r_dealer_id is not null)

 select distinct r2r_dealer_id from portal.account with (nolock) where r2r_dealer_id is not null and lower(accountstatus) ='active'
 select distinct dealer_id from [18.216.140.206].[r2r_cm].template.template a with (nolock)


 select count(*)
 from  [18.216.140.206].[r2r_cm].template.template a with (nolock) 
 inner join portal.account b with (nolock) on a.dealer_id = b.r2r_dealer_id and lower(b.accountstatus) = 'active'



  select 
			b.r2r_dealer_id
			,b.accountname
			,count(r2r_template_id) as cc
			,count(distinct r2r_template_id) as dist_cc
			,count(r2r_template_id) - count(distinct r2r_template_id) as diff
  from [template].[templates] a (nolock)
  inner join portal.account b with (nolock) on lower(a.account_id) = lower(b._id)
  where 
		r2r_template_id is not null 
		and lower(b.accountstatus) = 'active'
  group by b.r2r_dealer_id,b.accountname
  order by r2r_dealer_id

  select 
			b.r2r_dealer_id
			,b.accountname
			,count(a.template_id) as cc_valid_delaer
 from  [18.216.140.206].[r2r_cm].template.template a with (nolock) 
 inner join portal.account b with (nolock) on a.dealer_id = b.r2r_dealer_id 
 where 
		lower(b.accountstatus) = 'active'
 group by b.r2r_dealer_id,b.accountname
 order by r2r_dealer_id

 select 
		dealer_id
		,count(a.template_id) as cc_actual
 from  [18.216.140.206].[r2r_cm].template.template a with (nolock) 
 group by dealer_id
 order by dealer_id

 ------*******
 select 
			b.r2r_dealer_id
			,b.accountname
			,a.*
from [template].[templates] a (nolock)
  inner join portal.account b with (nolock) on lower(a.account_id) = lower(b._id)
  where 
		r2r_template_id is not null 
		and lower(b.accountstatus) = 'active'
		and r2r_dealer_id =3001
  order by r2r_dealer_id

  select 
			b.r2r_dealer_id
			,b.accountname
			,a.*
 from  [18.216.140.206].[r2r_cm].template.template a with (nolock) 
 inner join portal.account b with (nolock) on a.dealer_id = b.r2r_dealer_id 
 where 
		lower(b.accountstatus) = 'active' and r2r_dealer_id =3001
 order by r2r_dealer_id

 select 
		a.dealer_id
		,a.*
 from  [18.216.140.206].[r2r_cm].template.template a with (nolock) 
 where dealer_id = 3001
 order by a.dealer_id

 ------------------------_______


 select a.dealer_id, b.accountname, c.account_id, a.template_id,c.r2r_template_id
	into #tmep
 from  [template].[templates] c (nolock) 
 inner join portal.account b with (nolock) on lower(c.account_id) = lower(b._id)
left outer join [18.216.140.206].[r2r_cm].template.template a with (nolock) on a.dealer_id = b.r2r_dealer_id and a.template_id = c.r2r_template_id
where b.r2r_dealer_id is not null

select distinct r2r_template_id from #tmep where template_id is null

------------------------------------


use auto_media
go

select count(*) from [auto_media].[media].[images] c with (nolock) 
inner join auto_portal.[portal].[account]b with (nolock) on c.account_id = b._id
where r2r_image_id is not null and lower(b.accountstatus) = 'active'


select c.*,b.accountname

from [auto_media].[media].[images] c with (nolock) 
inner join auto_portal.[portal].[account] b with (nolock) on c.account_id = b._id
where r2r_image_id is not null 

and lower(b.accountstatus) = 'active'
group by b.account_id,b.accountname,r2r_image_id 
having count(*) >1
order by b.account_id,r2r_image_id 

-----------------DELETING DUPLICATE ROWS FROM media.images-----------------
select 
		r2r_image_id
		, count(*) as cc  
from [auto_media].[media].[images] c with (nolock) 

where r2r_image_id is not null
group by r2r_image_id 
having count(*) > 1 -- 362 duplicates


--select 
--		count(*)  
--from [auto_media].[media].[images] c with (nolock) 
--inner join auto_portal.[portal].[account] b with (nolock) on c.account_id = b._id
--where r2r_image_id is not null and lower(b.accountstatus) = 'active'



drop table #dupe_del_images

select 
		c.*
		, row_number() over (partition by account_id,r2r_image_id order by image_id) as rnk
	into #dupe_del_images
from [auto_media].[media].[images] c with (nolock) 
where r2r_image_id is not null 


select * from #dupe_del_images where rnk  = 1 --523
select * from #dupe_del_images where rnk  <> 1 --390
select count(*) from [auto_media].[media].[images] c with (nolock) where r2r_image_id is not null --913

--delete from    [auto_media].[media].[images]  where image_id in (select image_id from #dupe_del_images where rnk <> 1) and r2r_image_id is not null


-----------------******************
select * 
from [auto_media].[media].[images] a with (nolock)  
inner join auto_portal.portal.account b with (nolock) on a.account_id = b._id
where a.r2r_image_id = 6556
	



select count(*) from 
[18.216.140.206].[r2r_cm].[media].[digital_media] a with (nolock)
inner join auto_portal.[portal].[account]b with (nolock) on a.dealer_id = b.r2r_dealer_id
where lower(b.accountstatus) = 'active'

left outer join [auto_media].[media].[images] c with (nolock) on a.digital_media_id = c.r2r_image_id
where b.r2r_dealer_id is not null 
		and image_id is null

Use auto_media
GO
select *
from [18.216.140.206].[r2r_cm].[media].[landing_page] a with (nolock)
inner join auto_portal.[portal].[account] b with (nolock) on a.dealer_id = b.r2r_dealer_id
left outer join [media].[landing_pages] c with (nolock) on a.landing_page_id = c.r2r_landingpage_id
where lower(b.accountstatus) = 'active' and c.landing_page_id is null  --133


select * from [media].[landing_pages] (nolock) where r2r_landingpage_id is not null  --12
order by r2r_landingpage_id

select r2r_landingpage_id, count(*) from [media].[landing_pages] (nolock) where r2r_landingpage_id is not null group by r2r_landingpage_id having count(*) > 1

select count(*)
from [18.216.140.206].[r2r_cm].[media].[landing_page] a with (nolock)
inner join auto_portal.[portal].[account] b with (nolock) on a.dealer_id = b.r2r_dealer_id
where lower(b.accountstatus) = 'active' --145



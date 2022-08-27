use auto_campaigns
go
select c.r2r_dealer_id, c.account_id,   count(distinct a.r2r_campaignitem_id), count(*)
from email.campaign_items a (nolock)
inner join email.campaigns b (nolock) on a.campaign_id = b.campaign_id
inner join [PostgreSQL_Clictell].[clictell].[public].[account] c with (nolock) on lower(b.account_id) = lower(c._id)
where c.r2r_dealer_id in ('2987', '2988', '2989', '2992', '2993', '2994', '2995', '2996', '2997', '2998', '2999', '3000', '3001', '4755', '5572', '16618', '48054', '48253', '48254', '48255', '48570'
, '48606', '48607', '48608', '48636', '48640', '48641', '48652', '48654', '48657', '48663', '48664', '48665', '48685', '48686', '48689', '48690', '48691', '48714', '48715', '48716', '48750', '48751'
, '48752', '48753', '48755', '48766', '48767', '48768', '48776', '48778', '48806', '48811', '48816', '48826', '48829', '48853', '48859', '48870', '48873', '48874', '48878', '48879', '48880', '48883'
, '48884', '48887', '48888', '48905', '48906', '48907', '48909', '48911', '37429'
)
and a.r2r_campaignitem_id is not null and c.accountstatus = 'inactive'
group by c.r2r_dealer_id, c.account_id
order by 1

 

 

select * from email.campaign_items (nolock) where campaign_item_id in (
--delete from email.campaign_items where campaign_item_id in (
select distinct a.campaign_item_id
from email.campaign_items a (nolock)
inner join email.campaigns b (nolock) on a.campaign_id = b.campaign_id
inner join [PostgreSQL_Clictell].[clictell].[public].[account] c with (nolock) on lower(b.account_id) = lower(c._id)
where c.account_id = 4421 and a.r2r_campaignitem_id is not null )

 

 

 

select * from [PostgreSQL_Clictell].[clictell].[public].[account] with (nolock) where account_id in (4418)
use [auto_stg_campaigns]
go

Insert into social.campaign_items
(
         social_type_id
       , social_id
       , campaign_id
       , post_id
       , access_token
       , page_id
       , body
       , link_url
       , image_url
       , video_url
       , is_link
       , is_image
       , is_video
       , is_posted
       , scheduled_time
       , status_id
       , is_deleted
       , created_dt
       , created_by
       , updated_dt
       , updated_by
       , is_post_deleted
       , likes
       , comments
       , shares
       , status
       , flow_id
       , is_internal_notification
       , r2r_campaignitem_id
)

select

        (Case when a.type_social_id = 1 then 1
                when a.type_social_id = 2 then 2
                when a.type_social_id = 3 then 3
                when a.type_social_id = 4 then 5
             end ) as social_type_id
		,f.social_id
       , c.campaign_id
       , a.post_id
       , a.access_token
       , a.page_id
       , a.body
       , a.link_url
       , a.image_url
       , a.video_url
       , a.is_link
       , a.is_image
       , a.is_video
       , a.is_posted
       , a.created_dt as scheduled_time
       , 1 as status_id -- need to check the column
       , a.is_deleted
       , a.created_dt
       , a.created_by
       , a.updated_dt
       , a.updated_by
       , a.is_post_deleted
       , null as likes
       , null as comments
       , null as shares
       , a.status
       ,a.flow_id
       , 0 as is_internal_notification -- not null constraint so '0' as default
       , a.campaign_item_id
--into #tem_socialcampaign_items
from [18.216.140.206].[r2r_cm].[social].[campaign_item] a
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign_media] b on a.campaign_media_id = b.campaign_media_id
inner join [18.216.140.206].[r2r_cm].[campaign].[campaign] e on b.campaign_id = e.campaign_id
inner join social.campaigns c on e.campaign_id = c.r2r_campaign_id
inner join social.social f (nolock) on a.social_id =f.r2r_social_id
left outer join social.campaign_items g (nolock) on a.campaign_item_id = g.r2r_campaignitem_id and c.campaign_id = g.campaign_id
--inner join auto_stg_customers.customer.customers d on a.list_member_id = d.r2r_customer_id
where e.dealer_id in (select r2r_dealer_id from auto_portal.portal.account with (nolock) where r2r_dealer_id is not null and lower(accountstatus) = 'active')
--where e.dealer_id in (48625, 2990, 2991) 
and g.campaign_item_id is null
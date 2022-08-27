USE [r2r_admin]
GO
/****** Object:  StoredProcedure [template].[get_templates]    Script Date: 10/22/2021 12:25:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [template].[get_templates]  
	@type varchar(30) = null,
	@dealer_id int = null
	  
AS        
      
/*
	 exec [template].[get_templates] 'Event',4035
	 exec [template].[get_templates] 'SMS',46053
	 exec [template].[get_templates] 'Email',4035
	 exec [template].[get_templates] 'Push',2936
	 exec [template].[get_templates] 'social',46053
	 exec [template].[get_templates] 'promotions',4035

	 select * from event.events

	 ------------------------------------------------------------         
	 PURPOSE        
	 Get Event By Id
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date           Author     Work Tracker Id     Description          
	 -----------------------------------------------------------        
	 10/05/2017     Warrous                           Created
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/        
BEGIN 


	IF(@type = 'event')
	BEGIN
		SELECT
			ev.event_id,
			ev.event_guid,
			ev.event_name,
			ev.event_title,
			ev.event_image_path,
			ev.start_date,
			ev.start_time,
			ev.exp_date,
			ev.end_time,
			ev.created_dt,
			ev.event_description,
			ev.street,
			ev.city,
			ev.zip_code,
			ev.state
		FROM
			event.events ev with(nolock,readuncommitted)
		WHERE
			ev.dealer_id = @dealer_id
			and ev.is_deleted = 0
			and ev.is_template = 1
		order by 
			created_dt desc
	END	

	IF(@type = 'promotions')
	BEGIN
		SELECT
			pm.promotion_id,
			pm.promotion_guid,
			pm.title,
			pm.description,
			pm.promo_code,
			pm.footer_description,
			pm.promotion_image_path,
			pm.promo_url,
			pm.created_dt
		FROM
			event.promotions pm with(nolock,readuncommitted)
		WHERE
			pm.dealer_id = @dealer_id
			and pm.is_deleted = 0
			and pm.is_template = 1
		order by 
			created_dt desc
	END	

	IF(@type = 'email' or @type = 'sms' or @type ='push' or @type ='social')
	BEGIN
		SELECT
			cp.campaign_id,
			cp.campaign_guid,
			cp.media_type,
			cp.name,
			cp.created_dt,
			cm.html_content,
			 --case when @type<>'Email' then cm.html_content end as
			cm.img_url,
			cp.from_name,
			cp.from_email,
			cp.target_audience,
			cp.schedule_options,
			cs.subject,
			cs.preview_text,
			cm.push_from,
			cm.action,
			cm.insert_url,
			cm.thumbnail_url,
			cm.total_count,
			ss.page_name,
			cm.is_append_instruction,
			cm.social_type
		FROM
			r2r_cm.campaign.campaign cp with(nolock,readuncommitted)
			INNER JOIN r2r_cm.campaign.campaign_media cm with(nolock,readuncommitted) on
			cm.campaign_id = cp.campaign_id
			LEFT JOIN r2r_cm.campaign.campaign_subject cs with(nolock,readuncommitted) on
			cs.campaign_media_id = cm.campaign_media_id
			LEFT JOIN (select top 1 s.social_id,s.dealer_id,s.page_name from social.social(nolock) s where s.is_deleted = 0 and dealer_id = @dealer_id) ss on
			ss.dealer_id = cp.dealer_id
		WHERE
			cp.dealer_id = @dealer_id
			and cp.is_deleted = 0
			and cp.is_template = 1
			and cp.media_type = @type
		order by 
			created_dt desc
	END	
	

	SET NOCOUNT OFF
END


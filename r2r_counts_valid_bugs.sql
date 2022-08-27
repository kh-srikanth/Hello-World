			select   
				cu.customer_id,
				cu.customer_guid,
				cu.first_name,
				cu.last_name, 
				case when cu.last_name is null or cu.last_name='' then cu.first_name
				when cu.first_name is null or cu.first_name= '' then cu.last_name
				else isnull(cu.first_name, '') + ' ' + isnull(cu.last_name, '') end as full_name,
				--cu.primary_phone_number,
				(Case when Len(Isnull(cu.primary_phone_number, '')) >= 10 then cu.primary_phone_number 
					  when Len(Isnull(cu.secondary_phone_number, '')) >= 10 then cu.secondary_phone_number 
					  else cu.primary_phone_number  end) primary_phone_number,

				cu.company_name,
				cu.address_line,
				cu.city,
				isnull(nullif(cu.country_code,''),'') as country_code,
				cu.county as county,
				cu.primary_email,
				cu.zip,
				case when cu.tags is null or cu.tags = '' then 'No Tags'
				else cu.tags end as tags,
				case when ll.list_name is null or cu.tags = '' then '-'
				else ll.list_name end as list_name,
				cu.do_not_email as do_not_email,
				isnull(cu.is_subscriber, 0) as is_subscriber,
				isnull(cu.do_not_phone, 1) as do_not_phone,
				cu.updated_dt,
				--@total_count as total_count,
				cu.segment_list,
				isnull(cu.created_dt,getdate()) as created_dt,
				isnull(cu.whats_app_status,'not valid') as whats_app_status,
				isnull(cu.whats_app_valid,0) as whats_app_valid,
				cu.lead_status_id,
				ls.status,
				--isnull(vc.vin,'') as vin,
				cu.do_not_sms as 'do_not_sms'
				,primary_phone_number_valid
				,secondary_phone_number_valid
				,r2r_customer_id
		  from
				[customer].[customers] cu with(nolock,readuncommitted)
				left join [list].[lists] ll with(nolock,readuncommitted)
				on cu.list_id = ll.list_id
				left join auto_crm.[lead].[status] ls with(nolock,readuncommitted)
				on cu.lead_status_id = ls.status_id and ls.is_deleted = 0
				--left join customer.vehicles vc with(nolock,readuncommitted)
				--on vc.customer_id=cu.customer_id and vc.is_deleted= 0
		  where  cu.r2r_customer_id = 1286093 and
				cu.account_id in ('A1478891-4F48-4B55-9D64-B5FB5B99B1EF') and
				cu.is_deleted = 0  and 
				(Isnull(cu.primary_email_valid, 0) = 1 or Isnull(cu.primary_phone_number_valid, 0) = 1 or isnull(cu.secondary_phone_number_valid, 0) = 1) and
				list_ids like '%,1609,%'
			
				--(@list_id is null or @list_id IN ( select value from STRING_SPLIT(list_ids, ','))) and
				isnull(cu.is_subscriber, 0) = isnull(@is_subscriber, 0) and
				(@email_opt is null or cu.do_not_email = (case when @email_opt = 1 then 0 else 1 end)) and
				(@sms_opt is null or cu.do_not_sms = (case when @sms_opt = 1 then 0 else 1 end)) and
				(@from_date is null or @from_date = '' or (isDate(cast(@from_date as datetime)) = 1 and cast(@from_date as date) <= cast(cu.created_dt as date))) and
				(@end_date is null or @end_date = '' or (isDate(cast(@end_date as datetime)) = 1 and cast(@end_date as date) >= cast(cu.created_dt as date))) and
				(@search = '' or 
				cu.first_name like '%'+ @search +'%' or 
				cu.first_name + ' ' + cu.last_name like '%'+ @search +'%' or
				cu.last_name like '%'+ @search +'%' or
				cu.primary_email like '%'+ @search +'%' or
				--cu.primary_phone_number like '%'+ @search +'%' or 
				(Case when Len(Isnull(cu.primary_phone_number, '')) >= 10 then cu.primary_phone_number 
					  when Len(Isnull(cu.secondary_phone_number, '')) >= 10 then cu.secondary_phone_number 
					  end) like '%'+ @search +'%' or 
				ls.status = @search) 
				and ls.status = case when (len(trim(@status_filter)) = 0 or @status_filter = 'All') then  ls.status else @status_filter end


				select a.customer_id, a.r2r_customer_id, b.owner_id,a.do_not_sms, b.is_lime_opted_in
				--update a set secondary_phone_number = REPLACE(translate(upper(b.phone),'ABCDEFGHIJKLMNOPQRSTUVWXYZ+-;,.()[]{}* ','@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),'@','') 
				--update a set secondary_phone_number_valid = case when len(secondary_phone_number) >=10 then 1 else 0 end
				from auto_customers.customer.customers a (nolock)
				inner join [18.216.140.206].[r2r_admin].owner.owner b with (nolock) on a.r2r_customer_id = b.owner_id 
				where a.account_id  = 'A1478891-4F48-4B55-9D64-B5FB5B99B1EF' and b.dealer_id = 48884
				and do_not_sms is null
			

				select owner_id from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where contact_list_ids like '%,13559,%' and is_lime_opted_in =1 and is_deleted =0-- 18767
				select * from auto_customers.customer.customers a (nolock) where r2r_customer_id =1286093
				select * from [18.216.140.206].[r2r_admin].owner.owner b with (nolock) where owner_id =1286093
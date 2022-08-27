select * from auto_stg_media.template.templates (nolock) where is_deleted =0 and account_id  = 'feb5347d-2fad-4c1a-acf5-205ddc642ca3'

select * from auto_stg_media.[print].template_formats (nolock)
where template_id in (select template_id from auto_stg_media.template.templates_del (nolock) where is_deleted =0 and account_id  = 'feb5347d-2fad-4c1a-acf5-205ddc642ca3'
and template_name in (select template_name from auto_stg_media.template.templates (nolock) where is_deleted =0 and account_id  = 'feb5347d-2fad-4c1a-acf5-205ddc642ca3')
)
order by template_id,print_format_id

--insert into auto_stg_media.[print].template_formats
--(
--[template_id], 
--[print_format_id], 
--[print_size_id], [front_html_content], [middle_html_content], [back_html_content], [thumbnail_url], [print_format], [print_type], [letter_front_file_name], [letter_back_file_name], [postcard_front_file_name], [postcard_back_file_name], [trifold_front_file_name], [trifold_back_file_name], [bifold_front_file_name], [bifold_back_file_name], [is_deleted], [created_by], [created_dt], [updated_by], [updated_dt]

--)

select 
(case	when [template_id] = 7937 then 3930
		when [template_id] = 8159 then 3931 
		when [template_id] = 8507 then 3932 
		when [template_id] = 8570 then 3933 
		when [template_id] = 8633 then 3934 
		when [template_id] = 8634 then 3935 
		when [template_id] = 8635 then 3936 
		when [template_id] = 8636 then 3937 
		when [template_id] = 10252 then 3938 end) as [template_id],
[print_format_id], 

[print_size_id], [front_html_content], [middle_html_content], [back_html_content], [thumbnail_url], [print_format], [print_type], [letter_front_file_name], [letter_back_file_name], [postcard_front_file_name], [postcard_back_file_name], [trifold_front_file_name], [trifold_back_file_name], [bifold_front_file_name], [bifold_back_file_name], [is_deleted], suser_name() as [created_by], getdate() as [created_dt], suser_name() as [updated_by], getdate()  as [updated_dt]
from auto_stg_media.[print].template_formats_del (nolock) where template_id  in (7937,8159,8507,8570,8633,8634,8635,8636,10252)




select template_id,template_name,* from auto_stg_media.template.templates (nolock) where is_deleted =0 and account_id  = 'feb5347d-2fad-4c1a-acf5-205ddc642ca3' and 
template_name in (
'AutoCare Welcome Kit'
,'Mazda Welcome Kit'
,'Lexus Welcome Kit'
,'Toyota Welcome Kit'
,'Toyota Service Reminder'
,'Mazda Service Reminder'
,'AutoCare Service Reminder'
,'Lexus Service Reminder'
,'AutoCare Welcome Kit(ACM)'

)


select * from auto_stg_media.[print].template_formats (nolock) where template_id = 3930

select * from auto_stg_media.template.templates (nolock) where is_deleted =0 and account_id  = 'feb5347d-2fad-4c1a-acf5-205ddc642ca3' and template_id = 3930



----------------------------------**********************
use auto_crm
select * from auto_media.template.templates (nolock) where is_Deleted =0 and account_id  = 'D659F818-D1D1-421D-98AD-6C76CB7CD54B'

select * from auto_media.[print].template_formats (nolock) where is_deleted =0 order by template_id,print_format_id

select * from portal.account with (nolock) where accountname like 'RAPP%'


select template_id,template_name,* from auto_media.template.templates (nolock) where is_Deleted =0 and account_id  = 'D659F818-D1D1-421D-98AD-6C76CB7CD54B' and template_name in 
(
'AutoCare Welcome Kit'
,'Mazda Welcome Kit'
,'Lexus Welcome Kit'
,'Toyota Welcome Kit'
,'Toyota Service Reminder'
,'Mazda Service Reminder'
,'AutoCare Service Reminder'
,'Lexus Service Reminder'
,'AutoCare Welcome Kit(ACM)'
)

----------------------------------*************************************---------------------

select * from [print].template_formats (nolock)

select top 10 * from [print].[campaign_formats] (nolock)

select * from auto_campaigns.[print].[format_sizes] (nolock) where is_Deleted =0--15/13

select * from auto_media.[print].sizes (nolock) where is_Deleted =0 --19/10


select * from auto_stg_campaigns.[print].[format_sizes] (nolock) where is_Deleted =0 order by print_size_id--15/13 order 
select * from auto_stg_campaigns.[print].[format_sizes_del] (nolock) where is_Deleted =0 order by print_size_id--15/13



select * from auto_stg_media.[print].sizes (nolock) where is_Deleted =0 --19/10    12= 11
select * from auto_stg_media.[print].sizes_del a (nolock) where is_Deleted =0 --19/10



insert into auto_stg_media.[print].sizes
(
print_size,width,height,created_dt,created_by,updated_dt,updated_by
)
select 
	a.print_size,a.width,a.height,getdate() as created_dt,suser_name() as created_by,getdate() as updated_dt,suser_name() as updated_by
from auto_stg_media.[print].sizes_del a (nolock)
left outer join auto_stg_media.[print].sizes b (nolock) on a.width = b.width and a.height = b.height --a.print_size = b.print_size
where a.is_Deleted =0 --19/10
and b.print_size_id is null


insert into auto_stg_campaigns.[print].[format_sizes]
(
print_format_id,print_size_id,created_dt,created_by,updated_dt,updated_by
)

select a.print_format_id,a.print_size_id-1,getdate() as created_dt,suser_name() as created_by,getdate() as updated_dt,suser_name() as updated_by
from auto_stg_campaigns.[print].[format_sizes_del] a (nolock)
left outer join auto_stg_campaigns.[print].[format_sizes] b (nolock) on a.print_size_id = b.print_size_id  

where a.is_Deleted =0--15/13
and b.format_size_id is null





select * from 
select print_size_id from auto_stg_media.[print].sizes a (nolock)where print_size_id not in (select distinct print_size_id from  auto_stg_campaigns.[print].[format_sizes] (nolock))




select * from auto_stg_campaigns.[print].[format_sizes] (nolock) where is_Deleted =0 order by print_size_id--15/13 order 
select * from auto_stg_campaigns.[print].[format_sizes_del] (nolock) where is_Deleted =0 order by print_size_id--15/13



select * from auto_stg_media.[print].sizes (nolock) where is_Deleted =0 --19/10    12= 11
select * from auto_stg_media.[print].sizes_del a (nolock) where is_Deleted =0 --19/10


select * from auto_campaigns.campaign.reports (nolock)
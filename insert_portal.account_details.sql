use clictell_auto_etl
go

select * from [etl].[dt_customer] (nolock)

alter table [etl].[dt_customer]  add parent_dealer_id int
alter table [etl].[dt_customer]  add src_dealer_code varchar(20)

select * from auto_customers.portal.account with (nolock) where accountname like 'Team Nissan'

insert into auto_customers.portal.account
(
accountname
,accountstatus
,accounttype
,address1
,adminname
,city
,country
,createdate
,hostname
,parentid
,parenttype
,phone
,[source]
,[state]
,updatedate
,updatetime
,additionalattributes
,src_dealer_code
,dms_type
,email_address
,zipcode
,timezone
,dealerwebsiteurl
)
select
 'Team Nissan' as accountname
,'Active' as accountstatus
,'Dealer' as accounttype
,'70 Keller Street' as address1
,'Team Nissan' as adminname
,'Manchester' as city
,'US' as country
,getdate() as createdate
,'teamnissannh.clicmotion.com' as hostname
,'17BDE13D-DB6A-486F-9408-E24489F66814' as parentid
,'OEM' as parenttype
,'(888) 387-0064' as phone
,'signup-ui' as [source]
,'NH' as [state]
,getdate() as updatedate
,'12:00' as updatetime
,'{"ContractInfo":{"department":"","person_name":"","phone":"","email_id":""},"salesInfo":{"contactName":"Team Nissan","contactTitle":"Mr","departmentPhone":"8883870064","departmentPhone_Ext":"","tollFreeNumber":"8883870064","departmentEmail":"teamnissannh@yopmail.com","departmentUrl":"www.teamnissannh.com","Department_Hours":[{"Day":"Monday","OpTime":"09:00","OpMer":"AM","CloTime":"07:00","CloMer":"PM"},{"Day":"Tuesday","OpTime":"09:00","OpMer":"AM","CloTime":"07:00","CloMer":"PM"},{"Day":"Wednesday","OpTime":"09:00","OpMer":"AM","CloTime":"07:00","CloMer":"PM"},{"Day":"Thursday","OpTime":"09:00","OpMer":"AM","CloTime":"07:00","CloMer":"PM"},{"Day":"Friday","OpTime":"09:00","OpMer":"AM","CloTime":"07:00","CloMer":"PM"},{"Day":"Saturday","OpTime":":00","OpMer":"AM","CloTime":":00","CloMer":"PM"},{"Day":"Sunday","OpTime":":00","OpMer":"AM","CloTime":":00","CloMer":"PM"}],"additional_Hours":"","physical_Address":{"Address1":"70 Keller Street","Address2":"","City":"Manchester","Country":"US","State":"NH","Zip_Code":"03103"},"mailing_Address":{"Address1":"70 Keller Street","Address2":"","City":"Manchester","Country":"US","State":"NH","Zip_Code":"03103"}},"serviceInfo":{"contactName":"Team Nissan","contactTitle":"Mr","departmentPhone":"8666088546","departmentPhone_Ext":"","tollFreeNumber":"8666088546","departmentEmail":"teamnissannh@yopmail.com","departmentUrl":"www.teamnissannh.com","appointmentUrl":"www.teamnissannh.com","Department_Hours":[{"Day":"Monday","OpTime":"09:00","OpMer":"AM","CloTime":"07:00","CloMer":"PM"},{"Day":"Tuesday","OpTime":"09:00","OpMer":"AM","CloTime":"07:00","CloMer":"PM"},{"Day":"Wednesday","OpTime":"09:00","OpMer":"AM","CloTime":"07:00","CloMer":"PM"},{"Day":"Thursday","OpTime":"09:00","OpMer":"AM","CloTime":"07:00","CloMer":"PM"},{"Day":"Friday","OpTime":"09:00","OpMer":"AM","CloTime":"07:00","CloMer":"PM"},{"Day":"Saturday","OpTime":":00","OpMer":"AM","CloTime":":00","CloMer":"PM"},{"Day":"Sunday","OpTime":":00","OpMer":"AM","CloTime":":00","CloMer":"PM"}],"additional_Hours":"","physical_Address":{"Address1":"70 Keller Street","Address2":"","City":"Manchester","Country":"US","State":"NH","Zip_Code":"03103"},"mailing_Address":{"Address1":"70 Keller Street","Address2":"","City":"Manchester","Country":"US","State":"NH","Zip_Code":"03103"}},"wholeSaleInfo":{"contactName":"Team Nissan","contactTitle":"Mr","departmentPhone":"8773680899","departmentPhone_Ext":"","tollFreeNumber":"8773680899","departmentEmail":"teamnissannh@yopmail.com","departmentUrl":"www.teamnissannh.com","Department_Hours":[{"Day":"Monday","OpTime":"09:00","OpMer":"AM","CloTime":"07:00","CloMer":"PM"},{"Day":"Tuesday","OpTime":"09:00","OpMer":"AM","CloTime":"07:00","CloMer":"PM"},{"Day":"Wednesday","OpTime":"09:00","OpMer":"AM","CloTime":"07:00","CloMer":"PM"},{"Day":"Thursday","OpTime":"09:00","OpMer":"AM","CloTime":"07:00","CloMer":"PM"},{"Day":"Friday","OpTime":"09:00","OpMer":"AM","CloTime":"07:00","CloMer":"PM"},{"Day":"Saturday","OpTime":":00","OpMer":"AM","CloTime":":00","CloMer":"PM"},{"Day":"Sunday","OpTime":":00","OpMer":"AM","CloTime":":00","CloMer":"PM"}],"additional_Hours":"","physical_Address":{"Address1":"70 Keller Street","Address2":"","City":"Manchester","Country":"US","State":"NH","Zip_Code":"03103"},"mailing_Address":{"Address1":"70 Keller Street","Address2":"","City":"Manchester","Country":"US","State":"NH","Zip_Code":"03103"}},"CustomInfo":""}' as additionalattributes
,'Team Nissan' as src_dealer_code
,'Dealer Track' as dms_type
,'teamnissannh@yopmail.com' as email_address
,'3103' as zipcode
,'EST' as timezone
,'www.teamnissannh.com' as dealerwebsiteurl




insert into etl.file_process_details
(
process_id
,file_name
,full_file_path
,process_start_date
,source
)

select 
 289 as process_id
,'Customers_20220804111023.txt' as file_name
,'D:\etl_source\dealer_track\process\Customers_20220804111023.txt' as full_file_path
,getdate() as process_start_date
,'DealerTrack' as source



insert into  etl.etl_config
(
[environemnt]
, [process_file_path]
, [success_file_path]
, [error_file_path]
, [etl_db_conn]
, [stg_db_conn]
, [master_db_conn]
, [source]
)

select 
[environemnt]
, 'D:\etl_process\dealer_track\process' as [process_file_path]
, 'D:\etl_process\dealer_track\success' as [success_file_path]
, 'D:\etl_process\dealer_track\error' as [error_file_path]
, 'Data Source=3.128.227.94;User ID=sa;Password=CnsxtApp1QZ;Initial Catalog=clictell_stg_auto_etl;Persist Security Info=True;Application Name=Auto_etl;' as [etl_db_conn]
, 'Data Source=3.128.227.94;User ID=sa;Password=CnsxtApp1QZ;Initial Catalog=clictell_stg_auto_stg;Persist Security Info=True;Application Name=Auto_stg;' as [stg_db_conn]
, 'Data Source=3.128.227.94;User ID=sa;Password=CnsxtApp1QZ;Initial Catalog=clictell_stg_auto_master;Persist Security Info=True;Application Name=Auto_master;' as [master_db_conn]
, 'DealerTrack' as [source]

from etl.etl_config (nolock)
where etl_config_id = 3


[etl_config_id], 

select * from auto_stg_customers.portal.account with (nolock) where accountname like '%nissa%'

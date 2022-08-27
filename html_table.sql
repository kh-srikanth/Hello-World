use clictell_auto_master
go

DECLARE @xml NVARCHAR(MAX)
DECLARE @body1 NVARCHAR(MAX)

SET @xml = CAST(( 
		select 
				a.src_dealer_code AS 'td','', 
				a.file_process_id AS 'td','', 
				a.file_process_detail_id AS 'td','',
				b.file_name AS 'td','', 
				isnull(b.file_count,0) AS 'td','',
				isnull(insert_count,0) AS 'td','', 
				isnull(update_count,0) AS 'td','', 
				isnull(error_count,0) AS 'td','' ,
				(isnull(insert_count,0)+isnull(update_count,0)+isnull(error_count,0))-isnull(b.file_count,0) as 'td',''
		from [master].[dealer_audit_log] a (nolock) 
				inner join clictell_auto_etl.etl.file_process_details b (nolock) on a.file_process_detail_id = b.file_process_detail_id
		where a.file_process_id = 1337
	FOR XML PATH('tr'), ELEMENTS ) 

AS NVARCHAR(MAX))

--select @xml

SET @body1 ='<html><body><p>Hi Team!</p><p> Plz find the ETL Process Audit report for Automate source</p>
<table border = 1> 
<tr>
<th> Dealer Code </th> <th> File Process ID </th> <th> File Process Detail ID </th> <th> File Name </th> 
<th> File Count </th> <th> Insert Count </th> <th> Update Count </th> <th> Error Count </th> <th> Unaccounted Records </th></tr>' 

declare @ps varchar(max) ='<html><body><p>Regards,</p><p> ETL Team</p>'

SET @body1 = @body1 + @xml +'</table></body></html>'+@ps


select @body1

/*
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'DB Admin Profile',  
    @recipients = 'admin@example.com',  
    @body = @body1,
    @body_format = 'HTML',
    @subject = 'Daily ETL report for ATM';
*/

--select * from clictell_auto_etl.etl.file_process_details (nolock) order by file_process_detail_id desc
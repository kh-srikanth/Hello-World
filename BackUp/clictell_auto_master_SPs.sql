USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [master].[get_notification_for_rapp_backup_20220420_DEL]    Script Date: 5/2/2022 2:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [master].[get_notification_for_rapp_backup_20220420_DEL] 
	  @file_process_id int

AS
/*        

  exec [master].[get_notification_for_rapp] 1825 
  ----------------------------------------------------------------------------        
  MODIFICATIONS        
  Date            Author      Work Tracker Id      Description          
  ----------------------------------------------------------------------------------------------------------------------------       
  3/30/2022       purnachandra                         Created-This procedure is used to get the emails for rapp
  ----------------------------------------------------------------------------------------------------------------------------      
                              Copyright 2021 Warrous Pvt Ltd 
*/        
BEGIN
	
 SET NOCOUNT ON;
	        Declare @xml Nvarchar(max)
			Declare @xml2 Nvarchar(max)
	        Declare @body1 NVarchar(max)
			Declare @body2 NVarchar(max)
			Declare @body NVarchar(max)


 -----------Insert count of [etl].[etl_rapp_customer]  table---------------
	---declare	@file_process_id int =232
         drop table if exists #temp
         select 
		         file_process_id as FileProcessId,
			     file_process_detail_id as FileProcessDetailId,
		         src_dealer_code as DealerCode,
			     parent_dealer_id as ParentDealerId,
		         count(*) as ETLCOUNT
			
		  into #temp
		  from [clictell_auto_etl].[etl].[etl_rapp_customer](nolock)
		  where file_process_id = @file_process_id 
		  group by src_dealer_code,file_process_id,file_process_detail_id,parent_dealer_id 

		  --select * from #temp
		  		
         drop table if exists #t
         select 
		         file_process_id as FileProcessId,
			     file_process_detail_id as FileProcessDetailId,
		         src_dealer_code as DealerCode,
			     parent_dealer_id as ParentDealerId,
				 count(*) as valid_records
		  into #t
		  from [clictell_auto_etl].[etl].[etl_rapp_customer](nolock)
		  where file_process_id = @file_process_id and is_valid_record=1
		  group by src_dealer_code,file_process_id,file_process_detail_id,parent_dealer_id ,is_valid_record
		  
		           drop table if exists #t1
         select 
		         file_process_id as FileProcessId,
			     file_process_detail_id as FileProcessDetailId,
		         src_dealer_code as DealerCode,
			     parent_dealer_id as ParentDealerId,
				 count(*) as Invalid_records
		  into #t1
		  from [clictell_auto_etl].[etl].[etl_rapp_customer](nolock)
		  where file_process_id = @file_process_id and is_valid_record=0
		  group by src_dealer_code,file_process_id,file_process_detail_id,parent_dealer_id ,is_valid_record

		 -- select * from #t
		 -- select * from #t1

 -----------Insert count of  [customer].[customer_rapp] table---------------	
         drop table if exists #temp2
         select 
		       file_process_id as FileProcessId,
			   file_process_detail_id as FileProcessDetailId,
		       src_dealer_code as DealerCode,
			   parent_dealer_id as ParentDealerId,
		       count(*) as CustomerRAPPCOUNT
		  into #temp2
		  from [auto_customers].[customer].[customer_rapp](nolock) where file_process_id = @file_process_id 
		  group by src_dealer_code,file_process_id,file_process_detail_id,parent_dealer_id 

		--select * from #temp2
    
------------------Invali ncoa Address---------------------------------
drop table if exists #temp3
         select
		       count(*) as Invalidcustomers,
			   file_process_id as FileProcessId
		 into #temp3
		 from [clictell_auto_master].master.ncoa_customers(nolock)
		 where is_invalid_address = 1 and is_ncoa_received= 1 and file_process_id = @file_process_id
		 group by file_process_id

		--select * from [clictell_auto_etl].etl.file_process_details (nolock)


------TOTAL COUNT 		  
		drop table if exists #final  
		  select
					a.FileProcessId as FileProcessId,
					a.FileProcessDetailId as FileProcessDetailId,
					a.DealerCode as DealerCode,
					a.ParentDealerId as ParentDealerId,
					a.ETLCOUNT as ETLCount,
					e.valid_records as Valid_records,
					f.Invalid_records as Invalid_records,
					--b.CustomerRAPPCOUNT as CustomerRAPPcount,
					--c.Invalidcustomers,
					d.file_count as File_count
        into #final
	    from  #temp as a
	   -- inner join #temp2 as b  on a.ParentDealerId = b.ParentDealerId  and a.FileProcessId =b.FileProcessId and a.FileProcessDetailId = b.FileProcessDetailId
		inner join [clictell_auto_etl].etl.file_process_details d (nolock) on d.file_process_detail_id=a.FileProcessDetailId
		inner join #t as e  on e.ParentDealerId = a.ParentDealerId  and e.FileProcessId =a.FileProcessId and e.FileProcessDetailId = a.FileProcessDetailId
		inner join #t1 as f  on f.ParentDealerId = a.ParentDealerId  and f.FileProcessId =a.FileProcessId and f.FileProcessDetailId = a.FileProcessDetailId
		--inner join #temp3 as c on a.FileProcessId = c.FileProcessId

	   --- select * from #final


	   -------------failed_rules table
	 
	 --		           drop table if exists #t3
  --       select 
		--		 failed_rules ,value 
		--  into #t3
		--  from [clictell_auto_etl].[etl].[etl_rapp_customer](nolock)
		--  CROSS APPLY STRING_SPLIT(failed_rules, ',')
		--  where file_process_id = @file_process_id and is_valid_record=0

		--drop table if exists #t4
		--		select value as falied_rule, count(*) as cnt into #t4 from  #t3 where value not in ('-1',' ') group by value
		
		--drop table if exists #t5
		--select a.falied_rule,b.rule_discretion, a.cnt as [count]
		--into #t5
		--from #t4 a
		--inner join [clictell_auto_etl].[etl].[etl_rapp_Rules] b (nolock) on a.falied_rule=b.rapp_rule_id



		set @xml = cast((select
								  FileProcessId as 'td','',
								  FileProcessDetailId as 'td','',
								  DealerCode as 'td','',
								  ParentDealerId as 'td','',
								  File_count as 'td','',
								  ETLCOUNT as 'td','',
								  Valid_records as 'td','',
								  Invalid_records as 'td',''
								 -- CustomerRAPPCOUNT as 'td',''
								  --Invalidcustomers as 'td',''
	                     from  #final 
						 FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))
		--set @xml2 = cast((select
		--						  falied_rule as 'td','',
		--						  rule_discretion as 'td','',
		--						  [count] as 'td',''
				
	 --                    from  #t5 
		--				 FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))


		 Set @body1 ='</table><br/><br/><br/>
					 <p>Plz find the ETL Process Audit report for RAPP source:</p>
					 <table border = 1> 
					 <tr>
					 <th>FileProcessId</th> <th>FileProcessDetailId</th> <th>DealerCode</th> <th>ParentDealerId</th><th>File_count</th><th>ETLCOUNT</th><th>Valid_records</th>
					 <th>Invalid_records</th>'--<th>CustomerRAPPCOUNT</th>'---<th>Invalidcustomers</th>' 

		--Set @body2 ='</table><br/><br/><br/>
		--			 <p>Plz find the ETL Process Audit report for RAPP failed rules with count:</p>
		--			 <table border = 1> 
		--			 <tr>
		--			 <th>falied_rule</th> <th>rule_discretion</th> <th>[count]</th>' 



        declare @ps1 varchar(max) ='<html><body><p>Regards,</p><p> ETL Team</p>'
		 --set @body1 = @body1 + @xml +@body2+ @xml2 +'</table></body></html>'+@ps1
		set @body1 = concat(@body1 , @xml  ,'</table></body></html>',@ps1)
		 SET @body = REPLACE(@body, '<tdc>', '<td style="color:red;">')
		 SET @body = REPLACE(@body, '<tdc>', '<td>')
		 SET @body = REPLACE(@body, '</tdc>', '</td>')
		
		DECLARE @Source varchar(50) = (select source from clictell_auto_etl.etl.etl_process (nolock) where process_id = @file_process_id)
		Declare @Subject varchar(max) = 'PROD ' + @Source + ' - Comparision between ETL & RAPPCustomer'

		EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'office365',
		--@recipients='santosh.b@warrous.com;srikanth.k@warrous.com;supraja.k@warrous.com;rajesh.m@warrous.com;purnachandra@warrous.com',
		@recipients='purnachandra@warrous.com',
		@subject= @Subject,
		@body=@body1,
		@body_format='HTML',
		@from_address='contact@clictell.com',
		@reply_to='contact@clictell.com'
		end

GO
/****** Object:  StoredProcedure [master].[get_notification_for_rapp_old]    Script Date: 5/2/2022 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [master].[get_notification_for_rapp_old] 
	   @file_process_id int

AS
/*        

  exec [master].[get_notification_for_rapp] 1825 
  ----------------------------------------------------------------------------        
  MODIFICATIONS        
  Date            Author      Work Tracker Id      Description          
  ----------------------------------------------------------------------------------------------------------------------------       
  3/15/2022       Rajesh M                          Created-This procedure is used to get the emails for rapp
  ----------------------------------------------------------------------------------------------------------------------------      
                              Copyright 2021 Warrous Pvt Ltd 
*/        
BEGIN
	
 SET NOCOUNT ON;
	        Declare @xml Nvarchar(max)
	        Declare @body1 NVarchar(max)
			Declare @body NVarchar(max)


 -----------Insert count of [etl].[etl_rapp_customer]  table---------------
         drop table if exists #temp
         select 
		         file_process_id as FileProcessId,
			     file_process_detail_id as FileProcessDetailId,
		         src_dealer_code as DealerCode,
			     parent_dealer_id as ParentDealerId,
		         count(*) as ETLCOUNT
		  into #temp
		  from [clictell_auto_etl].[etl].[etl_rapp_customer](nolock)
		  where file_process_id = @file_process_id 
		  group by src_dealer_code,file_process_id,file_process_detail_id,parent_dealer_id 

		  --select * from #temp

 -----------Insert count of  [customer].[customer_rapp] table---------------	
         drop table if exists #temp2
         select 
		       file_process_id as FileProcessId,
			   file_process_detail_id as FileProcessDetailId,
		       src_dealer_code as DealerCode,
			   parent_dealer_id as ParentDealerId,
		       count(*) as CustomerRAPPCOUNT
		  into #temp2
		  from [auto_customers].[customer].[customer_rapp](nolock) where file_process_id = @file_process_id 
		  group by src_dealer_code,file_process_id,file_process_detail_id,parent_dealer_id 

		--select * from #temp2
    
------------------Invali ncoa Address---------------------------------
         select
		       count(*) as Invalidcustomers,
			   file_process_id as FileProcessId
		 into #temp3
		 from [clictell_auto_master].master.ncoa_customers(nolock)
		 where is_invalid_address = 1 and is_ncoa_received= 1 and file_process_id = @file_process_id
		 group by file_process_id

	      select
					a.FileProcessId as FileProcessId,
					a.FileProcessDetailId as FileProcessDetailId,
					a.DealerCode as DealerCode,
					a.ParentDealerId as ParentDealerId,
					a.ETLCOUNT as ETLCount,
					b.CustomerRAPPCOUNT as CustomerRAPPcount,
					c.Invalidcustomers
        into #final
	    from  #temp as a
	    inner join #temp2 as b
	    on a.ParentDealerId = b.ParentDealerId 
	    and a.FileProcessId =b.FileProcessId 
	    and a.FileProcessDetailId = b.FileProcessDetailId
		inner join #temp3 as c
		on a.FileProcessId = c.FileProcessId

	   --- select * from #final

		set @xml = cast((select
								  FileProcessId as 'td','',
								  FileProcessDetailId as 'td','',
								  DealerCode as 'td','',
								  ParentDealerId as 'td','',
								  ETLCOUNT as 'td','',
								  CustomerRAPPCOUNT as 'td','',
								  Invalidcustomers as 'td',''
	                     from  #final 
						 FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))
	
		 Set @body1 ='</table><br/><br/><br/>
					 <p>Plz find the ETL Process Audit report for RAPP source:</p>
					 <table border = 1> 
					 <tr>
					 <th>FileProcessId</th> <th>FileProcessDetailId</th> <th>DealerCode</th> <th>ParentDealerId</th><th>ETLCOUNT</th>
					 <th>CustomerRAPPCOUNT</th><th>Invalidcustomers</th>' 


        declare @ps1 varchar(max) ='<html><body><p>Regards,</p><p> ETL Team</p>'
		 set @body1 = @body1 + @xml   +'</table></body></html>'+@ps1
		-- set @body1 = concat(@body1 , @xml  ,'</table></body></html>',@ps1)
		 SET @body = REPLACE(@body, '<tdc>', '<td style="color:red;">')
		 SET @body = REPLACE(@body, '<tdc>', '<td>')
		 SET @body = REPLACE(@body, '</tdc>', '</td>')
		
		DECLARE @Source varchar(50) = (select source from clictell_auto_etl.etl.etl_process (nolock) where process_id = @file_process_id)
		Declare @Subject varchar(max) = 'PROD ' + @Source + ' - Comparision between ETL & RAPPCustomer'

		EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'office365',
		@recipients='santosh.b@warrous.com;srikanth.k@warrous.com;supraja.k@warrous.com;rajesh.m@warrous.com;purnachandra@warrous.com',
		--@recipients='rajesh.m@warrous.com',
		@subject= @Subject,
		@body=@body1,
		@body_format='HTML',
		@from_address='contact@clictell.com',
		@reply_to='contact@clictell.com'
		end

GO
/****** Object:  StoredProcedure [master].[get_notifications_for_Cdk&Atm_Make&Model_del]    Script Date: 5/2/2022 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [master].[get_notifications_for_Cdk&Atm_Make&Model_del]
---declare
   @file_process_id int 

AS

/*        


  exec [master].[get_notifications_for_CDK&ATM_Make&Model]
  
  --------------------------------------------------------------------------        
  MODIFICATIONS        
  Date            Author      Work Tracker Id      Description          
  --------------------------------------------------------------------------------------------------------------------------       
  12/23/2021      Supraja K                           Created-This procedure is used to get the emails for Ncoa Customers
  --------------------------------------------------------------------------------------------------------------------------      
                              Copyright 2021 Warrous Pvt Ltd 
*/        
begin 

	select * from clictell_auto_master.[master].[dealer_audit_log] a (nolock) 
		where file_process_id = 1810
		---@file_process_id 
		and file_process_detail_id is null


DECLARE 
	@xml NVARCHAR(MAX),
	@body1 NVARCHAR(MAX)





SET @xml = CAST(( 
		select distinct
				file_process_id AS 'td','', 
				isnull(make,'') AS 'td','',
				isnull(model,'') AS 'td',''

		from master.vehicle (nolock) 
		where file_process_id = @file_process_id 

FOR XML PATH('tr'), ELEMENTS ) 

	AS NVARCHAR(MAX))

-----

	SET @body1 ='<html><body><p>Hi Team!</p><p> Plz find Make Model List </p>
	<table border = 1> 
	<tr>
	<th> File ProcessId </th> <th> Make </th> <th> Model </th> </tr>' 


		declare @ps1 varchar(max) ='<html><body><p>Regards,</p><p> ETL Team</p>'

		SET @body1 = @body1 + @xml +'</table></body></html>'+@ps1
---print @body1

		SET @body1 = REPLACE(@body1, '<tdc>', '<td style="color:red;">')
		SET @body1 = REPLACE(@body1, '<tdc>', '<td>')
		SET @body1 = REPLACE(@body1, '</tdc>', '</td>')



	DECLARE @Source varchar(50) = (select source from clictell_auto_etl.etl.etl_process (nolock) where process_id = @file_process_id)
	Declare @Subject varchar(max) = 'PROD ' + @Source + ' - To find Make and Model List'

		EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'office365',
		@recipients='santosh.b@warrous.com;srikanth.k@warrous.com;supraja.k@warrous.com;rajesh.m@warrous.com',
		@subject= @Source,
		@body=@body1,
		@body_format='HTML',
		@from_address='contact@clictell.com',
		@reply_to='contact@clictell.com'

		--EXEC msdb.dbo.sp_send_dbmail  
		--@profile_name = 'office365',
		--@recipients='supraja.k@warrous.com',
		--@subject= @Subject,
		--@body=@body1,
		--@body_format='HTML',
		--@from_address='contact@clictell.com',
		--@reply_to='contact@clictell.com'

end

GO
/****** Object:  StoredProcedure [master].[insert_campaign_items_data_del]    Script Date: 5/2/2022 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [master].[insert_campaign_items_data_del]  
  
  
 AS  
/*          
  
  
  exec [master].[insert_campaign_items_data]  
    
  ------------------------------------------------------------------------------          
  MODIFICATIONS          
  Date            Author      Work Tracker Id      Description            
  ------------------------------------------------------------------------------------------------------------------------------         
  06/28/2021     Supraja K                         Created-This procedure is used to INSERT  campaign response data  
  ------------------------------------------------------------------------------------------------------------------------------        
                              Copyright 2021 Warrous Pvt Ltd   
*/          
  
Begin  
  
  
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp  
  
select distinct  
  19 as [campaign_id]  
  ,c.master_customer_id as list_member_id  
  ,isnull(cust_email_address1,cust_email_address2) as address  
  ,cust_first_name  
  ,cust_last_name  
  ,cust_salutation_text as salutaion  
  ,isnull(cust_address1,'') + ' ' + isnull(cust_address2,'') as home_address  
  ,cust_city  
  ,cust_state_code  
  ,'Thank You' as [campaign_name]  
  ,'Thank You' as [description]  
  ,cast(dateadd(day,7,convert(date,convert(char(8),ro_close_date))) as datetime) as schedule_date_time  
  ,'Email' as [source]  
  ,2 as list_type_id  
  ,r.parent_dealer_id  
into #temp  
from master.repair_order_header r (nolock)   
left outer join  master.customer c (nolock) on c.master_customer_id = r.master_customer_id --and c.parent_dealer_id = r.parent_dealer_id  
  
where --ro_close_date > 20210601 and   
  isnull(cust_email_address1,cust_email_address2) != ''   
  
alter table #temp add campaign_item_id int identity(2000,1)  
  
  
   insert into master.campaign_items  
 (  
  campaign_id  
  ,campaign_item_id  
  ,list_member_id  
  ,[address]  
  ,first_name  
  ,last_name  
  ,salutation  
  ,home_address  
  ,city  
  ,[state]  
  ,campaign_name  
  ,[description]  
  ,run_date  
  ,[source]  
  ,list_type_id 
  ,parent_dealer_id
    
 )  
  
 select   
  campaign_id  
  ,campaign_item_id  
  ,list_member_id  
  ,[address]  
  ,cust_first_name  
  ,cust_last_name  
  ,salutaion  
  ,home_address  
  ,cust_city  
  ,cust_state_code  
  ,campaign_name  
  ,[description]  
  ,schedule_date_time  
  ,[source]  
  ,list_type_id  
  ,parent_dealer_id
 from #temp  
  
  
 --update a  
 --set a.parent_dealer_id  = b.parent_dealer_id  
 --from   
 --master.campaign_items a (nolock) inner join #temp b (nolock) on a.list_member_id = b.list_member_id  
  
  
-- select * from master.campaign_items where campaign_id =19 and list_type_id =2 --and list_member_id in (478,519,550)  
  
 --select * from master.customer (nolock) where master_customer_id in (478,519,550)  
  
 -- table: response for campaign in RO, scheduled_date_time --> run_date  
  
 -----EXEC sp_rename 'master.campaign_items.scheduled_date_time', 'run_date', 'COLUMN';  
  
 --  select * from master.campaign_items   
 end
GO
/****** Object:  StoredProcedure [master].[insert_campaign_response_data_del]    Script Date: 5/2/2022 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
create procedure [master].[insert_campaign_response_data_del]  
  
  
 AS  
/*          
  
  
  exec [master].[insert_campaign_response_data]  
    
  ------------------------------------------------------------------------------          
  MODIFICATIONS          
  Date            Author      Work Tracker Id      Description            
  ------------------------------------------------------------------------------------------------------------------------------         
  06/28/2021     Supraja K                         Created-This procedure is used to INSERT  campaign response data  
  ------------------------------------------------------------------------------------------------------------------------------        
                              Copyright 2021 Warrous Pvt Ltd   
*/          
  
Begin  
  
  
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp  
  
select   
  campaign_id  
  ,ca.list_member_id  
  ,run_date  
  ,convert(date,convert(char(8),ro_open_date)) as ro_open_date  
  ,ro_number  
  ,ca.parent_dealer_id  
  ,datediff(day,convert(date,convert(char(8),ro_open_date)), run_date) as diff  
  ,ROW_NUMBER() over (partition by ca.list_member_id,ro_number order by ro_open_date asc) as rnk  
    
  into #temp  
from master.campaign_items ca(nolock)  
left outer join master.repair_order_header h (nolock) on h.master_customer_id = ca.list_member_id  
  
where   
  ca.campaign_id =19 and ca.list_type_id =2   
and convert(date,convert(char(8),ro_open_date)) > ca.run_date  
and  convert(date,convert(char(8),ro_close_date)) < dateadd(day,60,ca.run_date)  
and ca.parent_dealer_id is not null  
  
order by list_member_id, run_date, ro_number  
  
--select * from #temp where rnk =1  
  
  
insert into master.campaign_responce  
(  campaign_id  
  ,master_customer_id  
  ,run_date  
  ,ro_open_date  
  ,ro_number   
  ,parent_dealer_id)  
  
select   
  
  campaign_id  
  ,list_member_id  
  ,run_date  
  ,ro_open_date  
  ,ro_number  
  ,parent_dealer_id  
from #temp where rnk=1  


--select * from  master.campaign_responce order by master_customer_id, run_date  
  
/*  
create table master.campaign_responce ( campaign_id int, list_member_id int , run_date datetime, ro_open_date date, ro_number int )  
drop table campaign_responce  
select * from  master.campaign_responce  
  
truncate table master.campaign_responce  
  
  
select master_ro_header_id, natural_key, parent_dealer_id, master_customer_id, master_vehicle_id, vin, cust_dms_number, ro_number, ro_open_date, ro_close_date, Dateadd(day, 8, Cast(Cast(ro_open_date as varchar(10)) as date)) as run_date into #temp  from m
aster.repair_order_header (nolock) where --ro_open_date >= 20210601  
ro_close_date is not null  
  
select a.*   
from #temp a  
inner join #temp b on   
  a.master_customer_id = b.master_customer_id  
 and a.master_vehicle_id = b.master_vehicle_id  
 and Cast(Cast(b.ro_open_date as varchar(10)) as date) between a.run_date and dateadd(day, 60, a.run_date)  
 and a.ro_number != b.ro_number  
*/  
  
  
end  
  
GO
/****** Object:  StoredProcedure [master].[sales_kpi_update_old_DEL]    Script Date: 5/2/2022 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [master].[sales_kpi_update_old_DEL]

/*
exec [master].[sales_kpi_update]
*/

as
begin

	IF OBJECT_ID('tempdb..#gross') IS NOT NULL DROP TABLE #gross
	IF OBJECT_ID('tempdb..#gross_total') IS NOT NULL DROP TABLE #gross_total
	IF OBJECT_ID('tempdb..#gross_ly') IS NOT NULL DROP TABLE #gross_ly
	IF OBJECT_ID('tempdb..#gross_mtd') IS NOT NULL DROP TABLE #gross_mtd
	IF OBJECT_ID('tempdb..#header') IS NOT NULL DROP TABLE #header


		select
			parent_dealer_id
 
			,frontend_gross_profit
			,backend_gross_profit
			,frontend_gross_profit + backend_gross_profit as total_gross_profit
			,ltrim(rtrim(nuo_flag)) as nuo_flag
			,convert(decimal(18,2),(frontend_gross_profit /datediff(day,DATEFROMPARTS(YEAR(GETDATE()), 1, 1),GETDATE()))/365) as pace_fgross_ytd
			,convert(decimal(18,2),(isnull(backend_gross_profit,0)/datediff(day,DATEFROMPARTS(YEAR(GETDATE()), 1, 1),GETDATE()))/365) as pace_bgross_ytd
			,convert(decimal(18,2),((frontend_gross_profit + isnull(backend_gross_profit,0))/datediff(day,DATEFROMPARTS(YEAR(GETDATE()), 1, 1),GETDATE()))/365) as pace_gross_ytd
			--,month(convert(date,convert(char(8),purchase_date))) as mnt
			--,datename(month,convert(date,convert(char(8),purchase_date))) as mnt_name
			into #gross
		from master.fi_sales (nolock)
		where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and parent_dealer_id =1806 
		and deal_status in ('Finalized','Sold', 'Booked')



		select
			parent_dealer_id
			,sum(frontend_gross_profit) as front_gross
			,sum(backend_gross_profit) as back_gross	
			,sum(total_gross_profit) as total_gross
			,sum(pace_gross_ytd) as pace_gross
			,sum(pace_fgross_ytd) as pace_fgross
			,sum(pace_bgross_ytd) as pace_bgross
			,nuo_flag

			into #gross_total
		from #gross
		group by parent_dealer_id,nuo_flag

		 ---LY calculations

		 select
				parent_dealer_id
				,sum(frontend_gross_profit + backend_gross_profit) as total_gross_ly
				,ltrim(rtrim(nuo_flag)) as nuo_flag
			into #gross_ly
		from master.fi_sales (nolock)
		where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
		and parent_dealer_id =1806 and deal_status in ('Finalized','Sold', 'Booked')
		group by parent_dealer_id, nuo_flag


		---MTD Caluclations

		 select
				parent_dealer_id
				,sum(frontend_gross_profit + backend_gross_profit) as total_gross_mtd
				,ltrim(rtrim(nuo_flag)) as nuo_flag

			into #gross_mtd
		from master.fi_sales (nolock)
		where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), month(getdate()), 1) and getdate()
		and parent_dealer_id =1806 
		and deal_status in ('Finalized','Sold', 'Booked')
		group by parent_dealer_id, nuo_flag


		select
				t.parent_dealer_id
				,t.nuo_flag
				,'Vertical Bar' as chart_type
				,'New Car Retail Gross Profit' as chart_title
				,convert(varchar(100),YEAR(GETDATE())) + ' Total Gross = $'+convert(varchar(100),convert(decimal(18,1),t.total_gross)) +'and LY Change % = '+isnull(convert(varchar(100),((t.total_gross-l.total_gross_ly)*100)/l.total_gross_ly),100)+'%' as chart_subtitle_1
				,convert(varchar(100),datename(month,getdate()))+' Gross Profit = $'+convert(varchar(100),m.total_gross_mtd) as chart_subtitle_2
			into #header
		from  #gross_total t 
		left outer join #gross_ly l on t.parent_dealer_id =l.parent_dealer_id and t.nuo_flag =l.nuo_flag
		inner join #gross_mtd m on m.parent_dealer_id =t.parent_dealer_id and m.nuo_flag =t.nuo_flag

		declare @graph_data_kpi1 varchar(5000) = (
		select 
				  header.parent_dealer_id
				 ,header.nuo_flag
				 ,header.chart_type
				 ,header.chart_title
				 ,header.chart_subtitle_1
				 ,header.chart_subtitle_2
				 ,graph_data.front_gross
				 ,graph_data.pace_fgross
				 ,graph_data.back_gross
				 ,graph_data.pace_bgross
				 ,graph_data.total_gross
				 ,graph_data.pace_gross
		from #header header left outer join #gross_total graph_data on header.parent_dealer_id = graph_data.parent_dealer_id and header.nuo_flag =graph_data.nuo_flag

		for json auto
		)

			 ------------------Updating master.dashboard_kpis table
		update master.dashboard_kpis set 
			graph_data = @graph_data_kpi1 
			,chart_title =(select top 1 chart_title from #header)
			,chart_subtitle1=(select top 1 chart_subtitle_1 from #header)
			,chart_subtitle2=(select top 1 chart_subtitle_2 from #header)
		where kpi_type = 'Sales - Gross Profit'
			-----------------------------------------------------------

		-------------Sales KPI--2


		IF OBJECT_ID('tempdb..#units_ytd') IS NOT NULL DROP TABLE #units_ytd
		IF OBJECT_ID('tempdb..#units_ly') IS NOT NULL DROP TABLE #units_ly 
		IF OBJECT_ID('tempdb..#units_mtd') IS NOT NULL DROP TABLE #units_mtd
		IF OBJECT_ID('tempdb..#header_2') IS NOT NULL DROP TABLE #header_2
		IF OBJECT_ID('tempdb..#graph_data_2') IS NOT NULL DROP TABLE #graph_data_2

		select 
				parent_dealer_id
				,ltrim(rtrim(nuo_flag)) as nuo_flag
				,count(vin) as units_sold_ytd
				,convert(decimal(18,1),(convert(decimal(18,2),count(vin))/DATEDIFF(day,DATEFROMPARTS(YEAR(GETDATE()), 1, 1),GETDATE()))*365) as pace_ytd
			into #units_ytd
		from master.fi_sales (nolock)
		where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and parent_dealer_id =1806 
		and deal_status in ('Finalized','Sold', 'Booked')

		group by parent_dealer_id, nuo_flag

		--select convert(decimal(18,2),55)/DATEDIFF(day,DATEFROMPARTS(YEAR(GETDATE()), 1, 1),GETDATE())
		select 
				parent_dealer_id
				,ltrim(rtrim(nuo_flag)) as nuo_flag
				,count(vin) as units_sold_ly
				,convert(decimal(18,2),(convert(decimal(18,2),count(vin))/DATEDIFF(day,DATEFROMPARTS(YEAR(GETDATE()), 1, 1),GETDATE()))*365) as pace_ly
			into #units_ly
		from master.fi_sales (nolock)
		where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
		and parent_dealer_id =1806 
		and deal_status in ('Finalized','Sold', 'Booked')

		group by parent_dealer_id, nuo_flag


		select 
				parent_dealer_id
				,ltrim(rtrim(nuo_flag)) as nuo_flag
				,count(vin) as units_sold_mtd
				,convert(decimal(18,1),(convert(decimal(18,2),count(vin))/DATEDIFF(day,DATEFROMPARTS(YEAR(GETDATE()), MONTH(getdate()), 1),GETDATE()))*(day(EOMONTH(getdate())))) as pace_mtd
			into #units_mtd
		from master.fi_sales (nolock)
		where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), MONTH(getdate()), 1) and getdate()
		and parent_dealer_id =1806 
		and deal_status in ('Finalized','Sold', 'Booked')

		group by parent_dealer_id, nuo_flag


		select
				y.parent_dealer_id
				,y.nuo_flag
				,'Horizontal' as chart_type
				,'New Units Retailed' as chart_title
				,convert(varchar(100),YEAR(GETDATE())) + ' Units retailed = ' + convert(varchar(50),units_sold_ytd)+', LY Change % = '+convert(varchar(100), convert(decimal(18,1),convert(decimal(18,2),(units_sold_ytd -units_sold_ly)*100)/units_sold_ly))+'%' as chart_subtitle_1
				,convert(varchar(50),DATENAME(MONTH,getdate())) +' units sale = '+ convert(varchar(50),units_sold_mtd) as chart_subtitle_2
			into #header_2
		from #units_ytd y inner join #units_ly l on y.parent_dealer_id = l.parent_dealer_id and y.nuo_flag =l.nuo_flag
		inner join #units_mtd m on m.parent_dealer_id =l.parent_dealer_id and m.nuo_flag = l.nuo_flag
		--group by y.parent_dealer_id,y.nuo_flag



		select 
				parent_dealer_id
				,nuo_flag
				,units_sold_ytd
				,pace_ytd
			into #graph_data_2
		from #units_ytd

		declare @graph_data_kpi2 varchar(5000) = (
		select 
				header.parent_dealer_id
				,header.chart_type
				,header.chart_title
				,header.chart_subtitle_1
				,header.chart_subtitle_2
				,header.nuo_flag
				,graph_data.units_sold_ytd
				,graph_data.pace_ytd

		from #header_2 header inner join #graph_data_2  graph_data on header.parent_dealer_id =graph_data.parent_dealer_id and header.nuo_flag =graph_data.nuo_flag
		--where header.nuo_flag ='New'
		for json auto
		)

			 ------------------Updating master.dashboard_kpis table
		update master.dashboard_kpis set 
		graph_data = @graph_data_kpi2 
		,chart_title=(select top 1 chart_title from #header_2)
		,chart_subtitle1=(select top 1 chart_subtitle_1 from #header_2)
		,chart_subtitle2=(select top 1 chart_subtitle_2 from #header_2)
		where kpi_type = 'Sales - Car units'
			---------------------------------------------------------


		--------Sales KPI--3

		declare @graph_data_kpi3 varchar(5000) =(
		select 

			parent_dealer_id
			,'Number' as chart_type
			,ltrim(rtrim(nuo_flag)) + ' Car PNVR' as chart_title
			,ltrim(rtrim(nuo_flag)) as nuo_flag
			--,count(vin) as "graph_data.units_sold"
			--,sum(frontend_gross_profit+isnull(backend_gross_profit,0)) as "graph_data.total_gross"
			,convert(decimal(18,1),sum(frontend_gross_profit+isnull(backend_gross_profit,0))/count(vin))  as "graph_data.pnvr"

		from master.fi_sales (nolock)
		where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and parent_dealer_id =1806 
		and deal_status in ('Finalized','Sold', 'Booked')

		group by parent_dealer_id, nuo_flag

		for json path
		)

			 ------------------Updating master.dashboard_kpis table
		update master.dashboard_kpis set graph_data = @graph_data_kpi3 where kpi_type = 'Sales - PNVR'
			--------------------------------------------------------


		---------------------------sales KPI--4

		declare @graph_data_kpi4 varchar(5000)= (
		select 

				parent_dealer_id
				,ltrim(rtrim(nuo_flag)) as nuo_flag
				,'Number' as chart_type
				,'Total F&I Income PNVR' as chart_title
				,'Total F&I Income PNVR = $' + convert(varchar(100),convert(decimal(18,1),sum(isnull(total_fin_res,0) + isnull(frontend_gross_profit,0)+isnull(backend_gross_profit,0))/count(vin))) as chart_subtitle_1
				,'Total F&I = $' + convert(varchar(100),sum(isnull(total_fin_res,0) + isnull(frontend_gross_profit,0)+isnull(backend_gross_profit,0))) as chart_subtitle_2
				,count(vin) as units_retailed
				,sum(isnull(total_fin_res,0) + isnull(frontend_gross_profit,0)+isnull(backend_gross_profit,0)) as  fin_prod_gross
				,convert(decimal(18,1),sum(isnull(total_fin_res,0) + isnull(frontend_gross_profit,0)+isnull(backend_gross_profit,0))/count(vin)) as "graph_data.PNVR"

		from master.fi_sales (nolock)
		where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and parent_dealer_id =1806 
		and deal_status in ('Finalized','Sold', 'Booked') 
		and total_finance_amount is not null

		group by parent_dealer_id,nuo_flag

		for json path	
		)

			 ------------------Updating master.dashboard_kpis table
		update master.dashboard_kpis set graph_data = @graph_data_kpi4 where kpi_type = 'Sales - Total F&I Income PNVR'
			--------------------------------------------------------

		------Sales KPI--5

		declare @graph_data_kpi5 varchar(5000)= (
		select 
				parent_dealer_id
				,ltrim(rtrim(nuo_flag)) as nuo_flag
				,'Numbers' as chart_type
				,'New Inventory Units' as chart_title
				,count(vin) as "graph_data.inventory_units"
				,sum(vehicle_price) as "graph_data.inventory_value"

		from master.fi_sales s (nolock) 
		where inventory_date is not null
				and convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
				and parent_dealer_id =1806
		group by parent_dealer_id,nuo_flag

		for json path
		)


			 ------------------Updating master.dashboard_kpis table
		update master.dashboard_kpis set 
				graph_data = @graph_data_kpi5
		where kpi_type = 'Sales - Inventory'
			-------------------------------------------------------


		----Sales KPI--6

		IF OBJECT_ID('tempdb..#header_6') IS NOT NULL DROP TABLE #header_6
		IF OBJECT_ID('tempdb..#result_6') IS NOT NULL DROP TABLE #result_6
		IF OBJECT_ID('tempdb..#result1_6') IS NOT NULL DROP TABLE #result1_6
		IF OBJECT_ID('tempdb..#graph_data_6') IS NOT NULL DROP TABLE #graph_data_6
		IF OBJECT_ID('tempdb..#seg1') IS NOT NULL DROP TABLE #seg1
		IF OBJECT_ID('tempdb..#seg2') IS NOT NULL DROP TABLE #seg2
		IF OBJECT_ID('tempdb..#seg3') IS NOT NULL DROP TABLE #seg3
		IF OBJECT_ID('tempdb..#seg4') IS NOT NULL DROP TABLE #seg4

		select 
				parent_dealer_id
				,ltrim(rtrim(nuo_flag)) as nuo_flag
				,'Numbers' as chart_type
				,ltrim(rtrim(nuo_flag))+' Inventory Aging' as chart_title
				,count(vin) as inventory_units
				,sum(vehicle_price) as inventory_value
		into #header_6
		from master.fi_sales s (nolock) 
		where inventory_date is not null
				and convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
				and parent_dealer_id =1806
		group by parent_dealer_id,nuo_flag


		select 
				parent_dealer_id
				,ltrim(rtrim(nuo_flag)) as nuo_flag
				,vin
				,datediff(day,convert(date,convert(char(8),inventory_date)),isnull(convert(date,convert(char(8),purchase_date)),getdate())) as diff
		into #result_6
		from master.fi_sales s (nolock) 
		where inventory_date is not null
				and convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
				and parent_dealer_id =1806


		select 
			parent_dealer_id
			,nuo_flag
			,diff
			,vin
			,(case when diff <= 30 then 1
				when diff between 31 and 60 then 2
				when diff between 61 and 90 then 3
				else 4 end )						as age_seg

		into #result1_6 
		from #result_6 

		select	parent_dealer_id,nuo_flag,count(vin) as count_seg1 into #seg1 from #result1_6 where age_seg =1 group by parent_dealer_id,nuo_flag

		select	parent_dealer_id,nuo_flag,count(vin) as count_seg2 into #seg2 from #result1_6 where age_seg =2 group by parent_dealer_id,nuo_flag

		select	parent_dealer_id,nuo_flag,count(vin) as count_seg3 into #seg3 from #result1_6 where age_seg =3 group by parent_dealer_id,nuo_flag

		select  parent_dealer_id,nuo_flag,count(vin) as count_seg4 into #seg4 from #result1_6 where age_seg =4 group by parent_dealer_id,nuo_flag


		select 
		s1.parent_dealer_id
		,s1.nuo_flag
		,s1.count_seg1 
		,count_seg2
		,count_seg3
		,count_seg4


		into #graph_data_6
		from #seg1 s1 inner join #seg2 s2 on s1.parent_dealer_id =s2.parent_dealer_id and s1.nuo_flag=s2.nuo_flag
		inner join #seg3 s3 on s3.parent_dealer_id =s1.parent_dealer_id and s3.nuo_flag=s1.nuo_flag
		inner join #seg4 s4 on s4.parent_dealer_id =s1.parent_dealer_id and s4.nuo_flag=s1.nuo_flag

		declare @graph_data_kpi6 varchar(5000)= (
		select
				 header.parent_dealer_id as "header.accountId"
				,header.nuo_flag as "header.nuo_flag"
				,header.chart_type as "header.chart_type"
				,header.chart_title as "header.chart_title"
				,'Total Value = $'+convert(varchar(50),convert(decimal(18,1),inventory_value)) as "header.chart_subtitle_1"
				,'Total Value' as "header.chart_subtitle_2"

				,graph_data.count_seg1 as "graph_data.age_30_below"
				,graph_data.count_seg2 as "graph_data.age_31_60"
				,graph_data.count_seg3 as "graph_data.age_61_90"
				,graph_data.count_seg4 as "graph_data.age_90_above"


		from #header_6 header inner join #graph_data_6 graph_data on header.parent_dealer_id =graph_data.parent_dealer_id and header.nuo_flag =graph_data.nuo_flag
		for json path
		)



			 ------------------Updating master.dashboard_kpis table
		update master.dashboard_kpis set 
				graph_data = @graph_data_kpi6 
				,chart_title =(select top 1 chart_title from #header_6)
				,chart_subtitle1 =(select top 1 chart_subtitle1 from #header_6)
				,chart_subtitle2 =(select top 1 chart_subtitle2 from #header_6)
		where kpi_type = 'Sales - Inventory unit Aging'
			--------------------------------------------------------

		-------Sales KPI-7



		IF OBJECT_ID('tempdb..#header_7') IS NOT NULL DROP TABLE #header_7
		IF OBJECT_ID('tempdb..#result_7') IS NOT NULL DROP TABLE #result_7
		IF OBJECT_ID('tempdb..#graph_data_7') IS NOT NULL DROP TABLE #graph_data_7
		IF OBJECT_ID('tempdb..#avg_sale') IS NOT NULL DROP TABLE #avg_sale
		IF OBJECT_ID('tempdb..#avg1') IS NOT NULL DROP TABLE #avg1
		IF OBJECT_ID('tempdb..#avg2') IS NOT NULL DROP TABLE #avg2
		IF OBJECT_ID('tempdb..#avg3') IS NOT NULL DROP TABLE #avg3

		IF OBJECT_ID('tempdb..#days_supply') IS NOT NULL DROP TABLE #days_supply

		select					---last month sales average
			parent_dealer_id
			,ltrim(rtrim(nuo_flag)) as nuo_flag
			--,sum(isnull(vehicle_price,0))/day(EOMONTH(dateadd(month,-1,getdate()))) as avg_sale_1
			,count(vin)/day(EOMONTH(dateadd(month,-1,getdate()))) as avg_sale_1
			into #avg1
		from master.fi_sales s (nolock) 
		where deal_status in ('Sold','Finalized', 'Booked')
				and convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), MONTH(dateadd(month,-1,getdate())), 1) and DATEFROMPARTS(YEAR(GETDATE()), MONTH(dateadd(month,-1,getdate())), day(EOMONTH(dateadd(month,-1,getdate()))))
				and parent_dealer_id =1806
		group by parent_dealer_id,nuo_flag

		select				---this month -2 month average
			parent_dealer_id
			,ltrim(rtrim(nuo_flag)) as nuo_flag
			--,sum(isnull(vehicle_price,0))/day(EOMONTH(dateadd(month,-2,getdate()))) as avg_sale_2
			,count(vin)/day(EOMONTH(dateadd(month,-2,getdate()))) as avg_sale_2
			into #avg2
		from master.fi_sales s (nolock) 
		where deal_status in ('Sold','Finalized', 'Booked')
				and convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), MONTH(dateadd(month,-2,getdate())), 1) and DATEFROMPARTS(YEAR(GETDATE()), MONTH(dateadd(month,-2,getdate())), day(EOMONTH(dateadd(month,-2,getdate()))))
				and parent_dealer_id =1806
		group by parent_dealer_id,nuo_flag


		select					-----current month average
			parent_dealer_id
			,ltrim(rtrim(nuo_flag)) as nuo_flag
			--,sum(isnull(vehicle_price,0))/day(getdate()) as avg_sale_3
			,count(vin)/day(getdate()) as avg_sale_3
			into #avg3

		from master.fi_sales s (nolock) 
		where deal_status in ('Sold','Finalized', 'Booked')
				and convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), MONTH(getdate()), 1) and DATEFROMPARTS(YEAR(GETDATE()), MONTH(getdate()), day(getdate()))
				and parent_dealer_id =1806
		group by parent_dealer_id,nuo_flag


		select			--- Average of three months sales
				a1.parent_dealer_id
				,a1.nuo_flag
				,(isnull(a1.avg_sale_1,0)+isnull(a2.avg_sale_2,0)+isnull(a3.avg_sale_3,0))/3 as avg_sale
			into #avg_sale
		from #avg1 a1 inner join #avg2 a2 on a1.parent_dealer_id =a2.parent_dealer_id and a1.nuo_flag=a2.nuo_flag
		inner join #avg3 a3 on a3.parent_dealer_id =a1.parent_dealer_id and a3.nuo_flag=a1.nuo_flag



		select 
				 parent_dealer_id
				,(case when odometer > 1000 then 'Used' else 'New' end) as nuo_flag
				,count(vin) as current_inventory_units

				into #graph_data_7

		from master.inventory (nolock) where vehicle_status in ('AVAILABLE')
		 group by parent_dealer_id,(case when odometer > 1000 then 'Used' else 'New' end)


		 select 
				  a.parent_dealer_id
				 ,a.nuo_flag
				 ,convert(decimal(18,2),(convert(decimal(18,2),a.current_inventory_units)/b.avg_sale)*30) as days_supply
			into #days_supply
		 from #graph_data_7 a inner join #avg_sale b on a.parent_dealer_id =b.parent_dealer_id and a.nuo_flag =b.nuo_flag

		 declare @graph_data_kpi7 varchar(5000) = (
		 select
				  parent_dealer_id
				 ,nuo_flag
				 ,'Number' as chart_type
				 ,nuo_flag+' Inventory Days Supply' as chart_title
				 ,days_supply as "graph_data.days_supply"

		 from #days_supply

		 for json path
		 )

			 ------------------Updating master.dashboard_kpis table
		update master.dashboard_kpis set 
			graph_data = @graph_data_kpi7 
			,chart_title =(select top 1 chart_title from #days_supply)
			,chart_subtitle1 =(select top 1 chart_subtitle1 from #days_supply)
			,chart_subtitle2 =(select top 1 chart_subtitle2 from #days_supply)
		where kpi_type = 'Sales - Vehicle Days Supply'
			------------------------------------------------------


		 ------Sales KPI--8

 
		IF OBJECT_ID('tempdb..#fin_units') IS NOT NULL DROP TABLE #fin_units
		IF OBJECT_ID('tempdb..#total_units') IS NOT NULL DROP TABLE #total_units

		select
				parent_dealer_id
				,ltrim(rtrim(nuo_flag)) as nuo_flag
				,count(vin) as units_sold_finance

			into #fin_units
		from master.fi_sales (nolock)
			where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
					and parent_dealer_id =1806 
					and deal_status in ('Finalized','Sold', 'Booked') 
					and total_finance_amount is not null
			group by parent_dealer_id, nuo_flag

		select
				parent_dealer_id
				,ltrim(rtrim(nuo_flag)) as nuo_flag
				,count(vin) as units_sold_total

			into #total_units
		from master.fi_sales (nolock)
			where 	convert(date,convert(char(8),purchase_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
					and parent_dealer_id =1806 
					and deal_status in ('Finalized','Sold', 'Booked') 
			group by parent_dealer_id, nuo_flag

		declare @graph_data_kpi8 varchar(5000)=(
			select 
				f.parent_dealer_id
				,f.nuo_flag
				,'Table' as chart_type
				,convert(varchar(100),ltrim(rtrim(f.nuo_flag)))+' Finance Penetration' as chart_title
				,convert(varchar(100),ltrim(rtrim(f.nuo_flag)))+' Finance Penetration = '
						+convert(varchar(100),convert(decimal(18,1),(convert(decimal(18,2),units_sold_finance)/units_sold_total)*100))+'%' as chart_subtitle_1
				,convert(varchar(100),convert(decimal(18,1),(convert(decimal(18,2),units_sold_finance)/units_sold_total)*100))+'%' as "graph_data.finance_penetration"

			from #fin_units f inner join #total_units t on t.parent_dealer_id=f.parent_dealer_id and t.nuo_flag=f.nuo_flag
			--where f.nuo_flag = 'New'
			for json path
			)

			 ------------------Updating master.dashboard_kpis table
		update master.dashboard_kpis set 
				graph_data = @graph_data_kpi8 
				,chart_title=(select top 1 chart_title from #fin_units)
				,chart_subtitle1 =(select top 1 chart_subtitle1 from #fin_units)
				,chart_subtitle2 =(select top 1 chart_subtitle2 from #fin_units)
		where kpi_type = 'Sales - Finance Penetration'
			-----------------------------------------------------------
end
GO
/****** Object:  StoredProcedure [master].[service_kpi_update_old_DEL]    Script Date: 5/2/2022 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [master].[service_kpi_update_old_DEL]

as
/*
exec [master].[service_kpi_update]

select dashboard_kpi_id, kpi_type, chart_title, graph_data from master.dashboard_kpis (nolock) where kpi_type like 'Service%'

*/
begin

	IF OBJECT_ID('tempdb..#lbr_sale_ytd') IS NOT NULL DROP TABLE #lbr_sale_ytd
	IF OBJECT_ID('tempdb..#lbr_sale_ytd_ly') IS NOT NULL DROP TABLE #lbr_sale_ytd_ly
	IF OBJECT_ID('tempdb..#lbr_sale_mtd') IS NOT NULL DROP TABLE #lbr_sale_mtd
	IF OBJECT_ID('tempdb..#data') IS NOT NULL DROP TABLE #data
	IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result
	IF OBJECT_ID('tempdb..#result1') IS NOT NULL DROP TABLE #result1
	IF OBJECT_ID('tempdb..#result2') IS NOT NULL DROP TABLE #result2

	IF OBJECT_ID('tempdb..#result1_k2') IS NOT NULL DROP TABLE #result1_k2
	IF OBJECT_ID('tempdb..#result2_k2') IS NOT NULL DROP TABLE #result2_k2

		----YTD calcualtions
		select 	sum(total_labor_price) as lbr_sale_ytd	,parent_Dealer_id into #lbr_sale_ytd	from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and parent_dealer_id = 1806
		group by parent_Dealer_id
		---- LY Calculations
		select  sum(total_labor_price) as lbr_sale_ytd_ly,parent_Dealer_id into #lbr_sale_ytd_ly	from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate()) and parent_dealer_id = 1806
		group by parent_Dealer_id
		----MTD calculations
		select 	sum(total_labor_price) as lbr_sale_mtd	,parent_Dealer_id	into #lbr_sale_mtd from master.repair_order_header (nolock)
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), month(getdate()), 1) and getdate() and parent_dealer_id = 1806
		group by parent_Dealer_id
		---YTD monthly calculations
		select 
			sum(total_labor_price) as labor_sale_amount
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name
			,parent_dealer_id 
		
			into #data 
			from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and parent_dealer_id = 1806
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))


		---joining all data tables for result
		select 
				l.parent_Dealer_id
				,'Labor Sales' as chart_title
				,datename(year,getdate())+' Sales = $' + convert(varchar(50),convert(decimal(18,1),lbr_sale_ytd)) + ' and ' + 'LY Change % = ' + convert(varchar(50),convert(int,(lbr_sale_ytd - lbr_sale_ytd_ly)*100 / lbr_sale_ytd_ly)) + '%' as chart_subtitle_1
				,datename(month,getdate())+' Total = $'+convert(varchar(50),convert(decimal(18,1),lbr_sale_mtd))  as chart_subtitle_2
				,[data].mnt_name
				,[data].mnt
				,[data].labor_sale_amount

		into #result
		from 	#lbr_sale_ytd y 
		inner join #lbr_sale_ytd_ly l on y.parent_Dealer_id = l.parent_Dealer_id
		inner join #lbr_sale_mtd m on m.parent_Dealer_id =y.parent_Dealer_id
		inner join #data [data] on [data].parent_Dealer_id = y.parent_Dealer_id
		order by mnt

	----pivoting the result table to get data all data in a single JSON node
	select * into #result1 from 
	( 
	select 
			parent_Dealer_id
			,chart_title
			,chart_subtitle_1
			,chart_subtitle_2
			,mnt_name
			,labor_sale_amount

	from #result
	) as t
	pivot (
			sum(labor_sale_amount)

			FOR mnt_name in (
								January
								,February
								,March
								,April
								,May
								,June
								,July
								,August
								,September
								,October
								,November
								,December
								)
		) as pivot_table;


		
		declare @graph_data varchar(max) =  (	
		select  
				[header].parent_dealer_id as accountId
				,'vertical bar' as chart_type
				,[header].chart_title
				,[header].chart_subtitle_1
				,[header].chart_subtitle_2
				,graph_data.mnt_name as mnt_name
				,graph_data.labor_sale_amount
		from #result graph_data 
		inner join #result1 header on graph_data.parent_dealer_id = header.parent_dealer_id
	
			order by graph_data.mnt

		for json auto
		)

		print 1
		print @graph_data

	
	update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Labor Sales'

		---------------------KPI--2
	
	IF OBJECT_ID('tempdb..#gross_ytd') IS NOT NULL DROP TABLE #gross_ytd
	IF OBJECT_ID('tempdb..#gross_ytd_ly') IS NOT NULL DROP TABLE #gross_ytd_ly
	IF OBJECT_ID('tempdb..#gross_mtd') IS NOT NULL DROP TABLE #gross_mtd
	IF OBJECT_ID('tempdb..#data_k2') IS NOT NULL DROP TABLE #data_k2
	IF OBJECT_ID('tempdb..#result_k2') IS NOT NULL DROP TABLE #result_k2
	IF OBJECT_ID('tempdb..#result1_k2') IS NOT NULL DROP TABLE #result1_k2
	IF OBJECT_ID('tempdb..#result2_k2') IS NOT NULL DROP TABLE #result2_k2

		----YTD calcualtions
		select 	sum(total_repair_order_price ) - sum(total_repair_order_cost ) as gross_ytd	,parent_Dealer_id into #gross_ytd	from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and parent_dealer_id = 1806
		group by parent_Dealer_id
		---- LY Calculations
		select  sum(total_repair_order_price ) - sum(total_repair_order_cost ) as gross_ytd_ly	,parent_Dealer_id into #gross_ytd_ly	from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate()) and parent_dealer_id = 1806
		group by parent_Dealer_id
		----MTD calculations
		select 	sum(total_repair_order_price ) - sum(total_repair_order_cost ) as gross_mtd		,parent_Dealer_id	into #gross_mtd from master.repair_order_header (nolock)
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), month(getdate()), 1) and getdate() and parent_dealer_id = 1806
		group by parent_Dealer_id

		---YTD monthly calculations
		select 
			sum(total_repair_order_price ) - sum(total_repair_order_cost ) as total_gross_profit
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name
			,parent_dealer_id 
		
			into #data_k2 
			from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and parent_dealer_id = 1806
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))


		---joining all data for result
		select 
				l.parent_Dealer_id
				,'Total Gorss Profit' as chart_title
				,datename(year,getdate())+' Total Gross profit = $' + convert(varchar(50),convert(decimal(18,1),gross_ytd)) + ' and ' + 'LY Change % = ' + convert(varchar(50),convert(int,(gross_ytd - gross_ytd_ly)*100 / gross_ytd_ly)) + '%' as chart_subtitle_1
				,datename(month,getdate())+' Gross Profit = $'+convert(varchar(50),convert(decimal(18,1),gross_mtd))  as chart_subtitle_2
				,[data].mnt_name
				,[data].mnt
				,[data].total_gross_profit

		into #result_k2
		from 	#gross_ytd y 
		inner join #gross_ytd_ly l on y.parent_Dealer_id = l.parent_Dealer_id
		inner join #gross_mtd m on m.parent_Dealer_id =y.parent_Dealer_id
		inner join #data_k2 [data] on [data].parent_Dealer_id = y.parent_Dealer_id
		order by mnt

		select distinct parent_dealer_id, chart_title, chart_subtitle_1, chart_subtitle_2 into #result1_k2 from #result_k2
		select distinct parent_dealer_id, mnt, mnt_name, total_gross_profit into #result2_k2 from #result_k2 order by mnt


		set @graph_data = (	
		select  
				[header].parent_dealer_id as accountId
				,'Horizonital Bar' as chart_type
				,[header].chart_title
				,[header].chart_subtitle_1
				,[header].chart_subtitle_2
				,graph_data.mnt_name as mnt_name
				,graph_data.total_gross_profit
		from #result2_k2 graph_data 
		inner join #result1_k2 header on graph_data.parent_dealer_id = header.parent_dealer_id
	
			order by graph_data.mnt

		for json auto
		)

		print 2
		print @graph_data

		update master.dashboard_kpis set graph_data = @graph_data where chart_title = 'Total Gorss Profit'


------------KPI--3
		/*

	Total Gross ($) by CP, WP and INT KPI - 3
	select * from master.dashboard_kpis
	*/
	IF OBJECT_ID('tempdb..#gross_ytd_k3') IS NOT NULL DROP TABLE #gross_ytd_k3
	IF OBJECT_ID('tempdb..#gross_ytd_ly_k3') IS NOT NULL DROP TABLE #gross_ytd_ly_k3
	IF OBJECT_ID('tempdb..#gross_mtd_k3') IS NOT NULL DROP TABLE #gross_mtd_k3
	IF OBJECT_ID('tempdb..#data_k3') IS NOT NULL DROP TABLE #data_k3
	IF OBJECT_ID('tempdb..#reult_k3') IS NOT NULL DROP TABLE #reult_k3
	IF OBJECT_ID('tempdb..#result1_k3') IS NOT NULL DROP TABLE #result1_k3
	IF OBJECT_ID('tempdb..#result2_k3') IS NOT NULL DROP TABLE #result2_k3
	IF OBJECT_ID('tempdb..#header_k3') IS NOT NULL DROP TABLE #header_k3



		select 	
			sum(total_customer_price ) - sum(total_customer_cost ) as gross_cp_ytd	
			,sum(total_internal_price) - sum(total_internal_cost) as gross_ip_ytd
			,sum(total_warranty_price) - sum(total_internal_cost) as gross_wp_ytd
			,parent_Dealer_id 
		into #gross_ytd_k3	
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()  and parent_dealer_id = 1806
		group by parent_Dealer_id


		select 	
			sum(total_customer_price ) - sum(total_customer_cost ) as gross_cp_ytd_ly	
			,sum(total_internal_price) - sum(total_internal_cost) as gross_ip_ytd_ly
			,sum(total_warranty_price) - sum(total_internal_cost) as gross_wp_ytd_ly
			,parent_Dealer_id 
		into #gross_ytd_ly_k3
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate()) and parent_dealer_id = 1806
		group by parent_Dealer_id

		select 
				l.parent_dealer_id
				,'Stacked Trend' as chart_type
				,'Gross by Pay Type' as chart_title
				,datename(year,getdate())+' Total Gross profit = $' + convert(varchar(50),convert(decimal(18,1),gross_cp_ytd+gross_ip_ytd+gross_wp_ytd)) 
					+ ' and ' + 'LY Change % = ' + convert(varchar(50),convert(int,((gross_cp_ytd+gross_ip_ytd+gross_wp_ytd) - (gross_cp_ytd_ly+gross_ip_ytd_ly+gross_wp_ytd_ly))*100 / (gross_cp_ytd_ly+gross_ip_ytd_ly+gross_wp_ytd_ly))) + '%' as chart_subtitle_1
				,'YTD Total = $' + convert(varchar(50),(gross_cp_ytd+gross_ip_ytd+gross_wp_ytd))  as chart_subtitle_2

			into #header_k3
		from #gross_ytd_k3 y inner join #gross_ytd_ly_k3 l on y.parent_dealer_id =l.parent_dealer_id
	

		select 	
				sum(total_customer_price ) - sum(total_customer_cost ) as gross_cp_ytd	
				,sum(total_internal_price) - sum(total_internal_cost) as gross_ip_ytd
				,sum(total_warranty_price) - sum(total_internal_cost) as gross_wp_ytd
				,month(convert(date,convert(char(8),ro_close_date))) as mnt
				,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name
				,parent_Dealer_id 
			into #result1_k3
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and parent_dealer_id = 1806
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))


	set @graph_data = (	
		select 
				[header].parent_dealer_id as accountId
				,[header].chart_type
				,[header].chart_title
				,[header].chart_subtitle_1
				,[header].chart_subtitle_2
				,mnt_name
				,gross_cp_ytd 
				,gross_ip_ytd 
				,gross_wp_ytd 
		from #result1_k3 graph_data 
		inner join #header_k3 header on graph_data.parent_dealer_id = header.parent_dealer_id
	
			order by mnt

		for json auto
		)
	
	print 3
	print @graph_data

	update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Gross by Pay Type'
	
		------------ KPI --4


		IF OBJECT_ID('tempdb..#ro_ytd') IS NOT NULL DROP TABLE #ro_ytd
	IF OBJECT_ID('tempdb..#ro_ytd_ly') IS NOT NULL DROP TABLE #ro_ytd_ly
	IF OBJECT_ID('tempdb..#ro_mtd') IS NOT NULL DROP TABLE #ro_mtd
	IF OBJECT_ID('tempdb..#header_k4') IS NOT NULL DROP TABLE #header_k4
	IF OBJECT_ID('tempdb..#data_k4') IS NOT NULL DROP TABLE #data_k4

		----YTD calcualtions
		select 	count(distinct ro_number) as ro_vol_ytd	,parent_Dealer_id into #ro_ytd	from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and parent_dealer_id = 1806
		group by parent_Dealer_id

		---- LY Calculations
		select  count(distinct ro_number) as ro_vol_ytd_ly	,parent_Dealer_id into #ro_ytd_ly	from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate()) and parent_dealer_id = 1806
		group by parent_Dealer_id
		----MTD calculations
		select 	count(distinct ro_number) as ro_vol_mtd	,parent_Dealer_id	into #ro_mtd from master.repair_order_header (nolock)
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), month(getdate()), 1) and getdate() and parent_dealer_id = 1806
		group by parent_Dealer_id


		select 
				y.parent_dealer_id
				,'Closed ROs' as chart_title
				,'Horizonital Bar' as chart_type
				,datename(year,getdate()) + ' Total RO Count = '+ convert(varchar(100),y.ro_vol_ytd) 
					+ ' and LY change % = '+ convert(varchar(100),(y.ro_vol_ytd - l.ro_vol_ytd_ly)*100/l.ro_vol_ytd_ly)+'%' as chart_subtitle_1
				,datename(month, getdate()) + ' RO Count = ' + convert(varchar(100),m.ro_vol_mtd) as chart_subtitle_2
			into #header_k4
		from #ro_ytd y inner join #ro_ytd_ly l on y.parent_dealer_id = l.parent_dealer_id
		inner join #ro_mtd m on m.parent_dealer_id = l.parent_dealer_id

		
		select 
			count(distinct ro_number) as RO_count
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name
			,parent_dealer_id 
		
			into #data_k4 
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and parent_dealer_id = 1806
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))


		set @graph_data  = (
		select 
		header.parent_dealer_id as accountId
		,header.chart_type
		,header.chart_title
		,header.chart_subtitle_1
		,header.chart_subtitle_2
		,mnt_name
		,RO_count
		from #header_k4 header inner join #data_k4 graph_data on header.parent_dealer_id = graph_data.parent_dealer_id
		order by mnt
		for json auto )

		print 4
		print @graph_data
		
		update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Closed ROs'

		-------------KPI--5

		IF OBJECT_ID('tempdb..#ro_cp') IS NOT NULL DROP TABLE #ro_cp
	IF OBJECT_ID('tempdb..#ro_wp') IS NOT NULL DROP TABLE #ro_wp
	IF OBJECT_ID('tempdb..#ro_ip') IS NOT NULL DROP TABLE #ro_ip

	IF OBJECT_ID('tempdb..#ro_cp_ly') IS NOT NULL DROP TABLE #ro_cp_ly
	IF OBJECT_ID('tempdb..#ro_wp_ly') IS NOT NULL DROP TABLE #ro_wp_ly
	IF OBJECT_ID('tempdb..#ro_ip_ly') IS NOT NULL DROP TABLE #ro_ip_ly

	IF OBJECT_ID('tempdb..#header1_k5') IS NOT NULL DROP TABLE #header1_k5
	IF OBJECT_ID('tempdb..#header2_k5') IS NOT NULL DROP TABLE #header2_k5
	IF OBJECT_ID('tempdb..#header_k5') IS NOT NULL DROP TABLE #header_k5

	IF OBJECT_ID('tempdb..#ro_cp_graph') IS NOT NULL DROP TABLE #ro_cp_graph
	IF OBJECT_ID('tempdb..#ro_wp_graph') IS NOT NULL DROP TABLE #ro_wp_graph
	IF OBJECT_ID('tempdb..#ro_ip_graph') IS NOT NULL DROP TABLE #ro_ip_graph

	IF OBJECT_ID('tempdb..#result_k5') IS NOT NULL DROP TABLE #result_k5



	-----YTD calculations
		select 	
			count(distinct ro_number) as ro_cp_count
			,parent_Dealer_id 

		into #ro_cp
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and total_customer_price >0 and parent_dealer_id = 1806
		group by parent_Dealer_id

		select 	
			count(distinct ro_number) as ro_wp_count
			,parent_Dealer_id 

		into #ro_wp
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and total_warranty_price >0 and parent_dealer_id = 1806
		group by parent_Dealer_id

		select 	
			count(distinct ro_number) as ro_ip_count
			,parent_Dealer_id 

		into #ro_ip
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and total_internal_price >0 and parent_dealer_id = 1806
		group by parent_Dealer_id




	------LY Calculations
		select 	
			count(distinct ro_number) as ro_cp_count_ly
			,parent_Dealer_id 

		into #ro_cp_ly
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
		and total_customer_price >0 and parent_dealer_id = 1806
		group by parent_Dealer_id

		select 	
			count(distinct ro_number) as ro_wp_count_ly
			,parent_Dealer_id 

		into #ro_wp_ly
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
		and total_warranty_price >0 and parent_dealer_id = 1806
		group by parent_Dealer_id

		select 	
			count(distinct ro_number) as ro_ip_count_ly
			,parent_Dealer_id 

		into #ro_ip_ly
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
		and total_internal_price >0 and parent_dealer_id = 1806
		group by parent_Dealer_id

		--------Headings
		select 
				c.parent_dealer_id
				,ro_cp_count
				,ro_wp_count
				,ro_ip_count
				into #header1_k5
			from #ro_cp c inner join #ro_wp w on c.parent_dealer_id=w.parent_dealer_id
			inner join #ro_ip i on i.parent_dealer_id =w.parent_dealer_id

			select 
				c.parent_dealer_id
				,ro_cp_count_ly
				,ro_wp_count_ly
				,ro_ip_count_ly
				into #header2_k5
			from #ro_cp_ly c inner join #ro_wp_ly w on c.parent_dealer_id=w.parent_dealer_id
			inner join #ro_ip_ly i on i.parent_dealer_id =w.parent_dealer_id


		select 
			h1.parent_dealer_id
			,'Line Trend' as chart_type
			,'ROs by Pay Type' as chart_title
			,datename(year,getdate()) +' CP RO Count = '+ convert(varchar(100),ro_cp_count)+', LY Change % = '+ convert(varchar(200),(ro_cp_count - ro_cp_count_ly)*100/ro_cp_count_ly)+'%; '
				+ datename(year,getdate()) +' WP RO Count = '+ convert(varchar(100),ro_wp_count)+', LY Change % = '+ convert(varchar(200),(ro_wp_count - ro_wp_count_ly)*100/ro_wp_count_ly)+'%; '
				+ datename(year,getdate()) +' IP RO Count = '+ convert(varchar(100),ro_ip_count)+', LY Change % = '+ convert(varchar(200),(ro_ip_count - ro_ip_count_ly)*100/ro_ip_count_ly)+'%; ' as chart_subtitle_1
			, datename(year, getdate()) + ' CP Total RO Count = ' + convert(varchar(100),ro_cp_count)+'; WP Total RO Count = ' + convert(varchar(100),ro_wp_count)+'; IP Total RO Count = ' + convert(varchar(100),ro_ip_count) as chart_subtitle_2
		into #header_k5
		from #header1_k5 h1 inner join #header2_k5 h2 on h1.parent_dealer_id =h2.parent_dealer_id

		----------graph_data

		select 	
			count(distinct ro_number) as ro_cp_count
			,parent_Dealer_id 
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

		into #ro_cp_graph
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and parent_dealer_id = 1806
		and total_customer_price >0
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))

		select 	
			count(distinct ro_number) as ro_wp_count
			,parent_Dealer_id 
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name
		into #ro_wp_graph
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and parent_dealer_id = 1806
		and total_warranty_price >0
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))

		select 	
			count(distinct ro_number) as ro_ip_count
			,parent_Dealer_id 
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name
		into #ro_ip_graph
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and parent_dealer_id = 1806
		and total_internal_price >0
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))

		select
				w.parent_dealer_id
				,w.mnt
				,w.mnt_name
				,ro_cp_count
				,ro_wp_count
				,ro_ip_count
			into #result_k5
		from #ro_cp_graph c 
		inner join #ro_wp_graph w on c.parent_dealer_id =w.parent_dealer_id and c.mnt =w.mnt
		inner join #ro_ip_graph i on i.parent_dealer_id =w.parent_dealer_id and i.mnt =w.mnt
		order by mnt


	set @graph_data =(
		select
			header.parent_dealer_id as accountId
			,header.chart_type
			,header.chart_title
			,header.chart_subtitle_1
			,header.chart_subtitle_2
			,graph_data.mnt
			,graph_data.mnt_name
			,graph_data.ro_cp_count
			,graph_data.ro_wp_count
			,graph_data.ro_ip_count
		from #header_k5 header inner join #result_k5 graph_data on header.parent_dealer_id = graph_data.parent_dealer_id
		order by mnt
		for JSON AUTO )

		print 5
		print @graph_data
			update master.dashboard_kpis set graph_data = @graph_data where chart_title ='ROs by Pay Type'

			--------KPI--6


	IF OBJECT_ID('tempdb..#age') IS NOT NULL DROP TABLE #age
	IF OBJECT_ID('tempdb..#result_k6') IS NOT NULL DROP TABLE #result_k6
	IF OBJECT_ID('tempdb..#result1_k6') IS NOT NULL DROP TABLE #result1_k6
	IF OBJECT_ID('tempdb..#cp_hrs') IS NOT NULL DROP TABLE #cp_hrs
	IF OBJECT_ID('tempdb..#wp_hrs') IS NOT NULL DROP TABLE #wp_hrs
	IF OBJECT_ID('tempdb..#ip_hrs') IS NOT NULL DROP TABLE #ip_hrs
	IF OBJECT_ID('tempdb..#cwi_hrs') IS NOT NULL DROP TABLE #cwi_hrs
	IF OBJECT_ID('tempdb..#cp_hrs_ly') IS NOT NULL DROP TABLE #cp_hrs_ly
	IF OBJECT_ID('tempdb..#wp_hrs_ly') IS NOT NULL DROP TABLE #wp_hrs_ly
	IF OBJECT_ID('tempdb..#ip_hrs_ly') IS NOT NULL DROP TABLE #ip_hrs_ly
	IF OBJECT_ID('tempdb..#cwi_hrs_ly') IS NOT NULL DROP TABLE #cwi_hrs_ly
	IF OBJECT_ID('tempdb..#header_k6') IS NOT NULL DROP TABLE #header_k6

	IF OBJECT_ID('tempdb..#cp_hrs_ytd') IS NOT NULL DROP TABLE #cp_hrs_ytd
	IF OBJECT_ID('tempdb..#wp_hrs_ytd') IS NOT NULL DROP TABLE #wp_hrs_ytd
	IF OBJECT_ID('tempdb..#ip_hrs_ytd') IS NOT NULL DROP TABLE #ip_hrs_ytd
	IF OBJECT_ID('tempdb..#graph_data_k6') IS NOT NULL DROP TABLE #graph_data_k6


		select 
				parent_dealer_id
				,sum(total_billed_labor_hours) as cp_hrs

				into #cp_hrs
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and total_customer_price >0 and parent_dealer_id = 1806
		group by parent_Dealer_id


		select 
				parent_dealer_id
				,sum(total_billed_labor_hours) as wp_hrs

				into #wp_hrs
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and total_warranty_price >0 and parent_dealer_id = 1806
		group by parent_Dealer_id

		select 
				parent_dealer_id
				,sum(total_billed_labor_hours) as ip_hrs
				into #ip_hrs
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and total_internal_price >0 and parent_dealer_id = 1806
		group by parent_Dealer_id


		select 
			c.parent_dealer_id
			,cp_hrs
			,wp_hrs
			,ip_hrs
			into #cwi_hrs
		from #cp_hrs c inner join #wp_hrs w on c.parent_dealer_id = w.parent_dealer_id
		inner join #ip_hrs i on i.parent_dealer_id=w.parent_dealer_id


		--------------------------LY caluclations

			select 
				parent_dealer_id
				,sum(total_billed_labor_hours) as cp_hrs_ly

				into #cp_hrs_ly
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate()) and parent_dealer_id = 1806
		and total_customer_price >0 and parent_dealer_id = 1806
		group by parent_Dealer_id


		select 
				parent_dealer_id
				,sum(total_billed_labor_hours) as wp_hrs_ly

				into #wp_hrs_ly
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate())
		and total_warranty_price >0 and parent_dealer_id = 1806
		group by parent_Dealer_id

		select 
				parent_dealer_id
				,sum(total_billed_labor_hours) as ip_hrs_ly
				into #ip_hrs_ly
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate()) and parent_dealer_id = 1806
		and total_internal_price >0
		group by parent_Dealer_id


		select 
			c.parent_dealer_id
			,cp_hrs_ly
			,wp_hrs_ly
			,ip_hrs_ly
			into #cwi_hrs_ly
		from #cp_hrs_ly c inner join #wp_hrs_ly w on c.parent_dealer_id = w.parent_dealer_id
		inner join #ip_hrs_ly i on i.parent_dealer_id=w.parent_dealer_id


		select 
			c.parent_dealer_id
			,'Stacked bar trend' as chart_type
			,'Hours Sold' as chart_title
			,datename(year,getdate())+' CP hrs Sold = '+convert(varchar(50),convert(decimal(18,1),c.cp_hrs))+ ', LY Change % = '+ convert(varchar(50),convert(decimal(18,1),(c.cp_hrs - l.cp_hrs_ly)*100/l.cp_hrs_ly))+'%' 
									+'; WP hrs sold = '+convert(varchar(50),convert(decimal(18,1),c.wp_hrs))+ ', LY Change % = '+ convert(varchar(50),convert(decimal(18,1),(c.wp_hrs - l.wp_hrs_ly)*100/l.wp_hrs_ly))+'%' 
									+'; IP hrs sold = '+convert(varchar(50),convert(decimal(18,1),c.ip_hrs))+ ', LY Change % = '+ convert(varchar(50),convert(decimal(18,1),(c.ip_hrs - l.ip_hrs_ly)*100/l.ip_hrs_ly))+'%'  as chart_subtitle_1
			,datename(year,getdate())+ ' Total CP hrs sold = '+convert(varchar(50),convert(decimal(18,1),c.cp_hrs))
									+ '; Total WP hrs sold = '+convert(varchar(50),convert(decimal(18,1),c.wp_hrs))
									+ '; Total IP hrs sold = '+convert(varchar(50),convert(decimal(18,1),c.ip_hrs)) as chart_subtitle_2

			into #header_k6
		from #cwi_hrs c inner join #cwi_hrs_ly l on c.parent_dealer_id =l.parent_dealer_id


		----YTD Trend Calculations


			select 
				parent_dealer_id
				,sum(total_billed_labor_hours) as cp_hrs
				,month(convert(date,convert(char(8),ro_close_date))) as mnt
				,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

				into #cp_hrs_ytd
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and total_customer_price >0 and parent_dealer_id = 1806
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))


		select 
				parent_dealer_id
				,sum(total_billed_labor_hours) as wp_hrs
				,month(convert(date,convert(char(8),ro_close_date))) as mnt
				,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

				into #wp_hrs_ytd
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and total_warranty_price >0 and parent_dealer_id = 1806
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))

		select 
				parent_dealer_id
				,sum(total_billed_labor_hours) as ip_hrs
				,month(convert(date,convert(char(8),ro_close_date))) as mnt
				,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

				into #ip_hrs_ytd
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and parent_dealer_id = 1806
		and total_internal_price >0
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))


		select 
			c.parent_dealer_id
			,c.mnt
			,c.mnt_name
			,cp_hrs
			,wp_hrs
			,ip_hrs
		into #graph_data_k6
		from #cp_hrs_ytd c inner join #wp_hrs_ytd w on c.parent_dealer_id = w.parent_dealer_id and c.mnt =w.mnt
		inner join #ip_hrs_ytd i on i.parent_dealer_id =c.parent_dealer_id and c.mnt =i.mnt
		order by mnt

	set @graph_data  = (

		select 
		header.parent_dealer_id as accountId
		,header.chart_type
		,header.chart_title
		,header.chart_subtitle_1
		,header.chart_subtitle_2
		,graph_data.mnt
		,graph_data.mnt_name
		,graph_data.cp_hrs
		,graph_data.wp_hrs
		,graph_data.ip_hrs

		from #header_k6 header inner join #graph_data_k6 graph_data on header.parent_dealer_id = graph_data.parent_dealer_id
		order by mnt

		for json auto )

		print 6
		print @graph_data
				update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Hours Sold'



	---------KPI --7

	IF OBJECT_ID('tempdb..#elr') IS NOT NULL DROP TABLE #elr
		select 
			sum(total_customer_price)/sum(total_billed_labor_hours) as ELR
			,parent_Dealer_id 

	into #elr
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate()
		and total_customer_price >0 and parent_dealer_id = 1806
		group by parent_Dealer_id

		set @graph_data  = (
		select
				 parent_dealer_id as accountId
				 ,'Number ($)' as chart_type
				 ,'ELR' as chart_title#
				 ,ELR
			from #elr
		FOR JSON AUTO
		)
		print 7
		print @graph_data
		update master.dashboard_kpis set graph_data = @graph_data where chart_title ='ELR'



	----KPI--8


	IF OBJECT_ID('tempdb..#gross') IS NOT NULL DROP TABLE #gross
	IF OBJECT_ID('tempdb..#gross_ly') IS NOT NULL DROP TABLE #gross_ly
	IF OBJECT_ID('tempdb..#result1_k8') IS NOT NULL DROP TABLE #result1_k8
	IF OBJECT_ID('tempdb..#result2_k8') IS NOT NULL DROP TABLE #result2_k8
	IF OBJECT_ID('tempdb..#header1_k8') IS NOT NULL DROP TABLE #header1_k8
	IF OBJECT_ID('tempdb..#header_k8') IS NOT NULL DROP TABLE #header_k8

	select
		parent_dealer_id
		,total_repair_order_price - total_repair_order_cost as total_gross
		,total_warranty_price - total_warranty_cost as warranty_gross
		,total_customer_price - total_customer_cost as customer_gross
		,total_internal_price - total_internal_cost as internal_gross
		,ro_number

		into #gross
	from master.repair_order_header (nolock)
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and parent_dealer_id = 1806

	select
		parent_dealer_id
		,sum(total_gross) as total_gross_ytd
		,avg(total_gross) as avg_gross_ytd
		,Avg(warranty_gross) as avg_wp_gross
		,avg(customer_gross) as avg_cp_gross
		,avg(internal_gross) as avg_ip_gross
		into #result1_k8
	from #gross
	group by parent_dealer_id


	---------LY Calculations

	select
		parent_dealer_id
		,total_repair_order_price - total_repair_order_cost as total_gross
		,total_warranty_price - total_warranty_cost as warranty_gross
		,total_customer_price - total_customer_cost as customer_gross
		,total_internal_price - total_internal_cost as internal_gross
		,ro_number

		into #gross_ly
	from master.repair_order_header (nolock)
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE())-1, 1, 1) and dateadd(year,-1,getdate()) and parent_dealer_id = 1806

	select
		parent_dealer_id
		,sum(total_gross) as total_gross_ytd_ly
		,avg(total_gross) as avg_gross_ytd_ly
		,Avg(warranty_gross) as avg_wp_gross_ly
		,avg(customer_gross) as avg_cp_gross_ly
		,avg(internal_gross) as avg_ip_gross_ly
		into #result2_k8
	from #gross_ly
	group by parent_dealer_id

	select 
		c.parent_dealer_id as accountId
		,'Number' as chart_type
		,'Average Gross per RO' as chart_title
		,convert(decimal(18,1),convert(decimal(18,1),(total_gross_ytd - total_gross_ytd_ly)*100)/total_gross_ytd_ly) as total_gross_ly_perc_change
		,convert(decimal(18,1),convert(decimal(18,1),(avg_gross_ytd - avg_gross_ytd_ly)*100)/avg_gross_ytd_ly) as avg_gross_ly_perc_change
		,total_gross_ytd
		into #header1_k8
	from #result1_k8 c inner join #result2_k8 l on c.parent_dealer_id =l.parent_dealer_id


	select 
		accountId
		,chart_type
		,chart_title
		,datename(year,getdate())+' Total Gross = ' + convert(varchar(100),total_gross_ytd)+', LY Change % = '+convert(varchar(100),total_gross_ly_perc_change)+'%' as chart_subtitle_1
		,datename(year,getdate())+' YTD Total Gross = ' + convert(varchar(100),total_gross_ytd) as chart_subtitle_2
		into #header_k8
	from #header1_k8

	set @graph_data  = (
	select 
		 header.accountId
		,header.chart_type
		,header.chart_title
		,header.chart_subtitle_1
		,header.chart_subtitle_2
		,number_data.total_gross_ytd
		--,number_data.avg_gross_ytd
		,number_data.avg_cp_gross
		,number_data.avg_wp_gross
		,number_data.avg_ip_gross

	from #header_k8 header inner join #result1_k8 number_data on header.accountId =number_data.parent_dealer_id
	for json auto  )

	print 8
	print @graph_data

		update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Average Gross per RO'



		-------KPI--9

		IF OBJECT_ID('tempdb..#hrs_ro') IS NOT NULL DROP TABLE #hrs_ro

		select 	

				parent_Dealer_id 
				,sum(total_billed_labor_hours)/count(ro_number) as hrs_per_ro
		into #hrs_ro	
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and parent_dealer_id = 1806
		group by parent_Dealer_id


		set @graph_data  = (
		select 
				parent_dealer_id as accountId
				,'Number' as chart_type
				,'Hours per RO' as chart_title
				,convert(decimal(18,1),hrs_per_ro) as hrs_per_ro
		from #hrs_ro
		FOR JSON AUTO )

		print 9
		print @graph_data
		update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Hours per RO'


		--------KPI---10

		IF OBJECT_ID('tempdb..#prts_lbr') IS NOT NULL DROP TABLE #prts_lbr

		select 	

				parent_Dealer_id 
				,sum(total_parts_price)/100000 as parts_price
				,sum(total_labor_price)/100000 as labor_price	
		into #prts_lbr	
		from master.repair_order_header (nolock) 
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and parent_dealer_id = 1806
		group by parent_Dealer_id

	----Finding HCF for parts price and labour price to get ratio
	DECLARE @num1 int = (select convert(int,parts_price) from #prts_lbr)
	DECLARE @num2 int = (select convert(int,labor_price) from #prts_lbr)
	DECLARE @count INT = 1, @hcf int 

	WHILE (@count < @num1 or @count < @num2)
	BEGIN
		IF (@num1 % @count = 0 and @num2 % @count = 0)
		BEGIN
			set @hcf = @count
		END
		set @count = @count + 1
	END
	----divide parts price and labour price by HCF, calculated above to get the least ratio

		set @graph_data  = (
		select 
				parent_dealer_id as accountId
				,'Number' as chart_type
				,'Parts to Labour Ratio' as chart_title
				,convert(varchar(50),convert(int,parts_price)/@hcf) +':' +convert(varchar(50),convert(int,labor_price)/@hcf) as prt_lbr_ratio
		from #prts_lbr
		FOR JSON AUTO )

		print 10
		print @graph_data
		update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Parts to Labour Ratio'


	--------KPI--11

	IF OBJECT_ID('tempdb..#age') IS NOT NULL DROP TABLE #age
	IF OBJECT_ID('tempdb..#result_k11') IS NOT NULL DROP TABLE #result_k11
	IF OBJECT_ID('tempdb..#result1_k11') IS NOT NULL DROP TABLE #result1_k11
	IF OBJECT_ID('tempdb..#result11') IS NOT NULL DROP TABLE #result11
	IF OBJECT_ID('tempdb..#head') IS NOT NULL DROP TABLE #head
	IF OBJECT_ID('tempdb..#gd') IS NOT NULL DROP TABLE #gd

		select 	

				h.parent_Dealer_id 
				,datediff(year,convert(date,convert(char(8),iif(len(model_year)=0,0,model_year))),getdate())  as age
				,model_year
				,v.master_vehicle_id
		into #age
		from master.repair_order_header h (nolock) 
		inner join master.vehicle v (nolock) on h.master_vehicle_id = v.master_vehicle_id
		where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and h.parent_dealer_id = 1806
		--group by parent_Dealer_id

		--select * from #age order by age
	
		select 
		parent_dealer_id
		,(case when age <=1 then 1
			when age>1 and age <=2 then 2
			when age>2 and age<=3 then 3
			when age>3 and age<=4 then 4
			when age>4 and age <=5 then 5
			when age>5 and age <=10 then 6
			else 7 end) as age_seg
		into #result_k11
		from #age

		declare @1yr int = (select count(*) from #result_k11 where age_seg =1)
		declare @2yr int = (select count(*) from #result_k11 where age_seg =2)
		declare @3yr int = (select count(*) from #result_k11 where age_seg =3)
		declare @4yr int = (select count(*) from #result_k11 where age_seg =4)
		declare @5yr int = (select count(*) from #result_k11 where age_seg =5)
		declare @6yr int = (select count(*) from #result_k11 where age_seg =6)

		select distinct(parent_dealer_id), @1yr as seg_1,@2yr as seg_2,@3yr as seg_3,@4yr as seg_4,@5yr as seg_5,@6yr as seg_6
				,@1yr+@2yr+@3yr+@4yr+@5yr+@6yr as total
			into #result1_k11
		from #result_k11
		
		select 
				parent_dealer_id as accountId
				,'Pie' as chart_type
				,'Vehicle Age' as chart_title
				,convert(decimal(18,1),convert(decimal(18,1),seg_1*100)/total) as  perc_1yr_old
				,convert(decimal(18,1),convert(decimal(18,1),seg_2*100)/total) as  perc_2yr_old
				,convert(decimal(18,1),convert(decimal(18,1),seg_3*100)/total) as  perc_3yr_old
				,convert(decimal(18,1),convert(decimal(18,1),seg_4*100)/total) as  perc_4yr_old
				,convert(decimal(18,1),convert(decimal(18,1),seg_5*100)/total) as  perc_5yr_10yr_old
				,convert(decimal(18,1),convert(decimal(18,1),seg_6*100)/total) as  perc_more_10yr_old
			into #result11
		from #result1_k11

		create table #head  (accountId int,chart_type varchar(20),chart_title varchar(50),[type] varchar(50), [count] decimal(18,1))

		insert into #head (accountId,chart_type,chart_title, [type],[count]) 
		values 
		 ((select accountId from #result11),'Pie','Vehicle Age','1 year old %', (select perc_1yr_old from #result11))
		,((select accountId from #result11),'Pie','Vehicle Age','2 year old %',(select perc_2yr_old from #result11))
		,((select accountId from #result11),'Pie','Vehicle Age','3 year old %',(select perc_3yr_old from #result11))
		,((select accountId from #result11),'Pie','Vehicle Age','4 year old %',(select perc_4yr_old from #result11))
		,((select accountId from #result11),'Pie','Vehicle Age','5 to 10 year old %',(select perc_5yr_10yr_old from #result11))
		,((select accountId from #result11),'Pie','Vehicle Age','> 10 year old %',(select perc_more_10yr_old from #result11))
		
		set @graph_data = (
		select 
				 r.accountId
				,r.chart_type
				,r.chart_title
			,[type] as "Type"
			,[count] as "Count"
				
		from #head graph_data inner join #result11 r on graph_data.accountId = r.accountId
		for json auto)

		print 11
		print @graph_data
		update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Vehicle age'


	------KPI---12

	IF OBJECT_ID('tempdb..#age_k12') IS NOT NULL DROP TABLE #age_k12
	IF OBJECT_ID('tempdb..#result_k12') IS NOT NULL DROP TABLE #result_k12
	IF OBJECT_ID('tempdb..#result1_k12') IS NOT NULL DROP TABLE #result1_k12
	IF OBJECT_ID('tempdb..#age1') IS NOT NULL DROP TABLE #age1
	IF OBJECT_ID('tempdb..#age2') IS NOT NULL DROP TABLE #age2
	IF OBJECT_ID('tempdb..#age3') IS NOT NULL DROP TABLE #age3
	IF OBJECT_ID('tempdb..#age4') IS NOT NULL DROP TABLE #age4
	IF OBJECT_ID('tempdb..#age5') IS NOT NULL DROP TABLE #age5
	IF OBJECT_ID('tempdb..#age6') IS NOT NULL DROP TABLE #age6
	IF OBJECT_ID('tempdb..#age7') IS NOT NULL DROP TABLE #age7
	IF OBJECT_ID('tempdb..#graph_data_k12') IS NOT NULL DROP TABLE #graph_data_k12
	IF OBJECT_ID('tempdb..#header_k12') IS NOT NULL DROP TABLE #header_k12

	select 	
		h.parent_Dealer_id 
		,datediff(year,convert(date,convert(char(8),iif(len(model_year)=0,0,model_year))),getdate())  as age
		,ro_close_date
	into #age_k12
	from master.repair_order_header h (nolock) 
	inner join master.vehicle v (nolock) on h.master_vehicle_id = v.master_vehicle_id
	where 	convert(date,convert(char(8),ro_close_date)) between DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and getdate() and h.parent_dealer_id = 1806
		--group by parent_Dealer_id
	

		select 
			parent_dealer_id
			,	(case when age <=1 then 1
			when age>1 and age <=2 then 2
			when age>2 and age<=3 then 3
			when age>3 and age<=4 then 4
			when age>4 and age <=5 then 5
			when age>5 and age <=10 then 6
			else 7 end) as age_seg
			,ro_close_date
		into #result1_k12
		from #age_k12

	--select * from #age_k12
	--select * from #result1_k12


		select 
			parent_dealer_id
			,count(*) as age_1
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name
			into #age1
		from #result1_k12 where age_seg =1
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
		order by mnt

		select 
			parent_dealer_id
			,count(*) as age_2
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #age2
		from #result1_k12 where age_seg =2
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
		order by mnt

		select 
			parent_dealer_id
			,count(*) as age_3
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #age3
		from #result1_k12 where age_seg =3
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
		order by mnt

		select 
			parent_dealer_id
			,count(*) as age_4
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #age4
		from #result1_k12 where age_seg =4
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
		order by mnt

		select 
			parent_dealer_id
			,count(*) as age_5
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #age5
		from #result1_k12 where age_seg =5
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
		order by mnt
		
		
		select 
			parent_dealer_id
			,count(*) as age_6
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #age6
		from #result1_k12 where age_seg =6
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
		order by mnt
		
		select 
			parent_dealer_id
			,count(*) as age_7
			,month(convert(date,convert(char(8),ro_close_date))) as mnt
			,datename(month,convert(date,convert(char(8),ro_close_date))) as mnt_name

			into #age7
		from #result1_k12 where age_seg =7
		group by parent_Dealer_id, month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date)))
		order by mnt

		select 
				a1.parent_dealer_id
				,a1.mnt
				,a1.mnt_name
				,convert(decimal(18,1),convert(decimal(18,1),a1.age_1*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_1
				,convert(decimal(18,1),convert(decimal(18,1),a2.age_2*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_2
				,convert(decimal(18,1),convert(decimal(18,1),a3.age_3*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_3
				,convert(decimal(18,1),convert(decimal(18,1),a4.age_4*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_4
				,convert(decimal(18,1),convert(decimal(18,1),a5.age_5*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_5
				,convert(decimal(18,1),convert(decimal(18,1),a6.age_6*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_6
				,convert(decimal(18,1),convert(decimal(18,1),a7.age_7*100)/(a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7)) as perc_seg_7
				,convert(decimal(18,1),a1.age_1+a2.age_2+a3.age_3+a4.age_4+a5.age_5+a6.age_6+a7.age_7) as total
		into #graph_data_k12
		from #age1 a1 
		inner join #age2 a2 on a1.parent_dealer_id = a2.parent_dealer_id and a1.mnt = a2.mnt
		inner join #age3 a3 on a1.parent_dealer_id = a3.parent_dealer_id and a1.mnt = a3.mnt
		inner join #age4 a4 on a1.parent_dealer_id = a4.parent_dealer_id and a1.mnt = a4.mnt
		inner join #age5 a5 on a1.parent_dealer_id = a5.parent_dealer_id and a1.mnt = a5.mnt
		inner join #age6 a6 on a1.parent_dealer_id = a6.parent_dealer_id and a1.mnt = a6.mnt
		inner join #age7 a7 on a1.parent_dealer_id = a7.parent_dealer_id and a1.mnt = a7.mnt
		order by mnt

		select distinct
			parent_dealer_id
			,'Line Trend' as chart_type
			,'Vehicle Age Trend' as chart_title
			into #header_k12
		from #result1_k12

		set @graph_data = (
		select 
			header.parent_Dealer_id as accountId
			,header.chart_type
			,header.chart_title
			,graph_data.mnt
			,graph_data.mnt_name
			,graph_data.perc_seg_1
			,graph_data.perc_seg_2
			,graph_data.perc_seg_3
			,graph_data.perc_seg_4
			,graph_data.perc_seg_5
			,graph_data.perc_seg_6
			,graph_data.perc_seg_7
		

		from #header_k12 header inner join #graph_data_k12 graph_data on header.parent_Dealer_id =graph_data.parent_dealer_id
		order by mnt
		for json auto )

		print 12
		print @graph_data
	
	update master.dashboard_kpis set graph_data = @graph_data where chart_title ='Vehicle Age Trend'


end
GO
/****** Object:  StoredProcedure [master].[service_opcode_category_get_DEL]    Script Date: 5/2/2022 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [master].[service_opcode_category_get_DEL]
(
	@Op_code_desc varchar(4000),
	@op_category_id int output
)
as

begin


	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
	IF OBJECT_ID('tempdb..#items') IS NOT NULL drop table #items 


	--Set @Op_code_desc = 'IGNITION SYSTEM' 
	--Set @Op_code_desc = 'FOUR WHEEL ALIGNMENT'
	/* Temp table creations */
	create table #items 
	(
		keyword varchar(100),
		keyword_group_id int,
		op_category_id int,
		not_keyword bit,
		is_available_flag bit default(0)
	)

	/* Populating data into temp table */
	Insert into #items 
	(
		keyword, 
		keyword_group_id, 
		op_category_id, 
		not_keyword
	)		
	select 
		keyword, 
		keyword_group_id, 
		op_category_id, 
		not_keyword 
	from 
		[master].[ro_op_codes_keywords] (nolock)

	/* Inserting matched keywods and respective columns data into temp table */

	select 
		Keyword, 
		Keyword_group_id, 
		a.op_category_id, 
		not_keyword 
	into 
		#temp
	from [master].[ro_op_codes_keywords] a (nolock) 
	inner join 
	(
		select 
			items 
		from dbo.split(@Op_code_desc,' ')
	) as b on 
		b.items = a.keyword
	order by 2

	/* Updating availabel flag */
	Update 
		a 
	set 
		a.is_available_flag = 1
	from 
		#items a (nolock) 
	inner join #temp b on 
			a.keyword_group_id = b.keyword_group_id
		and a.keyword = b.keyword

	/* Updating available flag based not keyword */
	Update 
		a 
	set 
		a.is_available_flag =  (case when a.is_available_flag = 1 then 0 else 1 end)
	from 
		#items a 
	inner join #temp b on 
			a.keyword_group_id = b.keyword_group_id
		and a.op_category_id = b.op_category_id
	where 
		a.not_keyword = 1 

	select top 1
		@op_category_id = op_category_id
	from(
	select keyword_group_id, op_category_id, count(*) as [total KeyWords], sum(cast(is_available_flag as int)) as [present Keywords]
	from #items 
	group by keyword_group_id, op_category_id
	) as a 
	where a.[total KeyWords] = a.[present Keywords]
		

	set @op_category_id = isnull(@op_category_id, 238)
	

end
GO
/****** Object:  StoredProcedure [master].[Update_RO_KPI_graph_data_old_DEL]    Script Date: 5/2/2022 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [master].[Update_RO_KPI_graph_data_old_DEL]

--declare
--@FromDate date = '2021-01-01',
--@ToDate date ='2021-06-22',
--@dealer_id varchar(50)='1806'
    
AS
/*
	 exec [master].[Update_RO_KPI_graph_data]

	 select * from master.dashboard_kpis (nolock)
	 
	 ----------------------------------------------------------               
	 PURPOSE        
	 To Upate master.dashboard_kpis
    
	 PROCESSES        
    
	 MODIFICATIONS        
	 Date          Author			Work Tracker Id		Description          
	 -----------------------------------------------------------        
	 06/23/2021	   Srikanth K							Created - To update RO graph data in master.dashboard_kpis table.      
	 -----------------------------------------------------------      
                   Copyright 2017 Warrous Pvt Ltd
*/

Begin


	Declare @FromDate date = DATEFROMPARTS(YEAR(GETDATE()), 1, 1),
			@ToDate date = Cast(getdate() as date)

	IF OBJECT_ID('tempdb..#ytd') IS NOT NULL DROP TABLE #ytd   
	IF OBJECT_ID('tempdb..#lytd') IS NOT NULL DROP TABLE #lytd  
	IF OBJECT_ID('tempdb..#temp_dlr') IS NOT NULL DROP TABLE #temp_dlr   
	IF OBJECT_ID('tempdb..#temp10') IS NOT NULL DROP TABLE #temp10  

/*
Previous Year vs Current Year Total RO’s Revenue by Month (Please make sure to consider distinct RO’s). We can show CP vs WP vs IP vs Parts
*/

select
		month(convert(date,convert(char(8),ro_close_date))) as ro_month
		,datename(month,convert(date,convert(char(8),ro_close_date))) as ro_month_name
		,year(convert(date,convert(char(8),ro_close_date))) as ro_year
		,count(distinct ro_number) ro_count
		,sum(total_customer_parts_price) as total_customer_parts_price
		,sum(total_warranty_parts_price) as total_warranty_parts_price
		,sum(total_internal_parts_price) as total_internal_parts_price
		,sum(total_customer_labor_price) as total_customer_labor_price
		,sum(total_warranty_labor_price) as total_warranty_labor_price
		,sum(total_internal_labor_price) as total_internal_labor_price
		,sum(total_customer_price) as total_customer_price
		,sum(total_warranty_price) as total_warranty_price
		,sum(total_internal_price) as total_internal_price
		,sum(total_parts_price) as total_parts_price
		,sum(total_labor_price) as total_labor_price
		,sum(total_repair_order_price) as total_repair_order_price
		,parent_dealer_id

		into #ytd
from master.repair_order_header (nolock)
where --parent_dealer_id = @dealer_id
 convert(date,convert(char(8),ro_close_date)) between @FromDate and @ToDate
and is_deleted =0 and ro_status = 'Completed' and total_repair_order_price > 0
group by parent_dealer_id,month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date))),year(convert(date,convert(char(8),ro_close_date)))


select
		month(convert(date,convert(char(8),ro_close_date))) as ro_month
		,datename(month,convert(date,convert(char(8),ro_close_date))) as ro_month_name
		,year(convert(date,convert(char(8),ro_close_date))) as ro_year
		,count(distinct ro_number) ro_count_ly
		,sum(total_customer_parts_price) as total_customer_parts_price_ly
		,sum(total_warranty_parts_price) as total_warranty_parts_price_ly
		,sum(total_internal_parts_price) as total_internal_parts_price_ly
		,sum(total_customer_labor_price) as total_customer_labor_price_ly
		,sum(total_warranty_labor_price) as total_warranty_labor_price_ly
		,sum(total_internal_labor_price) as total_internal_labor_price_ly
		,sum(total_customer_price) as total_customer_price_ly
		,sum(total_warranty_price) as total_warranty_price_ly
		,sum(total_internal_price) as total_internal_price_ly
		,sum(total_parts_price) as total_parts_price_ly
		,sum(total_labor_price) as total_labor_price_ly
		,sum(total_repair_order_price) as total_repair_order_price_ly
		,parent_dealer_id

	into #lytd
from master.repair_order_header (nolock)
where --parent_dealer_id = @dealer_id
convert(date,convert(char(8),ro_close_date)) between dateadd(year,-1,@FromDate) and dateadd(year,-1,@ToDate)
and is_deleted =0 and ro_status = 'Completed' and total_repair_order_price > 0
group by parent_dealer_id,month(convert(date,convert(char(8),ro_close_date))),datename(month,convert(date,convert(char(8),ro_close_date))),year(convert(date,convert(char(8),ro_close_date)))

select distinct(parent_dealer_id) into #temp_dlr from #ytd union select distinct(parent_dealer_id) from #lytd


select 
c.parent_dealer_id
,c.ro_month_name
,c.ro_month
,c.ro_count
,l.ro_count_ly
,c.total_customer_price
,l.total_customer_price_ly
,c.total_warranty_price
,l.total_warranty_price_ly
,c.total_internal_price
,l.total_internal_price_ly
,c.total_parts_price
,l.total_parts_price_ly
into #temp10
from #ytd c inner join #lytd l on c.parent_dealer_id =l.parent_dealer_id and c.ro_month =l.ro_month


declare @ro_revenue_kpi_graph_data varchar(5000) 
set @ro_revenue_kpi_graph_data =
(
select 
[data].parent_dealer_id
,[data].ro_month
,[data].ro_month_name
,[data].ro_count
,[data].ro_count_ly
,[data].total_customer_price
,[data].total_customer_price_ly
,[data].total_warranty_price
,[data].total_warranty_price_ly
,[data].total_internal_price
,[data].total_internal_price_ly
,[data].total_parts_price
,[data].total_parts_price_ly
from #temp_dlr accountId
inner join #temp10 [data] on accountId.parent_dealer_id =[data].parent_dealer_id
order by data.ro_month

FOR JSON AUTO
)


--select @ro_revenue_kpi_graph_data
--return;


--------------------------------------KPI2:	Customers Segmentation Contribution from Total RO’s: New vs Active vs Lapsed vs Lost
/*
--- All Customers
select a.master_customer_id, a.cust_dms_number,  0 as new_customer, 0 as active_customer, 0 as lapsed_customer, 0 as lost_customer
into #temp_customer
from master.customer a (nolock)
where a.parent_dealer_id = @dealer_id 

--Servies
select  cust_dms_number, vin, ro_number,  ro_close_date, DateDiff(month, Cast(Cast(ro_close_date as varchar(10)) as date), getdate()) as diff
into #temp_ros
from master.repair_order_header (nolock)
where parent_dealer_id = @dealer_id 


--Sales
select cust_dms_number,vin, deal_number_dms, purchase_date, DateDiff(month, Cast(Cast(purchase_date as varchar(10)) as date), getdate()) as diff
into #temp_sales
from master.fi_sales (nolock)
where parent_dealer_id = @dealer_id


select *, 'Service'as source into #temp3
from 
(
select cust_dms_number, vin, ro_number, ro_close_date, diff, rank() over (partition by cust_dms_number order by diff asc) as rnk from #temp_ros
) as a
where a.rnk = 1 and diff >= 12 and diff <= 24
Union
select *, 'Sales'
from 
(
select cust_dms_number, vin, deal_number_dms, purchase_date, diff, rank() over (partition by cust_dms_number order by diff asc) as rnk from #temp_sales
) as a
where a.rnk = 1 and diff >= 12 and diff <= 24


Update #temp_customer set lapsed_customer = 1 where cust_dms_number in (select distinct cust_dms_number from #temp3)


select *, 'Service'as source into #temp4
from 
(
select cust_dms_number, vin, ro_number, ro_close_date, diff, rank() over (partition by cust_dms_number order by diff asc) as rnk from #temp_ros
) as a
where a.rnk = 1 and diff > 24
Union
select *, 'Sales'
from 
(
select cust_dms_number, vin, deal_number_dms, purchase_date, diff, rank() over (partition by cust_dms_number order by diff asc) as rnk from #temp_sales
) as a
where a.rnk = 1 and diff > 24

Update #temp_customer set lost_customer = 1 where cust_dms_number in (select distinct cust_dms_number from #temp4)


select * into #temp5 from #temp_sales where diff <12 and cust_dms_number + '#' + vin not in (select distinct cust_dms_number + '#' + vin from #temp_ros)

Update #temp_customer set new_customer = 1 where cust_dms_number in (select distinct cust_dms_number from #temp5)

Update #temp_customer set active_customer = 1 where cust_dms_number in (select cust_dms_number from #temp_ros  where diff <= 12)


--select * from #temp_customer where lapsed_customer = 1 and lost_customer = 1

Update #temp_customer set new_customer = 0 where new_customer = 1 and active_customer = 1
Update #temp_customer set lapsed_customer = 0 where lapsed_customer = 1 and active_customer = 1
Update #temp_customer set lost_customer = 0 where lost_customer = 1 and active_customer = 1
Update #temp_customer set lapsed_customer = 0 where new_customer = 1 and lapsed_customer = 1 -- 215
Update #temp_customer set lost_customer = 0 where new_customer = 1 and lost_customer = 1 -- 586
Update #temp_customer set lost_customer = 0 where lapsed_customer = 1 and lost_customer = 1 -- 510

declare 
@new int = (select count(distinct cust_dms_number) as new_customer from #temp_customer where new_customer = 1), -- 3346 - 1338 -- 2008
@active int = (select count(distinct cust_dms_number) as active_customer from #temp_customer where active_customer = 1), -- 16385 -- 16385
@lapsed int = (select count(distinct cust_dms_number) as lapsed_customer from #temp_customer where lapsed_customer = 1), -- 8210 - 1480 -- 6515
@lost int = (select count(distinct cust_dms_number) as lost_customer from #temp_customer where lost_customer = 1) -- 22398 - 295 -- 21007




IF OBJECT_ID('tempdb..#customer') IS NOT NULL DROP TABLE #customer  
IF OBJECT_ID('tempdb..#type_customer') IS NOT NULL DROP TABLE #type_customer  
IF OBJECT_ID('tempdb..#result1') IS NOT NULL DROP TABLE #result1  

select 
		parent_dealer_id
		, cust_dms_number
		, ro_number
		, ro_close_date
		, DateDiff(month, Cast(Cast(ro_close_date as varchar(10)) as date), getdate()) as diff
into #customer
from master.repair_order_header (nolock)
where  ro_close_date is not null and is_deleted=0 and total_repair_order_price>0


select *, row_number() over(partition by cust_dms_number order by diff asc) as rnk 
into #type_customer
from #customer order by parent_dealer_id,cust_dms_number, diff

select * ,0 as new_cust, 0 as active_cust, 0 as lapsed_cust, 0 as lost_cust into #result1 from #type_customer where rnk =1 

update #result1 set new_cust=1 where diff<12 and cust_dms_number not in (select distinct cust_dms_number from #customer where diff>=12)
update #result1 set active_cust =1 where diff<12 and cust_dms_number in (select distinct cust_dms_number from #customer where diff>=12)
update #result1 set lapsed_cust=1 where diff >= 12 and diff <= 24
update #result1 set lost_cust=1 where diff > 24


declare 
@new int	= (select sum(new_cust) from #result1),
@active int = (select sum(active_cust) from #result1),
@lapsed int = (select sum(lapsed_cust) from #result1),
@lost int	= (select sum(lost_cust) from #result1)

IF OBJECT_ID('tempdb..#temp22') IS NOT NULL DROP TABLE #temp22  
IF OBJECT_ID('tempdb..#dlr22') IS NOT NULL DROP TABLE #dlr22  

select distinct parent_dealer_id into #dlr22 from #result1
select 
	@dealer_id as parent_dealer_id
	,@new as [New Customers]
	,@active as [Active Customers]
	,@lapsed as [Lapsed Customer]
	,@lost as [Lost Customers]
into #temp22

declare @ro_cust_seg_graph_data varchar(5000)
set @ro_cust_seg_graph_data = 
(

select 
 accountId.parent_dealer_id
,[data].[New Customers]
,[data].[Active Customers]
,[data].[Lapsed Customer]
,[data].[Lost Customers]
from #dlr22 accountId inner join #temp22 [data] on accountId.parent_dealer_id = [data].parent_dealer_id
FOR JSON AUTO
)

--select @ro_cust_seg_graph_data
--return;
*/


IF OBJECT_ID('tempdb..#customer') IS NOT NULL DROP TABLE #customer  
IF OBJECT_ID('tempdb..#type_customer') IS NOT NULL DROP TABLE #type_customer  
IF OBJECT_ID('tempdb..#result1') IS NOT NULL DROP TABLE #result1  

select 
		parent_dealer_id
		, cust_dms_number
		, ro_number
		, ro_close_date
		, DateDiff(month, Cast(Cast(ro_close_date as varchar(10)) as date), getdate()) as diff
into #customer
from master.repair_order_header (nolock)
where  ro_close_date is not null and is_deleted=0 and total_repair_order_price>0


select *, row_number() over(partition by cust_dms_number order by diff asc) as rnk 
into #type_customer
from #customer order by parent_dealer_id,cust_dms_number, diff

select * ,0 as new_cust, 0 as active_cust, 0 as lapsed_cust, 0 as lost_cust into #result1 from #type_customer where rnk =1 

update #result1 set new_cust=1 where diff<12 and cust_dms_number not in (select distinct cust_dms_number from #customer where diff>=12)
update #result1 set active_cust =1 where diff<12 and cust_dms_number in (select distinct cust_dms_number from #customer where diff>=12)
update #result1 set lapsed_cust=1 where diff >= 12 and diff <= 24
update #result1 set lost_cust=1 where diff > 24

IF OBJECT_ID('tempdb..#new') IS NOT NULL DROP TABLE #new 
IF OBJECT_ID('tempdb..#active') IS NOT NULL DROP TABLE #active 
IF OBJECT_ID('tempdb..#lapsed') IS NOT NULL DROP TABLE #lapsed  
IF OBJECT_ID('tempdb..#lost') IS NOT NULL DROP TABLE #lost  

select  parent_dealer_id,sum(new_cust) as new_cust into #new from #result1 group by parent_dealer_id
select  parent_dealer_id,sum(active_cust) as active_cust into #active from #result1 group by parent_dealer_id
select  parent_dealer_id,sum(lapsed_cust) as lapsed_cust into #lapsed from #result1 group by parent_dealer_id
select  parent_dealer_id,sum(lost_cust) as lost_cust into #lost from #result1 group by parent_dealer_id

IF OBJECT_ID('tempdb..#temp22') IS NOT NULL DROP TABLE #temp22  
IF OBJECT_ID('tempdb..#dlr22') IS NOT NULL DROP TABLE #dlr22  

select distinct parent_dealer_id into #dlr22 from #result1


select
n.parent_dealer_id
,new_cust as [New Customers]
,active_cust as [Active Customers]
,lapsed_cust as [Lapsed Customer]
,lost_cust as [Lost Customers]
into #temp22
from #new n inner join #active ac on n.parent_dealer_id =ac.parent_dealer_id
inner join #lapsed l on l.parent_dealer_id =ac.parent_dealer_id
inner join #lost ls on ls.parent_dealer_id =ac.parent_dealer_id

declare @ro_cust_seg_graph_data varchar(5000)
set @ro_cust_seg_graph_data = 
(

select 
 [data].parent_dealer_id
,[data].[New Customers]
,[data].[Active Customers]
,[data].[Lapsed Customer]
,[data].[Lost Customers]
from #dlr22 accountId inner join #temp22 [data] on accountId.parent_dealer_id = [data].parent_dealer_id
order by accountId.parent_dealer_id
FOR JSON AUTO
)
------------------------------------KPI3: Total Declines by Month


IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result  
IF OBJECT_ID('tempdb..#dlr33') IS NOT NULL DROP TABLE #dlr33 


select 
			parent_Dealer_id
			,is_declined
			,DATENAME(month,convert(date,convert(char(8),ro_closed_date))) as month_year
			,month(convert(date,convert(char(8),ro_closed_date))) as m
			,year(convert(date,convert(char(8),ro_closed_date))) as y
into #result
from master.repair_order_header_detail (nolock)

where  is_declined =1
and convert(date,convert(char(8),ro_closed_date)) between @FromDate and @ToDate

select distinct parent_dealer_id into #dlr33 from #result1

declare @declined_month_graph_data varchar(5000) = 
(
select 
		[data].parent_dealer_id
		,[data].month_year
		,count(*) as declined
from #dlr33 accountId inner join #result [data] on accountId.parent_dealer_id=[data].parent_Dealer_id
group by [data].parent_dealer_id,m,y,month_year

FOR JSON AUTO
)
--select @declined_month_graph_data
--return;

-------------------updating master.dashboard_kpis table with graph data


	Update master.dashboard_kpis set graph_data = @ro_revenue_kpi_graph_data where kpi_type = 'Total RO''s Revenue'

	Update master.dashboard_kpis set graph_data = @ro_cust_seg_graph_data where kpi_type = 'Total RO''s Customer Segmentation'

	Update master.dashboard_kpis set graph_data = @declined_month_graph_data where kpi_type = 'Total Declines by Month'

--select 	@ro_revenue_kpi_graph_data, @ro_cust_seg_graph_data, @declined_month_graph_data
end
GO
/****** Object:  StoredProcedure [master].[Update_Sales_KPI_graph_data_old_DEL]    Script Date: 5/2/2022 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE Procedure [master].[Update_Sales_KPI_graph_data_old_DEL]


as     
/*    
    
 exec [master].[Update_Sales_KPI_graph_data_old]
     
 select * from master.dashboard_kpis  
    
*/    

begin   

	declare @FromDate date = dateadd(yy,-1,DATEFROMPARTS(YEAR(GETDATE()), 1, 1))
	declare @ToDate date = cast(getdate() as date)

	IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1   
	IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2   
	IF OBJECT_ID('tempdb..#tempA') IS NOT NULL DROP TABLE #tempA  
	IF OBJECT_ID('tempdb..#tempB') IS NOT NULL DROP TABLE #tempB   
	IF OBJECT_ID('tempdb..#tempC') IS NOT NULL DROP TABLE #tempC   
	IF OBJECT_ID('tempdb..#tempD') IS NOT NULL DROP TABLE #tempD 
	IF OBJECT_ID('tempdb..#temp_finalresult') IS NOT NULL DROP TABLE #temp_finalresult
	

------------------Previous Year vs Current Year Total Sales and  Revenue by Month ---------------------------------
	   select 
	        parent_dealer_id
			,vin
			,rtrim(ltrim(nuo_flag)) as nuo_flag
			,cast(cast(purchase_date as varchar(10)) as date) as purchase_date
			,vehicle_cost
			,CAST(YEAR(cast(cast(purchase_date as varchar(20)) as date)) AS VARCHAR)  as year
			,LEFT(DATENAME(MONTH,cast(cast(purchase_date as varchar(20)) as date)),3) as Month
			,substring(cast(purchase_date as varchar(10)),5,2) as month_number
	   into #temp1
	   from  master.fi_sales (nolock)
	   where 
			 deal_status in ('Booked','Sold')
			and cast(cast(purchase_date as varchar(10)) as date) between @FromDate and @ToDate
			and parent_dealer_id = 1806
			order by purchase_date

		select 
			parent_dealer_id
			,nuo_flag
			,count(vin) as sales
			,sum(vehicle_cost) as revenue
			,year
			,Month
			,month_number
		into #temp2
		from #temp1
		group by parent_dealer_id ,nuo_flag,Month,month_number,year
		order by nuo_flag,month_number,year


		select parent_dealer_id,nuo_flag,sales as current_year_sales 
		--,sum(revenue) as current_year_revenue
		,month,month_number 
		into #tempA
		from #temp2
		where year = CAST(YEAR(cast(getdate() as date)) AS VARCHAR)
		order by month_number

		select parent_dealer_id,nuo_flag,sales as previous_year_sales
		--,revenue as previous_year_revenue
		,month,month_number 
		into #tempB
		from #temp2
		where year = CAST(YEAR(dateadd(yy,-1,cast(getdate() as date))) AS VARCHAR)
		order by month_number


		select parent_dealer_id --,nuo_flag,sales as current_year_sales 
		,sum(revenue) as current_year_revenue
		,month,month_number 
		into #tempC
		from #temp2
		where year = CAST(YEAR(cast(getdate() as date)) AS VARCHAR)
		group by parent_dealer_id,month,month_number 

		order by month_number

		select parent_dealer_id  --,nuo_flag,sales as previous_year_sales
		,sum(revenue) as previous_year_revenue
		,month,month_number 
		into #tempD
		from #temp2
		where year = CAST(YEAR(dateadd(yy,-1,cast(getdate() as date))) AS VARCHAR)
		group by parent_dealer_id,month,month_number 
		order by month_number

		select distinct parent_dealer_id, [month], month_number, 0 as current_year_new_sales, 0 as previous_year_new_sales, 0 as current_year_used_sales, 0 as previous_year_used_sales into #temp_finalresult from #tempB 

		Update a set a.current_year_new_sales =  current_year_sales
		from #temp_finalresult a
		inner join #tempA b on a.parent_dealer_id = b.parent_dealer_id and a.month_number = b.month_number
		where b.nuo_flag = 'New'

		Update a set a.current_year_used_sales =  current_year_sales
		from #temp_finalresult a
		inner join #tempA b on a.parent_dealer_id = b.parent_dealer_id and a.month_number = b.month_number
		where b.nuo_flag = 'Used'

		Update a set a.previous_year_new_sales =  b.previous_year_sales
		from #temp_finalresult a
		inner join #tempB b on a.parent_dealer_id = b.parent_dealer_id and a.month_number = b.month_number
		where b.nuo_flag = 'New'

		Update a set a.previous_year_used_sales =  b.previous_year_sales
		from #temp_finalresult a
		inner join #tempB b on a.parent_dealer_id = b.parent_dealer_id and a.month_number = b.month_number
		where b.nuo_flag = 'Used'

		declare @sales_NewUsed_kpi_graph_data varchar(5000) 
		set @sales_NewUsed_kpi_graph_data = (select * from #temp_finalresult order by month_number FOR JSON PATH)


	--declare @sales_NewUsed_kpi_graph_data varchar(5000) 
	--set @sales_NewUsed_kpi_graph_data =
	--(

	--		select  b.parent_dealer_id,b.nuo_flag,b.month,b.month_number,isnull(current_year_sales,0) as current_year_sales,previous_year_sales
	--		from   #tempB b 
	--		left outer join #tempA a on a.month = b.month and a.nuo_flag = b.nuo_flag
	--		order by  b.month_number,a.nuo_flag
	--		FOR JSON PATH

	--)


	declare @sales_Revenue_kpi_graph_data varchar(5000) 
	set @sales_Revenue_kpi_graph_data =
	(

			select  d.parent_dealer_id,d.month,d.month_number,isnull(current_year_revenue,0) as current_year_revenue,previous_year_revenue
			from   #tempD d left outer join #tempC c on c.month = d.month 
			order by d.month_number 
		 
			FOR JSON PATH

	)

-------------updating master.dashboard_kpis table with graph data----------------------------


	Update master.dashboard_kpis set graph_data = @sales_NewUsed_kpi_graph_data where kpi_type = 'New vs Used Vehicles Sales' and parent_dealer_id = 1806
	Update master.dashboard_kpis set graph_data = @sales_Revenue_kpi_graph_data where kpi_type = 'Total Sales Revenue' and parent_dealer_id = 1806


end



--	   select 
--			vin
--			,rtrim(ltrim(nuo_flag)) as nuo_flag
--			,purchase_date
--			,vehicle_price
--			,LEFT(DATENAME(MONTH,cast(cast(purchase_date as varchar(20)) as date)),3) as Month
--			,substring(cast(purchase_date as varchar(10)),5,2) as month_number
--	   into 
--			#temp1
--	   from  master.fi_sales (nolock)
--	   where 
--			parent_dealer_id = @dealer and deal_status in ('Booked','Sold')
--			and cast(cast(purchase_date as varchar(10)) as date) between @FromDate and @ToDate

--	   select 
--			vin
--			,rtrim(ltrim(nuo_flag)) as nuo_flag
--			,purchase_date
--			,vehicle_price
--			--,CAST(YEAR(cast(cast(purchase_date as varchar(20)) as date)) AS VARCHAR)  as year
--			,LEFT(DATENAME(MONTH,cast(cast(purchase_date as varchar(20)) as date)),3) as Month

--		into 
--			#temp2
--		from master.fi_sales (nolock)
--		where 
--			parent_dealer_id = @dealer and deal_status in ('Booked','Sold')
--			and cast(cast(purchase_date as varchar(10)) as date) between dateadd(yy,-1,@FromDate) and dateadd(yy,-1,@ToDate)
			
----drop table #temp
--	   select 
--			nuo_flag
--			,month
--			,month_number
--			,count(vin) as current_year_sales
--	  into #tempA
--	  from #temp1 (nolock)
--	  group by 
--			month,nuo_flag,month_number
--      order by 
--			nuo_flag

--	 select 
--		 nuo_flag
--		,month
--		,count(vin) as previous_year_sales
--	 into #tempB
--	 from #temp2 (nolock)
--		group by 
--			month,nuo_flag
--		order by 
--			nuo_flag

--		alter table #tempA
--		add id int identity(1,1)

--		alter table #tempB
--		add id int identity(1,1)

--	declare @sales_NewUsed_kpi_graph_data varchar(5000) 
--	set @sales_NewUsed_kpi_graph_data =

--(
--		select a.nuo_flag,a.Month,current_year_sales,previous_year_sales 
--		from #tempA a (nolock) inner join #tempB b (nolock) on a.id = b.id
--		order by nuo_flag,month_number
	
--	   FOR JSON path

--)
--	   select 
--			month
--			,month_number
--			,sum(vehicle_price) as current_year_revenue
--	    into #tempC
--	    from #temp1 (nolock)
--	    group by 
--		   month,month_number
--	   order by 
--		   month_number

--	  select 
--		 month
--		,sum(vehicle_price) as previous_year_revenue
--		into #tempD
--		from #temp2 (nolock)
--		group by 
--		month	

--	declare @sales_Revenue_kpi_graph_data varchar(5000) 
--	set @sales_Revenue_kpi_graph_data =
--(
--		select c.Month,current_year_revenue,previous_year_revenue from #tempC c (nolock) inner join #tempD d (nolock) on c.Month = d.Month
--		order by 
--			month_number
--	   FOR JSON path
--)

-------------updating master.dashboard_kpis table with graph data----------------------------


--	Update master.dashboard_kpis set graph_data = @sales_NewUsed_kpi_graph_data where kpi_type = 'New vs Used Vehicles Sales'
--	Update master.dashboard_kpis set graph_data = @sales_Revenue_kpi_graph_data where kpi_type = 'Total Sales Revenue'


--end

--select @sales_NewUsed_kpi_graph_data
--select @sales_Revenue_kpi_graph_data

GO


USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [master].[update_campaign_responses_new]    Script Date: 5/2/2022 2:24:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [master].[update_campaign_responses_new]

as	

/*
-----------------------------------------------------------------------  
	Copyright 2021 Clictell

	PURPOSE  
	Update Campaign Responses

	PROCESSES  

	MODIFICATIONS  
	Date			Author			Work Tracker Id		Description    
	------------------------------------------------------------------------  
	07/15/2021		Santhosh B		Created				Update Campaign Responses
	------------------------------------------------------------------------

	exec [master].[update_campaign_responses]

	truncate table master.campaign_items

	select count(*) from master.campaign_items (nolock) where response_type is null -- 19954
	select count(*) from master.campaign_responses (nolock) where Updated_dt >= getdate() -- 0
-----------------------------------------------------------------------
*/
Begin

	IF OBJECT_ID('tempdb..#temp_campaign_Items') IS NOT NULL DROP TABLE #temp_campaign_Items
	IF OBJECT_ID('tempdb..#temp_campaings') IS NOT NULL DROP TABLE #temp_campaings
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

	--IF OBJECT_ID('tempdb..#temp_response') IS NOT NULL DROP TABLE #temp_response
	--IF OBJECT_ID('tempdb..#temp_ro') IS NOT NULL DROP TABLE #temp_ro
	
	IF OBJECT_ID('tempdb..#temp_assigned_responses') IS NOT NULL DROP TABLE #temp_assigned_responses
	
	Declare @fromm_date date,
			@to_date date,
			@campaign_id int,
			@run_dt date,
			@source varchar(10),
			@rownum int

	--Create table #temp_response
	--(
	--	master_campaign_item_id int, 
	--	master_ro_header_id int,
	--	total_customer_price decimal(18,2),
	--	total_warranty_price decimal(18,2),
	--	total_internal_price decimal(18,2),
	--)

	Create table #temp_campaign_Items
	(
		master_campaign_item_id int,
		parent_dealer_id int,
		campaign_id int,
		campaign_item_id int,
		master_customer_id int,
		run_date datetime,
		vin varchar(20),
		first_name varchar(250),
		last_name varchar(250),
		address1 varchar(250),
		address2 varchar(250),
		city varchar(50),
		state_code varchar(50),
		zip_code varchar(20),
		communication_address varchar(100),
		media_type varchar(25),
		response_number int,
		cp_amount decimal(18,2),
		wp_amount decimal(18,2),
		ip_amount decimal(18,2),
		response_type varchar(50),
		campaing_response_id int,
	)

	--select distinct campaign_id, run_date, count(*)  from master.campaign_items (nolock) where communication_address like '%1' group by campaign_id, run_date

	select parent_dealer_id, campaing_response_id, campaign_id, campaign_date, media_type, 0 as is_processed
	into #temp_campaings
	from master.campaign_responses (nolock)
	where campaign_date between DateAdd(day, -60, getdate()) and DateAdd(day, -1, getdate())
	and is_deleted = 0
--return;
--select * from #temp_campaings
	While ((select count(*) from #temp_campaings where is_processed = 0) > 0)
	Begin

		select top 1 
			@rownum = campaing_response_id,
			@campaign_id = campaign_id, 
			@run_dt = campaign_date, 
			@source = media_type  
		from 
			#temp_campaings 
		where 
			is_processed = 0 
		order by 
			campaign_date
		
		print 'Campaign ID : ' + cast(@campaign_id as varchar(10))


		/*
		Insert into #temp_campaign_Items (parent_dealer_id, master_campaign_item_id, campaign_id, campaign_item_id, master_customer_id, run_date, communication_address, media_type, vin, campaing_response_id)
		select parent_dealer_id, master_campaign_item_id, campaign_id, campaign_item_id, list_member_id, run_date, communication_address, [source] as media_type, vin, @rownum
		from master.campaign_items (nolock)
		where campaign_id = @campaign_id -- @campaign_id
		and run_date = @run_dt--@run_dt
		and response_number is null
		and is_deleted = 0

		*/

		IF @source = 'Email'
		BEGIN
			Insert into #temp_campaign_Items (parent_dealer_id, master_campaign_item_id, campaign_id, campaign_item_id, master_customer_id, run_date, communication_address, media_type, vin, campaing_response_id)
			select c.parent_dealer_id, campaign_item_id, a.campaign_id, campaign_item_id, list_member_id, b.scheduled_date as run_date, a.email_address as communication_address, b.media_type, vin, @rownum
			from 
				email.campaign_items  a (nolock)
				inner join email.campaigns b (nolock) on a.campaign_id =b.campaign_id
				inner join master.dealer c (nolock) on c._id = b.account_id
			where a.campaign_id = @campaign_id -- @campaign_id
			and b.scheduled_date = @run_dt--@run_dt
			--and response_number is null
			and a.is_deleted = 0
		END

		IF @source = 'SMS'
			BEGIN
				Insert into #temp_campaign_Items (parent_dealer_id, master_campaign_item_id, campaign_id, campaign_item_id, master_customer_id, run_date, communication_address, media_type, vin, campaing_response_id)
				select c.parent_dealer_id, campaign_item_id, a.campaign_id, campaign_item_id, list_member_id, b.scheduled_date, a.phone as communication_address, b.media_type, vin, @rownum
				from 
					sms.campaign_items  a (nolock)
					inner join sms.campaigns b (nolock) on a.campaign_id =b.campaign_id
					inner join master.dealer c (nolock) on c._id = b.account_id
				where a.campaign_id = @campaign_id -- @campaign_id
				and b.scheduled_date = @run_dt--@run_dt
				--and response_number is null
				and a.is_deleted = 0
			END
		IF @source = 'Print'
			BEGIN
				Insert into #temp_campaign_Items (parent_dealer_id, master_campaign_item_id, campaign_id, campaign_item_id, master_customer_id, run_date, communication_address, media_type, vin, campaing_response_id)
				select c.parent_dealer_id, campaign_item_id, a.campaign_id, campaign_item_id, list_member_id, b.scheduled_date, address as communication_address, b.media_type, vin, @rownum
				from 
					email.campaign_items  a (nolock)
					inner join email.campaigns b (nolock) on a.campaign_id =b.campaign_id
					inner join master.dealer c (nolock) on c._id = b.account_id
				where a.campaign_id = @campaign_id -- @campaign_id
				and b.scheduled_date = @run_dt--@run_dt
				--and response_number is null
				and a.is_deleted = 0
			END


--select top 3 * from email.campaign_items (nolock)
--select top 3 * from email.campaigns (nolock)


		print 'Customer Response based on master_customer_id from servcie'

		Update a set 
			a.response_number = b.master_ro_header_id, 
			a.cp_amount = b.total_customer_price,
			a.wp_amount = b.total_warranty_price,
			a.ip_amount = b.total_internal_price,
			a.response_type = 'Service'
		from #temp_campaign_Items a (nolock) 
		inner join master.repair_order_header b (nolock) on
			a.master_customer_id = b.master_customer_id
		where 
				b.ro_status != 'VOID'
			and b.is_deleted = 0
			and Cast(Cast(ro_open_date as varchar(10)) as date) between DateAdd(day, 1, run_date) and Dateadd(day, 61, run_date)

		--select * from #temp_campaign_Items

		
		print 'Customer Response based on vin and communication (email) from servcie'

		Update a set a.response_number = d.master_ro_header_id , a.response_type = 'Service', a.cp_amount = d.total_customer_price, a.wp_amount = d.total_warranty_price
		, ip_amount = d.total_internal_price
		--select a.*
		from #temp_campaign_Items a
		inner join master.cust_2_vehicle b (nolock) on a.parent_dealer_id = b.parent_dealer_id and a.vin = b.vin
		inner join master.customer c (nolock) on a.parent_dealer_id = c.parent_dealer_id and a.communication_address = c.cust_email_address1 + '1'
		inner join master.repair_order_header d (nolock) on 
				b.master_customer_id = d.master_customer_id
			and b.master_vehicle_id = d.master_vehicle_id
			and b.parent_dealer_id = d.parent_dealer_id
		where 
			a.response_number is null
		and a.media_type = 'Email'--@source
		and d.ro_status != 'VOID'
		and d.is_deleted = 0
		and Cast(Cast(ro_open_date as varchar(10)) as date) between DateAdd(day, 1, run_date) and Dateadd(day, 61, run_date)

		print 'Customer Response based on vin and communication (phone) from servcie'

		Update a set a.response_number = d.master_ro_header_id , a.response_type = 'Service', a.cp_amount = d.total_customer_price, a.wp_amount = d.total_warranty_price
		, ip_amount = d.total_internal_price
		--select a.*
		from #temp_campaign_Items a
		inner join master.cust_2_vehicle b (nolock) on a.vin = b.vin
		inner join master.customer c (nolock) on (a.communication_address = c.cust_home_phone or a.communication_Address = c.cust_mobile_phone)
		inner join master.repair_order_header d (nolock) on 
				b.master_customer_id = d.master_customer_id
			and b.master_vehicle_id = d.master_vehicle_id
		where 
			a.response_number is null
		and a.media_type = 'SMS'--@source
		and d.ro_status != 'VOID'
		and d.is_deleted = 0
		and Cast(Cast(ro_open_date as varchar(10)) as date) between DateAdd(day, 1, run_date) and Dateadd(day, 61, run_date)

		--select top 3 * from master.customer (nolock)
				print 'Customer Response based on vin and communication (Print) from servcie'

		Update a set a.response_number = d.master_ro_header_id , a.response_type = 'Service', a.cp_amount = d.total_customer_price, a.wp_amount = d.total_warranty_price
		, ip_amount = d.total_internal_price
		--select a.*
		from #temp_campaign_Items a
		inner join master.cust_2_vehicle b (nolock) on a.vin = b.vin
		inner join master.customer c (nolock) on (a.communication_address = c.cust_address1 or a.communication_address = c.cust_address2)
		inner join master.repair_order_header d (nolock) on 
				b.master_customer_id = d.master_customer_id
			and b.master_vehicle_id = d.master_vehicle_id
		where 
			a.response_number is null
		and a.media_type = 'Print'--@source
		and d.ro_status != 'VOID'
		and d.is_deleted = 0
		and Cast(Cast(ro_open_date as varchar(10)) as date) between DateAdd(day, 1, run_date) and Dateadd(day, 61, run_date)
	
	--select top 3 * from master.customer (nolock)
		--print 'Customer Response based on vin, FirstName and LastName from servcie'

		--Update a set a.response_number = d.master_ro_header_id , a.response_type = 'Service', a.cp_amount = d.total_customer_price, a.wp_amount = d.total_warranty_price
		--, ip_amount = d.total_internal_price
		--from #temp_campaign_Items a
		--inner join master.cust_2_vehicle b (nolock) on a.vin = b.vin
		--inner join master.customer c (nolock) on 
		--		a.first_name = c.cust_first_name
		--	and a.last_name = c.cust_last_name
		--inner join master.repair_order_header d (nolock) on 
		--		b.master_customer_id = d.master_customer_id
		--	and b.master_vehicle_id = d.master_vehicle_id
		--where response_number is null
		--and campaign_id = 1444
		--and a.[source] = 'Email'--@source
		--and d.ro_status != 'VOID'
		--and d.is_deleted = 0
		--and Cast(Cast(ro_open_date as varchar(10)) as date) between DateAdd(day, 1, run_date) and Dateadd(day, 61, run_date)
		--and d.master_ro_header_id not in (select response_number from #temp_assigned_responses where response_type = 'Service')

		--insert into #temp_assigned_responses (response_number, response_type)
		--select response_number, response_type  from #temp_campaign_Items where response_number not in (select response_number from #temp_assigned_responses)

		--print 'Customer Response based on vin, and address from servcie'

		--Update a set a.response_number = d.master_ro_header_id , a.response_type = 'Service', a.cp_amount = d.total_customer_price, a.wp_amount = d.total_warranty_price
		--, ip_amount = d.total_internal_price
		--from #temp_campaign_Items a
		--inner join master.cust_2_vehicle b (nolock) on a.vin = b.vin
		--inner join master.customer c (nolock) on 
		--		a.first_name = c.cust_first_name
		--	and a.last_name = c.cust_last_name
		--	and a.home_address = c.cust_address1
		--inner join master.repair_order_header d (nolock) on 
		--		b.master_customer_id = d.master_customer_id
		--	and b.master_vehicle_id = d.master_vehicle_id
		--where response_number is null
		--and campaign_id = 1444
		--and a.[source] = 'Email'--@source
		--and d.ro_status != 'VOID'
		--and d.is_deleted = 0
		--and Cast(Cast(ro_open_date as varchar(10)) as date) between DateAdd(day, 1, run_date) and Dateadd(day, 61, run_date)
		--and d.master_ro_header_id not in (select response_number from #temp_assigned_responses where response_type = 'Service')

		Update #temp_campaings set is_processed = 1 where campaing_response_id = @rownum

		--truncate table #temp_response
	end

--return;
--select * from #temp_campaings
--select top 3 * from #temp_campaign_Items
--select top 3 * from master.campaign_items (nolock)

--select top 3 * from master.campaign_items (nolock)

	Update 
		a
	set
		a.response_number = b.response_number,
		a.response_type = b.response_type,
		a.cp_amount = b.cp_amount,
		a.wp_amount = b.wp_amount,
		a.ip_amount = b.ip_amount,
		a.updated_date = getdate(),
		a.updated_by = suser_name()
	from master.campaign_items a
	inner join #temp_campaign_Items b on 
		a.master_campaign_item_id = b.master_campaign_item_id
	where 
		b.response_number is not null

	select parent_dealer_id, campaign_id, Cast(run_date as date) as campaign_date, [source], [program_name]
		, count(*) as [sent]
		, sum(Cast(Isnull([is_delivered], 0) as int)) as [delivered]
		, sum(Cast(Isnull([is_opened], 0) as int)) as [opened]
		, sum(Cast(Isnull([is_clicked], 0) as int)) as [clicked]
		, sum(Cast(Isnull([is_bounced], 0) as int)) as [bounced]
		, sum(Cast(Isnull([is_failed], 0) as int)) as [failed]
		, sum(case when response_number is not null then 1 else 0 end) as [responders]
		, Sum(Isnull(cp_amount, 0)) as cp_amount
		, sum(isnull(wp_amount, 0)) as wp_amount
		, sum(isnull(ip_amount, 0)) as ip_amount
	into #temp
	from master.campaign_items (nolock)
	where updated_date >= DateAdd(day, -1, getdate())
	group by parent_dealer_id, campaign_id, Cast(run_date as date), [source], [program_name]

	Update 
		a
	set 
		 a.[sent] = b.[sent]
		,a.[delivered] = b.[delivered]
		,a.[opened] = b.[opened]
		,a.[clicked] = b.[clicked]
		,a.[bounced] = b.[bounced]
		,a.[failed] = b.[failed]
		,a.[responders] = b.[responders]
		,a.cp_amount = b.cp_amount
		,a.wp_amount = b.wp_amount
		,a.ip_amount = b.ip_amount
		,a.[ro_amount] = b.cp_amount + b.wp_amount + b.ip_amount
		,a.updated_dt = getdate()
		,a.updated_by = suser_name()
	from master.campaign_responses a (nolock)
	inner join #temp b on a.campaign_id = b.campaign_id and a.campaign_date = b.campaign_date

End


USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[CustomerDetailView_del]    Script Date: 5/2/2022 2:27:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure  [reports].[CustomerDetailView_del]

--declare
@cust_dms_number varchar(20),
@dealer_id varchar(20)
as 
/*
	exec [reports].[CustomerDetailView_new] '127682', '3407'
*/

begin
	

	select distinct

			v.model_year
			,v.model
			,v.make
			,s.mileage_out
			,d.dealer_name
			,iif(s.nuo_flag='N','New',iif(s.nuo_flag='U','Used',ltrim(rtrim(s.nuo_flag)))) as nuo_flag
			,s.invoice_price
			,s.vehicle_cost
			,replace(convert(varchar(10), convert(date,(convert(varchar(10),Isnull(s.purchase_date,s.delivery_date) )), 111)),'/','-')as purchase_date
			,s.sale_type
			,Isnull(s.finance_apr, 'N/A') as finance_apr
			,s.monthly_payment
			 ,Isnull(s.contract_term, 'N/A') as contract_term
			--,(Case when s.contract_term != null then s.contract_term else 'N/A' end) as contract_term
			,s.total_trade_actuval_cashvalue
			--,p.sale_full_name as sale_full_name
			,s.sales_manager_fullname as sale_full_name
			,(Case when s.total_gross_profit is not null then  s.total_gross_profit else Isnull(s.frontend_gross_profit,'') + Isnull(s.backend_gross_profit, '') end) as total_gross_profit
			,s.frontend_gross_profit
			,s.backend_gross_profit
			,s.cust_dms_number
			,v.vin

	from [master].[fi_sales] s (nolock)
	inner join master.vehicle v (nolock) on s.master_fi_sales_id = v.master_vehicle_id
	inner join master.customer c (nolock) on s.master_fi_sales_id = c.master_customer_id
	inner join master.dealer d (nolock) on s.natural_key = d.natural_key
	--inner join master.fi_sales_people p (nolock) on p.master_fi_sales_id = s.master_fi_sales_id --1311 rows/5512
	
	where 
				s.cust_dms_number = @cust_dms_number
			and @dealer_id = s.parent_dealer_id

end

---------------------------------------
------------------------------------------REPORTS

USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[declined_services]    Script Date: 5/2/2022 2:30:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure  [reports].[declined_services]
--declare
@dealer varchar(4000) = '524',
@FromDate date = '2015-01-01',
@ToDate date = '2021-04-01',
@DateRange int = 6
as 
/*
	exec [reports].[declined_services]  '524','2012-01-01','2013-01-01',6
*/

begin
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#declined') IS NOT NULL DROP TABLE #declined
IF OBJECT_ID('tempdb..#completed') IS NOT NULL DROP TABLE #completed


select
rd.ro_number
,rd.master_ro_header_id
,rd.op_code
,rd.op_code_desc
,rd.customer_comment
into #temp
from master.repair_order_header_detail rd (nolock) 
where rd.ro_number is not null
and parent_Dealer_id = @dealer
and (convert(date,convert(char(8),ro_closed_date))  between @FromDate and @ToDate)

select 
ro_number
,master_ro_header_id
,string_agg(op_code_desc,',') as dec_opcode_desc
,string_agg(op_code,',') as dec_opcodes
,string_agg(customer_comment,',') as dec_cust_comment
into #declined
from #temp t
where op_code like '%declined%' or customer_comment like '%declined%' or op_code_desc like '%declined%'
group by ro_number,master_ro_header_id
order by ro_number



select 
ro_number
,master_ro_header_id
,string_agg(op_code_desc,',') as comp_opcode_desc
,string_agg(op_code,',') as comp_opcodes
,string_agg(customer_comment,',') as comp_cust_comment
into #completed
from #temp
where op_code not like '%declined%' and customer_comment not like '%declined%' and op_code_desc not like '%declined%'
group by ro_number,master_ro_header_id
order by ro_number

IF OBJECT_ID('tempdb..#decl_comp') IS NOT NULL DROP TABLE #decl_comp

select c.ro_number,d.master_ro_header_id,dec_opcode_desc,dec_opcodes,dec_cust_comment,comp_opcode_desc,comp_opcodes,comp_cust_comment 
into #decl_comp
from #declined d inner join #completed c on c.ro_number = d.ro_number


select 
c.cust_full_name
,v.vin
,v.make
,v.model
,v.model_year
,rh.sa_number as service_advisor
,rd.ro_number
,rd.dec_opcode_desc as declined_opcodes
,rd.comp_opcodes as completed_opcodes
,convert(date,convert(char(8),rh.ro_close_date)) as ro_close_date
,rh.total_repair_order_price
from #decl_comp rd 
inner join master.repair_order_header rh (nolock) on rd.master_ro_header_id = rh.master_ro_header_id
inner join master.customer c (nolock) on rh.master_customer_id = c.master_customer_id
inner join master.vehicle v (nolock) on rh.master_vehicle_id = v.master_vehicle_id


end


USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[Master_Service_CustomerReport]    Script Date: 5/2/2022 2:34:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
  
ALTER PROCEDURE [reports].[Master_Service_CustomerReport]  

	--declare  
	@dealer_id varchar(20) = '3407',  
	@Customer_id varchar(30) = null,  
	@State varchar(30) = null,  
	@Zip varchar(20) = null,	
	@Email varchar(50)= null,  
	@Mobile_phone varchar(50) = null,  
	@model_year varchar(20) = 'All',  
	@make varchar(20)= 'FORD',  
	@model varchar(20) = 'All'   


AS    
/*  
exec [reports].[Master_Service_CustomerReport] '3407', null,null,null,null,null, 'All', 'All', 'All'  

*/ 
BEGIN    


	IF OBJECT_ID('tempdb..#temp_dealer') IS NOT NULL DROP TABLE #temp_dealer
	IF OBJECT_ID('tempdb..#temp_ro') IS NOT NULL DROP TABLE #temp_ro
	IF OBJECT_ID('tempdb..#temp_custvehicle') IS NOT NULL DROP TABLE #temp_custvehicle
	IF OBJECT_ID('tempdb..#t') IS NOT NULL DROP TABLE #t
	IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result



	select * into #temp_dealer from master.dealer with (nolock)

	select * into #temp_ro from master.repair_order_header a (nolock) where parent_dealer_id = @dealer_id and is_deleted = 0


	select 
			a.master_customer_id,
			a.master_vehicle_id, 
			a.active_date,
			b.cust_dms_number as customer_ID,  
			b.cust_first_name,  
			b.cust_last_name,  
			b.cust_address1,  
			b.cust_state_code,  
			b.cust_zip_code,  
			b.cust_email_address1,  
			b.cust_mobile_phone,
			c.model_year,  
			c.make,  
			c.model,  
			c.vin,
			a.last_sale_date
		into #temp_custvehicle
	from master.cust_2_vehicle a (nolock)
	inner join master.customer b (nolock) on a.master_customer_id = b.master_customer_id
	inner join master.vehicle c (nolock) on a.master_vehicle_id = c.master_vehicle_id
	where a.parent_dealer_id = @dealer_id and a.is_deleted = 0 and a.inactive_date is null
	and b.cust_full_name not like 'Unknown'


	CREATE NONCLUSTERED INDEX IX_PrtDlrID ON #temp_dealer(parent_dealer_id ASC)

	CREATE NONCLUSTERED INDEX IX_rohIdx ON #temp_ro(parent_dealer_id, master_customer_id, master_vehicle_id)
	
	declare  @unique_customers int

	select 
			cust_dms_number
	into #t
	from 
		#temp_ro m (nolock)  
	inner join #temp_dealer d (nolock) on m.parent_dealer_id = d.parent_dealer_id
	inner join #temp_custvehicle e on m.master_customer_id = e.master_customer_id and m.master_vehicle_id = e.master_vehicle_id
    
	where   
	 (@Customer_id is null or (@customer_id is not null and e.customer_ID = @Customer_id))   
	and (@State is null or (@State is not null and e.cust_state_code = @State))  
	and (@Zip is null or (@Zip is not null and e.cust_zip_code = @Zip))   
	and (@Email is null or (@Email is not null and e.cust_email_address1 = @Email))   
	and (@Mobile_phone is null or (@Mobile_phone is not null and e.cust_mobile_phone=@Mobile_phone))   
	and (@make = 'All' or (@make!='All'and e.make = @make ))  
	and (@model ='All'or (@model!='All'and e.model = @model))   
	and (@model_year='All' or(@model_year != 'All' and e.model_year=@model_year))   
	   	
	set @unique_customers = (select count(distinct(cust_dms_number)) from #t)

	select distinct  
		e.customer_ID,  
		row_number() over (partition by e.customer_ID order by m.ro_close_date desc) as rnk,
		e.cust_first_name,  
		e.cust_last_name,  
		e.cust_address1,  
		e.cust_state_code,  
		e.cust_zip_code,  
		e.cust_email_address1,  
		e.cust_mobile_phone,  
		m.ro_number,  
		convert(date,convert(char(8),m.ro_close_date)) as ro_close_date,
		e.model_year,  
		e.make,  
		e.model,  
		e.vin,  
		m.total_repair_order_price,  
		m.total_customer_labor_price,  
		m.total_customer_parts_price,  
		m.total_warranty_labor_price,  
		m.total_warranty_parts_price,  
		m.total_internal_labor_price,
		m.total_internal_parts_price,
		convert(date, convert(char(8), m.first_ro_date)) as first_ro_date,
		convert(date, convert(char(8), m.last_ro_date)) as last_ro_date,
		convert(date, convert(char(8), m.ro_open_date)) as ro_open_date,
		datediff(month,convert(date,convert(char(10),m.ro_close_date)),getdate()) as Last_service,  
		iif(datediff(month,convert(date,convert(char(10),m.ro_close_date)),getdate())between 6 and 12,1,null) as in_six_months,  
		iif(datediff(month,convert(date,convert(char(10),m.ro_close_date)),getdate())>12,1,null) as over_12_months,  
		@unique_customers as unique_customers,
		e.active_date,
		(select count(distinct vin ) from master.repair_order_header (nolock) where cust_dms_number = e.customer_ID and parent_dealer_id=@dealer_id) as current_veh_garrage,
		(case when e.last_sale_date is not null then 'Yes' else 'No' end) as sales_customer  

		into #result
	from 
		#temp_ro m (nolock)  
	inner join #temp_dealer d (nolock) on m.parent_dealer_id = d.parent_dealer_id
	inner join #temp_custvehicle e on m.master_customer_id = e.master_customer_id and m.master_vehicle_id = e.master_vehicle_id
    
	where   
	 (@Customer_id is null or (@customer_id is not null and e.customer_ID = @Customer_id))   
	and (@State is null or (@State is not null and e.cust_state_code = @State))  
	and (@Zip is null or (@Zip is not null and e.cust_zip_code = @Zip))   
	and (@Email is null or (@Email is not null and e.cust_email_address1 = @Email))   
	and (@Mobile_phone is null or (@Mobile_phone is not null and e.cust_mobile_phone=@Mobile_phone))   
	and (@make = 'All' or (@make!='All'and e.make = @make ))  
	and (@model ='All'or (@model!='All'and e.model = @model))   
	and (@model_year='All' or(@model_year != 'All' and e.model_year=@model_year))  

	

	select * from #result where rnk =1
	Order by customer_ID,ro_close_date desc  
    
  
  
END 


USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[MasterSalesCustomerReport]    Script Date: 5/2/2022 2:35:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER PROCEDURE [reports].[MasterSalesCustomerReport]    
 (   
 --declare    
 @dealer_id varchar(20) ='500',    
 @vehicle_condition varchar(10) = 'All' ,    
 @make varchar(20)  = 'All' ,    
 @model varchar(20) = 'All' ,    
 @model_year varchar(20) = 'All' ,    
 @cust_dms_number varchar(20) =null ,    
 @cust_zip varchar(50) = null,    
 @cust_last_name varchar(100) = null    
)    
 AS      
/*    
exec [reports].[MasterSalesCustomerReport]  '3407','N','All','All','All',null,null,null    
*/    
BEGIN    

   
  
 IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1    
 IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2    
   
 SELECT  --distinct    
			  c.cust_dms_number as Customer_ID,    
			  d.dealer_name,    
			  d.state as zip,    
			  [dbo].[CamelCase](c.cust_first_name) as cust_first_name,    
			  [dbo].[CamelCase](c.cust_full_name) as cust_full_name,   
			  [dbo].[CamelCase](c.cust_last_name) as Customer_Last_Name,    
			  c.cust_address1,    
			  c.cust_zip_code,    
			  c.cust_region,     
			  c.cust_state_code,    
			  c.cust_city,    
			  c.cust_district,    
			  iif(len(c.cust_mobile_phone)=0,c.cust_home_phone,c.cust_mobile_phone) as cust_mobile_phone,
			  v.make,    
			  v.model,    
			  v.model_year,    
			  v.last_sale_type,    
			  (case when s.nuo_flag = 'U' then 'Used'  
					 when s.nuo_flag ='N' then 'New'
					 when s.nuo_flag ='L' then 'Lease'
					 when s.nuo_flag = 'W' then 'Wholesale'
					else ltrim(rtrim(nuo_flag)) end) as vehicle_condition,    
			  (convert(date,convert(char(8),purchase_date))) AS purchaseDate,    
			  convert(date,convert(char(8),s.deal_date)) AS deal_date,    
			  s.sale_type,    
			  s.monthly_payment,    
			  s.total_of_payments,    
			  convert(date,convert(varchar(8),s.last_sale_date)) as last_sale_date,    
			  iif(len(c.cust_email_address1)=0,c.cust_email_address2,c.cust_email_address1) as cust_email_address1,    
			  s.deal_number_dms,    
			  convert(date,convert(varchar(10),c.last_activity_date)) as last_activity_date,    
			  iif(ltrim(rtrim(c.cust_state_code)) = ltrim(rtrim(d.state)), 'Yes' , 'No') as local_status,    
			  s.contract_term,    
			  --(Case when s.last_payment_date is not null then s.last_payment_date else DateDiff(Month, DateAdd(Month, s.contract_term, s.first_payment_date), getdate()) end) as balance_term,    
			 (Case when s.last_payment_date is not null then DateDiff(Month, getdate(), convert(date,convert(char(8),s.last_payment_date)))
					else DateDiff(Month, getdate(), DateAdd(Month, Cast(s.contract_term as int), (convert(date,convert(char(8),s.first_payment_date))))) end) as balance_term,
			  row_number() OVER (Partition by s.cust_dms_number order by s.purchase_date desc) as rnk,    
			  s.master_vehicle_id,    
			  v.vin,    
			  --datediff(month, getdate(), v.last_ro_date) as months_since_last_service    
			  datediff(month, convert(varchar(10), convert(date,(convert(varchar(10),Isnull(v.last_ro_date, s.purchase_date))), 111)),getdate()) as months_since_last_service    
 into   
  #temp1    
 from master.fi_sales s (NOLOCK)    
 inner join master.vehicle (NOLOCK) v on s.master_vehicle_id = v.master_vehicle_id    
 inner join master.customer (NOLOCK) c on s.master_customer_id = c.master_customer_id    
 inner join master.vehicle_makemodel m (nolock) on v.make = m.make and v.model = m.model and v.model_year = m.modelyear --added extra: model, model_year    
 inner join master.dealer (NOLOCK) d on s.natural_key = d.natural_key    
    
 where     
 --convert(date,(convert(varchar(10),purchase_date))) between @from_date AND @to_date     
 (@vehicle_condition = 'All' or (@vehicle_condition != 'All' and @vehicle_condition = (Case when nuo_flag ='Used' then 'U'  
																							when nuo_flag = 'New' then 'N'  
																							else nuo_flag end)))    
 --AND (@sale_type = 'All' or (@sale_type != 'All'and @sale_type = sale_type))     
 AND (@make = 'All' or (@make != 'All' and @make = v.make))    
 AND (@model='All' or (@model != 'All' and @model = v.model))    
 AND (@model_year = 'All' or (@model_year ! = 'All' and @model_year = model_year))    
 AND (@cust_dms_number is NULL or (@cust_dms_number is not null and c.cust_dms_number = @cust_dms_number))    
 AND (@cust_zip is null or (@cust_zip is not null and c.cust_zip_code = @cust_zip))    
 AND (@cust_last_name is null or (@cust_last_name is not null and (case when c.customer_type = 'B' then c.cust_first_name else c.cust_last_name end) = @cust_last_name))    
 
 AND d.parent_dealer_id = @dealer_id     
 AND s.deal_status in ('Finalized', 'Sold', 'Booked','Booked/Recapped')
    
    
  select     
  customer_ID, count(distinct vin) as cc    
  into #temp2    
  from #temp1 a    
  group by customer_ID    
    
  select distinct t1.*,    
  t2.cc as less_than_5yrs    
  from    
  #temp1 t1 inner join #temp2 t2 on t1.customer_ID = t2.customer_ID    
  where t1.rnk = 1    
  order by t2.cc desc    
    
END

USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[MasterSalesCustomerReport_New]    Script Date: 5/2/2022 2:36:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec [reports].[MasterSalesCustomerReport_New]  '500','2010-01-01','2021-01-01','All','All','All','All',null,null
*/
ALTER PROCEDURE [reports].[MasterSalesCustomerReport_New]


 --declare
 @dealer_id varchar(20) ='500',
 @from_date date = '2010-01-01',
 @to_date date ='2021-01-01',
 @vehicle_condition varchar(10) = 'All' ,
 --@sale_type varchar(50)  = 'All' ,
 @make varchar(20)  = 'All' ,
 @model varchar(20) = 'All' ,
 @model_year varchar(20) = 'All' ,
 @cust_dms_number varchar(20) =null ,
 @cust_zip varchar(50) = null

 AS  

BEGIN
 IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
  IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2
SELECT  c.cust_dms_number as Customer_ID,
		d.dealer_name,
		d.state as zip,
		c.cust_first_name,
		c.cust_full_name,
		c.cust_last_name as Customer_Last_Name,
		c.cust_address1,
		c.cust_zip_code,
		c.cust_region, 
		c.cust_state_code,
		c.cust_city,
		c.cust_district,
		c.cust_mobile_phone,
		v.make,
		v.model,
		v.model_year,
		v.last_sale_type,
		case when s.nuo_flag ='N' then 'New' 
		when s.nuo_flag ='U' then 'Used' 
		else s.nuo_flag end as vehicle_condition,
		replace(convert(varchar(10), convert(date,(convert(varchar(10),purchase_date)), 111)),'/','-') AS purchaseDate,
		replace(convert(varchar(10), convert(date,(convert(varchar(10),s.deal_date)), 111)),'/','-') AS deal_date,
		s.sale_type,
		s.monthly_payment,
		s.total_of_payments,
		replace(convert(varchar(10), convert(date,(convert(varchar(10),s.last_sale_date)), 111)),'/','-') as last_sale_date,
		c.cust_email_address1,
		s.deal_number_dms,
		replace(convert(varchar(10), convert(date,(convert(varchar(10),first_payment_date)), 111)),'/','-') as FirstPaymentdate,
		iif(ltrim(rtrim(c.cust_state_code)) = ltrim(rtrim(d.state)), 'Yes' , 'No') as local_status,
		s.contract_term,
	    datediff(month,convert(date,convert(varchar(20),purchase_date)),getdate()) as balance_term,
		row_number() OVER (Partition by s.cust_dms_number order by s.purchase_date desc) as rnk,
		s.master_vehicle_id,
		v.vin,
		--datediff(month, getdate(), v.last_ro_date) as months_since_last_service
		datediff(month, getdate(), convert(varchar(10), convert(date,(convert(varchar(10),v.last_ro_date)), 111))) as months_since_last_service
		into #temp1
		from master.fi_sales s (NOLOCK)
		inner join master.dealer (NOLOCK) d on s.natural_key = d.natural_key
		inner join master.vehicle (NOLOCK) v on s.master_vehicle_id = v.master_vehicle_id
		inner join master.customer (NOLOCK) c on s.master_customer_id = c.master_customer_id

	where 
	convert(date,(convert(varchar(10),purchase_date))) between @from_date AND @to_date 
	AND (@vehicle_condition = 'All' or (@vehicle_condition != 'All' and @vehicle_condition = nuo_flag))
	--AND (@sale_type = 'All' or (@sale_type != 'All'and @sale_type = sale_type)) 
	AND (@make = 'All' or (@make != 'All' and @make = make))
	AND (@model='All' or (@model != 'All' and @model = model))
	AND (@model_year = 'All' or (@model_year ! = 'All' and @model_year = model_year))
	AND (@cust_dms_number is NULL or (@cust_dms_number is not null and c.cust_dms_number = @cust_dms_number))
	AND (@cust_zip is null or (@cust_zip is not null and c.cust_zip_code = @cust_zip))
	AND d.parent_dealer_id = @dealer_id 


	select 
	customer_ID, count(distinct vin) as cc
	into #temp2
	from #temp1 a
	group by customer_ID

	select distinct t1.*,
	t2.cc as less_than_5yrs
	from
	#temp1 t1 inner join #temp2 t2 on t1.customer_ID = t2.customer_ID
	where t1.rnk = 1
	order by t2.cc desc

END  


USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[sale_without_servicesale_without_service]    Script Date: 5/2/2022 2:46:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure  [reports].[sale_without_servicesale_without_service]

@dealer_id varchar(4000) = '500,144,157,51,170,181,184,290,317,216,70',
@FromDate date = '2011-01-01',
@ToDate date ='2012-01-01'
--@DateRange int =1

as 
/*
	exec [reports].[sale_without_service]  1806,'1/1/2021','10/5/2021'
*/
begin
select distinct
s.vin--, rh.vin
,s.parent_dealer_id
,s.cust_dms_number
,isnull(c.cust_full_name,c.cust_first_name + c.cust_last_name) as customer_fullname
,c.cust_city 
,s.deal_number_dms as sale_id
,convert(date,convert(char(8),s.purchase_date)) as deal_date
,isnull(vehicle_cost,0) as sale_value
,d.dealer_name
from master.fi_sales s (nolock) inner join master.customer c (nolock) on s.master_customer_id = c.master_customer_id
inner join master.dealer d (nolock) on s.parent_dealer_id = d.parent_dealer_id
left outer join master.repair_order_header rh (nolock) on s.master_vehicle_id = rh.master_vehicle_id
 where rh.vin is null 
and convert(date,convert(char(8),s.purchase_date)) between @FromDate and @ToDate
and s.parent_dealer_id in (select value from [dbo].[fn_split_string_to_column] (@dealer_id, ','))
order by s.cust_dms_number
end



USE [clictell_auto_master]
GO
/****** Object:  StoredProcedure [reports].[sales_trend_monthly_latest]    Script Date: 5/2/2022 2:48:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--/****** Object:  StoredProcedure [reports].[sales_trend_monthly]    Script Date: 28-05-2021 11:45:21 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

ALTER Procedure [reports].[sales_trend_monthly_latest]  
( 

 @Startdate date ,
 @Enddate date,
 @dealer_id int ,
 @DateRange int 
)  
as   
--/*  
  
   exec [reports].[sales_trend_monthly_latest] '2021-01-01', '2021-06-24', '1806', 1 



-- select * from master.fi_sales (nolock) where purchase_date between 20210101 and 20210131
  
--*/  
begin  
  
set nocount on  
  
 DECLARE     
      @start DATE = @Startdate   
    , @end DATE = @Enddate  
	 
  if @DateRange=1
 
 with  ctem as (
 Select    
  --case when nuo_flag = 'N' then 'New' else case when nuo_flag='U' then 'Used'else   nuo_flag end end as [Vehicle Status],    
  Ltrim(Rtrim(nuo_flag)) as [Vehicle condition],  
  month(((CONVERT (datetime,convert(char(8),[purchase_date] ))))) as month_no ,  
  cast(Year(CONVERT (datetime,convert(char(8),[purchase_date] ))) as varchar(4)) as year_no,  
   CONVERT (date,convert(char(8),[purchase_date] ))    as MYear,  
  Count(Nuo_flag) as [Count]  
 
 from    
  [master].[fi_sales] with (nolock)  
 Where   
 parent_dealer_id = @dealer_id  
  and Ltrim(Rtrim(nuo_flag)) in ('New','Used')  
  and (CONVERT (date,convert(char(8),[purchase_date] )) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE))  
  and deal_status in ('Sold', 'Finalized', 'Booked')  
 group by     
  Ltrim(Rtrim(nuo_flag)),   
  month(((CONVERT (datetime,convert(char(8),[purchase_date] )))))  ,  
  cast(Year(CONVERT (datetime,convert(char(8),[purchase_date] ))) as varchar(4)),  
   CONVERT (date,convert(char(8),[purchase_date] ))    
)
  select month_no, Year_no, Isnull([Vehicle condition], '') as [Vehicle_Status],  cast(MYear as varchar(10)) as MYear, Isnull([Count],0) as [Count]  
from ctem
  else 
     
 WITH cte AS     
 (    
  SELECT dt = DATEADD(DAY, -(DAY(@start) - 1), @start)    
  UNION ALL    
  SELECT DATEADD(MONTH, 1, dt)    
  FROM cte    
  WHERE dt < DATEADD(DAY, -(DAY(@end) - 1), @end)    
 )    
 SELECT Year(dt) as Year_no, DATENAME(MONTH,dt) as [Name], MONTH(dt) as MonthId  into #temp1   
 FROM cte   
   if @DateRange<>1
   select *, 'New' as [Vehicle condition] into #temp3 from #temp1  
 Union  
 select *, 'Used' as [Vehicle condition] from #temp1  
  if @DateRange<>1
 Select    
  --case when nuo_flag = 'N' then 'New' else case when nuo_flag='U' then 'Used'else   nuo_flag end end as [Vehicle Status],    
  Ltrim(Rtrim(nuo_flag)) as [Vehicle condition],  
  month(((CONVERT (datetime,convert(char(8),[purchase_date] ))))) as month_no ,  
  cast(Year(CONVERT (datetime,convert(char(8),[purchase_date] ))) as varchar(4)) as year_no,  
  datename(month,((CONVERT (datetime,convert(char(8),[purchase_date] ))))) +' '+  
  cast(Year(CONVERT (datetime,convert(char(8),[purchase_date] ))) as varchar(4))  as MYear,  
  Count(Nuo_flag) as cc  
 into #temp2  
 from    
  [master].[fi_sales] with (nolock)  
 Where   
   parent_dealer_id = @dealer_id  
  and Ltrim(Rtrim(nuo_flag)) in ('New','Used')  
  and (CONVERT (date,convert(char(8),[purchase_date] )) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE))  
  and deal_status in ('Sold', 'Finalized', 'Booked')  
 group by     
  Ltrim(Rtrim(nuo_flag)),   
  month(((CONVERT (datetime,convert(char(8),[purchase_date] )))))  ,  
  cast(Year(CONVERT (datetime,convert(char(8),[purchase_date] ))) as varchar(4)),  
  datename(month,((CONVERT (datetime,convert(char(8),[purchase_date] ))))) +' '+  
  cast(Year(CONVERT (datetime,convert(char(8),[purchase_date] ))) as varchar(4))   
 order by    
  year_no ,month_no  
  if @DateRange<>1
 select a.MonthId as month_no, a.Year_no, Isnull(a.[Vehicle condition], '') as [Vehicle_Status],  [Name] + ' ' +  Cast(a.Year_no as varchar(5)) as MYear, Isnull(b.cc,0) as [Count]  
 from #temp3 a  
 left outer join #temp2 b on a.Year_no = b.year_no and a.MonthId = b.month_no and a.[Vehicle condition] = b.[Vehicle condition]  
 Order by a.Year_no, month_no  

end

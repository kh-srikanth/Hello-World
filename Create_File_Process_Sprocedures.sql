use [clicktell_auto_etl]
go
CREATE PROCEDURE etl.sp_file_process_insert   
AS  
/*  
-- =============================================  
-- Author:  Santhsoh Boddeda  
-- Create date: 2020-10-05  
-- Description: To Create a new entry for file process.  
  
EXEC etl.sp_file_process_insert  
  
-- =============================================  
*/  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
 Declare @processed_id int  
 Insert into [etl].[etl_process](process_date) values(getdate())  
 set @processed_id = SCOPE_IDENTITY()  
 select @processed_id  
END  
GO

CREATE PROCEDURE etl.sp_file_process_details_insert   
(  
 @process_id int,  
 @file_name varchar(100),  
 @file_path varchar(250)  
)  
AS  
/*  
-- =============================================  
-- Author:  Santhsoh Boddeda  
-- Create date: 2020-10-05  
-- Description: To Create a new entry for file process.  
  
EXEC etl.sp_file_process_insert  
  
-- =============================================  
*/  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
 Declare @file_process_detail_id int
 Insert into [etl].[file_process_details](process_id,[file_name],full_file_path)  
 values(@process_id,@file_name,@file_path + '\' + @file_name)  
 set @file_process_detail_id = SCOPE_IDENTITY()  
 select @file_process_detail_id  
END  
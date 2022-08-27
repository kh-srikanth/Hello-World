use clictell_auto_master
go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter PROCEDURE [master].[unique_customer_table_load]
@file_process_id int

AS

BEGIN
		drop table if exists #cust1
		drop table if exists #master_customer

		--load master.customer data into temp table
		select * into #master_customer from master.customer (nolock) where file_process_id = @file_process_id

		--insert data into master.unique_customer from master.customer WHILE ELIMINATING DATA WITHOUT first_name or WITHOUT email,address,mobile // Avoid Duplicate also
		insert into master.unique_customer 
				(cust_dms_number,master_customer_id,unique_cust_id,first_name,last_name
				,email,mobile,address,parent_dealer_id,file_process_id)
		select 
				a.cust_dms_number,a.master_customer_id,null,trim(a.cust_first_name) ,trim(a.cust_last_name) 
				,trim(a.cust_email_address1),trim(a.cust_mobile_phone), a.cust_address1,a.parent_dealer_id,a.file_process_id
		from #master_customer a (nolock) 
		left outer join master.unique_customer b (nolock) --Avoid Duplicate insert
				on a.parent_dealer_id = b.parent_dealer_id 
				and a.master_customer_id = b.master_customer_id 
		where	
				b.cust_id is null -- avoid duplicate insert
				and (len(a.cust_first_name) <> 0 or (len(a.cust_address1) <> 0 and len(a.cust_mobile_phone) <> 0 and len(a.cust_email_address1) <> 0))

		--update data for records with existing master_customer_id 
		update a set

				a.cust_dms_number = b.cust_dms_number,
				a.first_name = b.cust_first_name,
				a.last_name = b.cust_last_name,
				a.address = b.cust_address1,
				a.mobile = b.cust_mobile_phone,
				a.updated_dt = getdate(),
				a.updated_by = SUSER_NAME(),
				a.file_process_id = b.file_process_id

			from master.unique_customer a (nolock)
		inner join #master_customer b (nolock) on a.parent_dealer_id = b.parent_dealer_id and a.master_customer_id = b.master_customer_id

		--identifying customers with UNIQUE first_name,last_name,address,email,mobile and insert the data into new temp table #cust1

		select *, ROW_NUMBER() over (partition by first_name, last_name, address order by file_process_id desc,cust_id desc) as rnk
		into #cust1 from master.unique_customer (nolock) a 

		--setting unique_cust_id = cust_id for UNIQUE CUSTOMERS in #cust1
		update #cust1 set unique_cust_id = cust_id where rnk=1

		/*joining #cust1 to #customers with same [mobile or email or address] and with same [first_name and last_name] and assigning same unique_cust_id to UNIQUE CUSTOMER*/

		update b set b.unique_cust_id =a.unique_cust_id
		from #cust1 a 
		inner join master.unique_customer (nolock) b 
				on a.rnk=1 
				and (
						(a.first_name = b.first_name and a.last_name = b.last_name and replace(a.mobile,'-','') = replace(b.mobile,'-','') and len(b.mobile) <> 0) 
						or 
						(a.first_name = b.first_name and a.last_name = b.last_name and a.email = b.email and len(b.email) <> 0) 
						or 
						(a.first_name = b.first_name and a.last_name = b.last_name and a.address = b.address and len(b.address) <> 0) 
					)

		---update the rest of the customers unique_cust_id "without mobile and email and address" with cust_id
		update master.unique_customer set unique_cust_id = cust_id where len(email)=0 and len(mobile)=0 and len(address)=0

END



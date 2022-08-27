drop table if exists #customer_customers
select top 10 * into #customer_customers from auto_customers.customer.customers (nolock)
truncate table #customer_customers
select * from #customer_customers
alter table #customer_customers drop column customer_id
alter table #customer_customers add customer_id int identity(1,1)
alter table #customer_customers add constraint df_guid default(newid()) for customer_guid 
alter table #customer_customers add constraint df_1 default(0) for is_email_bounce
alter table #customer_customers add constraint df_2 default(0) for is_welcome_email_sent
alter table #customer_customers add constraint df_3 default(0) for is_deleted
alter table #customer_customers add constraint df_8 default(0) for is_web_landing

alter table #customer_customers add constraint df_4 default(getdate()) for created_dt
alter table #customer_customers add constraint df_5 default(getdate()) for updated_dt
alter table #customer_customers add constraint df_6 default(suser_name()) for created_by
alter table #customer_customers add constraint df_7 default(suser_name()) for updated_by


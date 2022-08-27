
--ADD new columns in customer.customer
alter table auto_customers.customer.customers add  src_cust_id int
alter table auto_customers.customer.customers add  customer_type varchar(50)

--ADD new columns in customer.vehicle
alter table auto_customers.customer.vehicles add src varchar(20)
alter table auto_customers.customer.vehicles add deal_status varchar(50)
alter table auto_customers.customer.vehicles add is_active bit default 1

--ALTER columns in customer.vehicle
alter table auto_customers.customer.vehicles alter column exterior_color varchar(30)
alter table auto_customers.customer.vehicles alter column sale_classs varchar(30)


select a.vin,a.customer_id,a.is_active,delivery_date,* from auto_customers.customer.vehicles a(nolock) where account_id = '2FBFFF86-50E3-40F6-B59D-8335327E6BB1' order by a.vin
select * from auto_customers.customer.customers (nolock) where account_id = '2FBFFF86-50E3-40F6-B59D-8335327E6BB1' 


select * from auto_campaigns.campaign.campaign_run a (nolock)

select * from clictell_auto_etl.etl.file_process_details (nolock) order by process_start_date desc


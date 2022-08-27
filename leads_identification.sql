select * 
--update a set is_subscriber =1,updated_by = 'subscriber_update_sk',updated_dt = getdate()
from auto_customers.customer.customers a (nolock) where is_deleted =0 and account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150' and isnull(is_subscriber,0) =0 and r2r_customer_id is not null

select * from auto_customers.customer.customers (nolock) 
where is_deleted =0 
and account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150' 
and isnull(is_subscriber,0) =0
and r2r_customer_id is not null
and lead_status_id is not null

select * from auto_crm.lead.status (nolock) where account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150'  and status_type_id = 1 and status = 'New Lead'
select * from auto_crm.lead.status (nolock) where account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150'  and status_type_id = 2 and status = 'New Customers'


--Sales CRM ---customers list SP: [customer].[get_customers_by_account_id] 
select lead_status_id,first_name,last_name,primary_email,primary_phone_number,secondary_phone_number--,make,model,year
from auto_customers.customer.customers (nolock) 
where is_deleted =0 
and account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150' 
and isnull(is_subscriber,0) =0 
and isnull(is_bdc,0) =0 
--and lead_status_id in (select status_id from auto_crm.lead.status (nolock) where account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150'  and status_type_id = 1 and is_deleted=0)


--service_CRM  --Customer list SP: [lead].[get_leads_by_account_id]
select lead_status_id,* from auto_customers.customer.customers (nolock) 
where is_deleted =0 
and account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150' 
and is_subscriber =1 
and ISNULL([is_bdc], 0) = 0  
and lead_status_id    in (select status_id from auto_crm.lead.status (nolock) where account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150'  and status_type_id = 2 and is_deleted=0)


--customers Marketing
select lead_status_id,[is_bdc],* from auto_customers.customer.customers (nolock) 
where is_deleted =0 
and account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150' 
and is_subscriber =1 ---and lead_status_id not in (select status_id from auto_crm.lead.status (nolock) where account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150' and is_deleted =0)



--Identifying customers with full form data
select a.customer_id,lead_status_id,first_name,last_name,primary_email,primary_phone_number,secondary_phone_number,make,model,year
from auto_customers.customer.customers a (nolock) 
inner join auto_customers.customer.vehicles b (nolock) on a.customer_id  = b.customer_id
where a.is_deleted =0 and b.is_deleted =0
	and a.account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150' 
	and isnull(a.is_subscriber,0) =0 
	and isnull(a.is_bdc,0) =0 
	and len(isnull(make,'')) > 0 
	and len(isnull(model,'')) > 0
	and (len(isnull(primary_phone_number,'')) > 0 or len(isnull(secondary_phone_number,'')) > 0)
	and len(isnull(primary_email,'')) > 0

order by first_name,last_name,primary_phone_number,secondary_phone_number,make,model,year desc


select 
a.account_id,b.accountname,is_subscriber,count(*) as counts 
from auto_customers.customer.customers a (nolock) 
inner join auto_customers.portal.account b with (nolock) on upper(a.account_id) = upper(b._id) and b.parentid  = 'C994B4F4-666E-446B-9A2F-C4985EBEA150'
where is_deleted =0 
group by b.accountname,a.account_id,is_subscriber
order by b.accountname,is_subscriber

select top 10 * from auto_customers.portal.account b with (nolock) where b.parentid  = 'c994b4f4-666e-446b-9a2f-c4985ebea150'


select is_subscriber,count(*) from auto_customers.customer.customers a (nolock) where is_deleted =0 and account_id = 'F0590E45-19AA-4597-A2B5-67553DD7B113' group by is_subscriber

--soft deleted salesCRM leads
select lead_status_id,first_name,last_name,primary_email,primary_phone_number,secondary_phone_number
--update a set is_deleted =1,updated_by = 'sk_clean',updated_dt = getdate()
from auto_customers.customer.customers a (nolock) 
where is_deleted =0 
and account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150' 
and isnull(is_subscriber,0) =0 and isnull(is_bdc,0) =0 
and customer_id not in (37860,37863,3429805,3445902,3463431,3623317,3623318,3623319,3623320,3623321,3623322,3623323,3623324,3623325,3623326,3623327,3623328,3623329,3623330,3623331)






--service_CRM
select a.customer_id,lead_status_id,first_name,last_name,primary_email,primary_phone_number,secondary_phone_number,make,model,year
from auto_customers.customer.customers a (nolock) 
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id  = b.customer_id and b.is_deleted =0

where a.is_deleted =0 
and a.account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150' 
and a.is_subscriber =1 
and  ISNULL([is_bdc], 0) = 0  
and lead_status_id    in (select status_id from auto_crm.lead.status (nolock) where account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150'  and status_type_id = 2 and is_deleted=0)



--Identifying customers with full form data
select a.customer_id,lead_status_id,first_name,last_name,primary_email,primary_phone_number,secondary_phone_number
from auto_customers.customer.customers a (nolock) 
where a.is_deleted =0 
	and a.account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150' 
	and isnull(a.is_subscriber,0) =0 
	and isnull(a.is_bdc,0) =0 
	--and len(isnull(make,'')) > 0 
	--and len(isnull(model,'')) > 0
	and (len(isnull(primary_phone_number,'')) > 0 or len(isnull(secondary_phone_number,'')) > 0)
	and len(isnull(primary_email,'')) > 0


--verifying data
select a.customer_id,lead_status_id,first_name,last_name,primary_email,primary_phone_number,secondary_phone_number,make,model,year
from auto_customers.customer.customers a (nolock) 
left outer join auto_customers.customer.vehicles b (nolock) on a.customer_id  = b.customer_id and b.is_deleted =0
where a.is_deleted =0 
and a.account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150' 
and a.is_subscriber =1 
and  ISNULL([is_bdc], 0) = 0  
and lead_status_id    in (select status_id from auto_crm.lead.status (nolock) where account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150'  and status_type_id = 2 and is_deleted=0)
and a.customer_id in (40327,3427462,3427464,3429807,3427463,3566478,3566478,3623945,3623879,3623910,3623923,3624015,3623943,3623944,3624017,3623902,3623912,3623986,3624008,3623892)
order by make desc,model desc,year desc


--soft deleted serviceCRM leads
select lead_status_id,* 
--update a set is_deleted = 1,updated_by ='sk_clean',updated_dt = getdate()
from auto_customers.customer.customers a (nolock) 
where a.is_deleted =0 
and a.account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150' 
and a.is_subscriber =1 
and  ISNULL([is_bdc], 0) = 0  
and a.lead_status_id    in (select status_id from auto_crm.lead.status (nolock) where account_id  = 'c994b4f4-666e-446b-9a2f-c4985ebea150'  and status_type_id = 2 and is_deleted=0)
and a.customer_id not in (40327,3427462,3427464,3429807,3427463,3566478,3566478,3623945,3623879,3623910,3623923,3624015,3623943,3623944,3624017,3623902,3623912,3623986,3624008,3623892)

---D2
select * 
--update a set is_subscriber =  1, updated_by = 'sk_lead_cust', updated_dt = getdate()
from auto_customers.customer.customers a (nolock)
where is_Deleted =0
and account_id  = 'D51E5DA3-9099-42C6-B311-DE6BBC9D825C'
and is_subscriber is null

select * from auto_customers.portal.account b with (nolock) where _id  = 'D51E5DA3-9099-42C6-B311-DE6BBC9D825C'


--lonestar
select * 
--update a set is_subscriber =  1, updated_by = 'sk_lead_cust', updated_dt = getdate()
from auto_customers.customer.customers a (nolock)
where is_Deleted =0
and account_id  = '2928EACC-A39D-4743-BF02-F9689F16E79F'
and is_subscriber is null

select * from auto_customers.portal.account b with (nolock) where _id  = '2928EACC-A39D-4743-BF02-F9689F16E79F'

--Brothers

select * 
--update a set is_subscriber =  1, updated_by = 'sk_lead_cust', updated_dt = getdate()
from auto_customers.customer.customers a (nolock)
where is_Deleted =0
and account_id  = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'
and is_subscriber is null

select * from auto_customers.portal.account b with (nolock) where _id  = 'AEACFC4E-FADA-4FA1-A24D-EACED71020BB'


select top 10  is_bdc,* from auto_customers.customer.customers (nolock)


--alter table auto_stg_customers.customer.customers add constraint df_is_bdc default ((0)) for is_bdc
--alter table auto_stg_customers.customer.customers drop constraint [DF__customers__is_bd__34B3CB38]
--alter table auto_customers.customer.customers alter column is_bdc bit set default ((0))


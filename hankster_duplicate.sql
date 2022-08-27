select * from auto_customers.customer.customers (nolock) where account_id = '489436CB-731A-4647-A26F-24BBD7034D28' and primary_email = '3warnes@sbcglobal.net'

select * from auto_customers.portal.account with (nolock) where accountname like 'hank%'


drop table if exists #temp
select 
	customer_id,first_name,last_name,primary_phone_number,secondary_phone_number,primary_email,list_ids,created_dt
	into #temp
from auto_customers.customer.customers (nolock) 
where is_Deleted =0 and account_id = '489436CB-731A-4647-A26F-24BBD7034D28' 
	and primary_email is not null
	
use auto_customers
drop table if exists #temp1
select *
,ROW_NUMBER() over (partition by primary_email order by primary_phone_number desc) as rnk 
into #temp1
from #temp 
order by primary_email

drop table if exists #lists
select * into #lists from #temp1 where primary_email in (
select primary_email from #temp1 where rnk =2 and primary_phone_number is null )



--select *  --863
--update a set is_deleted =1, updated_by = 'sk_dupli_del',updated_dt = getdate()
--from auto_customers.customer.customers a (nolock) where customer_id in (
--select customer_id from #lists where rnk >1 
--)
select primary_email,string from #lists 

--select * from #cat_list
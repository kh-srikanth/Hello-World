use clictell_auto_master
go

drop table if exists #customer
drop table if exists #cust1

--create temp table #customer

create table #customer 
(
	 cust_id int identity(1,1) not null primary key
	,cust_dms_number varchar(20)
	,master_customer_id int
	,unique_cust_id int
	,first_name varchar(250)
	,last_name varchar(250)
	,address varchar(250)
	,email varchar(100)
	,mobile varchar(12)
)


--insert data into #customer from master.customer WHILE ELIMINATING DATA WITHOUT first_name or WITHOUT email,address,mobile
insert into #customer 
		(cust_dms_number,master_customer_id,unique_cust_id,first_name,last_name,email,mobile,address)
select cust_dms_number,master_customer_id,null,trim(cust_first_name) ,trim(cust_last_name) 
,trim(cust_email_address1),trim(cust_mobile_phone), cust_address1
from master.customer (nolock) where parent_dealer_id =1806 and (len(cust_first_name) <> 0 or (len(cust_address1) <> 0 and len(cust_mobile_phone) <> 0 and len(cust_email_address1) <> 0))


--identifying customers with UNIQUE first_name,last_name,address,email,mobile and insert the data into new temp table #cust1

select *, ROW_NUMBER() over (partition by first_name,last_name , address, email, mobile order by cust_id) as rnk
into #cust1 from #customer a 

--setting unique_cust_id = cust_id for UNIQUE CUSTOMERS in #cust1
update #cust1 set unique_cust_id = cust_id where rnk=1


-- joining #cust1 to #customers with same [mobile or email or address] and with same [first_name and last_name]
-- and assigning same unique_cust_id to UNIQUE CUSTOMER

-- select a.cust_id,a.unique_cust_id,b.cust_id,b.unique_cust_id,a.first_name,a.last_name
update b set b.unique_cust_id =a.unique_cust_id
from #cust1 a 
inner join #customer b 
		on a.rnk=1 --and len(a.mobile) <> 0 and len(a.email) <> 0
		and (
				(a.first_name = b.first_name and a.last_name = b.last_name and replace(a.mobile,'-','') = replace(b.mobile,'-','') and len(b.mobile) <> 0) 
				or 
				(a.first_name = b.first_name and a.last_name = b.last_name and a.email = b.email and len(b.email) <> 0) 
				or 
				(a.first_name = b.first_name and a.last_name = b.last_name and a.address = b.address and len(b.address) <> 0) 
			)


---update the rest of the customers unique_cust_id without mobile and email and address with cust_id
update #customer set unique_cust_id = cust_id where len(email)=0 and len(mobile)=0 and unique_cust_id is null

----result
select * from #customer order by first_name,last_name,address,email


/*
----/*testing*/


select * from #customer --order by first_name,last_name,address,email 
--where unique_cust_id is null 
--where first_name = 'Aaron' and last_name = 'Franco'
order by first_name,last_name,address,email 

select * from #customer where unique_cust_id is null order by first_name, last_name

select * from #customer where first_name  = 'Alex' order by last_name

select * from #customer where unique_cust_id = 28172
select * from #customer where 
first_name = 'Alex'  and last_name ='Encarnacion-Lara'
--first_name  = 'Abel','Abhishek'
--first_name = 'Abhilash' and last_name  = 'Raval'
--first_name = 'Abhishek' and last_name  = 'Gupta'
--first_name = 'Abid' and last_name  = 'Rajput'
 */
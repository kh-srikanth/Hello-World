use clictell_auto_master
go

IF OBJECT_ID('tempdb..#customer') IS NOT NULL DROP TABLE #customer 
IF OBJECT_ID('tempdb..#cust1') IS NOT NULL DROP TABLE #cust1

create table #customer 
(
	 cust_id int identity(1,1) not null primary key
	,cust_dms_number varchar(20)
	,master_customer_id int
	,unique_cust_id int
	,first_name varchar(250)
	,last_name varchar(250)
)

insert into #customer (cust_dms_number,master_customer_id,unique_cust_id,first_name,last_name)
values (11,12,null,'asdf','qwer'),(33,14,null,'asdf','qwer'),(44,10,null,'qaz','wsx'),(55,15,null,'thn','qwer'),(66,16,null,'qaz','wsx')

select *, ROW_NUMBER() over (partition by first_name,last_name order by cust_id) as rnk
into #cust1 from #customer

update #cust1 set unique_cust_id = cust_id where rnk=1

--select a.cust_id,a.unique_cust_id,b.cust_id,b.unique_cust_id,a.first_name,a.last_name
update b set b.unique_cust_id =a.unique_cust_id
from #cust1 a 
inner join #customer b 
		on a.first_name = b.first_name and a.last_name =b.last_name and a.rnk=1

select * from #cust1
select * from #customer


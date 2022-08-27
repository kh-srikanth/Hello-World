select list_id,list_name
--update a set is_deleted =1, updated_by=suser_name(),updated_dt=getdate()
from auto_customers.list.lists a (nolock) where account_id = 'aeacfc4e-fada-4fa1-a24d-eaced71020bb'  and
is_deleted =0 and
 list_name not in (
'All Contacts'
,'App Users'
,'All SMS Subscribers'
,'All Email Subscribers'
,'Bike Clubs'
,'Texas.Dealers'
,'Harley Dealers'
,'Non Harley Dealers'
,'Trike Dealers'
,'Triumph Dealers'
,'Indian MC Dealers'
,'BMW_PS_list'
,'Master_Dealers_List'
,'Generate over 100 Used Harley Leads'
,'Suppression List'
,'Ducati_List_14_01_2020'
,'Kawasaki_20_01_2021'
,'Master_Newsletter_List'
,'Trike Dealer'
,'Yamaha_01_Jun_21'
,'NL_Harley_Dealer_Kawasaki_02_06_21'
,'Dev_Internal'
,'External_Seed_List'
)


select list_id,list_name
--update a set is_deleted =1, updated_by=suser_name(),updated_dt=getdate()
from auto_customers.list.lists a (nolock) where account_id = 'aeacfc4e-fada-4fa1-a24d-eaced71020bb'  and
is_deleted =0 
 list_name  like 'Seed List'

 select * from auto_customers.customer.segments (nolock) where account_id = 'aeacfc4e-fada-4fa1-a24d-eaced71020bb'  and is_deleted =0

 select * 
 update a set is_deleted =1, updated_by=suser_name(),updated_dt=getdate()
 from auto_campaigns.email.campaigns a (nolock) where account_id = 'aeacfc4e-fada-4fa1-a24d-eaced71020bb'  and is_deleted =0 and 
 campaign_id in (22265,22264,22227,22273,22226	)


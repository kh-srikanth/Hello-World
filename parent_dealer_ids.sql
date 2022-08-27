use clictell_auto_master
go
--3.140.33.104
select parent_dealer_id, dealer_name from master.dealer (nolock) where parentid = @ParentDealer

select * from master.dealer (nolock) where _id ='713B95A3-BD3E-11EB-B976-0A4357799CFA'--'24BF2DC4-BD3E-11EB-B972-0A4357799CFA'--'713B95A3-BD3E-11EB-B976-0A4357799CFA'--'E26CE42E-BD40-11EB-B988-0A4357799CFA'
select * from master.dealer (nolock) where dealer_name like 'greenwich%'

'7113589E-B6E0-11EB-82D4-0A4357799CFA' --Greenwich
'E26CE42E-BD40-11EB-B988-0A4357799CFA' -- District E
'713B95A3-BD3E-11EB-B976-0A4357799CFA'-- Zone 05

'24BF2DC4-BD3E-11EB-B972-0A4357799CFA' -- Eastern

'3397D8EA-BD3A-11EB-845D-0A4357799CFA'  --Honda --parent_Dealer_id =1811

select * from master.dealer (nolock) where parentid ='E26CE42E-BD40-11EB-B988-0A4357799CFA'


-----3.23.227.224
select * from master.dealer (nolock) where parent_dealer_id=681   
select * from master.dealer (nolock) where parentid ='93D00129-A276-49FF-BFEB-8C80B5443B72' and accountstatus='active'


--_id='B38E89BA-BC34-11EB-98F7-0A51EEDFE7CA'

--parentid='93D00129-A276-49FF-BFEB-8C80B5443B72'
'514,530,531,532,533,534,513,512,546,524,681'
declare @dealer_id varchar(4000) = '514,530,531,532,533,534,513,512,546,524,681'
select distinct value from dbo.fn_split_string_to_column(@dealer_id,',')


select distinct sale_type from master.fi_sales (nolock) where parent_dealer_id =681

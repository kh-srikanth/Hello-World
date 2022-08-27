use clictell_auto_master
go
create table [master].[maintenance_schedule] 

(
s_no int identity(1,1)
,parent_dealer_id int
,general_service_miles int
,general_service_months int
,minor_service_miles int
,minor_service_months int
,major_service_miles int
,major_service_months int
,is_deleted bit default 0
,created_by varchar(50) default suser_name()
,created_date datetime default getdate()
,updated_by varchar(50) default suser_name()
,updated_date datetime default getdate()
)


insert into [master].[maintenance_schedule] 
(general_service_miles,general_service_months,minor_service_miles,minor_service_months,major_service_miles,major_service_months)
values 
(7500,6,15000,12,30000,24),
(22500,18,45000,36,60000,48),
(37500,30,75000,60,90000,72),
(52500,42,105000,84,120000,96),
(67500,54,135000,108,150000,120),
(82500,66,165000,132,180000,144),
(97500,78,195000,156,210000,168),
(112500,90,225000,180,240000,192),
(127500,102,255000,204,270000,216),
(142500,114,285000,228,300000,240),
(157500,126,null,null,null,null),
(172500,138,null,null,null,null),
(187500,150,null,null,null,null),
(202500,162,null,null,null,null),
(217500,174,null,null,null,null),
(232500,186,null,null,null,null),
(247500,198,null,null,null,null),
(262500,210,null,null,null,null),
(277500,222,null,null,null,null),
(292500,234,null,null,null,null)


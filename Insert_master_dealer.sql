select * from [etl].[etl_process] 
select * from [etl].[file_process_details]
select * from [etl].[atc_service];

delete from [master].[dealer];
insert into [master].[dealer]
(parent_dealer_id, natural_key, dealer_name,is_deleted,created_by,created_dt,updated_by,updated_dt,
is_etl_required, is_opcode_required, oem_code, opcode_processed_date, phone_number, country, address1,city,
state, zip,time_zone, address2, dealer_guid, declined_processed_date, adm, is_hm_required)
select ([DV Dealer ID]) from [etl].[atc_service]



insert into [master].[dealer] (natural_key, source_dealer_id)
select distinct [DV Dealer ID], [Vendor Dealer ID] from [etl].[atc_service];


select * from [master].[dealer];



WITH TopRows AS (
	SELECT [DV Dealer ID], Created_by, Created_date, updated_by, updated_date, row_number()
	OVER (PARTITION BY  [DV Dealer ID] ORDER BY  Created_date DESC) as rownumber
	FROM [etl].[atc_service]
)
insert into [master].[dealer] (natural_key, created_by,created_dt,updated_by,updated_dt)
SELECT [DV Dealer ID], Created_by, Created_date, updated_by, updated_date FROM TopRows WHERE TopRows.[rownumber] < 2;
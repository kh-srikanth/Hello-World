USE [clictell_auto_master]

GO
/****** Object:  Table [master].[customer_history]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[customer_history](
	[master_customer_id] [int] NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[cust_dms_number] [varchar](100) NULL,
	[cust_salutation_text] [varchar](50) NULL,
	[cust_full_name] [varchar](250) MASKED WITH (FUNCTION = 'partial(1, "XXXXX", 0)') NULL,
	[cust_first_name] [varchar](250) MASKED WITH (FUNCTION = 'partial(1, "XXXXX", 0)') NULL,
	[cust_middle_name] [varchar](250) MASKED WITH (FUNCTION = 'partial(1, "XXXXX", 0)') NULL,
	[cust_last_name] [varchar](250) MASKED WITH (FUNCTION = 'partial(1, "XXXXX", 0)') NULL,
	[cust_suffix] [varchar](50) NULL,
	[cust_address1] [varchar](250) MASKED WITH (FUNCTION = 'partial(1, "XXXXXX", 0)') NULL,
	[cust_address2] [varchar](250) MASKED WITH (FUNCTION = 'partial(1, "XXXXXX", 0)') NULL,
	[cust_city] [varchar](250) MASKED WITH (FUNCTION = 'default()') NULL,
	[cust_county] [varchar](250) NULL,
	[cust_district] [varchar](250) NULL,
	[cust_region] [varchar](250) NULL,
	[cust_country] [varchar](250) NULL,
	[cust_state_code] [varchar](250) NULL,
	[cust_zip_code] [varchar](50) MASKED WITH (FUNCTION = 'default()') NULL,
	[cust_zip_code4] [varchar](50) MASKED WITH (FUNCTION = 'default()') NULL,
	[cust_mobile_phone] [varchar](50) MASKED WITH (FUNCTION = 'default()') NULL,
	[cust_home_phone] [varchar](50) MASKED WITH (FUNCTION = 'default()') NULL,
	[cust_home_phone_ext] [varchar](50) NULL,
	[cust_home_ph_country_code] [varchar](50) NULL,
	[cust_work_phone] [varchar](50) MASKED WITH (FUNCTION = 'default()') NULL,
	[cust_work_phone_ext] [varchar](50) NULL,
	[cust_work_ph_country_code] [varchar](50) NULL,
	[cust_work_address] [varchar](250) NULL,
	[cust_work_address_district] [varchar](50) NULL,
	[cust_work_address_city] [varchar](50) NULL,
	[cust_work_address_zip_code] [varchar](50) NULL,
	[cust_work_address_region] [varchar](50) NULL,
	[cust_work_address_country] [varchar](50) NULL,
	[cust_email_address1] [varchar](250) MASKED WITH (FUNCTION = 'email()') NULL,
	[cust_email_address2] [varchar](250) NULL,
	[cust_birth_date] [date] MASKED WITH (FUNCTION = 'default()') NULL,
	[cust_birth_type] [varchar](50) NULL,
	[cust_status] [varchar](50) NULL,
	[cust_gender] [varchar](50) NULL,
	[cust_category] [varchar](50) NULL,
	[customer_type] [varchar](50) NULL,
	[cust_driver_type] [varchar](50) NULL,
	[cust_lic_number] [varchar](50) NULL,
	[cust_driver_lic_exp_dt] [int] NULL,
	[co_buyer_id] [varchar](250) NULL,
	[co_buyer_salutation_text] [varchar](250) NULL,
	[co_buyer_first_name] [varchar](250) NULL,
	[co_buyer_middle_name] [varchar](250) NULL,
	[co_buyer_last_name] [varchar](250) NULL,
	[co_buyer_suffix] [varchar](250) NULL,
	[co_buyer_full_name] [varchar](250) NULL,
	[co_buyer_address1] [varchar](250) NULL,
	[co_buyer_address2] [varchar](250) NULL,
	[co_buyer_city] [varchar](250) NULL,
	[co_buyer_district] [varchar](250) NULL,
	[co_buyer_region] [varchar](250) NULL,
	[co_buyer_zip_code] [varchar](250) NULL,
	[co_buyer_zip_code4] [varchar](10) NULL,
	[co_buyer_country] [varchar](250) NULL,
	[co_buyer_home_phone] [varchar](100) NULL,
	[co_buyer_home_phone_ext] [varchar](100) NULL,
	[co_buyer_home_ph_country_code] [varchar](100) NULL,
	[co_buyer_mobile_phone] [varchar](100) NULL,
	[co_buyer_work_phone] [varchar](100) NULL,
	[cust_work_email_address] [varchar](250) NULL,
	[co_buyer_work_phone_ext] [varchar](100) NULL,
	[co_buyer_work_ph_country_code] [varchar](100) NULL,
	[co_buyer_email_address1] [varchar](250) NULL,
	[co_buyer_email_address2] [varchar](250) NULL,
	[co_buyer_birth_date] [date] NULL,
	[mailing_preference] [varchar](50) NULL,
	[cust_do_not_call] [bit] NULL,
	[cust_do_not_email] [bit] NULL,
	[cust_do_not_mail] [bit] NULL,
	[cust_do_not_data_share] [bit] NULL,
	[cust_opt_out_all] [bit] NULL,
	[last_activity_date] [int] NULL,
	[inactive_date] [int] NULL,
	[is_invalid_dms_num] [bit] NULL,
	[is_deleted] [bit] NULL,
	[is_invalid_email] [bit] NULL,
	[latitude] [varchar](800) NULL,
	[longitude] [varchar](800) NULL,
	[ncoa_date] [int] NULL,
	[ncoa_address1] [varchar](250) NULL,
	[ncoa_address2] [varchar](250) NULL,
	[ncoa_city] [varchar](50) NULL,
	[ncoa_state] [varchar](5) NULL,
	[ncoa_zip_code] [varchar](20) NULL,
	[ncoa_zip_code4] [varchar](50) NULL,
	[ncoa_suppression_code] [varchar](100) NULL,
	[is_suppressed] [bit] NULL,
	[cust_ethnicity_id] [int] NULL,
	[cust_occupation_id] [int] NULL,
	[lifecycle_stage] [varchar](50) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_by] [varchar](50) NULL,
	[sysstart] [datetime2](2) NOT NULL,
	[sysend] [datetime2](2) NOT NULL,
	[model_score_100] [int] NULL,
	[model_score_110] [int] NULL,
	[model_score_200] [int] NULL,
	[model_score_550] [int] NULL,
	[model_score_555] [int] NULL,
	[model_score_650] [int] NULL,
	[prison_flag] [bit] NULL,
	[deceased_flag] [bit] NULL,
	[under_14_flag] [bit] NULL,
	[name_based_suppress_flag] [bit] NULL,
	[upfitter_address_flag] [bit] NULL,
	[household_id] [varchar](250) NULL,
	[is_vehicle_owner] [bit] NULL,
	[cust_age] [varchar](10) NULL,
	[cust_miles_distance] [int] NULL,
	[is_blank_record] [bit] NULL,
	[temp_name_flag] [varchar](20) NULL,
	[daily_average_mile] [int] NULL,
	[last_estimated_mileage] [int] NULL,
	[surrogate_id] [int] NULL,
	[is_invalid_mail] [int] NULL,
	[cust_do_not_text] [bit] NULL,
	[cust_do_not_social] [bit] NULL,
	[cust_fax] [varchar](100) NULL,
	[email_dnc_type] [varchar](15) NULL,
	[email_dnc_date] [datetime] NULL,
	[mail_suppression_reason] [varchar](100) NULL,
	[mail_suppression_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[customer]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[customer](
	[master_customer_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[cust_dms_number] [varchar](100) NULL,
	[cust_salutation_text] [varchar](50) NULL,
	[cust_full_name] [varchar](250) MASKED WITH (FUNCTION = 'partial(1, "XXXXX", 0)') NULL,
	[cust_first_name] [varchar](250) MASKED WITH (FUNCTION = 'partial(1, "XXXXX", 0)') NULL,
	[cust_middle_name] [varchar](250) MASKED WITH (FUNCTION = 'partial(1, "XXXXX", 0)') NULL,
	[cust_last_name] [varchar](250) MASKED WITH (FUNCTION = 'partial(1, "XXXXX", 0)') NULL,
	[cust_suffix] [varchar](50) NULL,
	[cust_address1] [varchar](250) MASKED WITH (FUNCTION = 'partial(1, "XXXXXX", 0)') NULL,
	[cust_address2] [varchar](250) MASKED WITH (FUNCTION = 'partial(1, "XXXXXX", 0)') NULL,
	[cust_city] [varchar](250) MASKED WITH (FUNCTION = 'default()') NULL,
	[cust_county] [varchar](250) NULL,
	[cust_district] [varchar](250) NULL,
	[cust_region] [varchar](250) NULL,
	[cust_country] [varchar](250) NULL,
	[cust_state_code] [varchar](250) NULL,
	[cust_zip_code] [varchar](50) MASKED WITH (FUNCTION = 'default()') NULL,
	[cust_zip_code4] [varchar](50) MASKED WITH (FUNCTION = 'default()') NULL,
	[cust_mobile_phone] [varchar](50) MASKED WITH (FUNCTION = 'default()') NULL,
	[cust_home_phone] [varchar](50) MASKED WITH (FUNCTION = 'default()') NULL,
	[cust_home_phone_ext] [varchar](50) NULL,
	[cust_home_ph_country_code] [varchar](50) NULL,
	[cust_work_phone] [varchar](50) MASKED WITH (FUNCTION = 'default()') NULL,
	[cust_work_phone_ext] [varchar](50) NULL,
	[cust_work_ph_country_code] [varchar](50) NULL,
	[cust_work_address] [varchar](250) NULL,
	[cust_work_address_district] [varchar](50) NULL,
	[cust_work_address_city] [varchar](50) NULL,
	[cust_work_address_zip_code] [varchar](50) NULL,
	[cust_work_address_region] [varchar](50) NULL,
	[cust_work_address_country] [varchar](50) NULL,
	[cust_email_address1] [varchar](250) MASKED WITH (FUNCTION = 'email()') NULL,
	[cust_email_address2] [varchar](250) NULL,
	[cust_birth_date] [date] MASKED WITH (FUNCTION = 'default()') NULL,
	[cust_birth_type] [varchar](50) NULL,
	[cust_status] [varchar](50) NULL,
	[cust_gender] [varchar](50) NULL,
	[cust_category] [varchar](50) NULL,
	[customer_type] [varchar](50) NULL,
	[cust_driver_type] [varchar](50) NULL,
	[cust_lic_number] [varchar](50) NULL,
	[cust_driver_lic_exp_dt] [int] NULL,
	[co_buyer_id] [varchar](250) NULL,
	[co_buyer_salutation_text] [varchar](250) NULL,
	[co_buyer_first_name] [varchar](250) NULL,
	[co_buyer_middle_name] [varchar](250) NULL,
	[co_buyer_last_name] [varchar](250) NULL,
	[co_buyer_suffix] [varchar](250) NULL,
	[co_buyer_full_name] [varchar](250) NULL,
	[co_buyer_address1] [varchar](250) NULL,
	[co_buyer_address2] [varchar](250) NULL,
	[co_buyer_city] [varchar](250) NULL,
	[co_buyer_district] [varchar](250) NULL,
	[co_buyer_region] [varchar](250) NULL,
	[co_buyer_zip_code] [varchar](250) NULL,
	[co_buyer_zip_code4] [varchar](10) NULL,
	[co_buyer_country] [varchar](250) NULL,
	[co_buyer_home_phone] [varchar](100) NULL,
	[co_buyer_home_phone_ext] [varchar](100) NULL,
	[co_buyer_home_ph_country_code] [varchar](100) NULL,
	[co_buyer_mobile_phone] [varchar](100) NULL,
	[co_buyer_work_phone] [varchar](100) NULL,
	[cust_work_email_address] [varchar](250) NULL,
	[co_buyer_work_phone_ext] [varchar](100) NULL,
	[co_buyer_work_ph_country_code] [varchar](100) NULL,
	[co_buyer_email_address1] [varchar](250) NULL,
	[co_buyer_email_address2] [varchar](250) NULL,
	[co_buyer_birth_date] [date] NULL,
	[mailing_preference] [varchar](50) NULL,
	[cust_do_not_call] [bit] NULL,
	[cust_do_not_email] [bit] NULL,
	[cust_do_not_mail] [bit] NULL,
	[cust_do_not_data_share] [bit] NULL,
	[cust_opt_out_all] [bit] NULL,
	[last_activity_date] [int] NULL,
	[inactive_date] [int] NULL,
	[is_invalid_dms_num] [bit] NULL,
	[is_deleted] [bit] NULL,
	[is_invalid_email] [bit] NULL,
	[latitude] [varchar](800) NULL,
	[longitude] [varchar](800) NULL,
	[ncoa_date] [int] NULL,
	[ncoa_address1] [varchar](250) NULL,
	[ncoa_address2] [varchar](250) NULL,
	[ncoa_city] [varchar](50) NULL,
	[ncoa_state] [varchar](5) NULL,
	[ncoa_zip_code] [varchar](20) NULL,
	[ncoa_zip_code4] [varchar](50) NULL,
	[ncoa_suppression_code] [varchar](100) NULL,
	[is_suppressed] [bit] NULL,
	[cust_ethnicity_id] [int] NULL,
	[cust_occupation_id] [int] NULL,
	[lifecycle_stage] [varchar](50) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_by] [varchar](50) NULL,
	[sysstart] [datetime2](2) GENERATED ALWAYS AS ROW START NOT NULL,
	[sysend] [datetime2](2) GENERATED ALWAYS AS ROW END NOT NULL,
	[model_score_100] [int] NULL,
	[model_score_110] [int] NULL,
	[model_score_200] [int] NULL,
	[model_score_550] [int] NULL,
	[model_score_555] [int] NULL,
	[model_score_650] [int] NULL,
	[prison_flag] [bit] NULL,
	[deceased_flag] [bit] NULL,
	[under_14_flag] [bit] NULL,
	[name_based_suppress_flag] [bit] NULL,
	[upfitter_address_flag] [bit] NULL,
	[household_id] [varchar](250) NULL,
	[is_vehicle_owner] [bit] NULL,
	[cust_age] [varchar](10) NULL,
	[cust_miles_distance] [int] NULL,
	[is_blank_record] [bit] NULL,
	[temp_name_flag] [varchar](20) NULL,
	[daily_average_mile] [int] NULL,
	[last_estimated_mileage] [int] NULL,
	[surrogate_id] [int] NULL,
	[is_invalid_mail] [int] NULL,
	[cust_do_not_text] [bit] NULL,
	[cust_do_not_social] [bit] NULL,
	[cust_fax] [varchar](100) NULL,
	[email_dnc_type] [varchar](15) NULL,
	[email_dnc_date] [datetime] NULL,
	[mail_suppression_reason] [varchar](100) NULL,
	[mail_suppression_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[master_customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([sysstart], [sysend])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [master].[customer_history] )
)
GO
/****** Object:  Table [master].[cust_2_vehicle]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[cust_2_vehicle](
	[cust_vehicle_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[cust_dms_number] [varchar](250) NULL,
	[master_customer_id] [int] NULL,
	[master_vehicle_id] [int] NULL,
	[vin] [varchar](20) MASKED WITH (FUNCTION = 'partial(0, "XXXXXXXXX", 8)') NULL,
	[active_date] [date] NULL,
	[inactive_date] [date] NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[update_by] [varchar](50) NULL,
	[first_ro_date] [int] NULL,
	[last_ro_date] [int] NULL,
	[first_ro_mileage] [int] NULL,
	[last_ro_mileage] [int] NULL,
	[last_sale_date] [int] NULL,
	[last_sale_mileage] [int] NULL,
	[sale_type] [varchar](10) NULL,
	[last_service_amount] [decimal](9, 2) NULL,
	[last_advisor_id] [varchar](50) NULL,
	[last_sale_dealer] [varchar](20) NULL,
	[is_deleted] [bit] NULL,
	[vehicle_type] [varchar](100) NULL,
	[loan_or_lease_end_date] [date] NULL,
 CONSTRAINT [PK__cust_2_v__58B2C7DFFD4B8E3DEED] PRIMARY KEY CLUSTERED 
(
	[cust_vehicle_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[cust_2_vehicle_actvdt_inactvdt_test_del]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[cust_2_vehicle_actvdt_inactvdt_test_del](
	[cust_vehicle_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[cust_dms_number] [varchar](250) NULL,
	[master_customer_id] [int] NULL,
	[master_vehicle_id] [int] NULL,
	[vin] [varchar](20) NULL,
	[active_date] [date] NULL,
	[inactive_date] [date] NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[update_by] [varchar](50) NULL,
	[first_ro_date] [int] NULL,
	[last_ro_date] [int] NULL,
	[first_ro_mileage] [int] NULL,
	[last_ro_mileage] [int] NULL,
	[last_sale_date] [int] NULL,
	[last_sale_mileage] [int] NULL,
	[sale_type] [varchar](10) NULL,
	[last_service_amount] [decimal](9, 2) NULL,
	[last_advisor_id] [varchar](50) NULL,
	[last_sale_dealer] [varchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[cust_2_vehicle_back_20180527_del]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[cust_2_vehicle_back_20180527_del](
	[cust_vehicle_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[cust_dms_number] [varchar](250) NULL,
	[master_customer_id] [int] NULL,
	[master_vehicle_id] [int] NULL,
	[vin] [varchar](20) NULL,
	[active_date] [date] NULL,
	[inactive_date] [date] NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[update_by] [varchar](50) NULL,
	[first_ro_date] [int] NULL,
	[last_ro_date] [int] NULL,
	[first_ro_mileage] [int] NULL,
	[last_ro_mileage] [int] NULL,
	[last_sale_date] [int] NULL,
	[last_sale_mileage] [int] NULL,
	[sale_type] [varchar](10) NULL,
	[last_service_amount] [decimal](9, 2) NULL,
	[last_advisor_id] [varchar](50) NULL,
	[last_sale_dealer] [varchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[cust_2_vehicle_backup_20181008_del]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[cust_2_vehicle_backup_20181008_del](
	[cust_vehicle_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[cust_dms_number] [varchar](250) NULL,
	[master_customer_id] [int] NULL,
	[master_vehicle_id] [int] NULL,
	[vin] [varchar](20) NULL,
	[active_date] [date] NULL,
	[inactive_date] [date] NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[update_by] [varchar](50) NULL,
	[first_ro_date] [int] NULL,
	[last_ro_date] [int] NULL,
	[first_ro_mileage] [int] NULL,
	[last_ro_mileage] [int] NULL,
	[last_sale_date] [int] NULL,
	[last_sale_mileage] [int] NULL,
	[sale_type] [varchar](10) NULL,
	[last_service_amount] [decimal](9, 2) NULL,
	[last_advisor_id] [varchar](50) NULL,
	[last_sale_dealer] [varchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[cust_2_vehicle_grgn_del]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[cust_2_vehicle_grgn_del](
	[cust_vehicle_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[cust_dms_number] [varchar](250) NULL,
	[master_customer_id] [int] NULL,
	[master_vehicle_id] [int] NULL,
	[vin] [varchar](20) NULL,
	[active_date] [date] NULL,
	[inactive_date] [date] NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[update_by] [varchar](50) NULL,
	[first_ro_date] [int] NULL,
	[last_ro_date] [int] NULL,
	[first_ro_mileage] [int] NULL,
	[last_ro_mileage] [int] NULL,
	[last_sale_date] [int] NULL,
	[last_sale_mileage] [int] NULL,
	[sale_type] [varchar](10) NULL,
	[last_service_amount] [decimal](9, 2) NULL,
	[last_advisor_id] [varchar](50) NULL,
	[last_sale_dealer] [varchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[cust_2_vehicle_porsche_test_del]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[cust_2_vehicle_porsche_test_del](
	[cust_vehicle_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[cust_dms_number] [varchar](250) NULL,
	[master_customer_id] [int] NULL,
	[master_vehicle_id] [int] NULL,
	[vin] [varchar](20) NULL,
	[active_date] [date] NULL,
	[inactive_date] [date] NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[update_by] [varchar](50) NULL,
	[first_ro_date] [int] NULL,
	[last_ro_date] [int] NULL,
	[first_ro_mileage] [int] NULL,
	[last_ro_mileage] [int] NULL,
	[last_sale_date] [int] NULL,
	[last_sale_mileage] [int] NULL,
	[sale_type] [varchar](10) NULL,
	[last_service_amount] [decimal](9, 2) NULL,
	[last_advisor_id] [varchar](50) NULL,
	[last_sale_dealer] [varchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[cust_mail_block]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[cust_mail_block](
	[master_mail_block_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NULL,
	[parent_dealer_id] [int] NULL,
	[master_customer_id] [int] NULL,
	[cust_dms_number] [varchar](50) NULL,
	[cust_do_not_call] [varchar](50) NULL,
	[cust_do_not_email] [varchar](50) NULL,
	[cust_do_not_mail] [varchar](50) NULL,
	[cust_do_not_data_share] [varchar](50) NULL,
	[cust_opt_out] [varchar](500) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[customer_ncoa]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[customer_ncoa](
	[ncoa_customer_id] [bigint] IDENTITY(1,1) NOT NULL,
	[master_customer_id] [varchar](250) NULL,
	[ncoa_suffix] [varchar](100) NULL,
	[ncoa_prefix] [varchar](50) NULL,
	[ncoa_cust_first_name] [varchar](250) NULL,
	[ncoa_cust_middle_name] [varchar](250) NULL,
	[ncoa_cust_last_name] [varchar](250) NULL,
	[ncoa_customer_full_name] [varchar](250) NULL,
	[ncoa_description] [varchar](max) NULL,
	[address1] [varchar](250) NULL,
	[address2] [varchar](250) NULL,
	[city] [varchar](50) NULL,
	[state] [varchar](50) NULL,
	[zip] [varchar](50) NULL,
	[ncoa_address1] [varchar](250) NULL,
	[ncoa_address2] [varchar](250) NULL,
	[ncoa_city] [varchar](50) NULL,
	[ncoa_state] [varchar](50) NULL,
	[ncoa_zip] [varchar](50) NULL,
	[return_code] [varchar](4000) NULL,
	[move_type] [char](5) NULL,
	[move_date] [varchar](50) NULL,
	[address_error] [char](1) NULL,
	[urban] [varchar](250) NULL,
	[is_deleted] [bit] NULL,
	[is_suppressed] [bit] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
 CONSTRAINT [PK__customer__D4222F94ED0C42CC] PRIMARY KEY CLUSTERED 
(
	[ncoa_customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[daily_stats]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[daily_stats](
	[etl_id] [int] IDENTITY(1,1) NOT NULL,
	[file_log_id] [int] NULL,
	[customer_tot_cnt] [int] NULL,
	[vehicle_tot_cnt] [int] NULL,
	[cust2vehicle_tot_cnt] [int] NULL,
	[service_tot_cnt] [int] NULL,
	[sale_tot_cnt] [int] NULL,
	[customer_upd_cnt] [int] NULL,
	[vehicle_upd_cnt] [int] NULL,
	[cust2vehicle_upd_cnt] [int] NULL,
	[service_upd_cnt] [int] NULL,
	[sale_upd_cnt] [int] NULL,
	[created_by] [varchar](250) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](250) NULL,
	[updated_dt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[etl_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[dealer]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[dealer](
	[parent_dealer_id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[natural_key] [varchar](25) NULL,
	[dealer_name] [varchar](250) NULL,
	[is_deleted] [bit] NULL,
	[created_by] [varchar](250) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](250) NULL,
	[updated_dt] [datetime] NULL,
	[bac_code] [varchar](10) NULL,
	[is_etl_required] [bit] NULL,
	[is_opcode_required] [bit] NULL,
	[oem_code] [varchar](10) NULL,
	[opcode_processed_date] [smalldatetime] NULL,
	[phone_number] [varchar](20) NULL,
	[country] [varchar](100) NULL,
	[address1] [varchar](100) NULL,
	[city] [varchar](100) NULL,
	[state] [varchar](100) NULL,
	[zip] [varchar](10) NULL,
	[time_zone] [varchar](10) NULL,
	[address2] [varchar](100) NULL,
	[dealer_guid] [uniqueidentifier] NULL,
	[declined_processed_date] [datetime] NULL,
	[adm] [decimal](5, 2) NULL,
	[is_hm_required] [bit] NULL,
	[source_dealer_id] [varchar](100) NULL,
 CONSTRAINT [PK_dealer] PRIMARY KEY CLUSTERED 
(
	[parent_dealer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [mstr_dlr_natural_key] UNIQUE NONCLUSTERED 
(
	[natural_key] ASC,
	[is_deleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[dealer_audit_log]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[dealer_audit_log](
	[audit_log_id] [bigint] IDENTITY(1,1) NOT NULL,
	[parent_dealer_id] [int] NULL,
	[dealer_mapping_id] [int] NULL,
	[src_dealer_code] [varchar](50) NULL,
	[file_received_dt] [datetime] NULL,
	[ro_count] [int] NULL,
	[sales_count] [int] NULL,
	[min_ro_dt] [int] NULL,
	[max_ro_dt] [int] NULL,
	[min_sale_dt] [int] NULL,
	[max_sale_dt] [int] NULL,
	[is_deleted] [bit] NULL,
	[created_by] [varchar](100) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](100) NULL,
	[updated_dt] [datetime] NULL,
	[file_log_detail_id] [bigint] NULL,
	[natural_key] [varchar](25) NULL,
PRIMARY KEY CLUSTERED 
(
	[audit_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[dealer_log]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[dealer_log](
	[parent_dealer_id] [bigint] NOT NULL,
	[natural_key] [varchar](25) NULL,
	[dealer_name] [varchar](250) NULL,
	[is_deleted] [bit] NULL,
	[created_by] [varchar](250) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](250) NULL,
	[updated_dt] [datetime] NULL,
	[bac_code] [varchar](10) NULL,
	[is_etl_required] [bit] NULL,
	[is_opcode_required] [bit] NULL,
	[oem_code] [varchar](10) NULL,
	[opcode_processed_date] [smalldatetime] NULL,
	[phone_number] [varchar](20) NULL,
	[country] [varchar](100) NULL,
	[address1] [varchar](100) NULL,
	[city] [varchar](100) NULL,
	[state] [varchar](100) NULL,
	[zip] [varchar](10) NULL,
	[time_zone] [varchar](10) NULL,
	[address2] [varchar](100) NULL,
	[dealer_guid] [uniqueidentifier] NULL,
	[declined_processed_date] [datetime] NULL,
	[adm] [decimal](5, 2) NULL,
	[is_hm_required] [bit] NULL,
	[create_dt] [datetime] NULL,
	[create_by] [varchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[dealer_mapping]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[dealer_mapping](
	[dealer_mapping_id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[parent_dealer_id] [int] NULL,
	[source_of_dealer] [varchar](25) NULL,
	[src_dealer_code] [varchar](50) NULL,
	[dealer_source] [varchar](25) NULL,
	[is_deleted] [bit] NULL,
	[created_by] [varchar](250) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](250) NULL,
	[updated_dt] [datetime] NULL,
	[yellow_flag] [bit] NULL,
	[red_flag] [bit] NULL,
	[last_file_received_dt] [datetime] NULL,
	[file_processed_dt] [datetime] NULL,
	[source_type] [varchar](25) NULL,
	[last_ro_date] [datetime] NULL,
	[last_sale_date] [datetime] NULL,
	[last_sale_file_date] [datetime] NULL,
	[last_ro_file_date] [datetime] NULL,
	[external_cdk_id] [int] NULL,
	[dealer_source_type_id] [int] NULL,
	[source_type_id] [int] NULL,
	[src_code] [varchar](50) NULL,
	[delete_comments] [varchar](max) NULL,
 CONSTRAINT [PK__dealer_m__019990C0E2D6D59C] PRIMARY KEY CLUSTERED 
(
	[dealer_mapping_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UNIQUE_SRC_DM] UNIQUE NONCLUSTERED 
(
	[parent_dealer_id] ASC,
	[src_dealer_code] ASC,
	[dealer_source] ASC,
	[is_deleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[dealer_mapping_backup_20201102]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[dealer_mapping_backup_20201102](
	[dealer_mapping_id] [bigint] IDENTITY(1,1) NOT NULL,
	[parent_dealer_id] [int] NULL,
	[source_of_dealer] [varchar](25) NULL,
	[src_dealer_code] [varchar](50) NULL,
	[dealer_source] [varchar](25) NULL,
	[is_deleted] [bit] NULL,
	[created_by] [varchar](250) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](250) NULL,
	[updated_dt] [datetime] NULL,
	[yellow_flag] [bit] NULL,
	[red_flag] [bit] NULL,
	[last_file_received_dt] [datetime] NULL,
	[file_processed_dt] [datetime] NULL,
	[source_type] [varchar](25) NULL,
	[last_ro_date] [datetime] NULL,
	[last_sale_date] [datetime] NULL,
	[last_sale_file_date] [datetime] NULL,
	[last_ro_file_date] [datetime] NULL,
	[external_cdk_id] [int] NULL,
	[dealer_source_type_id] [int] NULL,
	[source_type_id] [int] NULL,
	[src_code] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[dealer_mapping_log]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[dealer_mapping_log](
	[dealer_mapping_id] [bigint] NOT NULL,
	[parent_dealer_id] [int] NULL,
	[source_of_dealer] [varchar](25) NULL,
	[src_dealer_code] [varchar](50) NULL,
	[dealer_source] [varchar](25) NULL,
	[is_deleted] [bit] NULL,
	[created_by] [varchar](250) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](250) NULL,
	[updated_dt] [datetime] NULL,
	[yellow_flag] [bit] NULL,
	[red_flag] [bit] NULL,
	[last_file_received_dt] [datetime] NULL,
	[file_processed_dt] [datetime] NULL,
	[source_type] [varchar](25) NULL,
	[last_ro_date] [datetime] NULL,
	[last_sale_date] [datetime] NULL,
	[last_sale_file_date] [datetime] NULL,
	[last_ro_file_date] [datetime] NULL,
	[external_cdk_id] [int] NULL,
	[dealer_source_type_id] [int] NULL,
	[source_type_id] [int] NULL,
	[src_code] [varchar](50) NULL,
	[create_dt] [datetime] NULL,
	[create_by] [varchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[dealer_source_type]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[dealer_source_type](
	[dealer_source_type_id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[dealer_source] [varchar](250) NOT NULL,
	[is_deleted] [bit] NOT NULL,
	[created_dt] [datetime] NOT NULL,
	[created_by] [varchar](250) NOT NULL,
	[updated_by] [varchar](250) NULL,
	[updated_dt] [datetime] NULL,
	[dealer_source_code] [varchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[decline_ros]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[decline_ros](
	[decline_ro_id] [int] IDENTITY(1,1) NOT NULL,
	[parent_dealer_id] [bigint] NOT NULL,
	[natural_key] [varchar](100) NOT NULL,
	[master_ro_header_id] [int] NULL,
	[ro_number] [varchar](50) NULL,
	[ro_close_date] [int] NULL,
	[cust_dms_no] [varchar](25) NULL,
	[cust_full_name] [varchar](500) NULL,
	[cust_first_name] [varchar](500) NULL,
	[cust_last_name] [varchar](500) NULL,
	[cust_address] [varchar](500) NULL,
	[cust_city] [varchar](250) NULL,
	[cust_state] [varchar](50) NULL,
	[cust_zip] [varchar](15) NULL,
	[cust_home_phone] [varchar](15) NULL,
	[cust_work_phone] [varchar](15) NULL,
	[cust_cell_phone] [varchar](15) NULL,
	[cust_email] [varchar](100) NULL,
	[vin] [varchar](20) NULL,
	[year] [varchar](10) NULL,
	[make] [varchar](50) NULL,
	[model] [varchar](50) NULL,
	[engine] [varchar](50) NULL,
	[mileage] [varchar](50) NULL,
	[sa_name] [varchar](50) NULL,
	[sa_number] [varchar](25) NULL,
	[tech_name] [varchar](250) NULL,
	[tech_number] [varchar](250) NULL,
	[package_name] [varchar](250) NULL,
	[package_type] [varchar](250) NULL,
	[task_category] [varchar](250) NULL,
	[task] [varchar](800) NULL,
	[task_status] [varchar](250) NULL,
	[observation] [varchar](4000) NULL,
	[recommendation] [varchar](4000) NULL,
	[recommended_date] [varchar](50) NULL,
	[rec_type] [varchar](4000) NULL,
	[rec_status] [varchar](4000) NULL,
	[declined_reason] [varchar](4000) NULL,
	[estimate_Price] [varchar](50) NULL,
	[fax] [varchar](50) NULL,
	[is_deleted] [bit] NOT NULL,
	[created_by] [varchar](100) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](100) NULL,
	[updated_dt] [datetime] NULL,
	[file_log_detail_id] [bigint] NULL,
	[oem_name] [varchar](50) NULL,
 CONSTRAINT [PK__decline___7183683FEBC3E093] PRIMARY KEY CLUSTERED 
(
	[decline_ro_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[decline_ros_backaup_dup_del_2020]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[decline_ros_backaup_dup_del_2020](
	[decline_ro_id] [int] IDENTITY(1,1) NOT NULL,
	[parent_dealer_id] [bigint] NOT NULL,
	[natural_key] [varchar](100) NOT NULL,
	[master_ro_header_id] [int] NULL,
	[ro_number] [varchar](50) NULL,
	[ro_close_date] [int] NULL,
	[cust_dms_no] [varchar](25) NULL,
	[cust_full_name] [varchar](500) NULL,
	[cust_first_name] [varchar](500) NULL,
	[cust_last_name] [varchar](500) NULL,
	[cust_address] [varchar](500) NULL,
	[cust_city] [varchar](250) NULL,
	[cust_state] [varchar](50) NULL,
	[cust_zip] [varchar](15) NULL,
	[cust_home_phone] [varchar](15) NULL,
	[cust_work_phone] [varchar](15) NULL,
	[cust_cell_phone] [varchar](15) NULL,
	[cust_email] [varchar](100) NULL,
	[vin] [varchar](20) NULL,
	[year] [varchar](10) NULL,
	[make] [varchar](50) NULL,
	[model] [varchar](50) NULL,
	[engine] [varchar](50) NULL,
	[mileage] [varchar](50) NULL,
	[sa_name] [varchar](50) NULL,
	[sa_number] [varchar](25) NULL,
	[tech_name] [varchar](50) NULL,
	[tech_number] [varchar](25) NULL,
	[package_name] [varchar](250) NULL,
	[package_type] [varchar](50) NULL,
	[task_category] [varchar](250) NULL,
	[task] [varchar](500) NULL,
	[task_status] [varchar](50) NULL,
	[observation] [varchar](250) NULL,
	[recommendation] [varchar](500) NULL,
	[recommended_date] [varchar](50) NULL,
	[rec_type] [varchar](50) NULL,
	[rec_status] [varchar](50) NULL,
	[declined_reason] [varchar](50) NULL,
	[estimate_Price] [varchar](50) NULL,
	[fax] [varchar](50) NULL,
	[is_deleted] [bit] NOT NULL,
	[created_by] [varchar](100) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](100) NULL,
	[updated_dt] [datetime] NULL,
	[file_log_detail_id] [bigint] NULL,
	[oem_name] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[declined_comment]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[declined_comment](
	[master_ro_header_id] [int] NULL,
	[comment] [varchar](max) NULL,
	[program_type] [varchar](25) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](max) NULL,
	[declined_categories] [varchar](max) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NULL,
	[master_declined_text_id] [int] NULL,
	[qc_flag] [bit] NULL,
	[qc_date] [smalldatetime] NULL,
	[split_sentences] [varchar](max) NULL,
	[recommend_sentences] [varchar](max) NULL,
	[performed_sentences] [varchar](max) NULL,
	[recommend_extract_words] [varchar](max) NULL,
	[performed_extract_words] [varchar](max) NULL,
	[declined_comment_id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_declined_comment] PRIMARY KEY CLUSTERED 
(
	[declined_comment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[declined_comment_backup_07032018]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[declined_comment_backup_07032018](
	[master_ro_header_id] [int] NULL,
	[comment] [varchar](max) NULL,
	[program_type] [varchar](25) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](max) NULL,
	[declined_categories] [varchar](max) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NULL,
	[master_declined_text_id] [int] NULL,
	[qc_flag] [bit] NULL,
	[qc_date] [smalldatetime] NULL,
	[split_sentences] [varchar](max) NULL,
	[recommend_sentences] [varchar](max) NULL,
	[performed_sentences] [varchar](max) NULL,
	[recommend_extract_words] [varchar](max) NULL,
	[performed_extract_words] [varchar](max) NULL,
	[declined_comment_id] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[declined_comment_details]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[declined_comment_details](
	[declined_comment_detail_id] [bigint] IDENTITY(1,1) NOT NULL,
	[declined_comment_id] [int] NOT NULL,
	[master_ro_header_id] [int] NOT NULL,
	[comment] [varchar](max) NULL,
	[performed_services] [varchar](500) NULL,
	[recommended_services] [varchar](500) NULL,
	[declined_services] [varchar](500) NULL,
	[is_performed] [bit] NOT NULL,
	[is_recommended] [bit] NOT NULL,
	[is_declined] [bit] NOT NULL,
	[created_dt] [smalldatetime] NOT NULL,
	[created_by] [varchar](50) NOT NULL,
	[updated_dt] [smalldatetime] NULL,
	[updated_by] [varchar](50) NULL,
	[is_deleted] [bit] NULL,
 CONSTRAINT [PK_declined_comment_details] PRIMARY KEY CLUSTERED 
(
	[declined_comment_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[declined_comments]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[declined_comments](
	[declined_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NOT NULL,
	[master_ro_header_id] [int] NOT NULL,
	[master_declined_text_id] [int] NULL,
	[comment] [varchar](max) NULL,
	[is_reviewed] [bit] NULL,
	[reviewed_dt] [smalldatetime] NULL,
	[created_dt] [smalldatetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_dt] [smalldatetime] NULL,
	[updated_by] [varchar](50) NULL,
	[is_processed] [bit] NOT NULL,
	[performed_services] [varchar](500) NULL,
	[recommended_services] [varchar](500) NULL,
	[declined_services] [varchar](500) NULL,
	[is_performed] [bit] NULL,
	[is_recommended] [bit] NULL,
	[is_declined] [bit] NULL,
	[source] [varchar](10) NULL,
 CONSTRAINT [PK_declined_comments] PRIMARY KEY CLUSTERED 
(
	[declined_comment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[declined_dealer_value]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[declined_dealer_value](
	[dealer_declined_value_key] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[declined_type_key] [int] NOT NULL,
	[operator_key] [int] NOT NULL,
	[select_value] [varchar](256) NULL,
	[program] [varchar](25) NULL,
	[current_method] [varchar](250) NULL,
	[is_active] [bit] NOT NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](64) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](64) NULL,
 CONSTRAINT [PK__declined__0CAC1EE04FB921FE] PRIMARY KEY CLUSTERED 
(
	[dealer_declined_value_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[declined_dealers]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[declined_dealers](
	[Declined_Dealer_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [nvarchar](50) NULL,
	[is_Active] [bit] NULL,
	[created_date] [datetime] NULL,
	[created_by] [nvarchar](100) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [nvarchar](100) NULL,
	[Oem_code] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Declined_Dealer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[declined_final]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[declined_final](
	[declined_final_id] [int] IDENTITY(1,1) NOT NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](10) NULL,
	[master_ro_header_id] [int] NULL,
	[master_ro_line_item_id] [int] NULL,
	[declined_source] [varchar](50) NULL,
	[declined_category_dode] [varchar](20) NULL,
	[declined_print_text] [varchar](max) NULL,
	[declined_priority] [smallint] NULL,
	[declined_suppressed] [bit] NULL,
	[declined_suppressed_reason] [varchar](255) NULL,
	[create_date] [smalldatetime] NULL,
	[processed_flag] [bit] NULL,
	[processed_date] [smalldatetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[declined_final_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[declined_keywords]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[declined_keywords](
	[DeclinedCategory] [nvarchar](max) NULL,
	[KeywordGroup] [float] NULL,
	[NotKeyword] [float] NULL,
	[TriggerKeyword] [nvarchar](max) NULL,
	[created_date] [smalldatetime] NULL,
	[created_by] [varchar](100) NULL,
	[updated_date] [smalldatetime] NULL,
	[updated_by] [varchar](100) NULL,
	[is_deleted] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[declined_operator]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[declined_operator](
	[operator_key] [int] IDENTITY(1,1) NOT NULL,
	[operator_code] [varchar](64) NOT NULL,
	[operator_name] [varchar](64) NOT NULL,
	[is_active] [bit] NOT NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](64) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[declined_test]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[declined_test](
	[master_ro_header_id] [int] NULL,
	[comment] [varchar](max) NULL,
	[program_type] [varchar](25) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](max) NULL,
	[declined_categories] [varchar](max) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NULL,
	[master_declined_text_id] [int] NULL,
	[qc_flag] [bit] NULL,
	[qc_date] [smalldatetime] NULL,
	[split_sentences] [varchar](max) NULL,
	[recommend_sentences] [varchar](max) NULL,
	[performed_sentences] [varchar](max) NULL,
	[recommend_extract_words] [varchar](max) NULL,
	[performed_extract_words] [varchar](max) NULL,
	[declined_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[svc_year] [int] NULL,
	[svc_mileage] [varchar](10) NULL,
	[opcode_category_id] [int] NULL,
	[opcode_categories] [varchar](40) NULL,
	[confidence_level] [varchar](15) NULL,
	[is_processed] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[declined_text]    Script Date: 1/13/2021 4:01:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[declined_text](
	[master_decline_text_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NULL,
	[text_review_id] [int] NULL,
	[master_ro_header_id] [int] NULL,
	[data_source] [varchar](100) NULL,
	[text_review] [varchar](max) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [bit] NULL,
	[declined_categories] [varchar](4000) NULL,
	[reviewed_date] [datetime] NULL,
	[program_type] [varchar](25) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](500) NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[finalized_flag] [bit] NULL,
	[finalized_date] [datetime] NULL,
 CONSTRAINT [PK__decline___E246366B92336DC6] PRIMARY KEY CLUSTERED 
(
	[master_decline_text_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[declined_type]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[declined_type](
	[declined_type_key] [int] IDENTITY(1,1) NOT NULL,
	[declined_type_code] [varchar](64) NOT NULL,
	[declined_type_description] [varchar](128) NULL,
	[is_active] [bit] NOT NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](64) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](64) NULL,
PRIMARY KEY CLUSTERED 
(
	[declined_type_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[eappends_get]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[eappends_get](
	[eappend_get_id] [int] IDENTITY(1,1) NOT NULL,
	[customer_id] [int] NULL,
	[first_name] [varchar](250) NULL,
	[last_name] [varchar](250) NULL,
	[address1] [varchar](500) NULL,
	[address2] [varchar](500) NULL,
	[city] [varchar](500) NULL,
	[state] [varchar](50) NULL,
	[zip_code] [varchar](20) NULL,
	[append_email] [varchar](250) NULL,
	[match_type] [varchar](50) NULL,
	[is_deleted] [bit] NULL,
	[created_by] [varchar](50) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[updated_dt] [datetime] NULL,
	[eappend_log_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[eappend_get_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[eappends_log]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[eappends_log](
	[eappend_log_id] [int] IDENTITY(1,1) NOT NULL,
	[org_id] [int] NULL,
	[src_file_name] [varchar](50) NULL,
	[response_file_name] [varchar](100) NULL,
	[file_count] [int] NULL,
	[is_deleted] [bit] NULL,
	[created_by] [varchar](50) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[updated_dt] [datetime] NULL,
	[process_status] [varchar](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[eappend_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[eappends_post]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[eappends_post](
	[eappend_post_id] [int] IDENTITY(1,1) NOT NULL,
	[eppend_log_id] [int] NULL,
	[customer_id] [int] NULL,
	[vehicle_year_make_model] [varchar](500) NULL,
	[first_name] [varchar](250) NULL,
	[last_name] [varchar](250) NULL,
	[address] [varchar](500) NULL,
	[city] [varchar](500) NULL,
	[state] [varchar](50) NULL,
	[zip_code] [varchar](20) NULL,
	[dealer_name] [varchar](250) NULL,
	[is_deleted] [bit] NULL,
	[created_by] [varchar](50) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[updated_dt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[eappend_post_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[email_dnc]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[email_dnc](
	[email_dnc_id] [int] IDENTITY(1,1) NOT NULL,
	[email_address] [varchar](50) NULL,
	[reason_id] [int] NULL,
	[is_deleted] [bit] NULL,
	[created_by] [varchar](50) NULL,
	[created_dt] [date] NULL,
	[updated_by] [varchar](50) NULL,
	[updated_dt] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[email_dnc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[employee_details]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[employee_details](
	[master_employee_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](25) NULL,
	[parent_dealer_id] [int] NULL,
	[employee_id] [varchar](100) NULL,
	[employee_name] [varchar](250) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_dt] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_dt] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
 CONSTRAINT [PK__master_employee_id] PRIMARY KEY CLUSTERED 
(
	[master_employee_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[fi_sales]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[fi_sales](
	[master_fi_sales_id] [bigint] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[master_customer_id] [int] NULL,
	[master_vehicle_id] [int] NULL,
	[cust_dms_number] [varchar](500) NULL,
	[vin] [varchar](20) NULL,
	[deal_number_dms] [varchar](500) NULL,
	[purchase_date] [int] NULL,
	[delivery_date] [int] NULL,
	[deal_date] [int] NULL,
	[close_deal_date] [int] NULL,
	[nuo_flag] [char](1) NULL,
	[invoice_price] [decimal](18, 2) NULL,
	[sale_type] [varchar](100) NULL,
	[pay_type] [varchar](100) NULL,
	[deal_status_date] [int] NULL,
	[deal_status] [varchar](250) NULL,
	[inventory_date] [int] NULL,
	[termination_date] [int] NULL,
	[mileage_in] [varchar](50) NULL,
	[mileage_out] [varchar](50) NULL,
	[contract_type] [varchar](100) NULL,
	[stock_id] [varchar](100) NULL,
	[vehicle_price] [decimal](18, 2) NULL,
	[vehicle_cost] [decimal](18, 2) NULL,
	[msrp] [decimal](18, 2) NULL,
	[reg_state] [varchar](20) NULL,
	[units_of_measure] [char](1) NULL,
	[list_price] [decimal](18, 2) NULL,
	[total_sale_credit_amount] [decimal](18, 2) NULL,
	[total_pickup_payment] [decimal](18, 2) NULL,
	[total_cashdown_payment] [decimal](18, 2) NULL,
	[total_rebate_amount] [decimal](18, 2) NULL,
	[total_taxes] [decimal](18, 2) NULL,
	[total_accessories] [decimal](18, 2) NULL,
	[total_feeandaccessories] [decimal](18, 2) NULL,
	[total_trade_allownce_amount] [decimal](18, 2) NULL,
	[total_trade_actuval_cashvalue] [decimal](18, 2) NULL,
	[total_trade_payoff] [decimal](18, 2) NULL,
	[total_net_trade_amount] [decimal](18, 2) NULL,
	[total_gross_profit] [decimal](18, 2) NULL,
	[backend_gross_profit] [decimal](18, 2) NULL,
	[frontend_gross_profit] [decimal](18, 2) NULL,
	[total_drive_of_amount] [decimal](18, 2) NULL,
	[net_captilized_cost] [decimal](18, 2) NULL,
	[sale_comments] [varchar](max) NULL,
	[total_finance_amount] [decimal](18, 2) NULL,
	[contract_term] [varchar](100) NULL,
	[monthly_payment] [decimal](18, 2) NULL,
	[total_of_payments] [decimal](18, 2) NULL,
	[first_payment_date] [int] NULL,
	[ballon_payment] [decimal](18, 2) NULL,
	[buy_rate] [decimal](18, 2) NULL,
	[total_estimated_miles] [decimal](18, 2) NULL,
	[total_mileage_limit] [decimal](18, 2) NULL,
	[resiudal_amount] [decimal](18, 2) NULL,
	[sales_manager_id] [varchar](50) NULL,
	[sales_manager_fullname] [varchar](500) NULL,
	[fin_manger_id] [varchar](50) NULL,
	[fin_manager_fullname] [varchar](500) NULL,
	[accident_health_cost] [decimal](18, 2) NULL,
	[accident_health_reserve] [decimal](18, 2) NULL,
	[credit_life_cost] [decimal](18, 2) NULL,
	[credit_life_reserve] [decimal](18, 2) NULL,
	[gap_cost] [decimal](18, 2) NULL,
	[gap_reserve] [decimal](18, 2) NULL,
	[loss_of_employement_cost] [decimal](18, 2) NULL,
	[loss_of_employement_reserve] [decimal](18, 2) NULL,
	[mechanical_breakdown_cost] [decimal](18, 2) NULL,
	[mechanical_breakdown_reserve] [decimal](18, 2) NULL,
	[service_contract_cost] [decimal](18, 2) NULL,
	[service_contract_reserve] [decimal](18, 2) NULL,
	[total_afm_cost] [decimal](18, 2) NULL,
	[vehicle_gross] [decimal](18, 2) NULL,
	[net_profit] [decimal](18, 2) NULL,
	[gross_cap_cost] [decimal](18, 2) NULL,
	[init_veh_cost] [decimal](18, 2) NULL,
	[vehicle_extended_dealer_cost] [decimal](18, 2) NULL,
	[vehicle_extended_customer_cost] [decimal](18, 2) NULL,
	[fleet_deal] [varchar](500) NULL,
	[afm_cost] [decimal](18, 2) NULL,
	[afm_code] [varchar](500) NULL,
	[afm_price] [decimal](18, 2) NULL,
	[afm_descr] [varchar](500) NULL,
	[deferred_payment] [decimal](18, 2) NULL,
	[afm_finance_price] [decimal](18, 2) NULL,
	[incentives] [decimal](18, 2) NULL,
	[rebate] [decimal](18, 2) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_by] [varchar](50) NULL,
	[last_sale_date] [int] NULL,
	[last_sale_mileage] [int] NULL,
	[last_sale_dealer] [varchar](20) NULL,
	[finance_apr] [varchar](100) NULL,
	[lease_end_date] [date] NULL,
 CONSTRAINT [PK__fi_sales__E6611BCAFB20B4C2] PRIMARY KEY CLUSTERED 
(
	[master_fi_sales_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[fi_sales_people]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[fi_sales_people](
	[master_sales_people_id] [int] IDENTITY(1,1) NOT NULL,
	[master_fi_sales_id] [int] NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[deal_number_dms] [varchar](50) NULL,
	[deal_date] [int] NULL,
	[purchase_date] [int] NULL,
	[sale_contact_id] [varchar](50) NULL,
	[sale_salutation] [varchar](50) NULL,
	[sale_first_name] [varchar](250) NULL,
	[sale_middle_name] [varchar](250) NULL,
	[sale_last_name] [varchar](250) NULL,
	[sale_suffix] [varchar](50) NULL,
	[sale_full_name] [varchar](500) NULL,
	[vin] [varchar](50) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_by] [varchar](50) NULL,
	[created_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [PK__sales_pe__63FB059BD0AB350A] PRIMARY KEY CLUSTERED 
(
	[master_sales_people_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[fi_sales_trade_vehicles]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[fi_sales_trade_vehicles](
	[master_trade_vehicle_id] [int] IDENTITY(1,1) NOT NULL,
	[master_fi_sales_id] [int] NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[deal_number_dms] [varchar](50) NULL,
	[deal_date] [int] NULL,
	[purchase_date] [int] NULL,
	[trade_vin] [varchar](60) NULL,
	[trade_type_code] [varchar](250) NULL,
	[trade_make] [varchar](50) NULL,
	[trade_model] [varchar](50) NULL,
	[trade_model_year] [varchar](50) NULL,
	[trade_trim_level] [varchar](50) NULL,
	[trade_sub_trim_level] [varchar](max) NULL,
	[trade_exterior_color_description] [varchar](max) NULL,
	[trade_body_description] [varchar](max) NULL,
	[trade_body_door_count] [varchar](max) NULL,
	[trade_transmission_description] [varchar](max) NULL,
	[trade_engine_description] [varchar](max) NULL,
	[trade_model_code] [varchar](max) NULL,
	[trade_allowance_amount] [decimal](11, 2) NULL,
	[trade_actual_cash_value] [decimal](11, 2) NULL,
	[trade_payoff_amount] [decimal](11, 2) NULL,
	[trade_net_trade_amount] [varchar](max) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_by] [varchar](50) NULL,
	[created_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [PK_trade_vehicles] PRIMARY KEY CLUSTERED 
(
	[master_trade_vehicle_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[list_status]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[list_status](
	[status_id] [int] IDENTITY(1,1) NOT NULL,
	[status_code] [varchar](50) NOT NULL,
	[description] [nchar](500) NULL,
 CONSTRAINT [PK_status_1] PRIMARY KEY CLUSTERED 
(
	[status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[list_suppress]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[list_suppress](
	[list_suppress_id] [int] IDENTITY(1,1) NOT NULL,
	[dealer_id] [int] NOT NULL,
	[list_name] [varchar](200) NOT NULL,
	[list_path] [nvarchar](500) NULL,
	[status_id] [int] NOT NULL,
	[is_deleted] [bit] NOT NULL,
	[created_dt] [datetime] NOT NULL,
	[created_by] [varchar](50) NOT NULL,
	[updated_dt] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
 CONSTRAINT [PK_list_suppress] PRIMARY KEY CLUSTERED 
(
	[list_suppress_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[make_model]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[make_model](
	[make_model_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](20) NULL,
	[make] [varchar](100) NULL,
	[model] [varchar](250) NULL,
	[created_dt] [datetime] NULL,
	[created_by] [varchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[master_data_counts]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[master_data_counts](
	[data_count_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](50) NULL,
	[src_dealer_code] [varchar](250) NULL,
	[etl_count] [int] NULL,
	[master_count] [int] NULL,
	[diff] [int] NULL,
	[type] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[data_count_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[natural_key]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[natural_key](
	[natural_key] [varchar](20) NULL,
	[oem_code] [varchar](10) NULL,
	[is_processed] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[ncoa_log]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[ncoa_log](
	[ncoa_log_id] [bigint] IDENTITY(1,1) NOT NULL,
	[file_log_id] [int] NULL,
	[src_file_name] [varchar](100) NULL,
	[response_file_name] [varchar](100) NULL,
	[status] [varchar](50) NULL,
	[is_deleted] [bit] NULL,
	[created_by] [varchar](30) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](30) NULL,
	[updated_dt] [datetime] NULL,
	[file_count] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ncoa_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[oem_adm]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[oem_adm](
	[adm_id] [int] NOT NULL,
	[oem_code] [varchar](50) NULL,
	[adm] [decimal](9, 2) NULL,
	[is_deleted] [bit] NULL,
	[created_by] [varchar](20) NULL,
	[created_dt] [smalldatetime] NULL,
	[updated_by] [varchar](20) NULL,
	[updated_dt] [smalldatetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[pace_premium_dealers_fb_event_offline]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[pace_premium_dealers_fb_event_offline](
	[dealer_name] [varchar](50) NULL,
	[offline_event_set_id] [varchar](50) NULL,
	[natural_key] [varchar](10) NULL,
	[update_dt] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[por_declined_comment]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[por_declined_comment](
	[master_ro_header_id] [int] NULL,
	[comment] [varchar](max) NULL,
	[program_type] [varchar](25) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](max) NULL,
	[declined_categories] [varchar](max) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NULL,
	[master_declined_text_id] [int] NULL,
	[qc_flag] [bit] NULL,
	[qc_date] [smalldatetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[por_declined_final]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[por_declined_final](
	[declined_final_id] [int] IDENTITY(1,1) NOT NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](10) NULL,
	[master_ro_header_id] [int] NULL,
	[master_ro_line_item_id] [int] NULL,
	[declined_source] [varchar](50) NULL,
	[declined_category_dode] [varchar](20) NULL,
	[declined_print_text] [varchar](max) NULL,
	[declined_priority] [smallint] NULL,
	[declined_suppressed] [bit] NULL,
	[declined_suppressed_reason] [varchar](255) NULL,
	[create_date] [smalldatetime] NULL,
	[processed_flag] [bit] NULL,
	[processed_date] [smalldatetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[declined_final_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[por_declined_text]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[por_declined_text](
	[master_decline_text_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NULL,
	[text_review_id] [int] NULL,
	[master_ro_header_id] [int] NOT NULL,
	[ro_number] [varchar](100) NOT NULL,
	[data_source] [varchar](100) NULL,
	[text_review] [varchar](max) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](4000) NULL,
	[declined_categories] [varchar](4000) NULL,
	[reviewed_date] [datetime] NULL,
	[program_type] [varchar](25) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](4000) NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[finalized_flag] [bit] NULL,
	[finalized_date] [smalldatetime] NULL,
 CONSTRAINT [PK_decline_id] PRIMARY KEY CLUSTERED 
(
	[master_decline_text_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[por_sr_interval_types]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[por_sr_interval_types](
	[interval_type_id] [int] IDENTITY(1,1) NOT NULL,
	[interval_id] [int] NULL,
	[minor_miles] [int] NULL,
	[major_miles] [int] NULL,
	[is_deleted] [bit] NULL,
	[created_dt] [datetime] NULL,
	[interval_type] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[por_sr_intervals]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[por_sr_intervals](
	[interval_id] [int] NOT NULL,
	[oem_code] [varchar](50) NULL,
	[model] [varchar](250) NULL,
	[trim] [varchar](250) NULL,
	[min_year] [int] NULL,
	[max_year] [int] NULL,
	[miles] [int] NULL,
	[days] [int] NULL,
	[is_deleted] [bit] NULL,
	[created_by] [varchar](20) NULL,
	[created_dt] [smalldatetime] NULL,
	[updated_by] [varchar](20) NULL,
	[updated_dt] [smalldatetime] NULL,
	[is_special] [bit] NULL,
	[oil_miles] [int] NULL,
	[oil_days] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[porsche_dealers]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[porsche_dealers](
	[dealer_code] [varchar](10) NULL,
	[pia_dealer_code] [varchar](10) NULL,
	[natural_key] [varchar](10) NULL,
	[dealer_id] [int] NULL,
	[dba_area] [varchar](50) NULL,
	[sales_reg] [varchar](50) NULL,
	[time_zone] [varchar](50) NULL,
	[digital_dealer_website_provider] [varchar](50) NULL,
	[dealer_primary_url] [varchar](50) NULL,
	[latitudes] [varchar](50) NULL,
	[longitudes] [varchar](50) NULL,
	[address] [varchar](500) NULL,
	[city] [varchar](50) NULL,
	[state] [varchar](50) NULL,
	[zip_code] [varchar](50) NULL,
	[phone_main] [varchar](50) NULL,
	[fax] [varchar](50) NULL,
	[porsche_regional_manager] [varchar](50) NULL,
	[regional_after_sales_mgr] [varchar](50) NULL,
	[area_marketing_mgr] [varchar](50) NULL,
	[porsche_dealer_service_marketing_pdms] [varchar](50) NULL,
	[digital_business_consultant] [varchar](50) NULL,
	[gm_sal] [varchar](50) NULL,
	[gm_first_name] [varchar](50) NULL,
	[gm_last_name] [varchar](50) NULL,
	[gm_nick_name] [varchar](50) NULL,
	[gm_email] [varchar](50) NULL,
	[gm_email_2] [varchar](50) NULL,
	[porsche_service_manager] [varchar](50) NULL,
	[dms] [varchar](50) NULL,
	[service_booking_url] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[porsche_dealers_del]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[porsche_dealers_del](
	[dealer_code] [varchar](10) NULL,
	[pia_dealer_code] [varchar](10) NULL,
	[natural_key] [varchar](10) NULL,
	[dba] [varchar](100) NULL,
	[area] [varchar](100) NULL,
	[sales_reg] [varchar](1000) NULL,
	[TIME  ZONE] [varchar](1000) NULL,
	[DIGITAL DEALER WEBSITE PROVIDER] [varchar](1000) NULL,
	[DEALER PRIMARY URL] [varchar](1000) NULL,
	[LATITUDES] [varchar](1000) NULL,
	[LONGITUDES ] [varchar](1000) NULL,
	[ADDRESS] [varchar](1000) NULL,
	[CITY] [varchar](1000) NULL,
	[STATE] [varchar](1000) NULL,
	[ZIP CODE] [varchar](1000) NULL,
	[PHONE-MAIN] [varchar](1000) NULL,
	[FAX] [varchar](1000) NULL,
	[Porsche Regional Manager] [varchar](1000) NULL,
	[REGIONAL AFTERSALES MGR ] [varchar](1000) NULL,
	[AREA MARKETING MGR] [varchar](1000) NULL,
	[PORSCHE DEALER MARKETING  SERVICES CONSULTANT (PDMS)] [varchar](1000) NULL,
	[DIGITAL BUSINESS CONSULTANT] [varchar](1000) NULL,
	[GM SAL] [varchar](1000) NULL,
	[GM FIRST NAME] [varchar](1000) NULL,
	[GM LAST NAME] [varchar](1000) NULL,
	[GM NICK NAME] [varchar](1000) NULL,
	[GM EMAIL] [varchar](1000) NULL,
	[GM EMAIL 2] [varchar](1000) NULL,
	[PORSCHE SERVICE MANAGER] [varchar](1000) NULL,
	[DMS] [varchar](1000) NULL,
	[Service Booking URL] [varchar](1000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[rci_header_comment]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[rci_header_comment](
	[rci_header_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](25) NULL,
	[parent_dealer_id] [int] NULL,
	[ro_close_date] [int] NULL,
	[vin] [varchar](20) NULL,
	[ro_number] [varchar](10) NULL,
	[tech_rec_comment] [varchar](max) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[rci_header_comment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_header]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_header](
	[master_ro_header_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[master_customer_id] [int] NOT NULL,
	[master_vehicle_id] [int] NOT NULL,
	[vin] [varchar](25) MASKED WITH (FUNCTION = 'partial(0, "XXXXXXXXX", 8)') NULL,
	[ro_number] [varchar](100) NULL,
	[ro_open_date] [int] NULL,
	[ro_close_date] [int] NULL,
	[ro_invoice_date] [int] NULL,
	[in_service_date] [int] NULL,
	[first_ro_date] [int] NULL,
	[last_ro_date] [int] NULL,
	[last_activity_date] [int] NULL,
	[promise_date] [int] NULL,
	[delivery_date] [int] NULL,
	[veh_pick_up_date] [int] NULL,
	[last_ro_number] [varchar](50) NULL,
	[mileage_in] [int] NULL,
	[mileage_out] [int] NULL,
	[last_mileage_odometer] [int] NULL,
	[service_days] [int] NULL,
	[no_of_visits] [int] NULL,
	[ro_status] [varchar](50) NULL,
	[warr_post_dt] [varchar](15) NULL,
	[veh_priority] [varchar](50) NULL,
	[tag_no] [varchar](50) NULL,
	[appt_flag] [varchar](50) NULL,
	[disp_no] [varchar](50) NULL,
	[dept_type] [varchar](100) NULL,
	[sa_number] [varchar](50) NULL,
	[sa_name] [varchar](250) NULL,
	[is_declined] [bit] NULL,
	[total_billed_labor_hours] [decimal](18, 2) NULL,
	[total_customer_cost] [decimal](18, 2) NULL,
	[total_customer_gog_cost] [decimal](18, 2) NULL,
	[total_customer_gog_price] [decimal](18, 2) NULL,
	[total_customer_labor_cost] [decimal](18, 2) NULL,
	[total_customer_labor_price] [decimal](18, 2) NULL,
	[total_customer_misc_cost] [decimal](18, 2) NULL,
	[total_customer_misc_price] [decimal](18, 2) NULL,
	[total_customer_parts_cost] [decimal](18, 2) NULL,
	[total_customer_parts_price] [decimal](18, 2) NULL,
	[total_customer_price] [decimal](18, 2) NULL,
	[total_customer_sublet_cost] [decimal](18, 2) NULL,
	[total_customer_sublet_price] [decimal](18, 2) NULL,
	[total_gog_cost] [decimal](18, 2) NULL,
	[total_internal_cost] [decimal](18, 2) NULL,
	[total_internal_gog_cost] [decimal](18, 2) NULL,
	[total_internal_gog_price] [decimal](18, 2) NULL,
	[total_internal_labor_cost] [decimal](18, 2) NULL,
	[total_internal_labor_price] [decimal](18, 2) NULL,
	[total_internal_misc_cost] [decimal](18, 2) NULL,
	[total_internal_misc_price] [decimal](18, 2) NULL,
	[total_internal_parts_cost] [decimal](18, 2) NULL,
	[total_internal_parts_price] [decimal](18, 2) NULL,
	[total_internal_price] [decimal](18, 2) NULL,
	[total_internal_sublet_cost] [decimal](18, 2) NULL,
	[total_internal_sublet_price] [decimal](18, 2) NULL,
	[total_gog_price] [decimal](18, 2) NULL,
	[total_warranty_gog_cost] [decimal](18, 2) NULL,
	[total_warranty_gog_price] [decimal](18, 2) NULL,
	[total_warranty_labor_cost] [decimal](18, 2) NULL,
	[total_warranty_labor_price] [decimal](18, 2) NULL,
	[total_warranty_misc_cost] [decimal](18, 2) NULL,
	[total_warranty_misc_price] [decimal](18, 2) NULL,
	[total_warranty_parts_cost] [decimal](18, 2) NULL,
	[total_warranty_parts_price] [decimal](18, 2) NULL,
	[total_warranty_price] [decimal](18, 2) NULL,
	[total_warranty_sublet_cost] [decimal](18, 2) NULL,
	[total_warranty_sublet_price] [decimal](18, 2) NULL,
	[total_repair_order_cost] [decimal](18, 2) NULL,
	[total_repair_order_price] [decimal](18, 2) NULL,
	[total_sublet_cost] [decimal](18, 2) NULL,
	[total_sublet_price] [decimal](18, 2) NULL,
	[total_tax_price] [decimal](18, 2) NULL,
	[total_warranty_cost] [decimal](18, 2) NULL,
	[total_parts_price] [decimal](18, 2) NULL,
	[total_misc_price] [decimal](18, 2) NULL,
	[total_misc_cost] [decimal](18, 2) NULL,
	[total_labor_price] [decimal](18, 2) NULL,
	[total_labor_cost] [decimal](18, 2) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_by] [varchar](50) NULL,
	[service_only_flag] [bit] NULL,
	[first_ro_mileage] [int] NULL,
	[last_ro_mileage] [int] NULL,
	[is_deleted] [bit] NULL,
	[svc_mileage] [int] NULL,
	[decline_svc_comment] [varchar](max) NULL,
	[total_ro_amount] [decimal](18, 2) NULL,
 CONSTRAINT [PK__repair_o__C165F894A41022DEEPU] PRIMARY KEY CLUSTERED 
(
	[master_ro_header_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_header_comments]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_header_comments](
	[ro_header_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[master_ro_header_id] [bigint] NULL,
	[natural_key] [varchar](10) NULL,
	[ro_number] [varchar](15) NULL,
	[ro_open_date] [int] NULL,
	[ro_close_date] [int] NULL,
	[vin] [varchar](20) NULL,
	[ro_tech_comments] [varchar](max) NULL,
	[ro_cust_comments] [varchar](max) NULL,
	[ro_comment] [varchar](max) NULL,
	[source_type] [varchar](20) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_dt] [datetime] NULL,
	[created_by] [varchar](250) NULL,
	[updated_dt] [datetime] NULL,
	[updated_by] [varchar](250) NULL,
 CONSTRAINT [PK__repair_o__C879E13F5815CBFE] PRIMARY KEY CLUSTERED 
(
	[ro_header_comment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_header_detail]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_header_detail](
	[master_ro_detail_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_Dealer_id] [int] NOT NULL,
	[master_ro_header_id] [int] NULL,
	[master_ro_op_code_id] [int] NULL,
	[ro_number] [varchar](250) NULL,
	[ro_closed_date] [int] NULL,
	[op_code] [varchar](250) NULL,
	[op_code_desc] [varchar](4000) NULL,
	[op_code_sequence] [int] NULL,
	[declined_comment] [varchar](4000) NULL,
	[is_declined_opcode] [bit] NULL,
	[actual_labor_hours] [decimal](10, 2) NULL,
	[billed_labor_hours] [decimal](10, 2) NULL,
	[billing_rate] [decimal](10, 2) NULL,
	[opcode_pay_type] [varchar](50) NULL,
	[total_labor_cost] [decimal](18, 2) NULL,
	[total_parts_cost] [decimal](18, 2) NULL,
	[total_labor_price] [decimal](18, 2) NULL,
	[total_parts_price] [decimal](18, 2) NULL,
	[total_misc_cost] [decimal](18, 2) NULL,
	[total_misc_price] [decimal](18, 2) NULL,
	[ro_comment] [varchar](max) NULL,
	[technician_comment] [varchar](max) NULL,
	[customer_comment] [varchar](max) NULL,
	[technician_recomended] [varchar](max) NULL,
	[technician_note] [varchar](max) NULL,
	[upsell_flag] [varchar](10) NULL,
	[opcode_category_id] [int] NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_by] [varchar](50) NULL,
	[ro_opcode_id] [int] NULL,
	[svc_mileage] [int] NULL,
	[svc_year] [int] NULL,
	[opcode_category_codes] [varchar](100) NULL,
	[is_processed] [int] NULL,
	[performed_services] [varchar](500) NULL,
	[recommended_services] [varchar](500) NULL,
	[declined_services] [varchar](500) NULL,
	[is_performed] [bit] NULL,
	[is_recommended] [bit] NULL,
	[is_declined] [bit] NULL,
	[svc_int_mileage] [int] NULL,
	[total_warranty_amount] [decimal](9, 2) NULL,
	[total_customer_amount] [decimal](9, 2) NULL,
	[total_internal_amount] [decimal](9, 2) NULL,
	[total_labor_amount] [decimal](18, 2) NULL,
	[total_misc_amount] [decimal](18, 2) NULL,
	[total_parts_amount] [decimal](18, 2) NULL,
 CONSTRAINT [PK_repair_orders_detail] PRIMARY KEY CLUSTERED 
(
	[master_ro_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_keywords]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_keywords](
	[Category] [nvarchar](max) NULL,
	[KeywordGroup] [float] NULL,
	[NotKeyword] [float] NULL,
	[TriggerKeyword] [varchar](200) NOT NULL,
	[created_date] [smalldatetime] NULL,
	[created_by] [varchar](100) NULL,
	[updated_date] [smalldatetime] NULL,
	[updated_by] [varchar](100) NULL,
	[opcode_category_id] [int] NOT NULL,
 CONSTRAINT [keyword_u] UNIQUE NONCLUSTERED 
(
	[TriggerKeyword] ASC,
	[opcode_category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_old]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_old](
	[master_ro_detail_id] [int] NOT NULL,
	[comment] [varchar](max) NULL,
	[program_type] [varchar](25) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](max) NULL,
	[declined_categories] [varchar](max) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NULL,
	[master_declined_text_id] [int] NULL,
	[qc_flag] [bit] NULL,
	[qc_date] [smalldatetime] NULL,
	[split_sentences] [varchar](max) NULL,
	[recommend_sentences] [varchar](max) NULL,
	[performed_sentences] [varchar](max) NULL,
	[recommend_extract_words] [varchar](max) NULL,
	[performed_extract_words] [varchar](max) NULL,
	[declined_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[is_processed] [bit] NOT NULL,
	[svc_mileage] [varchar](10) NULL,
	[opcode_category_id] [int] NULL,
	[master_ro_header_id] [bigint] NULL,
	[vin] [varchar](20) NULL,
	[svc_year] [int] NULL,
	[opcode_categories] [varchar](40) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_opcode_category]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_opcode_category](
	[opcode_category_id] [int] IDENTITY(1,1) NOT NULL,
	[opcode_category_code] [varchar](20) NOT NULL,
	[opcode_category_desc] [varchar](100) NOT NULL,
	[is_deleted] [bit] NOT NULL,
	[created_by] [varchar](50) NOT NULL,
	[created_date] [datetime] NOT NULL,
	[updated_by] [varchar](50) NOT NULL,
	[updated_date] [datetime] NOT NULL,
 CONSTRAINT [PK_repair_order_opcode_category] PRIMARY KEY CLUSTERED 
(
	[opcode_category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_opcode_del]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_opcode_del](
	[ro_opcode_id] [int] IDENTITY(1,1) NOT NULL,
	[opcode_category_id] [int] NOT NULL,
	[parent_dealer_id] [int] NULL,
	[natural_key] [varchar](10) NOT NULL,
	[op_code] [varchar](250) NOT NULL,
	[op_code_desc] [varchar](4000) NULL,
	[mileage] [int] NULL,
	[is_deleted] [bit] NOT NULL,
	[created_by] [varchar](50) NOT NULL,
	[created_date] [datetime] NOT NULL,
	[updated_by] [varchar](50) NOT NULL,
	[updated_date] [datetime] NOT NULL,
	[is_reviewed] [bit] NULL,
	[reviewed_by] [varchar](50) NULL,
	[reviewed_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_opcode_detail]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_opcode_detail](
	[repair_order_opcode_detail_id] [int] IDENTITY(1,1) NOT NULL,
	[repair_order_header_detail_id] [int] NOT NULL,
	[op_code_desc] [varchar](max) NULL,
	[performed_services] [varchar](max) NULL,
	[recommended_services] [varchar](max) NULL,
	[declined_services] [varchar](500) NULL,
	[is_performed] [bit] NULL,
	[is_recommended] [bit] NULL,
	[is_declined] [bit] NULL,
	[created_dt] [smalldatetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_dt] [smalldatetime] NULL,
	[updated_by] [varchar](50) NULL,
 CONSTRAINT [PK_repair_order_opcode_detail] PRIMARY KEY CLUSTERED 
(
	[repair_order_opcode_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_opcode_details]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_opcode_details](
	[ro_opcode_detail_id] [bigint] IDENTITY(1,1) NOT NULL,
	[master_ro_detail_id] [int] NOT NULL,
	[op_code_desc] [varchar](4000) NOT NULL,
	[performed_services] [varchar](500) NULL,
	[recommended_services] [varchar](500) NULL,
	[declined_services] [varchar](500) NULL,
	[is_performed] [bit] NOT NULL,
	[is_recommended] [bit] NOT NULL,
	[is_declined] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL,
	[created_dt] [smalldatetime] NOT NULL,
	[created_by] [varchar](50) NOT NULL,
	[updated_dt] [smalldatetime] NULL,
	[updated_by] [varchar](50) NULL,
 CONSTRAINT [PK__repair_o__567D40D7AD7AE77E] PRIMARY KEY CLUSTERED 
(
	[ro_opcode_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_opcodes]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_opcodes](
	[ro_opcode_id] [int] IDENTITY(1,1) NOT NULL,
	[opcode_category_id] [int] NOT NULL,
	[parent_dealer_id] [int] NULL,
	[natural_key] [varchar](10) NOT NULL,
	[op_code] [varchar](250) NOT NULL,
	[op_code_desc] [varchar](4000) NULL,
	[mileage] [int] NULL,
	[is_deleted] [bit] NOT NULL,
	[created_by] [varchar](50) NOT NULL,
	[created_date] [datetime] NOT NULL,
	[updated_by] [varchar](50) NOT NULL,
	[updated_date] [datetime] NOT NULL,
	[is_reviewed] [bit] NULL,
	[reviewed_by] [varchar](50) NULL,
	[reviewed_date] [datetime] NULL,
	[is_ignored] [bit] NOT NULL,
 CONSTRAINT [PK_repair_order_opcodes] PRIMARY KEY CLUSTERED 
(
	[ro_opcode_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_opcodes_test]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_opcodes_test](
	[ro_opcode_id] [int] IDENTITY(1,1) NOT NULL,
	[opcode_category_id] [int] NOT NULL,
	[parent_dealer_id] [int] NULL,
	[natural_key] [varchar](10) NOT NULL,
	[op_code] [varchar](250) NOT NULL,
	[op_code_desc] [varchar](4000) NULL,
	[mileage] [int] NULL,
	[is_deleted] [bit] NOT NULL,
	[created_by] [varchar](50) NOT NULL,
	[created_date] [datetime] NOT NULL,
	[updated_by] [varchar](50) NOT NULL,
	[updated_date] [datetime] NOT NULL,
	[is_reviewed] [bit] NULL,
	[reviewed_by] [varchar](50) NULL,
	[reviewed_date] [datetime] NULL,
	[is_ignored] [bit] NOT NULL,
	[is_checked] [int] NULL,
 CONSTRAINT [PK_repair_order_opcodes_] PRIMARY KEY CLUSTERED 
(
	[ro_opcode_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_text]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_text](
	[master_repair_order_text_id] [bigint] IDENTITY(1,1) NOT NULL,
	[master_ro_detail_id] [bigint] NULL,
	[master_ro_header_id] [bigint] NULL,
	[vin] [varchar](17) NULL,
	[natural_key] [varchar](10) NULL,
	[opcode_category_id] [int] NULL,
	[svc_mileage] [varchar](10) NULL,
	[svc_year] [int] NULL,
	[opcode_categories] [varchar](40) NULL,
	[processed_date] [smalldatetime] NULL,
	[comment] [varchar](max) NULL,
	[is_processed] [bit] NOT NULL,
	[is_reviewed] [bit] NOT NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[confidence_level] [varchar](15) NULL,
 CONSTRAINT [PK__repair_o__813824E3349CD6C9] PRIMARY KEY CLUSTERED 
(
	[master_repair_order_text_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_text_AGPO]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_text_AGPO](
	[master_ro_detail_id] [int] NOT NULL,
	[comment] [varchar](max) NULL,
	[program_type] [varchar](25) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](max) NULL,
	[declined_categories] [varchar](max) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NULL,
	[master_declined_text_id] [int] NULL,
	[qc_flag] [bit] NULL,
	[qc_date] [smalldatetime] NULL,
	[split_sentences] [varchar](max) NULL,
	[recommend_sentences] [varchar](max) NULL,
	[performed_sentences] [varchar](max) NULL,
	[recommend_extract_words] [varchar](max) NULL,
	[performed_extract_words] [varchar](max) NULL,
	[declined_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[is_processed] [bit] NOT NULL,
	[svc_mileage] [varchar](10) NULL,
	[opcode_category_id] [int] NULL,
	[master_ro_header_id] [bigint] NULL,
	[vin] [varchar](20) NULL,
	[svc_year] [int] NULL,
	[opcode_categories] [varchar](40) NULL,
	[confidence_level] [varchar](15) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_text_D2D]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_text_D2D](
	[master_ro_detail_id] [int] NOT NULL,
	[comment] [varchar](max) NULL,
	[program_type] [varchar](25) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](max) NULL,
	[declined_categories] [varchar](max) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NULL,
	[master_declined_text_id] [int] NULL,
	[qc_flag] [bit] NULL,
	[qc_date] [smalldatetime] NULL,
	[split_sentences] [varchar](max) NULL,
	[recommend_sentences] [varchar](max) NULL,
	[performed_sentences] [varchar](max) NULL,
	[recommend_extract_words] [varchar](max) NULL,
	[performed_extract_words] [varchar](max) NULL,
	[declined_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[is_processed] [bit] NOT NULL,
	[svc_mileage] [varchar](10) NULL,
	[opcode_category_id] [int] NULL,
	[master_ro_header_id] [bigint] NULL,
	[vin] [varchar](20) NULL,
	[svc_year] [int] NULL,
	[opcode_categories] [varchar](40) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_text_DD2]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_text_DD2](
	[master_ro_detail_id] [int] NOT NULL,
	[comment] [varchar](max) NULL,
	[program_type] [varchar](25) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](max) NULL,
	[declined_categories] [varchar](max) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NULL,
	[master_declined_text_id] [int] NULL,
	[qc_flag] [bit] NULL,
	[qc_date] [smalldatetime] NULL,
	[split_sentences] [varchar](max) NULL,
	[recommend_sentences] [varchar](max) NULL,
	[performed_sentences] [varchar](max) NULL,
	[recommend_extract_words] [varchar](max) NULL,
	[performed_extract_words] [varchar](max) NULL,
	[declined_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[is_processed] [bit] NOT NULL,
	[svc_mileage] [varchar](10) NULL,
	[opcode_category_id] [int] NULL,
	[master_ro_header_id] [bigint] NULL,
	[vin] [varchar](20) NULL,
	[svc_year] [int] NULL,
	[opcode_categories] [varchar](40) NULL,
	[ro_close_date] [date] NULL,
	[ro_open_date] [date] NULL,
	[milege_in] [int] NULL,
	[mileage_out] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_text_DD2_IHB]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_text_DD2_IHB](
	[master_ro_detail_id] [int] NOT NULL,
	[comment] [varchar](max) NULL,
	[program_type] [varchar](25) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](max) NULL,
	[declined_categories] [varchar](max) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NULL,
	[master_declined_text_id] [int] NULL,
	[qc_flag] [bit] NULL,
	[qc_date] [smalldatetime] NULL,
	[split_sentences] [varchar](max) NULL,
	[recommend_sentences] [varchar](max) NULL,
	[performed_sentences] [varchar](max) NULL,
	[recommend_extract_words] [varchar](max) NULL,
	[performed_extract_words] [varchar](max) NULL,
	[declined_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[is_processed] [bit] NOT NULL,
	[svc_mileage] [varchar](10) NULL,
	[opcode_category_id] [int] NULL,
	[master_ro_header_id] [bigint] NULL,
	[vin] [varchar](20) NULL,
	[svc_year] [int] NULL,
	[opcode_categories] [varchar](40) NULL,
	[ro_close_date] [date] NULL,
	[ro_open_date] [date] NULL,
	[milege_in] [int] NULL,
	[mileage_out] [int] NULL,
	[confidence_level] [varchar](15) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_text_GM]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_text_GM](
	[master_ro_detail_id] [int] NOT NULL,
	[comment] [varchar](max) NULL,
	[program_type] [varchar](25) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](max) NULL,
	[declined_categories] [varchar](max) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NULL,
	[master_declined_text_id] [int] NULL,
	[qc_flag] [bit] NULL,
	[qc_date] [smalldatetime] NULL,
	[split_sentences] [varchar](max) NULL,
	[recommend_sentences] [varchar](max) NULL,
	[performed_sentences] [varchar](max) NULL,
	[recommend_extract_words] [varchar](max) NULL,
	[performed_extract_words] [varchar](max) NULL,
	[declined_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[is_processed] [bit] NOT NULL,
	[svc_mileage] [varchar](10) NULL,
	[opcode_category_id] [int] NULL,
	[master_ro_header_id] [bigint] NULL,
	[vin] [varchar](20) NULL,
	[svc_year] [int] NULL,
	[opcode_categories] [varchar](40) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_text_GM2]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_text_GM2](
	[master_ro_detail_id] [int] NOT NULL,
	[comment] [varchar](max) NULL,
	[program_type] [varchar](25) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](max) NULL,
	[declined_categories] [varchar](max) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NULL,
	[master_declined_text_id] [int] NULL,
	[qc_flag] [bit] NULL,
	[qc_date] [smalldatetime] NULL,
	[split_sentences] [varchar](max) NULL,
	[recommend_sentences] [varchar](max) NULL,
	[performed_sentences] [varchar](max) NULL,
	[recommend_extract_words] [varchar](max) NULL,
	[performed_extract_words] [varchar](max) NULL,
	[declined_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[is_processed] [bit] NOT NULL,
	[svc_mileage] [varchar](10) NULL,
	[opcode_category_id] [int] NULL,
	[master_ro_header_id] [bigint] NULL,
	[vin] [varchar](20) NULL,
	[svc_year] [int] NULL,
	[opcode_categories] [varchar](40) NULL,
	[ro_close_date] [date] NULL,
	[ro_open_date] [date] NULL,
	[milege_in] [int] NULL,
	[mileage_out] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_text_jose]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_text_jose](
	[master_ro_detail_id] [int] NOT NULL,
	[comment] [varchar](max) NULL,
	[program_type] [varchar](25) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](max) NULL,
	[declined_categories] [varchar](max) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NULL,
	[master_declined_text_id] [int] NULL,
	[qc_flag] [bit] NULL,
	[qc_date] [smalldatetime] NULL,
	[split_sentences] [varchar](max) NULL,
	[recommend_sentences] [varchar](max) NULL,
	[performed_sentences] [varchar](max) NULL,
	[recommend_extract_words] [varchar](max) NULL,
	[performed_extract_words] [varchar](max) NULL,
	[declined_comment_id] [int] NOT NULL,
	[is_processed] [bit] NOT NULL,
	[svc_mileage] [varchar](10) NULL,
	[opcode_category_id] [int] NULL,
	[master_ro_header_id] [bigint] NULL,
	[vin] [varchar](20) NULL,
	[svc_year] [int] NULL,
	[opcode_categories] [varchar](40) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_text_POHK]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_text_POHK](
	[master_ro_detail_id] [int] NOT NULL,
	[comment] [varchar](max) NULL,
	[program_type] [varchar](25) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](max) NULL,
	[declined_categories] [varchar](max) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NULL,
	[master_declined_text_id] [int] NULL,
	[qc_flag] [bit] NULL,
	[qc_date] [smalldatetime] NULL,
	[split_sentences] [varchar](max) NULL,
	[recommend_sentences] [varchar](max) NULL,
	[performed_sentences] [varchar](max) NULL,
	[recommend_extract_words] [varchar](max) NULL,
	[performed_extract_words] [varchar](max) NULL,
	[declined_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[is_processed] [bit] NOT NULL,
	[svc_mileage] [varchar](10) NULL,
	[opcode_category_id] [int] NULL,
	[master_ro_header_id] [bigint] NULL,
	[vin] [varchar](20) NULL,
	[svc_year] [int] NULL,
	[opcode_categories] [varchar](40) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_text_porsche]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_text_porsche](
	[master_ro_detail_id] [int] NOT NULL,
	[comment] [varchar](max) NULL,
	[program_type] [varchar](25) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](max) NULL,
	[declined_categories] [varchar](max) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NULL,
	[master_declined_text_id] [int] NULL,
	[qc_flag] [bit] NULL,
	[qc_date] [smalldatetime] NULL,
	[split_sentences] [varchar](max) NULL,
	[recommend_sentences] [varchar](max) NULL,
	[performed_sentences] [varchar](max) NULL,
	[recommend_extract_words] [varchar](max) NULL,
	[performed_extract_words] [varchar](max) NULL,
	[declined_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[is_processed] [bit] NOT NULL,
	[svc_mileage] [varchar](10) NULL,
	[opcode_category_id] [int] NULL,
	[master_ro_header_id] [bigint] NULL,
	[vin] [varchar](20) NULL,
	[svc_year] [int] NULL,
	[opcode_categories] [varchar](40) NULL,
	[ro_close_date] [date] NULL,
	[ro_open_date] [date] NULL,
	[milege_in] [int] NULL,
	[mileage_out] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_order_text_porsche2]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_order_text_porsche2](
	[master_ro_detail_id] [int] NOT NULL,
	[comment] [varchar](max) NULL,
	[program_type] [varchar](25) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](max) NULL,
	[declined_categories] [varchar](max) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[master_dealer_id] [int] NULL,
	[natural_key] [varchar](25) NULL,
	[master_declined_text_id] [int] NULL,
	[qc_flag] [bit] NULL,
	[qc_date] [smalldatetime] NULL,
	[split_sentences] [varchar](max) NULL,
	[recommend_sentences] [varchar](max) NULL,
	[performed_sentences] [varchar](max) NULL,
	[recommend_extract_words] [varchar](max) NULL,
	[performed_extract_words] [varchar](max) NULL,
	[declined_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[is_processed] [bit] NOT NULL,
	[svc_mileage] [varchar](10) NULL,
	[opcode_category_id] [int] NULL,
	[master_ro_header_id] [bigint] NULL,
	[vin] [varchar](20) NULL,
	[svc_year] [int] NULL,
	[opcode_categories] [varchar](40) NULL,
	[ro_close_date] [date] NULL,
	[ro_open_date] [date] NULL,
	[milege_in] [int] NULL,
	[mileage_out] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[repair_orders_text]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[repair_orders_text](
	[master_repair_order_text_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NULL,
	[text_review_id] [int] NULL,
	[master_ro_header_id] [int] NOT NULL,
	[ro_number] [varchar](100) NOT NULL,
	[data_source] [varchar](100) NULL,
	[text_review] [varchar](max) NULL,
	[declined_found] [bit] NULL,
	[triggers_found] [varchar](4000) NULL,
	[declined_categories] [varchar](4000) NULL,
	[reviewed_date] [datetime] NULL,
	[program_type] [varchar](25) NULL,
	[exclusion_flag] [bit] NULL,
	[exclusion_keywords] [varchar](4000) NULL,
	[master_dealer_id] [int] NULL,
	[finalized_flag] [bit] NULL,
	[finalized_date] [smalldatetime] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
 CONSTRAINT [PK_ro_text_id] PRIMARY KEY CLUSTERED 
(
	[master_repair_order_text_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[ro_detail_comments]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[ro_detail_comments](
	[master_ro_detail_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[master_ro_detail_id] [int] NULL,
	[master_ro_header_id] [int] NULL,
	[ro_comment] [varchar](max) NULL,
	[technician_comment] [varchar](max) NULL,
	[customer_comment] [varchar](max) NULL,
	[declined_comment] [varchar](max) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [PK__ro_detai__B530874230D80D079] PRIMARY KEY CLUSTERED 
(
	[master_ro_detail_comment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[ro_detail_rec_service]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[ro_detail_rec_service](
	[ro_rec_svc_id] [bigint] IDENTITY(1,1) NOT NULL,
	[master_ro_detail_id] [int] NULL,
	[master_ro_header_id] [int] NULL,
	[rec_svc_performace_flag] [varchar](50) NULL,
	[rec_svc_opcode] [varchar](800) NULL,
	[rec_svc_opcode_desc] [varchar](max) NULL,
	[rec_svc_tech_comment] [varchar](max) NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](100) NULL,
	[updated_date] [datetime] NULL,
	[updated_by] [varchar](100) NULL,
	[parent_dealer_id] [int] NULL,
	[natural_key] [varchar](20) NULL,
 CONSTRAINT [PK__ro_recom__7621E026C72CBEF0] PRIMARY KEY CLUSTERED 
(
	[ro_rec_svc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[ro_detail_technicians]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[ro_detail_technicians](
	[master_ro_detail_tech_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_Dealer_id] [int] NOT NULL,
	[master_ro_detail_id] [int] NULL,
	[master_ro_header_id] [int] NULL,
	[tech_no] [varchar](50) NULL,
	[tech_name] [varchar](250) NULL,
	[cust_tech_rate] [decimal](18, 2) NULL,
	[warr_tech_rate] [decimal](18, 2) NULL,
	[intr_tech_rate] [decimal](18, 2) NULL,
	[tech_hrs] [decimal](18, 2) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_by] [varchar](50) NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [PK__ro_detai__609E5DAD1A98B7D07] PRIMARY KEY CLUSTERED 
(
	[master_ro_detail_tech_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[ro_header_comments]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[ro_header_comments](
	[ro_header_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[master_ro_header_id] [bigint] NULL,
	[natural_key] [varchar](10) NULL,
	[ro_number] [varchar](15) NULL,
	[ro_open_date] [int] NULL,
	[ro_close_date] [int] NULL,
	[vin] [varchar](20) NULL,
	[ro_tech_comments] [varchar](max) NULL,
	[ro_cust_comments] [varchar](max) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_dt] [datetime] NULL,
	[created_by] [varchar](250) NULL,
	[updated_dt] [datetime] NULL,
	[updated_by] [varchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[ro_header_comment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [master].[ro_op_codes]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[ro_op_codes](
	[master_ro_op_code_id] [int] IDENTITY(1,1) NOT NULL,
	[op_code] [varchar](100) NULL,
	[op_code_desc] [varchar](4000) NULL,
	[op_code_service_desc_id] [int] NULL,
	[is_deleted] [int] NULL,
	[created_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_by] [varchar](50) NULL,
	[op_category_id] [int] NULL,
 CONSTRAINT [PK__ro_op_co__3B55FD4DB9AD542CC] PRIMARY KEY CLUSTERED 
(
	[master_ro_op_code_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[ro_op_codes_category]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[ro_op_codes_category](
	[op_category_id] [int] IDENTITY(1,1) NOT NULL,
	[opcode_category_id] [int] NULL,
	[op_category_desc] [varchar](5000) NULL,
	[category_group] [varchar](5000) NULL,
	[mileage] [int] NULL,
	[src_opcode_category_id] [int] NULL,
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](50) NOT NULL,
	[updated_date] [datetime] NOT NULL,
	[updated_by] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ro_op_codes_category] PRIMARY KEY CLUSTERED 
(
	[op_category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[ro_op_codes_keyword_group]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[ro_op_codes_keyword_group](
	[keyword_id] [int] NOT NULL,
	[op_category_id] [int] NULL,
	[keyword_group_id] [int] NULL,
	[keyword] [varchar](800) NULL,
	[not_keyword] [int] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[ro_op_codes_keywords]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[ro_op_codes_keywords](
	[op_keyword_id] [int] NOT NULL,
	[op_category_id] [int] NULL,
	[keyword_id] [int] NULL,
	[op_category_desc] [varchar](1000) NULL,
	[keyword_group_id] [int] NULL,
	[keyword] [varchar](800) NULL,
	[not_keyword] [int] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[src_opcode_category_id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[ro_parts_details]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[ro_parts_details](
	[master_ro_parts_detail_id] [int] IDENTITY(1,1) NOT NULL,
	[master_ro_header_id] [int] NULL,
	[master_ro_detail_id] [int] NULL,
	[ro_number] [varchar](50) NULL,
	[part_sequence] [int] NULL,
	[part_number] [varchar](50) NULL,
	[part_desc] [varchar](500) NULL,
	[part_quantity] [int] NULL,
	[indv_unit_part_cost] [decimal](18, 2) NULL,
	[indv_unit_part_sale] [decimal](18, 2) NULL,
	[file_log_id] [int] NULL,
	[created_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_by] [varchar](50) NULL,
	[parent_dealer_id] [int] NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[file_log_detail_id] [int] NULL,
 CONSTRAINT [PK__ro_parts__1F0C868432A0BF000] PRIMARY KEY CLUSTERED 
(
	[master_ro_parts_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[service_appts]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[service_appts](
	[master_srv_appt_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](50) NULL,
	[parent_Dealer_id] [int] NULL,
	[master_customer_id] [int] NULL,
	[master_vehicle_id] [int] NULL,
	[appt_id] [varchar](50) NULL,
	[appt_date] [varchar](50) NULL,
	[appt_time] [varchar](50) NULL,
	[vin] [varchar](20) NULL,
	[service_advisor_id] [varchar](50) NULL,
	[service_advisor_name] [varchar](250) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_dt] [datetime] NULL,
	[created_by] [varchar](100) NULL,
	[updated_dt] [datetime] NULL,
	[updated_by] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[source_type]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[source_type](
	[source_type_id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[source_type] [varchar](250) NOT NULL,
	[is_deleted] [bit] NOT NULL,
	[created_dt] [datetime] NOT NULL,
	[created_by] [varchar](250) NOT NULL,
	[updated_by] [varchar](250) NULL,
	[updated_dt] [datetime] NULL,
	[source_type_code] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[sr_interval_types_new]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[sr_interval_types_new](
	[interval_type_id] [int] IDENTITY(1,1) NOT NULL,
	[interval_id] [int] NULL,
	[interval_type] [varchar](50) NULL,
	[miles] [int] NULL,
	[months] [int] NULL,
	[days] [int] NULL,
	[is_deleted] [bit] NULL,
	[created_dt] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[sr_intervals]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[sr_intervals](
	[interval_id] [int] IDENTITY(1,1) NOT NULL,
	[segment_name] [varchar](50) NULL,
	[org_id] [int] NULL,
	[oem_dealer_id] [int] NULL,
	[dealer_id] [int] NULL,
	[model] [varchar](50) NULL,
	[trim] [varchar](50) NULL,
	[min_model_year] [int] NULL,
	[max_model_year] [int] NULL,
	[miles] [int] NULL,
	[days] [int] NULL,
	[is_deleted] [bit] NULL,
	[created_by] [varchar](20) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](20) NULL,
	[updated_dt] [datetime] NULL,
	[natural_key] [varchar](20) NULL,
	[cm3_segment_name] [varchar](20) NULL,
	[common_segment_name] [varchar](20) NULL,
 CONSTRAINT [pk_sr_intervals] PRIMARY KEY CLUSTERED 
(
	[interval_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[sr_intervals_new]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[sr_intervals_new](
	[interval_id] [int] NULL,
	[oem_code] [varchar](10) NULL,
	[model] [varchar](250) NULL,
	[trim] [varchar](250) NULL,
	[min_year] [int] NULL,
	[max_year] [int] NULL,
	[is_deleted] [bit] NULL,
	[is_special] [bit] NULL,
	[create_dt] [datetime] NULL,
	[create_by] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[suppressions]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[suppressions](
	[suppression_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varbinary](50) NOT NULL,
	[list_suppress_id] [int] NOT NULL,
	[first_name] [varchar](100) NULL,
	[last_name] [varchar](100) NULL,
	[email_address] [varchar](250) NULL,
	[phone_num] [varchar](50) NULL,
	[address1] [varchar](250) NULL,
	[address2] [varchar](250) NULL,
	[city] [varchar](100) NULL,
	[state] [varchar](100) NULL,
	[zip_code] [varchar](50) NULL,
	[media_json] [varchar](500) NULL,
	[is_gobal_suppress] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL,
	[created_dt] [datetime] NOT NULL,
	[created_by] [varchar](50) NOT NULL,
	[updated_dt] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
 CONSTRAINT [PK_suppressions] PRIMARY KEY CLUSTERED 
(
	[suppression_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[vehicle]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[vehicle](
	[master_vehicle_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[vin] [varchar](25) MASKED WITH (FUNCTION = 'partial(0, "XXXXXXXXX", 8)') NULL,
	[vin_pattern] [varchar](15) NULL,
	[vin_decode_id] [int] NULL,
	[is_invalid_vin] [bit] NULL,
	[make] [varchar](100) NULL,
	[model] [varchar](250) NULL,
	[model_no] [varchar](50) NULL,
	[model_year] [varchar](10) NULL,
	[body_type] [varchar](500) NULL,
	[cylinders] [varchar](20) NULL,
	[transmission] [varchar](250) NULL,
	[fuel_type] [varchar](50) NULL,
	[engine_type] [varchar](250) NULL,
	[engine_size] [varchar](50) NULL,
	[engine_number] [varchar](50) NULL,
	[engine_desc] [varchar](50) NULL,
	[vehicle_trim] [varchar](100) NULL,
	[vehicle_type] [varchar](50) NULL,
	[vehicle_weight] [varchar](10) NULL,
	[vehicle_color] [varchar](50) NULL,
	[drive_train] [varchar](50) NULL,
	[ext_svc_contract_num] [varchar](50) NULL,
	[ext_svc_contract_name] [varchar](250) NULL,
	[ext_svc_contract_exp_date] [int] NULL,
	[ext_svc_contract_exp_mileage] [int] NULL,
	[warr_term] [varchar](50) NULL,
	[warr_miles] [int] NULL,
	[vehicle_mileage] [int] NULL,
	[last_ro_date] [int] NULL,
	[last_ro_mileage] [int] NULL,
	[last_sale_date] [int] NULL,
	[last_sale_mileage] [int] NULL,
	[avg_mileage_per_day_no_use] [int] NULL,
	[estd_mileage] [int] NULL,
	[vehicle_prod_date] [int] NULL,
	[exterior_color_desc] [varchar](800) NULL,
	[int_color_desc] [varchar](800) NULL,
	[accent_color] [varchar](100) NULL,
	[license_plat_num] [varchar](50) NULL,
	[four_wd] [varchar](3) NULL,
	[front_wd] [varchar](3) NULL,
	[gm_cert] [varchar](3) NULL,
	[car_line] [varchar](800) NULL,
	[carline_desc] [varchar](8000) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_by] [varchar](50) NULL,
	[sysstart] [datetime2](2) GENERATED ALWAYS AS ROW START NOT NULL,
	[sysend] [datetime2](2) GENERATED ALWAYS AS ROW END NOT NULL,
	[model_score_100] [int] NULL,
	[model_score_110] [int] NULL,
	[model_score_200] [int] NULL,
	[model_score_550] [int] NULL,
	[model_score_555] [int] NULL,
	[model_score_650] [int] NULL,
	[interval_type] [varchar](30) NULL,
	[last_activity_date] [int] NULL,
	[last_activity_type] [varchar](50) NULL,
	[next_service_mileage] [int] NULL,
	[comp_start_date] [date] NULL,
	[comp_end_date] [date] NULL,
	[comp_end_mileage] [int] NULL,
	[comp_plan_code] [varchar](50) NULL,
	[sr_comm_count] [int] NULL,
	[last_service_advisor_id] [varchar](250) NULL,
	[last_sale_type] [varchar](10) NULL,
	[next_service_due_date] [date] NULL,
	[next_service_reset_date] [datetime] NULL,
	[comp_comm_count] [int] NULL,
	[last_activity_mileage] [int] NULL,
	[avg_mileage_per_day] [numeric](9, 2) NULL,
	[interval_id] [int] NULL,
	[is_deleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[master_vehicle_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([sysstart], [sysend])
) ON [PRIMARY]
GO
/****** Object:  Table [master].[vehicle_history]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[vehicle_history](
	[master_vehicle_id] [int] NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[vin] [varchar](25) MASKED WITH (FUNCTION = 'partial(0, "XXXXXXXXX", 8)') NULL,
	[vin_pattern] [varchar](15) NULL,
	[vin_decode_id] [int] NULL,
	[is_invalid_vin] [bit] NULL,
	[make] [varchar](100) NULL,
	[model] [varchar](250) NULL,
	[model_no] [varchar](50) NULL,
	[model_year] [varchar](10) NULL,
	[body_type] [varchar](500) NULL,
	[cylinders] [varchar](20) NULL,
	[transmission] [varchar](250) NULL,
	[fuel_type] [varchar](50) NULL,
	[engine_type] [varchar](250) NULL,
	[engine_size] [varchar](50) NULL,
	[engine_number] [varchar](50) NULL,
	[engine_desc] [varchar](50) NULL,
	[vehicle_trim] [varchar](100) NULL,
	[vehicle_type] [varchar](50) NULL,
	[vehicle_weight] [varchar](10) NULL,
	[vehicle_color] [varchar](50) NULL,
	[drive_train] [varchar](50) NULL,
	[ext_svc_contract_num] [varchar](50) NULL,
	[ext_svc_contract_name] [varchar](250) NULL,
	[ext_svc_contract_exp_date] [int] NULL,
	[ext_svc_contract_exp_mileage] [int] NULL,
	[warr_term] [varchar](50) NULL,
	[warr_miles] [int] NULL,
	[vehicle_mileage] [int] NULL,
	[last_ro_date] [int] NULL,
	[last_ro_mileage] [int] NULL,
	[last_sale_date] [int] NULL,
	[last_sale_mileage] [int] NULL,
	[avg_mileage_per_day] [int] NULL,
	[estd_mileage] [int] NULL,
	[vehicle_prod_date] [int] NULL,
	[exterior_color_desc] [varchar](800) NULL,
	[int_color_desc] [varchar](800) NULL,
	[accent_color] [varchar](100) NULL,
	[license_plat_num] [varchar](50) NULL,
	[four_wd] [varchar](3) NULL,
	[front_wd] [varchar](3) NULL,
	[gm_cert] [varchar](3) NULL,
	[car_line] [varchar](800) NULL,
	[carline_desc] [varchar](8000) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_by] [varchar](50) NULL,
	[sysstart] [datetime2](2) NOT NULL,
	[sysend] [datetime2](2) NOT NULL,
	[model_score_100] [int] NULL,
	[model_score_110] [int] NULL,
	[model_score_200] [int] NULL,
	[model_score_550] [int] NULL,
	[model_score_555] [int] NULL,
	[model_score_650] [int] NULL,
	[interval_type] [varchar](30) NULL,
	[last_activity_date] [int] NULL,
	[last_activity_type] [varchar](50) NULL,
	[next_service_mileage] [int] NULL,
	[comp_start_date] [date] NULL,
	[comp_end_date] [date] NULL,
	[comp_end_mileage] [int] NULL,
	[comp_plan_code] [varchar](50) NULL,
	[sr_comm_count] [int] NULL,
	[last_service_advisor_id] [varchar](250) NULL,
	[last_sale_type] [varchar](10) NULL,
	[next_service_due_date] [date] NULL,
	[next_service_reset_date] [datetime] NULL,
	[comp_comm_count] [int] NULL,
	[last_activity_mileage] [int] NULL,
	[adm_per_day] [numeric](9, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[vehicle_porsche_backup]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[vehicle_porsche_backup](
	[master_vehicle_id] [int] NULL,
	[avg_mileage_per_day] [numeric](9, 2) NULL,
	[estd_mileage] [int] NULL,
	[natural_key] [varchar](50) NULL,
	[parent_dealer_id] [int] NULL,
	[next_service_due_date] [date] NULL,
	[next_service_mileage] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[vehicle_t1]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[vehicle_t1](
	[master_vehicle_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[vin] [varchar](25) NULL,
	[vin_pattern] [varchar](15) NULL,
	[vin_decode_id] [int] NULL,
	[is_invalid_vin] [bit] NULL,
	[make] [varchar](100) NULL,
	[model] [varchar](250) NULL,
	[model_no] [varchar](50) NULL,
	[model_year] [varchar](10) NULL,
	[body_type] [varchar](500) NULL,
	[cylinders] [varchar](20) NULL,
	[transmission] [varchar](250) NULL,
	[fuel_type] [varchar](50) NULL,
	[engine_type] [varchar](250) NULL,
	[engine_size] [varchar](50) NULL,
	[engine_number] [varchar](50) NULL,
	[engine_desc] [varchar](50) NULL,
	[vehicle_trim] [varchar](100) NULL,
	[vehicle_type] [varchar](50) NULL,
	[vehicle_weight] [varchar](10) NULL,
	[vehicle_color] [varchar](50) NULL,
	[drive_train] [varchar](50) NULL,
	[ext_svc_contract_num] [varchar](50) NULL,
	[ext_svc_contract_name] [varchar](250) NULL,
	[ext_svc_contract_exp_date] [int] NULL,
	[ext_svc_contract_exp_mileage] [int] NULL,
	[warr_term] [varchar](50) NULL,
	[warr_miles] [int] NULL,
	[vehicle_mileage] [int] NULL,
	[last_ro_date] [int] NULL,
	[last_ro_mileage] [int] NULL,
	[last_sale_date] [int] NULL,
	[last_sale_mileage] [int] NULL,
	[avg_mileage_per_day] [int] NULL,
	[estd_mileage] [int] NULL,
	[vehicle_prod_date] [int] NULL,
	[exterior_color_desc] [varchar](800) NULL,
	[int_color_desc] [varchar](800) NULL,
	[accent_color] [varchar](100) NULL,
	[license_plat_num] [varchar](50) NULL,
	[four_wd] [varchar](3) NULL,
	[front_wd] [varchar](3) NULL,
	[gm_cert] [varchar](3) NULL,
	[car_line] [varchar](800) NULL,
	[carline_desc] [varchar](8000) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_by] [varchar](50) NULL,
	[sysstart] [datetime2](2) NOT NULL,
	[sysend] [datetime2](2) NOT NULL,
	[model_score_100] [int] NULL,
	[model_score_110] [int] NULL,
	[model_score_200] [int] NULL,
	[model_score_550] [int] NULL,
	[model_score_555] [int] NULL,
	[model_score_650] [int] NULL,
	[interval_type] [varchar](30) NULL,
	[last_activity_date] [int] NULL,
	[last_activity_type] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[vehicle_t11]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[vehicle_t11](
	[master_vehicle_id] [int] IDENTITY(1,1) NOT NULL,
	[natural_key] [varchar](10) NOT NULL,
	[parent_dealer_id] [int] NOT NULL,
	[vin] [varchar](25) NULL,
	[vin_pattern] [varchar](15) NULL,
	[vin_decode_id] [int] NULL,
	[is_invalid_vin] [bit] NULL,
	[make] [varchar](100) NULL,
	[model] [varchar](250) NULL,
	[model_no] [varchar](50) NULL,
	[model_year] [varchar](10) NULL,
	[body_type] [varchar](500) NULL,
	[cylinders] [varchar](20) NULL,
	[transmission] [varchar](250) NULL,
	[fuel_type] [varchar](50) NULL,
	[engine_type] [varchar](250) NULL,
	[engine_size] [varchar](50) NULL,
	[engine_number] [varchar](50) NULL,
	[engine_desc] [varchar](50) NULL,
	[vehicle_trim] [varchar](100) NULL,
	[vehicle_type] [varchar](50) NULL,
	[vehicle_weight] [varchar](10) NULL,
	[vehicle_color] [varchar](50) NULL,
	[drive_train] [varchar](50) NULL,
	[ext_svc_contract_num] [varchar](50) NULL,
	[ext_svc_contract_name] [varchar](250) NULL,
	[ext_svc_contract_exp_date] [int] NULL,
	[ext_svc_contract_exp_mileage] [int] NULL,
	[warr_term] [varchar](50) NULL,
	[warr_miles] [int] NULL,
	[vehicle_mileage] [int] NULL,
	[last_ro_date] [int] NULL,
	[last_ro_mileage] [int] NULL,
	[last_sale_date] [int] NULL,
	[last_sale_mileage] [int] NULL,
	[avg_mileage_per_day] [int] NULL,
	[estd_mileage] [int] NULL,
	[vehicle_prod_date] [int] NULL,
	[exterior_color_desc] [varchar](800) NULL,
	[int_color_desc] [varchar](800) NULL,
	[accent_color] [varchar](100) NULL,
	[license_plat_num] [varchar](50) NULL,
	[four_wd] [varchar](3) NULL,
	[front_wd] [varchar](3) NULL,
	[gm_cert] [varchar](3) NULL,
	[car_line] [varchar](800) NULL,
	[carline_desc] [varchar](8000) NULL,
	[file_log_id] [int] NULL,
	[file_log_detail_id] [int] NULL,
	[created_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_by] [varchar](50) NULL,
	[sysstart] [datetime2](2) NOT NULL,
	[sysend] [datetime2](2) NOT NULL,
	[model_score_100] [int] NULL,
	[model_score_110] [int] NULL,
	[model_score_200] [int] NULL,
	[model_score_550] [int] NULL,
	[model_score_555] [int] NULL,
	[model_score_650] [int] NULL,
	[interval_type] [varchar](30) NULL,
	[last_activity_date] [int] NULL,
	[last_activity_type] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[vin_decoding]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[vin_decoding](
	[vin_decode_id] [int] IDENTITY(1,1) NOT NULL,
	[vin_pattern] [varchar](20) NULL,
	[append_year] [int] NULL,
	[append_make] [varchar](100) NULL,
	[append_model] [varchar](100) NULL,
	[append_trim] [varchar](100) NULL,
	[append_doors] [varchar](100) NULL,
	[append_body_style] [varchar](100) NULL,
	[append_engine_clyn] [varchar](100) NULL,
	[append_engine_size] [varchar](100) NULL,
	[append_fuel_type] [varchar](100) NULL,
	[append_type_code] [varchar](100) NULL,
	[override_model] [varchar](50) NULL,
	[adm_checked] [int] NULL,
	[is_processed] [bit] NULL,
	[created_by] [varchar](50) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[updated_dt] [datetime] NULL,
	[override_model_gm] [varchar](50) NULL,
	[is_camelcase] [int] NULL,
	[override_model_mongo] [varchar](100) NULL,
	[adm] [numeric](36, 14) NULL,
	[is_deleted] [bit] NULL,
	[override_make] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[vin_decode_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[vin_decoding_911]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[vin_decoding_911](
	[vin_decode_id] [int] IDENTITY(1,1) NOT NULL,
	[vin_pattern] [varchar](20) NULL,
	[append_year] [int] NULL,
	[append_make] [varchar](100) NULL,
	[append_model] [varchar](100) NULL,
	[append_trim] [varchar](100) NULL,
	[append_doors] [varchar](100) NULL,
	[append_body_style] [varchar](100) NULL,
	[append_engine_clyn] [varchar](100) NULL,
	[append_engine_size] [varchar](100) NULL,
	[append_fuel_type] [varchar](100) NULL,
	[append_type_code] [varchar](100) NULL,
	[override_model] [varchar](50) NULL,
	[adm] [varchar](20) NULL,
	[adm_checked] [int] NULL,
	[is_processed] [bit] NULL,
	[created_by] [varchar](50) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[updated_dt] [datetime] NULL,
	[override_model_gm] [varchar](50) NULL,
	[is_camelcase] [int] NULL,
	[override_model_mongo] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[vin_decoding_backup_20200628]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[vin_decoding_backup_20200628](
	[vin_decode_id] [int] IDENTITY(1,1) NOT NULL,
	[vin_pattern] [varchar](20) NULL,
	[append_year] [int] NULL,
	[append_make] [varchar](100) NULL,
	[append_model] [varchar](100) NULL,
	[append_trim] [varchar](100) NULL,
	[append_doors] [varchar](100) NULL,
	[append_body_style] [varchar](100) NULL,
	[append_engine_clyn] [varchar](100) NULL,
	[append_engine_size] [varchar](100) NULL,
	[append_fuel_type] [varchar](100) NULL,
	[append_type_code] [varchar](100) NULL,
	[override_model] [varchar](50) NULL,
	[adm_checked] [int] NULL,
	[is_processed] [bit] NULL,
	[created_by] [varchar](50) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[updated_dt] [datetime] NULL,
	[override_model_gm] [varchar](50) NULL,
	[is_camelcase] [int] NULL,
	[override_model_mongo] [varchar](100) NULL,
	[adm] [numeric](36, 14) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[vin_decoding_backup_20200910]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[vin_decoding_backup_20200910](
	[vin_decode_id] [int] IDENTITY(1,1) NOT NULL,
	[vin_pattern] [varchar](20) NULL,
	[append_year] [int] NULL,
	[append_make] [varchar](100) NULL,
	[append_model] [varchar](100) NULL,
	[append_trim] [varchar](100) NULL,
	[append_doors] [varchar](100) NULL,
	[append_body_style] [varchar](100) NULL,
	[append_engine_clyn] [varchar](100) NULL,
	[append_engine_size] [varchar](100) NULL,
	[append_fuel_type] [varchar](100) NULL,
	[append_type_code] [varchar](100) NULL,
	[override_model] [varchar](50) NULL,
	[adm_checked] [int] NULL,
	[is_processed] [bit] NULL,
	[created_by] [varchar](50) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[updated_dt] [datetime] NULL,
	[override_model_gm] [varchar](50) NULL,
	[is_camelcase] [int] NULL,
	[override_model_mongo] [varchar](100) NULL,
	[adm] [numeric](36, 14) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[vin_decoding_temp]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[vin_decoding_temp](
	[vin_decode_id] [int] IDENTITY(1,1) NOT NULL,
	[vin_pattern] [varchar](20) NULL,
	[append_year] [varchar](1000) NULL,
	[append_make] [varchar](1000) NULL,
	[append_model] [varchar](1000) NULL,
	[append_trim] [varchar](1000) NULL,
	[append_doors] [varchar](1000) NULL,
	[append_body_style] [varchar](1000) NULL,
	[append_engine_clyn] [varchar](1000) NULL,
	[append_engine_size] [varchar](1000) NULL,
	[append_fuel_type] [varchar](1000) NULL,
	[append_type_code] [varchar](1000) NULL,
	[override_model] [varchar](1000) NULL,
	[adm] [varchar](20) NULL,
	[adm_checked] [int] NULL,
	[is_processed] [bit] NULL,
	[created_by] [varchar](50) NULL,
	[created_dt] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[updated_dt] [datetime] NULL,
 CONSTRAINT [PK__vin_deco__963863F9538380BA] PRIMARY KEY CLUSTERED 
(
	[vin_decode_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [master].[zip_code_distance]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[zip_code_distance](
	[zipcode_distance_id] [int] IDENTITY(1,1) NOT NULL,
	[master_customer_id] [int] NULL,
	[zipcode] [varchar](100) NULL,
	[zipcode2] [varchar](100) NULL,
	[city] [varchar](100) NULL,
	[state] [varchar](100) NULL,
	[distance] [varchar](1000) NULL,
	[created_dt] [datetime] NULL,
	[created_by] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [master].[zip_code_long_lat]    Script Date: 1/13/2021 4:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [master].[zip_code_long_lat](
	[long_lat_id] [int] IDENTITY(1,1) NOT NULL,
	[zip_code] [varchar](50) NULL,
	[latitude] [varchar](100) NULL,
	[longitude] [varchar](100) NULL,
	[city] [varchar](50) NULL,
	[state] [varchar](5) NULL,
	[created_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[long_lat_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [master].[cust_2_vehicle] ADD  CONSTRAINT [DEEPU_cust_2_vehicle_created_date]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[cust_2_vehicle] ADD  CONSTRAINT [DEEPU_cust_2_vehicle_update_date]  DEFAULT (getdate()) FOR [update_date]
GO
ALTER TABLE [master].[cust_2_vehicle] ADD  CONSTRAINT [DEEPU__cust_2_ve__creat__605D434C_C]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[cust_2_vehicle] ADD  CONSTRAINT [DEEPU__cust_2_ve__updat__61516785C]  DEFAULT (suser_name()) FOR [update_by]
GO
ALTER TABLE [master].[cust_mail_block] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[cust_mail_block] ADD  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[cust_mail_block] ADD  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[cust_mail_block] ADD  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[customer] ADD  DEFAULT ((0)) FOR [cust_do_not_call]
GO
ALTER TABLE [master].[customer] ADD  DEFAULT ((0)) FOR [cust_do_not_email]
GO
ALTER TABLE [master].[customer] ADD  DEFAULT ((0)) FOR [cust_do_not_mail]
GO
ALTER TABLE [master].[customer] ADD  DEFAULT ((0)) FOR [cust_do_not_data_share]
GO
ALTER TABLE [master].[customer] ADD  DEFAULT ((0)) FOR [cust_opt_out_all]
GO
ALTER TABLE [master].[customer] ADD  DEFAULT ((0)) FOR [is_invalid_dms_num]
GO
ALTER TABLE [master].[customer] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[customer] ADD  DEFAULT ((0)) FOR [is_invalid_email]
GO
ALTER TABLE [master].[customer] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[customer] ADD  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[customer] ADD  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[customer] ADD  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[customer] ADD  DEFAULT ((0)) FOR [is_blank_record]
GO
ALTER TABLE [master].[customer] ADD  CONSTRAINT [df_invalid_mail]  DEFAULT ((0)) FOR [is_invalid_mail]
GO
ALTER TABLE [master].[customer] ADD  DEFAULT ((0)) FOR [cust_do_not_text]
GO
ALTER TABLE [master].[customer] ADD  DEFAULT ((0)) FOR [cust_do_not_social]
GO
ALTER TABLE [master].[customer_ncoa] ADD  CONSTRAINT [DF_cust_vehicle_Is_deleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[customer_ncoa] ADD  CONSTRAINT [DF__customer___is_su__037240B6]  DEFAULT ((0)) FOR [is_suppressed]
GO
ALTER TABLE [master].[customer_ncoa] ADD  CONSTRAINT [DF_cust_vehicle_created_dt]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[customer_ncoa] ADD  CONSTRAINT [DF_cust_vehicle_created_by]  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[customer_ncoa] ADD  CONSTRAINT [DF_cust_vehicle_updated_dt]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[customer_ncoa] ADD  CONSTRAINT [DF_cust_vehicle_updated_by]  DEFAULT (suser_sname()) FOR [updated_by]
GO
ALTER TABLE [master].[daily_stats] ADD  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[daily_stats] ADD  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[daily_stats] ADD  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[daily_stats] ADD  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [master].[dealer] ADD  CONSTRAINT [DF__parent_de__is_de__2A170C8B]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[dealer] ADD  CONSTRAINT [DF__parent_de__creat__2B0B30C4]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[dealer] ADD  CONSTRAINT [DF__parent_de__creat__2BFF54FD]  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[dealer] ADD  CONSTRAINT [DF__parent_de__updat__2CF37936]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[dealer] ADD  CONSTRAINT [DF__parent_de__updat__2DE79D6F]  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [master].[dealer] ADD  CONSTRAINT [DF_dealer_is_etl_required]  DEFAULT ((0)) FOR [is_etl_required]
GO
ALTER TABLE [master].[dealer] ADD  DEFAULT ((0)) FOR [is_opcode_required]
GO
ALTER TABLE [master].[dealer] ADD  DEFAULT (newid()) FOR [dealer_guid]
GO
ALTER TABLE [master].[dealer] ADD  DEFAULT ((0)) FOR [is_hm_required]
GO
ALTER TABLE [master].[dealer_audit_log] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[dealer_audit_log] ADD  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[dealer_audit_log] ADD  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[dealer_audit_log] ADD  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[dealer_audit_log] ADD  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [master].[dealer_mapping] ADD  CONSTRAINT [DF__dealer_ma__is_de__30C40A1A]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[dealer_mapping] ADD  CONSTRAINT [DF__dealer_ma__creat__31B82E53]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[dealer_mapping] ADD  CONSTRAINT [DF__dealer_ma__creat__32AC528C]  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[dealer_mapping] ADD  CONSTRAINT [DF__dealer_ma__updat__33A076C5]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[dealer_mapping] ADD  CONSTRAINT [DF__dealer_ma__updat__34949AFE]  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [master].[dealer_source_type] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[decline_ros] ADD  CONSTRAINT [DF__decline_r__is_de__30242045]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[decline_ros] ADD  CONSTRAINT [DF__decline_r__creat__3118447E]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[decline_ros] ADD  CONSTRAINT [DF__decline_r__creat__320C68B7]  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[decline_ros] ADD  CONSTRAINT [DF__decline_r__updat__33008CF0]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[decline_ros] ADD  CONSTRAINT [DF__decline_r__updat__33F4B129]  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [master].[declined_comment] ADD  CONSTRAINT [DF_declined_comment_qc_flag]  DEFAULT ((0)) FOR [qc_flag]
GO
ALTER TABLE [master].[declined_comment_details] ADD  CONSTRAINT [DF_declined_comment_details_is_performed]  DEFAULT ((0)) FOR [is_performed]
GO
ALTER TABLE [master].[declined_comment_details] ADD  CONSTRAINT [DF_declined_comment_details_is_recommended]  DEFAULT ((0)) FOR [is_recommended]
GO
ALTER TABLE [master].[declined_comment_details] ADD  CONSTRAINT [DF_declined_comment_details_is_declined]  DEFAULT ((0)) FOR [is_declined]
GO
ALTER TABLE [master].[declined_comment_details] ADD  CONSTRAINT [DF_declined_comment_details_created_dt]  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[declined_comment_details] ADD  CONSTRAINT [DF_declined_comment_details_created_by]  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[declined_comment_details] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[declined_comments] ADD  CONSTRAINT [DF_declined_comment_qc_flags]  DEFAULT ((0)) FOR [is_reviewed]
GO
ALTER TABLE [master].[declined_comments] ADD  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[declined_comments] ADD  DEFAULT ((0)) FOR [is_performed]
GO
ALTER TABLE [master].[declined_comments] ADD  DEFAULT ((0)) FOR [is_recommended]
GO
ALTER TABLE [master].[declined_comments] ADD  DEFAULT ((0)) FOR [is_declined]
GO
ALTER TABLE [master].[declined_dealer_value] ADD  CONSTRAINT [DF__declined___is_ac__1F247CCC]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [master].[declined_dealer_value] ADD  CONSTRAINT [DF__declined___creat__2018A105]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[declined_dealer_value] ADD  CONSTRAINT [DF__declined___creat__210CC53E]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[declined_dealer_value] ADD  CONSTRAINT [DF__declined___updat__2200E977]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[declined_dealer_value] ADD  CONSTRAINT [DF__declined___updat__22F50DB0]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[declined_dealers] ADD  DEFAULT ((0)) FOR [is_Active]
GO
ALTER TABLE [master].[declined_dealers] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[declined_dealers] ADD  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[declined_dealers] ADD  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[declined_dealers] ADD  DEFAULT (suser_sname()) FOR [updated_by]
GO
ALTER TABLE [master].[declined_operator] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [master].[declined_operator] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[declined_operator] ADD  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[declined_operator] ADD  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[declined_operator] ADD  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[declined_test] ADD  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[declined_text] ADD  CONSTRAINT [DF__decline_t__decli__7A8729A3]  DEFAULT ((0)) FOR [declined_found]
GO
ALTER TABLE [master].[declined_text] ADD  CONSTRAINT [DF__decline_t__trigg__7B7B4DDC]  DEFAULT ((0)) FOR [triggers_found]
GO
ALTER TABLE [master].[declined_text] ADD  CONSTRAINT [DF__decline_t__revie__7993056A]  DEFAULT (getdate()) FOR [reviewed_date]
GO
ALTER TABLE [master].[declined_text] ADD  CONSTRAINT [DF_declined_text_exclusion_flag]  DEFAULT ((0)) FOR [exclusion_flag]
GO
ALTER TABLE [master].[declined_text] ADD  CONSTRAINT [DF__decline_t__creat__789EE131]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[declined_text] ADD  CONSTRAINT [DF_declined_text_created_by]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[declined_text] ADD  CONSTRAINT [DF_declined_text_updated_date]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[declined_text] ADD  CONSTRAINT [DF_declined_text_updated_by]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[declined_text] ADD  DEFAULT ((0)) FOR [finalized_flag]
GO
ALTER TABLE [master].[declined_type] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [master].[declined_type] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[declined_type] ADD  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[declined_type] ADD  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[declined_type] ADD  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[eappends_get] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[eappends_get] ADD  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[eappends_get] ADD  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[eappends_get] ADD  DEFAULT (suser_sname()) FOR [updated_by]
GO
ALTER TABLE [master].[eappends_get] ADD  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [master].[eappends_log] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[eappends_log] ADD  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[eappends_log] ADD  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[eappends_log] ADD  DEFAULT (suser_sname()) FOR [updated_by]
GO
ALTER TABLE [master].[eappends_log] ADD  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [master].[eappends_post] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[eappends_post] ADD  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[eappends_post] ADD  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[eappends_post] ADD  DEFAULT (suser_sname()) FOR [updated_by]
GO
ALTER TABLE [master].[eappends_post] ADD  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [master].[email_dnc] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[email_dnc] ADD  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[email_dnc] ADD  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[email_dnc] ADD  DEFAULT (suser_sname()) FOR [updated_by]
GO
ALTER TABLE [master].[email_dnc] ADD  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [master].[employee_details] ADD  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[employee_details] ADD  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[employee_details] ADD  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [master].[employee_details] ADD  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[fi_sales] ADD  CONSTRAINT [DF__fi_sales__create__487B981B]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[fi_sales] ADD  CONSTRAINT [DF__fi_sales__update__4A63E08D]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[fi_sales] ADD  CONSTRAINT [DF__fi_sales__create__478773E2]  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[fi_sales] ADD  CONSTRAINT [DF__fi_sales__update__496FBC54]  DEFAULT (suser_sname()) FOR [updated_by]
GO
ALTER TABLE [master].[fi_sales_people] ADD  CONSTRAINT [DF__sales_peo__creat__579DE019]  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[fi_sales_people] ADD  CONSTRAINT [DF__sales_peo__creat__58920452]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[fi_sales_people] ADD  CONSTRAINT [DF__sales_peo__updat__5986288B]  DEFAULT (suser_sname()) FOR [updated_by]
GO
ALTER TABLE [master].[fi_sales_people] ADD  CONSTRAINT [DF__sales_peo__updat__5A7A4CC4]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[fi_sales_trade_vehicles] ADD  CONSTRAINT [DF__trade_veh__creat__5D56B96F]  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[fi_sales_trade_vehicles] ADD  CONSTRAINT [DF__trade_veh__creat__5E4ADDA8]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[fi_sales_trade_vehicles] ADD  CONSTRAINT [DF__trade_veh__updat__5F3F01E1]  DEFAULT (suser_sname()) FOR [updated_by]
GO
ALTER TABLE [master].[fi_sales_trade_vehicles] ADD  CONSTRAINT [DF__trade_veh__updat__6033261A]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[list_suppress] ADD  CONSTRAINT [DF_list_suppress_is_deleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[list_suppress] ADD  CONSTRAINT [DF_list_suppress_created_dt]  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[list_suppress] ADD  CONSTRAINT [DF_list_suppress_created_by]  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[make_model] ADD  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[make_model] ADD  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[natural_key] ADD  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[ncoa_log] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[ncoa_log] ADD  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[ncoa_log] ADD  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[ncoa_log] ADD  DEFAULT (suser_sname()) FOR [updated_by]
GO
ALTER TABLE [master].[ncoa_log] ADD  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [master].[por_declined_text] ADD  CONSTRAINT [DF__pordecline_t__decli__7A8729A3]  DEFAULT ((0)) FOR [declined_found]
GO
ALTER TABLE [master].[por_declined_text] ADD  CONSTRAINT [DF__pordecline_t__trigg__7B7B4DDC]  DEFAULT ((0)) FOR [triggers_found]
GO
ALTER TABLE [master].[por_declined_text] ADD  CONSTRAINT [DF_pordeclined_text_exclusion_flag]  DEFAULT ((0)) FOR [exclusion_flag]
GO
ALTER TABLE [master].[por_declined_text] ADD  CONSTRAINT [DF__pordecline_t__creat__789EE131]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[por_declined_text] ADD  CONSTRAINT [DF_pordeclined_text_created_by]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[por_declined_text] ADD  CONSTRAINT [DF_pordeclined_text_updated_date]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[por_declined_text] ADD  CONSTRAINT [DF_pordeclined_text_updated_by]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[por_declined_text] ADD  DEFAULT ((0)) FOR [finalized_flag]
GO
ALTER TABLE [master].[por_sr_interval_types] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[por_sr_interval_types] ADD  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[repair_order_header] ADD  CONSTRAINT [DF_repair_orders_header_is_decline]  DEFAULT ((0)) FOR [is_declined]
GO
ALTER TABLE [master].[repair_order_header] ADD  CONSTRAINT [DF__repair_or__create__02FC7413D]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[repair_order_header] ADD  CONSTRAINT [DF__repair_or__update__03F0984CL]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[repair_order_header] ADD  CONSTRAINT [DF__repair_or__create__04E4BC85A]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[repair_order_header] ADD  CONSTRAINT [DF__repair_or__update__05D8E0BEL]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[repair_order_header] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[repair_order_header_comments] ADD  CONSTRAINT [DF__repair_or__creat__7310F064]  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[repair_order_header_comments] ADD  CONSTRAINT [DF__repair_or__creat__7405149D]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[repair_order_header_comments] ADD  CONSTRAINT [DF__repair_or__updat__74F938D6]  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [master].[repair_order_header_comments] ADD  CONSTRAINT [DF__repair_or__updat__75ED5D0F]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[repair_order_header_detail] ADD  CONSTRAINT [DF__repairs_or__is_0B5CAFEAD]  DEFAULT ((0)) FOR [is_declined_opcode]
GO
ALTER TABLE [master].[repair_order_header_detail] ADD  CONSTRAINT [DF_repair_order_details_created_dt]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[repair_order_header_detail] ADD  CONSTRAINT [DF_repair_order_details_updated_dt]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[repair_order_header_detail] ADD  CONSTRAINT [DF_repair_orders_detail_created_by]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[repair_order_header_detail] ADD  CONSTRAINT [DF_repair_orders_detail_updated_by]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[repair_order_header_detail] ADD  CONSTRAINT [DF_repair_order_header_detail_is_processed]  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[repair_order_header_detail] ADD  DEFAULT ((0)) FOR [is_performed]
GO
ALTER TABLE [master].[repair_order_header_detail] ADD  DEFAULT ((0)) FOR [is_recommended]
GO
ALTER TABLE [master].[repair_order_header_detail] ADD  DEFAULT ((0)) FOR [is_declined]
GO
ALTER TABLE [master].[repair_order_old] ADD  CONSTRAINT [DF_comment_qc_flag]  DEFAULT ((0)) FOR [qc_flag]
GO
ALTER TABLE [master].[repair_order_old] ADD  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[repair_order_opcode_category] ADD  CONSTRAINT [DF_repair_order_opcode_category_is_deleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[repair_order_opcode_category] ADD  CONSTRAINT [DF_repair_order_opcode_category_created_by]  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[repair_order_opcode_category] ADD  CONSTRAINT [DF_repair_order_opcode_category_created_date]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[repair_order_opcode_category] ADD  CONSTRAINT [DF_repair_order_opcode_category_updated_by]  DEFAULT (suser_sname()) FOR [updated_by]
GO
ALTER TABLE [master].[repair_order_opcode_category] ADD  CONSTRAINT [DF_repair_order_opcode_category_updated_date]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[repair_order_opcode_details] ADD  CONSTRAINT [DF_repair_order_opcode_details_is_performed]  DEFAULT ((0)) FOR [is_performed]
GO
ALTER TABLE [master].[repair_order_opcode_details] ADD  CONSTRAINT [DF_repair_order_opcode_details_is_recommended]  DEFAULT ((0)) FOR [is_recommended]
GO
ALTER TABLE [master].[repair_order_opcode_details] ADD  CONSTRAINT [DF_repair_order_opcode_details_is_declined]  DEFAULT ((0)) FOR [is_declined]
GO
ALTER TABLE [master].[repair_order_opcode_details] ADD  CONSTRAINT [DF_repair_order_opcode_details_is_deleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[repair_order_opcode_details] ADD  CONSTRAINT [DF_repair_order_opcode_details_created_dt]  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[repair_order_opcode_details] ADD  CONSTRAINT [DF_repair_order_opcode_details_created_by]  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[repair_order_opcodes] ADD  CONSTRAINT [DF_repair_order_opcodes_is_deleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[repair_order_opcodes] ADD  CONSTRAINT [DF_repair_order_opcodes_created_by]  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[repair_order_opcodes] ADD  CONSTRAINT [DF_repair_order_opcodes_created_date]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[repair_order_opcodes] ADD  CONSTRAINT [DF_repair_order_opcodes_updated_by]  DEFAULT (suser_sname()) FOR [updated_by]
GO
ALTER TABLE [master].[repair_order_opcodes] ADD  CONSTRAINT [DF_repair_order_opcodes_updated_date]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[repair_order_opcodes] ADD  DEFAULT ((0)) FOR [is_reviewed]
GO
ALTER TABLE [master].[repair_order_opcodes] ADD  DEFAULT ((0)) FOR [is_ignored]
GO
ALTER TABLE [master].[repair_order_opcodes_test] ADD  CONSTRAINT [DF_repair_order_opcodes_is_deleted_1]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[repair_order_opcodes_test] ADD  CONSTRAINT [DF_repair_order_opcodes_created_by_1]  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[repair_order_opcodes_test] ADD  CONSTRAINT [DF_repair_order_opcodes_created_date_1]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[repair_order_opcodes_test] ADD  CONSTRAINT [DF_repair_order_opcodes_updated_by_1]  DEFAULT (suser_sname()) FOR [updated_by]
GO
ALTER TABLE [master].[repair_order_opcodes_test] ADD  CONSTRAINT [DF_repair_order_opcodes_updated_date_1]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[repair_order_opcodes_test] ADD  DEFAULT ((0)) FOR [is_reviewed]
GO
ALTER TABLE [master].[repair_order_opcodes_test] ADD  DEFAULT ((0)) FOR [is_ignored]
GO
ALTER TABLE [master].[repair_order_opcodes_test] ADD  CONSTRAINT [df_is_checked]  DEFAULT ((0)) FOR [is_checked]
GO
ALTER TABLE [master].[repair_order_text] ADD  CONSTRAINT [DF__repair_or__is_pr__3FA65AF7]  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[repair_order_text] ADD  CONSTRAINT [DF__repair_or__is_re__409A7F30]  DEFAULT ((0)) FOR [is_reviewed]
GO
ALTER TABLE [master].[repair_order_text] ADD  CONSTRAINT [DF__repair_or__creat__418EA369]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[repair_order_text] ADD  CONSTRAINT [DF__repair_or__creat__4282C7A2]  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[repair_order_text] ADD  CONSTRAINT [DF__repair_or__updat__4376EBDB]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[repair_order_text] ADD  CONSTRAINT [DF__repair_or__updat__446B1014]  DEFAULT (suser_sname()) FOR [updated_by]
GO
ALTER TABLE [master].[repair_order_text_AGPO] ADD  CONSTRAINT [DF_comment_qc_flag_AGPO]  DEFAULT ((0)) FOR [qc_flag]
GO
ALTER TABLE [master].[repair_order_text_AGPO] ADD  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[repair_order_text_D2D] ADD  CONSTRAINT [DF_comment_qc_flag_D2D]  DEFAULT ((0)) FOR [qc_flag]
GO
ALTER TABLE [master].[repair_order_text_D2D] ADD  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[repair_order_text_DD2] ADD  CONSTRAINT [DF_comment_qc_flag_DD2]  DEFAULT ((0)) FOR [qc_flag]
GO
ALTER TABLE [master].[repair_order_text_DD2] ADD  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[repair_order_text_DD2_IHB] ADD  CONSTRAINT [DF_comment_qc_flag_DD2_IHB]  DEFAULT ((0)) FOR [qc_flag]
GO
ALTER TABLE [master].[repair_order_text_DD2_IHB] ADD  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[repair_order_text_GM] ADD  CONSTRAINT [DF_comment_qc_flag_GM]  DEFAULT ((0)) FOR [qc_flag]
GO
ALTER TABLE [master].[repair_order_text_GM] ADD  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[repair_order_text_GM2] ADD  CONSTRAINT [DF_comment_qc_flag_GM2]  DEFAULT ((0)) FOR [qc_flag]
GO
ALTER TABLE [master].[repair_order_text_GM2] ADD  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[repair_order_text_POHK] ADD  CONSTRAINT [DF_comment_qc_flag_pohk]  DEFAULT ((0)) FOR [qc_flag]
GO
ALTER TABLE [master].[repair_order_text_POHK] ADD  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[repair_order_text_porsche] ADD  CONSTRAINT [DF_comment_qc_flag_porsche]  DEFAULT ((0)) FOR [qc_flag]
GO
ALTER TABLE [master].[repair_order_text_porsche] ADD  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[repair_order_text_porsche2] ADD  CONSTRAINT [DF_comment_qc_flag_porsche2]  DEFAULT ((0)) FOR [qc_flag]
GO
ALTER TABLE [master].[repair_order_text_porsche2] ADD  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[repair_orders_text] ADD  CONSTRAINT [DF__pordecline_t__decli__7A8729A3dd]  DEFAULT ((0)) FOR [declined_found]
GO
ALTER TABLE [master].[repair_orders_text] ADD  CONSTRAINT [DF__pordecline_t__trigg__7B7B4DDCdd]  DEFAULT ((0)) FOR [triggers_found]
GO
ALTER TABLE [master].[repair_orders_text] ADD  CONSTRAINT [DF_pordeclined_text_exclusion_flagdd]  DEFAULT ((0)) FOR [exclusion_flag]
GO
ALTER TABLE [master].[repair_orders_text] ADD  DEFAULT ((0)) FOR [finalized_flag]
GO
ALTER TABLE [master].[repair_orders_text] ADD  CONSTRAINT [DF__pordecline_t__creat__789EE131dd]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[repair_orders_text] ADD  CONSTRAINT [DF_pordeclinedd_text_created_by]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[repair_orders_text] ADD  CONSTRAINT [DF_pordeclinedd_text_updated_date]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[repair_orders_text] ADD  CONSTRAINT [DF_pordeclinedd_text_updated_by]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[ro_detail_rec_service] ADD  CONSTRAINT [DF__ro_recomm__creat__3B0C8E63]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[ro_detail_rec_service] ADD  CONSTRAINT [DF__ro_recomm__creta__3C00B29C]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[ro_detail_rec_service] ADD  CONSTRAINT [DF__ro_recomm__updat__3CF4D6D5]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[ro_detail_rec_service] ADD  CONSTRAINT [DF__ro_recomm__updat__3DE8FB0E]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[ro_header_comments] ADD  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[ro_header_comments] ADD  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[ro_header_comments] ADD  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [master].[ro_header_comments] ADD  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[ro_op_codes] ADD  CONSTRAINT [DF__ro_op_cod__is_de__260684850]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[ro_op_codes] ADD  CONSTRAINT [DF__ro_op_cod__creat__29221CFB0]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[ro_op_codes] ADD  CONSTRAINT [DF__ro_op_cod__updat__2A1641340]  DEFAULT (getdate()) FOR [update_date]
GO
ALTER TABLE [master].[ro_op_codes] ADD  CONSTRAINT [DF__ro_op_cod__creat__2B0A656D0]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[ro_op_codes] ADD  CONSTRAINT [DF__ro_op_cod__updat__2BFE89A60]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[ro_op_codes_category] ADD  CONSTRAINT [DF_ro_op_codes_category_created_date]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[ro_op_codes_category] ADD  CONSTRAINT [DF_ro_op_codes_category_created_by]  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[ro_op_codes_category] ADD  CONSTRAINT [DF_ro_op_codes_category_updated_date]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[ro_op_codes_category] ADD  CONSTRAINT [DF_ro_op_codes_category_updated_by]  DEFAULT (suser_sname()) FOR [updated_by]
GO
ALTER TABLE [master].[ro_parts_details] ADD  CONSTRAINT [DF__ro_parts___creat__17036CC00]  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[ro_parts_details] ADD  CONSTRAINT [DF__ro_parts___updat__17F790F90]  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[ro_parts_details] ADD  CONSTRAINT [DF__ro_parts___creat__18EBB5320]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[ro_parts_details] ADD  CONSTRAINT [DF__ro_parts___updat__19DFD96B0]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[service_appts] ADD  CONSTRAINT [df_created_dt]  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[service_appts] ADD  CONSTRAINT [df_created_by]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[service_appts] ADD  CONSTRAINT [df_updated_dt]  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [master].[service_appts] ADD  CONSTRAINT [df_updated_by]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[source_type] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[sr_interval_types_new] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[sr_interval_types_new] ADD  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[sr_intervals_new] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[sr_intervals_new] ADD  DEFAULT ((0)) FOR [is_special]
GO
ALTER TABLE [master].[sr_intervals_new] ADD  DEFAULT (getdate()) FOR [create_dt]
GO
ALTER TABLE [master].[sr_intervals_new] ADD  DEFAULT (suser_sname()) FOR [create_by]
GO
ALTER TABLE [master].[suppressions] ADD  CONSTRAINT [DF_suppressions_is_gobal_suppression]  DEFAULT ((0)) FOR [is_gobal_suppress]
GO
ALTER TABLE [master].[suppressions] ADD  CONSTRAINT [DF_suppressions_is_deleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[suppressions] ADD  CONSTRAINT [DF_suppressions_created_dt]  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[suppressions] ADD  CONSTRAINT [DF_suppressions_created_by]  DEFAULT (suser_sname()) FOR [created_by]
GO
ALTER TABLE [master].[vehicle] ADD  DEFAULT ((0)) FOR [is_invalid_vin]
GO
ALTER TABLE [master].[vehicle] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[vehicle] ADD  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[vehicle] ADD  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[vehicle] ADD  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[vehicle] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[vin_decoding] ADD  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [master].[vin_decoding] ADD  CONSTRAINT [DF__vin_decode__creat__44FF419A]  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[vin_decoding] ADD  CONSTRAINT [DF__vin_decode__is_pr__4222D4EF]  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[vin_decoding] ADD  CONSTRAINT [DF_vin_decode_updated_by]  DEFAULT (suser_name()) FOR [updated_by]
GO
ALTER TABLE [master].[vin_decoding] ADD  CONSTRAINT [DF_vin_decode_updated_dt]  DEFAULT (getdate()) FOR [updated_dt]
GO
ALTER TABLE [master].[vin_decoding] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [master].[zip_code_distance] ADD  DEFAULT (getdate()) FOR [created_dt]
GO
ALTER TABLE [master].[zip_code_distance] ADD  DEFAULT (suser_name()) FOR [created_by]
GO
ALTER TABLE [master].[zip_code_long_lat] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [master].[zip_code_long_lat] ADD  DEFAULT (getdate()) FOR [updated_date]
GO
ALTER TABLE [master].[declined_comment_details]  WITH CHECK ADD  CONSTRAINT [FK_declined_comment_details_declined_comments] FOREIGN KEY([declined_comment_id])
REFERENCES [master].[declined_comments] ([declined_comment_id])
GO
ALTER TABLE [master].[declined_comment_details] CHECK CONSTRAINT [FK_declined_comment_details_declined_comments]
GO
ALTER TABLE [master].[list_suppress]  WITH CHECK ADD  CONSTRAINT [FK_list_suppress_list_status] FOREIGN KEY([status_id])
REFERENCES [master].[list_status] ([status_id])
GO
ALTER TABLE [master].[list_suppress] CHECK CONSTRAINT [FK_list_suppress_list_status]
GO
ALTER TABLE [master].[repair_order_opcode_details]  WITH CHECK ADD  CONSTRAINT [FK_repair_order_opcode_details_repair_order_header_detail] FOREIGN KEY([master_ro_detail_id])
REFERENCES [master].[repair_order_header_detail] ([master_ro_detail_id])
GO
ALTER TABLE [master].[repair_order_opcode_details] CHECK CONSTRAINT [FK_repair_order_opcode_details_repair_order_header_detail]
GO
ALTER TABLE [master].[repair_order_opcodes]  WITH CHECK ADD FOREIGN KEY([opcode_category_id])
REFERENCES [master].[repair_order_opcode_category] ([opcode_category_id])
GO
ALTER TABLE [master].[repair_order_opcodes_test]  WITH CHECK ADD FOREIGN KEY([opcode_category_id])
REFERENCES [master].[repair_order_opcode_category] ([opcode_category_id])
GO
ALTER TABLE [master].[ro_op_codes_category]  WITH CHECK ADD  CONSTRAINT [FK_ro_op_codes_category_repair_order_opcode_category] FOREIGN KEY([opcode_category_id])
REFERENCES [master].[repair_order_opcode_category] ([opcode_category_id])
GO
ALTER TABLE [master].[ro_op_codes_category] CHECK CONSTRAINT [FK_ro_op_codes_category_repair_order_opcode_category]
GO
ALTER TABLE [master].[suppressions]  WITH CHECK ADD  CONSTRAINT [FK_suppressions_list_suppress] FOREIGN KEY([list_suppress_id])
REFERENCES [master].[list_suppress] ([list_suppress_id])
GO
ALTER TABLE [master].[suppressions] CHECK CONSTRAINT [FK_suppressions_list_suppress]
GO

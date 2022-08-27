use clictell_auto_etl;
/****** Object:  Table [error].[records_2_validate]    Script Date: 12/23/2020 1:45:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [error].[records_2_validate](
[error_rec_validating_id] [int] IDENTITY(1,1) NOT NULL,
[source_sale_service_id] [int] NULL,
[table_desc_type] [varchar](100) NULL,
[source_error_desc] [varchar](100) NULL,
[vin] [varchar](50) NULL,
[is_processed] [bit] NULL,
[is_deleted] [bit] NULL,
[created_date] [datetime] NULL,
[created_by] [varchar](100) NULL,
[updated_date] [datetime] NULL,
[updated_by] [varchar](100) NULL,
[file_log_id] [int] NULL,
[file_log_detail_id] [int] NULL,
[source_file_type] [varchar](50) NULL,
[parent_dealer_id] [int] NULL,
[natural_key] [varchar](30) NULL,
 CONSTRAINT [PK__records___B8F0EA256BC337C7] PRIMARY KEY CLUSTERED 
(
[error_rec_validating_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

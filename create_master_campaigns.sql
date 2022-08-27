USE [clictell_auto_master]
GO

/****** Object:  Table [master].[campaigns]    Script Date: 11/23/2021 8:12:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [master].[campaigns](
	[master_campaign_id] [int] IDENTITY(1,1) NOT NULL,
	[parent_dealer_id] [int] NULL,
	[campaign_id] [int] NULL,
	[campaign_date] [datetime] NULL,
	[campaign_run_id] [int] NULL,
	[program_name] [varchar](250) NULL,
	[touch_point] [varchar](250) NULL,
	[media_type] [varchar](50) NULL,
	[sent] [int] NULL,
	[delivered] [int] NULL,
	[opened] [int] NULL,
	[clicked] [int] NULL,
	[bounced] [int] NULL,
	[failed] [int] NULL,
	[responders] [int] NULL,
	[ro_amount] [int] NULL,
	[is_deleted] [bit] NULL,
	[created_dt] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[updated_dt] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[cp_amount] [decimal](18, 2) NULL,
	[wp_amount] [decimal](18, 2) NULL,
	[ip_amount] [decimal](18, 2) NULL,
	[parts_amount] [decimal](18, 2) NULL,
	[labor_amount] [decimal](18, 2) NULL,
	[sales_amount] [decimal](18, 2) NULL
) ON [PRIMARY]
GO

ALTER TABLE [master].[campaigns] ADD  CONSTRAINT [DF__campaigns__is_de__08F5448B]  DEFAULT ((0)) FOR [is_deleted]
GO

ALTER TABLE [master].[campaigns] ADD  CONSTRAINT [DF__campaigns__creat__09E968C4]  DEFAULT (getdate()) FOR [created_dt]
GO

ALTER TABLE [master].[campaigns] ADD  CONSTRAINT [DF__campaigns__creat__0ADD8CFD]  DEFAULT (suser_name()) FOR [created_by]
GO

ALTER TABLE [master].[campaigns] ADD  CONSTRAINT [DF__campaigns__updat__0BD1B136]  DEFAULT (getdate()) FOR [updated_dt]
GO

ALTER TABLE [master].[campaigns] ADD  CONSTRAINT [DF__campaigns__updat__0CC5D56F]  DEFAULT (suser_name()) FOR [updated_by]
GO



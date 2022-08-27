USE [auto_customers]
GO
/****** Object:  StoredProcedure [customer].[get_condition_elements_data]    Script Date: 8/25/2022 11:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--ALTER procedure [customer].[get_condition_elements_data]      
   declare     
  @account_id uniqueidentifier = null,
  @dealer_id int = 1604,
  @list_type_id int = 3
		
--AS        
/*
  exec [customer].[get_condition_elements_data] '93d00129-a276-49ff-bfeb-8c80b5443b72', 524, 3
  -----------------------------------------------------------------------------------------             
  MODIFICATIONS        
  Date            Author      Work Tracker Id      Description          
  -----------------------------------------------------------------------------------------       
  3/23/2021    Madhavi.k           Created-This procedure is used to get segment data elements
  6/6/2021     Raviteja.V.V        Updated-This procedure is used to get segment data elements
  ------------------------------------------------------------------------------------------     
                              Copyright 2017 Warrous Pvt Ltd 
							   
*/        
BEGIN

SET NOCOUNT ON 

IF OBJECT_ID('tempdb..#OperatorValues') IS NOT NULL
DROP TABLE #OperatorValues

IF OBJECT_ID('tempdb..#Makes') IS NOT NULL
DROP TABLE #Makes

IF OBJECT_ID('tempdb..#Models') IS NOT NULL
DROP TABLE #Models

IF OBJECT_ID('tempdb..#Years') IS NOT NULL
DROP TABLE #Years
drop table if exists #SegmentDataElements
drop table if exists #temp_class
drop table if exists #vehicle_class


	 set @dealer_id = iif(@dealer_id > 0, @dealer_id, null)
	 set @list_type_id = iif(@list_type_id > 2, @list_type_id, 2)

	 --Form here we add all dynamic values(from different tables) for operators

	 --makes insert (23 is element_id for make)
	 select
		o.[element_operator_id],
		o.[operator_name],
		cast('Make' as varchar(200)) as [name],
		cast(isnull(m.[make],'') as varchar(200)) as [value],
		cast(m.[make] as varchar(200)) as [description]
	 into
		#Makes
	 from 
		(select distinct [makedesc] as [make] from [master].[vehicle_makemodel] (nolock) where parent_dealer_id = @dealer_id) m
		cross join (select distinct [element_operator_id], [operator_name] from [customer].[element_operators] where [element_id] = 23) as o

	--models insert (24 is element_id for model)
	 select
		o.[element_operator_id],
		o.[operator_name],
		cast('Model' as varchar(200)) as [name],
		cast(isnull(m.[model],'') as varchar(200)) as [value],
		cast(m.[model] as varchar(200)) as [description]
	 into
		#Models
	 from 
		(select distinct [modeldesc] as [model] from [master].[vehicle_makemodel] (nolock) where parent_dealer_id = @dealer_id) m
		cross join (select distinct [element_operator_id], [operator_name] from [customer].[element_operators] where [element_id] = 24) as o

	--years insert (25 is element_id for year)
	 select
		o.[element_operator_id],
		o.[operator_name],
		cast('Year' as varchar(200)) as [name],
		cast(isnull(m.[year],'') as varchar(200)) as [value],
		cast(m.[year] as varchar(200)) as [description]
	 into
		#Years
	 from 
		(select distinct [modelyear] as [year] from [master].[vehicle_makemodel] (nolock) where parent_dealer_id = @dealer_id) m
		cross join (select distinct [element_operator_id], [operator_name] from [customer].[element_operators] where [element_id] = 25) as o


		select   
				distinct sale_classs as vehicle_class
			into #temp_class
		from 
			auto_customers.customer.vehicles a (nolock)
		inner join auto_customers.customer.customers b (nolock) on a.customer_id = b.customer_id
		where 
			b.is_deleted =0 and a.is_deleted =0 and len(isnull(sale_classs,'')) <> 0
			and b.account_id = (select _id from clictell_auto_master.master.dealer (nolock) where parent_dealer_id = @dealer_id)



		select 
					o.[element_operator_id]
					,o.[operator_name]
					,'Vehicle Class' as name
					,m.vehicle_class as [value]
					,m.vehicle_class as [description]
				into #vehicle_class
		from 
		(select vehicle_class from #temp_class) as m
		cross join (select distinct [element_operator_id], [operator_name] from [customer].[element_operators] where [element_id] = 110 and element_operator_id in (399,400))  as o

	 select [element_operator_id], [value], [description] into #OperatorValues from #Makes order by element_operator_id, [value]
	 --insert into #OperatorValues select [element_operator_id], [value], [description] from #Makes order by element_operator_id, [value]
	 insert into #OperatorValues select [element_operator_id], [value], [description] from #Models order by element_operator_id, [value]
	 insert into #OperatorValues select [element_operator_id], [value], [description] from #Years order by element_operator_id, [value]
	 insert into #OperatorValues select [element_operator_id], [value], [description] from #vehicle_class order by element_operator_id, [value]

	 --select * from #OperatorValues
		--select   --count(*)
		--		distinct sale_classs as vehicle_class
		--	--into #temp_class
		--from 
		--	auto_customers.customer.vehicles a (nolock)
		--inner join auto_customers.customer.customers b (nolock) on a.customer_id = b.customer_id
		--where 
		--	b.is_deleted =0 and a.is_deleted =0 --and len(isnull(sale_classs,'')) <> 0
		--	and b.account_id = (select _id from clictell_auto_master.master.dealer (nolock) where parent_dealer_id = 1604)

			--select * 
			----update a set parent_dealer_id = 1604--,model = '112 SX', modeldesc ='112 SX',modelyear = '2021'
			--from master.vehicle_makemodel a (nolock) where make = 'ACE'  and model = 'ACE STANDARD' and makemodel_id = 30265
			
			--select 
			--		a.vehicle_id,a.make,a.model,a.year,a.sale_classs
			--		--update a set sale_classs  = 'Birt Bike'
			--from 
			--auto_customers.customer.vehicles a (nolock) 
			--inner join auto_customers.customer.customers b (nolock) on a.customer_id = b.customer_id
			--where a.account_id = 'F4E3E402-657F-4807-971F-EF301779E950' and a.is_deleted =0 and b.is_deleted =0 
			--and a.sale_classs is not null
			--and a.vehicle_id = 3272

	 --select * from #OperatorValues order by element_operator_id
	 --return
	 
--select * from clictell_auto_master.master.dealer (nolock) where accountname like 'free%'
	 -- final step
	  
	 select
		  cse.element_id,
		  cse.[name],
		  cse.[name] as [element_name],
		  ceo.element_operator_id,
		  ceo.operator_name,
		  cft.field_type_name as next_field_type,
		  ISNULL(cov.value,'') as value,
		  ISNULL(cov.description,'') as value_description
	 into
		#SegmentDataElements
	 from
		 [customer].[segment_elements] cse with(nolock,readuncommitted)
		 inner join [customer].[element_operators] ceo with(nolock,readuncommitted)
		 on cse.element_id = ceo.element_id
		 inner join [dbo].[field_type] cft with(nolock,readuncommitted)
		 on ceo.field_type_id = cft.field_type_id
		 left join #OperatorValues cov with(nolock,readuncommitted)
		 on ceo.[element_operator_id] = cov.[element_operator_id]
	 where 
		cse.is_deleted = 0
		and cse.element_id in (23,24,25,110)
		and ceo.is_deleted = 0
	 order by
		cse.element_id asc, ceo.[element_operator_id] asc

	 select * from #SegmentDataElements order by element_id, element_operator_id asc

SET NOCOUNT OFF        
      
END


--select * from clictell_auto_master.master.vehicle_makemodel (nolock)
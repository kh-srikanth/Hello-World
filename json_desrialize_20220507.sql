declare @jss nvarchar(max)  = '[{"displayName":"Inbox","displayValue":"Inbox","iconName":".\/assets\/media\/svg\/SideBarIcons\/inbox.svg","route":"\/inbox","ModuleName":"Marketing"},{"displayName":"Customers","displayValue":"ServiceCustomers","iconName":".\/assets\/media\/svg\/SideBarIcons\/customers.svg","route":"","ModuleName":"Service CRM","children":[{"displayName":"View by All","displayValue":"ServiceViewbyAll","iconName":"","route":"\/crm-customers\/customers\/View by Status\/AllC","ModuleName":"Service CRM"},{"displayName":"View by Status","displayValue":"ServiceViewbyStatus","iconName":"","route":"#","ModuleName":"Service CRM"},{"displayName":"View by Call Status","displayValue":"ServiceViewbyCallStatus","iconName":"","route":"#","ModuleName":"Service CRM"}]},{"displayName":"Leads","displayValue":"Leads","iconName":".\/assets\/media\/svg\/SideBarIcons\/leads.svg","route":"","ModuleName":"Sales CRM","children":[{"displayName":"View by All","displayValue":"SalesViewbyAll","iconName":"","route":"\/crm-leads\/lead-management\/View by Status\/All","ModuleName":"Sales CRM"},{"displayName":"View by Status","displayValue":"SalesViewbyStatus","iconName":".\/assets\/media\/svg\/SideBarIcons\/arrow.svg","route":"#","ModuleName":"Sales CRM"},{"displayName":"View By Department","displayValue":"SalesViewbyDepartment","iconName":".\/assets\/media\/svg\/SideBarIcons\/arrow.svg","route":"#","ModuleName":"Sales CRM"},{"displayName":"View By Request Type","displayValue":"SalesViewbyRequest","iconName":".\/assets\/media\/svg\/SideBarIcons\/arrow.svg","route":"#","ModuleName":"Sales CRM"},{"displayName":"View by Source","displayValue":"SalesViewbySource","iconName":".\/assets\/media\/svg\/SideBarIcons\/arrow.svg","route":"#","ModuleName":"Sales CRM"},{"displayName":"View by Call Status","displayValue":"SalesViewbyCallStatus","iconName":"","route":"#","ModuleName":"Sales CRM"}]}]'
		--select @jss
		--select * from openjson(@jss)
		
		drop table if exists #temp
		select 	*  into #temp from openjson(@jss)
		
		
		drop table if exists #temp2
		select 
				a.[key]
				,a.value
				,b.[key] as key1
				,b.[value] as value1
			into #temp2
		from #temp a
		cross apply openjson(value) b

		drop table if exists #temp3
		select 
				a.[key]
				,a.[key1]
				,a.value1
				,b.[key] as key2
				,b.[value] as value2
			into #temp3
		from #temp2 a
		cross apply openjson(value1) b
		where key1 = 'children'

		--select * from #temp3
		drop table if exists #temp5
		select 
				a.[key]
				,a.[key1]
				,a.key2
				,b.[key] as key3
				,b.[value] as value3
			into #temp5
		from #temp3 a
		cross apply openjson(value2) b



		select * from #temp2
		select * from #temp3
		select * from #temp5


		drop table if exists #result
		select 
			a.[key]	
			,a.key1
			,a.value1
			,key2
			,key3
			,value3
			into #result
		from #temp2 a
		left outer join #temp5 b on a.[key] = b.[key] and a.key1 = b.key1


		select 
			* 
		from #result

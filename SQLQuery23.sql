USE [clictell_auto_stg]
GO
/****** Object:  StoredProcedure [stg].[move_servicero_detail_stage_2_master]    Script Date: 3/2/2021 3:20:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
  ALTER procedure  [stg].[move_servicero_detail_stage_2_master]  
    
	@file_process_id int 

as 
/*
	   exec [master].[move_ro_header_detail_stage_2_master] 94
-----------------------------------------------------------------------  


	PURPOSE  
	To split customer data from sales service & service appointment customers based on etl

	PROCESSES  

	MODIFICATIONS  
	Date			Author    Work Tracker Id   Description    
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------

	*/  

	begin


	select * into #rr_service_operations from  stg.service_ro_operations with(nolock) where file_process_id = @file_process_id
	select * into #rr_service_parts from stg.service_ro_parts with(nolock) where file_process_id = @file_process_id
	--select * into #rr_service_miscs from stg.rr_service_miscs with(nolock) where file_process_id = @file_process_id
	--select * into #rr_service_technicians from  stg.rr_service_technicians with(nolock) where file_process_id = @file_process_id
 
   create nonclustered index idx_detail1 on  #rr_service_operations (parent_dealer_id,RoNo,finalpostdate,opcode)
   create nonclustered index idx_detail2 on  #rr_service_parts (parent_dealer_id,ro_number,ro_close_Date,opcode)
   --create nonclustered index idx_detail3 on  #rr_service_miscs (parent_dealer_id,RoNo,finalpostdate)
   --create nonclustered index idx_detail4 on  #rr_service_technicians (parent_dealer_id,RoNo,finalpostdate,opcode)
 
 

	create table #rr_cost_insert 
	 (  

		  parent_dealer_id int
		 ,natural_key varchar(30) 
		 ,ro_number varchar(50) 
		 ,ro_open_date date
		 ,ro_closed_date date
		 ,vin varchar(50)	
		 ,file_process_id int 
		 ,file_process_detail_id int  
		 ,opcode varchar(250)
		 ,opcode_desc varchar(max)
		 ,ro_comment varchar(max)
         ,technician_comment varchar(max)
         ,customer_comment varchar(max)
         ,technician_note varchar(max)
		 ,actual_labor_hours decimal(9,2)
         ,billed_labor_hours decimal(9,2)
         ,billing_rate decimal(9,2)
         ,ro_opcode_pay_type varchar(50)		 
		 ,ro_total_parts_cost decimal(9,2)
		 ,ro_total_parts_price decimal(9,2)
		 ,ro_total_labor_cost decimal(9,2)
         ,ro_total_labor_price decimal(9,2)
		 ,ro_total_misc_cost decimal(9,2)
         ,ro_total_misc_price decimal(9,2)
		 ,opcode_sequence int
	 )

   	 insert into #rr_cost_insert 
	    (
		   
		  parent_dealer_id
		 ,natural_key 
		 ,ro_number 		
		 ,ro_closed_date		 
		 ,opcode  
		 ,opcode_desc 
		 ,ro_comment 
         ,technician_comment 
         ,customer_comment 
         ,technician_note
		 --,actual_labor_hours 
         ,billed_labor_hours 
         ,billing_rate          
		 ,ro_opcode_pay_type 
		 ,ro_total_parts_cost 
		 ,ro_total_parts_price 
		 ,ro_total_labor_cost 
         ,ro_total_labor_price 
		 --,ro_total_misc_cost 
         --,ro_total_misc_price 
		 ,opcode_sequence
		 ,file_process_id	
		 ,file_process_detail_id
		)

		select distinct 		   
		  a.parent_dealer_id
		 ,a.natural_key
		 ,a.RoNo 		 
		 ,a.FinalPostDate		 
		 ,a.opcode
		 ,a.opcode_desc
		 ,a.Cause
		 ,a.correction
		 ,a.complaint
		 ,a.tech_note
		 --,max(d.Techhours) as Techhours
		 ,0.00 as billed_labor_hours
		 ,isnull(a.Billrate,0.00) as Billrate
		 ,max(a.opcode_paytype)				
		 ,isnull(max(cast(b.prt_cost as decimal(9,2))),0.00) as ro_total_parts_cost
		 ,isnull(max(cast(b.prt_sale as decimal(9,2))),0.00) + isnull(max(cast(b.prt_sale as decimal(9,2))),0.00) as ro_total_parts_price 
		 ,isnull(max(cast(a.opcode_dlrcost as decimal(9,2))),0.00) as ro_total_labor_cost
		 ,isnull(max(cast(a.opcode_total_amt as decimal(9,2))),0.00) as ro_total_labor_price
		 --,isnull(max(cast(c.misc_total_amt as decimal(9,2))),0.00) as ro_total_misc_cost
		 --,isnull(max(cast(c.misc_ntxbl_amt as decimal(9,2))),0.00) + isnull(max(cast(c.misc_txbl_amt as decimal(9,2))),0.00) as ro_total_misc_price 
		 ,a.jobno
		 ,a.file_process_id
		 ,a.file_process_detail_id

		from 
		     #rr_service_operations a with(nolock) 
		     left outer join #rr_service_parts b with(nolock) on a.RoNo = b.ro_number and 
				convert(varchar(10), a.FinalPostDate, 112) = convert(varchar(10),cast(b.ro_close_date as date), 112) and 
				a.opcode = b.opcode and --a.src_dealer_code = b.src_dealer_code	
				a.parent_dealer_id = b.parent_dealer_id		
		  --   left outer join #rr_service_miscs c with(nolock) on 
			 --   a.header_xml_id = c.header_xml_id and 
				--a.RoNo = c.RoNo and 
				--convert(varchar(10), a.FinalPostDate, 112) = convert(varchar(10),cast(b.FinalPostDate as date), 112)
			 --left outer join #rr_service_technicians d with(nolock) on 
			 --   a.header_xml_id = d.header_xml_id and 
				--a.RoNo = d.RoNo and 
				--convert(varchar(10), a.FinalPostDate, 112) = convert(varchar(10),cast(d.FinalPostDate as date), 112) and
				--a.opcode = d.opcode and a.jobno = d.jobno			 	
		where 
				1 = 1  
	    group by 
		  a.parent_dealer_id,a.natural_key,a.RoNo,a.FinalPostDate,a.opcode,a.opcode_desc,
		  a.Cause,a.correction,a.complaint,a.tech_note,a.jobno,Billrate,a.file_process_id,a.file_process_detail_id
		  
		  
  create table  #master_repair_order_detail
   (
	    master_ro_detail_id int identity(1,1) 
	   ,parent_dealer_id int
	   ,natural_key varchar(30)	    
	   ,master_ro_header_id int 
	   ,master_ro_op_code_id int 
	   ,ro_number varchar(100) 
	   ,ro_closed_date int 
	   ,op_code varchar(250) 
	   ,op_code_desc varchar(4000) 
	   ,op_code_sequence int 
	   ,declined_comment varchar(4000) 
	   ,declined_reason_desc varchar(4000) 
	   ,is_declined_opcode bit 
	   ,actual_labor_hours decimal(10,2) 
	   ,billed_labor_hours decimal(10,2) 
	   ,billing_rate decimal(10,2) 
	   ,opcode_pay_type varchar(50) 	   
	   ,total_labor_cost decimal(18,2) 
	   ,total_parts_cost decimal(18,2) 
	   ,total_labor_price decimal(18,2) 
	   ,total_parts_price decimal(18,2) 
	   ,total_misc_cost decimal(18,2) 
	   ,total_misc_price decimal(18,2) 
	   ,ro_comment varchar(max) 
	   ,technician_comment varchar(max) 
	   ,customer_comment varchar(max) 
	   ,tech_recomended varchar(max)
	   ,technician_note varchar(max) 
	   ,file_process_id int 	 
	   ,file_process_detail_id  int
	   ,file_type varchar(10)	
	   ,warranty_pay_total decimal(9,2) 
	   ,internal_pay_total decimal(9,2) 
	   ,customer_pay_total decimal(9,2) 	      
	 )

    insert into #master_repair_order_detail
        (
		   
		  parent_dealer_id
		 ,natural_key
         ,master_ro_header_id
         ,master_ro_op_code_id
		 ,ro_number
		 ,ro_closed_date
         ,op_code
         ,op_code_desc
         ,op_code_sequence
         ,declined_comment
         ,declined_reason_desc
         ,is_declined_opcode
         ,actual_labor_hours
         ,billed_labor_hours
         ,billing_rate
         ,opcode_pay_type         
         ,total_labor_cost
         ,total_parts_cost
         ,total_labor_price
         ,total_parts_price
         ,total_misc_cost
         ,total_misc_price
         ,ro_comment
         ,technician_comment
         ,customer_comment
		 ,technician_note
         ,file_process_id
		 ,file_process_detail_id
		 ,file_type		
		 ,warranty_pay_total  
		 ,internal_pay_total 
		 ,customer_pay_total 		           
		)


     select distinct 		 
		 sg.parent_dealer_id
		,sg.natural_key
		,master_ro_header_id,		
		-1 as [master_ro_op_code_id],
		RoNo,
		convert(varchar(10),cast(replace(Finalpostdate,'00000000','') as date),112) as RepairOrderCloseDate,
		OpCode,
		opcode_desc
		LineNumber,
		null,
		null,
		0,
		sg.JobTotalHrs,
		sg.billtime,
		sg.Billrate,
	    case when sg.opcode_paytype = 'C' then 'Cust'
		     when sg.opcode_paytype = 'I' then 'Intr'
			 when sg.opcode_paytype = 'W' then 'Warr' else sg.opcode_paytype end ,		
		rod.total_labor_cost,
		rod.total_parts_price,
		rod.total_labor_price,
		rod.total_parts_price,
		rod.total_misc_cost,
		rod.total_misc_price,
		sg.Cause,
		isnull(sg.correction,''),
		isnull(sg.complaint,''),
		'',
		sg.file_process_id,
		sg.file_process_detail_id,
		'DMI' ,
		rod.total_warranty_cost,
		rod.total_internal_cost,
		rod.total_customer_cost

	from 
		stg.service_ro_operations sg with(nolock) 	
		 inner join master.repair_order_header rod with(nolock) on 
		   sg.RoNo = rod.ro_number and 		    
		   sg.parent_dealer_id = rod.parent_dealer_id and 
		   --sg.vin = rod.vin and 
		   convert(varchar(10),cast(replace(sg.Finalpostdate,'00000000','') as date),112)  = ro_close_date
		   		  
	where 		 
		sg.file_process_id= @file_process_id
		
    order by
	    opcode
		
	

    insert into #master_repair_order_detail
        (
		   
		  parent_dealer_id
		 ,natural_key
         ,master_ro_header_id
         ,master_ro_op_code_id
		 ,ro_number
		 ,ro_closed_date
         ,op_code
         ,op_code_desc
         ,op_code_sequence
         ,declined_comment
         ,declined_reason_desc
         ,is_declined_opcode
         ,actual_labor_hours
         ,billed_labor_hours
         ,billing_rate
         ,opcode_pay_type         
         ,total_labor_cost
         ,total_parts_cost
         ,total_labor_price
         ,total_parts_price
         ,total_misc_cost
         ,total_misc_price
         ,ro_comment
         ,technician_comment
         ,customer_comment
		 ,technician_note
		 ,file_process_id
         ,file_process_detail_id
		 ,file_type		          
		)


     select distinct 		 
		sg.parent_dealer_id,
		sg.natural_key,
		master_ro_header_id,		
		-1 as [master_ro_op_code_id],
	    sg.ro_number,
	    convert(varchar(10),cast(replace(sg.ro_closed_date,'00000000','') as date),112) as ro_closed_date,
		sg.opcode,
		sg.opcode_desc,
		sg.opcode_sequence,
		'',
		'',
		0,
		sg.actual_labor_hours,
		sg.billed_labor_hours,
		sg.billing_rate,
		sg.ro_opcode_pay_type,		
		sg.ro_total_labor_cost,
		sg.ro_total_parts_cost,
		sg.ro_total_labor_price,
		sg.ro_total_parts_price,
		sg.ro_total_misc_cost,
		sg.ro_total_misc_price,
		sg.ro_comment,
		isnull(sg.technician_comment,''),
		isnull(sg.customer_comment,''),
	    isnull(sg.technician_note,''),
		sg.file_process_id,
		sg.file_process_detail_id,	
		'RNR'     	
	from 
		#rr_cost_insert sg		
		 inner join master.repair_order_header rod with(nolock) on 
		   sg.ro_number = rod.ro_number and 		   
		   sg.parent_dealer_id = rod.parent_dealer_id	and 
		   convert(varchar(10),cast(replace(sg.ro_closed_date,'00000000','') as date),112)  = ro_close_date
		   		  
	where 		   
		  rod.file_process_id = @file_process_id
		 
    order by 
	    sg.opcode
	
	
	select 
	     * ,
		 row_number() over (partition by ro_number,parent_Dealer_id,ro_closed_date,op_code,op_code_sequence order by op_code_sequence , isnull(customer_comment,'')desc,isnull(technician_comment,'')desc,isnull(ro_comment,'')desc,isnull(technician_note,'')desc,master_ro_detail_id) as rnk 
    into 
	   #master_repair_order_detail_final
	from 
	   #master_repair_order_detail
	   
    insert into error.repair_order_header_detail
           (
		     
			parent_Dealer_id
		   ,natural_key
           ,master_ro_header_id
           ,master_ro_op_code_id
           ,ro_number
           ,ro_closed_date
           ,op_code
           ,op_code_desc
           ,op_code_sequence
           ,declined_comment
           ,declined_reason_desc
           ,is_declined_opcode
           ,actual_labor_hours
           ,billed_labor_hours
           ,billing_rate
           ,opcode_pay_type           
           ,total_labor_cost
           ,total_parts_cost
           ,total_labor_price
           ,total_parts_price
           ,total_misc_cost
           ,total_misc_price
           ,ro_comment
           ,technician_comment
           ,customer_comment		              
           ,file_process_id
		   ,file_process_detail_id
           ,created_date
           ,updated_date
           ,created_by
           ,updated_by
		   )

	select 
		   
		    mas.parent_Dealer_id
		   ,mas.natural_key
		   ,mas.master_ro_header_id
		   ,mas.master_ro_op_code_id
		   ,mas.ro_number
		   ,mas.ro_closed_date
		   ,mas.op_code
		   ,mas.op_code_desc
		   ,mas.op_code_sequence
		   ,mas.declined_comment
		   ,mas.declined_reason_desc
		   ,mas.is_declined_opcode
		   ,mas.actual_labor_hours
		   ,mas.billed_labor_hours
		   ,mas.billing_rate
		   ,mas.opcode_pay_type		  
		   ,mas.total_labor_cost
		   ,mas.total_parts_cost
		   ,mas.total_labor_price
		   ,mas.total_parts_price
		   ,mas.total_misc_cost
		   ,mas.total_misc_price
		   ,mas.ro_comment
		   ,mas.technician_comment
		   ,mas.customer_comment
		   ,mas.file_process_id
		   ,mas.file_process_detail_id
		   ,getdate()
           ,getdate()
           ,suser_name()
           ,suser_name()
	from 
	     #master_repair_order_detail_final mas 
		  left outer join error.repair_order_header_detail erod with(nolock) on 
		   mas.ro_number = erod.ro_number and 
		   mas.parent_dealer_id = erod.parent_dealer_id and 
		   mas.ro_closed_date = erod.ro_closed_date 
	where
	     1= 1 
	     and rnk >= 2 
		 and erod.master_ro_detail_check_id is null 

		 
      insert into master.repair_order_header_detail
           (
		    
			parent_dealer_id
		   ,natural_key
           ,master_ro_header_id
           ,master_ro_op_code_id
           ,ro_number
           ,ro_closed_date
           ,op_code
           ,op_code_desc
           ,op_code_sequence
           ,declined_comment           
           ,is_declined_opcode
           ,actual_labor_hours
           ,billed_labor_hours
           ,billing_rate
           ,opcode_pay_type           
           ,total_labor_cost
           ,total_parts_cost
           ,total_labor_price
           ,total_parts_price
           ,total_misc_cost
           ,total_misc_price
           ,ro_comment
           ,technician_comment
           ,customer_comment
		   ,technician_note
           ,file_process_id
		   ,file_process_detail_id
           ,created_date
           ,updated_date
           ,created_by
           ,updated_by
		   ,total_warranty_amount
		   ,total_customer_amount
		   ,total_internal_amount	
		   )

	select 
		   
		    mas.parent_dealer_id
		   ,mas.natural_key
		   ,mas.master_ro_header_id
		   ,mas.master_ro_op_code_id
		   ,mas.ro_number
		   ,mas.ro_closed_date
		   ,mas.op_code
		   ,mas.op_code_desc
		   ,mas.op_code_sequence
		   ,mas.declined_comment		   
		   ,mas.is_declined_opcode
		   ,mas.actual_labor_hours
		   ,mas.billed_labor_hours
		   ,mas.billing_rate
		   ,mas.opcode_pay_type		   
		   ,mas.total_labor_cost
		   ,mas.total_parts_cost
		   ,mas.total_labor_price
		   ,mas.total_parts_price
		   ,mas.total_misc_cost
		   ,mas.total_misc_price
		   ,mas.ro_comment
		   ,mas.technician_comment
		   ,mas.customer_comment
		   ,mas.technician_note
		   ,mas.file_process_id
		   ,mas.file_process_detail_id
		   ,getdate()
           ,getdate()
           ,suser_name()
           ,suser_name()
		   ,warranty_pay_total  
		   ,internal_pay_total 
		   ,customer_pay_total 	
	from 
	     #master_repair_order_detail_final mas 
		  left outer join master.repair_order_header_detail erod with(nolock) on 
		   mas.ro_number = erod.ro_number and 		    
		   mas.parent_dealer_id = erod.parent_dealer_id and 
		   mas.ro_closed_date = erod.ro_closed_date and 
		   mas.op_code = erod.op_code and 
		   mas.op_code_sequence = erod.op_code_sequence
	where 
	      1= 1 
	      and rnk = 1 
		  and erod.master_ro_detail_id is null 
		
		 
	insert into [master].[ro_op_codes]
		(
		op_code,
		op_code_desc		 
		)
	select distinct 
		a.op_code,
		a.op_code_desc		 
	from 
	 master.repair_order_header_detail a with(nolock)
		left join master.ro_op_codes b with(nolock) on
		a.op_code= b.op_code and 
		a.op_code_desc = b.op_code_desc
	where 
	    b.master_ro_op_code_id is null and 
		  a.file_process_id = @file_process_id
		  
		 
-----------------------------------------------END DMI REPAIR ORDER DETAILS WITH DUPLICATES MOVING TO OTHER ERROR TABLE--------------------------------------------------------------
 		
	update 
	     rod 
	set 
	     rod.upsell_flag = sop.UpSellFlag   
	from 
	    stg.service_ro_operations sop with(nolock)
          inner join master.repair_order_header_detail rod  with(nolock) on              
			 sop.parent_Dealer_id = rod.parent_dealer_id and 
             sop.RoNo = rod.ro_number and 
             sop.opcode = rod.op_code and
             convert(varchar(10),cast(sop.FinalPostDate as date), 112) = rod.ro_closed_date
	 where 
	     
		sop.file_process_id = @file_process_id
		
		
	--update 
	--    rod 
 --   set
	--    rod.master_ro_op_code_id = roc.master_ro_op_code_id,
	--	rod.opcode_category_id = roc.op_code_service_desc_id
 --   from 
	--    master.repair_order_header_detail rod with(nolock)
 --        inner join master.ro_op_codes roc with(nolock) on 
 --            rod.op_code = roc.op_code and  
	--		 rod.op_code_desc = roc.op_code_desc
 --    where 	    
	--	rod.file_process_id = @file_process_id

		 
        drop table #rr_cost_insert
		drop table #master_repair_order_detail
		drop table #master_repair_order_detail_final 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	/*	Moving Technician from RNR & DMI to ro_details_technicians */		

	select * 
	     into #master_repair_order_header_detail 
	from 
	  master.repair_order_header_detail with(nolock)
	 where 	 
	   file_process_id = @file_process_id


    create nonclustered index idx_detail on  #master_repair_order_header_detail (parent_dealer_id,ro_number,ro_closed_date,op_code)
 		
	create table #master_ro_detail_technicians
	  (
	     
	      master_ro_detail_tech_id int identity(1,1) 
	     ,master_ro_detail_id int
	     ,master_ro_header_id int
		 ,parent_dealer_id int
		 ,natural_key varchar(30)		  
	     ,tech_no varchar(50) 
	     ,tech_name varchar(250) 
	     ,tech_hrs decimal(18,2) 
		 ,cust_tech_rate decimal(18,2)
		 ,warr_tech_rate decimal(18,2)
		 ,intr_tech_rate decimal(18,2)
	     ,file_process_id int 
		 ,file_process_detail_id int         
	      
	  )		
		
	insert into #master_ro_detail_technicians
           (
		    master_ro_detail_id
           ,master_ro_header_id
		   ,parent_dealer_id
		   ,natural_key
		   --,src_dealer_code
           ,tech_no
           ,tech_name
           ,tech_hrs
		   ,cust_tech_rate
		   ,warr_tech_rate
		   ,intr_tech_rate
           ,file_process_id    
		   ,file_process_detail_id       
          )

    select 
	    distinct 
           rd.master_ro_detail_id
		  ,rd.master_ro_header_id
		  ,rd.parent_dealer_id
		  ,rd.natural_key
		  --,cc.src_dealer_code
		  ,Techno
		  ,Techname
		  ,'0.00'
		  ,null
		  ,null
		  ,null
		  ,cc.file_process_id	
		  ,cc.file_process_detail_id	  
		   
     from 
	    stg.service_ro_technicians cc  with(nolock)
		   inner join #master_repair_order_header_detail rd with(nolock) on
			 cc.RoNo=rd.ro_number and
			 convert(varchar(10),cast(cc.FinalPostDate as date), 112) =rd.ro_closed_date and
			 --cc.src_dealer_code=rd.src_dealer_code and
			 cc.parent_dealer_id = rd.parent_dealer_id and 
			 cc.OpCode=rd.op_code
    where  
	   --cc.file_process_id = @job_process_id  
	   cc.file_process_id = @file_process_id
	   


		insert into #master_ro_detail_technicians
           (
		    master_ro_detail_id
           ,master_ro_header_id
		   --,src_dealer_code
		   ,parent_dealer_id
		   ,natural_key
           ,tech_no
           ,tech_name
           ,tech_hrs
		   ,cust_tech_rate
		   ,warr_tech_rate
		   ,intr_tech_rate
           ,file_process_id 
		   ,file_process_detail_id          
          )

    select 
	    distinct 
           rd.master_ro_detail_id
		  ,rd.master_ro_header_id
		  ,cc.parent_dealer_id
		  ,cc.natural_key
		  --,cc.src_dealer_code
		  ,Techno
		  ,Techname
		  ,Techhours
		  ,cust_tech_rate
		  ,warr_tech_rate
		  ,intr_tech_rate
		  ,cc.file_process_id	
		  ,cc.file_process_detail_id	  
		   
     from 
	    stg.service_ro_technicians cc  with(nolock)
		   inner join #master_repair_order_header_detail rd with(nolock) on
			 cc.RoNo=rd.ro_number and
			 convert(varchar(10),cast(cc.FinalPostDate as date), 112) =rd.ro_closed_date and
			 --cc.src_dealer_code=rd.src_dealer_code and
			 cc.parent_dealer_id = rd.parent_dealer_id and
			 cc.OpCode=rd.op_code
    where  
	   --cc.file_process_id = @job_process_id
	   cc.file_process_id = @file_process_id
	   

    select  
	       master_ro_detail_id
		  ,master_ro_header_id
		  --,src_dealer_code
		  ,parent_dealer_id
		  ,natural_key
	      ,tech_no
		  ,tech_name
		  ,sum(tech_hrs) as tech_hrs
		  ,max(cust_tech_rate) as cust_tech_rate
		  ,max(warr_tech_rate) as warr_tech_rate
		  ,max(intr_tech_rate) as intr_tech_rate		  
	into
	    #master_ro_detail_technicians_main
	from
		#master_ro_detail_technicians 
   
    group by 
	     master_ro_detail_id
		,master_ro_header_id
	    ,tech_no
		,parent_dealer_id
		,natural_key
		--,src_dealer_code
		,tech_name
		
 	insert into master.ro_detail_technicians
           (
		    master_ro_detail_id
           ,master_ro_header_id
		   ,parent_Dealer_id
		   ,natural_key
           ,tech_no
           ,tech_name
           ,tech_hrs
		   ,cust_tech_rate
		   ,warr_tech_rate
		   ,intr_tech_rate
           ,file_process_id 
		   ,file_process_detail_id
		   ,created_date
		   ,created_by
		   ,updated_date
		   ,updated_by        
          )
	select 
	     distinct 
	        mrt.master_ro_detail_id
           ,mrt.master_ro_header_id
		   ,mrt.parent_Dealer_id
		   ,mrt.natural_key
           ,mrt.tech_no
           ,mrt.tech_name
           ,isnull(mrt.tech_hrs,0.00)
		   ,isnull(mrt.cust_tech_rate,0.00)
		   ,isnull(mrt.warr_tech_rate,0.00)
		   ,isnull(mrt.intr_tech_rate,0.00)
           ,null
		   ,null
		   ,getdate()
		   ,suser_name()
		   ,getdate()
		   ,suser_name()
	from 
	    #master_ro_detail_technicians_main mrt
	     left outer join master.ro_detail_technicians  mrd with(nolock) on 
		   mrt.tech_name = mrd.tech_name and 
		   mrt.tech_no  = mrd.tech_no and 
		   mrt.master_ro_detail_id = mrd.master_ro_detail_id
	where	  
		 mrd.master_ro_detail_tech_id is null 		
		 
		update mrt 
		  set mrt.file_process_id = rod.file_process_id,
			  mrt.file_process_detail_id = rod.file_process_detail_id
		from 
		master.ro_detail_technicians mrt 
		 inner join master.repair_order_header rod on 
		   mrt.master_ro_header_id = rod.master_ro_header_id
		where 
		  -- rod.job_process_id = @job_process_id
		 rod.file_process_id = @file_process_id

		  
     drop table #master_ro_detail_technicians
	 drop table #master_ro_detail_technicians_main  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------		
                  /* Moving PARTS DETAILS from RNR & DMI to master from stage */

    create table #master_ro_parts_details
	        (
               master_ro_parts_detail_id int identity(1,1) 
	          ,master_ro_header_id int 
	          ,master_ro_detail_id int
			  ,parent_dealer_id int
			  ,natural_key varchar(30)
	          --,src_dealer_code varchar(15)
	          --,dealer_id int
	          ,ro_number varchar(50)	      
	          ,part_sequence int 
	          ,part_number varchar(50) 
	          ,part_desc varchar(500) 
	          ,part_quantity int 
	          ,indv_unit_part_cost decimal(18,2) 
	          ,indv_unit_part_sale decimal(18,2)	       
	          --,oem_id int 
	          ,file_process_id int
			  ,file_process_detail_id int 			
		     )
  

    insert into #master_ro_parts_details
             (
		       master_ro_detail_id
		      ,master_ro_header_id
			  ,parent_dealer_id
			  ,natural_key
		      --,src_dealer_code
		      --,dealer_id
		      ,ro_number		      
              ,part_sequence
              ,part_number
              ,part_desc
              ,part_quantity
              ,indv_unit_part_cost
              ,indv_unit_part_sale              
              --,oem_id
              ,file_process_id
			  ,file_process_detail_id
              
		    )
			
	 select 
	       distinct 
		      rd.master_ro_detail_id
			 ,rd.master_ro_header_id
			 ,cc.parent_dealer_id
			 ,cc.src_dealer_code
			 --,cc.src_dealer_code
			 --,pd.dealer_id
			 ,cc.ro_number			 
			-- ,LineNumber
			,lbrLineCode
			 --,PartNumberDMSValue
			 ,prt_part_no
			 --,PartDescription
			 ,prt_class
			 --,Quantity
			 ,prt_qty_sold	
			 --,UnitCost
			 ,prt_cost
			 --,UnitPrice	
			 ,prt_sale
			 --,pd.org_id
			 ,cc.file_process_id
			 ,cc.file_process_detail_id			 
		   from 
			stg.service_ro_parts cc with(nolock)
			 --inner join portal.dealer pd with(nolock) on 
			 --  cc.src_dealer_code  = pd.src_dealer_code 
		     inner join #master_repair_order_header_detail rd with(nolock) on
			   cc.ro=rd.ro_number and
			   convert(varchar(10),cast(cc.ro_close_date as date), 112)=rd.ro_closed_date and
			   cc.parent_dealer_id = rd.parent_dealer_id and 
			   --cc.src_dealer_code=rd.src_dealer_code and
			   cc.OpCode=rd.op_code 
		   where  
		      --cc.file_process_id = @job_process_id
			  cc.file_process_id = @file_process_id
			  
			  and cc.prt_part_no is not null
			  
			  
      insert into #master_ro_parts_details
             (
		       master_ro_detail_id
		      ,master_ro_header_id
			  ,parent_dealer_id
			  ,natural_key
		      --,src_dealer_code
		      --,dealer_id
		      ,ro_number		      
              ,part_sequence
              ,part_number
              ,part_desc
              ,part_quantity
              ,indv_unit_part_cost
              ,indv_unit_part_sale              
              --,oem_id
              ,file_process_id 
			  ,file_process_detail_id             
		    )
			
	 select 
	       distinct 
		      rd.master_ro_detail_id
			 ,rd.master_ro_header_id
			 ,cc.parent_dealer_id
			 ,cc.src_dealer_code
			 --,cc.src_dealer_code
			 --,pd.dealer_id
			 ,cc.ro_number			 
			 --,cc.parts_seq_no
			 ,cc.part_seq_no
			 ,cc.part_no
			 --,cc.parts_num_desc
			 ,cc.part_desc
			 ,null
			 ,null
			 ,null			 
			 --,pd.org_id
			 ,cc.file_process_id
			 ,cc.file_process_detail_id			 
		   from 
			stg.service_ro_parts cc with(nolock)
			 --inner join portal.dealer pd with(nolock) on 
			 --  cc.src_dealer_code  = pd.src_dealer_code 
		     inner join #master_repair_order_header_detail rd with(nolock) on
			   cc.ro_number=rd.ro_number and
			   convert(varchar(10),cast(cc.ro_close_date as date), 112)=rd.ro_closed_date and
			   --cc.src_dealer_code=rd.src_dealer_code and
			   cc.parent_dealer_id = rd.parent_dealer_id and 
			   cc.OpCode=rd.op_code 
		   where  
		      --cc.file_process_id = @job_process_id
			  cc.file_process_id = @file_process_id
			  
			  and cc.part_no is not null 
			  

		   select 
		        *,
				rank() over (partition by master_ro_header_id,parent_dealer_id,part_sequence 
				       order by 
					   isnull(part_desc,0)desc,part_quantity desc ,master_ro_parts_detail_id desc ) as rnk 
		   into 
		       #master_ro_parts_details_rnk
		   from 
		       #master_ro_parts_details 
			   

		 insert into error.ro_parts_details 
              (
		         master_ro_header_id
                ,master_ro_detail_id
				,parent_dealer_id
				,natural_key
                --,src_dealer_code
                --,dealer_id
                ,ro_number                
                ,part_sequence
                ,part_number
                ,part_desc
                ,part_quantity
                ,indv_unit_part_cost
                ,indv_unit_part_sale
                --,oem_id
                ,file_process_id
				,file_process_detail_id
                ,created_date
                ,updated_date
                ,created_by
                ,updated_by
		     )
   
		 select 
		         trp.master_ro_header_id
			    ,trp.master_ro_detail_id
				,trp.parent_dealer_id
				,trp.natural_key
			    --,trp.src_dealer_code
			    --,trp.dealer_id
			    ,trp.ro_number			 
			    ,trp.part_sequence
			    ,trp.part_number
			    ,trp.part_desc
			    ,trp.part_quantity
			    ,trp.indv_unit_part_cost
			    ,trp.indv_unit_part_sale
			    --,trp.oem_id
			    ,trp.file_process_id
				,trp.file_process_detail_id
			    ,getdate()
			    ,getdate()
			    ,suser_name()
			    ,suser_name()
			    
		 from
		  #master_ro_parts_details_rnk  trp 
		   left outer join error.ro_parts_details mrp with(nolock) on 
		     trp.ro_number = mrp.ro_number and
			 trp.part_number = mrp.part_number and 
			 trp.part_desc = mrp.part_desc 
		 where 
		  rnk >= 2
		  and mrp.error_ro_parts_detail_id is null  
		  
		 insert into master.ro_parts_details 
              (
		         master_ro_header_id
                ,master_ro_detail_id
				,parent_dealer_id
				,natural_key
                --,src_dealer_code
                --,dealer_id
                ,ro_number                
                ,part_sequence
                ,part_number
                ,part_desc
                ,part_quantity
                ,indv_unit_part_cost
                ,indv_unit_part_sale
                --,oem_id
                ,file_process_id
				,file_process_detail_id
                ,created_date
                ,updated_date
                ,created_by
                ,updated_by
		     )
   
		 select 
		         trp.master_ro_header_id
			    ,trp.master_ro_detail_id
				,trp.parent_dealer_id
				,trp.natural_key
			    --,trp.src_dealer_code
			    --,trp.dealer_id
			    ,trp.ro_number			 
			    ,trp.part_sequence
			    ,trp.part_number
			    ,trp.part_desc
			    ,trp.part_quantity
			    ,trp.indv_unit_part_cost
			    ,trp.indv_unit_part_sale
			    --,trp.oem_id
			    ,trp.file_process_id
				,trp.file_process_detail_id
			    ,getdate()
			    ,getdate()
			    ,suser_name()
			    ,suser_name()
			    
		 from
		  #master_ro_parts_details_rnk  trp 
		   left outer join master.ro_parts_details mrp with(nolock) on 
		     trp.ro_number = mrp.ro_number and
			 trp.part_number = mrp.part_number and 
			 trp.part_desc = mrp.part_desc 
		 where 
		  rnk = 1   
		  and mrp.master_ro_parts_detail_id is null   
		
		
		drop table #master_ro_parts_details,#master_ro_parts_details_rnk,#master_repair_order_header_detail  



	END


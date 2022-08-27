 use clictell_auto_master
 go
 
 declare    
@from_date datetime ='2019-01-01',  
@to_date datetime ='2021-01-01',  
@months_since_purchased int = 10,  
@local_customer varchar(20) = 'All',  
@customer_id varchar(30) = null,  
@buyer_first_name varchar(100) = null,  
@buyer_last_name varchar(100) =null,  
@dealer_id varchar(30) = '1806',  
@state varchar(20) = 'All' 
  
  
 IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
 
  select  distinct  
 d.dealer_name as store  
 --,d.natural_key  
 ,isnull(datediff(month,convert(date,convert(char(10),rh.ro_open_date)),getdate()),'') as months_since_last_purchase  
 ,convert(date,convert(char(10),s.purchase_date)) as contract_date  
 ,iif(ltrim(rtrim(c.cust_state_code)) = ltrim(rtrim(d.state)), 'Local','Non-local') as local_customer  
 ,c.cust_dms_number as customer_ID  
 ,c.cust_first_name  
 ,c.cust_last_name  
 ,c.cust_state_code  
 ,c.cust_zip_code  
 ,convert(date,convert(char(8),rh.ro_close_date)) as last_service_date  
 ,convert(date,convert(char(10),rh.last_activity_date)) as last_contacted  
 ,(row_number() over(partition by v.vin order by rh.ro_close_date desc) ) as rnk
 ,rh.ro_number  
 , (case when s.nuo_flag = 'N' then 'New' when s.nuo_flag = 'U' then 'Used' else ltrim(rtrim(s.nuo_flag)) end) as nuo_flag
 ,v.make  
 ,v.model_year  
 ,v.vin 
 ,v.model
 ,v.vehicle_mileage
 ,s.sale_type  
 ,s.deal_type  
 ,s.deal_status  
 ,s.delivery_date  
 ,s.deal_status_date  
 ,s.vehicle_cost as sale_price  
 ,s.finance_apr as finace_rate  
 ,s.monthly_payment  
 ,s.contract_term as finance_term  
 ,s.total_trade_actuval_cashvalue as trade_acv  
 ,sp.sale_full_name as salesman_name  
 ,total_gross_profit as total_gross  
 ,frontend_gross_profit as front_gross  
 ,backend_gross_profit as back_gross  
into #temp 
  from   

  master.fi_sales s (nolock)
  inner join master.dealer d (nolock) on d.parent_dealer_id = s.parent_dealer_id
  left outer join master.repair_order_header rh (nolock) on rh.master_customer_id = s.master_customer_id and rh.master_vehicle_id = s.master_vehicle_id
  inner join master.customer c (nolock) on c.master_customer_id =s.master_customer_id
  inner join master.cust_2_vehicle cv (nolock) on cv.master_customer_id = c.master_customer_id and cv.master_vehicle_id = s.master_vehicle_id
  inner join master.vehicle v (nolock) on v.master_vehicle_id = cv.master_vehicle_id
  left outer join master.fi_sales_people sp (nolock) on sp.master_fi_sales_id = s.master_fi_sales_id
        
  where    
  d.parent_dealer_id = @dealer_id  
  and (convert(date,convert(char(8),s.purchase_date))  between @from_date and @to_date)  
  and (rh.ro_open_date is null or datediff(month,convert(date,convert(char(10),rh.ro_open_date)),getdate()) > = @months_since_purchased  )
	and (@local_customer = 'All' or (@local_customer !='All' and @local_customer = iif(ltrim(rtrim(c.cust_state_code)) = ltrim(rtrim(d.state)), 'Local','Non-local')))  
  and (@customer_id is null or (@customer_id is not null and  @customer_id = c.cust_dms_number))  
  and (@buyer_first_name is null or (@buyer_first_name is not null and  @buyer_first_name = cust_first_name))  
  and (@buyer_last_name is null or (@buyer_last_name is not null and  @buyer_last_name = cust_last_name))  
  and (@state = 'All' or (@state !='All' and @state =c.cust_state_code))  
  and (s.deal_type = 'Retail' or s.deal_type is null)
  and (s.deal_status in('Finalized','Sold'))

select * from #temp where rnk =1 order by customer_ID, vin

--select distinct deal_type from master.fi_sales (nolock) --where parent_dealer_id =1806

--select top 10 * from master.fi_sales_people (nolock)
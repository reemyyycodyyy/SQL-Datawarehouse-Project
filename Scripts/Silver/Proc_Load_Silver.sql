/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze → Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL process to move and transform data
    from the 'bronze' schema into the 'silver' schema.
Actions Performed:
    - Cleans and prepares Silver tables.
    - Inserts transformed and standardized data from Bronze layer.
Parameters:
    None. 
    This stored procedure does not accept any parameters or return values.
Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/
exec Silver.load_silver
go
create or alter procedure Silver.load_silver as 
begin
   declare @start_time datetime, @end_time datetime, @start_whole_batch datetime, @end_whole_batch datetime 
   begin try 
	set @start_whole_batch = getdate();
		print'=====================';
		print 'Loading the Silver Layer';
		print '====================';

		print '----------------------';
		print'Loading the CRM tables';
		print '----------------------';

    set @start_time = getdate();
    print '>> Truncating Data'
    truncate table silver.crm_cust_inf 
    print '>>> Inserting Data'
    insert into silver.crm_cust_inf (
        cst_id, 
        cst_key, 
        cst_fname, 
        cst_lname, 
        cst_marital_status, 
        cst_gndr, 
        cst_create_date
    )
    select 
        cst_id,
        cst_key,
        trim(cst_fname),
        trim(cst_lname),
        case 
            when upper(trim(cst_marital_status)) = 's' then 'single'
            when upper(trim(cst_marital_status)) = 'm' then 'married'
            else 'n/a'
        end,
        case 
            when upper(trim(cst_gndr)) = 'f' then 'female'
            when upper(trim(cst_gndr)) = 'm' then 'male'
            else 'n/a'
        end,
        try_convert(date, cst_create_date)
    from (
        select *,
               row_number() over (
                   partition by cst_id
                   order by try_convert(date, cst_create_date) desc
               ) as flag_last
        from bronze.crm_cust_inf
        where cst_id is not null
    ) t
    where flag_last = 1;
    set @end_time = getdate();
	print '>> load duration ' + ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds'

    set @start_time = getdate();
    print '>> Truncating Data'
    truncate table Silver.crm_prd_info 
    print '>>> Inserting Data'
    insert into Silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
    )

    select prd_id,
    replace(SUBSTRING(prd_key, 1, 5 ), '-', '_') as cat_id,
    SUBSTRING(prd_key, 7, len(prd_key)) as prd_key ,
    prd_nm,
    isnull(prd_cost, 0) as prd_cost ,
    case when upper(trim(prd_line)) = 'M' then 'Mountain'
         when upper(trim(prd_line)) = 'R' then 'Road'
         when upper(trim(prd_line)) = 'S' then 'Other Sales'
         when upper(trim(prd_line)) = 'T' then 'Touring'
         else 'N/A'
    end prd_line, 
    prd_start_dt,
    dateadd(day, -1,lead(prd_start_dt) over (partition by prd_key order by prd_start_dt))  as prd_end_dt
    from Bronze.crm_prd_info ; 
    set @end_time = getdate();
	print '>> load duration ' + ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds'

    set @start_time = getdate();
    print '>>> Truncating Data'
    truncate table Silver.crm_sales_details
    print '>>> Inserting Data'
    insert into Silver.crm_sales_details(
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price

    )
    select
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    case when sls_order_dt = 0 or len(sls_order_dt) != 8  then null 
         else cast(cast(sls_order_dt as varchar) as date)
         end as sls_order_dt,
    case when sls_ship_dt = 0 or len(sls_ship_dt) != 8  then null 
         else cast(cast(sls_ship_dt as varchar) as date)
         end as sls_ship_dt,
    case when sls_due_dt = 0 or len(sls_due_dt) != 8  then null 
         else cast(cast(sls_due_dt as varchar) as date)
         end as sls_due_dt,
    case when sls_sales is null or sls_sales <= 0 or sls_sales = sls_quantity * abs(sls_price)
         then sls_quantity * abs(sls_price)
         else sls_sales 
         end as sls_sales,
    sls_quantity,
    case when sls_price <= 0 or sls_price is null 
         then sls_sales / nullif(sls_quantity, 0 ) 
         else sls_price
         end as sls_price
      from Bronze.crm_sales_details;
      set @end_time = getdate();
	  print '>> load duration ' + ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds'

    print '----------------------';
	print'Loading the ERP tables';
	print '----------------------';
    set @start_time = getdate();
    print '>> Truncating Data'
    truncate table Silver.erp_cust_az12
    print '>>> Inserting Data'
    insert into Silver.erp_cust_az12 (cid, bdate,gen)
    select 
    case when cid like 'NAS%' then SUBSTRING(cid, 4, len(cid) ) 
         else cid 
         end as cid , 
    case when bdate > getdate() then null 
         else bdate 
         end as bdate , 
    case when upper(trim(gen)) in ('F', 'Female') then 'Female'
         when upper(trim(gen)) in ('M', 'Male') then 'Male'
         else 'N/A' 
         end as gen 
    from Bronze.erp_cust_az12 ;
    set @end_time = getdate();
	print '>> load duration ' + ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds'

    set @start_time = getdate();
    print '>> Truncating Data'
    truncate table Silver.erp_loc_a101
    print '>>> Inserting Data'
    insert into Silver.erp_loc_a101(cid,cntry)
    select 
    REPLACE(cid, '-','') cid , 
    case when trim(cntry) = 'DE' then 'Germany'
         when trim(cntry) in ('US', 'USA') then 'United States'
         when trim(cntry) = '' or cntry is null then 'N/A'
         else trim(cntry)
    end as cntry 
    from Bronze.erp_loc_a101 ;
    set @end_time = getdate();
	print '>> load duration '+ ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds'

    set @start_time = getdate();
    print '>> Truncating Data'
    truncate table Silver.erp_px_cat_g1v2
    print '>>> Inserting Data'
    insert into Silver.erp_px_cat_g1v2 (
    id,
    cat,
    subcat,
    maintenance
    )
    select id,
    cat,
    subcat,
    maintenance 
    from Bronze.erp_px_cat_g1v2 ; 
    set @end_time = getdate();
		print '>> load duration ' + ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds'
		set @end_whole_batch = getdate();
		print '================'
		print 'Loading the whole batch is completed'
		print '>> load duration of the whole batch ' + ' ' + cast(datediff(second, @start_whole_batch, @end_whole_batch) as nvarchar ) + ' seconds'


	end try 
	begin catch 
	print '==================='
	print 'Error Message :' + error_message() ;
	print 'Error Message :' +cast (error_number() as nvarchar);
	print 'Error Message :' +cast (error_state() as nvarchar);
	print '===================' 
	end catch 
end 

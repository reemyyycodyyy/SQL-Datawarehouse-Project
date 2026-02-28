/*
===============================================================================
Stored Procedure: Load Data Into Bronze Layer (Source → Bronze)
===============================================================================
Script Purpose:
    This stored procedure is responsible for loading source data into the 'Bronze'
    schema from external CSV files using bulk data ingestion techniques.
    The procedure performs the following operations:
    - Prepares the Bronze layer tables for data loading.
    - Removes existing data to ensure clean ingestion.
    - Uses the `BULK INSERT` command to efficiently load data from CSV source files.

Key Features:
    - Ensures data consistency before data ingestion.
    - Supports high-performance batch loading.
    - Designed for raw data preservation in the Bronze layer.

Parameters:
    None.
Return Value:
    This procedure does not return any values.
Usage Example:
    EXEC Bronze.load_bronze;
===============================================================================
*/

exec Bronze.load_Bronze;
go 
create or alter procedure Bronze.load_Bronze as 
begin
    declare @start_time datetime, @end_time datetime, @start_whole_batch datetime, @end_whole_batch datetime 
	begin try 
	set @start_whole_batch = getdate();
		print'=====================';
		print 'Loading the Bronze Layer';
		print '====================';

		print '----------------------';
		print'Loading the CRM tables';
		print '----------------------';

		-- full load for the files in the Bronze layer :
		--Bronze.crm_cust_inf
		set @start_time = getdate();
		print '>> truncating the table:Bronze.crm_cust_inf';
		truncate table Bronze.crm_cust_inf;
		print '>> inserting data into Bronze.crm_cust_inf';
		bulk insert Bronze.crm_cust_inf
		from 'C:\SQL DataWarehouse Project\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with(
		   firstrow = 2, -- the 1st row is the columns name 
		   fieldterminator = ',',
		   tablock 
		);
		set @end_time = getdate();
		print '>> load duration ' + ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds'
	
		--Bronze.crm_prd_info
		set @start_time = getdate();
		print '>> truncating the table:Bronze.crm_prd_info';
		truncate table Bronze.crm_prd_info;
		print '>> inserting data into Bronze.crm_prd_info';
		bulk insert Bronze.crm_prd_info
		from 'C:\SQL DataWarehouse Project\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = getdate();
		print '>> load duration ' + ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds'
	

		-- Bronze.crm_sales_details
		set @start_time = getdate();
		print '>> truncating the table:Bronze.crm_sales_details';
		truncate table Bronze.crm_sales_details;
		print '>> inserting data into Bronze.crm_sales_details';
		bulk insert Bronze.crm_sales_details 
		from 'C:\SQL DataWarehouse Project\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = getdate();
		print '>> load duration ' + ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds'
	
		print '----------------------';
		print'Loading the ERP tables';
		print '----------------------';

		-- Bronze.erp_cust_az12
		set @start_time = getdate();
		print '>> truncating the table:Bronze.erp_cust_az12' ;
		truncate table Bronze.erp_cust_az12;
		print '>> inserting data into Bronze.erp_cust_az12 ';
		bulk insert Bronze.erp_cust_az12 
		from 'C:\SQL DataWarehouse Project\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = getdate();
		print '>> load duration ' + ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds'

		-- Bronze.erp_loc_a101:
		set @start_time = getdate();
		print '>> truncating the table:Bronze.erp_loc_a101' ;
		truncate table Bronze.erp_loc_a101;
		print '>> inserting data into Bronze.erp_loc_a101';
		bulk insert Bronze.erp_loc_a101
		from 'C:\SQL DataWarehouse Project\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print '>> load duration '+ ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds'
	

		-- Bronze.erp_px_cat_g1v2
		set @start_time = getdate();
		print '>> truncating the table:Bronze.erp_px_cat_g1v2' ;
		truncate table Bronze.erp_px_cat_g1v2;
		print '>> inserting data into Bronze.erp_px_cat_g1v2';
		bulk insert Bronze.erp_px_cat_g1v2
		from 'C:\SQL DataWarehouse Project\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
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

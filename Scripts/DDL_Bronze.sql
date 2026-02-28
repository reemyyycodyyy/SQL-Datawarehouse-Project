/*
===============================================================================
Data Warehouse ETL Script
===============================================================================
Script Purpose:
    This script contains ETL transformations and data processing logic for the
    Data Warehouse project.
    The script is responsible for preparing data across the warehouse layers
    including data cleansing, transformation, and analytical modeling.

Execution Instructions:
    - Run this script after loading source data into the staging/Bronze layer.
    - Ensure database connectivity is properly configured before execution.
    - Review dependencies between tables before running the script.

Notes:
    - Tables are created using controlled DDL operations.
    - Existing objects may be dropped and recreated when necessary.
    - Focus is placed on data quality and structural consistency.
===============================================================================
*/
if object_id('Bronze.crm_cust_inf', 'u') is not null 
	drop table Bronze.crm_cust_inf ; 

create table Bronze.crm_cust_inf(
	cst_id int,
	cst_key nvarchar(50),
	cst_fname nvarchar(50),
	cst_lname nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date 
) ; 


if object_id('Bronze.crm_prd_info', 'u') is not null 
	drop table Bronze.crm_prd_info ; 

create table Bronze.crm_prd_info(
prd_id int,
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost float,
prd_line nvarchar(50),
prd_start_dt date,
prd_end_dt date
);


if object_id('Bronze.crm_sales_details', 'u') is not null 
	drop table Bronze.crm_sales_details ; 

create table Bronze.crm_sales_details(
sls_ord_num nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id int,
sls_order_dt int,
sls_ship_dt int,
sls_due_dt int,
sls_sales int,
sls_quantity int,
sls_price int
);


if object_id('Bronze.erp_cust_az12', 'u') is not null 
	drop table Bronze.erp_cust_az12 ; 

create table Bronze.erp_cust_az12(
cid nvarchar(50),
bdate date,
gen nvarchar(50)
);


if object_id('Bronze.erp_loc_a101', 'u') is not null 
	drop table Bronze.erp_loc_a101 ; 

create table Bronze.erp_loc_a101(
cid nvarchar(50),
cntry nvarchar(50)
);


if object_id('Bronze.erp_px_cat_g1v2', 'u') is not null 
	drop table Bronze.erp_px_cat_g1v2 ; 

create table Bronze.erp_px_cat_g1v2(
id nvarchar(50),
cat nvarchar(50),
subcat nvarchar(50),
maintenance nvarchar(50)
);

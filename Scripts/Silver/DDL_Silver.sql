/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

if object_id('Silver.crm_cust_inf', 'u') is not null 
	drop table Silver.crm_cust_inf ; 

create table Silver.crm_cust_inf(
	cst_id int,
	cst_key nvarchar(50),
	cst_fname nvarchar(50),
	cst_lname nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date 
) ; 


if object_id('Silver.crm_prd_info', 'u') is not null 
	drop table Silver.crm_prd_info ; 

create table Silver.crm_prd_info(
prd_id int,
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost float,
prd_line nvarchar(50),
prd_start_dt date,
prd_end_dt date
);


if object_id('Silver.crm_sales_details', 'u') is not null 
	drop table Silver.crm_sales_details ; 

create table Silver.crm_sales_details(
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


if object_id('Silver.erp_cust_az12', 'u') is not null 
	drop table Silver.erp_cust_az12 ; 

create table Silver.erp_cust_az12(
cid nvarchar(50),
bdate date,
gen nvarchar(50)
);


if object_id('Silver.erp_loc_a101', 'u') is not null 
	drop table Silver.erp_loc_a101 ; 

create table Silver.erp_loc_a101(
cid nvarchar(50),
cntry nvarchar(50)
);


if object_id('Silver.erp_px_cat_g1v2', 'u') is not null 
	drop table Silver.erp_px_cat_g1v2 ; 

create table Silver.erp_px_cat_g1v2(
id nvarchar(50),
cat nvarchar(50),
subcat nvarchar(50),
maintenance nvarchar(50)
);

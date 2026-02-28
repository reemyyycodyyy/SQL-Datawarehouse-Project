/*
===============================================================================
DDL Script: Create Gold Layer Views
===============================================================================
Script Purpose:
    This script creates analytical views for the Gold layer in the data warehouse.
    The Gold layer represents the final business-ready data model following the
    Star Schema design, including dimension and fact structures.
    Each view combines and transforms data from the Silver layer to produce
    clean, enriched datasets suitable for reporting and analysis.
Usage:
    - These views are designed to be used directly for analytical queries and dashboards.
===============================================================================
*/
-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
create view Gold.dim_customers as 
	select
	ROW_NUMBER() over (order by cst_id) as Customer_Key,
		ci.cst_id as Customer_id,
		ci.cst_key as Customer_Number,
		ci.cst_fname as First_Name,
		ci.cst_lname as Last_Name,
		la.cntry as Country,
		case when ci.cst_gndr != 'N/A' then ci.cst_gndr
			 else coalesce(ca.gen, 'N/A')
		end as Gender,
		ci.cst_marital_status as Marital_Status,
		ca.bdate as Birthdate,
		ci.cst_create_date Create_Date
	from Silver.crm_cust_inf ci
	left join Silver.erp_cust_az12 ca 
	on ci.cst_key = ca.cid 
	left join Silver.erp_loc_a101 la
	on ci.cst_key = la.cid 

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
-- if the prd_end_dt is null then this is a current data 
create view Gold.dim_Products as 
select 
    ROW_NUMBER() over (order by prd_start_dt, prd_key) as Product_key, 
	prd_id as Product_id,
	prd_key as Product_Number,
	cat_id as Category_id,
	pc.cat as Category,
	pc.subcat as SubCategory,
	pc.maintenance as Maintenance,
	prd_nm as Product_Name,
	prd_cost as Product_Cost,
	prd_line as Product_Line,
	prd_start_dt as StartDate 
from Silver.crm_prd_info pn
left join Silver.erp_px_cat_g1v2 pc  
on pn.cat_id = pc.id 
where prd_end_dt is null ;

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
create view Gold.fact_sales as 
select 
	sls_ord_num as order_number,
	pr.Product_Key ,
	cu.Cusromer_Key,
	sls_sales as sales,
	sls_quantity as quantity,
	sls_price as price,
	sls_order_dt as order_date,
	sls_ship_dt as ship_date,
	sls_due_dt as due_date
from Silver.crm_sales_details sd
left join gold.dim_Products pr 
on sd.sls_prd_key = pr.Product_Number
left join gold.dim_customers cu
on sd.sls_cust_id = cu.Customer_id ; 

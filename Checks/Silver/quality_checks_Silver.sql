/*
===============================================================================
Quality Checks
===============================================================================
script purpose:
    this script performs data quality validation checks across the 'silver' layer
    to ensure consistency, accuracy, and standardization of warehouse data.
    the checks include:
    - detection of duplicate or null primary keys.
    - removal of unwanted leading or trailing spaces in text fields.
    - verification of data standardization rules.
    - validation of date ranges and logical date relationships.
    - consistency checking between related numerical fields.
usage notes:
    - run these checks after loading data into the silver layer.
    - review any returned records and resolve detected data issues.
===============================================================================
*/

-- ====================================================================
-- checking 'silver.crm_cust_info'
-- ====================================================================
select 
    cst_id,
    count(*) 
from silver.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null;

select 
    cst_key 
from silver.crm_cust_info
where cst_key != trim(cst_key);

select distinct 
    cst_marital_status 
from silver.crm_cust_info;

-- ====================================================================
-- checking 'silver.crm_prd_info'
-- ====================================================================

select 
    prd_id,
    count(*) 
from silver.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null;

select 
    prd_nm 
from silver.crm_prd_info
where prd_nm != trim(prd_nm);

select 
    prd_cost 
from silver.crm_prd_info
where prd_cost < 0 or prd_cost is null;

select distinct 
    prd_line 
from silver.crm_prd_info;

select 
    * 
from silver.crm_prd_info
where prd_end_dt < prd_start_dt;

-- ====================================================================
-- checking 'silver.crm_sales_details'
-- ====================================================================

select 
    nullif(sls_due_dt, 0) as sls_due_dt 
from bronze.crm_sales_details
where sls_due_dt <= 0 
    or length(sls_due_dt) != 8 
    or sls_due_dt > 20500101 
    or sls_due_dt < 19000101;

select 
    * 
from silver.crm_sales_details
where sls_order_dt > sls_ship_dt 
   or sls_order_dt > sls_due_dt;

select distinct 
    sls_sales,
    sls_quantity,
    sls_price 
from silver.crm_sales_details
where sls_sales != sls_quantity * sls_price
   or sls_sales is null 
   or sls_quantity is null 
   or sls_price is null
   or sls_sales <= 0 
   or sls_quantity <= 0 
   or sls_price <= 0
order by sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- checking 'silver.erp_cust_az12'
-- ====================================================================

select distinct 
    bdate 
from silver.erp_cust_az12
where bdate < '1924-01-01' 
   or bdate > getdate();

select distinct 
    gen 
from silver.erp_cust_az12;

-- ====================================================================
-- checking 'silver.erp_loc_a101'
-- ====================================================================

select distinct 
    cntry 
from silver.erp_loc_a101
order by cntry;

-- ====================================================================
-- checking 'silver.erp_px_cat_g1v2'
-- ====================================================================

select 
    * 
from silver.erp_px_cat_g1v2
where cat != trim(cat) 
   or subcat != trim(subcat) 
   or maintenance != trim(maintenance);

select distinct 
    maintenance 
from silver.erp_px_cat_g1v2;

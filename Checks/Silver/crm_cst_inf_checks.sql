select * from Bronze.crm_cust_inf ; 

-- check for nulls or duplicates in the primary key 
select cst_id,
count(*) from Bronze.crm_cust_inf
group by cst_id
having count(*) > 1 or cst_id is null ; 

-- check for unwanted spaces
-- expectations: no results 
select cst_fname from Bronze.crm_cust_inf 
where cst_fname != trim(cst_fname) ; -- if the original value is not equal to the value after trimming therefore there are spaces 

-- check for unwanted spaces 
select cst_lname from Bronze.crm_cust_inf 
where cst_lname != trim(cst_lname) ; 

-- check for unwanted spaces 
-- expectations: no spaces 
select cst_marital_status from Bronze.crm_cust_inf 
where cst_marital_status != trim(cst_marital_status) ; 

-- check for unwanted spaces 
-- expectations: no spaces 
select cst_gndr from Bronze.crm_cust_inf 
where cst_gndr != trim(cst_gndr) ; 

-- data standrilization & consistency 
select distinct cst_gndr from Bronze.crm_cust_inf ; 
select distinct cst_marital_status from Bronze.crm_cust_inf ; 

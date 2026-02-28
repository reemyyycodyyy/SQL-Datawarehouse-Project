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
        else 'N/A'
    end,
    case 
        when upper(trim(cst_gndr)) = 'f' then 'Female'
        when upper(trim(cst_gndr)) = 'm' then 'Male'
        else 'N/A'
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

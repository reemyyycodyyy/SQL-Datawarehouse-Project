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
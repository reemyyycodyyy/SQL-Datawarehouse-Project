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
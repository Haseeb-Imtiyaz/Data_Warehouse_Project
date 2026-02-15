-- Extract Poper cid fom cid
SELECT cid FROM bronze.erp_CUST_AZ12

-- Date Validation
SELECT bdate FROM bronze.erp_CUST_AZ12
where bdate > getdate() or bdate is null or bdate < '1900-01-01'

-- Data validatioin for Gender
SELECT DISTINCT gen
FROM bronze.erp_CUST_AZ12
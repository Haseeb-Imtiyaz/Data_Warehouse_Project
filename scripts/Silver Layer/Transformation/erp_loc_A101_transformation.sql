INSERT INTO silver.erp_LOC_A101(
cid,
cntry
)
SELECT 
REPLACE(cid,'-','') as cid,
CASE WHEN TRIM(cntry) ='DE' THEN 'Germany'
	 WHEN TRIM(cntry) =''  OR cntry IS NULL THEN 'n/a'
	 WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
	 ELSE TRIM(cntry)
END cntry
FROM bronze.erp_LOC_A101
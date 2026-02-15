INSERT INTO silver.erp_CUST_AZ12(
	cid,
	bdate,
	gen
)
SELECT
	CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
	     ELSE cid
	END cid,
	CASE WHEN bdate>GETDATE() THEN NULL
		 ELSE bdate
	END bdate,
	CASE WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
		 WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
		 ELSE 'n/a'
	END gen
FROM bronze.erp_CUST_AZ12

INSERT INTO silver.crm_prd_info(
	prd_id,
	prd_cat,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT
	prd_id,
	REPLACE(LEFT(prd_key,5),'-','_') AS prd_cat,
	SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost,
	CASE 
		WHEN TRIM(UPPER(prd_line)) = 'M' THEN 'Mountain'
		WHEN TRIM(UPPER(prd_line)) = 'R' THEN 'Road'
		WHEN TRIM(UPPER(prd_line)) = 'S' THEN 'Other Sales'
		WHEN TRIM(UPPER(prd_line)) = 'T' THEN 'Touring'
		ELSE 'n/a'
	END prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info;
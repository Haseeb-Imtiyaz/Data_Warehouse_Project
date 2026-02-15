-- Check duplicates and Nulls in Primary Key
SELECT 
	prd_id,
	COUNT(*) AS CNT
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)>1

-- Check Categories from prd_info that are not present in ERP_id

SELECT
	REPLACE(LEFT(prd_key,5),'-','_') AS prd_cat
FROM bronze.crm_prd_info
WHERE REPLACE(LEFT(prd_key,5),'-','_') NOT IN (SELECT DISTINCT id FROM bronze.erp_PX_CAT_G1V2)

-- Check Categories from prd_info that are not present in CRM_SALES
SELECT
	SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key
FROM bronze.crm_prd_info
WHERE SUBSTRING(prd_key,7,LEN(prd_key)) NOT IN (SELECT DISTINCT sls_prd_key FROM bronze.crm_sales_details)

-- Check for unwanted spaces in string columns

	-- prd_nm
SELECT 
	prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm!=TRIM(prd_nm)

-- Check cost = Null & in Neagative
SELECT 
	prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost<0

-- Data Standardisation & Validity in prd_line
SELECT 
	DISTINCT prd_line
FROM bronze.crm_prd_info

-- Date Validation
SELECT 
*
FROM bronze.crm_prd_info
WHERE prd_end_dt<prd_start_dt



--Quality Check for silver prd_info

-- Check duplicates and Nulls in Primary Key
SELECT 
	prd_id,
	COUNT(*) AS CNT
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)>1

-- Check Categories from prd_info that are not present in ERP_id

SELECT
	REPLACE(LEFT(prd_key,5),'-','_') AS prd_cat
FROM silver.crm_prd_info
WHERE REPLACE(LEFT(prd_key,5),'-','_') NOT IN (SELECT DISTINCT id FROM silver.erp_PX_CAT_G1V2)

-- Check Categories from prd_info that are not present in CRM_SALES
SELECT
	SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key
FROM silver.crm_prd_info
WHERE SUBSTRING(prd_key,7,LEN(prd_key)) NOT IN (SELECT DISTINCT sls_prd_key FROM silver.crm_sales_details)

-- Check for unwanted spaces in string columns

	-- prd_nm
SELECT 
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm!=TRIM(prd_nm)

-- Check cost = Null & in Neagative
SELECT 
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost<0

-- Data Standardisation & Validity in prd_line
SELECT 
	DISTINCT prd_line
FROM silver.crm_prd_info

-- Date Validation
SELECT 
*
FROM silver.crm_prd_info
WHERE prd_end_dt<prd_start_dt

select * from silver.crm_prd_info



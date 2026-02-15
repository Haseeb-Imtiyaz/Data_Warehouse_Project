-- Check for unwanted spaces
SELECT 
       [sls_ord_num]
FROM [DataWareHouse].[bronze].[crm_sales_details]
WHERE [sls_ord_num]!=TRIM([sls_ord_num])

-- Check for Data Validation
SELECT sls_prd_key
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)

-- Check for Data Validation
SELECT sls_cust_id
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)

-- Date Handling sls_order_dt
SELECT NULLIF(sls_order_dt,0)
FROM bronze.crm_sales_details
WHERE sls_order_dt>sls_ship_dt OR sls_order_dt>sls_due_dt OR sls_ship_dt>sls_due_dt OR sls_order_dt IS NULL 
OR sls_order_dt<=0 OR LEN(sls_order_dt)!=8 OR sls_order_dt>20501230 OR sls_order_dt<19901230

-- Date Handling [sls_ship_dt]
SELECT NULLIF([sls_ship_dt],0)
FROM bronze.crm_sales_details
WHERE [sls_ship_dt]<=0 OR LEN([sls_ship_dt])!=8 OR [sls_ship_dt]>20501230 OR [sls_ship_dt]<19901230

-- Data Validation for Sales , Ouantity & Price
SELECT 
       sls_sales,
       sls_quantity
      ,sls_price
FROM bronze.crm_sales_details
WHERE sls_sales IS NULL OR sls_sales <= 0 
OR sls_quantity IS NULL OR sls_quantity <= 0
OR sls_price IS NULL OR sls_price <= 0
OR sls_sales != sls_quantity * sls_price
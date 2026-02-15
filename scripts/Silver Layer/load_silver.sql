EXEC silver.load_silver;
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	BEGIN TRY
		DECLARE @st_time datetime, @end_time datetime, @batch_st_time datetime, @batch_end_time datetime
		SET @batch_st_time=GETDATE()
		PRINT '<<<<<<<<Loading Silver data>>>>>>>>>';
		PRINT 'LOADING CRM DATA..........................';


		PRINT '			---------Loading Cust_Info Data---------------';
		TRUNCATE TABLE silver.crm_cust_info
		SET @st_time=GETDATE()
		INSERT INTO silver.crm_cust_info(
		cst_id,cst_key,cst_firstname,cst_lastname,cst_gndr,cst_marital_status,cst_create_date
		)
		SELECT 
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE 
				WHEN TRIM(UPPER(cst_gndr))='M' THEN 'Male'
				WHEN TRIM(UPPER(cst_gndr))='F' THEN 'Female'
				ELSE 'n/a'
			END cst_gndr,
			CASE 
				WHEN TRIM(UPPER(cst_marital_status))='M' THEN 'Married'
				WHEN TRIM(UPPER(cst_marital_status))='S' THEN 'Single'
				ELSE 'n/a'
			END cst_marital_status,
			cst_create_date 
		FROM(
		SELECT 
			*, 
			ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS RN
		FROM bronze.crm_cust_info 
		WHERE cst_id IS NOT NULL)T
		WHERE RN=1
		SET @end_time=GETDATE()
		PRINT '******************************************'
		PRINT 'Loading Cust_Info Data Completed'
		PRINT 'Time Taken: ' + CAST(DATEDIFF(second,@st_time,@end_time) AS NVARCHAR(50)) + 'seconds'
		PRINT '******************************************'


		PRINT '			---------Loading Prd_Info Data---------------';
		TRUNCATE TABLE silver.crm_prd_info
		SET @st_time=GETDATE()
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
		SET @end_time=GETDATE()
		PRINT '******************************************'
		PRINT 'Loading Prd_Info Data Completed'
		PRINT 'Time Taken: ' + CAST(DATEDIFF(second,@st_time,@end_time) AS NVARCHAR(50)) + 'seconds'
		PRINT '******************************************'


		PRINT '			---------Loading crm_sales_details Data---------------';
		TRUNCATE TABLE silver.crm_sales_details
		SET @st_time=GETDATE()
		INSERT INTO silver.crm_sales_details(
		sls_ord_num ,
		sls_prd_key ,
		sls_cust_id ,
		sls_order_dt ,
		sls_ship_dt ,
		sls_due_dt ,
		sls_sales ,
		sls_quantity ,
		sls_price
		)
		SELECT 
			   [sls_ord_num]
			  ,[sls_prd_key]
			  ,[sls_cust_id],
			  CASE WHEN [sls_order_dt] = 0 OR LEN([sls_order_dt])!=8 THEN NULL
				   ELSE CAST(CAST([sls_order_dt] AS VARCHAR) AS DATE)
			  END [sls_order_dt],
			  CASE WHEN [sls_ship_dt] = 0 OR LEN([sls_ship_dt])!=8 THEN NULL
					ELSE CAST(CAST([sls_ship_dt] AS VARCHAR) AS DATE)
			  END [sls_ship_dt],
			  CASE WHEN [sls_due_dt] = 0 OR LEN([sls_due_dt])!=8 THEN NULL
					ELSE CAST(CAST([sls_due_dt] AS VARCHAR) AS DATE)
			  END [sls_due_dt],
			  CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales!= sls_quantity*ABS(sls_price) THEN sls_quantity*ABS(sls_price) 
				   ELSE sls_sales
			  END sls_sales
			  ,[sls_quantity]
			  ,CASE WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales/NULLIF(sls_quantity,0)
					ELSE sls_price
			   END sls_price
		FROM [DataWareHouse].[bronze].[crm_sales_details]
		SET @end_time=GETDATE()
		PRINT '******************************************'
		PRINT 'Loading crm_sales_details Data Completed'
		PRINT 'Time Taken: ' + CAST(DATEDIFF(second,@st_time,@end_time) AS NVARCHAR(50)) + 'seconds'
		PRINT '******************************************'

		PRINT 'LOADING ERP DATA..........................';


		PRINT '			---------Loading erp_CUST_AZ12 Data---------------';
		TRUNCATE TABLE silver.erp_CUST_AZ12
		SET @st_time=GETDATE()
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
		SET @end_time=GETDATE()
		PRINT '******************************************'
		PRINT 'Loading erp_CUST_AZ12 Data Completed'
		PRINT 'Time Taken: ' + CAST(DATEDIFF(second,@st_time,@end_time) AS NVARCHAR(50)) + 'seconds'
		PRINT '******************************************'

		
		PRINT '			---------Loading erp_LOC_A101 Data---------------';
		TRUNCATE TABLE silver.erp_LOC_A101
		SET @st_time=GETDATE()
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
		SET @end_time=GETDATE()
		PRINT '******************************************'
		PRINT 'Loading erp_LOC_A101 Data Completed'
		PRINT 'Time Taken: ' + CAST(DATEDIFF(second,@st_time,@end_time) AS NVARCHAR(50)) + 'seconds'
		PRINT '******************************************'

		PRINT '			---------Loading erp_PX_CAT_G1V2 Data---------------';
		TRUNCATE TABLE silver.erp_PX_CAT_G1V2
		SET @st_time=GETDATE()
		INSERT INTO silver.erp_PX_CAT_G1V2(
       [id]
      ,[cat]
      ,[subcat]
      ,[maintenance])
	   SELECT [id]
		  ,[cat]
		  ,[subcat]
		  ,[maintenance]
	   FROM [bronze].[erp_PX_CAT_G1V2]
	  	SET @end_time=GETDATE()
		PRINT '******************************************'
		PRINT 'Loading erp_PX_CAT_G1V2 Data Completed'
		PRINT 'Time Taken: ' + CAST(DATEDIFF(second,@st_time,@end_time) AS NVARCHAR(50)) + 'seconds'
		PRINT '******************************************'

		PRINT '------------->Silver Layer Loading Completed'
		SET @batch_end_time=GETDATE()
		PRINT 'Total Time Taken: ' + CAST(DATEDIFF(second,@batch_st_time,@batch_end_time) AS NVARCHAR(50)) + 'seconds'

	END TRY
	BEGIN CATCH
		PRINT '<<<<<FAILED TO LOAD Silver DATA>>>>>';
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER: '+ CAST(ERROR_NUMBER() AS NVARCHAR(50)) 
	END CATCH
END
	
-- Execute the Bronze load procedure
EXEC bronze.load_bronze;
GO

-- Create or update the Bronze layer loading procedure
CREATE OR ALTER PROCEDURE bronze.load_bronze 
AS
BEGIN
	BEGIN TRY

		/*====================================================
		  VARIABLE DECLARATION
		====================================================*/
		-- @st_time       : Start time for individual table load
		-- @end_time      : End time for individual table load
		-- @batch_st_time : Start time for full bronze batch
		-- @batch_end_time: End time for full bronze batch
		DECLARE @st_time datetime, 
		        @end_time datetime, 
		        @batch_st_time datetime, 
		        @batch_end_time datetime;

		/*====================================================
		  START CRM DATA LOAD
		====================================================*/
		PRINT '*********LOADING CRM DATA***********';

		-- Capture batch start time
		SET @batch_st_time = GETDATE();

		/*------------------------------
		  Load crm_cust_info
		------------------------------*/
		SET @st_time = GETDATE();

		-- Remove existing records before reload
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '-------------------------------------------------';
		PRINT 'LOADING: crm_cust_info TABLE';
		PRINT '-------------------------------------------------';

		-- Bulk load data from CSV file into table
		BULK INSERT bronze.crm_cust_info 
		FROM 'C:\Users\pumas\Desktop\Data Analysis Project\Data Warehousing\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,          -- Skip header row
			FIELDTERMINATOR = ',', -- CSV delimiter
			TABLOCK                -- Table-level lock for faster load
		);

		SET @end_time = GETDATE();

		-- Log completion and duration
		PRINT '-------------------------------------------------';
		PRINT 'COMPLETED LOADING: crm_cust_info TABLE';
		PRINT 'TIME TAKEN: ' + CAST(DATEDIFF(second,@st_time,@end_time) AS NVARCHAR(50)) + ' seconds';
		PRINT '-------------------------------------------------';


		/*------------------------------
		  Load crm_prd_info
		------------------------------*/
		SET @st_time = GETDATE();

		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '-------------------------------------------------';
		PRINT 'LOADING: crm_prd_info TABLE';
		PRINT '-------------------------------------------------';

		BULK INSERT bronze.crm_prd_info 
		FROM 'C:\Users\pumas\Desktop\Data Analysis Project\Data Warehousing\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();

		PRINT '-------------------------------------------------';
		PRINT 'COMPLETED LOADING: crm_prd_info TABLE';
		PRINT 'TIME TAKEN: ' + CAST(DATEDIFF(second,@st_time,@end_time) AS NVARCHAR(50)) + ' seconds';
		PRINT '-------------------------------------------------';


		/*------------------------------
		  Load crm_sales_details
		------------------------------*/
		SET @st_time = GETDATE();

		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '-------------------------------------------------';
		PRINT 'LOADING: crm_sales_details TABLE';
		PRINT '-------------------------------------------------';

		BULK INSERT bronze.crm_sales_details 
		FROM 'C:\Users\pumas\Desktop\Data Analysis Project\Data Warehousing\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();

		PRINT '-------------------------------------------------';
		PRINT 'COMPLETED LOADING: crm_sales_details TABLE';
		PRINT 'TIME TAKEN: ' + CAST(DATEDIFF(second,@st_time,@end_time) AS NVARCHAR(50)) + ' seconds';
		PRINT '-------------------------------------------------';

		PRINT '*********COMPLETED LOADING CRM DATA***********';


		/*====================================================
		  START ERP DATA LOAD
		====================================================*/
		PRINT '++++++++++LOADING ERP DATA++++++++++';

		/*------------------------------
		  Load erp_CUST_AZ12
		------------------------------*/
		SET @st_time = GETDATE();

		TRUNCATE TABLE bronze.erp_CUST_AZ12;

		PRINT '-------------------------------------------------';
		PRINT 'LOADING: erp_CUST_AZ12 TABLE';
		PRINT '-------------------------------------------------';

		BULK INSERT bronze.erp_CUST_AZ12 
		FROM 'C:\Users\pumas\Desktop\Data Analysis Project\Data Warehousing\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();

		PRINT '-------------------------------------------------';
		PRINT 'COMPLETED LOADING: erp_CUST_AZ12 TABLE';
		PRINT 'TIME TAKEN: ' + CAST(DATEDIFF(second,@st_time,@end_time) AS NVARCHAR(50)) + ' seconds';
		PRINT '-------------------------------------------------';


		/*------------------------------
		  Load erp_LOC_A101
		------------------------------*/
		SET @st_time = GETDATE();

		TRUNCATE TABLE bronze.erp_LOC_A101;

		PRINT '-------------------------------------------------';
		PRINT 'LOADING: erp_LOC_A101 TABLE';
		PRINT '-------------------------------------------------';

		BULK INSERT bronze.erp_LOC_A101 
		FROM 'C:\Users\pumas\Desktop\Data Analysis Project\Data Warehousing\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();

		PRINT '-------------------------------------------------';
		PRINT 'COMPLETED LOADING: erp_LOC_A101 TABLE';
		PRINT 'TIME TAKEN: ' + CAST(DATEDIFF(second,@st_time,@end_time) AS NVARCHAR(50)) + ' seconds';
		PRINT '-------------------------------------------------';


		/*------------------------------
		  Load erp_PX_CAT_G1V2
		------------------------------*/
		SET @st_time = GETDATE();

		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;

		PRINT '-------------------------------------------------';
		PRINT 'LOADING: erp_PX_CAT_G1V2 TABLE';
		PRINT '-------------------------------------------------';

		BULK INSERT bronze.erp_PX_CAT_G1V2 
		FROM 'C:\Users\pumas\Desktop\Data Analysis Project\Data Warehousing\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		SET @batch_end_time = GETDATE();

		PRINT '-------------------------------------------------';
		PRINT 'COMPLETED LOADING: erp_PX_CAT_G1V2 TABLE';
		PRINT 'TIME TAKEN: ' + CAST(DATEDIFF(second,@st_time,@end_time) AS NVARCHAR(50)) + ' seconds';
		PRINT '-------------------------------------------------';

		PRINT '++++++++++COMPLETED LOADING ERP DATA++++++++++';

		-- Log total batch duration
		PRINT '---->TOTAL TIME FOR LOADING BRONZE LAYER: ' 
		      + CAST(DATEDIFF(second,@batch_st_time,@batch_end_time) AS NVARCHAR(50)) 
		      + ' seconds';

	END TRY

	/*====================================================
	  ERROR HANDLING
	====================================================*/
	BEGIN CATCH
		PRINT '<<<<<FAILED TO LOAD BRONZE DATA>>>>>';
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR(50));
	END CATCH
END;
GO

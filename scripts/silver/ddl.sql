-- Use the target database
USE DataWareHouse;
GO

/*====================================================
  CRM CUSTOMER INFORMATION TABLE (BRONZE LAYER)
====================================================*/

-- Drop table if it already exists (makes script re-runnable)
IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
GO

-- Create CRM Customer Information table
CREATE TABLE bronze.crm_cust_info(
	cst_id int,                     -- Customer unique identifier
	cst_key nvarchar(50),           -- Business/customer key from source system
	cst_firstname nvarchar(50),     -- Customer first name
	cst_lastname nvarchar(50),      -- Customer last name
	cst_marital_status nvarchar(50),-- Marital status of customer
	cst_gndr char(1),               -- Gender (M/F)
	cst_create_date date            -- Record creation date
);
GO


/*====================================================
  CRM PRODUCT INFORMATION TABLE (BRONZE LAYER)
====================================================*/

-- Drop table if it already exists
IF OBJECT_ID('bronze.crm_prd_info','U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
GO

-- Create CRM Product Information table
CREATE TABLE bronze.crm_prd_info(
	prd_id int,                     -- Product unique identifier
	prd_key nvarchar(50),           -- Business/product key from source system
	prd_nm nvarchar(50),            -- Product name
	prd_cost int,                   -- Product cost
	prd_line nvarchar(50),          -- Product line/category
	prd_start_dt datetime,          -- Product availability start date
	prd_end_dt datetime             -- Product availability end date
);
GO


/*====================================================
  CRM SALES DETAILS TABLE (BRONZE LAYER)
====================================================*/

-- Drop table if it already exists
IF OBJECT_ID('bronze.crm_sales_details','U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
GO

-- Create CRM Sales Details table
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num nvarchar(50),   -- Sales order number
	sls_prd_key nvarchar(50),   -- Product key (references product)
	sls_cust_id int,            -- Customer ID (references customer)
	sls_order_dt int,           -- Order date (stored as integer, likely YYYYMMDD)
	sls_ship_dt int,            -- Shipping date (stored as integer)
	sls_due_dt int,             -- Due date (stored as integer)
	sls_sales int,              -- Total sales amount
	sls_quantity int,           -- Quantity sold
	sls_price int               -- Price per unit
);
GO


/*====================================================
  ERP CUSTOMER ADDITIONAL DATA TABLE (BRONZE LAYER)
====================================================*/

-- Drop table if it already exists
IF OBJECT_ID('bronze.erp_CUST_AZ12','U') IS NOT NULL
	DROP TABLE bronze.erp_CUST_AZ12;
GO

-- Create ERP Customer Additional Info table
CREATE TABLE bronze.erp_CUST_AZ12(
	cid nvarchar(50),    -- Customer ID (from ERP system)
	bdate date,          -- Birth date
	gen nvarchar(10)     -- Gender description
);
GO


/*====================================================
  ERP CUSTOMER LOCATION TABLE (BRONZE LAYER)
====================================================*/

-- Drop table if it already exists
IF OBJECT_ID('bronze.erp_LOC_A101','U') IS NOT NULL
	DROP TABLE bronze.erp_LOC_A101;
GO

-- Create ERP Customer Location table
CREATE TABLE bronze.erp_LOC_A101(
	cid nvarchar(50),    -- Customer ID (from ERP system)
	cntry nvarchar(50)   -- Country of customer
);
GO


/*====================================================
  ERP PRODUCT CATEGORY TABLE (BRONZE LAYER)
====================================================*/

-- Drop table if it already exists
IF OBJECT_ID('bronze.erp_PX_CAT_G1V2','U') IS NOT NULL
	DROP TABLE bronze.erp_PX_CAT_G1V2;
GO

-- Create ERP Product Category table
CREATE TABLE bronze.erp_PX_CAT_G1V2(
	id nvarchar(50),         -- Product ID
	cat nvarchar(50),        -- Product category
	subcat nvarchar(50),     -- Product subcategory
	maintenance nvarchar(50) -- Maintenance type/category
);
GO

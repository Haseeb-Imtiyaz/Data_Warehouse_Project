use DataWareHouse;

IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info
CREATE TABLE bronze.crm_cust_info(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr char(1),
	cst_create_date date
)

IF OBJECT_ID('bronze.crm_prd_info','U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info
CREATE TABLE bronze.crm_prd_info(
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt datetime,
	prd_end_dt datetime
)

IF OBJECT_ID('bronze.crm_sales_details','U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int
)

IF OBJECT_ID('bronze.erp_CUST_AZ12','U') IS NOT NULL
	DROP TABLE bronze.erp_CUST_AZ12
CREATE TABLE bronze.erp_CUST_AZ12(
	cid nvarchar(50),
	bdate date,
	gen nvarchar(10)
)

IF OBJECT_ID('bronze.erp_LOC_A101','U') IS NOT NULL
	DROP TABLE bronze.erp_LOC_A101
CREATE TABLE bronze.erp_LOC_A101(
	cid nvarchar(50),
	cntry nvarchar(50)
)

IF OBJECT_ID('bronze.erp_PX_CAT_G1V2','U') IS NOT NULL
	DROP TABLE bronze.erp_PX_CAT_G1V2
CREATE TABLE bronze.erp_PX_CAT_G1V2(
	id nvarchar(50),
	cat nvarchar(50),
	subcat nvarchar(50),
	maintenance nvarchar(50)
)
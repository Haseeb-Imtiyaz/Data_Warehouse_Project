CREATE VIEW gold.dim_customers AS
    SELECT 
         ROW_NUMBER() OVER (ORDER BY cst_id) AS Customer_Key,
         cst_id AS Customer_id
        ,ci.cst_key AS Customer_Number
        ,ci.cst_firstname AS First_Name
        ,ci.cst_lastname AS Last_name,
         cl.cntry AS Country,
        CASE WHEN ci.cst_gndr !='n/a' THEN ci.cst_gndr
             ELSE COALESCE(ca.gen,'n/a')
        END Gender
        ,ca.bdate AS Birth_Date
        ,ci.cst_marital_status AS Marital_Status
        ,ci.cst_create_date AS Create_Date   
    FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_CUST_AZ12 ca
    ON ca.cid=ci.cst_key
    LEFT JOIN silver.erp_LOC_A101 cl
    ON cl.cid=ci.cst_key
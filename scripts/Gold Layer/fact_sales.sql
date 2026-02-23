CREATE VIEW gold.fact_sales AS
    SELECT [sls_ord_num] as Order_Number
          ,dp.Product_Key
          ,dc.Customer_Key
          ,[sls_order_dt] as Order_Date
          ,[sls_ship_dt] AS Ship_Date
          ,[sls_due_dt] AS Due_Date
          ,[sls_sales] AS Sales
          ,[sls_quantity] As Quantity
          ,[sls_price] as Price
    FROM [silver].[crm_sales_details] sd
    LEFT JOIN gold.dim_customers dc
    ON dc.customer_id=sd.sls_cust_id
    LEFT JOIN gold.dim_products dp
    ON sd.sls_prd_key=dp.Product_number
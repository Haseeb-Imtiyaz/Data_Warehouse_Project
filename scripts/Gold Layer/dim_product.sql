CREATE VIEW gold.dim_products AS
    SELECT 
           ROW_NUMBER() OVER (ORDER BY prd_start_dt,prd_key) as Product_Key,
           [prd_id] AS Product_id
          ,pdi.[prd_cat] AS Category_ID
          ,pc.[cat] AS Category
          ,pc.[subcat] AS Subcatgory
          ,pdi.[prd_key] AS Product_number
          ,pdi.[prd_nm] AS Product_Name
          ,pdi.[prd_line] AS Product_Line
          ,pc.[maintenance] as maintenance
          ,pdi.[prd_cost] AS Cost
          ,pdi.[prd_start_dt] AS Product_Start_Date
    FROM silver.crm_prd_info pdi
    LEFT JOIN bronze.erp_PX_CAT_G1V2 pc
    ON pdi.prd_cat=pc.id
    WHERE pdi.[prd_end_dt] IS NULL

USE DataWarehouse;

-- !Data Integration
SELECT
    ci.cst_id             ,
    ci.cst_key           ,
    ci.cst_firstname     ,
    ci.cst_lastname      ,
    ci.cst_marital_status,
    CASE  
        WHEN ci.cst_gndr!='n/a' THEN ci.cst_gndr   -- CRM is the Master for gender info
        ELSE  COALESCE(ca.gen,'N/A')
    END as new_gen,
    ci.cst_create_date,
    ca.bdate,
    la.cntry
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca 
ON ci.cst_key=ca.cid 
LEFT JOIN silver.erp_loc_a101 la
on ci.cst_key=la.cid


SELECT DISTINCT
    ci.cst_gndr ,
    ca.gen,
    CASE  
        WHEN ci.cst_gndr!='n/a' THEN ci.cst_gndr   -- CRM is the Master for gender info
        ELSE  COALESCE(ca.gen,'N/A')
    END as new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca 
ON ci.cst_key=ca.cid 
LEFT JOIN silver.erp_loc_a101 la
on ci.cst_key=la.cid

-- ? name column  in friendly way and order properly

SELECT
    -- SURROGATE KEY
    ROW_NUMBER() OVER (ORDER BY cst_id) as CUSTOMER_KEY,
    ci.cst_id AS CUSTOMER_ID            ,
    ci.cst_key AS CUSTOMER_NAME          ,
    ci.cst_firstname AS FIRST_NAME    ,
    ci.cst_lastname   AS LAST_NAME   ,
    ci.cst_marital_status AS MARITAL_STATUS,
    CASE  
        WHEN ci.cst_gndr!='n/a' THEN ci.cst_gndr   -- CRM is the Master for gender info
        ELSE  COALESCE(ca.gen,'N/A')
    END as GENDER,
    ci.cst_create_date AS CREATE_DATE,
    ca.bdate AS BIRTHDATE,
    la.cntry AS COUNTRY 
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca 
ON ci.cst_key=ca.cid 
LEFT JOIN silver.erp_loc_a101 la
on ci.cst_key=la.cid



-- ! CREATE VIEW
CREATE VIEW gold.dim_customers as 
SELECT
    -- SURROGATE KEY
    ROW_NUMBER() OVER (ORDER BY cst_id) as CUSTOMER_KEY,
    ci.cst_id AS CUSTOMER_ID            ,
    ci.cst_key AS CUSTOMER_NAME          ,
    ci.cst_firstname AS FIRST_NAME    ,
    ci.cst_lastname   AS LAST_NAME   ,
    ci.cst_marital_status AS MARITAL_STATUS,
    CASE  
        WHEN ci.cst_gndr!='n/a' THEN ci.cst_gndr   -- CRM is the Master for gender info
        ELSE  COALESCE(ca.gen,'N/A')
    END as GENDER,
    ci.cst_create_date AS CREATE_DATE,
    ca.bdate AS BIRTHDATE,
    la.cntry AS COUNTRY 
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca 
ON ci.cst_key=ca.cid 
LEFT JOIN silver.erp_loc_a101 la
on ci.cst_key=la.cid









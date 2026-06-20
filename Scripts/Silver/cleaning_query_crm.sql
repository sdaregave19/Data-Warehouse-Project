USE DataWarehouse;

-- !  ****************************************************************
-- ! table->crm_cust_info

SELECT
    cst_id,
    COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 or cst_id is NULL;

SELECT *
FROM bronze.crm_cust_info
WHERE cst_id=29466;

SELECT *
FROM(
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
    FROM bronze.crm_cust_info
) as t
WHERE flag_last=1;

SELECT *
FROM(
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
    FROM bronze.crm_cust_info
) as t
WHERE flag_last=1;


-- ? check for unwanted spaces
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname!=TRIM(cst_firstname)



SELECT
    cst_id,
    cst_key ,
    TRIM(cst_firstname) AS cst_first_name ,
    TRIM(cst_lastname) AS cst_lastname ,
    cst_marital_status ,
    cst_gndr ,
    cst_create_date
FROM(
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) as t
WHERE flag_last=1;



-- ? Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info

-- ** making F and M meaning full means full form

SELECT
    cst_id,
    cst_key ,
    TRIM(cst_firstname) AS cst_first_name ,
    TRIM(cst_lastname) AS cst_lastname ,
    CASE 
    WHEN UPPER(TRIM(cst_marital_status ))='M' THEN 'MARRIED' 
    WHEN UPPER(TRIM(cst_marital_status ))='S' THEN 'SINGLE' 
    ELSE  'n/a'
END cst_marital_status ,
    CASE 
    WHEN UPPER(TRIM(cst_gndr))='M' THEN 'MALE' 
    WHEN UPPER(TRIM(cst_gndr))='F' THEN 'FEMALE' 
    ELSE  'n/a'
END cst_gndr,
    cst_create_date
FROM(
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) as t
WHERE flag_last=1;


-- !NOW insert into table
INSERT INTO silver.crm_cust_info
    (
    cst_id ,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date )
SELECT
    cst_id,
    cst_key ,
    TRIM(cst_firstname) AS cst_first_name ,
    TRIM(cst_lastname) AS cst_lastname ,
    CASE 
    WHEN UPPER(TRIM(cst_marital_status ))='M' THEN 'MARRIED' 
    WHEN UPPER(TRIM(cst_marital_status ))='S' THEN 'SINGLE' 
    ELSE  'n/a'
END cst_marital_status ,
    CASE 
    WHEN UPPER(TRIM(cst_gndr))='M' THEN 'MALE' 
    WHEN UPPER(TRIM(cst_gndr))='F' THEN 'FEMALE' 
    ELSE  'n/a'
END cst_gndr,
    cst_create_date
FROM(
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) as t
WHERE flag_last=1;
--* select the most recent record per customer

SELECT *
FROM silver.crm_cust_info;

-- !  ****************************************************************
-- ! table->crm_prd_info
SELECT *
from bronze.crm_prd_info;

-- *check for nulls or duplicates in PK
SELECT
    prd_id,
    COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)>1 or prd_id is NULL;

SELECT
    prd_id ,
    prd_key ,
    REPLACE(SUBSTRING(prd_key,1,5),'-','_' )AS cat_id, --done this so we can join with other table pk
    SUBSTRING(prd_key,7,LEN(prd_key) )AS prd_key,
    prd_nm ,
    prd_cost ,
    prd_line ,
    prd_start_dt ,
    prd_end_dt
FROM bronze.crm_prd_info


-- ? check for unwanted spaces
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm!=TRIM(prd_nm)

-- ? xheck for NULL or -ve number
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost is NULL OR prd_cost <0;

-- we got 2 null value so replace it with 0 using ISNULL()
SELECT
    prd_id ,
    prd_key ,
    REPLACE(SUBSTRING(prd_key,1,5),'-','_' )AS cat_id, --done this so we can join with other table pk
    SUBSTRING(prd_key,7,LEN(prd_key) )AS prd_key,
    prd_nm ,
    ISNULL(prd_cost,0) AS prd_cost ,
    prd_line ,
    prd_start_dt ,
    prd_end_dt
FROM bronze.crm_prd_info

-- ?Data standardization & consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;


SELECT
    prd_id ,
    prd_key ,
    REPLACE(SUBSTRING(prd_key,1,5),'-','_' )AS cat_id, --done this so we can join with other table pk
    SUBSTRING(prd_key,7,LEN(prd_key) )AS prd_key,
    prd_nm ,
    ISNULL(prd_cost,0) AS prd_cost ,
    CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road' 
        WHEN 'S' THEN 'Other Sales' 
        WHEN 'T' THEN 'Touring'   
        ELSE  'n/a'
    END as prd_line,
    prd_start_dt ,
    prd_end_dt
FROM bronze.crm_prd_info


-- ? Check for invalid date order
SELECT *
from bronze.crm_prd_info
WHERE prd_end_dt<prd_start_dt
-- end date must NOT be earlier

-- LEAD()-> s a window function that returns the value from the next row without using a self-join.

SELECT
    prd_id ,
    prd_key ,
    REPLACE(SUBSTRING(prd_key,1,5),'-','_' )AS cat_id, --done this so we can join with other table pk
    SUBSTRING(prd_key,7,LEN(prd_key) )AS prd_key,
    prd_nm ,
    ISNULL(prd_cost,0) AS prd_cost ,
    CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road' 
        WHEN 'S' THEN 'Other Sales' 
        WHEN 'T' THEN 'Touring'   
        ELSE  'n/a'
    END as prd_line,
    CAST(prd_start_dt AS DATE) AS prd_start_dt,
    CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info


SELECT *
FROM silver.crm_prd_info

-- ? now insert the data
INSERT INTO silver.crm_prd_info
    (
    prd_id ,
    cat_id ,
    prd_key ,
    prd_nm ,
    prd_cost ,
    prd_line ,
    prd_start_dt ,
    prd_end_dt
    )
SELECT
    prd_id ,
    REPLACE(SUBSTRING(prd_key,1,5),'-','_' )AS cat_id, --done this so we can join with other table pk
    SUBSTRING(prd_key,7,LEN(prd_key) )AS prd_key,
    prd_nm ,
    ISNULL(prd_cost,0) AS prd_cost ,
    CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road' 
        WHEN 'S' THEN 'Other Sales' 
        WHEN 'T' THEN 'Touring'   
        ELSE  'n/a'
    END as prd_line,
    CAST(prd_start_dt AS DATE) AS prd_start_dt,
    CAST(
        LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 
        AS DATE
    ) AS prd_end_dt -- Calculate end date as one day befor the next star date
FROM bronze.crm_prd_info



-- !  ****************************************************************
-- ! table->crm_sales_deatils

SELECT * from bronze.crm_sales_details

--* for column 2 and 3 
SELECT sls_prd_key
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)

SELECT sls_cust_id
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)

-- ? Check for invalid dates

SELECT 
NULLIF(sls_order_dt,0) sls_order_dt                              
FROM bronze.crm_sales_details
WHERE sls_order_dt <=0 OR LEN(sls_order_dt)!= 8

SELECT
    sls_ord_num     ,
    sls_prd_key     ,
    sls_cust_id     ,
    CASE 
        WHEN sls_order_dt = 0 OR LEN(sls_order_dt)!=8 THEN NULL  
        ELSE  CAST(CAST(sls_order_dt AS varchar) as date)
    END as sls_order_dt,
    CASE 
        WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt)!=8 THEN NULL  
        ELSE  CAST(CAST(sls_ship_dt AS varchar) as date)
    END as sls_ship_dt,
    CASE 
        WHEN sls_due_dt = 0 OR LEN(sls_due_dt)!=8 THEN NULL  
        ELSE  CAST(CAST(sls_due_dt AS varchar) as date)
    END as sls_due_dt,
    sls_sales       ,
    sls_quantity    ,
    sls_price       
from bronze.crm_sales_details


-- ? Check for invalid dates order
SELECT * FROM bronze.crm_sales_details
WHERE sls_order_dt>sls_ship_dt OR sls_order_dt>sls_due_dt


/* bsiness rule :-
sales = quantity * price
-ve ,0 , null are not allowed
*/

SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,
CASE 
    WHEN sls_sales is NULL or sls_sales <= 0 or sls_sales != sls_quantity* ABS(sls_price)  THEN  sls_quantity * ABS(sls_price)
    ELSE  sls_sales
END as sls_sales,

CASE 
    WHEN sls_price is NULL or sls_price <= 0 THEN  sls_sales / NULLIF(sls_quantity,0)
    ELSE  sls_price
END as sls_price
from bronze.crm_sales_details
WHERE sls_sales != sls_quantity*sls_price
or sls_sales is NULL or sls_quantity <=0 or sls_price<=0
ORDER BY sls_sales , sls_quantity,sls_price  -- sales and price is not proper

-- combine to main query
INSERT into silver.crm_sales_details(
    sls_ord_num     ,
    sls_prd_key     ,
    sls_cust_id     ,
    sls_order_dt    ,
    sls_ship_dt     ,
    sls_due_dt      ,
    sls_sales       ,
    sls_quantity    ,
    sls_price 
)
SELECT
    sls_ord_num     ,
    sls_prd_key     ,
    sls_cust_id     ,
    CASE 
        WHEN sls_order_dt = 0 OR LEN(sls_order_dt)!=8 THEN NULL  
        ELSE  CAST(CAST(sls_order_dt AS varchar) as date)
    END as sls_order_dt,
    CASE 
        WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt)!=8 THEN NULL  
        ELSE  CAST(CAST(sls_ship_dt AS varchar) as date)
    END as sls_ship_dt,
    CASE 
        WHEN sls_due_dt = 0 OR LEN(sls_due_dt)!=8 THEN NULL  
        ELSE  CAST(CAST(sls_due_dt AS varchar) as date)
    END as sls_due_dt,
    CASE 
        WHEN sls_sales is NULL or sls_sales <= 0 or sls_sales != sls_quantity* ABS(sls_price)  THEN  sls_quantity * ABS(sls_price)
        ELSE  sls_sales
    END as sls_sales,
    sls_quantity    ,
    CASE 
        WHEN sls_price is NULL or sls_price <= 0 THEN  sls_sales / NULLIF(sls_quantity,0)
        ELSE  sls_price
    END as sls_price
    
from bronze.crm_sales_details

SELECT * FROM silver.crm_sales_details




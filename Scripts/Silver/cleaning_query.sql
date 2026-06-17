USE DataWarehouse;

-- !  ****************************************************************
-- ? table->crm_cust_info

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


-- ! check for unwanted spaces
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

    

-- ! Data Standardization & Consistency
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
INSERT INTO silver.crm_cust_info(
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

SELECT * FROM silver.crm_cust_info;

-- !  ****************************************************************
-- ? table->crm_prd_info

SELECT 
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)>1 or prd_id is NULL;

SELECT * from bronze.crm_prd_info;
USE DataWarehouse;

-- !  ****************************************************************
-- ! table->erp_cust_az12

SELECT 
CASE 
    WHEN cid like 'NAS%' THEN  SUBSTRING(cid,4,LEN(cid))
    ELSE  cid
END  as scid,
bdate,
gen
from bronze.erp_cust_az12

--? Identifying Out of range Dtes 

SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate< '1924-01-01' or bdate > GETDATE()


SELECT 
CASE 
    WHEN cid like 'NAS%' THEN  SUBSTRING(cid,4,LEN(cid))
    ELSE  cid
END  as scid,
CASE 
    WHEN bdate > GETDATE() THEN  NULL
    ELSE  bdate
END as bdate,
gen
from bronze.erp_cust_az12

-- ? data Standardization and Consistency
SELECT DISTINCT
gen,
CASE 
    WHEN gen is NULL or gen =' '  THEN 'n/a'
    when gen='F' then 'Female' 
    when gen='M' then 'Male' 
    ELSE  gen
END as gen_new
FROM bronze.erp_cust_az12

SELECT 
CASE 
    WHEN cid like 'NAS%' THEN  SUBSTRING(cid,4,LEN(cid))
    ELSE  cid
END  as scid,
CASE 
    WHEN bdate > GETDATE() THEN  NULL
    ELSE  bdate
END as bdate,
CASE 
    WHEN UPPER(trim(gen)) is NULL or gen =' '  THEN 'n/a'
    when UPPER(trim(gen))='F' then 'Female' 
    when UPPER(trim(gen))='M' then 'Male' 
    ELSE  gen
END as gen
from bronze.erp_cust_az12

--? now insert into silver

INSERT into silver.erp_cust_az12(
    cid,
    bdate,
    gen
)SELECT 
CASE 
    WHEN cid like 'NAS%' THEN  SUBSTRING(cid,4,LEN(cid))
    ELSE  cid
END  as scid,
CASE 
    WHEN bdate > GETDATE() THEN  NULL
    ELSE  bdate
END as bdate,
CASE 
    WHEN UPPER(trim(gen)) is NULL or gen =' '  THEN 'n/a'
    when UPPER(trim(gen))='F' then 'Female' 
    when UPPER(trim(gen))='M' then 'Male' 
    ELSE  gen
END as gen
from bronze.erp_cust_az12


SELECT * from silver.erp_cust_az12

-- !  ****************************************************************
-- ! table->erp_loc_a101
SELECT 
REPLACE(cid,'-','') as cid ,
cntry
FROM bronze.erp_loc_a101

SELECT * from silver.crm_cust_info



-- !  ****************************************************************
-- ! table->erp_loc_a101
SELECT *
FROM bronze.erp_px_cat_g1v2

SELECT * from silver.crm_prd_info
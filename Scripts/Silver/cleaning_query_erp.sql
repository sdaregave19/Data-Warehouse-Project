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
CASE 
    WHEN TRIM(cntry)='DE' THEN 'Germany'
    when TRIM(cntry) in ('US','USA') then 'United States'
    when TRIM(cntry) = '' OR cntry is NULL then 'n/a'  
    ELSE  TRIM(cntry)
END as cntry
FROM bronze.erp_loc_a101

SELECT DISTINCT cntry
from bronze.erp_loc_a101

-- insert into silver
INSERT into silver.erp_loc_a101(
    cid  ,
    cntry
)SELECT 
REPLACE(cid,'-','') as cid ,
CASE 
    WHEN TRIM(cntry)='DE' THEN 'Germany'
    when TRIM(cntry) in ('US','USA') then 'United States'
    when TRIM(cntry) = '' OR cntry is NULL then 'n/a'  
    ELSE  TRIM(cntry)
END as cntry
FROM bronze.erp_loc_a101



-- !  ****************************************************************
-- ! table->erp_loc_a101
SELECT *
FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT cat_id from silver.crm_prd_info
-- loading to silver as all clear

insert into silver.erp_px_cat_g1v2(
    id,
    cat,
    subcat,
    maintenance
)SELECT *
FROM bronze.erp_px_cat_g1v2


SELECT * from silver.erp_px_cat_g1v2
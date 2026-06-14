-- BULK INSERT
USE DataWarehouse;

TRUNCATE TABLE bronze.crm_cust_info

BULK INSERT bronze.crm_cust_info
FROM 'E:\code\PROJECTS\Data-Warehouse-Project\Dataset\source_crm\cust_info.csv'
WITH (
    firstrow=2,
    FIELDTERMINATOR=',',
    TABLOCK
)

SELECT  COUNT(*) FROM bronze.crm_cust_info;

-- ! not loading
BULK INSERT bronze.crm_prd_info
FROM 'E:\code\PROJECTS\Data-Warehouse-Project\Dataset\source_crm\prd_info'
WITH (
    firstrow=2,
    FIELDTERMINATOR=',',
    TABLOCK
)

-- ! not loading
BULK INSERT bronze.crm_sales_details
FROM 'E:\code\PROJECTS\Data-Warehouse-Project\Dataset\source_crm\sales_details'
WITH (
    firstrow=2,
    FIELDTERMINATOR=',',
    TABLOCK
)


BULK INSERT bronze.erp_cust_az12
FROM 'E:\code\PROJECTS\Data-Warehouse-Project\Dataset\source_erp\cust_az12.csv'
WITH (
    firstrow=2,
    FIELDTERMINATOR=',',
    TABLOCK
)


BULK INSERT bronze.erp_loc_a101
FROM 'E:\code\PROJECTS\Data-Warehouse-Project\Dataset\source_erp\loc_a101.csv'
WITH (
    firstrow=2,
    FIELDTERMINATOR=',',
    TABLOCK
)

BULK INSERT bronze.erp_px_cat_g1v2
FROM 'E:\code\PROJECTS\Data-Warehouse-Project\Dataset\source_erp\PX_CAT_G1V2.csv'
WITH (
    firstrow=2,
    FIELDTERMINATOR=',',
    TABLOCK
)

SELECT  * FROM bronze.erp_px_cat_g1v2;
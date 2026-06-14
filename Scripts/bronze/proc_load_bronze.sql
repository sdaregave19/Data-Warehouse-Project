-- BULK INSERT
-- USE DataWarehouse;


CREATE OR ALTER PROCEDURE bronze.load_bronze 
AS
BEGIN
    DECLARE @start_time DATETIME , @end_time DATETIME , @batch_start DATETIME , @batch_end DATETIME;
    BEGIN TRY
        SET @batch_start=GETDATE();
        PRINT'********************************************************'
        PRINT 'Loading Bronze Layer'
        PRINT'********************************************************'

        PRINT'--------------------------------------------------------'
        PRINT'Loading CRM Tables';

        SET @start_time=GETDATE();
        TRUNCATE TABLE bronze.crm_cust_info;
        BULK INSERT bronze.crm_cust_info
        FROM 'E:\code\PROJECTS\Data-Warehouse-Project\Dataset\source_crm\cust_info.csv'
        WITH (
            firstrow=2,
            FIELDTERMINATOR=',',
            TABLOCK
        );
        SET @end_time=GETDATE();
        PRINT'>>> Load Duration: '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'seconds';
        PRINT'////////////////////';

        SET @start_time=GETDATE();
        TRUNCATE TABLE bronze.crm_prd_info;
        BULK INSERT bronze.crm_prd_info 
        FROM 'E:\code\PROJECTS\Data-Warehouse-Project\Dataset\source_crm\prd_info.csv'
        WITH (
            firstrow=2,
            FIELDTERMINATOR=',',
            TABLOCK
        );
        SET @end_time=GETDATE();
        PRINT'>>> Load Duration: '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'seconds';
        PRINT'////////////////////';

        SET @start_time=GETDATE();
        TRUNCATE TABLE bronze.crm_sales_details;
        BULK INSERT bronze.crm_sales_details
        FROM 'E:\code\PROJECTS\Data-Warehouse-Project\Dataset\source_crm\sales_details.csv'
        WITH (
            firstrow=2,
            FIELDTERMINATOR=',',
            TABLOCK
        );
        SET @end_time=GETDATE();
        PRINT'>>> Load Duration: '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'seconds';
        
        PRINT'--------------------------------------------------------'

        PRINT'--------------------------------------------------------'
        PRINT'Loading ERP Tables'
        PRINT'--------------------------------------------------------'

        SET @start_time=GETDATE();
        TRUNCATE TABLE bronze.erp_cust_az12;
        BULK INSERT bronze.erp_cust_az12
        FROM 'E:\code\PROJECTS\Data-Warehouse-Project\Dataset\source_erp\cust_az12.csv'
        WITH (
            firstrow=2,
            FIELDTERMINATOR=',',
            TABLOCK
        );
        SET @end_time=GETDATE();
        PRINT'>>> Load Duration: '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'seconds';
        PRINT'////////////////////';

        SET @start_time=GETDATE();
        TRUNCATE TABLE bronze.erp_loc_a101;
        BULK INSERT bronze.erp_loc_a101
        FROM 'E:\code\PROJECTS\Data-Warehouse-Project\Dataset\source_erp\loc_a101.csv'
        WITH (
            firstrow=2,
            FIELDTERMINATOR=',',
            TABLOCK
        );
        SET @end_time=GETDATE();
        PRINT'>>> Load Duration: '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'seconds';
        PRINT'////////////////////';


        SET @start_time=GETDATE();
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'E:\code\PROJECTS\Data-Warehouse-Project\Dataset\source_erp\PX_CAT_G1V2.csv'
        WITH (
            firstrow=2,
            FIELDTERMINATOR=',',
            TABLOCK
        );
        SET @end_time=GETDATE();
        PRINT'>>> Load Duration: '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'seconds';
        PRINT'////////////////////';

        --Bronze layer duration
        SET @batch_end=GETDATE();
        PRINT' ';
        PRINT'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
        PRINT'Loading bronze layer completed';
        PRINT'Total Duration : '+CAST(DATEDIFF(second,@batch_start,@batch_end) AS NVARCHAR)+'seconds';
        PRINT'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
        PRINT' '
        END TRY
        BEGIN CATCH
        PRINT'-------------------------------------------'
        PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER'
        PRINT'Error Message : '+ERROR_MESSAGE();
        PRINT'Error Number : '+CAST(ERROR_NUMBER() AS NVARCHAR); --?use CAST() because PRINT can only print a string,
        PRINT'-------------------------------------------'
        END CATCH
END



EXEC bronze.load_bronze;
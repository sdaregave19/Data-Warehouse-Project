-- !Data Warehouse project, names like bronze, silver, and gold are often used as separate databases/layers
-- SCHEMA->A database contains one or more schemas, and a schema contains tables and other database objects.


IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;


-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;


USE DataWarehouse;


-- Create Schemas
CREATE SCHEMA bronze;


CREATE SCHEMA silver;


CREATE SCHEMA gold;

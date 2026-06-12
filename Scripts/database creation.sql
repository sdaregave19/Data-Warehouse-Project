DROP DATABASE if EXISTS DataWarehouse;

SELECT DATABASE();
CREATE DATABASE bronze;
CREATE DATABASE silver;
CREATE DATABASE gold;
-- !Data Warehouse project, names like bronze, silver, and gold are often used as separate databases/layers
-- SCHEMA->A database contains one or more schemas, and a schema contains tables and other database objects.

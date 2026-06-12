load data local infile 'E:\code\PROJECTS\Data-Warehouse-Project\Dataset\source_crm\cust_info.csv'
into table crm_cust_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# SQL Data Warehouse & Analytics Project

## Overview

This project demonstrates the design and implementation of a modern Data Warehouse using SQL Server and the Medallion Architecture (Bronze, Silver, Gold). The solution integrates data from multiple source systems, performs ETL processes, and creates analytical data models for business reporting and insights.

## Objectives

* Build a scalable and maintainable data warehouse.
* Implement ETL pipelines for data ingestion and transformation.
* Apply data cleansing and standardization techniques.
* Design dimensional models using a Star Schema.
* Generate business insights through SQL-based analytics.

---

## Architecture

### Bronze Layer

* Stores raw data extracted from source systems.
* Preserves original data without modifications.
* Serves as the foundation for downstream processing.

### Silver Layer

* Performs data cleansing, validation, and transformation.
* Standardizes formats and handles missing or duplicate records.
* Creates a reliable and consistent dataset.

### Gold Layer

* Contains business-ready data models.
* Implements fact and dimension tables.
* Optimized for reporting, dashboards, and analytics.

---

## Data Sources

### CRM Data

* Customer information
* Product details
* Sales transactions

### ERP Data

* Operational records
* Product master data
* Business process information

---

## Technologies Used

* SQL Server
* T-SQL
* ETL Development
* Data Warehousing
* Star Schema Modeling
* Stored Procedures
* Views
* Git & GitHub

---

## Project Structure

```text
Data-Warehouse-Project/
│
├── datasets/
│   ├── source_crm/
│   └── source_erp/
│
├── scripts/
│   ├── bronze/
│   ├── silver/
│   ├── gold/
│   └── analytics/
│
├── docs/
│   └── data_architecture/
│
└── README.md
```

---

## ETL Workflow

1. Extract data from CRM and ERP source files.
2. Load raw data into the Bronze layer.
3. Clean and standardize data in the Silver layer.
4. Transform data into dimensional models in the Gold layer.
5. Perform analytical queries and generate insights.

---


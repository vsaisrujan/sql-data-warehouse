#  SQL Data Warehouse Project (Medallion Architecture)

------------------------------------------------------------

## Project Overview

This project demonstrates the design and implementation of an **end-to-end SQL Data Warehouse**
using the **Medallion Architecture (Bronze, Silver, Gold)**.

Raw source data is ingested, cleansed, standardized, enriched, and transformed into
**analytics-ready fact and dimension views** using SQL.

This project was built by following **Baraa Khatib Salkini’s SQL Data Warehouse YouTube course**
and applying real-world data engineering best practices.

------------------------------------------------------------

## Architecture Overview

### Medallion Architecture

- **Bronze Layer**  
  Raw data ingestion from source CSV files (no transformations)

- **Silver Layer**  
  Data cleansing, standardization, enrichment, and deduplication

- **Gold Layer**  
  Business-ready fact and dimension views using a **Star Schema**

Source CSV Files
↓
Bronze Layer (Raw Tables)
↓
Silver Layer (Cleaned & Transformed Tables)
↓
Gold Layer (Fact & Dimension Views)


------------------------------------------------------------

## 🛠️ Technologies Used

- SQL Server
- T-SQL
- Stored Procedures
- BULK INSERT
- Medallion Architecture
- Star Schema Data Modeling
- Git & GitHub

------------------------------------------------------------

## 🥉 Bronze Layer – Raw Data

**Purpose:**  
Store raw, source-aligned data with minimal transformation.

**Key Features:**
- Data loaded directly from CSV files
- Truncate-and-load strategy
- `BULK INSERT` for ingestion
- Load duration logging
- Error handling using TRY…CATCH

**Tables Include:**
- `bronze.crm_cust_info`
- `bronze.crm_prd_info`
- `bronze.crm_sales_details`
- `bronze.erp_cust_az12`
- `bronze.erp_loc_a101`
- `bronze.erp_px_cat_g1v2`

------------------------------------------------------------

## 🥈 Silver Layer – Cleansed & Transformed Data

**Purpose:**  
Prepare clean, standardized, and enriched data for analytics.

**Key Transformations:**
- Deduplication using `ROW_NUMBER()`
- Data standardization (gender, country, product lines)
- Handling nulls and invalid values
- Date normalization
- Data enrichment (derived columns)
- Business-rule validation

**Examples:**
- Selecting latest customer records
- Normalizing gender and marital status
- Recalculating incorrect sales values
- Deriving category and product keys

------------------------------------------------------------

## Gold Layer – Analytics-Ready Data

**Purpose:**  
Provide business-friendly views optimized for reporting and analysis.

**Key Features:**
- Star Schema design
- Fact and Dimension views
- Surrogate keys for dimensions
- Optimized for BI tools

**Includes:**
- Dimension views (Customers, Products, Categories, Locations)
- Fact views (Sales)

------------------------------------------------------------

## Data Modeling

- Star Schema design
- Surrogate keys generated using deterministic ordering
- Clear separation of facts and dimensions
- Optimized joins for analytical queries

------------------------------------------------------------

## Data Quality Checks

- Duplicate detection and removal
- Validation of date fields
- Handling null, zero, and negative values
- Sales amount reconciliation
- Referential consistency across layers

------------------------------------------------------------

## Key Learnings

- Implementing Medallion Architecture in SQL
- Building scalable ETL pipelines
- Applying data cleansing and enrichment techniques
- Designing fact and dimension models
------------------------------------------------------------
## References

- Course: **SQL Data Warehouse** by *Baraa Khatib Salkini*
- Architecture: Medallion (Bronze–Silver–Gold)
- Data Modeling: Star Schema

------------------------------------------------------------




create table bronze.crm_cust_info (
	cst_id int,cst_key Nvarchar(50),
	cst_firstname Nvarchar(50),
	cst_lastname Nvarchar(50),
	cst_marital_status Nvarchar(50),
	cst_gndr Nvarchar(50),
	cst_create_date DATE
);

-- =============================================
-- Table: bronze.crm_prd_info
-- Purpose: Store raw product data from CRM source
-- Source File: prd_info.csv
-- Load Type: Full / Incremental (raw ingestion)
-- =============================================
CREATE TABLE bronze.crm_prd_info (
    prd_id         INT,                -- Surrogate or source product ID
    prd_key        NVARCHAR(50),        -- Business key for product
    prd_nm         NVARCHAR(100),       -- Product name
    prd_cost       INT,					 -- Product cost
    prd_line       NVARCHAR(50),        -- Product line / category
    prd_start_dt   DATETIME,                -- Product effective start date
    prd_end_dt     DATETIME                 -- Product effective end date
);
GO

-- =============================================
-- Table: bronze.crm_sales_details
-- Purpose: Store raw sales transaction data
-- Source File: sales_details.csv
-- Load Type: Transactional fact data (raw)
-- =============================================
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num    NVARCHAR(50),        -- Sales order number
    sls_prd_key    NVARCHAR(50),        -- Product business key
    sls_cust_id    INT,                 -- Customer ID
    sls_order_dt   INT,                -- Order date
    sls_ship_dt    INT,                -- Shipment date
    sls_due_dt     INT,                -- Payment due date
    sls_sales      INT,      -- Total sales amount
    sls_quantity   INT,                 -- Quantity sold
    sls_price      INT       -- Unit price
);
GO

create table bronze.erp_loc_a101 (
	cid NVARCHAR(50),
	cntry NVARCHAR(50)
);
GO

create table bronze.erp_cust_az12 (
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(50)
);
GO

create table bronze.erp_px_cat_g1v2 (
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50)
);




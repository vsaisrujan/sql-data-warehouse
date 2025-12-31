-- Switch context to the master database
-- This is required because new databases must be created from master
USE master;
GO

-- Create the main Data Warehouse database
-- This database will store all warehouse-related schemas and objects
CREATE DATABASE DataWarehouse;
GO

-- Switch context to the newly created DataWarehouse database
USE DataWarehouse;
GO

-- Create the BRONZE schema
-- Purpose: Store raw, unprocessed data ingested from source systems
-- Data here is typically loaded as-is with minimal transformation
CREATE SCHEMA bronze;
GO

-- Create the SILVER schema
-- Purpose: Store cleaned, validated, and transformed data
-- This layer applies business rules and standardization
CREATE SCHEMA silver;
GO

-- Create the GOLD schema
-- Purpose: Store curated, analytics-ready data
-- This layer is optimized for reporting, dashboards, and BI tools
CREATE SCHEMA gold;
GO

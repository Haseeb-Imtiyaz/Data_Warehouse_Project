-- Create a new database named DataWareHouse
CREATE DATABASE DataWareHouse;

-- Switch to the DataWareHouse database
USE DataWareHouse;

-- ================================
-- Creating schemas for data layers
-- ================================

-- Bronze schema:
-- Used to store raw data as it is received from source systems
-- No cleaning or transformation is done here
CREATE SCHEMA bronze;
GO

-- Silver schema:
-- Used to store cleaned and processed data
-- Basic transformations and data quality checks are applied here
CREATE SCHEMA silver;
GO

-- Gold schema:
-- Used to store final, business-ready data
-- Data here is optimized for reporting and analytics
CREATE SCHEMA gold;
GO

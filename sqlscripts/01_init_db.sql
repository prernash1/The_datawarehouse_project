DROP DATABASE IF EXISTS DataWarehouse;
Create Database DataWarehouse;
Use DataWarehouse;

-- =====================================================
-- INITIAL SERVER SETUP
-- Run once before executing the project
-- =====================================================

SET GLOBAL local_infile = 1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';
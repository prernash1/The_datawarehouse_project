/*
===============================================================================
Database Initialization Script
===============================================================================
Project: Enterprise E-Commerce Data Warehouse (CRM + ERP Integration)
Script Purpose:
    This script initializes the core database container for our analytical 
    data pipeline. It handles environment cleanup by dropping any existing 
    instance of the database to ensure a clean, idempotent deployment state.

WARNING:
    Running this script will permanently drop the 'DataWarehouse' database 
    and all of its underlying historical layers. Proceed with caution.
===============================================================================
*/

-- Step 1: Drop the existing database instance to prevent schema conflicts
DROP DATABASE IF EXISTS DataWarehouse;

-- Step 2: Create a fresh instance of our unified analytical Data Warehouse
CREATE DATABASE DataWarehouse;

-- Step 3: Set the context to the newly created database for subsequent operations
USE DataWarehouse;

-- =====================================================
-- INITIAL SERVER SETUP
-- Run once before executing the project
-- =====================================================

SET GLOBAL local_infile = 1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

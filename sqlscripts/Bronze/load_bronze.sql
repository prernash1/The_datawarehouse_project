-- Ingestion(bulk load)
    -- Pipeline Timer
    SET @pipeline_start = NOW();
	--  Start the pipeline
    SELECT '================================================' AS Log;
    SELECT 'LOADING BRONZE LAYER' AS Log;
	SELECT '================================================' AS Log;
    SELECT '------------------------------------------------' AS Log;
    SELECT 'LOADING CRM TABLES' AS Log;
    SELECT '------------------------------------------------' AS Log;
    
    -- TABLE 1: bronze_crm_cust_info
    SET @start = NOW();
    SELECT '>> Truncating table: bronze_crm_cust_info' AS Log;
    TRUNCATE TABLE bronze_crm_cust_info;
    
	SELECT '>> Inserting data into table: bronze_crm_cust_info' AS Log;
	LOAD DATA LOCAL INFILE 'C:/The_Datawarehouse_and_analytics_project/datasets/crm_source_file/cust_info.csv'
	INTO TABLE bronze_crm_cust_info
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS;
    
    SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS Log;

	SELECT CONCAT(
		'>> Load Duration: ',
		TIMESTAMPDIFF(SECOND, @start, NOW()),
		' seconds'
	) AS Log;

	SELECT '>> -----------------------------' AS Log;


    -- TABLE 2: bronze_crm_prd_info
    SET @start = NOW();
    SELECT '>>Truncating table: bronze_crm_prd_info' as LOG;
	TRUNCATE TABLE bronze_crm_prd_info;
    
    SELECT '>>Inserting data into table: bronze_crm_prd_info;' AS LOG;
	LOAD DATA LOCAL INFILE 'C:/The_Datawarehouse_and_analytics_project/datasets/crm_source_file/prd_info.csv'
	INTO TABLE bronze_crm_prd_info
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS;
    
    SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS Log;

	SELECT CONCAT(
		'>> Load Duration: ',
		TIMESTAMPDIFF(SECOND, @start, NOW()),
		' seconds'
	) AS Log;

	SELECT '>> -----------------------------' AS Log;
    
    -- TABLE 3: bronze_crm_sales_details
    SET @start = NOW();
    SELECT '>>Truncating table: bronze_crm_sales_details' AS Log;
	TRUNCATE TABLE bronze_crm_sales_details;
    
    SELECT '>>Inserting data into table: bronze_crm_sales_details;' AS LOG;
	LOAD DATA LOCAL INFILE 'C:/The_Datawarehouse_and_analytics_project/datasets/crm_source_file/sales_details.csv'
	INTO TABLE bronze_crm_sales_details
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS;
    
    SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS Log;

	SELECT CONCAT(
		'>> Load Duration: ',
		TIMESTAMPDIFF(SECOND, @start, NOW()),
		' seconds'
	) AS Log;

	SELECT '>> -----------------------------' AS Log;
    
    
    SELECT '------------------------------------------------' AS Log;
    SELECT 'LOADING ERP TABLES' AS Log;
    SELECT '------------------------------------------------' AS Log;
	
    -- TABLE 1: bronze_erp_cust_az12
    SET @start = NOW();
    SELECT '>> Truncating table: bronze_erp_cust_az12' AS Log;
	TRUNCATE TABLE bronze_erp_cust_az12;
    
    SELECT '>>Inserting data into table: bronze_erp_cust_az12;' AS LOG;
	LOAD DATA LOCAL INFILE 'C:/The_Datawarehouse_and_analytics_project/datasets/erp_source_file/cust_az12.csv'
	INTO TABLE bronze_erp_cust_az12
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS;
    
    SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS Log;

	SELECT CONCAT(
		'>> Load Duration: ',
		TIMESTAMPDIFF(SECOND, @start, NOW()),
		' seconds'
	) AS Log;

	SELECT '>> -----------------------------' AS Log;
    
     
	-- TABLE 2: bronze_erp_loc_a101
    SET @start = NOW();
    SELECT '>> Truncating table: bronze_erp_loc_a101' AS Log;
	TRUNCATE TABLE bronze_erp_loc_a101;
    
    SELECT '>>Inserting data into table: bronze_erp_loc_a101;' AS LOG;
	LOAD DATA LOCAL INFILE 'C:/The_Datawarehouse_and_analytics_project/datasets/erp_source_file/loc_a101.csv'
	INTO TABLE bronze_erp_loc_a101
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS;
    
    SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS Log;

	SELECT CONCAT(
		'>> Load Duration: ',
		TIMESTAMPDIFF(SECOND, @start, NOW()),
		' seconds'
	) AS Log;

	SELECT '>> -----------------------------' AS Log;
    
    -- TABLE 3: bronze_erp_px_cat_g1v2
    SET @start = NOW();
    SELECT '>> Truncating table: bronze_erp_px_cat_g1v2' AS log;
	TRUNCATE TABLE bronze_erp_px_cat_g1v2;
    
    SELECT '>>Inserting data into table: bronze_erp_px_cat_g1v2;' AS LOG;
	LOAD DATA LOCAL INFILE 'C:/The_Datawarehouse_and_analytics_project/datasets/erp_source_file/px_cat_g1v2.csv'
	INTO TABLE bronze_erp_px_cat_g1v2
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS;
    
    SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS Log;

	SELECT CONCAT(
		'>> Load Duration: ',
		TIMESTAMPDIFF(SECOND, @start, NOW()),
		' seconds'
	) AS Log;

	SELECT '>> -----------------------------' AS Log;
    
	SELECT '==========================================' AS Log;
	SELECT 'Loading Bronze Layer Completed' AS Log;

	SELECT CONCAT(
		'Total Pipeline Duration: ',
		TIMESTAMPDIFF(SECOND, @pipeline_start, NOW()),
		' seconds'
	) AS Log;

	SELECT '==========================================' AS Log;
		

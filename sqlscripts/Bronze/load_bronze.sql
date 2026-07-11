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
    OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS
	(
	  @cst_id,
	  @cst_key,
	  @cst_firstname,
	  @cst_lastname,
	  @cst_marital_status,
      @cst_gndr,
	  @cst_create_date
	)
    SET
	  cst_id             = NULLIF(TRIM(@cst_id), ''),
	  cst_key            = NULLIF(TRIM(@cst_key), ''),
	  cst_firstname      = NULLIF(TRIM(@cst_firstname), ''),
	  cst_lastname       = NULLIF(TRIM(@cst_lastname), ''),
	  cst_marital_status = NULLIF(TRIM(@cst_marital_status), ''),
	  cst_gndr           = NULLIF(TRIM(@cst_gndr), ''),
	  cst_create_date    = NULLIF(TRIM(@cst_create_date), '');
    
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
    OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS
    (
	  @prd_id,
	  @prd_key,
	  @prd_nm,
	  @prd_cost,
	  @prd_line,
	  @prd_start_dt,
	  @prd_end_dt
	)
    SET
	  prd_id       = NULLIF(TRIM(@prd_id), ''),
	  prd_key      = NULLIF(TRIM(@prd_key), ''),
	  prd_nm       = NULLIF(TRIM(@prd_nm), ''),
	  prd_cost     = NULLIF(TRIM(@prd_cost), ''),
	  prd_line     = NULLIF(TRIM(@prd_line), ''),
	  prd_start_dt = NULLIF(TRIM(@prd_start_dt), ''),
	  prd_end_dt   = NULLIF(TRIM(@prd_end_dt), '');
    
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
    OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS
	(
	  @sls_ord_num,
	  @sls_prd_key,
	  @sls_cust_id,
	  @sls_order_dt,
	  @sls_ship_dt,
	  @sls_due_dt,
	  @sls_sales,
      @sls_quantity,
      @sls_price
	)
    SET
	  sls_ord_num  = NULLIF(TRIM(@sls_ord_num), ''),
	  sls_prd_key  = NULLIF(TRIM(@sls_prd_key), ''),
	  sls_cust_id  = NULLIF(TRIM(@sls_cust_id), ''),
	  sls_order_dt = NULLIF(TRIM(@sls_order_dt), ''),
	  sls_ship_dt  = NULLIF(TRIM(@sls_ship_dt), ''),
	  sls_due_dt   = NULLIF(TRIM(@sls_due_dt), ''),
	  sls_sales    = NULLIF(TRIM(@sls_sales), ''),
      sls_quantity = NULLIF(TRIM(@sls_quantity), ''),
      sls_price    = NULLIF(TRIM(@sls_price), '');
    
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
	OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS
    (
	  @cid,
	  @bdate,
	  @gen
	)
    SET
	  cid   = NULLIF(TRIM(@cid), ''),
	  bdate = NULLIF(TRIM(@bdate), ''),
	  gen   = NULLIF(TRIM(@gen), '');
    
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
	OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS
    (
      @cid,
	  @cntry
	)
    SET
	  cid   = NULLIF(TRIM(@cid), ''),
	  cntry = NULLIF(TRIM(@cntry), '');
      
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
    OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 ROWS
    (
      @id,
	  @cat,
	  @subcat,
      @maintenance
	)
    SET
	  id          = NULLIF(TRIM(@id), ''),
	  cat         = NULLIF(TRIM(@cat), ''),
	  subcat      = NULLIF(TRIM(@subcat), ''),
      maintenance = NULLIF(TRIM(@maintenance), '');
    
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
		

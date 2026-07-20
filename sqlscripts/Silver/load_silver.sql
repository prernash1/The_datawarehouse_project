# Usage method : CALL load_silver();

DELIMITER $$
DROP PROCEDURE IF EXISTS load_silver $$
CREATE PROCEDURE load_silver()
BEGIN
	-- Error handling
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN 
    ROLLBACK;
    SELECT CONCAT(
    'ERROR at ',
    NOW(),
    '. Transaction rolled back.'
	) AS Log;
    SELECT 'ERROR: Silver layer loading failed. Transaction rolled back.' AS Log;
    END;
    
	SET @pipeline_start = NOW();
    
	SELECT '================================================' AS Log
	UNION ALL
	SELECT 'LOADING SILVER LAYER'
	UNION ALL
	SELECT CONCAT('Started At: ', @pipeline_start)
	UNION ALL
	SELECT '================================================';
    
	START TRANSACTION; 
    
	-- TABLE 1: silver_crm_cust_info  
    
	SELECT '>> -----------------------------' AS Log;
    
	SET @start = NOW();
    
    SELECT '>> Truncating table: silver_crm_cust_info' AS Log;
	TRUNCATE TABLE silver_crm_cust_info;
	SELECT '>> Inserting data into table: silver_crm_cust_info' AS Log;
	INSERT INTO silver_crm_cust_info(
		cst_id, 
		cst_key, 
		cst_firstname, 
		cst_lastname, 
		cst_marital_status, 
		cst_gndr, 
		cst_create_date  
	)
	SELECT 
		cst_id,    
		cst_key,
		TRIM(cst_firstname) as cst_firstname, -- removed unwanted spaces using TRIM()
		TRIM(cst_lastname) as cst_lastname,
		CASE 
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'    -- standardized the data by replacing abbv with a clear data
		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		ELSE 'N/A'
		END as cst_marital_status, -- normalize marital status to readable format
		CASE 
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		ELSE 'N/A'
		END as cst_gndr,
		cst_create_date
	FROM(
		SELECT *, ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date desc) as latest_id
		from bronze_crm_cust_info
		WHERE cst_id IS NOT NULL
	) as no_null
	WHERE latest_id = 1; -- select the latest record per person
    
    SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS Log
	UNION ALL
	SELECT CONCAT(
		'>> Load Duration: ',
		TIMESTAMPDIFF(SECOND, @start, NOW()),
		' seconds'
	) AS Log;
    SELECT '>> -----------------------------' AS Log;
    
	-- TABLE 2: silver_crm_prd_info
    
    SELECT '>> -----------------------------' AS Log;
    
    SET @start = NOW();
    
    SELECT '>> Truncating table: silver_crm_prd_info' AS Log;
    TRUNCATE TABlE silver_crm_prd_info;
    SELECT '>> Inserting data into table: silver_crm_prd_info' AS LOG;
	INSERT INTO silver_crm_prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
	)
	SELECT 
	prd_id, 
	REPLACE(SUBSTRING(prd_key,1,5),'-', '_') AS cat_id, -- extract category id from prd_key
	SUBSTRING(prd_key,7) AS prd_key, -- extract product id
	prd_nm,
	IFNULL(prd_cost, 0) as prd_cost,
	CASE UPPER(TRIM(prd_line))
	WHEN 'M' THEN 'Mountain'
	WHEN 'R' THEN 'Road'
	WHEN 'S' THEN 'Other Sales'
	WHEN 'T' THEN 'Touring'
	ELSE 'N/A'
	END AS prd_line, -- convert abbreviations to readable format
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	-- to ensure start date never comes after end date
	-- calculate end date as one day before the next start date
	LEAD(CAST(prd_start_dt AS DATE)) OVER (PARTITION BY prd_key ORDER BY CAST(prd_start_dt AS DATE)) - INTERVAL 1 DAY AS prd_end_dt
	FROM bronze_crm_prd_info;
    
    SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS Log
	UNION ALL
	SELECT CONCAT(
		'>> Load Duration: ',
		TIMESTAMPDIFF(SECOND, @start, NOW()),
		' seconds'
	) AS Log;

	SELECT '>> -----------------------------' AS Log;
     
	-- TABLE 3: silver_crm_sales_details
    
    SELECT '>> -----------------------------' AS Log;
    
    SET @start = NOW();
    
    SELECT '>> Truncating table: silver_crm_sales_details' AS Log;
    TRUNCATE TABLE silver_crm_sales_details;
    SELECT '>> Inserting data into table: silver_crm_sales_details' AS LOG;
	INSERT INTO silver_crm_sales_details(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
	)
	SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE WHEN sls_order_dt <= 0 OR LENGTH(sls_order_dt) <> 8 THEN NULL
		 ELSE STR_TO_DATE(sls_order_dt,'%Y%m%d')
	END AS sls_order_dt,
	CASE WHEN sls_ship_dt <= 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
		 ELSE STR_TO_DATE(sls_ship_dt,'%Y%m%d')
	END AS sls_ship_dt,
	CASE WHEN sls_due_dt <= 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
		 ELSE STR_TO_DATE(sls_due_dt,'%Y%m%d')
	END AS sls_due_dt,
	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
		 THEN sls_quantity * ABS(sls_price)
		 ELSE sls_sales
	END AS sls_sales,
	sls_quantity,
	CASE
    WHEN sls_price IS NULL OR sls_price <= 0 THEN
        (
            CASE
                WHEN sls_sales IS NULL
                     OR sls_sales <= 0
                     OR sls_sales <> sls_quantity * ABS(sls_price)
                THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END
        ) / NULLIF(sls_quantity, 0)

    ELSE ABS(sls_price)
	END AS sls_price
	FROM bronze_crm_sales_details;
    
    SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS Log
	UNION ALL
	SELECT CONCAT(
		'>> Load Duration: ',
		TIMESTAMPDIFF(SECOND, @start, NOW()),
		' seconds'
	) AS Log;
    
    SELECT '>> -----------------------------' AS Log;
      
	-- TABLE 4: silver_erp_cust_az12
    
    SELECT '>> -----------------------------' AS Log;
    
    SET @start = NOW();
    
    SELECT '>> Truncating table: silver_erp_cust_az12' AS Log;
    TRUNCATE TABLE silver_erp_cust_az12;
    SELECT '>> Inserting data into table: silver_erp_cust_az12' AS LOG;
	INSERT INTO silver_erp_cust_az12(
		cid,
		bdate,
		gen
	)
	SELECT 
	CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4)
		 ELSE cid
	END AS cid,
	CASE WHEN bdate > CURRENT_DATE() THEN NULL
		ELSE bdate
	END AS bdate,
	CASE WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		ELSE 'N/A'
	END AS gen
	FROM bronze_erp_cust_az12;
    
    SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS Log
	UNION ALL
	SELECT CONCAT(
		'>> Load Duration: ',
		TIMESTAMPDIFF(SECOND, @start, NOW()),
		' seconds'
	) AS Log;
    
    SELECT '>> -----------------------------' AS Log;

    
	-- TABLE 5: silver_erp_loc_a101
    
    SELECT '>> -----------------------------' AS Log;
    
    SET @start = NOW();
    
    SELECT '>> Truncating table: silver_erp_loc_a101' AS Log;
    TRUNCATE TABLE silver_erp_loc_a101;
    SELECT '>> Inserting data into table: silver_erp_loc_a101' AS LOG;
	INSERT INTO silver_erp_loc_a101(
	cid,
	cntry
	)
	SELECT 
	REPLACE((cid), '-', '') as cid,
	CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
		 WHEN cntry IS NULL THEN 'N/A'
		 ELSE TRIM(cntry)
	END AS cntry
	FROM bronze_erp_loc_a101;
    
    SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS Log
	UNION ALL
	SELECT CONCAT(
		'>> Load Duration: ',
		TIMESTAMPDIFF(SECOND, @start, NOW()),
		' seconds'
	) AS Log;
    
    SELECT '>> -----------------------------' AS Log;
    
	-- TABLE 6: silver_erp_px_cat_g1v2
    
    SELECT '>> -----------------------------' AS Log;
    
    SET @start = NOW();
    
    SELECT '>> Truncating table: silver_erp_px_cat_g1v2' AS Log;
    TRUNCATE TABLE silver_erp_px_cat_g1v2;
    SELECT '>> Inserting data into table: silver_erp_px_cat_g1v2' AS LOG;
	INSERT INTO silver_erp_px_cat_g1v2(
		id,
		cat,
		subcat,
		maintenance
	)
	SELECT 
	id,
	cat,
	subcat,
	maintenance
	FROM bronze_erp_px_cat_g1v2;
    
    SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS Log
	UNION ALL
	SELECT CONCAT(
		'>> Load Duration: ',
		TIMESTAMPDIFF(SECOND, @start, NOW()),
		' seconds'
	) AS Log;
    
    SELECT '>> -----------------------------' AS Log;
    
    COMMIT;
    
    SELECT '=========================================' AS Log
	UNION ALL
	SELECT 'Silver Layer Loaded Successfully'
	UNION ALL
	SELECT CONCAT('Finished At: ', NOW())
	UNION ALL
	SELECT '=========================================';
END $$

DELIMITER ;
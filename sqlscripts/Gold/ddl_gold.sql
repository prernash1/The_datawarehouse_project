CREATE VIEW gold_customer_dim AS
	SELECT
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id, 
	ci.cst_key AS customer_code, 
	ci.cst_firstname AS first_name, 
	ci.cst_lastname AS last_name,
	CASE  
		WHEN ci.cst_gndr <> 'N/A' THEN ci.cst_gndr  -- we are taking CRM as the master table
		ELSE COALESCE(ca.gen, 'N/A')
	END AS gender,
	ca.bdate AS birth_date, 
	ci.cst_marital_status AS marital_status, 
	la.cntry AS country,
	ci.cst_create_date AS create_date
	FROM silver_crm_cust_info ci
	LEFT JOIN silver_erp_cust_az12 ca
	ON ci.cst_key = ca.cid
	LEFT JOIN silver_erp_loc_a101 la
	ON ci.cst_key = la.cid
;































































































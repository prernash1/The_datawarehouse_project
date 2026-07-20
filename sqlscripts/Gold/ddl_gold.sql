-- Dimension 1: gold_customer_dim

DROP VIEW IF EXISTS gold_customer_dim;
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

-- Dimension 2: gold_product_dim

DROP VIEW IF EXISTS gold_product_dim;
CREATE VIEW gold_product_dim AS
SELECT 
ROW_NUMBER() OVER(ORDER BY pi.prd_id) AS product_key, -- surrogate key
pi.prd_id AS product_id,
pi.prd_key AS product_code,
pi.prd_nm AS product_name,
pi.prd_line AS product_line,
pi.prd_cost AS cost,
pi.cat_id AS category_id,
pc.cat AS category,
pc.subcat AS subcategory,
pc.maintenance AS maintenance,
pi.prd_start_dt AS start_date
FROM silver_crm_prd_info pi
LEFT JOIN silver_erp_px_cat_g1v2 pc
ON pi.cat_id = pc.id
WHERE pi.prd_end_dt IS NULL -- To filter out historical data because a null end date means product is active
;

-- Fact Table : gold_sales_fact

DROP VIEW IF EXISTS gold_sales_fact;
CREATE VIEW gold_sales_fact AS
SELECT 
sd.sls_ord_num AS order_number,
pd.product_key,
cd.customer_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS due_date,
sd.sls_quantity AS quantity,
sd.sls_sales AS sales_amount,
sd.sls_price AS price
FROM silver_crm_sales_details sd
LEFT JOIN gold_product_dim pd
ON sd.sls_prd_key = pd.product_code
LEFT JOIN gold_customer_dim cd
ON sd.sls_cust_id = cd.customer_id
;




























































































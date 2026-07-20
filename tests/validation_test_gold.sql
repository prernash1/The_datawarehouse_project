-- customer dimension 

-- Check gender standardization
SELECT DISTINCT gender
FROM gold_customer_dim;

-- Check marital status
SELECT DISTINCT marital_status
FROM gold_customer_dim;

-- Check country standardization
SELECT DISTINCT country
FROM gold_customer_dim
ORDER BY country;

-- Check duplicate customers
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM gold_customer_dim
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Check surrogate key
SELECT *
FROM gold_customer_dim
WHERE customer_key IS NULL;

-- product dimension

-- active products
SELECT *
FROM gold_product_dim
WHERE start_date > CURRENT_DATE();

-- duplicate products
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM gold_product_dim
GROUP BY product_id
HAVING COUNT(*) > 1;

-- category check
SELECT DISTINCT category
FROM gold_product_dim;

-- product line check
SELECT DISTINCT product_line
FROM gold_product_dim;

-- fact sales

-- duplicate orders
SELECT
    order_number,
    COUNT(*)
FROM gold_sales_fact
GROUP BY order_number
HAVING COUNT(*) > 1;

-- negative sales
SELECT *
FROM gold_sales_fact
WHERE sales_amount <= 0;

-- missing product key
SELECT *
FROM gold_sales_fact
WHERE product_key IS NULL;

-- missing customer keys
SELECT *
FROM gold_sales_fact
WHERE customer_key IS NULL;
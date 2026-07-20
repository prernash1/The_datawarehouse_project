-- Quality check for GOLD layer

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
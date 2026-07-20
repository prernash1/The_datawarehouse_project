-- check for duplicates or null values in primary key
select cst_id, count(*)
from bronze_crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null;

-- Check for unwanted spaces in the string values
select cst_firstname
from silver_crm_cust_info
where cst_firstname != TRIM(cst_firstname);

-- check for data standardization or consistency
select distinct cst_gndr
from silver_crm_cust_info;


-- crm_prd_info

-- check for null or negative numbers
select prd_cost from silver_crm_prd_info
where prd_cost < 0 or prd_cost IS NULL;

-- data normalization and standardization
select distinct prd_line from bronze_crm_prd_info;

-- check for invalid date orders
select * from silver_crm_prd_info
where prd_end_dt < prd_start_dt;
	
-- crm_sales_details

select *
from bronze_crm_sales_details
where sls_prd_key NOT IN (select prd_key from silver_crm_prd_info);

select *
from bronze_crm_sales_details
where sls_cust_id NOT IN (select cst_id from silver_crm_cust_info);

-- Dates format must be changed from string to 'date' 
-- Zeroes or negative numbers cannot be cast to date
select sls_due_dt
from silver_crm_sales_details
where sls_due_dt <= 0 
or length(sls_due_dt) <> 8;

-- Invalid date orders
Select * from silver_crm_sales_details
Where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;

-- Business Rule:  Sales = Quantity*Price And No negatives, nulls or zeroes allowed
Select sls_sales, sls_quantity, sls_price from silver_crm_sales_details
where sls_sales <> sls_quantity * sls_price
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by 1, 2, 3;

-- erp_cust_az12

-- identify out of range dates
select bdate from silver_erp_cust_az12
where bdate > current_Date();

-- data standardization and consistency check
select distinct gen from silver_erp_cust_az12;

-- erp_loc_a101

-- data standardization and consistency
select distinct cntry
from silver_erp_loc_a101;
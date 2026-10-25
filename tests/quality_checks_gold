/*
==========================================================
Quality Checks
==========================================================
Script Purpose:
	This script performs the quality checks to validate the integrity, consistency, and 
	accuracy of the Gold Layer. These checks ensure:
	- Uniquesness of surrogate keys in dimesnion tables.
	- Referential Integrity between fact and dimension tables
	- Validation of relationships in the data model for analytical purposes.

Usage Notes:
	- Run the checks after data loading Silver layer.
	- Investigate and resolve any discrepancies found during the checks.
==========================================================
*/

-- ====================================================
-- 'Checking gold.dim_customers'
-- ====================================================
-- Check for uniqueness of customer key in gold.dim_customers
-- Expectation: No results
SELECT
	Customer_key,
	COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY Customer_key
HAVING COUNT(*) > 1;

-- ====================================================
-- 'Checking gold.dim_products'
-- ====================================================
--Checking for uniqueness of product key in gold.dim_products
--Expectation: No results
SELECT
	Product_Key,
	COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY Product_Key
HAVING COUNT(*) > 1;

-- ====================================================
-- 'Checking gold.fact_sales'
-- ====================================================
--Check the data model connectivity between fact and dimensions
SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.Customer_key = c.Customer_key
LEFT JOIN gold.dim_products p
ON p.Product_Key = f.Product_Key
WHERE p.Product_Key IS NULL OR c.Customer_key IS NULL

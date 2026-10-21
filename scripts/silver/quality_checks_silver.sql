/*
===========================================================================
Quality Checks
===========================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy and standardization across the 'silver' schema.
    It inckudes checks for:
    - Null or Duplicate Primary Key
    - Unwanted spaces in string fields.
    - Data Standardization & consistency
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading silver layer.
    -Investigate and resolve any discrepancies found during the checks.
===========================================================================
*/

--FOR UNWANTED SPACES
--EXPECTATIONS: No Results
SELECT
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--DATA STANDARDIZATION & CONSISTENCY
SELECT DISTINCT
	prd_line
FROM silver.crm_prd_info

--CHECK FOR NULLS OR NEGATIVE NUMBERS
--EXPECTATION: No Results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

--CHECK FOR INVALID DATE ORDERS
SELECT 
		prd_key,
		prd_start_dt,
		prd_end_dt
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

--IDENTIFY OUT OF ORDER DATES
SELECT [bdate]
FROM [Datawarehouse].[silver].[erp_cust_az12]
WHERE [bdate] < '1924-01-01' OR [bdate] > GETDATE()

--Check for Nulls or Duplicates for Primary Key
--Expectation: No Result
SELECT 
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL


--CHECK FOR INVALID DATES
SELECT *
FROM silver.crm_sales_details
WHERE 
	sls_order_dt > sls_due_dt OR sls_order_dt > sls_ship_dt OR
	sls_due_dt = 0 OR
	LEN(sls_due_dt) !=8 OR			--Checking Length of Date Entry
	sls_due_dt >20500101 OR			--CHECKING Boundary Range
	sls_due_dt < 19000101
	
--Check Data Consistency: Between Sales, Quantity & Price
-->> Sales = Quantity * Price
--> Values must not be  NULL, zero or negative numbers
SELECT DISTINCT 
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price OR
	  sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL OR
	  sls_sales <=0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

SELECT DISTINCT 
		[gen]
FROM [Datawarehouse].[silver].[erp_cust_az12]

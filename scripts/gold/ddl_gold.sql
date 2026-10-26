/*
==============================================================
DDL Script: Create Gold Views
==============================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold Layer represents the final dimensions and fact tables (Star Schema)

    Each View performs transformations and combines data from silver layer to producce a clean,
    and business-ready dataset.

Usage:
    - These Views can be queries directly for analytics and reporting.
=============================================================
*/
-- ================================================================
-- Create Dimension: gold.dim_customers
-- ================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW gold.dim_customers;
GO
CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER(ORDER BY cst_id) AS Customer_key,	--A Surrogate Key created for this Dimension Table
	ci.cst_id AS Customer_ID,
	ci.cst_key AS Customer_Number,
	ci.cst_firstname AS First_Name,
	ci.cst_lastname AS Last_Name,
	la.cntry AS Country,
	ci.cst_marital_status AS Marital_Status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr		--CRM is the Master Table for gender info
		 ELSE COALESCE(ca.gen,'n/a')					--ERP table is the secondary source for gender info incase of n/a in CRM
	END AS Gender,
	ca.bdate AS Birthdate,
	ci.cst_create_date AS Created_Date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON	ci.cst_key =ca.cid

-- ================================================================
-- Create Dimension: gold.dim_products
-- ================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
	DROP VIEW gold.dim_products;
GO
CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS Product_Key,
	pn.prd_id AS Product_id,
	pn.prd_key AS Product_Number,
	pn.prd_nm AS Product_name,
	pn.cat_id AS Category_ID,
	pc.cat AS Category,
	pc.subcat AS Subcategory,
	pc.maintenance,
	pn.prd_cost AS Product_Cost,
	pn.prd_line AS Product_line,
	pn.prd_start_dt AS Start_Date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL		--Filter Out all Historical Data
LEFT JOIN silver.erp_loc_a101 la
ON	ci.cst_key = la.cid

-- ================================================================
-- Create Fact: gold.fact_sales
-- ================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO
CREATE VIEW gold.fact_sales AS
SELECT
	sd.sls_ord_num AS [Order Number],
	pr.Product_Key,
	cu.Customer_key,
	sd.sls_order_dt AS [Order Date],
	sd.sls_ship_dt AS [Ship Date],
	sd.sls_due_dt AS [Due Date],
	sd.sls_sales AS [Sales Amount],
	sd.sls_quantity AS Quantity,
	sd.sls_price AS Price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prod_key = pr.Product_Number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.Customer_ID

/*
=======================================================
Product Report
=======================================================
Purpose:
	- This report consolidates key product metrics and behaviours.

Highlights:
	1. Gathers essential fields such as product name, category, subcategory and cost.
	2. Segments product by revenue to identify High-Performers, Mid-Range, or Low-Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- Lifespan (in months)
	4. Calculate Valuable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue
======================================================
*/
CREATE VIEW gold.report_products AS
With Base_query AS (
/*---------------------------------------------------------
1) Base Query: Retrieves core columns from tables
-----------------------------------------------------------*/
SELECT
	p.Product_name,
	p.Category,
	p.Subcategory,
	p.Product_Cost,
	f.[Order Number],
	f.Customer_key,
	f.[Sales Amount],
	f.Quantity,
	f.[Order Date]
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.Product_Key = p.Product_Key
WHERE f.[Order Date] IS NOT NULL
)
, product_aggregation AS (
/*------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
--------------------------------------------------*/
SELECT
	Product_name,
	Category,
	Subcategory,
	COUNT([Order Number]) AS [Total Orders],
	COUNT(DISTINCT Customer_key) AS [Total Customers],
	MAX([Order Date]) AS [Last Order Date],
	SUM([Sales Amount]) AS [Total Sales],
	SUM(Quantity) AS [Total Quantity Sold],
	DATEDIFF(Month , MIN([Order Date]), MAX([Order Date])) AS Lifespan
FROM Base_query
GROUP BY
	Product_name,
	Category,
	Subcategory
)
SELECT
	Product_name,
	Category,
	Subcategory,
	CASE WHEN [Total Sales] >= 1000000 THEN 'High Performer'
		 WHEN [Total Sales] BETWEEN 300000 AND 1000000 THEN 'Mid Range'
		 ELSE 'Low Performer'
	END [Segment],
	[Total Sales],
	[Total Quantity Sold],
	[Total Customers],
	[Total Orders],
	DATEDIFF(Month, [Last Order Date], GETDATE()) AS Recency,
	--Compute Average Order Revenue
	CASE WHEN [Total Quantity Sold] = 0 THEN [Total Sales]
		 ELSE ROUND(CAST([Total Sales] AS Float)/[Total Quantity Sold], 2)
	END [Avg Order Revenue],
	--Compute Average Monthly Revenue
	CASE WHEN Lifespan = 0 THEN [Total Sales]
		 ELSE [Total Sales]/Lifespan
	END AS [Avg Monthly Revenue]
FROM product_aggregation

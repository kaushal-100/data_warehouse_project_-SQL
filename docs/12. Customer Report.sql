/*
============================================================
Customer Report
============================================================
Purpose:
	- This report consolidates key customer metrics and behaviours

Highlights:
	1. Gather essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregates Customer-level metrics:
		- total orders
		- total sales
		- total quantity purcahsed
		- total products
		- lifespan (in months)
	4. Calculate valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend
===========================================================
*/
CREATE VIEW gold.report_customers AS
WITH base_query AS (
/*---------------------------------------------------------
1) Base Query: Retrieves core columns from tables
-----------------------------------------------------------*/
SELECT
	f.[Order Number],
	f.Product_Key,
	f.Quantity,
	f.[Order Date],
	f.[Sales Amount],
	c.Customer_key,
	c.Customer_Number,
	CONCAT(c.First_Name, ' ', c.Last_Name) AS [Customer Name],
	DATEDIFF(Year, c.Birthdate, GETDATE()) AS Age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.Customer_key = c.Customer_key
WHERE f.[Order Date] IS NOT NULL
)
, customer_aggregation AS (
/*------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
--------------------------------------------------*/
SELECT
	Customer_key,
	Customer_Number,
	[Customer Name],
	Age,
	COUNT(DISTINCT [Order Number]) AS [Total Orders],
	SUM([Sales Amount]) AS [Total Sales],
	SUM(Quantity) AS [Total Quantity],
	COUNT(DISTINCT Product_Key) AS [Total Products],
	MAX([Order Date]) AS [Last Order Date],
	DATEDIFF(Month, MIN([Order Date]), MAX([Order Date])) AS Lifespan
FROM base_query
GROUP BY
	Customer_key,
	Customer_Number,
	[Customer Name],
	Age
)
SELECT
	Customer_key,
	Customer_Number,
	[Customer Name],
	Age,
	CASE WHEN Age <20 THEN 'Under 20'
		 WHEN Age BETWEEN 20 AND 29 THEN '20-29'
		 WHEN Age BETWEEN 30 AND 39 THEN '30-39'
		 WHEN Age BETWEEN 40 AND 49 THEN '40-49'
		 ELSE '50 and Above'
	END AS [Age Group],
	CASE WHEN Lifespan >12 AND [Total Sales] > 5000 THEN 'VIP'
			WHEN Lifespan >=12 AND [Total Sales] <= 5000 THEN 'Regular'
			ELSE 'New'
	END [Customer Segment],
	[Last Order Date],
	DATEDIFF(MONTH,[Last Order Date], GETDATE()) AS Recency, 
	[Total Orders],
	[Total Sales],
	[Total Quantity],
	[Total Products],
	Lifespan,
--Compute Average Order Value (AVO)
	CASE WHEN [Total Orders] = 0 THEN 0
		 ELSE ROUND(CAST([Total Sales] AS Float)/[Total Orders], 2)
	END AS [Avg Order Value],
--Compute Average monthly spend
	CASE WHEN Lifespan = 0 THEN [Total Sales]
		 ELSE [Total Sales]/Lifespan
	END AS [Avg Monthly Spend]
FROM customer_aggregation
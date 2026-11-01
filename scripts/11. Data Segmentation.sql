--11. Data Segmentation

/*Segment Products into cost ranges and
count how many products fall into each segment */
WITH product_segments AS (
	SELECT
		Product_Key,
		Product_name,
		Product_Cost,
		CASE WHEN Product_Cost < 100 THEN 'Below 100'
			 WHEN Product_Cost BETWEEN 100 AND 500 THEN '100-500'
			 WHEN Product_Cost BETWEEN 500 AND 1000 THEN '500-1000'
			 ELSE 'Above 1000'
		END [Cost Range]
	FROM gold.dim_products
)
SELECT
	[Cost Range],
	COUNT(Product_Key) AS [Total Products]
FROM product_segments
GROUP BY [Cost Range]
ORDER BY [Total Products] DESC

/*Group Customers into 3 Segments based on their segment behaviour:
- VIP: atleast 12 months of history and spending more than $5000
- Regular: atleast 12 months of history but spending $5000 or less
- New: lifespan less than 12 months 
Find the total number of customers by each group*/
WITH customer_spending AS (
	SELECT
		c.Customer_key AS [Customer Key],
		SUM(f.[Sales Amount]) AS [Total Spending],
		MIN(f.[Order Date]) AS [First Order],
		MAX(f.[Order Date]) AS [Last Order],
		DATEDIFF(Month, MIN(f.[Order Date]), MAX(f.[Order Date])) AS Lifespan
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON f.Customer_key = c.Customer_key
	GROUP BY c.Customer_key
)
SELECT
	[Customer Segment],
	COUNT([Customer Key]) AS [Total Customers]
FROM (
	SELECT
		[Customer Key],
		CASE WHEN Lifespan >12 AND [Total Spending] > 5000 THEN 'VIP'
			 WHEN Lifespan >=12 AND [Total Spending] <= 5000 THEN 'Regular'
			 ELSE 'New'
		END [Customer Segment]
	FROM customer_spending
)t
GROUP BY [Customer Segment]
ORDER BY [Total Customers] DESC
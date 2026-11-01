--6. RANKING EXPLORATION

--Which 5 Products generate the highest revenue?
SELECT TOP 5
	p.Product_name,
	SUM(f.[Sales Amount]) AS [Total Revenue]
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.Product_Key = p.Product_Key
GROUP BY p.Product_name
ORDER BY [Total Revenue] DESC



SELECT *				/* Using Windows Function instead of TOP */
FROM ( 
	SELECT
		p.Product_name,
		SUM(f.[Sales Amount]) AS [Total Revenue],
		ROW_NUMBER() OVER(ORDER BY SUM(f.[Sales Amount]) DESC) AS [Rank Products] 
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.Product_Key = p.Product_Key
	GROUP BY p.Product_name
)t WHERE [Rank Products] <= 5

--What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
	p.Product_name,
	SUM(f.[Sales Amount]) AS [Total Revenue]
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.Product_Key = p.Product_Key
GROUP BY p.Product_name
ORDER BY [Total Revenue] ASC

--Find the top 10 Customers who have generated the highest revenue
SELECT TOP 10
	c.Customer_key,
	c.First_Name,
	c.Last_Name,
	SUM(f.[Sales Amount]) AS [Total Revenue]
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.Customer_key = c.Customer_key
GROUP BY c.Customer_key, c.First_Name, c.Last_Name
ORDER BY [Total Revenue] DESC

--The 3 Customers with fewest orders placed
SELECT TOP 3
	c.Customer_key,
	c.First_Name,
	c.Last_Name,
	COUNT(DISTINCT f.[Order Number]) AS [Total Orders Placed]
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.Customer_key = c.Customer_key
GROUP BY c.Customer_key, c.First_Name, c.Last_Name
ORDER BY [Total Orders Placed] ASC
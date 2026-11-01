--7. Change over Time
--Analyze Sales over the time
SELECT
	DATETRUNC(MONTH, [Order Date]) AS [Order Date],
	SUM([Sales Amount]) AS [Total Sales],
	COUNT(DISTINCT Customer_key) AS [Total Customers],
	SUM(Quantity) AS [Total Quantity]
FROM gold.fact_sales
WHERE [Order Date] IS NOT NULL
GROUP BY DATETRUNC(MONTH, [Order Date])
ORDER BY DATETRUNC(MONTH, [Order Date])

SELECT
	YEAR([Order Date]) AS [Order Year],
	MONTH([Order Date]) AS [Order Month],
	SUM([Sales Amount]) AS [Total Sales],
	COUNT(DISTINCT Customer_key) AS [Total Customers],
	SUM(Quantity) AS [Total Quantity]
FROM gold.fact_sales
WHERE [Order Date] IS NOT NULL
GROUP BY YEAR([Order Date]), MONTH([Order Date])
ORDER BY YEAR([Order Date]), MONTH([Order Date])

SELECT
	FORMAT([Order Date], 'yyyy-MMMM') AS [Order Date],
	SUM([Sales Amount]) AS [Total Sales],
	COUNT(DISTINCT Customer_key) AS [Total Customers],
	SUM(Quantity) AS [Total Quantity]
FROM gold.fact_sales
WHERE [Order Date] IS NOT NULL
GROUP BY FORMAT([Order Date], 'yyyy-MMMM')
ORDER BY FORMAT([Order Date], 'yyyy-MMMM')
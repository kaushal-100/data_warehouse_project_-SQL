--8.Cumulative Analysis

--Calculate the total Sales per month
--and the running total of sales over time
SELECT
	[Order Date],
	[Total Sales],
	SUM([Total Sales]) OVER(PARTITION BY YEAR([Order Date]) ORDER BY [Order Date]) AS [Running Total Sales],
	AVG([Average Price]) OVER(PARTITION BY YEAR([Order Date]) ORDER BY [Order Date]) AS [Moving Average Price]
FROM
	(
	SELECT
		DATETRUNC(MONTH,[Order Date]) AS [Order Date],
		SUM([Sales Amount]) AS [Total Sales],
		AVG(Price) AS [Average Price]
	FROM gold.fact_sales
	WHERE [Order Date] IS NOT NULL
	GROUP BY DATETRUNC(MONTH,[Order Date])
	) t
--10. Part to Whole Analysis

--Which categories contribute the most to overall sales ?
WITH category_sales AS (
	SELECT
		p.Category AS Category,
		SUM(f.[Sales Amount]) AS [Total Sales]
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.Product_Key = p.Product_Key
	GROUP BY p.Category
)
SELECT
	Category,
	[Total Sales],
	SUM([Total Sales]) OVER() AS [Overall Sales],
	CONCAT(ROUND((CAST([Total Sales] AS float)/SUM([Total Sales]) OVER()) * 100, 2), '%') AS [Percentage of Total]
FROM category_sales
ORDER BY [Total Sales] DESC
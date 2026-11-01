--9. Performance Analysis

/* Analyze the yearly performance of products by comparing their sales
to both the average sales performance of the product and the previous year's sales*/
WITH yearly_product_sales AS
(	SELECT
		YEAR(f.[Order Date]) AS [Order Year],
		p.Product_name AS [Product Name],
		SUM(f.[Sales Amount]) AS [Current Sales]
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.Product_Key = p.Product_Key
	WHERE YEAR(f.[Order Date]) IS NOT NULL
	GROUP BY YEAR(f.[Order Date]), p.Product_name)
SELECT
	[Order Year],
	[Product Name],
	[Current Sales],
	AVG([Current Sales]) OVER(PARTITION BY [Product Name]) [Average Sales],
	[Current Sales] - AVG([Current Sales]) OVER(PARTITION BY [Product Name]) AS [Diff with Avg],
	CASE WHEN [Current Sales] - AVG([Current Sales]) OVER(PARTITION BY [Product Name]) > 0 THEN 'Above Avg'
		 WHEN [Current Sales] - AVG([Current Sales]) OVER(PARTITION BY [Product Name]) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END Change,
--Year-over-Year Analysis
	LAG([Current Sales]) OVER(PARTITION BY [Product Name] ORDER BY [Order Year]) [PY Sales],
	[Current Sales] - LAG([Current Sales]) OVER(PARTITION BY [Product Name] ORDER BY [Order Year]) AS [Diff with PY],
	CASE WHEN [Current Sales] - LAG([Current Sales]) OVER(PARTITION BY [Product Name] ORDER BY [Order Year]) > 0 THEN 'Increase'
		 WHEN [Current Sales] - LAG([Current Sales]) OVER(PARTITION BY [Product Name] ORDER BY [Order Year]) < 0 THEN 'Decrease'
		 ELSE 'No Change'
	END Change
FROM yearly_product_sales
ORDER BY [Product Name],[Order Year]
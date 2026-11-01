--3.DATE EXPLORATION

--Find the date of the first and last order
--How many years of sales are available
SELECT
	MIN([Order Date]) AS [First Order Date],
	MAX([Order Date]) AS [Last Order Date],
	DATEDIFF(year, MIN([Order Date]), MAX([Order Date])) AS [Order Range Year]
FROM gold.fact_sales

--Find the youngest and the oldest customer
SELECT
	MIN(Birthdate) AS [Oldest Birthdate],
	DATEDIFF(Year, MIN(Birthdate), GETDATE()) AS [Oldest Age],
	MAX(Birthdate) AS [Youngest Birthdate],
	DATEDIFF(Year, MAX(Birthdate), GETDATE()) AS [Youngest Age]
FROM gold.dim_customers
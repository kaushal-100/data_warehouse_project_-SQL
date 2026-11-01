--4. MEASURE EXPLORATION

--Find the Total Sales
SELECT SUM([Sales Amount]) AS [Total Sales]
FROM gold.fact_sales

--Find how many items are sold
SELECT SUM(Quantity) AS [Total Items]
FROM gold.fact_sales

--Find the average selling price
SELECT AVG(Price) AS [Average Seling Price]
FROM gold.fact_sales

--find the total number of orders
SELECT 
	COUNT([Order Number]) AS [Total Orders],
	COUNT(DISTINCT [Order Number]) AS [Total Distinct Orders]
FROM gold.fact_sales

--Find the total number of products
SELECT 
	COUNT([Product_Key]) AS [Total Products]
FROM gold.dim_products

--find the total number of customers
SELECT
	COUNT(Customer_key) AS [Total Customers]
FROM gold.dim_customers;

--Find the total number of customers who have actually placed an order
SELECT
	COUNT(DISTINCT Customer_key) AS [Total Customers]
FROM gold.fact_sales


--Generate a report that shows all key metrics of the business

SELECT 'Total Sales' AS [Measure Name],
		SUM([Sales Amount]) AS [Total Sales]
FROM gold.fact_sales
UNION ALL
SELECT 'Total Items', SUM(Quantity)
FROM gold.fact_sales
UNION ALL
SELECT 'Average Seling Price', AVG(Price)
FROM gold.fact_sales
UNION ALL
SELECT 
	'Total Distinct Orders', COUNT(DISTINCT [Order Number])
FROM gold.fact_sales
UNION ALL
SELECT 
	'Total Products', COUNT([Product_Key])
FROM gold.dim_products
UNION ALL
SELECT
	'Total Customers', COUNT(Customer_key)
FROM gold.dim_customers
UNION ALL
SELECT
	'Total Customers with Orders', COUNT(DISTINCT Customer_key)
FROM gold.fact_sales
--2. DIMENSIONS EXPLORATION

--Explore all countries our customers come from
SELECT DISTINCT country
FROM gold.dim_customers

--Explore all categories "The Major Divisions"
SELECT DISTINCT Category, Subcategory, Product_name
FROM gold.dim_products
ORDER BY 1,2,3
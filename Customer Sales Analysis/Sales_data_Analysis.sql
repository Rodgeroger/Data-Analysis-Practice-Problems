/*Show all the data*/
SELECT * 
FROM sales_data;


/*Calculate total sales for each category order by most sales*/
SELECT 
	category AS Category,
    	ROUND(SUM(quantity * unit_price), 2) AS total_sales
FROM sales_data
GROUP BY product, category
ORDER by total_sales DESC;


/*Find the top 5 customers by total spending*/
SELECT TOP 5
	customer_id,
    	ROUND(SUM(quantity * unit_price), 2) AS total_spent
FROM sales_data
GROUP BY customer_id
ORDER BY total_spent DESC;


/*Determine which region had the highest average order value.*/
--cte to find amount of orders per region
WITH Amount_of_Orders_per_region AS
	(SELECT
		COUNT(*) AS Amount_of_Orders,
		region
	FROM sales_data
	GROUP BY region)
SELECT TOP 1
	sd.region,
    	ROUND(AVG(quantity * unit_price), 2) AS avg_order_value
	ar.Amount_of_Orders
FROM sales_data AS sd
JOIN Amount_of_Orders_per_region AS ar
ON sd.region = ar.region
GROUP BY sd.region, ar.Amount_of_Orders
ORDER BY avg_order_value DESC;


/*Identify the month with the highest sales overall.*/
--cte to find amount of orders per month
/* Identify the month with the highest sales overall using a CTE */
WITH Amount_of_Sales_By_Month AS 
	(SELECT
		FORMAT(order_date, 'yyyy-MM') AS order_month,
		COUNT(*) AS Amount_of_Orders
	FROM sales_data
	GROUP BY FORMAT(order_date, 'yyyy-MM'))
SELECT TOP 1
	sd_month.order_month,
	ROUND(SUM(sd.quantity * sd.unit_price), 2) AS total_sales,
	am.Amount_of_Orders
FROM sales_data sd
JOIN Amount_of_Sales_By_Month am
ON FORMAT(sd.order_date, 'yyyy-MM') = am.order_month
GROUP BY sd_month.order_month, am.Amount_of_Orders
ORDER BY total_sales DESC;


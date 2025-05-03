/*Show all the data*/
SELECT * 
FROM sales_data;

/*Calculate total sales for each category order by most sales*/
SELECT 
	product AS Product,
	category AS Category,
	SUM(unit_price) as 'Total Sales'
FROM sales_data
GROUP BY product, category
ORDER by 'Total Sales' DESC;

/*Find the top 5 customers by total spending*/
SELECT TOP 5
	customer_id,
	sum(unit_price) as 'Total Spending'
FROM sales_data
GROUP BY customer_id
ORDER BY 'Total Spending' DESC;

/*Determine which region had the highest average order value.*/
--cte to find amount of orders per region
WITH Amount_of_Orders_per_region AS
	(SELECT
		COUNT(*) AS 'Amount of Orders',
		region
	FROM sales_data
	GROUP BY region)
SELECT TOP 1
	sd.region,
	ROUND(AVG(unit_price),2) AS 'Average Order Value',
	ar.[Amount of Orders]
FROM sales_data AS sd
JOIN Amount_of_Orders_per_region AS ar
ON sd.region = ar.region
GROUP BY sd.region, ar.[Amount of Orders]
ORDER BY 'Average Order Value' DESC;

/*Identify the month with the highest sales overall.*/
--cte to find amount of orders per month
WITH Amount_of_Sales_By_Month AS 
	(SELECT
		COUNT(*) AS 'Amount of Orders',
		MONTH(order_date) AS Month
	FROM sales_data
	GROUP BY MONTH(order_date)
	)
SELECT TOP 1
	MONTH(sd.order_date) AS Month,
	SUM(sd.unit_price) AS 'Overall Sales',
	am.[Amount of Orders]
FROM sales_data AS sd
JOIN Amount_of_Sales_By_Month AS am
ON MONTH(sd.order_date) = am.month
GROUP BY MONTH(sd.order_date), am.[Amount of Orders]
ORDER BY 'Overall Sales' DESC

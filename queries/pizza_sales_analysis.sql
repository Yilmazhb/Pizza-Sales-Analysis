USE Pizza;


-- 1. Average Order Value
SELECT (SUM(total_price) / COUNT(DISTINCT order_id)) AS Avg_order_Value FROM pizza_sales



-- 2. Average Pizzas Per Order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
  CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
  AS Avg_Pizzas_per_order
  FROM pizza_sales


-- 3. Best selling pizza categories
SELECT 
    pizza_category,
    COUNT(*) as pizza_count,
    SUM(quantity) as total_quantity,
    SUM(total_price) as total_revenue,
    ROUND(SUM(total_price) / SUM(SUM(total_price)) OVER() * 100, 2) as revenue_percentage
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_revenue DESC;


-- 4. Top 5 Pizzas by Revenue   
SELECT Top 5 pizza_name, SUM(total_price) AS Total_Revenue
    FROM pizza_sales
    GROUP BY pizza_name
    ORDER BY Total_Revenue DESC;


-- 5. Bottom 5 Pizzas by Revenue
SELECT Top 5 pizza_name, SUM(total_price) AS Total_Revenue
    FROM pizza_sales
    GROUP BY pizza_name
    ORDER BY Total_Revenue ASC;


-- 6. Top 5 Pizzas by Total Orders
SELECT Top 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
    FROM pizza_sales
    GROUP BY pizza_name
    ORDER BY Total_Orders DESC


-- 7. Most profitable pizza sizes
SELECT 
    pizza_size,
    COUNT(*) as pizza_count,
    SUM(total_price) as total_revenue,
    ROUND(AVG(unit_price), 2) as average_price,
    ROUND(SUM(total_price) / SUM(quantity), 2) as revenue_per_pizza,
    ROUND(SUM(total_price) * 100.0 / SUM(SUM(total_price)) OVER(), 2) as revenue_percentage
FROM pizza_sales
GROUP BY pizza_size
ORDER BY total_revenue DESC;



-- 8. Monthly revenue development
SELECT 
    FORMAT(order_date, 'MMMM', 'en-US') AS Month_Name_EN,
    COUNT(DISTINCT order_id) AS Total_Orders,
    SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY FORMAT(order_date, 'MMMM', 'en-US'), MONTH(order_date)
ORDER BY MONTH(order_date);


-- 9. Weekly sales performance
SELECT 
    YEAR(CAST(order_date AS DATE)) as year,
    DATEPART(WEEK, CAST(order_date AS DATE)) as week_number,
    MIN(CAST(order_date AS DATE)) as week_start,
    COUNT(DISTINCT order_id) as order_count,
    SUM(total_price) as weekly_revenue
FROM pizza_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(CAST(order_date AS DATE)), DATEPART(WEEK, CAST(order_date AS DATE))
ORDER BY year, week_number;

SELECT * FROM pizza_sales;



-- 10. Best ordering times by hour
SELECT 
    DATEPART(HOUR, CAST(order_time AS TIME)) as hour,
    CASE 
        WHEN DATEPART(HOUR, CAST(order_time AS TIME)) BETWEEN 6 AND 11 THEN 'Morning (6-11)'
        WHEN DATEPART(HOUR, CAST(order_time AS TIME)) BETWEEN 12 AND 17 THEN 'Afternoon (12-17)'
        WHEN DATEPART(HOUR, CAST(order_time AS TIME)) BETWEEN 18 AND 23 THEN 'Evening (18-23)'
        ELSE 'Night (0-5)'
    END as time_period,
    COUNT(DISTINCT order_id) as order_count,
    COUNT(*) as pizza_count,
    SUM(total_price) as total_revenue,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM pizza_sales
WHERE order_time IS NOT NULL
GROUP BY DATEPART(HOUR, CAST(order_time AS TIME))
ORDER BY order_count DESC;



-- 11. Average order value by weekday
SELECT 
    CASE 
        WHEN DATEPART(WEEKDAY, order_date) = 1 THEN 'Sunday'
        WHEN DATEPART(WEEKDAY, order_date) = 2 THEN 'Monday'
        WHEN DATEPART(WEEKDAY, order_date) = 3 THEN 'Tuesday'
        WHEN DATEPART(WEEKDAY, order_date) = 4 THEN 'Wednesday'
        WHEN DATEPART(WEEKDAY, order_date) = 5 THEN 'Thursday'
        WHEN DATEPART(WEEKDAY, order_date) = 6 THEN 'Friday'
        WHEN DATEPART(WEEKDAY, order_date) = 7 THEN 'Saturday'
    END as weekday,
    COUNT(DISTINCT order_id) as order_count,
    ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 2) as average_order_value,
    ROUND(AVG(pizza_per_order), 2) as average_pizzas_per_order
FROM (
    SELECT 
        order_id,
        order_date,
        SUM(total_price) as total_price,
        COUNT(*) as pizza_per_order
    FROM pizza_sales
    WHERE order_date IS NOT NULL
    GROUP BY order_id, order_date
) as orders
GROUP BY DATEPART(WEEKDAY, order_date)
ORDER BY COUNT(DISTINCT order_id) DESC;


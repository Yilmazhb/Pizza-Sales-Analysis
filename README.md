# Pizza Sales Analysis

## Technologies Used:
Tool: Microsoft SQL
Skills: aggregation functions, Case, date/time functions, AOV, Data Transformation

## Business Problem
While the restaurant has been successfully serving its customers, management lacks a deep, data-driven understanding of their own business performance. They are operating with intuition rather than insight, which makes it difficult to make strategic decisions. In essence, the business is sitting on a goldmine of data but lacks the capability to extract meaningful patterns and insights from it, hindering their growth, profitability, and operational efficiency.

## Solution 
To address these challenges, we will conduct a comprehensive analysis of the pizza sales data. The goal is to transform raw data into actionable insights that can directly inform business strategy. This project will ultimately empower the business to move from operating on guesswork to making informed, strategic decisions that drive growth and efficiency.

## Questions:
## 1. What is the average order value?
```sql
  SELECT(SUM(total_price) / COUNT(DISTINCT order_id)) AS Avg_order_Value FROM pizza_sales.
```
### Result:
<img width="128" height="38" alt="Screenshot 2025-11-30 220254" src="https://github.com/user-attachments/assets/5cb4467d-81dd-48a8-83ea-1faf3d7c4632" />


The average order value serves as a fundamental basis for assessing the financial health of the business. A rising AOV indicates that customers are spending more per transaction, which directly increases profitability without the need to acquire new customers.

## 2. What is the average number of pizzas per order?
```sql
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
AS Avg_Pizzas_per_order
FROM pizza_sales
```
### Result:
<img width="154" height="41" alt="Screenshot 2025-11-30 214702" src="https://github.com/user-attachments/assets/009e47e6-1a73-4b1f-a0d8-4239149af15a" />

In sales and marketing, this metric reveals potential for improvement. If the value is close to 1.0, this could represent an opportunity for targeted upselling, for example by promoting combination offers or additional products. At the same time, it is an important early indicator of changes in customer behaviour a falling value could indicate changing eating habits or an unfavourable pricing policy.

## 3. What are the best selling pizza categories?
```sql
SELECT 
    pizza_category,
    COUNT(*) as pizza_count,
    SUM(quantity) as total_quantity,
    SUM(total_price) as total_revenue,
    ROUND(SUM(total_price) / SUM(SUM(total_price)) OVER() * 100, 2) as revenue_percentage
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_revenue DESC;
```
### Result:
<img width="470" height="96" alt="Screenshot 2025-11-30 205044" src="https://github.com/user-attachments/assets/e445cf98-b393-4aa5-84d3-3a40a42af098" />

This analysis forms a fundamental basis for strategic decisions in the areas of menu engineering, pricing policy and marketing. It helps to focus resources on the most profitable categories while identifying potential for less successful categories.

## 4. What are the top five pizzas by revenue?
```sql
 SELECT Top 5 pizza_name, SUM(total_price) AS Total_Revenue
    FROM pizza_sales
    GROUP BY pizza_name
    ORDER BY Total_Revenue DESC
```
### Result:
<img width="275" height="114" alt="Screenshot 2025-12-01 171748" src="https://github.com/user-attachments/assets/5163d5f5-9140-49aa-b95b-d74ab44fa19e" />

This analysis identifies the absolute sales champions in the pizza range the five pizzas that make the highest financial contribution to the business's success. The query produces a clear ranking of the most profitable pizza varieties based on their cumulative total sales.

## 5. What are the bottom five pizzas by revenue?
```sql
SELECT Top 5 pizza_name, SUM(total_price) AS Total_Revenue
    FROM pizza_sales
    GROUP BY pizza_name
    ORDER BY Total_Revenue ASC
```
### Result: 
<img width="269" height="112" alt="Screenshot 2025-12-01 173059" src="https://github.com/user-attachments/assets/0953cf4f-e414-40f7-b3a5-ffd9aa7808c1" />

This analysis identifies the weakest revenue generators in the pizza range, the five pizzas that make the smallest financial contribution to the business's success. In contrast to the previous query, which showed the top performers, this evaluation reveals the ‘underperformers’ or problem children on the menu.

## 6. Which pizzas rank in the top 5 based on total orders?
```sql
SELECT Top 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
    FROM pizza_sales
    GROUP BY pizza_name
    ORDER BY Total_Orders DESC
```
### Result:
<img width="261" height="113" alt="Screenshot 2025-12-01 173622" src="https://github.com/user-attachments/assets/dc31846a-d1f4-45a2-b98c-143e3f741715" />

This analysis identifies the most popular pizzas in the range based on their pure order frequency,  the five pizzas that are most frequently requested by customers. In contrast to the sales analysis, which looks at financial value, this metric measures pure popularity and customer demand.

## 7. What are the most profitable pizza sizes?
```sql
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
```
### Result:
<img width="547" height="117" alt="Screenshot 2025-12-01 133402" src="https://github.com/user-attachments/assets/47374561-5829-4e4f-a425-80928cd2720e" />

These findings are of strategic importance for pricing policy, product range design and marketing. They help to focus resources on the most profitable sizes, optimise pricing strategies (incentives to buy larger pizzas) and plan production in line with value-creating demand.

## 8. What does the analysis of monthly revenue development reveal about business performance?
```sql
SELECT 
    FORMAT(order_date, 'MMMM', 'en-US') AS Month_Name_EN,
    COUNT(DISTINCT order_id) AS Total_Orders,
    SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY FORMAT(order_date, 'MMMM', 'en-US'), MONTH(order_date)
ORDER BY MONTH(order_date);
```

### Result:
<img width="295" height="247" alt="Screenshot 2025-12-01 160653" src="https://github.com/user-attachments/assets/da71dbc6-da15-4c37-b3cd-174d23ce78cc" />

This monthly analysis is crucial for strategic planning. It helps identify seasonal patterns, plan marketing campaigns (e.g. special offers in slower months), plan staffing (additional requirements during peak periods) and budget. It also enables comparisons with previous years' months to measure growth or decline and make informed forecasts for the future.

## 9. Which hours are best for placing orders?
```sql
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
```

## Result:
<img width="396" height="302" alt="Screenshot 2025-12-01 161044" src="https://github.com/user-attachments/assets/eca20574-60ef-435d-9d4b-03b5c37d889b" />

This analysis provides a detailed hourly and daily breakdown of the pizza restaurant's total business activity. It shows not only when orders are received, but also how order volume, pizza quantity, revenue and market share are distributed throughout the day.

## 10. What is the average order value by weekday?
```sql
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
```

## Result:
<img width="291" height="151" alt="Screenshot 2025-12-01 225312" src="https://github.com/user-attachments/assets/14efe67e-1717-417f-91bb-1ed16bb975b9" />

This analysis provides a comprehensive weekly performance overview and shows how business activity, customer behaviour and sales potential are distributed across the seven days of the week. Unlike pure order statistics, this evaluation combines several key figures to paint a complete picture of the weekly structure.

# Conclusion of the analysis
The analysis of pizza orders provides a comprehensive and differentiated picture of business performance that goes far beyond simple sales figures. The insights gained form a solid basis for data-driven decisions in almost all areas of the company.

The key findings reveal a clear pattern: the business is dominated by a few crucial factors. Large pizzas prove to be the real revenue drivers, while the classic category forms the backbone of the product range. The distribution over time reveals a pronounced weekend and evening dominance, with Friday and Saturday evenings representing the absolute peak business times.

In terms of customer preferences, an interesting dualism emerges: on the one hand, there are a handful of premium pizzas that generate the majority of sales, while on the other hand, there are volume pizzas that top the popularity scale due to their frequency in orders. This differentiation between ‘what brings in money’ and ‘what customers frequently choose’ is crucial for a balanced menu strategy.

Ultimately, the analysis shows that success in the pizza business depends on a balanced interplay: the right products in the right sizes, at the right time, at the right prices, guided by data-driven insights rather than gut feeling. This analysis transforms raw data into concrete actionable knowledge, laying the foundation for sustainable growth and increased profitability.



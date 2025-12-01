# Pizza Sales Analysis

## Business Problem
While the restaurant has been successfully serving its customers, management lacks a deep, data-driven understanding of their own business performance. They are operating with intuition rather than insight, which makes it difficult to make strategic decisions. In essence, the business is sitting on a goldmine of data but lacks the capability to extract meaningful patterns and insights from it, hindering their growth, profitability, and operational efficiency.

## Solution 
To address these challenges, we will conduct a comprehensive analysis of the pizza sales data. The goal is to transform raw data into actionable insights that can directly inform business strategy. This project will ultimately empower the business to move from operating on guesswork to making informed, strategic decisions that drive growth and efficiency.

## Questions
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

## 4. What are the most profitable pizza sizes?
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

## 5. What does the analysis of monthly revenue development reveal about business performance?
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


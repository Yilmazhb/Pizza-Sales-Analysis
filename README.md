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

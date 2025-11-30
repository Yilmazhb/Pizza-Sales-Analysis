# Pizza Sales Analysis

## Business Problem
While the restaurant has been successfully serving its customers, management lacks a deep, data-driven understanding of their own business performance. They are operating with intuition rather than insight, which makes it difficult to make strategic decisions. In essence, the business is sitting on a goldmine of data but lacks the capability to extract meaningful patterns and insights from it, hindering their growth, profitability, and operational efficiency.

## Solution 
To address these challenges, we will conduct a comprehensive analysis of the pizza sales data. The goal is to transform raw data into actionable insights that can directly inform business strategy. This project will ultimately empower the business to move from operating on guesswork to making informed, strategic decisions that drive growth and efficiency.

## Questions

## 1. Best selling pizza categories
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
### Reult:
<img width="470" height="96" alt="Screenshot 2025-11-30 205044" src="https://github.com/user-attachments/assets/e445cf98-b393-4aa5-84d3-3a40a42af098" />
Sorting by total sales in descending order provides a clear ranking of the most profitable categories. For example, the result could show that the ‘Classic’ category generates the highest share of sales at 35%, followed by ‘Supreme’ at 28%, while “Veggie” pizzas may only contribute 20% and ‘Chicken’ varieties 17% to total sales.

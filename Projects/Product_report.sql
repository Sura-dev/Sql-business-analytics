/*
Product Report

Purpose:
      - This report consolidates key product metrics and behaviors

Highlights:
       1, Gathers essential fields such as product_name, category , subcategory, and cost
       2, Segments products by revenu to identify High-Performers, Mid-Range, or Low-Performers
       3,Aggregates product-level metrics:
           - total orders
           - total sales
           - total quantity sold
           - total customers (unique)
           - lifespan (in months)
        4,Calculates valuable KPIs:
            - recency (months since last sale)
            - average order revenue (AOR)
            - average monthly revenue

*/
---1) Base Query: Retrieves core columns from fact_sales and dim_products
 
--CREATE VIEW gold.product_report AS 
WITH essential_info AS(
select 
order_number,
gdp.product_key,
customer_key,
order_date,
sales_amount,
quantity,
product_number,
product_name,
category_id,
category,
subcategory,
cost
from gold_fact_sales gfs 
LEFT JOIN gold_dim_products gdp 
ON gfs.product_key=gdp.product_key

)

--2) Product Aggregations : Summarizes key metrics at the product level
, product_level_aggregation AS(
select 
product_key,
product_name,
category,
subcategory,
cost,
MAX(order_date) last_date,
DATEDIFF(month,MIN(order_date),MAX(order_date)) lifespan,
COUNT(DISTINCT order_number) AS total_orders,
COUNT(DISTINCT customer_key) Total_customer,
SUM(sales_amount) total_sales,
SUM(quantity) Total_quantity,
ROUND(AVG(CAST(sales_amount AS FLOAT)/ NULLIF(quantity,0)),1) Avg_selling_price
from essential_info
GROUP BY product_key,
product_name,
category,
subcategory,
cost
)

--3) Final Query: Combines all product results into one output

select *,
DATEDIFF(month,last_date,GETDATE()) recency_in_month,
CASE WHEN total_sales > 1000000 THEN 'High-performance'
     WHEN total_sales > 500000  THEN 'Mid-range'
     ELSE 'Low_performance'
END product_segment,
CASE WHEN total_orders = 0 THEN 0  
     ELSE total_sales / total_orders
END avg_order_revenu,
CASE WHEN lifespan = 0 THEN total_sales
     ELSE total_sales / lifespan
END avg_monthly_revenu
from product_level_aggregation





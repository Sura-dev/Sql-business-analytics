/*
Customer Report

Purpose:
     - This report consolidates key customer metrics and behaviors

  Highlights:
        1, Gathers essential fields such as names,ages and transaction details
        2,Segments customers in to categories (VIP, Regular, New) and age groups
        3.Aggregates customer-level metrics:
               - total orders
               - total sales
               - total quantity purchased
               - tottal products
               - lifespan (in months)
        4. Calculates valuable KPIs:
               - recency (months since last order)
               - average order value
               - average moonthly spend              
*/
---1)Base query: Retrieves core columns from tables

--CREATE VIEW gold.report_customers AS
WITH customer_purchasing AS(
SELECT 
gfs.order_number,
gfs.product_key,
gfs.order_date,
gfs.sales_amount,
gfs.quantity,
gdc.customer_key,
gdc.customer_number,
CONCAT(gdc.first_name,' ', gdc.last_name) AS customer_name,
DATEDIFF(year,gdc.birthdate,GETDATE()) Age
from gold_fact_sales gfs 
LEFT JOIN gold_dim_customers gdc
ON gdc.customer_key=gfs.customer_key
WHERE gdc.birthdate >= '1916-02-10' 
)

--2 Customer Aggregations: Summarizes key metrics at the customer level

, customer_aggregation AS (
select 
customer_key,
customer_number,
customer_name,
age,
COUNT(DISTINCT order_number) Total_orders,
SUM(sales_amount) Total_sales,
SUM(quantity) Total_quantity,
COUNT(DISTINCT product_key ) Total_products,
MIN(order_date) start_date,
MAX(order_date) last_date,
DATEDIFF(month,MIN(order_date),MAX(order_date)) lifespan
from  customer_purchasing
GROUP BY customer_key,customer_number,customer_name,age
)

--3, Calculates valuable KPIs

select 
customer_key,
customer_number,
customer_name,
age,
CASE WHEN age < 40 THEN 'under 40 '
     WHEN age BETWEEN 40 and 60 THEN '40-60'
     WHEN age BETWEEN 60 and 80 THEN '60-80'
     ELSE 'above 80'
END age_group,
CASE WHEN lifespan > 12 AND Total_sales > 5000 THEN 'VIP'
     WHEN lifespan < 12 AND Total_sales < 5000 THEN 'Regular'
     ELSE 'New'
END customer_status,
start_date,
last_date,
DATEDIFF(month, last_date,GETDATE()) recency,
total_orders,
total_sales,
total_quantity,
total_products,
lifespan,
-- compuate average order value (AVO)
CASE WHEN total_orders = 0 THEN 0
     ELSE total_sales / total_orders
END avg_order_value,
---compuate average monthly spend
CASE WHEN lifespan = 0 THEN total_sales
     ELSE total_sales / lifespan
END avg_monthly_spend
from customer_aggregation









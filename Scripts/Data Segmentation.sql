
/*
      # DATA SEGMENTATION

 > Segment products into cost ranges and count how many products fall into each segment
                                                                              */

WITH CTE_segmentation AS (
SELECT 
product_key,
product_name,
cost,
CASE WHEN cost < 100 THEN 'below 100'
     WHEN cost <= 500 THEN '100-500'
     WHEN cost <= 1500 THEN '501-1500'
     ELSE 'Above 1501'
END cost_range
from gold_dim_products gdp 
)

select cost_range,
COUNT(product_key)  num_products
from CTE_segmentation
GROUP BY cost_range
ORDER BY num_products DESC



/*

 > Group customers in to threee segments based on their spending behavio:
       Vip: at least 12 months of history and spending more that 5000
       Regular: at least 12 months of history but spending 5000 or less
       New:lifespan less than 12 months
   And find the total number of customers by each group

                                                                                 */

WITH CTE_customer_status AS (

select 
gfs.customer_key,
SUM(sales_amount) Total_sales,
MIN(order_date) first_date,
MAX(order_date) last_date,
DATEDIFF(month,MIN(order_date),MAX(order_date)) lifespan
from gold_fact_sales gfs 
LEFT JOIN gold_dim_customers gdc 
ON gfs.customer_key = gdc.customer_key 
GROUP BY gfs.customer_key
)

select
customer_status,
COUNT(customer_key) num_customer
from(
select *,
CASE WHEN lifespan > 12 AND Total_sales > 5000 THEN 'VIP'
     WHEN lifespan < 12 AND Total_sales < 5000 THEN 'Regular'
     ELSE 'New'
END customer_status
from CTE_customer_status
)t
GROUP BY customer_status
ORDER BY num_customer DESC

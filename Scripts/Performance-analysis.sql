

/*
     ##PERFORMANCE ANALYSES

   Analyze the yearly performance of products by comparing each product's sales to both its average sales performance and 
   the previous year's sales          
                                                                                 */
WITH CTE_Performance_indicator AS (
select 
year(order_date) order_year,
gdp .product_name,
SUM(sales_amount) current_sale
from gold_fact_sales gfs 
LEFT JOIN gold_dim_products gdp 
ON gfs.product_key=gdp.product_key
WHERE order_date > '2012-12-30'
GROUP BY year(order_date),gdp.product_name
)


select *,
AVG(current_sale) over(PARTITION BY product_name) Avg_sales,
current_sale - AVG(current_sale) over(PARTITION BY product_name) avg_diff,
CASE WHEN current_sale - AVG(current_sale) over(PARTITION BY product_name) > 0 THEN 'above'
     WHEN current_sale - AVG(current_sale) over(PARTITION BY product_name) < 0 THEN 'below'
     ELSE 'Avg'
END avg_change,
LAG(current_sale) over(PARTITION BY product_name ORDER BY order_year) previous_sales,
current_sale - LAG(current_sale) over(PARTITION BY product_name ORDER BY order_year) yoy_performance,
CASE WHEN current_sale - LAG(current_sale) over(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'increasing'
     WHEN current_sale - LAG(current_sale) over(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'decreasing'
     ELSE 'no change'
END yoy_change
from CTE_Performance_indicator
ORDER BY product_name,order_year






















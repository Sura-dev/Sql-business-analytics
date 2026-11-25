
/*
   #Ranking Analysis 
 > Find the top 10 customers who have generated the highest revenue
                                                                                  */
select TOP(10)
gfs.customer_key,
gdc.first_name ,
SUM(gfs.sales_amount) Revenu
from gold_fact_sales gfs 
LEFT JOIN  gold_dim_customers gdc
ON gdc.customer_key=gfs.customer_key
GROUP BY gfs.customer_key,gdc.first_name 
ORDER BY Revenu DESC

/* 
> The 3 customers with the fewest order placed                                     */

select TOP(3)
gdc.customer_key,
gdc.first_name ,
--gfs.order_number Orders,
COUNT(DISTINCT gfs.order_number ) num_order
from  gold_fact_sales gfs 
LEFT JOIN gold_dim_customers gdc 
ON gdc.customer_key=gfs.customer_key
GROUP BY gdc.customer_key,gdc.first_name,gfs.order_number 
ORDER BY num_order


---which 5 products generate the highest revenue?

SELECT 
* from(
select --TOP(5)
gdp.product_name,
SUM(sales_amount) Total_revenu,
RANK() over(ORDER BY SUM(sales_amount) DESC) RANK_revenu
from gold_fact_sales gfs 
LEFT JOIN gold_dim_products gdp 
ON gfs.product_key=gdp.product_key
GROUP BY gdp.product_name
--ORDER BY Total_revenu  DESC
)t WHERE RANK_revenu < 6

--What are the 5 worst-performing products in terms of sales??

select TOP(5)
gdp.subcategory, 
--gdp.product_name,
gfs.sales_amount Sales
from gold_fact_sales gfs 
LEFT JOIN gold_dim_products gdp 
ON gfs.product_key = gdp.product_key 
GROUP BY gdp.subcategory,gfs.sales_amount 
ORDER BY Sales 


select 
select TOP(10)
gfs.customer_key,
gfs.sales_amount Revenu
--COUNT(gfs.order_number ) num_order
from gold_dim_customers gdc 
INNER JOIN gold_fact_sales gfs 
ON gdc.customer_key=gfs.customer_key
GROUP BY gfs.customer_key,gfs.sales_amount 
ORDER BY Revenu DESC







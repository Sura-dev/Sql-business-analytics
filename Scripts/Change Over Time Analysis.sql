

/*
    ##CHNAGE OVER TIME ANALYSES

 > Analyse sales performance over time   */

select 
YEAR(order_date),
month(order_date),
--DATETRUNC(month,order_date),
--FORMAT(order_date,'yyyy-MMM'),
SUM(sales_amount) Total_sale,
COUNT(DISTINCT customer_key) Total_customer,
SUM(quantity) total_quantity
from gold_fact_sales gfs 
WHERE order_date >= '2010-12-29'
GROUP BY YEAR(order_date),month(order_date)
ORDER BY YEAR(order_date),month(order_date)


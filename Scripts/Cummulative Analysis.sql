

/*
    ##COMMULATIVE ANALYSES

> calculate the total sales per month and the running total of sales over time  */

SELECT 
order_date,
Total_sales,
SUM(Total_sales) over(ORDER BY order_date) Running_commulative_sales
--SUM(Total_sales) over(PARTITION BY order_date ORDER BY order_date) Running_commulative_sales
--DATETRUNC(month,order_date))
from(
select
order_date,
--year(order_date) order_date,
SUM(sales_amount) Total_sales
from gold_fact_sales gfs 
WHERE order_date >= '2010-12-29'
GROUP BY order_date --year(order_date) 
)t
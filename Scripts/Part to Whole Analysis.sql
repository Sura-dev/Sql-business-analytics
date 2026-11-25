
/*
      # PART TO WHOLE Analysis

 > Which categories contribute the most to overall sales??                          */

WITH CTE_overall_contribution AS (
select 
gdp.category ,
SUM(sales_amount) Total_sale
from gold_fact_sales gfs 
LEFT JOIN gold_dim_products gdp 
ON gdp.product_key = gfs.product_key 
GROUP BY gdp.category
)


select *,
SUM(Total_sale) over() over_all_sale,
ROUND(Total_sale / CAST(SUM(Total_sale) over() AS float),3) indidvidual_cont,
CONCAT(ROUND(Total_sale / CAST(SUM(Total_sale) over() AS float),3) *100,'%') BY_PERCENT
from CTE_overall_contribution

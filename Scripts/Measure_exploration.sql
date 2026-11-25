/*   
       # Measure Exploration
                                                                          */

 --Find the Total Sales           
 select 'Total sales' AS measure_name ,SUM(sales_amount)  AS measure_valuefrom from gold_fact_sales
 UNION ALL  
 select 'Total Quantity',SUM(quantity) from gold_fact_sales gfs   
 --Find how many items are sold
 UNION ALL
 select 'Average Price',AVG(price) from gold_fact_sales gfs       
 --Find the average selling price
 UNION ALL 
 select 'Total Nr. Orders',COUNT(DISTINCT order_number) from gold_fact_sales gfs    
 --Find the Total number of orders
 UNION ALL
 select 'Total Nr. products',COUNT(product_key) from gold_dim_products gdp        
 --Find the Total number of products
 UNION ALL
 select 'Total Nr. Customers',COUNT(customer_key)  from gold_dim_customers gdc      
 --Find the total number of customers
 UNION ALL
 select 'Total_orders_by_customers',COUNT(DISTINCT gdc.customer_key) from gold_dim_customers gdc     
 --Find the total number of customers that has placed an order
 INNER JOIN gold_fact_sales gfs 
 ON gdc.customer_key = gfs.customer_key 
 
 select COUNT(DISTINCT customer_key) from gold_fact_sales gfs 
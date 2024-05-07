/*
1. Your company loads sales data in a table named sales with columns product_id, customer_id, sale_date, and sale_amount. You want to identify the top 5 customers by total sales amount on each product category in the last quarter ,assume Q4 of 2024 .Write a SQL query to achieve this using window functions.

The following answer uses PostGreSQL
*/
CREATE TABLE sales (
  product_id INT,
  customer_id INT,
  sale_date DATE,
  sale_amount DECIMAL(10,2)
);

INSERT INTO sales (product_id, customer_id, sale_date, sale_amount)
VALUES (1, 101, '2024-04-20', 100.00),
       (1, 102, '2024-03-15', 50.00),
       (1, 103, '2024-04-01', 75.00),
       (1, 104, '2024-04-25', 150.00),
       (1, 105, '2024-04-05', 125.00),
       (1, 106, '2024-04-10', 200.00),
       (1, 107, '2024-04-10', 80.00),
       (3, 101, '2024-03-20', 60.00),
       (3, 102, '2024-04-15', 90.00),
       (2, 101, '2024-04-20', 1001.00),
       (2, 102, '2024-04-15', 5800.00),
       (2, 103, '2024-04-01', 750.00),
       (2, 104, '2024-04-25', 1050.00),
       (2, 105, '2024-03-05', 1125.00),
       (2, 106, '2024-04-10', 2000.00),
       (2, 107, '2024-04-10', 180.00),
       (3, 104, '2024-03-20', 660.00),
       (3, 105, '2024-01-15', 90.00);

with filtered_sales as (
  select product_id,
  		customer_id,
  		sale_date,
  		sale_amount
  from sales
  where date_trunc('quarter', sale_date) = make_date( cast(extract(year from current_date) as integer), 10, 1 )
),
  
  partitioned_sum_sales as (
  select product_id,
          customer_id,
          sum( sale_amount ) over( partition by product_id, customer_id ) as total_sales
   from filtered_sales
   order by product_id, total_sales desc
 ),
 
 ranked_partitioned_sum_sales as (
   select product_id,
          customer_id,
   			total_sales,
   			rank() over( partition by product_id order by total_sales desc ) as rank_num
   from partitioned_sum_sales
   )
   
select product_id,
       customer_id,
       total_sales
from ranked_partitioned_sum_sales
where rank_num <= 5
;
/*
3. You have a table named order_items with columns order_id, product_id, and quantity. Write a SQL query that transforms this data into a pivoted format, showing the quantity of each product ordered for each order. The resulting table should have columns for order_id and separate columns for each distinct product_id with corresponding quantity values.Assume you have 4 products.

I would have preferred to solve this in dbt using jinja to dynamically leverage the Snowflake PIVOT function.
PostGreSQL was used for this response.

Dataset
*/

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT
);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 101, 2),
(1, 102, 1),
(2, 101, 1),
(2, 103, 5),
(3, 102, 3),
(3, 104, 2);

with pivoted_order_items as (
  select order_id,
  		sum( case when product_id = 101 then quantity  else 0 end) as product_101,
   		sum( case when product_id = 102 then quantity  else 0 end) as product_102,
    	sum( case when product_id = 103 then quantity  else 0 end) as product_103,
  		sum( case when product_id = 104 then quantity  else 0 end) as product_104
  from order_items
  group by order_id
 )
 
 select order_id,
 	product_101,
    product_102,
    product_103,
    product_104
 from pivoted_order_items
 order by order_id
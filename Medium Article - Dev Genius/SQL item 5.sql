/*
5. You have three tables: customers (customer details), orders (order information), and order_items (items within an order). Write a SQL query that finds the total number of orders placed by each customer in the last year (along with their customer name), excluding orders with a total amount less than $100. Utilize CTE .

This response uses PostgreSQL v15
*/

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL
);


INSERT INTO customers (customer_id, customer_name) VALUES
(1, 'Chou'),
(2, 'Mini'),
(3, 'Alex');

INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2024-04-20'),
(2, 1, '2023-04-26'),
(3, 2, '2024-04-26'),
(4, 3, '2023-04-20');

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, price) 
VALUES
(1, 1, 101, 1, 150),
(2, 2, 102, 1, 90),
(3, 3, 103, 2, 100),
(4, 4, 104, 2, 45);


with customer_order_details as (
  select orders.order_id,
  		orders.order_date,
  		customers.customer_id,
  		customers.customer_name,
  		order_items.order_item_id,
  		order_items.product_id,
  		order_items.quantity,
  		order_items.price
  from orders
  	left join order_items on orders.order_id = order_items.order_id
  	left join customers on orders.customer_id = customers.customer_id
  ),
  
customer_order_detail_line_totals as (
  select order_id,
    	order_date,
    	customer_id,
    	customer_name,
    	order_item_id,
    	product_id,
    	sum( quantity * price ) as item_order_total
  from customer_order_details
  group by order_id, order_date, customer_id, customer_name, order_item_id, product_id
),
    
customer_order_totals as (
  select order_id,
  		order_date,
 		customer_id,
 		customer_name,
  		sum( item_order_total ) as order_total
  from customer_order_detail_line_totals
  group by order_id, order_date, customer_id, customer_name
),

filtered_customer_order_totals as (
  select * from customer_order_totals
  where order_total >= 100
  and order_date >= current_date - 365
),

final_counted as (
  select customer_id,
  		customer_name,
  		count(*) as order_count
  from filtered_customer_order_totals
  group by customer_id, customer_name
)
  select * from final_counted
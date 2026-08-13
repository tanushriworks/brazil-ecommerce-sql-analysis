-- creating table customers
CREATE TABLE customers(
       customer_id VARCHAR(50) PRIMARY KEY,
	   customer_unique_id VARCHAR(50),
	   customer_zip_code_prefix INTEGER,
	   customer_city VARCHAR(100),
	   customer_state VARCHAR(100)
);  

SELECT * FROM customers
LIMIT 10;


DROP TABLE  IF EXISTS orders;
--creating table orders
CREATE TABLE IF NOT EXISTS orders(
       order_id VARCHAR(50) PRIMARY KEY,
	   customer_id VARCHAR(50),
	   order_status VARCHAR(30),
	   order_purchase_timestamp TIMESTAMP,
	   order_approved_at TIMESTAMP,
       order_delivered_carrier_date TIMESTAMP,
       order_delivered_customer_date TIMESTAMP,
       order_estimated_delivery_date TIMESTAMP
);

SELECT COUNT (*) FROM orders;


--creating table for items which are orderd
CREATE TABLE order_item(
       order_id VARCHAR(50),
	   order_item_id INTEGER,
       product_id VARCHAR(50),
       seller_id VARCHAR(50),
       shipping_limit_date TIMESTAMP,
       price NUMERIC(10,2),
       freight_value NUMERIC(10,2)
);

SELECT * FROM order_item
LIMIT 10;

SELECT COUNT(*) FROM order_item;


--creating table products
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INTEGER,
    product_description_length INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm NUMERIC(10,2),
    product_height_cm NUMERIC(10,2),
    product_width_cm NUMERIC(10,2)
);

SELECT * FROM products
LIMIT 10;
SELECT COUNT(*) FROM products;


--total orders by customers
SELECT 
    c.customer_id,
	c.customer_city,
	c.customer_state,
	COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
	c.customer_city,
	c.customer_state
ORDER BY total_orders DESC;	


--top 10 cities with highest sales
SELECT 
    c.customer_city,
	c.customer_state,
	COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
   ON c.customer_id = o.customer_id
GROUP BY
    c.customer_city,
	c.customer_state
ORDER BY total_orders DESC
LIMIT 10;


--total sales across all items
SELECT SUM(price) AS total_sales
FROM order_item;

SELECT 
    p.product_category_name,
	SUM(oi.price) AS total_sales
FROM order_item oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_sales DESC
LIMIT 10;


-- top 5 product categories with highest sales
SELECT
     p.product_category_name,
	 SUM(oi.price) AS total_sales
FROM order_item oi
JOIN productS p
     ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_sales DESC
LIMIT 5;


-- months with highest sales
SELECT
     DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
	 SUM(oi.price) AS total_sales
FROM order_item oi
JOIN orders o
     ON oi.order_id = o.order_id
GROUP BY DATE_TRUNC('month', order_purchase_timestamp)	 
ORDER BY total_sales DESC;


-- months with lowest sales
SELECT 
     DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
	 SUM(oi.price) AS total_sales
FROM order_item oi
JOIN orders o
     ON oi.order_id = o.order_id
GROUP BY DATE_TRUNC('month', order_purchase_timestamp)	 
ORDER BY total_sales ASC;	 


--states generating the most total sales
SELECT 
    SUM(oi.price) AS total_sales,
	c.customer_state
FROM order_item oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state	
ORDER BY total_sales DESC;
	

--top 10 customers spending the most money
SELECT 
    c.customer_id,
	SUM(oi.price)  AS total_sales
FROM order_item oi
JOIN orders o
    ON o.order_id = oi.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_sales DESC
LIMIT 10;


--states with the highest average item price
SELECT 
    c.customer_state,
	AVG(oi.price) AS avg_item_price
FROM order_item oi
JOIN orders o
    ON o.order_id = oi.order_id
JOIN customers c
    ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY avg_item_price DESC
LIMIT 10;


--customer states having more than 1000 customers
SELECT customer_state, COUNT(customer_id) AS customer_count
FROM customers
GROUP BY customer_state
HAVING COUNT(customer_id) > 1000
ORDER BY customer_count DESC;


--top 5 customer states by number of customers
SELECT customer_state , COUNT(customer_id) AS customer_count
FROM customers
GROUP BY customer_state
ORDER BY customer_count DESC
LIMIT 5;




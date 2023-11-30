-------------------------------
-- Restaurant Order Analysis --
-------------------------------

-- Select the restaurant_db database
USE restaurant_db;

-- **************************
-- Explore the items table
-- **************************

-- View the menu_items table
SELECT * FROM menu_items;

-- Find the number of items on the menu
SELECT COUNT(*) AS num_items
FROM menu_items;

-- The least expensive items on the menu: Edamame (5.00)
SELECT * FROM menu_items
ORDER BY price ASC;

-- The most expensive items on the menu: Shrimp Scampi (19.95)
SELECT * FROM menu_items
ORDER BY price DESC;  

-- How many Italian dishes are on the menu? : 9 Italian dishes
SELECT COUNT(*) FROM menu_items
WHERE category = 'Italian';

-- The least expensive Italian dishes: Spaghetti (14.50)
SELECT * FROM menu_items
WHERE category = 'Italian'
ORDER BY price;

-- The most expensive Italian dishes: Shrimp Scampi (19.95)
SELECT * FROM menu_items
WHERE category = 'Italian'
ORDER BY price DESC; 

-- How many dishes are in each category?
SELECT category, COUNT(menu_item_id) AS num_dishes
FROM menu_items
GROUP BY category;

-- What is the average dish price within each category?
SELECT category, AVG(price) AS avg_price
FROM menu_items
GROUP BY category;

-- **************************
-- Explore the orders table
-- **************************

-- View the order_details table
SELECT * FROM order_details;

-- What is the date range of the table?
SELECT MIN(order_date), MAX(order_date)
FROM order_details;

-- How many orders were made within this date range?
SELECT COUNT(distinct order_id) AS total_order
FROM order_details;

-- How many items were ordered within this date range?
SELECT COUNT(*) AS total_items
FROM order_details;

-- Which orders had the most number of items?
SELECT order_id, COUNT(item_id) AS num_item
FROM order_details
GROUP BY order_id
ORDER BY num_item DESC;

-- How many orders had more than 12 items?
SELECT COUNT(*) FROM
(SELECT order_id, COUNT(item_id) AS num_item
FROM order_details
GROUP BY order_id
HAVING num_item > 12
ORDER BY num_item DESC) AS num_orders;

-- **************************
-- Analyze customer behavior
-- **************************

-- Combine the menu_items and order_details tables into a single table
SELECT *
FROM order_details od
LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id; -- > [choose matching id FROM 2 tables]

-- The least ordered items and what categories were they in?
SELECT item_name, category, COUNT(order_details_id) AS num_purchases
FROM order_details od
LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY num_purchases ASC;

-- The most ordered items and what categories were they in?
SELECT item_name, category, COUNT(order_details_id) AS num_purchases
FROM order_details od
LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY num_purchases DESC; 

-- What were the top 5 orders that spent the most money?
SELECT order_id, SUM(price) AS total_spend
FROM order_details od
LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5;

-- View the details of the highest spend order
SELECT category, COUNT(item_id) AS num_items
FROM order_details od
LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id = 440
GROUP BY category;
    
-- View the details of the top 5 highest spend orders
SELECT order_id, category, COUNT(item_id) AS num_items
FROM order_details od
LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY order_id, category;

-- View more details of item name for each category from previous step
SELECT order_id, category, item_name, COUNT(item_id) AS num_items
FROM order_details od
LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY order_id, category, item_name;

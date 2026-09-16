
USE customer_sales_intelligence;
-- SELECT
--     o.customer_id,
--     c.customer_unique_id,
--     SUM(oi.price) AS total_revenue
-- FROM Orders o
-- JOIN Customers c
--     ON o.customer_id = c.customer_id
-- JOIN Order_Items oi
--     ON o.order_id = oi.order_id
-- GROUP BY
--     o.customer_id,
--     c.customer_unique_id
-- ORDER BY total_revenue DESC
-- LIMIT 10;

-- SELECT
--     o.customer_id,
--     c.customer_unique_id,
--     COUNT(DISTINCT o.order_id) AS total_orders
-- FROM Orders o
-- JOIN Customers c
--     ON o.customer_id = c.customer_id
-- GROUP BY
--     o.customer_id,
--     c.customer_unique_id
-- ORDER BY total_orders DESC
-- LIMIT 10;

-- SELECT
--     o.customer_id,
--     c.customer_unique_id,
--     COUNT(DISTINCT o.order_id) AS total_orders
-- FROM Orders o
-- JOIN Customers c
--     ON o.customer_id = c.customer_id
-- GROUP BY
--     o.customer_id,
--     c.customer_unique_id
-- HAVING COUNT(DISTINCT o.order_id) > 1
-- ORDER BY total_orders DESC
-- LIMIT 10;
-- SELECT
--     c.customer_unique_id,
--     COUNT(DISTINCT o.order_id) AS total_orders
-- FROM Orders o
-- JOIN Customers c
--     ON o.customer_id = c.customer_id
-- GROUP BY
--     c.customer_unique_id
-- HAVING COUNT(DISTINCT o.order_id) > 1
-- ORDER BY total_orders DESC
-- LIMIT 10;

-- SELECT
--     c.customer_unique_id,
--     MAX(o.order_purchase_timestamp) AS last_purchase_date
-- FROM Orders o
-- JOIN Customers c
--     ON o.customer_id = c.customer_id
-- GROUP BY
--     c.customer_unique_id
-- ORDER BY last_purchase_date ASC
-- LIMIT 10;

-- SELECT
--     c.customer_unique_id,
--     SUM(oi.price) AS total_revenue
-- FROM Orders o
-- JOIN Customers c
--     ON o.customer_id = c.customer_id
-- JOIN Order_Items oi
--     ON o.order_id = oi.order_id
-- GROUP BY
--     c.customer_unique_id
-- ORDER BY total_revenue DESC
-- LIMIT 10;

-- SELECT
--     p.product_id,
--     p.product_category_name,
--     SUM(oi.price) AS total_revenue
-- FROM Order_Items oi
-- JOIN Products p
--     ON oi.product_id = p.product_id
-- GROUP BY
--     p.product_id,
--     p.product_category_name
-- ORDER BY total_revenue DESC
-- LIMIT 10;

-- SELECT
--     c.customer_unique_id,
--     p.product_category_name,
--     SUM(oi.price) AS total_spent
-- FROM Orders o
-- JOIN Customers c
--     ON o.customer_id = c.customer_id
-- JOIN Order_Items oi
--     ON o.order_id = oi.order_id
-- JOIN Products p
--     ON oi.product_id = p.product_id
-- GROUP BY
--     c.customer_unique_id,
--     p.product_category_name
-- ORDER BY total_spent DESC
-- LIMIT 20;

SELECT
    c.customer_unique_id,
    MAX(o.order_purchase_timestamp) AS last_purchase_date,
    SUM(oi.price) AS total_revenue
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
JOIN Order_Items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_unique_id
HAVING
    MAX(o.order_purchase_timestamp) < DATE_SUB(
        (SELECT MAX(order_purchase_timestamp) FROM Orders),
        INTERVAL 6 MONTH
    )
    AND SUM(oi.price) >= 3000
ORDER BY total_revenue DESC
LIMIT 20;

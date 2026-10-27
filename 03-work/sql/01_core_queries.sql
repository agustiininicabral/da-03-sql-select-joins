-- SQL practice: SELECT, aggregation, INNER JOIN, and LEFT JOIN.
-- Dialect: PostgreSQL / SQLite.
-- Sales and products share category but sales has no product_id. Aggregate before
-- joining by category to avoid multiplying revenue by the number of products.

-- QUERY: Q01 Top categories by net revenue
SELECT category, ROUND(SUM(CAST(net_revenue AS REAL)), 2) AS revenue
FROM sales
GROUP BY category
ORDER BY revenue DESC;

-- QUERY: Q02 Estimated gross margin by channel
SELECT channel,
       ROUND(SUM(CAST(net_revenue AS REAL)), 2) AS revenue,
       ROUND(SUM(CAST(net_revenue AS REAL) - CAST(cost AS REAL)), 2) AS gross_margin
FROM sales
GROUP BY channel
ORDER BY gross_margin DESC;

-- QUERY: Q03 Top customers by cumulative net revenue
SELECT customer_id,
       ROUND(SUM(CAST(net_revenue AS REAL)), 2) AS revenue_lifetime_proxy,
       COUNT(*) AS orders
FROM sales
GROUP BY customer_id
ORDER BY revenue_lifetime_proxy DESC
LIMIT 20;

-- QUERY: Q04 INNER JOIN sales KPIs to aggregated product catalog by category
WITH sales_by_category AS (
    SELECT category,
           COUNT(*) AS orders,
           ROUND(SUM(CAST(net_revenue AS REAL)), 2) AS revenue,
           ROUND(SUM(CAST(net_revenue AS REAL) - CAST(cost AS REAL)), 2) AS gross_margin
    FROM sales
    GROUP BY category
),
products_by_category AS (
    SELECT category,
           COUNT(*) AS product_count,
           SUM(CASE WHEN LOWER(active) = 'yes' THEN 1 ELSE 0 END) AS active_products
    FROM products
    GROUP BY category
)
SELECT s.category, s.orders, s.revenue, s.gross_margin,
       p.product_count, p.active_products
FROM sales_by_category AS s
INNER JOIN products_by_category AS p ON p.category = s.category
ORDER BY s.revenue DESC;

-- QUERY: Q05 LEFT JOIN product categories to sales aggregates
WITH sales_by_category AS (
    SELECT category,
           COUNT(*) AS orders,
           ROUND(SUM(CAST(net_revenue AS REAL)), 2) AS revenue
    FROM sales
    GROUP BY category
),
products_by_category AS (
    SELECT category,
           COUNT(*) AS product_count,
           SUM(CASE WHEN LOWER(active) = 'yes' THEN 1 ELSE 0 END) AS active_products
    FROM products
    GROUP BY category
)
SELECT p.category, p.product_count, p.active_products,
       COALESCE(s.orders, 0) AS orders,
       COALESCE(s.revenue, 0) AS revenue
FROM products_by_category AS p
LEFT JOIN sales_by_category AS s ON s.category = p.category
ORDER BY revenue DESC;

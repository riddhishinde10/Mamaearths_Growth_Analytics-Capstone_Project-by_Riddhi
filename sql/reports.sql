-- Task 3: reports.sql
-- ============================================================
-- (a) Order totals
-- Exact output:
-- total_orders | total_revenue | avg_order_value
-- 180          | 99860.20      | 554.78
-- ============================================================
SELECT
    COUNT(*) AS total_orders,
    ROUND(
        SUM(o.quantity * p.price * (1 - COALESCE(o.discount_pct, 0) / 100.0)),
        2
    ) AS total_revenue,
    ROUND(
        AVG(o.quantity * p.price * (1 - COALESCE(o.discount_pct, 0) / 100.0)),
        2
    ) AS avg_order_value
FROM orders AS o
JOIN products AS p
    ON o.product_id = p.product_id;

-- ============================================================
-- (b) COUNT(*) vs COUNT(column)
-- Exact output:
-- total_rows | rated_orders | unrated_orders
-- 180        | 165          | 15
-- COUNT(rating) ignores NULL ratings; COUNT(*) counts every row.
-- ============================================================
SELECT
    COUNT(*) AS total_rows,
    COUNT(rating) AS rated_orders,
    COUNT(*) - COUNT(rating) AS unrated_orders
FROM orders;

-- ============================================================
-- (c1) LEFT JOIN: customers with zero orders
-- Exact output:
-- customer_id | name
-- C045        | Vihaan
-- COUNT(order_id), rather than COUNT(*), detects the unmatched row.
-- ============================================================
SELECT
    c.customer_id,
    c.name
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) = 0;

-- ============================================================
-- (c2) Independent confirmation using NOT IN
-- Exact output:
-- customer_id | name
-- C045        | Vihaan
-- ============================================================
SELECT
    c.customer_id,
    c.name
FROM customers AS c
WHERE c.customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM orders
);

-- ============================================================
-- (d) GROUP BY + HAVING: cities with return rate above 20%
-- Exact output:
-- city      | total_orders | returned_orders | return_rate_pct
-- Jaipur    | 19           | 8               | 42.1
-- Lucknow   | 49           | 15              | 30.6
-- Bangalore | 33           | 8               | 24.2
-- ============================================================
SELECT
    c.city,
    COUNT(*) AS total_orders,
    SUM(o.returned) AS returned_orders,
    ROUND(100.0 * SUM(o.returned) / COUNT(*), 1) AS return_rate_pct
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY c.city
HAVING return_rate_pct > 20
ORDER BY return_rate_pct DESC;

-- ============================================================
-- (e1) Top 5 customers by total spend
-- Exact output:
-- customer_id | name    | total_spend
-- C043        | Reyansh | 12920.00
-- C026        | Isha    | 8371.60
-- C008        | Meera   | 4564.60
-- C011        | Arjun   | 4111.00
-- C042        | Sanya   | 3785.00
-- Tie-break: customer_id ASC makes the ranking deterministic when
-- two customers have equal total_spend.
-- ============================================================
SELECT
    c.customer_id,
    c.name,
    CAST(ROUND(SUM(o.quantity * p.price *
        (1 - COALESCE(o.discount_pct, 0) / 100.0)), 2) AS DECIMAL(12,2))
        AS total_spend
FROM orders AS o
JOIN products AS p
    ON o.product_id = p.product_id
JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spend DESC, c.customer_id ASC
LIMIT 5;

-- ============================================================
-- (e2) Ranks 3-5 using LIMIT/OFFSET (not a separate ranking rule)
-- Exact output:
-- customer_id | name  | total_spend
-- C008        | Meera | 4564.60
-- C011        | Arjun | 4111.00
-- C042        | Sanya | 3785.00
-- ============================================================
SELECT
    c.customer_id,
    c.name,
    CAST(ROUND(SUM(o.quantity * p.price *
        (1 - COALESCE(o.discount_pct, 0) / 100.0)), 2) AS DECIMAL(12,2))
        AS total_spend
FROM orders AS o
JOIN products AS p
    ON o.product_id = p.product_id
JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spend DESC, c.customer_id ASC
LIMIT 3 OFFSET 2;

-- ============================================================
-- (f) Three-table JOIN + GROUP BY: revenue by product category
-- Exact output:
-- category     | order_count | category_revenue
-- Haircare     | 54          | 44956.10
-- Skincare     | 60          | 27346.00
-- Babycare     | 30          | 16805.00
-- PersonalCare | 36          | 10753.10
-- ============================================================
SELECT
    p.category,
    COUNT(*) AS order_count,
    CAST(ROUND(SUM(o.quantity * p.price *
        (1 - COALESCE(o.discount_pct, 0) / 100.0)), 2) AS DECIMAL(12,2))
        AS category_revenue
FROM orders AS o
JOIN products AS p
    ON o.product_id = p.product_id
JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY p.category
ORDER BY category_revenue DESC;

-- ============================================================
-- (g) LIKE pattern match: customer names starting with A
-- Exact output (10 rows):
-- customer_id | name
-- C001        | Aarav
-- C003        | Aditi
-- C004        | Ananya
-- C011        | Arjun
-- C021        | Aryan
-- C030        | Anika
-- C031        | Aditya
-- C036        | Aisha
-- C041        | Ayaan
-- C044        | Aria
-- ============================================================
SELECT
    customer_id,
    name
FROM customers
WHERE name LIKE 'A%'
ORDER BY customer_id;

-- ============================================================
-- (h) DISTINCT acquisition sources
-- Exact output:
-- acquisition_source
-- Ad
-- Organic
-- Referral
-- Social
-- ============================================================
SELECT DISTINCT acquisition_source
FROM customers
ORDER BY acquisition_source;

-- ============================================================
-- (i1) Add the loyalty_tier column
-- ============================================================
ALTER TABLE customers
ADD COLUMN loyalty_tier VARCHAR(10);

-- ============================================================
-- (i2) Assign a tier to every customer using one CASE update
-- No WHERE clause: every customer receives a value.
-- ============================================================
UPDATE customers
SET loyalty_tier = CASE
    WHEN city_tier = 1 THEN 'Gold'
    ELSE 'Silver'
END;

-- ============================================================
-- (i3) Verify loyalty-tier counts
-- Exact output:
-- loyalty_tier | customer_count
-- Gold          | 28
-- Silver        | 17
-- ============================================================
SELECT
    loyalty_tier,
    COUNT(*) AS customer_count
FROM customers
GROUP BY loyalty_tier
ORDER BY loyalty_tier;

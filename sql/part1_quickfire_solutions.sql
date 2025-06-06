-- PART 1 – QUICKFIRE SQL SOLUTIONS
-- ======================================================

-- Question 1: What was the first product sold in each month?

SELECT DISTINCT ON (DATE_TRUNC('month', ORDER_DATE))
    DATE_TRUNC('month', ORDER_DATE) AS sale_month,
    ORDER_DATE,
    PRODUCT_CODE,
    CUSTOMER_NAME,
    SALES,
    PRODUCT_LINE
FROM sales_data
ORDER BY DATE_TRUNC('month', ORDER_DATE), ORDER_DATE;

-- Question 2: Which products are common to the two customers who have spent the most in total?

WITH customer_totals AS (
    SELECT CUSTOMER_NAME, SUM(SALES) AS total_spent
    FROM sales_data 
    GROUP BY CUSTOMER_NAME
    ORDER BY total_spent DESC
    LIMIT 2
),
top_customers AS (
    SELECT CUSTOMER_NAME FROM customer_totals
),
customer_products AS (
    SELECT CUSTOMER_NAME, PRODUCT_CODE
    FROM sales_data
    WHERE CUSTOMER_NAME IN (SELECT CUSTOMER_NAME FROM top_customers)
),
common_products AS (
    SELECT PRODUCT_CODE
    FROM customer_products
    GROUP BY PRODUCT_CODE
    HAVING COUNT(DISTINCT CUSTOMER_NAME) = 2
)
SELECT 
    cp.PRODUCT_CODE,
    cp.CUSTOMER_NAME
FROM customer_products cp
JOIN common_products p ON cp.PRODUCT_CODE = p.PRODUCT_CODE
ORDER BY cp.PRODUCT_CODE, cp.CUSTOMER_NAME;


-- Question 3: Are there any months where the average monthly revenue decreased compared to the month before?

WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', ORDER_DATE) AS sale_month,
        SUM(SALES) AS total_revenue
    FROM sales_data
    GROUP BY sale_month
),
monthly_lag AS (
    SELECT
        sale_month,
        total_revenue,
        LAG(total_revenue) OVER (ORDER BY sale_month) AS previous_revenue
    FROM monthly_revenue
)
SELECT *
FROM monthly_lag
WHERE total_revenue < previous_revenue;

-- Question 4: What is the best-selling product line by total sales and how does it compare to others?

SELECT
    PRODUCT_LINE,
    SUM(SALES) AS total_sales,
    ROUND(
        SUM(SALES) * 100.0 / SUM(SUM(SALES)) OVER (),
        2
    ) AS percent_of_total
FROM sales_data
GROUP BY PRODUCT_LINE
ORDER BY total_sales DESC;

-- Question 5: Identify customers who ordered in three or more consecutive months.

WITH customer_months AS (
    SELECT DISTINCT CUSTOMER_NAME, DATE_TRUNC('month', ORDER_DATE) AS order_month
    FROM sales_data
),
ranked_months AS (
    SELECT
        CUSTOMER_NAME,
        order_month,
        ROW_NUMBER() OVER (PARTITION BY CUSTOMER_NAME ORDER BY order_month) AS rn
    FROM customer_months
),
gaps AS (
    SELECT
        CUSTOMER_NAME,
        order_month,
        rn,
        order_month - (INTERVAL '1 month' * rn) AS grp
    FROM ranked_months
),
consecutive_groups AS (
    SELECT
        CUSTOMER_NAME,
        grp,
        COUNT(*) AS months_in_a_row,
        MIN(order_month) AS start_month,
        MAX(order_month) AS end_month
    FROM gaps
    GROUP BY CUSTOMER_NAME, grp
    HAVING COUNT(*) >= 3
),
final_output AS (
    SELECT
        cg.CUSTOMER_NAME,
        cg.months_in_a_row,
        cg.start_month,
        cg.end_month,
        STRING_AGG(TO_CHAR(cm.order_month, 'YYYY-MM'), ', ' ORDER BY cm.order_month) AS ordered_months
    FROM consecutive_groups cg
    JOIN customer_months cm
      ON cg.CUSTOMER_NAME = cm.CUSTOMER_NAME
     AND cm.order_month BETWEEN cg.start_month AND cg.end_month
    GROUP BY cg.CUSTOMER_NAME, cg.months_in_a_row, cg.start_month, cg.end_month
)
SELECT *
FROM final_output
ORDER BY CUSTOMER_NAME;



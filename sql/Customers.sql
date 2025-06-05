---First Order Date Per Customer
SELECT
  CUSTOMER_NAME,
  MIN(ORDER_DATE) AS first_order_date
FROM sales_data
GROUP BY CUSTOMER_NAME;

--- New vs Returning Customers Per Month
WITH first_orders AS (
  SELECT CUSTOMER_NAME, MIN(ORDER_DATE) AS first_order
  FROM sales_data
  GROUP BY CUSTOMER_NAME
),
tagged_orders AS (
  SELECT
    s.CUSTOMER_NAME,
    s.ORDER_DATE,
    CASE
      WHEN s.ORDER_DATE = f.first_order THEN 'new'
      ELSE 'returning'
    END AS customer_type
  FROM sales_data s
  JOIN first_orders f ON s.CUSTOMER_NAME = f.CUSTOMER_NAME
)
SELECT
  DATE_TRUNC('month', ORDER_DATE) AS month,
  customer_type,
  COUNT(DISTINCT CUSTOMER_NAME) AS customer_count
FROM tagged_orders
GROUP BY month, customer_type
ORDER BY month, customer_type;


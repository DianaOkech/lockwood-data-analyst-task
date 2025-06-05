--- Lifetime Value & Frequency
SELECT
  CUSTOMER_NAME,
  COUNT(DISTINCT ORDER_NUMBER) AS num_orders,
  SUM(SALES) AS total_revenue,
  AVG(SALES) AS avg_order_value,
  MAX(ORDER_DATE) - MIN(ORDER_DATE) AS lifespan
FROM sales_data
GROUP BY CUSTOMER_NAME
ORDER BY total_revenue DESC;

---Enrich LTV with Demographics
SELECT
  CUSTOMER_NAME,
  COUNTRY,
  DEAL_SIZE,
  COUNT(DISTINCT ORDER_NUMBER) AS num_orders,
  SUM(SALES) AS total_revenue,
  AVG(SALES) AS avg_order_value
FROM sales_data
GROUP BY CUSTOMER_NAME, COUNTRY, DEAL_SIZE
ORDER BY total_revenue DESC;

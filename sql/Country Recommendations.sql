---Revenue by Country
SELECT
  COUNTRY,
  SUM(SALES) AS total_revenue,
  COUNT(DISTINCT CUSTOMER_NAME) AS customers,
  AVG(SALES) AS avg_order_value
FROM sales_data
GROUP BY COUNTRY
ORDER BY total_revenue DESC;

---Deal Size Contribution
SELECT
  DEAL_SIZE,
  COUNT(*) AS num_orders,
  SUM(SALES) AS total_revenue,
  AVG(SALES) AS avg_order_value
FROM sales_data
GROUP BY DEAL_SIZE
ORDER BY total_revenue DESC;


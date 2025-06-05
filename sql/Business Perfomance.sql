-- Monthly Revenue Summary
SELECT
  DATE_TRUNC('month', ORDER_DATE) AS month,
  SUM(SALES) AS total_revenue
FROM sales_data
GROUP BY month
ORDER BY month;

---Quarterly Revenue Summary
SELECT
  EXTRACT(YEAR FROM ORDER_DATE) AS year,
  EXTRACT(QUARTER FROM ORDER_DATE) AS quarter,
  SUM(SALES) AS total_revenue
FROM sales_data
GROUP BY year, quarter
ORDER BY year, quarter;

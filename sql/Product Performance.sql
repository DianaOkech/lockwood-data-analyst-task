---Revenue by Product Line
SELECT
  PRODUCT_LINE,
  SUM(SALES) AS total_revenue,
  COUNT(DISTINCT PRODUCT_CODE) AS distinct_products
FROM sales_data
GROUP BY PRODUCT_LINE
ORDER BY total_revenue DESC;

--- SKU - Level Revenue 
SELECT
  PRODUCT_CODE,
  PRODUCT_LINE,
  SUM(SALES) AS total_revenue,
  SUM(QUANTITY_ORDERED) AS total_units,
  AVG(PRICE_EACH) AS avg_price
FROM sales_data
GROUP BY PRODUCT_CODE, PRODUCT_LINE
ORDER BY total_revenue DESC;

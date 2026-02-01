CREATE TABLE pizza_sales (
    pizza_id INT PRIMARY KEY,
    order_id INT,
    pizza_name_id VARCHAR(50),
    quantity INT,
    order_date DATE,
    order_time TIME,
    unit_price NUMERIC(10,2),
    total_price NUMERIC(10,2),
    pizza_size VARCHAR(10),
    pizza_category VARCHAR(50),
    pizza_ingredients TEXT,
    pizza_name VARCHAR(100)
);

select * from pizza_sales

--Total Revenue
SELECT SUM(total_price) AS Total_revenu
FROM pizza_sales

--2. Average Order Value
SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Average_order_value
FROM pizza_sales

--3. Total Pizzas Sold
SELECT SUM(quantity) AS Total_pizza_sales
FROM pizza_sales

--4. Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales

--5. Average Pizzas Per Order
SELECT ROUND(SUM(quantity)::numeric / COUNT(DISTINCT order_id)::numeric,2) AS avg_pizzas_per_order
FROM pizza_sales



---B. Daily Trend for Total Orders
SELECT 
   EXTRACT(DOW FROM order_date) AS DOW,--EXTRACT USE TO 0 → Sunday 1 → Monday .....6 → Saturday
   TRIM(TO_CHAR(order_date,'DAY')) AS Order_day,--Converts the date into the day name: Monday, Tuesday, etc.
   COUNT(DISTINCT order_id) AS Total_order
FROM pizza_sales
GROUP BY DOW, Order_day
ORDER BY DOW

---C. Hourly Trend for Orders
SELECT
   EXTRACT(HOUR FROM order_time) AS Order_hours,
   COUNT(DISTINCT order_id) AS Total_order
FROM pizza_sales
GROUP BY Order_hours
ORDER BY Order_hours

---D. % of Sales by Pizza Category
SELECT pizza_category,
ROUND(SUM(total_price)::NUMERIC,2)AS Total_revenue,
ROUND(SUM(total_price) * 100.0 / (SELECT SUM(total_price) FROM pizza_sales),2) AS PCT
FROM pizza_sales
GROUP BY pizza_category
---- IN % of Sales by Month
SELECT
  pizza_category,
  ROUND(SUM(total_price)::numeric, 2) AS monthly_revenue,
  ROUND(
    SUM(total_price) * 100.0
    / (
        SELECT SUM(total_price)
        FROM pizza_sales
        WHERE EXTRACT(MONTH FROM order_date) = 1
      ),
    2
  ) AS pct_of_monthly_sales
FROM pizza_sales
WHERE EXTRACT(MONTH FROM order_date) = 1
GROUP BY pizza_category;

--- IN Quarter
SELECT
  pizza_category,
  ROUND(SUM(total_price)::numeric, 2) AS quarterly_revenue,
  ROUND(
    SUM(total_price) * 100.0
    / (
        SELECT SUM(total_price)
        FROM pizza_sales
        WHERE EXTRACT(QUARTER FROM order_date) = 1
      ),
    2
  ) AS pct_of_quarterly_sales
FROM pizza_sales
WHERE EXTRACT(QUARTER FROM order_date) = 1
GROUP BY pizza_category;

--E. % of Sales by Pizza Size
SELECT pizza_size,
ROUND(SUM(total_price)::numeric, 2) AS total_revenue,
ROUND(SUM(total_price) * 100.0 / (SELECT SUM(total_price) FROM pizza_sales),2) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size

--F. Total Pizzas Sold by Pizza Category
SELECT pizza_category,SUM(quantity) AS total_quantity_sold
FROM pizza_sales
WHERE EXTRACT(MONTH FROM order_date) = 2
GROUP BY pizza_category
ORDER BY total_quantity_sold DESC;

--G. Top 5 Best Sellers by Total Pizzas Sold
SELECT pizza_name,SUM(quantity) AS total_pizza_sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_pizza_sold DESC
LIMIT 5;

--H. Bottom 5 Best Sellers by Total Pizzas Sold
SELECT pizza_name,SUM(quantity) AS total_pizza_sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_pizza_sold ASC
LIMIT 5;


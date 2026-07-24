1. Total Customers:
SELECT COUNT(*) AS Total_Customers
FROM customers;

2. Total products:
SELECT COUNT(*) AS Total_Products
FROM products;

3. Total orders:
SELECT COUNT(*) AS Total_Orders
FROM orders;

4. Total sales:
SELECT
SUM(p.price * o.quantity) AS Total_Sales
FROM orders o
JOIN products p
ON o.product_id=p.product_id;

5. Total profit:
SELECT
SUM((p.price-p.cost_price)*o.quantity) AS Total_Profit
FROM orders o
JOIN products p
ON o.product_id=p.product_id;

6. Average order value:
SELECT
ROUND(SUM(p.price*o.quantity)/COUNT(DISTINCT o.order_id),2) AS Average_Order_Value
FROM orders o
JOIN products p
ON o.product_id=p.product_id;

7. Top 10 customers by sales:
SELECT
c.customer_name,
SUM(p.price*o.quantity) AS Sales
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN products p
ON o.product_id=p.product_id
GROUP BY c.customer_name
ORDER BY Sales DESC
LIMIT 10;

8. Top 10 products:
SELECT
p.product_name,
SUM(o.quantity) AS Quantity_Sold,
SUM(p.price*o.quantity) AS Sales
FROM products p
JOIN orders o
ON p.product_id=o.product_id
GROUP BY p.product_name
ORDER BY Sales DESC
LIMIT 10;

9. Lowest selling products:
SELECT
p.product_name,
SUM(o.quantity) AS Quantity_Sold
FROM products p
JOIN orders o
ON p.product_id=o.product_id
GROUP BY p.product_name
ORDER BY Quantity_Sold ASC
LIMIT 10;

10. Sales by category:
SELECT
p.category,
SUM(p.price*o.quantity) AS Sales
FROM products p
JOIN orders o
ON p.product_id=o.product_id
GROUP BY p.category
ORDER BY Sales DESC;

11. Profit by category:
SELECT
p.category,
SUM((p.price-p.cost_price)*o.quantity) AS Profit
FROM products p
JOIN orders o
ON p.product_id=o.product_id
GROUP BY p.category
ORDER BY Profit DESC;

12. Monthly sales:
SELECT
DATE_FORMAT(order_date,'%Y-%m') AS Month,
SUM(p.price*o.quantity) AS Sales
FROM orders o
JOIN products p
ON o.product_id=p.product_id
GROUP BY Month
ORDER BY Month;

13. Yearly sales:
SELECT
YEAR(order_date) AS Year,
SUM(p.price*o.quantity) AS Sales
FROM orders o
JOIN products p
ON o.product_id=p.product_id
GROUP BY Year;

14. Daily sales:
SELECT
order_date,
SUM(p.price*o.quantity) AS Sales
FROM orders o
JOIN products p
ON o.product_id=p.product_id
GROUP BY order_date
ORDER BY order_date;

15. Sales by state:
SELECT
c.state,
SUM(p.price*o.quantity) AS Sales
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN products p
ON o.product_id=p.product_id
GROUP BY c.state
ORDER BY Sales DESC;

16. Sales by city:
SELECT
c.city,
SUM(p.price*o.quantity) AS Sales
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN products p
ON o.product_id=p.product_id
GROUP BY c.city
ORDER BY Sales DESC;

17. Sales by gender:
SELECT
c.gender,
SUM(p.price*o.quantity) AS Sales
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN products p
ON o.product_id=p.product_id
GROUP BY c.gender;

18. Sales by payment mode:
SELECT
payment_mode,
COUNT(*) AS Orders,
SUM(p.price*o.quantity) AS Sales
FROM orders o
JOIN products p
ON o.product_id=p.product_id
GROUP BY payment_mode;

19. Highest order value:
SELECT
o.order_id,
SUM(p.price*o.quantity) AS Order_Value
FROM orders o
JOIN products p
ON o.product_id=p.product_id
GROUP BY o.order_id
ORDER BY Order_Value DESC
LIMIT 1;

20. Customer age group Analysis:
SELECT
CASE
WHEN age<20 THEN 'Below 20'
WHEN age BETWEEN 20 AND 30 THEN '20-30'
WHEN age BETWEEN 31 AND 40 THEN '31-40'
WHEN age BETWEEN 41 AND 50 THEN '41-50'
ELSE 'Above 50'
END AS Age_Group,
COUNT(*) AS Customers
FROM customers
GROUP BY Age_Group;

21. Products never ordered:
SELECT
product_name
FROM products
WHERE product_id NOT IN
(
SELECT DISTINCT product_id
FROM orders
);

22. Customers with Maximum orders:
SELECT
c.customer_name,
COUNT(o.order_id) AS Total_Orders
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_name
ORDER BY Total_Orders DESC
LIMIT 10;

23. Repeat customers:
SELECT
c.customer_name,
COUNT(o.order_id) AS Orders
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id)>1
ORDER BY Orders DESC;

24. Top 5 Most Profitable Products:
SELECT
p.product_name,
SUM((p.price-p.cost_price)*o.quantity) AS Profit
FROM products p
JOIN orders o
ON p.product_id=o.product_id
GROUP BY p.product_name
ORDER BY Profit DESC
LIMIT 5;

25. Rank Products by Sales (Window Function):
SELECT
product_name,
Sales,
RANK() OVER(ORDER BY Sales DESC) AS Product_Rank
FROM
(
SELECT
p.product_name,
SUM(p.price*o.quantity) AS Sales
FROM products p
JOIN orders o
ON p.product_id=o.product_id
GROUP BY p.product_name
) t;
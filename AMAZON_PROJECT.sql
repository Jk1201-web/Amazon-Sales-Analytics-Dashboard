CREATE DATABASE amazon_project;

USE amazon_project;

SELECT * FROM amazon_sales LIMIT 5;

ALTER TABLE amazon_sales
RENAME COLUMN ï»¿OrderID TO OrderID;

--- 1] Total revenue

SELECT SUM(TotalSales) AS Total_revenue
FROM amazon_sales;

--- 2] Total Orders

SELECT COUNT(OrderID) AS Total_orders
FROM amazon_sales;

--- 3] Top selling products

SELECT Product,
       SUM(TotalSales) AS Revenue
FROM amazon_sales
GROUP BY Product
ORDER BY Revenue DESC;

--- 4] Category wise sales

SELECT Category,
       SUM(TotalSales) AS Revenue
FROM amazon_sales
GROUP BY Category
ORDER BY Revenue DESC;

--- 5] Payment method analysis

SELECT PaymentMethod,
       COUNT(*) AS Total_transactions
FROM amazon_sales
GROUP BY PaymentMethod
ORDER BY Total_transactions DESC;

--- 6] Orders status analysis

SELECT Status,
       COUNT(*) AS Total_orders
FROM amazon_sales
GROUP BY Status;

--- 7] Regional sales

SELECT CustomerLocation,
       SUM(TotalSales) AS Revenue
FROM amazon_sales
GROUP BY CustomerLocation
ORDER BY Revenue DESC;

--- 8] Monthly revenus trend

SET SQL_SAFE_UPDATES = 0;

UPDATE amazon_sales
SET OrderDate = STR_TO_DATE(OrderDate, '%Y/%m/%d');

SELECT MONTH(OrderDate) AS month,
       SUM(TotalSales) AS Revenue
FROM amazon_sales
GROUP BY month
ORDER BY Revenue DESC;

--- 9] Customer intelligence analysis 
-- 1] top customers

SELECT CustomerName,
       SUM(TotalSales) AS Spending
FROM amazon_sales
GROUP BY CustomerName
ORDER BY Spending DESC
LIMIT 10;

-- 2] repeat customer

SELECT CustomerName,
       COUNT(OrderID) AS Total_orders
FROM amazon_sales
GROUP BY CustomerName
HAVING Total_orders > 1;

--- 3] calculate customer spending

SELECT CustomerName,
       SUM(TotalSales) AS Total_spending
FROM amazon_sales
GROUP BY CustomerName
ORDER BY Total_spending DESC;

--- Customer segmentation

SELECT CustomerName,
	   SUM(TotalSales) AS Total_spending,
       CASE
		   WHEN SUM(totalSales) >= 30000 THEN 'VIP'
           WHEN SUM(totalSales) >= 20000 THEN 'Premium'
           WHEN SUM(totalSales) >= 10000 THEN 'Regular'
           ELSE 'Low Value'
	   END AS customer_segment
FROM amazon_sales
GROUP BY CustomerName;

--- profit analysis

ALTER TABLE amazon_sales
ADD COLUMN Profit INT;

UPDATE amazon_sales
SET Profit = TotalSales * 0.30;

--- profit by category

SELECT Category,
       SUM(Profit) AS Total_profit
FROM amazon_sales
GROUP BY Category
ORDER BY Total_profit DESC;

--- Sales forecasting 

--- monthly sales 

SELECT MONTH(OrderDate) AS month,
       SUM(TotalSales) AS Monthly_sales
FROM amazon_sales
GROUP BY month
ORDER BY month;

--- moving average forecasting
SELECT month,
       AVG(Monthly_sales) OVER(
           ORDER BY month
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
           ) AS Moving_average
FROM (
SELECT month(OrderDate) AS month,
       SUM(TotalSales) AS Monthly_sales
FROM amazon_sales
GROUP BY month
) Sales_data;

--- Growth rate forecasting

WITH monthly_sales AS (
    SELECT MONTH(OrderDate) AS month,
           SUM(TotalSales) AS Revenue
    FROM amazon_sales
    GROUP BY month
)

SELECT month,
       Revenue,
       LAG(Revenue) OVER(ORDER BY month) AS Previous_month,
       ROUND(
		   ((Revenue - LAG(Revenue) OVER(ORDER BY month)) 
           / LAG(Revenue) OVER(ORDER BY month)) * 100,
           2
		) AS growth_rate
FROM monthly_sales;

--- Inventary analytics 

ALTER TABLE amazon_sales
ADD COLUMN Inventory_stock INT;

UPDATE amazon_sales
SET Inventory_stock = FLOOR(RAND() * 500);

--- Find low cost product

SELECT Product,
       ROUND(AVG(Inventory_stock),0) AS Avg_inventory
FROM amazon_sales
GROUP BY Product
ORDER BY Avg_inventory;

--- A/B Testing analytics

ALTER TABLE amazon_sales
ADD COLUMN Test_group VARCHAR(10);

UPDATE amazon_sales
SET Test_group =
CASE
    WHEN RAND() < 0.5 THEN "A"
    ELSE 'B'
END;

SELECT Test_group,
       COUNT(*) AS Total_orders
FROM amazon_sales
GROUP BY Test_group
ORDER BY Test_group;

SELECT Test_group,
       COUNT(*) AS Total_orders,
       SUM(
           CASE
               WHEN Status = 'Completed' THEN 1
               ELSE 0
               END
			) AS Completed_orders,
            ROUND(
            	(
                   SUM(
                       CASE
					   WHEN Status = 'Completed' THEN 1
					   ELSE 0
                       END
                       ) / COUNT(*)
		         ) * 100,
                 2
	             ) AS Conersion_rate
FROM amazon_sales
GROUP BY Test_group;






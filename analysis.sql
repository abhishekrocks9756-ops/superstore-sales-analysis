create database ecom;

use ecom;

--  Profit ka size badha ke
CREATE TABLE superstore (
    Category        VARCHAR(100),
    City            VARCHAR(100),
    Country         VARCHAR(100),
    Customer_ID     VARCHAR(50),
    Customer_Name   VARCHAR(100),
    Discount        DECIMAL(10,4),
    Market          VARCHAR(100),
    Record_Count    INT,
    Order_Date      VARCHAR(20),
    Order_ID        VARCHAR(50),
    Order_Priority  VARCHAR(50),
    Product_ID      VARCHAR(50),
    Product_Name    VARCHAR(255),
    Profit          DECIMAL(15,4),
    Quantity        INT,
    Region          VARCHAR(100),
    Row_ID          INT,
    Sales           DECIMAL(15,4),
    Segment         VARCHAR(100),
    Ship_Date       VARCHAR(20),
    Ship_Mode       VARCHAR(100),
    Shipping_Cost   DECIMAL(15,4),
    State           VARCHAR(100),
    Sub_Category    VARCHAR(100),
    Year            INT,
    Market2         VARCHAR(100),
    weeknum         INT
);




LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/superstore_fixed.csv'
INTO TABLE superstore
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


ALTER TABLE superstore 
MODIFY Profit DECIMAL(20,6),
MODIFY Shipping_Cost DECIMAL(20,6),
MODIFY Sales DECIMAL(20,6),
MODIFY Discount DECIMAL(20,6);


SELECT COUNT(*) FROM superstore;
SELECT * FROM superstore LIMIT 5;

#KPI

-- #1 Total Sales
SELECT SUM(sales) AS Total_Sales
FROM superstore;

-- #2 Total Profit
SELECT SUM(profit) AS Total_Profit
FROM superstore;

-- #3 Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM superstore;

-- #4 Total Customers
SELECT COUNT(DISTINCT customer_id) AS Total_Customers
FROM superstore;

-- #5 Profit Margin %
SELECT
ROUND(
SUM(profit)*100/SUM(sales),
2
) AS Profit_Margin
FROM superstore;

-- #6 Sales by Category
SELECT
category,
SUM(sales) AS Total_Sales
FROM superstore
GROUP BY category
ORDER BY Total_Sales DESC;

-- #7 Sales by Sub Category
SELECT
sub_category,
SUM(sales) AS Total_Sales
FROM superstore
GROUP BY sub_category
ORDER BY Total_Sales DESC;

-- #8 Top 10 Products by Sales
SELECT
product_name,
SUM(sales) AS Total_Sales
FROM superstore
GROUP BY product_name
ORDER BY Total_Sales DESC
LIMIT 10;

-- #9 Top 10 Customers by Sales
SELECT
customer_name,
SUM(sales) AS Total_Sales
FROM superstore
GROUP BY customer_name
ORDER BY Total_Sales DESC
LIMIT 10;

-- #10 Most Profitable Products
SELECT
product_name,
SUM(profit) AS Total_Profit
FROM superstore
GROUP BY product_name
ORDER BY Total_Profit DESC
LIMIT 10;

-- #11 Loss Making Products
SELECT
product_name,
SUM(profit) AS Total_Profit
FROM superstore
GROUP BY product_name
ORDER BY Total_Profit
LIMIT 10;

-- #12 Profit by Category
SELECT
category,
SUM(profit) AS Total_Profit
FROM superstore
GROUP BY category
ORDER BY Total_Profit DESC;

-- #13 Profit Margin by Category
SELECT
category,
ROUND(
SUM(profit)*100/SUM(sales),
2
) AS Profit_Margin
FROM superstore
GROUP BY category;

-- #14 Sales by Region
SELECT
region,
SUM(sales) AS Total_Sales
FROM superstore
GROUP BY region
ORDER BY Total_Sales DESC;

-- #15 Profit by Region
SELECT
region,
SUM(profit) AS Total_Profit
FROM superstore
GROUP BY region
ORDER BY Total_Profit DESC;

-- #16 Sales by Country
SELECT
country,
SUM(sales) AS Total_Sales
FROM superstore
GROUP BY country
ORDER BY Total_Sales DESC;

-- #17 Top Countries by Profit
SELECT
country,
SUM(profit) AS Total_Profit
FROM superstore
GROUP BY country
ORDER BY Total_Profit DESC
LIMIT 10;

-- #18 Segment Analysis
SELECT
segment,
SUM(sales) AS Total_Sales,
SUM(profit) AS Total_Profit
FROM superstore
GROUP BY segment;

-- #19 Average Discount by Category
SELECT
category,
ROUND(AVG(discount),2) AS Avg_Discount
FROM superstore
GROUP BY category;

-- #20 Discount Impact on Profit
SELECT
discount,
SUM(sales) AS Sales,
SUM(profit) AS Profit
FROM superstore
GROUP BY discount
ORDER BY discount;

-- #21 High Discount Orders
SELECT *
FROM superstore
WHERE discount > 0.30;

-- #22 Average Shipping Cost by Ship Mode
SELECT
ship_mode,
ROUND(AVG(shipping_cost),2) AS Avg_Shipping_Cost
FROM superstore
GROUP BY ship_mode;

-- #23 Average Delivery Days
SELECT
ROUND(
AVG(
DATEDIFF(ship_date,order_date)
),
2
) AS Avg_Delivery_Days
FROM superstore;

-- #24 Delivery Days by Ship Mode
SELECT
ship_mode,
ROUND(
AVG(
DATEDIFF(ship_date,order_date)
),
2
) AS Avg_Days
FROM superstore
GROUP BY ship_mode;

-- #25 Top Customers by Profit
SELECT
customer_name,
SUM(profit) AS Total_Profit
FROM superstore
GROUP BY customer_name
ORDER BY Total_Profit DESC
LIMIT 10;

-- #26 Top Customers by Quantity
SELECT
customer_name,
SUM(quantity) AS Total_Quantity
FROM superstore
GROUP BY customer_name
ORDER BY Total_Quantity DESC
LIMIT 10;

-- #27 Top Products by Quantity
SELECT
product_name,
SUM(quantity) AS Total_Quantity
FROM superstore
GROUP BY product_name
ORDER BY Total_Quantity DESC
LIMIT 10;

-- #28 Revenue Contribution %
SELECT
category,
SUM(sales) AS Revenue,
ROUND(
SUM(sales)*100/
(SELECT SUM(sales) FROM superstore),
2
) AS Revenue_Percentage
FROM superstore
GROUP BY category;

-- #29 First Purchase of Every Customer
SELECT
customer_id,
MIN(order_date) AS First_Order
FROM superstore
GROUP BY customer_id;

-- #30 Monthly Sales Trend
SELECT
YEAR(order_date) AS Year_,
MONTH(order_date) AS Month_,
SUM(sales) AS Sales
FROM superstore
GROUP BY
YEAR(order_date),
MONTH(order_date)
ORDER BY Year_,Month_;
-- #31 Top 3 Customers per Region
WITH cte AS
(
    SELECT
        region,
        customer_name,
        SUM(sales) AS total_sales,
        DENSE_RANK() OVER
        (
            PARTITION BY region
            ORDER BY SUM(sales) DESC
        ) AS rn
    FROM superstore
    GROUP BY region, customer_name
)
SELECT *
FROM cte
WHERE rn <= 3;

-- #32 Top 5 Products per Category
WITH cte AS
(
    SELECT
        category,
        product_name,
        SUM(sales) AS total_sales,
        DENSE_RANK() OVER
        (
            PARTITION BY category
            ORDER BY SUM(sales) DESC
        ) AS rn
    FROM superstore
    GROUP BY category, product_name
)
SELECT *
FROM cte
WHERE rn <= 5;

-- #33 Best Selling Product in Each Category
WITH cte AS
(
    SELECT
        category,
        product_name,
        SUM(sales) AS total_sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY category
            ORDER BY SUM(sales) DESC
        ) AS rn
    FROM superstore
    GROUP BY category, product_name
)
SELECT *
FROM cte
WHERE rn = 1;

-- #34 Worst Selling Product in Each Category
WITH cte AS
(
    SELECT
        category,
        product_name,
        SUM(sales) AS total_sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY category
            ORDER BY SUM(sales)
        ) AS rn
    FROM superstore
    GROUP BY category, product_name
)
SELECT *
FROM cte
WHERE rn = 1;

-- #35 Most Profitable Product in Each Category
WITH cte AS
(
    SELECT
        category,
        product_name,
        SUM(profit) AS total_profit,
        ROW_NUMBER() OVER
        (
            PARTITION BY category
            ORDER BY SUM(profit) DESC
        ) AS rn
    FROM superstore
    GROUP BY category, product_name
)
SELECT *
FROM cte
WHERE rn = 1;

-- #36 Running Sales Total by Year
SELECT
    year,
    SUM(sales) AS yearly_sales,
    SUM(SUM(sales))
    OVER(ORDER BY year)
    AS running_total
FROM superstore
GROUP BY year;

-- #37 Rank Countries by Sales
SELECT
    country,
    SUM(sales) AS total_sales,
    DENSE_RANK() OVER
    (
        ORDER BY SUM(sales) DESC
    ) AS country_rank
FROM superstore
GROUP BY country;

-- #38 Rank Customers by Profit
SELECT
    customer_name,
    SUM(profit) AS total_profit,
    DENSE_RANK() OVER
    (
        ORDER BY SUM(profit) DESC
    ) AS customer_rank
FROM superstore
GROUP BY customer_name;

-- #39 Monthly Revenue Trend
SELECT
    YEAR(order_date) AS yr,
    MONTH(order_date) AS mn,
    SUM(sales) AS revenue
FROM superstore
GROUP BY
YEAR(order_date),
MONTH(order_date)
ORDER BY yr,mn;

-- #40 Month-over-Month Growth %
WITH monthly_sales AS
(
    SELECT
        YEAR(order_date) AS yr,
        MONTH(order_date) AS mn,
        SUM(sales) AS revenue
    FROM superstore
    GROUP BY
    YEAR(order_date),
    MONTH(order_date)
)
SELECT
    *,
    ROUND(
        (
            revenue -
            LAG(revenue)
            OVER(ORDER BY yr,mn)
        )
        *100/
        LAG(revenue)
        OVER(ORDER BY yr,mn),
        2
    ) AS growth_pct
FROM monthly_sales;

-- #41 Year-over-Year Growth
WITH yearly_sales AS
(
    SELECT
        year,
        SUM(sales) AS revenue
    FROM superstore
    GROUP BY year
)
SELECT
    *,
    ROUND(
        (
            revenue -
            LAG(revenue)
            OVER(ORDER BY year)
        )
        *100/
        LAG(revenue)
        OVER(ORDER BY year),
        2
    ) AS yoy_growth
FROM yearly_sales;

-- #42 Revenue Contribution % by Category
SELECT
    category,
    SUM(sales) AS revenue,
    ROUND(
        SUM(sales)*100/
        (SELECT SUM(sales) FROM superstore),
        2
    ) AS revenue_pct
FROM superstore
GROUP BY category;

-- #43 Top 20 Customers by Revenue
SELECT
    customer_name,
    SUM(sales) AS revenue
FROM superstore
GROUP BY customer_name
ORDER BY revenue DESC
LIMIT 20;

-- #44 Most Frequently Ordered Products
SELECT
    product_name,
    COUNT(*) AS total_orders
FROM superstore
GROUP BY product_name
ORDER BY total_orders DESC
LIMIT 10;

-- #45 Highest Profit Order
SELECT
    order_id,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY order_id
ORDER BY total_profit DESC
LIMIT 10;


##1. Total Sales, Profit, Orders, Customers (KPI)

SELECT SUM(sales) AS Total_Sales FROM superstore;
SELECT SUM(profit) AS Total_Profit FROM superstore;
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM superstore;
SELECT COUNT(DISTINCT customer_id) AS Total_Customers FROM superstore;

##Sales by Category
SELECT
category,
SUM(sales) AS Total_Sales
FROM superstore
GROUP BY category
ORDER BY Total_Sales DESC;

##Top 3 Customers Per Region
WITH cte AS
(
SELECT
region,
customer_name,
SUM(sales) total_sales,
DENSE_RANK() OVER
(
PARTITION BY region
ORDER BY SUM(sales) DESC
) rn
FROM superstore
GROUP BY region,customer_name
)
SELECT *
FROM cte
WHERE rn<=3;

##Month-over-Month Growth
WITH monthly_sales AS
(
SELECT
YEAR(order_date) yr,
MONTH(order_date) mn,
SUM(sales) revenue
FROM superstore
GROUP BY YEAR(order_date),MONTH(order_date)
)
SELECT *,
ROUND(
(revenue-LAG(revenue)
OVER(ORDER BY yr,mn))
*100/
LAG(revenue)
OVER(ORDER BY yr,mn),
2
) growth_pct
FROM monthly_sales;


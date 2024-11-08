SELECT * FROM retail;

-- Renaming Columns

ALTER TABLE retail
RENAME COLUMN `Product Category` TO product_category;

ALTER TABLE retail
RENAME COLUMN `Transaction ID` TO transaction_id;

ALTER TABLE retail
RENAME COLUMN `Customer ID` TO customer_id;

ALTER TABLE retail
RENAME COLUMN `Price per Unit` TO price_per_unit;

ALTER TABLE retail
RENAME COLUMN `Total Amount` TO total_amount;


-- Demographic Influence:

-- 1. How does the age and gender of customers influence the total amount spent per transaction?

SELECT age, gender, SUM(total_amount) AS totaL_amount
FROM retail
GROUP BY age, gender
ORDER BY age, gender;

-- 2. What age group tends to purchase from each product category the most?
SELECT MIN(age), MAX(age)
FROM retail;

SELECT 
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group, 
    COUNT(*) AS count, 
    product_category
FROM retail
GROUP BY age_group, product_category
ORDER BY age_group, product_category;

-- Sales Trends Over Time:

-- 1. What are the monthly sales trends, and are there particular days of the week that generate higher sales?

-- Monthly Sales Trends
SELECT MONTH(date) AS month, SUM(total_amount) AS total_sales
FROM retail
GROUP BY month
ORDER BY month;

-- Daily Sales Trends
SELECT DAYNAME(date) AS day_of_week, SUM(total_amount) AS total_sales
FROM retail
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- Maximum, Minimum, and Average Sales
SELECT MIN(total_amount) AS min_sales, MAX(total_amount) AS max_sales, AVG(total_amount) as avg_sales
from retail;


-- 2. Are there seasonal trends evident in sales volumes across different product categories?

SELECT month, seasons, SUM(total_amount) AS total_sales
FROM 
(

SELECT MONTH(date) AS month,
 CASE
 WHEN MONTH(date) IN (3, 4, 5) THEN 'Spring'
 WHEN MONTH(date) IN (6, 7, 8) THEN 'Summer'
 WHEN MONTH(date) IN (9, 10, 11) THEN 'Autumn'
ELSE 'Winter'
END AS Seasons, total_amount
FROM retail

) AS seasons_data
GROUP BY  month, seasons
ORDER BY month;

-- Product Category Appeal:

-- 1. Which product categories generate the highest total revenue?

SELECT product_category, SUM(total_amount) AS total_amount
FROM retail
GROUP BY product_category;

-- 2. How does the average price per unit vary across different product categories?
SELECT product_category, AVG(price_per_unit) AS avg_price_per_unit
FROM retail
GROUP BY product_category;


-- Spending Patterns:

-- 1. What is the average transaction value for different age groups and genders?

SELECT 
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group, 
    gender,
    AVG(total_amount) AS avg_transaction
FROM retail
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 2. How does the quantity of items purchased relate to the total amount spent?

SELECT quantity, SUM(total_amount) AS total_sales
FROM retail
GROUP BY quantity
ORDER BY quantity;


-- Price Distribution:

-- 1. What is the distribution of product prices within each category, and are there any outliers?

SELECT DISTINCT(price_per_unit)
FROM retail
ORDER BY price_per_unit;

SELECT 
    product_category,
    CASE 
	WHEN price_per_unit < 25 THEN 'Below Low'
	WHEN price_per_unit BETWEEN 25 AND 150 THEN 'Low'
	WHEN price_per_unit BETWEEN 151 AND 300 THEN 'Medium'
	WHEN price_per_unit BETWEEN 301 AND 500 THEN 'High'
	ELSE 'Above High'
    END AS price_distribution,
    COUNT(*) AS count
FROM retail
GROUP BY product_category, price_distribution
ORDER BY product_category, FIELD(price_distribution, 'Low','Medium', 'High');

-- 2. How does the price per unit correlate with the quantity sold for each product category?

SELECT 
    product_category,
    CASE 
	WHEN price_per_unit < 25 THEN 'Below Low'
	WHEN price_per_unit BETWEEN 25 AND 150 THEN 'Low'
	WHEN price_per_unit BETWEEN 151 AND 300 THEN 'Medium'
	WHEN price_per_unit BETWEEN 301 AND 500 THEN 'High'
	ELSE 'Above High'
    END AS price_distribution,
    SUM(Quantity) AS total_quantity
FROM retail
GROUP BY product_category, price_distribution
ORDER BY product_category, FIELD(price_distribution, 'Low','Medium', 'High');

-- Customer Segmentation:

-- 1. How many unique customers are there, and what percentage of total sales do they represent?

SELECT 
    COUNT(DISTINCT Customer_id) AS unique_customers,
    SUM(total_amount) AS total_sales,
    (SUM(total_amount) / (SELECT SUM(total_amount) FROM retail) * 100) AS percentage_of_total_sales
FROM retail;



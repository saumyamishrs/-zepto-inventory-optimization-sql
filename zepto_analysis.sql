-- 1. DATABASE SETUP & SCHEMA CREATION

DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountpercent NUMERIC(5,2),
    availableQuantity INTEGER,
    discountSellingPrice NUMERIC(8,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER
);


-- 2. DATA EXPLORATION & AUDITING


-- Total records count
SELECT COUNT(*) FROM zepto;

-- Sample check
SELECT * FROM zepto
LIMIT 30;

-- Check for missing/NULL values across core fields
SELECT * FROM zepto
WHERE name IS NULL
   OR category IS NULL
   OR mrp IS NULL
   OR discountpercent IS NULL
   OR availableQuantity IS NULL
   OR discountSellingPrice IS NULL
   OR weightInGms IS NULL
   OR outOfStock IS NULL
   OR quantity IS NULL;

-- Unique product categories available
SELECT DISTINCT category 
FROM zepto
ORDER BY category;

-- Stock availability breakdown
SELECT outOfStock, COUNT(sku_id) AS total_skus
FROM zepto
GROUP BY outOfStock;

-- Identify duplicate product names if any
SELECT name, COUNT(sku_id) AS "No. of SKU" 
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

-- Identify free or invalid pricing records
SELECT * FROM zepto 
WHERE mrp = 0 OR discountSellingPrice = 0;


-- 3. DATA CLEANING & TRANSFORMATION


-- Remove invalid entries with zero price
DELETE FROM zepto WHERE mrp = 0;

-- Normalise decimal values for financial metrics
UPDATE zepto
SET mrp = mrp / 100.0,
    discountSellingPrice = discountSellingPrice / 100.0;

-- Verify transformed prices
SELECT name, mrp, discountSellingPrice FROM zepto LIMIT 10;


-- 4. BUSINESS CORE ANALYTICS (Q1 - Q8)


-- • Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

-- • Q2. What are the Products with High MRP but Out of Stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = TRUE AND mrp > 200
ORDER BY mrp DESC;

-- • Q3. Calculate Estimated Revenue for each category
SELECT category, SUM(discountSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

-- • Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountpercent 
FROM zepto
WHERE mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;

-- • Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
       ROUND(AVG(discountpercent), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5; 

-- • Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountSellingPrice,
       ROUND(discountSellingPrice / weightInGms, 4) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram ASC;

-- • Q7. Group the products into weight slabs (Low, Medium, Bulk)
SELECT DISTINCT name, weightInGms,
       CASE
           WHEN weightInGms < 1000 THEN 'Low'
           WHEN weightInGms < 5000 THEN 'Medium'
           ELSE 'Bulk'
       END AS weight_category
FROM zepto
ORDER BY weightInGms ASC;

-- • Q8. What is the Total Inventory Weight Per Category
SELECT category,
       SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;


-- 5. ADVANCED QUICK-COMMERCE INSIGHTS

-- • Q9. Proactive Restock Alert for Dark Store Managers (Urgent Supply Chain Management)
-- Filters items that are out of stock or approaching critical single-digit stock numbers.

SELECT category, name, availableQuantity,
       CASE 
           WHEN outOfStock = TRUE OR availableQuantity = 0 THEN 'Immediate Refill Needed'
           WHEN availableQuantity <= 5 THEN 'Critical Low Stock'
           ELSE 'Healthy Stock'
       END AS stock_urgency_status
FROM zepto
WHERE outOfStock = TRUE OR availableQuantity <= 5
ORDER BY availableQuantity ASC;

-- • Q10. Audit Query: Integrity Check for Price Anomalies
-- Checks for edge cases where the Selling Price accidentally exceeds the base MRP due to human input error.

SELECT sku_id, name, mrp, discountSellingPrice
FROM zepto
WHERE discountSellingPrice > mrp;

-- • Q11. Highest Discounted Product per Category (Advanced Window Function Analysis)
-- Demonstrates proficiency in Window Functions (DENSE_RANK) to pull the top deal for every section.

WITH RankedProducts AS (
    SELECT category, name, discountpercent,
           DENSE_RANK() OVER(PARTITION BY category ORDER BY discountpercent DESC) as item_rank
    FROM zepto
)
SELECT category, name, discountpercent
FROM RankedProducts
WHERE item_rank = 1;

-- • Q12. Identify Candidates for Value Pack/Combo Offers (Low Price + High Stock Volume)
-- Suggests slow-moving or heavily stocked items under ₹50 suitable for impulse bundle buying.

SELECT category, name, discountSellingPrice, availableQuantity
FROM zepto
WHERE discountSellingPrice < 50.00 AND availableQuantity > 50
ORDER BY availableQuantity DESC;

-- • Q13. Comprehensive Dark Store Inventory Valuation Dashboard
-- Executive-level rollup summary metric sheet showing stock sizes and financial value per category.

SELECT 
    category,
    COUNT(sku_id) AS total_unique_products,
    SUM(availableQuantity) AS total_stock_items,
    ROUND(SUM(discountSellingPrice * availableQuantity), 2) AS total_inventory_value,
    ROUND(AVG(discountpercent), 2) AS average_discount_rate
FROM zepto
GROUP BY category
ORDER BY total_inventory_value DESC;

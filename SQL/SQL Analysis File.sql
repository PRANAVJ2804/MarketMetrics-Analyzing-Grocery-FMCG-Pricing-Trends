create database MarketMetrics;
use MarketMetrics;

select * from `bigbasket products`;

# Which product categories have the highest and lowest average prices?
SELECT 
    category, AVG(sale_price) AS avg_sale_price
FROM
    `bigbasket products`
GROUP BY category
ORDER BY avg_sale_price DESC;


# Do brand-name products cost significantly more than unbranded products?
SELECT 
    CASE
        WHEN brand IS NULL OR brand = 'Unbranded' THEN 'Unbranded'
        ELSE 'Branded'
    END AS brand_type,
    AVG(sale_price) AS avg_price,
    COUNT(*) AS num_products
FROM
    `bigbasket products`
GROUP BY brand_type;


# Is there a pattern in pricing across product sizes or pack types?
SELECT 
    `type`, 
    AVG(sale_price) AS avg_price, 
    COUNT(*) AS count
FROM
    `bigbasket products`
GROUP BY `type`
ORDER BY avg_price DESC;


# What categories have the widest price dispersion (standard deviation)?
SELECT 
    category,
    STDDEV(sale_price) AS std_dev_price,
    COUNT(*) AS count
FROM
    `bigbasket products`
GROUP BY category
ORDER BY std_dev_price DESC;


# Can we identify clusters or groups based on price, category, and pack size?
SELECT 
    category,
    type,
    CASE
        WHEN sale_price < 50 THEN 'Low'
        WHEN sale_price < 200 THEN 'Mid'
        ELSE 'High'
    END AS price_range,
    COUNT(*) AS num_products
FROM
    `bigbasket products`
GROUP BY category , type , price_range
ORDER BY category , type , price_range;


#  Top 5 Expensive Items in Each Category
SELECT *
FROM (
    SELECT 
        *,
        RANK() OVER (PARTITION BY category ORDER BY sale_price DESC) AS price_rank
    FROM `bigbasket products`
) ranked
WHERE price_rank <= 5
ORDER BY category, sale_price DESC;


# Running Average Sale Price (Within Each Category)
SELECT
  *,
  AVG(sale_price) OVER (PARTITION BY category ORDER BY sale_price ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg_price
FROM `bigbasket products`
ORDER BY category, sale_price;


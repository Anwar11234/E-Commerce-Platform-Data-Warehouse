-- How long are the delay for delivery / shipping process in each state?

-- delay for delivery

-- If delay for delivery is the difference between delivery date and estimated 
-- time delivery
SELECT customer_state, 
ROUND(AVG(CAST(delivery_delay AS FLOAT)),2) AS [Average delay (days)]
FROM(
	SELECT DISTINCT f.order_key,delivery_delay ,customer_state
	FROM Orders_Fact f
	JOIN [Order] o
	ON f.order_key = o.order_key
	JOIN Customer c
	ON f.customer_key = c.customer_key
) S
GROUP BY customer_state
ORDER BY [Average delay (days)] DESC

-- If delay for delivery is the difference between order date and delivery date
WITH order_dates AS (
	SELECT 
		DISTINCT order_key,
		customer_state, 
		CAST(d1.date AS DATE) AS order_date,
		CAST(d2.date AS DATE) AS delivery_date
	FROM 
		Orders_Fact f
	JOIN Date d1
		ON d1.date_key = f.order_date_key
	JOIN Date d2
		ON d2.date_key = f.delivered_date_key
	JOIN Customer c
		ON c.customer_key = f.customer_key
	WHERE d1.date != 'unknown' AND d2.date != 'unknown'
)
SELECT 
	customer_state, 
	AVG(DATEDIFF(DAY,order_date, delivery_date)) AS [Average days to delivery]
FROM order_dates
GROUP BY customer_state
ORDER BY [Average days to delivery] DESC

-- delay for shipping
-- If delay for shipping is the difference between pickup date and pickup limit date
SELECT customer_state, 
ROUND(AVG(shipping_delay / 60),2) AS [Average shipping delay (hours)]
FROM(
	SELECT DISTINCT f.order_key,shipping_delay ,customer_state
	FROM Orders_Fact f
	JOIN [Order] o
	ON f.order_key = o.order_key
	JOIN Customer c
	ON f.customer_key = c.customer_key
) S
GROUP BY customer_state
ORDER BY [Average shipping delay (hours)] DESC

-- If delay for shipping is the difference between pickup date and delivery date
WITH order_dates AS (
	SELECT 
		DISTINCT order_key,
		customer_state, 
		CAST(d1.date AS DATE) AS pickup_date,
		CAST(d2.date AS DATE) AS delivery_date
	FROM 
		Orders_Fact f
	JOIN Date d1
		ON d1.date_key = f.pickup_date_key
	JOIN Date d2
		ON d2.date_key = f.delivered_date_key
	JOIN Customer c
		ON c.customer_key = f.customer_key
	WHERE d1.date != 'unknown' AND d2.date != 'unknown'
)
SELECT 
	customer_state, 
	AVG(DATEDIFF(DAY,pickup_date, delivery_date)) AS [Average days to shipping]
FROM order_dates
GROUP BY customer_state
ORDER BY [Average days to shipping] DESC
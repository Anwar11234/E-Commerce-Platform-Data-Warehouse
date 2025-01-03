-- How many late delivered order in our ecommerce? 
SELECT COUNT(DISTINCT f.order_key) AS [Number of Late Deliveries]
FROM Orders_Fact f
JOIN [Order] o
ON f.order_key = o.order_key
WHERE order_status = 'delivered' AND delivery_delay > 0

-- Are late order affecting the customer satisfaction?
WITH late_orders AS (
	SELECT DISTINCT f.order_key, feedback_score
	FROM Orders_Fact f
	JOIN [Order] o
	ON f.order_key = o.order_key 
	WHERE order_status = 'delivered' AND delivery_delay > 0
)
SELECT AVG(feedback_score) AS [Average Feedback Score]
FROM late_orders
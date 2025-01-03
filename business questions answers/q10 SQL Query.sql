-- How long are the difference between estimated delivery time 
-- and actual delivery time in each state?
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
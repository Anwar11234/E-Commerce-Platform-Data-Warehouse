-- What is the average spending time for user for our ecommerce?
SELECT ROUND(AVG(order_approval_time) / 60, 2) AS [Average Spending Time (hours) ]
FROM(
	SELECT DISTINCT o.order_key, order_approval_time
	FROM Orders_Fact f
	JOIN [Order] o
	ON f.order_key = o.order_key
) S
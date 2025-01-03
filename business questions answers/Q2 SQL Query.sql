-- What time users are most likely make an order or using the ecommerce app?
SELECT order_time_of_day, COUNT(DISTINCT f.order_key) AS [Total Orders]
FROM Orders_Fact f
JOIN [Order] o
ON f.order_key = o.order_key
GROUP BY order_time_of_day
ORDER BY [Total Orders] DESC
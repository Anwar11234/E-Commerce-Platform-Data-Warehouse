-- When is the peak season of our ecommerce ?
SELECT season, COUNT(DISTINCT order_key) AS [Total Orders]
FROM Orders_Fact f
JOIN Date d
ON f.order_date_key = d.date_key
GROUP BY season
ORDER BY [Total Orders] DESC
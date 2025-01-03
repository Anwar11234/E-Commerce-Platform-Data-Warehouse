-- Which logistic route that have heavy traffic in our ecommerce?
SELECT CONCAT(seller_city, ', ', seller_state, ' - ', customer_city, ', ', customer_state) AS [Logistic Route], 
COUNT(DISTINCT order_key) AS [Total Orders]
FROM Orders_Fact f
JOIN Seller s 
ON f.seller_key = s.seller_key
JOIN Customer c
ON f.customer_key = c.customer_key
GROUP BY CONCAT(seller_city, ', ', seller_state, ' - ', customer_city, ', ', customer_state)
ORDER BY [Total Orders] DESC
-- What is the frequency of purchase on each state?
SELECT customer_state, COUNT(DISTINCT order_key) AS [Total Orders]
FROM Orders_Fact f
JOIN Customer c
ON f.customer_key = c.customer_key
GROUP BY customer_state
ORDER BY [Total Orders] DESC
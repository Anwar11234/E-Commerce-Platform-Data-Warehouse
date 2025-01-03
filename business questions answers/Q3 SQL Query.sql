-- What is the preferred way to pay in the ecommerce?
SELECT payment_method_description, COUNT(payment_method_description) AS [Number of times used]
FROM payment_fact pf
JOIN payment_method pm
ON pf.payment_method_key = pm.payment_method_key
WHERE payment_method_description != 'not_defined'
GROUP BY payment_method_description
ORDER BY [Number of times used] DESC
-- How many installment is usually done when paying in the ecommerce?
SELECT AVG(payment_installments) AS [Average Installments]
FROM payment_fact pf
JOIN payment_method pm
ON pf.payment_method_key = pm.payment_method_key
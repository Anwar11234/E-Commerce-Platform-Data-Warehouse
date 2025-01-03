CREATE TABLE payment_method(
	payment_method_key INT PRIMARY KEY,
	payment_method_description VARCHAR(20)
)

CREATE TABLE payment_fact(
	order_key INT, 
	payment_method_key INT,
	payment_sequential INT,
	payment_installments INT,
	payment_value FLOAT,
	PRIMARY KEY (order_key, payment_method_key, payment_sequential),
	FOREIGN KEY (order_key) REFERENCES [Order](order_key),
	FOREIGN KEY (payment_method_key) REFERENCES payment_method(payment_method_key)
)
# E-Commerce Platform Data Warehouse

This project is part of [the data engineering mentorship program](https://github.com/ahmedshaaban1999/Data_Engineering_Mentorship). 

### Project Overview:
Ecommerce website dataset is ready for you to build data warehouse for to answer business questions. The project consist of 3 main phases.

1. Building data warehouse model to serve business queries.
2. Building ETL pipeline to land data into the warehouse.
3. Run analytical queries to answer business questions

### Resources:
Ecommerce data set on git project folder

### requirements:
- Design Data warehouse schema.
- Build ETL pipeline to load data into DW
- Answer Below business questions:
    - When is the peak season of our ecommerce ?
    - What time users are most likely make an order or using the ecommerce app?
    - What is the preferred way to pay in the ecommerce?
    - How many installment is usually done when paying in the ecommerce?
    - What is the average spending time for user for our ecommerce?
    - What is the frequency of purchase on each state?
    - Which logistic route that have heavy traffic in our ecommerce?
    - How many late delivered order in our ecommerce? Are late order affecting the customer satisfaction?
    - How long are the delay for delivery / shipping process in each state?
    - How long are the difference between estimated delivery time and actual delivery time in each state?

### Data Warehouse Data Model
Based on the given data and requirements, I designed a data warehouse schema that models 2 business processes:

1. **Ordering**: The process of customers placing orders on the ecommerce platform, this process has dimensions **Date**, **Customer**, **Seller**, **Product**, and **Order**. And a fact table with granularity of one row per order item. 

![ordering data model](<Data Model/Orders.png>)

2. **Payment**: The process of customers paying for their orders, this process has dimensions **Order** and **Payment Method**. And a fact table with granularity of one row per payment operation per order.

![payment data model](<Data Model/Payment.png>)

### ETL Pipeline 

- Python was used as an ETL tool to extract the data from the given CSV file, perform necessary transformations, and load the data into the data model. 

- ETL scripts for the order data model can be found in the `Orders` directory, and scripts for payment data model can be found in the `Payment` directory.

- The file `main.py` is the entry point for running the pipeline to load both data models.

### Business Questions Answered

#### When is the peak season of our ecommerce ?
```sql
    SELECT season, COUNT(DISTINCT order_key) AS [Total Orders]
    FROM Orders_Fact f
    JOIN Date d
    ON f.order_date_key = d.date_key
    GROUP BY season
    ORDER BY [Total Orders] DESC
```

**Result**:
![alt text](<business questions answers/q1 result.png>)

#### What time users are most likely make an order or using the ecommerce app?
```sql
    SELECT order_time_of_day, COUNT(DISTINCT f.order_key) AS [Total Orders]
    FROM Orders_Fact f
    JOIN [Order] o
    ON f.order_key = o.order_key
    GROUP BY order_time_of_day
    ORDER BY [Total Orders] DESC
```

**Result**:
![alt text](<business questions answers/q2 result.png>)

#### What is the preferred way to pay in the ecommerce?
```sql
    SELECT 
        payment_method_description, 
        COUNT(payment_method_description) AS [Number of times used]
    FROM 
        payment_fact pf
    JOIN 
        payment_method pm
    ON 
        pf.payment_method_key = pm.payment_method_key
    WHERE 
        payment_method_description != 'not_defined'
    GROUP BY 
        payment_method_description
    ORDER BY 
        [Number of times used] DESC
```

**Result**:
![alt text](<business questions answers/q3 result.png>)

#### How many installment is usually done when paying in the ecommerce?
```sql
    SELECT 
        AVG(payment_installments) AS [Average Installments]
    FROM 
        payment_fact pf
    JOIN 
        payment_method pm
    ON 
        pf.payment_method_key = pm.payment_method_key
```

**Result**:
![alt text](<business questions answers/q4 result.png>)

#### What is the average spending time for user for our ecommerce?
Based on my understanding of the data, the spending time for a user is the duration from when the user places the order until the payment is approved, which is the difference between `order_date` and `order_approval_date`

```sql
    SELECT 
        ROUND(AVG(order_approval_time) / 60, 2) AS [Average Spending Time (hours) ]
    FROM(
        SELECT 
            DISTINCT o.order_key, order_approval_time
        FROM 
            Orders_Fact f
        JOIN 
            [Order] o
        ON 
            f.order_key = o.order_key
    ) S
```

**Result**:
![alt text](<business questions answers/q5 result.png>)

#### What is the frequency of purchase on each state?
```sql
    SELECT 
        customer_state, 
        COUNT(DISTINCT order_key) AS [Total Orders]
    FROM 
        Orders_Fact f
    JOIN 
        Customer c
    ON 
        f.customer_key = c.customer_key
    GROUP BY 
        customer_state
    ORDER BY 
        [Total Orders] DESC
```

**Result**:
![alt text](<business questions answers/q6 result.png>)

#### Which logistic route that have heavy traffic in our ecommerce?
```sql
    SELECT 
        CONCAT(seller_city, ', ', seller_state, ' - ', customer_city, ', ', customer_state) AS [Logistic Route], 
        COUNT(DISTINCT order_key) AS [Total Orders]
    FROM 
        Orders_Fact f
    JOIN 
        Seller s 
    ON 
        f.seller_key = s.seller_key
    JOIN 
        Customer c
    ON 
        f.customer_key = c.customer_key
    GROUP BY 
        CONCAT(seller_city, ', ', seller_state, ' - ', customer_city, ', ', customer_state)
    ORDER BY 
        [Total Orders] DESC
```

**Result**:
![alt text](<business questions answers/q7 result.png>)

#### How many late delivered order in our ecommerce? Are late order affecting the customer satisfaction?

**Number of late deliveries:**
```sql
    SELECT 
        COUNT(DISTINCT f.order_key) AS [Number of Late Deliveries]
    FROM 
        Orders_Fact f
    JOIN 
        [Order] o
    ON 
        f.order_key = o.order_key
    WHERE 
        order_status = 'delivered' AND delivery_delay > 0
```

**Result**:
![alt text](<business questions answers/q8.1 result.png>)

**Average feedback score for late orders:**
```sql
    WITH late_orders AS (
        SELECT DISTINCT f.order_key, feedback_score
        FROM Orders_Fact f
        JOIN [Order] o
        ON f.order_key = o.order_key 
        WHERE order_status = 'delivered' AND delivery_delay > 0
    )
    SELECT AVG(feedback_score) AS [Average Feedback Score]
    FROM late_orders
```

**Result**:
![alt text](<business questions answers/q8.2 result.png>)

The average feedback score is low for late orders, so late deliveries are affecting customer satisfaction.

#### How long are the delay for delivery / shipping process in each state?

Delay for delivery can be defined as either:
- The number of days between order date and delivery date. In this case the answer will be: 
```sql
    SELECT 
        customer_state, 
        ROUND(AVG(CAST(delivery_delay AS FLOAT)),2) AS [Average delay (days)]
    FROM(
        SELECT 
            DISTINCT f.order_key,
            delivery_delay ,
            customer_state
        FROM 
            Orders_Fact f
        JOIN 
            [Order] o
        ON 
            f.order_key = o.order_key
        JOIN 
            Customer c
        ON 
            f.customer_key = c.customer_key
    ) S
    GROUP BY 
        customer_state
    ORDER BY 
        [Average delay (days)] DESC
```
**Result**:
![alt text](<business questions answers/q9.1.1 result.png>)

- Or it can be The number of days between delivery date and estimated time delivery, and the answer in this case will be:

```sql
WITH order_dates AS (
	SELECT 
		DISTINCT order_key,
		customer_state, 
		CAST(d1.date AS DATE) AS order_date,
		CAST(d2.date AS DATE) AS delivery_date
	FROM 
		Orders_Fact f
	JOIN Date d1
		ON d1.date_key = f.order_date_key
	JOIN Date d2
		ON d2.date_key = f.delivered_date_key
	JOIN Customer c
		ON c.customer_key = f.customer_key
	WHERE d1.date != 'unknown' AND d2.date != 'unknown'
)
SELECT 
	customer_state, 
	AVG(DATEDIFF(DAY,order_date, delivery_date)) AS [Average days to delivery]
FROM 
    order_dates
GROUP BY 
    customer_state
ORDER BY 
    [Average days to delivery] DESC
```

**Result**:
![alt text](<business questions answers/q9.1.2 result.png>)

Similarly, shipping delay can be defined in 2 ways:

1. The difference between pickup date and pickup limit date

```sql
SELECT 
    customer_state, 
    ROUND(AVG(shipping_delay / 60),2) AS [Average shipping delay (hours)]
FROM(
	SELECT 
        DISTINCT f.order_key,
        shipping_delay,
        customer_state
	FROM 
        Orders_Fact f
	JOIN 
        [Order] o
	ON 
        f.order_key = o.order_key
	JOIN 
        Customer c
	ON 
        f.customer_key = c.customer_key
) S
GROUP BY 
    customer_state
ORDER BY 
    [Average shipping delay (hours)] DESC
```

**Result**:
![alt text](<business questions answers/q9.2.1 result.png>)

2. The difference between pickup date and delievery date

```sql
WITH order_dates AS (
	SELECT 
		DISTINCT order_key,
		customer_state, 
		CAST(d1.date AS DATE) AS pickup_date,
		CAST(d2.date AS DATE) AS delivery_date
	FROM 
		Orders_Fact f
	JOIN Date d1
		ON d1.date_key = f.pickup_date_key
	JOIN Date d2
		ON d2.date_key = f.delivered_date_key
	JOIN Customer c
		ON c.customer_key = f.customer_key
	WHERE d1.date != 'unknown' AND d2.date != 'unknown'
)
SELECT 
	customer_state, 
	AVG(DATEDIFF(DAY,pickup_date, delivery_date)) AS [Average days to shipping]
FROM 
    order_dates
GROUP BY 
    customer_state
ORDER BY 
    [Average days to shipping] DESC
```

**Result**:
![alt text](<business questions answers/q9.2.2 result.png>)

#### How long are the difference between estimated delivery time and actual delivery time in each state?
```sql
    SELECT 
        customer_state, 
        ROUND(AVG(CAST(delivery_delay AS FLOAT)),2) AS [Average delay (days)]
    FROM(
        SELECT 
            DISTINCT f.order_key,delivery_delay ,customer_state
        FROM 
            Orders_Fact f
        JOIN 
            [Order] o
        ON 
            f.order_key = o.order_key
        JOIN 
            Customer c
        ON 
            f.customer_key = c.customer_key
    ) S
    GROUP BY 
        customer_state
    ORDER BY 
        [Average delay (days)] DESC
```

**Result**:
![alt text](<business questions answers/q10 result.png>)
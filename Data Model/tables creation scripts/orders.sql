CREATE TABLE Date (
    date_key INT PRIMARY KEY,
    date VARCHAR(20) NOT NULL,
    full_date_description VARCHAR(100),
    day_of_week VARCHAR(50),
    calendar_month VARCHAR(50),
    calendar_quarter VARCHAR(50),
    calendar_year INT,
    season VARCHAR(50),
    holiday_indicator VARCHAR(11),
    weekday_indicator CHAR(7)
);

CREATE TABLE Customer (
    customer_key INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
	customer_zip_code VARCHAR(20),
    customer_city VARCHAR(100),
    customer_state VARCHAR(50)
);

CREATE TABLE Seller (
    seller_key INT PRIMARY KEY,
    seller_id VARCHAR(50) NOT NULL,
    seller_zip_code VARCHAR(20),
    seller_city VARCHAR(100),
    seller_state VARCHAR(50)
);

CREATE TABLE Product (
    product_key INT PRIMARY KEY,
    product_id VARCHAR(50) NOT NULL,
    product_category VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g FLOAT,
    product_length_cm FLOAT,
    product_height_cm FLOAT,
    product_width_cm FLOAT
);

CREATE TABLE [Order] (
    order_key INT PRIMARY KEY,
    order_id NVARCHAR(50) NOT NULL,
    feedback_score INT,
    delivery_delay INT,
    shipping_delay FLOAT,
    order_approval_time FLOAT,
    order_status VARCHAR(50),
    order_time_of_day VARCHAR(50)
);

CREATE TABLE Orders_Fact (
    order_key INT NOT NULL,
    order_date_key INT NOT NULL,
    order_approved_date_key INT,
    pickup_date_key INT,
    delivered_date_key INT,
    estimated_time_delivery_key INT,
    pickup_limit_date_key INT,
    order_item_id INT,
    customer_key INT NOT NULL,
    seller_key INT NOT NULL,
    product_key INT NOT NULL,
    price FLOAT,
    shipping_cost FLOAT,
    PRIMARY KEY (order_key, order_item_id),
    FOREIGN KEY (order_date_key) REFERENCES Date(date_key),
    FOREIGN KEY (order_approved_date_key) REFERENCES Date(date_key),
    FOREIGN KEY (pickup_date_key) REFERENCES Date(date_key),
    FOREIGN KEY (delivered_date_key) REFERENCES Date(date_key),
    FOREIGN KEY (estimated_time_delivery_key) REFERENCES Date(date_key),
    FOREIGN KEY (pickup_limit_date_key) REFERENCES Date(date_key),
    FOREIGN KEY (customer_key) REFERENCES Customer(customer_key),
    FOREIGN KEY (seller_key) REFERENCES Seller(seller_key),
    FOREIGN KEY (product_key) REFERENCES Product(product_key)
);

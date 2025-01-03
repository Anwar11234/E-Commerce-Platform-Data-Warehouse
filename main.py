from config import destination_engine
from Orders.date_dim import date_df
from Orders.order_dim import order_df
from Orders.orders_fact import order_item_df
from Orders.product_dim import product_df
from Orders.seller_dim import seller_df
from Orders.user_dim import user_df
from Payment.payment_fact import payment_df, payment_method_df

if __name__ == '__main__':
    date_df.to_sql('Date', destination_engine, if_exists='append', index = False)

    user_df.to_sql('Customer', destination_engine, if_exists='append', index = False)

    seller_df.to_sql('Seller', destination_engine, if_exists='append', index = False)

    product_df.to_sql('Product', destination_engine, if_exists='append', index = False)

    order_df.to_sql('Order', destination_engine, if_exists = 'append', index = False)

    order_item_df.to_sql('Orders_Fact', destination_engine, if_exists = 'append', index = False)

    payment_method_df.to_sql('payment_method', destination_engine, if_exists='append', index = False)

    payment_df.to_sql('payment_fact', destination_engine, if_exists='append', index = False)
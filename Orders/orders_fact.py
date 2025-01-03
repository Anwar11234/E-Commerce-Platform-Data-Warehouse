from Orders.order_dim import order_item_df, date_cols
from Orders.product_dim import product_df
from Orders.user_dim import user_df
from Orders.seller_dim import seller_df
from Orders.date_dim import date_df
from global_utils import lookup_keys

order_item_df = lookup_keys(order_item_df, product_df, 'product_id', 'product_id', 'product_key')

order_item_df = lookup_keys(order_item_df, user_df[['customer_name', 'customer_key']], 'user_name', 'customer_name', 'customer_key')

order_item_df = lookup_keys(order_item_df, seller_df, 'seller_id', 'seller_id', 'seller_key')

for col in date_cols:
    order_item_df = lookup_keys(order_item_df, date_df, col, 'date', 'date_key', 'left', f"{col}_key")

order_item_df = order_item_df[list(order_item_df.columns[3:]) + list(order_item_df.columns[:3])]
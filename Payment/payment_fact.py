import pandas as pd
from global_utils import lookup_keys
from Orders.order_dim import order_df

payment_df = pd.read_csv('Data/payment_dataset.csv')

payment_method_df = pd.DataFrame({'payment_method_description':payment_df.payment_type.unique()})

payment_method_df['payment_method_key'] = payment_method_df.index + 1

payment_df = lookup_keys(payment_df, order_df, 'order_id', 'order_id', 'order_key')

payment_df = lookup_keys(payment_df, payment_method_df, 'payment_type', 'payment_method_description', 'payment_method_key')
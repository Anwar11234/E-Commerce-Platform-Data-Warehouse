import pandas as pd
from Orders.order_utils import calculate_delay, process_date_columns

order_df = pd.read_csv('Data/order_dataset.csv')
feedback_df = pd.read_csv('Data/feedback_dataset.csv')
order_item_df = pd.read_csv('Data/order_item_dataset.csv')

date_cols = ['order_date','order_approved_date', 'pickup_date', 'delivered_date','pickup_limit_date', 'estimated_time_delivery']

order_df = order_df.merge(order_item_df[['order_id', 'pickup_limit_date']], on = 'order_id', how = 'left').drop_duplicates(subset = ['order_id'], keep = 'first').reset_index(drop = True)
order_item_df.drop('pickup_limit_date', axis = 1, inplace = True)

order_df = calculate_delay(order_df, 'pickup_date', 'pickup_limit_date', 'shipping_delay', time_unit='minutes')
order_df = calculate_delay(order_df, 'delivered_date', 'estimated_time_delivery', 'delivery_delay', time_unit='days')

order_df['order_time_of_day'] = pd.to_datetime(order_df['order_date']).dt.strftime('%I %p')
order_df['order_approval_time'] = (pd.to_datetime(order_df['order_approved_date']) - pd.to_datetime(order_df['order_date'])).dt.total_seconds() / 60

order_df = process_date_columns(order_df, date_cols)

order_df['feedback_score'] = order_df.merge(feedback_df.drop_duplicates(subset = 'order_id', keep = 'first'), on = 'order_id', how = 'inner')['feedback_score']

order_df['order_key'] = order_df.index + 1

order_item_df = order_item_df.merge(order_df[['order_id','user_name','order_date',
       'order_approved_date', 'pickup_date', 'delivered_date',
       'estimated_time_delivery', 'pickup_limit_date', 'order_key']], on = 'order_id', how = 'left').drop('order_id', axis = 1)

order_df = order_df.drop(['user_name', 'order_date',
       'order_approved_date', 'pickup_date', 'delivered_date',
       'estimated_time_delivery', 'pickup_limit_date'], axis = 1)

order_df = order_df[[order_df.columns[-1]] + list(order_df.columns[:-1])]
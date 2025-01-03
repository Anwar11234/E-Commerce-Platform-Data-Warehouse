import pandas as pd

user_df = pd.read_csv('Data/user_dataset.csv')
user_df = user_df.rename(columns = {'user_name': 'customer_name'})

user_df = user_df.drop_duplicates(subset = 'customer_name', keep = 'last').reset_index(drop = True)

user_df['customer_key'] = user_df.index + 1
import pandas as pd

seller_df = pd.read_csv('Data/seller_dataset.csv')

seller_df['seller_key'] = seller_df.index + 1
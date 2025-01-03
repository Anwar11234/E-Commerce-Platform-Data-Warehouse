import pandas as pd

product_df = pd.read_csv('Data/products_dataset.csv')

product_df['product_key'] = product_df.index + 1

product_df = product_df.rename(columns = {'product_name_lenght': 'product_name_length','product_description_lenght': 'product_description_length'})

import pandas as pd
import numpy as np

def calculate_delay(df, actual_date_col, expected_date_col, delay_col, time_unit='minutes'):
    if time_unit == 'minutes':
        df[delay_col] = np.where(
            pd.to_datetime(df[actual_date_col]) > pd.to_datetime(df[expected_date_col]),
            (pd.to_datetime(df[actual_date_col]) - pd.to_datetime(df[expected_date_col])).dt.total_seconds() / 60,
            0
        )
    elif time_unit == 'days':
        df[delay_col] = np.where(
            pd.to_datetime(df[actual_date_col]) > pd.to_datetime(df[expected_date_col]),
            (pd.to_datetime(df[actual_date_col]) - pd.to_datetime(df[expected_date_col])).dt.days,
            0
        )
    return df

def process_date_columns(df, date_cols):
    for col in date_cols:
        df[col] = pd.to_datetime(df[col]).dt.strftime('%Y-%m-%d')
        df[col].fillna('unknown', inplace=True)
    return df

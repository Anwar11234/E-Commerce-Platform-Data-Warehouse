import pandas as pd
import numpy as np
from datetime import datetime
from pandas.tseries.holiday import USFederalHolidayCalendar

start_date = datetime(2016, 1, 1) 
end_date = datetime(2036, 12, 31)
date_range = pd.date_range(start=start_date, end=end_date)
cal = USFederalHolidayCalendar()
holidays = cal.holidays(start=start_date, end=end_date).to_pydatetime()

date_df = pd.DataFrame({
    'date_key': date_range.strftime('%Y%m%d').astype(int),
    'date': date_range.strftime('%Y-%m-%d'),  
    'full_date_description': date_range.strftime('%A, %B %d, %Y'), 
    'day_of_Week': date_range.strftime('%A'),  
    'calendar_month': date_range.strftime('%B'),  
    'calendar_quarter': 'Q' + ((date_range.month - 1) // 3 + 1).astype(str),
    'calendar_year': date_range.year,  
    'season': np.where(date_range.month.isin([12, 1, 2]), 'winter',
                       np.where(date_range.month.isin([3, 4, 5]), 'spring',
                                np.where(date_range.month.isin([6, 7, 8]), 'summer', 'fall'))), 
    'weekday_indicator': np.where(date_range.weekday < 5, 'weekday', 'weekend')
})

date_df['holiday_indicator'] = np.where(date_df['date'].isin(holidays), 'holiday', 'non-holiday')

unknown_date = {'date_key': -1,
    'date': 'unknown',  
    'full_date_description': 'unknown', 
    'day_of_Week': 'unknown',  
    'calendar_month': 'unknown',  
    'calendar_quarter': 'unknown',
    'calendar_year': 0,  
    'season': 'unknown', 
    'weekday_indicator': 'unknown',
    'holiday_indicator': 'unknown'
}

date_df.loc[len(date_df)] = unknown_date
def lookup_keys(fact_df, dim_df, fact_join_col, dim_join_col, key_col,how = 'left',  new_key_col_name = None):
    fact_df = fact_df.merge(dim_df[[dim_join_col, key_col]], left_on = fact_join_col, right_on = dim_join_col, how = how)
    if fact_join_col != dim_join_col:
        fact_df = fact_df.drop([fact_join_col, dim_join_col], axis = 1)
    else:
        fact_df = fact_df.drop([dim_join_col], axis = 1)

    if new_key_col_name:
        fact_df = fact_df.rename(columns = {key_col: new_key_col_name})
    
    return fact_df
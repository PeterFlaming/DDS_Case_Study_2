
# Define Custom Functions

summarize_frame <- function(df)
{
  #returns table of summary statistics for each numberic column in dataframe
  as.data.frame(summarytools::descr(df, transpose = TRUE)) %>%
    rownames_to_column('attribute') %>%
    mutate_if(is.numeric, round) %>%
    column_to_rownames('attribute') %>%
    select(Mean, Median, Min, Max, Std.Dev, Q1, Q3, IQR, N.Valid, Pct.Valid) 
  
  
}

standardize_names <- function(df) 
{  
  df %>% 
    rename_all(gsub, pattern = '[[:punct:] ]+', replacement = '') %>%
    rename_all(tolower) %>%
    rename_all(trimws)

}



# 
# 
# # df <- fracfocus
# df %>% standardize_names() %>% head()
# 
# 
# 
# 








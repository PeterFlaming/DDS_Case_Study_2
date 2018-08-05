
# Define Custom Functions


## @knitr functions
summarize_frame <- function(frameframe)
{
    #returns table of summary statistics for each numeric column in dataframe
    as.data.frame(summarytools::descr(frameframe, transpose = TRUE)) %>%
    rownames_to_column('attribute') %>%
    mutate_if(is.numeric, round) %>%
    column_to_rownames('attribute') %>%
    select(Mean, Median, Min, Max, Std.Dev, Q1, Q3, IQR, N.Valid, Pct.Valid) 
  
  
}

#standardizes column names for consistency and readability, including trimming
#whitespace
standardize_names <- function(frameframe) 
{  
    frameframe %>% 
    rename_all(gsub, pattern = '[[:punct:] ]+', replacement = '') %>%
    rename_all(tolower) %>%
    rename_all(trimws)

}









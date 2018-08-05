
# Define Custom Functions


## @knitr functions
summarize_frame <- function(frameframe)
{
<<<<<<< HEAD
    #returns table of summary statistics for each numberic column in dataframe
    x <- as.data.frame(summarytools::descr(frameframe, transpose = TRUE)) %>%
    rownames_to_column('Attribute') %>%
=======
    # returns table of summary statistics for each numeric column in dataframe
    as.data.frame(summarytools::descr(frameframe, transpose = TRUE)) %>%
    rownames_to_column('attribute') %>%
>>>>>>> 3b02cc0fe237137980570ffe7cfe13cd29e4e3fd
    mutate_if(is.numeric, round) %>%
    column_to_rownames('Attribute') %>%
    select(Mean, Median, Min, Max, Std.Dev, Q1, Q3, IQR, N.Valid, Pct.Valid) 
  
    x
}

# standardizes column names for consistency and readability, including trimming
# whitespace
standardize_names <- function(frameframe) 
{  
    frameframe %>% 
    rename_all(gsub, pattern = '[[:punct:] ]+', replacement = '') %>%
    rename_all(tolower) %>%
    rename_all(trimws)

}

kable_zen <- function(frameframe)
{
    kable(frameframe) %>%
    kable_styling(position = "center"
                 ,full_width = FALSE)




#   kable_styling(bootstrap_options = c("striped", "hover", "condensed"))
#   kable_styling(bootstrap_options = "striped", full_width = F, position = "float_right"























}



# frameframe = welldata
# as.data.frame(summarytools::descr(frameframe, transpose = TRUE)) %>%
#     rownames_to_column('Attribute') %>%
#     mutate_if(is.numeric, round) %>%
#     #column_to_rownames('attribute') %>%
#     select(Attribute, Mean, Median, Min, Max, Std.Dev, Q1, Q3, IQR, N.Valid, Pct.Valid) 
  
  
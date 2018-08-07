
#TODO: cleanup the commented code in this bad boy

# Define Custom Functions

#U.STATS <- c("mean", "sd", "min", "med", "max", "Q1", "Q3", "N.Valid")


# analogous palette
COL.A.G = '#CDFFAC'
COL.A.B = '#87E4E8'
COL.A.P = '#9F6FFF'
COL.A.R = '#E8A8A4'
COL.A.O = '#FFDA81'

# monochromatic greens
COL.M.G1 = '#1A7F67'
COL.M.G2 = '#81FFE0'
COL.M.G3 = '#34FFCE'
COL.M.G4 = '#407F70'
COL.M.G5 = '#2ACCA4'

# complementary
COL.CO.G1 = '#56B262'
COL.CO.G2 = '#AEFFB8'
COL.CO.G3 = '#94FFA2'
COL.CO.I4 = '#adb5bd'
COL.CO.P5 = '#adb5bd'


# compound palette
COL.CP.B1 = '#7EA3CC' # muted blue
COL.CP.B2 = '#3F6999' # navy blue
COL.CP.B3 = '#CEFFFF' # pale blue
COL.CP.O4 = '#FFA58B' # pale orange
COL.CP.N5 = '#CCB1AE' # light brown

COL.SPBY_U = '#354A73'
COL.SPBY_M = '#4D6BA6'
COL.SPBY_L_SILT = '#2A3A59'
COL.SPBY_JO_MILL = '#6877A6'
COL.SPBY_L_SHALE = '#002673'
COL.DEAN = '#A80084'
COL.WFMP_A = '#A80000'
COL.WFMP_B = '#A8A800'
COL.WFMP_B_LOWER = '#737300'
COL.WFMP_C = '#38A800'
COL.WFMP_C_TARGET = '#56B262'
COL.WFMP_D = '#9C9C9C'
COL.STRAWN = '#828282'
COL.UNKNOWN = '#B730E8'
COL.GRID_ERROR = '#E1E1E1'

COL.ALLFORMS <- c("SPBY_U" = COL.SPBY_U
                , "SPBY_M" = COL.SPBY_M
                , "SPBY_L_SILT" = COL.SPBY_L_SILT
                , "SPBY_JO_MILL" = COL.SPBY_JO_MILL
                , "SPBY_L_SHALE" = COL.SPBY_L_SHALE
                , "DEAN" = COL.DEAN
                , "WFMP_A" = COL.WFMP_A
                , "WFMP_B" = COL.WFMP_B
                , "WFMP_B_LOWER" = COL.WFMP_B_LOWER
                , "WFMP_C" = COL.WFMP_C
                , "WFMP_C_TARGET" = COL.WFMP_C_TARGET
                , "WFMP_D" = COL.WFMP_D
                , "STRAWN" = COL.STRAWN
                , "UNKNOWN" = COL.UNKNOWN
                , "GRID_ERROR" = COL.GRID_ERROR
                )

WFMP_FORMS <- c(  "WFMP_A"
                , "WFMP_B"
                , "WFMP_B_LOWER"
                , "WFMP_C"
                , "WFMP_C_TARGET"
                , "WFMP_D"
                )

## @knitr functions
summarize_frame <- function(frameframe)
{
    #returns table of summary statistics for each numeric column in dataframe
    #summarytools::descr(frameframe, transpose = TRUE) #%>%

    #frameframe %<>% as.data.frame()

    descr(frameframe, transpose = TRUE)
   
    # NOTE TO FUTURE SELF: summarytools::descr is NOT frieldly with the pipe tools. 

   #cnames <- frameframe %>% select_if(is.numeric) %>% colnames()

    
    #    #t() %>%
    #    #rownames_to_column('Attribute') %>%
    #    #descr()
    #    #as.data.frame() %>%
    #    #rownames_to_column('Attribute')
    #    #%>%
   #descr(stats = c("mean", "sd", "min", "med", "max"), transpose = TRUE)

   # row.names(frameframe) <- cnames

   # frameframe %>% as.tibble()
   
    # mutate_if(is.numeric, round) %>%
    # column_to_rownames('Attribute') %>%
    #select(Mean, Median, Min, Max, Std.Dev, Q1, Q3, IQR, N.Valid, Pct.Valid) 
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


# ff_summary %>% head()

# frameframe <- ff_summary %>% head(10)

#     frameframe %<>% as.data.frame()

#    cnames <- frameframe %>% select_if(is.numeric) %>% colnames()

#    frameframe %>% as.data.frame() %>%
#    select_if(is.numeric)  %>% descr()
# #    #t() %>%
# #    #rownames_to_column('Attribute') %>%
# #    #descr()
# #    #as.data.frame() %>%
# #    #rownames_to_column('Attribute')
# #    #%>%
#    descr(frameframe, stats = c("mean", "sd", "min", "med", "max"))

#    row.names(frameframe) <- cnames

#    frameframe %>% as.tibble()


#    class(frameframe)
# ff_summary %>% head()

# frameframe <- ff_summary %>% head(10)

#     frameframe %<>% as.data.frame()

#    cnames <- frameframe %>% select_if(is.numeric) %>% colnames()

#    frameframe %>% as.data.frame() %>%
#    select_if(is.numeric)  %>% descr()
# #    #t() %>%
# #    #rownames_to_column('Attribute') %>%
# #    #descr()
# #    #as.data.frame() %>%
# #    #rownames_to_column('Attribute')
# #    #%>%
#    descr(frameframe, stats = c("mean", "sd", "min", "med", "max"))

#    row.names(frameframe) <- cnames

#    frameframe %>% as.tibble()


#    class(frameframe)
# ff_summary %>% head()

# frameframe <- ff_summary %>% head(10)

#     frameframe %<>% as.data.frame()

#    cnames <- frameframe %>% select_if(is.numeric) %>% colnames()

#    frameframe %>% as.data.frame() %>%
#    select_if(is.numeric)  %>% descr()
# #    #t() %>%
# #    #rownames_to_column('Attribute') %>%
# #    #descr()
# #    #as.data.frame() %>%
# #    #rownames_to_column('Attribute')
# #    #%>%
#    descr(frameframe, stats = c("mean", "sd", "min", "med", "max"))

#    row.names(frameframe) <- cnames

#    frameframe %>% as.tibble()


#    class(frameframe)

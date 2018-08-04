#setwd('C:\\Repositories\\DDS_Case_Study_2\\src')
source('Setup.R')
source('Functions.R')

well_data <- read.csv("../data/deo_well_data.csv") %>%
             standardize_names() %>% 
             rename(oil='oilpknormperk6mo') %>%
             mutate(api = as.character(api)
                     , api10 = as.character(api10)
                     , perfll=as.integer(perfll)
                     , firstprod = as.Date(firstprod, "%m/%d/%Y")
                     , oil = as.integer(oil)
                     , firstprod_year = as.integer(format(firstprod, '%Y'))
                     ) %>%
             as.tibble()















































             
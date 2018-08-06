setwd('C:\\Repositories\\DDS_Case_Study_2\\src')
source('Setup.R')
source('Functions.R')

## ---- wellfeatures_import

wellfeatures <- read.csv("../data/deo_well_data.csv") %>%
             standardize_names() %>% 
             rename(oil='oilpknormperk6mo') %>%
             mutate(api14 = as.character(api)
                   ,api10 = as.character(api10)
                   ,perfll=as.integer(perfll)
                   ,firstprod = as.Date(firstprod, "%m/%d/%Y")
                   ,oil = as.integer(oil)
                   ,firstprod_year = as.integer(format(firstprod, '%Y'))
                ) %>%
             as.tibble()



## ---- wellfeatures_count

# count unique wellbores. api14 represents a unique wellbore.
wf_wellcount <- wellfeatures %>%
    select(api14) %>%
    distinct(api14) %>%
    summarize(wellbores = n())

# count unique locations. api10 represents a unique XY coordinate pair.
wf_loccount <- wellfeatures %>%
    select(api10) %>%
    distinct(api10) %>%
    summarize(locations = n())

kable_zen(data.frame("Distinct Locations" = wf_loccount
          ,"Unique Wellbores" = wf_wellcount
          ,row.names=c("Well_Features"))
          )



## ---- wellfeatures_aggregates

summarize_frame(wellfeatures)













             
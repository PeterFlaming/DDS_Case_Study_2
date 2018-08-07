#setwd('C:\\Repositories\\DDS_Case_Study_2\\src')
source('Setup.R')
source('Functions.R')

#if(!exists("summarize_frame", mode="function")) source("Functions.R")

## ---- fracfocus_import

#import fracfocus data
fracfocus <- read.csv("../data/fracfocus_registry.csv") %>%
              standardize_names() %>%
              rename(api14='apinumber') %>%
              mutate( api14=as.character(api14)
                     ,api10 = as.character(api10)
                     ,tvd = as.integer(tvd)
                     ,jobstartdate = as.Date(jobstartdate, "%m/%d/%Y")
                     ,jobenddate = as.Date(jobenddate, "%m/%d/%Y")
                     ,jobduration = jobenddate - jobstartdate
                     ,totalbasewatervolume = as.double(totalbasewatervolume)
                     ,totalbasenonwatervolume = as.double(totalbasenonwatervolume)
                     ,percenthighadditive = as.double(percenthighadditive)
                     ,percenthfjob = as.double(percenthfjob)
                     ,massingredient = as.double(massingredient)
                     ,iswater = as.logical.factor(iswater)
                     ) %>%
              select( api14
                     ,api10
                     ,wellname
                     ,operatorname
                     ,tvd
                     ,jobstartdate
                     ,jobenddate
                     ,jobduration
                     ,latitude
                     ,longitude
                     ,totalbasewatervolume
                     ,totalbasenonwatervolume
                     ,statename
                     ,countyname
                     ,ingredientname
                     ,percenthighadditive
                     ,percenthfjob
                     ,massingredient
                     ,iswater
                     ) %>%
             as.tibble()



## ---- fracfocus_count

# count unique wellbores. api14 represents a unique wellbore.
ff_wellcount <- fracfocus %>%
    select(api14) %>%
    distinct(api14) %>%
    summarize(wellbores = n())

# count unique locations. api10 represents a unique XY coordinate pair.
ff_loccount <- fracfocus %>%
    select(api10) %>%
    distinct(api10) %>%
    summarize(locations = n())

kable(data.frame("Distinct Locations" = ff_loccount
                ,"Unique Wellbores" = ff_wellcount
                ,row.names=c("Frac_Focus"))
        , digits = 0) %>%
    kable_styling(position = "center"
                 ,full_width = FALSE
                 )



## ---- fracfocus_summary

ff_summary <- fracfocus %>%
    filter('sand' %in% ingredientname
        | 'silica' %in% ingredientname
        | 'propp' %in% ingredientname
        | 'mesh' %in% ingredientname
        | 'brown' %in% ingredientname
        | 'white' %in% ingredientname
        | '30%50' %in% ingredientname
        | '40%70' %in% ingredientname
        | '30%50' %in% ingredientname
        | '100' %in% ingredientname
        ) %>%
    group_by(api10) %>%
    summarize(totalwater.gal = max(totalbasewatervolume)
              ,totalwater.bbl = totalwater.gal/42
              ,totalsand.lb = sum(massingredient)
              ,tvd.ft = max(tvd)
              ,jobduration.day = max(jobduration)
              #, percenthfjob = sum(percenthfjob)
              # add additional summary variables here.
              ) %>%
    inner_join(
                fracfocus %>%
                    group_by(api10) %>%
                    summarize(additive.ct = n_distinct(ingredientname))
                ,by = c("api10", "api10")
              )

# ff_units <- data.frame(
#         vars = c("api10", "totalwater","totalsand", "tvd"),
#         units = c("","(gal)","(lbs)", "(ft)"))


## ---- fracfocus_aggregates

kable(descr(ff_summary), digits = 0) %>%
    kable_styling(position = "center"
                 ,full_width = FALSE
                 )



















































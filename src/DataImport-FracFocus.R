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
                     ,jobstartdate=as.Date(jobstartdate, "%m/%d/%Y")
                     ,jobenddate=as.Date(jobenddate, "%m/%d/%Y")
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
                     ,jobstartdate
                     ,jobenddate
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

kable_zen(data.frame("Distinct Locations" = ff_loccount
                    ,"Unique Wellbores" = ff_wellcount
                    ,row.names=c("Frac_Focus")))



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
    summarize(totalwater = max(totalbasewatervolume)
              , totalsand = sum(massingredient)
              #, percenthfjob = sum(percenthfjob)
              # add additional summary variables here.
              )

ff_units <- data.frame(
        vars = c("api10", "totalwater","totalsand"),
        units = c("","(gal)","(lbs)")


## ---- fracfocus_aggregates

kable_zen(descr(ff_summary))



















































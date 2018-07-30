
if(!exists("summarize_frame", mode="function")) source("Functions.R")



fracfocus <- read.csv("data/fracfocus_registry.csv") %>%
              standardize_names() %>%
              rename(api='apinumber') %>%
              mutate( api=as.character(api)
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
              select( api
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



# Supplementary Data Frames - Unique record per well

ff_distinct_api <- fracfocus %>%
    distinct(api)

# Clean Frac Focus Data

### Frac Focus Summary - Unique record per well

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
              , percenthfjob = sum(percenthfjob)
              # add additional summary variables here.
              )

ff_summary %>% head()

summarize_frame(ff_summary)

























































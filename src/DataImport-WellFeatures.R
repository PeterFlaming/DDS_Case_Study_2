
source('Setup.R')
source('Functions.R')

## ---- wellfeatures_import

# import data features of individual wells
wellfeatures <- read.csv("../data/deo_well_data.csv") %>%
             standardize_names() %>% 
             rename(oil.pk.bbl='oilpknormperk6mo'
                    ,api14='api'
                    ,perfll.ft='perfll') %>%
             mutate(api14 = as.character(api14)
                   ,api10 = as.character(api10)
                   ,perfll.ft=as.integer(perfll.ft)
                   ,firstprod = as.Date(firstprod, "%m/%d/%Y")
                   ,oil.pk.bbl = as.integer(oil.pk.bbl)
                   ,vintage.yr = as.integer(format(firstprod, '%Y'))
                   ,age.mo = as.integer((as.Date('08/01/2018', "%m/%d/%Y") - firstprod)/(365/12)) #30.4 = avg month duration
                ) %>%
             as.tibble()


# wf_units <- data.frame(
#         vars = c("api14","api10","operalias","formavg","status"    
#                 ,"perfll","firstprod","oil.pk","vintage","age.mo"),
#         units = c("","","","",""    
#                 ,"(ft)","","(bbl/day)","(year)","(months)"))



# wellfeatures %>% head()

# wellfeatures %>% 
# mutate(age.mo = as.integer((as.Date('08/01/2018', "%m/%d/%Y") - firstprod)/30.4)) %>%
# select(firstprod, age.mo) %>%
# head() 

# class(as.Date('08/01/2018', "%m/%d/%Y"))
# wellfeatures$firstprod - as.Date('08/01/2018', "%m/%d/%Y")

#read.csv("../data/deo_well_data.csv") %>%standardize_names() %>%  head()


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

kable(data.frame("Distinct Locations" = wf_loccount
                ,"Unique Wellbores" = wf_wellcount
                ,row.names=c("Well_Features")
                )
          , digits = 0) %>%
        kable_styling(position = "float_right", 
                full_width = FALSE,
                bootstrap_options = c("striped", "hover", "condensed")
                )



## ---- wellfeatures_aggregates

# generate descriptive statistics of the individual well features
kable_zen(descr(wellfeatures))





             
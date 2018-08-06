setwd('C:\\Repositories\\DDS_Case_Study_2\\src')
source('Setup.R')
source('Functions.R')

## ---- wellfeatures_import

wellfeatures <- read.csv("../data/deo_well_data.csv") %>%
             standardize_names() %>% 
             rename(oil.pk='oilpknormperk6mo'
                    ,api14='api') %>%
             mutate(api14 = as.character(api14)
                   ,api10 = as.character(api10)
                   ,perfll=as.integer(perfll)
                   ,firstprod = as.Date(firstprod, "%m/%d/%Y")
                   ,oil.pk = as.integer(oil.pk)
                   ,vintage = as.integer(format(firstprod, '%Y'))
                   ,age.mo = as.integer((as.Date('08/01/2018', "%m/%d/%Y") - firstprod)/(365/12)) #30.4 = avg month duration
                ) %>%
             as.tibble()

wellfeatures %>% colnames()

"api14"     
"api10"     
"operalias" 
"formavg"   
"status"    
"perfll"    
"firstprod" 
"oil.pk"    
"vintage"   
"age.mo"

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

kable_zen(data.frame("Distinct Locations" = wf_loccount
          ,"Unique Wellbores" = wf_wellcount
          ,row.names=c("Well_Features"))
          )



## ---- wellfeatures_aggregates

kable_zen(descr(wellfeatures))





             
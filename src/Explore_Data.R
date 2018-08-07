setwd('C:\\Repositories\\DDS_Case_Study_2\\src')
source('Setup.R')
source('Functions.R')
source('DataImport-WellFeatures.R')
source('DataImport-FracFocus.R')

## ---- exp_welldata_calcs

# create new table by joining data on wells with data on chemicals
welldata <- wellfeatures %>%
    inner_join(ff_summary, by = c("api10", "api10")) %>%
    #rename(vintage.yr = vintage) %>%
    mutate(lb.ft = totalsand.lb / perfll.ft
           , gal.ft = totalwater.gal / perfll.ft #todo: totalwater bbl looks way too high.
           , bbl.ft = gal.ft / 42
           , distance = sqrt(gal.ft ^ 2 + lb.ft ^ 2) * (180 / pi) # linear_distance_from_origin (hypotenuse length)
           , angle = atan(gal.ft / lb.ft) * (180 / pi) #in degrees
           , deviation = abs(45 - angle) #deviation_from_45deg
           , weight = 500 # weighting_constant
           , frac.size = distance-(deviation-weight) # weighted_distance_from_origin
           ) %>%
           select(-distance, -angle, -deviation, -weight)


## ---- exp_wd_nrow_1

# Before developing models and making predictions, it's important to understand the data.
# Here we're summarize the data mathematically and explore it visually.

# create a count of well observations
wd_nrow <- list()
wd_nrow[['All Records']] <- nrow(welldata)

## ---- exp_summary

# function call to provide summary statistics for well data
    kable(descr(welldata), digits = 0) %>%
    kable_styling(position = "center"
                 ,full_width = TRUE)


## ---- exp_clean_forms

# remove observations with insufficient information    
welldata <- welldata %<>% 
                filter(!formavg %in% c("UNKNOWN","GRID_ERROR"))


## ---- exp_wd_nrow_2

# provide count of observations that will be used for analysis
wd_nrow[['Cleaned Forms']] <- nrow(welldata)


## ---- exp_clean_frac_size

# filters observations by the amount of sand used
welldata <- welldata %>% 
                filter(160000 < totalsand.lb
                     & totalsand.lb < 50000000
                     & 100000 < totalwater.bbl 
                     & totalwater.bbl < 4080000)




## ---- exp_wd_nrow_3

# summarizes the number of "clean" observations
wd_nrow[['Cleaned Frac Size']] <- nrow(welldata)

# wd_nrow %>% as.data.frame()

## ---- exp_wd_nrow_print
 kable(wd_nrow %>% as.data.frame()) %>%
    kable_styling(position = "center"
                 ,full_width = TRUE) %>%
 add_header_above(c(" ", "Cleansed" = 2))

## ---- exp_freq_vintage

# calculate frequency of wells by year 
kable(freq(welldata$vintage.yr), digits = 0) %>% 
    kable_styling(position = "left", 
                  full_width = FALSE
                 )

## ---- exp_freq_status

# calculate frequency of wells by status
kable(freq(welldata$status), digits = 0) %>% 
    kable_styling(position = "right",
                 full_width = FALSE
                 )




## ---- exp_freq_by_form
kable(freq(welldata$form), digits = 0) %>% 
    kable_styling(position = "right",
                 full_width = FALSE
                 )

## ---- exp_boxplot_fracsize

# create a summary boxplot of wells by size
ggplot((welldata), #%>% na.omit(abv)), 
       aes(x=reorder(formavg, tvd.ft, FUN=mean) , y=log(frac.size), fill = formavg)) +
  geom_boxplot() +
  scale_fill_manual(values = COL.ALLFORMS) +
  scale_x_discrete(limits = rev(names(COL.ALLFORMS))) + #manually set x.axis order
  ggtitle("Frac Size by Formation") +
  xlab("Geological Formation") +
  ylab("Frac Size (dimensionless)") +
  coord_flip() +
  theme(text = element_text(size=10),
        axis.text.x = element_text(angle=90, vjust=0.5),
        plot.title = element_text(hjust = 0.5, size = 16))


## ---- exp_boxplot_oil

# create a summary boxplot of wells by peak production
ggplot((welldata), #%>% na.omit(abv)), 
       aes(x=formavg , y=oil.pk.bbl, fill = formavg)) +
  geom_boxplot() +
  scale_fill_manual(values = COL.ALLFORMS) +
  scale_x_discrete(limits = rev(names(COL.ALLFORMS))) + #manually set x.axis order
  ggtitle("Frac Size by Formation") +
  xlab("Geological Formation") +
  ylab("International Bitterness Units (IBU)") +
  coord_flip() +
  theme(text = element_text(size=10),
        axis.text.x = element_text(angle=90, vjust=0.5),
        plot.title = element_text(hjust = 0.5, size = 16))


## ---- exp_hist_prod



## ---- 












# ggplot((welldata), aes(x = lb_ft, y = bbl_ft)) +
#     geom_point() 


# ## ---- hist_production

# ggplot(welldata) +  
#     geom_histogram(aes(x = oil), binwidth = 100) +
#     theme(text = element_text(size = 10),
#         axis.text.x = element_text(angle = 90, hjust = 1))






# number of wells v formation by vintage


# Geographic area -> lat v lon by formation -> color by oil_pk


# Average productivity v formation by vintage



# Average frac size
# Average age of well (or avg length of production)
# Average productivity
# Wells by formation type
# Number of different additives used
# Average amount of sand used
# Average amount of water used



if (!interactive()) {
require(rmarkdown)
setwd('C:\\Repositories\\DDS_Case_Study_2\\src')
rmarkdown::render('Explore_Data.R')
browseURL('Explore_Data.html')

}


setwd('C:\\Repositories\\DDS_Case_Study_2\\src')
source('Setup.R')
source('Functions.R')
source('DataImport-WellFeatures.R')
source('DataImport-FracFocus.R')

## ---- exp_welldata_calcs

welldata <- wellfeatures %>%
    inner_join(ff_summary, by = c("api10", "api10")) %>%
    mutate(lb_ft = totalsand / perfll
           , bbl_ft = totalwater / perfll #todo: totalwater bbl looks way too high.
           , gal_ft = bbl_ft / 42
           , distance = sqrt(gal_ft ^ 2 + lb_ft ^ 2) * (180 / pi) # linear_distance_from_origin (hypotenuse length)
           , angle = atan(gal_ft / lb_ft) * (180 / pi) #in degrees
           , deviation = abs(45 - angle) #deviation_from_45deg
           , weight = 500 # weighting_constant
           , frac_size = distance-(deviation-weight) # weighted_distance_from_origin
           ) %>%
           select(-distance, -angle, -deviation, -weight)



#welldata %>% head()
## ---- exp_summary
welldata_summary <- select_if(welldata, is.numeric) %>% as.data.frame()

#with(welldata_summary, descr(welldata_summary))
kable_zen(descr(welldata_summary))

# ## ---- scatter_lb_v_bbl




# ggplot((welldata %>% na.omit(abv)), 
#        aes(x=state , y=abv)) +  #TODO: Move to Appendix
#   geom_boxplot(fill = abv_fill) +
#   ggtitle("IBU by State") +
#   xlab("States") +
#   ylab("International Bitterness Units (IBU)") +
#   theme(text = element_text(size=10),
#         axis.text.x = element_text(angle=90, vjust=0.5),
#         plot.title = element_text(hjust = 0.5, size = 16))






















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
rmarkdown::render('Explore_Data.Rmd')
browseURL('Explore_Data.html')

}


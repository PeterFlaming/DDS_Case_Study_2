setwd('C:\\Repositories\\DDS_Case_Study_2\\src')
source('Setup.R')
source('DataImport-WellFeatures.R')
source('DataImport-FracFocus.R')

## ---- welldata_calcs

welldata <- wellfeatures %>%
    inner_join(ff_summary, by = c("api10", "api10")) %>%
    mutate(lb_ft = totalsand / perfll
           , bbl_ft = totalwater / perfll #todo: totalwater bbl looks way too high.
           , gal_ft = bbl_ft / 42
           , distance = sqrt(gal_ft ^ 2 + lb_ft ^ 2) * (180 / pi) # linear_distance_from_origin (hypotenuse length)
           , angle = atan(gal_ft / lb_ft) * (180 / pi) #in degrees
           , deviation = abs(45 - angle) #deviation_from_45deg
           , weight = 500 # weighting_constant
           , frac_rating = distance-(deviation-weight) # weighted_distance_from_origin
           ) %>%
           select(-distance, -angle, -deviation, -weight)


## ---- summary_table

summarize_frame(welldata)

## ---- scatter_lb_v_bbl

ggplot((welldata), aes(x = lb_ft, y = bbl_ft)) +
    geom_point() 


## ---- hist_production

ggplot(welldata) +  
    geom_histogram(aes(x = oil), binwidth = 100) +
    theme(text = element_text(size = 10),
        axis.text.x = element_text(angle = 90, hjust = 1))











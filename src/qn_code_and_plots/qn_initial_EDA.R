setwd("~/Documents/@Grad School/@SMU/@Term 1 Courses/Doing Data Science/Week11/DDS_Case_Study_2/src/qn_code_and_plots")
#setwd("~/Documents/@Grad School/@SMU/@Term 1 Courses/Doing Data Science/Week11/DDS_Case_Study_2/data")

library(tidyverse)

# original import
well_data <- read.csv("deo_well_data.csv", stringsAsFactors = FALSE)
registry_data <- read.csv("fracfocus_registry.csv", stringsAsFactors = FALSE)

# old plots Do Not Use
# well_data$FirstProd <- as.Date(well_data$FirstProd, "%m/%d/%Y")
# well_data$Oil_PkNorm_PerK_6mo <- as.numeric(well_data$Oil_PkNorm_PerK_6mo)
# well_data$Oil_PkNorm_PerK_6mo <- as.integer(well_data$Oil_PkNorm_PerK_6mo)
# 
# peak_performance_wells <- subset(well_data, !is.na(well_data$Oil_PkNorm_PerK_6mo))
# boxplot(log(peak_performance_wells$Oil_PkNorm_PerK_6mo))
# barplot(peak_performance_wells$oper_alias)

# pulling code chunk from Brock's file for consistency
driftwood <- well_data %>%
  mutate(API = as.character(API)
         , API10 = as.character(API10)
         ,PerfLL=as.integer(PerfLL)
         ,FirstProd=as.Date(FirstProd)
         ,Oil_PkNorm_Perk_6mo = as.integer(Oil_PkNorm_Perk_6mo)
  )

fracfocus <- registry_data %>%
  rename(API='APINumber') %>%
  mutate( API=as.character(API)
          ,API10 = as.character(API10)
          ,JobStartDate=as.Date(JobStartDate, "%m/%d/%Y")
          ,JobEndDate=as.Date(JobEndDate, "%m/%d/%Y")
          ,TotalBaseWaterVolume = as.double(TotalBaseWaterVolume)
          ,TotalBaseNonWaterVolume = as.double(TotalBaseNonWaterVolume)
          ,PercentHighAdditive = as.double(PercentHighAdditive)
          ,PercentHFJob = as.double(PercentHFJob)
          ,MassIngredient = as.double(MassIngredient)
          ,IsWater = as.logical.factor(IsWater)
  ) %>%
  select( API
          ,API10
          ,WellName
          ,OperatorName
          ,JobStartDate
          ,JobEndDate
          ,Latitude
          ,Longitude
          ,TotalBaseWaterVolume
          ,TotalBaseNonWaterVolume
          ,StateName
          ,CountyName
          ,IngredientName
          ,PercentHighAdditive
          ,PercentHFJob
          ,MassIngredient
          ,IsWater
  )

# peak performance plots
peak_performance_wells <- subset(driftwood, !is.na(driftwood$Oil_PkNorm_Perk_6mo))
boxplot(peak_performance_wells$Oil_PkNorm_Perk_6mo)
boxplot(log(peak_performance_wells$Oil_PkNorm_Perk_6mo), main = "Log of Peak Performance")
# wells by operator 
wells_by_operator <- peak_performance_wells %>% count(oper_alias) %>% arrange(desc(n))
colnames(wells_by_operator) <- c("operator", "well_count")
wells_by_operator

operator_plot <- ggplot(wells_by_operator, aes(reorder(operator, well_count),
                                               well_count, fill = operator))
operator_plot + geom_col() + ggtitle("Wells by Operator") + coord_flip() +
  theme(legend.position="none")
# these clusters might be worth exploring further
plot(peak_performance_wells$PerfLL, peak_performance_wells$Oil_PkNorm_Perk_6mo,
     main = "Peak Performance vs PerfLL")
# do newer wells have higher peaks?  maybe
plot(peak_performance_wells$FirstProd, peak_performance_wells$Oil_PkNorm_Perk_6mo,
     main = "Peak Performance by Start Date")
# do newer wells have more PerfLL or are there just more newer wells
plot(peak_performance_wells$FirstProd, peak_performance_wells$PerfLL,
     main = "PerfLL by Start Date")
wells_by_date <- peak_performance_wells %>%
  group_by(FirstProd) %>%
  summarise(wells_this_year = n_distinct(API))
# drilling wells has definitely increased in recent years
plot(wells_by_date$FirstProd, wells_by_date$wells_this_year, 
     main = "Wells by Date")

# fracfocus plots
# frac_wells by operator 
frac_wells_by_operator <- fracfocus %>% count(OperatorName) %>% arrange(desc(n))
colnames(frac_wells_by_operator) <- c("operator", "well_count")
frac_wells_by_operator
frac_operator_plot <- ggplot(frac_wells_by_operator, aes(reorder(operator, well_count),
                                               well_count, fill = operator))
frac_operator_plot + geom_col() + ggtitle("Fracking Wells by Operator") + coord_flip() +
  theme(legend.position="none")

library(leaflet)

frac_map <- leaflet() %>% 
  addTiles(urlTemplate="http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}") %>% 
  addCircleMarkers(~Longitude, ~Latitude, popup = ~as.character(WellName),
                   data = fracfocus, color = "red", radius = .1, fillOpacity = 0.3) 
frac_map

# need pounds per foot and barrels per foot and well size

frac_locations <- fracfocus[, c(2,7,8)]
well_loc <- merge(driftwood, frac_locations, by.x = "API10", by.y = "API10")
well_loc <- unique(well_loc)

well_map <- leaflet() %>%
  addTiles(urlTemplate="https://{s}.tile.openstreetmap.se/hydda/full/{z}/{x}/{y}.png") %>% 
  addCircleMarkers(~Longitude, ~Latitude, popup = ~as.character(API10),
                   data = fracfocus, color = "red", radius = .01, fillOpacity = 0.3) 
well_map

ff_distinct_api <- fracfocus %>%
  distinct(API)


# match brock's renamed tables
wells_distinct_api14 <- driftwood %>%
  inner_join(fracfocus, by = c("API", "API")) %>%
  distinct(API)

wells_distinct_api10 <- driftwood %>%
  inner_join(fracfocus, by = c("API10", "API10")) %>%
  distinct(API10)

ff_summary <- fracfocus %>%
  filter('sand' %in% IngredientName
         | 'silica' %in% IngredientName
         | 'propp' %in% IngredientName
         | 'mesh' %in% IngredientName
         | 'brown' %in% IngredientName
         | 'white' %in% IngredientName
         | '30%50' %in% IngredientName
         | '40%70' %in% IngredientName
         | '30%50' %in% IngredientName
         | '100' %in% IngredientName
  ) %>%
  group_by(API10) %>%
  summarize(TotalWater = max(TotalBaseWaterVolume)
            , TotalSand = sum(MassIngredient)
            , PercentHFJob = sum(PercentHFJob)
            # Add additional summary variables here.
  )


ff_summary %>% head()

well_data_2 <- driftwood %>%
  inner_join(ff_summary, by = c("API10", "API10")) %>%
  mutate(lb_ft = TotalSand / PerfLL
         , bbl_ft = TotalWater / PerfLL
         , gal_ft = bbl_ft / 42
  )
well_data_2 %>% head()

# well_data_2 plots
plot(log(well_data_2$TotalSand), log(well_data_2$Oil_PkNorm_Perk_6mo),
     main = "Log of Peak performance vs. Log of Total Sand")

plot(log(well_data_2$TotalWater) , well_data_2$Oil_PkNorm_Perk_6mo,
     main = "Peak performance vs. Log of Total Water")

x_wells <- subset(well_data_2, well_data_2$form_avg == "WFMP_C")
plot(log(x_wells$TotalSand), log(x_wells$Oil_PkNorm_Perk_6mo),
     main = "log(Peak performance) vs. log(Total Sand) for WFMP_C")
# c is interesting
# SPBY_L_SHALE is interesting
# SPBY_M is sparse, but could be interesting


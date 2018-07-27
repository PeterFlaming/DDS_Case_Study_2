setwd("~/Documents/@Grad School/@SMU/@Term 1 Courses/Doing Data Science/Week11/DDS_Case_Study_2/src/qn_code_and_plots")
#setwd("~/Documents/@Grad School/@SMU/@Term 1 Courses/Doing Data Science/Week11/DDS_Case_Study_2/data")

library(tidyverse)


well_data <- read.csv("deo_well_data.csv", stringsAsFactors = FALSE)
registry_data <- read.csv("fracfocus_registry.csv", stringsAsFactors = FALSE)

well_data$FirstProd <- as.Date(well_data$FirstProd, "%m/%d/%Y")
well_data$Oil_PkNorm_PerK_6mo <- as.numeric(well_data$Oil_PkNorm_PerK_6mo)
well_data$Oil_PkNorm_PerK_6mo <- as.integer(well_data$Oil_PkNorm_PerK_6mo)

peak_performance_wells <- subset(well_data, !is.na(well_data$Oil_PkNorm_PerK_6mo))
boxplot(log(peak_performance_wells$Oil_PkNorm_PerK_6mo))
barplot(peak_performance_wells$oper_alias)

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

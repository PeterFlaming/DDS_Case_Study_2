# setwd("~/Documents/@Grad School/@SMU/@Term 1 Courses/Doing Data Science/Week11/DDS_Case_Study_2/qn_code_and_plots")
# setwd("~/Documents/@Grad School/@SMU/@Term 1 Courses/Doing Data Science/Week11/DDS_Case_Study_2/data")


well_data <- read.csv("deo_well_data.csv", stringsAsFactors = FALSE)
registry_data <- read.csv("fracfocus_registry_texas.csv", stringsAsFactors = FALSE)

well_data$FirstProd <- as.Date(well_data$FirstProd, "%m/%d/%Y")
well_data$Oil_PkNorm_PerK_6mo <- as.numeric(well_data$Oil_PkNorm_PerK_6mo)


peak_performance_wells <- subset(well_data, !is.na(well_data$Oil_PkNorm_PerK_6mo))

boxplot(log(peak_performance_wells$Oil_PkNorm_PerK_6mo))

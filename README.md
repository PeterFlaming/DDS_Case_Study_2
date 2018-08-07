---
output:
  html_document: default
  pdf_document: default
---
# MSDS 6306 Doing Data Science 

## Case Study 2 with R and RStudio

### Group Members and Case Study Responsibilities (alphabetically)
  
Member Name           GitHub Username            Project Duties                                  

Peter Flaming         PeterFlaming               Regression Models/README/Presentation   

Brock Friedrich       la-mar                     R Code/Rmarkdown/Data Gathering/Organization  

Quinton Nixon         qatsmu                     R Code/Code Commenting/Powerpoint Preparation  

Matthew Trevathan     mrtrevathan0               Codebook/Code Formatting/Organization             


### Purose of Case Study 2

The client wishes to invest in the Oil & Gas industry with respect the Permian Basin, and doesn't know today's Top Plays for the region, or what type of play would be high in demand in the future. We were hired to find out what kind of play (conventional or unconventional) is most successful today in the Permian Basin by the quantitification and statitistical analysis of the well data provided for the region from open sources. This case study will make it clear to see what aspects of well data makes each play so favorable to the industry leaders in a highly competive market. We gathered data from an opensource database [here](http://fracfocusdata.org/digitaldownload/fracfocuscsv.zip) on the nation's drilling operators and companies focusing our study on the listed levels of total vertical depth (TVD), total base water volume (TBWV), projection, and frac'ing chemicals and fluids. From these data we found the most desired play in the U.S. by carefully measuring the correlation of these predictive variables from the most frequently used parameters across each play and operator/company in the region. The resulting list of top plays includes the best type to invest in for our client. 


### Updates for Case Study 2

A number of changes have been made to this case study for the **Doing Data Science Course** with plans of **Reproducibility within R and RStudio**. Most importantly the case study structure has been planned to take full advantage of relative file paths to reproduce this research.

### Current Version

For the current version of this **Case Study** see
[here](https://github.com/la-mar/DDS_Case_Study_2/blob/master/README.md).

### Reproduce the Case Study

Use the following directions to reproduce the data gathering, analysis, and
presentation documents.

### First download this repository onto your computer.
```r
# Set the working directory to this repository as needed for your system
setwd("https://github.com/la-mar/DDS_Case_Study_2")
```
### Load and cite R packages
```r
# Create list of packages
PackagesUsed <- c("AER", "car" "dplyr","tidyr", "knitr", "ggplot2", "maptools", "RColorBrewer", "magrittr", "repmis")

# Load PackagesUsed and create .bib BibTeX file
# Note must have repmis package installed.
repmis::LoadandCite(PackagesUsed, file = "Packages.bib", install = TRUE)

# Create package BibTeX file
knitr::write_bib(PackagesUsed, file = "Packages.bib")
```

### Open Rmarkdown and follow code

Use the following code to reproduce the study [here](https://github.com/la-mar/DDS_Case_Study_2/blob/master/Final_Analysis.md).


# Executive Summary

FTNF Analytics is a boutique firm specializing in statistics and data analysis for the energy sector.  The FTNF team includes experts in geology, data visualization, statistics, and predictive modeling.  Our practice services producers globally with a special emphasis on those operating in the Southwest United States.

The Consortium of Texas Oil Producers (CTOP), has engaged FTNF to develop a study to better understand the potential for production in designated areas and help decide the best way to allocate their valuable resources.  Specifically, CTOP needs a way to predict potential energy production (and revenues generated).

FTNF is the ideal partner for this undertaking.  Our process includes enriching existing CTOP data to improve the ability to predict production outcomes.  We start with exploring the data, creating new data, and augmenting the data.  Once satisfied, we proceed to analyzing the data using contemporary statistical methods.  From there, we build predictive models to provide insight necessary to make drilling decisions.

CTOP companies no longer have to rely on hope as a strategy for finding productive wells.  With the help of FTNF Analytics, you can rely on sound science and quantifiable predictions.


# Frac Focus Data Source

The Hydraulic Fracturing Disclosure and Education websites found [here](http://fracfocusdata.org) are being hosted by the Ground Water Protection Council (GWPC) and the Interstate Oil and Gas Compact Commission (IOGCC).  This website provides a central location for public and industry to communicate and relay information on the chemicals used during the process of hydraulic fracturing of oil or gas wells.  The FracFocus website provides impartial and balanced education tools to the public on the topic of hydraulic fracturing.

The GWPC and IOGCC are uniquely suited to host these websites due to their impartial nature and ties to the regulated and regulatory community. This website provides a means for industry to voluntarily supply hydraulic fracturng chemical data in a consistent and centralized location.  This open process assists both public and industry by supplying a centralized repository for the data and removing similar fragmented efforts from around the web. 

These websites provide the following:
A means to Search for voluntarily submitted chemical records by State/County, Operator and Well.
An Education and Informative site for the public and industry on Hydraulic Fracturing Chemicals and the processes used in Hydraulic Fracturing of wells.

FracFocus has instituted a Help Desk to address any issues you may have in using the system. You can reach the Help Desk Monday-Thursday from 8 AM to 5 PM and on Friday from 8 AM to 4 PM CDT at 405-607-6808.


# Driftwood Well Data Source

The Driftwood dataset was provided by the client and can be found [here](https://github.com/la-mar/DDS_Case_Study_2/blob/master/data/deo_well_data.csv). This dataset provides a central location for wellsites to communicate and relay information on the drilling parameters used during the process of extraction of oil or gas wells. The following variables are included within the dataset:

* API - fourteen digit american petroleum institue number
* API10 - ten digit american petroleum institue number. Represents a unique hole in the ground.
* oper_alias - standardized operator (company) names
* Form_Avg - geological formation names
* PerfLL - wellbore lateral length
* FirstProd - date of first oil/gas production
* Oil_PkNorm_PerK_6mo - peak oil production within the first 6 months of first production, normalized to 1000 ft 


## FracFocus Dataset Import
### 19 of the 24 variables are selected for the study
```{r fracfocus_import, cache = TRUE}
```

# Count Locations and Wellbores
### The FracFocus Data consists of Well Data for 3162 locations with 3163 wellbores
```{r fracfocus_count, cache = TRUE}
```

## Aggregate Proppant and Water by wellbore
### Filtering and grouping of aggregates proponents and water for each wellbore
```{r fracfocus_summary, cache = TRUE}
```

## Aggregates
### A table of FracFocus wellbore specific descriptive statistics
```{r fracfocus_aggregates, cache = TRUE}
```

# Well Features and Characteristics Dataset Import
### 7 of the 8 variables are selected for the study
```{r wellfeatures_import, cache = TRUE}
```

## Count Locations and Wellbores
### The Well Features and Characteristics consists of Well Data for 2907 locations with 2914 wellbores
```{r wellfeatures_count, cache = TRUE}
```

## Aggregates
### A table of Well Features and Characteristics wellbore specific descriptive statistics
```{r fracfocus_aggregates, cache = TRUE}
```


# Data Exploration of Well Data

Here the FracFocus and Well Features and Characteristics datasets are joined into a new dataset named welldata by the common variable api10, which represents a specific wellbore hole.


## Add Calculated Columns to Well Data
### Columns are created by the mutate function to provide 8 new variables for upcomming data analysis
```{r exp_welldata_calcs}
```

## Clean Well Data
### Here the welldata is cleaned in preparation for statistical procedures and visualization
```{r exp_welldata_calcs}
```

## Summarize Well Data 
### A table of Well Data wellbore specific descriptive statistics
```{r exp_summary}
```
## Well Data Box Plot
### A visualization of the summary statistics for Well Data
```{r exp_boxplot_fracsize}
```

```{r exp_boxplot_fracsize}
```

## Wellsite Frequencies
### A table of well frequency by respective year
```{r exp_freq_vintage}
```

## Wellsite Production Frequencies
### A table of well production by respective year
```{r exp_freq_status}
```

# Histograms (to be added)

# Regression Model 1  (to be added)

 - Peter: Insert your model here if you have it, otherwise I will make one.

 - Well Productivity (oil.pk.bbl) vs frac.size, controlling for formation, would be a really good one.
  - Well Productivity (oil.pk.bbl) vs frac.size, controlling for formation, would be a really good one.

# Regression Model 2  (to be added)

 - Peter: Insert your model here if you have it, otherwise I will make one.

- Well Productivity (oil.pk.bbl) vs formation | perf.ll.ft + lb.ft + bbl.ft + additive.ct and controlling for formation would also be great.

# Anova to compare models



# Results of Tests



# Conclusions



# Appendix:

```{r}
sessionInfo()











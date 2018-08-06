# DDS_Case_Study_2

* analysis -> final analysis code
* data -> raw datasets
    - on dropbox: https://www.dropbox.com/sh/w8hp62d6o4blmo2/AAC6VeGM2EIUSKLaPGw-AGnZa?dl=0
    - source data: http://fracfocusdata.org/digitaldownload/fracfocuscsv.zip
* output -> sims/processed data
* fig -> charts
* assets -> assets for presentation/report
* src -> code other than the final analysis


---
output:
  html_document: default
  pdf_document: default
---
# MSDS 6306 Doing Data Science 

## Case Study 2 with R and RStudio

### Group Members
  
`Member Name           GitHub Username           Project Duties `  

`Peter Flaming         PeterFlaming                             `  

`Brock Friedrich       la-mar                                   `

`Quinton Nixon         qatsmu                                   ` 

`Matthew Trevathan     mrtrevathan0                             `     


### Purose of Case Study 1

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

### Data Gathering

Use the following code to reproduce the data gathering:

#### Import Frac Focus Data and Clean

In this section we load and begin cleaning the data in order to aid our
exploratory analysis.

```r

```

#### Import Deo Well Data and Clean

In this section we load and begin cleaning the data in order to aid our
exploratory analysis.

```r

```












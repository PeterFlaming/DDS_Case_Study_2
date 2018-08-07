---
title: "Measuring Well Productivity by Completion Design"
author: | 
        | Flaming  
        | Trevathan
        | Nixon  
        | Friedrich
output:
  prettydoc::html_pretty:
    keep_md: yes
    theme: leonids
    highlight: github
    toc: true
    number_sections: true
    df_print: kable
    fontsize: 11pt
    fontfamily: palatino

date: "July 24, 2018"

---

<!-- ```{r code = readLines('Setup.R'), message=FALSE, warning=FALSE} -->
<!-- ``` -->




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

The data related to chemicals used to enrich the data on wells comes from the chemical registry website FracFocus.com.  The FracFocus website and data is maintained by two organizations:  Interstate Oil and Gas Compact Commission and the Ground Water Protection Council.

The site maintains data on over 127,000 wells and includes not only data about which chemicals are used, but also data about groundwater protection. FracFocus has instituted a Help Desk to address any issues you may have in using the system. You can reach the Help Desk Monday-Thursday from 8 AM to 5 PM and on Friday from 8 AM to 4 PM CDT at 405-607-6808.




## FracFocus Dataset Import
### 19 of the 24 variables are selected for the study
The deata from FracFocus is obtained via an API call.  For the sake of reproducibility,
the API call is made outside of the code and the resulting CSV is stored in the 
program repository.



```r
#import fracfocus data
fracfocus <- read.csv("../data/fracfocus_registry.csv") %>%
              standardize_names() %>%
              rename(api14='apinumber') %>%
              mutate( api14=as.character(api14)
                     ,api10 = as.character(api10)
                     ,tvd = as.integer(tvd)
                     ,jobstartdate = as.Date(jobstartdate, "%m/%d/%Y")
                     ,jobenddate = as.Date(jobenddate, "%m/%d/%Y")
                     ,jobduration = jobenddate - jobstartdate
                     ,totalbasewatervolume = as.double(totalbasewatervolume)
                     ,totalbasenonwatervolume = as.double(totalbasenonwatervolume)
                     ,percenthighadditive = as.double(percenthighadditive)
                     ,percenthfjob = as.double(percenthfjob)
                     ,massingredient = as.double(massingredient)
                     ,iswater = as.logical.factor(iswater)
                     ) %>%
              select( api14
                     ,api10
                     ,wellname
                     ,operatorname
                     ,tvd
                     ,jobstartdate
                     ,jobenddate
                     ,jobduration
                     ,latitude
                     ,longitude
                     ,totalbasewatervolume
                     ,totalbasenonwatervolume
                     ,statename
                     ,countyname
                     ,ingredientname
                     ,percenthighadditive
                     ,percenthfjob
                     ,massingredient
                     ,iswater
                     ) %>%       
             as.tibble()
```

## Count Locations and Wellbores
### The FracFocus Data consists of Well Data for 3162 locations with 3163 wellbores

```r
# count unique wellbores. api14 represents a unique wellbore.
ff_wellcount <- fracfocus %>%
    select(api14) %>%
    distinct(api14) %>%
    summarize(wellbores = n())

# count unique locations. api10 represents a unique XY coordinate pair.
ff_loccount <- fracfocus %>%
    select(api10) %>%
    distinct(api10) %>%
    summarize(locations = n())

kable(data.frame("Distinct Locations" = ff_loccount
                ,"Unique Wellbores" = ff_wellcount
                ,row.names=c("Frac_Focus"))
        , digits = 0) %>%
    kable_styling(position = "center"
                 ,full_width = FALSE
                 )
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> locations </th>
   <th style="text-align:right;"> wellbores </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Frac_Focus </td>
   <td style="text-align:right;"> 3162 </td>
   <td style="text-align:right;"> 3163 </td>
  </tr>
</tbody>
</table>

## Aggregate Proppant and Water by wellbore
### Filtering and grouping of aggregates proponents and water for each wellbore

```r
# create a tidy table summarizing the data imported from the FracFocus registry
ff_summary <- fracfocus %>%
    filter('sand' %in% ingredientname
        | 'silica' %in% ingredientname
        | 'propp' %in% ingredientname
        | 'mesh' %in% ingredientname
        | 'brown' %in% ingredientname
        | 'white' %in% ingredientname
        | '30%50' %in% ingredientname
        | '40%70' %in% ingredientname
        | '30%50' %in% ingredientname
        | '100' %in% ingredientname
        ) %>%
    group_by(api10) %>%
    summarize(totalwater.gal = max(totalbasewatervolume)
              ,totalwater.bbl = totalwater.gal/42
              ,totalsand.lb = sum(massingredient)
              ,tvd.ft = max(tvd)
              ,jobduration.day = max(jobduration)
              #, percenthfjob = sum(percenthfjob)
              # add additional summary variables here.
              ) %>%
    inner_join(
                fracfocus %>%
                    group_by(api10) %>%
                    summarize(additive.ct = n_distinct(ingredientname))
                ,by = c("api10", "api10")
              )

# ff_units <- data.frame(
#         vars = c("api10", "totalwater","totalsand", "tvd"),
#         units = c("","(gal)","(lbs)", "(ft)"))
```

## Aggregates
### A table of FracFocus wellbore specific descriptive statistics

```r
# generate descriptive statistics for the summarized chemical data
kable(descr(ff_summary), digits = 0) %>%
    kable_styling(position = "center"
                 ,full_width = FALSE
                 )
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Mean </th>
   <th style="text-align:right;"> Std.Dev </th>
   <th style="text-align:right;"> Min </th>
   <th style="text-align:right;"> Median </th>
   <th style="text-align:right;"> Max </th>
   <th style="text-align:right;"> Q1 </th>
   <th style="text-align:right;"> Q3 </th>
   <th style="text-align:right;"> N.Valid </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> totalwater.gal </td>
   <td style="text-align:right;"> 8631322 </td>
   <td style="text-align:right;"> 8517091 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 7960218 </td>
   <td style="text-align:right;"> 202222958 </td>
   <td style="text-align:right;"> 1348074 </td>
   <td style="text-align:right;"> 13285482 </td>
   <td style="text-align:right;"> 3162 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> totalwater.bbl </td>
   <td style="text-align:right;"> 205508 </td>
   <td style="text-align:right;"> 202788 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 189529 </td>
   <td style="text-align:right;"> 4814832 </td>
   <td style="text-align:right;"> 32097 </td>
   <td style="text-align:right;"> 316321 </td>
   <td style="text-align:right;"> 3162 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> totalsand.lb </td>
   <td style="text-align:right;"> 834510 </td>
   <td style="text-align:right;"> 520151 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 807304 </td>
   <td style="text-align:right;"> 4556769 </td>
   <td style="text-align:right;"> 556858 </td>
   <td style="text-align:right;"> 1117587 </td>
   <td style="text-align:right;"> 3162 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> tvd.ft </td>
   <td style="text-align:right;"> 88518 </td>
   <td style="text-align:right;"> 4445993 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 9281 </td>
   <td style="text-align:right;"> 250014549 </td>
   <td style="text-align:right;"> 8011 </td>
   <td style="text-align:right;"> 10575 </td>
   <td style="text-align:right;"> 3162 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> additive.ct </td>
   <td style="text-align:right;"> 32 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 30 </td>
   <td style="text-align:right;"> 86 </td>
   <td style="text-align:right;"> 21 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 3162 </td>
  </tr>
</tbody>
</table>

# Driftwood Well Data Source

The Driftwood dataset was provided by the client and can be found [here](https://github.com/la-mar/DDS_Case_Study_2/blob/master/data/deo_well_data.csv). This dataset provides a central location for wellsites to communicate and relay information on the drilling parameters used during the process of extraction of oil or gas wells. The following variables are included within the dataset:

* API - fourteen digit american petroleum institue number
* API10 - ten digit american petroleum institue number. Represents a unique hole in the ground.
* oper_alias - standardized operator (company) names
* Form_Avg - geological formation names
* PerfLL - wellbore lateral length
* FirstProd - date of first oil/gas production
* Oil_PkNorm_PerK_6mo - peak oil production within the first 6 months of first production, normalized to 1000 ft 


## Well Features and Characteristics Dataset Import

### 7 of the 8 variables are selected for the study

```r
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
```

## Count Locations and Wellbores
### The Well Features and Characteristics consists of Well Data for 2907 locations with 2914 wellbores

```r
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
```

<table class="table table-striped table-hover table-condensed" style="width: auto !important; float: right; margin-left: 10px;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> locations </th>
   <th style="text-align:right;"> wellbores </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Well_Features </td>
   <td style="text-align:right;"> 2907 </td>
   <td style="text-align:right;"> 2914 </td>
  </tr>
</tbody>
</table>

## Aggregates
### A table of Well Features and Characteristics wellbore specific descriptive statistics

```r
# generate descriptive statistics for the summarized chemical data
kable(descr(ff_summary), digits = 0) %>%
    kable_styling(position = "center"
                 ,full_width = FALSE
                 )
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Mean </th>
   <th style="text-align:right;"> Std.Dev </th>
   <th style="text-align:right;"> Min </th>
   <th style="text-align:right;"> Median </th>
   <th style="text-align:right;"> Max </th>
   <th style="text-align:right;"> Q1 </th>
   <th style="text-align:right;"> Q3 </th>
   <th style="text-align:right;"> N.Valid </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> totalwater.gal </td>
   <td style="text-align:right;"> 8631322 </td>
   <td style="text-align:right;"> 8517091 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 7960218 </td>
   <td style="text-align:right;"> 202222958 </td>
   <td style="text-align:right;"> 1348074 </td>
   <td style="text-align:right;"> 13285482 </td>
   <td style="text-align:right;"> 3162 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> totalwater.bbl </td>
   <td style="text-align:right;"> 205508 </td>
   <td style="text-align:right;"> 202788 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 189529 </td>
   <td style="text-align:right;"> 4814832 </td>
   <td style="text-align:right;"> 32097 </td>
   <td style="text-align:right;"> 316321 </td>
   <td style="text-align:right;"> 3162 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> totalsand.lb </td>
   <td style="text-align:right;"> 834510 </td>
   <td style="text-align:right;"> 520151 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 807304 </td>
   <td style="text-align:right;"> 4556769 </td>
   <td style="text-align:right;"> 556858 </td>
   <td style="text-align:right;"> 1117587 </td>
   <td style="text-align:right;"> 3162 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> tvd.ft </td>
   <td style="text-align:right;"> 88518 </td>
   <td style="text-align:right;"> 4445993 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 9281 </td>
   <td style="text-align:right;"> 250014549 </td>
   <td style="text-align:right;"> 8011 </td>
   <td style="text-align:right;"> 10575 </td>
   <td style="text-align:right;"> 3162 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> additive.ct </td>
   <td style="text-align:right;"> 32 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 30 </td>
   <td style="text-align:right;"> 86 </td>
   <td style="text-align:right;"> 21 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 3162 </td>
  </tr>
</tbody>
</table>

# Exploration of Datasets

Here the FracFocus and Well Features and Characteristics datasets are joined into a new dataset named welldata by the common variable api10, which represents a specific wellbore hole.


## Add Calculated Columns to Well Data
### Columns are created by the mutate function to provide 8 new variables for upcomming data analysis

```r
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
```


```r
# function call to provide summary statistics for well data
    kable(descr(welldata), digits = 0) %>%
    kable_styling(position = "center"
                 ,full_width = TRUE)
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Mean </th>
   <th style="text-align:right;"> Std.Dev </th>
   <th style="text-align:right;"> Min </th>
   <th style="text-align:right;"> Median </th>
   <th style="text-align:right;"> Max </th>
   <th style="text-align:right;"> Q1 </th>
   <th style="text-align:right;"> Q3 </th>
   <th style="text-align:right;"> N.Valid </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> perfll.ft </td>
   <td style="text-align:right;"> 868 </td>
   <td style="text-align:right;"> 491 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 909 </td>
   <td style="text-align:right;"> 1570 </td>
   <td style="text-align:right;"> 524 </td>
   <td style="text-align:right;"> 1288 </td>
   <td style="text-align:right;"> 1908 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> oil.pk.bbl </td>
   <td style="text-align:right;"> 1071 </td>
   <td style="text-align:right;"> 601 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1104 </td>
   <td style="text-align:right;"> 1854 </td>
   <td style="text-align:right;"> 541 </td>
   <td style="text-align:right;"> 1650 </td>
   <td style="text-align:right;"> 1908 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> vintage.yr </td>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2001 </td>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 1742 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> age.mo </td>
   <td style="text-align:right;"> 35 </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 37 </td>
   <td style="text-align:right;"> 209 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 1742 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> totalwater.gal </td>
   <td style="text-align:right;"> 13387410 </td>
   <td style="text-align:right;"> 7837647 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 11351928 </td>
   <td style="text-align:right;"> 202222958 </td>
   <td style="text-align:right;"> 8640555 </td>
   <td style="text-align:right;"> 17433362 </td>
   <td style="text-align:right;"> 1908 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> totalwater.bbl </td>
   <td style="text-align:right;"> 318748 </td>
   <td style="text-align:right;"> 186611 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 270284 </td>
   <td style="text-align:right;"> 4814832 </td>
   <td style="text-align:right;"> 205728 </td>
   <td style="text-align:right;"> 415080 </td>
   <td style="text-align:right;"> 1908 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> totalsand.lb </td>
   <td style="text-align:right;"> 774981 </td>
   <td style="text-align:right;"> 529758 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 763048 </td>
   <td style="text-align:right;"> 4496574 </td>
   <td style="text-align:right;"> 488646 </td>
   <td style="text-align:right;"> 1065444 </td>
   <td style="text-align:right;"> 1908 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> tvd.ft </td>
   <td style="text-align:right;"> 8895 </td>
   <td style="text-align:right;"> 3183 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 8649 </td>
   <td style="text-align:right;"> 92089 </td>
   <td style="text-align:right;"> 7758 </td>
   <td style="text-align:right;"> 9426 </td>
   <td style="text-align:right;"> 1908 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> additive.ct </td>
   <td style="text-align:right;"> 33 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 31 </td>
   <td style="text-align:right;"> 86 </td>
   <td style="text-align:right;"> 23 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 1908 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lb.ft </td>
   <td style="text-align:right;"> 39384 </td>
   <td style="text-align:right;"> 204467 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 871 </td>
   <td style="text-align:right;"> 2292880 </td>
   <td style="text-align:right;"> 433 </td>
   <td style="text-align:right;"> 1765 </td>
   <td style="text-align:right;"> 1908 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gal.ft </td>
   <td style="text-align:right;"> 803290 </td>
   <td style="text-align:right;"> 5707366 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 12953 </td>
   <td style="text-align:right;"> 202222958 </td>
   <td style="text-align:right;"> 9761 </td>
   <td style="text-align:right;"> 17991 </td>
   <td style="text-align:right;"> 1908 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> bbl.ft </td>
   <td style="text-align:right;"> 19126 </td>
   <td style="text-align:right;"> 135890 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 308 </td>
   <td style="text-align:right;"> 4814832 </td>
   <td style="text-align:right;"> 232 </td>
   <td style="text-align:right;"> 428 </td>
   <td style="text-align:right;"> 1908 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> frac.size </td>
   <td style="text-align:right;"> 46224719 </td>
   <td style="text-align:right;"> 327197476 </td>
   <td style="text-align:right;"> 23658 </td>
   <td style="text-align:right;"> 747575 </td>
   <td style="text-align:right;"> 11586664381 </td>
   <td style="text-align:right;"> 563766 </td>
   <td style="text-align:right;"> 1035822 </td>
   <td style="text-align:right;"> 1908 </td>
  </tr>
</tbody>
</table>

## Munge Datasets
### Here the welldata is cleaned in preparation for statistical procedures and visualization

```r
# Before developing models and making predictions, it's important to understand the data.
# Here we're summarize the data mathematically and explore it visually.

# create a count of well observations
wd_nrow <- list()
wd_nrow[['All Records']] <- nrow(welldata)
```


```r
# remove observations with insufficient information    
welldata <- welldata %<>% 
                filter(!formavg %in% c("UNKNOWN","GRID_ERROR"))
```


```r
# provide count of observations that will be used for analysis
wd_nrow[['Cleaned Forms']] <- nrow(welldata)
```


```r
# summarizes the number of "clean" observations
wd_nrow[['Cleaned Frac Size']] <- nrow(welldata)
```


```r
# summarizes the number of observations after 
# removing NAs from vintage column
welldata <- welldata %>% na.omit(vintage.yr)

wd_nrow[['Cleaned Vintage']] <- nrow(welldata)
# wd_nrow %>% as.data.frame()
```


```r
 kable(wd_nrow %>% as.data.frame()) %>%
    kable_styling(position = "center"
                 ,full_width = TRUE) %>%
 add_header_above(c(" ", "Cleansed" = 3))
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
<tr>
<th style="border-bottom:hidden" colspan="1"></th>
<th style="border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="3"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px;">Cleansed</div></th>
</tr>
  <tr>
   <th style="text-align:right;"> All.Records </th>
   <th style="text-align:right;"> Cleaned.Forms </th>
   <th style="text-align:right;"> Cleaned.Frac.Size </th>
   <th style="text-align:right;"> Cleaned.Vintage </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1908 </td>
   <td style="text-align:right;"> 1856 </td>
   <td style="text-align:right;"> 1856 </td>
   <td style="text-align:right;"> 1715 </td>
  </tr>
</tbody>
</table>

## Summarize Well Data 
### A table of Well Data wellbore specific descriptive statistics

```r
# function call to provide summary statistics for well data
    kable(descr(welldata), digits = 0) %>%
    kable_styling(position = "center"
                 ,full_width = TRUE)
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Mean </th>
   <th style="text-align:right;"> Std.Dev </th>
   <th style="text-align:right;"> Min </th>
   <th style="text-align:right;"> Median </th>
   <th style="text-align:right;"> Max </th>
   <th style="text-align:right;"> Q1 </th>
   <th style="text-align:right;"> Q3 </th>
   <th style="text-align:right;"> N.Valid </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> perfll.ft </td>
   <td style="text-align:right;"> 844 </td>
   <td style="text-align:right;"> 458 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 895 </td>
   <td style="text-align:right;"> 1570 </td>
   <td style="text-align:right;"> 530 </td>
   <td style="text-align:right;"> 1216 </td>
   <td style="text-align:right;"> 1715 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> oil.pk.bbl </td>
   <td style="text-align:right;"> 997 </td>
   <td style="text-align:right;"> 576 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1022 </td>
   <td style="text-align:right;"> 1854 </td>
   <td style="text-align:right;"> 487 </td>
   <td style="text-align:right;"> 1508 </td>
   <td style="text-align:right;"> 1715 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> vintage.yr </td>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2001 </td>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:right;"> 1715 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> age.mo </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 37 </td>
   <td style="text-align:right;"> 209 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 1715 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> totalwater.gal </td>
   <td style="text-align:right;"> 13030462 </td>
   <td style="text-align:right;"> 7697296 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 11018196 </td>
   <td style="text-align:right;"> 202222958 </td>
   <td style="text-align:right;"> 8543724 </td>
   <td style="text-align:right;"> 16540356 </td>
   <td style="text-align:right;"> 1715 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> totalwater.bbl </td>
   <td style="text-align:right;"> 310249 </td>
   <td style="text-align:right;"> 183269 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 262338 </td>
   <td style="text-align:right;"> 4814832 </td>
   <td style="text-align:right;"> 203422 </td>
   <td style="text-align:right;"> 393818 </td>
   <td style="text-align:right;"> 1715 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> totalsand.lb </td>
   <td style="text-align:right;"> 781277 </td>
   <td style="text-align:right;"> 536322 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 776275 </td>
   <td style="text-align:right;"> 4496574 </td>
   <td style="text-align:right;"> 487398 </td>
   <td style="text-align:right;"> 1082611 </td>
   <td style="text-align:right;"> 1715 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> tvd.ft </td>
   <td style="text-align:right;"> 8971 </td>
   <td style="text-align:right;"> 3276 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 8669 </td>
   <td style="text-align:right;"> 92089 </td>
   <td style="text-align:right;"> 7800 </td>
   <td style="text-align:right;"> 9426 </td>
   <td style="text-align:right;"> 1715 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> additive.ct </td>
   <td style="text-align:right;"> 33 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 31 </td>
   <td style="text-align:right;"> 86 </td>
   <td style="text-align:right;"> 23 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 1715 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lb.ft </td>
   <td style="text-align:right;"> 25528 </td>
   <td style="text-align:right;"> 167913 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 910 </td>
   <td style="text-align:right;"> 2143603 </td>
   <td style="text-align:right;"> 448 </td>
   <td style="text-align:right;"> 1766 </td>
   <td style="text-align:right;"> 1715 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gal.ft </td>
   <td style="text-align:right;"> 494862 </td>
   <td style="text-align:right;"> 5401735 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 12905 </td>
   <td style="text-align:right;"> 202222958 </td>
   <td style="text-align:right;"> 9737 </td>
   <td style="text-align:right;"> 17851 </td>
   <td style="text-align:right;"> 1715 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> bbl.ft </td>
   <td style="text-align:right;"> 11782 </td>
   <td style="text-align:right;"> 128613 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 307 </td>
   <td style="text-align:right;"> 4814832 </td>
   <td style="text-align:right;"> 232 </td>
   <td style="text-align:right;"> 425 </td>
   <td style="text-align:right;"> 1715 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> frac.size </td>
   <td style="text-align:right;"> 28541135 </td>
   <td style="text-align:right;"> 309632332 </td>
   <td style="text-align:right;"> 23658 </td>
   <td style="text-align:right;"> 745429 </td>
   <td style="text-align:right;"> 11586664381 </td>
   <td style="text-align:right;"> 560992 </td>
   <td style="text-align:right;"> 1025937 </td>
   <td style="text-align:right;"> 1715 </td>
  </tr>
</tbody>
</table>
## Well Data Box Plot
### A visualization of the summary statistics for Well Data

```r
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
```

![](../Figs/exp_boxplot_fracsize-1.png)<!-- -->


```r
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
```

![](../Figs/exp_boxplot_fracsize-1.png)<!-- -->

## Wellsite Frequencies
### A table of well frequency by respective year

```r
# calculate frequency of wells by year 
kable(freq(welldata$vintage.yr), digits = 0) %>% 
    kable_styling(position = "left", 
                  full_width = FALSE
                 )
```

<table class="table" style="width: auto !important; ">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Freq </th>
   <th style="text-align:right;"> % Valid </th>
   <th style="text-align:right;"> % Valid Cum. </th>
   <th style="text-align:right;"> % Total </th>
   <th style="text-align:right;"> % Total Cum. </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:right;"> 139 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:right;"> 443 </td>
   <td style="text-align:right;"> 26 </td>
   <td style="text-align:right;"> 35 </td>
   <td style="text-align:right;"> 26 </td>
   <td style="text-align:right;"> 35 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:right;"> 403 </td>
   <td style="text-align:right;"> 23 </td>
   <td style="text-align:right;"> 59 </td>
   <td style="text-align:right;"> 23 </td>
   <td style="text-align:right;"> 59 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 286 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 75 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 75 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 374 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 97 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 97 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:right;"> 51 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 100 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> &lt;NA&gt; </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Total </td>
   <td style="text-align:right;"> 1715 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 100 </td>
  </tr>
</tbody>
</table>

## Wellsite Production Frequencies
### A table of well production by respective year

```r
# calculate frequency of wells by status
kable(freq(welldata$status), digits = 0) %>% 
    kable_styling(position = "right",
                 full_width = FALSE
                 )
```

<table class="table" style="width: auto !important; margin-right: 0; margin-left: auto">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Freq </th>
   <th style="text-align:right;"> % Valid </th>
   <th style="text-align:right;"> % Valid Cum. </th>
   <th style="text-align:right;"> % Total </th>
   <th style="text-align:right;"> % Total Cum. </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> COMPLETED </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DUC </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PERMIT </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PRODUCING </td>
   <td style="text-align:right;"> 1705 </td>
   <td style="text-align:right;"> 99 </td>
   <td style="text-align:right;"> 99 </td>
   <td style="text-align:right;"> 99 </td>
   <td style="text-align:right;"> 99 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> STALE-PERMIT </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 99 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 99 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TA </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 100 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> &lt;NA&gt; </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 100 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Total </td>
   <td style="text-align:right;"> 1715 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 100 </td>
  </tr>
</tbody>
</table>

## Frac Size Distribution
### Plot 1




## Conclusions
From the p-values for the Linear Regression Model coefficients (last column) from the anova() output, you can see that the explanitory variable frac.size given formavg makes a significant contribution to the equation (you can reject the hypothesis that the parameters are 0). With that being evident, there is no need to fit a second reduced model that may fit the data as well. The log-log Linear Regression Model shows that each regression coefficient in the model is statistically significant (p < .05). The anova() function for linear models uses a F-test resulting in an (F-value = 5.9052) and (Pr(>F) < 0.0001). The nonsignificant  F-value (p < 0.0001) suggests that the model fits well, reinforcing your belief that frac.size given formavg adds significantly to the model above and therefore, you can base your interpretations on the resulting linear model. 



## Conclusions
From the p-values for the Full Logistic Regression Model coefficients (last column) of the anova.full model output, you can see that the predictor variable Status may not make a significant contribution to the equation (you can't reject the hypothesis that the parameters are 0). With that being evident, there is a need to fit a second equation without the Status variable and test whether this reduced model fits the data as well. The Reduced Logistic Regression Model shows that each regression coefficient in the reduced model is statistically significant (p < .05). Because the two models are nested (fit.reduced is a subset of fit.full), you can use the anova() function to compare them. For generalized linear models, you’ll want a chi-square version of this test. The nonsignificant chi-square value (p < 0.0001) suggests that the reduced model with three predictors fits as well as the full model with seven predictors, reinforcing your belief that Status, CountyName, Latitude, and Longitude don’t add significantly to the prediction above and beyond the other variables in the equation. Therefore, you can base your interpretations on the simpler model. 


# Appendix:


```
## $names
##  [1] "R.version"  "platform"   "locale"     "running"    "basePkgs"   "otherPkgs"  "loadedOnly"
##  [8] "matprod"    "BLAS"       "LAPACK"    
## 
## $class
## [1] "sessionInfo"
```



<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> platform </th>
   <th style="text-align:left;"> arch </th>
   <th style="text-align:left;"> os </th>
   <th style="text-align:left;"> system </th>
   <th style="text-align:left;"> status </th>
   <th style="text-align:left;"> major </th>
   <th style="text-align:left;"> minor </th>
   <th style="text-align:left;"> year </th>
   <th style="text-align:left;"> month </th>
   <th style="text-align:left;"> day </th>
   <th style="text-align:left;"> svn.rev </th>
   <th style="text-align:left;"> language </th>
   <th style="text-align:left;"> version.string </th>
   <th style="text-align:left;"> nickname </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x86_64-w64-mingw32 </td>
   <td style="text-align:left;"> x86_64 </td>
   <td style="text-align:left;"> mingw32 </td>
   <td style="text-align:left;"> x86_64, mingw32 </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> 5.1 </td>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 07 </td>
   <td style="text-align:left;"> 02 </td>
   <td style="text-align:left;"> 74947 </td>
   <td style="text-align:left;"> R </td>
   <td style="text-align:left;"> R version 3.5.1 (2018-07-02) </td>
   <td style="text-align:left;"> Feather Spray </td>
  </tr>
</tbody>
</table>

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> . </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x86_64-w64-mingw32/x64 (64-bit) </td>
  </tr>
</tbody>
</table>

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> . </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> LC_COLLATE=English_United States.1252;LC_CTYPE=English_United States.1252;LC_MONETARY=English_United States.1252;LC_NUMERIC=C;LC_TIME=English_United States.1252 </td>
  </tr>
</tbody>
</table>


<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> . </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Windows 10 x64 (build 16299) </td>
  </tr>
</tbody>
</table>

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> . </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> grid </td>
  </tr>
  <tr>
   <td style="text-align:left;"> stats </td>
  </tr>
  <tr>
   <td style="text-align:left;"> graphics </td>
  </tr>
  <tr>
   <td style="text-align:left;"> grDevices </td>
  </tr>
  <tr>
   <td style="text-align:left;"> utils </td>
  </tr>
  <tr>
   <td style="text-align:left;"> datasets </td>
  </tr>
  <tr>
   <td style="text-align:left;"> methods </td>
  </tr>
  <tr>
   <td style="text-align:left;"> base </td>
  </tr>
</tbody>
</table>

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> pkgs </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> bindrcpp </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AER </td>
  </tr>
  <tr>
   <td style="text-align:left;"> survival </td>
  </tr>
  <tr>
   <td style="text-align:left;"> sandwich </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lmtest </td>
  </tr>
  <tr>
   <td style="text-align:left;"> zoo </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gridExtra </td>
  </tr>
  <tr>
   <td style="text-align:left;"> summarytools </td>
  </tr>
  <tr>
   <td style="text-align:left;"> knitr </td>
  </tr>
  <tr>
   <td style="text-align:left;"> car </td>
  </tr>
  <tr>
   <td style="text-align:left;"> carData </td>
  </tr>
  <tr>
   <td style="text-align:left;"> kableExtra </td>
  </tr>
  <tr>
   <td style="text-align:left;"> magrittr </td>
  </tr>
  <tr>
   <td style="text-align:left;"> forcats </td>
  </tr>
  <tr>
   <td style="text-align:left;"> stringr </td>
  </tr>
  <tr>
   <td style="text-align:left;"> dplyr </td>
  </tr>
  <tr>
   <td style="text-align:left;"> purrr </td>
  </tr>
  <tr>
   <td style="text-align:left;"> readr </td>
  </tr>
  <tr>
   <td style="text-align:left;"> tidyr </td>
  </tr>
  <tr>
   <td style="text-align:left;"> tibble </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ggplot2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> tidyverse </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rmarkdown </td>
  </tr>
</tbody>
</table>

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> pkgs </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> httr </td>
  </tr>
  <tr>
   <td style="text-align:left;"> jsonlite </td>
  </tr>
  <tr>
   <td style="text-align:left;"> viridisLite </td>
  </tr>
  <tr>
   <td style="text-align:left;"> splines </td>
  </tr>
  <tr>
   <td style="text-align:left;"> prettydoc </td>
  </tr>
  <tr>
   <td style="text-align:left;"> modelr </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Formula </td>
  </tr>
  <tr>
   <td style="text-align:left;"> assertthat </td>
  </tr>
  <tr>
   <td style="text-align:left;"> highr </td>
  </tr>
  <tr>
   <td style="text-align:left;"> pander </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cellranger </td>
  </tr>
  <tr>
   <td style="text-align:left;"> yaml </td>
  </tr>
  <tr>
   <td style="text-align:left;"> pillar </td>
  </tr>
  <tr>
   <td style="text-align:left;"> backports </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lattice </td>
  </tr>
  <tr>
   <td style="text-align:left;"> glue </td>
  </tr>
  <tr>
   <td style="text-align:left;"> digest </td>
  </tr>
  <tr>
   <td style="text-align:left;"> pryr </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rvest </td>
  </tr>
  <tr>
   <td style="text-align:left;"> colorspace </td>
  </tr>
  <tr>
   <td style="text-align:left;"> htmltools </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Matrix </td>
  </tr>
  <tr>
   <td style="text-align:left;"> plyr </td>
  </tr>
  <tr>
   <td style="text-align:left;"> pkgconfig </td>
  </tr>
  <tr>
   <td style="text-align:left;"> broom </td>
  </tr>
  <tr>
   <td style="text-align:left;"> haven </td>
  </tr>
  <tr>
   <td style="text-align:left;"> scales </td>
  </tr>
  <tr>
   <td style="text-align:left;"> openxlsx </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rio </td>
  </tr>
  <tr>
   <td style="text-align:left;"> withr </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lazyeval </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cli </td>
  </tr>
  <tr>
   <td style="text-align:left;"> crayon </td>
  </tr>
  <tr>
   <td style="text-align:left;"> readxl </td>
  </tr>
  <tr>
   <td style="text-align:left;"> evaluate </td>
  </tr>
  <tr>
   <td style="text-align:left;"> nlme </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xml2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> foreign </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rapportools </td>
  </tr>
  <tr>
   <td style="text-align:left;"> tools </td>
  </tr>
  <tr>
   <td style="text-align:left;"> data.table </td>
  </tr>
  <tr>
   <td style="text-align:left;"> hms </td>
  </tr>
  <tr>
   <td style="text-align:left;"> formatR </td>
  </tr>
  <tr>
   <td style="text-align:left;"> matrixStats </td>
  </tr>
  <tr>
   <td style="text-align:left;"> munsell </td>
  </tr>
  <tr>
   <td style="text-align:left;"> zip </td>
  </tr>
  <tr>
   <td style="text-align:left;"> compiler </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rlang </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RCurl </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rstudioapi </td>
  </tr>
  <tr>
   <td style="text-align:left;"> labeling </td>
  </tr>
  <tr>
   <td style="text-align:left;"> bitops </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gtable </td>
  </tr>
  <tr>
   <td style="text-align:left;"> codetools </td>
  </tr>
  <tr>
   <td style="text-align:left;"> abind </td>
  </tr>
  <tr>
   <td style="text-align:left;"> curl </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lubridate </td>
  </tr>
  <tr>
   <td style="text-align:left;"> bindr </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rprojroot </td>
  </tr>
  <tr>
   <td style="text-align:left;"> stringi </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rcpp </td>
  </tr>
  <tr>
   <td style="text-align:left;"> tidyselect </td>
  </tr>
</tbody>
</table>

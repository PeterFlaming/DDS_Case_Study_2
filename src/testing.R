descr(welldata, stats = U.STATS, transpose = TRUE)

setwd('C:\\Repositories\\DDS_Case_Study_2\\src')
source("Setup.R")
source("Functions.R")
source('DataImport-FracFocus.R')
source('DataImport-WellFeatures.R')
source('Explore_Data.R')

welldata %>% head()


welldata %>% colnames()

fracfocus %>% colnames()
  geom_bar(stat= "identity",
           fill = "red", 
           color = "black", 
           width=1,
           #aes(y =..density..)
           ) +
  #facet_grid(vintage.yr ~ formavg, scales = "free") +
  theme(text = element_text(size=10),
        axis.text.x = element_text(angle=90, hjust=1)) +
  theme(legend.position="none") +
  ggtitle("Median Frac Size by Formation") +
  xlab("Proppant (lb/ft)") +
  ylab("Fluid (bbl/ft)") +
  theme(plot.title = element_text(hjust = 0.5))




















nrow(welldata)

class(COL.ALLFORMS)


COL.ALLFORMS[name]

names(COL.ALLFORMS)


freq(welldata$status) %>% as.data.frame() %>% select("Freq","% Total")


Grid Layouts:

freq_layout <- rbind(c(1,1,1,2,2),
                     c(1,1,1,3,3))

grid.arrange(tableGrob(freq(welldata$vintage.yr))
                      ,tableGrob(freq(welldata$vintage.yr))
                      ,tableGrob(freq(welldata$vintage.yr))
                      , layout_matrix = freq_layout)



Altername Headers:

  html_document:
    theme: null
    highlight: null
    css: dark.css


css:
```{css echo = FALSE}
<style>
  .col2 {
    columns: 2 200px;         /* number of columns and width in pixels*/
    -webkit-columns: 2 200px; /* chrome, safari */
    -moz-columns: 2 200px;    /* firefox */
  }
  .col3 {
    columns: 3 100px;
    -webkit-columns: 3 100px;
    -moz-columns: 3 100px;
  }
</style>
<div class="col2">
</div>

 




---------------------------------------------------------------------

## Regression Model 2  
### Logistic Regression Model for Successfully Drilling the Target Formation  
```{r} 
#  fracfocus_registry}
library(readr)
fracfocus_registry <- read_csv("../data/fracfocus_registry.csv",
col_types = cols(API10 = col_number(),
APINumber = col_skip(), ClaimantCompany = col_skip(),
CountyNumber = col_number(), DTMOD = col_skip(),
FFVersion = col_number(), FederalWell = col_logical(),
IndianWell = col_logical(), IngredientComment = col_skip(),
IngredientMSDS = col_logical(), IsWater = col_skip(),
JobEndDate = col_date(format = "%m/%d/%Y"),
JobStartDate = col_date(format = "%m/%d/%Y"),
Latitude = col_number(), Longitude = col_number(),
MassIngredient = col_number(), PercentHFJob = col_skip(),
PercentHighAdditive = col_skip(),
Source = col_skip(), StateNumber = col_skip(),
Supplier = col_skip(), SystemApproach = col_skip(),
TVD = col_number(), TotalBaseNonWaterVolume = col_number(),
TotalBaseWaterVolume = col_number(),
TradeName = col_skip(), pKey = col_number(),
pKeyDisclosure = col_number(), pKeyPurpose = col_skip(),
pKeyRegistryUpload = col_skip()),
na = "0")
View(fracfocus_registry)
str(fracfocus_registry)
TVD <- as.data.frame.numeric(fracfocus_registry$TVD)
TBWV <- as.data.frame.numeric(fracfocus_registry$TotalBaseWaterVolume)
TBNonWV <- as.data.frame.numeric(fracfocus_registry$TotalBaseNonWaterVolume)

fracfocus_registry_clean <- drop_na(fracfocus_registry)

summary(fracfocus_registry_clean)
```

```{r} 
#  deo_well_data}
deo_well_data <- read_csv("../data/deo_well_data.csv")
deo_well_data["PerfLL"] <- as.numeric(deo_well_data$PerfLL)
deo_well_data["FirstProd"] <- as.numeric(deo_well_data$FirstProd)
deo_well_data["Oil_PkNorm_Perk_6mo"] <- as.numeric(deo_well_data$Oil_PkNorm_Perk_6mo)

str(deo_well_data)

deo_well_data_clean <- drop_na(deo_well_data)

summary(deo_well_data_clean)
```

```{r} 
#  Permian Basin Well Data Selection}
library(tidyverse)
Basin_Data <- merge.data.frame(deo_well_data, fracfocus_registry, by = intersect(x="API10", y="API10"))
summary(Basin_Data)
```

## Data Preperation for Logistic Regression Model

```{r} 
#  Logistic Model for Basin_Data}

#Creating Logistic Model binary outcome for TVD greater than 8782ft set as yes, and less than 8782 as no
Basin_Data$ynTVD[Basin_Data$TVD <= 8394] <- 0
Basin_Data$ynTVD[Basin_Data$TVD >= 8394] <- 1
#Create a dichotomous factor to be used as the outcome variable in a logistic regression model
Basin_Data$ynTVD <- factor(Basin_Data$ynTVD, levels=c(0,1), labels=c("No","Yes"))
#View table of output for new predictor variable ynTVD
table(Basin_Data$ynTVD)
#Selecting Basin variables for Logistic Regression and creating new dataset for analysis
Basin_Model_Data <- Basin_Data[, c(4, 5, 8, 15, 16, 17, 18, 22, 32)]
head(Basin_Model_Data)
#Descriptive Statistics for Model variables
summary(Basin_Model_Data)
```

```{r} 
#  Full Logistic Regression Model}
#Full Model formula = ynTVD ~ form_avg + Status + Oil_PkNorm_Perk_6mo + Latitude + Longitude + Projection + CountyName, family = binomial(), data = Basin_Model_Data
fit.full.basin <- glm(ynTVD ~ form_avg + Status + Oil_PkNorm_Perk_6mo + Latitude + Longitude + Projection + CountyName, data=Basin_Model_Data, family=binomial(link='logit'))
```


```{r} 
#  Full Logistic Regression Model Summary}
#Descriptive Statistics for the Full Logistic Regression Model
summary(fit.full.basin)
#There are three predictors ("SPBY_L_SILT", "SPBY_M", and "WFMP_D") and one predictor variable ("Status") that are not statistically significant
```


```{r Full Logistic Regression Model Plots}
plot(fit.full.basin)
```


```{r} 
#  Full Logistic Regression Model 95% CIs}
#95% CI for Full Logistic Model
exp(confint(fit.full.basin))
```


```{r} 
#  Reduced Logistic Regression Model}
#Reduced Logistic Model formula = ynTVD ~ form_avg + Oil_PkNorm_Perk_6mo + Projection, family = binomial(), data = Basin_Model_Data
fit.reduced.basin <- glm(ynTVD ~ form_avg + Oil_PkNorm_Perk_6mo + Projection, data=Basin_Model_Data, family=binomial(link='logit'))
```


```{r} 
#  Reduced Logistic Regression Model Summary}
#Descriptive Statistics for the Reduced Logistic Regression Model
summary(fit.reduced.basin)
```


```{r} 
#  Reduced Logistic Regression Model Plots}
#Plot of reduced Logistic Model
plot(fit.reduced.basin)
```


```{r} 
# Reduced Logistic Regression Model 95% CIs}
#95% CI for Reduced Logistic Model
exp(confint(fit.reduced.basin))
```



```{r} 
#  Check for Overdispersion of Logistic Regression Model}
#Residual deviance divided by residual degrees of freedom is used to detect overdispersion in a binomial model, if considerably larger than 1, you have evidence of overdispersion
overdispersion_test <- deviance(fit.reduced.basin)/df.residual(fit.reduced.basin)
overdispersion_test
```


```{r} 
#  Hypothesis Test for H0 = 1 and Ha != 1}
#First instance
fit <- glm(ynTVD ~ form_avg + Oil_PkNorm_Perk_6mo + CountyName + Latitude + Longitude + Projection, data=Basin_Model_Data, family=binomial())
#Second instance
fit.od <- glm(ynTVD ~ form_avg + Oil_PkNorm_Perk_6mo + Projection, data=Basin_Model_Data, family = quasibinomial())

#If the p-value is small (say, less than 0.05), you'd reject the null hypothesis
pchisq(summary(fit.od)$dispersion * fit$df.residual, fit$df.residual, lower = F)
#The resulting p-value is clearly significant (p < 0.05), strengthening the belief that overdispersion isn't a problem
```


## Two-Way Anova for Full Logistic Regression Model
### For the two generalized linear models, likelihood-ratio chisquare, Wald chisquare, or F-tests are calculated
```{r} 
#  Two-Way Anova for Full Logistic Regression Model}
library(car)
#Two-Way Anova Test for Full Logistic Regression Model
anova.full <- Anova(fit.full.basin)

anova.full
```

## Two-Way Anova for Reduced Logistic Regression Model
### For the two generalized linear models, likelihood-ratio chisquare, Wald chisquare, or F-tests are calculated
```{r} 
#  Two-Way Anova for the Reduced Logistic Regression Model}
library(car)
#Two-Way Anova Test for Reduced Logistic Regression Model
anova.reduced <- Anova(fit.reduced.basin)

anova.reduced
```


## Results of Tests
```{r} 
#  Results for Anova Chi-Suared Test}
#Comparison of the Two-Way Anova Tests for Full and Reduced Logistic Regression Model
anova(fit.reduced.basin, fit.full.basin, test = "Chisq")



```




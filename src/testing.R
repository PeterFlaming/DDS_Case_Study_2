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


```{r mlr_prod_plots} 
# Linear Regression Model for Well Productivity Plots
plot(effect("frac.size:formavg"
          , well.production
          , list(wt = c(2.2, 3.2, 4.2)))
          , multiline = TRUE)

```

``{r  echo = FALSE}
kable_zen(as.data.frame(session[["platform"]]))
```

```{r  echo = FALSE}
kable_zen(as.data.frame(session[["locale"]]))
```

```{r  echo = FALSE}
kable_zen(as.data.frame(session[["running"]]))
```

```{r  echo = FALSE}
kable_zen(as.data.frame(session[["basePkgs"]]))
```

```{r  echo = FALSE}
kable_zen(as.data.frame(session[["otherPkgs"]]))
```

```{r  echo = FALSE}
kable_zen(as.data.frame(session[["BLAS"]]))
```

```{r  echo = FALSE}
kable_zen(as.data.frame(session[["LAPACK"]]))
```
 [1] "R.version"  "platform"   "locale"     "running"    "basePkgs"
 [6] "otherPkgs"  "loadedOnly" "matprod"    "BLAS"       "LAPACK"


ggplot(welldata) +
      geom_bar(aes(x = reorder(vintage.yr, vintage.yr, FUN=mean),
                   y = frac.size), 
               stat ="identity",
               fill = COL.A.G) 



ggplot(welldata, aes(x = frac.size, fill = vintage.yr)) +
        geom_histogram() +
        #geom_freqpoly() +
        xlim(0, 2000000)










```

### Plot 2
```{r}

```










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

 ```{r  echo = FALSE}
kable_zen(as.data.frame(session[["loadedOnly"]]))
```




---------------------------------------------------------------------


## Regression Model 1
### Multiple Linear Regression Model for Well Productivity given Aggregate and Formation Interaction
Some of the most interesting research findings are those involving interactions among
predictor variables. Consider the welldata oil.pk.bbl measure of production. Let’s say
that you’re interested in the impact of geological formation (formavg) and aggregates (frac.size) on well production (oil.pk.bbl). You could fit a regression model that includes both predictors, along with their
interaction, as shown in the model formula below.

 - formula = lm(log(oil.pk.bbl) ~ log(frac.size) : formavg, data=welldata)  

The formula is typically written as Y ~ X1 + X2 + ... + Xk where the ~ separates the response variable log(oil.pk.bbl) on the left from the predictor variables log(frac.size) : formavg on the right, and the predictor variables are separated by + signs. The colon is used to denote an interaction between predictor variables. A prediction of y from x, z, and the interaction between x and z would be coded y ~ x + z + x:z.
```{r} 
#  Linear Regression Model for Well Productivity}
#Linear Regression Model formula = lm(log(oil.pk.bbl) ~ log(frac.size) : formavg, data=welldata)
well.production <- lm(log(oil.pk.bbl) ~ log(frac.size) : formavg, data = welldata)
```

The use of logarithmic transformations on the quantifiable variables is needed to meet the four linear regression assumptions of Normality, Independence, Linearity, and Homoscedasticity. These logarithmic transformations allow the model to meet all assumptions and our goal is to select model parameters (intercept and slopes) that minimize the difference between actual response values and those predicted by the model. Specifically, model parameters are selected to minimize the sum of squared residuals.


## Linear Regression Model for Well Productivity given Aggregate and Formation Summary
### Summary of Significant Aggregate-Formation Combinations
```{r} 
#  Linear Regression Model for Well Productivity Summary}
summary(well.production)
```
You can see from the Pr(>|t|) column that the interaction between log(frac.size) and
formavg is significant. What does this mean? A significant interaction between two
predictor variables tells you that the relationship between one predictor and the
response variable depends on the level of the other predictor. Here it means the relationship
between log(oil.pk.bbl) and log(frac.size) varies by formavg.



## Linear Regression Model for Well Productivity Plots
### Plots of Linear Model for Production given all Aggregate-Formation Combinations
```{r} 
#  Linear Regression Model for Well Productivity Plots}
install.packages("effects")
library(effects)
#Plot for effect on log(Production) by Aggregate-Formation interaction 
plot(effect("frac.size:formavg", well.production,, list(wt = c(2.2, 3.2, 4.2))), multiline = TRUE)

```


## Linear Regression Model for Well Productivity 95% CIs
### 95% CIs for Significant Aggregate-Formation Combinations
```{r} 
#  Linear Regression Model for Well Productivity 95% CIs}
#95% CI for Linear Regression Model
confint(well.production)
```

## Overdispersion Check for Linear Model
### Rebuild Model if considerally larger than 1
```{r} 
#  Check222 for Overdispersion of Logistic Regression Model}
#Residual deviance divided by residual degrees of freedom is used to detect overdispersion in a binomial model, if considerably larger than 1, you have evidence of overdispersion
overdispersion_test1 <- deviance(well.production)/df.residual(well.production)
overdispersion_test1
```


## Results of Linear Regression Model for Well Productivity given all Aggregate-Formation Combinations
```{r} 
# Results for Anova Test}
#Comparison of the One-Way Anova Tests for Linear Regression Model
anova(well.production)

```


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


crPlots(lm(log(oil.pk.bbl) ~ log(frac.size), data = welldata))

coplot(logBrain ~ logGestation|logLitter)

coplot(log(oil.pk.bbl) ~ log(frac.size) | formavg, data = welldata)


# ff_units <- data.frame(
#         vars = c("api10", "totalwater","totalsand", "tvd"),
#         units = c("","(gal)","(lbs)", "(ft)"))




## Conclusions
From the p-values for the Linear Regression Model coefficients (last column) from the anova() output, you can see that the explanitory variable frac.size given formavg makes a significant contribution to the equation (you can reject the hypothesis that the parameters are 0). With that being evident, there is no need to fit a second reduced model that may fit the data as well. The log-log Linear Regression Model shows that each regression coefficient in the model is statistically significant (p < .05). The anova() function for linear models uses a F-test resulting in an (F-value = 5.9052) and (Pr(>F) < 0.0001). The nonsignificant  F-value (p < 0.0001) suggests that the model fits well, reinforcing your belief that frac.size given formavg adds significantly to the model above and therefore, you can base your interpretations on the resulting linear model. 

----------------------------------------------------------------------------------

## Logistic Regression
```{r} 

deo_well_data <- read_csv("../data/deo_well_data.csv")
deo_well_data["PerfLL"] <- as.numeric(deo_well_data$PerfLL)
deo_well_data["FirstProd"] <- as.numeric(deo_well_data$FirstProd)
deo_well_data["Oil_PkNorm_Perk_6mo"] <- as.numeric(deo_well_data$Oil_PkNorm_Perk_6mo)

str(deo_well_data)

deo_well_data_clean <- drop_na(deo_well_data)

summary(deo_well_data_clean)
```

```{r} 
#Permian Basin Well Data Selection
Basin_Data <- merge.data.frame(deo_well_data, fracfocus, by = intersect(x="API10", y="api10"))
summary(Basin_Data)
```

## Data Preperation for Logistic Regression Model
Logistic regression is applied to situations in which the response variable is dichotomous (0 or 1). The model assumes that Y follows a binomial distribution and that you can fit a linear model of the form where π = μY is the conditional mean of Y (that is, the probability that Y = 1 given a set of X values), (π/1 – π) is the odds that Y = 1, and log(π/1 – π) is the log odds, or logit. In this case, log(π/1 – π) is the link function, the probability distribution is binomial, and the logistic regression model can be fit using glm(Y~X1+X2+X3, family=binomial(link="logit"), data=mydata)

```{r} 
#  Logistic Model for Basin_Data}
# Creating Logistic Model binary outcome for TVD greater than 8782ft set as yes, and less than 8782 as no
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



The target depth is 8394ft. for the WFMP_C_TARGET Formation. 

The glm() function allows you to fit a number of popular models, including logistic regression, Poisson regression, and survival analysis (not considered here). You can demonstrate this for the first two models as follows. Assume that you have a single response variable (Y), three predictor variables (X1, X2, X3), and a data frame (mydata) containing the data.

Logistic regression is useful when you’re predicting a binary outcome from a set of continuous and/or categorical predictor variables. To demonstrate this, let’s explore the well data for total vertical depth of target formation contained in the data frame under study. Be sure to download and install the package (using install.packages("AER")) before first use.

```{r full_model} 
#  Full Logistic Regression Model
fit.full.basin <- glm(ynTVD ~ form_avg + Status + Oil_PkNorm_Perk_6mo + Latitude + Longitude + Projection + CountyName, data=Basin_Model_Data, family=binomial(link='logit'))
```


```{r} 
# Full Logistic Regression Model Summary
summary(fit.full.basin)
```

From the p-values for the regression coefficients (last column), you can see that there are three predictors ("SPBY_L_SILT", "SPBY_M", and "WFMP_D") and one predictor variable ("Status") that are not statistically significant (p-values > 0.05) and they may not make a significant contribution to the equation (you can’t reject the hypothesis that the parameters are 0). Let’s fit a second equation without them and test whether this reduced model fits the data as well:

```{r full_model_plots}
# Full Logistic Regression Model Plots
influencePlot(fit.full.basin)
```

The horizontal axis is the leverage, the vertical axis is the studentized residual, and the plotted symbol is proportional to the Cook’s distance. Diagnostic plots tend to be most helpful when the response variable takes on many values. When the response variable can only take on a limited number of values (for example, logistic regression), the utility of these plots is decreased.You can see from these graphs that as the geological formation (form_avg) of the well increases in depth, the relationship between those significant predictors explane the response of target formation depth throughout the well drilling process.

```{r full_model_ci} 
#  Full Logistic Regression Model 95% CIs
exp(confint(fit.full.basin))
```

The results suggest that you can be 95% confident that the intervals that DO NOT contain 0 predict the true change in well production rate for their respected % change in aggregate:formation interaction rate. Remember that, because the confidence intervals for the DEAN, SPBY_L_SILT, and STRAWN formations contain 0, you can conclude that a change in their rate is unrelated to the well production rate, holding the other variables constant. But your faith in these results is only as strong as the evidence you have that your data satisfies the statistical assumptions underlying the model.

```{r reduced_model} 
# Reduced Logistic Regression Model}
fit.reduced.basin <- glm(ynTVD ~ form_avg + Oil_PkNorm_Perk_6mo + Projection, data=Basin_Model_Data, family=binomial(link='logit'))
```

```{r reduced_model_plots, echo = FALSE}
#  Reduced Logistic Regression Model Plots}
influencePlot(fit.reduced.basin)
```

The horizontal axis is the leverage, the vertical axis is the studentized residual, and the plotted symbol is proportional to the Cook’s distance. Diagnostic plots tend to be most helpful when the response variable takes on many values. When the response variable can only take on a limited number of values (for example, logistic regression), the utility of these plots is decreased.You can see from these graphs that as the geological formation (form_avg) of the well increases in depth, the relationship between those significant predictors explane the response of target formation depth throughout the well drilling process.

## Two-Way Anova for Reduced Logistic Regression Model
  - For the two generalized linear models, likelihood-ratio chisquare, Wald chisquare, or F-tests are calculated.

```{r anova_compare} 
#  Results for Anova Chi-Suared Test
#Comparison of the Two-Way Anova Tests for Full and Reduced Logistic Regression Models
anova(fit.reduced.basin, fit.full.basin, test = "Chisq")

```

The nonsignificant chi-square value (Chi < 0.0001) suggests that the reduced model with three predictors fits as well as the full model with six predictors, reinforcing your belief that status, latitude, longitude, and countyname don’t add significantly to the prediction above and beyond the other variables in the equation. Therefore, you can base your interpretations on the simpler model.





































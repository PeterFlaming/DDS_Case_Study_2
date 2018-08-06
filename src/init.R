require(rmarkdown)
setwd('C:\\Repositories\\DDS_Case_Study_2\\src')
rmarkdown::render('Final_Analysis.Rmd')
browseURL('Final_Analysis.html')
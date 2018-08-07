require(tidyverse)
require(magrittr)
require(kableExtra)
require(car)
require(knitr)
require(summarytools)
require(grid)
require(gridExtra)

# set knitr output options for consistent figures
knitr::opts_chunk$set(fig.width=12, 
                      fig.height=8, 
                      fig.path='../Figs/',
                      warning=FALSE, 
                      message=FALSE,
                      echo = TRUE,
                      #root.dir = normalizePath(".."),
                      #child.dir = normalizePath(".."),
                      cache = FALSE,
                      results = 'markup',
                      collapse = TRUE
                      )



# set visual theme for the project
ggplot2::theme_set(ggplot2::theme_bw())
ggplot2::theme_update(plot.title = ggplot2::element_text(hjust = 0.5))

#prevent implicit conversion to scientific notation
options(scipen = 999)
options(knitr.table.format = "html")
#disable column wrapping
options(width=100) 

# set options for descriptive statistics
st_options('escape.pipe', TRUE)
st_options('descr.stats', c("mean", "sd", "min", "med", "max", "Q1", "Q3", "N.Valid"))
st_options('descr.transpose', TRUE)
st_options('style', "rmarkdown")




require(tidyverse)
require(magrittr)
require(kableExtra)
require(car)
require(knitr)
require(summarytools)

knitr::opts_chunk$set(fig.width=6,#12, 
                      fig.height=4,#8, 
                      fig.path='../Figs/',
                      warning=TRUE, 
                      message=TRUE,
                      echo = TRUE,
                      #root.dir = normalizePath(".."),
                      #child.dir = normalizePath(".."),
                      cache = FALSE,
                      results = 'markup'
                      )


ggplot2::theme_set(ggplot2::theme_bw())
ggplot2::theme_update(plot.title = ggplot2::element_text(hjust = 0.5))

#prevent implicit conversion to scientific notation
options(scipen = 999)

#disable column wrapping
options(width=800) 

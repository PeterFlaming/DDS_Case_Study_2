knitr::opts_chunk$set(echo = TRUE)
ggplot2::theme_set(ggplot2::theme_bw())
ggplot2::theme_update(plot.title = ggplot2::element_text(hjust = 0.5))
knitr::opts_chunk$set(fig.width=6,#12, 
                      fig.height=4,#8, 
                      fig.path='Figs/',
                      warning=FALSE, 
                      message=FALSE)

require(tidyverse)
require(magrittr)
require(kableExtra)
require(car)
#options(knitr.table.format = "asis")#"markdown")

#prevent implicit conversion to scientific notation
options(scipen = 999)
knitr::opts_knit$set(root.dir = normalizePath(".."),
                     child.dir = normalizePath(".."))



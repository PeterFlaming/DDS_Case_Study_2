ggplot2::theme_set(ggplot2::theme_bw())
ggplot2::theme_update(plot.title = ggplot2::element_text(hjust = 0.5))
knitr::opts_chunk$set(fig.width = 12,
                      fig.height = 8,
                      fig.path = 'Figs/',
                      warning = FALSE,
                      message = FALSE)

require(tidyverse)
require(magrittr)
require(kableExtra)
options(knitr.table.format = "markdown")

setwd("C:/Repositories/DDS_Case_Study_2")


descr(welldata, stats = U.STATS, transpose = TRUE)

st_options()

welldata %>% head()

fracfocus %>% colnames()

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

 








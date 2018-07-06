Fetch NASA-POWER Parameters
================
Adam H Sparks
2018-07-05

# Create parameters list for internal checks

These data are used for internal checks to be sure that data requested
from the POWER dataset are valid. The POWER list of parameters that can
be queried is available as a JSON file. Thanks to
[raymondben](https://github.com/raymondben) for pointing me to this
file.

## Fetch list from JSON file

Using `jsonlite` read the JSON file into R creating a list.

``` r
parameters <-
  jsonlite::fromJSON(
    "https://power.larc.nasa.gov/RADAPP/GEODATA/powerWeb/POWER_Parameters_v108.json"
  )
```

Replace UTF-8 characters in the dataset since R doesn’t like this in
packages.

``` r
parameters$SG_DEC_AVG$climatology_definition <-
  gsub("°",
       " degrees",
       parameters$SG_DEC_AVG$climatology_definition)

parameters$SG_HR_SET_ANG$climatology_definition <-
  gsub("°",
       " degrees",
       parameters$SG_HR_SET_ANG$climatology_definition)

parameters$SG_NOON$climatology_definition <-
  gsub("°",
       " degrees",
       parameters$SG_NOON$climatology_definition)
```

## Save list for use in `nasapower` package

Using `devtools` to save the list as an R data object for use in the
`nasapower`
    package.

``` r
devtools::use_data(parameters, overwrite = TRUE)
```

## Session Info

``` r
sessioninfo::session_info()
```

    ## ─ Session info ──────────────────────────────────────────────────────────
    ##  setting  value                       
    ##  version  R version 3.5.1 (2018-07-02)
    ##  os       macOS High Sierra 10.13.5   
    ##  system   x86_64, darwin17.6.0        
    ##  ui       X11                         
    ##  language (EN)                        
    ##  collate  en_AU.UTF-8                 
    ##  tz       Australia/Brisbane          
    ##  date     2018-07-05                  
    ## 
    ## ─ Packages ──────────────────────────────────────────────────────────────
    ##  package     * version date       source        
    ##  backports     1.1.2   2017-12-13 CRAN (R 3.5.1)
    ##  clisymbols    1.2.0   2017-05-21 CRAN (R 3.5.1)
    ##  curl          3.2     2018-03-28 CRAN (R 3.5.1)
    ##  devtools      1.13.6  2018-06-27 CRAN (R 3.5.1)
    ##  digest        0.6.15  2018-01-28 CRAN (R 3.5.1)
    ##  evaluate      0.10.1  2017-06-24 CRAN (R 3.5.1)
    ##  htmltools     0.3.6   2017-04-28 CRAN (R 3.5.1)
    ##  jsonlite      1.5     2017-06-01 CRAN (R 3.5.1)
    ##  knitr         1.20    2018-02-20 CRAN (R 3.5.1)
    ##  magrittr      1.5     2014-11-22 CRAN (R 3.5.1)
    ##  memoise       1.1.0   2017-04-21 CRAN (R 3.5.1)
    ##  Rcpp          0.12.17 2018-05-18 CRAN (R 3.5.1)
    ##  rmarkdown     1.10    2018-06-11 CRAN (R 3.5.1)
    ##  rprojroot     1.3-2   2018-01-03 CRAN (R 3.5.1)
    ##  sessioninfo   1.0.0   2017-06-21 CRAN (R 3.5.1)
    ##  stringi       1.2.3   2018-06-12 CRAN (R 3.5.1)
    ##  stringr       1.3.1   2018-05-10 CRAN (R 3.5.1)
    ##  withr         2.1.2   2018-03-15 CRAN (R 3.5.1)
    ##  yaml          2.1.19  2018-05-01 CRAN (R 3.5.1)

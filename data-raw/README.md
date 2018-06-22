Fetch NASA/POWER Parameters
================
Adam H Sparks
2018-06-22

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
    ##  version  R version 3.5.0 (2018-04-23)
    ##  os       macOS Sierra 10.12.6        
    ##  system   x86_64, darwin16.7.0        
    ##  ui       X11                         
    ##  language (EN)                        
    ##  collate  en_AU.UTF-8                 
    ##  tz       Australia/Brisbane          
    ##  date     2018-06-22                  
    ## 
    ## ─ Packages ──────────────────────────────────────────────────────────────
    ##  package     * version date       source        
    ##  backports     1.1.2   2017-12-13 CRAN (R 3.5.0)
    ##  clisymbols    1.2.0   2017-05-21 CRAN (R 3.5.0)
    ##  curl          3.2     2018-03-28 CRAN (R 3.5.0)
    ##  devtools      1.13.5  2018-02-18 CRAN (R 3.5.0)
    ##  digest        0.6.15  2018-01-28 CRAN (R 3.5.0)
    ##  evaluate      0.10.1  2017-06-24 CRAN (R 3.5.0)
    ##  htmltools     0.3.6   2017-04-28 CRAN (R 3.5.0)
    ##  jsonlite      1.5     2017-06-01 CRAN (R 3.5.0)
    ##  knitr         1.20    2018-02-20 CRAN (R 3.5.0)
    ##  magrittr      1.5     2014-11-22 CRAN (R 3.5.0)
    ##  memoise       1.1.0   2017-04-21 CRAN (R 3.5.0)
    ##  Rcpp          0.12.17 2018-05-18 CRAN (R 3.5.0)
    ##  rmarkdown     1.10    2018-06-11 CRAN (R 3.5.0)
    ##  rprojroot     1.3-2   2018-01-03 CRAN (R 3.5.0)
    ##  sessioninfo   1.0.0   2017-06-21 CRAN (R 3.5.0)
    ##  stringi       1.2.3   2018-06-12 cran (@1.2.3) 
    ##  stringr       1.3.1   2018-05-10 CRAN (R 3.5.0)
    ##  withr         2.1.2   2018-03-15 CRAN (R 3.5.0)
    ##  yaml          2.1.19  2018-05-01 CRAN (R 3.5.0)

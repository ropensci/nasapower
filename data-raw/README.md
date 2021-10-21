Fetch NASA-POWER Parameters and Include Them as an Internal List
================
Adam H Sparks
2021-10-21

# Create parameters nested list for internal checks before sending queries to POWER server

These data are used for internal checks to be sure that data requested
from the POWER dataset are valid. The POWER list of parameters that can
be queried is available as an API query from the POWER server.

The list structure will be

-   `parameters`
    -   `HOURLY_AG`
        -   `parameter_1` …
        -   `parameter_n`
    -   `DAILY_AG`
        -   `parameter_1` …
        -   `parameter_n`
    -   `MONTHLY_AG`
        -   `parameter_1` …
        -   `parameter_n`
    -   `CLIMATOLOGY_AG`
        -   `parameter_1` …
        -   `parameter_n`
    -   `HOURLY_RE`
        -   `parameter_1` …
        -   `parameter_n`
    -   `DAILY_RE`
        -   `parameter_1` …
        -   `parameter_n`
    -   `MONTHLY_RE`
        -   `parameter_1` …
        -   `parameter_n`
    -   `CLIMATOLOGY_RE`
        -   `parameter_1` …
        -   `parameter_n`
    -   `HOURLY_SB`
        -   `parameter_1` …
        -   `parameter_n`
    -   `DAILY_SB`
        -   `parameter_1` …
        -   `parameter_n`
    -   `MONTHLY_SB`
        -   `parameter_1` …
        -   `parameter_n`
    -   `CLIMATOLOGY_SB`
        -   `parameter_1` …
        -   `parameter_n`

## POWER JSON file

Using `purrr::map2` and jsonlite::fromJSON()\` read the JSON file into R
creating a single, nested list and reorder it alphabetically by
parameter name.

``` r
library("purrr")
library("jsonlite")
```

    ## 
    ## Attaching package: 'jsonlite'

    ## The following object is masked from 'package:purrr':
    ## 
    ##     flatten

``` r
temporal_api <- c("HOURLY", "DAILY", "MONTHLY", "CLIMATOLOGY")
community <- c("AG", "RE", "SB")

# create all combinations
vals <- expand.grid(temporal_api, community, stringsAsFactors = FALSE)

# create equal length vectors for purrr::map2
temporal_api <- vals[, 1]
community <- vals[, 2]

base_url <- "https://power.larc.nasa.gov/api/system/manager/parameters?"

power_pars <- map2(.x = temporal_api,
                  .y = community,
                  .f = ~ fromJSON(paste0(
                    base_url,
                    "temporal=",
                    .x,
                    "&community=",
                    .y
                  )))

names(power_pars) <- paste(temporal_api, community, sep = "_")

# create a list of vectors for each temporal API/par combination for easier
# checking and validation
parameters <- vector(mode = "list", length = length(power_pars))
for (i in names(power_pars)) {
  parameters[[i]] <- names(power_pars[[i]])
}
```

## Save list for use in `nasapower` package

Using `usethis::use_data()` save the list as an R data object for use in
the *nasapower* package. These values will not be exposed to the user
and so will not be documented as previously. Users will be be pointed to
functions to interact directly with the POWER APIs to query information
for the temporal API/community combinations or for the parameters
themselves.

``` r
usethis::use_data(parameters, overwrite = TRUE, internal = TRUE)
```

## Session Info

``` r
sessioninfo::session_info()
```

    ## ─ Session info ───────────────────────────────────────────────────────────────
    ##  setting  value                       
    ##  version  R version 4.1.1 (2021-08-10)
    ##  os       macOS Big Sur 11.6          
    ##  system   aarch64, darwin20           
    ##  ui       X11                         
    ##  language (EN)                        
    ##  collate  en_AU.UTF-8                 
    ##  ctype    en_AU.UTF-8                 
    ##  tz       Australia/Perth             
    ##  date     2021-10-21                  
    ## 
    ## ─ Packages ───────────────────────────────────────────────────────────────────
    ##  package     * version date       lib source        
    ##  cli           3.0.1   2021-07-17 [1] CRAN (R 4.1.0)
    ##  crayon        1.4.1   2021-02-08 [1] CRAN (R 4.1.0)
    ##  curl          4.3.2   2021-06-23 [1] CRAN (R 4.1.0)
    ##  desc          1.4.0   2021-09-28 [1] CRAN (R 4.1.1)
    ##  digest        0.6.28  2021-09-23 [1] CRAN (R 4.1.1)
    ##  ellipsis      0.3.2   2021-04-29 [1] CRAN (R 4.1.0)
    ##  evaluate      0.14    2019-05-28 [1] CRAN (R 4.1.0)
    ##  fansi         0.5.0   2021-05-25 [1] CRAN (R 4.1.0)
    ##  fastmap       1.1.0   2021-01-25 [1] CRAN (R 4.1.0)
    ##  fs            1.5.0   2020-07-31 [1] CRAN (R 4.1.0)
    ##  glue          1.4.2   2020-08-27 [1] CRAN (R 4.1.0)
    ##  htmltools     0.5.2   2021-08-25 [1] CRAN (R 4.1.1)
    ##  jsonlite    * 1.7.2   2020-12-09 [1] CRAN (R 4.1.0)
    ##  knitr         1.36    2021-09-29 [1] CRAN (R 4.1.1)
    ##  lifecycle     1.0.1   2021-09-24 [1] CRAN (R 4.1.1)
    ##  magrittr      2.0.1   2020-11-17 [1] CRAN (R 4.1.0)
    ##  pillar        1.6.4   2021-10-18 [1] CRAN (R 4.1.1)
    ##  pkgconfig     2.0.3   2019-09-22 [1] CRAN (R 4.1.0)
    ##  purrr       * 0.3.4   2020-04-17 [1] CRAN (R 4.1.0)
    ##  R6            2.5.1   2021-08-19 [1] CRAN (R 4.1.1)
    ##  rlang         0.4.12  2021-10-18 [1] CRAN (R 4.1.1)
    ##  rmarkdown     2.11    2021-09-14 [1] CRAN (R 4.1.1)
    ##  rprojroot     2.0.2   2020-11-15 [1] CRAN (R 4.1.0)
    ##  rstudioapi    0.13    2020-11-12 [1] CRAN (R 4.1.0)
    ##  sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 4.1.0)
    ##  stringi       1.7.5   2021-10-04 [1] CRAN (R 4.1.1)
    ##  stringr       1.4.0   2019-02-10 [1] CRAN (R 4.1.0)
    ##  tibble        3.1.5   2021-09-30 [1] CRAN (R 4.1.1)
    ##  usethis       2.1.0   2021-10-16 [1] CRAN (R 4.1.1)
    ##  utf8          1.2.2   2021-07-24 [1] CRAN (R 4.1.0)
    ##  vctrs         0.3.8   2021-04-29 [1] CRAN (R 4.1.0)
    ##  withr         2.4.2   2021-04-18 [1] CRAN (R 4.1.0)
    ##  xfun          0.26    2021-09-14 [1] CRAN (R 4.1.1)
    ##  yaml          2.2.1   2020-02-01 [1] CRAN (R 4.1.0)
    ## 
    ## [1] /Library/Frameworks/R.framework/Versions/4.1-arm64/Resources/library

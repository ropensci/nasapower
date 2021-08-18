Fetch NASA-POWER Parameters and Include Them as an Internal List
================
Adam H Sparks
2021-08-13

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
    ##  version  R version 4.1.0 (2021-05-18)
    ##  os       macOS Big Sur 11.5.1        
    ##  system   aarch64, darwin20           
    ##  ui       X11                         
    ##  language (EN)                        
    ##  collate  en_AU.UTF-8                 
    ##  ctype    en_AU.UTF-8                 
    ##  tz       Australia/Perth             
    ##  date     2021-08-13                  
    ## 
    ## ─ Packages ───────────────────────────────────────────────────────────────────
    ##  ! package     * version date       lib source        
    ##    cli           3.0.1   2021-07-17 [1] CRAN (R 4.1.0)
    ##  P crayon        1.4.1   2021-02-08 [?] CRAN (R 4.1.0)
    ##    curl          4.3.2   2021-06-23 [1] CRAN (R 4.1.0)
    ##  P desc          1.3.0   2021-03-05 [?] CRAN (R 4.1.0)
    ##  P digest        0.6.27  2020-10-24 [?] CRAN (R 4.1.0)
    ##  P ellipsis      0.3.2   2021-04-29 [?] CRAN (R 4.1.0)
    ##  P evaluate      0.14    2019-05-28 [?] CRAN (R 4.1.0)
    ##  P fansi         0.5.0   2021-05-25 [?] CRAN (R 4.1.0)
    ##  P fs            1.5.0   2020-07-31 [?] CRAN (R 4.1.0)
    ##  P glue          1.4.2   2020-08-27 [?] CRAN (R 4.1.0)
    ##  P htmltools     0.5.1.1 2021-01-22 [?] CRAN (R 4.1.0)
    ##  P jsonlite    * 1.7.2   2020-12-09 [?] CRAN (R 4.1.0)
    ##  P knitr         1.33    2021-04-24 [?] CRAN (R 4.1.0)
    ##  P lifecycle     1.0.0   2021-02-15 [?] CRAN (R 4.1.0)
    ##  P magrittr      2.0.1   2020-11-17 [?] CRAN (R 4.1.0)
    ##    pillar        1.6.2   2021-07-29 [1] CRAN (R 4.1.0)
    ##  P pkgconfig     2.0.3   2019-09-22 [?] CRAN (R 4.1.0)
    ##  P purrr       * 0.3.4   2020-04-17 [?] CRAN (R 4.1.0)
    ##  P R6            2.5.0   2020-10-28 [?] CRAN (R 4.1.0)
    ##  P rlang         0.4.11  2021-04-30 [?] CRAN (R 4.1.0)
    ##    rmarkdown     2.10    2021-08-06 [1] CRAN (R 4.1.0)
    ##  P rprojroot     2.0.2   2020-11-15 [?] CRAN (R 4.1.0)
    ##  P rstudioapi    0.13    2020-11-12 [?] CRAN (R 4.1.0)
    ##  P sessioninfo   1.1.1   2018-11-05 [?] CRAN (R 4.1.0)
    ##    stringi       1.7.3   2021-07-16 [1] CRAN (R 4.1.0)
    ##  P stringr       1.4.0   2019-02-10 [?] CRAN (R 4.1.0)
    ##    tibble        3.1.3   2021-07-23 [1] CRAN (R 4.1.0)
    ##  P usethis       2.0.1   2021-02-10 [?] CRAN (R 4.1.0)
    ##    utf8          1.2.2   2021-07-24 [1] CRAN (R 4.1.0)
    ##  P vctrs         0.3.8   2021-04-29 [?] CRAN (R 4.1.0)
    ##  P withr         2.4.2   2021-04-18 [?] CRAN (R 4.1.0)
    ##    xfun          0.25    2021-08-06 [1] CRAN (R 4.1.0)
    ##  P yaml          2.2.1   2020-02-01 [?] CRAN (R 4.1.0)
    ## 
    ## [1] /Users/adamsparks/Development/GitHub/rOpenSci/nasapower/renv/library/R-4.1/aarch64-apple-darwin20
    ## [2] /private/var/folders/tr/fwv720l96bz2btcr0jr_gs840000gn/T/RtmpAypaK5/renv-system-library
    ## [3] /Library/Frameworks/R.framework/Versions/4.1-arm64/Resources/library
    ## 
    ##  P ── Loaded and on-disk path mismatch.

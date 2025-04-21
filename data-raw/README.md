---
title: "Fetch NASA-POWER Parameters and Include Them as an Internal List"
author: "Adam H. Sparks"
date: "2025-04-21"
output: github_document
---



# Create parameters nested list for internal checks before sending queries to POWER server

These data are used for internal checks to be sure that data requested from the POWER dataset are valid.
The POWER list of parameters that can be queried is available as an API query from the POWER server.

The list structure will be

-   `parameters`
    -   `HOURLY_AG`
        -   `parameter_1` ...
        -   `parameter_n`
    -   `DAILY_AG`
        -   `parameter_1` ...
        -   `parameter_n`
    -   `MONTHLY_AG`
        -   `parameter_1` ...
        -   `parameter_n`
    -   `CLIMATOLOGY_AG`
        -   `parameter_1` ...
        -   `parameter_n`
    -   `HOURLY_RE`
        -   `parameter_1` ...
        -   `parameter_n`
    -   `DAILY_RE`
        -   `parameter_1` ...
        -   `parameter_n`
    -   `MONTHLY_RE`
        -   `parameter_1` ...
        -   `parameter_n`
    -   `CLIMATOLOGY_RE`
        -   `parameter_1` ...
        -   `parameter_n`
    -   `HOURLY_SB`
        -   `parameter_1` ...
        -   `parameter_n`
    -   `DAILY_SB`
        -   `parameter_1` ...
        -   `parameter_n`
    -   `MONTHLY_SB`
        -   `parameter_1` ...
        -   `parameter_n`
    -   `CLIMATOLOGY_SB`
        -   `parameter_1` ...
        -   `parameter_n`
...

and so on.

## POWER JSON file

Using `purrr::map2` and `jsonlite::fromJSON()` read the JSON file into R creating a single, nested list and reorder it alphabetically by parameter name.


``` r
library(purrr)
```

```
## 
## Attaching package: 'purrr'
```

```
## The following object is masked from 'package:testthat':
## 
##     is_null
```

``` r
library(jsonlite)
```

```
## 
## Attaching package: 'jsonlite'
```

```
## The following object is masked from 'package:purrr':
## 
##     flatten
```

``` r
temporal_api <- c("HOURLY", "DAILY", "MONTHLY", "CLIMATOLOGY")
community <- c("AG", "RE", "SB")

# create all combinations
vals <- expand.grid(temporal_api, community, stringsAsFactors = FALSE)

# create equal length vectors for purrr::map2
temporal_api <- vals[, 1]
community <- vals[, 2]

base_url <- "https://power.larc.nasa.gov/api/system/manager/parameters?"

power_pars <- map2(
  .x = temporal_api,
  .y = community,
  .f = ~ fromJSON(sprintf(
    "%stemporal=%s&community=%s", base_url, .x, .y
  ))
)

names(power_pars) <- paste(temporal_api, community, sep = "_")

# create a list of vectors for each temporal API/par combination for easier
# checking and validation
parameters <- vector(mode = "list", length = length(power_pars))
names(parameters) <- names(power_pars)
for (i in names(power_pars)) {
  parameters[[i]] <- names(power_pars[[i]])
}

parameters <- map(.x = parameters, .f = sort)
```

## Save list for use in `nasapower` package

Using `usethis::use_data()` save the list as an R data object for use in the *nasapower* package.
These values will not be exposed to the user and so will not be documented as previously.
Users will be be pointed to functions to interact directly with the POWER APIs to query information for the temporal API/community combinations or for the parameters themselves.


``` r
usethis::use_data(parameters, overwrite = TRUE, internal = TRUE)
```

## Session Info


``` r
sessioninfo::session_info()
```

```
## ─ Session info ───────────────────────────────────────────────────────────────
##  setting  value
##  version  R version 4.5.0 (2025-04-11)
##  os       macOS Sequoia 15.4.1
##  system   aarch64, darwin20
##  ui       X11
##  language (EN)
##  collate  en_AU.UTF-8
##  ctype    en_AU.UTF-8
##  tz       Australia/Perth
##  date     2025-04-21
##  pandoc   3.6.4 @ /opt/homebrew/bin/pandoc
##  quarto   1.6.43 @ /usr/local/bin/quarto
## 
## ─ Packages ───────────────────────────────────────────────────────────────────
##  ! package     * version    date (UTC) lib source
##    askpass       1.2.1      2024-10-04 [1] CRAN (R 4.5.0)
##    base64enc     0.1-3      2015-07-28 [1] CRAN (R 4.5.0)
##    brio          1.1.5      2024-04-24 [1] CRAN (R 4.5.0)
##    cachem        1.1.0      2024-05-16 [1] CRAN (R 4.5.0)
##    cli           3.6.4      2025-02-13 [1] CRAN (R 4.5.0)
##    commonmark    1.9.5      2025-03-17 [1] CRAN (R 4.5.0)
##    credentials   2.0.2      2024-10-04 [1] CRAN (R 4.5.0)
##    crul          1.5.0      2024-07-19 [1] CRAN (R 4.5.0)
##    curl          6.2.2      2025-03-24 [1] CRAN (R 4.5.0)
##    desc          1.4.3      2023-12-10 [1] CRAN (R 4.5.0)
##    devtag        0.0.0.9000 2025-04-18 [1] Github (moodymudskipper/devtag@24f9b21)
##    devtools      2.4.5      2022-10-11 [1] CRAN (R 4.5.0)
##    digest        0.6.37     2024-08-19 [1] CRAN (R 4.5.0)
##    ellipsis      0.3.2      2021-04-29 [1] CRAN (R 4.5.0)
##    evaluate      1.0.3      2025-01-10 [1] CRAN (R 4.5.0)
##    fastmap       1.2.0      2024-05-15 [1] CRAN (R 4.5.0)
##    fauxpas       0.5.2      2023-05-03 [1] CRAN (R 4.5.0)
##    fs            1.6.6      2025-04-12 [1] CRAN (R 4.5.0)
##    generics      0.1.3      2022-07-05 [1] CRAN (R 4.5.0)
##    glue          1.8.0      2024-09-30 [1] CRAN (R 4.5.0)
##    hms           1.1.3      2023-03-21 [1] CRAN (R 4.5.0)
##    htmltools     0.5.8.1    2024-04-04 [1] CRAN (R 4.5.0)
##    htmlwidgets   1.6.4      2023-12-06 [1] CRAN (R 4.5.0)
##    httpcode      0.3.0      2020-04-10 [1] CRAN (R 4.5.0)
##    httpuv        1.6.15     2024-03-26 [1] CRAN (R 4.5.0)
##    httr          1.4.7      2023-08-15 [1] CRAN (R 4.5.0)
##    httr2         1.1.2      2025-03-26 [1] CRAN (R 4.5.0)
##    jsonlite    * 2.0.0      2025-03-27 [1] CRAN (R 4.5.0)
##    knitr       * 1.50       2025-03-16 [1] CRAN (R 4.5.0)
##    later         1.4.2      2025-04-08 [1] CRAN (R 4.5.0)
##    lifecycle     1.0.4      2023-11-07 [1] CRAN (R 4.5.0)
##    lubridate     1.9.4      2024-12-08 [1] CRAN (R 4.5.0)
##    magrittr      2.0.3      2022-03-30 [1] CRAN (R 4.5.0)
##    memoise       2.0.1      2021-11-26 [1] CRAN (R 4.5.0)
##    mime          0.13       2025-03-17 [1] CRAN (R 4.5.0)
##    miniUI        0.1.1.1    2018-05-18 [1] CRAN (R 4.5.0)
##  P nasapower   * 4.2.3      2025-04-21 [?] local
##    nvimcom     * 0.9.67     2025-04-12 [1] local
##    openssl       2.3.2      2025-02-03 [1] CRAN (R 4.5.0)
##    pak           0.8.0      2025-02-19 [1] local
##    pillar        1.10.2     2025-04-05 [1] CRAN (R 4.5.0)
##    pkgbuild      1.4.7      2025-03-24 [1] CRAN (R 4.5.0)
##    pkgconfig     2.0.3      2019-09-22 [1] CRAN (R 4.5.0)
##    pkgload       1.4.0      2024-06-28 [1] CRAN (R 4.5.0)
##    profvis       0.4.0      2024-09-20 [1] CRAN (R 4.5.0)
##    promises      1.3.2      2024-11-28 [1] CRAN (R 4.5.0)
##    purrr       * 1.0.4      2025-02-05 [1] CRAN (R 4.5.0)
##    R6            2.6.1      2025-02-15 [1] CRAN (R 4.5.0)
##    rappdirs      0.3.3      2021-01-31 [1] CRAN (R 4.5.0)
##    Rcpp          1.0.14     2025-01-12 [1] CRAN (R 4.5.0)
##    readr         2.1.5      2024-01-10 [1] CRAN (R 4.5.0)
##    remotes       2.5.0      2024-03-17 [1] CRAN (R 4.5.0)
##    rlang         1.1.6      2025-04-11 [1] CRAN (R 4.5.0)
##    roxygen2      7.3.2      2024-06-28 [1] CRAN (R 4.5.0)
##    roxylint      0.1.0      2024-02-19 [1] CRAN (R 4.5.0)
##    rprojroot     2.0.4      2023-11-05 [1] CRAN (R 4.5.0)
##    rstudioapi    0.17.1     2024-10-22 [1] CRAN (R 4.5.0)
##    sessioninfo   1.2.3      2025-02-05 [1] CRAN (R 4.5.0)
##    shiny         1.10.0     2024-12-14 [1] CRAN (R 4.5.0)
##    stringi       1.8.7      2025-03-27 [1] CRAN (R 4.5.0)
##    stringr       1.5.1      2023-11-14 [1] CRAN (R 4.5.0)
##    sys           3.4.3      2024-10-04 [1] CRAN (R 4.5.0)
##    testthat    * 3.2.3      2025-01-13 [1] CRAN (R 4.5.0)
##    tibble        3.2.1      2023-03-20 [1] CRAN (R 4.5.0)
##    timechange    0.3.0      2024-01-18 [1] CRAN (R 4.5.0)
##    triebeard     0.4.1      2023-03-04 [1] CRAN (R 4.5.0)
##    tzdb          0.5.0      2025-03-15 [1] CRAN (R 4.5.0)
##    urlchecker    1.0.1      2021-11-30 [1] CRAN (R 4.5.0)
##    urltools      1.7.3      2019-04-14 [1] CRAN (R 4.5.0)
##    usethis       3.1.0      2024-11-26 [1] CRAN (R 4.5.0)
##    vcr         * 1.7.0      2025-03-10 [1] CRAN (R 4.5.0)
##    vctrs         0.6.5      2023-12-01 [1] CRAN (R 4.5.0)
##    webmockr      2.0.0      2025-02-11 [1] CRAN (R 4.5.0)
##    whisker       0.4.1      2022-12-05 [1] CRAN (R 4.5.0)
##    withr         3.0.2      2024-10-28 [1] CRAN (R 4.5.0)
##    xfun          0.52       2025-04-02 [1] CRAN (R 4.5.0)
##    xml2          1.3.8      2025-03-14 [1] CRAN (R 4.5.0)
##    xtable        1.8-4      2019-04-21 [1] CRAN (R 4.5.0)
##    yaml          2.3.10     2024-07-26 [1] CRAN (R 4.5.0)
##    yyjsonr       0.1.20     2024-04-10 [1] CRAN (R 4.5.0)
## 
##  [1] /Users/adamsparks/Library/R/arm64/4.5/library
##  [2] /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/library
## 
##  * ── Packages attached to the search path.
##  P ── Loaded and on-disk path mismatch.
## 
## ──────────────────────────────────────────────────────────────────────────────
```

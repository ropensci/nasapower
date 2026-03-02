---
title: "Fetch NASA-POWER Parameters and Include Them as an Internal List"
author: "Adam H. Sparks"
date: "2026-03-02"
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
##  version  R version 4.5.2 (2025-10-31)
##  os       macOS Tahoe 26.3
##  system   aarch64, darwin20
##  ui       X11
##  language (EN)
##  collate  en_AU.UTF-8
##  ctype    en_AU.UTF-8
##  tz       Australia/Perth
##  date     2026-03-02
##  pandoc   3.9 @ /opt/homebrew/bin/pandoc
##  quarto   1.8.27 @ /usr/local/bin/quarto
## 
## ─ Packages ───────────────────────────────────────────────────────────────────
##  package          * version date (UTC) lib source
##  askpass            1.2.1   2024-10-04 [1] CRAN (R 4.5.2)
##  base64enc          0.1-6   2026-02-02 [1] CRAN (R 4.5.2)
##  cli                3.6.5   2025-04-23 [1] CRAN (R 4.5.2)
##  credentials        2.0.3   2025-09-12 [1] CRAN (R 4.5.2)
##  curl               7.0.0   2025-08-19 [1] CRAN (R 4.5.2)
##  desc               1.4.3   2023-12-10 [1] CRAN (R 4.5.2)
##  evaluate           1.0.5   2025-08-27 [1] CRAN (R 4.5.2)
##  fs                 1.6.6   2025-04-12 [1] CRAN (R 4.5.2)
##  glue               1.8.0   2024-09-30 [1] CRAN (R 4.5.2)
##  jsonlite         * 2.0.0   2025-03-27 [1] CRAN (R 4.5.2)
##  knitr            * 1.51    2025-12-20 [1] CRAN (R 4.5.2)
##  lifecycle          1.0.5   2026-01-08 [1] CRAN (R 4.5.2)
##  magrittr           2.0.4   2025-09-12 [1] CRAN (R 4.5.2)
##  nvimcom          * 0.9.86  2026-02-15 [1] local
##  openssl            2.3.5   2026-02-26 [1] CRAN (R 4.5.2)
##  otel               0.2.0   2025-08-29 [1] CRAN (R 4.5.2)
##  pillar             1.11.1  2025-09-17 [1] CRAN (R 4.5.2)
##  pkgconfig          2.0.3   2019-09-22 [1] CRAN (R 4.5.2)
##  purrr            * 1.2.1   2026-01-09 [1] CRAN (R 4.5.2)
##  R6                 2.6.1   2025-02-15 [1] CRAN (R 4.5.2)
##  Rcpp               1.1.1   2026-01-10 [1] CRAN (R 4.5.2)
##  rlang              1.1.7   2026-01-09 [1] CRAN (R 4.5.2)
##  rprojroot          2.1.1   2025-08-26 [1] CRAN (R 4.5.2)
##  sessioninfo        1.2.3   2025-02-05 [1] CRAN (R 4.5.2)
##  sys                3.4.3   2024-10-04 [1] CRAN (R 4.5.2)
##  terminalgraphics   0.2.1   2025-11-26 [1] CRAN (R 4.5.2)
##  tibble             3.3.1   2026-01-11 [1] CRAN (R 4.5.2)
##  usethis            3.2.1   2025-09-06 [1] CRAN (R 4.5.2)
##  vctrs              0.7.1   2026-01-23 [1] CRAN (R 4.5.2)
##  xfun               0.56    2026-01-18 [1] CRAN (R 4.5.2)
## 
##  [1] /Users/adamsparks/Library/R/arm64/4.5/library
##  [2] /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/library
##  * ── Packages attached to the search path.
## 
## ──────────────────────────────────────────────────────────────────────────────
```

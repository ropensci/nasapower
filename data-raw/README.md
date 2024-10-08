Fetch NASA-POWER Parameters and Include Them as an Internal List
================
Adam H. Sparks
2024-08-30

# Create parameters nested list for internal checks before sending queries to POWER server

These data are used for internal checks to be sure that data requested
from the POWER dataset are valid. The POWER list of parameters that can
be queried is available as an API query from the POWER server.

The list structure will be

- `parameters`
  - `HOURLY_AG`
    - `parameter_1` …
    - `parameter_n`
  - `DAILY_AG`
    - `parameter_1` …
    - `parameter_n`
  - `MONTHLY_AG`
    - `parameter_1` …
    - `parameter_n`
  - `CLIMATOLOGY_AG`
    - `parameter_1` …
    - `parameter_n`
  - `HOURLY_RE`
    - `parameter_1` …
    - `parameter_n`
  - `DAILY_RE`
    - `parameter_1` …
    - `parameter_n`
  - `MONTHLY_RE`
    - `parameter_1` …
    - `parameter_n`
  - `CLIMATOLOGY_RE`
    - `parameter_1` …
    - `parameter_n`
  - `HOURLY_SB`
    - `parameter_1` …
    - `parameter_n`
  - `DAILY_SB`
    - `parameter_1` …
    - `parameter_n`
  - `MONTHLY_SB`
    - `parameter_1` …
    - `parameter_n`
  - `CLIMATOLOGY_SB`
    - `parameter_1` …
    - `parameter_n` …

and so on.

## POWER JSON file

Using `purrr::map2` and `jsonlite::fromJSON()` read the JSON file into R
creating a single, nested list and reorder it alphabetically by
parameter name.

``` r
library(purrr)
library(jsonlite)
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
                    .f = ~ fromJSON(sprintf(
                    "%stemporal=%s&community=%s", base_url, .x, .y)
                    ))

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

    ## ─ Session info ──────────────────────────────────────
    ##  setting  value
    ##  version  R version 4.4.1 (2024-06-14)
    ##  os       macOS Sonoma 14.6.1
    ##  system   aarch64, darwin20
    ##  ui       X11
    ##  language (EN)
    ##  collate  en_AU.UTF-8
    ##  ctype    en_AU.UTF-8
    ##  tz       Australia/Perth
    ##  date     2024-08-30
    ##  pandoc   3.3 @ /opt/homebrew/bin/ (via rmarkdown)
    ## 
    ## ─ Packages ──────────────────────────────────────────
    ##  package     * version date (UTC) lib source
    ##  askpass       1.2.0   2023-09-03 [1] CRAN (R 4.4.0)
    ##  cli           3.6.3   2024-06-21 [1] CRAN (R 4.4.0)
    ##  colorout      1.3-1   2024-07-14 [1] Github (jalvesaq/colorout@d783015)
    ##  credentials   2.0.1   2023-09-06 [1] CRAN (R 4.4.0)
    ##  desc          1.4.3   2023-12-10 [1] CRAN (R 4.4.0)
    ##  digest        0.6.37  2024-08-19 [1] CRAN (R 4.4.1)
    ##  evaluate      0.24.0  2024-06-10 [1] CRAN (R 4.4.0)
    ##  fansi         1.0.6   2023-12-08 [1] CRAN (R 4.4.0)
    ##  fastmap       1.2.0   2024-05-15 [1] CRAN (R 4.4.0)
    ##  fs            1.6.4   2024-04-25 [1] CRAN (R 4.4.0)
    ##  glue          1.7.0   2024-01-09 [1] CRAN (R 4.4.0)
    ##  htmltools     0.5.8.1 2024-04-04 [1] CRAN (R 4.4.0)
    ##  jsonlite    * 1.8.8   2023-12-04 [1] CRAN (R 4.4.0)
    ##  knitr         1.48    2024-07-07 [1] CRAN (R 4.4.0)
    ##  lifecycle     1.0.4   2023-11-07 [1] CRAN (R 4.4.0)
    ##  magrittr      2.0.3   2022-03-30 [1] CRAN (R 4.4.0)
    ##  openssl       2.2.1   2024-08-16 [1] CRAN (R 4.4.0)
    ##  pillar        1.9.0   2023-03-22 [1] CRAN (R 4.4.0)
    ##  pkgconfig     2.0.3   2019-09-22 [1] CRAN (R 4.4.0)
    ##  purrr       * 1.0.2   2023-08-10 [1] CRAN (R 4.4.0)
    ##  R6            2.5.1   2021-08-19 [1] CRAN (R 4.4.0)
    ##  rlang         1.1.4   2024-06-04 [1] CRAN (R 4.4.0)
    ##  rmarkdown     2.28    2024-08-17 [1] CRAN (R 4.4.0)
    ##  rprojroot     2.0.4   2023-11-05 [1] CRAN (R 4.4.0)
    ##  sessioninfo   1.2.2   2021-12-06 [1] CRAN (R 4.4.0)
    ##  sys           3.4.2   2023-05-23 [1] CRAN (R 4.4.0)
    ##  tibble        3.2.1   2023-03-20 [1] CRAN (R 4.4.0)
    ##  usethis       3.0.0   2024-07-29 [1] CRAN (R 4.4.0)
    ##  utf8          1.2.4   2023-10-22 [1] CRAN (R 4.4.0)
    ##  vctrs         0.6.5   2023-12-01 [1] CRAN (R 4.4.0)
    ##  xfun          0.47    2024-08-17 [1] CRAN (R 4.4.0)
    ##  yaml          2.3.10  2024-07-26 [1] CRAN (R 4.4.0)
    ## 
    ##  [1] /Users/adamsparks/Library/R/arm64/4.4/library
    ##  [2] /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/library
    ## 
    ## ─────────────────────────────────────────────────────

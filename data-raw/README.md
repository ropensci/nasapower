Fetch NASA-POWER Parameters and Include Them as an Internal List
================
Adam H. Sparks
2022-12-11

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
    - `parameter_n`

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

    ## ─ Session info ───────────────────────────────────────────────────────────────
    ##  setting  value
    ##  version  R version 4.2.2 (2022-10-31)
    ##  os       macOS Ventura 13.0.1
    ##  system   aarch64, darwin20
    ##  ui       X11
    ##  language (EN)
    ##  collate  en_US.UTF-8
    ##  ctype    en_US.UTF-8
    ##  tz       Australia/Perth
    ##  date     2022-12-11
    ##  pandoc   2.19.2 @ /opt/homebrew/bin/ (via rmarkdown)
    ## 
    ## ─ Packages ───────────────────────────────────────────────────────────────────
    ##  package     * version date (UTC) lib source
    ##  askpass       1.1     2019-01-13 [1] CRAN (R 4.2.2)
    ##  cli           3.4.1   2022-09-23 [1] CRAN (R 4.2.2)
    ##  crayon        1.5.2   2022-09-29 [1] CRAN (R 4.2.2)
    ##  credentials   1.3.2   2021-11-29 [1] CRAN (R 4.2.2)
    ##  desc          1.4.2   2022-09-08 [1] CRAN (R 4.2.2)
    ##  digest        0.6.30  2022-10-18 [1] CRAN (R 4.2.2)
    ##  evaluate      0.18    2022-11-07 [1] CRAN (R 4.2.2)
    ##  fansi         1.0.3   2022-03-24 [1] CRAN (R 4.2.2)
    ##  fastmap       1.1.0   2021-01-25 [1] CRAN (R 4.2.2)
    ##  fs            1.5.2   2021-12-08 [1] CRAN (R 4.2.2)
    ##  glue          1.6.2   2022-02-24 [1] CRAN (R 4.2.2)
    ##  htmltools     0.5.4   2022-12-07 [1] CRAN (R 4.2.0)
    ##  jsonlite    * 1.8.4   2022-12-06 [1] CRAN (R 4.2.2)
    ##  knitr         1.41    2022-11-18 [1] CRAN (R 4.2.2)
    ##  lifecycle     1.0.3   2022-10-07 [1] CRAN (R 4.2.2)
    ##  magrittr      2.0.3   2022-03-30 [1] CRAN (R 4.2.2)
    ##  openssl       2.0.5   2022-12-06 [1] CRAN (R 4.2.2)
    ##  pillar        1.8.1   2022-08-19 [1] CRAN (R 4.2.2)
    ##  pkgconfig     2.0.3   2019-09-22 [1] CRAN (R 4.2.2)
    ##  purrr       * 0.3.5   2022-10-06 [1] CRAN (R 4.2.2)
    ##  R6            2.5.1   2021-08-19 [1] CRAN (R 4.2.2)
    ##  rlang         1.0.6   2022-09-24 [1] CRAN (R 4.2.2)
    ##  rmarkdown     2.18    2022-11-09 [1] CRAN (R 4.2.2)
    ##  rprojroot     2.0.3   2022-04-02 [1] CRAN (R 4.2.2)
    ##  rstudioapi    0.14    2022-08-22 [1] CRAN (R 4.2.2)
    ##  sessioninfo   1.2.2   2021-12-06 [1] CRAN (R 4.2.2)
    ##  stringi       1.7.8   2022-07-11 [1] CRAN (R 4.2.2)
    ##  stringr       1.5.0   2022-12-02 [1] CRAN (R 4.2.2)
    ##  sys           3.4.1   2022-10-18 [1] CRAN (R 4.2.2)
    ##  tibble        3.1.8   2022-07-22 [1] CRAN (R 4.2.2)
    ##  usethis       2.1.6   2022-05-25 [1] CRAN (R 4.2.2)
    ##  utf8          1.2.2   2021-07-24 [1] CRAN (R 4.2.2)
    ##  vctrs         0.5.1   2022-11-16 [1] CRAN (R 4.2.2)
    ##  xfun          0.35    2022-11-16 [1] CRAN (R 4.2.2)
    ##  yaml          2.3.6   2022-10-18 [1] CRAN (R 4.2.2)
    ## 
    ##  [1] /Users/adamsparks/Library/R/arm64/4.2/library
    ##  [2] /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library
    ## 
    ## ──────────────────────────────────────────────────────────────────────────────

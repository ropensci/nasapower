
# {nasapower}: NASA POWER API Client <img src="man/figures/logo.png" style="float:right;" alt="logo" width="120" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/ropensci/nasapower/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ropensci/nasapower/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/ropensci/nasapower/branch/main/graph/badge.svg?token=Kq9aea0TQN)](https://app.codecov.io/gh/ropensci/nasapower)
[![DOI](https://zenodo.org/badge/109224461.svg)](https://zenodo.org/badge/latestdoi/109224461)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![peer-review](https://badges.ropensci.org/155_status.svg)](https://github.com/ropensci/software-review/issues/155)
[![JOSS](https://joss.theoj.org/papers/10.21105/joss.01035/status.svg)](https://doi.org/10.21105/joss.01035)
[![CRAN
status](https://www.r-pkg.org/badges/version/nasapower)](https://CRAN.R-project.org/package=nasapower)
<!-- badges: end -->

## POWER data vs {nasapower}

Please note that {nasapower} is **NOT** the source of NASA POWER data.
It is only an API client that allows easy access to the data.
{nasapower} does not redistribute the data or provide it in any way, *we
encourage users to follow the requests of the POWER Project Team and
properly acknowledge them for the data rather than citing this package*
(unless you have actually used it in your work).

> *When POWER data products are used in a publication, we request the
> following acknowledgement be included: “The data was obtained from the
> National Aeronautics and Space Administration (NASA) Langley Research
> Center (LaRC) Prediction of Worldwide Energy Resource (POWER) Project
> funded through the NASA Earth Science/Applied Science Program.”*

The previous statement that properly cites the POWER data is different
than the citation for {nasapower}. To cite this R package, {nasapower},
please use the output from `citation(package = "nasapower")` and cite
both the package manual, which includes the version you used and the
paper which refers to the peer-review of the software package as the
functionality of the package has changed and will likely change to match
the API in the future as necessary.

## About {nasapower}

{nasapower} aims to make it quick and easy to automate *downloading* of
the [NASA-POWER](https://power.larc.nasa.gov) global meteorology,
surface solar energy and climatology data in your R session as a tidy
data frame `tibble` object for analysis and use in modelling or other
purposes. POWER (Prediction Of Worldwide Energy Resource) data are
freely available for download with varying spatial resolutions dependent
on the original data and with several temporal resolutions depending on
the POWER parameter and community.

**Note that the data are not static and may be replaced with improved
data.** Please see <https://power.larc.nasa.gov/docs/services/> for
detailed information in this regard.

### Quick start

{nasapower} can easily be installed using the following code.

#### From CRAN

The stable version is available through CRAN.

``` r
install.packages("nasapower")
```

#### From GitHub for the version in-development

A development version is available through GitHub.

``` r
install.packages("nasapower", repos = "https://ropensci.r-universe.dev")
```

### Example

Fetch daily “ag” community temperature, relative humidity and
precipitation for January 1, 1985 for Kingsthorpe, Queensland,
Australia.

``` r
library("nasapower")
daily_ag <- get_power(
  community = "ag",
  lonlat = c(151.81, -27.48),
  pars = c("RH2M", "T2M", "PRECTOTCORR"),
  dates = "1985-01-01",
  temporal_api = "daily"
)
daily_ag
```

    ## NASA/POWER CERES/MERRA2 Native Resolution Daily Data  
    ##  Dates (month/day/year): 01/01/1985 through 01/01/1985  
    ##  Location: Latitude  -27.48   Longitude 151.81  
    ##  Elevation from MERRA-2: Average for 0.5 x 0.625 degree lat/lon region = 442.77 meters 
    ##  The value for missing source data that cannot be computed or is outside of the sources availability range: NA  
    ##  Parameter(s):  
    ##  
    ##  Parameters: 
    ##  RH2M            MERRA-2 Relative Humidity at 2 Meters (%) ;
    ##  T2M             MERRA-2 Temperature at 2 Meters (C) ;
    ##  PRECTOTCORR     MERRA-2 Precipitation Corrected (mm/day)  
    ##  
    ## # A tibble: 1 × 10
    ##     LON   LAT  YEAR    MM    DD   DOY YYYYMMDD    RH2M   T2M PRECTOTCORR
    ##   <dbl> <dbl> <dbl> <int> <int> <int> <date>     <dbl> <dbl>       <dbl>
    ## 1  152. -27.5  1985     1     1     1 1985-01-01  54.7  24.9         0.9

## Documentation

More documentation is available in the vignette in your R session,
`vignette("nasapower")` or available online,
<https://docs.ropensci.org/nasapower/articles/nasapower.html>.

## Meta

- Please note that this package is released with a [Contributor Code of
  Conduct](https://ropensci.org/code-of-conduct/). By contributing to
  this project, you agree to abide by its terms.

- Please [report any issues or
  bugs](https://github.com/ropensci/nasapower/issues).

- License: MIT

## References

<https://power.larc.nasa.gov>

<https://power.larc.nasa.gov/docs/methodology/>


# *nasapower*: NASA POWER API Client <img align='right' src='man/figures/logo.png'>

<!-- badges: start -->

[![tic](https://github.com/ropensci/nasapower/workflows/tic/badge.svg?branch=main)](https://github.com/ropensci/nasapower/actions)
[![codecov](https://codecov.io/gh/ropensci/nasapower/branch/master/graph/badge.svg?token=Kq9aea0TQN)](https://app.codecov.io/gh/ropensci/nasapower)
[![DOI](https://zenodo.org/badge/109224461.svg)](https://zenodo.org/badge/latestdoi/109224461)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![peer-review](https://badges.ropensci.org/155_status.svg)](https://github.com/ropensci/software-review/issues/155)
[![DOI](http://joss.theoj.org/papers/10.21105/joss.01035/status.svg)](https://doi.org/10.21105/joss.01035)
[![CRAN](http://www.r-pkg.org/badges/version/nasapower)](https://CRAN.R-project.org/package=nasapower)

<!-- badges: end -->

*nasapower* aims to make it quick and easy to automate downloading
[NASA-POWER](https://power.larc.nasa.gov) global meteorology, surface
solar energy and climatology data in your R session as a tidy data frame
`tibble` object for analysis and use in modelling or other purposes.
POWER (Prediction Of Worldwide Energy Resource) data are freely
available for download with varying spatial resolutions dependent on the
original data and with several temporal resolutions depending on the
POWER parameter and community.

**Note that the data are not static and may be replaced with improved
data.** Please see <https://power.larc.nasa.gov/docs/services/> for
detailed information in this regard.

### Quick start

*nasapower* can easily be installed using the following code.

#### From CRAN

The stable version is available through CRAN.

``` r
install.packages("nasapower")
```

#### From GitHub for the version in-development

A development version is available through GitHub.

``` r
if (!require("remotes")) {
  install.packages("remotes")
}

remotes::install_github("ropensci/nasapower")
```

### Example

Fetch daily “ag” community temperature, relative humidity and
precipitation for January 1, 1985 for Kingsthorpe, Queensland,
Australia.

``` r
library("nasapower")
daily_ag <- get_power(community = "ag",
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
    ##  Value for missing model data cannot be computed or out of model availability range: NA  
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
<https://docs.ropensci.org/nasapower/>.

## Use of POWER Data

While *nasapower* does not redistribute the data or provide it in any
way, we encourage users to follow the requests of the POWER Project
Team.

> When POWER data products are used in a publication, we request the
> following acknowledgement be included: “These data were obtained from
> the NASA Langley Research Center POWER Project funded through the NASA
> Earth Science Directorate Applied Science Program.”

## Meta

-   Please [report any issues or
    bugs](https://github.com/ropensci/nasapower/issues).

-   License: MIT

-   To cite *nasapower*, please use the output from
    `citation(package = "nasapower")`.

-   Please note that the *nasapower* project is released with a
    [Contributor Code of
    Conduct](https://github.com/ropensci/nasapower/blob/main/CODE_OF_CONDUCT.md).
    By participating in the *nasapower* project you agree to abide by
    its terms.

-   The U.S. Earth System Research Laboratory, Physical Science Division
    of the National Atmospheric & Oceanic Administration (NOAA)
    maintains a list of gridded climate data sets that provide different
    data and different resolutions <https://psl.noaa.gov/data/gridded/>.

## References

<https://power.larc.nasa.gov>

<https://power.larc.nasa.gov/docs/methodology/>

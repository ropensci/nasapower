
<!-- badges: start -->
[![tic](https://github.com/ropensci/nasapower/workflows/tic/badge.svg?branch=master)](https://github.com/ropensci/nasapower/actions)
[![codecov](https://codecov.io/gh/ropensci/nasapower/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/nasapower)
[![DOI](https://zenodo.org/badge/109224461.svg)](https://zenodo.org/badge/latestdoi/109224461)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![peer-review](https://badges.ropensci.org/155_status.svg)](https://github.com/ropensci/software-review/issues/155)
[![DOI](http://joss.theoj.org/papers/10.21105/joss.01035/status.svg)](https://doi.org/10.21105/joss.01035)
[![CRAN](http://www.r-pkg.org/badges/version/nasapower)](https://CRAN.R-project.org/package=nasapower)
<!-- badges: end -->

# _nasapower_: NASA POWER Global Meteorology, Surface Solar Energy and Climatology Data Client <img align="right" src="man/figures/logo.png">

_nasapower_ aims to make it quick and easy to automate downloading [NASA-POWER](https://power.larc.nasa.gov) global meteorology, surface solar energy and climatology data in your R session as a tidy data frame `tibble` object for analysis and use in modelling or other purposes.
POWER (Prediction Of Worldwide Energy Resource) data are freely available for download with a spatial resolution of 0.5 x 0.625 degree latitude and longitude and various temporal resolutions depending on the POWER parameter and community.

Please see <https://power.larc.nasa.gov/> for more on the data and other ways to access it and other forms of data available, _e.g._, your web browser or an ESRI REST API.

### Quick start

_nasapower_ can easily be installed using the following code.

#### From CRAN

The stable version is available through CRAN.

``` r
install.packages("nasapower")
```

#### From GitHub for the version in-development

A development version that may have new features or bug fixes is available through GitHub.

``` r
if (!require(devtools)) {
  install.packages("devtools")
}

devtools::install_github("ropensci/nasapower",
                         build_vignettes = TRUE
)
```

### Example

Fetch daily “AG” community temperature, relative humidity and precipitation for January 1 1985 for Kingsthorpe, Queensland, Australia.

``` r
library(nasapower)
daily_ag <- get_power(community = "AG",
                      lonlat = c(151.81, -27.48),
                      pars = c("RH2M", "T2M", "PRECTOTCORR"),
                      dates = "1985-01-01",
                      temporal_average = "daily"
                      )
```

## Documentation

More documentation is available in the vignette in your R session, `vignette("nasapower")` or available online, <https://docs.ropensci.org/nasapower/>.

## Use of POWER Data

While _nasapower_ does not redistribute the data or provide it in any way, we encourage users to follow the requests of the POWER Project Team.

> When POWER data products are used in a publication, we request the
  following acknowledgement be included: “These data were obtained from
  the NASA Langley Research Center POWER Project funded through the NASA
  Earth Science Directorate Applied Science Program.”

## Meta

  - Please [report any issues or
    bugs](https://github.com/ropensci/nasapower/issues).

  - License: MIT

  - To cite _nasapower_, please use the output from `citation(package = "nasapower")`.

  - Please note that the _nasapower_ project is released with a [Contributor Code of Conduct](https://github.com/ropensci/nasapower/blob/master/CONDUCT.md).
    By participating in the _nasapower_ project you agree to abide by its terms.

  - The U.S. Earth System Research Laboratory, Physical Science Division of the National Atmospheric & Oceanic Administration (NOAA) maintains a list of gridded climate data sets that provide different data and different resolutions <https://psl.noaa.gov/data/gridded/>.

## References

<https://power.larc.nasa.gov>

<https://power.larc.nasa.gov/docs/methodology/>

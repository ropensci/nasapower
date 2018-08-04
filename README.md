
[![Travis-CI Build Status](https://travis-ci.org/adamhsparks/nasapower.svg?branch=master)](https://travis-ci.org/adamhsparks/nasapower)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/adamhsparks/nasapower?branch=master&svg=true)](https://ci.appveyor.com/project/adamhsparks/nasapower)
[![Coverage Status](https://img.shields.io/codecov/c/github/adamhsparks/nasapower/master.svg)](https://codecov.io/github/adamhsparks/nasapower?branch=master)
[![DOI](https://zenodo.org/badge/109224461.svg)](https://zenodo.org/badge/latestdoi/109224461)
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)

# _nasapower_: NASA-POWER Data from R <img align="right" src="man/figures/logo.png">

_nasapower_ aims to make it quick and easy to automate downloading
[NASA-POWER](https://power.larc.nasa.gov) global meteorology and surface solar
energy climatology data  data in your R session as a tidy data frame `tibble`
object for analysis and use in modelling or other purposes. POWER (Prediction Of
Worldwide Energy Resource) data are freely available for download through a web
interface at a resolution of 0.5 arc degree longitude by 0.5 arc degree
latitude. Further functionality is provided to quickly and easily generate an
[APSIM](https://github.com/fainges/R-APSIM) package `metFile` object from POWER
data for use in the
[Agricultural Production Systems sIMulator (APSIM)](http://www.apsim.info/) and
ICASA format text files for use in
[DSSAT (Decision Support System for Agrotechnology Transfer)](https://dssat.net/).

Please see
<https://power.larc.nasa.gov/> for more on the data and other ways to access it
and other forms of data available, _e.g._ an ESRI REST API.

### Quick start

_nasapower_ is not yet available from CRAN, only GitHub. It can easily be
installed using the following code:

```r
if (!require(devtools)) {
  install.packages("devtools")
  library(devtools)
}

devtools::install_github("adamhsparks/nasapower", build_vignettes = TRUE)
```

## Documentation

More documentation is available in the vignette in your R session,
`vignette("nasapower")` or available online,
<https://adamhsparks.github.io/nasapower/articles/nasapower.html>.

## Use of POWER Data

While _nasapower_ does not redistribute the data or provide it in any way, we
encourage users to follow the requests of the POWER Project Team.

> When POWER data products are used in a publication, we request the following
acknowledgment be included: "These data were obtained from the NASA Langley
Research Center POWER Project funded through the NASA Earth Science Directorate
Applied Science Program."

## Meta

* Please [report any issues or bugs](https://github.com/adamhsparks/nasapower/issues).

* License: MIT

* Get citation information for `nasapower` in R by typing
`citation(package = "nasapower")`.

* Please note that this project is released with a
[Contributor Code of Conduct](CONDUCT.md).
By participating in this project you agree to abide by its terms.

* The U.S. Earth System Research Laboratory, Physical Science Division of the
National Atmospheric & Oceanic Administration (NOAA) maintains a list of
gridded climate data sets that provide different data and different resolutions
<https://www.esrl.noaa.gov/psd/data/gridded/>.

## References

<https://power.larc.nasa.gov>

<https://power.larc.nasa.gov/documents/POWER_Data_v8_methodology.pdf>

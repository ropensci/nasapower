# nasapower: NASA-POWER Agroclimatology Data from R

[![Travis-CI Build Status](https://travis-ci.org/adamhsparks/nasapower.svg?branch=master)](https://travis-ci.org/adamhsparks/nasapower)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/adamhsparks/nasapower?branch=master&svg=true)](https://ci.appveyor.com/project/adamhsparks/nasapower)
[![Coverage Status](https://img.shields.io/codecov/c/github/adamhsparks/nasapower/master.svg)](https://codecov.io/github/adamhsparks/nasapower?branch=master)

## Introduction

_nasapower_ aims to make it quick, easy and efficient to automate downloading
NASA-POWER agroclimatology data in your R session as a tidy data frame.

### Quick start

_nasapower_ is not avaiable from CRAN, only GitHub. It can easily be installed
using the following code:

```r
# install.packages("devtools", dep = TRUE)
devtools::install_github("adamhsparks/nasapower")
```

_nasapower_ only provides one function, `get_nasa()`, which will download
specified variables for a given 1˚ longitude by 1˚ latitude cell and return a
tidy data frame of the requested data.

```r
get_nasa(lon = -179.5, lat = 89.5, vars = c("T2M", "T2MN", "T2MX"))
```

Valid `vars` include:

* toa_dwn - Average top-of-atmosphere insolation (MJ/m^2/day)

* swv_dwn - Average insolation incident on a horizontal surface (MJ/m^2/day)

* lwv_dwn - Average downward longwave radiative flux (MJ/m^2/day)

* T2M - Average air temperature at 2m above the surface of the Earth (degrees C)

* T2MN - Minimum air temperature at 2m above the surface of the Earth (degrees C)

* T2MX - Maximum air temperature at 2m above the surface of the Earth (degrees C)

* RH2M - Relative humidity at 2m above the surface of the Earth (%)

* DFP2M - Dew/Frost point temperature at 2m above the surface of the Earth (degrees C)

* RAIN - Average precipitation (mm/day)

* WS10M - Wind speed at 10m above the surface of the Earth (m/s)

## Meta

### References
<https://power.larc.nasa.gov>

<https://power.larc.nasa.gov/documents/Agroclimatology_Methodology.pdf>

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
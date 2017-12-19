---
title: 'nasapower: NASA-POWER Agroclimatology Data from R'
authors:
  - affiliation: 1
    name: Adam H Sparks
    orcid: 0000-0002-0061-8359
output:
  html_document:
    keep_md: yes
bibliography: paper.bib
tags:
- NASA
- weather data
- meteorology
- agroclimatology
- R
- climate data
- earth science
- reproducibility
affiliations:
  index: 1
  name: University of Southern Queensland, Centre for Crop Health, Toowoomba Queensland 4350, Australia
---

# Introduction

NASA’s POWER (Prediction Of Worldwide Energy Resource) data are
freely available for download via a
[web interface](https://power.larc.nasa.gov/cgi-bin/agro.cgi?email=agroclim@larc.nasa.gov)
at a resolution of 1 degree longitude by 1 degree latitude grid. Funded through
the NASA Earth Science Directorate Applied Science Program, the data provide
daily global coverage from 1983 until near present for all parameters except
precipitation, which is provided for January 1997 to near present with a several
month delay. Parameters available for download include: i.) top-of-atmosphere
insolation, ii.) insolation on horizontal surface, iii) downward longwave
radiative flux, iv.) average air temperature at two meters, v.) minimum air
temperature at two meters, vi.) maximum air temperature at two meters, vii.)
relative humidity at two meters, viii.) dew point at two meters, ix.)
precipitation (Jan 1997 to near present with several month delay) and x.) wind
speed at ten meters. The data are widely used in agricultural modelling
[@bai2010evaluation; @vanwart2013; @vanwart2015] for estimating yields, other
crop simulation exercises [@ojeda2017] and plant disease modelling
[@savary2012].

# Using _nasapower_

_nasapower_ [@sparks2017] provides two R [@R-base] functions to automate and
make data retrieval faster, easier and reproducible than using the web
interface. The first, `get_cell()`, downloads NASA-POWER agroclimatology data
for a given one degree latitude by one degree longitude cell for a range of
days and years and specified solar radiation or meteorological parameters,
_e.g._, download all data available for the cell containing Toowoomba,
Queensland, Australia on January 1 2017.

```r
nasa <- get_cell(lonlat = c(-27.5, 151.5), stdate = "2017-1-1",
                 endate = "2017-1-1")
```

The second function, `get_region()`, performs the same task for a region defined
by the four corners, minimum longitude, maximum longitude, minimum latitude, and
maximum latitude and returns the requested values for the one degree cells that
all within that region, _e.g._, download all available data for Australia on
January 1 2017.

```r
 nasa <- get_region(lonlat = c(112.91972, 159.256088, -55.11694, -9.221099),
                    stdate = "2017-1-1", endate = "2017-1-1")
```

Both functions will return the requested data in a tidy data frame
[@wickham2014] with missing values as `NA` rather than "-" that POWER uses to
help users focus on using the data rather than importing and tidying. Extended
documentation is provided with examples of visualising the data using _ggplot2_
[@wickham2009] and converting it to spatial objects using _raster_
[@hijmans2017] and for obtaining solar radiation values for use in APSIM
[@keating2003] and creating a .met file for APSIM modelling purposes.

While _nasapower_ does not redistribute any of the NASA-POWER data, we encourage
users of the data to please refer to the acknowledgement guidelines available
at, <https://power.larc.nasa.gov/common/php/POWER_Acknowledgments.php> and
properly acknowledge the data as requested.

# References

---
title: 'nasapower: NASA-POWER Agroclimatology Data from R'
authors:
  - affiliation: 1
    name: Adam H Sparks
    orcid: 0000-0002-0061-8359
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
date: 2017-12-21
---

# Summary and Statement of Need

_nasapower_ [@sparks2017] is an R [@R-base] package providing functionality to
automate and make NASA-POWER agroclimatology [@stackhouse2017] data retrieval
faster and easier than using the web interface and also reproducible. Two
functions are provided, one to query for and return single cell values, the
other to query and return all cell values in a given region. Both functions
return the requested data in a tidy data frame [@wickham2014] to allow users to
focus on using the data rather than importing and tidying. Integrating this data
retrieval and formatting in R will streamline processes with models such as
APSIM [@keating2003] and EPIRICE [@savary2012] that can be linked to or are
implemented in R. Extended documentation is provided with examples of visualising
the data using _ggplot2_ [@wickham2009], converting it to spatial objects using
_raster_ [@hijmans2017] and for obtaining solar radiation values and generating
a .met file using the _APSIM_ R package [@fainges2017] to use in the APSIM
model.

# About POWER Data

NASA’s POWER (Prediction Of Worldwide Energy Resource) agroclimatology data
[@stackhouse2017] are freely available for download via a
[web interface](https://power.larc.nasa.gov/cgi-bin/agro.cgi?email=agroclim@larc.nasa.gov)
at a grid resolution of one arc degree longitude by one arc degree latitude or
roughly 111 square kilometres. Funded through the NASA Earth Science Directorate
Applied Science Program, the data provide daily global coverage from 1983 until
near present for all parameters except precipitation, which is provided for
January 1997 to near present with a several month delay. Parameters available
for download include: i) top-of-atmosphere insolation, ii) insolation on
horizontal surface, iii) downward longwave radiative flux, iv) average air
temperature at two meters, v) minimum air temperature at two meters, vi) maximum
air temperature at two meters, vii) relative humidity at two meters, viii) dew
point at two meters, ix) precipitation (January 1997 to near present with
several month delay) and x) wind speed at ten meters. The data are widely used
in agricultural modelling for modelling crop yields [@bai2010evaluation;
@vanwart2013; @vanwart2015], other crop simulation exercises [@ojeda2017] and
plant disease modelling [@savary2012].

While _nasapower_ does not redistribute any of the NASA-POWER data, users are
encouraged to please refer to the acknowledgement guidelines available at, <https://power.larc.nasa.gov/common/php/POWER_Acknowledgments.php> and
properly acknowledge the data as requested.

> When POWER data products are used in a publication, we request the following
acknowledgment be included: "_These data were obtained from the NASA Langley
Research Center POWER Project funded through the NASA Earth Science Directorate
Applied Science Program._"

# References

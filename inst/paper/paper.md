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
- climatology
- R
- climate data
- earth science
- reproducibility
affiliations:
  index: 1
  name: University of Southern Queensland, Centre for Crop Health, Toowoomba Queensland 4350, Australia
date: 2018-28-06
---

# Summary and Statement of Need

_nasapower_ [@sparks2018] is an R [@R-base] package providing functionality to
interface with the NASA-POWER API [@stackhouseJr2018] for reproducible data
retrieval using R. A single function, `get_power`, is provided. The function
provides complete access to all functionality that the POWER API provides, which
includes three user communities, AG (agroclimatoloy), SSE (Surface meteorology
and Solar Energy) and SB (Sustainable Buildings); three temporal averages, Daily
Inter-annual and Climatology; three geographic options, single point, regional
and global for the appropriate 141 parameters offered. Data are returned in a
tidy data frame [@wickham2014] as a _tibble_ [@muller2018]. Integrating this
data retrieval and formatting in R will streamline processes with models such as
APSIM [@keating2003overview], DSSAT [@jones1998decision; @jones2003dssat] and
EPIRICE [@savary2012] that can be linked to or are implemented fully in R.
Extended documentation is provided with examples of converting it to spatial
objects using _raster_ [@hijmans2017] and for obtaining solar radiation values
and generating a .met file using the _APSIM_ R package [@fainges2017] to use in
the APSIM model.

# About POWER Data

NASA’s POWER (Prediction Of Worldwide Energy Resource) data [@stackhouseJr2018]
are freely available for download via a
[web interface](https://power.larc.nasa.gov/data-access-viewer/) at a
grid resolution of one-half arc degree longitude by one-half arc degree
latitude. Funded through the NASA Earth Science Directorate Applied Science
Program, the data provide daily global coverage from 1983 until near present for
all parameters except precipitation, which is provided for January 1997 to near
present with a several month delay. The data are widely used in agricultural
modelling for modelling crop yields [@bai2010evaluation; @vanwart2013;
@vanwart2015], other crop simulation exercises [@ojeda2017], plant disease
modelling [@savary2012].

While _nasapower_ does not redistribute any of the NASA-POWER data, users are
encouraged to please refer to the acknowledgement guidelines available at, <https://power.larc.nasa.gov/common/php/POWER_Acknowledgments.php> and
properly acknowledge the data as requested.

> When POWER data products are used in a publication, we request the following
acknowledgment be included: "_These data were obtained from the NASA Langley
Research Center POWER Project funded through the NASA Earth Science Directorate
Applied Science Program._"

# References

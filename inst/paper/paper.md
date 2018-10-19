---
title: 'nasapower: A NASA POWER Global Meteorology, Surface Solar Energy and Climatology Data Client for R'
authors:
  - affiliation: 1
    name: Adam H. Sparks
    orcid: 0000-0002-0061-8359
date: 19 Oct 2018
output: pdf_document
bibliography: paper.bib
tags:
  - NASA
  - weather data
  - solar data
  - climate data
  - meteorology
  - agroclimatology
  - climatology
  - alternative energy
  - sustainable buildings
  - R
  - earth science
  - reproducibility
affiliations:
  - name: University of Southern Queensland, Centre for Crop Health, Toowoomba Queensland 4350, Australia
    index: 1

---

# Summary and Statement of Need

_nasapower_ is an R [@RCT2018] package providing functionality to interface with
the NASA POWER API [@StackhouseJr2018] for reproducible data retrieval using R.
Three functions, `get_power()`, `create_met()` and `create_icasa()` are
provided. The `get_power()` function provides complete access to all
functionality that the POWER API provides, which includes three user
communities, AG (agroclimatology), SSE (Surface meteorology and Solar Energy)
and SB (Sustainable Buildings); three temporal averages, Daily, Interannual and
Climatology; three geographic options, single point, regional and global for the
appropriate parameters offered. _nasapower_ uses _lubridate_ [@Grolemund2011]
internally to format and parse dates which are passed along to the the query
constructed using _crul_ [@Chamberlain2018] to interface with the POWER API. The
query returns a json response, which is parsed by _jsonlite_ [@Ooms2014] to
obtain the url of the .csv file that has been requested. The .csv file is
downloaded to local disk using _curl_ [@Ooms2018] and read into R using _readr_
[@Wickham2017]. Data are returned in a tidy data frame [@Wickham2014] as a
_tibble_ [@Mueller2018] with a custom header, which provides POWER metadata. Two
other functions provide functionality to generate weather input files for
agricultural crop modelling. The `create_met()` function is a wrapper for the
`get_power()` function coupled with the `prepareMet()` and `writeMet()`
functions from _APSIM_ [@Fainges2017] to simplify the process of querying the
data and creating text files in the .met format for use in Agricultural
Production Systems sIMulator (APSIM). While the `create_icasa()` function wraps
the `get_power()` into a function that generates and locally saves a text file
in the International Consortium for Agricultural Systems Applications (ICASA)
format for use in the Decision Support System for Agrotechnology Transfer
(DSSAT) framework [@Jones2003; @Hoogenboom2017]. Extended documentation is
provided with examples of converting it to spatial objects using _raster_
[@Hijmans2017].

Integrating this data retrieval and formatting in R will streamline processes
with models such as APSIM [@Keating2003], DSSAT
[@Jones1998; @Jones2003] and EPIRICE [@Savary2012] that can be
linked to or are implemented fully in the R programming language.

# About POWER Data

NASA’s POWER (Prediction Of Worldwide Energy Resource) data [@StackhouseJr2018]
are freely available for download via a
[web interface](https://power.larc.nasa.gov/data-access-viewer/) at a
grid resolution of one-half arc degree longitude by one-half arc degree
latitude. Funded through the NASA Earth Science Directorate Applied Science
Program, the data provide daily global coverage from 1983 until near present for
all parameters except precipitation, which is provided for January 1997 to near
present with a several month delay. The data are widely used in agricultural
modelling for modelling crop yields [@Bai2010; @vanWart2013;
@vanWart2015], other crop simulation exercises [@Ojeda2017], plant disease
modelling [@Savary2012].

While _nasapower_ does not redistribute any of the NASA POWER data, users are
encouraged to please refer to the acknowledgement guidelines available at,
<https://power.larc.nasa.gov/#contact> and properly acknowledge the data as
requested.

> When POWER data products are used in a publication, we request the following
acknowledgment be included: "_These data were obtained from the NASA Langley
Research Center POWER Project funded through the NASA Earth Science Directorate
Applied Science Program._"

# References

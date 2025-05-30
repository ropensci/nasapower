---
output: github_document
---

# {nasapower}: NASA POWER API Client <img src="man/figures/logo.png" style="float:right;" alt="logo" width="120" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/ropensci/nasapower/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/ropensci/nasapower/actions/workflows/check-standard.yaml)
[![DOI](https://zenodo.org/badge/109224461.svg)](https://zenodo.org/badge/latestdoi/109224461) 
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) 
[![peer-review](https://badges.ropensci.org/155_status.svg)](https://github.com/ropensci/software-review/issues/155) 
[![JOSS](https://joss.theoj.org/papers/10.21105/joss.01035/status.svg)](https://doi.org/10.21105/joss.01035)
[![CRAN status](https://www.r-pkg.org/badges/version/nasapower)](https://CRAN.R-project.org/package=nasapower)
[![codecov](https://codecov.io/gh/ropensci/nasapower/graph/badge.svg?token=Kq9aea0TQN)](https://app.codecov.io/gh/ropensci/nasapower)
<!-- badges: end -->

## POWER data vs {nasapower}

Please note that {nasapower} is **NOT** the source of NASA POWER data.
It is only an API client that allows easy access to the data.
{nasapower} does not redistribute the data or provide it in any way, *we encourage users to follow the requests of the POWER Project Team and properly acknowledge them for the data rather than citing this package* (unless you have actually used it in your work).

  >*When POWER data products are used in a publication, we request the following acknowledgement be included:
   "The data was obtained from the National Aeronautics and Space Administration (NASA) Langley Research Center (LaRC) Prediction of Worldwide Energy Resource (POWER) Project funded through the NASA Earth Science/Applied Science Program."*

The previous statement that properly cites the POWER data is different than the citation for {nasapower}.
To cite this R package, {nasapower}, please use the output from `citation(package = "nasapower")` and cite both the package manual, which includes the version you used and the paper which refers to the peer-review of the software package as the functionality of the package has changed and will likely change to match the API in the future as necessary.

## About {nasapower}

{nasapower} aims to make it quick and easy to automate *downloading* of the [NASA-POWER](https://power.larc.nasa.gov) global meteorology, surface solar energy and climatology data in your R session as a tidy data frame `tibble` object for analysis and use in modelling or other purposes.
POWER (Prediction Of Worldwide Energy Resource) data are freely available for download with varying spatial resolutions dependent on the original data and with several temporal resolutions depending on the POWER parameter and community.

**Note that the data are not static and may be replaced with improved data.**
Please see <https://power.larc.nasa.gov/docs/services/> for detailed information in this regard.

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

Fetch daily “ag” community temperature, relative humidity and precipitation for January 1, 1985 for Kingsthorpe, Queensland, Australia.


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

```
## ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────
```

```
## 
```

```
## ── NASA/POWER Source Native Resolution Daily Data  ────────────────────────────────────────────────────────────────
```

```
## Dates (month/day/year): 01/01/1985 through 01/01/1985 in LST
```

```
## Location: latitude -27.48 longitude 151.81
```

```
## elevation from MERRA-2: Average for 0.5 x 0.625 degree lat/lon region = 442.77 meters
```

```
## The value for missing source data that cannot be computed or is outside of the sources availability range: NA
```

```
## parameter(s):
```

```
## ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────
```

```
## Parameters:
```

```
## RH2M MERRA-2 Relative Humidity at 2 Meters (%) ; T2M MERRA-2 Temperature at 2 Meters (C) ; PRECTOTCORR MERRA-2
## Precipitation Corrected (mm/day)
```

```
## ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────
## # A tibble: 1 × 10
##     LON   LAT  YEAR    MM    DD   DOY YYYYMMDD    RH2M   T2M PRECTOTCORR
##   <dbl> <dbl> <dbl> <int> <int> <int> <date>     <dbl> <dbl>       <dbl>
## 1  152. -27.5  1985     1     1     1 1985-01-01  54.7  24.9         0.9
```

## Documentation

More documentation is available in the vignette in your R session, `vignette("nasapower")` or available online, <https://docs.ropensci.org/nasapower/articles/nasapower.html>.

## Meta

- Please note that this package is released with a [Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). 
By contributing to this project, you agree to abide by its terms.

- Please [report any issues or bugs](https://github.com/ropensci/nasapower/issues).

- License: MIT

### Citing {nasapower}

When citing the use of this package, please use,


``` r
library("nasapower")
citation("nasapower")
```

```
## To cite package 'nasapower' in publications use:
## 
##   Sparks A (2018). "nasapower: A NASA POWER Global Meteorology, Surface Solar Energy and Climatology
##   Data Client for R." _The Journal of Open Source Software_, *3*(30), 1035. doi:10.21105/joss.01035
##   <https://doi.org/10.21105/joss.01035>.
## 
## A BibTeX entry for LaTeX users is
## 
##   @Article{,
##     author = {Adam H. Sparks},
##     title = {nasapower: A NASA POWER Global Meteorology, Surface Solar Energy and Climatology Data Client for R},
##     doi = {10.21105/joss.01035},
##     year = {2018},
##     month = {oct},
##     publisher = {The Open Journal},
##     volume = {3},
##     number = {30},
##     pages = {1035},
##     journal = {The Journal of Open Source Software},
##   }
```

## References

<https://power.larc.nasa.gov>

<https://power.larc.nasa.gov/docs/methodology/>

## Contributors


<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->

All contributions to this project are gratefully acknowledged using the [`allcontributors` package](https://github.com/ropensci/allcontributors) following the [all-contributors](https://allcontributors.org) specification. Contributions of any kind are welcome!

### Code

<table>

<tr>
<td align="center">
<a href="https://github.com/adamhsparks">
<img src="https://avatars.githubusercontent.com/u/3195906?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/commits?author=adamhsparks">adamhsparks</a>
</td>
<td align="center">
<a href="https://github.com/femiguez">
<img src="https://avatars.githubusercontent.com/u/10869358?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/commits?author=femiguez">femiguez</a>
</td>
<td align="center">
<a href="https://github.com/maelle">
<img src="https://avatars.githubusercontent.com/u/8360597?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/commits?author=maelle">maelle</a>
</td>
<td align="center">
<a href="https://github.com/kguidonimartins">
<img src="https://avatars.githubusercontent.com/u/8163542?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/commits?author=kguidonimartins">kguidonimartins</a>
</td>
<td align="center">
<a href="https://github.com/palderman">
<img src="https://avatars.githubusercontent.com/u/2990672?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/commits?author=palderman">palderman</a>
</td>
</tr>

</table>


### Issue Authors

<table>

<tr>
<td align="center">
<a href="https://github.com/emdelponte">
<img src="https://avatars.githubusercontent.com/u/16880798?u=a406d1d934266191c84bc6f67505c77edb131e26&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Aemdelponte">emdelponte</a>
</td>
<td align="center">
<a href="https://github.com/evanmusick">
<img src="https://avatars.githubusercontent.com/u/4440210?u=34fdfe9ae76362b3e6e477579766ef4d8193760c&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Aevanmusick">evanmusick</a>
</td>
<td align="center">
<a href="https://github.com/danielreispereira">
<img src="https://avatars.githubusercontent.com/u/4158858?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Adanielreispereira">danielreispereira</a>
</td>
<td align="center">
<a href="https://github.com/olugovoy">
<img src="https://avatars.githubusercontent.com/u/5607267?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Aolugovoy">olugovoy</a>
</td>
<td align="center">
<a href="https://github.com/mladencucak">
<img src="https://avatars.githubusercontent.com/u/11738104?u=7cef0e4787598c43499c1a4e4c325392240a7139&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Amladencucak">mladencucak</a>
</td>
<td align="center">
<a href="https://github.com/ymutua">
<img src="https://avatars.githubusercontent.com/u/182165?u=892f60e453d746e68527a6a0f1d93875853d37f9&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Aymutua">ymutua</a>
</td>
<td align="center">
<a href="https://github.com/marcoslana1">
<img src="https://avatars.githubusercontent.com/u/56367310?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Amarcoslana1">marcoslana1</a>
</td>
</tr>


<tr>
<td align="center">
<a href="https://github.com/AboodaA">
<img src="https://avatars.githubusercontent.com/u/7856227?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3AAboodaA">AboodaA</a>
</td>
<td align="center">
<a href="https://github.com/victofs">
<img src="https://avatars.githubusercontent.com/u/45796840?u=5740271f2b2b1192b3fbe002ed0106def265fead&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Avictofs">victofs</a>
</td>
<td align="center">
<a href="https://github.com/andvar95">
<img src="https://avatars.githubusercontent.com/u/34283249?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Aandvar95">andvar95</a>
</td>
<td align="center">
<a href="https://github.com/Bradley-Macpherson-NASA">
<img src="https://avatars.githubusercontent.com/u/64919787?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3ABradley-Macpherson-NASA">Bradley-Macpherson-NASA</a>
</td>
<td align="center">
<a href="https://github.com/a4sberg">
<img src="https://avatars.githubusercontent.com/u/62616339?u=503cb016033213be4c0f1e26323127ef8ae58759&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Aa4sberg">a4sberg</a>
</td>
<td align="center">
<a href="https://github.com/leichx">
<img src="https://avatars.githubusercontent.com/u/10319655?u=9816bec5b8ff988150dea82f572b10fad99c45ab&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Aleichx">leichx</a>
</td>
<td align="center">
<a href="https://github.com/Yonaba">
<img src="https://avatars.githubusercontent.com/u/884058?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3AYonaba">Yonaba</a>
</td>
</tr>


<tr>
<td align="center">
<a href="https://github.com/kauedesousa">
<img src="https://avatars.githubusercontent.com/u/29840771?u=87ae78a7053c64125e0570d013755d4b16f103ca&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Akauedesousa">kauedesousa</a>
</td>
<td align="center">
<a href="https://github.com/camwur">
<img src="https://avatars.githubusercontent.com/u/89774766?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Acamwur">camwur</a>
</td>
<td align="center">
<a href="https://github.com/agronomofiorentini">
<img src="https://avatars.githubusercontent.com/u/66969646?u=88ac4cadcb9003d64d05a3dbd5abd3c39e13de81&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Aagronomofiorentini">agronomofiorentini</a>
</td>
<td align="center">
<a href="https://github.com/Varsha-Ujjinni-VijayKumar">
<img src="https://avatars.githubusercontent.com/u/62937040?u=255cf0dd07a865b060596c6154aef84c006fc43a&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3AVarsha-Ujjinni-VijayKumar">Varsha-Ujjinni-VijayKumar</a>
</td>
<td align="center">
<a href="https://github.com/agryji08">
<img src="https://avatars.githubusercontent.com/u/49504482?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Aagryji08">agryji08</a>
</td>
<td align="center">
<a href="https://github.com/mps9506">
<img src="https://avatars.githubusercontent.com/u/11282246?u=afe5bf9772b5b2d57307783e5f9b58a2b6f2017a&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Amps9506">mps9506</a>
</td>
<td align="center">
<a href="https://github.com/daniel-althoff">
<img src="https://avatars.githubusercontent.com/u/36540557?u=6f191e4a4d342242e330350c09f048e7e2912305&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Adaniel-althoff">daniel-althoff</a>
</td>
</tr>


<tr>
<td align="center">
<a href="https://github.com/egbendito">
<img src="https://avatars.githubusercontent.com/u/52239752?u=74a9056d89ee9eba4109fa6f8a9d06543af0b205&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Aegbendito">egbendito</a>
</td>
<td align="center">
<a href="https://github.com/makorb">
<img src="https://avatars.githubusercontent.com/u/91082324?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Amakorb">makorb</a>
</td>
<td align="center">
<a href="https://github.com/saulo1305">
<img src="https://avatars.githubusercontent.com/u/41703024?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Asaulo1305">saulo1305</a>
</td>
<td align="center">
<a href="https://github.com/emmalink1">
<img src="https://avatars.githubusercontent.com/u/46287320?u=639e820366b81de7d058cb794c2a4404d7ea8190&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3Aemmalink1">emmalink1</a>
</td>
<td align="center">
<a href="https://github.com/Gonzalo1985">
<img src="https://avatars.githubusercontent.com/u/7884005?u=d6918d5161f0143d9b2d2a5ec379520c10d82dd8&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+author%3AGonzalo1985">Gonzalo1985</a>
</td>
</tr>

</table>


### Issue Contributors

<table>

<tr>
<td align="center">
<a href="https://github.com/andresouzaesilva">
<img src="https://avatars.githubusercontent.com/u/32813659?u=177ac2a828f313055d02c3e01c4f9ee1a737cad1&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+commenter%3Aandresouzaesilva">andresouzaesilva</a>
</td>
<td align="center">
<a href="https://github.com/xianranli">
<img src="https://avatars.githubusercontent.com/u/33258053?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+commenter%3Axianranli">xianranli</a>
</td>
<td align="center">
<a href="https://github.com/jizarten">
<img src="https://avatars.githubusercontent.com/u/37815915?u=e9b8254bec4d6ce04e510d1302b21124070bfc70&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+commenter%3Ajizarten">jizarten</a>
</td>
<td align="center">
<a href="https://github.com/fe-neculqueo">
<img src="https://avatars.githubusercontent.com/u/49450859?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+commenter%3Afe-neculqueo">fe-neculqueo</a>
</td>
<td align="center">
<a href="https://github.com/LucasJorgeAbdala">
<img src="https://avatars.githubusercontent.com/u/67706494?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+commenter%3ALucasJorgeAbdala">LucasJorgeAbdala</a>
</td>
<td align="center">
<a href="https://github.com/olicoste">
<img src="https://avatars.githubusercontent.com/u/80519625?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/nasapower/issues?q=is%3Aissue+commenter%3Aolicoste">olicoste</a>
</td>
</tr>

</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->


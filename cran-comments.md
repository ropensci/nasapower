# nasapower v2.0.0

## Test environments
* local macOS, R 4.0.2
* win-builder, R Under development (unstable) (2020-09-17 r79226)
* win-builder, R 4.0.2

## R CMD check results

0 errors | 0 warnings | 1 note

This is a major version release

## Bug Fixes

* Correct any missing or redirecting URLs

* Replace deprecated `subclass` with `class` in `new_tibble()`

## Major Changes to Functionality

* Following a UNIX-like philosophy, this release removes functionality to write APSIM .met and DSSAT ICASA files to disk.
_nasapower_ now will only fetch the appropriate data and return a `tibble()` object in-session, please use [apsimx](https://cran.r-project.org/package=apsimx) or the POWER web API data access viewer, <https://power.larc.nasa.gov/data-access-viewer/>, for fetching and/or writing .met or .icasa files, respectively.
Note that  `create_icasa()` ideally should have been deprecated, but the server was not responding properly when queried for some time before the current release of _nasapower_ so the function has been removed.

* Add ability to `get_power()` to accept a user-provided `site_elevation` parameter that is passed to the API.
When this is used it will return a corrected atmospheric pressure value adjusted to the elevation provided.

## Minor and Internal Changes

* Use newest values from POWER team to validate user inputs for API requests, see <https://github.com/ropensci/nasapower/issues/48> for more.

* Replace _raster_ with _terra_ for examples of converting to spatial data in vignettes

* Use _vcr_ for enhanced testing

* Refactor the internal handling of temporary files to allow for more efficient use of the _future_ package


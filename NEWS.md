
# nasapower 0.1.2.9000

### Bug fixes

- Fix bug where lon/lat values were improperly assigned internally due to row
names not being ordered correctly in `get_region()`

- Fix bug reports link in DESCRIPTION file

- Correct vignette where it had said, "both of which will which will download

- Correct documentation for `get_region()`, which incorrectly stated that it
downloaded data for a 1 x 1 degree cell

### Minor improvements

- Optimise arguments used in `read.table` to ingest weather data in the
`get_cell()` and `get_region()` functions more quickly

- NEWS now formatted more nicely for easier reading

- Add statement about possible performance and memory usage when using
`get_region()` in the vignette

- Add an example of converting the data frame to a spatial object using
_raster_

- Specify in documentation that a range of days to years can be specified for
download

## Minor changes

- `get_region()` and `get_cell()` now default to download all weather vars

- Add a check to see if POWER website is responding before making request for
data. If not, stop and return error message to user.

- Add new use case vignette for APSIM modelling work,
https://adamhsparks.github.io/nasapower/articles/use-case.html

--------------------------------------------------------------------------------

# nasapower 0.1.2 (2017-11-06)

### Bug fixes

- Fixes bug where only first date is reported when using `get_region()` with
multiple dates. https://github.com/adamhsparks/nasapower/issues/1

### Minor improvements

- Enhanced documentation

- Superflous function, `.onLoad()`, removed from zzz.R

- Tidied up startup message

- Clean up vignette

- Build vignette faster

- Remove DATE from DESCRIPTION

--------------------------------------------------------------------------------

# nasapower 0.1.1 (2017-11-04)

### Minor improvements

- Fix issues in documentation, typos, incorrect links, etc.

--------------------------------------------------------------------------------

# nasapower 0.1.0 (2017-11-04)

### New features

* Add new functionality to download regions in addition to single cells

* Add static documentation website, <https://adamhsparks.github.io/nasapower/>

* Add startup message

### Minor improvements

* Better documentation

--------------------------------------------------------------------------------

# nasapower 0.0.2  (2017-11-02)

### New features

* Added citation file

--------------------------------------------------------------------------------

# nasapower 0.0.1 (2017-11-02)

* Added a `NEWS.md` file to track changes to the package.

* First release, no changes to report yet

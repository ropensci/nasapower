# nasapower 4.2.5

## Bug fixes

- Fixes bug where `get_power()` printed encoding messages

# nasapower 4.2.4

## Bug fixes

- Fixes bug where `pars` that are not valid returned a cryptic error message as
  seen here, <https://stackoverflow.com/questions/78416035/issue-with-nasapower-r-library>

# nasapower 4.2.3

## Minor changes

- Ensure that only one parameter can be passed to a regional request due to undocumented changes in the POWER API.

# nasapower 4.2.2

## Bug fixes

- [Ensure that `wind_elevation` must be a numeric value](https://github.com/ropensci/nasapower/commit/bc61b8e7474e2513a2002d50911d26d69ac6c7ea).

## Minor changes

- [Fix typo](https://github.com/ropensci/nasapower/pull/92) thanks, @kguidonimartins!

- [Fix another typo](https://github.com/ropensci/nasapower/commit/bfc53022b3b0acd89377e3bfaaf92dba4ba6ac6f) in documentation.

- [Clarify error message](https://github.com/ropensci/nasapower/commit/8e91a612d4720a297948be4f1c302b221f6f1c2b).

- [Add contributors to README](https://github.com/ropensci/nasapower/commit/293e030dc10d76dbbd3d8f43770225c41b2bf21f)

- Code and Roxygen linting.

# nasapower 4.2.1

## Bug Fixes

- Fixes [Issue](https://github.com/ropensci/nasapower/issues/85) where querying all parameters failed.

# nasapower 4.2.0

## Minor Changes

- Two new functions are added:

  - `query_surfaces()`: Query the POWER API for Detailed Information on Wind Type Surfaces
  - `query_groupings()`: Query the POWER API for Detailed Information on Available Parameter Groupings

- `query_parameters` now allows you to retrieve rich metadata for the parameters.

- Error, warning and other informational messages are now all formatted with {cli} for more attractive and informative messages.

- The username passed along to the POWER API is now "nasapower4r" to support other packages built on {nasapower} that could use {vcr} in tests.
  Previously the user agent string took the version of {nasapower} and appended it, _e.g._, "nasapower410" for v4.1.0.
  Doing so breaks tests in packages relying on {nasapower} due to incompatibilities in cassettes, while not affecting functionality.

## Bug fixes

- Fixes a bug that allowed users to send requests to the API for hourly data over a region.
  The API does not support this and this client now provides a user-friendly error when it is attempted.

# nasapower 4.1.0

## Bug fixes

- Fix formula in documentation that didn't display properly in HTML.

- Fix non-functional link in documentation.

- Fix code coverage badging.

## Minor changes

- Use {cli} and {rlang} for clear messages for end users.

- Use argument matching for function arguments where practical.

- The `temporal_api` argument of `get_power()` now defaults to "daily", previously it had no default value.

- The `temporal_average` argument for `get_power()` has now been removed after being deprecated and issuing a message to users to use `temporal_api` instead since release 4.0.0.

# nasapower 4.0.11

## Bug fixes

- Replaces `&` or `|` with the proper `&&` or `||`.

- Corrects documentation titles for functions to be title case.

- Fixes the CRAN badge in the README.

- Updates {vcr} configuration files for testing.

## Minor changes

- Reorder README to stress that this is not the data source and should not be cited as such.

- Tidy up minor bits-n-pieces in documentation to make it nicer, _e.g._, grammar corrections, using `\dQuote{}` rather than """ in ROxygen.

- Uses `sprintf()` rather than `paste()` where possible.

- Update {vcr} configuration and infrastructure to use .json cassettes.

# nasapower 4.0.10

- Update CITATION file to follow CRAN's ~ever-changing whims~ guidelines.

# nasapower 4.0.9

- Remove an example that no longer works with the API.

- Remove incorrect documentation about rate limiting and include details on how to use rate limiting.

- Ensure tests are skipped on CRAN, thanks Maëlle!

- Use `skip_if_offline()` rather than `skip_on_cran()` for tests.

# nasapower 4.0.8

- Redoc package to align with CRAN policies on well-formed HTML.

- Update list of allowed parameters for querying the API, ([18e4495e0ca2e9f14006260c019ac878a3023843](https://github.com/ropensci/nasapower/commit/9ed90e0708a32650992795b818e1681e7150a0d9)).

- Updated test infrastructure.

# nasapower 4.0.7

- Adds new `time_standard` parameter to `get_power()` as requested in [##70](https://github.com/ropensci/nasapower/issues/70).

- Updates internal list of accepted POWER parameters.

# nasapower 4.0.6

## Bug fixes

- Fixes bug when requesting `site_elevation`.
  Thanks to @daniel_althoff for reporting this bug [Issue 69](https://github.com/ropensci/nasapower/issues/69).

- Fixes bug where `wind_elevation` and `wind_surface` were not properly passed along to the API.

## Minor changes

- Fixes redundant and broken tests by removing or updating new tests.

# nasapower 4.0.5

- Fixes bug when requesting `site_elevation` corrected data.
  Thanks to @daniel_althoff for reporting this bug [Issue 69](https://github.com/ropensci/nasapower/issues/69).

# nasapower 4.0.4

## Bug fixes

- Fixes message when importing data using _vroom_ >= 1.5.0, `The`file`argument of`vroom()`must use`I()`for literal data as of vroom 1.5.0.`. Thanks to @palderman for the fix in [Pull Request 67](https://github.com/ropensci/nasapower/pull/67).

## Minor changes

- Sets minimum version of _tibble_ necessary for use with _nasapower_.

# nasapower 4.0.3

- Fixes tests that should use _vcr_ or be skipped on CRAN.

# nasapower 4.0.2

- Update checks for number of parameters requested by user, maximum of 15 for hourly and 20 for all other temporal APIs.

- Return API messages to user to assist with troubleshooting when an error occurs server-side, see [Issue 55](https://github.com/ropensci/nasapower/issues/55).

- The list of POWER parameters that can be queried from the API, `parameters`, is now in alphabetical order.

- Add paragraph to vignette describing how to work with possible rate limiting by API endpoints using _ratelimitr_.
  This is in place of internally rate-limiting due to the way _ratelimitr_ handles function creation and the fact that the rate limits are extremely generous and may change as the project matures.

# nasapower 4.0.1 (unreleased on CRAN)

## Bug fixes

- Fixes a bug in where `NA` values were improperly handled.
  Thanks to [@femiguez](https://github.com/femiguez) for the [Pull Request with the fix](https://github.com/ropensci/nasapower/pull/56).

## Minor changes

- Enforces API limits client-side where the API limits unique queries to 30 per 60 seconds as found and reported by [@camwur](https://github.com/camwur) in [Issue 57](https://github.com/ropensci/nasapower/issues/57).
  This can be adjusted in future releases of _nasapower_ if the POWER API changes as has been indicated is possible.

- (Re)enables _vcr_ for better unit testing.

- More comprehensive unit tests.

# nasapower 4.0.0

## Major changes

- Adds support for new NASA POWER API v2.0, which includes new hourly data and other major changes to the API and available data.
  See <https://power.larc.nasa.gov/> for fully detailed changes to the data.

- Drops support for the deprecated NASA POWER API V1.0.
  Previous versions of _nasapower_ are no longer functional.

- Adds new function, `query_parameters()` to fetch information from the API on individual and all available community/temporal API combination parameters.

- Removes `SSE` community, replaced with `RE`.

- Removes `global` option for geographic coverage as passed along through the `latlon` argument of `get_power()`.

- Directly parse data from API response rather than downloading data to disk and importing.

- The `get_power()` arguments are changed:
  - two new arguments are added,
    - `wind_elevation`, and
    - `wind_surface`,
  - the `temporal_average` argument has been superseded by `temporal_api` to align with the terminology used in the POWER API.
    The `temporal_average` argument will still work, however, a message will be given if a user still uses `temporal_average` to alert the user of the change and ask them to update their scripts.

## Minor changes

- Improved documentation.

- Removes internal references to ICASA format files that are no longer supported in this client.

# nasapower 3.0.1

## Bug fixes

- Fix bug where Solar Radiation, "ALLSKY_SFC_SW_DWN", and perhaps others that were missed, return a numeric `-99.00` value rather than the proper `NA` for missing data.
  Thanks to Fernando Miguez, <https://github.com/femiguez>, for the assistance in isolating the issue.

# nasapower 3.0.0

## Major Changes to Functionality

- Due to the removal of the CRAN package _APSIM_ from CRAN, the removal of the `create_met()` function has been implemented sooner than expected to keep _nasapower_ on CRAN.

- Deprecates `create_met()`

## Bug fixes

- Properly deprecates `create_icasa()`

# nasapower 2.0.0

## Bug Fixes

- Correct any missing or redirecting URLs

- Replace deprecated `subclass` with `class` in `new_tibble()`

## Major Changes to Functionality

- Following a UNIX-like philosophy, this release removes functionality to write APSIM .met and DSSAT ICASA files to disk.
  _nasapower_ now will only fetch the appropriate data and return a `tibble()` object in-session, please use [apsimx](https://cran.r-project.org/package=apsimx) or the POWER web API data access viewer, <https://power.larc.nasa.gov/data-access-viewer/>, for fetching and/or writing .met or .icasa files, respectively.
  Note that `create_icasa()` ideally should have been deprecated, but the server was not responding properly when queried for some time before the current release of _nasapower_ so the function has been removed.

- Add ability to `get_power()` to accept a user-provided `site_elevation` parameter that is passed to the API.
  When this is used it will return a corrected atmospheric pressure value adjusted to the elevation provided.

## Minor and Internal Changes

- Use newest values from POWER team to validate user inputs for API requests, see <https://github.com/ropensci/nasapower/issues/48> for more.

- Replace _raster_ with _terra_ for examples of converting to spatial data in vignettes

- Use _vcr_ for enhanced testing

- Refactor the internal handling of temporary files to allow for more efficient use of the _future_ package

# nasapower 1.1.3

## Bug Fixes

- Corrects bug when querying the SB or SSE communities resulting in an error

- Corrects example in vignette when creating a .met file

## Minor Changes

- Update documentation to use ROxygen 7.0.0

- Add new vignette, "Using nasapower with large geographic areas"

# nasapower 1.1.2

## Minor changes

- Correct URL in BibTeX version of citation

- Suppress output in console from `APSIM::createMetFile()`

- Help file titles are now in sentence case

# nasapower 1.1.1

## Bug fixes

- Fix issues reported in CRAN checks with failing tests.
  These tests should be skipped on CRAN but were not.

- Fixes bug where missing values in POWER data were not properly replaced with `NA` in `tibble` and metFile outputs

- Fixes bug in documentation for `create_icasa()` where the parameter for `file_out` was misidentified as just `file`

## Minor changes

- Users are now notified if creating a .met file that has any missing values through a console message and .csv file being written to disk to accompany the resulting .met file describing which values are missing

# nasapower 1.1.0

## Bug fixes

- Fixes bug where .met files were not created properly including where "radn" and "rain" col headers were reversed

- Fix `Warning: Must pass a scalar integer as 'nrow' argument to 'new_tibble()'.`

- Fixes bug where "CLIMATE" could not be requested for a single point

## Major changes

- Change how `GLOBAL` values are requested. This is now specified in `lonlat` in conjunction with `temporal_average = CLIMATOLOGY`.

## Minor changes

- Adds example of fetching climate for a single point

- Refactor code to split internal functions by functionality and add more complete test coverage

# nasapower 1.0.7

## Minor changes

- Removes internal check for data - community agreement, as all data is available for all communities, only the units change

- Update links to latest documentation provided by the POWER team

# nasapower 1.0.6

## Minor changes

- Adds support for WS2M_MIN, WS2M_MAX and WS2M_RANGE in AG community

## Bug fixes

- Fixes bug where previous release did not support WS2M from AG community due to a local typo

# nasapower 1.0.5

## Minor changes

- "Fixes" [Issue 32](https://github.com/ropensci/nasapower/issues/32) where WS2M is not available through `nasapower` until the POWER team can properly address how pre-query validation should be performed

# nasapower 1.0.4

## Minor changes

- Corrects an instance where vignette example executed on CRAN but should not

- Adds link to POWER website in error message when query fails

- Documentation .Rd files are now more readable with better formatting

# nasapower 1.0.3

## Minor changes

- Adds citation information for JOSS paper, <https://joss.theoj.org/papers/10.21105/joss.01035>

## Documentation changes

- Flesh out examples using `naspower` data with `raster` to create spatial objects for systems with low-RAM where the functionality may not work as expected

- Standardise formatting of vignette subheadings

- Spell check vignette

## Bug fixes

- Fixes tests to not run on CRAN so that errors aren't reported when API is unavailable

# nasapower 1.0.2

## Minor changes

- Updates documentation examples

- Provides nicer method of printing data in R console

- Updates tests for better coverage and removes non-functional tests

- Removes `dplyr` as an Import

## Bug fixes

- Corrects issue where `if()` was called with a vector of length 2 or more

- Corrects logical operators `&&` and `||` where they should be `&` or `|`

- Removes extra code in `create_icasa()` and `create_met()` that performed a duplicated check of `latlon` values

- Removes unnecessary checks for `latlon` in `get_power()`

# nasapower 1.0.1

## Minor changes

- Provides corrections to documentation formatting as per CRAN volunteers' requests

- Provides edits and clarifications in DESCRIPTION's Description and Title about the package's uses and capabilities

# nasapower 1.0.0 (unreleased)

## Major changes

- _nasapower_ is now a part of [rOpenSci](https://ropensci.org/) after [peer-review of the code](https://github.com/ropensci/software-review/issues/155)!

- Provides access to all three communities, AG, SSE and and SB, not just AG

- Uses new 'POWER' 'API' to download new 1/2 x 1/2 degree data

- Adds function `get_power()` to get weather data and optionally metadata as well

- Adds function `create_met()` to create 'APSIM' met objects from 'POWER' data

- Adds function `create_icasa()` to create a text file of weather data for use in 'DSSAT' crop modelling

- Internally, replaces _httr_ package with _crul_

## Deprecated functions

- The `get_cell` and `get_region` functions are deprecated in favour of `get_power()`.
  The new POWER interface allows for the specification of single points or regional areas.
  Global coverage may be queried for Climatology.
  See the help for `?get_power()` for more details.

# nasapower 0.1.4

## Bug Fixes

- Fixes bug related to date columns where `MONTH`, `DAY` and `YYYY-MM-DD` were incorrectly reported in final data frame. This did not affect the weather data, `YEAR` or `DOY` columns.

# nasapower 0.1.3

## Bug fixes

- Fix bug where lon/lat values were improperly assigned internally due to row names not being ordered correctly in `get_region()`

- Fix bug reports link in DESCRIPTION file

- Correct vignette where it had said, "both of which will which will download"

- Correct documentation for `get_region()`, which incorrectly stated that it downloaded data for a 1 x 1 degree cell

### Minor improvements

- Optimise arguments used in `utils::read.table()` to ingest weather data in the `get_cell()` and `get_region()` functions more quickly

- NEWS now formatted more nicely for easier reading

- Add statement about possible performance and memory usage when using
  `get_region()` in the vignette

- Add an example of converting the data frame to a spatial object using
  _raster_ to create a `raster::brick()`

- Specify in documentation that a range of days to years can be specified for download

## Minor changes

- `get_region()` and `get_cell()` now default to download all weather vars

- Add a check to see if POWER website is responding before making request for data. If not, stop and return error message to user.

# nasapower 0.1.2

## Bug fixes

- Fixes bug where only first date is reported when using `get_region()` with multiple dates. <https://github.com/ropensci/nasapower/issues/1>

### Minor improvements

- Enhanced documentation

- Superfluous function, `.onLoad()`, removed from zzz.R

- Tidied up startup message

- Clean up vignette

- Build vignette faster

- Remove DATE from DESCRIPTION

# nasapower 0.1.1

### Minor improvements

- Fix issues in documentation, typos, incorrect links, etc.

# nasapower 0.1.0

## New features

- Add new functionality to download regions in addition to single cells

- Add static documentation website, <https://docs.ropensci.org/nasapower/>

- Add startup message

### Minor improvements

- Better documentation

# nasapower 0.0.2

## New features

- Added citation file

# nasapower 0.0.1

- Added a `NEWS.md` file to track changes to the package.

- First release, no changes to report yet

# nasapower v1.1.1

## Test environments
* local macOS 10.14.4 install, R 3.5.3
* local Ubuntu 18.04, R 3.6.0
* Circle-CI Rocker/geospatial Debian:9, R 3.5.3
* win-builder (devel, release and oldrel)
## R CMD check results

0 errors | 0 warnings | 1 note

This is a minor release mainly for bug fixes but also including new functionality
based on feedback from v1.1.0.

# Bug fixes

- Fixes bug where missing values in POWER data were not properly replaced with
`NA` in `tibble` output

- Fixes bug in documentation for `create_icasa()` where the parameter for
`file_out` was misidentified as just `file`

## Minor changes

- Users are now notified if creating a .met file that has any missing values
through a console message and .csv file being written to disk to accompany the
resulting .met file describing which values are missing

## Reverse dependencies

There are currently no reverse dependencies.

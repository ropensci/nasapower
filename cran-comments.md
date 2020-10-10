# nasapower v2.0.0

## Test environments
* local macOS, R 4.0.2
* win-builder, R Under development (unstable) (2020-10-09 r79316)
* win-builder, R 4.0.2

## R CMD check results

0 errors | 0 warnings | 1 note

This is a new major release

## Major changes to functionality

* Due to the removal of the CRAN package _APSIM_ from CRAN, the removal of the `create_met()` function has been implemented sooner than expected to keep _nasapower_ on CRAN

* Deprecates `create_icasa()`

## Bug fixes

* Properly deprecates `create_icasa()`

## Reverse dependencies

No ERRORs or WARNINGs found

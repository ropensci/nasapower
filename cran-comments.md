## Test environments
* local macOS 10.13.6 install, R 3.5.1
* local Ubuntu 18.04, R 3.5.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new patch release at the request of CRAN maintainers, changes
follow.

  ## Requested changes
  
    * Corrects issue where `if()` was called with a vector of length 2 or more

  ## Bug fixes
  
    * Corrects logical operators `&&` and `||` where they should be `&` or `|`

    * Removes extra code in `create_icasa()` and `create_met()` that peformed
    a duplicated check of `latlon` values

    * Removes unnecessary checks for `latlon` in `get_power()`
  
  ## Minor changes
  
    * Updates documentation examples

    * Provides nicer method of printing data in R console

    * Updates tests for better coverage and removes non-functional tests

    * Removes `dplyr` as an Import

## Reverse dependencies

There are currently no reverse dependencies.

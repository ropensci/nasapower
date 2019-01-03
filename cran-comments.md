## Test environments
* local macOS 10.14.2 install, R 3.5.2
* local Ubuntu 18.04, R 3.5.2
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

This is a new patch release at the request of CRAN maintainers, changes
follow.

  ## Requested changes
  
    * Fixes tests to not run on CRAN so that errors aren't reported when API is unavailable. Especially due to the unreliability of the NASA server
  
  ## Bug fixes

    * Fixes bug with the data frame class returned by `nasapower` that could result in known issues when creating `raster` objects

## Documentation changes

    * Flesh out examples using `naspower` data with `raster` to create spatial objects for systems with low-RAM where the functionality may not work as expected
  
    * Standardise formatting of vignette subheadings

    * Spellcheck vignette

  
  ## Minor changes
  
    * Adds citation information for JOSS paper, http://joss.theoj.org/papers/10.21105/joss.01035

    * Remove `vcr` from Suggests and Test Cases

## Reverse dependencies

There are currently no reverse dependencies.

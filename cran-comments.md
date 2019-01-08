# nasapower v1.0.4

## Test environments
* local macOS 10.14.2 install, R 3.5.2
* local Ubuntu 18.04, R 3.5.2
* win-builder (devel, release and oldrel)

## R CMD check results

0 errors | 0 warnings | 1 note

This is a the second new patch release at the request of CRAN maintainers,
changes follow.

With the US government partial shut down the POWER API is officially offline.
It is unclear how long this will last. I've done my best to address CRAN's
comments without full functionality of the API.

  ## Bug fixes
  
    * Does not run any test on CRAN which requires `vcr`. This will fix the
    issue with `vcr` not available on r-oldrel-osx-x86_64. It should also fix
    all other ERRORs related to the API not being available being reported:
    <https://cran.r-project.org/web/checks/check_results_nasapower.html> since
    it's not tested on CRAN, it will pass all tests.
    
    * Any examples in the vignette will no longer be evaluated on CRAN. The
    previous (rejected) submission had one code chunk that was still incorrectly
    evaluated and the API failed leading to an error. No code chunks are
    evaulated on CRAN now and so should not fail due to external circumstances.
  
  ## Minor changes
  
    * Documentation .Rd files are now more readable with better formatting
    
    * Adds link to POWER website in error message when query fails

## Reverse dependencies

There are currently no reverse dependencies.

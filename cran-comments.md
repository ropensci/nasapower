# nasapower v1.0.4

## Test environments
* local macOS 10.14.2 install, R 3.5.2
* local Ubuntu 18.04, R 3.5.2
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

This is a the second new patch release at the request of CRAN maintainers,
changes follow.

With the US government partial shut down the POWER API is officially offline.
It is unclear how long this will last. I've done my best to address CRAN's
comments without full functionality of the API.

  ## Requested changes
  
    * Does not run any test on CRAN which require `vcr` since it is not
    available on r-oldrel-osx-x86_64. I cannot control what is or is not
    available there but by not running tests on CRAN should remove this issue
    along with other issues related to the API not being availble which is
    causing all other ERRORs reported on
    <https://cran.r-project.org/web/checks/check_results_nasapower.html>.
    
    * Any examples in the vignette will no longer be evaluated on CRAN. The
    previous (rejected) submission had one code chunk that was still incorrectly
    evaluated and the API failed leading to an error. No code chunks are
    evaulated on CRAN now and so should not fail due to external circumstances.

## Reverse dependencies

There are currently no reverse dependencies.

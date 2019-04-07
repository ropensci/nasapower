# nasapower v1.1.0

## Test environments
* local macOS 10.14.2 install, R 3.5.3
* local Ubuntu 18.04, R 3.5.3
* win-builder (devel, release and oldrel)

## R CMD check results

0 errors | 0 warnings | 1 note

  ## Bug fixes
  
    - Fixes bug where CLIMATE could not be requested for a single point

    - Fixes bug where .met files were not created
    
  ## Major changes

    - Change how `GLOBAL` values are requested. This is now specified in
    `lonlat` in conjunction with `temporal_average = CLIMATOLOGY`.

## Minor changes

    - Refactor code to split internal functions by functionality and add more
    complete test coverage

## Reverse dependencies

There are currently no reverse dependencies.

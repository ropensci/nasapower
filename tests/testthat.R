# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
# * https://testthat.r-lib.org/articles/special-files.html

library(testthat)
library(nasapower)

if (Sys.getenv("NOT_CRAN") == "true") {
  # like global skip_on_cran
  # https://github.com/r-lib/testthat/issues/144#issuecomment-396902791
  # according to https://github.com/hadley/testthat/issues/144
  Sys.setenv("R_TESTS" = "")
  test_check("nasapower")
}

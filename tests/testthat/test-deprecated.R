
# test deprecated functions return a warning -----------------------------------
context("nasapower-deprecated")
test_that("deprecated functions return warning message", {
  expect_warning(get_cell(lonlat = c(-179.5, -89.5)),
                 regexp = "'get_cell' is deprecated.*")
  expect_warning(get_region(lonlat = NULL, stdate = "2017-1-1",
                            endate = "2017-1-1"),
                 regexp = "'get_region' is deprecated.*")
})

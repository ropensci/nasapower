
# test deprecated functions return a warning -----------------------------------
context("nasapower-deprecated")
test_that("deprecated functions return warning message", {
  expect_warning(get_cell(),
                 regexp = "'get_cell' is deprecated.*")
  expect_warning(get_region(),
                 regexp = "'get_region' is deprecated.*")
})


# lonlat checks ----------------------------------------------------------------
context("Test that when `lonlat` is set to `Global`, dates and temporal avg are
        handled correctly")
test_that("check_global stops if value is not valid char string", {
  # set up lonlat argument for testing
  lonlat <- "T2M"
  expect_error(check_global(lonlat),
               regexp = "\nYou have entered an invalid value for `lonlat`.\n")
  })

test_that("check_global returns properly formatted `global` object", {
  lonlat <- "GLOBAL"
  expect_equal(check_global(lonlat), "GLOBAL")
})

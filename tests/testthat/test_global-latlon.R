
# latlon checks ----------------------------------------------------------------
context("Test that when `latlon` is set to `Global`, dates and temporal avg are handled correctly")
test_that("check_global stops if value is not valid char string", {
  # set up latlon argument for testing
  latlon <- "T2M"
  expect_error(check_global(latlon),
               regexp = "\nYou have entered an invalid value for `latlon`.\n")
  })

test_that("check_global returns properly formatted `global` object", {
  latlon <- "global"
  expect_equal(check_global(latlon), "Global")

  latlon <- "globaL"
  expect_equal(check_global(latlon), "Global")

  latlon <- "Global"
  expect_equal(check_global(latlon), "Global")
})

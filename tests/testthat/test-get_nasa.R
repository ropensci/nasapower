context("get_nasa")
# Check that .validate_years handles invalid years -----------------------------

test_that("get_nasa returns a valid data frame", {
  expect_is(get_nasa(
    lon = -179.5,
    lat = 89.5
  ), "data.frame")
})

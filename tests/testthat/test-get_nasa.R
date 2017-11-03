context("get_nasa")
# Check that .validate_years handles invalid years -----------------------------

test_that("get_nasa returns a valid data frame", {
  expect_is(get_nasa(lonlat = c(-179.5, 89.5)), "data.frame")
})

test_that("get_nasa only uses first value of lat/lon", {
  expect_error(test <-
                   get_nasa(lonlat = c(-179.5, -178.5, -89.5)))
})

test_that("get_nasa emits a message when RAIN requested outside provision", {
  expect_message(get_nasa(
    lonlat = c(-179.5, -89.5),
    vars = c("T2M", "RAIN")
  ))
})

test_that("stdate can't be before 1983", {
  expect_error(get_nasa(
    lonlat = c(-179.5, -89.5),
    stdate = "1982-12-31"
  ))
})

test_that("stdate comes before endate", {
  expect_error(get_nasa(
    lonlat = c(-179.5, -89.5),
    stdate = "1984-01-31",
    endate = "1983-12-31"
  ))
})

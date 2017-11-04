context("get_cell")
# Check that .validate_years handles invalid years -----------------------------

test_that("get_cell returns a valid data frame", {
  expect_is(get_cell(
    lonlat = c(-179.5, 89.5),
    stdate = "2017-1-1",
    endate = "2017-1-1"
  ),
  "data.frame")
})

test_that("get_cell only uses first value of lat/lon", {
  expect_error(test <-
                 get_cell(lonlat = c(-179.5, -178.5, -89.5)))
})

test_that("get_cell emits a message when RAIN requested outside provision", {
  expect_message(get_cell(
    lonlat = c(-179.5, -89.5),
    vars = c("T2M", "RAIN"),
    stdate = "1987-1-1",
    endate = "1987-1-1"
  ))
})

test_that("stdate can't be before 1983", {
  expect_error(get_cell(lonlat = c(-179.5, -89.5),
                        stdate = "1982-12-31"))
})

test_that("stdate comes before endate", {
  expect_error(get_cell(
    lonlat = c(-179.5, -89.5),
    stdate = "1984-01-31",
    endate = "1983-12-31"
  ))
})

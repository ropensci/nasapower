context("get_cell")

test_that("get_cell returns a valid data frame and multiple dates", {
  x <- get_cell(
    lonlat = c(-179.5, 89.5),
    stdate = "2017-1-1",
    endate = "2017-1-2")
  expect_is(x, "data.frame")
  expect_equal(sum(!duplicated(x["DOY"])), 2)
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


# lonlat checks ----------------------------------------------------------------
context("check_lonlat")
test_that("check_lonlat_cell properly reports errors", {
  # set up pars argument for testing
  pars <- "T2M"

  # out-of-scope latitude for singlePoint
  lonlat <- c(-27.5, 151.5)
  expect_error(check_lonlat(lonlat, pars))

  # out-of-scope longitude for singlePoint
  lonlat <- c(181, 0)
  expect_error(check_lonlat(lonlat, pars))

  # non-numeric values for singlePoint
  lonlat <- c(181, "x")
  expect_error(check_lonlat(lonlat, pars))

  # out-of-scope latitude for regional
  lonlat <- c(-181, 181, -90, 90)
  expect_error(check_lonlat(lonlat, pars))

  # out-of-scope longitude for regional
  lonlat <- c(-180, 180, -91, 91)
  expect_error(check_lonlat(lonlat, pars))

  # incorrect orders for regional
  lonlat <- c(-180, 180, -91, 91)
  expect_error(check_lonlat(lonlat, pars))

  # non-numeric values for regional
  lonlat <- c(112.91972, 159.256088, -55.11694, "x")
  expect_error(check_lonlat(lonlat, pars))

  # incorrect order of values requested for regional
  lonlat <- c(180, -180, -90, 90)
  expect_error(check_lonlat(lonlat, pars))

  lonlat <- c(-180, 180, 90, -90)
  expect_error(check_lonlat(lonlat, pars))
})

test_that("check_lonlat stops if more than three are requested for global", {
  lonlat <- NULL
  pars <-  c(
    "T2M",
    "T2MN",
    "T2MX",
    "RH2M",
    "toa_dwn",
    "swv_dwn",
    "lwv_dwn",
    "DFP2M",
    "RAIN",
    "WS10M"
  )
  expect_error(check_lonlat(lonlat, pars))
})

test_that("check_lonlat stops if no `lonlat` is supplied", {
  expect_error(check_lonlat(lonlat  = NULL, pars),
               regexp = "*You must provide a `lonlat` (maximum 100 points total or 10x10 cells)*")
})



# lonlat checks ----------------------------------------------------------------
context("Test that check_lonlat function handles lat lon strings correctly")
test_that("check_lonlat properly reports errors", {
  # set up pars argument for testing
  pars <- "T2M"

  # out-of-scope latitude for singlePoint
  lonlat <- c(-27.5, 151.5)
  expect_error(check_lonlat(lonlat, pars))

  # out-of-scope longitude for singlePoint
  lonlat <- c(0, 181)
  expect_error(check_lonlat(lonlat, pars))

  # non-numeric values for singlePoint
  lonlat <- c("x", 181)
  expect_error(check_lonlat(lonlat, pars))

  # out-of-scope latitude for regional
  lonlat <- c(-90, 90, -181, 181)
  expect_error(check_lonlat(lonlat, pars))

  # out-of-scope longitude for regional
  lonlat <- c(-91, 91, -180, 180)
  expect_error(check_lonlat(lonlat, pars))

  # incorrect orders for regional
  lonlat <- c(-91, 91, -180, 180)
  expect_error(check_lonlat(lonlat, pars))

  # non-numeric values for regional
  lonlat <- c(112.91972, -55.11694, "x", 159.256088)
  expect_error(check_lonlat(lonlat, pars))

  # incorrect order of values requested for regional
  lonlat <- c(-90, 90, 180, -180)
  expect_error(check_lonlat(lonlat, pars))

  lonlat <- c(90, -90, -180, 180)
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
  expect_error(check_lonlat(lonlat = NULL, pars),
               regexp = "\nYou must provide a `lonlat` *")
})

test_that("check_lonlat handles single point properly", {
  expect_message(test <- check_lonlat(lonlat = c(-179.5, -89.5), pars))
  expect_equal(test$lon, -179.5)
  expect_equal(test$lat, -89.5)
  expect_equal(test$identifier, "SinglePoint")
})

test_that("check_lonlat checks validity of single lon values", {
  expect_error(check_lonlat(lonlat = c(179.5, 91), pars),
               regexp = "\nPlease check your longitude, `91`,*")
})

test_that("check_lonlat checks validity of single lat values", {
  expect_error(check_lonlat(lonlat = c(182, 90), pars),
               regexp = "Please check your latitude, `182`,*")
})

# bbox checks ------------------------------------------------------------------

test_that("check_lonlat handles bboxes that are too large", {
  expect_error(check_lonlat(lonlat = c(-179.5, -89.5, 179.5, 89.5), pars),
               regexp = "Please provide correct bounding box values*")
})

test_that("check_lonlat checks order of the latitude values", {
  expect_error(check_lonlat(lonlat = c(-179.5, 89.5, 179.5, -89.5), pars),
               regexp = "\nThe first `lat` value must be the minimum value.\n")
})

test_that("check_lonlat checks order of the longitude values", {
  expect_error(check_lonlat(lonlat = c(179.5, -89.5, -179.5,  89.5), pars),
               regexp = "\nThe first `lon` value must be the minimum value.\n")
})

test_that("check_lonlat checks validity of bbox latmin values", {
  expect_error(check_lonlat(lonlat = c(-179.5, 91, -179.5, 90), pars),
               regexp = "\nPlease check your longitude, `-179.5`, `-179.5`,*")
})

test_that("check_lonlat checks validity of bbox latmax values", {
  expect_error(check_lonlat(lonlat = c(-179.5, 90, -179.5, 93), pars),
               regexp = "\nPlease check your longitude, `-179.5`, `-179.5`,*")
})

test_that("check_lonlat checks validity of bbox lonmin values", {
  expect_error(check_lonlat(lonlat = c(-181.5, 89.5, -179.5, 89.5), pars),
               regexp = "\nPlease check your longitude, `-181.5`, `-179.5`*")
})

test_that("check_lonlat checks validity of bbox lonmax values", {
  expect_error(check_lonlat(lonlat = c(-179.5, 89.5, 181, 89.5), pars),
               regexp = "\nPlease check your longitude, `-179.5`, `181`,*")
})

test_that("check_lonlat returns message with proper identifier when valid
          coordinates are given", {
            expect_message(test <- check_lonlat(lonlat = c(-179.5,
                                                           88.5,
                                                           -179.5,
                                                           89.5),
                                                pars),
                           regexp = "Fetching regional data for the*")

          expect_equal(test$bbox, "88.5,-179.5,89.5,-179.5")
          expect_equal(test$identifier, "Regional")
          })

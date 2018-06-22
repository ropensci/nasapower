
# latlon checks ----------------------------------------------------------------
context("Test that check_latlon function handles lat lon strings correctly")
test_that("check_latlon properly reports errors", {
  # set up pars argument for testing
  pars <- "T2M"

  # out-of-scope latitude for singlePoint
  latlon <- c(151.5, -27.5)
  expect_error(check_latlon(latlon, pars))

  # out-of-scope longitude for singlePoint
  latlon <- c(181, 0)
  expect_error(check_latlon(latlon, pars))

  # non-numeric values for singlePoint
  latlon <- c(181, "x")
  expect_error(check_latlon(latlon, pars))

  # out-of-scope latitude for regional
  latlon <- c(-181, 181, -90, 90)
  expect_error(check_latlon(latlon, pars))

  # out-of-scope longitude for regional
  latlon <- c(-180, 180, -91, 91)
  expect_error(check_latlon(latlon, pars))

  # incorrect orders for regional
  latlon <- c(-180, 180, -91, 91)
  expect_error(check_latlon(latlon, pars))

  # non-numeric values for regional
  latlon <- c(112.91972, 159.256088, -55.11694, "x")
  expect_error(check_latlon(latlon, pars))

  # incorrect order of values requested for regional
  latlon <- c(180, -180, -90, 90)
  expect_error(check_latlon(latlon, pars))

  latlon <- c(-180, 180, 90, -90)
  expect_error(check_latlon(latlon, pars))
})

test_that("check_latlon stops if more than three are requested for global", {
  latlon <- NULL
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
  expect_error(check_latlon(latlon, pars))
})

test_that("check_latlon stops if no `latlon` is supplied", {
  expect_error(check_latlon(latlon = NULL, pars),
               regexp = "*You must provide a `latlon` (maximum 100 points*)")
})

test_that("check_latlon handles single point properly", {
  expect_message(test <- check_latlon(latlon = c(-89.5, -179.5), pars))
  expect_equal(test$lon, -179.5)
  expect_equal(test$lat, -89.5)
  expect_equal(test$identifier, "SinglePoint")
})

test_that("check_latlon checks validity of single lat values", {
  expect_error(check_latlon(latlon = c(91, 179.5), pars),
               regexp = "Please check your latitude, `91`, to be sure it is*\n")
})

test_that("check_latlon checks validity of single lon values", {
  expect_error(check_latlon(latlon = c(90, 182), pars),
               regexp = "Please check your longitude, `182`,*")
})

# bbox checks ------------------------------------------------------------------

test_that("check_latlon handles bboxes that are too large", {
  expect_error(check_latlon(latlon = c(-89.5, -179.5, 89.5, 179.5), pars),
               regexp = "Please provide correct bounding box values*")
})

test_that("check_latlon checks order of the latitude values", {
  expect_error(check_latlon(latlon = c(89.5, -179.5, -89.5, 179.5), pars),
               regexp = "\nThe first `lat` value must be the minimum value.\n")
})

test_that("check_latlon checks order of the longitude values", {
  expect_error(check_latlon(latlon = c(-89.5,  179.5, 89.5, -179.5), pars),
               regexp = "\nThe first `lon` value must be the minimum value.\n")
})

test_that("check_latlon checks validity of bbox latmin values", {
  expect_error(check_latlon(latlon = c(91, -179.5, 90, -179.5), pars),
               regexp = "\nPlease check your latitude, `91`, `90`, values*")
})

test_that("check_latlon checks validity of bbox latmax values", {
  expect_error(check_latlon(latlon = c( 90, -179.5,  93, -179.5), pars),
               regexp = "\nPlease check your latitude, `90`, `93`, values to*")
})

test_that("check_latlon checks validity of bbox lonmin values", {
  expect_error(check_latlon(latlon = c(89.5, -181.5, 89.5, -179.5), pars),
               regexp = "\nPlease check your longitude, `-181.5`, `-179.5`*")
})

test_that("check_latlon checks validity of bbox lonmax values", {
  expect_error(check_latlon(latlon = c(89.5, -179.5, 89.5, 181), pars),
               regexp = "\nPlease check your longitude, `-179.5`, `181`,*")
})

test_that("check_latlon returns message with proper identifier when valid
          coordinates are given", {
          expect_message(test <- check_latlon(latlon = c( 88.5,
                                                          -179.5,
                                                          89.5,
                                                          -179.5),
                                              pars),
                                 regexp = "Fetching regional data for the*")

          expect_equal(test$bbox, "88.5,-179.5,89.5,-179.5")
          expect_equal(test$identifier, "Regional")
          })


# Date handling and checking ---------------------------------------------------
context("Check dates handles dates correctly")
test_that("Missing `dates` are properly handled", {
  temporal_average <- "DAILY"
  dates <- NULL
  lonlat <- c(-179.5, -89.5)
  expect_error(.check_dates(dates, lonlat, temporal_average))
})

test_that("`dates` with one value set one day query", {
  temporal_average <- "DAILY"
  dates <- "1983-01-01"
  lonlat <- c(-179.5, -89.5)
  dates <- .check_dates(dates, lonlat, temporal_average)
  expect_equal(dates[1], "19830101")
  expect_equal(dates[2], "19830101")
})

test_that("`dates` > 2 cause an error", {
  temporal_average <- "DAILY"
  dates <- c("1983-01-01", "1983-01-02", "1983-01-03")
  lonlat <- c(-179.5, -89.5)
  expect_error(.check_dates(dates, lonlat, temporal_average),
    regexp =
      "\nYou have supplied more than two dates for start and end*"
  )
})

test_that("`dates` entered in incorrect formats are corrected", {
  temporal_average <- "DAILY"
  dates <- "01-01-1983"
  lonlat <- c(-179.5, -89.5)
  dates <- .check_dates(dates, lonlat, temporal_average)
  expect_equal(dates[1], "19830101")

  dates <- "Jan-01-1983"
  dates <- .check_dates(dates, lonlat, temporal_average)
  expect_equal(dates[1], "19830101")
})

test_that("DAILY `dates` entered in reverse order are corrected", {
  temporal_average <- "DAILY"
  today <- as.character(Sys.Date())
  dates <- c(today, "1983-01-01")
  lonlat <- c(-179.5, -89.5)
  expect_message(.check_dates(dates, lonlat, temporal_average),
    regexp = "*Your start and end dates were reversed.*"
  )
})

test_that("INTERANNUAL `dates` entered in reverse order are corrected", {
  temporal_average <- "INTERANNUAL"
  today <- as.character(Sys.Date())
  dates <- c(today, "1983-01-01")
  lonlat <- c(-179.5, -89.5)
  expect_message(.check_dates(dates, lonlat, temporal_average),
    regexp = "*Your start and end dates were reversed.*"
  )
})

test_that("`dates` before the start of POWER data cause error", {
  temporal_average <- "DAILY"
  today <- as.character(Sys.Date())
  dates <- c("1979-12-31", today)
  lonlat <- c(-179.5, -89.5)
  expect_error(.check_dates(dates, lonlat, temporal_average),
    regexp = "*\n1981-01-01 is the earliest available data from POWER*"
  )
})

test_that("`dates` after today POWER cause error", {
  temporal_average <- "DAILY"
  tomorrow <- as.character(Sys.Date() + 1)
  lonlat <- c(-179.5, -89.5)
  expect_error(.check_dates(tomorrow, lonlat, temporal_average),
    regexp = "*The data cannot possibly extend beyond this moment.*"
  )
})

test_that("Invalid `dates` are handled", {
  temporal_average <- "DAILY"
  dates <- c("1983-01-01", "1983-02-31")
  lonlat <- c(-179.5, -89.5)
  expect_error(.check_dates(dates, lonlat, temporal_average),
    regexp = "*1983-02-31 is not a valid entry for date.*"
  )
})

test_that("Dates are returned as a vector of characters", {
  temporal_average <- "DAILY"
  dates <- c("1983-01-01", "1983-02-02")
  lonlat <- c(-179.5, -89.5)
  dates <- .check_dates(dates, lonlat, temporal_average)
  expect_is(dates, "character")
})

test_that(
  "If temporal_average == INTERANNUAL and dates are specified, that only years
  are returned", {
    temporal_average <- "INTERANNUAL"
    dates <- c("1983-01-01", "1984-01-01")
    lonlat <- c(-179.5, -89.5)
    dates <- .check_dates(dates, lonlat, temporal_average)
    expect_equal(nchar(dates[1]), 4)
  }
)

test_that("If temporal_average == INTERANNUAL and <2 dates provided, error", {
  temporal_average <- "INTERANNUAL"
  dates <- c("1983-01-01")
  lonlat <- c(-179.5, -89.5)
  expect_error(.check_dates(dates, lonlat, temporal_average),
    regexp = "*\nFor `temporal_average = INTERANNUAL`, *"
  )
})


# community checks -------------------------------------------------------------
context("Test that .check_community() handles community checks correctly")
test_that(".check_community() properly reports errors", {

  community <- "R"
  pars <- c(
    "ALLSKY_SFC_SW_DWN_03_GMT",
    "ALLSKY_SFC_LW_DWN",
    "ALLSKY_SFC_SW_DWN_06_GMT",
    "RH2M"
  )
  expect_error(.check_community(community, pars))
})

# lonlat checks ----------------------------------------------------------------
context("Test that .check_lonlat() handles lat lon strings correctly")
test_that(".check_lonlat() properly reports errors", {
  # set up pars argument for testing
  pars <- "T2M"

  # out-of-scope latitude for singlePoint
  lonlat <- c(-27.5, 151.5)
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat, pars, temporal_average))

  # out-of-scope longitude for singlePoint
  lonlat <- c(0, 181)
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat, pars, temporal_average))

  # non-numeric values for singlePoint
  lonlat <- c("x", 181)
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat, pars, temporal_average))

  # out-of-scope latitude for regional
  lonlat <- c(-90, 90, -181, 181)
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat, pars, temporal_average))

  # out-of-scope longitude for regional
  lonlat <- c(-91, 91, -180, 180)
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat, pars, temporal_average))

  # incorrect orders for regional
  lonlat <- c(-91, 91, -180, 180)
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat, pars, temporal_average))

  # non-numeric values for regional
  lonlat <- c(112.91972, -55.11694, "x", 159.256088)
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat, pars, temporal_average))

  # incorrect order of values requested for regional
  lonlat <- c(-90, 90, 180, -180)
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat, pars, temporal_average))

  lonlat <- c(90, -90, -180, 180)
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat, pars, temporal_average))

  # invalid lonlat value
  lonlat <- "x"
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat, pars, temporal_average))
})

test_that(".check_lonlat() handles single point properly", {
  temporal_average <- "DAILY"
  test <- .check_lonlat(lonlat = c(-179.5, -89.5),
                        pars,
                        temporal_average)
  expect_equal(test$lon, -179.5)
  expect_equal(test$lat, -89.5)
  expect_equal(test$identifier, "SinglePoint")
})

test_that(".check_lonlat() checks validity of single lon values", {
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat = c(179.5, 91),
                             pars,
                             temporal_average),
    regexp = "\nPlease check your latitude, `91`,*"
  )
})

test_that(".check_lonlat() checks validity of single lat values", {
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat = c(182, 90),
                             pars,
                             temporal_average),
    regexp = "Please check your longitude, `182`,*"
  )
})

# bbox checks ------------------------------------------------------------------

test_that(".check_lonlat() handles bboxes that are too large", {
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat = c(-179.5, -89.5, 179.5, 89.5),
                             pars,
                             temporal_average),
    regexp = "Please provide correct bounding box values*"
  )
})

test_that(".check_lonlat() checks order of the latitude values", {
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat = c(-179.5, 89.5, 179.5, -89.5),
                             pars,
                             temporal_average),
    regexp = "\nThe first `lat` value must be the minimum value.\n"
  )
})

test_that(".check_lonlat() checks order of the longitude values", {
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat = c(179.5, -89.5, -179.5, 89.5),
                             pars,
                             temporal_average),
    regexp = "\nThe first `lon` value must be the minimum value.\n"
  )
})

test_that(".check_lonlat() checks validity of bbox latmin values", {
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat = c(-179.5, 91, -179.5, 90),
                             pars,
                             temporal_average),
    regexp = "\nPlease check your latitude, `91`, `90`*"
  )
})

test_that(".check_lonlat() checks validity of bbox latmax values", {
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat = c(-179.5, 90, -179.5, 93),
                             pars,
                             temporal_average),
    regexp = "\nPlease check your latitude, `90`, `93`,*"
  )
})

test_that(".check_lonlat() checks validity of bbox lonmin values", {
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat = c(-181.5, 89.5, -179.5, 89.5),
                             pars,
                             temporal_average),
    regexp = "\nPlease check your longitude, `-181.5`, `-179.5`*"
  )
})

test_that(".check_lonlat() checks validity of bbox lonmax values", {
  temporal_average <- "DAILY"
  expect_error(.check_lonlat(lonlat = c(-179.5, 89.5, 181, 89.5),
                             pars,
                             temporal_average),
    regexp = "\nPlease check your longitude, `-179.5`, `181`,*"
  )
})

test_that(".check_lonlat() returns message with proper identifier when valid
          coordinates are given", {
            temporal_average <- "DAILY"
  test <- .check_lonlat(
    lonlat = c(
      -179.5,
      88.5,
      -179.5,
      89.5
    ),
    pars,
    temporal_average
  )
  expect_equal(test$bbox, "88.5,-179.5,89.5,-179.5")
  expect_equal(test$identifier, "Regional")
})


# parameter checks -------------------------------------------------------------
context("Test that check_pars handles pars strings correctly")
test_that(".check_pars() stops if no `pars` provided", {
  temporal_average <- "DAILY"
  lonlat <- c(-179.5, -89.5)

  expect_error(.check_pars(
    temporal_average,
    lonlat,
    pars
  ))
})

test_that(".check_pars()  stops if no `temporal_average` provided", {
  pars <- "AG"
  lonlat <- c(-179.5, -89.5)

  expect_error(.check_pars(
    temporal_average,
    lonlat,
    pars
  ))
})

test_that(".check_pars()  stops if `pars` not valid", {
  pars <- "asdflkuewr"
  temporal_average <- "DAILY"
  lonlat <- c(-179.5, -89.5)

  expect_error(.check_pars(
    pars,
    temporal_average,
    lonlat
  ))
})

test_that(".check_pars()  stops if `pars` not valid for given temporal_average", {
  pars <- "ALLSKY_SFC_SW_DWN_03_GMT"
  temporal_average <- "INTERANNUAL"
  lonlat <- c(-179.5, -89.5)

  expect_error(.check_pars(
    pars,
    temporal_average,
    lonlat
  ))
})

test_that("pars are returned as a comma separated string with no spaces", {
  pars <- c(
    "ALLSKY_SFC_SW_DWN_03_GMT",
    "ALLSKY_SFC_LW_DWN"
  )
  temporal_average <- "CLIMATOLOGY"
  lonlat <- c(-179.5, -89.5)

  pars <- .check_pars(
    pars,
    temporal_average,
    lonlat
  )
  expect_named(pars, c("pars", "temporal_average", "skip_lines"))
  expect_equal(nchar(pars$pars), 42)
  expect_equal(pars$pars, "ALLSKY_SFC_SW_DWN_03_GMT,ALLSKY_SFC_LW_DWN")
  expect_equal(pars$temporal_average, "CLIMATOLOGY")
  expect_length(pars, 3)
})

test_that("Only 3 pars are allowed when `temporal_average` = CLIMATOLOGY", {
  pars <- c(
    "ALLSKY_SFC_SW_DWN_03_GMT",
    "ALLSKY_SFC_LW_DWN",
    "ALLSKY_SFC_SW_DWN_06_GMT",
    "RH2M"
  )
  temporal_average <- "CLIMATOLOGY"
  lonlat <- NULL
  expect_error(
    pars <-
      .check_pars(pars, temporal_average, lonlat),
    regexp <- "\nYou can only specify three*"
  )
})

test_that("Only 20 pars are allowed when `temporal_average` != CLIMATOLOGY", {
  pars <- c(
    "ALLSKY_SFC_LW_DWN",
    "ALLSKY_TOA_SW_DWN",
    "CDD0",
    "CDD10",
    "CDD18_3",
    "CLRSKY_SFC_SW_DWN",
    "FROST_DAYS",
    "HDD0",
    "HDD10",
    "HDD18_3",
    "KT",
    "KT_CLEAR",
    "PRECTOT",
    "PS",
    "QV2M",
    "RH2M",
    "T10M",
    "T10M_MAX",
    "T10M_MIN",
    "T10M_RANGE",
    "T2M_RANGE",
    "T2M_MIN",
    "T2M_MAX"
  )
  temporal_average <- "DAILY"
  lonlat <- c(-179.5, -89.5)
  expect_error(
    pars <- .check_pars(pars, temporal_average, lonlat),
    regexp <- "\nYou can only specify 20 parameters for download*"
  )
})

test_that("Only unique `pars` are queried", {
  pars <- c(
    "RH2M",
    "RH2M",
    "RH2M"
  )
  temporal_average <- "CLIMATOLOGY"
  lonlat <- NULL
  pars <- .check_pars(pars, temporal_average, lonlat)
  expect_equal(pars[[1]], "RH2M")
  expect_equal(length(pars[[1]]), 1)
})

test_that("If an invalid temporal average is given for `pars`,
          an error occurs", {
  pars <- "ALLSKY_SFC_SW_DWN_00_GMT"
  temporal_average <- "DAILY"
  lonlat <- c(-179.5, -89.5)
  expect_error(.check_pars(pars, temporal_average, lonlat))
})

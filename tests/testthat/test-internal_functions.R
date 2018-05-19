
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

# Date handling and checking ---------------------------------------------------

test_that("NULL `dates`` are properly handled", {
  dates <- NULL
  dates <- check_dates(dates)
  today <- as.character(Sys.Date())
  today <- gsub("-", "" , today, ignore.case = TRUE)
  expect_equal(dates[1], "19830101")
  expect_equal(dates[2], today)
})

test_that("`dates` with one value set one day query", {
  dates <- "1983-01-01"
  dates <- check_dates(dates)
  expect_equal(dates[1], "19830101")
  expect_equal(dates[2], "19830101")
})

test_that("`dates` >2 cause an error", {
  dates <- c("1983-01-01", "1983-01-02", "1983-01-03")
  expect_error(check_dates(dates),
               regexp =
                 "You have supplied more than two dates for a start and end date.")
})

test_that("`dates` entered in incorrect formats are corrected", {
  dates <- "01-01-1983"
  dates <- check_dates(dates)
  expect_equal(dates[1], "19830101")

  dates <- "Jan-01-1983"
  dates <- check_dates(dates)
  expect_equal(dates[1], "19830101")
})

test_that("`dates` entered in reverse order are corrected", {
  today <- as.character(Sys.Date())
  dates <- c(today, "1983-01-01")
  expect_message(
    check_dates(dates),
    regexp = "*Your start and end dates were reversed.*")
})

test_that("`dates` before the start of POWER data cause error", {
  today <- as.character(Sys.Date())
  dates <- c("1982-12-31", today)
  expect_error(
    check_dates(dates),
    regexp = "*NASA-POWER data do not start before 1983-01-01*")
})

test_that("`dates` after today POWER cause error", {
  tomorrow <- as.character(Sys.Date() + 1)
  expect_error(
    check_dates(tomorrow),
    regexp = "*The data cannot possibly extend beyond this moment.*")
})

test_that("Invalid `dates` are handled", {
  dates <- c("1983-01-01", "1983-02-31")
  expect_error(
    check_dates(dates),
    regexp = "*1983-02-31 is not a valid entry for date.*")
})

test_that("Dates are returned as a vector of characters", {
  dates <- c("1983-01-01", "1983-02-02")
  dates <- check_dates(dates)
  expect_is(dates, "character")
})

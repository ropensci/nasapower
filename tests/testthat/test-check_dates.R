
# Date handling and checking ---------------------------------------------------
context("Check dates function handles dates correctly")
test_that("Missing `dates` are properly handled", {
  temporal_average <- "DAILY"
  lonlat <- c(-179.5, -89.5)
  expect_error(check_dates(dates, lonlat, temporal_average))
})

test_that("`dates` with one value set one day query", {
  temporal_average <- "DAILY"
  dates <- "1983-01-01"
  lonlat <- c(-179.5, -89.5)
  dates <- check_dates(dates, lonlat, temporal_average)
  expect_equal(dates[1], "19830101")
  expect_equal(dates[2], "19830101")
})

test_that("`dates` >2 cause an error", {
  temporal_average <- "DAILY"
  dates <- c("1983-01-01", "1983-01-02", "1983-01-03")
  lonlat <- c(-179.5, -89.5)
  expect_error(check_dates(dates, lonlat, temporal_average),
               regexp =
                 "\nYou have supplied more than two dates for start and end*")
})

test_that("`dates` entered in incorrect formats are corrected", {
  temporal_average <- "DAILY"
  dates <- "01-01-1983"
  lonlat <- c(-179.5, -89.5)
  dates <- check_dates(dates, lonlat, temporal_average)
  expect_equal(dates[1], "19830101")

  dates <- "Jan-01-1983"
  dates <- check_dates(dates, lonlat, temporal_average)
  expect_equal(dates[1], "19830101")
})

test_that("`dates` entered in reverse order are corrected", {
  temporal_average <- "DAILY"
  today <- as.character(Sys.Date())
  dates <- c(today, "1983-01-01")
  lonlat <- c(-179.5, -89.5)
  expect_message(check_dates(dates, lonlat, temporal_average),
                 regexp = "*Your start and end dates were reversed.*")
})

test_that("`dates` before the start of POWER data cause error", {
  temporal_average <- "DAILY"
  today <- as.character(Sys.Date())
  dates <- c("1982-12-31", today)
  lonlat <- c(-179.5, -89.5)
  expect_error(check_dates(dates, lonlat, temporal_average),
               regexp = "*NASA-POWER data do not start before 1983-01-01*")
})

test_that("`dates` after today POWER cause error", {
  temporal_average <- "DAILY"
  tomorrow <- as.character(Sys.Date() + 1)
  lonlat <- c(-179.5, -89.5)
  expect_error(check_dates(tomorrow, lonlat, temporal_average),
               regexp = "*The data cannot possibly extend beyond this moment.*")
})

test_that("Invalid `dates` are handled", {
  temporal_average <- "DAILY"
  dates <- c("1983-01-01", "1983-02-31")
  lonlat <- c(-179.5, -89.5)
  expect_error(check_dates(dates, lonlat, temporal_average),
               regexp = "*1983-02-31 is not a valid entry for date.*")
})

test_that("Dates are returned as a vector of characters", {
  temporal_average <- "DAILY"
  dates <- c("1983-01-01", "1983-02-02")
  lonlat <- c(-179.5, -89.5)
  dates <- check_dates(dates, lonlat, temporal_average)
  expect_is(dates, "character")
})

test_that("If temporal_average == CLIMATOLOGY, no dates can be specified", {
  temporal_average <- "CLIMATOLOGY"
  dates <- c("1983-01-01", "1983-02-02")
  lonlat <- c(-179.5, -89.5)
  expect_error(check_dates(dates, lonlat, temporal_average),
               regexp = "*Dates are not used when querying climatology data.*")
})

test_that(
  "If temporal_average == INTERANNUAL and dates are specified, that
  a message is emitted about years only",
  {
    temporal_average <- "INTERANNUAL"
    dates <- c("1983-01-01", "1984-01-01")
    lonlat <- c(-179.5, -89.5)
    expect_message(check_dates(dates, lonlat, temporal_average),
                   regexp = "*Only years are used with INTERANNUAL temporal.*")
  }
)

test_that(
  "If temporal_average == INTERANNUAL and dates are specified, that
  a message is emitted about years only",
  {
    temporal_average <- "INTERANNUAL"
    dates <- c("1983-01-01", "1983-02-02")
    lonlat <- c(-179.5, -89.5)
    expect_error(check_dates(dates, lonlat, temporal_average),
                 regexp = "*For `temporal_average == INTERANNUAL`,*")
  }
)

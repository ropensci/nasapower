

# Date handling and checking ---------------------------------------------------
context("Check dates function handles dates correctly")
test_that("NULL `dates`` are properly handled", {
  temporal_average <- "DAILY"
  dates <- NULL
  latlon <- c(-89.5, -179.5)
  dates <- check_dates(dates, latlon, temporal_average)
  today <- as.character(Sys.Date())
  today <- gsub("-", "" , today, ignore.case = TRUE)
  expect_equal(dates[1], "19830101")
  expect_equal(dates[2], today)
})

test_that("`dates` with one value set one day query", {
  temporal_average <- "DAILY"
  dates <- "1983-01-01"
  latlon <- c(-89.5, -179.5)
  dates <- check_dates(dates, latlon, temporal_average)
  expect_equal(dates[1], "19830101")
  expect_equal(dates[2], "19830101")
})

test_that("`dates` >2 cause an error", {
  temporal_average <- "DAILY"
  dates <- c("1983-01-01", "1983-01-02", "1983-01-03")
  latlon <- c(-89.5, -179.5)
  expect_error(check_dates(dates, latlon),
               regexp =
                 "\nYou have supplied more than two dates for start and end*")
})

test_that("`dates` entered in incorrect formats are corrected", {
  temporal_average <- "DAILY"
  dates <- "01-01-1983"
  latlon <- c(-89.5, -179.5)
  dates <- check_dates(dates, latlon, temporal_average)
  expect_equal(dates[1], "19830101")

  dates <- "Jan-01-1983"
  dates <- check_dates(dates, latlon, temporal_average)
  expect_equal(dates[1], "19830101")
})

test_that("`dates` entered in reverse order are corrected", {
  temporal_average <- "DAILY"
  today <- as.character(Sys.Date())
  dates <- c(today, "1983-01-01")
  latlon <- c(-89.5, -179.5)
  expect_message(check_dates(dates, latlon, temporal_average),
                 regexp = "*Your start and end dates were reversed.*")
})

test_that("`dates` before the start of POWER data cause error", {
  temporal_average <- "DAILY"
  today <- as.character(Sys.Date())
  dates <- c("1982-12-31", today)
  latlon <- c(-89.5, -179.5)
  expect_error(check_dates(dates, latlon),
               regexp = "*NASA-POWER data do not start before 1983-01-01*")
})

test_that("`dates` after today POWER cause error", {
  temporal_average <- "DAILY"
  tomorrow <- as.character(Sys.Date() + 1)
  latlon <- c(-89.5, -179.5)
  expect_error(check_dates(tomorrow, latlon, temporal_average),
               regexp = "*The data cannot possibly extend beyond this moment.*")
})

test_that("Invalid `dates` are handled", {
  temporal_average <- "DAILY"
  dates <- c("1983-01-01", "1983-02-31")
  latlon <- c(-89.5, -179.5)
  expect_error(check_dates(dates, latlon),
               regexp = "*1983-02-31 is not a valid entry for date.*")
})

test_that("Dates are returned as a vector of characters", {
  temporal_average <- "DAILY"
  dates <- c("1983-01-01", "1983-02-02")
  latlon <- c(-89.5, -179.5)
  dates <- check_dates(dates, latlon, temporal_average)
  expect_is(dates, "character")
})

test_that("A `global` `latlon` returns `NULL` dates", {
  temporal_average <- "DAILY"
  latlon <- "Global"
  dates <- c("1983-01-01", "1983-02-02")
  expect_message(dates <- check_dates(dates, latlon, temporal_average),
                 regexp = "*are not used with CLIMATOLOGY. Setting to NULL.\n")
  expect_true(is.null(dates))
})

test_that("If temporal_average == CLIMATOLOGY, no dates can be specified", {
  temporal_average <- "CLIMATOLOGY"
  dates <- c("1983-01-01", "1983-02-02")
  latlon <- c(-89.5, -179.5)
  expect_error(check_dates(dates, latlon, temporal_average),
               regexp = "*Dates are not used when querying climatology data.*")
})

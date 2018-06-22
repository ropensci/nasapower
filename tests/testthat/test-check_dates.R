

# Date handling and checking ---------------------------------------------------
context("Check dates function handles dates correctly")
test_that("NULL `dates`` are properly handled", {
  dates <- NULL
  latlon <- c(-89.5, -179.5)
  dates <- check_dates(dates, latlon)
  today <- as.character(Sys.Date())
  today <- gsub("-", "" , today, ignore.case = TRUE)
  expect_equal(dates[1], "19830101")
  expect_equal(dates[2], today)
})

test_that("`dates` with one value set one day query", {
  dates <- "1983-01-01"
  latlon <- c(-89.5, -179.5)
  dates <- check_dates(dates, latlon)
  expect_equal(dates[1], "19830101")
  expect_equal(dates[2], "19830101")
})

test_that("`dates` >2 cause an error", {
  dates <- c("1983-01-01", "1983-01-02", "1983-01-03")
  latlon <- c(-89.5, -179.5)
  expect_error(check_dates(dates, latlon),
               regexp =
                 "You have supplied more than two dates for a start and end date.")
})

test_that("`dates` entered in incorrect formats are corrected", {
  dates <- "01-01-1983"
  latlon <- c(-89.5, -179.5)
  dates <- check_dates(dates, latlon)
  expect_equal(dates[1], "19830101")

  dates <- "Jan-01-1983"
  dates <- check_dates(dates, latlon)
  expect_equal(dates[1], "19830101")
})

test_that("`dates` entered in reverse order are corrected", {
  today <- as.character(Sys.Date())
  dates <- c(today, "1983-01-01")
  latlon <- c(-89.5, -179.5)
  expect_message(check_dates(dates, latlon),
                 regexp = "*Your start and end dates were reversed.*")
})

test_that("`dates` before the start of POWER data cause error", {
  today <- as.character(Sys.Date())
  dates <- c("1982-12-31", today)
  latlon <- c(-89.5, -179.5)
  expect_error(check_dates(dates, latlon),
               regexp = "*NASA-POWER data do not start before 1983-01-01*")
})

test_that("`dates` after today POWER cause error", {
  tomorrow <- as.character(Sys.Date() + 1)
  latlon <- c(-89.5, -179.5)
  expect_error(check_dates(tomorrow, latlon),
               regexp = "*The data cannot possibly extend beyond this moment.*")
})

test_that("Invalid `dates` are handled", {
  dates <- c("1983-01-01", "1983-02-31")
  latlon <- c(-89.5, -179.5)
  expect_error(check_dates(dates, latlon),
               regexp = "*1983-02-31 is not a valid entry for date.*")
})

test_that("Dates are returned as a vector of characters", {
  dates <- c("1983-01-01", "1983-02-02")
  latlon <- c(-89.5, -179.5)
  dates <- check_dates(dates, latlon)
  expect_is(dates, "character")
})

test_that("A `global` `latlon` returns `NULL` dates", {
  latlon <- "Global"
  dates <- c("1983-01-01", "1983-02-02")
  expect_message(dates <- check_dates(dates, latlon),
                 regexp = "\nDates are not used with CLIMATOLOGY. Setting to NULL.\n")
  expect_true(is.null(dates))
})

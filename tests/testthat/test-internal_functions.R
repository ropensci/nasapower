context(".check_response")
# Check that .check_response handles web-site responses properly  --------------

test_that(".check_response stops if server not responding", {
  url <- "http://badurl.gov.au"
  expect_error(.check_response(url))
})

test_that(".check_response proceeds if server is responding", {
  url <- "https://www.google.com/"
  expect_warning(.check_response(url), regexp = NA)
})

test_that(".check_lonlat_cell properly reports errors", {
  # out-of-scope latitude
  lonlat <- c(-27.5, 151.5)
  expect_error(.check_lonlat_cell(lonlat))

  # out-of-scope longitude
  lonlat <- c(181, 0)
  expect_error(.check_lonlat_cell(lonlat))

  # non-numeric values
  lonlat <- c(181, "x")
  expect_error(.check_lonlat_cell(lonlat))
})

test_that(".check_lonlat_region properly reports errors", {
  # out-of-scope latitude
  lonlat <- c(-181, 181, -90, 90)
  expect_error(.check_lonlat_region(lonlat))

  # out-of-scope longitude
  lonlat <- c(-180, 180, -91, 91)
  expect_error(.check_lonlat_region(lonlat))

  # incorrect orders
  lonlat <- c(-180, 180, -91, 91)
  expect_error(.check_lonlat_region(lonlat))

  # non-numeric values
  lonlat <- c(112.91972, 159.256088, -55.11694, "x")
  expect_error(.check_lonlat_region(lonlat))

  # incorrect order of values requested
  lonlat <- c(180, -180, -90, 90)
  expect_error(.check_lonlat_region(lonlat))

  lonlat <- c(-180, 180, 90, -90)
  expect_error(.check_lonlat_region(lonlat))
})

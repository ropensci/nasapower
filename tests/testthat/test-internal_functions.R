context(".check_response")
# check that .check_response handles web-site responses properly  --------------

test_that(".check_response stops if server not responding", {
  url <- "http://badurl.gov.au"
  expect_error(.check_response(url))
})

test_that(".check_response proceeds if server is responding", {
  url <- "https://www.google.com/"
  expect_warning(.check_response(url), regexp = NA)
})

# check that .check_lonlat* handles incorrect values properly  -----------------
context(".check_lonlat_cell")
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

context(".check_lonlat_region")
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

# check that .create_nasa_df handles data/no data properly ---------------------
context(".create_nasa_df")
test_that(".create_nasa_df alerts user that no data are available", {
  load(system.file("extdata", "NASA_no_data.rda", package = "nasapower"))
  stdate <- as.Date("2017-12-19")
  endate <- as.Date("2017-12-21")
  expect_error(.create_nasa_df(NASA, stdate, endate))
})

test_that(".create_nasa_df creates a data frame of data", {
  load(system.file("extdata", "NASA_with_data.rda", package = "nasapower"))
  stdate <- as.Date("2017-11-1")
  endate <- as.Date("2017-11-3")
  test <- .create_nasa_df(NASA, stdate, endate)
  expect_is(test, "data.frame")
})

# check that user entered vars are properly validated --------------------------
test_that(".check_vars stops if an invalid entry is made", {
  vars <- c("asdfasdf", "RH2M")
  expect_error(.check_vars(vars))
})

test_that(".check_vars passes if a valid entry is made", {
  # single entry
  vars <- "RH2M"
  expect_error(.check_vars(vars), NA)

  # full string
  vars <-  c(
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
  expect_error(.check_vars(vars), NA)
})

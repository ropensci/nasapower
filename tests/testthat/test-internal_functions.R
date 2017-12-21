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
context(".check_nasa_df")
test_that(".check_nasa_df alerts user that no data are available", {
  load(system.file("extdata", "NASA_no_data.rda", package = "nasapower"))
  expect_error(.check_nasa_df(NASA))
})

test_that(".check_nasa_df creates a data frame of data", {
  load(system.file("extdata", "NASA_with_data.rda", package = "nasapower"))
  expect_error(.check_nasa_df(NASA), NA)
})

# check that user entered vars are properly validated --------------------------
context(".check_dates")
test_that(".check_dates reverses dates that are entered backwards", {
  stdate <- "2001-05-01"
  endate <- "1985-01-01"
  expect_message(udates <- .check_dates(stdate, endate))
  expect_equal(as.Date(udates[[1]]), as.Date("1985-01-01"))
  expect_equal(as.Date(udates[[2]]), as.Date("2001-05-01"))
})

test_that(".check_dates stops if an invalid entry is made", {
  stdate <- "asdfasdf"
  endate <- "1985-01-01"
  expect_error(.check_dates(stdate, endate))
})

test_that(".check_dates stops if dates are beyond current date", {
  stdate <- Sys.Date()
  endate <- Sys.Date() + 7
  expect_error(.check_dates(stdate, endate))
})

test_that(".check_dates stops if dates are beyond current date", {
  stdate <- "1982-12-31"
  endate <- Sys.Date()
  expect_error(.check_dates(stdate, endate))
})

test_that(".check_dates returns properly formatted dates", {
  stdate <- "01-01-1983"
  endate <- "01-01-1985"
  expect_error(.check_dates(stdate, endate), NA)
})

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

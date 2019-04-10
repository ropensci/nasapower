
# test queries -----------------------------------------------------------------
context("create_met()")

test_that("create_met() creates a .met file for APSIM use", {
  skip_on_cran()
  create_met(
      lonlat = c(151.81, -27.48),
      dates = c("1985-01-01", "1985-12-31"),
      dsn = tempdir(),
      file_out = "APSIM"
    )

    expect_true(any(grepl("APSIM.met", list.files(tempdir()))))
    met <- readLines(file.path(tempdir(), "APSIM.met"))
    expect_equal(length(met), 377)
    expect_equal(nchar(met)[[1]], 21)
    expect_equal(nchar(met)[[14]], 28)
    expect_equal(nchar(met)[[311]], 31)
    expect_equal(met[4], "Latitude = -27.48")
    expect_equal(met[6], "Longitude = 151.81")
    expect_equal(met[8], "tav = 13.975064516129")
    expect_equal(met[9], "amp = 18.6052245903738")
})


test_that("create_met() fails if no dsn or file_out are supplied", {
  expect_error(
    create_met(
      lonlat = c(151.81, -27.48),
      dates = "1983-01-01",
      dsn = tempdir()
    )
  )

  expect_error(
    create_met(
      lonlat = c(151.81, -27.48),
      dates = "1983-01-01",
      file_out = tempfile()
    )
  )
})

test_that(".met_checks assigns a '.met' file ext if none supplied", {
    dsn <- tempdir()
    file_out <- "APSIM"
    file_out <- .met_checks(.dsn = dsn, .file_out = file_out)
    expect_equal(file_out, "APSIM.met")
})

test_that(".get_power_data returns an APSIM metFile s4 object", {
  skip_on_cran()
  lonlat <- c(151.81, -27.48)
  dates <- c("1983-01-01", "1983-12-31")
  power_data <- .get_met_data(.dates = dates, .lonlat = lonlat)
  expect_s4_class(power_data, "metFile")
})

context(".get_met_data()")

test_that(
  ".get_met_data creates an APSIM.met s4 object",
  {
    lonlat = c(151.81, -27.48)
    dates = c("1985-01-01", "1985-12-31")

    met_file <- .get_met_data(.dates = dates, .lonlat = lonlat)
    expect_s4_class(met_file, "metFile")
    expect_named(met_file@data,
                 c("maxt", "mint", "radn", "rain", "year", "day"))
    expect_equal(met_file@lat, -27.5, tolerance = 0.1)
    expect_equal(met_file@lon, 152, tolerance = 0.1)
    expect_equal(met_file@tav, 14, tolerance = 0.1)
    expect_equal(met_file@amp, 18.6, tolerance = 0.1)
})

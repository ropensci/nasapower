
# test queries -----------------------------------------------------------------
context("Test that create_icasa() creates a text file")
test_that("create_icasa() creates a txt file with proper values", {
  skip_on_cran()
    create_icasa(
      lonlat = c(151.81, -27.48),
      dates = c("1983-01-01"),
      file_out = "icasa",
      dsn = tempdir()
    )
    icasa <- readLines(file.path(tempdir(), "icasa.txt"))
    expect_true(any(grepl("icasa.txt", list.files(tempdir()))))
    expect_equal(length(icasa), 16)
    expect_equal(nchar(icasa)[[1]], 47)
    expect_equal(nchar(icasa)[[16]], 73)
})

test_that("create_icasa() fails if no dsn or file_out are supplied", {
  expect_error(
    create_icasa(
      lonlat = c(151.81, -27.48),
      dates = "1983-01-01",
      dsn = tempdir()
    )
  )

  expect_error(
    create_icasa(
      lonlat = c(151.81, -27.48),
      dates = "1983-01-01",
      file_out = tempfile()
    )
  )
})

test_that(".icasa_checks creates a proper file path for `file_out`", {
  skip_on_cran()
  icasa <- .icasa_checks(.dsn = tempdir(),
                     .file_out = "ICASA.txt",
                     .dates = c("1983-01-01"),
                     .lonlat = c(151.81, -27.48))

  expect_equal(icasa[[1]], file.path(tempdir(), "ICASA.txt"))

  query_list <- .build_query(
    community = "AG",
    pars = icasa[[2]],
    lonlat_identifier = icasa[[3]],
    dates = icasa[[4]],
    outputList = "ICASA")

  expect_named(query_list,
               c("request",
                 "identifier",
                 "parameters",
                 "startDate",
                 "endDate",
                 "userCommunity",
                 "tempAverage",
                 "outputList",
                 "lon",
                 "lat",
                 "user"))

  out <- .send_query(query_list, .pars = icasa[[2]])
  out <- readLines(out$outputs$icasa)
  expect_equal(out[[1]], "! TMAX     Maximum Temperature at 2 Meters (C) ")
  expect_equal(out[[2]], "! RH2M     Relative Humidity at 2 Meters (%) ")
  expect_equal(out[[3]], "! T2M     Temperature at 2 Meters (C) ")
  expect_equal(out[[4]], "! TMIN     Minimum Temperature at 2 Meters (C) ")
  expect_equal(out[[5]], "! RAIN     Precipitation (mm day-1) ")
  expect_equal(out[[6]], "! TDEW     Dew/Frost Point at 2 Meters (C) ")
  expect_equal(out[[7]], "! WIND     Wind Speed at 2 Meters (m/s) ")
  expect_equal(out[[8]], "! SRAD     All Sky Insolation Incident on a Horizontal Surface (MJ/m^2/day) ")
  expect_equal(out[[9]], "! Mean elevation for source NASA/POWER data tile (0.5 x 0.5 grid cell) = 434.55m")
  expect_equal(out[[10]], "*WEATHER DATA: NASA")
  expect_equal(out[[12]], " @ INSI   WTHLAT  WTHLONG   WELEV   TAV  AMP  REFHT  WNDHT")
  expect_equal(out[[13]], "   NASA   -27.48   151.81  434.55  25.7                  2")
  expect_equal(out[[15]], " @   DATE    TMAX    RH2M     T2M    TMIN    RAIN    TDEW    WIND    SRAD")
  expect_equal(out[[16]], "    83001    31.4    75.1    24.6    20.0     9.1    19.9     2.8     -99")
})

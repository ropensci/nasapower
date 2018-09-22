
# test queries -----------------------------------------------------------------
context("Test that create_met creates an APSIM .met file")
test_that("create_met stops if user specifies global coverage", {
  vcr::use_cassette("create_met_global_stop", {
    expect_error(
      power_query <- create_met(
        lonlat = "global",
        dates = c("1983-01-01"),
        dsn = tempdir(),
        file_out = tmpfile.txt
      ),
      regexp = "*The `lonlat` must be numeric values.*"
    )
  })
})

test_that("create_met creates a .met file for APSIM use", {
  vcr::use_cassette("create_met", {
    power_query <- create_met(
      lonlat = c(151.81, -27.48),
      dates = c("1985-01-01", "1985-01-02"),
      dsn = tempdir(),
      file_out = "APSIM"
    )

    met <- readLines(file.path(tempdir(), "APSIM.met"))
    expect_true(any(grepl("APSIM.met", list.files(tempdir()))))
    expect_equal(length(met), 14)
    expect_equal(nchar(met)[[1]], 21)
    expect_equal(nchar(met)[[14]], 28)
  })
})


test_that("create_met fails if no dsn or file_out are supplied", {
  expect_error(
    create_met(
      lonlat = c(151.81, -27.48),
      dates = c("1983-01-01"),
      dsn = tempdir()
    )
  )

  expect_error(
    create_met(
      lonlat = c(151.81, -27.48),
      dates = c("1983-01-01"),
      file_out = tempfile()
    )
  )
})

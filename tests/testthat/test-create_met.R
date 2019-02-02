
# test queries -----------------------------------------------------------------
context("Test that create_met() creates an APSIM .met file")

test_that("create_met() creates a .met file for APSIM use", {
  skip_on_cran()
    power_query <- create_met(
      lonlat = c(151.81, -27.48),
      dates = c("1985-01-01", "1985-12-31"),
      dsn = tempdir(),
      file_out = "APSIM"
    )

    met <- readLines(file.path(tempdir(), "APSIM.met"))
    expect_true(any(grepl("APSIM.met", list.files(tempdir()))))
    expect_equal(length(met), 377)
    expect_equal(nchar(met)[[1]], 21)
    expect_equal(nchar(met)[[14]], 28)
    expect_equal(nchar(met)[[311]], 31)
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

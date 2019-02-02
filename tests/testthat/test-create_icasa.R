
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

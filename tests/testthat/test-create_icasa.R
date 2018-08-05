
# test queries -----------------------------------------------------------------
context("Test that create_icasa creates a text file")
test_that("create_icasa stops if user specifies global coverage", {
  vcr::use_cassette("create_icasa_global_stop", {
    expect_error(
      create_icasa(
        lonlat = "global",
        dates = c("1983-01-01"),
        file_out = "icasa.txt",
        dsn = tmpdir()
      ), regexp = "*The `lonlat` must be numeric values.*"
    )
  })
})

test_that("create_icasa stops if user fails to specify dsn", {
  vcr::use_cassette("create_icasa_no_file_stop", {
    expect_error(
      create_icasa(
        lonlat = c(151.81, -27.48),
        dates = c("1983-01-01"),
        dsn = tmpdir()
      ), regexp = "*You must specify a file path and name where to save.*"
    )
  })
})

test_that("create_icasa stops if user fails to specify file name", {
  vcr::use_cassette("create_icasa_no_dsn_stop", {
    expect_error(
      create_icasa(
        lonlat = c(151.81, -27.48),
        dates = c("1983-01-01"),
        file_out = "icasa.txt",
      ), regexp = "*You must specify a file path and name where to save.*"
    )
  })
})

test_that("create_icasa creates a txt file with proper values", {
  vcr::use_cassette("create_icasa", {
    create_icasa(
      lonlat = c(151.81, -27.48),
      dates = c("1983-01-01"),
      file_out = "icasa.txt",
      dsn = tempdir()
    )
    icasa <- readLines(file.path(tempdir(), "icasa.txt"))
    expect_true(any(grepl("icasa.txt", list.files(tempdir()))))
    expect_equal(length(icasa), 16)
    expect_equal(nchar(icasa)[[1]], 47)
    expect_equal(nchar(icasa)[[16]], 73)
  })

})

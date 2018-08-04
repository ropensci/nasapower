
# test queries -----------------------------------------------------------------
context("Test that create_icasa creates an APSIM .met file")
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

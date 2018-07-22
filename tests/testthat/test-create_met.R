
# test queries -----------------------------------------------------------------
context("Test that create_met creates an APSIM .met file")
test_that("create_met stops if user specifies global coverage", {
  vcr::use_cassette("create_met_global_stop", {
    expect_error(
      power_query <- create_met(
        lonlat = "global",
        dates = c("1983-01-01")
      ), regexp = "*The `lonlat` must be numeric values.*"
    )
  })
})

test_that("create_met creates an S4 object for APSIM use", {
  vcr::use_cassette("create_met", {
    power_query <- create_met(lonlat = c(151.81, -27.48),
                              dates = c("1985-01-01", "1985-01-02"))

    power_query_slots <- c("const",
                           "lat",
                           "lon",
                           "tav",
                           "amp",
                           "units",
                           "data")

    data_names <- c("year",
                    "day",
                    "maxt",
                    "mint",
                    "radn",
                    "rain")

    expect_s4_class(power_query, "metFile")
    expect_equal(methods::slotNames(power_query),
                 power_query_slots)
    expect_equal(names(power_query@data), data_names)

    rm(power_query)
  })
})

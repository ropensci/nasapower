
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
                              dates = c("1985-01-01", "1985-12-31"))

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

test_that("get_power returns global AG data for climatology", {
  vcr::use_cassette("Global_AG", {
    power_query <- get_power(
      community = "AG",
      lonlat = "Global",
      pars =  "T2M",
      temporal_average = "Climatology"
    )

    expect_equal(nrow(power_query), 259200)
    expect_equal(power_query$PARAMETER[1], "T2M")
    expect_equal(power_query$LAT[259200], 89.75)
    expect_equal(power_query$LAT[1], -89.75)
    expect_equal(power_query$LON[259200], 179.75)
    expect_equal(power_query$LON[1], -179.75)
    expect_named(
      power_query,
      c(
        "LON",
        "LAT",
        "PARAMETER",
        "JAN",
        "FEB",
        "MAR",
        "APR",
        "MAY",
        "JUN",
        "JUL",
        "AUG",
        "SEP",
        "OCT",
        "NOV",
        "DEC",
        "ANN"
      )
    )
    rm(power_query)
  })
})

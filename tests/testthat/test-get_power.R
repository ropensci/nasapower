#
# test queries -----------------------------------------------------------------
context("Test that get_power queries the server and returns the proper
        requested data")
test_that("get_power returns daily point AG data", {
  vcr::use_cassette("SinglePoint_AG", {
    query <- get_power(
      community = "AG",
      latlon = c(-89.5, -179.5),
      pars =  c("T2M",
                "T2M_MIN",
                "T2M_MAX",
                "RH2M",
                "WS10M"),
      dates = c("1983-01-01"),
      temporal_average = "Daily"
    )

    expect_equal(query$LAT, -89.5)
    expect_equal(query$LON, -179.5)
    expect_equal(query$YEAR, 1983)
    expect_equal(query$DOY, "001")
    expect_equal(query$T2M, -25.24)
    expect_equal(query$T2M_MIN, -25.55)
    expect_equal(query$T2M_MAX, -24.9)
    expect_equal(query$RH2M, 73.92)
    expect_equal(query$WS10M, 2.14)
    rm(query)
  })
})

test_that("get_power returns daily regional AG data", {
  vcr::use_cassette("Regional_AG", {
    query <- get_power(
      community = "AG",
      latlon = c(-55.5, 112.5, -50.5, 115.5),
      pars =  "T2M",
      dates = c("1983-01-01"),
      temporal_average = "Daily"
    )

    expect_equal(nrow(query), 77)
    expect_equal(
      unique(query$LAT),
      c(
        -55.25,
        -54.75,
        -54.25,
        -53.75,
        -53.25,
        -52.75,
        -52.25,
        -51.75,
        -51.25,
        -50.75,
        -50.25
      )
    )
    expect_equal(unique(query$LON),
                 c(112.75, 113.25, 113.75, 114.25, 114.75, 115.25, 115.75))
    expect_equal(query$YEAR[1], 1983)
    expect_equal(query$DOY[1], "001")
    expect_equal(query$T2M[1], 3.28)
    rm(query)
  })
})

test_that("get_power returns global AG data for climatology", {
  vcr::use_cassette("Global_AG", {
    query <- get_power(
      community = "AG",
      latlon = "Global",
      pars =  "T2M",
      temporal_average = "Climatology"
    )

    expect_equal(nrow(query), 259200)
    expect_equal(query$PARAMETER[1], "T2M")
    expect_equal(query$LAT[259200], 89.75)
    expect_equal(query$LAT[1], -89.75)
    expect_equal(query$LON[259200], 179.75)
    expect_equal(query$LON[1], -179.75)
    expect_named(
      query,
      c(
        "LAT",
        "LON",
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
    rm(query)
  })
})
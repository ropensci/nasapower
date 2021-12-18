
# test queries using vcr -------------------------------------------------------
vcr::use_cassette("daily_ag_point", {
  test_that("get_power returns daily point ag data", {
    skip_on_cran()
    power_query <- get_power(
      community = "ag",
      lonlat = c(-179.5, -89.5),
      pars = c("T2M",
               "T2M_MIN",
               "T2M_MAX",
               "RH2M",
               "WS10M",
               "PS"),
      dates = c("1983-01-01"),
      temporal_api = "Daily"
    )

    expect_is(power_query, "data.frame")
    expect_equal(power_query$LAT, -89.5, tolerance = 1e-3)
    expect_equal(power_query$LON, -179.5, tolerance = 1e-3)
    expect_equal(power_query$YEAR, 1983)
    expect_equal(power_query$MM, 1)
    expect_equal(power_query$DD, 1)
    expect_equal(power_query$DOY, 1)
    expect_equal(power_query$YYYYMMDD, as.Date("1983-01-01"))
    expect_equal(power_query$T2M, -25.24)
    expect_equal(power_query$T2M_MIN, -25.67)
    expect_equal(power_query$T2M_MAX, -24.88)
    expect_equal(power_query$RH2M, 94.25)
    expect_equal(power_query$WS10M, 2.32)
    expect_equal(power_query$PS, 69.06)
    expect_named(
      power_query,
      c(
        "LON",
        "LAT",
        "YEAR",
        "MM",
        "DD",
        "DOY",
        "YYYYMMDD",
        "T2M",
        "T2M_MIN",
        "T2M_MAX",
        "RH2M",
        "WS10M",
        "PS"
      )
    )
  })
})


vcr::use_cassette("adjusted_air_pressure", {
  test_that("get_power() returns daily point ag data with adjusted atmospheric
          air pressure",
          {
            skip_on_cran()
            power_query <- get_power(
              community = "ag",
              lonlat = c(-179.5, -89.5),
              pars = c("T2M",
                       "T2M_MIN",
                       "T2M_MAX",
                       "RH2M",
                       "WS10M",
                       "PS"),
              dates = c("1983-01-01"),
              temporal_api = "Daily",
              site_elevation = 0
            )

            expect_is(power_query, "data.frame")
            expect_equal(power_query$LAT, -89.5, tolerance = 1e-3)
            expect_equal(power_query$LON, -179.5, tolerance = 1e-3)
            expect_equal(power_query$YEAR, 1983)
            expect_equal(power_query$MM, 1)
            expect_equal(power_query$DD, 1)
            expect_equal(power_query$DOY, 1)
            expect_equal(power_query$YYYYMMDD, as.Date("1983-01-01"))
            expect_equal(power_query$T2M, -25.24)
            expect_equal(power_query$T2M_MIN, -25.67)
            expect_equal(power_query$T2M_MAX, -24.88)
            expect_equal(power_query$RH2M, 94.25)
            expect_equal(power_query$WS10M, 2.32)
            expect_equal(power_query$PS, 69.06)
            expect_named(
              power_query,
              c(
                "LON",
                "LAT",
                "YEAR",
                "MM",
                "DD",
                "DOY",
                "YYYYMMDD",
                "T2M",
                "T2M_MIN",
                "T2M_MAX",
                "RH2M",
                "WS10M",
                "PS"
              )
            )
          })
})

vcr::use_cassette("daily_sb_point", {
  test_that("get_power returns daily point SB data", {
    skip_on_cran()
    power_query <- get_power(
      community = "sb",
      lonlat = c(-179.5, -89.5),
      pars = c("T2M",
               "T2M_MIN",
               "T2M_MAX",
               "RH2M",
               "WS10M"),
      dates = c("1983-01-01"),
      temporal_api = "Daily"
    )

    expect_is(power_query, "data.frame")
    expect_equal(power_query$LAT, -89.5, tolerance = 1e-3)
    expect_equal(power_query$LON, -179.5, tolerance = 1e-3)
    expect_equal(power_query$YEAR, 1983)
    expect_equal(power_query$MM, 1)
    expect_equal(power_query$DD, 1)
    expect_equal(power_query$DOY, 1)
    expect_equal(power_query$YYYYMMDD, as.Date("1983-01-01"))
    expect_equal(power_query$T2M, -25.24)
    expect_equal(power_query$T2M_MIN, -25.67)
    expect_equal(power_query$T2M_MAX, -24.88)
    expect_equal(power_query$RH2M, 94.25)
    expect_equal(power_query$WS10M, 2.32)
  })
})

test_that("get_power() returns daily regional ag data", {
  skip_on_cran()
  power_query <- get_power(
    community = "ag",
    lonlat = c(112.5, -55.5, 115.5, -50.5),
    pars = "T2M",
    dates = c("1983-01-01"),
    temporal_api = "Daily"
  )

  expect_equal(nrow(power_query), 60)
  expect_equal(
    unique(power_query$LAT),
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
      -50.75
    ),
    tolerance = 0.1
  )
  expect_equal(unique(power_query$LON),
               c(112.8,
                 113.2,
                 113.8,
                 114.2,
                 114.8,
                 115.2),
               tolerance = 0.1)
  expect_equal(power_query$YEAR[1], 1983)
  expect_equal(power_query$MM[1], 1)
  expect_equal(power_query$DD[1], 1)
  expect_equal(power_query$DOY[1], 1)
  expect_equal(power_query$YYYYMMDD[1], as.Date("1983-01-01"))
  expect_equal(power_query$DOY[1], 1)
  expect_equal(power_query$T2M[1], 3.28)
})

test_that("get_power() returns point ag data for climatology", {
  vcr::use_cassette("climatology_ag_point", {
    skip_on_cran()
    power_query <- get_power(
      community = "ag",
      pars = "T2M",
      temporal_api = "climatology",
      lonlat = c(-179.5, -89.5),
    )

    expect_equal(nrow(power_query), 1)
    expect_equal(power_query$PARAMETER[1], "T2M")
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
  })
})

# check for failure status
vcr::use_cassette("API_failure", {
  test_that("get_power() errors when the API doesn't behave", {
    skip_on_cran()
    vcr::skip_if_vcr_off()
    expect_error(
      get_power(
        community = "ag",
        lonlat = c(-179.5, -89.5),
        pars = c("T2M"),
        dates = c("1983-01-01"),
        temporal_api = "Daily"
      )
    )
  })
})

# test user input check response messages -----
test_that("get_power() stops if `temporal_api` not valid", {
  skip_on_cran()
  expect_error(
    power_query <- get_power(
      community = "ag",
      lonlat = c(-179.5, -89.5),
      pars = "T2M",
      dates = "1983-01-01",
      temporal_api = 1
    ),
    regexp = "You have entered an invalid value for `temporal_api`.\n"
  )
})

test_that("get_power() stops if hourly data are requested < 2001-01-01", {
  skip_on_cran()
  expect_error(
    power_query <- get_power(
      community = "ag",
      lonlat = c(-179.5, -89.5),
      pars = "T2M",
      dates = "1983-01-01",
      temporal_api = "hourly"
    ),
    regexp = "2001-01-01 is the earliest available hourly data*"
  )
})

test_that("get_power() stops if an invalid community supplied", {
  skip_on_cran()
  expect_error(
    power_query <- get_power(
      community = "rOpenSci",
      lonlat = "global",
      pars = "T2M",
      dates = "1983-01-01",
      temporal_api = "daily"
    ),
    regexp = "You have provided an invalid `community` value.\n"
  )
})

test_that("get_power() stops if site elevation is supplied not for point", {
  Sys.sleep(10)
  skip_on_cran()
  expect_message(
    power_query <- get_power(
      community = "ag",
      lonlat = c(112.5, -55.5, 115.5, -50.5),
      pars = "T2M",
      dates = "1983-01-01",
      temporal_api = "daily",
      site_elevation = 35
    ),
    regexp = "You have provided `site_elevation` for a region*."
  )
})

test_that("get_power() stops if site_elevation is invalid", {
  skip_on_cran()
  expect_error(
    power_query <- get_power(
      community = "ag",
      lonlat = c(112.5, -55.5),
      pars = "T2M",
      dates = "1983-01-01",
      temporal_api = "daily",
      site_elevation = "cartograph"
    ),
    regexp = "You have entered an invalid value for `site_elevation`*"
  )
})

test_that("get_power() stops wind_surface is supplied w/ no wind_elevation",
          {
            skip_on_cran()
            expect_error(
              power_query <- get_power(
                community = "ag",
                lonlat = c(112.5, -55.5),
                pars = "T2M",
                dates = "1983-01-01",
                temporal_api = "daily",
                wind_surface = "vegtype_6"
              ),
              regexp = "If you provide a correct wind surface alias*"
            )
          })

test_that("get_power() stops wind_elevation is invalid", {
  skip_on_cran()
  expect_error(
    power_query <- get_power(
      community = "ag",
      lonlat = c(112.5, -55.5),
      pars = "T2M",
      dates = "1983-01-01",
      temporal_api = "daily",
      wind_elevation = 5
    ),
    regexp = "`wind_elevation` values in metres are required to be between*"
  )
})

test_that("get_power() stops if `global` coverage is requested", {
  skip_on_cran()
  expect_error(
    power_query <- get_power(
      community = "ag",
      lonlat = "global",
      pars = "T2M",
      dates = "1983-01-01",
      temporal_api = "climatology"
    ),
    regexp = "The POWER team have not enabled `global` data queries with this*"
  )
})

test_that("get_power() stops if temporal_api is hourly and pars > 15", {
  skip_on_cran()
  expect_error(
    power_query <- get_power(
      community = "ag",
      lonlat = c(112.5, -55.5),
      pars = c(
        "T2M",
        "DIRECT_ILLUMINANCE",
        "CLRSKY_SRF_ALB",
        "RH2M",
        "WS10M",
        "PS",
        "PRECTOTCORR",
        "CLRSKY_SFC_SW_DNI",
        "CLRSKY_SFC_SW_DIRH",
        "CLRSKY_SFC_PAR_TOT",
        "ALLSKY_SFC_UVB",
        "ALLSKY_SFC_UVA",
        "ZENITH_LUMINANCE",
        "TOA_SW_DWN",
        "SZA",
        "PW",
        "DIRECT_ILLUMINANCE"
      ),
      dates = "1983-01-01",
      temporal_api = "hourly"
    ),
    regexp = ""
  )
})

vcr::use_cassette("temporal_api-warning", {
  test_that("get_power() gives warning if `temporal_average` is used", {
    skip_on_cran()
    expect_warning(
      power_query <- get_power(
        community = "ag",
        lonlat = c(-179.5, -89.5),
        pars = "T2M",
        dates = "1983-01-01",
        temporal_average = "daily"
      ),
      regexp = "`temporal_average has been deprecated for `temporal_api`*"
    )
  })
})

test_that("get_power() stops if there is no temporal_api()", {
  skip_on_cran()
  expect_error(
    power_query <- get_power(
      community = "ag",
      lonlat = c(-179.5, -89.5),
      pars = "T2M",
      dates = "1983-01-01"
    ),
    regexp = "You must provide a `temporal_api` value."
  )
})

test_that("get_power() stops if global lonlat is set", {
  skip_on_cran()
  expect_error(
    power_query <- get_power(
      community = "ag",
      lonlat = "global",
      pars = "T2M",
      dates = "1983-01-01",
      temporal_api = "daily"
    ),
    regexp = "The POWER team have not enabled `global` data queries with *"
  )
})

test_that("get_power() stops if lonlat = is invalid", {
  skip_on_cran()
  expect_error(
    power_query <- get_power(
      community = "ag",
      lonlat = "x",
      pars = "T2M",
      dates = "1983-01-01",
      temporal_api = "daily"
    ),
    regexp = "You have entered an invalid value for `lonlat`. *"
  )
})

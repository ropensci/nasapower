
# test queries using vcr -------------------------------------------------------
test_that("get_power() returns daily point ag data", {
  skip_if_offline()
  vcr::use_cassette("daily_ag_point", {
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
      time_standard = "UTC"
    )
  })

  expect_is(power_query, "data.frame")
  expect_equal(power_query$LAT, -89.5, tolerance = 1e-3)
  expect_equal(power_query$LON, -179.5, tolerance = 1e-3)
  expect_equal(power_query$YEAR, 1983)
  expect_equal(power_query$MM, 1)
  expect_equal(power_query$DD, 1)
  expect_equal(power_query$DOY, 1)
  expect_equal(power_query$YYYYMMDD, as.Date("1983-01-01"))
  expect_equal(power_query$T2M, -24.4, tolerance = 1e-2)
  expect_equal(power_query$T2M_MIN, -25.4, tolerance = 1e-2)
  expect_equal(power_query$T2M_MAX, -22.7, tolerance = 1e-2)
  expect_equal(power_query$RH2M, 92.4, tolerance = 1e-2)
  expect_equal(power_query$WS10M, 1.93, tolerance = 1e-2)
  expect_equal(power_query$PS, 69.2, tolerance = 1e-2)
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

test_that("get_power() returns daily point ag data with adjusted atmospheric
          air pressure",
  {
    skip_if_offline()
    vcr::use_cassette("adjusted_air_pressure", {
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
        site_elevation = 0,
        time_standard = "UTC"
      )
    })

    expect_is(power_query, "data.frame")
    expect_equal(power_query$LAT, -89.5, tolerance = 1e-3)
    expect_equal(power_query$LON, -179.5, tolerance = 1e-3)
    expect_equal(power_query$YEAR, 1983)
    expect_equal(power_query$MM, 1)
    expect_equal(power_query$DD, 1)
    expect_equal(power_query$DOY, 1)
    expect_equal(power_query$YYYYMMDD, as.Date("1983-01-01"))
    expect_equal(power_query$T2M, -24.4, tolerance = 1e-2)
    expect_equal(power_query$T2M_MIN, -25.4, tolerance = 1e-2)
    expect_equal(power_query$T2M_MAX, -22.7, tolerance = 1e-2)
    expect_equal(power_query$RH2M, 92.4, tolerance = 1e-2)
    expect_equal(power_query$WS10M, 1.93, tolerance = 1e-2)
    expect_equal(power_query$PS, 69.2, tolerance = 1e-2)
    expect_equal(power_query$PSC, 101, tolerance = 1e-2)
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
        "PS",
        "PSC"
      )
    )
  })

test_that("get_power() returns daily point ag data with adjusted wind
          elevation",
  {
    skip_if_offline()
    vcr::use_cassette("adjusted_wind_elevation", {
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
        wind_elevation = 300,
        wind_surface = "vegtype_1",
        time_standard = "UTC"
      )
    })

    expect_is(power_query, "data.frame")
    expect_equal(power_query$LAT, -89.5, tolerance = 1e-3)
    expect_equal(power_query$LON, -179.5, tolerance = 1e-3)
    expect_equal(power_query$YEAR, 1983)
    expect_equal(power_query$MM, 1)
    expect_equal(power_query$DD, 1)
    expect_equal(power_query$DOY, 1)
    expect_equal(power_query$YYYYMMDD, as.Date("1983-01-01"))
    expect_equal(power_query$T2M, -24.4, tolerance = 1e-2)
    expect_equal(power_query$T2M_MIN, -25.4, tolerance = 1e-2)
    expect_equal(power_query$T2M_MAX, -22.7, tolerance = 1e-2)
    expect_equal(power_query$RH2M, 92.4, tolerance = 1e-2)
    expect_equal(power_query$WS10M, 1.93, tolerance = 1e-2)
    expect_equal(power_query$PS, 69.06, tolerance = 1e-2)
    expect_equal(power_query$WSC, 6.49, tolerance = 1e-2)
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
        "PS",
        "WSC"
      )
    )
  })


test_that("get_power() returns daily point SB data", {
  skip_if_offline()
  vcr::use_cassette("daily_sb_point_UTC", {
    power_query <- get_power(
      community = "sb",
      lonlat = c(-179.5, -89.5),
      pars = c("T2M",
        "T2M_MIN",
        "T2M_MAX",
        "RH2M",
        "WS10M"),
      dates = c("1983-01-01"),
      temporal_api = "Daily",
      time_standard = "UTC"
    )
  })

  expect_is(power_query, "data.frame")
  expect_equal(power_query$LAT, -89.5, tolerance = 1e-3)
  expect_equal(power_query$LON, -179.5, tolerance = 1e-3)
  expect_equal(power_query$YEAR, 1983)
  expect_equal(power_query$MM, 1)
  expect_equal(power_query$DD, 1)
  expect_equal(power_query$DOY, 1)
  expect_equal(power_query$YYYYMMDD, as.Date("1983-01-01"))
  expect_equal(power_query$T2M, -24.4, tolerance = 1e-2)
  expect_equal(power_query$T2M_MIN, -25.4, tolerance = 1e-2)
  expect_equal(power_query$T2M_MAX, -22.7, tolerance = 1e-2)
  expect_equal(power_query$RH2M, 92.4, tolerance = 1e-2)
  expect_equal(power_query$WS10M, 1.93,  tolerance = 1e-2)
})

test_that("get_power() returns daily point SB data for LST", {
  skip_if_offline()
  vcr::use_cassette("daily_sb_point_LST", {
    power_query <- get_power(
      community = "sb",
      lonlat = c(-179.5, -89.5),
      pars = c("T2M",
        "T2M_MIN",
        "T2M_MAX",
        "RH2M",
        "WS10M"),
      dates = c("1983-01-01"),
      temporal_api = "Daily",
      time_standard = "LST"
    )
  })

  expect_is(power_query, "data.frame")
  expect_equal(power_query$LAT, -89.5, tolerance = 1e-3)
  expect_equal(power_query$LON, -179.5, tolerance = 1e-3)
  expect_equal(power_query$YEAR, 1983)
  expect_equal(power_query$MM, 1)
  expect_equal(power_query$DD, 1)
  expect_equal(power_query$DOY, 1)
  expect_equal(power_query$YYYYMMDD, as.Date("1983-01-01"))
  expect_equal(power_query$T2M, -25.2, tolerance = 1e-2)
  expect_equal(power_query$T2M_MIN, -25.7, tolerance = 1e-2)
  expect_equal(power_query$T2M_MAX, -24.9, tolerance = 1e-2)
  expect_equal(power_query$RH2M, 94.2, tolerance = 1e-2)
  expect_equal(power_query$WS10M, 2.32,  tolerance = 1e-2)
})

test_that("get_power() returns daily regional ag data", {
  skip_if_offline()
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
  skip_if_offline()
  vcr::use_cassette("climatology_ag_point", {
    power_query <- get_power(
      community = "ag",
      pars = "T2M",
      temporal_api = "climatology",
      lonlat = c(-179.5, -89.5),
    )
  })

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


# test user input check response messages -----
test_that("get_power() stops if `temporal_api` not valid", {
  skip_if_offline()
  expect_error(
    get_power(
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
  skip_if_offline()
  expect_error(
    get_power(
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
  skip_if_offline()
  expect_error(
    get_power(
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
  skip_if_offline()
  expect_message(
    get_power(
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
  skip_if_offline()
  expect_error(
    get_power(
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
    skip_if_offline()
    expect_error(
      get_power(
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
  skip_if_offline()
  expect_error(
    get_power(
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

test_that("get_power() ignores wind_elevation for regional requests", {
  skip_if_offline()
  expect_message(
    get_power(
      community = "ag",
      lonlat = c(112.5, -55.5, 115.5, -50.5),
      pars = "T2M",
      dates = "1983-01-01",
      temporal_api = "daily",
      wind_elevation = 15
    ),
    regexp = "You have provided `wind_elevation` for a region request.*"
  )
})

test_that("get_power() stops if `global` coverage is requested", {
  skip_if_offline()
  expect_error(
    get_power(
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
  skip_if_offline()
  expect_error(
    get_power(
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
        "WSC",
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
    regexp = "A maximum of 15 parameters can currently be requested*"
  )
})


test_that("get_power() gives warning if `temporal_average` is used", {
  skip_if_offline()
  vcr::use_cassette("temporal_api-warning", {
    expect_warning(
      get_power(
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
  skip_if_offline()
  expect_error(
    get_power(
      community = "ag",
      lonlat = c(-179.5, -89.5),
      pars = "T2M",
      dates = "1983-01-01"
    ),
    regexp = "You must provide a `temporal_api` value."
  )
})

test_that("get_power() stops if global lonlat is set", {
  skip_if_offline()
  expect_error(
    get_power(
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
  skip_if_offline()
  expect_error(
    get_power(
      community = "ag",
      lonlat = "x",
      pars = "T2M",
      dates = "1983-01-01",
      temporal_api = "daily"
    ),
    regexp = "You have entered an invalid value for `lonlat`. *"
  )
})

test_that("get_power() stops if lonlat = is invalid for climatology", {
  skip_if_offline()
  expect_error(
    get_power(
      community = "ag",
      lonlat = "global",
      pars = "T2M",
      dates = "1983-01-01",
      temporal_api = "climatology"
    ),
    regexp = "The POWER team have not enabled `global`*"
  )
})

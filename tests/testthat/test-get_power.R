
# test queries -----------------------------------------------------------------
context("get_power() ag Community")
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
  rm(power_query)
})

test_that("get_power() returns daily point ag data with adjusted atmospheric
          air pressure", {
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
            rm(power_query)
          })

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
  expect_equal(power_query$T2M_MIN, -25.55)
  expect_equal(power_query$T2M_MAX, -24.9)
  expect_equal(power_query$RH2M, 73.92)
  expect_equal(power_query$WS10M, 2.14)
  rm(power_query)
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

  expect_equal(nrow(power_query), 77)
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
      -50.75,
      -50.25
    )
  )
  expect_equal(unique(power_query$LON),
               c(112.75, 113.25, 113.75, 114.25, 114.75, 115.25, 115.75))
  expect_equal(power_query$YEAR[1], 1983)
  expect_equal(power_query$MM[1], 1)
  expect_equal(power_query$DD[1], 1)
  expect_equal(power_query$DOY[1], 1)
  expect_equal(power_query$YYYYMMDD[1], as.Date("1983-01-01"))
  expect_equal(power_query$DOY[1], 1)
  expect_equal(power_query$T2M[1], 3.28)
  rm(power_query)
})

test_that("get_power() returns global ag data for climatology", {
  skip_on_cran()
  power_query <- get_power(
    community = "ag",
    pars = "T2M",
    temporal_api = "climatology",
    lonlat = "global"
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

test_that("get_power() stops if `temporal_api` not valid", {
  expect_error(
    power_query <- get_power(
      community = "ag",
      lonlat = c(-179.5, -89.5),
      pars = "T2M",
      dates = "1983-01-01",
      temporal_api = 1
    ),
    regexp = "\nYou have entered an invalid value for `temporal_api`.\n"
  )
})

test_that("get_power() stops if `temporal_api` != climatology
          when lonlat == global", {
            expect_error(
              power_query <- get_power(
                community = "ag",
                lonlat = "global",
                pars = "T2M",
                dates = "1983-01-01",
                temporal_api = "daily"
              ),
              regexp = "\nYou have asked for 'global' data. However, this"
            )
          })

test_that("get_power() stops if lonlat is char and != global", {
  expect_error(
    power_query <- get_power(
      community = "ag",
      lonlat = "test",
      pars = "T2M",
      dates = "1983-01-01",
      temporal_api = "climatology"
    ),
    regexp = "\nYou have entered an invalid value for `lonlat`. Valid values"
  )
})


# Date handling and checking ---------------------------------------------------
test_that("Missing `dates` are properly handled", {
  temporal_api <- "daily"
  dates <- NULL
  lonlat <- c(-179.5, -89.5)
  site_elevation <- NULL
  expect_error(.check_dates(dates, lonlat, temporal_api))
})

test_that("`dates` with one value set one day query", {
  temporal_api <- "daily"
  dates <- "1983-01-01"
  lonlat <- c(-179.5, -89.5)
  site_elevation <- NULL
  dates <- .check_dates(dates, lonlat, temporal_api)
  expect_equal(dates[1], "19830101")
  expect_equal(dates[2], "19830101")
})

test_that("`dates` > 2 cause an error", {
  temporal_api <- "daily"
  dates <- c("1983-01-01", "1983-01-02", "1983-01-03")
  lonlat <- c(-179.5, -89.5)
  site_elevation <- NULL
  expect_error(.check_dates(dates, lonlat, temporal_api),
               regexp =
                 "You have supplied more than two dates for start and end*")
})

test_that("`dates` entered in incorrect formats are corrected", {
  temporal_api <- "daily"
  dates <- "01-01-1983"
  lonlat <- c(-179.5, -89.5)
  site_elevation <- NULL
  dates <- .check_dates(dates, lonlat, temporal_api)
  expect_equal(dates[1], "19830101")

  dates <- "Jan-01-1983"
  dates <- .check_dates(dates, lonlat, temporal_api)
  expect_equal(dates[1], "19830101")
})

test_that("daily `dates` entered in reverse order are corrected", {
  temporal_api <- "daily"
  today <- as.character(Sys.Date())
  dates <- c(today, "1983-01-01")
  lonlat <- c(-179.5, -89.5)
  site_elevation <- NULL
  expect_message(.check_dates(dates, lonlat, temporal_api),
                 regexp = "*Your start and end dates were reversed.*")
})

test_that("monthly `dates` entered in reverse order are corrected", {
  temporal_api <- "monthly"
  today <- as.character(Sys.Date())
  dates <- c(today, "1983-01-01")
  lonlat <- c(-179.5, -89.5)
  site_elevation <- NULL
  expect_message(.check_dates(dates, lonlat, temporal_api),
                 regexp = "*Your start and end dates were reversed.*")
})

test_that("`dates` before the start of POWER data cause error", {
  temporal_api <- "daily"
  today <- as.character(Sys.Date())
  dates <- c("1979-12-31", today)
  lonlat <- c(-179.5, -89.5)
  site_elevation <- NULL
  expect_error(.check_dates(dates, lonlat, temporal_api),
               regexp = "*1981-01-01 is the earliest available data from*")
})

test_that("`dates` after today POWER cause error", {
  temporal_api <- "daily"
  tomorrow <- as.character(Sys.Date() + 1)
  lonlat <- c(-179.5, -89.5)
  site_elevation <- NULL
  expect_error(.check_dates(tomorrow, lonlat, temporal_api),
               regexp = "The weather data cannot possibly extend beyond*")
})

test_that("Invalid `dates` are handled", {
  temporal_api <- "daily"
  dates <- c("1983-01-01", "1983-02-31")
  lonlat <- c(-179.5, -89.5)
  site_elevation <- NULL
  expect_error(.check_dates(dates, lonlat, temporal_api),
               regexp = "*1983-02-31 is not a valid entry for date.*")
})

test_that("Dates are returned as a vector of characters", {
  temporal_api <- "daily"
  dates <- c("1983-01-01", "1983-02-02")
  lonlat <- c(-179.5, -89.5)
  site_elevation <- NULL
  dates <- .check_dates(dates, lonlat, temporal_api)
  expect_is(dates, "character")
})

test_that(
  "If temporal_api == monthly and dates are specified, that only years
  are returned", {
    temporal_api <- "monthly"
    dates <- c("1983-01-01", "1984-01-01")
    lonlat <- c(-179.5, -89.5)
    site_elevation <- NULL
    dates <- .check_dates(dates, lonlat, temporal_api)
    expect_equal(nchar(dates[1]), 4)
  }
)

test_that("If temporal_api == monthly and <2 dates provided, error", {
            temporal_api <- "monthly"
            dates <- c("1983-01-01")
            lonlat <- c(-179.5, -89.5)
            site_elevation <- NULL
            expect_error(.check_dates(dates, lonlat, temporal_api),
                         regexp = "*For `temporal_api = monthly`, *")
          })


# community checks -------------------------------------------------------------
test_that(".check_community() properly reports errors", {
  community <- "R"
  pars <- c(
    "ALLSKY_SFC_SW_DWN_03_GMT",
    "ALLSKY_SFC_LW_DWN",
    "ALLSKY_SFC_SW_DWN_06_GMT",
    "RH2M"
  )
  expect_error(.check_community(community, pars))
})

# lonlat checks ----------------------------------------------------------------
test_that(".check_lonlat() properly reports errors", {
  # set up pars argument for testing
  pars <- "T2M"

  # out-of-scope latitude for singlePoint
  lonlat <- c(-27.5, 151.5)
  expect_error(.check_lonlat(lonlat, pars))

  # out-of-scope longitude for singlePoint
  lonlat <- c(0, 181)
  expect_error(.check_lonlat(lonlat, pars))

  # non-numeric values for singlePoint
  lonlat <- c("x", 181)
  expect_error(.check_lonlat(lonlat, pars))

  # out-of-scope latitude for regional
  lonlat <- c(-90, 90, -181, 181)
  expect_error(.check_lonlat(lonlat, pars))

  # out-of-scope longitude for regional
  lonlat <- c(-91, 91, -180, 180)
  expect_error(.check_lonlat(lonlat, pars))

  # incorrect orders for regional
  lonlat <- c(-91, 91, -180, 180)
  expect_error(.check_lonlat(lonlat, pars))

  # non-numeric values for regional
  lonlat <- c(112.91972, -55.11694, "x", 159.256088)
  expect_error(.check_lonlat(lonlat, pars))

  # incorrect order of values requested for regional
  lonlat <- c(-90, 90, 180, -180)
  expect_error(.check_lonlat(lonlat, pars))

  lonlat <- c(90, -90, -180, 180)
  expect_error(.check_lonlat(lonlat, pars))

  # invalid lonlat value
  lonlat <- "x"
  expect_error(.check_lonlat(lonlat, pars))
})

test_that(".check_lonlat() handles single point properly", {
  temporal_api <- "daily"
  test <- .check_lonlat(lonlat = c(-179.5, -89.5),
                        pars)
  expect_equal(test$lon, -179.5)
  expect_equal(test$lat, -89.5)
  expect_equal(test$identifier, "point")
})

test_that(".check_lonlat() checks validity of single lon values", {
  temporal_api <- "daily"
  expect_error(.check_lonlat(lonlat = c(179.5, 91),
                             pars),
               regexp = "Please check your latitude, `91`,*")
})

test_that(".check_lonlat() checks validity of single lat values", {
  temporal_api <- "daily"
  expect_error(.check_lonlat(lonlat = c(182, 90),
                             pars),
               regexp = "Please check your longitude, `182`,*")
})

# bbox checks ------------------------------------------------------------------
test_that(".check_lonlat() handles bboxes that are too large", {
  temporal_api <- "daily"
  expect_error(.check_lonlat(lonlat = c(-179.5, -89.5, 179.5, 89.5),
                             pars),
               regexp = "Please provide correct bounding box values*")
})

test_that(".check_lonlat() checks order of the latitude values", {
  temporal_api <- "daily"
  expect_error(.check_lonlat(lonlat = c(-179.5, 89.5, 179.5, -89.5),
                             pars),
               regexp = "The first `lat` value must be the minimum value.\n")
})

test_that(".check_lonlat() checks order of the longitude values", {
  temporal_api <- "daily"
  expect_error(.check_lonlat(lonlat = c(179.5, -89.5, -179.5, 89.5),
                             pars),
               regexp = "The first `lon` value must be the minimum value.\n")
})

test_that(".check_lonlat() checks validity of bbox latmin values", {
  temporal_api <- "daily"
  expect_error(.check_lonlat(lonlat = c(-179.5, 91, -179.5, 90),
                             pars),
               regexp = "Please check your latitude, `91`, `90`*")
})

test_that(".check_lonlat() checks validity of bbox latmax values", {
  temporal_api <- "daily"
  expect_error(.check_lonlat(lonlat = c(-179.5, 90, -179.5, 93),
                             pars),
               regexp = "Please check your latitude, `90`, `93`,*")
})

test_that(".check_lonlat() checks validity of bbox lonmin values", {
  temporal_api <- "daily"
  expect_error(.check_lonlat(lonlat = c(-181.5, 89.5, -179.5, 89.5),
                             pars),
               regexp = "Please check your longitude, `-181.5`, `-179.5`*")
})

test_that(".check_lonlat() checks validity of bbox lonmax values", {
  temporal_api <- "daily"
  expect_error(.check_lonlat(lonlat = c(-179.5, 89.5, 181, 89.5),
                             pars),
               regexp = "Please check your longitude, `-179.5`, `181`,*")
})

test_that(
  ".check_lonlat() returns message with proper identifier when valid
          coordinates are given", {
    temporal_api <- "daily"
    test <- .check_lonlat(lonlat = c(-179.5,
                                     88.5,
                                     -179.5,
                                     89.5),
                          pars)
    expect_named(test$bbox, c("xmin", "ymin", "xmax", "ymax"))
    expect_equal(test$identifier, "regional")
  }
)


# parameter checks -------------------------------------------------------------
test_that(".check_pars() stops if no `pars` provided", {
  temporal_api <- "daily"
  community <- "ag"

  expect_error(.check_pars(temporal_api,
                           community,
                           pars))
})

test_that(".check_pars()  stops if no `temporal_api` provided", {
  pars <- "AG"
  community <- "ag"

  expect_error(.check_pars(temporal_api,
                           community,
                           pars))
})

test_that(".check_pars()  stops if `pars` not valid", {
  pars <- "asdflkuewr"
  temporal_api <- "daily"
  community <- "ag"

  expect_error(.check_pars(pars,
                           community,
                           temporal_api))
})

test_that(".check_pars()  stops if `pars` not valid for given
          temporal_api", {
            pars <- "ALLSKY_SFC_SW_DWN_03_GMT"
            temporal_api <- "monthly"
            lonlat <- c(-179.5, -89.5)
            community <- "ag"

            expect_error(.check_pars(pars,
                                     community,
                                     temporal_api))
          })

test_that("pars are returned as a comma separated string with no spaces", {
  pars <- c("RH2M", "T2M")
  temporal_api <- "climatology"
  community <- "ag"

  pars <- .check_pars(pars,
                      community,
                      temporal_api)
  expect_equal(nchar(pars), 8)
  expect_equal(pars, "RH2M,T2M")
})

test_that("Only 20 pars are allowed when `temporal_api` != climatology", {
            pars <- c(
              "Z0M",
              "CLRSKY_SFC_SW_DNI",
              "CDD0",
              "CDD10",
              "CDD18_3",
              "FROST_DAYS",
              "HDD0",
              "HDD10",
              "HDD18_3",
              "AIRMASS",
              "WSC",
              "PRECTOTCORR",
              "PS",
              "QV2M",
              "RH2M",
              "T10M",
              "T10M_MAX",
              "T10M_MIN",
              "T10M_RANGE",
              "T2M_RANGE",
              "T2M_MIN",
              "T2M_MAX"
            )
            temporal_api <- "daily"
            lonlat <- c(-179.5, -89.5)
            expect_error(
              pars <- .check_pars(pars, community = "ag", temporal_api),
              regexp <- "A maximum of 20 parameters can currently be requested*"
            )
          })

test_that("Only unique `pars` are queried", {
  pars <- c("RH2M",
            "RH2M",
            "RH2M")
  temporal_api <- "climatology"
  community <- "ag"
  pars <- .check_pars(pars, community, temporal_api)
  expect_equal(pars[[1]], "RH2M")
  expect_equal(length(pars[[1]]), 1)
})

test_that("If an invalid temporal average is given for `pars`,
          an error occurs", {
            pars <- "ALLSKY_SFC_SW_DWN_00_GMT"
            temporal_api <- "daily"
            community <- "ag"

            expect_error(.check_pars(pars, community, temporal_api))
          })

# query constructs -------------------------------------------------------------
test_that(".build_query assembles a proper query for single point and != NULL
          dates", {
            temporal_api <- "daily"
            dates <- c("1983-01-01", "1983-02-02")
            lonlat <- c(-179.5, -89.5)
            site_elevation <- 50
            community <- "ag"
            pars <- "T2M"
            site_elevation <- NULL
            wind_elevation <- NULL
            wind_surface <- NULL
            time_standard = "UTC"

            dates <- .check_dates(dates,
                                  lonlat,
                                  temporal_api)
            pars <- .check_pars(pars,
                                community,
                                temporal_api)
            lonlat_identifier <- .check_lonlat(lonlat,
                                               pars)
            user_agent <- "nasapower"

            query_list <- .build_query(community,
                                       lonlat_identifier,
                                       pars,
                                       dates,
                                       site_elevation,
                                       wind_elevation,
                                       wind_surface,
                                       time_standard)

            expect_named(
              query_list,
              c(
                "parameters",
                "community",
                "start",
                "end",
                "longitude",
                "latitude",
                "format",
                "time-standard",
                "user"
              )
            )
          })


test_that(".build_query assembles a proper query for single point and NULL
          dates", {
            temporal_api <- "climatology"
            dates <- NULL
            lonlat <- c(-179.5, -89.5)
            site_elevation <- NULL
            community <- "ag"
            pars <- "T2M"
            site_elevation <- NULL
            wind_elevation <- NULL
            wind_surface <- NULL
            time_standard = "UTC"

            dates <- .check_dates(dates,
                                  lonlat,
                                  temporal_api)
            pars <- .check_pars(pars,
                                community,
                                temporal_api)
            lonlat_identifier <- .check_lonlat(lonlat,
                                               pars)
            user_agent <- "nasapower"

            query_list <- .build_query(community,
                                       lonlat_identifier,
                                       pars,
                                       dates,
                                       site_elevation,
                                       wind_elevation,
                                       wind_surface,
                                       time_standard)

            expect_named(
              query_list,
              c(
                "parameters",
                "community",
                "longitude",
                "latitude",
                "format",
                "time-standard",
                "user"
              )
            )
          })

test_that(".build_query assembles a proper query for regional and != NULL
          dates", {
            temporal_api <- "daily"
            dates <- c("1983-01-01", "1983-02-02")
            lonlat <- c(112.5, -55.5, 115.5, -50.5)
            site_elevation <- NULL
            community <- "ag"
            pars <- "T2M"
            site_elevation <- NULL
            wind_elevation <- NULL
            wind_surface <- NULL
            time_standard = "UTC"

            dates <- .check_dates(dates,
                                  community,
                                  temporal_api)
            pars <- .check_pars(pars,
                                community,
                                temporal_api)
            lonlat_identifier <- .check_lonlat(lonlat,
                                               pars)
            user_agent <- "nasapower"

            query_list <- .build_query(community,
                                       lonlat_identifier,
                                       pars,
                                       dates,
                                       site_elevation,
                                       wind_elevation,
                                       wind_surface,
                                       time_standard)

            expect_named(
              query_list,
              c(
                "parameters",
                "community",
                "latitude-min",
                "latitude-max",
                "longitude-min",
                "longitude-max",
                "format",
                "time-standard",
                "user"
              )
            )
          })

test_that(".build_query assembles a proper query for regional and NULL dates", {
            temporal_api <- "climatology"
            dates <- NULL
            lonlat <- c(112.5, -55.5, 115.5, -50.5)
            site_elevation <- NULL
            community <- "ag"
            pars <- "T2M"

            dates <- .check_dates(dates,
                                  lonlat,
                                  temporal_api)
            pars <- .check_pars(pars,
                                community,
                                temporal_api)
            lonlat_identifier <- .check_lonlat(lonlat,
                                               pars)
            user_agent <- "nasapower"
            time_standard = "UTC"

            query_list <- .build_query(community,
                                       lonlat_identifier,
                                       pars,
                                       dates,
                                       site_elevation,
                                       wind_elevation,
                                       wind_surface,
                                       time_standard)

            expect_named(
              query_list,
              c(
                "parameters",
                "community",
                "latitude-min",
                "latitude-max",
                "longitude-min",
                "longitude-max",
                "format",
                "time-standard",
                "user"
              )
            )
          })

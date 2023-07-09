
#' Get NASA POWER Data From the POWER API
#'
#' @description Get \acronym{POWER} global meteorology and surface solar energy
#'   climatology data and return a tidy data frame [tibble::tibble()]
#'   object.  All options offered by the official \acronym{POWER} \acronym{API}
#'   are supported.  Requests are formed to submit one request per point.
#'   There is no need to make synchronous requests for multiple parameters for
#'   a single point or regional request.  See section on \dQuote{Rate Limiting}
#'   for more.
#'
#' @param community A character vector providing community name: \dQuote{ag},
#'   \dQuote{re} or \dQuote{sb}.  See argument details for more.
#' @param pars A character vector of solar, meteorological or climatology
#'   parameters to download.  When requesting a single point of x, y
#'   coordinates, a maximum of twenty (20) `pars` can be specified at one time,
#'   for \dQuote{daily}, \dQuote{monthly} and \dQuote{climatology}
#'   `temporal_api`s.  If the `temporal_api` is specified as \dQuote{hourly}
#'   only 15 `pars` can be specified in a single query.  See `temporal_api` for
#'   more.
#' @param temporal_api Temporal \acronym{API} end-point for data being queried,
#'   supported values are \dQuote{hourly}, \dQuote{daily}, \dQuote{monthly} or
#'   \dQuote{climatology}.  See argument details for more.
#' @param lonlat A numeric vector of geographic coordinates for a cell or region
#'   entered as x, y coordinates.  See argument details for more.
#' @param dates A character vector of start and end dates in that order,\cr
#'   _e.g._, `dates = c("1983-01-01", "2017-12-31")`.
#'   Not used when\cr `temporal_api` is set to \dQuote{climatology}.
#'   See argument details for more.
#' @param site_elevation A user-supplied value for elevation at a single point
#'   in metres.  If provided this will return a corrected atmospheric pressure
#'   value adjusted to the elevation provided.  Only used with `lonlat` as a
#'   single point of x, y coordinates, not for use with \dQuote{global} or with
#'   a regional request.
#' @param wind_elevation A user-supplied value for elevation at a single point
#'   in metres.  Wind Elevation values in Meters are required to be between 10m
#'   and 300m.  Only used with `lonlat` as a single point of x, y coordinates,
#'   not for use with \dQuote{global} or with a regional request.  If this
#'   parameter is provided, the `wind-surface` parameter is required with the
#'   request, see
#'    <https://power.larc.nasa.gov/docs/methodology/meteorology/wind/>.
#' @param wind_surface A user-supplied wind surface for which the corrected
#'   wind-speed is to be supplied.  See `wind-surface` section for more detail.
#' @param temporal_average Deprecated. This argument has been superseded by
#'   `temporal_api` to align with the new \acronym{POWER} \acronym{API}
#'   terminology.
#' @param time_standard \acronym{POWER} provides two different time standards:
#'    * Universal Time Coordinated (\acronym{UTC}): is the standard time measure
#'     that used by the world.
#'    * Local Solar Time (\acronym{LST}): A 15 degree swath that represents
#'     solar noon at the middle longitude of the swath.
#'    Defaults to `LST`.
#'
#' @section Argument details for \dQuote{community}: There are three valid
#'   values, one must be supplied. This  will affect the units of the parameter
#'   and the temporal display of time series data.
#'
#' \describe{
#'   \item{ag}{Provides access to the Agroclimatology Archive, which
#'  contains industry-friendly parameters formatted for input to crop models.}
#'
#'  \item{sb}{Provides access to the Sustainable Buildings Archive, which
#'  contains industry-friendly parameters for the buildings community to include
#'  parameters in multi-year monthly averages.}
#'
#'  \item{re}{Provides access to the Renewable Energy Archive, which contains
#'  parameters specifically tailored to assist in the design of solar and wind
#'  powered renewable energy systems.}
#'  }
#'
#' @section Argument details for `temporal_api`: There are four valid values.
#'  \describe{
#'   \item{hourly}{The hourly average of `pars` by hour, day, month and year,
#'   the time zone is LST by default.}
#'   \item{daily}{The daily average of `pars` by day, month and year.}
#'   \item{monthly}{The monthly average of `pars` by month and year.}
#'   \item{climatology}{Provide parameters as 22-year climatologies (solar)
#'    and 30-year climatologies (meteorology); the period climatology and
#'    monthly average, maximum, and/or minimum values.}
#'  }
#'
#' @section Argument details for `lonlat`:
#' \describe{
#'  \item{For a single point}{To get a specific cell, 1/2 x 1/2 degree, supply a
#'  length-two numeric vector giving the decimal degree longitude and latitude
#'  in that order for data to download,\cr
#'  _e.g._, `lonlat = c(-179.5, -89.5)`.}
#'
#'  \item{For regional coverage}{To get a region, supply a length-four numeric
#'  vector as lower left (lon, lat) and upper right (lon, lat) coordinates,
#'  _e.g._, `lonlat = c(xmin, ymin, xmax, ymax)` in that order for a
#'  given region, _e.g._, a bounding box for the south western corner of
#'  Australia: `lonlat = c(112.5, -55.5, 115.5, -50.5)`.  *Maximum area
#'  processed is 4.5 x 4.5 degrees (100 points).}
#'
#'  \item{For global coverage}{To get global coverage for \dQuote{climatology},
#'  supply \dQuote{global} while also specifying \dQuote{climatology} for the
#'  `temporal_api`.}
#' }
#'
#' @section Argument details for `dates`: if one date only is provided, it
#'   will be treated as both the start date and the end date and only a single
#'   day's values will be returned, _e.g._, `dates = "1983-01-01"`.  When
#'   `temporal_api` is set to \dQuote{monthly}, use only two year values (YYYY),
#'   _e.g._ `dates = c(1983, 2010)`.  This argument should not be used when
#'   `temporal_api` is set to \dQuote{climatology} and will be ignored if set.
#'
#' @section `wind_surface`: There are 17 surfaces that may be used for corrected
#'   wind-speed values using the following equation:
#'   \deqn{WSC_hgt = WS_10m\times(\frac{hgt}{WS_50m})^\alpha}{WSC_hgt = WS_10m*(hgt/WS_50m)^\alpha}
#'   Valid surface types are described here.
#'
#' \describe{
#'   \item{vegtype_1}{35-m broadleaf-evergreen trees (70% coverage)}
#'   \item{vegtype_2}{20-m broadleaf-deciduous trees (75% coverage)}
#'   \item{vegtype_3}{20-m broadleaf and needleleaf trees (75% coverage)}
#'   \item{vegtype_4}{17-m needleleaf-evergreen trees (75% coverage)}
#'   \item{vegtype_5}{14-m needleleaf-deciduous trees (50% coverage)}
#'   \item{vegtype_6}{Savanna:18-m broadleaf trees (30%) & groundcover}
#'   \item{vegtype_7}{0.6-m perennial groundcover (100%)}
#'   \item{vegtype_8}{0.5-m broadleaf shrubs (variable %) & groundcover}
#'   \item{vegtype_9}{0.5-m broadleaf shrubs (10%) with bare soil}
#'   \item{vegtype_10}{Tundra: 0.6-m trees/shrubs (variable %) & groundcover}
#'   \item{vegtype_11}{Rough bare soil}
#'   \item{vegtype_12}{Crop: 20-m broadleaf-deciduous trees (10%) & wheat}
#'   \item{vegtype_20}{Rough glacial snow/ice}
#'   \item{seaice}{Smooth sea ice}
#'   \item{openwater}{Open water}
#'   \item{airportice}{Airport: flat ice/snow}
#'   \item{airportgrass}{Airport: flat rough grass}
#' }
#'
#' @section Rate limiting: The POWER API endpoints limit queries to prevent
#'  server overloads due to repetitive and rapid requests.  If you find that
#'  the \acronym{API} is throttling your queries, I suggest that you
#'  investigate the use of `limit_rate()` from \CRANpkg{ratelimitr} to create
#'  self-limiting functions that will respect the rate limits that the
#' \acronym{API} has in place.  It is considered best practice to check the
#'  POWER website](https://power.larc.nasa.gov/docs/services/api/#rate-limiting)
#'  for the latest rate limits as they differ between temporal \acronym{API}s
#'  and may change over time as the project matures.
#'
#' @note The associated metadata shown in the decorative header are not saved
#'   if the data are exported to a file format other than a native \R data
#'   format, *e.g.*, .Rdata, .rda or .rds.
#'
#' @return A data frame as a `POWER.Info` class, an extension of the
#' [tibble::tibble], object of \acronym{POWER} data including location, dates
#' (not including \dQuote{climatology}) and requested parameters.  A decorative
#' header of metadata is included in this object.
#'
#' @references
#' <https://power.larc.nasa.gov/docs/methodology/>
#' <https://power.larc.nasa.gov>
#'
#' @examplesIf interactive()
#'
#' # Fetch daily "ag" community temperature, relative humidity and
#' # precipitation for January 1 1985 at Kingsthorpe, Queensland, Australia
#' ag_d <- get_power(
#'   community = "ag",
#'   lonlat = c(151.81, -27.48),
#'   pars = c("RH2M", "T2M", "PRECTOTCORR"),
#'   dates = "1985-01-01",
#'   temporal_api = "daily"
#' )
#'
#' ag_d
#'
#' # Fetch single point climatology for air temperature
#' ag_c_point <- get_power(
#'   community = "ag",
#'   pars = "T2M",
#'   c(151.81, -27.48),
#'   temporal_api = "climatology"
#' )
#'
#' ag_c_point
#'
#' # Fetch interannual solar cooking parameters for a given region
#' sse_i <- get_power(
#'   community = "re",
#'   lonlat = c(112.5, -55.5, 115.5, -50.5),
#'   dates = c("1984", "1985"),
#'   temporal_api = "monthly",
#'   pars = c("CLRSKY_SFC_SW_DWN", "ALLSKY_SFC_SW_DWN")
#' )
#'
#' sse_i
#'
#' @author Adam H. Sparks \email{adamhsparks@@gmail.com}
#'
#' @export
get_power <- function(community,
                      pars,
                      temporal_api = NULL,
                      lonlat,
                      dates = NULL,
                      site_elevation = NULL,
                      wind_elevation = NULL,
                      wind_surface = NULL,
                      temporal_average = NULL,
                      time_standard = "LST") {
  if (is.null(temporal_api) & !is.null(temporal_average)) {
    warning(
      call. = FALSE,
      "`temporal_average has been deprecated for `temporal_api`.\n",
      "Your query has been modified to use the new terminology for ",
      "`get_power`.  Please update your scripts to use the new argument."
    )
    temporal_api <- temporal_average
  }
  if (is.null(temporal_api)) {
    stop(call. = FALSE,
         "You must provide a `temporal_api` value.")
  }
  if (is.character(temporal_api)) {
    temporal_api <- tolower(temporal_api)
    if (temporal_api == "climatology") {
      dates <- NULL
    }
  }
  if (temporal_api %notin% c("hourly", "daily", "monthly", "climatology")) {
    stop(call. = FALSE,
         "You have entered an invalid value for `temporal_api`.\n")
  }
  if (is.character(community)) {
    community <- tolower(community)
  }
  if (community %notin% c("ag", "sb", "re")) {
    stop(call. = FALSE,
         "You have provided an invalid `community` value.\n")
  }
  if (is.character(pars)) {
    pars <- toupper(pars)
  }
  if (any(lonlat == "global")) {
    # remove this if POWER enables global queries for climatology again
    stop(
      call. = FALSE,
      "The POWER team have not enabled `global` data queries with this ",
      "version of the 'API'."
    )
  }
  if (!is.null(site_elevation) && !is.numeric(site_elevation)) {
    stop(call. = FALSE,
         "You have entered an invalid value for `site_elevation`.\n")
  }
  if (length(lonlat) > 2 && !is.null(site_elevation)) {
    message(
      "You have provided `site_elevation` for a region request.\n",
      "The `site_elevation` value will be ignored.\n"
    )
    site_elevation <- NULL
  }

  if (length(lonlat) > 2 && !is.null(wind_elevation)) {
    message(
      "You have provided `wind_elevation` for a region request.\n",
      "The `wind_elevation` value will be ignored.\n"
    )
    wind_elevation <- NULL
  }
  if (is.character(wind_surface) && is.null(wind_elevation)) {
    stop(
      call. = FALSE,
      "If you provide a correct wind surface alias, `wind_surface`, please ",
      "include a surface elevation, `wind_elevation`, with the request.\n"
    )
  }
  if (!is.null(wind_elevation)) {
    if (wind_elevation < 10 || wind_elevation > 300) {
      stop(
        call. = FALSE,
        "`wind_elevation` values in metres are required to be between",
        " 10m and 300m.\n"
      )
    }
  }
  if (is.character(lonlat)) {
    lonlat <- tolower(lonlat)
    if (lonlat != "global") {
      stop(
        call. = FALSE,
        "You have entered an invalid value for `lonlat`. Valid values are ",
        "`global` with `climatology` or a string of lon and lat values.\n"
      )
    }
  }

  # see internal_functions.R for these functions prefixed with "."
  pars <- .check_pars(pars,
                      community,
                      temporal_api)
  lonlat_identifier <- .check_lonlat(lonlat,
                                    pars)
  dates <- .check_dates(dates,
                        lonlat,
                        temporal_api)

  # submit query -------------------------------------------------------------
  query_list <- .build_query(
    community,
    lonlat_identifier,
    pars,
    dates,
    site_elevation,
    wind_elevation,
    wind_surface,
    time_standard
  )

  power_url <- paste0(
    "https://power.larc.nasa.gov/api/temporal/",
    temporal_api,
    "/",
    lonlat_identifier$identifier
  )

  response <-
    .send_query(.query_list = query_list,
                .temporal_api = temporal_api,
                .url = power_url)

  response$raise_for_status()

  # create meta object
  power_data <- readr::read_lines(I(response$parse("UTF8")))

  meta <- power_data[c(grep("-BEGIN HEADER-",
                            power_data):grep("-END HEADER-",
                                            power_data))]
  # strip BEGIN/END HEADER lines
  meta <- meta[-c(1, max(length(meta)))]

  # replace missing values with NA in metadata header
  for (i in c("-999", "-99", "-99.00")) {
    meta <- gsub(pattern = i,
                replacement = "NA",
                x = meta)
  }

  # create tibble object
  power_data <- readr::read_csv(
    I(response$parse("UTF8")),
    col_types = readr::cols(),
    na = c("-999", "-999.00", "-999.0", "-99", "-99.00", "-99.0"),
    skip = length(meta) + 2
  )

  # add lon and lat values from user's request
  power_data <- tibble::add_column(
    LON = query_list$longitude,
    LAT = query_list$latitude,
    power_data,
    .before = 1
  )

  # if the temporal average is anything but climatology, add date fields
  if (temporal_api == "daily" &&
      query_list$community == "re" ||
      query_list$community == "sb") {
    power_data <- .format_dates_re_sb(power_data)
  }
  if (temporal_api == "daily" &&
      query_list$community == "ag") {
    power_data <- .format_dates_ag(power_data)
  }

  # add new class
  power_data <- tibble::new_tibble(power_data,
                                  class = "POWER.Info",
                                  nrow = nrow(power_data))

  # add attributes for printing df
  attr(power_data, "POWER.Info") <- meta[1]
  attr(power_data, "POWER.Dates") <- meta[2]
  attr(power_data, "POWER.Location") <- meta[3]
  attr(power_data, "POWER.Elevation") <- meta[4]
  attr(power_data, "POWER.Climate_zone") <- meta[5]
  attr(power_data, "POWER.Missing_value") <- meta[6]
  attr(power_data, "POWER.Parameters") <-
    paste(meta[7:length(meta)],
          collapse = ";\n ")
  return(power_data)
}

# functions internal to get_power() -----

#' Check Dates for Validity When Querying API
#'
#' Validates user entered dates against `lonlat` and `temporal_api` values
#'
#' @param dates User entered `dates` value.
#' @param lonlat User entered `lonlat` value.
#' @param temporal_api User entered `temporal_api` value.
#'
#' @return Validated dates in a list for use in `.build_query`
#' @keywords internal
#' @noRd
.check_dates <- function(dates, lonlat, temporal_api) {
  if (is.null(dates) & temporal_api != "climatology") {
    stop(call. = FALSE,
         "You have not entered dates for the query.\n")
  }
  if (temporal_api == "monthly") {
    if (length(unique(dates)) < 2) {
      stop(
        call. = FALSE,
        "For `temporal_api = monthly`, at least two (2) years ",
        "are required to be provided.\n"
      )
    }
    if (any(nchar(dates) > 4)) {
      dates <- unique(substr(dates, 1, 4))
    }
    if (dates[[2]] < dates[[1]]) {
      message("Your start and end dates were reversed. ",
              "They have been reordered.\n")
      dates <- c(dates[2], dates[1])
    }
    return(dates)
  }
  if (temporal_api == "daily" || temporal_api == "hourly") {
    if (is.numeric(lonlat)) {
      if (length(dates) == 1) {
        dates <- c(dates, dates)
      }
      if (length(dates) > 2) {
        stop(call. = FALSE,
             "You have supplied more than two dates for start and end.\n")
      }

      # put dates in list to use lapply
      dates <- as.list(dates)

      # check dates as entered by user
      date_format <- function(x) {
        tryCatch(
          # try to parse the date format using lubridate
          x <- lubridate::parse_date_time(x,
                                          c(
                                            "Ymd",
                                            "dmY",
                                            "mdY",
                                            "BdY",
                                            "Bdy",
                                            "bdY",
                                            "bdy"
                                          )),
          warning = function(c) {
            stop(call. = FALSE,
                 "",
                 x,
                 " is not a valid entry for date. Enter as YYYY-MM-DD.\n")
          }
        )
        as.Date(x)
      }

      # apply function to reformat/check dates
      dates <- lapply(X = dates, FUN = date_format)

      # if the stdate is > endate, flip order
      if (dates[[2]] < dates[[1]]) {
        message("Your start and end dates were reversed. ",
                "They have been reordered.\n")
        dates <- c(dates[2], dates[1])
      }

      # check date to be sure it's not before POWER data start
      if (temporal_api != "hourly" &&
          dates[[1]] < "1981-01-01") {
        stop(call. = FALSE,
             "1981-01-01 is the earliest available data from POWER.\n")
      } else if (temporal_api == "hourly" &
                 dates[[1]] < "2001-01-01")
        stop(call. = FALSE,
             "2001-01-01 is the earliest available hourly data from POWER.\n")
      # check end date to be sure it's not _after_
      if (dates[[2]] > Sys.Date()) {
        stop(call. = FALSE,
             "The weather data cannot possibly extend beyond this day.\n")
      }

      dates <- lapply(dates, as.character)
      dates <- gsub("-", "", dates, ignore.case = TRUE)
    }
  }
}

#' Check user-supplied `lonlat` for validity when querying API
#'
#' Validates user entered `lonlat` values and checks against `pars`
#' values.
#'
#' @param lonlat User entered `lonlat` value.
#' @param pars User entered `pars` value.
#'
#' @return A list called `lonlat_identifier` for use in [.build_query()]
#' @keywords internal
#' @noRd
.check_lonlat <-
  function(lonlat, pars) {
    bbox <- NULL
    if (is.character(lonlat) & length(lonlat) == 1) {
      if (lonlat == "global") {
        identifier <- "global"
      } else if (is.character(lonlat)) {
        stop(call. = FALSE,
             "You have entered an invalid request for `lonlat`.\n")
      }
    } else if (is.numeric(lonlat) & length(lonlat) == 2) {
      if (lonlat[1] < -180 | lonlat[1] > 180) {
        stop(
          call. = FALSE,
          "Please check your longitude, `",
          paste0(lonlat[1]),
          "`, to be sure it is valid.\n"
        )
      }
      if (lonlat[2] < -90 | lonlat[2] > 90) {
        stop(
          call. = FALSE,
          "Please check your latitude, `",
          paste0(lonlat[2]),
          "`, value to be sure it is valid.\n"
        )
      }
      identifier <- "point"
      longitude <- lonlat[1]
      latitude <- lonlat[2]
    } else if (length(lonlat) == 4 & is.numeric(lonlat)) {
      if ((lonlat[[3]] - lonlat[[1]]) * (lonlat[[4]] - lonlat[[2]]) * 4 > 100) {
        stop(
          call. = FALSE,
          "Please provide correct bounding box values. The bounding box\n",
          "can only enclose a max of 10 x 10 region of 0.5 degree values\n",
          "or a 5 x 5 region of 1 degree values, (i.e., 100 points total).\n"
        )
      } else if (any(lonlat[1] < -180 |
                     lonlat[3] < -180 |
                     lonlat[1] > 180 |
                     lonlat[3] > 180)) {
        stop(
          call. = FALSE,
          "Please check your longitude, `",
          lonlat[1],
          "`, `",
          lonlat[3],
          "`, values to be sure they are valid.\n"
        )
      } else if (any(lonlat[2] < -90 |
                     lonlat[4] < -90 |
                     lonlat[2] > 90 |
                     lonlat[4] > 90)) {
        stop(
          call. = FALSE,
          "Please check your latitude, `",
          lonlat[2],
          "`, `",
          lonlat[4],
          "`, values to be sure they are valid.\n"
        )
      } else if (lonlat[2] > lonlat[4]) {
        stop(call. = FALSE,
             "The first `lat` value must be the minimum value.\n")
      } else if (lonlat[1] > lonlat[3]) {
        stop(call. = FALSE,
             "The first `lon` value must be the minimum value.\n")
      }
      identifier <- "regional"
      bbox <- c(
        "xmin" = lonlat[1],
        "ymin" = lonlat[2],
        "xmax" = lonlat[3],
        "ymax" = lonlat[4]
      )
    } else {
      stop(call. = FALSE,
           "You have entered an invalid request for `lonlat`.\n")
    }

    if (!is.null(bbox)) {
      lonlat_identifier <- list(bbox, identifier)
      names(lonlat_identifier) <- c("bbox", "identifier")
    } else if (identifier == "global") {
      lonlat_identifier <- list("global")
      names(lonlat_identifier) <- "identifier"
    } else {
      lonlat_identifier <- list(longitude, latitude, identifier)
      names(lonlat_identifier) <-
        c("longitude", "latitude", "identifier")
    }
    return(lonlat_identifier)
  }

#' Construct a list of options to pass to the POWER API
#'
#' @param community A validated value for community from [check_community()].
#' @param lonlat_identifier A list of values, a result of [check_lonlat()]
#' @param pars A validated value from [check_pars()].
#' @param dates A list of values, a result of [check_dates()].
#' @param site_elevation A validated value from
#' @param wind_elevation A validate value from
#' @param wind_surface A validated value from
#' @return A `list` object of values to be passed to a [crul] object to query
#'  the 'POWER' 'API'
#' @keywords internal
#' @noRd
.build_query <- function(community,
                         lonlat_identifier,
                         pars,
                         dates,
                         site_elevation,
                         wind_elevation,
                         wind_surface,
                         time_standard) {
  user_agent <- paste0("nasapower",
                       gsub(
                         pattern = "\\.",
                         replacement = "",
                         x = getNamespaceVersion("nasapower")
                       ))

  if (lonlat_identifier$identifier == "point") {
    query_list <- list(
      parameters = pars,
      community = community,
      start = dates[[1]],
      end = dates[[2]],
      `site-elevation` = site_elevation,
      `wind-elevation` = wind_elevation,
      `wind-surface` = wind_surface,
      longitude = lonlat_identifier$longitude,
      latitude = lonlat_identifier$latitude,
      format = "csv",
      `time-standard` = time_standard,
      user = user_agent
    )
  }

  if (lonlat_identifier$identifier == "regional") {
    query_list <- list(
      parameters = pars,
      community = community,
      start = dates[[1]],
      end = dates[[2]],
      `latitude-min` = lonlat_identifier$bbox["ymin"],
      `latitude-max` = lonlat_identifier$bbox["ymax"],
      `longitude-min` = lonlat_identifier$bbox["xmin"],
      `longitude-max` = lonlat_identifier$bbox["xmax"],
      format = "csv",
      `time-standard` = time_standard,
      user = user_agent
    )
  }

  if (lonlat_identifier$identifier == "global") {
    query_list <- list(
      parameters = pars,
      community = community,
      format = "csv",
      `time-standard` = time_standard,
      user = user_agent
    )
  }
  return(query_list[lengths(query_list) != 0])
}

#' Format date columns in POWER data frame for the ag community
#'
#' Formats columns as integers for DOY and adds columns for year, month and day.
#'
#' @param power_response A tidy data.frame resulting from [build_query()].
#'
#' @return A tidy data frame of 'POWER' data with additional date information
#'   columns.
#' @keywords internal
#' @noRd

.format_dates_ag <- function(power_response) {
  # convert DOY to integer
  power_response$DOY <- as.integer(power_response$DOY)

  # Calculate the full date from YEAR and DOY
  power_response <- tibble::add_column(
    power_response,
    YYYYMMDD = as.Date(power_response$DOY - 1,
                       origin = as.Date(
                         paste(power_response$YEAR, "-01-01",
                               sep = "")
                       )),
    .after = "DOY"
  )

  # Extract month as integer
  power_response <- tibble::add_column(power_response,
                                       MM = as.integer(
                                         substr(
                                           power_response$YYYYMMDD, 6, 7)),
                                       .after = "YEAR")

  # Extract day as integer
  return(tibble::add_column(power_response,
                            DD = as.integer(
                              substr(
                              power_response$YYYYMMDD, 9, 10
                            )),
                            .after = "MM"))
}

#' Format date columns in POWER data frame for the re community
#'
#' Formats columns as integers for DOY and adds columns for year, month and day.
#'
#' @param power_response A tidy data.frame resulting from [.build_query()].
#'
#' @return A tidy data frame of 'POWER' data with additional date information
#'   columns.
#' @keywords internal
#' @noRd

.format_dates_re_sb <- function(power_response) {
  names(power_response)[names(power_response) == "DY"] <- "DD"
  names(power_response)[names(power_response) == "MO"] <- "MM"

  # add day of year col
  power_response$YYYYMMDD <-
    as.Date(
      paste(
        power_response$DD,
        power_response$MM,
        power_response$YEAR,
        sep = "-"
      ),
      format = "%d-%m-%Y"
    )
  power_response$DOY <- lubridate::yday(power_response$YYYYMMDD)

  # set integer cols
  power_response$MM <- as.integer(power_response$MM)
  power_response$DD <- as.integer(power_response$DD)

  refcols <- c("LON", "LAT", "YEAR", "MM", "DD", "DOY", "YYYYMMDD")
  return(power_response[, c(refcols, setdiff(names(power_response), refcols))])
}

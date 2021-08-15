
#' Add %notin% function
#'
#' Negates `%in%` for easier matching.
#'
#' @param x A character string to match.
#' @param table A table containing values to match `x` against.
#'
#' @return A function to use for checking if something is not in a table
#'
#' @noRd
`%notin%` <- function(x, table) {
  # Same as !(x %in% table)
  match(x, table, nomatch = 0L) == 0L
}

#' Check dates for validity when querying API
#'
#' Validates user entered date values against `lonlat` and `temporal_api` values
#'
#' @param dates User entered `dates` value.
#' @param lonlat User entered `lonlat` value.
#' @param temporal_api User entered `temporal_api` value.
#'
#' @return Validated dates in a list for use in `.build_query`
#'
#' @noRd
.check_dates <- function(dates, lonlat, temporal_api) {
  if (is.null(dates) & temporal_api != "climatology") {
    stop(call. = FALSE,
         "\nYou have not entered dates for the query.\n")
  }

  if (temporal_api == "monthly") {
    if (length(unique(dates)) < 2) {
      stop(
        call. = FALSE,
        "\nFor `temporal_api = monthly`, at least two (2) years ",
        "are required to be provided.\n"
      )
    }
    if (any(nchar(dates) > 4)) {
      dates <- unique(substr(dates, 1, 4))
    }
    if (dates[[2]] < dates[[1]]) {
      message("\nYour start and end dates were reversed. ",
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
             "\nYou have supplied more than two dates for start and end.\n")
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
                 "\n",
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
        message("\nYour start and end dates were reversed. ",
                "They have been reordered.\n")
        dates <- c(dates[2], dates[1])
      }

      # check date to be sure it's not before POWER data start
      if (temporal_api != "hourly" &&
          dates[[1]] < "1981-01-01") {
        stop(call. = FALSE,
             "\n1981-01-01 is the earliest available data from POWER.\n")
      } else if (temporal_api == "hourly" &
                 dates[[1]] < "2001-01-01")
        stop(call. = FALSE,
             "\n2001-01-01 is the earliest available hourly data from POWER.\n")
      # check end date to be sure it's not _after_
      if (dates[[2]] > Sys.Date()) {
        stop(call. = FALSE,
             "\nThe weather data cannot possibly extend beyond this day.\n")
      }

      dates <- lapply(dates, as.character)
      dates <- gsub("-", "", dates, ignore.case = TRUE)
    }
  }
}

#' Check pars for validity when querying API
#'
#' Validates user entered date values against `lonlat` and
#' `temporal_api` values
#'
#' @param pars User entered `pars` value.
#' @param community User entered `community` value.
#' @param temporal_api User entered `temporal_api` value.
#' @param lonlat User entered `lonlat` value.
#'
#' @return Validated pars for use in [.build_query()]
#'
#' @noRd
.check_pars <-
  function(pars, community, temporal_api) {

    # make sure that there are no duplicates in the query
    pars <- unique(pars)

    p <- unlist(parameters[paste(toupper(temporal_api),
                                 toupper(community),
                                 sep = "_")])

    # check pars to make sure that they are valid for both the par and
    # temporal_api
    if (any(pars %notin% p)) {
      stop(call. = FALSE,
           "\n", pars[which(pars %notin% p)],
                  " is not valid in 'pars'.\n",
           "Check that the 'pars', 'community' and 'temporal_api' align.")
    }

    # check pars to make sure < allowed
    if (length(pars) > 3 & temporal_api == "CLIMATOLOGY") {
      stop(
        call. = FALSE,
        "\nYou can only specify three (3) parameters for download when ",
        "querying climatology.\n"
      )
    }

    if (length(pars) > 20 & temporal_api != "CLIMATOLOGY") {
      stop(call. = FALSE,
           "\nYou can only specify 20 parameters for download at a time.\n")
    }

    # all good? great. now we format it for the API
    pars <- paste0(pars, collapse = ",")
    return(pars)
  }

#' Check lonlat for validity when querying API
#'
#' Validates user entered `lonlat` values and checks against `pars`
#' values.
#'
#' @param lonlat User entered `lonlat` value.
#' @param pars User entered `pars` value.
#'
#' @return A list called `lonlat_identifier` for use in [.build_query()]
#'
#' @noRd
.check_lonlat <-
  function(lonlat, pars) {
    bbox <- NULL
    if (is.character(lonlat) & length(lonlat) == 1) {
      if (lonlat == "global") {
        identifier <- "global"
      } else if (is.character(lonlat)) {
        stop(call. = FALSE,
             "\nYou have entered an invalid request for `lonlat`.\n")
      }
    } else if (is.numeric(lonlat) & length(lonlat) == 2) {
      if (lonlat[1] < -180 | lonlat[1] > 180) {
        stop(
          call. = FALSE,
          "\nPlease check your longitude, `",
          paste0(lonlat[1]),
          "`, to be sure it is valid.\n"
        )
      }
      if (lonlat[2] < -90 | lonlat[2] > 90) {
        stop(
          call. = FALSE,
          "\nPlease check your latitude, `",
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
          "\nPlease provide correct bounding box values. The bounding box\n",
          "can only enclose a max of 10 x 10 region of 0.5 degree values\n",
          "or a 5 x 5 region of 1 degree values, (i.e. 100 points total).\n"
        )
      } else if (any(lonlat[1] < -180 |
                     lonlat[3] < -180 |
                     lonlat[1] > 180 |
                     lonlat[3] > 180)) {
        stop(
          call. = FALSE,
          "\nPlease check your longitude, `",
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
          "\nPlease check your latitude, `",
          lonlat[2],
          "`, `",
          lonlat[4],
          "`, values to be sure they are valid.\n"
        )
      } else if (lonlat[2] > lonlat[4]) {
        stop(call. = FALSE,
             "\nThe first `lat` value must be the minimum value.\n")
      } else if (lonlat[1] > lonlat[3]) {
        stop(call. = FALSE,
             "\nThe first `lon` value must be the minimum value.\n")
      }
      identifier <- "regional"
      bbox <- paste(lonlat[2],
                    lonlat[1],
                    lonlat[4],
                    lonlat[3],
                    sep = ",")
    } else {
      stop(call. = FALSE,
           "\nYou have entered an invalid request for `lonlat`.\n")
    }

    if (!is.null(bbox)) {
      lonlat_identifier <- list(bbox, identifier)
      names(lonlat_identifier) <- c("bbox", "identifier")
    } else if (identifier == "global") {
      lonlat_identifier <- list("global")
      names(lonlat_identifier) <- "identifier"
    } else {
      lonlat_identifier <- list(longitude, latitude, identifier)
      names(lonlat_identifier) <- c("longitude", "latitude", "identifier")
    }
    return(lonlat_identifier)
  }

#' Query the POWER API
#'
#' Constructs and sends a query to the 'POWER' 'API' using validated values from
#' previous functions in this file.
#'
#' @param community A validated value for community from [check_community()].
#' @param lonlat_identifier A list of values, a result of [check_lonlat()]
#' @param pars A validated value from [check_pars()].
#' @param dates A list of values, a result of [check_dates()].
#'
#' @return A [tibble::tibble()] of requested 'POWER' data
#'
#' @noRd
.build_query <- function(community,
                         lonlat_identifier,
                         pars,
                         dates,
                         site_elevation,
                         wind_elevation,
                         wind_surface) {
  user_agent <- paste0("nasapower",
                       gsub(
                         pattern = "\\.",
                         replacement = "",
                         x = getNamespaceVersion("nasapower")
                       ))

  # If user has given a site_elevation value, use it
  if (lonlat_identifier$identifier == "point") {
    if (!is.null(dates)) {
      query_list <- list(
        parameters = pars,
        community = community,
        start = dates[[1]],
        end = dates[[2]],
        siteElev = site_elevation,
        longitude = lonlat_identifier$longitude,
        latitude = lonlat_identifier$latitude,
        format = "csv",
        time_standard = "utc",
        user = user_agent
      )
    }

    if (is.null(dates)) {
      query_list <- list(
        parameters = pars,
        community = community,
        siteElev = site_elevation,
        longitude = lonlat_identifier$longitude,
        latitude = lonlat_identifier$latitude,
        format = "csv",
        time_standard = "utc",
        user = user_agent
      )
    }
  }

  # if no site elevation value provided, send request without
  if (lonlat_identifier$identifier == "point" &
      is.null(site_elevation)) {
    if (!is.null(dates)) {
      query_list <- list(
        parameters = pars,
        community = community,
        start = dates[[1]],
        end = dates[[2]],
        longitude = lonlat_identifier$longitude,
        latitude = lonlat_identifier$latitude,
        format = "csv",
        time_standard = "utc",
        user = user_agent
      )
    }

    if (is.null(dates)) {
      query_list <- list(
        parameters = pars,
        community = community,
        longitude = lonlat_identifier$longitude,
        latitude = lonlat_identifier$latitude,
        format = "csv",
        time_standard = "utc",
        user = user_agent
      )
    }
  }

  if (lonlat_identifier$identifier == "regional" &
      !is.null(dates)) {
    query_list <- list(
      parameters = pars,
      community = community,
      start = dates[[1]],
      end = dates[[2]],
      bbox = I(lonlat_identifier$bbox),
      format = "csv",
      time_standard = "utc",
      user = user_agent
    )
  }

  if (lonlat_identifier$identifier == "regional" &
      is.null(dates)) {
    query_list <- list(
      parameters = pars,
      community = community,
      bbox = I(lonlat_identifier$bbox),
      format = "csv",
      time_standard = "utc",
      user = user_agent
    )
  }

  if (lonlat_identifier$identifier == "global") {
    query_list <- list(
      parameters = pars,
      community = community,
      format = "csv",
      time_standard = "utc",
      user = user_agent
    )
  }
  return(query_list)
}

#' Sends the query to the API
#'
#' @param .query_list A query list created by [.build_query()]
#' @param .pars A character string of validated pars provided by the user
#'  generated by [.check_pars()]
#' @param .temporal_api A character string of the validated `temporal_api`
#'  provided by the user as `temporal_api`
#' @param .community A character string of the validated community provided by
#'  the user
#' @param .identifer A character string of the validated identifier values as
#'  created by [.check_lonlat()]
#' @noRd
#'
.send_query <- function(.query_list,
                        .pars,
                        .temporal_api,
                        .community,
                        .identifier) {
  # constructs URL from url defined in zzz.R and the temporal_api and community
  power_url <- paste0(
    getOption("nasapower_base_url"),
    "temporal/",
    .temporal_api,
    "/",
    .identifier
  )

  client <- crul::HttpClient$new(url = power_url)

  tryCatch({
    # nocov begin
    response <- client$get(query = .query_list, retry = 6)
    if (!response$success()) {
      stop(call. = FALSE)
    }
  },
  error = function(e) {
    e$message <-
      paste(
        "\nSomething went wrong with the query, no data were returned.",
        "Please see <https://power.larc.nasa.gov> for potential",
        "server issues.\n"
      )
    # Otherwise refers to open.connection
    e$call <- NULL
    stop(call. = FALSE,
         e)
  }) # nocov end
  return(response)
}


#' Import data after download
#' @param .response A response from the POWER API generated by [.send_query()]
#' @param .pars A vector of validated parameters that the user has requested
#'  generated by [.check_pars()]
#' @param .query_list A query list created by [.build_query()]
#' @param .temporal_api A character string of the validated `temporal_api`
#'  provided by the user as `temporal_api`
#' @noRd

.return_power <- function(.response,
                          .pars,
                          .query_list,
                          .temporal_api) {
  if (response$status_code != 200) {
    stop(call. = FALSE,
         unlist(response$status_http()))
  }

  # create meta object
  power_data <- readr::read_lines(response$parse("UTF8"))

  meta <- power_data[c(grep("-BEGIN HEADER-",
                            power_data):grep("-END HEADER-",
                                             power_data))]
  # strip BEGIN/END HEADER lines
  meta <- meta[-c(1, max(length(meta)))]
  # replace missing values with NA
  meta <- gsub(pattern = "-999",
               replacement = "NA",
               x = meta)

  # replace missing values with NA
  meta <- gsub(pattern = "-99",
               replacement = "NA",
               x = meta)

  power_data <- readr::read_csv(
    response$parse("UTF8"),
    col_types = readr::cols(),
    na = c("-999", "-99", "-99.00"),
    skip = length(meta) + 2
  )

  # add lon and lat values from user's request
  power_data <- tibble::add_column(
    lon = .query_list$longitude,
    lat = .query_list$latitude,
    power_data,
    .before = 1
  )

  # if the temporal average is anything but climatology, add date fields
  if (temporal_api == "daily" &
      .query_list$community == "re" |
      .query_list$community == "sb") {
    power_data <- .format_dates_re_sb(power_data)
  }
  if (temporal_api == "daily" &
      .query_list$community == "ag") {
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

#' Prints Power.Info object
#'
#' @param x POWER.Info object
#' @param ... ignored
#' @export
#' @noRd
print.POWER.Info <- function(x, ...) {
  if (!is.null(attr(x, "POWER.Info"))) {
    cat(
      attr(x, "POWER.Info"),
      "\n",
      attr(x, "POWER.Dates"),
      "\n",
      attr(x, "POWER.Location"),
      "\n",
      attr(x, "POWER.Elevation"),
      "\n",
      attr(x, "POWER.Climate_zone"),
      "\n",
      attr(x, "POWER.Missing_value"),
      "\n",
      "\n",
      "Parameters: \n",
      attr(x, "POWER.Parameters"),
      "\n",
      "\n"
    )
    format(x)
  }
  NextMethod(x)
  invisible(x)
}

#' Format date columns in POWER data frame for the AG community
#'
#' Formats columns as integers for DOY and adds columns for year, month and day.
#'
#' @param NASA A tidy data.frame resulting from [build_query()].
#'
#' @return A tidy data frame of 'POWER' data with additional date information
#'   columns.
#'
#' @noRd
#'
.format_dates_AG <- function(NASA) {
  # convert DOY to integer
  NASA$DOY <- as.integer(NASA$DOY)

  # Calculate the full date from YEAR and DOY
  NASA <- tibble::add_column(NASA,
                             YYYYMMDD = as.Date(NASA$DOY - 1,
                                                origin = as.Date(paste(
                                                  NASA$YEAR, "-01-01",
                                                  sep = ""
                                                ))),
                             .after = "DOY")

  # Extract month as integer
  NASA <- tibble::add_column(NASA,
                             MM = as.integer(substr(NASA$YYYYMMDD, 6, 7)),
                             .after = "YEAR")

  # Extract day as integer
  NASA <- tibble::add_column(NASA,
                             DD = as.integer(substr(NASA$YYYYMMDD, 9, 10)),
                             .after = "MM")
}

#' Format date columns in POWER data frame for the SSE community
#'
#' Formats columns as integers for DOY and adds columns for year, month and day.
#'
#' @param NASA A tidy data.frame resulting from [.build_query()].
#'
#' @return A tidy data frame of 'POWER' data with additional date information
#'   columns.
#'
#' @noRd
#'
.format_dates_SSE_SB <- function(NASA) {
  names(NASA)[names(NASA) == "DY"] <- "DD"
  names(NASA)[names(NASA) == "MO"] <- "MM"

  # create YYYYMMDD col
  NASA$YYYYMMDD <- paste0(NASA$YEAR, NASA$MM, NASA$DD)

  # add day of year col
  NASA$DOY <- lubridate::yday(lubridate::as_date(NASA$YYYYMMDD))

  # set integer cols
  NASA$YYYYMMDD <- lubridate::as_date(NASA$YYYYMMDD)
  NASA$MM <- as.integer(NASA$MM)
  NASA$DD <- as.integer(NASA$DD)

  refcols <- c("LON", "LAT", "YEAR", "MM", "DD", "DOY", "YYYYMMDD")
  NASA <- NASA[, c(refcols, setdiff(names(NASA), refcols))]
}

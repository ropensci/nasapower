

`%notin%` <- function(x, table) {
  # Same as !(x %in% table)
  match(x, table, nomatch = 0L) == 0L
}

#' @noRd
# start/end dates not required for global.
check_global <- function(latlon) {
  if (is.character(latlon)) {
    latlon <- paste0(toupper(substr(latlon, 1, 1)),
                     tolower(substr(latlon, 2, nchar(latlon))))
    if (latlon != "Global") {
      stop("\nYou have entered an invalid value for `latlon`.\n")
    }
  }
  return(latlon)
}

#' @noRd
check_dates <- function(dates, latlon) {
  if (is.numeric(latlon)) {
    # if dates are NULL, set to defaults
    if (is.null(dates)) {
      dates <- c("1983-01-01", as.character(Sys.Date()))
    }
    if (length(dates) == 1) {
      dates <- c(dates, dates)
    }

    if (length(dates) > 2) {
      stop(call. = FALSE,
           "\nYou have supplied more than two dates for start and end dates.\n")
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
      return(as.Date(x))
    }

    # apply function to reformat/check dates
    dates <- lapply(X = dates, FUN = date_format)

    # if the stdate is > endate, flip order
    if (dates[[2]] < dates[[1]]) {
      message("\nYour start and end dates were reversed.\n",
              "They have been reordered.\n")
      dates <- as.list(c(dates[2], dates[1]))
    }

    # check date to be sure it's not before POWER data start
    if (dates[[1]] < "1983-01-01") {
      stop(call. = FALSE,
           "\nNASA-POWER data do not start before 1983-01-01.\n")
    }

    # check end date to be sure it's not _after_
    if (dates[[2]] > Sys.Date()) {
      stop(call. = FALSE,
           "\nThe data cannot possibly extend beyond this moment.\n")
    }

    dates <- lapply(dates, as.character)
    dates <- gsub("-", "" , dates, ignore.case = TRUE)
  } else if (is.character(latlon) & !is.null(dates)) {
    message("\nDates are not used with CLIMATOLOGY. Setting to NULL.\n")
    dates <- NULL
  }

  return(dates)
}

#' @noRd
check_community <-
  function(community) {
    if (is.null(community)) {
      stop(call. = FALSE,
           "\nYou have not provided a `community` value.\n")
    }
    community <- toupper(community)
    if (community %notin% c("AG", "SB", "SSE")) {
      stop(call. = FALSE,
           "\nYou have provided an invalid `community` value.\n")
    }
    return(community)
  }

#' @noRd
check_pars <-
  function(pars, temporal_average, latlon) {
    if (!is.null(temporal_average)) {
      temporal_average <- toupper(temporal_average)
    }
    if (!is.numeric(latlon) & !is.null(temporal_average)) {
      if (temporal_average != "CLIMATOLOGY") {
        message(
          "\nGlobal data are only available for Climatology.\n",
          "\nSetting `temporal_average` to `CLIMATOLOGY`.\n"
        )
      }
    }
    if (is.character(latlon)) {
      temporal_average <- "CLIMATOLOGY"
    }

    if (is.null(temporal_average)) {
      stop(call. = FALSE,
           "\nYou have not provided a `temporal_average` value.\n")
    }

    if (is.null(pars)) {
      stop(call. = FALSE,
           "\nYou have not provided a `pars` value.\n")
    }

    if (temporal_average %notin% c("DAILY", "INTERANNUAL", "CLIMATOLOGY")) {
      stop(call. = FALSE,
           "\nYou have entered an invalid value for `temporal_average`.\n")
    }

    pars <- toupper(pars)
    # check pars to make sure that they are valid
    if (any(pars %notin% names(parameters))) {
      stop(call. = FALSE,
           paste0("\n", pars[which(pars %notin% names(parameters))],
                  " is/are not valid in 'pars'.\n"))
    }

    # check to make sure temporal_average is appropriate for given pars
    for (i in pars) {
      if (temporal_average %notin% parameters[[i]]$include) {
        stop(
          call. = FALSE,
          "\nYou have entered an invalid value for `temporal_average` for\n",
          "the supplied `pars`. One or more `pars` are not, available for\n",
          "`",
          temporal_average,
          "`, please check.\n"
        )
      }
    }

    # all good? great. now we format it for the API
    pars <- paste0(pars, collapse = ",")
    pars <- list(pars, temporal_average)
    names(pars) <- c("pars", "temporal_average")
    return(pars)
  }

#' @noRd
check_latlon <-
  function(latlon, pars) {
    bbox <- NULL
    if (is.null(latlon)) {
      stop(call. = FALSE,
           "\nYou must provide a `latlon` (max 100 points or 10x10 cells).\n")
    }
    if (length(latlon) == 2 && is.numeric(latlon)) {
      if (latlon[1] < -90 || latlon[1] > 90) {
        stop(
          call. = FALSE,
          "\nPlease check your latitude, `",
          paste0(latlon[1]),
          "`, to be sure it is valid.\n"
        )
      }
      if (latlon[2] < -180 || latlon[2] > 180) {
        stop(
          call. = FALSE,
          "\nPlease check your longitude, `",
          paste0(latlon[2]),
          "`, value to be sure it is valid.\n"
        )
      }
      message("\nFetching single point data for lat ",
              latlon[1],
              ", lon ",
              latlon[2],
              "\n")
      identifier <- "SinglePoint"
      lat <- latlon[1]
      lon <- latlon[2]

    } else if (length(latlon) == 4 && is.numeric(latlon)) {
      if ((latlon[[3]] - latlon[[1]]) * (latlon[[4]] - latlon[[2]]) * 4 > 100) {
        stop(
          call. = FALSE,
          "\nPlease provide correct bounding box values. The bounding box\n",
          "can only enclose a max of 10 x 10 region of 0.5 degree values\n",
          "or a 5 x 5 region of 1 degree values, (i.e. 100 points total).\n"
        )
      }

      if (any(latlon[1] < -90 ||
              latlon[3] < -90 ||
              latlon[1] > 90 ||
              latlon[3] > 90)) {
        stop(
          call. = FALSE,
          "\nPlease check your latitude, `",
          latlon[1],
          "`, `",
          latlon[3],
          "`, values to be sure they are valid.\n"
        )
      }
      if (any(latlon[2] < -180 ||
              latlon[4] < -180 ||
              latlon[2] > 180 ||
              latlon[4] > 180)) {
        stop(
          call. = FALSE,
          "\nPlease check your longitude, `",
          latlon[2],
          "`, `",
          latlon[4],
          "`, values to be sure they are valid.\n"
        )
      }
      if (latlon[1] > latlon[3]) {
        stop(call. = FALSE,
             "\nThe first `lat` value must be the minimum value.\n")
      }
      if (latlon[2] > latlon[4]) {
        stop(call. = FALSE,
             "\nThe first `lon` value must be the minimum value.\n")
      }
      message(
        "\nFetching regional data for the area within ",
        latlon[[1]],
        " lat & ",
        latlon[[2]],
        " lon, ",
        latlon[[3]],
        " lat & ",
        latlon[[4]],
        " lon.\n"
      )
      identifier <- "Regional"
      bbox <-  paste0(latlon, collapse = ",")
    } else if (latlon == "Global") {
      identifier <- "Global"
    } else {
      stop(call. = FALSE,
           "\nYou have entered an invalid request for `latlon`.\n")
    }
    if (!is.null(bbox)) {
      latlon_identifier <- list(bbox, identifier)
      names(latlon_identifier) <- c("bbox", "identifier")
    } else if (identifier == "Global") {
      latlon_identifier <- list("Global")
      names(latlon_identifier) <- "identifier"
    }  else {
      latlon_identifier <- list(lat, lon, identifier)
      names(latlon_identifier) <- c("lat", "lon", "identifier")
    }
    return(latlon_identifier)
  }

#' @noRd
power_query <- function(community,
                        latlon_identifier,
                        pars,
                        dates) {
  power_url <- # nocov start
    "power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?"
  client <- crul::HttpClient$new(url = power_url)
  user_agent <- "anonymous"

  # check status
  status <- client$get()
  status$raise_for_status() # nocov end

  # build query list for single point
  if (latlon_identifier$identifier == "SinglePoint") {
    query_list <- list(
      request = "execute",
      identifier = latlon_identifier$identifier,
      parameters = I(pars$pars),
      startDate = dates[[1]],
      endDate = dates[[2]],
      userCommunity = community,
      tempAverage = pars$temporal_average,
      outputList = "CSV",
      lon = latlon_identifier$lon,
      lat = latlon_identifier$lat,
      user = user_agent
    )
  }

  if (latlon_identifier$identifier == "Regional") {
    query_list <- list(
      request = "execute",
      identifier = latlon_identifier$identifier,
      parameters = I(pars$pars),
      startDate = dates[[1]],
      endDate = dates[[2]],
      userCommunity = community,
      tempAverage = pars$temporal_average,
      bbox = I(latlon_identifier$bbox),
      outputList = "CSV",
      user = user_agent
    )
  }

  if (latlon_identifier$identifier == "Global") {
    query_list <- list(
      request = "execute",
      identifier = latlon_identifier$identifier,
      parameters = I(pars$pars),
      userCommunity = community,
      tempAverage = pars$temporal_average,
      outputList = "CSV",
      user = user_agent
    )
  }

  # parse to an R list
  tryCatch({
    res <- client$get(query = query_list)
  }, # nocov start
  error = function(e) {
    e$message <-
      paste("\nSomething went wrong with the query. Please try again.\n")
    # Otherwise refers to open.connection
    e$call <- NULL
    stop(e)
  }) # nocov end

  # read resulting CSV file
  tryCatch({
    txt <-
      jsonlite::fromJSON(res$parse("UTF-8"))
    res <- readr::read_csv(txt$outputs$csv,
                           na = c("-", -99),
                           col_types = readr::cols())
  }, # nocov start
  error = function(e) {
    e$message <-
      paste("\nA CSV file was not created, this is a server error.\n")
    # Otherwise refers to open.connection
    e$call <- NULL
    stop(e)
  }) # nocov end
}

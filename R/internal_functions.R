
`%notin%` <- function(x, table) {
  # Same as !(x %in% table)
  match(x, table, nomatch = 0L) == 0L
}

#' @noRd
# start/end dates not required for global.
check_global <- function(lonlat) {
  if (is.character(lonlat)) {
    lonlat <- paste0(toupper(substr(lonlat, 1, 1)),
                     tolower(substr(lonlat, 2, nchar(lonlat))))
    if (lonlat != "Global") {
      stop("\nYou have entered an invalid value for `lonlat`.\n")
    }
  }
  return(lonlat)
}

#' @noRd
check_dates <- function(dates, lonlat, temporal_average) {

  temporal_average <- toupper(temporal_average)

  if (!is.null(dates) & temporal_average == "CLIMATOLOGY") {
    stop(call. = FALSE,
         "\nDates are not used when querying climatology data. ",
         "Do you wish to query daily or interannual data instead?\n")
  }

  if (is.numeric(lonlat)) {
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
      message("\nYour start and end dates were reversed. ",
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
  }

  if (temporal_average == "INTERANNUAL" &&
      length(unique(substr(dates, 1, 4))) < 2) {
    stop(call. = FALSE,
         "For `temporal_average == INTERANNUAL`, at least two (2) years ",
         "are required to be given.\n")
  }

  if (temporal_average == "INTERANNUAL" & any(nchar(dates) > 4)) {
    dates <- unique(substr(dates, 1, 4))
    message("\nOnly years are used with INTERANNUAL temporal average. ",
            "The dates have been set to ", dates[1], " ", dates[2], ".\n")
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
  function(pars, temporal_average, lonlat) {
    if (!is.null(temporal_average)) {
      temporal_average <- toupper(temporal_average)
    }
    if (!is.numeric(lonlat) & !is.null(temporal_average)) {
      if (temporal_average != "CLIMATOLOGY") {
        message(
          "\nGlobal data are only available for Climatology.\n",
          "\nSetting `temporal_average` to `CLIMATOLOGY`.\n"
        )
      }
    }
    if (is.character(lonlat)) {
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
          "\nYou have entered an invalid value for `temporal_average` for ",
          "the supplied `pars`. One or more `pars` are not, available for ",
          "`", temporal_average, "`, please check.\n"
        )
      }
    }

    # make sure that there are no duplicates in the query
    pars <- unique(pars)

    # check pars to make sure < allowed
    if (length(pars) > 3 && temporal_average == "CLIMATOLOGY") {
      stop(
        call. = FALSE,
        "\nYou can only specify three (3) parameters for download when ",
        "querying CLIMATOLOGY.\n"
      )
    }

    if (length(pars) > 20 & temporal_average != "CLIMATOLOGY") {
      stop(
        call. = FALSE,
        "\nYou can only specify 20 parameters for download at a time.\n"
      )
    }

    # all good? great. now we format it for the API
    pars <- paste0(pars, collapse = ",")
    pars <- list(pars, temporal_average)
    names(pars) <- c("pars", "temporal_average")
    return(pars)
  }

#' @noRd
check_lonlat <-
  function(lonlat, pars) {
    bbox <- NULL
    if (is.null(lonlat)) {
      stop(call. = FALSE,
           "\nYou must provide a `lonlat` (max 100 points or 10x10 cells).\n")
    }
    if (length(lonlat) == 2 && is.numeric(lonlat)) {
      if (lonlat[1] < -180 || lonlat[1] > 180) {
        stop(
          call. = FALSE,
          "\nPlease check your longitude, `",
          paste0(lonlat[1]),
          "`, to be sure it is valid.\n"
        )
      }
      if (lonlat[2] < -90 || lonlat[2] > 90) {
        stop(
          call. = FALSE,
          "\nPlease check your latitude, `",
          paste0(lonlat[2]),
          "`, value to be sure it is valid.\n"
        )
      }
      message("\nFetching single point data for lon ",
              lonlat[1],
              ", lat ",
              lonlat[2],
              "\n")
      identifier <- "SinglePoint"
      lon <- lonlat[1]
      lat <- lonlat[2]

    } else if (length(lonlat) == 4 && is.numeric(lonlat)) {
      if ((lonlat[[3]] - lonlat[[1]]) * (lonlat[[4]] - lonlat[[2]]) * 4 > 100) {
        stop(
          call. = FALSE,
          "\nPlease provide correct bounding box values. The bounding box\n",
          "can only enclose a max of 10 x 10 region of 0.5 degree values\n",
          "or a 5 x 5 region of 1 degree values, (i.e. 100 points total).\n"
        )
      }

      if (any(lonlat[1] < -180 ||
              lonlat[3] < -180 ||
              lonlat[1] > 180 ||
              lonlat[3] > 180)) {
        stop(
          call. = FALSE,
          "\nPlease check your longitude, `",
          lonlat[1],
          "`, `",
          lonlat[3],
          "`, values to be sure they are valid.\n"
        )
      }
      if (any(lonlat[2] < -90 ||
              lonlat[4] < -90 ||
              lonlat[2] > 90 ||
              lonlat[4] > 90)) {
        stop(
          call. = FALSE,
          "\nPlease check your latitude, `",
          lonlat[2],
          "`, `",
          lonlat[4],
          "`, values to be sure they are valid.\n"
        )
      }
      if (lonlat[2] > lonlat[4]) {
        stop(call. = FALSE,
             "\nThe first `lat` value must be the minimum value.\n")
      }
      if (lonlat[1] > lonlat[3]) {
        stop(call. = FALSE,
             "\nThe first `lon` value must be the minimum value.\n")
      }
      message(
        "\nFetching regional data for the area within ",
        lonlat[[1]],
        " lon & ",
        lonlat[[2]],
        " lat, ",
        lonlat[[3]],
        " lon & ",
        lonlat[[4]],
        " lat\n"
      )
      identifier <- "Regional"
      bbox <-  paste(lonlat[2],
                     lonlat[1],
                     lonlat[4],
                     lonlat[3],
                     sep = ",")
    } else if (lonlat == "Global") {
      identifier <- "Global"
    } else {
      stop(call. = FALSE,
           "\nYou have entered an invalid request for `lonlat`.\n")
    }
    if (!is.null(bbox)) {
      lonlat_identifier <- list(bbox, identifier)
      names(lonlat_identifier) <- c("bbox", "identifier")
    } else if (identifier == "Global") {
      lonlat_identifier <- list("Global")
      names(lonlat_identifier) <- "identifier"
    }  else {
      lonlat_identifier <- list(lon, lat, identifier)
      names(lonlat_identifier) <- c("lon", "lat", "identifier")
    }
    return(lonlat_identifier)
  }

#' @noRd
power_query <- function(community,
                        lonlat_identifier,
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
  if (lonlat_identifier$identifier == "SinglePoint") {
    query_list <- list(
      request = "execute",
      identifier = lonlat_identifier$identifier,
      parameters = I(pars$pars),
      startDate = dates[[1]],
      endDate = dates[[2]],
      userCommunity = community,
      tempAverage = pars$temporal_average,
      outputList = "CSV",
      lon = lonlat_identifier$lon,
      lat = lonlat_identifier$lat,
      user = user_agent
    )
  }

  if (lonlat_identifier$identifier == "Regional") {
    query_list <- list(
      request = "execute",
      identifier = lonlat_identifier$identifier,
      parameters = I(pars$pars),
      startDate = dates[[1]],
      endDate = dates[[2]],
      userCommunity = community,
      tempAverage = pars$temporal_average,
      bbox = I(lonlat_identifier$bbox),
      outputList = "CSV",
      user = user_agent
    )
  }

  if (lonlat_identifier$identifier == "Global") {
    query_list <- list(
      request = "execute",
      identifier = lonlat_identifier$identifier,
      parameters = I(pars$pars),
      userCommunity = community,
      tempAverage = pars$temporal_average,
      outputList = "CSV",
      user = user_agent
    )
  }

  # parse to an R list
  tryCatch({
    response <- client$get(query = query_list)
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
      jsonlite::fromJSON(response$parse("UTF-8"))
    response <- readr::read_csv(txt$outputs$csv,
                                col_types = readr::cols(),
                                na = "-99")
  }, # nocov start
  error = function(e) {
    # check if POWER is returning an error message
    if (exists("txt") && "Alert" %in% names(txt)) {
        e$message <- paste0(txt$messages$Alert$Description)
    } else {
      # if not, return our own error message
      e$message <- paste(
        "\nA CSV file was not created, this is a server error.",
        "The server may not be responding.",
        "Please check <https://power.larc.nasa.gov/> for notifications if",
        "you repeatedly get this error.",
        sep = "\n"
      )
    }
    # Otherwise refers to open.connection
    e$call <- NULL
    stop(e)
  }) # nocov end
}

#' @noRd
format_dates <- function(NASA) {
  # convert DOY to integer
  NASA$DOY <- as.integer(NASA$DOY)

  # Calculate the full date from YEAR and DOY
  NASA <- tibble::add_column(NASA,
                             YYYYMMDD = as.Date(NASA$DOY - 1,
                                                origin = as.Date(paste(
                                                  NASA$YEAR, "-01-01", sep = ""
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


`%notin%` <- function(x, table) {
  # Same as !(x %in% table)
  match(x, table, nomatch = 0L) == 0L
}

#' @noRd
check_dates <- function(dates) {
  # if dates are NULL, set to defaults
  if (is.null(dates)) {
    dates <- c("1983-01-01", as.character(Sys.Date()))
  }
  if (length(dates) == 1) {
    dates <- c(dates, dates)
  }

  if (length(dates) > 2) {
    stop(call. = FALSE,
         "You have supplied more than two dates for a start and end date.")
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
             x,
             " is not a valid entry for date. Enter as YYYY-MM-DD.")
      }
    )
    return(as.Date(x))
  }

  # apply function to reformat/check dates
  dates = lapply(X = dates, FUN = date_format)

  # if the stdate is > endate, flip order
  if (dates[[2]] < dates[[1]]) {
    message("Your start and end dates were reversed.\n",
            "They have been reordered.\n")
    dates <- as.list(c(dates[2], dates[1]))
  }

  # check date to be sure it's not before POWER data start
  if (dates[[1]] < "1983-01-01") {
    stop(call. = FALSE,
         "NASA-POWER data do not start before 1983-01-01")
  }

  # check end date to be sure it's not _after_
  if (dates[[2]] > Sys.Date()) {
    stop(call. = FALSE,
         "The data cannot possibly extend beyond this moment.")
  }

  dates <- lapply(dates, as.character)
  dates <- gsub("-", "" , dates, ignore.case = TRUE)
  return(dates)
}

#' @noRd
check_community <-
  function(community) {
    if (is.null(community)) {
      stop(call. = FALSE,
           "You have not provided a `community` value.")
    }
    community <- toupper(community)
    if (community %notin% c("AG", "SB", "SSE")) {
      stop(call. = FALSE,
           "You have provided an invalid `community` value.")
    }
    return(community) # nocov
  }

#' @noRd
check_pars <-
  function(pars, temporal_average) {
    if (is.null(temporal_average)) {
      stop(call. = FALSE,
           "You have not provided a `temporal_average` value.")
    }

    if (is.null(pars)) {
      stop(call. = FALSE,
           "You have not provided a `pars` value.")
    }

    temporal_average <- lettercase::str_ucfirst(
      lettercase::str_lowercase(temporal_average)
    )
    if (temporal_average %notin% c("Daily", "Interannual", "Climatology")) {
      stop(call. = FALSE,
           "You have entered an invalid value for `temporal_average`.")
    }

    pars <- toupper(pars)
    # check pars to make sure that they are valid
    if (any(pars %notin% parameters[[1]])) {
      stop(call. = FALSE,
           "You have entered an invalid value for `pars`.")
    }

    # check to make sure temporal_average is appropriate for given pars
    rows <- which(parameters$Value %in% pars) # nocov
    cols <- grep(temporal_average, colnames(parameters)) # nocov

    if (any(is.na(parameters[rows, cols]))) {
      stop(
        call. = FALSE,
        "\nYou have entered an invalid value for `temporal_average` for the\n",
        "supplied `pars`. One or more `pars` are not, available for\n",
        "`", temporal_average,
        "`, please check."
      )
    }

    # all good? great. now we format it for the API
    pars <- paste0(pars, collapse = ",")
    return(pars)
  }

#' @noRd
check_lonlat <-
  function(lonlat, pars) {
    bbox <- NULL
    if (is.null(lonlat)) {
     stop(call. = FALSE,
          "\nYou must provide a `lonlat` (maximum 100 points total or 10x10 cells).\n")
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
      message(
        "\nFetching single point data for lon ", lonlat[1], ", lat ", lonlat[2],
        "\n"
        )
      identifier <- "SinglePoint"
      lon <- lonlat[1]
      lat <- lonlat[2]

    } else if (length(lonlat) == 4 && is.numeric(lonlat)) {
      if ((lonlat[[2]] - lonlat[[1]]) * (lonlat[[4]] - lonlat[[3]]) * 4 > 100) {
        stop(
          call. = FALSE,
          "\nPlease provide correct bounding box values. The bounding box\n",
          "can only enclose a max of 10 x 10 region of 0.5 degree values\n",
          "or a 5 x 5 region of 1 degree values, (i.e. 100 points total).\n"
        )
      }

      if (any(lonlat[1] < -180 ||
              lonlat[2] < -180 ||
              lonlat[1] > 180 ||
              lonlat[2] > 180)) {
        stop(
          call. = FALSE,
          "\nPlease check your longitude, `",
          lonlat[1], "`, `", lonlat[2],
          "`, values to be sure they are valid.\n"
        )
      }
      if (any(lonlat[3] < -90 ||
              lonlat[4] < -90 ||
              lonlat[3] > 90 ||
              lonlat[4] > 90)) {
        stop(
          call. = FALSE,
          "\nPlease check your latitude, `",
          lonlat[3], "`, `", lonlat[4],
          "`, values to be sure they are valid.\n"
        )
      }
      if (lonlat[1] > lonlat[2]) {
        stop(call. = FALSE,
             "\nThe first `lon` value must be the minimum value.\n")
      }
      if (lonlat[3] > lonlat[4]) {
        stop(call. = FALSE,
             "\nThe first `lat` value must be the minimum value.\n")
      }
      message(
        "\nFetching regional data for the area within ",
        lonlat[[1]],
        " & ",
        lonlat[[2]],
        " lon, ",
        lonlat[[3]],
        " & ",
        lonlat[[4]],
        " lat.\n"
      )
      identifier <- "Regional"
      bbox <-  paste0(lonlat, collapse = ",")
    } else {
      stop(call. = FALSE,
           "\nYou have entered an invalid request for `lonlat`.\n")
    }
    if (!is.null(bbox)) {
      lonlat_identfier <- list(bbox, identifier)
      names(lonlat_identfier) <- c("bbox", "identifier")
    } else {
      lonlat_identfier <- list(lon, lat, identifier)
      names(lonlat_identfier) <- c("lon", "lat", "identifier")
    }
    return(lonlat_identfier)
  }

#' @noRd
power_query <- function(community,
                        lonlat_identifier,
                        pars,
                        dates,
                        temporal_average) {
  power_url <- # nocov start
    "power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?"
  client <- crul::HttpClient$new(url = power_url)
  user_agent <- "http://github.com/adamhsparks/nasapower"

  # check status
  status <- client$get()
  status$raise_for_status() # nocov end

  # build query list for single point
  if (lonlat_identifier$identifier == "SinglePoint") {
    query_list <- list(
      request = "execute",
      identifier = lonlat_identifier$identifier,
      parameters = I(pars),
      startDate = dates[[1]],
      endDate = dates[[2]],
      userCommunity = community,
      tempAverage = temporal_average,
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
      parameters = I(pars),
      startDate = dates[[1]],
      endDate = dates[[2]],
      userCommunity = community,
      tempAverage = temporal_average,
      bbox = I(lonlat_identifier$bbox),
      outputList = "CSV",
      user = user_agent
    )
  }

  if (lonlat_identifier$identifier == "Global") {
    query_list <- list(
      request = "execute",
      identifier = lonlat_identifier$identifier,
      parameters = I(pars),
      startDate = dates[[1]],
      endDate = dates[[2]],
      userCommunity = community,
      tempAverage = temporal_average,
      outputList = "CSV",
      user = user_agent
    )
  }

  # parse to an R list
  tryCatch({
    res <- client$get(query = query_list)
  },
  error = function(e) {
    e$message <-
      paste("\nSomething went wrong with the query. Please try again.\n")
    # Otherwise refers to open.connection
    e$call <- NULL
    stop(e)
  })

  # read resulting CSV file
  tryCatch({
    txt <-
      jsonlite::fromJSON(res$parse("UTF-8"))
    res <- readr::read_csv(txt$outputs$csv,
                           na = c("-", -99),
                           col_types = readr::cols())
  },
  error = function(e) {
    e$message <-
      paste("\nA CSV file was not created, this is a server error.\n")
    # Otherwise refers to open.connection
    e$call <- NULL
    stop(e)
  })
}

#' @noRd
check_nasa_df <- function(NASA) {
  # check if data is empty, stop if no data is available
  if (all(is.na(NASA[, -c(1:2)]))) {
    stop(
      call. = FALSE,
      "\nNo data are available as requested. If you are requesting\n",
      "very recent data, please be aware that there is a lag in\n",
      "availability (within two months of current time).\n"
    )
  }
}

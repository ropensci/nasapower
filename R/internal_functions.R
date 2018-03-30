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
             x, " is not a valid entry for date. Enter as YYYY-MM-DD.")
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

  names(dates) <- c("startDate", "endDate")
  dates <- lapply(dates, as.character)
  dates <- gsub("-","" , dates,ignore.case = TRUE)
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
    return(community)
  }

#' @noRd
check_pars <-
  function(pars) {
    if (is.null(pars)) {
      stop(call. = FALSE,
           "You have not provided a `pars` value.")
    }
    pars <- toupper(pars)
    if (any(pars %notin% parameters[[1]])) {
      stop(call. = FALSE,
           "You have entered an invalid value for `pars`.")
    } else
    pars <- paste0(pars, collapse = ",")
    return(pars)
  }

#' @noRd
check_tempavg <-
  function(temporal_average) {
    if (is.null(temporal_average)) {
      stop(call. = FALSE,
           "You have not provided a `temporal_average` value.")
    }
    temporal_average <- toupper(temporal_average)
    if (temporal_average %notin% c("DAILY", "INTERANNUAL", "CLIMATOLOGY")) {
      stop(call. = FALSE,
           "You have entered an invalid value for `temporal_average`.")
    }
    return(temporal_average)
  }

#' @noRd
check_lonlat <-
  function(lonlat, pars) {
    bbox <- NULL
    if (is.null(lonlat)) {
      if (length(pars) > 3) {
        stop(call. = FALSE,
             "Only a maximum of 3 pars are accepted for global data requests.")
      } else {
        message("lonlat was not set, fetching global data.")
        identifier <- "Global"
      }
    }

    if (length(lonlat) == 2 && is.numeric(lonlat)) {
      if (lonlat[1] < -180 || lonlat[1] > 180) {
        stop(call. = FALSE,
          "Please check your longitude, `",
          paste0(lonlat[1]),
          "`, to be sure it is valid.\n"
        )
      }
      if (lonlat[2] < -90 || lonlat[2] > 90) {
        stop(call. = FALSE,
          "Please check your latitude, `",
          paste0(lonlat[2]),
          "`, value to be sure it is valid.\n"
        )
      }
      message(
          "Fetching single point data for lon ", lonlat[1], ", lat ", lonlat[2]
            )
      identifier <- "SinglePoint"
      lon <- lonlat[1]
      lat <- lonlat[2]

    } else if (length(lonlat) == 4 && is.numeric(lonlat)) {
      if (lonlat[1:2] < -180 || lonlat[1:2] > 180) {
        stop(call. = FALSE,
          "Please check your longitude, `",
          paste0(lonlat[1:2]),
          "`, to be sure it is valid.\n"
        )
      }
      if (lonlat[3:4] < -90 || lonlat[3:4] > 90) {
        stop(call. = FALSE,
          "Please check your latitude, `",
          paste0(lonlat[3:4]),
          "`, value to be sure it is valid.\n"
        )
      }
      if (lonlat[1] > lonlat[2]) {
        stop(call. = FALSE,
             "The first `lon`` value must be the minimum value.")
      }
      if (lonlat[3] > lonlat[4]) {
        stop(call. = FALSE,
             "The first `lat`` value must be the minimum value.")
      }
      message(
        "Fetching regional data for lon ",
        lonlat[1],
        ", ",
        lonlat[2],
        ", lat ",
        lonlat[3],
        ", ",
        lonlat[4]
      )
      identifier <- "Regional"
      bbox <- lonlat
    } else {
      stop(call. = FALSE,
           "You have entered an invalid request for `lonlat`.")
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
  power_url <-
    "asdc-arcgis.larc.nasa.gov/cgi-bin/power/v1beta/DataAccess.py?"

  client <- crul::HttpClient$new(url = power_url)

  # check status
  status <- client$get()
  status$raise_for_status()

  # build query list for single point
  if (lonlat$identifier == "SinglePoint") {
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
      user = "anonymous"
    )
  }

  if (lonlat$identifier == "Regional") {
    query_list <- list(
      request = "execute",
      identifier = lonlat_identifier$identifier,
      parameters = I(pars),
      startDate = dates[[1]],
      startDate = dates[[2]],
      userCommunity = community,
      tempAverage = temporal_average,
      bbox = lonlat_identifier$bbox,
      outputList = "CSV",
      user = "anonymous"
    )
  }

  if (lonlat$identifier == "Global") {
    query_list <- list(
      request = "execute",
      identifier = lonlat_identifier$identifier,
      parameters = I(pars),
      startDate = dates[[1]],
      startDate = dates[[2]],
      userCommunity = community,
      tempAverage = temporal_average,
      outputList = "CSV",
      user = "anonymous"
    )
  }

  res <- client$get(query = query_list)

  # parse to an R list
  txt <- jsonlite::fromJSON(res$parse("UTF-8"))

  # read resulting CSV file
  res <- readr::read_csv(txt$outputs$csv, na = c("-", -99),
                         col_types = readr::cols())
  return(res)
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

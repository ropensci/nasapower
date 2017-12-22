
# check user entered dates -----------------------------------------------------
#' @noRd
.check_dates <- function(dates) {
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
        stop(x, " is not a valid entry for date. Please check.")
      }
    )
    return(as.Date(x))
  }

  # apply function to reformat/check dates
  dates <- lapply(X = dates, FUN = date_format)

  # if the stdate is > endate, flip order
  if (dates[[2]] < dates[[1]]) {
    message(
      "Your start and end dates appear to have been reversed.\n",
      "They now are in this order ",
      print(dates[[1]]),
      " to ",
      print(dates[[2]]),
      ".\n"
    )
    dates <-  as.list(c(dates[2], dates[1]))
  }

  # check date to be sure it's not before POWER data start
  if (dates[[1]] < "1983-01-01") {
    stop("NASA-POWER data do not start before 1983-01-01")
  }

  # check end date to be sure it's not _after_
  if (dates[[2]] > Sys.Date()) {
    stop("The data cannot possibly extend beyond today, can they?")
  }
  return(dates)
}

# validate cell lon lat user provided values -----------------------------------
.check_lonlat_cell <- function(lonlat) {
  if (is.null(lonlat) | length(lonlat) != 2 | !is.numeric(lonlat)) {
    stop("\nlonlat must be provided in a length-2 numeric vector.\n")
  }
  if (lonlat[1] < -180 || lonlat[1] > 180) {
    stop("\nPlease check your longitude, `",
         paste0(lonlat[1]),
         "`, to be sure it is valid.\n")
  }
  if (lonlat[2] < -90 || lonlat[2] > 90) {
    stop(
      "\nPlease check your latitude, `",
      paste0(lonlat[2]),
      "`, value to be sure it is valid.\n"
    )
  }
}

# validate region lon lat user provided values ---------------------------------
.check_lonlat_region <- function(lonlat) {
  if (is.null(lonlat) | length(lonlat) != 4 | !is.numeric(lonlat)) {
    stop("\nlonlat must be provided in a length-2 numeric vector.\n")
  }
  if (lonlat[1:2] < -180 || lonlat[1:2] > 180) {
    stop("\nPlease check your longitude, `",
         paste0(lonlat[1:2]),
         "`, to be sure it is valid.\n")
  }
  if (lonlat[3:4] < -90 || lonlat[3:4] > 90) {
    stop(
      "\nPlease check your latitude, `",
      paste0(lonlat[3:4]),
      "`, value to be sure it is valid.\n"
    )
  }
  if (lonlat[1] > lonlat[2]) {
    stop("The first lon value must be the minimum value requested.")
  }
  if (lonlat[3] > lonlat[4]) {
    stop("The first lat value must be the minimum value requested.")
  }
}

# validate user entered variables, fail internally if not valid ----------------
.check_vars <- function(vars, type) {
  if (all(
    vars %in% c(
      "T2M",
      "T2MN",
      "T2MX",
      "RH2M",
      "toa_dwn",
      "swv_dwn",
      "lwv_dwn",
      "DFP2M",
      "RAIN",
      "WS10M"
    )
  )) {
    vars <- vars
  } else {
    stop("You have entered an invalid value for `vars`.")
  }

  # check global vars
  if (vars > 3 && type == "global") {
    stop("A max of three vars is allowed for a global query.")
  }
}

# check if POWER website is responding -----------------------------------------
#' @noRd
.check_response <- function(url) {
  tryCatch(
    httr::http_status(httr::GET(url)),
    error = function(c) {
      c$message <-
        paste0("\nThe POWER website does not appear to be responding.\n",
               "Please try again later.\n")
      stop(c)
    }
  )
}

# create a data.frame of the NASA - POWER data and add names -------------------
.check_nasa_df <- function(NASA) {
  # check if data is empty, stop if no data is available
  if (all(is.na(NASA[, -c(1:2)]))) {
    stop(
      "\nNo data are available as requested. If you are requesting very\n",
      "recent data, please be aware that there is a lag in availability\n",
      "(within two months of current time).\n"
    )
  }
}


# execute downloading and parsing data -----------------------------------------
.get_NASA <- function(power_url, download_vars, power_query) {
  # read lines from the NASA-POWER website
  NASA <- httr::GET(paste0("https://",
                           power_url,
                           download_vars),
                    query = power_query,
                    httr::progress())
  httr::stop_for_status(NASA)
  NASA <- httr::content(NASA, encoding = "UTF8")

  # clear console
  message("\n")

  NASA <- unlist(strsplit(NASA, "\n"))

  return(NASA)
}

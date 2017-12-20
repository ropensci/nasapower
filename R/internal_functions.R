


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
.check_vars <- function(vars) {
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
}

# create a data.frame of the NASA - POWER data and add names -------------------
.create_nasa_df <- function(NASA, stdate, endate) {
  out <- utils::read.table(
    text = NASA,
    skip = grep("-END HEADER-", NASA),
    na.strings = "-",
    nrows = as.numeric(endate - stdate) + 1,
    stringsAsFactors = FALSE
  )

  # check if data is empty, stop if no data is available
  if (all(is.na(out[, -c(1:2)]))) {
    stop(
      "\nNo data are available as requested. If you are requesting very\n",
      "recent data, please be aware that there is a lag in availability\n",
      "(within two months of current time).\n"
    )
  } else {
    return(out)
  }
}


# execute downloading and parsing data -----------------------------------------
.get_NASA <- function(durl) {
  # read lines from the NASA-POWER website
  NASA <- httr::GET(durl, httr::progress())
  httr::stop_for_status(NASA)
  NASA <- httr::content(NASA, encoding = "UTF8")

  # clear console
  message("\n")

  NASA <- unlist(strsplit(NASA, "\n"))

  return(NASA)
}

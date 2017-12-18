
# check if POWER website is responding
#' @noRd
.check_response <- function(url) {
  tryCatch(
    httr::http_status(httr::GET(url)), error = function(c) {
      c$message <- paste0(
        "\nThe POWER website does not appear to be responding.\n",
        "Please try again later.\n")
      stop(c)
    }
  )
}

# validate cell lon lat values
.check_lonlat_cell <- function(lonlat) {
  if (is.null(lonlat) | length(lonlat) != 2 | !is.numeric(lonlat)) {
    stop("\nlonlat must be provided in a length-2 numeric vector.\n")
  }
  if (lonlat[1] < -180 || lonlat[1] > 180) {
    stop("\nPlease check your longitude, `", paste0(lonlat[1]),
          "`, to be sure it is valid.\n")
  }
  if (lonlat[2] < -90 || lonlat[2] > 90) {
    stop("\nPlease check your latitude, `", paste0(lonlat[2]),
        "`, value to be sure it is valid.\n")
  }
}

# validate region lon lat values
.check_lonlat_region <- function(lonlat) {
  if (is.null(lonlat) | length(lonlat) != 4 | !is.numeric(lonlat)) {
    stop("\nlonlat must be provided in a length-2 numeric vector.\n")
  }
  if (lonlat[1:2] < -180 || lonlat[1:2] > 180) {
    stop("\nPlease check your longitude, `", paste0(lonlat[1:2]),
         "`, to be sure it is valid.\n")
  }
  if (lonlat[3:4] < -90 || lonlat[3:4] > 90) {
    stop("\nPlease check your latitude, `", paste0(lonlat[3:4]),
         "`, value to be sure it is valid.\n")
  }
  if (lonlat[1] > lonlat[2]) {
    stop("The first lon value must be the minimum value requested.")
  }
  if (lonlat[3] > lonlat[4]) {
    stop("The first lat value must be the minimum value requested.")
  }
}

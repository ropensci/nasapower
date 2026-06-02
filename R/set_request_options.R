#' Get Request Timeout Option
#'
#' Retrieves the timeout value for POWER API requests from the
#' `nasapower.timeout` option, falling back to a default of `10L` seconds
#' if not set.
#'
#' @returns An integer giving the timeout in seconds.
#'
#' @examples
#' # Use default
#' .get_timeout()
#'
#' # Override via option
#' options(nasapower.timeout = 60L)
#' .get_timeout()
#'
#' @dev
.get_timeout <- function() {
  val <- getOption("nasapower.timeout", default = 10L)
  if (!.is_boolean(val) && is.numeric(val) && length(val) == 1L && val > 0) {
    return(as.integer(val))
  }
  cli::cli_warn(
    c(
      "!" = "Invalid {.opt nasapower.timeout} value: {.val {val}}.",
      i = "Must be a single positive number. Using default: {.val 10L}."
    )
  )
  10L
}

#' Get Connection Timeout Option
#'
#' Retrieves the connection timeout value for POWER API requests from the
#' `nasapower.timeout.connect` option, falling back to a default of `5L`
#' seconds if not set.
#'
#' @returns An integer giving the connection timeout in seconds.
#'
#' @examples
#' # Use default
#' .get_timeout_connect()
#'
#' # Override via option
#' options(nasapower.timeout.connect = 10L)
#' .get_timeout_connect()
#'
#' @dev
.get_timeout_connect <- function() {
  val <- getOption("nasapower.timeout.connect", default = 5L)
  if (!.is_boolean(val) && is.numeric(val) && length(val) == 1L && val > 0) {
    return(as.integer(val))
  }
  cli::cli_warn(
    c(
      "!" = "Invalid {.opt nasapower.timeout.connect} value: {.val {val}}.",
      i = "Must be a single positive number. Using default: {.val 5L}."
    )
  )
  5L
}

#' Get Max Tries Option
#'
#' Retrieves the maximum number of request attempts for POWER API requests
#' from the `nasapower.max_tries` option, falling back to a default of `6L`
#' if not set.
#'
#' @returns An integer giving the maximum number of attempts.
#'
#' @examples
#' # Use default
#' .get_max_tries()
#'
#' # Override via option
#' options(nasapower.max_tries = 3L)
#' .get_max_tries()
#'
#' @dev
.get_max_tries <- function() {
  val <- getOption("nasapower.max_tries", default = 6L)
  if (!.is_boolean(val) && is.numeric(val) && length(val) == 1L && val >= 1) {
    return(as.integer(val))
  }
  cli::cli_warn(
    c(
      "!" = "Invalid {.opt nasapower.max_tries} value: {.val {val}}.",
      i = "Must be a single positive integer >= 1. Using default: {.val 6L}."
    )
  )
  6L
}

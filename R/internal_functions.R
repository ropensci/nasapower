
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

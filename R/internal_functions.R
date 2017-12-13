
# check if POWER website is responding
#' @noRd
.check_response <- function(url) {

  if (all(is.na(pingr::ping(url, count = 5)))) {
    stop("\nThe POWER website does not appear to be responding.\n",
         "Please try again later.\n")
  }
}
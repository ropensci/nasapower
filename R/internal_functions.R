
# check if POWER website is responding
#' @noRd
.check_response <- function(url) {

  if (httr::http_status(httr::GET(url))$category != "Success") {
    stop("\nThe POWER website does not appear to be responding.\n",
         "Please try again later.\n")
  }
}
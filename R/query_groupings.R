
#' Query the POWER API for Detailed Information on Available Parameter Groupings
#'
#' Queries the \acronym{POWER} \acronym{API} returning detailed information on
#'  available parameter groupings grouped by community followed by temporal
#'  \acronym{API} or if `global = TRUE`, grouped by climatology, then by the
#'  available types of parameters.
#'
#' @param global Boolean; should the query return global parameter groupings and
#'   attribute information?  Defaults to `FALSE` returning details for point
#'   data.
#'
#' @examplesIf interactive()
#'
#' # fetch groupings for parameters
#' query_groupings()
#'
#' # fetch groupings for global parameters
#' query_groupings(global = TRUE)
#'
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#'
#' @return A [list] object of information on parameter groupings in the
#'   \acronym{POWER} \acronym{API}.
#'
#' @export

query_groupings <- function(global = FALSE) {
  if (!.is_boolean(global)) {
    cli::cli_abort(
      c(x = "{.arg global} should be a Boolean value.",
        i = "{Please provide either {.var TRUE} or {.var FALSE}.")
    )
  }

  power_url <-
    "https://power.larc.nasa.gov/api/system/manager/system/groupings"

  if (isFALSE(global)) {
    response <-
      .send_mgmt_query(.url = power_url)

    response$raise_for_status()
    return(jsonlite::fromJSON(response$parse("UTF8")))

  } else {
    power_url <- sprintf("%s/global", power_url)
    response <-
      .send_mgmt_query(.url = power_url)

    response$raise_for_status()
    return(jsonlite::fromJSON(response$parse("UTF8")))
  }
}

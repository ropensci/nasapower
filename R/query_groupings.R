#' Query the POWER API for Detailed Information on Available Parameter Groupings
#'
#' Queries the POWER API returning detailed information on available parameter
#' groupings. Results are grouped by community followed by temporal API, or if
#' `global = TRUE`, grouped by climatology then by available parameter types.
#'
#' @param global Boolean; should the query return global parameter groupings and
#'   attribute information? Defaults to `FALSE`, returning details for point data.
#'
#' @examplesIf interactive()
#' # Fetch groupings for parameters
#' query_groupings()
#'
#' # Fetch groupings for global parameters
#' query_groupings(global = TRUE)
#'
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#'
#' @returns A list object of information on parameter groupings in the POWER API.
#'
#' @export
query_groupings <- function(global = FALSE) {
  if (!.is_boolean(global)) {
    cli::cli_abort(
      c(
        x = "{.arg global} should be a Boolean value.",
        i = "Please provide either {.var TRUE} or {.var FALSE}."
      )
    )
  }

  power_url <- "https://power.larc.nasa.gov/api/system/manager/system/groupings"

  if (isTRUE(global)) {
    power_url <- paste0(power_url, "/global")
  }

  response <- .send_mgmt_query(.url = power_url)

  yyjsonr::read_json_raw(response$content)
}

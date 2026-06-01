#' Query the POWER API for Detailed Information on Available Parameters
#'
#' Queries the POWER API returning detailed information on available parameters.
#' For a list of all available parameters, see `parameters`.
#'
#' @param community An optional character vector providing community name:
#'   "ag", "sb", or "re".
#' @param pars An optional character string of a single solar, meteorological,
#'   or climatology parameter to query. If not provided, all parameters are
#'   returned.
#' @param temporal_api An optional character vector indicating the temporal
#'   API endpoint for data being queried. Supported values are "hourly",
#'   "daily", "monthly", or "climatology".
#' @param metadata Boolean; retrieve extra parameter metadata? This is only
#'   applicable if you supply both `community` and `temporal_api`; otherwise
#'   it will be ignored. Defaults to `FALSE`.
#'
#' @section Argument details for `temporal_api`:
#' There are four valid values:
#' \describe{
#'   \item{hourly}{The hourly average of parameters by hour, day, month, and
#'     year.}
#'   \item{daily}{The daily average of parameters by day, month, and year.}
#'   \item{monthly}{The monthly average of parameters by month and year.}
#'   \item{climatology}{Parameters as 22-year climatologies (solar) and
#'     30-year climatologies (meteorology); includes period climatology and
#'     monthly average, maximum, and/or minimum values.}
#' }
#'
#' @examplesIf interactive()
#' # Fetch complete attribute information for "T2M"
#' query_parameters(pars = "T2M")
#'
#' # Fetch temporal and community-specific attribute information
#' # for "T2M" in the "ag" community for the "hourly" temporal API
#' query_parameters(
#'   pars = "T2M",
#'   community = "ag",
#'   temporal_api = "hourly"
#' )
#'
#' # Fetch all parameters in the "ag" community for "hourly" temporal API
#' query_parameters(
#'   community = "ag",
#'   temporal_api = "hourly"
#' )
#'
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#'
#' @returns A list object of information for the requested parameter(s),
#'   community(ies), and temporal API(s).
#'
#' @export
query_parameters <- function(
  community = NULL,
  pars = NULL,
  temporal_api = NULL,
  metadata = FALSE
) {
  .COMMUNITY_VALS <- c("AG", "RE", "SB")
  .TEMPORAL_API_VALS <- c("DAILY", "MONTHLY", "HOURLY", "CLIMATOLOGY")

  if (!.is_boolean(metadata)) {
    cli::cli_abort(
      c(
        x = "{.arg metadata} should be a Boolean value.",
        i = "Please provide either {.var TRUE} or {.var FALSE}."
      )
    )
  }

  # Validate and normalize community
  if (!is.null(community)) {
    community <- toupper(community)
    community <- rlang::arg_match(community, .COMMUNITY_VALS)
  }

  # Validate and normalize temporal_api
  if (!is.null(temporal_api)) {
    temporal_api <- toupper(temporal_api)
    temporal_api <- rlang::arg_match(temporal_api, .TEMPORAL_API_VALS)
  }

  # Validate and format parameters
  if (!is.null(pars)) {
    pars <- toupper(pars)
    pars <- .check_pars(
      pars = pars,
      community = community,
      temporal_api = temporal_api
    )
  }

  power_url <- "https://power.larc.nasa.gov/api/system/manager/parameters"

  # Branch 1: No community or temporal_api provided
  if (is.null(community) && is.null(temporal_api)) {
    query_url <- if (is.null(pars)) {
      paste0(power_url, "?user=nasapower4r")
    } else {
      paste0(power_url, "/", pars, "?user=nasapower4r")
    }

    response <- .send_mgmt_query(.url = query_url)
    return(yyjsonr::read_json_raw(response$content))
  }

  # Branch 2: Query with community and/or temporal_api
  query_list <- list(
    community = community,
    parameters = pars,
    temporal = temporal_api,
    metadata = metadata,
    user = "nasapower4r"
  )

  # Remove NULL/empty elements
  query_list <- query_list[lengths(query_list) != 0L]

  response <- .send_query(.query_list = query_list, .url = power_url)

  yyjsonr::read_json_raw(response$content)
}

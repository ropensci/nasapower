
#' Query the POWER API for Detailed Information on Available Parameters
#'
#' Queries the \acronym{POWER} \acronym{API} returning detailed information on
#'  available parameters.  For a list of all available parameters, use
#'  `parameters`
#'
#' @param community An optional character vector providing community name:
#'   \dQuote{ag}, \dQuote{sb} or \dQuote{re}.
#' @param pars A required character string of a single solar, meteorological or
#'  climatology parameter to query.
#' @param temporal_api An optional character vector indicating the temporal
#'   \acronym{API} end-point for data being queried, supported values are
#'   \dQuote{hourly}, \dQuote{daily}, \dQuote{monthly} or \dQuote{climatology}.
#' @param metadata `Boolean`; retrieve extra parameter metadata?  This is only
#'  applicable if you supply the `community` and `temporal_api`, if these values
#'  are not provided it will be ignored.  Defaults to
#'   `FALSE`.
#'
#' @section Argument details for `temporal_api`: There are four valid values.
#'  \describe{
#'   \item{hourly}{The hourly average of `pars` by hour, day, month and year.}
#'   \item{daily}{The daily average of `pars` by day, month and year.}
#'   \item{monthly}{The monthly average of `pars` by month and year.}
#'   \item{climatology}{Provide parameters as 22-year climatologies (solar)
#'    and 30-year climatologies (meteorology); the period climatology and
#'    monthly average, maximum, and/or minimum values.}
#'  }
#'
#' @examplesIf interactive()
#'
#' # fetch the complete set of attribute information for "T2M".
#' query_parameters(pars = "T2M")
#'
#' # fetch complete temporal and community specific attribute information
#' # for "T2M" in the "ag" community for the "hourly" temporal API.
#' query_parameters(pars = "T2M",
#'                  community = "ag",
#'                  temporal_api = "hourly")
#'
#' # fetch complete temporal and community specific attribute information
#' # for all parameters in the "ag" community for the "hourly" temporal API.
#' query_parameters(community = "ag",
#'                  temporal_api = "hourly")
#'
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#'
#' @return A [list] object of information for the requested parameter(s) (if
#'  requested), community(ies) and temporal \acronym{API}(s).
#'
#' @export

query_parameters <- function(community = NULL,
                             pars,
                             temporal_api = NULL,
                             metadata = FALSE) {
  community_vals <- c("AG", "RE", "SB")
  temporal_api_vals <- c("DAILY",
                         "MONTHLY",
                         "HOURLY",
                         "CLIMATOLOGY")

  # if the args for `community` and `temporal_api` are not empty, check and
  # then reset `community_vals` and `temporal_api_vals` for use later

  if (!is.null(community)) {
    community <- toupper(community)

    if (community %notin% community_vals) {
      cli::cli_abort(c(x = "{.arg community} does not match any valid values for {.var community}."))
    }
    community_vals <- community
  }

  if (!is.null(temporal_api)) {
    temporal_api <- toupper(temporal_api)
    if (temporal_api %notin% temporal_api_vals) {
      cli::cli_abort(
        c(x = "{.arg temporal_api} does not match any valid values for {.var temporal_api}.")
      )
    }
    temporal_api_vals <- temporal_api
  }

  pars <- toupper(pars)
  pars <-
    .check_pars(pars = pars,
                community = community_vals,
                temporal_api = temporal_api_vals)

  power_url <-
    "https://power.larc.nasa.gov/api/system/manager/parameters"

  if (is.null(community) && is.null(temporal_api)) {
    return(jsonlite::fromJSON(sprintf(
      "%s/%s?user=nasapower4r", power_url, pars
    )))
  } else {

    if (!.is_boolean(metadata)) {
      cli::cli_abort(
        c(x = "{.arg metadata} should be a Boolean value.",
          i = "{Please provide either {.var TRUE} or {.var FALSE}.")
      )
    }

    query_list <-
      list(
        community = community,
        parameters = pars,
        temporal = temporal_api,
        metadata = metadata,
        user = "nasapower4r"
      )

    query_list <- query_list[lengths(query_list) != 0]
    response <- .send_query(.query_list = query_list,
                            .url = power_url)

    return(jsonlite::fromJSON(response$parse(encoding = "UTF8")))
  }
}

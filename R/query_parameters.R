
#' Query the POWER API for Detailed Information on Available Parameters
#'
#' Queries the \acronym{POWER} \acronym{API} returning detailed information on
#'  available parameters.
#'
#' @details If `pars` is not provided all possible parameters for the provided
#'  community, `community` and temporal \acronym{API}, `temporal_api` will be
#'  returned.  If only a single parameter is supplied with no `community` or
#'  `temporal_api` then the complete attribute information for that parameter
#'  will be returned for all possible communities and temporal \acronym{API}s
#'  combinations.  If all three values are provided, only the information for
#'  that specific combination of parameter, temporal \acronym{API} and community
#'  will be returned. If none of the three are provided, all combinations are
#'  returned.
#'
#' @param community An optional character vector providing community name:
#'   \dQuote{ag}, \dQuote{sb} or \dQuote{re}.
#' @param pars An optional character vector of a single solar, meteorological or
#'  climatology parameter to query.  If unsure, omit this argument for for a
#'  full list of all the parameters available for each temporal \acronym{API}
#'  and community.
#' @param temporal_api An optional character vector indicating the temporal
#'   \acronym{API} end-point for data being queried, supported values are
#'   \dQuote{hourly}, \dQuote{daily}, \dQuote{monthly} or \dQuote{climatology}.
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
#'  requested), community and temporal \acronym{API}.
#'
#' @export

query_parameters <- function(community = NULL,
                             pars = NULL,
                             temporal_api = NULL) {

  if (!is.null(community)) {
    community <- toupper(community)
  }
  if (!is.null(pars)) {
    pars <- toupper(pars)
    pars <-
      .check_pars(pars = pars,
                  community = community,
                  temporal_api = temporal_api)
  }
  if (!is.null(temporal_api)) {
    temporal_api <- toupper(temporal_api)
  }

  power_url <-
    "https://power.larc.nasa.gov/api/system/manager/parameters"
  user_agent <- .create_ua_string()

  # if only a `par` is provided, then create URL w/o using {crul} and parse w/
  # {jsonlite}, otherwise use {crul} to fetch from the API
  if (is.null(community) || is.null(temporal_api) && !is.null(pars)) {
    return(jsonlite::fromJSON(sprintf(
      "%s/%s?user=%s", power_url, pars, user_agent
    )))
  } else {
    if (is.null(community) || is.null(temporal_api)) {
      cli::cli_abort(
        "`commmunity` and `temporal_api` strings must be supplied."
        )
    }

    query_list <-
      list(
        community = community,
        parameters = par,
        temporal = temporal_api,
        user = user_agent
      )

    # if a `par` isn't supplied, remove this from the query list or leave as-is
    query_list <- query_list[lengths(query_list) != 0]

    response <- .send_query(.query_list = query_list,
                            .temporal_api = temporal_api,
                            .url = power_url)

    return(jsonlite::fromJSON(response$parse(encoding = "UTF8")))
  }
}

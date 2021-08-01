
#' Query the POWER API for detailed information on a given POWER parameter
#'
#' Queries the \acronym{POWER} \acronym{API} returning detailed information on
#'  a single user-provided parameter, `par`.
#'
#' @param par A character vector of a single solar, meteorological or
#'  climatology parameter to query.  If unsure check [query_parameters()] for a
#'  full list of parameters available for each temporal \acronym{API} and
#'  community.
#' @return A [list] defining the given `par` and providing valid temporal
#'  \acronym{API} endpoints and communities for the given `par`.
#'
#' @examplesIf interactive()
#' query_par("T2M")
#'
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#'
#' @seealso query_parameters
#'
#' @export
query_par <- function(par) {
  par <- toupper(par)
  par_def <-
    jsonlite::fromJSON(paste0(getOption("nasapower_base_url"),
                              "parameters/",
                              par))
  return(par_def)
}


#' Query the POWER API for parameter descriptions
#'
#' Queries the \acronym{POWER} \acronym{API} for detailed information for all
#'  parameters provided by the user-provided community and temporal \acronym{API}
#'  endpoints.
#'
#' @param temporal_api Temporal average for data being queried, supported
#'   values are \dQuote{hourly}, \dQuote{daily}, \dQuote{monthly} or
#'   \dQuote{climatology}.  See argument details for more.
#' @param community A character vector providing community name: \dQuote{ag},
#'   \dQuote{sb} or \dQuote{re}.  See argument details for more.
#'
#' @section Argument details for \dQuote{community}: there are three valid
#'   values, one must be supplied.  This  will affect the units of the parameter
#'   and the temporal display of time series data.
#'
#' \describe{
#'   \item{ag}{Provides access to the Agroclimatology Archive, which
#'  contains industry-friendly parameters formatted for input to crop models.}
#'
#'  \item{sb}{Provides access to the Sustainable Buildings Archive, which
#'  contains industry-friendly parameters for the buildings community to include
#'  parameters in multi-year monthly averages.}
#'
#'  \item{re}{Provides access to the Renewable Energy Archive, which contains
#'  parameters specifically tailored to assist in the design of solar and wind
#'  powered renewable energy systems.}
#'  }
#'
#' @section Argument details for `temporal_average`: There are four valid
#'  values.
#'  \describe{
#'   \item{hourly}{The hourly average of `pars` by hour, day, month and
#'    year.}
#'   \item{daily}{The daily average of `pars` by day, month and year.}
#'   \item{monthly}{The monthly average of `pars` by month and year.}
#'   \item{climatology}{Provide parameters as 22-year climatologies (solar)
#'    and 30-year climatologies (meteorology); the period climatology and
#'    monthly average, maximum, and/or minimum values.}
#'  }
#'
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#'
#' @return A [list] of definitions providing valid parameters and their
#'  definitions for each of the three \acronym{API} endpoints and three
#'  communities
#'
#' @examplesIf interactive()
#' # Get a full list of all valid parameters for the 'DAILY' API for the 'AG'
#' # community
#' query_parameters(temporal_api = "DAILY", community = "AG")
#'
#' @seealso query_par
#'
#' @export
#'
query_parameters <- function(temporal_api, community) {

  temporal_api <- toupper(temporal_api)
  community <- toupper(community)

  query_hourly_ag <- function()

  parameters <-
    jsonlite::fromJSON(
      paste0(
        getOption("mypkg-myval"),
        "parameters?temporal=",
        temporal_api,
        "&community=",
        community
      )
    )
}
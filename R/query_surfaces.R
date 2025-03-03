#' Query the POWER API for Detailed Information on Wind Type Surfaces
#'
#' Queries the \acronym{POWER} \acronym{API} returning detailed information on
#'   all (or just one) wind elevation surface alias and attribute information.
#'
#' @param surface_alias An optional character vector providing a wind surface
#'   alias available from the \acronym{POWER} \acronym{API}.  All values are
#'   returned if this value is not provided.
#'
#' @examplesIf interactive()
#'
#' # fetch all wind surface information
#' query_surfaces()
#'
#' # fetch surface information for `airportgrass`
#' query_surfaces(surface_alias = "airportgrass")
#'
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#'
#' @returns A [list] object of information for the requested wind surface(s).
#'
#' @export

query_surfaces <- function(surface_alias = NULL) {
  power_url <-
    "https://power.larc.nasa.gov/api/system/manager/surface"

  if (is.null(surface_alias)) {
    response <-
      .send_mgmt_query(.url = power_url)

    response$raise_for_status()
    return(yyjsonr::read_json_raw(response$content))
  } else {
    wind_surface <- .match_surface_alias(surface_alias)
    power_url <- sprintf("%s/%s", power_url, wind_surface)
    response <-
      .send_mgmt_query(.url = power_url)

    response$raise_for_status()
    return(yyjsonr::read_json_raw(response$content))
  }
}

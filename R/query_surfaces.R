#' Query the POWER API for Detailed Information on Wind Type Surfaces
#'
#' Queries the POWER API returning detailed information on all (or just one)
#' wind elevation surface alias and attribute information.
#'
#' @param surface_alias An optional character vector providing a wind surface
#'   alias available from the POWER API. All values are returned if not
#'   provided.
#'
#' @examplesIf interactive()
#' # Fetch all wind surface information
#' query_surfaces()
#'
#' # Fetch surface information for "airportgrass"
#' query_surfaces(surface_alias = "airportgrass")
#'
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#'
#' @returns A list object of information for the requested wind surface(s).
#'
#' @export
query_surfaces <- function(surface_alias = NULL) {
  power_url <- "https://power.larc.nasa.gov/api/system/manager/surface"

  if (!is.null(surface_alias)) {
    wind_surface <- .match_surface_alias(surface_alias)
    power_url <- paste0(power_url, "/", wind_surface)
  }

  response <- .send_mgmt_query(.url = power_url)

  yyjsonr::read_json_raw(response$content)
}


#'@title Get NASA-POWER Data and Return a Tidy Data Frame
#'
#'@description Get NASA-POWER data and return a tidy data frame. All options
#'offered by the official NASA-POWER API are supported.
#'
#'@export
#'@param community Dataset name, currently supported are AG, SB and SSE. See
#'  argument details for more.
#'@param latlon A numeric vector of geographic coordinates for a cell or region
#'  entered as x, y coordinates or `Global` for global area.  See argument
#'  details for more.
#'@param pars A character vector of solar or meteorological variables to
#'  download.  See the `Value` field of [`parameters`] for a full list of valid
#'  values or visit the [POWER website](https://power.larc.nasa.gov/new/) for
#'  the Parameter Dictionary.  If downloading global coverage a maximum of 3
#'  `pars` can be specified at one time.
#'@param dates A character vector of start and end dates in that order, *e.g.*,
#'  `dates = c("1983-01-01", "2017-12-31")`.  Not required for global
#'  coverage.  See argument details for more.
#'@param temporal_average Temporal average for data being queried, currently
#'  supported are DAILY, INTERANNUAL, CLIMATOLOGY.  See argument details for
#'  more.
#'
#'@details Further details for each of the arguments are provided in their
#'respective sections following below.
#'
#'@section Argument details for `community`: There are three valid values, one
#'  must be supplied. This  will affect the units of the parameter and the
#'  temporal display of time series data.
#'
#'  \describe{
#'  \item{AG}{Provides access to the Agroclimatology Archive, which
#'  contains industry-friendly parameters formatted for input to crop models.}
#'
#'  \item{SB}{Provides access to the Sustainable Buildings Archive, which
#'  contains industry-friendly parameters for the buildings community to include
#'  parameters in multi-year monthly averages.}
#'
#'  \item{SSE}{Provides access to the Renewable Energy Archive, which contains
#'  parameters specifically tailored to assist in the design of solar and wind
#'  powered renewable energy systems.}
#'  }
#'
#'@section Argument details for `latlon`:
#' \describe{
#'  \item{For a single point}{To get a specific cell, 1/2 x 1/2 degree, supply a
#'  length-2 numeric vector giving the decimal degree longitude and latitude in
#'  that order for data to download, *e.g.*, `latlon = c(-179.5, -89.5)`.}
#'
#'  \item{For regional coverage}{To get a region, supply a length-4 numeric
#'  vector as lower left (lat, lon) and upper right (lat, lon) coordinates,
#'  e.g., `latlon = c(ymin, xmin, ymax, xmax)` in that order for a given
#'  region, *e.g.*, a bounding box for the southwestern corner of Australia:
#'  `latlon = c(-55.5,, 112.5, -50.5, 115.5)`. *Max bounding box is 10 x 10
#'  degrees* of 1/2 x 1/2 degree data, *i.e.*, 100 points maximum in total.}
#'
#'  \item{For global coverage}{To get global coverage for long term
#'  monthly averages for the entire globe use `Global` in place of
#'  `latlon` values. `temporal_average` will automatically be set to
#'  `climatology` if this option is set.}
#' }
#'
#'@section Argument details for `dates`: If `dates` is unspecified, defaults to
#'  a start date of 1983-01-01 (the earliest available data) and an end date of
#'  current date according to the system.
#'
#'  If one date only is provided, it will be treated as both the start date and
#'  the end date and only a single day's values will be returned.
#'
#'@section Argument details for `temporal_average`: There are three valid
#'  values, one must be supplied. \describe{ \item{DAILY}{The daily average of
#'  `pars` by year.} \item{INTERANNUAL}{The monthly average of `pars` by year.}
#'  \item{CLIMATOLOGY}{The monthly average of `pars` at the surface of the earth
#'  for a given month, averaged for that month over the 30-year period (Jan.
#'  1984 - Dec. 2013).} }
#'
#'@references
#'\url{https://power.larc.nasa.gov/documents/Agroclimatology_Methodology.pdf}
#'
#'@examples
#'# Fetch temperature and relative humidity for January 1 1985
#'
#'\dontrun{
#'power <- get_power(community = "AG",
#'                   latlon = c(-179.5, -89.5),
#'                   pars = c("RH2M", "T2M"),
#'                   dates = "1985-01-01",
#'                   temporal_average = "daily")
#'}
#'
#'@author Adam H. Sparks, adamhsparks@gmail.com
#'
get_power <- function(community = NULL,
                      latlon = NULL,
                      pars = NULL,
                      dates = NULL,
                      temporal_average = NULL) {
  # user input checks and formatting -------------------------------------------
  # see internal_functions.R for these functions
  latlon <- check_global(latlon)
  dates <- check_dates(dates, latlon)
  pars <- check_pars(pars,
                     temporal_average,
                     latlon)
  latlon_identifier <- check_latlon(latlon,
                                    pars)
  community <- check_community(community)

  # submit query ---------------------------------------------------------------
  # see internal_functions.R for this function
  NASA <- power_query(community,
                      latlon_identifier,
                      pars,
                      dates)
  return(NASA)
}

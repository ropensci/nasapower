
#' Get NASA POWER data from the POWER web API
#'
#' @description Get \acronym{POWER} global meteorology and surface solar energy
#'   climatology data and return a tidy data frame [tibble::tibble()]
#'   object. All options offered by the official \acronym{POWER} \acronym{API}
#'   are supported.
#'
#' @param community A character vector providing community name: \dQuote{ag},
#'   \dQuote{sb} or \dQuote{re}.  See argument details for more.
#' @param pars A character vector of solar, meteorological or climatology
#'   parameters to download.  If downloading \dQuote{climatology} a maximum of
#'   three `pars` can be specified at one time, for \dQuote{daily} and
#'   \dQuote{monthly} a maximum of 20 can be specified at one time.
#' @param temporal_average Temporal average for data being queried, supported
#'   values are \dQuote{hourly}, \dQuote{daily}, \dQuote{monthly} or
#'   \dQuote{climatology}.  See argument details for more.
#' @param lonlat A numeric vector of geographic coordinates for a cell or region
#'   entered as x, y coordinates or \dQuote{global} for global coverage (only
#'   used for \dQuote{climatology}).  See argument details for more.
#' @param dates A character vector of start and end dates in that order,\cr
#'   _e.g._, `dates = c("1983-01-01", "2017-12-31")`.
#'   Not used when\cr `temporal_average` is set to \dQuote{climatology}.
#'   See argument details for more.
#' @param site_elevation A user-supplied value for elevation at a single point
#'   in metres.  If provided this will return a corrected atmospheric pressure
#'   value adjusted to the elevation provided.  Only used with `lonlat` as a
#'   single point of x, y coordinates, not for use with \dQuote{global} or with
#'   a regional request.
#' @param wind_elevation A user-supplied value for elevation at a single point
#'   in metres.  Wind Elevation values in Meters are required to be between 10m
#'   and 300m.  Only used with `lonlat` as a single point of x, y coordinates,
#'   not for use with \dQuote{global} or with a regional request.  If this
#'   parameter is provided, the `wind-surface` parameter is required with the
#'   request, see \url{https://power.larc.nasa.gov/beta/docs/methodology/meteorology/wind/}
#' @param wind_surface A user-supplied wind surface for which the corrected
#'   wind-speed is to be supplied.  See `wind-surface` section for more detail.
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
#' @section Argument details for `lonlat`:
#' \describe{
#'  \item{For a single point}{To get a specific cell, 1/2 x 1/2 degree, supply a
#'  length-two numeric vector giving the decimal degree longitude and latitude
#'  in that order for data to download,\cr
#'  _e.g._, `lonlat = c(-179.5, -89.5)`.}
#'
#'  \item{For regional coverage}{To get a region, supply a length-four numeric
#'  vector as lower left (lon, lat) and upper right (lon, lat) coordinates,
#'  _e.g._, `lonlat = c(xmin, ymin, xmax, ymax)` in that order for a
#'  given region, _e.g._, a bounding box for the south western corner of
#'  Australia: `lonlat = c(112.5, -55.5, 115.5, -50.5)`.  *Maximum area
#'  processed is 4.5 x 4.5 degrees (100 points).}
#'
#'  \item{For global coverage}{To get global coverage for \dQuote{climatology},
#'  supply \dQuote{global} while also specifying \dQuote{climatology} for the
#'  `temporal_average`.}
#' }
#'
#' @section Argument details for `dates`: if one date only is provided, it
#'   will be treated as both the start date and the end date and only a single
#'   day's values will be returned, _e.g._, `dates = "1983-01-01"`.
#'   When `temporal_average` is set to \dQuote{monthly}, use only two
#'   year values (YYYY), _e.g._ `dates = c(1983, 2010)`.  This
#'   argument should not be used when `temporal_average` is set to
#'   \dQuote{climatology}.
#'
#' @section wind-surface: There are 17 surfaces that may be used for corrected
#'   wind-speed values using the following equation:
#'   \deqn{WSC_hgt = WS_10m\times(\frac{hgt}{WS_50m})^\alpha}{WSC_hgt = WS_10m*(hgt/WS_50m)^\alpha}
#'   Valid surface types are described here.
#'
#' \describe{
#'   \item{vegtype_1}{35-m broadleaf-evergreen trees (70% coverage)}
#'   \item{vegtype_2}{20-m broadleaf-deciduous trees (75% coverage)}
#'   \item{vegtype_3}{20-m broadleaf and needleleaf trees (75% coverage)}
#'   \item{vegtype_4}{17-m needleleaf-evergreen trees (75% coverage)}
#'   \item{vegtype_5}{14-m needleleaf-deciduous trees (50% coverage)}
#'   \item{vegtype_6}{Savanna:18-m broadleaf trees (30%) & groundcover}
#'   \item{vegtype_7}{0.6-m perennial groundcover (100%)}
#'   \item{vegtype_8}{0.5-m broadleaf shrubs (variable %) & groundcover}
#'   \item{vegtype_9}{0.5-m broadleaf shrubs (10%) with bare soil}
#'   \item{vegtype_10}{Tundra: 0.6-m trees/shrubs (variable %) & groundcover}
#'   \item{vegtype_11}{Rough bare soil}
#'   \item{vegtype_12}{Crop: 20-m broadleaf-deciduous trees (10%) & wheat}
#'   \item{vegtype_20}{Rough glacial snow/ice}
#'   \item{seaice}{Smooth sea ice}
#'   \item{openwater}{Open water}
#'   \item{airportice}{Airport: flat ice/snow}
#'   \item{airportgrass}{Airport: flat rough grass}
#' }
#'
#' @note The associated metadata shown in the decorative header are not saved if
#'   the data are exported to a file format other than a native \R data format,
#'   _e.g._, .Rdata, .rda or .rds.
#'
#' @return A data frame as a `POWER.Info` class, an extension of the
#' [tibble::tibble], object of \acronym{POWER} data including location, dates
#' (not including \dQuote{climatology}) and requested parameters.  A decorative
#' header of metadata is included in this object.
#'
#' @references
#' <https://power.larc.nasa.gov/docs/methodology/>
#' <https://power.larc.nasa.gov>
#'
#' @examplesIf interactive()
#'
#' # Fetch daily "ag" community temperature, relative humidity and precipitation
#' # for January 1 1985 at Kingsthorpe, Queensland, Australia
#' ag_d <- get_power(
#'   community = "ag",
#'   lonlat = c(151.81, -27.48),
#'   pars = c("RH2M", "T2M", "PRECTOTCORR"),
#'   dates = "1985-01-01",
#'   temporal_average = "daily"
#' )
#'
#' ag_d
#'
#' # Fetch single point climatology for air temperature
#' ag_c_point <- get_power(
#'   community = "ag",
#'   pars = "T2M",
#'   c(151.81, -27.48),
#'   temporal_average = "climatology"
#' )
#'
#' ag_c_point
#'
#' # Fetch global ag climatology for air temperature
#' ag_c_global <- get_power(
#'   community = "ag",
#'   pars = "T2M",
#'   lonlat = "global",
#'   temporal_average = "climatology"
#' )
#'
#' ag_c_global
#'
#' # Fetch interannual solar cooking parameters for a given region
#' sse_i <- get_power(
#'   community = "re",
#'   lonlat = c(112.5, -55.5, 115.5, -50.5),
#'   dates = c("1984", "1985"),
#'   temporal_average = "monthly",
#'   pars = c("CLRSKY_SFC_SW_DWN", "ALLSKY_SFC_SW_DWN")
#' )
#'
#' sse_i
#'
#' @author Adam H. Sparks \email{adamhsparks@@gmail.com}
#'
#' @export
get_power <- function(community,
                      pars,
                      temporal_average,
                      lonlat,
                      dates = NULL,
                      site_elevation = NULL,
                      wind_elevation = NULL,
                      wind_surface = NULL) {

  # user input checks and formatting -------------------------------------------

    # I've kept "temporal_average" for backwards compatibility in user inputs.
  # However, POWER uses the term "temporal API", for internal purposes, I do the
  # same starting here for referring to API calls in the same fashion.

  if (is.character(temporal_average)) {
    temporal_api <- toupper(temporal_average)
    if (temporal_api == "climatology") {
      dates <- NULL
    }
  }
  if (temporal_api %notin% c("HOURLY", "DAILY", "MONTHLY", "CLIMATOLOGY")) {
    stop(
      call. = FALSE,
      "\nYou have entered an invalid value for `temporal_average`.\n")
  }
  if (is.character(community)) {
    community <- toupper(community)
  }
  if (community %notin% c("AG", "SB", "RE")) {
    stop(call. = FALSE,
         "\nYou have provided an invalid `community` value.\n")
  }
   if (is.character(pars)) {
    pars <- toupper(pars)
  }
  if (isFALSE(length(lonlat != 2)) & !is.null(site_elevation)) {
    message("\nYou have provided `site_elevation` for a region or `global`.",
            "\nThe `site_elevation` value will be ignored.")
    site_elevation <- NULL
  }
  if (!is.null(site_elevation) && !is.numeric(site_elevation)) {
    stop(
      call. = FALSE,
      "\nYou have entered an invalid value for `site_elevation`.\n")
  }
  if (is.character(lonlat)) {
    lonlat <- tolower(lonlat)
    if (lonlat == "global" & temporal_api != "climatology") {
      stop(call. = FALSE,
           "\nYou have asked for 'global' data. However, this is only",
           "available for 'climatology'.\n")
    } else if (lonlat != "global") {
      stop(call. = FALSE,
           "\nYou have entered an invalid value for `lonlat`. Valid values are",
           "`global` with `climatology` or a string of lon and lat values.\n")
    }
  }

    # see internal_functions.R for these functions prefixed with "."
    pars <- .check_pars(
      pars,
      community,
      temporal_api,
    )
    lonlat_identifier <- .check_lonlat(
      lonlat,
      pars
    )

    # submit query -------------------------------------------------------------
    query_list <- .build_query(
      community,
      lonlat_identifier,
      pars,
      dates,
      site_elevation,
      wind_elevation,
      wind_surface
    )
    out <-
      .send_query(.query_list = query_list,
                  .pars = pars,
                  .temporal_api = temporal_average)
    out <-
      .import_power(.txt = out,
                    .pars = pars,
                    .query_list = query_list)
    return(out)
  }

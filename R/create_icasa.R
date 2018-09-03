
#' @title Create a DSSAT ICASA File from NASA - POWER Data
#'
#' @description Get NASA-POWER values for a single point or region and create
#' an ICASA format text file suitable for use in DSSAT for crop modelling saving
#' it to local disk.
#'
#' @export
#' @param lonlat A numeric vector of geographic coordinates for a cell or region
#'  entered as x, y coordinates.  See argument details for more.
#' @param dates A character vector of start and end dates in that order,\cr
#'  *e.g.*, `dates = c("1983-01-01", "2017-12-31")`.  See argument details for
#'  more.
#' @param dsn A file path where the resulting text file should be stored.
#' @param file_out A file name for the resulting text file, _e.g._ "ICASA.txt".
#' A ".txt" extension will be appended if not or otherwise specified by user.
#'
#' @details This function is essentially a wrapper for \code{\link{get_power}}
#' queryies the POWER API and writes a DSSAT ICASA weather file to disk. All
#' necessary `pars` are automatically included in the query.
#'
#' Further details for each of the arguments are provided in their
#' respective sections following below.
#'
#' @section Argument details for `lonlat`:
#' \describe{
#'  \item{For a single point}{To get a specific cell, 1/2 x 1/2 degree, supply a
#'  length-2 numeric vector giving the decimal degree longitude and latitude in
#'  that order for data to download,\cr
#'  *e.g.*, `lonlat = c(151.81, -27.48)`.}
#'
#'  \item{For regional coverage}{To get a region, supply a length-4 numeric
#'  vector as lower left (lon, lat) and upper right (lon, lat) coordinates,
#'  *e.g.*, `lonlat = c(xmin, ymin, xmax, ymax)` in that order for a given
#'  region, *e.g.*, a bounding box for the southwestern corner of Australia:
#'  `lonlat = c(112.5, -55.5, 115.5, -50.5)`. *Max bounding box is 10 x 10
#'  degrees* of 1/2 x 1/2 degree data, *i.e.*, 100 points maximum in total.}
#' }
#'
#' @section Argument details for `dates`: If `dates` is unspecified, defaults to
#'  a start date of 1983-01-01 (the earliest available data) and an end date of
#'  current date according to the system.
#'
#'  If one date only is provided, it will be treated as both the start date and
#'  the end date and only a single day's values will be returned.
#'
#' @examples
#' # Create an ICASA file for Kingsthorpe, Qld from 1985-01-01 to 1985-06-30 and
#' # save it in "Documents".
#'
#' \dontrun{
#' create_icasa(lonlat = c(151.81, -27.48),
#'              dates = c("1985-01-01", "1985-12-31"),
#'              dsn = "~/Documents",
#'              file = "ICASA.txt"
#' )
#' }
#'
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#'
create_icasa <- function(lonlat,
                         dates,
                         dsn = NULL,
                         file_out = NULL) {

  temporal_average <- "DAILY"
  pars <- c("T2M") # this is a dummy variable to check lonlat values,
                   # POWER will automatically select the proper pars for query

  if (!is.numeric(lonlat) && toupper(lonlat) == "GLOBAL") {
    stop(
      call. = FALSE,
      "The `lonlat` must be numeric values. Global coverage is not ",
      "available for `create_icasa()`"
    )
  }

  if (is.null(file_out) | is.null(dsn)) {
    message(
      call. = FALSE,
      "You you have not specifed a name or disk location defaulting to",
      path.expand("~"), "/ICASA.txt."
    )
    file_out <- "ICASA.txt"
    dsn <- path.expand("~")
  }

  if (substr(file_out, nchar(file_out) - 3, nchar(file_out)) != ".txt") {
    file_out <- paste0(file_out, ".txt")
  }

  # user input checks and formatting -------------------------------------------
  # see internal_functions.R for these functions
  lonlat <- check_global(lonlat)
  dates <- check_dates(dates,
                       lonlat,
                       temporal_average)
  pars <- check_pars(pars,
                     temporal_average,
                     lonlat)
  lonlat_identifier <- check_lonlat(lonlat,
                                    pars)

  out <- power_query(community = "AG",
                     lonlat_identifier,
                     pars,
                     dates = dates,
                     meta = FALSE,
                     outputList = "ICASA")

  file_out <- file.path(dsn, file_out)
  writeLines(out, file_out)
  message("Your ICASA file has been written to ", file_out, ".")
}

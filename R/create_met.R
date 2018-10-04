
#' Create an \acronym{APSIM} met File from \acronym{POWER} Data
#'
#' Get \acronym{POWER} values for a single point or region and create
#'   an \acronym{APSIM} met file suitable for use in \acronym{APSIM} for crop
#'   modelling; saving it to local disk.
#'
#' @param lonlat A numeric vector of geographic coordinates for a cell or region
#'    entered as x, y coordinates.  See argument details for more.
#' @param dates A character vector of start and end dates in that order,\cr
#'    *e.g.*, `dates = c("1983-01-01", "2017-12-31")`.  See argument details for
#'    more.
#' @param dsn A file path where the resulting text file should be stored.
#'
#' @param file_out A file name for the resulting text file, _e.g._
#'   "Kingsthorpe.met". A ".met" extension will be appended if given or
#'   otherwise specified by user.
#'
#' @details This function is essentially a wrapper for \code{\link{get_power}}
#'   \code{\link[APSIM]{prepareMet}} and \code{\link[APSIM]{writeMetFile}} that
#'   simplifies the querying of the \acronym{POWER} \acronym{API} and writes the
#'   met to local disk.
#'
#'   The weather values from \acronym{POWER} for temperature are 2 metre max and
#'   min temperatures, T2M_MAX and T2M_MIN; radiation, ALLSKY_SFC_SW_DWN; and
#'   rain, PRECTOT from the \acronym{POWER} AG community on a daily time-step.
#'
#'   Further details for each of the arguments are provided in their
#'   respective sections following below.
#'
#' @section Argument details for `lonlat`:
#' \describe{
#'   \item{For a single point}{To get a specific cell, 1/2 x 1/2 degree, supply
#'   a length-2 numeric vector giving the decimal degree longitude and latitude
#'   in that order for data to download,\cr
#'   *e.g.*, `lonlat = c(151.81, -27.48)`.}
#'
#'   \item{For regional coverage}{To get a region, supply a length-4 numeric
#'   vector as lower left (lon, lat) and upper right (lon, lat) coordinates,
#'   *e.g.*, `lonlat = c(xmin, ymin, xmax, ymax)` in that order for a given
#'   region, *e.g.*, a bounding box for the southwestern corner of Australia:
#'   `lonlat = c(112.5, -55.5, 115.5, -50.5)`. *Max bounding box is 10 x 10
#'   degrees* of 1/2 x 1/2 degree data, *i.e.*, 100 points maximum in total.}
#' }
#'
#' @section Argument details for `dates`: If `dates` is unspecified, defaults to
#'   a start date of 1983-01-01 (the earliest available data) and an end date of
#'   current date according to the system.
#'
#'   If one date only is provided, it will be treated as both the start date and
#'   the end date and only a single day's values will be returned.
#'
#' @return A text file in met format saved to local disk for use in
#'   \acronym{APSIM} crop modelling.
#'
#' @seealso \code{\link{create_icasa}} Create a \acronym{DSSAT} \acronym{ICASA}
#'   File from \acronym{NASA} \acronym{POWER} Data
#'
#' @examples
#' # Create a met file for Kingsthorpe, Qld from 1985-01-01 to 1985-06-30 and
#' # save it in the current R session \code{\link{tempdir()}} as
#' # "APSIM_example.met".
#'
#' \donttest{
#' create_met(lonlat = c(151.81, -27.48),
#'            dates = c("1985-01-01", "1985-12-31"),
#'            dsn = tempdir(),
#'            file = "APSIM_example.met"
#'            )
#' }
#'
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#' @export
create_met <- function(lonlat,
                       dates,
                       dsn,
                       file_out) {
  if (missing(dsn) || missing(file_out)) {
    stop(
      call. = FALSE,
      "You must provide a file location, `dsn` and file name, `file_out`."
    )
  }

  if (!is.numeric(lonlat) && toupper(lonlat) == "GLOBAL") {
    stop(
      call. = FALSE,
      "The `lonlat` must be numeric values. Global coverage is not ",
      "available for `create_met()`"
    )
  }

  if (substr(file_out, nchar(file_out) - 3, nchar(file_out)) != ".met") {
    file_out <- paste0(file_out, ".met")
  }

  power_data <- as.data.frame(
    get_power(
      pars = c(
        "T2M_MAX",
        "T2M_MIN",
        "ALLSKY_SFC_SW_DWN",
        "PRECTOT"
      ),
      dates = dates,
      lonlat = lonlat,
      temporal_average = "DAILY",
      community = "AG"
    )
  )

  power_data <-
    dplyr::select(
      power_data,
      "YEAR",
      "DOY",
      "T2M_MAX",
      "T2M_MIN",
      "PRECTOT",
      "ALLSKY_SFC_SW_DWN"
    )

  met_names <- c(
    "year",
    "day",
    "maxt",
    "mint",
    "radn",
    "rain"
  )

  met_units <-
    c(
      "()",
      "()",
      "(oC)",
      "(oC)",
      "(MJ/m^2/day)",
      "(mm)"
    )

  out <-
    suppressMessages(
      APSIM::prepareMet(
        power_data,
        lat = power_data[2, 1],
        lon = power_data[1, 1],
        newNames = met_names,
        units = met_units
      )
    )

  APSIM::writeMetFile(
    fileName = file.path(dsn, file_out),
    met = out
  )
}

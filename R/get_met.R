
#' Get Data Suitable for Creating an APSIM .met File from the POWER Web API
#'
#' Get \acronym{POWER} values for a single point or region and create
#'   an object suitable for the creation of an \acronym{APSIM} \code{met}
#'   for use in \acronym{APSIM} for crop modelling.
#'
#' @param lonlat A numeric vector of geographic coordinates for a cell or region
#'    entered as x, y coordinates.  See argument details for more.
#' @param dates A character vector of start and end dates in that order,\cr
#'    \emph{e.g.}, \code{dates = c("1983-01-01", "2017-12-31")}.  See argument
#'    details for more.
#' @param missing_csv A Boolean value indicating whether a csv file is to be
#'   written to disk with a record of missing values. If `FALSE`, the default,
#'   no file is created, only a message is emitted. If `TRUE` a csv file is
#'   created with a record of all missing values in the .met file.
#'
#' @details This function is essentially a wrapper for \code{\link{get_power}}
#'   \code{\link[APSIM]{prepareMet}} and \code{\link[APSIM]{writeMetFile}} that
#'   simplifies the querying of the \acronym{POWER} \acronym{API} and writes the
#'   \code{met} to local disk.
#'
#'   The weather values from \acronym{POWER} for temperature are 2 metre max and
#'   min temperatures, \dQuote{T2M_MAX} and \dQuote{T2M_MIN}; radiation,
#'   \dQuote{ALLSKY_SFC_SW_DWN}; rain, \dQuote{PRECTOT}; relative humidity at 2
#'   metres, \dQuote{RH2M}; and wind at 2 metres \dQuote{WS2M} from the
#'   \acronym{POWER} \sQuote{AG} community on a daily time-step.
#'
#'   Further details for each of the arguments are provided in their
#'   respective sections following below.
#'
#' @section Argument details for \code{lonlat}:
#' \describe{
#'   \item{For a single point}{To get a specific cell, 1/2 x 1/2 degree, supply
#'   a length-two numeric vector giving the decimal degree longitude and
#'   latitude in that order for data to download,\cr
#'   \emph{e.g.}, \code{lonlat = c(151.81, -27.48)}.}
#'
#'   \item{For regional coverage}{To get a region, supply a length-four numeric
#'   vector as lower left (lon, lat) and upper right (lon, lat) coordinates,
#'   \emph{e.g.}, \code{lonlat = c(xmin, ymin, xmax, ymax)} in that order for a
#'   given region, \emph{e.g.}, a bounding box for the southwestern corner of
#'   Australia: \code{lonlat = c(112.5, -55.5, 115.5, -50.5)}. \emph{Max
#'   bounding box is 10 x 10 degrees} of 1/2 x 1/2 degree data, \emph{i.e.}, 100
#'   points maximum in total.}
#' }
#'
#' @section Argument details for \code{dates}: If \code{dates} is unspecified,
#'   defaults to a start date of 1983-01-01 (the earliest available data) and an
#'   end date of current date according to the system.
#'
#'   If one date only is provided, it will be treated as both the start date and
#'   the end date and only a single day's values will be returned.
#'
#' @return A data frame of data suitable for creating a .met file for use in
#'  \acronym{APSIM} crop modelling.
#'
#' @seealso \code{\link{get_icasa}} Get data for a \acronym{DSSAT}
#'  \acronym{ICASA} File from \acronym{NASA} \acronym{POWER} Data
#'
#' @examples
#' # Get data to create a .met file for Kingsthorpe, Qld
#' # from 1985-01-01 to 1985-06-30
#'
#' \donttest{
#' create_met(lonlat = c(151.81, -27.48),
#'            dates = c("1985-01-01", "1985-12-31"),
#'            )
#' }
#'
#' @author Sparks, A. H. \email{adamhsparks@@gmail.com}
#' @export
create_met <- function(lonlat,
                       dates) {

  power_data <-
    .get_met_data(
      .dates = dates,
      .lonlat = lonlat
    )
}

#' Query POWER API and Return Data for an APSIM .met File
#'
#' Given user-supplied dates and lon and lat values, query POWER API and return
#' a `data.frame` of requested data.
#'
#' @param .dates user supplied `dates` value
#' @param .lonlat user supplied `lonlat` value
#'
#' @return A `list` of POWER data suitable for creating a .met file, names for
#' the file and corresponding units
#'
#' @noRd
#'
.get_met_data <- function(.dates, .lonlat, .dsn, .file_out, .missing_csv) {
  power_data <- as.data.frame(
    get_power(
      pars = c("T2M_MAX",
               "T2M_MIN",
               "ALLSKY_SFC_SW_DWN",
               "PRECTOT",
               "RH2M",
               "T2MDEW",
               "WS2M"),
      dates = .dates,
      lonlat = .lonlat,
      temporal_average = "DAILY",
      community = "AG"
    )
  )

  if (isTRUE(.missing_csv)) {
    .check_met_missing(.power_data = power_data,
                       #nocov start
                       .dsn = .dsn,
                       .file_out = .file_out) #nocov end
  }

  power_data <-
    power_data[c("T2M_MAX",
                 "T2M_MIN",
                 "ALLSKY_SFC_SW_DWN",
                 "PRECTOT",
                 "RH2M",
                 "WS2M",
                 "T2MDWEW",
                 "YEAR",
                 "DOY")]

  met_names <- c("maxt",
                 "mint",
                 "radn",
                 "rain",
                 "rh",
                 "wind",
                 "tdew",
                 "year",
                 "day")

  met_units <-
    c("(oC)",
      "(oC)",
      "(MJ/m^2/day)",
      "(mm)",
      "(%)",
      "(m/s)",
      "(oC)",
      "()",
      "()")

  return(out)
}

#' Check for Missing Values in .met File
#'
#' Checks for missing values in .met file. If missing values are found, a
#' message is emitted as well as an auxiliary .csv file being written to disk
#' alongside the .met file for the user to refer to
#'
#' @param .power_data data from a `get_power()` query
#' @param .file_out user-supplied file name for .met file output
#'
#' @return A .csv file if missing values are found
#'
#' @noRd
.check_met_missing <- function(.power_data, .dsn, .file_out) {
  if (any(is.na(as.data.frame(.power_data)))) {
    m <-
      as.data.frame(which(is.na(as.data.frame(.power_data)), arr.ind = TRUE))
    col_names <- names(.power_data)[unique(m[, 2])][match(m[, 2],
                                                          c(unique(m[, 2])))]
    m <- data.frame(col_names, m[, c(2, 1)])
    message(
      "\nThere are missing values in your .MET file, an auxillary file `",
      tools::file_path_sans_ext(.file_out),
      "_missing.csv` has been created as well.\n",
      paste0(utils::capture.output(m), collapse = "\n")
    )
    readr::write_csv(x = m,
                     path = file.path(.dsn, paste0(.file_out, "_missing.csv")))
  }
}


#' Create a DSSAT ICASA file from POWER data
#'
#' Get \acronym{POWER} values for a single point or region and create an
#'   \acronym{ICASA} format text file suitable for use in \acronym{DSSAT} for
#'   crop modelling; saving it to local disk.
#'
#' @param lonlat A numeric vector of geographic coordinates for a cell or region
#'   entered as x, y coordinates.  See argument details for more.
#' @param dates A character vector of start and end dates in that order,\cr
#'   \emph{e.g.}, \code{dates = c("1983-01-01", "2017-12-31")}.  See argument
#'   details for  more.
#' @param dsn A file path where the resulting text file should be stored.
#' @param file_out A file name for the resulting text file, \emph{e.g.}
#'   \dQuote{Kingsthorpe.txt}.  A \dQuote{.txt} extension will be appended if
#'   not or otherwise specified by user.
#'
#' @details This function is essentially a wrapper for \code{\link{get_power}}
#'   that queries the \acronym{POWER} \acronym{API} and writes a \acronym{DSSAT}
#'   \acronym{ICASA} weather file to disk.  All necessary \code{pars} are
#'   automatically included in the query.
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
#'   end date of current date according to the system. If one date only is
#'   provided, it will be treated as both the start date and the end date and
#'   only a single day's values will be returned.
#'
#' @seealso \code{\link{create_met}} Create an APSIM met File from NASA POWER
#'   Data
#'
#' @return A text file in \acronym{ICASA} format saved to local disk for use in
#'   \acronym{DSSAT} crop modelling.
#'
#' @examples
#' # Create an ICASA file for Kingsthorpe,
#' # Qld from 1985-01-01 to 1985-06-30
#' # and save it in the current R session
#' # tempdir() as ICASA_example.txt
#'
#' \donttest{
#' create_icasa(lonlat = c(151.81, -27.48),
#'             dates = c("1985-01-01", "1985-12-31"),
#'             dsn = tempdir(),
#'             file_out = "ICASA_example.txt"
#'             )
#' }
#'
#' @author Sparks, A. H. \email{adamhsparks@@gmail.com}
#'
#' @export
create_icasa <- function(lonlat,
                         dates,
                         dsn,
                         file_out) {
  # user input checks and formatting -------------------------------------------

  icasa <- .icasa_checks(
    .dsn = dsn,
    .file_out = file_out,
    .dates = dates,
    .lonlat = lonlat
  )

  query_list <- .build_query(
    community = "AG",
    pars = icasa[[2]],
    lonlat_identifier = icasa[[3]],
    dates = icasa[[4]],
    outputList = "ICASA"
  )

  # dummy `pars` list for .send_query arguments
  pars <- vector(mode = "list", length = 1)
  names(pars) <- "temporal_average"

  out <- .send_query(.query_list = query_list, .pars = pars)
  curl::curl_download(out$outputs$icasa,
                      destfile = icasa[[1]],
                      mode = "wb",
                      quiet = TRUE)
}

.icasa_checks <-
  function(.dsn,
           .file_out,
           .dates,
           .lonlat) {
    if (missing(.dsn) | missing(.file_out)) {
      stop(call. = FALSE,
           "You must provide a file location, `dsn` and file name, `file_out`.")
    }
    if (substr(.file_out, nchar(.file_out) - 3, nchar(.file_out)) != ".txt") {
      .file_out <- paste0(.file_out, ".txt")
    }

    file_out <- file.path(.dsn, .file_out)

    # these are dummy variables to check other values,
    # POWER will automatically select the proper pars and temp_avg for query
    .temporal_average <- "DAILY"
    .pars <- "T2M"

    # see internal_functions.R for these functions
    dates <- .check_dates(.dates,
                          .lonlat,
                          .temporal_average)
    pars <- .check_pars(.pars,
                        .temporal_average,
                        .lonlat)
    lonlat_identifier <- .check_lonlat(.lonlat,
                                       .pars)

    return(list(file_out, pars, lonlat_identifier, dates))
  }

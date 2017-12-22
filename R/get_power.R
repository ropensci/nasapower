
#'Get NASA-POWER Variables and Return a Tidy Data Frame
#'
#'@description Download NASA-POWER (Prediction of Worldwide Energy Resource)
#'  data for a given time span.
#'
#'@param name Data set name, currently supported are \code{'AG'}, \code{'SB'}
#'  and \code{'SSE'}. Defaults to \code{'AG'}.  See Details.
#'@param latlon Geographic coordinates for a cell or region as x, y coordinates
#'  or \code{"Global"}.  Defaults to \code{"Global"}. \item{To get a specific
#'  cell, 0.5 x 0.5 degrees, a length-2 numeric vector giving the decimal degree
#'  longitude and latitude in that order for data to download, \emph{e.g.},
#'  \code{lonlat = c(-179.5, -89.5)}.} \item{For a region, a length-4 numeric
#'  vector as \code{xmin, xmax, ymin, ymax} in that order for a given region,
#'  \emph{e.g.}, a bounding box for Australia: \code{lonlat = c(112.91972,
#'  159.256088, -55.11694, -9.221099)}.} \item{For global dataset, \code{lonlat
#'  = "Global"}.}
#'@param vars Solar or meteorological variables to download. See Details for
#'  \code{vars}
#'@param dates A length-2 character vector of start and end dates in that order,
#'  \emph{e.g.}, \code{dates = c("1983-01-01", "2017-12-31")}.  If \code{date}
#'  is unspecified,  defaults to a start date of "1983-01-01" (the earliest
#'  available data) and an end date of current date.
#'@param time_step Temporal averages, currently supported are \code{'DAILY'},
#'  \code{'INTERANNUAL'} and \code{'CLIMATOLOGY'}. See Details.
#'
#'@return A tidy \code{\link[base]{data.frame}} object of the requested
#'  variable(s) for the requested longitude and latitude values.
#'
#'@details Argument details for \code{name}: \describe{
#'  \item{\code{AG}}{Provides access to the Agroclimatology Archive, which
#'  contains industry-friendly parameters formatted for input to crop models.}
#'  \item{\code{SB}}{Provides access to the Sustainable Buildings Archive, which
#'  contains industry-friendly parameters for the buildings community to include
#'  parameters in multi-year monthly averages.} \item{\code{SSE}}{Provides
#'  access to the Renewable Energy Archive, which contains parameters
#'  specifically tailored to assist in the design of solar and wind powered
#'  renewable energy systems.} }
#'
#'  Argument details for \code{time_step}: \describe{ \item{DAILY}{Daily average
#'  by year.} \item{INTERANNUAL}{Monthly and annual average by year.}
#'  \item{CLIMATOLOGY}{Long term monthly averages.} }
#'
#'@section Details for \code{vars}:
#'
#'  \code{vars} can be indvidually specified or a pre-defined list can be used.
#'  See http://www.someurlhere.com for a list of valid variables.
#'
#'  If \code{latlon = "Global"} \strong{a maximum of three (3) variables} is
#'  allowed per request.
#'
#'@note The order in which the \code{vars} are listed will be the order of the
#'  columns in the data frame that \code{get_power()} returns.
#'
#' @examples
#' \dontrun{
#' nasa <- get_power(lonlat = c(-179.5, -89.5))
#' }
#'
#'@references
#'\url{https://power.larc.nasa.gov/documents/Agroclimatology_Methodology.pdf}
#'@author Adam H. Sparks, adamhsparks@gmail.com
#'
#'@export
get_power <-
  function(name = "AG",
           lonlat = "Global",
           vars = NULL,
           date = c("1983-01-01", Sys.Date()),
           time_step = "DAILY") {
    #check user inputs, see internal_functions.R for these

    if (type == NULL) {
      identifier <- "singlePoint"
    } else {
      identifier <- type
    }

    .check_lonlat_cell(lonlat)
    .check_vars(vars, type)
    dates <- .check_dates(start_date, end_date)

    # check if website is responding
    power_url <-
      "asdc-arcgis.larc.nasa.gov/cgi-bin/power/v1beta/DataAccess.py?"
    .check_response(power_url)

    if (isTRUE(any(stringi::stri_detect_fixed(vars, "RAIN")))) {
      if (start_date < "1997-01-01") {
        message("POWER does not supply precipitation data before 1997-01-01.\n")
      }
    }

    # create the query list ----------------------------------------------------

    # concatenate all the download vars into a single string for use below
    download_vars <- paste0("&p=", vars, collapse = "")

    # assemble the query list, previous step is necessary because httr::query
    # seems to remove duplicated list item names, all vars = "p" so...
    power_query <- list(
      lon = lonlat[1],
      lat = lonlat[2],
      parameters = paste0(vars, collapse = ","),
      identifier = type,
      startDate = dates[[1]],
      endDate = dates[[2]],
    )

    # submit query -------------------------------------------------------------
    # see internal-functions for this function
    NASA <- .get_NASA(power_url, download_vars, power_query)

    # create data frame of downloaded data -------------------------------------
    # colnames first
    colnames <-
      unlist(strsplit(NASA[grep("-END HEADER-", NASA) - 1], split = " "))

    # clean up column names, otherwise there are empty values in the vector
    colnames <- unique(colnames[colnames != ""])

    NASA <- utils::read.table(
      text = NASA,
      skip = grep("-END HEADER-", NASA),
      na.strings = "-",
      nrows = as.numeric(dates[[2]] - dates[[1]]) + 1,
      stringsAsFactors = FALSE
    )

    # check df, if all NA, stop, if has data, return df
    .check_nasa_df(NASA)

    names(NASA) <- colnames

    # create a tidy data frame object
    NASA["LON"] <- lonlat[1]
    NASA["LAT"] <- lonlat[2]

    # add additional date fields
    NASA["YYYYMMDD"] <- as.Date(NASA$DOY, origin = dates[[1]] - 1)
    NASA["MONTH"] <- format(as.Date(NASA$YYYYMMDD), "%m")
    NASA["DAY"] <- format(as.Date(NASA$YYYYMMDD), "%d")

    # rearrange columns
    refcols <-
      c("YEAR", "MONTH", "DAY", "YYYYMMDD", "DOY", "LON", "LAT")
    NASA <- NASA[, c(refcols, setdiff(names(NASA), refcols))]

    return(NASA)
  }

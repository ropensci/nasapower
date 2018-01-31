
#' Download NASA-POWER Agroclimatology Variables for a Given Cell and Return a Tidy Data Frame
#'
#' @description Download NASA-POWER (Prediction of Worldwide Energy Resource)
#' agroclimatology data for a given 1 degree x 1 degree cell for a range of
#' days to years.
#'
#' The agroclimatology data are satellite and modelled derived solar and
#' meteorological data. The POWER website describes the data as:
#' \itemize{
#'   \item{Near real-time 1° x 1° daily time series of solar radiation and
#'   meteorology}
#'   \item{Daily total solar radiation from July 1, 1983 through near real-time}
#'   \item{Daily averaged air temperature (average/minimum/maximum/dew point)
#'   from January 1, 1983 through near real-time}
#'   \item{Daily averaged precipitation from January 1997 through February 2013}
#'   \item{Global coverage on a 1° latitude by 1° longitude grid}
#' }
#' @param lonlat A length-2 numeric vector giving the decimal degree longitude
#' and latitude in that order for cell data to download.
#' @param vars Weather variables to download, defaults to all available.
#' Valid variables are:
#' \itemize{
#' \item{\strong{toa_dwn} - Average top-of-atmosphere insolation (MJ/m^2/day)}
#' \item{\strong{swv_dwn} - Average insolation incident on a horizontal surface
#' (MJ/m^2/day)}
#' \item{\strong{lwv_dwn} - Average downward longwave radiative flux
#' (MJ/m^2/day)}
#' \item{\strong{T2M} - Average air temperature at 2m above the surface of the
#' Earth (degrees C)}
#' \item{\strong{T2MN} - Minimum air temperature at 2m above the surface of the
#' Earth (degrees C)}
#' \item{\strong{T2MX} - Maximum air temperature at 2m above the surface of the
#' Earth (degrees C)}
#' \item{\strong{RH2M} - Relative humidity at 2m above the surface of the Earth
#' (\%)}
#' \item{\strong{DFP2M} - Dew/Frost point temperature at 2m above the surface of
#' the Earth (degrees C)}
#' \item{\strong{RAIN} - Average precipitation (mm/day)}
#' \item{\strong{WS10M} - Wind speed at 10m above the surface of the Earth
#' (m/s)} }
#' @param stdate Starting date for download, defaults to 1983-01-01 (there are
#' no earlier data).
#' @param endate End date for download, defaults to current date. Note that data
#' is often available only with a lag of days to a month or more. The last
#' available data will be silently returned with \code{NA} for any values not
#' yet reported.
#'
#' @return
#' A tidy \code{\link[base]{data.frame}} object of the requested variable(s)
#' for the requested longitude and latitude values.
#'
#' @note
#' The order in which the \code{vars} are listed will be the order of the
#' columns in the data frame that \code{get_cell()} returns.
#'
#' @examples
#' \dontrun{
#' nasa <- get_cell(lonlat = c(-179.5, -89.5))
#' }
#'
#' @references
#' \url{https://power.larc.nasa.gov/documents/Agroclimatology_Methodology.pdf}
#' @author Adam H. Sparks, adamhsparks@gmail.com
#'
#'@export
get_cell <-
  function(lonlat = NULL,
           vars = c(
             "T2M",
             "T2MN",
             "T2MX",
             "RH2M",
             "toa_dwn",
             "swv_dwn",
             "lwv_dwn",
             "DFP2M",
             "RAIN",
             "WS10M"
           ),
           stdate = "1983-1-1",
           endate = Sys.Date()) {
    #check user inputs, see internal_functions.R for these
    .check_lonlat_cell(lonlat)
    .check_vars(vars)
    dates <- .check_dates(stdate, endate)

    # check if website is responding
    power_url <-
      "power.larc.nasa.gov/cgi-bin/agro.cgi?email=agroclim@larc.nasa.gov"
    .check_response(power_url)

    if (isTRUE(any(stringi::stri_detect_fixed(vars, "RAIN")))) {
      if (stdate < "1997-01-01") {
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
      ys = format(as.Date(dates[[1]]), "%Y"),
      ms = format(as.Date(dates[[1]]), "%m"),
      ds = format(as.Date(dates[[1]]), "%d"),
      ye = format(as.Date(dates[[2]]), "%Y"),
      me = format(as.Date(dates[[2]]), "%m"),
      de = format(as.Date(dates[[2]]), "%d"),
      submit = "Submit"
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
    NASA["YYYYMMDD"] <- seq(from = dates[[1]], to = dates[[2]], by = 1)
    NASA["MONTH"] <- format(as.Date(NASA$YYYYMMDD), "%m")
    NASA["DAY"] <- format(as.Date(NASA$YYYYMMDD), "%d")

    # rearrange columns
    refcols <-
      c("YEAR", "MONTH", "DAY", "YYYYMMDD", "DOY", "LON", "LAT")
    NASA <- NASA[, c(refcols, setdiff(names(NASA), refcols))]

    return(NASA)
  }


#' Download NASA-POWER Agroclimatology Variables for a Given Cell and Return a Tidy Data Frame
#'
#' @description Download NASA-POWER (Prediction of Worldwide Energy Resource)
#' agroclimatology data for a given 1 degree x 1 degree cell for a range of
#' years.
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
#' and latitude in that order for cell data to download
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
#' @param stdate Starting date for download, defaults to 01/01/1983 (there is no
#' earlier data)
#' @param endate End date for download, defaults to current date
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
           vars = c("T2M",
                    "T2MN",
                    "T2MX",
                    "RH2M",
                    "toa_dwn",
                    "swv_dwn",
                    "lwv_dwn",
                    "DFP2M",
                    "RAIN",
                    "WS10M"),
           stdate = "1983-1-1",
           endate = Sys.Date()) {
    if (is.null(lonlat) | length(lonlat) != 2 | !is.numeric(lonlat)) {
      stop("lonlat must be provided in a length-2 numeric vector.\n")
    }

    stdate <- as.Date(stdate)
    endate <- as.Date(endate)

    if (stdate < "1983-01-01") {
      stop("NASA-POWER data do not start before 1983-01-01")
    }

    if (endate < stdate) {
      stop("Your end date is before your start date.")
    }

    if (isTRUE(any(stringi::stri_detect_fixed(vars, "RAIN")))) {
      if (stdate < "1997-01-01") {
        message("POWER does not supply precipitation data before 1997-01-01.\n")
      }
    }

    # concatenate all the download vars into a single string for use below
    download_vars <- paste0(vars, sep = "&p=", collapse = "")

    # remove the last "p" from the string
    download_vars <-
      substr(download_vars, 1, nchar(download_vars) - 2)

    durl <-
      paste0(
        "https://power.larc.nasa.gov/cgi-bin/agro.cgi?&p=",
        download_vars,
        "lat=",
        lonlat[2],
        "&email=agroclim40larc.nasa.gov&ye=",
        format(as.Date(endate), "%Y"),
        "&me=",
        format(as.Date(endate), "%m"),
        "&lon=",
        lonlat[1],
        "&submit=Submit&ms=",
        format(as.Date(stdate), "%m"),
        "&step=1&de=",
        format(as.Date(endate), "%d"),
        "&ds=",
        format(as.Date(stdate), "%d"),
        "&ys=",
        format(as.Date(stdate), "%Y")
      )

    # Read lines from the NASA-POWER website
    NASA <-
      httr::content(httr::GET(durl, httr::progress()), encoding = "UTF8")
    # clear console
    message("\n")
    NASA <-
      unlist(strsplit(NASA, "\n"))

    # Create a vector from the downloaded data of the column names
    colnames <-
      unlist(strsplit(NASA[grep("-END HEADER-", NASA) - 1], split = " "))

    # Clean up column names, otherwise there are empty values in the vector
    colnames <- unique(colnames[colnames != ""])

    # Create a data.frame of the NASA - POWER data and add names
    NASA <- utils::read.table(
      text = NASA,
      skip = grep("-END HEADER-", NASA),
      na.strings = "-",
      nrows = as.numeric(endate - stdate) + 1,
      stringsAsFactors = FALSE
    )

    names(NASA) <- colnames

    # Create a tidy data frame object
    NASA["LON"] <- lonlat[1]
    NASA["LAT"] <- lonlat[2]
    NASA["YYYYMMDD"] <- as.Date(NASA$DOY, origin = stdate - 1)
    NASA["MONTH"] <- format(as.Date(NASA$YYYYMMDD), "%m")
    NASA["DAY"] <- format(as.Date(NASA$YYYYMMDD), "%d")

    # rearrange columns
    refcols <-
      c("YEAR", "MONTH", "DAY", "YYYYMMDD", "DOY", "LON", "LAT")
    NASA <- NASA[, c(refcols, setdiff(names(NASA), refcols))]

    return(NASA)
  }

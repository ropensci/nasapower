
#' Download NASA-POWER Agroclimatology Variables and Return a Tidy Data Frame
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
#' @param x Longitude in decimal degrees for cell to download
#' @param y Latitude in decimal degrees for cell to download
#' @param vars Weather variables to download, defaults to T2M, T2MN, T2MX and
#' RH2m. Valid variables are:
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
#' for the requested LON and LAT values.
#'
#' @examples
#' \dontrun{
#' get_nasa(lon = -179.5, lat = 89.5)
#' }
#'
#' @references
#' \url{https://power.larc.nasa.gov/documents/Agroclimatology_Methodology.pdf}
#' @author Adam H. Sparks, adamhsparks@gmail.com
#' @importFrom rlang .data
#'
#'@export
get_nasa <-
  function(lon,
           lat,
           vars = c("T2M",
                    "T2MN",
                    "T2MX",
                    "RH2M"),
           stdate = "1983-1-1",
           endate = Sys.Date()) {
    if (length(lon) != 1 | length(lat) != 1) {
      message("Warning: Either lon or lat has length > 1. Using first\n",
              "only.\n",
              appendLF = TRUE)
      lon <- lon[1]
      lat <- lat[1]
    }

    if (isTRUE(any(stringi::stri_detect_fixed(vars, "RAIN")))) {
      if (stdate < "1997-01-01") {
        stop("POWER does not supply precipitation data prior to 1997-01-01")
      }
      if (endate > "2008-03-01") {
        stop("POWER does not supply precipitation data after 2008-02-28")
      }
    }

    stdate <- as.Date(stdate)
    endate <- as.Date(endate)

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
        lat,
        "&email=agroclim40larc.nasa.gov&ye=",
        lubridate::year(endate),
        "&me=",
        lubridate::month(endate),
        "&lon=",
        lon,
        "&submit=Submit&ms=",
        lubridate::month(stdate),
        "&step=1&de=",
        lubridate::day(endate),
        "&ds=",
        lubridate::day(stdate),
        "&ys=",
        lubridate::year(stdate)
      )

    message("Reading ", appendLF = FALSE)

    # Reads lines from the NASA-POWER website
    NASA <- readLines(durl)

    # Create a vector from the downloaded data of the column names
    colnames <- unlist(strsplit(NASA[grep("-END HEADER-", NASA) - 1], split = " "))

    # Clean up column names, otherwise there are empty values in the vector
    colnames <- unique(colnames[colnames != ""])

    # Create a data.frame of the NASA - POWER data and add names
    NASA <- read.table(textConnection(NASA), skip = grep("-END HEADER-", NASA))
    names(NASA) <- colnames

    # Create a tidy data frame object
    NASA["LON"] <- lon
    NASA["LAT"] <- lat
    NASA["YYYYMMDD"] <- as.Date(NASA$DOY, origin = stdate - 1)
    NASA["MONTH"] <- lubridate::month(NASA$YYYYMMDD)
    NASA["DAY"] <- lubridate::day(NASA$YYYYMMDD)
    NASA <- dplyr::select(
      NASA,
      .data$YEAR,
      .data$MONTH,
      .data$DAY,
      .data$YYYYMMDD,
      .data$LON,
      .data$LAT,
      dplyr::everything()
    )

    return(NASA)
  }

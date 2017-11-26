
#' Download NASA-POWER Agroclimatology Variables for a Given Region and Return a Tidy Data Frame
#'
#' @description Download NASA-POWER (Prediction of Worldwide Energy Resource)
#' agroclimatology data for a region given 1 degree x 1 degree cell for a range
#' of years.
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
#' @param lonlat A length-4 numeric vector giving the decimal degree minimum
#' longitude, maximum longitude, minimum latitude, and maximum latitude in that
#' order for the region data to download
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
#' for the requested region.
#'
#' @note
#' The order in which the \code{vars} are listed will be the order of the
#' columns in the data frame that \code{get_region()} returns.
#'
#' @examples
#' \dontrun{
#' # Get POWER data for Australia for 1/1/2017
#' nasa <- get_region(lonlat = c(112.91972, 159.256088, -55.11694, -9.221099),
#'                    stdate = "2017-1-1", endate = "2017-1-1")
#' }
#'
#' @references
#' \url{https://power.larc.nasa.gov/documents/Agroclimatology_Methodology.pdf}
#' @author Adam H. Sparks, adamhsparks@gmail.com
#'
#'@export
get_region <-
  function(lonlat = NULL,
           vars = c("T2M",
                    "T2MN",
                    "T2MX",
                    "RH2M"),
           stdate = "1983-1-1",
           endate = Sys.Date()) {
    if (is.null(lonlat) | length(lonlat) != 4 | !is.numeric(lonlat)) {
      stop("lonlat must be provided in a length-4 numeric vector.\n")
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
      substr(download_vars, 1, nchar(download_vars) - 1)

    # creates download URL for website

    durl <-
      paste0(
        "https://power.larc.nasa.gov/cgi-bin/agro.cgi?&ms=",
        format(as.Date(stdate), "%m"),
        "&area=area&",
        "latmin=",
        lonlat[3],
        "&ye=",
        format(as.Date(endate), "%Y"),
        "&p=",
        download_vars,
        "&ys=",
        format(as.Date(stdate), "%Y"),
        "&lonmax=",
        lonlat[2],
        "&ds=",
        format(as.Date(stdate), "%d"),
        "&latmax=",
        lonlat[4],
        "&me=",
        format(as.Date(endate), "%m"),
        "&de=",
        format(as.Date(endate), "%d"),
        "&email=agroclim40larc.nasa.gov&submit=Submit&lonmin=",
        lonlat[1]
      )

    # Read lines from the NASA-POWER website -----------------------------------
    NASA <-
      httr::content(httr::GET(durl, httr::progress()), encoding = "UTF8")
    # clear console
    message("\n")
    NASA <-
      unlist(strsplit(NASA, "\n"))

    end <- "-END HEADER-"
    start <- "-BEGIN HEADER-"
    location <- "Location: Latitude"

    colnames <-
      unlist(strsplit(NASA[grep(end, NASA) - 1][1], split = " "))

    # Clean up column names, otherwise there are empty values in the vector
    colnames <- c("LAT", "LON", unique(colnames[colnames != ""]))

    # Get the lon/lat values for each row and create a data frame of them ------
    location_rows <- grep(location, NASA)
    location_rows <- NASA[location_rows]

    # extract numeric values for locations
    location_rows <- unlist(regmatches(location_rows,
                                       gregexpr('\\(?[0-9,.]+',
                                                location_rows)))
    location_rows <-
      as.numeric(gsub('\\(', '-', gsub(',', '', location_rows)))

    # convert numeric vector to data.frame object
    location_rows <- as.data.frame(split(location_rows, 1:2))

    # add duplicate rows for n dates
    location_rows <- location_rows[rep(row.names(location_rows),
                                       each = as.numeric((endate - stdate) + 1)),
                                   1:2]

    location_rows <-
      location_rows[order(as.numeric(row.names(location_rows))), ]

    row.names(location_rows) <- NULL

    # Create a data.frame of the NASA - POWER data and add names ---------------
    # Find the immediate prior row to the data, "-END HEADER-"
    min_index <- grep(end, NASA) + 1
    max_index <- grep(start, NASA) - 1
    max_index <- max_index[-1]

    # Add last max_index value since there is no "end" at the end of the string
    max_index <- c(max_index, max(max_index) + (max_index[2] - min_index[1]))

    max_index[min_index == max(min_index)] <-
      max(min_index) + max_index[1] - min_index[1]

    indices <- data.frame(min_index, max_index)

    indices <- data.frame(mapply(`:`, indices$min_index, indices$max_index))
    indices <- unlist(indices, use.names = FALSE)

    NASA <- utils::read.table(
      text = NASA[indices],
      na.strings = "-",
      nrows = length(indices),
      stringsAsFactors = FALSE)

    # Create a tidy data frame object of lon/lat and data
    NASA <- cbind(location_rows, NASA)
    names(NASA) <- colnames

    # Add additional date fields
    NASA["YYYYMMDD"] <- as.Date(NASA$DOY, origin = stdate - 1)
    NASA["MONTH"] <- format(as.Date(NASA$YYYYMMDD), "%m")
    NASA["DAY"] <- format(as.Date(NASA$YYYYMMDD), "%d")

    # rearrange columns
    refcols <-
      c("YEAR", "MONTH", "DAY", "YYYYMMDD", "DOY", "LON", "LAT")
    NASA <- NASA[, c(refcols, setdiff(names(NASA), refcols))]

    return(NASA)
  }

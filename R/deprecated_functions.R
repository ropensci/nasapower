
#' Deprecated function(s) in the nasapower package
#'
#' These functions are now deprecated in \pkg{nasapower}.
#'
#' @docType package
#' @section Details:
#' \tabular{rl}{
#'   \code{get_cell} \tab now superceded by \code{get_power}\cr
#'   \code{get_region} \tab now superceded by \code{get_power}\cr
#' }
#'
#' @rdname nasapower-deprecated
#' @name nasapower-deprecated
#' @export
get_cell <- function(lonlat = NULL,
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
  .Deprecated(new = "get_power", package = "nasapower")
}

#' @rdname nasapower-deprecated
#' @name nasapower-deprecated
#' @export
get_region <- function(lonlat = NULL,
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
  .Deprecated(new = "get_power", package = "nasapower")
}
NULL


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
get_cell <- function() {
  .Deprecated("get_power", package = "nasapower")
}

#' @rdname nasapower-deprecated
#' @name nasapower-deprecated
#' @export
get_region <- function() {
  .Deprecated("get_power", package = "nasapower")
}

NULL

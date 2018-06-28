
#' @title NASA-POWER Data from R
#'
#' @name nasapower
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#' @docType package
#'
#' @description
#' Download NASA-POWER meteorology and climatology data for 141 parameters and
#' create a tidy data frame for a single point, a region or global coverage.
#' \pkg{nasapower} provides an R interface to the NASA - POWER API.  POWER
#' (Prediction Of Worldwide Energy Resource) data are freely available for
#' download with a resolution of 0.5 arc degree longitude by 0.5 arc degree
#' latitude and are funded through the NASA Earth Science Directorate Applied
#' Science Program. For more on the data themselves, please see
#' \url{https://power.larc.nasa.gov/}.
#'
#' @note
#' While \pkg{nasapower} does not redistribute the data in any way, we
#' encourage users to follow the requests of the POWER Project Team.
#'\preformatted{
#' When POWER data products are used in a publication, we request the
#' following acknowledgment be included:
#'
#' "These data were obtained from the NASA Langley Research Center
#' POWER Project funded through the NASA Earth Science Directorate Applied
#' Science Program."
#' }
#'
#' @seealso
#' \itemize{
#' \item \code{\link{get_power}} Download NASA-POWER Data and Return a Tidy Data
#'  Frame
#' \item \code{citation(nasapower)} For proper citation of \pkg{nasaspower}
#' }
#'
#' @references
#' \url{https://power.larc.nasa.gov/documents/POWER_Data_v8_methodology.pdf}
NULL

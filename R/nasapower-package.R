
#' @title 'NASA' 'POWER' Global Meteorology and Surface Solar Energy Climatology Data Client
#'
#' @name nasapower
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#' @docType package
#'
#' @description
#' Client for 'NASA' 'POWER' global meteorology and surface solar energy
#' climatology data 'API'.  'POWER' (Prediction Of Worldwide Energy Resource)
#' data are freely available global meteorology and surface solar energy
#' climatology data for download with a resolution of 0.5 by 0.5 arc degree
#' longitude and latitude and are funded through the 'NASA' Earth Science
#' Directorate Applied Science Program.  For more on the data themselves and a
#' web-based data viewer and access, please see <https://power.larc.nasa.gov/>.
#'
#' @note
#' While \pkg{nasapower} does not redistribute the data in any way, we
#' encourage users to follow the requests of the 'POWER' Project Team.
#' \preformatted{
#' When POWER data products are used in a publication, we request the
#' following acknowledgment be included:
#'
#' "These data were obtained from the NASA Langley Research Center POWER Project
#' funded through the NASA Earth Science Directorate Applied Science Program."
#' }
#'
#' @seealso
#'
#' \itemize{
#'  \item{\code{\link{get_power}} Download 'POWER' Data and Return a Tidy Data}
#'  Frame
#' \item{\code{\link{create_icasa}} Create a 'DSSAT' 'ICASA' File from 'POWER'
#'    Data}
#' \item{\code{\link{create_met}} Create an 'APSIM' metFile File from 'POWER'
#'  Data}
#' \item{\code{citation(nasapower)} For proper citation of \pkg{nasaspower}}
#' }
#'
#' @references
#' \url{https://power.larc.nasa.gov/documents/POWER_Data_v8_methodology.pdf}
NULL

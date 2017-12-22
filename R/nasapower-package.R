
#' NASA-POWER Agroclimatology Data from R
#'
#' @name nasapower
#' @author Adam H Sparks
#' @docType package
#'
#' @description
#' Download NASA-POWER agroclimatology data and create a tidy data frame for
#' individual cells or a user specified region. nasapower provides an R
#' interface to the NASA - POWER API.  POWER (Prediction Of Worldwide Energy
#' Resource) data are freely available for download with a resolution of 1 arc
#' degree longitude by 1 arc degree latitude and are funded through the NASA
#' Earth Science Directorate Applied Science Program. For more on the data
#' themselves, please see <https://power.larc.nasa.gov/>.
#'
#' @note
#' While \code{nasapower} does not redistribute the data in any way, we
#' encourage users to follow the requests of the POWER Project Team.
#'
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
#' \item \link{get_cell} Download NASA-POWER Agroclimatology Variables for a
#' Given Cell and Return a Tidy Data Frame
#' \item \link{get_region} Download NASA-POWER Agroclimatology Variables for a
#' Given Region and Return a Tidy Data Frame
#' }
#'
#' @references
#' \url{https://power.larc.nasa.gov/documents/Agroclimatology_Methodology.pdf}
#'
#' @author Adam H. Sparks, \email{adamhsparks@gmail.com}
#'
NULL

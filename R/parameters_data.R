
#' NASA - POWER Parameters Available for Download
#'
#' A table of POWER parameters available for download, their units, and
#' availability within `Daily`, `Interannual` or `Climatology` temporal
#' averages.
#'
#' @format A data frame
#' \describe{
#'   \item{Value}{Parameter value used in \code{vars} argument of
#'    \code{\link{get_power}} function}
#'   \item{Name}{Full name for the parameter}
#'   \item{SSE.Units.}{Surface meteorology and Solar Energy, parameter units*}
#'   \item{SB.Units.}{Sustainable Buildings parameter units*}
#'   \item{AG.Units.}{Agroclimatology parameter units*}
#'   \item{Daily}{"✓" - Available in daily temporal averages, else \code{NA}}
#'   \item{Interannual}{"✓" - Available in interannual temporal averages, else
#'    \code{NA}}
#'   \item{Climatology}{"✓" - Available in climatology interannual temporal
#'    averages, else \code{NA}}
#' }
#'
#' @note *Units based on user community value selected.
#'
#' @source \url{https://power.larc.nasa.gov/docs/v1/}
"parameters"

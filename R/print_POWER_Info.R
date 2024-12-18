#' Prints Power.Info object
#'
#' @param x POWER.Info object.
#' @param ... ignored.
#' @export
#' @noRd
print.POWER.Info <- function(x, ...) {
  if (!is.null(attr(x, "POWER.Info"))) {
    cli::cat_rule()
    cli::cli_h1(attr(x, "POWER.Info"))
    cli::cli_text(attr(x, "POWER.Dates"))
    cli::cli_text(attr(x, "POWER.Location"))
    cli::cli_text(attr(x, "POWER.Elevation"))
    cli::cli_text(attr(x, "POWER.Climate_zone"))
    cli::cli_text(attr(x, "POWER.Missing_value"))
    cli::cat_rule()
    cli::cli_text("{.strong Parameters:}")
    cli::cli_text(attr(x, "POWER.Parameters"))
    cli::cat_rule()
    format(x)
  }
  NextMethod(x)
  invisible(x)
}

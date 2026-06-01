#' Print POWER.Info Object
#'
#' @param x POWER.Info object.
#' @param ... ignored.
#'
#' @noRd
#' @export
print.POWER.Info <- function(x, ...) {
  info <- attr(x, "POWER.Info")

  if (!is.null(info)) {
    cli::cat_rule()
    cli::cli_h1(info)
    cli::cli_text(attr(x, "POWER.Dates"))
    cli::cli_text(attr(x, "POWER.Location"))
    cli::cli_text(attr(x, "POWER.Elevation"))
    cli::cli_text(attr(x, "POWER.Climate_zone"))
    cli::cli_text(attr(x, "POWER.Missing_value"))

    cli::cat_rule()
    cli::cli_text("{.strong Parameters:}")
    cli::cli_text(attr(x, "POWER.Parameters"))
    cli::cat_rule()
  }

  NextMethod()
  invisible(x)
}

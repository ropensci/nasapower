#' Prints Power.Info Object
#'
#' @param x POWER.Info object
#' @param ... ignored
#' @export
#' @noRd
print.POWER.Info <- function(x, ...) {
  if (!is.null(attr(x, "POWER.Info"))) {
    cat(
      attr(x, "POWER.Info"),
      "\n",
      attr(x, "POWER.Dates"),
      "\n",
      attr(x, "POWER.Location"),
      "\n",
      attr(x, "POWER.Elevation"),
      "\n",
      attr(x, "POWER.Climate_zone"),
      "\n",
      attr(x, "POWER.Missing_value"),
      "\n",
      "\n",
      "Parameters: \n",
      attr(x, "POWER.Parameters"),
      "\n",
      "\n"
    )
    format(x)
  }
  NextMethod(x)
  invisible(x)
}

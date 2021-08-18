
#' Add %notin% function
#'
#' Negates `%in%` for easier (mis)matching.
#'
#' @param x A character string to match.
#' @param table A table containing values to match `x` against.
#'
#' @return A logical vector, indicating if a mismatch was located for any
#'  element of x: thus the values are TRUE or FALSE and never NA.
#' @keywords internal
#' @noRd
`%notin%` <- function(x, table) {
  match(x, table, nomatch = 0L) == 0L
}

#' Check pars for validity when querying API
#'
#' Validates user entered `pars` values against `temporal_api` values.
#'
#' @param pars User entered `pars` value.
#' @param community User entered `community` value.
#' @param temporal_api User entered `temporal_api` value.
#'
#' @return Validated pars for use in [.build_query()]
#' @keywords internal
#' @noRd
.check_pars <-
  function(pars, community, temporal_api) {

    # make sure that there are no duplicates in the query
    pars <- unique(pars)

    p <- unlist(parameters[paste(toupper(temporal_api),
                                 toupper(community),
                                 sep = "_")])

    # check pars to make sure that they are valid for both the par and
    # temporal_api
    if (any(pars %notin% p)) {
      stop(call. = FALSE,
           "", paste(pars[which(pars %notin% p)], collapse = ", "),
                  " is/are not valid in 'pars'.\n",
           "Check that the 'pars', 'community' and 'temporal_api' align.")
    }

    if (temporal_api == "hourly" && length(pars) > 15) {
      stop(call. = FALSE,
           "You can only specify maximum of 15 parameters for download at a
           time for the hourly temporal API."
           )
    }

    if (length(pars) > 20 & temporal_api != "climatology") {
      stop(call. = FALSE,
           "You can only specify 20 parameters for download at a time.\n")
    }

    # all good? great. now we format it for the API
    pars <- paste0(pars, collapse = ",")
    return(pars)
  }

#' Sends the query to the POWER API
#'
#' @param .query_list A query list created by [.build_query()]
#' @param .temporal_api A character string of the validated `temporal_api`
#'  provided by the user as `temporal_api`
#' @param .url A character string of the URL to be used for the \acronym{API}
#'  query
#' @keywords internal
#' @noRd
#'
.send_query <- function(.query_list,
                        .temporal_api,
                        .url) {

  client <- crul::HttpClient$new(url = .url)

  tryCatch({
    # nocov begin
    response <- client$get(query = .query_list,
                           retry = 6L,
                           timeout = 30L)
    if (!response$success()) {
      stop(call. = FALSE)
    }
  },
  error = function(e) {
    e$message <-
      paste(
        "Something went wrong with the query, no data were returned.",
        "Please see <https://power.larc.nasa.gov> for potential",
        "server issues.\n"
      )
    # Otherwise refers to open.connection
    e$call <- NULL
    stop(e)
  }) # nocov end
  return(response)
}

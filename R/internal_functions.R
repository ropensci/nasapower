
#' Adds a %notin% Function
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

#' Check Pars for Validity When Querying API
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
    pars <- unique(toupper(pars))

    p <- unlist(parameters[paste(toupper(temporal_api),
                                toupper(community),
                                sep = "_")])

    # check pars to make sure that they are valid for both the par and
    # temporal_api
    if (any(pars %notin% p)) {
      cli::cli_abort(
        "",
        paste(pars[which(pars %notin% p)], collapse = ", "),
        " is/are not valid in 'pars'.\n",
        "Check that the 'pars', 'community' and 'temporal_api' align."
      )
    }

    if (length(pars) > 15 && temporal_api == "hourly") {
        cli::cli_abort(
        "A maximum of 15 parameters can currently be requested ",
        "in one submission for hourly data.\n"
      )
    } else if (length(pars) > 20) {
      cli::cli_abort(
        "A maximum of 20 parameters can currently be requested ",
        "in one submission.\n"
      )
    }

    # all good? great. now we format it for the API
    pars <- paste0(pars, collapse = ",")
    return(pars)
  }

#' Sends the Query to the POWER API
#'
#' @param .query_list A query list created by [.build_query()]
#' @param .temporal_api A character string of the validated `temporal_api`
#'  provided by the user as `temporal_api`
#' @param .url A character string of the URL to be used for the \acronym{API}
#'  query
#' @keywords internal
#' @return A response from the POWER server containing either an error message
#'   or the data requested.
#' @noRd
#'
.send_query <- function(.query_list,
                        .temporal_api,
                        .url) {
  client <- crul::HttpClient$new(url = .url)

  # nocov begin
  response <- client$get(query = .query_list,
                        retry = 6L,
                        timeout = 30L)

  # check to see if request failed or succeeded
  # - a custom approach this time combining status code,
  #   explanation of the code, and message from the server
  if (response$status_code > 201) {
    mssg <- jsonlite::fromJSON(response$parse("UTF-8"))$message
    x <- response$status_http()
    cli::cli_abort(
      sprintf("HTTP (%s) - %s\n  %s", x$status_code, x$explanation, mssg))
  }
  # parse response
  return(response)
}


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
#' @return Validated a collapsed string of  `pars` for use in [.build_query()]
#' @keywords internal
#' @noRd
.check_pars <-
  function(pars, community, temporal_api) {
    # make sure that there are no duplicates in the query
    pars <- unique(pars)

    # the `query_parameters()` may pass along `NULL` values, in that case we
    # want to check against all possible values
    if (is.null(community)) {
      community <- c("AG", "SB", "RE")
    } else {
      community <- toupper(community)
    }

    if (is.null(temporal_api)) {
      temporal_api <- c("HOURLY", "DAILY", "MONTHLY", "CLIMATOLOGY")
    } else {
      temporal_api <- toupper(temporal_api)
    }

    community_temporal_api <-
      paste(
        rep(temporal_api, each = length(temporal_api)),
            community, sep = "_")

      p <- unlist(parameters[community_temporal_api])

      # check pars to make sure that they are valid for both the par and
      # temporal_api
      if (any(pars %notin% p)) {
        nopar <- pars[which(pars %notin% p)]

        cli::cli_abort(
          call = rlang::caller_env(),
          c(
            i = "{.arg nopar} {?is/are} not valid in {.var pars}.",
            x = "Check that the {.arg pars}, {.arg community} and
            {.arg temporal_api} all align."
          )
        )
      }

    # all good? great. now we format it for the API
    pars <- paste0(pars, collapse = ",")
    return(pars)
  }

#' Sends the Query to the POWER API
#'
#' @param .query_list A query list created by [.build_query()]
#' @param .url A character string of the URL to be used for the \acronym{API}
#'  query
#' @keywords internal
#' @return A response from the POWER server containing either an error message
#'   or the data requested.
#' @noRd
#'
.send_query <- function(.query_list,
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

#' Create User Agent String
#'
#' Creates a user agent string to pass along to the API
#'
#' @example
#' .create_ua_string()
#'
#' @return a string with a value of \dQuote{nasapower} and the package version
#' number with no \dQuote{.} in it.
#' @keywords Internal
#' @noRd

.create_ua_string <- function() {
  sprintf("nasapower%s",
          gsub(
            pattern = "\\.",
            replacement = "",
            x = getNamespaceVersion("nasapower")
          ))
}

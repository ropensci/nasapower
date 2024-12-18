#' Adds a %notin% Function
#'
#' Negates `%in%` for easier (mis)matching.
#'
#' @param x A character string to match.
#' @param table A table containing values to match `x` against.
#'
#' @return A logical vector, indicating if a mismatch was located for any
#'  element of x: thus the values are `TRUE` or `FALSE` and never `NA`.
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
#' @return Validated a collapsed string of  `pars` for use in [.build_query].
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
        community,
        sep = "_"
      )

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
    pars <- paste(pars, collapse = ",")
    return(pars)
  }

#' Boolean
#'
#' Checks if provided object is a Boolean i.e. a length-one logical vector.
#' @param x an object to check.
#' @return a logical value indicating whether provided object is a `Boolean`.
#' @examples
#' is_boolean(TRUE) # [1] TRUE
#' # the following will work on most systems, unless you have tweaked global Rprofile
#' is_boolean(T) # [1] TRUE
#' is_boolean(1) # [1] FALSE
#' @note Taken from
#'  <https://github.com/Rapporter/rapportools/blob/master/R/utils.R>
#'
#' @noRd
#' @keywords Internal
.is_boolean <- function(x) {
  is.logical(x) && length(x) == 1
}

#' Match Wind Surface Aliases for Validity
#'
#' @noRd
#' @keywords Internal
.match_surface_alias <- function(x) {
  if (!is.null(x)) {
    wind_surface <- tolower(x)
    wind_surface <- rlang::arg_match(
      wind_surface,
      c(
        "vegtype_1",
        "vegtype_2",
        "vegtype_3",
        "vegtype_4",
        "vegtype_5",
        "vegtype_6",
        "vegtype_7",
        "vegtype_8",
        "vegtype_9",
        "vegtype_10",
        "vegtype_11",
        "vegtype_12",
        "vegtype_20",
        "seaice",
        "openwater",
        "airportice",
        "airportgrass"
      )
    )
  }
}

#' Sends the query to the POWER data API to retrieve data
#'
#' @param .query_list A query list created by [.build_query()]
#' @param .url A character string of the URL to be used for the \acronym{API}
#'  query
#' @keywords internal
#' @return A response from the POWER server containing either an error message.
#'   or the data requested.
#' @noRd
#'
.send_query <- function(.query_list,
                        .url) {
  client <- crul::HttpClient$new(url = .url)

  # nocov begin
  response <- client$get(
    query = .query_list,
    retry = 6L,
    timeout = 30L
  )

  # check to see if request failed or succeeded
  # - a custom approach this time combining status code,
  #   explanation of the code, and message from the server
  if (response$status_code > 201) {
    mssg <- jsonlite::fromJSON(response$parse("UTF-8"))$message
    x <- response$status_http()
    cli::cli_abort(
      sprintf("HTTP (%s) - %s\n  %s", x$status_code, x$explanation, mssg)
    )
  }
  # parse response
  return(response)
}


#' Sends the query to the POWER management API
#'
#' There are no parameters that these API end points accept.
#'
#' @param .url A character string of the URL to be used for the \acronym{API}
#'  query.
#' @keywords internal
#' @return A response from the POWER server containing either an error message
#'   or the data requested.
#' @noRd
#'
.send_mgmt_query <- function(.url) {
  client <- crul::HttpClient$new(url = .url)

  # nocov begin
  response <- client$get(
    retry = 6L,
    timeout = 30L
  )

  # check to see if request failed or succeeded
  # - a custom approach this time combining status code,
  #   explanation of the code, and message from the server
  if (response$status_code > 201) {
    mssg <- jsonlite::fromJSON(response$parse("UTF-8"))$message
    x <- response$status_http()
    cli::cli_abort(
      sprintf("HTTP (%s) - %s\n  %s", x$status_code, x$explanation, mssg)
    )
  }
  # parse response
  return(response)
}

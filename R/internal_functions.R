# Valid surface alias options (package constant)
.VALID_SURFACE_ALIASES <- c(
  paste0("vegtype_", c(1:12, 20)),
  "seaice",
  "openwater",
  "airportice",
  "airportgrass"
)

#' Handle HTTP Response Errors
#'
#' Validates HTTP response status codes and extracts error messages.
#'
#' @param response A response object from `crul::HttpClient$get()`.
#'
#' @returns Invisibly returns the response if status code is < 400,
#'   otherwise throws an error.
#' @dev
.handle_http_response <- function(response) {
  if (response$status_code >= 400L) {
    mssg <- tryCatch(
      yyjsonr::read_json_raw(response$content)$message,
      error = function(e) {
        rawToChar(response$content, multiple = FALSE) |>
          iconv(to = "UTF-8", sub = "byte")
      }
    )

    x <- response$status_http()

    cli::cli_abort(
      "HTTP ({x$status_code}) - {x$explanation}\n  {mssg}"
    )
  }

  invisible(response)
}

#' Check Pars for Validity When Querying API
#'
#' Validates user entered `pars` values against `temporal_api` values.
#'
#' @param pars User entered `pars` value.
#' @param community User entered `community` value.
#' @param temporal_api User entered `temporal_api` value.
#'
#' @returns Validated a collapsed string of `pars` for use in [.build_query].
#' @dev
.check_pars <- function(pars, community, temporal_api) {
  # ensure uniqueness and case consistency
  pars <- unique(toupper(pars))

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

  # build valid keys (temporal x community) using vector recycling
  community_temporal_api <- as.vector(
    outer(temporal_api, community, paste, sep = "_")
  )

  # detect invalid key combinations explicitly

  unknown_keys <- community_temporal_api[
    !community_temporal_api %in% names(parameters)
  ]
  if (length(unknown_keys)) {
    cli::cli_abort(
      c(
        "Invalid {.arg community}/{.arg temporal_api} combination.",
        x = "Not available: {.val {unknown_keys}}"
      ),
      call = rlang::caller_env()
    )
  }

  # subset parameter map
  pars_map <- parameters[community_temporal_api]

  # flatten valid parameters
  p <- unique(unlist(pars_map, use.names = FALSE))

  # validate
  bad <- !(pars %in% p)

  if (any(bad)) {
    nopar <- pars[bad]

    cli::cli_abort(
      call = rlang::caller_env(),
      c(
        i = "{nopar} {?is/are} not valid in {.arg pars}.",
        x = "Check that {.arg pars}, {.arg community}, and {.arg temporal_api} all align."
      )
    )
  }

  paste(pars, collapse = ",")
}

#' Check if Object is a Boolean
#'
#' Checks if provided object is a Boolean (i.e., a length-one logical vector).
#'
#' @param x An object to check.
#'
#' @returns A logical value indicating whether the provided object is a Boolean.
#'
#' @examples
#' .is_boolean(TRUE) # [1] TRUE
#' .is_boolean(1) # [1] FALSE
#'
#' @note Taken from
#'  <https://github.com/Rapporter/rapportools/blob/master/R/utils.R>
#'
#' @dev
.is_boolean <- function(x) {
  is.logical(x) && length(x) == 1L && !is.na(x)
}

#' Match Wind Surface Aliases for Validity
#'
#' Validates and matches surface type aliases against allowed values.
#'
#' @param x A character string representing a surface type alias.
#'
#' @returns The matched surface alias (lowercased), or NULL if input is NULL.
#'  The POWER API accepts case-insensitive surface aliases
#'
#' @dev
.match_surface_alias <- function(x) {
  if (is.null(x)) {
    return(NULL)
  }
  x_lower <- tolower(x)
  if (!x_lower %in% tolower(.VALID_SURFACE_ALIASES)) {
    cli::cli_abort(c(
      x = "{.val {x}} is not a valid surface alias.",
      i = "Valid options are: {.val {(.VALID_SURFACE_ALIASES)}}"
    ))
  }
  x_lower
}

#' Send Query to POWER Data API
#'
#' Sends the query to the POWER data API to retrieve data.
#'
#' @param .query_list A query list created by [.build_query()]
#' @param .url A character string of the URL to be used for the API query
#'
#' @returns The HTTP response object from the POWER server containing either
#'   an error message or the requested data.
#'
#' @dev
.send_query <- function(.query_list, .url) {
  client <- crul::HttpClient$new(url = .url)

  # nocov begin
  response <- client$get(
    query = .query_list,
    retry = .get_max_tries(),
    timeout = .get_timeout(),
    timeout_connect = .get_timeout_connect()
  )
  # nocov end

  .handle_http_response(response)
}

#' Send Query to POWER Management API
#'
#' Sends the query to the POWER management API.
#'
#' Note: The management API endpoints do not accept parameters.
#'
#' @param .url A character string of the URL to be used for the API query.
#'
#' @returns The HTTP response object from the POWER server containing either
#'   an error message or the requested data.
#'
#' @dev
.send_mgmt_query <- function(.url) {
  client <- crul::HttpClient$new(url = .url)

  # nocov begin
  response <- client$get(
    retry = .get_max_tries(),
    timeout = .get_timeout(),
    timeout_connect = .get_timeout_connect()
  )
  # nocov end

  .handle_http_response(response)
}

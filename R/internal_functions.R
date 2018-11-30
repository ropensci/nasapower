
#' Adds %notin% function
#'
#' Negates `%in%`` for easier matching.
#'
#' @param x A character string to match.
#' @param table A table containing values to match `x` against.
#'
#' @return A function to use for checking if something is not in a table
#'
#' @noRd
`%notin%` <- function(x, table) {
  # Same as !(x %in% table)
  match(x, table, nomatch = 0L) == 0L
}

#' Check dates for validity when querying API
#'
#' Validates user entered date values against `lonlat` and `temporal_average`
#' values
#'
#' @param dates User entered `dates` value.
#' @param lonlat User entered `lonlat` value.
#' @param temporal_average User entered `temporal_average` value.
#'
#' @return Validated dates in a list for use in .power_query()
#'
#' @noRd
.check_dates <- function(dates, lonlat, temporal_average) {
  if (is.null(dates) & temporal_average != "CLIMATOLOGY") {
    stop(
      call. = FALSE,
      "\nYou have not entered dates for the query.\n"
    )
  }

  if (temporal_average == "INTERANNUAL") {
    if (length(unique(dates)) < 2) {
      stop(
        call. = FALSE,
        "\nFor `temporal_average = INTERANNUAL`, at least two (2) years ",
        "are required to be provided.\n"
      )
    }
    if (any(nchar(dates) > 4)) {
      dates <- unique(substr(dates, 1, 4))
    }
    if (dates[[2]] < dates[[1]]) {
      message(
        "\nYour start and end dates were reversed. ",
        "They have been reordered.\n"
      )
      dates <- c(dates[2], dates[1])
    }
    return(dates)
  }

  if (temporal_average == "DAILY") {
    if (is.numeric(lonlat)) {
      if (length(dates) == 1) {
        dates <- c(dates, dates)
      }
      if (length(dates) > 2) {
        stop(
          call. = FALSE,
          "\nYou have supplied more than two dates for start and end.\n"
        )
      }

      # put dates in list to use lapply
      dates <- as.list(dates)

      # check dates as entered by user
      date_format <- function(x) {
        tryCatch(
          # try to parse the date format using lubridate
          x <- lubridate::parse_date_time(
            x,
            c(
              "Ymd",
              "dmY",
              "mdY",
              "BdY",
              "Bdy",
              "bdY",
              "bdy"
            )
          ),
          warning = function(c) {
            stop(
              call. = FALSE,
              "\n",
              x,
              " is not a valid entry for date. Enter as YYYY-MM-DD.\n"
            )
          }
        )
        as.Date(x)
      }

      # apply function to reformat/check dates
      dates <- lapply(X = dates, FUN = date_format)

      # if the stdate is > endate, flip order
      if (dates[[2]] < dates[[1]]) {
        message(
          "\nYour start and end dates were reversed. ",
          "They have been reordered.\n"
        )
        dates <- c(dates[2], dates[1])
      }

      # check date to be sure it's not before POWER data start
      if (dates[[1]] < "1981-01-01") {
        stop(
          call. = FALSE,
          "\n1981-01-01 is the earliest available data from POWER.\n"
        )
      }

      # check end date to be sure it's not _after_
      if (dates[[2]] > Sys.Date()) {
        stop(
          call. = FALSE,
          "\nThe data cannot possibly extend beyond this moment.\n"
        )
      }

      dates <- lapply(dates, as.character)
      dates <- gsub("-", "", dates, ignore.case = TRUE)
    }
  }
}

#' Check community for validity when querying API
#'
#' Validates user entered `community` values against `pars` for availability.
#'
#' @param community User entered `community` value.
#' @param pars User entered `pars` value.
#'
#' @return Validated community and pars for use in .power_query()
#'
#' @noRd
.check_community <-
  function(community, pars) {
    if (community %notin% c("AG", "SB", "SSE")) {
      stop(
        call. = FALSE,
        "\nYou have provided an invalid `community` value.\n"
      )
    }

    # check to make sure community is appropriate for given pars
    for (i in pars) {
      if (community %notin% parameters[[i]]$community) {
        stop(
          call. = FALSE,
          "\nYou have entered an invalid value for `community` for ",
          "the supplied `pars`. One or more `pars` are not, available for ",
          "`", community, "`, please check.\n"
        )
      }
    }
  }

#' Check pars for validity when querying API
#'
#' Validates user entered date values against `lonlat` and `temporal_average`
#' values
#'
#' @param dates User entered `dates` value.
#' @param lonlat User entered `lonlat` value.
#' @param temporal_average User entered `temporal_average` value.
#'
#' @return Validated pars for use in .power_query()
#'
#' @noRd
.check_pars <-
  function(pars, temporal_average, lonlat) {
    # check pars to make sure that they are valid
    if (any(pars %notin% names(parameters))) {
      stop(
        call. = FALSE,
        paste0(
          "\n", pars[which(pars %notin% names(parameters))],
          " is/are not valid in 'pars'.\n"
        )
      )
    }

    # check to make sure temporal_average is appropriate for given pars
    for (i in pars) {
      if (temporal_average %notin% parameters[[i]]$include) {
        stop(
          call. = FALSE,
          "\nYou have entered an invalid value for `temporal_average` for ",
          "the supplied `pars`. One or more `pars` are not, available for ",
          "`", temporal_average, "`, please check.\n"
        )
      }
    }

    # make sure that there are no duplicates in the query
    pars <- unique(pars)

    # check pars to make sure < allowed
    if (length(pars) > 3 & temporal_average == "CLIMATOLOGY") {
      stop(
        call. = FALSE,
        "\nYou can only specify three (3) parameters for download when ",
        "querying CLIMATOLOGY.\n"
      )
    }

    if (length(pars) > 20 & temporal_average != "CLIMATOLOGY") {
      stop(
        call. = FALSE,
        "\nYou can only specify 20 parameters for download at a time.\n"
      )
    }

    # calculate how many lines to skip in the header to read the CSV from server
    if (temporal_average == "CLIMATOLOGY") {
      skip_lines <- length(pars) + 7
    } else {
      skip_lines <- length(pars) + 9
    }

    # all good? great. now we format it for the API
    pars <- paste0(pars, collapse = ",")
    pars <- list(pars, temporal_average, skip_lines)
    names(pars) <- c("pars", "temporal_average", "skip_lines")
    return(pars)
  }

#' Check lonlat for validity when querying API
#'
#' Validates user entered `lonlat` values and checks against `pars` values.
#'
#' @param lonlat User entered `lonlat` value.
#' @param pars User entered `pars` value.
#'
#' @return A list called lonlat_identifier for use in .power_query()
#'
#' @noRd
.check_lonlat <-
  function(lonlat, pars, temporal_average) {
    bbox <- NULL
    if (is.numeric(lonlat) & length(lonlat) == 2) {
      if (lonlat[1] < -180 | lonlat[1] > 180) {
        stop(
          call. = FALSE,
          "\nPlease check your longitude, `",
          paste0(lonlat[1]),
          "`, to be sure it is valid.\n"
        )
      }
      if (lonlat[2] < -90 | lonlat[2] > 90) {
        stop(
          call. = FALSE,
          "\nPlease check your latitude, `",
          paste0(lonlat[2]),
          "`, value to be sure it is valid.\n"
        )
      }
      identifier <- "SinglePoint"
      lon <- lonlat[1]
      lat <- lonlat[2]
    } else if (length(lonlat) == 4 & is.numeric(lonlat)) {
      if ((lonlat[[3]] - lonlat[[1]]) * (lonlat[[4]] - lonlat[[2]]) * 4 > 100) {
        stop(
          call. = FALSE,
          "\nPlease provide correct bounding box values. The bounding box\n",
          "can only enclose a max of 10 x 10 region of 0.5 degree values\n",
          "or a 5 x 5 region of 1 degree values, (i.e. 100 points total).\n"
        )
      } else if (any(lonlat[1] < -180 |
              lonlat[3] < -180 |
              lonlat[1] > 180 |
              lonlat[3] > 180)) {
        stop(
          call. = FALSE,
          "\nPlease check your longitude, `",
          lonlat[1],
          "`, `",
          lonlat[3],
          "`, values to be sure they are valid.\n"
        )
      } else if (any(lonlat[2] < -90 |
                     lonlat[4] < -90 |
                     lonlat[2] > 90 |
                     lonlat[4] > 90)) {
        stop(
          call. = FALSE,
          "\nPlease check your latitude, `",
          lonlat[2],
          "`, `",
          lonlat[4],
          "`, values to be sure they are valid.\n"
        )
      } else if (lonlat[2] > lonlat[4]) {
        stop(
          call. = FALSE,
          "\nThe first `lat` value must be the minimum value.\n"
        )
      } else if (lonlat[1] > lonlat[3]) {
        stop(
          call. = FALSE,
          "\nThe first `lon` value must be the minimum value.\n"
        )
      }
      identifier <- "Regional"
      bbox <- paste(lonlat[2],
                    lonlat[1],
                    lonlat[4],
                    lonlat[3],
                    sep = ","
      )
    } else if (temporal_average == "CLIMATOLOGY") {
      identifier <- "Global"
    } else {
      stop(
        call. = FALSE,
        "\nYou have entered an invalid request for `lonlat`.\n"
      )
    }

    if (!is.null(bbox)) {
      lonlat_identifier <- list(bbox, identifier)
      names(lonlat_identifier) <- c("bbox", "identifier")
    } else if (identifier == "Global") {
      lonlat_identifier <- list("Global")
      names(lonlat_identifier) <- "identifier"
    } else {
      lonlat_identifier <- list(lon, lat, identifier)
      names(lonlat_identifier) <- c("lon", "lat", "identifier")
    }
    return(lonlat_identifier)
  }

#' Query the POWER API
#'
#' Constructs and sends a query to the POWER API using validated values from
#' previous functions in this file.
#'
#' @param community A validated value for community from `check_community()`.
#' @param lonlat_identifier A list of values, a result of `check_lonlat()`.
#' @param pars A validated value from `check_pars()`.
#' @param dates A list of valuse, a result of `check_dates()`.
#' @param outputList A value of either "CSV" or "ICASA" that tells the API the
#' desired format in which to return the data.
#'
#' @return A tidy data.frame() of requested 'POWER' data
#'
#' @noRd
.power_query <- function(community,
                         lonlat_identifier,
                         pars,
                         dates,
                         outputList) {
  power_url <- # nocov start
    "https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?"
  client <- crul::HttpClient$new(url = power_url)
  user_agent <- "anonymous"

  # check status
  status <- client$get()
  status$raise_for_status() # nocov end

  if (lonlat_identifier$identifier == "SinglePoint") {
    query_list <- list(
      request = "execute",
      identifier = lonlat_identifier$identifier,
      parameters = I(pars$pars),
      startDate = dates[[1]],
      endDate = dates[[2]],
      userCommunity = community,
      tempAverage = pars$temporal_average,
      outputList = outputList,
      lon = lonlat_identifier$lon,
      lat = lonlat_identifier$lat,
      user = user_agent
    )
  }

  if (lonlat_identifier$identifier == "Regional") {
    query_list <- list(
      request = "execute",
      identifier = lonlat_identifier$identifier,
      parameters = I(pars$pars),
      startDate = dates[[1]],
      endDate = dates[[2]],
      userCommunity = community,
      tempAverage = pars$temporal_average,
      bbox = I(lonlat_identifier$bbox),
      outputList = outputList,
      user = user_agent
    )
  }

  if (lonlat_identifier$identifier == "Global") {
    query_list <- list(
      request = "execute",
      identifier = lonlat_identifier$identifier,
      parameters = I(pars$pars),
      userCommunity = community,
      tempAverage = pars$temporal_average,
      outputList = "CSV",
      user = user_agent
    )
  }

  # send the query
  tryCatch({
    response <- client$get(query = query_list, retry = 6)
    txt <- jsonlite::fromJSON(response$parse("UTF-8"))
    raw_power_data <- file.path(tempdir(), "power_data_file")
  }, # nocov start
  error = function(e) {
    e$message <-
      paste("\nSomething went wrong with the query. Please try again.\n")
    # Otherwise refers to open.connection
    e$call <- NULL
    stop(e)
  }
  ) # nocov end

  if ("messages" %in% names(txt) & "outputs" %notin% names(txt)) {
    stop(
      call. = FALSE,
      unlist(txt$messages)
    )
  }

  if ("csv" %in% names(txt$output)) {
    if (outputList == "CSV") {
      curl::curl_download(txt$output$csv,
                          destfile = raw_power_data,
                          mode = "wb",
                          quiet = TRUE
      )

      meta <- readLines(
        raw_power_data,
        pars$skip_lines
      )
      meta <- meta[-c(1, pars$skip_lines)] # remove "HEADER ..." lines
      meta <- gsub(
        pattern = "-99",
        replacement = "NA",
        x = meta
      )

      power_data <- readr::read_csv(raw_power_data,
                                    col_types = readr::cols(),
                                    na = "-99",
                                    skip = pars$skip_lines
      )

      # put lon before lat (x, y format)
      power_data <- power_data[, c(2, 1, 3:ncol(power_data))]

      # if the temporal average is anything but climatology, add date fields
      if (pars$temporal_average == "DAILY") {
        power_data <- .format_dates(power_data)
      }

      attr(power_data, "class") <- c(
        "POWER.Info",
        "tbl_df",
        "tbl",
        "data.frame"
      )

      # add attributes for printing df
      attr(power_data, "POWER.Info") <- meta[1]
      attr(power_data, "POWER.Dates") <- meta[2]
      attr(power_data, "POWER.Location") <- meta[3]
      attr(power_data, "POWER.Elevation") <- meta[4]
      attr(power_data, "POWER.Climate_zone") <- meta[5]
      attr(power_data, "POWER.Missing_value") <- meta[6]
      attr(power_data, "POWER.Parameters") <- paste(meta[8:length(meta)],
                                                    collapse = ";\n "
      )
      return(power_data)
    }
  } else if ("icasa" %in% names(txt$output)) {
    curl::curl_download(txt$output$icasa,
                        destfile = raw_power_data,
                        mode = "wb",
                        quiet = TRUE
    )

    power_data <- readLines(raw_power_data)
    return(power_data)
  } else {
    stop(
      call. = FALSE,
      "Your requested data was not returned. Check",
      "<https://power.larc.nasa.gov/> and/or try again later."
    )
  }
}

#' Prints Power.Info object.
#'
#' @param x POWER.Info object
#' @param ... ignored
#' @export
print.POWER.Info <- function(x, ...) {
  if (!is.null(attr(x, "POWER.Info"))) {
    cat(
      attr(x, "POWER.Info"), "\n",
      attr(x, "POWER.Dates"), "\n",
      attr(x, "POWER.Location"), "\n",
      attr(x, "POWER.Elevation"), "\n",
      attr(x, "POWER.Climate_zone"), "\n",
      attr(x, "POWER.Missing_value"), "\n",
      "Parameters: \n",
      attr(x, "POWER.Parameters"), "\n",
      "\n"
    )
    format(x)
  }
  NextMethod(x)
  invisible(x)
}

#' Format date columns in POWER data frame
#'
#' Formats columns as integers for DOY and adds columns for year, month and day.
#'
#' @param NASA A tidy data.frame resulting from .power_query().
#'
#' @return A tidy data frame of power data with additional date information
#'   columns.
#'
#' @noRd
#'
.format_dates <- function(NASA) {
  # convert DOY to integer
  NASA$DOY <- as.integer(NASA$DOY)

  # Calculate the full date from YEAR and DOY
  NASA <- tibble::add_column(NASA,
                             YYYYMMDD = as.Date(NASA$DOY - 1,
                                                origin = as.Date(paste(
                                                  NASA$YEAR, "-01-01",
                                                  sep = ""
                                                ))
                             ),
                             .after = "DOY"
  )

  # Extract month as integer
  NASA <- tibble::add_column(NASA,
                             MM = as.integer(substr(NASA$YYYYMMDD, 6, 7)),
                             .after = "YEAR"
  )

  # Extract day as integer
  NASA <- tibble::add_column(NASA,
                             DD = as.integer(substr(NASA$YYYYMMDD, 9, 10)),
                             .after = "MM"
  )
}

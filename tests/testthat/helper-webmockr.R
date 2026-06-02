webmockr::enable("crul")
withr::defer(webmockr::disable("crul"), teardown_env())

clear_stubs <- function() webmockr::stub_registry_clear()

stub_get <- function(uri, body, status = 200L) {
  webmockr::stub_request("get", uri = uri) |>
    webmockr::to_return(
      body = body,
      status = status,
      headers = list("Content-Type" = "application/json")
    )
}

# ---- Shared response bodies ------------------------------------------------
.body_all_pars <- yyjsonr::write_json_str(list(
  T2M = list(longname = "Temperature at 2 Meters"),
  WS2M = list(longname = "Wind Speed at 2 Meters")
))

.body_single_par <- yyjsonr::write_json_str(list(
  T2M = list(longname = "Temperature at 2 Meters")
))

.body_community_temporal <- yyjsonr::write_json_str(list(
  T2M = list(longname = "Temperature at 2 Meters")
))

.body_all_surfaces <- yyjsonr::write_json_str(list(
  airportgrass = list(description = "Airport Grass"),
  airportice = list(description = "Airport Ice"),
  openwater = list(description = "Open Water"),
  seaice = list(description = "Sea Ice")
))

.body_single_surface <- yyjsonr::write_json_str(list(
  airportgrass = list(description = "Airport Grass")
))

.body_groupings <- yyjsonr::write_json_str(list(
  communities = list(
    AG = list(
      temporalAPIs = list(
        HOURLY = list(parameters = c("T2M", "WS10M"))
      )
    )
  )
))

.body_groupings_global <- yyjsonr::write_json_str(list(
  climatology = list(parameters = c("T2M_MAX", "T2M_MIN"))
))

.body_404 <- '{"error": "Not Found"}'
.body_500 <- '{"error": "Internal Server Error"}'

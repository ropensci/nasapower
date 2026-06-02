# Stub bodies and helpers defined in helper-webmockr.R.
# Exact URIs taken from webmockr "Unregistered request" error output.

.URI_SURFACES <- "https://power.larc.nasa.gov/api/system/manager/surface"
.URI_AIRPORTGRASS <- "https://power.larc.nasa.gov/api/system/manager/surface/airportgrass"
.URI_AIRPORTICE <- "https://power.larc.nasa.gov/api/system/manager/surface/airportice"
.URI_OPENWATER <- "https://power.larc.nasa.gov/api/system/manager/surface/openwater"
.URI_SEAICE <- "https://power.larc.nasa.gov/api/system/manager/surface/seaice"

.uri_vegtype <- function(vt) {
  paste0("https://power.larc.nasa.gov/api/system/manager/surface/", vt)
}

# ---- no surface_alias (all surfaces) ---------------------------------------

test_that("query_surfaces() with no args queries the base URL", {
  clear_stubs()
  stub_get(.URI_SURFACES, .body_all_surfaces)

  result <- query_surfaces()
  expect_type(result, "list")
  expect_named(result, c("airportgrass", "airportice", "openwater", "seaice"))
})

# ---- surface_alias provided ------------------------------------------------

test_that("query_surfaces() appends lowercased alias to URL", {
  clear_stubs()
  stub_get(.URI_AIRPORTGRASS, .body_single_surface)

  result <- query_surfaces(surface_alias = "airportgrass")
  expect_type(result, "list")
  expect_named(result, "airportgrass")
})

test_that("query_surfaces() is case-insensitive for surface_alias", {
  for (alias in c("AirportGrass", "AIRPORTGRASS")) {
    clear_stubs()
    stub_get(.URI_AIRPORTGRASS, .body_single_surface)
    expect_no_error(query_surfaces(surface_alias = alias))
  }
})

test_that("query_surfaces() works for all valid vegtype aliases", {
  for (vt in paste0("vegtype_", c(1:12, 20))) {
    clear_stubs()
    stub_get(
      .uri_vegtype(vt),
      yyjsonr::write_json_str(list(alias = list(description = vt)))
    )
    expect_no_error(query_surfaces(surface_alias = vt))
  }
})

test_that("query_surfaces() works for seaice alias", {
  clear_stubs()
  stub_get(
    .URI_SEAICE,
    yyjsonr::write_json_str(list(seaice = list(description = "Sea Ice")))
  )
  expect_no_error(query_surfaces(surface_alias = "seaice"))
})

test_that("query_surfaces() works for openwater alias", {
  clear_stubs()
  stub_get(
    .URI_OPENWATER,
    yyjsonr::write_json_str(list(openwater = list(description = "Open Water")))
  )
  expect_no_error(query_surfaces(surface_alias = "openwater"))
})

test_that("query_surfaces() works for airportice alias", {
  clear_stubs()
  stub_get(
    .URI_AIRPORTICE,
    yyjsonr::write_json_str(list(
      airportice = list(description = "Airport Ice")
    ))
  )
  expect_no_error(query_surfaces(surface_alias = "airportice"))
})

# ---- input validation ------------------------------------------------------

test_that("query_surfaces() errors on invalid surface_alias", {
  expect_error(query_surfaces(surface_alias = "rooftop"), regexp = "rooftop")
})

test_that("query_surfaces() error for invalid alias names a valid option", {
  err <- tryCatch(
    query_surfaces(surface_alias = "rooftop"),
    error = function(e) e
  )
  expect_match(conditionMessage(err), "airportgrass", fixed = TRUE)
})

test_that("query_surfaces() errors on vegtype alias out of valid range", {
  expect_error(query_surfaces(surface_alias = "vegtype_0"))
  expect_error(query_surfaces(surface_alias = "vegtype_13"))
  expect_error(query_surfaces(surface_alias = "vegtype_19"))
  expect_error(query_surfaces(surface_alias = "vegtype_21"))
})

test_that("query_surfaces() does NOT call the API for an invalid alias", {
  expect_error(
    query_surfaces(surface_alias = "rooftop"),
    regexp = "not a valid surface alias"
  )
})

# ---- HTTP error handling ---------------------------------------------------

test_that("query_surfaces() surfaces HTTP 404 as an error", {
  clear_stubs()
  stub_get(.URI_SURFACES, .body_404, status = 404L)
  expect_error(query_surfaces(), regexp = "404")
})

test_that("query_surfaces() surfaces HTTP 500 as an error", {
  clear_stubs()
  stub_get(.URI_SURFACES, .body_500, status = 500L)
  expect_error(query_surfaces(), regexp = "500")
})

# ---- return value ----------------------------------------------------------

test_that("query_surfaces() always returns a list", {
  clear_stubs()
  stub_get(.URI_SURFACES, .body_all_surfaces)
  expect_type(query_surfaces(), "list")
})

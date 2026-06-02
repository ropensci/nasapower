# Stub bodies and helpers defined in helper-webmockr.R.
# Exact URIs taken from webmockr "Unregistered request" error output.

.URI_GROUPINGS <- "https://power.larc.nasa.gov/api/system/manager/system/groupings"
.URI_GROUPINGS_GLOBAL <- "https://power.larc.nasa.gov/api/system/manager/system/groupings/global"

# ---- global = FALSE (default) ----------------------------------------------

test_that("query_groupings() calls the non-global endpoint by default", {
  clear_stubs()
  stub_get(.URI_GROUPINGS, .body_groupings)

  result <- query_groupings()
  expect_type(result, "list")
  expect_named(result, "communities")
})

test_that("query_groupings() does NOT call the /global endpoint when global = FALSE", {
  clear_stubs()
  stub_get(.URI_GROUPINGS, .body_groupings)
  expect_no_error(query_groupings(global = FALSE))
})

# ---- global = TRUE ---------------------------------------------------------

test_that("query_groupings(global = TRUE) calls the /global endpoint", {
  clear_stubs()
  stub_get(.URI_GROUPINGS_GLOBAL, .body_groupings_global)

  result <- query_groupings(global = TRUE)
  expect_type(result, "list")
  expect_named(result, "climatology")
})

# ---- return value ----------------------------------------------------------

test_that("query_groupings() returns a list parsed from JSON", {
  clear_stubs()
  stub_get(.URI_GROUPINGS, .body_groupings)

  result <- query_groupings()
  expect_type(result, "list")
  # yyjsonr returns JSON arrays as character vectors, not lists
  expect_type(result$communities$AG$temporalAPIs$HOURLY$parameters, "character")
})

# ---- input validation ------------------------------------------------------

test_that("query_groupings() errors when global is not a boolean", {
  expect_error(query_groupings(global = "yes"), regexp = "global")
  expect_error(query_groupings(global = 1L), regexp = "global")
  expect_error(query_groupings(global = NA), regexp = "global")
})

test_that("query_groupings() errors when global has length > 1", {
  expect_error(query_groupings(global = c(TRUE, FALSE)), regexp = "global")
})

# ---- HTTP error handling ---------------------------------------------------

test_that("query_groupings() surfaces HTTP 404 as an error", {
  clear_stubs()
  stub_get(.URI_GROUPINGS, .body_404, status = 404L)
  expect_error(query_groupings(), regexp = "404")
})

test_that("query_groupings() surfaces HTTP 500 as an error", {
  clear_stubs()
  stub_get(.URI_GROUPINGS, .body_500, status = 500L)
  expect_error(query_groupings(), regexp = "500")
})

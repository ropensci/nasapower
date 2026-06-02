# Stub bodies and helpers defined in helper-webmockr.R.
# Exact URIs taken from webmockr "Unregistered request" error output.

.URI_ALL <- "https://power.larc.nasa.gov/api/system/manager/parameters?user=nasapower4r"
.URI_T2M <- "https://power.larc.nasa.gov/api/system/manager/parameters/T2M?user=nasapower4r"
.URI_AG_HR <- "https://power.larc.nasa.gov/api/system/manager/parameters?community=AG&temporal=HOURLY&metadata=FALSE&user=nasapower4r"
.URI_AG_HR_META <- "https://power.larc.nasa.gov/api/system/manager/parameters?community=AG&parameters=T2M&temporal=HOURLY&metadata=TRUE&user=nasapower4r"
.URI_AG <- "https://power.larc.nasa.gov/api/system/manager/parameters?community=AG&metadata=FALSE&user=nasapower4r"
.URI_DL <- "https://power.larc.nasa.gov/api/system/manager/parameters?temporal=DAILY&metadata=FALSE&user=nasapower4r"
.URI_HR <- "https://power.larc.nasa.gov/api/system/manager/parameters?temporal=HOURLY&metadata=FALSE&user=nasapower4r"

# ---- Branch 1: no community or temporal_api --------------------------------

test_that("query_parameters() with no args queries base URL with user param", {
  clear_stubs()
  stub_get(.URI_ALL, .body_all_pars)

  result <- query_parameters()
  expect_type(result, "list")
  expect_named(result, c("T2M", "WS2M"))
})

test_that("query_parameters(pars) with no community/temporal_api appends par to path", {
  clear_stubs()
  stub_get(.URI_T2M, .body_single_par)

  result <- query_parameters(pars = "T2M")
  expect_type(result, "list")
  expect_named(result, "T2M")
})

test_that("query_parameters(pars) is case-insensitive", {
  clear_stubs()
  stub_get(.URI_T2M, .body_single_par)
  expect_no_error(query_parameters(pars = "t2m"))
})

# ---- Branch 2: community and/or temporal_api provided ----------------------

test_that("query_parameters() with community and temporal_api uses query params", {
  clear_stubs()
  stub_get(.URI_AG_HR, .body_community_temporal)
  expect_no_error(query_parameters(community = "ag", temporal_api = "hourly"))
})

test_that("query_parameters() with community only uses query params", {
  clear_stubs()
  stub_get(.URI_AG, .body_community_temporal)
  expect_no_error(query_parameters(community = "ag"))
})

test_that("query_parameters() with temporal_api only uses query params", {
  clear_stubs()
  stub_get(.URI_DL, .body_community_temporal)
  expect_no_error(query_parameters(temporal_api = "daily"))
})

test_that("query_parameters() with metadata = TRUE passes metadata in query", {
  clear_stubs()
  stub_get(.URI_AG_HR_META, .body_community_temporal)
  expect_no_error(
    query_parameters(
      pars = "T2M",
      community = "ag",
      temporal_api = "hourly",
      metadata = TRUE
    )
  )
})

test_that("query_parameters() metadata ignored without community/temporal_api", {
  clear_stubs()
  stub_get(.URI_T2M, .body_single_par)
  expect_no_error(query_parameters(pars = "T2M", metadata = TRUE))
})

# ---- case normalisation ----------------------------------------------------

test_that("query_parameters() normalises community to uppercase", {
  for (community in c("ag", "AG", "Ag")) {
    clear_stubs()
    stub_get(.URI_AG, .body_community_temporal)
    expect_no_error(query_parameters(community = community))
  }
})

test_that("query_parameters() normalises temporal_api to uppercase", {
  for (temporal in c("hourly", "HOURLY", "Hourly")) {
    clear_stubs()
    stub_get(.URI_HR, .body_community_temporal)
    expect_no_error(query_parameters(temporal_api = temporal))
  }
})

# ---- input validation ------------------------------------------------------

test_that("query_parameters() errors when metadata is not a boolean", {
  expect_error(query_parameters(metadata = "yes"), regexp = "metadata")
  expect_error(query_parameters(metadata = 1L), regexp = "metadata")
  expect_error(query_parameters(metadata = NA), regexp = "metadata")
})

test_that("query_parameters() errors when metadata has length > 1", {
  expect_error(query_parameters(metadata = c(TRUE, FALSE)), regexp = "metadata")
})

test_that("query_parameters() errors on invalid community", {
  expect_error(query_parameters(community = "XX"), regexp = "community")
})

test_that("query_parameters() errors on invalid temporal_api", {
  expect_error(
    query_parameters(temporal_api = "weekly"),
    regexp = "temporal_api"
  )
})

# ---- HTTP error handling ---------------------------------------------------

test_that("query_parameters() surfaces HTTP 404 as an error (branch 1)", {
  clear_stubs()
  stub_get(.URI_ALL, .body_404, status = 404L)
  expect_error(query_parameters(), regexp = "404")
})

test_that("query_parameters() surfaces HTTP 404 as an error (branch 2)", {
  clear_stubs()
  stub_get(.URI_AG, .body_404, status = 404L)
  expect_error(query_parameters(community = "ag"), regexp = "404")
})

test_that("query_parameters() surfaces HTTP 500 as an error (branch 2)", {
  clear_stubs()
  stub_get(.URI_AG, .body_500, status = 500L)
  expect_error(query_parameters(community = "ag"), regexp = "500")
})

# ---- return value ----------------------------------------------------------

test_that("query_parameters() always returns a list", {
  clear_stubs()
  stub_get(.URI_ALL, .body_all_pars)
  expect_type(query_parameters(), "list")
})

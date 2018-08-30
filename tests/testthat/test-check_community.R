
# community checks -------------------------------------------------------------
context("Test that check_community function handles community strings
        correctly")

test_that("check_community fails if one not provided", {
  expect_error(check_community())
})

test_that("check_community fails if invalid entry is supplied", {
  expect_error(check_community("R"),
               regexp = "*You have provided an invalid `community` value.*")
})

test_that("check_community returns a character string matching a community", {
  expect_equal(check_community("AG"), "AG")
  expect_equal(check_community("SB"), "SB")
  expect_equal(check_community("SSE"), "SSE")
})

test_that(
  "If an invalid community is given for a par, an error occurs", {
    pars <- "ALLSKY_SFC_SW_DWN_00_GMT"
    temporal_average <- "DAILY"
    lonlat <- "GLOBAL"
    community <- "AG"
    expect_error(check_community(community, pars))
  })

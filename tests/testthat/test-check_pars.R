
# parameter checks -------------------------------------------------------------
context("Test that check_pars function handles pars strings correctly")
test_that("check_pars stops if no `par` provided", {
  expect_error(check_pars(
    pars = NULL,
    temporal_average = "DAILY",
    latlon = c(-89.5, -179.5)
  ),
  regexp = "*You have not provided a `pars` value.*")
})

test_that("check_pars stops if no `temporal_average` provided", {
  expect_error(check_pars(
    pars = "AG",
    temporal_average = NULL,
    latlon = c(-89.5, -179.5)
  ),
  regexp = "*You have not provided a `temporal_average` value.*")
})


test_that("check_pars stops if `temporal_average` not valid", {
  expect_error(check_pars(
    pars = "AG",
    temporal_average = "ad09jlave",
    latlon = c(-89.5, -179.5)
  ),
  regexp = "\nYou have entered an invalid value for `temporal_average`.\n")
})

test_that("check_pars stops if `pars` not valid", {
  expect_error(check_pars(
    pars = "asdflkuewr",
    temporal_average = "DAILY",
    latlon = c(-89.5, -179.5)
  ),
  regexp = "\nASDFLKUEWR is/are not valid in 'pars'.\n")
})

test_that("check_pars stops if `pars` not valid", {
  expect_error(
    check_pars(
      pars = "ALLSKY_SFC_SW_DWN_03_GMT",
      temporal_average = "Interannual",
      latlon = c(-89.5, -179.5)
    ),
    regexp = "*You have entered an invalid value for `temporal_average` for*"
  )
})

test_that("pars are returned as a comma separated string with no spaces", {
  pars <- check_pars(
    pars = c("ALLSKY_SFC_SW_DWN_03_GMT",
             "ALLSKY_SFC_LW_DWN"),
    temporal_average = "Climatology",
    latlon = c(-89.5, -179.5)
  )
  expect_named(pars, c("pars", "temporal_average"))
  expect_equal(nchar(pars$pars), 42)
  expect_equal(pars$pars, "ALLSKY_SFC_SW_DWN_03_GMT,ALLSKY_SFC_LW_DWN")
  expect_equal(pars$temporal_average, "CLIMATOLOGY")
  expect_length(pars, 2)
})

test_that("`temporal_average`` is set to `CLIMATOLOGY` when global data
          queried",
          {
            pars <- c("ALLSKY_SFC_SW_DWN_03_GMT",
                      "ALLSKY_SFC_LW_DWN")
            temporal_average <- "Daily"
            latlon <- "Global"
            expect_message(pars <-
                             check_pars(pars, temporal_average, latlon),
                           regexp = "\nGlobal data are only available for*")
            expect_equal(pars$pars,
                         "ALLSKY_SFC_SW_DWN_03_GMT,ALLSKY_SFC_LW_DWN")
            expect_equal(pars$temporal_average, "CLIMATOLOGY")
          })

test_that("Only 3 pars are allowed when temporal_average == CLIMATOLOGY", {
  pars <- c("ALLSKY_SFC_SW_DWN_03_GMT",
            "ALLSKY_SFC_LW_DWN",
            "ALLSKY_SFC_SW_DWN_06_GMT",
            "RH2M")
  temporal_average <- "CLIMATOLOGY"
  latlon <- "Global"
  expect_message(pars <-
                   check_pars(pars, temporal_average, latlon),
                 regexp = "\nYou can only specify three (3)*")
})

# test_that("Only 20 pars are allowed when temporal_average != CLIMATOLOGY", {
#   pars <- c("ALLSKY_SFC_LW_DWN",
#             "CLD_AMT_12_GMT",
#             "ALLSKY_SFC_SW_DWN_00_GMT",
#             "ALLSKY_SFC_SW_DWN_03_GMT",
#             "ALLSKY_SFC_SW_DWN_06_GMT",
#             "ALLSKY_SFC_SW_DWN_09_GMT",
#             "ALLSKY_SFC_SW_DWN_12_GMT",
#             "ALLSKY_SFC_SW_DWN_15_GMT",
#             "ALLSKY_SFC_SW_DWN_18_GMT",
#             "ALLSKY_SFC_SW_DWN_21_GMT",
#             "ALLSKY_SFC_SW_DWN_MAX_DIFF",
#             "ALLSKY_SFC_SW_DWN_MIN_DIFF",
#             "ALLSKY_TOA_SW_DWN",
#             "CDD0",
#             "CDD10",
#             "CDD18_3",
#             "CLD_AMT",
#             "CLD_AMT_00_GMT",
#             "CLD_AMT_03_GMT",
#             "CLD_AMT_06_GMT",
#             "CLD_AMT_09_GMT"
#             )
#   temporal_average <- "INTERANNUAL"
#   latlon = c(-89.5, -179.5)
#   expect_message(pars <- check_pars(pars, temporal_average, latlon),
#                  regexp = "\nYou can only specify three (3) parameters for*")
# })
#
test_that("Only unique pars are queried", {
 pars <- c("RH2M",
           "RH2M",
           "RH2M")
 temporal_average <- "CLIMATOLOGY"
 latlon <- "Global"
 pars <- check_pars(pars, temporal_average, latlon)
 expect_equal(pars[1], "RH2M")
 expect_equal(length(pars[1]), 1)
})

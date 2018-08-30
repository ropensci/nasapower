
# parameter checks -------------------------------------------------------------
context("Test that check_pars function handles pars strings correctly")
test_that("check_pars stops if no `par` provided", {
  temporal_average = "DAILY"
  lonlat = c(-179.5, -89.5)

  expect_error(
    check_pars(
      temporal_average,
      lonlat,
      pars
    )
  )
})

test_that("check_pars stops if no `temporal_average` provided", {
  pars = "AG"
  lonlat = c(-179.5, -89.5)

  expect_error(
    check_pars(
      temporal_average,
      lonlat,
      pars
    )
  )
})

test_that("check_pars stops if `temporal_average` not valid", {
  pars = "AG"
  temporal_average = "ad09jlave"
  lonlat = c(-179.5, -89.5)

  expect_error(
    check_pars(
      pars,
      temporal_average,
      lonlat
    ),
    regexp = "\nYou have entered an invalid value for `temporal_average`.\n")
})

test_that("check_pars stops if `pars` not valid", {
  pars = "asdflkuewr"
  temporal_average = "DAILY"
  lonlat = c(-179.5, -89.5)

  expect_error(
    check_pars(
      pars,
      temporal_average,
      lonlat
    )
  )
})

test_that("check_pars stops if `pars` not valid", {
  pars = "ALLSKY_SFC_SW_DWN_03_GMT"
  temporal_average = "Interannual"
  lonlat = c(-179.5, -89.5)

  expect_error(
    check_pars(
      pars,
      temporal_average,
      lonlat
    )
  )
})

test_that("pars are returned as a comma separated string with no spaces", {
  pars = c("ALLSKY_SFC_SW_DWN_03_GMT",
           "ALLSKY_SFC_LW_DWN")
  temporal_average = "CLIMATOLOGY"
  lonlat = c(-179.5, -89.5)

  pars <- check_pars(
    pars,
    temporal_average,
    lonlat
  )
  expect_named(pars, c("pars", "temporal_average", "skip_lines"))
  expect_equal(nchar(pars$pars), 42)
  expect_equal(pars$pars, "ALLSKY_SFC_SW_DWN_03_GMT,ALLSKY_SFC_LW_DWN")
  expect_equal(pars$temporal_average, "CLIMATOLOGY")
  expect_length(pars, 3)
})

test_that("`temporal_average` is set to `CLIMATOLOGY` when global data
          queried",
          {
            pars <- c("ALLSKY_SFC_SW_DWN_03_GMT",
                      "ALLSKY_SFC_LW_DWN")
            temporal_average <- "DAILY"
            lonlat <- "GLOBAL"
            expect_message(pars <-
                             check_pars(pars,
                                        temporal_average,
                                        lonlat)
            )
            expect_equal(pars$pars,
                         "ALLSKY_SFC_SW_DWN_03_GMT,ALLSKY_SFC_LW_DWN")
            expect_equal(pars$temporal_average, "CLIMATOLOGY")
          })

test_that("Only 3 pars are allowed when temporal_average == CLIMATOLOGY",
          {
            pars <- c("ALLSKY_SFC_SW_DWN_03_GMT",
                      "ALLSKY_SFC_LW_DWN",
                      "ALLSKY_SFC_SW_DWN_06_GMT",
                      "RH2M")
            temporal_average <- "CLIMATOLOGY"
            lonlat <- "GLOBAL"
            expect_error(pars <-
                           check_pars(pars, temporal_average, lonlat),
                         regexp = "\nYou can only specify three*")
          })

test_that("Only 20 pars are allowed when temporal_average != CLIMATOLOGY", {
  pars <- c("ALLSKY_SFC_LW_DWN",
            "ALLSKY_TOA_SW_DWN",
            "CDD0",
            "CDD10",
            "CDD18_3",
            "CLRSKY_SFC_SW_DWN",
            "FROST_DAYS",
            "HDD0",
            "HDD10",
            "HDD18_3",
            "KT",
            "KT_CLEAR",
            "PRECTOT",
            "PS",
            "QV2M",
            "RH2M",
            "T10M",
            "T10M_MAX",
            "T10M_MIN",
            "T10M_RANGE",
            "T2M_RANGE",
            "T2M_MIN",
            "T2M_MAX"
  )
  temporal_average <- "DAILY"
  lonlat = c(-179.5, -89.5)
  expect_error(pars <- check_pars(pars, temporal_average, lonlat),
               regexp = "\nYou can only specify 20 parameters for download*")
})

test_that("Only unique pars are queried", {
  pars <- c("RH2M",
            "RH2M",
            "RH2M")
  temporal_average <- "CLIMATOLOGY"
  lonlat <- "GLOBAL"
  pars <- check_pars(pars, temporal_average, lonlat)
  expect_equal(pars[[1]], "RH2M")
  expect_equal(length(pars[[1]]), 1)
})

test_that(
  "If an invalid temporal average is given for a par, an error occurs", {
    pars <- "ALLSKY_SFC_SW_DWN_00_GMT"
    temporal_average <- "DAILY"
    lonlat <- c(-179.5, -89.5)
    expect_error(check_pars(pars, temporal_average, lonlat))
  })

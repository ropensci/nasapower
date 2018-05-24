
# parameter checks -------------------------------------------------------------
context("Test that check_pars function handles pars strings correctly")
test_that("check_pars stops if no `par` provided", {
  expect_error(check_pars(pars = NULL, temporal_average = "DAILY"),
               regexp = "*You have not provided a `pars` value.*")
})

test_that("check_pars stops if no `temporal_average` provided", {
  expect_error(check_pars(pars = "AG", temporal_average = NULL),
               regexp = "*You have not provided a `temporal_average` value.*")
})


test_that("check_pars stops if `temporal_average` not valid", {
  expect_error(check_pars(pars = "AG", temporal_average = "ad09jlave"),
               regexp = "*You have entered an invalid value for `temporal_average`.*")
})

test_that("check_pars stops if `pars` not valid", {
    expect_error(check_pars(pars = "asdflkuewr", temporal_average = "DAILY"),
               regexp = "*You have entered an invalid value for `pars`.*")
})

test_that("check_pars stops if `pars` not valid", {
expect_error(check_pars(pars = "ALLSKY_SFC_SW_DWN_03_GMT",
                        temporal_average = "Interannual"),
             regexp = "*You have entered an invalid value for `temporal_average` for the\n*")
})

test_that("pars are returned as a comma separated string with no spaces", {
  pars <- check_pars(pars = c("ALLSKY_SFC_SW_DWN_03_GMT",
                              "ALLSKY_SFC_LW_DWN"),
                     temporal_average = "Climatology")
  expect_equal(nchar(pars), 42)
  expect_length(pars, 1)
})


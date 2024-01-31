
test_that("query_parameters() returns proper list of info", {
            skip_on_cran()
            par_query <- query_parameters(community = "ag",
                                          pars = "T2M",
                                          temporal_api = "Daily")

            expect_type(par_query, "list")
            expect_length(par_query, 1)
            expect_named(par_query, "T2M")
          })

test_that("query_parameters() returns list of parameter information", {
  skip_on_cran()
  par_query <- query_parameters(pars = "T2M")
  expect_type(par_query, "list")
  expect_length(par_query, 1)
  expect_named(par_query, "T2M")
})

test_that("query_parameters() stops if par and community only supplied", {
  skip_on_cran()
  expect_error(query_parameters(pars = "T2M",
                                community = "AG"))
})

test_that("query_parameters() stops if par and community only supplied", {
  skip_on_cran()
  expect_error(query_parameters(pars = "T2M",
                                temporal_api = "daily"))
})

test_that("query_parameters() stops if metadata is not Boolean", {
  skip_on_cran()
  expect_error(query_parameters(pars = "T2M",
                                community = "ag",
                                temporal_api = "daily",
                                metadata = "orange"))
})

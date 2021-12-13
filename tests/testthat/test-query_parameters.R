
test_that("query_parameters() returns proper list of info", {
            skip_on_cran()
            par_query <- query_parameters(community = "ag",
                                          par = c("T2M"),
                                          temporal_api = "Daily")

            expect_is(par_query, "list")
            expect_length(par_query, 1)
            expect_named(par_query, "T2M")
          })

test_that("query_parameters() returns list of parameter information", {
  skip_on_cran()
  par_query <- query_parameters(par = "T2M")
  expect_is(par_query, "list")
  expect_length(par_query, 1)
  expect_named(par_query, "T2M")
})

test_that("query_parameters() stops if par and community only supplied", {
  skip_on_cran()
  expect_error(query_parameters(par = "T2M",
                                community = "AG"))
})

test_that("query_parameters() stops if par and community only supplied", {
  skip_on_cran()
  expect_error(query_parameters(par = "T2M",
                                temporal_api = "daily"))
})

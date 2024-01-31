
test_that("query_surfaces() returns proper list of info", {
            skip_on_cran()
            surface_query <- query_surfaces()

            expect_type(par_query, "list")
            expect_length(par_query, 1)
            expect_named(par_query, "T2M")
          })

test_that("query_surfaces() returns list of parameter information", {
  skip_on_cran()
  surface_query <- query_surfaces(pars = "T2M")
  expect_type(par_query, "list")
  expect_length(par_query, 1)
  expect_named(par_query, "T2M")
})

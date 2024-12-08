test_that("query_groupings() returns proper list of info", {
  skip_if_offline()
  vcr::use_cassette("query_groupings", {
    grouping_query <- query_groupings()

    expect_type(grouping_query, "list")
    expect_length(grouping_query, 1)
    expect_named(grouping_query, "groups")
  })
})

test_that("query_groupings(global) returns list of grouping information", {
  skip_if_offline()
  vcr::use_cassette("query_groupings_global", {
    grouping_query <- query_groupings(global = TRUE)
    expect_type(grouping_query, "list")
    expect_length(grouping_query, 1)
    expect_named(grouping_query, "Climatology")
  })
})

test_that("query_groupings() stops if global is not Boolean", {
  skip_if_offline()
  expect_error(query_groupings(global = "orange"))
})
